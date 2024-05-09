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
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
100 
101 
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Interface for the optional metadata functions from the ERC20 standard.
108  *
109  * _Available since v4.1._
110  */
111 interface IERC20Metadata is IERC20 {
112     /**
113      * @dev Returns the name of the token.
114      */
115     function name() external view returns (string memory);
116 
117     /**
118      * @dev Returns the symbol of the token.
119      */
120     function symbol() external view returns (string memory);
121 
122     /**
123      * @dev Returns the decimals places of the token.
124      */
125     function decimals() external view returns (uint8);
126 }
127 
128 // File: @openzeppelin/contracts/utils/Context.sol
129 
130 
131 
132 pragma solidity ^0.8.0;
133 
134 /*
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
150         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
151         return msg.data;
152     }
153 }
154 
155 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
156 
157 
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
175  * We have followed general OpenZeppelin guidelines: functions revert instead
176  * of returning `false` on failure. This behavior is nonetheless conventional
177  * and does not conflict with the expectations of ERC20 applications.
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
189     mapping (address => uint256) private _balances;
190 
191     mapping (address => mapping (address => uint256)) private _allowances;
192 
193     uint256 private _totalSupply;
194 
195     string private _name;
196     string private _symbol;
197 
198     /**
199      * @dev Sets the values for {name} and {symbol}.
200      *
201      * The defaut value of {decimals} is 18. To select a different value for
202      * {decimals} you should overload it.
203      *
204      * All two of these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor (string memory name_, string memory symbol_) {
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
230      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
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
303     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
304         _transfer(sender, recipient, amount);
305 
306         uint256 currentAllowance = _allowances[sender][_msgSender()];
307         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
308         _approve(sender, _msgSender(), currentAllowance - amount);
309 
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
327         return true;
328     }
329 
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         uint256 currentAllowance = _allowances[_msgSender()][spender];
346         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
347         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
348 
349         return true;
350     }
351 
352     /**
353      * @dev Moves tokens `amount` from `sender` to `recipient`.
354      *
355      * This is internal function is equivalent to {transfer}, and can be used to
356      * e.g. implement automatic token fees, slashing mechanisms, etc.
357      *
358      * Emits a {Transfer} event.
359      *
360      * Requirements:
361      *
362      * - `sender` cannot be the zero address.
363      * - `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      */
366     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
367         require(sender != address(0), "ERC20: transfer from the zero address");
368         require(recipient != address(0), "ERC20: transfer to the zero address");
369 
370         _beforeTokenTransfer(sender, recipient, amount);
371 
372         uint256 senderBalance = _balances[sender];
373         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
374         _balances[sender] = senderBalance - amount;
375         _balances[recipient] += amount;
376 
377         emit Transfer(sender, recipient, amount);
378     }
379 
380     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
381      * the total supply.
382      *
383      * Emits a {Transfer} event with `from` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `to` cannot be the zero address.
388      */
389     function _mint(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: mint to the zero address");
391 
392         _beforeTokenTransfer(address(0), account, amount);
393 
394         _totalSupply += amount;
395         _balances[account] += amount;
396         emit Transfer(address(0), account, amount);
397     }
398 
399     /**
400      * @dev Destroys `amount` tokens from `account`, reducing the
401      * total supply.
402      *
403      * Emits a {Transfer} event with `to` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `account` cannot be the zero address.
408      * - `account` must have at least `amount` tokens.
409      */
410     function _burn(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: burn from the zero address");
412 
413         _beforeTokenTransfer(account, address(0), amount);
414 
415         uint256 accountBalance = _balances[account];
416         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
417         _balances[account] = accountBalance - amount;
418         _totalSupply -= amount;
419 
420         emit Transfer(account, address(0), amount);
421     }
422 
423     /**
424      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
425      *
426      * This internal function is equivalent to `approve`, and can be used to
427      * e.g. set automatic allowances for certain subsystems, etc.
428      *
429      * Emits an {Approval} event.
430      *
431      * Requirements:
432      *
433      * - `owner` cannot be the zero address.
434      * - `spender` cannot be the zero address.
435      */
436     function _approve(address owner, address spender, uint256 amount) internal virtual {
437         require(owner != address(0), "ERC20: approve from the zero address");
438         require(spender != address(0), "ERC20: approve to the zero address");
439 
440         _allowances[owner][spender] = amount;
441         emit Approval(owner, spender, amount);
442     }
443 
444     /**
445      * @dev Hook that is called before any transfer of tokens. This includes
446      * minting and burning.
447      *
448      * Calling conditions:
449      *
450      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
451      * will be to transferred to `to`.
452      * - when `from` is zero, `amount` tokens will be minted for `to`.
453      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
454      * - `from` and `to` are never both zero.
455      *
456      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
457      */
458     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
459 }
460 
461 // File: contracts/service/ServicePayer.sol
462 
463 
464 
465 pragma solidity ^0.8.0;
466 
467 interface IPayable {
468     function pay(string memory serviceName) external payable;
469 }
470 
471 /**
472  * @title ServicePayer
473  * @dev Implementation of the ServicePayer
474  */
475 abstract contract ServicePayer {
476     constructor(address payable receiver, string memory serviceName) payable {
477         IPayable(receiver).pay{value: msg.value}(serviceName);
478     }
479 }
480 
481 // File: contracts/utils/GeneratorCopyright.sol
482 
483 
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @title GeneratorCopyright
489  * @dev Implementation of the GeneratorCopyright
490  */
491 contract GeneratorCopyright {
492     string private constant _GENERATOR = "https://vittominacori.github.io/erc20-generator";
493     string private _version;
494 
495     constructor(string memory version_) {
496         _version = version_;
497     }
498 
499     /**
500      * @dev Returns the token generator tool.
501      */
502     function generator() public pure returns (string memory) {
503         return _GENERATOR;
504     }
505 
506     /**
507      * @dev Returns the token generator version.
508      */
509     function version() public view returns (string memory) {
510         return _version;
511     }
512 }
513 
514 // File: contracts/token/ERC20/SimpleERC20.sol
515 
516 
517 
518 pragma solidity ^0.8.0;
519 
520 
521 
522 
523 /**
524  * @title SimpleERC20
525  * @author ERC20 Generator (https://vittominacori.github.io/erc20-generator)
526  * @dev Implementation of the SimpleERC20
527  */
528 contract SimpleERC20 is ERC20, ServicePayer, GeneratorCopyright("v5.1.0") {
529     constructor(
530         string memory name_,
531         string memory symbol_,
532         uint256 initialBalance_,
533         address payable feeReceiver_
534     ) payable ERC20(name_, symbol_) ServicePayer(feeReceiver_, "SimpleERC20") {
535         require(initialBalance_ > 0, "SimpleERC20: supply cannot be zero");
536 
537         _mint(_msgSender(), initialBalance_);
538     }
539 }