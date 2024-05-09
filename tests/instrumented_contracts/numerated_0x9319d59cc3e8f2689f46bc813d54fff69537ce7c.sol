1 // SPDX-License-Identifier: MIT
2 
3 /*
4  * This code has been generated using Token Generator on SmartContracts Tools (https://www.smartcontracts.tools)
5  *
6  * DISCLAIMER: SmartContracts Tools and its company are free of any liability regarding Tokens built 
7  * using Token Generator, and the use that is made of them. Tokens built on Token Generator, their projects, 
8  * their teams, their use of Token (as well as anything related to Token) are in no way connected to 
9  * SmartContracts Tools or its company.
10  */
11 
12 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
13 
14 
15 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20 {
23     /**
24      * @dev Emitted when `value` tokens are moved from one account (`from`) to
25      * another (`to`).
26      *
27      * Note that `value` may be zero.
28      */
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     /**
32      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
33      * a call to {approve}. `value` is the new allowance.
34      */
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 
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
48      * @dev Moves `amount` tokens from the caller's account to `to`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address to, uint256 amount) external returns (bool);
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
82      * @dev Moves `amount` tokens from `from` to `to` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address from,
92         address to,
93         uint256 amount
94     ) external returns (bool);
95 }
96 
97 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
101 
102 pragma solidity ^0.8.0;
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
129 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
156 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 
162 /**
163  * @dev Implementation of the {IERC20} interface.
164  *
165  * This implementation is agnostic to the way tokens are created. This means
166  * that a supply mechanism has to be added in a derived contract using {_mint}.
167  * For a generic mechanism see {ERC20PresetMinterPauser}.
168  *
169  * TIP: For a detailed writeup see our guide
170  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
171  * to implement supply mechanisms].
172  *
173  * We have followed general OpenZeppelin Contracts guidelines: functions revert
174  * instead returning `false` on failure. This behavior is nonetheless
175  * conventional and does not conflict with the expectations of ERC20
176  * applications.
177  *
178  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
179  * This allows applications to reconstruct the allowance for all accounts just
180  * by listening to said events. Other implementations of the EIP may not emit
181  * these events, as it isn't required by the specification.
182  *
183  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
184  * functions have been added to mitigate the well-known issues around setting
185  * allowances. See {IERC20-approve}.
186  */
187 contract ERC20 is Context, IERC20, IERC20Metadata {
188     mapping(address => uint256) private _balances;
189 
190     mapping(address => mapping(address => uint256)) private _allowances;
191 
192     uint256 private _totalSupply;
193 
194     string private _name;
195     string private _symbol;
196 
197     /**
198      * @dev Sets the values for {name} and {symbol}.
199      *
200      * The default value of {decimals} is 18. To select a different value for
201      * {decimals} you should overload it.
202      *
203      * All two of these values are immutable: they can only be set once during
204      * construction.
205      */
206     constructor(string memory name_, string memory symbol_) {
207         _name = name_;
208         _symbol = symbol_;
209     }
210 
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() public view virtual override returns (string memory) {
215         return _name;
216     }
217 
218     /**
219      * @dev Returns the symbol of the token, usually a shorter version of the
220      * name.
221      */
222     function symbol() public view virtual override returns (string memory) {
223         return _symbol;
224     }
225 
226     /**
227      * @dev Returns the number of decimals used to get its user representation.
228      * For example, if `decimals` equals `2`, a balance of `505` tokens should
229      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
230      *
231      * Tokens usually opt for a value of 18, imitating the relationship between
232      * Ether and Wei. This is the value {ERC20} uses, unless this function is
233      * overridden;
234      *
235      * NOTE: This information is only used for _display_ purposes: it in
236      * no way affects any of the arithmetic of the contract, including
237      * {IERC20-balanceOf} and {IERC20-transfer}.
238      */
239     function decimals() public view virtual override returns (uint8) {
240         return 18;
241     }
242 
243     /**
244      * @dev See {IERC20-totalSupply}.
245      */
246     function totalSupply() public view virtual override returns (uint256) {
247         return _totalSupply;
248     }
249 
250     /**
251      * @dev See {IERC20-balanceOf}.
252      */
253     function balanceOf(address account) public view virtual override returns (uint256) {
254         return _balances[account];
255     }
256 
257     /**
258      * @dev See {IERC20-transfer}.
259      *
260      * Requirements:
261      *
262      * - `to` cannot be the zero address.
263      * - the caller must have a balance of at least `amount`.
264      */
265     function transfer(address to, uint256 amount) public virtual override returns (bool) {
266         address owner = _msgSender();
267         _transfer(owner, to, amount);
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
281      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
282      * `transferFrom`. This is semantically equivalent to an infinite approval.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      */
288     function approve(address spender, uint256 amount) public virtual override returns (bool) {
289         address owner = _msgSender();
290         _approve(owner, spender, amount);
291         return true;
292     }
293 
294     /**
295      * @dev See {IERC20-transferFrom}.
296      *
297      * Emits an {Approval} event indicating the updated allowance. This is not
298      * required by the EIP. See the note at the beginning of {ERC20}.
299      *
300      * NOTE: Does not update the allowance if the current allowance
301      * is the maximum `uint256`.
302      *
303      * Requirements:
304      *
305      * - `from` and `to` cannot be the zero address.
306      * - `from` must have a balance of at least `amount`.
307      * - the caller must have allowance for ``from``'s tokens of at least
308      * `amount`.
309      */
310     function transferFrom(
311         address from,
312         address to,
313         uint256 amount
314     ) public virtual override returns (bool) {
315         address spender = _msgSender();
316         _spendAllowance(from, spender, amount);
317         _transfer(from, to, amount);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically increases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      */
333     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
334         address owner = _msgSender();
335         _approve(owner, spender, allowance(owner, spender) + addedValue);
336         return true;
337     }
338 
339     /**
340      * @dev Atomically decreases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      * - `spender` must have allowance for the caller of at least
351      * `subtractedValue`.
352      */
353     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
354         address owner = _msgSender();
355         uint256 currentAllowance = allowance(owner, spender);
356         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
357         unchecked {
358             _approve(owner, spender, currentAllowance - subtractedValue);
359         }
360 
361         return true;
362     }
363 
364     /**
365      * @dev Moves `amount` of tokens from `from` to `to`.
366      *
367      * This internal function is equivalent to {transfer}, and can be used to
368      * e.g. implement automatic token fees, slashing mechanisms, etc.
369      *
370      * Emits a {Transfer} event.
371      *
372      * Requirements:
373      *
374      * - `from` cannot be the zero address.
375      * - `to` cannot be the zero address.
376      * - `from` must have a balance of at least `amount`.
377      */
378     function _transfer(
379         address from,
380         address to,
381         uint256 amount
382     ) internal virtual {
383         require(from != address(0), "ERC20: transfer from the zero address");
384         require(to != address(0), "ERC20: transfer to the zero address");
385 
386         _beforeTokenTransfer(from, to, amount);
387 
388         uint256 fromBalance = _balances[from];
389         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
390         unchecked {
391             _balances[from] = fromBalance - amount;
392             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
393             // decrementing then incrementing.
394             _balances[to] += amount;
395         }
396 
397         emit Transfer(from, to, amount);
398 
399         _afterTokenTransfer(from, to, amount);
400     }
401 
402     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
403      * the total supply.
404      *
405      * Emits a {Transfer} event with `from` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `account` cannot be the zero address.
410      */
411     function _mint(address account, uint256 amount) internal virtual {
412         require(account != address(0), "ERC20: mint to the zero address");
413 
414         _beforeTokenTransfer(address(0), account, amount);
415 
416         _totalSupply += amount;
417         unchecked {
418             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
419             _balances[account] += amount;
420         }
421         emit Transfer(address(0), account, amount);
422 
423         _afterTokenTransfer(address(0), account, amount);
424     }
425 
426     /**
427      * @dev Destroys `amount` tokens from `account`, reducing the
428      * total supply.
429      *
430      * Emits a {Transfer} event with `to` set to the zero address.
431      *
432      * Requirements:
433      *
434      * - `account` cannot be the zero address.
435      * - `account` must have at least `amount` tokens.
436      */
437     function _burn(address account, uint256 amount) internal virtual {
438         require(account != address(0), "ERC20: burn from the zero address");
439 
440         _beforeTokenTransfer(account, address(0), amount);
441 
442         uint256 accountBalance = _balances[account];
443         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
444         unchecked {
445             _balances[account] = accountBalance - amount;
446             // Overflow not possible: amount <= accountBalance <= totalSupply.
447             _totalSupply -= amount;
448         }
449 
450         emit Transfer(account, address(0), amount);
451 
452         _afterTokenTransfer(account, address(0), amount);
453     }
454 
455     /**
456      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
457      *
458      * This internal function is equivalent to `approve`, and can be used to
459      * e.g. set automatic allowances for certain subsystems, etc.
460      *
461      * Emits an {Approval} event.
462      *
463      * Requirements:
464      *
465      * - `owner` cannot be the zero address.
466      * - `spender` cannot be the zero address.
467      */
468     function _approve(
469         address owner,
470         address spender,
471         uint256 amount
472     ) internal virtual {
473         require(owner != address(0), "ERC20: approve from the zero address");
474         require(spender != address(0), "ERC20: approve to the zero address");
475 
476         _allowances[owner][spender] = amount;
477         emit Approval(owner, spender, amount);
478     }
479 
480     /**
481      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
482      *
483      * Does not update the allowance amount in case of infinite allowance.
484      * Revert if not enough allowance is available.
485      *
486      * Might emit an {Approval} event.
487      */
488     function _spendAllowance(
489         address owner,
490         address spender,
491         uint256 amount
492     ) internal virtual {
493         uint256 currentAllowance = allowance(owner, spender);
494         if (currentAllowance != type(uint256).max) {
495             require(currentAllowance >= amount, "ERC20: insufficient allowance");
496             unchecked {
497                 _approve(owner, spender, currentAllowance - amount);
498             }
499         }
500     }
501 
502     /**
503      * @dev Hook that is called before any transfer of tokens. This includes
504      * minting and burning.
505      *
506      * Calling conditions:
507      *
508      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
509      * will be transferred to `to`.
510      * - when `from` is zero, `amount` tokens will be minted for `to`.
511      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
512      * - `from` and `to` are never both zero.
513      *
514      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
515      */
516     function _beforeTokenTransfer(
517         address from,
518         address to,
519         uint256 amount
520     ) internal virtual {}
521 
522     /**
523      * @dev Hook that is called after any transfer of tokens. This includes
524      * minting and burning.
525      *
526      * Calling conditions:
527      *
528      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
529      * has been transferred to `to`.
530      * - when `from` is zero, `amount` tokens have been minted for `to`.
531      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
532      * - `from` and `to` are never both zero.
533      *
534      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
535      */
536     function _afterTokenTransfer(
537         address from,
538         address to,
539         uint256 amount
540     ) internal virtual {}
541 }
542 
543 // File: contracts/service/ServicePayer.sol
544 
545 
546 
547 pragma solidity ^0.8.0;
548 
549 interface IPayable {
550     function pay(string memory serviceName, bytes memory signature, address wallet) external payable;
551 }
552 
553 /**
554  * @title ServicePayer
555  * @dev Implementation of the ServicePayer
556  */
557 abstract contract ServicePayer {
558     constructor(address payable receiver, string memory serviceName, bytes memory signature, address wallet) payable {
559         IPayable(receiver).pay{value: msg.value}(serviceName, signature, wallet);
560     }
561 }
562 
563 // File: contracts/utils/GeneratorCopyright.sol
564 
565 
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @title GeneratorCopyright
571  * @author SmartContracts Tools (https://www.smartcontracts.tools)
572  * @dev Implementation of the GeneratorCopyright
573  */
574 contract GeneratorCopyright {
575     string private constant _GENERATOR = "https://www.smartcontracts.tools";
576 
577     /**
578      * @dev Returns the token generator tool.
579      */
580     function generator() public pure returns (string memory) {
581         return _GENERATOR;
582     }
583 }
584 
585 // File: contracts/token/ERC20/SimpleERC20.sol
586 
587 
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @title SimpleERC20
594  * @author SmartContracts Tools (https://www.smartcontracts.tools)
595  * @dev Implementation of the SimpleERC20
596  */
597 contract SimpleERC20 is ERC20, ServicePayer, GeneratorCopyright {
598     constructor(
599         string memory name_,
600         string memory symbol_,
601         uint256 initialBalance_,
602         bytes memory signature_,
603         address payable feeReceiver_
604     ) payable ERC20(name_, symbol_) ServicePayer(feeReceiver_, "SimpleERC20", signature_, _msgSender()) {
605         require(initialBalance_ > 0, "SimpleERC20: supply cannot be zero");
606 
607         _mint(_msgSender(), initialBalance_);
608     }
609 }
