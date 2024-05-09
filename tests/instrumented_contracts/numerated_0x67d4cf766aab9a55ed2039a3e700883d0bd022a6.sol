1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 
96 /**
97  * @dev Interface for the optional metadata functions from the ERC20 standard.
98  *
99  * _Available since v4.1._
100  */
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 // File: @openzeppelin/contracts/utils/Context.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
146 
147 
148 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
149 
150 pragma solidity ^0.8.0;
151 
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
163  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
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
385         }
386         _balances[to] += amount;
387 
388         emit Transfer(from, to, amount);
389 
390         _afterTokenTransfer(from, to, amount);
391     }
392 
393     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
394      * the total supply.
395      *
396      * Emits a {Transfer} event with `from` set to the zero address.
397      *
398      * Requirements:
399      *
400      * - `account` cannot be the zero address.
401      */
402     function _mint(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: mint to the zero address");
404 
405         _beforeTokenTransfer(address(0), account, amount);
406 
407         _totalSupply += amount;
408         _balances[account] += amount;
409         emit Transfer(address(0), account, amount);
410 
411         _afterTokenTransfer(address(0), account, amount);
412     }
413 
414     /**
415      * @dev Destroys `amount` tokens from `account`, reducing the
416      * total supply.
417      *
418      * Emits a {Transfer} event with `to` set to the zero address.
419      *
420      * Requirements:
421      *
422      * - `account` cannot be the zero address.
423      * - `account` must have at least `amount` tokens.
424      */
425     function _burn(address account, uint256 amount) internal virtual {
426         require(account != address(0), "ERC20: burn from the zero address");
427 
428         _beforeTokenTransfer(account, address(0), amount);
429 
430         uint256 accountBalance = _balances[account];
431         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
432         unchecked {
433             _balances[account] = accountBalance - amount;
434         }
435         _totalSupply -= amount;
436 
437         emit Transfer(account, address(0), amount);
438 
439         _afterTokenTransfer(account, address(0), amount);
440     }
441 
442     /**
443      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
444      *
445      * This internal function is equivalent to `approve`, and can be used to
446      * e.g. set automatic allowances for certain subsystems, etc.
447      *
448      * Emits an {Approval} event.
449      *
450      * Requirements:
451      *
452      * - `owner` cannot be the zero address.
453      * - `spender` cannot be the zero address.
454      */
455     function _approve(
456         address owner,
457         address spender,
458         uint256 amount
459     ) internal virtual {
460         require(owner != address(0), "ERC20: approve from the zero address");
461         require(spender != address(0), "ERC20: approve to the zero address");
462 
463         _allowances[owner][spender] = amount;
464         emit Approval(owner, spender, amount);
465     }
466 
467     /**
468      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
469      *
470      * Does not update the allowance amount in case of infinite allowance.
471      * Revert if not enough allowance is available.
472      *
473      * Might emit an {Approval} event.
474      */
475     function _spendAllowance(
476         address owner,
477         address spender,
478         uint256 amount
479     ) internal virtual {
480         uint256 currentAllowance = allowance(owner, spender);
481         if (currentAllowance != type(uint256).max) {
482             require(currentAllowance >= amount, "ERC20: insufficient allowance");
483             unchecked {
484                 _approve(owner, spender, currentAllowance - amount);
485             }
486         }
487     }
488 
489     /**
490      * @dev Hook that is called before any transfer of tokens. This includes
491      * minting and burning.
492      *
493      * Calling conditions:
494      *
495      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
496      * will be transferred to `to`.
497      * - when `from` is zero, `amount` tokens will be minted for `to`.
498      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
499      * - `from` and `to` are never both zero.
500      *
501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
502      */
503     function _beforeTokenTransfer(
504         address from,
505         address to,
506         uint256 amount
507     ) internal virtual {}
508 
509     /**
510      * @dev Hook that is called after any transfer of tokens. This includes
511      * minting and burning.
512      *
513      * Calling conditions:
514      *
515      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
516      * has been transferred to `to`.
517      * - when `from` is zero, `amount` tokens have been minted for `to`.
518      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
519      * - `from` and `to` are never both zero.
520      *
521      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
522      */
523     function _afterTokenTransfer(
524         address from,
525         address to,
526         uint256 amount
527     ) internal virtual {}
528 }
529 
530 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
531 
532 
533 
534 pragma solidity ^0.8.0;
535 
536 
537 /**
538  * @title ERC20Decimals
539  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
540  */
541 abstract contract ERC20Decimals is ERC20 {
542     uint8 private immutable _decimals;
543 
544     /**
545      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
546      * set once during construction.
547      */
548     constructor(uint8 decimals_) {
549         _decimals = decimals_;
550     }
551 
552     function decimals() public view virtual override returns (uint8) {
553         return _decimals;
554     }
555 }
556 
557 // File: contracts/service/ServicePayer.sol
558 
559 
560 
561 pragma solidity ^0.8.0;
562 
563 interface IPayable {
564     function pay(
565         string memory serviceName,
566         bytes memory signature,
567         address wallet
568     ) external payable;
569 }
570 
571 /**
572  * @title ServicePayer
573  * @dev Implementation of the ServicePayer
574  */
575 abstract contract ServicePayer {
576     constructor(
577         address payable receiver,
578         string memory serviceName,
579         bytes memory signature,
580         address wallet
581     ) payable {
582         IPayable(receiver).pay{value: msg.value}(serviceName, signature, wallet);
583     }
584 }
585 
586 // File: contracts/token/ERC20/StandardERC20.sol
587 
588 
589 
590 pragma solidity ^0.8.0;
591 
592 
593 
594 /**
595  * @title StandardERC20
596  * @dev Implementation of the StandardERC20
597  */
598 contract StandardERC20 is ERC20Decimals, ServicePayer {
599     constructor(
600         string memory name_,
601         string memory symbol_,
602         uint8 decimals_,
603         uint256 initialBalance_,
604         bytes memory signature_,
605         address payable feeReceiver_
606     )
607         payable
608         ERC20(name_, symbol_)
609         ERC20Decimals(decimals_)
610         ServicePayer(feeReceiver_, "StandardERC20", signature_, _msgSender())
611     {
612         require(initialBalance_ > 0, "StandardERC20: supply cannot be zero");
613 
614         _mint(_msgSender(), initialBalance_);
615     }
616 
617     function decimals() public view virtual override returns (uint8) {
618         return super.decimals();
619     }
620 }
