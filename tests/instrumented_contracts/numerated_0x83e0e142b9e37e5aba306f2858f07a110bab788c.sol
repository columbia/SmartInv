1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
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
134 
135 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
136 
137 pragma solidity ^0.8.0;
138 
139 
140 
141 
142 /**
143  * @dev Implementation of the {IERC20} interface.
144  *
145  * This implementation is agnostic to the way tokens are created. This means
146  * that a supply mechanism has to be added in a derived contract using {_mint}.
147  * For a generic mechanism see {ERC20PresetMinterPauser}.
148  *
149  * TIP: For a detailed writeup see our guide
150  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
151  * to implement supply mechanisms].
152  *
153  * We have followed general OpenZeppelin guidelines: functions revert instead
154  * of returning `false` on failure. This behavior is nonetheless conventional
155  * and does not conflict with the expectations of ERC20 applications.
156  *
157  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
158  * This allows applications to reconstruct the allowance for all accounts just
159  * by listening to said events. Other implementations of the EIP may not emit
160  * these events, as it isn't required by the specification.
161  *
162  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
163  * functions have been added to mitigate the well-known issues around setting
164  * allowances. See {IERC20-approve}.
165  */
166 contract ERC20 is Context, IERC20, IERC20Metadata {
167     mapping (address => uint256) private _balances;
168 
169     mapping (address => mapping (address => uint256)) private _allowances;
170 
171     uint256 private _totalSupply;
172 
173     string private _name;
174     string private _symbol;
175 
176     /**
177      * @dev Sets the values for {name} and {symbol}.
178      *
179      * The defaut value of {decimals} is 18. To select a different value for
180      * {decimals} you should overload it.
181      *
182      * All two of these values are immutable: they can only be set once during
183      * construction.
184      */
185     constructor (string memory name_, string memory symbol_) {
186         _name = name_;
187         _symbol = symbol_;
188     }
189 
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() public view virtual override returns (string memory) {
194         return _name;
195     }
196 
197     /**
198      * @dev Returns the symbol of the token, usually a shorter version of the
199      * name.
200      */
201     function symbol() public view virtual override returns (string memory) {
202         return _symbol;
203     }
204 
205     /**
206      * @dev Returns the number of decimals used to get its user representation.
207      * For example, if `decimals` equals `2`, a balance of `505` tokens should
208      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
209      *
210      * Tokens usually opt for a value of 18, imitating the relationship between
211      * Ether and Wei. This is the value {ERC20} uses, unless this function is
212      * overridden;
213      *
214      * NOTE: This information is only used for _display_ purposes: it in
215      * no way affects any of the arithmetic of the contract, including
216      * {IERC20-balanceOf} and {IERC20-transfer}.
217      */
218     function decimals() public view virtual override returns (uint8) {
219         return 9;
220     }
221 
222     /**
223      * @dev See {IERC20-totalSupply}.
224      */
225     function totalSupply() public view virtual override returns (uint256) {
226         return _totalSupply;
227     }
228 
229     /**
230      * @dev See {IERC20-balanceOf}.
231      */
232     function balanceOf(address account) public view virtual override returns (uint256) {
233         return _balances[account];
234     }
235 
236     /**
237      * @dev See {IERC20-transfer}.
238      *
239      * Requirements:
240      *
241      * - `recipient` cannot be the zero address.
242      * - the caller must have a balance of at least `amount`.
243      */
244     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
245         _transfer(_msgSender(), recipient, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See {IERC20-allowance}.
251      */
252     function allowance(address owner, address spender) public view virtual override returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     /**
257      * @dev See {IERC20-approve}.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      */
263     function approve(address spender, uint256 amount) public virtual override returns (bool) {
264         _approve(_msgSender(), spender, amount);
265         return true;
266     }
267 
268     /**
269      * @dev See {IERC20-transferFrom}.
270      *
271      * Emits an {Approval} event indicating the updated allowance. This is not
272      * required by the EIP. See the note at the beginning of {ERC20}.
273      *
274      * Requirements:
275      *
276      * - `sender` and `recipient` cannot be the zero address.
277      * - `sender` must have a balance of at least `amount`.
278      * - the caller must have allowance for ``sender``'s tokens of at least
279      * `amount`.
280      */
281     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
282         _transfer(sender, recipient, amount);
283 
284         uint256 currentAllowance = _allowances[sender][_msgSender()];
285         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
286         _approve(sender, _msgSender(), currentAllowance - amount);
287 
288         return true;
289     }
290 
291     /**
292      * @dev Atomically increases the allowance granted to `spender` by the caller.
293      *
294      * This is an alternative to {approve} that can be used as a mitigation for
295      * problems described in {IERC20-approve}.
296      *
297      * Emits an {Approval} event indicating the updated allowance.
298      *
299      * Requirements:
300      *
301      * - `spender` cannot be the zero address.
302      */
303     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
304         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
305         return true;
306     }
307 
308     /**
309      * @dev Atomically decreases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      * - `spender` must have allowance for the caller of at least
320      * `subtractedValue`.
321      */
322     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
323         uint256 currentAllowance = _allowances[_msgSender()][spender];
324         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
325         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
326 
327         return true;
328     }
329 
330     /**
331      * @dev Moves tokens `amount` from `sender` to `recipient`.
332      *
333      * This is internal function is equivalent to {transfer}, and can be used to
334      * e.g. implement automatic token fees, slashing mechanisms, etc.
335      *
336      * Emits a {Transfer} event.
337      *
338      * Requirements:
339      *
340      * - `sender` cannot be the zero address.
341      * - `recipient` cannot be the zero address.
342      * - `sender` must have a balance of at least `amount`.
343      */
344     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
345         require(sender != address(0), "ERC20: transfer from the zero address");
346         require(recipient != address(0), "ERC20: transfer to the zero address");
347 
348         _beforeTokenTransfer(sender, recipient, amount);
349 
350         uint256 senderBalance = _balances[sender];
351         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
352         _balances[sender] = senderBalance - amount;
353         _balances[recipient] += amount;
354 
355         emit Transfer(sender, recipient, amount);
356     }
357 
358     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
359      * the total supply.
360      *
361      * Emits a {Transfer} event with `from` set to the zero address.
362      *
363      * Requirements:
364      *
365      * - `to` cannot be the zero address.
366      */
367     function _mint(address account, uint256 amount) internal virtual {
368         require(account != address(0), "ERC20: mint to the zero address");
369 
370         _beforeTokenTransfer(address(0), account, amount);
371 
372         _totalSupply += amount;
373         _balances[account] += amount;
374         emit Transfer(address(0), account, amount);
375     }
376 
377     /**
378      * @dev Destroys `amount` tokens from `account`, reducing the
379      * total supply.
380      *
381      * Emits a {Transfer} event with `to` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      * - `account` must have at least `amount` tokens.
387      */
388     function _burn(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: burn from the zero address");
390 
391         _beforeTokenTransfer(account, address(0), amount);
392 
393         uint256 accountBalance = _balances[account];
394         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
395         _balances[account] = accountBalance - amount;
396         _totalSupply -= amount;
397 
398         emit Transfer(account, address(0), amount);
399     }
400 
401     /**
402      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
403      *
404      * This internal function is equivalent to `approve`, and can be used to
405      * e.g. set automatic allowances for certain subsystems, etc.
406      *
407      * Emits an {Approval} event.
408      *
409      * Requirements:
410      *
411      * - `owner` cannot be the zero address.
412      * - `spender` cannot be the zero address.
413      */
414     function _approve(address owner, address spender, uint256 amount) internal virtual {
415         require(owner != address(0), "ERC20: approve from the zero address");
416         require(spender != address(0), "ERC20: approve to the zero address");
417 
418         _allowances[owner][spender] = amount;
419         emit Approval(owner, spender, amount);
420     }
421 
422     /**
423      * @dev Hook that is called before any transfer of tokens. This includes
424      * minting and burning.
425      *
426      * Calling conditions:
427      *
428      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
429      * will be to transferred to `to`.
430      * - when `from` is zero, `amount` tokens will be minted for `to`.
431      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
432      * - `from` and `to` are never both zero.
433      *
434      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
435      */
436     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
437 }
438 
439 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
440 
441 pragma solidity ^0.8.0;
442 
443 
444 
445 /**
446  * @dev Extension of {ERC20} that allows token holders to destroy both their own
447  * tokens and those that they have an allowance for, in a way that can be
448  * recognized off-chain (via event analysis).
449  */
450 abstract contract ERC20Burnable is Context, ERC20 {
451     /**
452      * @dev Destroys `amount` tokens from the caller.
453      *
454      * See {ERC20-_burn}.
455      */
456     function burn(uint256 amount) public virtual {
457         _burn(_msgSender(), amount);
458     }
459 
460     /**
461      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
462      * allowance.
463      *
464      * See {ERC20-_burn} and {ERC20-allowance}.
465      *
466      * Requirements:
467      *
468      * - the caller must have allowance for ``accounts``'s tokens of at least
469      * `amount`.
470      */
471     function burnFrom(address account, uint256 amount) public virtual {
472         uint256 currentAllowance = allowance(account, _msgSender());
473         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
474         _approve(account, _msgSender(), currentAllowance - amount);
475         _burn(account, amount);
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @dev {ERC20} token, including:
486  *
487  *  - Preminted initial supply
488  *  - Ability for holders to burn (destroy) their tokens
489  *  - No access control mechanism (for minting/pausing) and hence no governance
490  *
491  * This contract uses {ERC20Burnable} to include burn capabilities - head to
492  * its documentation for details.
493  *
494  * _Available since v3.4._
495  */
496 contract ERC20PresetFixedSupply is ERC20Burnable {
497     /**
498      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
499      *
500      * See {ERC20-constructor}.
501      */
502     constructor(
503         string memory name,
504         string memory symbol,
505         uint256 initialSupply,
506         address owner
507     ) ERC20(name, symbol) {
508         _mint(owner, initialSupply);
509     }
510 }
511 
512 // File: contracts/trillion.sol
513 
514 // Trillion token
515 
516 pragma solidity ^0.8.0;
517 
518 
519 contract QuadrillionToken is ERC20PresetFixedSupply {
520     constructor() ERC20PresetFixedSupply("Quadrillion", "QQ", 1000000000000000 * 10 ** 9, msg.sender) {
521     }
522 }