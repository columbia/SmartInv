1 // SPDX-License-Identifier: MIT
2 
3 /*
4  * Token has been generated using https://vittominacori.github.io/erc20-generator/
5  *
6  * NOTE: "Contract Source Code Verified (Similar Match)" means that this Token is similar to other tokens deployed
7  *  using the same generator. It is not an issue. It means that you won't need to verify your source code because of
8  *  it is already verified.
9  *
10  * DISCLAIMER: GENERATOR'S AUTHOR IS FREE OF ANY LIABILITY REGARDING THE TOKEN AND THE USE THAT IS MADE OF IT.
11  *  The following code is provided under MIT License. Anyone can use it as per their needs.
12  *  The generator's purpose is to make people able to tokenize their ideas without coding or paying for it.
13  *  Source code is well tested and continuously updated to reduce risk of bugs and to introduce language optimizations.
14  *  Anyway the purchase of tokens involves a high degree of risk. Before acquiring tokens, it is recommended to
15  *  carefully weighs all the information and risks detailed in Token owner's Conditions.
16  */
17 
18 
19 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
20 
21 
22 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
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
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
105 
106 
107 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 
112 /**
113  * @dev Interface for the optional metadata functions from the ERC20 standard.
114  *
115  * _Available since v4.1._
116  */
117 interface IERC20Metadata is IERC20 {
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() external view returns (string memory);
122 
123     /**
124      * @dev Returns the symbol of the token.
125      */
126     function symbol() external view returns (string memory);
127 
128     /**
129      * @dev Returns the decimals places of the token.
130      */
131     function decimals() external view returns (uint8);
132 }
133 
134 // File: @openzeppelin/contracts/utils/Context.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Provides information about the current execution context, including the
143  * sender of the transaction and its data. While these are generally available
144  * via msg.sender and msg.data, they should not be accessed in such a direct
145  * manner, since when dealing with meta-transactions the account sending and
146  * paying for execution may not be the actual sender (as far as an application
147  * is concerned).
148  *
149  * This contract is only required for intermediate, library-like contracts.
150  */
151 abstract contract Context {
152     function _msgSender() internal view virtual returns (address) {
153         return msg.sender;
154     }
155 
156     function _msgData() internal view virtual returns (bytes calldata) {
157         return msg.data;
158     }
159 }
160 
161 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 
169 
170 
171 /**
172  * @dev Implementation of the {IERC20} interface.
173  *
174  * This implementation is agnostic to the way tokens are created. This means
175  * that a supply mechanism has to be added in a derived contract using {_mint}.
176  * For a generic mechanism see {ERC20PresetMinterPauser}.
177  *
178  * TIP: For a detailed writeup see our guide
179  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
180  * to implement supply mechanisms].
181  *
182  * We have followed general OpenZeppelin Contracts guidelines: functions revert
183  * instead returning `false` on failure. This behavior is nonetheless
184  * conventional and does not conflict with the expectations of ERC20
185  * applications.
186  *
187  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
188  * This allows applications to reconstruct the allowance for all accounts just
189  * by listening to said events. Other implementations of the EIP may not emit
190  * these events, as it isn't required by the specification.
191  *
192  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
193  * functions have been added to mitigate the well-known issues around setting
194  * allowances. See {IERC20-approve}.
195  */
196 contract ERC20 is Context, IERC20, IERC20Metadata {
197     mapping(address => uint256) private _balances;
198 
199     mapping(address => mapping(address => uint256)) private _allowances;
200 
201     uint256 private _totalSupply;
202 
203     string private _name;
204     string private _symbol;
205 
206     /**
207      * @dev Sets the values for {name} and {symbol}.
208      *
209      * The default value of {decimals} is 18. To select a different value for
210      * {decimals} you should overload it.
211      *
212      * All two of these values are immutable: they can only be set once during
213      * construction.
214      */
215     constructor(string memory name_, string memory symbol_) {
216         _name = name_;
217         _symbol = symbol_;
218     }
219 
220     /**
221      * @dev Returns the name of the token.
222      */
223     function name() public view virtual override returns (string memory) {
224         return _name;
225     }
226 
227     /**
228      * @dev Returns the symbol of the token, usually a shorter version of the
229      * name.
230      */
231     function symbol() public view virtual override returns (string memory) {
232         return _symbol;
233     }
234 
235     /**
236      * @dev Returns the number of decimals used to get its user representation.
237      * For example, if `decimals` equals `2`, a balance of `505` tokens should
238      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
239      *
240      * Tokens usually opt for a value of 18, imitating the relationship between
241      * Ether and Wei. This is the value {ERC20} uses, unless this function is
242      * overridden;
243      *
244      * NOTE: This information is only used for _display_ purposes: it in
245      * no way affects any of the arithmetic of the contract, including
246      * {IERC20-balanceOf} and {IERC20-transfer}.
247      */
248     function decimals() public view virtual override returns (uint8) {
249         return 18;
250     }
251 
252     /**
253      * @dev See {IERC20-totalSupply}.
254      */
255     function totalSupply() public view virtual override returns (uint256) {
256         return _totalSupply;
257     }
258 
259     /**
260      * @dev See {IERC20-balanceOf}.
261      */
262     function balanceOf(address account) public view virtual override returns (uint256) {
263         return _balances[account];
264     }
265 
266     /**
267      * @dev See {IERC20-transfer}.
268      *
269      * Requirements:
270      *
271      * - `recipient` cannot be the zero address.
272      * - the caller must have a balance of at least `amount`.
273      */
274     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
275         _transfer(_msgSender(), recipient, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-allowance}.
281      */
282     function allowance(address owner, address spender) public view virtual override returns (uint256) {
283         return _allowances[owner][spender];
284     }
285 
286     /**
287      * @dev See {IERC20-approve}.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function approve(address spender, uint256 amount) public virtual override returns (bool) {
294         _approve(_msgSender(), spender, amount);
295         return true;
296     }
297 
298     /**
299      * @dev See {IERC20-transferFrom}.
300      *
301      * Emits an {Approval} event indicating the updated allowance. This is not
302      * required by the EIP. See the note at the beginning of {ERC20}.
303      *
304      * Requirements:
305      *
306      * - `sender` and `recipient` cannot be the zero address.
307      * - `sender` must have a balance of at least `amount`.
308      * - the caller must have allowance for ``sender``'s tokens of at least
309      * `amount`.
310      */
311     function transferFrom(
312         address sender,
313         address recipient,
314         uint256 amount
315     ) public virtual override returns (bool) {
316         _transfer(sender, recipient, amount);
317 
318         uint256 currentAllowance = _allowances[sender][_msgSender()];
319         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
320         unchecked {
321             _approve(sender, _msgSender(), currentAllowance - amount);
322         }
323 
324         return true;
325     }
326 
327     /**
328      * @dev Atomically increases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
340         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
341         return true;
342     }
343 
344     /**
345      * @dev Atomically decreases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to {approve} that can be used as a mitigation for
348      * problems described in {IERC20-approve}.
349      *
350      * Emits an {Approval} event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      * - `spender` must have allowance for the caller of at least
356      * `subtractedValue`.
357      */
358     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
359         uint256 currentAllowance = _allowances[_msgSender()][spender];
360         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
361         unchecked {
362             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
363         }
364 
365         return true;
366     }
367 
368     /**
369      * @dev Moves `amount` of tokens from `sender` to `recipient`.
370      *
371      * This internal function is equivalent to {transfer}, and can be used to
372      * e.g. implement automatic token fees, slashing mechanisms, etc.
373      *
374      * Emits a {Transfer} event.
375      *
376      * Requirements:
377      *
378      * - `sender` cannot be the zero address.
379      * - `recipient` cannot be the zero address.
380      * - `sender` must have a balance of at least `amount`.
381      */
382     function _transfer(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) internal virtual {
387         require(sender != address(0), "ERC20: transfer from the zero address");
388         require(recipient != address(0), "ERC20: transfer to the zero address");
389 
390         _beforeTokenTransfer(sender, recipient, amount);
391 
392         uint256 senderBalance = _balances[sender];
393         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
394         unchecked {
395             _balances[sender] = senderBalance - amount;
396         }
397         _balances[recipient] += amount;
398 
399         emit Transfer(sender, recipient, amount);
400 
401         _afterTokenTransfer(sender, recipient, amount);
402     }
403 
404     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
405      * the total supply.
406      *
407      * Emits a {Transfer} event with `from` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      */
413     function _mint(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: mint to the zero address");
415 
416         _beforeTokenTransfer(address(0), account, amount);
417 
418         _totalSupply += amount;
419         _balances[account] += amount;
420         emit Transfer(address(0), account, amount);
421 
422         _afterTokenTransfer(address(0), account, amount);
423     }
424 
425     /**
426      * @dev Destroys `amount` tokens from `account`, reducing the
427      * total supply.
428      *
429      * Emits a {Transfer} event with `to` set to the zero address.
430      *
431      * Requirements:
432      *
433      * - `account` cannot be the zero address.
434      * - `account` must have at least `amount` tokens.
435      */
436     function _burn(address account, uint256 amount) internal virtual {
437         require(account != address(0), "ERC20: burn from the zero address");
438 
439         _beforeTokenTransfer(account, address(0), amount);
440 
441         uint256 accountBalance = _balances[account];
442         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
443         unchecked {
444             _balances[account] = accountBalance - amount;
445         }
446         _totalSupply -= amount;
447 
448         emit Transfer(account, address(0), amount);
449 
450         _afterTokenTransfer(account, address(0), amount);
451     }
452 
453     /**
454      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
455      *
456      * This internal function is equivalent to `approve`, and can be used to
457      * e.g. set automatic allowances for certain subsystems, etc.
458      *
459      * Emits an {Approval} event.
460      *
461      * Requirements:
462      *
463      * - `owner` cannot be the zero address.
464      * - `spender` cannot be the zero address.
465      */
466     function _approve(
467         address owner,
468         address spender,
469         uint256 amount
470     ) internal virtual {
471         require(owner != address(0), "ERC20: approve from the zero address");
472         require(spender != address(0), "ERC20: approve to the zero address");
473 
474         _allowances[owner][spender] = amount;
475         emit Approval(owner, spender, amount);
476     }
477 
478     /**
479      * @dev Hook that is called before any transfer of tokens. This includes
480      * minting and burning.
481      *
482      * Calling conditions:
483      *
484      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
485      * will be transferred to `to`.
486      * - when `from` is zero, `amount` tokens will be minted for `to`.
487      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
488      * - `from` and `to` are never both zero.
489      *
490      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
491      */
492     function _beforeTokenTransfer(
493         address from,
494         address to,
495         uint256 amount
496     ) internal virtual {}
497 
498     /**
499      * @dev Hook that is called after any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * has been transferred to `to`.
506      * - when `from` is zero, `amount` tokens have been minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _afterTokenTransfer(
513         address from,
514         address to,
515         uint256 amount
516     ) internal virtual {}
517 }
518 
519 // File: contracts/service/ServicePayer.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 interface IPayable {
526     function pay(string memory serviceName) external payable;
527 }
528 
529 /**
530  * @title ServicePayer
531  * @dev Implementation of the ServicePayer
532  */
533 abstract contract ServicePayer {
534     constructor(address payable receiver, string memory serviceName) payable {
535         IPayable(receiver).pay{value: msg.value}(serviceName);
536     }
537 }
538 
539 // File: contracts/utils/GeneratorCopyright.sol
540 
541 
542 
543 pragma solidity ^0.8.0;
544 
545 /**
546  * @title GeneratorCopyright
547  * @author ERC20 Generator (https://vittominacori.github.io/erc20-generator)
548  * @dev Implementation of the GeneratorCopyright
549  */
550 contract GeneratorCopyright {
551     string private constant _GENERATOR = "https://vittominacori.github.io/erc20-generator";
552     string private _version;
553 
554     constructor(string memory version_) {
555         _version = version_;
556     }
557 
558     /**
559      * @dev Returns the token generator tool.
560      */
561     function generator() public pure returns (string memory) {
562         return _GENERATOR;
563     }
564 
565     /**
566      * @dev Returns the token generator version.
567      */
568     function version() public view returns (string memory) {
569         return _version;
570     }
571 }
572 
573 // File: contracts/token/ERC20/SimpleERC20.sol
574 
575 
576 
577 pragma solidity ^0.8.0;
578 
579 
580 
581 
582 /**
583  * @title SimpleERC20
584  * @author ERC20 Generator (https://vittominacori.github.io/erc20-generator)
585  * @dev Implementation of the SimpleERC20
586  */
587 contract SimpleERC20 is ERC20, ServicePayer, GeneratorCopyright("v5.4.0") {
588     constructor(
589         string memory name_,
590         string memory symbol_,
591         uint256 initialBalance_,
592         address payable feeReceiver_
593     ) payable ERC20(name_, symbol_) ServicePayer(feeReceiver_, "SimpleERC20") {
594         require(initialBalance_ > 0, "SimpleERC20: supply cannot be zero");
595 
596         _mint(_msgSender(), initialBalance_);
597     }
598 }