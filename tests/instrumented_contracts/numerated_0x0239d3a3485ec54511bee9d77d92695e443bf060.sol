1 /**
2  * See you on the Moon
3  * 
4 ██████  ██ ██      ██      ██  ██████  ███    ██ 
5 ██   ██ ██ ██      ██      ██ ██    ██ ████   ██ 
6 ██████  ██ ██      ██      ██ ██    ██ ██ ██  ██ 
7 ██   ██ ██ ██      ██      ██ ██    ██ ██  ██ ██ 
8 ██████  ██ ███████ ███████ ██  ██████  ██   ████ 
9                                                  
10  * Token name : Billion Token
11  * Supply: 1,000,000,000 
12  * Decimal place: 18 
13  * Symbol : BILL 
14  */ 
15 
16 
17 // File: @openzeppelin/contracts/utils/Context.sol
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity ^0.8.0;
22 
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
45 
46 pragma solidity ^0.8.0;
47 
48 /**
49  * @dev Interface of the ERC20 standard as defined in the EIP.
50  */
51 interface IERC20 {
52     /**
53      * @dev Returns the amount of tokens in existence.
54      */
55     function totalSupply() external view returns (uint256);
56 
57     /**
58      * @dev Returns the amount of tokens owned by `account`.
59      */
60     function balanceOf(address account) external view returns (uint256);
61 
62     /**
63      * @dev Moves `amount` tokens from the caller's account to `recipient`.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transfer(address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Returns the remaining number of tokens that `spender` will be
73      * allowed to spend on behalf of `owner` through {transferFrom}. This is
74      * zero by default.
75      *
76      * This value changes when {approve} or {transferFrom} are called.
77      */
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     /**
81      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * IMPORTANT: Beware that changing an allowance with this method brings the risk
86      * that someone may use both the old and the new allowance by unfortunate
87      * transaction ordering. One possible solution to mitigate this race
88      * condition is to first reduce the spender's allowance to 0 and set the
89      * desired value afterwards:
90      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
91      *
92      * Emits an {Approval} event.
93      */
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Moves `amount` tokens from `sender` to `recipient` using the
98      * allowance mechanism. `amount` is then deducted from the caller's
99      * allowance.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Emitted when `value` tokens are moved from one account (`from`) to
109      * another (`to`).
110      *
111      * Note that `value` may be zero.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     /**
116      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
117      * a call to {approve}. `value` is the new allowance.
118      */
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
124 
125 pragma solidity ^0.8.0;
126 
127 
128 /**
129  * @dev Interface for the optional metadata functions from the ERC20 standard.
130  *
131  * _Available since v4.1._
132  */
133 interface IERC20Metadata is IERC20 {
134     /**
135      * @dev Returns the name of the token.
136      */
137     function name() external view returns (string memory);
138 
139     /**
140      * @dev Returns the symbol of the token.
141      */
142     function symbol() external view returns (string memory);
143 
144     /**
145      * @dev Returns the decimals places of the token.
146      */
147     function decimals() external view returns (uint8);
148 }
149 
150 
151 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
152 
153 pragma solidity ^0.8.0;
154 
155 
156 
157 
158 /**
159  * @dev Implementation of the {IERC20} interface.
160  *
161  * This implementation is agnostic to the way tokens are created. This means
162  * that a supply mechanism has to be added in a derived contract using {_mint}.
163  * For a generic mechanism see {ERC20PresetMinterPauser}.
164  *
165  * TIP: For a detailed writeup see our guide
166  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
167  * to implement supply mechanisms].
168  *
169  * We have followed general OpenZeppelin guidelines: functions revert instead
170  * of returning `false` on failure. This behavior is nonetheless conventional
171  * and does not conflict with the expectations of ERC20 applications.
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
183     mapping (address => uint256) private _balances;
184 
185     mapping (address => mapping (address => uint256)) private _allowances;
186 
187     uint256 private _totalSupply;
188 
189     string private _name;
190     string private _symbol;
191 
192     /**
193      * @dev Sets the values for {name} and {symbol}.
194      *
195      * The defaut value of {decimals} is 18. To select a different value for
196      * {decimals} you should overload it.
197      *
198      * All two of these values are immutable: they can only be set once during
199      * construction.
200      */
201     constructor (string memory name_, string memory symbol_) {
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
224      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
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
257      * - `recipient` cannot be the zero address.
258      * - the caller must have a balance of at least `amount`.
259      */
260     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283 
284     /**
285      * @dev See {IERC20-transferFrom}.
286      *
287      * Emits an {Approval} event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of {ERC20}.
289      *
290      * Requirements:
291      *
292      * - `sender` and `recipient` cannot be the zero address.
293      * - `sender` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``sender``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
298         _transfer(sender, recipient, amount);
299 
300         uint256 currentAllowance = _allowances[sender][_msgSender()];
301         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
302         _approve(sender, _msgSender(), currentAllowance - amount);
303 
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
321         return true;
322     }
323 
324     /**
325      * @dev Atomically decreases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      * - `spender` must have allowance for the caller of at least
336      * `subtractedValue`.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         uint256 currentAllowance = _allowances[_msgSender()][spender];
340         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
341         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
342 
343         return true;
344     }
345 
346     /**
347      * @dev Moves tokens `amount` from `sender` to `recipient`.
348      *
349      * This is internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `sender` cannot be the zero address.
357      * - `recipient` cannot be the zero address.
358      * - `sender` must have a balance of at least `amount`.
359      */
360     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
361         require(sender != address(0), "ERC20: transfer from the zero address");
362         require(recipient != address(0), "ERC20: transfer to the zero address");
363 
364         _beforeTokenTransfer(sender, recipient, amount);
365 
366         uint256 senderBalance = _balances[sender];
367         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
368         _balances[sender] = senderBalance - amount;
369         _balances[recipient] += amount;
370 
371         emit Transfer(sender, recipient, amount);
372     }
373 
374     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
375      * the total supply.
376      *
377      * Emits a {Transfer} event with `from` set to the zero address.
378      *
379      * Requirements:
380      *
381      * - `to` cannot be the zero address.
382      */
383     function _mint(address account, uint256 amount) internal virtual {
384         require(account != address(0), "ERC20: mint to the zero address");
385 
386         _beforeTokenTransfer(address(0), account, amount);
387 
388         _totalSupply += amount;
389         _balances[account] += amount;
390         emit Transfer(address(0), account, amount);
391     }
392 
393     /**
394      * @dev Destroys `amount` tokens from `account`, reducing the
395      * total supply.
396      *
397      * Emits a {Transfer} event with `to` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      * - `account` must have at least `amount` tokens.
403      */
404     function _burn(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: burn from the zero address");
406 
407         _beforeTokenTransfer(account, address(0), amount);
408 
409         uint256 accountBalance = _balances[account];
410         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
411         _balances[account] = accountBalance - amount;
412         _totalSupply -= amount;
413 
414         emit Transfer(account, address(0), amount);
415     }
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
419      *
420      * This internal function is equivalent to `approve`, and can be used to
421      * e.g. set automatic allowances for certain subsystems, etc.
422      *
423      * Emits an {Approval} event.
424      *
425      * Requirements:
426      *
427      * - `owner` cannot be the zero address.
428      * - `spender` cannot be the zero address.
429      */
430     function _approve(address owner, address spender, uint256 amount) internal virtual {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433 
434         _allowances[owner][spender] = amount;
435         emit Approval(owner, spender, amount);
436     }
437 
438     /**
439      * @dev Hook that is called before any transfer of tokens. This includes
440      * minting and burning.
441      *
442      * Calling conditions:
443      *
444      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
445      * will be to transferred to `to`.
446      * - when `from` is zero, `amount` tokens will be minted for `to`.
447      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
448      * - `from` and `to` are never both zero.
449      *
450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
451      */
452     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
453 }
454 
455 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
456 
457 pragma solidity ^0.8.0;
458 
459 
460 
461 /**
462  * @dev Extension of {ERC20} that allows token holders to destroy both their own
463  * tokens and those that they have an allowance for, in a way that can be
464  * recognized off-chain (via event analysis).
465  */
466 abstract contract ERC20Burnable is Context, ERC20 {
467     /**
468      * @dev Destroys `amount` tokens from the caller.
469      *
470      * See {ERC20-_burn}.
471      */
472     function burn(uint256 amount) public virtual {
473         _burn(_msgSender(), amount);
474     }
475 
476     /**
477      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
478      * allowance.
479      *
480      * See {ERC20-_burn} and {ERC20-allowance}.
481      *
482      * Requirements:
483      *
484      * - the caller must have allowance for ``accounts``'s tokens of at least
485      * `amount`.
486      */
487     function burnFrom(address account, uint256 amount) public virtual {
488         uint256 currentAllowance = allowance(account, _msgSender());
489         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
490         _approve(account, _msgSender(), currentAllowance - amount);
491         _burn(account, amount);
492     }
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol
496 
497 pragma solidity ^0.8.0;
498 
499 
500 /**
501  * @dev {ERC20} token, including:
502  *
503  *  - Preminted initial supply
504  *  - Ability for holders to burn (destroy) their tokens
505  *  - No access control mechanism (for minting/pausing) and hence no governance
506  *
507  * This contract uses {ERC20Burnable} to include burn capabilities - head to
508  * its documentation for details.
509  *
510  * _Available since v3.4._
511  */
512 contract ERC20PresetFixedSupply is ERC20Burnable {
513     /**
514      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
515      *
516      * See {ERC20-constructor}.
517      */
518     constructor(
519         string memory name,
520         string memory symbol,
521         uint256 initialSupply,
522         address owner
523     ) ERC20(name, symbol) {
524         _mint(owner, initialSupply);
525     }
526 }
527 
528 // File: contracts/Billion.sol
529 
530 // Billion token
531 /**
532  * Token name : Billion 
533  * Supply: 1,000,000,000 
534  * Decimal place: 18 
535  * Symbol : BILL 
536  */ 
537 
538 pragma solidity ^0.8.0;
539 
540 
541 contract BillionToken is ERC20PresetFixedSupply {
542     constructor() ERC20PresetFixedSupply("Billion", "BILL", 1000000000 * 10 ** 18, msg.sender) {
543     }
544 }