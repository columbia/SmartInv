1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 //twitter: https://twitter.com/ftxinu
5 //telegram: https://t.me/ftxinu
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address from,
82         address to,
83         uint256 amount
84     ) external returns (bool);
85 }
86 
87 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
88 
89 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
90 
91 pragma solidity ^0.8.0;
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
115 // File: @openzeppelin/contracts/utils/Context.sol
116 
117 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
142 
143 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 
148 
149 /**
150  * @dev Implementation of the {IERC20} interface.
151  *
152  * This implementation is agnostic to the way tokens are created. This means
153  * that a supply mechanism has to be added in a derived contract using {_mint}.
154  * For a generic mechanism see {ERC20PresetMinterPauser}.
155  *
156  * TIP: For a detailed writeup see our guide
157  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
158  * to implement supply mechanisms].
159  *
160  * We have followed general OpenZeppelin Contracts guidelines: functions revert
161  * instead returning `false` on failure. This behavior is nonetheless
162  * conventional and does not conflict with the expectations of ERC20
163  * applications.
164  *
165  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
166  * This allows applications to reconstruct the allowance for all accounts just
167  * by listening to said events. Other implementations of the EIP may not emit
168  * these events, as it isn't required by the specification.
169  *
170  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
171  * functions have been added to mitigate the well-known issues around setting
172  * allowances. See {IERC20-approve}.
173  */
174 contract ERC20 is Context, IERC20, IERC20Metadata {
175     mapping(address => uint256) private _balances;
176 
177     mapping(address => mapping(address => uint256)) private _allowances;
178 
179     uint256 private _totalSupply;
180 
181     string private _name;
182     string private _symbol;
183 
184     /**
185      * @dev Sets the values for {name} and {symbol}.
186      *
187      * The default value of {decimals} is 18. To select a different value for
188      * {decimals} you should overload it.
189      *
190      * All two of these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor(string memory name_, string memory symbol_) {
194         _name = name_;
195         _symbol = symbol_;
196     }
197 
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() public view virtual override returns (string memory) {
202         return _name;
203     }
204 
205     /**
206      * @dev Returns the symbol of the token, usually a shorter version of the
207      * name.
208      */
209     function symbol() public view virtual override returns (string memory) {
210         return _symbol;
211     }
212 
213     /**
214      * @dev Returns the number of decimals used to get its user representation.
215      * For example, if `decimals` equals `2`, a balance of `505` tokens should
216      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
217      *
218      * Tokens usually opt for a value of 18, imitating the relationship between
219      * Ether and Wei. This is the value {ERC20} uses, unless this function is
220      * overridden;
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view virtual override returns (uint8) {
227         return 18;
228     }
229 
230     /**
231      * @dev See {IERC20-totalSupply}.
232      */
233     function totalSupply() public view virtual override returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(address account) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev See {IERC20-transfer}.
246      *
247      * Requirements:
248      *
249      * - `to` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address to, uint256 amount) public virtual override returns (bool) {
253         address owner = _msgSender();
254         _transfer(owner, to, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
269      * `transferFrom`. This is semantically equivalent to an infinite approval.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public virtual override returns (bool) {
276         address owner = _msgSender();
277         _approve(owner, spender, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-transferFrom}.
283      *
284      * Emits an {Approval} event indicating the updated allowance. This is not
285      * required by the EIP. See the note at the beginning of {ERC20}.
286      *
287      * NOTE: Does not update the allowance if the current allowance
288      * is the maximum `uint256`.
289      *
290      * Requirements:
291      *
292      * - `from` and `to` cannot be the zero address.
293      * - `from` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``from``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(
298         address from,
299         address to,
300         uint256 amount
301     ) public virtual override returns (bool) {
302         address spender = _msgSender();
303         _spendAllowance(from, spender, amount);
304         _transfer(from, to, amount);
305         return true;
306     }
307 
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         address owner = _msgSender();
322         _approve(owner, spender, allowance(owner, spender) + addedValue);
323         return true;
324     }
325 
326     /**
327      * @dev Atomically decreases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      * - `spender` must have allowance for the caller of at least
338      * `subtractedValue`.
339      */
340     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
341         address owner = _msgSender();
342         uint256 currentAllowance = allowance(owner, spender);
343         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
344         unchecked {
345             _approve(owner, spender, currentAllowance - subtractedValue);
346         }
347 
348         return true;
349     }
350 
351     /**
352      * @dev Moves `amount` of tokens from `from` to `to`.
353      *
354      * This internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `from` must have a balance of at least `amount`.
364      */
365     function _transfer(
366         address from,
367         address to,
368         uint256 amount
369     ) internal virtual {
370         require(from != address(0), "ERC20: transfer from the zero address");
371         require(to != address(0), "ERC20: transfer to the zero address");
372 
373         _beforeTokenTransfer(from, to, amount);
374 
375         uint256 fromBalance = _balances[from];
376         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
377         unchecked {
378             _balances[from] = fromBalance - amount;
379         }
380         _balances[to] += amount;
381 
382         emit Transfer(from, to, amount);
383 
384         _afterTokenTransfer(from, to, amount);
385     }
386 
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: mint to the zero address");
398 
399         _beforeTokenTransfer(address(0), account, amount);
400 
401         _totalSupply += amount;
402         _balances[account] += amount;
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
428         }
429         _totalSupply -= amount;
430 
431         emit Transfer(account, address(0), amount);
432 
433         _afterTokenTransfer(account, address(0), amount);
434     }
435 
436     /**
437      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
438      *
439      * This internal function is equivalent to `approve`, and can be used to
440      * e.g. set automatic allowances for certain subsystems, etc.
441      *
442      * Emits an {Approval} event.
443      *
444      * Requirements:
445      *
446      * - `owner` cannot be the zero address.
447      * - `spender` cannot be the zero address.
448      */
449     function _approve(
450         address owner,
451         address spender,
452         uint256 amount
453     ) internal virtual {
454         require(owner != address(0), "ERC20: approve from the zero address");
455         require(spender != address(0), "ERC20: approve to the zero address");
456 
457         _allowances[owner][spender] = amount;
458         emit Approval(owner, spender, amount);
459     }
460 
461     /**
462      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
463      *
464      * Does not update the allowance amount in case of infinite allowance.
465      * Revert if not enough allowance is available.
466      *
467      * Might emit an {Approval} event.
468      */
469     function _spendAllowance(
470         address owner,
471         address spender,
472         uint256 amount
473     ) internal virtual {
474         uint256 currentAllowance = allowance(owner, spender);
475         if (currentAllowance != type(uint256).max) {
476             require(currentAllowance >= amount, "ERC20: insufficient allowance");
477             unchecked {
478                 _approve(owner, spender, currentAllowance - amount);
479             }
480         }
481     }
482 
483     /**
484      * @dev Hook that is called before any transfer of tokens. This includes
485      * minting and burning.
486      *
487      * Calling conditions:
488      *
489      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
490      * will be transferred to `to`.
491      * - when `from` is zero, `amount` tokens will be minted for `to`.
492      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
493      * - `from` and `to` are never both zero.
494      *
495      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
496      */
497     function _beforeTokenTransfer(
498         address from,
499         address to,
500         uint256 amount
501     ) internal virtual {}
502 
503     /**
504      * @dev Hook that is called after any transfer of tokens. This includes
505      * minting and burning.
506      *
507      * Calling conditions:
508      *
509      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
510      * has been transferred to `to`.
511      * - when `from` is zero, `amount` tokens have been minted for `to`.
512      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
513      * - `from` and `to` are never both zero.
514      *
515      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
516      */
517     function _afterTokenTransfer(
518         address from,
519         address to,
520         uint256 amount
521     ) internal virtual {}
522 }
523 
524 
525 pragma solidity ^0.8.0;
526 
527 contract FTXINU is ERC20{
528     constructor() ERC20("FTXINU", "FTXI"){
529         _mint(msg.sender,20000000000*10**18);
530     }
531 }