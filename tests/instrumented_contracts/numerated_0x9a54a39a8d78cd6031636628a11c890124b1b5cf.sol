1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.2
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.2
89 
90 
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 
117 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
118 
119 
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 
144 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.2
145 
146 
147 
148 pragma solidity ^0.8.0;
149 
150 
151 
152 /**
153  * @dev Implementation of the {IERC20} interface.
154  *
155  * This implementation is agnostic to the way tokens are created. This means
156  * that a supply mechanism has to be added in a derived contract using {_mint}.
157  * For a generic mechanism see {ERC20PresetMinterPauser}.
158  *
159  * TIP: For a detailed writeup see our guide
160  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
161  * to implement supply mechanisms].
162  *
163  * We have followed general OpenZeppelin Contracts guidelines: functions revert
164  * instead returning `false` on failure. This behavior is nonetheless
165  * conventional and does not conflict with the expectations of ERC20
166  * applications.
167  *
168  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
169  * This allows applications to reconstruct the allowance for all accounts just
170  * by listening to said events. Other implementations of the EIP may not emit
171  * these events, as it isn't required by the specification.
172  *
173  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
174  * functions have been added to mitigate the well-known issues around setting
175  * allowances. See {IERC20-approve}.
176  */
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178     mapping(address => uint256) private _balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the value {ERC20} uses, unless this function is
223      * overridden;
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `recipient` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * Requirements:
286      *
287      * - `sender` and `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``sender``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         _transfer(sender, recipient, amount);
298 
299         uint256 currentAllowance = _allowances[sender][_msgSender()];
300         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
301         unchecked {
302             _approve(sender, _msgSender(), currentAllowance - amount);
303         }
304 
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
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         uint256 currentAllowance = _allowances[_msgSender()][spender];
341         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
342         unchecked {
343             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Moves `amount` of tokens from `sender` to `recipient`.
351      *
352      * This internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) internal virtual {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(sender, recipient, amount);
372 
373         uint256 senderBalance = _balances[sender];
374         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
375         unchecked {
376             _balances[sender] = senderBalance - amount;
377         }
378         _balances[recipient] += amount;
379 
380         emit Transfer(sender, recipient, amount);
381 
382         _afterTokenTransfer(sender, recipient, amount);
383     }
384 
385     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386      * the total supply.
387      *
388      * Emits a {Transfer} event with `from` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      */
394     function _mint(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: mint to the zero address");
396 
397         _beforeTokenTransfer(address(0), account, amount);
398 
399         _totalSupply += amount;
400         _balances[account] += amount;
401         emit Transfer(address(0), account, amount);
402 
403         _afterTokenTransfer(address(0), account, amount);
404     }
405 
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419 
420         _beforeTokenTransfer(account, address(0), amount);
421 
422         uint256 accountBalance = _balances[account];
423         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
424         unchecked {
425             _balances[account] = accountBalance - amount;
426         }
427         _totalSupply -= amount;
428 
429         emit Transfer(account, address(0), amount);
430 
431         _afterTokenTransfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Hook that is called before any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * will be transferred to `to`.
467      * - when `from` is zero, `amount` tokens will be minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _beforeTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 
479     /**
480      * @dev Hook that is called after any transfer of tokens. This includes
481      * minting and burning.
482      *
483      * Calling conditions:
484      *
485      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
486      * has been transferred to `to`.
487      * - when `from` is zero, `amount` tokens have been minted for `to`.
488      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
489      * - `from` and `to` are never both zero.
490      *
491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
492      */
493     function _afterTokenTransfer(
494         address from,
495         address to,
496         uint256 amount
497     ) internal virtual {}
498 }
499 
500 
501 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.3.2
502 
503 
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Extension of {ERC20} that allows token holders to destroy both their own
510  * tokens and those that they have an allowance for, in a way that can be
511  * recognized off-chain (via event analysis).
512  */
513 abstract contract ERC20Burnable is Context, ERC20 {
514     /**
515      * @dev Destroys `amount` tokens from the caller.
516      *
517      * See {ERC20-_burn}.
518      */
519     function burn(uint256 amount) public virtual {
520         _burn(_msgSender(), amount);
521     }
522 
523     /**
524      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
525      * allowance.
526      *
527      * See {ERC20-_burn} and {ERC20-allowance}.
528      *
529      * Requirements:
530      *
531      * - the caller must have allowance for ``accounts``'s tokens of at least
532      * `amount`.
533      */
534     function burnFrom(address account, uint256 amount) public virtual {
535         uint256 currentAllowance = allowance(account, _msgSender());
536         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
537         unchecked {
538             _approve(account, _msgSender(), currentAllowance - amount);
539         }
540         _burn(account, amount);
541     }
542 }
543 
544 
545 // File @openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol@v4.3.2
546 
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @dev {ERC20} token, including:
552  *
553  *  - Preminted initial supply
554  *  - Ability for holders to burn (destroy) their tokens
555  *  - No access control mechanism (for minting/pausing) and hence no governance
556  *
557  * This contract uses {ERC20Burnable} to include burn capabilities - head to
558  * its documentation for details.
559  *
560  * _Available since v3.4._
561  */
562 contract ERC20PresetFixedSupply is ERC20Burnable {
563     /**
564      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
565      *
566      * See {ERC20-constructor}.
567      */
568     constructor(
569         string memory name,
570         string memory symbol,
571         uint256 initialSupply,
572         address owner
573     ) ERC20(name, symbol) {
574         _mint(owner, initialSupply);
575     }
576 }
577 
578 
579 // File contracts/NFracTionToken.sol
580 
581 
582 pragma solidity ^0.8.6;
583 contract NFracTionToken is ERC20PresetFixedSupply {
584     uint256 private constant initSupply = 100000000 ether;
585 
586     constructor()
587         ERC20PresetFixedSupply(
588             "NFracTion Token",
589             "NFTA",
590             initSupply,
591             msg.sender
592         )
593     {}
594 }