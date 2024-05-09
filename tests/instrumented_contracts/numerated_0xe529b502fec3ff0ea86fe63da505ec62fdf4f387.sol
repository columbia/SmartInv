1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-12-08
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
12 
13 
14 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address sender,
77         address recipient,
78         uint256 amount
79     ) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
97 
98 
99 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 
104 /**
105  * @dev Interface for the optional metadata functions from the ERC20 standard.
106  *
107  * _Available since v4.1._
108  */
109 interface IERC20Metadata is IERC20 {
110     /**
111      * @dev Returns the name of the token.
112      */
113     function name() external view returns (string memory);
114 
115     /**
116      * @dev Returns the symbol of the token.
117      */
118     function symbol() external view returns (string memory);
119 
120     /**
121      * @dev Returns the decimals places of the token.
122      */
123     function decimals() external view returns (uint8);
124 }
125 
126 // File: @openzeppelin/contracts/utils/Context.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
155 
156 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 
162 
163 /**
164  * @dev Implementation of the {IERC20} interface.
165  *
166  * This implementation is agnostic to the way tokens are created. This means
167  * that a supply mechanism has to be added in a derived contract using {_mint}.
168  * For a generic mechanism see {ERC20PresetMinterPauser}.
169  *
170  * TIP: For a detailed writeup see our guide
171  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
172  * to implement supply mechanisms].
173  *
174  * We have followed general OpenZeppelin Contracts guidelines: functions revert
175  * instead returning `false` on failure. This behavior is nonetheless
176  * conventional and does not conflict with the expectations of ERC20
177  * applications.
178  *
179  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
180  * This allows applications to reconstruct the allowance for all accounts just
181  * by listening to said events. Other implementations of the EIP may not emit
182  * these events, as it isn't required by the specification.
183  *
184  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
185  * functions have been added to mitigate the well-known issues around setting
186  * allowances. See {IERC20-approve}.
187  */
188 contract ERC20 is Context, IERC20, IERC20Metadata {
189     mapping(address => uint256) private _balances;
190 
191     mapping(address => mapping(address => uint256)) private _allowances;
192 
193     uint256 private _totalSupply;
194 
195     string private _name;
196     string private _symbol;
197 
198     /**
199      * @dev Sets the values for {name} and {symbol}.
200      *
201      * The default value of {decimals} is 18. To select a different value for
202      * {decimals} you should overload it.
203      *
204      * All two of these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor(string memory name_, string memory symbol_) {
208         _name = name_;
209         _symbol = symbol_;
210     }
211 
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() public view virtual override returns (string memory) {
216         return _name;
217     }
218 
219     /**
220      * @dev Returns the symbol of the token, usually a shorter version of the
221      * name.
222      */
223     function symbol() public view virtual override returns (string memory) {
224         return _symbol;
225     }
226 
227     /**
228      * @dev Returns the number of decimals used to get its user representation.
229      * For example, if `decimals` equals `2`, a balance of `505` tokens should
230      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
231      *
232      * Tokens usually opt for a value of 18, imitating the relationship between
233      * Ether and Wei. This is the value {ERC20} uses, unless this function is
234      * overridden;
235      *
236      * NOTE: This information is only used for _display_ purposes: it in
237      * no way affects any of the arithmetic of the contract, including
238      * {IERC20-balanceOf} and {IERC20-transfer}.
239      */
240     function decimals() public view virtual override returns (uint8) {
241         return 18;
242     }
243 
244     /**
245      * @dev See {IERC20-totalSupply}.
246      */
247     function totalSupply() public view virtual override returns (uint256) {
248         return _totalSupply;
249     }
250 
251     /**
252      * @dev See {IERC20-balanceOf}.
253      */
254     function balanceOf(address account) public view virtual override returns (uint256) {
255         return _balances[account];
256     }
257 
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `recipient` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271     /**
272      * @dev See {IERC20-allowance}.
273      */
274     function allowance(address owner, address spender) public view virtual override returns (uint256) {
275         return _allowances[owner][spender];
276     }
277 
278     /**
279      * @dev See {IERC20-approve}.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      */
285     function approve(address spender, uint256 amount) public virtual override returns (bool) {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20}.
295      *
296      * Requirements:
297      *
298      * - `sender` and `recipient` cannot be the zero address.
299      * - `sender` must have a balance of at least `amount`.
300      * - the caller must have allowance for ``sender``'s tokens of at least
301      * `amount`.
302      */
303     function transferFrom(
304         address sender,
305         address recipient,
306         uint256 amount
307     ) public virtual override returns (bool) {
308         _transfer(sender, recipient, amount);
309 
310         uint256 currentAllowance = _allowances[sender][_msgSender()];
311         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
312         unchecked {
313             _approve(sender, _msgSender(), currentAllowance - amount);
314         }
315 
316         return true;
317     }
318 
319     /**
320      * @dev Atomically increases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
332         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
333         return true;
334     }
335 
336     /**
337      * @dev Atomically decreases the allowance granted to `spender` by the caller.
338      *
339      * This is an alternative to {approve} that can be used as a mitigation for
340      * problems described in {IERC20-approve}.
341      *
342      * Emits an {Approval} event indicating the updated allowance.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      * - `spender` must have allowance for the caller of at least
348      * `subtractedValue`.
349      */
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         uint256 currentAllowance = _allowances[_msgSender()][spender];
352         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
353         unchecked {
354             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
355         }
356 
357         return true;
358     }
359 
360     /**
361      * @dev Moves `amount` of tokens from `sender` to `recipient`.
362      *
363      * This internal function is equivalent to {transfer}, and can be used to
364      * e.g. implement automatic token fees, slashing mechanisms, etc.
365      *
366      * Emits a {Transfer} event.
367      *
368      * Requirements:
369      *
370      * - `sender` cannot be the zero address.
371      * - `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      */
374     function _transfer(
375         address sender,
376         address recipient,
377         uint256 amount
378     ) internal virtual {
379         require(sender != address(0), "ERC20: transfer from the zero address");
380         require(recipient != address(0), "ERC20: transfer to the zero address");
381 
382         _beforeTokenTransfer(sender, recipient, amount);
383 
384         uint256 senderBalance = _balances[sender];
385         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
386         unchecked {
387             _balances[sender] = senderBalance - amount;
388         }
389         _balances[recipient] += amount;
390 
391         emit Transfer(sender, recipient, amount);
392 
393         _afterTokenTransfer(sender, recipient, amount);
394     }
395 
396     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
397      * the total supply.
398      *
399      * Emits a {Transfer} event with `from` set to the zero address.
400      *
401      * Requirements:
402      *
403      * - `account` cannot be the zero address.
404      */
405     function _mint(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: mint to the zero address");
407 
408         _beforeTokenTransfer(address(0), account, amount);
409 
410         _totalSupply += amount;
411         _balances[account] += amount;
412         emit Transfer(address(0), account, amount);
413 
414         _afterTokenTransfer(address(0), account, amount);
415     }
416 
417     /**
418      * @dev Destroys `amount` tokens from `account`, reducing the
419      * total supply.
420      *
421      * Emits a {Transfer} event with `to` set to the zero address.
422      *
423      * Requirements:
424      *
425      * - `account` cannot be the zero address.
426      * - `account` must have at least `amount` tokens.
427      */
428     function _burn(address account, uint256 amount) internal virtual {
429         require(account != address(0), "ERC20: burn from the zero address");
430 
431         _beforeTokenTransfer(account, address(0), amount);
432 
433         uint256 accountBalance = _balances[account];
434         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
435         unchecked {
436             _balances[account] = accountBalance - amount;
437         }
438         _totalSupply -= amount;
439 
440         emit Transfer(account, address(0), amount);
441 
442         _afterTokenTransfer(account, address(0), amount);
443     }
444 
445     /**
446      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
447      *
448      * This internal function is equivalent to `approve`, and can be used to
449      * e.g. set automatic allowances for certain subsystems, etc.
450      *
451      * Emits an {Approval} event.
452      *
453      * Requirements:
454      *
455      * - `owner` cannot be the zero address.
456      * - `spender` cannot be the zero address.
457      */
458     function _approve(
459         address owner,
460         address spender,
461         uint256 amount
462     ) internal virtual {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470     /**
471      * @dev Hook that is called before any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * will be transferred to `to`.
478      * - when `from` is zero, `amount` tokens will be minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _beforeTokenTransfer(
485         address from,
486         address to,
487         uint256 amount
488     ) internal virtual {}
489 
490     /**
491      * @dev Hook that is called after any transfer of tokens. This includes
492      * minting and burning.
493      *
494      * Calling conditions:
495      *
496      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
497      * has been transferred to `to`.
498      * - when `from` is zero, `amount` tokens have been minted for `to`.
499      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
500      * - `from` and `to` are never both zero.
501      *
502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
503      */
504     function _afterTokenTransfer(
505         address from,
506         address to,
507         uint256 amount
508     ) internal virtual {}
509 }
510 
511 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
512 
513 
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @title ERC20Decimals
520  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
521  */
522 abstract contract ERC20Decimals is ERC20 {
523     uint8 private immutable _decimals;
524 
525     /**
526      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
527      * set once during construction.
528      */
529     constructor(uint8 decimals_) {
530         _decimals = decimals_;
531     }
532 
533     function decimals() public view virtual override returns (uint8) {
534         return _decimals;
535     }
536 }
537 
538 // File: contracts/service/ServicePayer.sol
539 
540 
541 
542 pragma solidity ^0.8.0;
543 
544 interface IPayable {
545     function pay(string memory serviceName) external payable;
546 }
547 
548 /**
549  * @title ServicePayer
550  * @dev Implementation of the ServicePayer
551  */
552 abstract contract ServicePayer {
553     constructor(address payable receiver, string memory serviceName) payable {
554         IPayable(receiver).pay{value: msg.value}(serviceName);
555     }
556 }
557 
558 // File: contracts/token/ERC20/StandardERC20.sol
559 
560 
561 
562 pragma solidity ^0.8.0;
563 
564 
565 
566 /**
567  * @title StandardERC20
568  * @dev Implementation of the StandardERC20
569  */
570 contract StandardERC20 is ERC20Decimals, ServicePayer {
571     constructor(
572         string memory name_,
573         string memory symbol_,
574         uint8 decimals_,
575         uint256 initialBalance_,
576         address payable feeReceiver_
577     ) payable ERC20(name_, symbol_) ERC20Decimals(decimals_) ServicePayer(feeReceiver_, "StandardERC20") {
578         require(initialBalance_ > 0, "StandardERC20: supply cannot be zero");
579 
580         _mint(_msgSender(), initialBalance_);
581     }
582 
583     function decimals() public view virtual override returns (uint8) {
584         return super.decimals();
585     }
586 }