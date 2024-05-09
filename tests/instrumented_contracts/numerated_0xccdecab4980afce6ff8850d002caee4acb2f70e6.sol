1 // SPDX-License-Identifier: MIT
2 
3 /*
4  * This code has been generated using Token Generator on SmartContracts Tools (https://www.smartcontracts.tools)
5  */
6 
7 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Emitted when `value` tokens are moved from one account (`from`) to
20      * another (`to`).
21      *
22      * Note that `value` may be zero.
23      */
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     /**
27      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
28      * a call to {approve}. `value` is the new allowance.
29      */
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `to`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address to, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `from` to `to` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(
86         address from,
87         address to,
88         uint256 amount
89     ) external returns (bool);
90 }
91 
92 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
93 
94 
95 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Interface for the optional metadata functions from the ERC20 standard.
101  *
102  * _Available since v4.1._
103  */
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 // File: @openzeppelin/contracts/utils/Context.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev Provides information about the current execution context, including the
130  * sender of the transaction and its data. While these are generally available
131  * via msg.sender and msg.data, they should not be accessed in such a direct
132  * manner, since when dealing with meta-transactions the account sending and
133  * paying for execution may not be the actual sender (as far as an application
134  * is concerned).
135  *
136  * This contract is only required for intermediate, library-like contracts.
137  */
138 abstract contract Context {
139     function _msgSender() internal view virtual returns (address) {
140         return msg.sender;
141     }
142 
143     function _msgData() internal view virtual returns (bytes calldata) {
144         return msg.data;
145     }
146 }
147 
148 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
149 
150 
151 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
152 
153 pragma solidity ^0.8.0;
154 
155 
156 
157 /**
158  * @dev Implementation of the {IERC20} interface.
159  *
160  * This implementation is agnostic to the way tokens are created. This means
161  * that a supply mechanism has to be added in a derived contract using {_mint}.
162  * For a generic mechanism see {ERC20PresetMinterPauser}.
163  *
164  * TIP: For a detailed writeup see our guide
165  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
166  * to implement supply mechanisms].
167  *
168  * We have followed general OpenZeppelin Contracts guidelines: functions revert
169  * instead returning `false` on failure. This behavior is nonetheless
170  * conventional and does not conflict with the expectations of ERC20
171  * applications.
172  *
173  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
174  * This allows applications to reconstruct the allowance for all accounts just
175  * by listening to said events. Other implementations of the EIP may not emit
176  * these events, as it isn't required by the specification.
177  *
178  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
179  * functions have been added to mitigate the well-known issues around setting
180  * allowances. See {IERC20-approve}.
181  */
182 contract ERC20 is Context, IERC20, IERC20Metadata {
183     mapping(address => uint256) private _balances;
184 
185     mapping(address => mapping(address => uint256)) private _allowances;
186 
187     uint256 private _totalSupply;
188 
189     string private _name;
190     string private _symbol;
191 
192     /**
193      * @dev Sets the values for {name} and {symbol}.
194      *
195      * The default value of {decimals} is 18. To select a different value for
196      * {decimals} you should overload it.
197      *
198      * All two of these values are immutable: they can only be set once during
199      * construction.
200      */
201     constructor(string memory name_, string memory symbol_) {
202         _name = name_;
203         _symbol = symbol_;
204     }
205 
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() public view virtual override returns (string memory) {
210         return _name;
211     }
212 
213     /**
214      * @dev Returns the symbol of the token, usually a shorter version of the
215      * name.
216      */
217     function symbol() public view virtual override returns (string memory) {
218         return _symbol;
219     }
220 
221     /**
222      * @dev Returns the number of decimals used to get its user representation.
223      * For example, if `decimals` equals `2`, a balance of `505` tokens should
224      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
225      *
226      * Tokens usually opt for a value of 18, imitating the relationship between
227      * Ether and Wei. This is the value {ERC20} uses, unless this function is
228      * overridden;
229      *
230      * NOTE: This information is only used for _display_ purposes: it in
231      * no way affects any of the arithmetic of the contract, including
232      * {IERC20-balanceOf} and {IERC20-transfer}.
233      */
234     function decimals() public view virtual override returns (uint8) {
235         return 18;
236     }
237 
238     /**
239      * @dev See {IERC20-totalSupply}.
240      */
241     function totalSupply() public view virtual override returns (uint256) {
242         return _totalSupply;
243     }
244 
245     /**
246      * @dev See {IERC20-balanceOf}.
247      */
248     function balanceOf(address account) public view virtual override returns (uint256) {
249         return _balances[account];
250     }
251 
252     /**
253      * @dev See {IERC20-transfer}.
254      *
255      * Requirements:
256      *
257      * - `to` cannot be the zero address.
258      * - the caller must have a balance of at least `amount`.
259      */
260     function transfer(address to, uint256 amount) public virtual override returns (bool) {
261         address owner = _msgSender();
262         _transfer(owner, to, amount);
263         return true;
264     }
265 
266     /**
267      * @dev See {IERC20-allowance}.
268      */
269     function allowance(address owner, address spender) public view virtual override returns (uint256) {
270         return _allowances[owner][spender];
271     }
272 
273     /**
274      * @dev See {IERC20-approve}.
275      *
276      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
277      * `transferFrom`. This is semantically equivalent to an infinite approval.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      */
283     function approve(address spender, uint256 amount) public virtual override returns (bool) {
284         address owner = _msgSender();
285         _approve(owner, spender, amount);
286         return true;
287     }
288 
289     /**
290      * @dev See {IERC20-transferFrom}.
291      *
292      * Emits an {Approval} event indicating the updated allowance. This is not
293      * required by the EIP. See the note at the beginning of {ERC20}.
294      *
295      * NOTE: Does not update the allowance if the current allowance
296      * is the maximum `uint256`.
297      *
298      * Requirements:
299      *
300      * - `from` and `to` cannot be the zero address.
301      * - `from` must have a balance of at least `amount`.
302      * - the caller must have allowance for ``from``'s tokens of at least
303      * `amount`.
304      */
305     function transferFrom(
306         address from,
307         address to,
308         uint256 amount
309     ) public virtual override returns (bool) {
310         address spender = _msgSender();
311         _spendAllowance(from, spender, amount);
312         _transfer(from, to, amount);
313         return true;
314     }
315 
316     /**
317      * @dev Atomically increases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      */
328     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
329         address owner = _msgSender();
330         _approve(owner, spender, allowance(owner, spender) + addedValue);
331         return true;
332     }
333 
334     /**
335      * @dev Atomically decreases the allowance granted to `spender` by the caller.
336      *
337      * This is an alternative to {approve} that can be used as a mitigation for
338      * problems described in {IERC20-approve}.
339      *
340      * Emits an {Approval} event indicating the updated allowance.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      * - `spender` must have allowance for the caller of at least
346      * `subtractedValue`.
347      */
348     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
349         address owner = _msgSender();
350         uint256 currentAllowance = allowance(owner, spender);
351         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
352         unchecked {
353             _approve(owner, spender, currentAllowance - subtractedValue);
354         }
355 
356         return true;
357     }
358 
359     /**
360      * @dev Moves `amount` of tokens from `from` to `to`.
361      *
362      * This internal function is equivalent to {transfer}, and can be used to
363      * e.g. implement automatic token fees, slashing mechanisms, etc.
364      *
365      * Emits a {Transfer} event.
366      *
367      * Requirements:
368      *
369      * - `from` cannot be the zero address.
370      * - `to` cannot be the zero address.
371      * - `from` must have a balance of at least `amount`.
372      */
373     function _transfer(
374         address from,
375         address to,
376         uint256 amount
377     ) internal virtual {
378         require(from != address(0), "ERC20: transfer from the zero address");
379         require(to != address(0), "ERC20: transfer to the zero address");
380 
381         _beforeTokenTransfer(from, to, amount);
382 
383         uint256 fromBalance = _balances[from];
384         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
385         unchecked {
386             _balances[from] = fromBalance - amount;
387             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
388             // decrementing then incrementing.
389             _balances[to] += amount;
390         }
391 
392         emit Transfer(from, to, amount);
393 
394         _afterTokenTransfer(from, to, amount);
395     }
396 
397     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
398      * the total supply.
399      *
400      * Emits a {Transfer} event with `from` set to the zero address.
401      *
402      * Requirements:
403      *
404      * - `account` cannot be the zero address.
405      */
406     function _mint(address account, uint256 amount) internal virtual {
407         require(account != address(0), "ERC20: mint to the zero address");
408 
409         _beforeTokenTransfer(address(0), account, amount);
410 
411         _totalSupply += amount;
412         unchecked {
413             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
414             _balances[account] += amount;
415         }
416         emit Transfer(address(0), account, amount);
417 
418         _afterTokenTransfer(address(0), account, amount);
419     }
420 
421     /**
422      * @dev Destroys `amount` tokens from `account`, reducing the
423      * total supply.
424      *
425      * Emits a {Transfer} event with `to` set to the zero address.
426      *
427      * Requirements:
428      *
429      * - `account` cannot be the zero address.
430      * - `account` must have at least `amount` tokens.
431      */
432     function _burn(address account, uint256 amount) internal virtual {
433         require(account != address(0), "ERC20: burn from the zero address");
434 
435         _beforeTokenTransfer(account, address(0), amount);
436 
437         uint256 accountBalance = _balances[account];
438         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
439         unchecked {
440             _balances[account] = accountBalance - amount;
441             // Overflow not possible: amount <= accountBalance <= totalSupply.
442             _totalSupply -= amount;
443         }
444 
445         emit Transfer(account, address(0), amount);
446 
447         _afterTokenTransfer(account, address(0), amount);
448     }
449 
450     /**
451      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
452      *
453      * This internal function is equivalent to `approve`, and can be used to
454      * e.g. set automatic allowances for certain subsystems, etc.
455      *
456      * Emits an {Approval} event.
457      *
458      * Requirements:
459      *
460      * - `owner` cannot be the zero address.
461      * - `spender` cannot be the zero address.
462      */
463     function _approve(
464         address owner,
465         address spender,
466         uint256 amount
467     ) internal virtual {
468         require(owner != address(0), "ERC20: approve from the zero address");
469         require(spender != address(0), "ERC20: approve to the zero address");
470 
471         _allowances[owner][spender] = amount;
472         emit Approval(owner, spender, amount);
473     }
474 
475     /**
476      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
477      *
478      * Does not update the allowance amount in case of infinite allowance.
479      * Revert if not enough allowance is available.
480      *
481      * Might emit an {Approval} event.
482      */
483     function _spendAllowance(
484         address owner,
485         address spender,
486         uint256 amount
487     ) internal virtual {
488         uint256 currentAllowance = allowance(owner, spender);
489         if (currentAllowance != type(uint256).max) {
490             require(currentAllowance >= amount, "ERC20: insufficient allowance");
491             unchecked {
492                 _approve(owner, spender, currentAllowance - amount);
493             }
494         }
495     }
496 
497     /**
498      * @dev Hook that is called before any transfer of tokens. This includes
499      * minting and burning.
500      *
501      * Calling conditions:
502      *
503      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
504      * will be transferred to `to`.
505      * - when `from` is zero, `amount` tokens will be minted for `to`.
506      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
507      * - `from` and `to` are never both zero.
508      *
509      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
510      */
511     function _beforeTokenTransfer(
512         address from,
513         address to,
514         uint256 amount
515     ) internal virtual {}
516 
517     /**
518      * @dev Hook that is called after any transfer of tokens. This includes
519      * minting and burning.
520      *
521      * Calling conditions:
522      *
523      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
524      * has been transferred to `to`.
525      * - when `from` is zero, `amount` tokens have been minted for `to`.
526      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
527      * - `from` and `to` are never both zero.
528      *
529      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
530      */
531     function _afterTokenTransfer(
532         address from,
533         address to,
534         uint256 amount
535     ) internal virtual {}
536 }
537 
538 // File: contracts/service/ServicePayer.sol
539 
540 
541 
542 pragma solidity ^0.8.0;
543 
544 interface IPayable {
545     function pay(string memory serviceName, bytes memory signature, address wallet) external payable;
546 }
547 
548 /**
549  * @title ServicePayer
550  * @dev Implementation of the ServicePayer
551  */
552 abstract contract ServicePayer {
553     constructor(address payable receiver, string memory serviceName, bytes memory signature, address wallet) payable {
554         IPayable(receiver).pay{value: msg.value}(serviceName, signature, wallet);
555     }
556 }
557 
558 // File: contracts/utils/GeneratorCopyright.sol
559 
560 
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @title GeneratorCopyright
566  * @author SmartContracts Tools (https://www.smartcontracts.tools)
567  * @dev Implementation of the GeneratorCopyright
568  */
569 contract GeneratorCopyright {
570     string private constant _GENERATOR = "https://www.smartcontracts.tools";
571 
572     /**
573      * @dev Returns the token generator tool.
574      */
575     function generator() external pure returns (string memory) {
576         return _GENERATOR;
577     }
578 }
579 
580 // File: contracts/token/ERC20/SimpleERC20.sol
581 
582 
583 
584 pragma solidity ^0.8.0;
585 
586 
587 /**
588  * @title SimpleERC20
589  * @author SmartContracts Tools (https://www.smartcontracts.tools)
590  * @dev Implementation of the SimpleERC20
591  */
592 contract SimpleERC20 is ERC20, ServicePayer, GeneratorCopyright {
593     constructor(
594         string memory name_,
595         string memory symbol_,
596         uint256 initialBalance_,
597         bytes memory signature_,
598         address payable feeReceiver_
599     ) payable ERC20(name_, symbol_) ServicePayer(feeReceiver_, "SimpleERC20", signature_, _msgSender()) {
600         require(initialBalance_ > 0, "SimpleERC20: supply cannot be zero");
601 
602         _mint(_msgSender(), initialBalance_);
603     }
604 }
