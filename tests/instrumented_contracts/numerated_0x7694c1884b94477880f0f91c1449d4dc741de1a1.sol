1 // SPDX-License-Identifier: MIT
2 /*************************************************************************
3 
4 Telegram:https://t.me/Jinguanzhang_eth
5 Twitter:https://twitter.com/JinguanzhangETH
6 
7 ****************************************************************************/
8 
9 // File: @openzeppelin/contracts/utils/Context.sol
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 pragma solidity ^0.8.0;
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
33 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
34 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Emitted when `value` tokens are moved from one account (`from`) to
43      * another (`to`).
44      *
45      * Note that `value` may be zero.
46      */
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     /**
50      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
51      * a call to {approve}. `value` is the new allowance.
52      */
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 
55     /**
56      * @dev Returns the amount of tokens in existence.
57      */
58     function totalSupply() external view returns (uint256);
59 
60     /**
61      * @dev Returns the amount of tokens owned by `account`.
62      */
63     function balanceOf(address account) external view returns (uint256);
64 
65     /**
66      * @dev Moves `amount` tokens from the caller's account to `to`.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transfer(address to, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Returns the remaining number of tokens that `spender` will be
76      * allowed to spend on behalf of `owner` through {transferFrom}. This is
77      * zero by default.
78      *
79      * This value changes when {approve} or {transferFrom} are called.
80      */
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     /**
84      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * IMPORTANT: Beware that changing an allowance with this method brings the risk
89      * that someone may use both the old and the new allowance by unfortunate
90      * transaction ordering. One possible solution to mitigate this race
91      * condition is to first reduce the spender's allowance to 0 and set the
92      * desired value afterwards:
93      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
94      *
95      * Emits an {Approval} event.
96      */
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Moves `amount` tokens from `from` to `to` using the
101      * allowance mechanism. `amount` is then deducted from the caller's
102      * allowance.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(
109         address from,
110         address to,
111         uint256 amount
112     ) external returns (bool);
113 }
114 
115 
116 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
117 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
118 pragma solidity ^0.8.0;
119 /**
120  * @dev Interface for the optional metadata functions from the ERC20 standard.
121  *
122  * _Available since v4.1._
123  */
124 interface IERC20Metadata is IERC20 {
125     /**
126      * @dev Returns the name of the token.
127      */
128     function name() external view returns (string memory);
129 
130     /**
131      * @dev Returns the symbol of the token.
132      */
133     function symbol() external view returns (string memory);
134 
135     /**
136      * @dev Returns the decimals places of the token.
137      */
138     function decimals() external view returns (uint8);
139 }
140 
141 
142 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
143 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Implementation of the {IERC20} interface.
148  *
149  * This implementation is agnostic to the way tokens are created. This means
150  * that a supply mechanism has to be added in a derived contract using {_mint}.
151  * For a generic mechanism see {ERC20PresetMinterPauser}.
152  *
153  * TIP: For a detailed writeup see our guide
154  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
155  * to implement supply mechanisms].
156  *
157  * We have followed general OpenZeppelin Contracts guidelines: functions revert
158  * instead returning `false` on failure. This behavior is nonetheless
159  * conventional and does not conflict with the expectations of ERC20
160  * applications.
161  *
162  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
163  * This allows applications to reconstruct the allowance for all accounts just
164  * by listening to said events. Other implementations of the EIP may not emit
165  * these events, as it isn't required by the specification.
166  *
167  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
168  * functions have been added to mitigate the well-known issues around setting
169  * allowances. See {IERC20-approve}.
170  */
171 contract ERC20 is Context, IERC20, IERC20Metadata {
172     mapping(address => uint256) private _balances;
173 
174     mapping(address => mapping(address => uint256)) private _allowances;
175 
176     uint256 private _totalSupply;
177 
178     string private _name;
179     string private _symbol;
180 
181     /**
182      * @dev Sets the values for {name} and {symbol}.
183      *
184      * The default value of {decimals} is 18. To select a different value for
185      * {decimals} you should overload it.
186      *
187      * All two of these values are immutable: they can only be set once during
188      * construction.
189      */
190     constructor(string memory name_, string memory symbol_) {
191         _name = name_;
192         _symbol = symbol_;
193     }
194 
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() public view virtual override returns (string memory) {
199         return _name;
200     }
201 
202     /**
203      * @dev Returns the symbol of the token, usually a shorter version of the
204      * name.
205      */
206     function symbol() public view virtual override returns (string memory) {
207         return _symbol;
208     }
209 
210     /**
211      * @dev Returns the number of decimals used to get its user representation.
212      * For example, if `decimals` equals `2`, a balance of `505` tokens should
213      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
214      *
215      * Tokens usually opt for a value of 18, imitating the relationship between
216      * Ether and Wei. This is the value {ERC20} uses, unless this function is
217      * overridden;
218      *
219      * NOTE: This information is only used for _display_ purposes: it in
220      * no way affects any of the arithmetic of the contract, including
221      * {IERC20-balanceOf} and {IERC20-transfer}.
222      */
223     function decimals() public view virtual override returns (uint8) {
224         return 18;
225     }
226 
227     /**
228      * @dev See {IERC20-totalSupply}.
229      */
230     function totalSupply() public view virtual override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235      * @dev See {IERC20-balanceOf}.
236      */
237     function balanceOf(address account) public view virtual override returns (uint256) {
238         return _balances[account];
239     }
240 
241     /**
242      * @dev See {IERC20-transfer}.
243      *
244      * Requirements:
245      *
246      * - `to` cannot be the zero address.
247      * - the caller must have a balance of at least `amount`.
248      */
249     function transfer(address to, uint256 amount) public virtual override returns (bool) {
250         address owner = _msgSender();
251         _transfer(owner, to, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-allowance}.
257      */
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See {IERC20-approve}.
264      *
265      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
266      * `transferFrom`. This is semantically equivalent to an infinite approval.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function approve(address spender, uint256 amount) public virtual override returns (bool) {
273         address owner = _msgSender();
274         _approve(owner, spender, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-transferFrom}.
280      *
281      * Emits an {Approval} event indicating the updated allowance. This is not
282      * required by the EIP. See the note at the beginning of {ERC20}.
283      *
284      * NOTE: Does not update the allowance if the current allowance
285      * is the maximum `uint256`.
286      *
287      * Requirements:
288      *
289      * - `from` and `to` cannot be the zero address.
290      * - `from` must have a balance of at least `amount`.
291      * - the caller must have allowance for ``from``'s tokens of at least
292      * `amount`.
293      */
294     function transferFrom(
295         address from,
296         address to,
297         uint256 amount
298     ) public virtual override returns (bool) {
299         address spender = _msgSender();
300         _spendAllowance(from, spender, amount);
301         _transfer(from, to, amount);
302         return true;
303     }
304 
305     /**
306      * @dev Atomically increases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
318         address owner = _msgSender();
319         _approve(owner, spender, allowance(owner, spender) + addedValue);
320         return true;
321     }
322 
323     /**
324      * @dev Atomically decreases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      * - `spender` must have allowance for the caller of at least
335      * `subtractedValue`.
336      */
337     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
338         address owner = _msgSender();
339         uint256 currentAllowance = allowance(owner, spender);
340         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
341         unchecked {
342             _approve(owner, spender, currentAllowance - subtractedValue);
343         }
344 
345         return true;
346     }
347 
348     /**
349      * @dev Moves `amount` of tokens from `from` to `to`.
350      *
351      * This internal function is equivalent to {transfer}, and can be used to
352      * e.g. implement automatic token fees, slashing mechanisms, etc.
353      *
354      * Emits a {Transfer} event.
355      *
356      * Requirements:
357      *
358      * - `from` cannot be the zero address.
359      * - `to` cannot be the zero address.
360      * - `from` must have a balance of at least `amount`.
361      */
362     function _transfer(
363         address from,
364         address to,
365         uint256 amount
366     ) internal virtual {
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
452     function _approve(
453         address owner,
454         address spender,
455         uint256 amount
456     ) internal virtual {
457         require(owner != address(0), "ERC20: approve from the zero address");
458         require(spender != address(0), "ERC20: approve to the zero address");
459 
460         _allowances[owner][spender] = amount;
461         emit Approval(owner, spender, amount);
462     }
463 
464     /**
465      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
466      *
467      * Does not update the allowance amount in case of infinite allowance.
468      * Revert if not enough allowance is available.
469      *
470      * Might emit an {Approval} event.
471      */
472     function _spendAllowance(
473         address owner,
474         address spender,
475         uint256 amount
476     ) internal virtual {
477         uint256 currentAllowance = allowance(owner, spender);
478         if (currentAllowance != type(uint256).max) {
479             require(currentAllowance >= amount, "ERC20: insufficient allowance");
480             unchecked {
481                 _approve(owner, spender, currentAllowance - amount);
482             }
483         }
484     }
485 
486     /**
487      * @dev Hook that is called before any transfer of tokens. This includes
488      * minting and burning.
489      *
490      * Calling conditions:
491      *
492      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
493      * will be transferred to `to`.
494      * - when `from` is zero, `amount` tokens will be minted for `to`.
495      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
496      * - `from` and `to` are never both zero.
497      *
498      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
499      */
500     function _beforeTokenTransfer(
501         address from,
502         address to,
503         uint256 amount
504     ) internal virtual {}
505 
506     /**
507      * @dev Hook that is called after any transfer of tokens. This includes
508      * minting and burning.
509      *
510      * Calling conditions:
511      *
512      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
513      * has been transferred to `to`.
514      * - when `from` is zero, `amount` tokens have been minted for `to`.
515      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
516      * - `from` and `to` are never both zero.
517      *
518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
519      */
520     function _afterTokenTransfer(
521         address from,
522         address to,
523         uint256 amount
524     ) internal virtual {}
525 }
526 
527 pragma solidity ^0.8.0;
528 contract Jinguanzhang is ERC20 {
529     constructor() ERC20("Jinguanzhang", "Jin") {
530         _mint(msg.sender, 1000 * 10 ** 9 * 10 ** decimals());
531     }
532 }