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
104 
105 /**
106  * @dev Interface for the optional metadata functions from the ERC20 standard.
107  *
108  * _Available since v4.1._
109  */
110 interface IERC20Metadata is IERC20 {
111     /**
112      * @dev Returns the name of the token.
113      */
114     function name() external view returns (string memory);
115 
116     /**
117      * @dev Returns the symbol of the token.
118      */
119     function symbol() external view returns (string memory);
120 
121     /**
122      * @dev Returns the decimals places of the token.
123      */
124     function decimals() external view returns (uint8);
125 }
126 
127 // File: @openzeppelin/contracts/utils/Context.sol
128 
129 
130 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Provides information about the current execution context, including the
136  * sender of the transaction and its data. While these are generally available
137  * via msg.sender and msg.data, they should not be accessed in such a direct
138  * manner, since when dealing with meta-transactions the account sending and
139  * paying for execution may not be the actual sender (as far as an application
140  * is concerned).
141  *
142  * This contract is only required for intermediate, library-like contracts.
143  */
144 abstract contract Context {
145     function _msgSender() internal view virtual returns (address) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view virtual returns (bytes calldata) {
150         return msg.data;
151     }
152 }
153 
154 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
155 
156 
157 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 
162 
163 
164 /**
165  * @dev Implementation of the {IERC20} interface.
166  *
167  * This implementation is agnostic to the way tokens are created. This means
168  * that a supply mechanism has to be added in a derived contract using {_mint}.
169  * For a generic mechanism see {ERC20PresetMinterPauser}.
170  *
171  * TIP: For a detailed writeup see our guide
172  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
173  * to implement supply mechanisms].
174  *
175  * We have followed general OpenZeppelin Contracts guidelines: functions revert
176  * instead returning `false` on failure. This behavior is nonetheless
177  * conventional and does not conflict with the expectations of ERC20
178  * applications.
179  *
180  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
181  * This allows applications to reconstruct the allowance for all accounts just
182  * by listening to said events. Other implementations of the EIP may not emit
183  * these events, as it isn't required by the specification.
184  *
185  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
186  * functions have been added to mitigate the well-known issues around setting
187  * allowances. See {IERC20-approve}.
188  */
189 contract ERC20 is Context, IERC20, IERC20Metadata {
190     mapping(address => uint256) private _balances;
191 
192     mapping(address => mapping(address => uint256)) private _allowances;
193 
194     uint256 private _totalSupply;
195 
196     string private _name;
197     string private _symbol;
198 
199     /**
200      * @dev Sets the values for {name} and {symbol}.
201      *
202      * The default value of {decimals} is 18. To select a different value for
203      * {decimals} you should overload it.
204      *
205      * All two of these values are immutable: they can only be set once during
206      * construction.
207      */
208     constructor(string memory name_, string memory symbol_) {
209         _name = name_;
210         _symbol = symbol_;
211     }
212 
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() public view virtual override returns (string memory) {
217         return _name;
218     }
219 
220     /**
221      * @dev Returns the symbol of the token, usually a shorter version of the
222      * name.
223      */
224     function symbol() public view virtual override returns (string memory) {
225         return _symbol;
226     }
227 
228     /**
229      * @dev Returns the number of decimals used to get its user representation.
230      * For example, if `decimals` equals `2`, a balance of `505` tokens should
231      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
232      *
233      * Tokens usually opt for a value of 18, imitating the relationship between
234      * Ether and Wei. This is the value {ERC20} uses, unless this function is
235      * overridden;
236      *
237      * NOTE: This information is only used for _display_ purposes: it in
238      * no way affects any of the arithmetic of the contract, including
239      * {IERC20-balanceOf} and {IERC20-transfer}.
240      */
241     function decimals() public view virtual override returns (uint8) {
242         return 18;
243     }
244 
245     /**
246      * @dev See {IERC20-totalSupply}.
247      */
248     function totalSupply() public view virtual override returns (uint256) {
249         return _totalSupply;
250     }
251 
252     /**
253      * @dev See {IERC20-balanceOf}.
254      */
255     function balanceOf(address account) public view virtual override returns (uint256) {
256         return _balances[account];
257     }
258 
259     /**
260      * @dev See {IERC20-transfer}.
261      *
262      * Requirements:
263      *
264      * - `to` cannot be the zero address.
265      * - the caller must have a balance of at least `amount`.
266      */
267     function transfer(address to, uint256 amount) public virtual override returns (bool) {
268         address owner = _msgSender();
269         _transfer(owner, to, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-allowance}.
275      */
276     function allowance(address owner, address spender) public view virtual override returns (uint256) {
277         return _allowances[owner][spender];
278     }
279 
280     /**
281      * @dev See {IERC20-approve}.
282      *
283      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
284      * `transferFrom`. This is semantically equivalent to an infinite approval.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function approve(address spender, uint256 amount) public virtual override returns (bool) {
291         address owner = _msgSender();
292         _approve(owner, spender, amount);
293         return true;
294     }
295 
296     /**
297      * @dev See {IERC20-transferFrom}.
298      *
299      * Emits an {Approval} event indicating the updated allowance. This is not
300      * required by the EIP. See the note at the beginning of {ERC20}.
301      *
302      * NOTE: Does not update the allowance if the current allowance
303      * is the maximum `uint256`.
304      *
305      * Requirements:
306      *
307      * - `from` and `to` cannot be the zero address.
308      * - `from` must have a balance of at least `amount`.
309      * - the caller must have allowance for ``from``'s tokens of at least
310      * `amount`.
311      */
312     function transferFrom(
313         address from,
314         address to,
315         uint256 amount
316     ) public virtual override returns (bool) {
317         address spender = _msgSender();
318         _spendAllowance(from, spender, amount);
319         _transfer(from, to, amount);
320         return true;
321     }
322 
323     /**
324      * @dev Atomically increases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
336         address owner = _msgSender();
337         _approve(owner, spender, allowance(owner, spender) + addedValue);
338         return true;
339     }
340 
341     /**
342      * @dev Atomically decreases the allowance granted to `spender` by the caller.
343      *
344      * This is an alternative to {approve} that can be used as a mitigation for
345      * problems described in {IERC20-approve}.
346      *
347      * Emits an {Approval} event indicating the updated allowance.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      * - `spender` must have allowance for the caller of at least
353      * `subtractedValue`.
354      */
355     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
356         address owner = _msgSender();
357         uint256 currentAllowance = allowance(owner, spender);
358         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
359         unchecked {
360             _approve(owner, spender, currentAllowance - subtractedValue);
361         }
362 
363         return true;
364     }
365 
366     /**
367      * @dev Moves `amount` of tokens from `sender` to `recipient`.
368      *
369      * This internal function is equivalent to {transfer}, and can be used to
370      * e.g. implement automatic token fees, slashing mechanisms, etc.
371      *
372      * Emits a {Transfer} event.
373      *
374      * Requirements:
375      *
376      * - `from` cannot be the zero address.
377      * - `to` cannot be the zero address.
378      * - `from` must have a balance of at least `amount`.
379      */
380     function _transfer(
381         address from,
382         address to,
383         uint256 amount
384     ) internal virtual {
385         require(from != address(0), "ERC20: transfer from the zero address");
386         require(to != address(0), "ERC20: transfer to the zero address");
387 
388         _beforeTokenTransfer(from, to, amount);
389 
390         uint256 fromBalance = _balances[from];
391         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
392         unchecked {
393             _balances[from] = fromBalance - amount;
394         }
395         _balances[to] += amount;
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
417         _balances[account] += amount;
418         emit Transfer(address(0), account, amount);
419 
420         _afterTokenTransfer(address(0), account, amount);
421     }
422 
423     /**
424      * @dev Destroys `amount` tokens from `account`, reducing the
425      * total supply.
426      *
427      * Emits a {Transfer} event with `to` set to the zero address.
428      *
429      * Requirements:
430      *
431      * - `account` cannot be the zero address.
432      * - `account` must have at least `amount` tokens.
433      */
434     function _burn(address account, uint256 amount) internal virtual {
435         require(account != address(0), "ERC20: burn from the zero address");
436 
437         _beforeTokenTransfer(account, address(0), amount);
438 
439         uint256 accountBalance = _balances[account];
440         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
441         unchecked {
442             _balances[account] = accountBalance - amount;
443         }
444         _totalSupply -= amount;
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
491             require(currentAllowance >= amount, "ERC20: insufficient allowance");
492             unchecked {
493                 _approve(owner, spender, currentAllowance - amount);
494             }
495         }
496     }
497 
498     /**
499      * @dev Hook that is called before any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * will be transferred to `to`.
506      * - when `from` is zero, `amount` tokens will be minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _beforeTokenTransfer(
513         address from,
514         address to,
515         uint256 amount
516     ) internal virtual {}
517 
518     /**
519      * @dev Hook that is called after any transfer of tokens. This includes
520      * minting and burning.
521      *
522      * Calling conditions:
523      *
524      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
525      * has been transferred to `to`.
526      * - when `from` is zero, `amount` tokens have been minted for `to`.
527      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
528      * - `from` and `to` are never both zero.
529      *
530      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
531      */
532     function _afterTokenTransfer(
533         address from,
534         address to,
535         uint256 amount
536     ) internal virtual {}
537 }
538 
539 // File: contracts/service/ServicePayer.sol
540 
541 
542 
543 pragma solidity ^0.8.0;
544 
545 interface IPayable {
546     function pay(
547         string memory serviceName,
548         bytes memory signature,
549         address wallet
550     ) external payable;
551 }
552 
553 /**
554  * @title ServicePayer
555  * @dev Implementation of the ServicePayer
556  */
557 abstract contract ServicePayer {
558     constructor(
559         address payable receiver,
560         string memory serviceName,
561         bytes memory signature,
562         address wallet
563     ) payable {
564         IPayable(receiver).pay{value: msg.value}(serviceName, signature, wallet);
565     }
566 }
567 
568 // File: contracts/utils/GeneratorCopyright.sol
569 
570 
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @title GeneratorCopyright
576  * @author SmartContracts Tools (https://www.smartcontracts.tools)
577  * @dev Implementation of the GeneratorCopyright
578  */
579 contract GeneratorCopyright {
580     string private constant _GENERATOR = "https://www.smartcontracts.tools";
581 
582     /**
583      * @dev Returns the token generator tool.
584      */
585     function generator() public pure returns (string memory) {
586         return _GENERATOR;
587     }
588 }
589 
590 // File: contracts/token/ERC20/SimpleERC20.sol
591 
592 
593 
594 pragma solidity ^0.8.0;
595 
596 
597 
598 
599 /**
600  * @title SimpleERC20
601  * @author SmartContracts Tools (https://www.smartcontracts.tools)
602  * @dev Implementation of the SimpleERC20
603  */
604 contract SimpleERC20 is ERC20, ServicePayer, GeneratorCopyright {
605     constructor(
606         string memory name_,
607         string memory symbol_,
608         uint256 initialBalance_,
609         bytes memory signature_,
610         address payable feeReceiver_
611     ) payable ERC20(name_, symbol_) ServicePayer(feeReceiver_, "SimpleERC20", signature_, _msgSender()) {
612         require(initialBalance_ > 0, "SimpleERC20: supply cannot be zero");
613 
614         _mint(_msgSender(), initialBalance_);
615     }
616 }