1 // File: contracts/DonToken/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: contracts/DonToken/IERC20Metadata.sol
82 
83 
84 pragma solidity ^0.8.0;
85 
86 
87 /**
88  * @dev Interface for the optional metadata functions from the ERC20 standard.
89  *
90  * _Available since v4.1._
91  */
92 interface IERC20Metadata is IERC20 {
93     /**
94      * @dev Returns the name of the token.
95      */
96     function name() external view returns (string memory);
97 
98     /**
99      * @dev Returns the symbol of the token.
100      */
101     function symbol() external view returns (string memory);
102 
103     /**
104      * @dev Returns the decimals places of the token.
105      */
106     function decimals() external view returns (uint8);
107 }
108 
109 // File: contracts/DonToken/Context.sol
110 
111 
112 pragma solidity ^0.8.0;
113 
114 /*
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 // File: contracts/DonToken/ERC20.sol
136 
137 
138 pragma solidity ^0.8.0;
139 
140 
141 
142 
143 /**
144  * @dev Implementation of the {IERC20} interface.
145  *
146  * This implementation is agnostic to the way tokens are created. This means
147  * that a supply mechanism has to be added in a derived contract using {_mint}.
148  * For a generic mechanism see {ERC20PresetMinterPauser}.
149  *
150  * TIP: For a detailed writeup see our guide
151  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
152  * to implement supply mechanisms].
153  *
154  * We have followed general OpenZeppelin guidelines: functions revert instead
155  * of returning `false` on failure. This behavior is nonetheless conventional
156  * and does not conflict with the expectations of ERC20 applications.
157  *
158  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
159  * This allows applications to reconstruct the allowance for all accounts just
160  * by listening to said events. Other implementations of the EIP may not emit
161  * these events, as it isn't required by the specification.
162  *
163  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
164  * functions have been added to mitigate the well-known issues around setting
165  * allowances. See {IERC20-approve}.
166  */
167 contract ERC20 is Context, IERC20, IERC20Metadata {
168     mapping (address => uint256) private _balances;
169 
170     mapping (address => mapping (address => uint256)) private _allowances;
171 
172     uint256 private _totalSupply;
173 
174     string private _name;
175     string private _symbol;
176 
177     /**
178      * @dev Sets the values for {name} and {symbol}.
179      *
180      * The defaut value of {decimals} is 18. To select a different value for
181      * {decimals} you should overload it.
182      *
183      * All two of these values are immutable: they can only be set once during
184      * construction.
185      */
186     constructor (string memory name_, string memory symbol_) {
187         _name = name_;
188         _symbol = symbol_;
189     }
190 
191     /**
192      * @dev Returns the name of the token.
193      */
194     function name() public view virtual override returns (string memory) {
195         return _name;
196     }
197 
198     /**
199      * @dev Returns the symbol of the token, usually a shorter version of the
200      * name.
201      */
202     function symbol() public view virtual override returns (string memory) {
203         return _symbol;
204     }
205 
206     /**
207      * @dev Returns the number of decimals used to get its user representation.
208      * For example, if `decimals` equals `2`, a balance of `505` tokens should
209      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
210      *
211      * Tokens usually opt for a value of 18, imitating the relationship between
212      * Ether and Wei. This is the value {ERC20} uses, unless this function is
213      * overridden;
214      *
215      * NOTE: This information is only used for _display_ purposes: it in
216      * no way affects any of the arithmetic of the contract, including
217      * {IERC20-balanceOf} and {IERC20-transfer}.
218      */
219     function decimals() public view virtual override returns (uint8) {
220         return 18;
221     }
222 
223     /**
224      * @dev See {IERC20-totalSupply}.
225      */
226     function totalSupply() public view virtual override returns (uint256) {
227         return _totalSupply;
228     }
229 
230     /**
231      * @dev See {IERC20-balanceOf}.
232      */
233     function balanceOf(address account) public view virtual override returns (uint256) {
234         return _balances[account];
235     }
236 
237     /**
238      * @dev See {IERC20-transfer}.
239      *
240      * Requirements:
241      *
242      * - `recipient` cannot be the zero address.
243      * - the caller must have a balance of at least `amount`.
244      */
245     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
246         _transfer(_msgSender(), recipient, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-allowance}.
252      */
253     function allowance(address owner, address spender) public view virtual override returns (uint256) {
254         return _allowances[owner][spender];
255     }
256 
257     /**
258      * @dev See {IERC20-approve}.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      */
264     function approve(address spender, uint256 amount) public virtual override returns (bool) {
265         _approve(_msgSender(), spender, amount);
266         return true;
267     }
268 
269     /**
270      * @dev See {IERC20-transferFrom}.
271      *
272      * Emits an {Approval} event indicating the updated allowance. This is not
273      * required by the EIP. See the note at the beginning of {ERC20}.
274      *
275      * Requirements:
276      *
277      * - `sender` and `recipient` cannot be the zero address.
278      * - `sender` must have a balance of at least `amount`.
279      * - the caller must have allowance for ``sender``'s tokens of at least
280      * `amount`.
281      */
282     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
283         _transfer(sender, recipient, amount);
284 
285         uint256 currentAllowance = _allowances[sender][_msgSender()];
286         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
287         _approve(sender, _msgSender(), currentAllowance - amount);
288 
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to {approve} that can be used as a mitigation for
296      * problems described in {IERC20-approve}.
297      *
298      * Emits an {Approval} event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
305         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
324         uint256 currentAllowance = _allowances[_msgSender()][spender];
325         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
326         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
327 
328         return true;
329     }
330 
331     /**
332      * @dev Moves tokens `amount` from `sender` to `recipient`.
333      *
334      * This is internal function is equivalent to {transfer}, and can be used to
335      * e.g. implement automatic token fees, slashing mechanisms, etc.
336      *
337      * Emits a {Transfer} event.
338      *
339      * Requirements:
340      *
341      * - `sender` cannot be the zero address.
342      * - `recipient` cannot be the zero address.
343      * - `sender` must have a balance of at least `amount`.
344      */
345     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
346         require(sender != address(0), "ERC20: transfer from the zero address");
347         require(recipient != address(0), "ERC20: transfer to the zero address");
348 
349         _beforeTokenTransfer(sender, recipient, amount);
350 
351         uint256 senderBalance = _balances[sender];
352         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
353         _balances[sender] = senderBalance - amount;
354         _balances[recipient] += amount;
355 
356         emit Transfer(sender, recipient, amount);
357     }
358 
359     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
360      * the total supply.
361      *
362      * Emits a {Transfer} event with `from` set to the zero address.
363      *
364      * Requirements:
365      *
366      * - `to` cannot be the zero address.
367      */
368     function _mint(address account, uint256 amount) internal virtual {
369         require(account != address(0), "ERC20: mint to the zero address");
370 
371         _beforeTokenTransfer(address(0), account, amount);
372 
373         _totalSupply += amount;
374         _balances[account] += amount;
375         emit Transfer(address(0), account, amount);
376     }
377 
378     /**
379      * @dev Destroys `amount` tokens from `account`, reducing the
380      * total supply.
381      *
382      * Emits a {Transfer} event with `to` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      * - `account` must have at least `amount` tokens.
388      */
389     function _burn(address account, uint256 amount) internal virtual {
390         require(account != address(0), "ERC20: burn from the zero address");
391 
392         _beforeTokenTransfer(account, address(0), amount);
393 
394         uint256 accountBalance = _balances[account];
395         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
396         _balances[account] = accountBalance - amount;
397         _totalSupply -= amount;
398 
399         emit Transfer(account, address(0), amount);
400     }
401 
402     /**
403      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
404      *
405      * This internal function is equivalent to `approve`, and can be used to
406      * e.g. set automatic allowances for certain subsystems, etc.
407      *
408      * Emits an {Approval} event.
409      *
410      * Requirements:
411      *
412      * - `owner` cannot be the zero address.
413      * - `spender` cannot be the zero address.
414      */
415     function _approve(address owner, address spender, uint256 amount) internal virtual {
416         require(owner != address(0), "ERC20: approve from the zero address");
417         require(spender != address(0), "ERC20: approve to the zero address");
418 
419         _allowances[owner][spender] = amount;
420         emit Approval(owner, spender, amount);
421     }
422 
423     /**
424      * @dev Hook that is called before any transfer of tokens. This includes
425      * minting and burning.
426      *
427      * Calling conditions:
428      *
429      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
430      * will be to transferred to `to`.
431      * - when `from` is zero, `amount` tokens will be minted for `to`.
432      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
433      * - `from` and `to` are never both zero.
434      *
435      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
436      */
437     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
438 }
439 
440 // File: contracts/DonToken/ERC20Burnable.sol
441 
442 
443 pragma solidity ^0.8.0;
444 
445 
446 
447 /**
448  * @dev Extension of {ERC20} that allows token holders to destroy both their own
449  * tokens and those that they have an allowance for, in a way that can be
450  * recognized off-chain (via event analysis).
451  */
452 abstract contract ERC20Burnable is Context, ERC20 {
453     /**
454      * @dev Destroys `amount` tokens from the caller.
455      *
456      * See {ERC20-_burn}.
457      */
458     function burn(uint256 amount) public virtual {
459         _burn(_msgSender(), amount);
460     }
461 
462     /**
463      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
464      * allowance.
465      *
466      * See {ERC20-_burn} and {ERC20-allowance}.
467      *
468      * Requirements:
469      *
470      * - the caller must have allowance for ``accounts``'s tokens of at least
471      * `amount`.
472      */
473     function burnFrom(address account, uint256 amount) public virtual {
474         uint256 currentAllowance = allowance(account, _msgSender());
475         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
476         _approve(account, _msgSender(), currentAllowance - amount);
477         _burn(account, amount);
478     }
479 }
480 
481 // File: contracts/DonToken/DonToken.sol
482 
483 
484 pragma solidity ^0.8.0;
485 
486 
487 contract Donkey is ERC20Burnable {
488 
489     constructor() ERC20("Donkey","DON"){
490       
491         uint256 initialSupply = 100000000 * 10 ** decimals();
492         
493         _mint(_msgSender(), initialSupply);
494     }
495 }