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
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
104 
105 
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Interface for the optional metadata functions from the ERC20 standard.
112  *
113  * _Available since v4.1._
114  */
115 interface IERC20Metadata is IERC20 {
116     /**
117      * @dev Returns the name of the token.
118      */
119     function name() external view returns (string memory);
120 
121     /**
122      * @dev Returns the symbol of the token.
123      */
124     function symbol() external view returns (string memory);
125 
126     /**
127      * @dev Returns the decimals places of the token.
128      */
129     function decimals() external view returns (uint8);
130 }
131 
132 // File: @openzeppelin/contracts/utils/Context.sol
133 
134 
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev Provides information about the current execution context, including the
140  * sender of the transaction and its data. While these are generally available
141  * via msg.sender and msg.data, they should not be accessed in such a direct
142  * manner, since when dealing with meta-transactions the account sending and
143  * paying for execution may not be the actual sender (as far as an application
144  * is concerned).
145  *
146  * This contract is only required for intermediate, library-like contracts.
147  */
148 abstract contract Context {
149     function _msgSender() internal view virtual returns (address) {
150         return msg.sender;
151     }
152 
153     function _msgData() internal view virtual returns (bytes calldata) {
154         return msg.data;
155     }
156 }
157 
158 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
159 
160 
161 
162 pragma solidity ^0.8.0;
163 
164 
165 
166 
167 /**
168  * @dev Implementation of the {IERC20} interface.
169  *
170  * This implementation is agnostic to the way tokens are created. This means
171  * that a supply mechanism has to be added in a derived contract using {_mint}.
172  * For a generic mechanism see {ERC20PresetMinterPauser}.
173  *
174  * TIP: For a detailed writeup see our guide
175  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
176  * to implement supply mechanisms].
177  *
178  * We have followed general OpenZeppelin Contracts guidelines: functions revert
179  * instead returning `false` on failure. This behavior is nonetheless
180  * conventional and does not conflict with the expectations of ERC20
181  * applications.
182  *
183  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
184  * This allows applications to reconstruct the allowance for all accounts just
185  * by listening to said events. Other implementations of the EIP may not emit
186  * these events, as it isn't required by the specification.
187  *
188  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
189  * functions have been added to mitigate the well-known issues around setting
190  * allowances. See {IERC20-approve}.
191  */
192 contract ERC20 is Context, IERC20, IERC20Metadata {
193     mapping(address => uint256) private _balances;
194 
195     mapping(address => mapping(address => uint256)) private _allowances;
196 
197     uint256 private _totalSupply;
198 
199     string private _name;
200     string private _symbol;
201 
202     /**
203      * @dev Sets the values for {name} and {symbol}.
204      *
205      * The default value of {decimals} is 18. To select a different value for
206      * {decimals} you should overload it.
207      *
208      * All two of these values are immutable: they can only be set once during
209      * construction.
210      */
211     constructor(string memory name_, string memory symbol_) {
212         _name = name_;
213         _symbol = symbol_;
214     }
215 
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() public view virtual override returns (string memory) {
220         return _name;
221     }
222 
223     /**
224      * @dev Returns the symbol of the token, usually a shorter version of the
225      * name.
226      */
227     function symbol() public view virtual override returns (string memory) {
228         return _symbol;
229     }
230 
231     /**
232      * @dev Returns the number of decimals used to get its user representation.
233      * For example, if `decimals` equals `2`, a balance of `505` tokens should
234      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
235      *
236      * Tokens usually opt for a value of 18, imitating the relationship between
237      * Ether and Wei. This is the value {ERC20} uses, unless this function is
238      * overridden;
239      *
240      * NOTE: This information is only used for _display_ purposes: it in
241      * no way affects any of the arithmetic of the contract, including
242      * {IERC20-balanceOf} and {IERC20-transfer}.
243      */
244     function decimals() public view virtual override returns (uint8) {
245         return 18;
246     }
247 
248     /**
249      * @dev See {IERC20-totalSupply}.
250      */
251     function totalSupply() public view virtual override returns (uint256) {
252         return _totalSupply;
253     }
254 
255     /**
256      * @dev See {IERC20-balanceOf}.
257      */
258     function balanceOf(address account) public view virtual override returns (uint256) {
259         return _balances[account];
260     }
261 
262     /**
263      * @dev See {IERC20-transfer}.
264      *
265      * Requirements:
266      *
267      * - `recipient` cannot be the zero address.
268      * - the caller must have a balance of at least `amount`.
269      */
270     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-allowance}.
277      */
278     function allowance(address owner, address spender) public view virtual override returns (uint256) {
279         return _allowances[owner][spender];
280     }
281 
282     /**
283      * @dev See {IERC20-approve}.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 amount) public virtual override returns (bool) {
290         _approve(_msgSender(), spender, amount);
291         return true;
292     }
293 
294     /**
295      * @dev See {IERC20-transferFrom}.
296      *
297      * Emits an {Approval} event indicating the updated allowance. This is not
298      * required by the EIP. See the note at the beginning of {ERC20}.
299      *
300      * Requirements:
301      *
302      * - `sender` and `recipient` cannot be the zero address.
303      * - `sender` must have a balance of at least `amount`.
304      * - the caller must have allowance for ``sender``'s tokens of at least
305      * `amount`.
306      */
307     function transferFrom(
308         address sender,
309         address recipient,
310         uint256 amount
311     ) public virtual override returns (bool) {
312         _transfer(sender, recipient, amount);
313 
314         uint256 currentAllowance = _allowances[sender][_msgSender()];
315         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
316         unchecked {
317             _approve(sender, _msgSender(), currentAllowance - amount);
318         }
319 
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
336         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
337         return true;
338     }
339 
340     /**
341      * @dev Atomically decreases the allowance granted to `spender` by the caller.
342      *
343      * This is an alternative to {approve} that can be used as a mitigation for
344      * problems described in {IERC20-approve}.
345      *
346      * Emits an {Approval} event indicating the updated allowance.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      * - `spender` must have allowance for the caller of at least
352      * `subtractedValue`.
353      */
354     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
355         uint256 currentAllowance = _allowances[_msgSender()][spender];
356         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
357         unchecked {
358             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
359         }
360 
361         return true;
362     }
363 
364     /**
365      * @dev Moves `amount` of tokens from `sender` to `recipient`.
366      *
367      * This internal function is equivalent to {transfer}, and can be used to
368      * e.g. implement automatic token fees, slashing mechanisms, etc.
369      *
370      * Emits a {Transfer} event.
371      *
372      * Requirements:
373      *
374      * - `sender` cannot be the zero address.
375      * - `recipient` cannot be the zero address.
376      * - `sender` must have a balance of at least `amount`.
377      */
378     function _transfer(
379         address sender,
380         address recipient,
381         uint256 amount
382     ) internal virtual {
383         require(sender != address(0), "ERC20: transfer from the zero address");
384         require(recipient != address(0), "ERC20: transfer to the zero address");
385 
386         _beforeTokenTransfer(sender, recipient, amount);
387 
388         uint256 senderBalance = _balances[sender];
389         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
390         unchecked {
391             _balances[sender] = senderBalance - amount;
392         }
393         _balances[recipient] += amount;
394 
395         emit Transfer(sender, recipient, amount);
396 
397         _afterTokenTransfer(sender, recipient, amount);
398     }
399 
400     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
401      * the total supply.
402      *
403      * Emits a {Transfer} event with `from` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `account` cannot be the zero address.
408      */
409     function _mint(address account, uint256 amount) internal virtual {
410         require(account != address(0), "ERC20: mint to the zero address");
411 
412         _beforeTokenTransfer(address(0), account, amount);
413 
414         _totalSupply += amount;
415         _balances[account] += amount;
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
441         }
442         _totalSupply -= amount;
443 
444         emit Transfer(account, address(0), amount);
445 
446         _afterTokenTransfer(account, address(0), amount);
447     }
448 
449     /**
450      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
451      *
452      * This internal function is equivalent to `approve`, and can be used to
453      * e.g. set automatic allowances for certain subsystems, etc.
454      *
455      * Emits an {Approval} event.
456      *
457      * Requirements:
458      *
459      * - `owner` cannot be the zero address.
460      * - `spender` cannot be the zero address.
461      */
462     function _approve(
463         address owner,
464         address spender,
465         uint256 amount
466     ) internal virtual {
467         require(owner != address(0), "ERC20: approve from the zero address");
468         require(spender != address(0), "ERC20: approve to the zero address");
469 
470         _allowances[owner][spender] = amount;
471         emit Approval(owner, spender, amount);
472     }
473 
474     /**
475      * @dev Hook that is called before any transfer of tokens. This includes
476      * minting and burning.
477      *
478      * Calling conditions:
479      *
480      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
481      * will be transferred to `to`.
482      * - when `from` is zero, `amount` tokens will be minted for `to`.
483      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
484      * - `from` and `to` are never both zero.
485      *
486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
487      */
488     function _beforeTokenTransfer(
489         address from,
490         address to,
491         uint256 amount
492     ) internal virtual {}
493 
494     /**
495      * @dev Hook that is called after any transfer of tokens. This includes
496      * minting and burning.
497      *
498      * Calling conditions:
499      *
500      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
501      * has been transferred to `to`.
502      * - when `from` is zero, `amount` tokens have been minted for `to`.
503      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
504      * - `from` and `to` are never both zero.
505      *
506      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
507      */
508     function _afterTokenTransfer(
509         address from,
510         address to,
511         uint256 amount
512     ) internal virtual {}
513 }
514 
515 // File: contracts/service/ServicePayer.sol
516 
517 
518 
519 pragma solidity ^0.8.0;
520 
521 interface IPayable {
522     function pay(string memory serviceName) external payable;
523 }
524 
525 /**
526  * @title ServicePayer
527  * @dev Implementation of the ServicePayer
528  */
529 abstract contract ServicePayer {
530     constructor(address payable receiver, string memory serviceName) payable {
531         IPayable(receiver).pay{value: msg.value}(serviceName);
532     }
533 }
534 
535 // File: contracts/utils/GeneratorCopyright.sol
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @title GeneratorCopyright
543  * @author ERC20 Generator (https://vittominacori.github.io/erc20-generator)
544  * @dev Implementation of the GeneratorCopyright
545  */
546 contract GeneratorCopyright {
547     string private constant _GENERATOR = "https://vittominacori.github.io/erc20-generator";
548     string private _version;
549 
550     constructor(string memory version_) {
551         _version = version_;
552     }
553 
554     /**
555      * @dev Returns the token generator tool.
556      */
557     function generator() public pure returns (string memory) {
558         return _GENERATOR;
559     }
560 
561     /**
562      * @dev Returns the token generator version.
563      */
564     function version() public view returns (string memory) {
565         return _version;
566     }
567 }
568 
569 // File: contracts/token/ERC20/SimpleERC20.sol
570 
571 
572 
573 pragma solidity ^0.8.0;
574 
575 
576 
577 
578 /**
579  * @title SimpleERC20
580  * @author ERC20 Generator (https://vittominacori.github.io/erc20-generator)
581  * @dev Implementation of the SimpleERC20
582  */
583 contract SimpleERC20 is ERC20, ServicePayer, GeneratorCopyright("v5.3.0") {
584     constructor(
585         string memory name_,
586         string memory symbol_,
587         uint256 initialBalance_,
588         address payable feeReceiver_
589     ) payable ERC20(name_, symbol_) ServicePayer(feeReceiver_, "SimpleERC20") {
590         require(initialBalance_ > 0, "SimpleERC20: supply cannot be zero");
591 
592         _mint(_msgSender(), initialBalance_);
593     }
594 }
