1 // SPDX-License-Identifier: MIT
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/utils/Context.sol
3 
4 
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
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 
113 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/token/ERC20/extensions/IERC20Metadata.sol
114 
115 
116 
117 pragma solidity ^0.8.0;
118 
119 
120 /**
121  * @dev Interface for the optional metadata functions from the ERC20 standard.
122  *
123  * _Available since v4.1._
124  */
125 interface IERC20Metadata is IERC20 {
126     /**
127      * @dev Returns the name of the token.
128      */
129     function name() external view returns (string memory);
130 
131     /**
132      * @dev Returns the symbol of the token.
133      */
134    function symbol() external view returns (string memory);
135 
136     /**
137      * @dev Returns the decimals places of the token.
138      */
139     function decimals() external view returns (uint8);
140 }
141 
142 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/token/ERC20/IERC20.sol
143 
144 
145 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/token/ERC20/ERC20.sol
146 
147 
148 
149 pragma solidity ^0.8.0;
150 
151 
152 
153 
154 /**
155  * @dev Implementation of the {IERC20} interface.
156  *
157  * This implementation is agnostic to the way tokens are created. This means
158  * that a supply mechanism has to be added in a derived contract using {_mint}.
159  * For a generic mechanism see {ERC20PresetMinterPauser}.
160  *
161  * TIP: For a detailed writeup see our guide
162  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
163  * to implement supply mechanisms].
164  *
165  * We have followed general OpenZeppelin Contracts guidelines: functions revert
166  * instead returning `false` on failure. This behavior is nonetheless
167  * conventional and does not conflict with the expectations of ERC20
168  * applications.
169  *
170  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
171  * This allows applications to reconstruct the allowance for all accounts just
172  * by listening to said events. Other implementations of the EIP may not emit
173  * these events, as it isn't required by the specification.
174  *
175  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
176  * functions have been added to mitigate the well-known issues around setting
177  * allowances. See {IERC20-approve}.
178  */
179 contract ERC20 is Context, IERC20, IERC20Metadata {
180     mapping(address => uint256) private _balances;
181 
182     mapping(address => mapping(address => uint256)) private _allowances;
183 
184     uint256 private _totalSupply;
185 
186     string private _name;
187     string private _symbol;
188 
189     /**
190      * @dev Sets the values for {name} and {symbol}.
191      *
192      * The default value of {decimals} is 18. To select a different value for
193      * {decimals} you should overload it.
194      *
195      * All two of these values are immutable: they can only be set once during
196      * construction.
197      */
198     constructor(string memory name_, string memory symbol_) {
199         _name = name_;
200         _symbol = symbol_;
201     }
202 
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() public view virtual override returns (string memory) {
207         return _name;
208     }
209 
210     /**
211      * @dev Returns the symbol of the token, usually a shorter version of the
212      * name.
213      */
214     function symbol() public view virtual override returns (string memory) {
215         return _symbol;
216     }
217 
218     /**
219      * @dev Returns the number of decimals used to get its user representation.
220      * For example, if `decimals` equals `2`, a balance of `505` tokens should
221      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
222      *
223      * Tokens usually opt for a value of 18, imitating the relationship between
224      * Ether and Wei. This is the value {ERC20} uses, unless this function is
225      * overridden;
226      *
227      * NOTE: This information is only used for _display_ purposes: it in
228      * no way affects any of the arithmetic of the contract, including
229      * {IERC20-balanceOf} and {IERC20-transfer}.
230      */
231     function decimals() public view virtual override returns (uint8) {
232         return 18;
233     }
234 
235     /**
236      * @dev See {IERC20-totalSupply}.
237      */
238     function totalSupply() public view virtual override returns (uint256) {
239         return _totalSupply;
240     }
241 
242     /**
243      * @dev See {IERC20-balanceOf}.
244      */
245     function balanceOf(address account) public view virtual override returns (uint256) {
246         return _balances[account];
247     }
248 
249     /**
250      * @dev See {IERC20-transfer}.
251      *
252      * Requirements:
253      *
254      * - `recipient` cannot be the zero address.
255      * - the caller must have a balance of at least `amount`.
256      */
257     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
258         _transfer(_msgSender(), recipient, amount);
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
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      */
276     function approve(address spender, uint256 amount) public virtual override returns (bool) {
277         _approve(_msgSender(), spender, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-transferFrom}.
283      *
284      * Emits an {Approval} event indicating the updated allowance. This is not
285      * required by the EIP. See the note at the beginning of {ERC20}.
286      *
287      * Requirements:
288      *
289      * - `sender` and `recipient` cannot be the zero address.
290      * - `sender` must have a balance of at least `amount`.
291      * - the caller must have allowance for ``sender``'s tokens of at least
292      * `amount`.
293      */
294     function transferFrom(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) public virtual override returns (bool) {
299         _transfer(sender, recipient, amount);
300 
301         uint256 currentAllowance = _allowances[sender][_msgSender()];
302         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
303         unchecked {
304             _approve(sender, _msgSender(), currentAllowance - amount);
305         }
306 
307         return true;
308     }
309 
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
324         return true;
325     }
326 
327     /**
328      * @dev Atomically decreases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `spender` must have allowance for the caller of at least
339      * `subtractedValue`.
340      */
341     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
342         uint256 currentAllowance = _allowances[_msgSender()][spender];
343         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
344         unchecked {
345             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
346         }
347 
348         return true;
349     }
350 
351     /**
352      * @dev Moves `amount` of tokens from `sender` to `recipient`.
353      *
354      * This internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `sender` cannot be the zero address.
362      * - `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      */
365     function _transfer(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) internal virtual {
370         require(sender != address(0), "ERC20: transfer from the zero address");
371         require(recipient != address(0), "ERC20: transfer to the zero address");
372 
373         _beforeTokenTransfer(sender, recipient, amount);
374 
375         uint256 senderBalance = _balances[sender];
376         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
377         unchecked {
378             _balances[sender] = senderBalance - amount;
379         }
380         _balances[recipient] += amount;
381 
382         emit Transfer(sender, recipient, amount);
383 
384         _afterTokenTransfer(sender, recipient, amount);
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
462      * @dev Hook that is called before any transfer of tokens. This includes
463      * minting and burning.
464      *
465      * Calling conditions:
466      *
467      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
468      * will be transferred to `to`.
469      * - when `from` is zero, `amount` tokens will be minted for `to`.
470      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
471      * - `from` and `to` are never both zero.
472      *
473      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
474      */
475     function _beforeTokenTransfer(
476         address from,
477         address to,
478         uint256 amount
479     ) internal virtual {}
480 
481     /**
482      * @dev Hook that is called after any transfer of tokens. This includes
483      * minting and burning.
484      *
485      * Calling conditions:
486      *
487      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
488      * has been transferred to `to`.
489      * - when `from` is zero, `amount` tokens have been minted for `to`.
490      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
491      * - `from` and `to` are never both zero.
492      *
493      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
494      */
495     function _afterTokenTransfer(
496         address from,
497         address to,
498         uint256 amount
499     ) internal virtual {}
500 }
501 
502 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/token/ERC20/extensions/ERC20Burnable.sol
503 
504 
505 
506 pragma solidity ^0.8.0;
507 
508 
509 
510 /**
511  * @dev Extension of {ERC20} that allows token holders to destroy both their own
512  * tokens and those that they have an allowance for, in a way that can be
513  * recognized off-chain (via event analysis).
514  */
515 abstract contract ERC20Burnable is Context, ERC20 {
516     /**
517      * @dev Destroys `amount` tokens from the caller.
518      *
519      * See {ERC20-_burn}.
520      */
521     function burn(uint256 amount) public virtual {
522         _burn(_msgSender(), amount);
523     }
524 
525     /**
526      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
527      * allowance.
528      *
529      * See {ERC20-_burn} and {ERC20-allowance}.
530      *
531      * Requirements:
532      *
533      * - the caller must have allowance for ``accounts``'s tokens of at least
534      * `amount`.
535      */
536     function burnFrom(address account, uint256 amount) public virtual {
537         uint256 currentAllowance = allowance(account, _msgSender());
538         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
539         unchecked {
540             _approve(account, _msgSender(), currentAllowance - amount);
541         }
542         _burn(account, amount);
543     }
544 }
545 
546 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.2/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol
547 
548 
549 pragma solidity ^0.8.0;
550 
551 
552 /**
553  * @dev {ERC20} token, including:
554  *
555  *  - Preminted initial supply
556  *  - Ability for holders to burn (destroy) their tokens
557  *  - No access control mechanism (for minting/pausing) and hence no governance
558  *
559  * This contract uses {ERC20Burnable} to include burn capabilities - head to
560  * its documentation for details.
561  *
562  * _Available since v3.4._
563  */
564 contract ERC20PresetFixedSupply is ERC20Burnable {
565     /**
566      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
567      *
568      * See {ERC20-constructor}.
569      */
570     constructor(
571         string memory name,
572         string memory symbol,
573         uint256 initialSupply,
574         address owner
575     ) ERC20(name, symbol) {
576         _mint(owner, initialSupply);
577     }
578 }