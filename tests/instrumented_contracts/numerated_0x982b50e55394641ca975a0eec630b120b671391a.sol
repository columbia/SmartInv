1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Emitted when `value` tokens are moved from one account (`from`) to
11      * another (`to`).
12      *
13      * Note that `value` may be zero.
14      */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     /**
18      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
19      * a call to {approve}. `value` is the new allowance.
20      */
21     event Approval(
22         address indexed owner,
23         address indexed spender,
24         uint256 value
25     );
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
53     function allowance(
54         address owner,
55         address spender
56     ) external view returns (uint256);
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
90 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
91 /**
92  * @dev Interface for the optional metadata functions from the ERC20 standard.
93  *
94  * _Available since v4.1._
95  */
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns (string memory);
101 
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns (string memory);
106 
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns (uint8);
111 }
112 
113 // File: @openzeppelin/contracts/utils/Context.sol
114 /**
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         return msg.data;
131     }
132 }
133 
134 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
135 /**
136  * @dev Implementation of the {IERC20} interface.
137  *
138  * This implementation is agnostic to the way tokens are created. This means
139  * that a supply mechanism has to be added in a derived contract using {_mint}.
140  * For a generic mechanism see {ERC20PresetMinterPauser}.
141  *
142  * TIP: For a detailed writeup see our guide
143  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
144  * to implement supply mechanisms].
145  *
146  * We have followed general OpenZeppelin Contracts guidelines: functions revert
147  * instead returning `false` on failure. This behavior is nonetheless
148  * conventional and does not conflict with the expectations of ERC20
149  * applications.
150  *
151  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
152  * This allows applications to reconstruct the allowance for all accounts just
153  * by listening to said events. Other implementations of the EIP may not emit
154  * these events, as it isn't required by the specification.
155  *
156  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
157  * functions have been added to mitigate the well-known issues around setting
158  * allowances. See {IERC20-approve}.
159  */
160 contract ERC20 is Context, IERC20, IERC20Metadata {
161     mapping(address => uint256) private _balances;
162 
163     mapping(address => mapping(address => uint256)) private _allowances;
164 
165     uint256 private _totalSupply;
166 
167     string private _name;
168     string private _symbol;
169 
170     /**
171      * @dev Sets the values for {name} and {symbol}.
172      *
173      * The default value of {decimals} is 18. To select a different value for
174      * {decimals} you should overload it.
175      *
176      * All two of these values are immutable: they can only be set once during
177      * construction.
178      */
179     constructor(string memory name_, string memory symbol_) {
180         _name = name_;
181         _symbol = symbol_;
182     }
183 
184     /**
185      * @dev Returns the name of the token.
186      */
187     function name() public view virtual override returns (string memory) {
188         return _name;
189     }
190 
191     /**
192      * @dev Returns the symbol of the token, usually a shorter version of the
193      * name.
194      */
195     function symbol() public view virtual override returns (string memory) {
196         return _symbol;
197     }
198 
199     /**
200      * @dev Returns the number of decimals used to get its user representation.
201      * For example, if `decimals` equals `2`, a balance of `505` tokens should
202      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
203      *
204      * Tokens usually opt for a value of 18, imitating the relationship between
205      * Ether and Wei. This is the value {ERC20} uses, unless this function is
206      * overridden;
207      *
208      * NOTE: This information is only used for _display_ purposes: it in
209      * no way affects any of the arithmetic of the contract, including
210      * {IERC20-balanceOf} and {IERC20-transfer}.
211      */
212     function decimals() public view virtual override returns (uint8) {
213         return 18;
214     }
215 
216     /**
217      * @dev See {IERC20-totalSupply}.
218      */
219     function totalSupply() public view virtual override returns (uint256) {
220         return _totalSupply;
221     }
222 
223     /**
224      * @dev See {IERC20-balanceOf}.
225      */
226     function balanceOf(
227         address account
228     ) public view virtual override returns (uint256) {
229         return _balances[account];
230     }
231 
232     /**
233      * @dev See {IERC20-transfer}.
234      *
235      * Requirements:
236      *
237      * - `to` cannot be the zero address.
238      * - the caller must have a balance of at least `amount`.
239      */
240     function transfer(
241         address to,
242         uint256 amount
243     ) public virtual override returns (bool) {
244         address owner = _msgSender();
245         _transfer(owner, to, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See {IERC20-allowance}.
251      */
252     function allowance(
253         address owner,
254         address spender
255     ) public view virtual override returns (uint256) {
256         return _allowances[owner][spender];
257     }
258 
259     /**
260      * @dev See {IERC20-approve}.
261      *
262      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
263      * `transferFrom`. This is semantically equivalent to an infinite approval.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(
270         address spender,
271         uint256 amount
272     ) public virtual override returns (bool) {
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
317     function increaseAllowance(
318         address spender,
319         uint256 addedValue
320     ) public virtual returns (bool) {
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
340     function decreaseAllowance(
341         address spender,
342         uint256 subtractedValue
343     ) public virtual returns (bool) {
344         address owner = _msgSender();
345         uint256 currentAllowance = allowance(owner, spender);
346         require(
347             currentAllowance >= subtractedValue,
348             "ERC20: decreased allowance below zero"
349         );
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
382         require(
383             fromBalance >= amount,
384             "ERC20: transfer amount exceeds balance"
385         );
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
491             require(
492                 currentAllowance >= amount,
493                 "ERC20: insufficient allowance"
494             );
495             unchecked {
496                 _approve(owner, spender, currentAllowance - amount);
497             }
498         }
499     }
500 
501     /**
502      * @dev Hook that is called before any transfer of tokens. This includes
503      * minting and burning.
504      *
505      * Calling conditions:
506      *
507      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
508      * will be transferred to `to`.
509      * - when `from` is zero, `amount` tokens will be minted for `to`.
510      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
511      * - `from` and `to` are never both zero.
512      *
513      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
514      */
515     function _beforeTokenTransfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal virtual {}
520 
521     /**
522      * @dev Hook that is called after any transfer of tokens. This includes
523      * minting and burning.
524      *
525      * Calling conditions:
526      *
527      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
528      * has been transferred to `to`.
529      * - when `from` is zero, `amount` tokens have been minted for `to`.
530      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
531      * - `from` and `to` are never both zero.
532      *
533      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
534      */
535     function _afterTokenTransfer(
536         address from,
537         address to,
538         uint256 amount
539     ) internal virtual {}
540 }
541 
542 contract ECOTERRA is ERC20 {
543     
544     function decimals() public view virtual override returns (uint8) {
545         return 9;
546     }
547 
548     constructor() ERC20("ecoterra", "ECOTERRA") {
549         _mint(msg.sender, 2_000_000_000 * 10 ** decimals());  
550     }
551 }