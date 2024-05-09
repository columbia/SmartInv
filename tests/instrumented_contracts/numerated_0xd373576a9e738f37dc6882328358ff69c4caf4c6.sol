1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
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
28 
29 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
110 
111 
112 
113 pragma solidity ^0.8.0;
114 
115 
116 /**
117  * @dev Interface for the optional metadata functions from the ERC20 standard.
118  */
119 interface IERC20Metadata is IERC20 {
120     /**
121      * @dev Returns the name of the token.
122      */
123     function name() external view returns (string memory);
124 
125     /**
126      * @dev Returns the symbol of the token.
127      */
128     function symbol() external view returns (string memory);
129 
130     /**
131      * @dev Returns the decimals places of the token.
132      */
133     function decimals() external view returns (uint8);
134 }
135 
136 
137 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
138 
139 
140 
141 pragma solidity ^0.8.0;
142 
143 
144 
145 
146 /**
147  * @dev Implementation of the {IERC20} interface.
148  *
149  * This implementation is agnostic to the way tokens are created. This means
150  * that a supply mechanism has to be added in a derived contract using {_mint}.
151  * For a generic mechanism see {ERC20PresetMinterPauser}.
152  *
153  * TIP: For a detailed writeup see our guide
154  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
155  * to implement supply mechanisms].
156  *
157  * We have followed general OpenZeppelin guidelines: functions revert instead
158  * of returning `false` on failure. This behavior is nonetheless conventional
159  * and does not conflict with the expectations of ERC20 applications.
160  *
161  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
162  * This allows applications to reconstruct the allowance for all accounts just
163  * by listening to said events. Other implementations of the EIP may not emit
164  * these events, as it isn't required by the specification.
165  *
166  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
167  * functions have been added to mitigate the well-known issues around setting
168  * allowances. See {IERC20-approve}.
169  */
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping (address => uint256) private _balances;
172 
173     mapping (address => mapping (address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     /**
181      * @dev Sets the values for {name} and {symbol}.
182      *
183      * The defaut value of {decimals} is 18. To select a different value for
184      * {decimals} you should overload it.
185      *
186      * All two of these values are immutable: they can only be set once during
187      * construction.
188      */
189     constructor (string memory name_, string memory symbol_) {
190         _name = name_;
191         _symbol = symbol_;
192     }
193 
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() public view virtual override returns (string memory) {
198         return _name;
199     }
200 
201     /**
202      * @dev Returns the symbol of the token, usually a shorter version of the
203      * name.
204      */
205     function symbol() public view virtual override returns (string memory) {
206         return _symbol;
207     }
208 
209     /**
210      * @dev Returns the number of decimals used to get its user representation.
211      * For example, if `decimals` equals `2`, a balance of `505` tokens should
212      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
213      *
214      * Tokens usually opt for a value of 18, imitating the relationship between
215      * Ether and Wei. This is the value {ERC20} uses, unless this function is
216      * overridden;
217      *
218      * NOTE: This information is only used for _display_ purposes: it in
219      * no way affects any of the arithmetic of the contract, including
220      * {IERC20-balanceOf} and {IERC20-transfer}.
221      */
222     function decimals() public view virtual override returns (uint8) {
223         return 18;
224     }
225 
226     /**
227      * @dev See {IERC20-totalSupply}.
228      */
229     function totalSupply() public view virtual override returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See {IERC20-balanceOf}.
235      */
236     function balanceOf(address account) public view virtual override returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See {IERC20-transfer}.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 amount) public virtual override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-transferFrom}.
274      *
275      * Emits an {Approval} event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of {ERC20}.
277      *
278      * Requirements:
279      *
280      * - `sender` and `recipient` cannot be the zero address.
281      * - `sender` must have a balance of at least `amount`.
282      * - the caller must have allowance for ``sender``'s tokens of at least
283      * `amount`.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
286         _transfer(sender, recipient, amount);
287 
288         uint256 currentAllowance = _allowances[sender][_msgSender()];
289         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
290         _approve(sender, _msgSender(), currentAllowance - amount);
291 
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
308         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
327         uint256 currentAllowance = _allowances[_msgSender()][spender];
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
330 
331         return true;
332     }
333 
334     /**
335      * @dev Moves tokens `amount` from `sender` to `recipient`.
336      *
337      * This is internal function is equivalent to {transfer}, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a {Transfer} event.
341      *
342      * Requirements:
343      *
344      * - `sender` cannot be the zero address.
345      * - `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      */
348     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
349         require(sender != address(0), "ERC20: transfer from the zero address");
350         require(recipient != address(0), "ERC20: transfer to the zero address");
351 
352         _beforeTokenTransfer(sender, recipient, amount);
353 
354         uint256 senderBalance = _balances[sender];
355         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
356         _balances[sender] = senderBalance - amount;
357         _balances[recipient] += amount;
358 
359         emit Transfer(sender, recipient, amount);
360     }
361 
362     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
363      * the total supply.
364      *
365      * Emits a {Transfer} event with `from` set to the zero address.
366      *
367      * Requirements:
368      *
369      * - `to` cannot be the zero address.
370      */
371     function _mint(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: mint to the zero address");
373 
374         _beforeTokenTransfer(address(0), account, amount);
375 
376         _totalSupply += amount;
377         _balances[account] += amount;
378         emit Transfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _beforeTokenTransfer(account, address(0), amount);
396 
397         uint256 accountBalance = _balances[account];
398         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
399         _balances[account] = accountBalance - amount;
400         _totalSupply -= amount;
401 
402         emit Transfer(account, address(0), amount);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(address owner, address spender, uint256 amount) internal virtual {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = amount;
423         emit Approval(owner, spender, amount);
424     }
425 
426     /**
427      * @dev Hook that is called before any transfer of tokens. This includes
428      * minting and burning.
429      *
430      * Calling conditions:
431      *
432      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
433      * will be to transferred to `to`.
434      * - when `from` is zero, `amount` tokens will be minted for `to`.
435      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
436      * - `from` and `to` are never both zero.
437      *
438      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
439      */
440     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
441 }
442 
443 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol
444 
445 
446 pragma solidity ^0.8.0;
447 
448 
449 
450 /**
451  * @dev Extension of {ERC20} that allows token holders to destroy both their own
452  * tokens and those that they have an allowance for, in a way that can be
453  * recognized off-chain (via event analysis).
454  */
455 abstract contract ERC20Burnable is Context, ERC20 {
456     /**
457      * @dev Destroys `amount` tokens from the caller.
458      *
459      * See {ERC20-_burn}.
460      */
461     function burn(uint256 amount) public virtual {
462         _burn(_msgSender(), amount);
463     }
464 
465     /**
466      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
467      * allowance.
468      *
469      * See {ERC20-_burn} and {ERC20-allowance}.
470      *
471      * Requirements:
472      *
473      * - the caller must have allowance for ``accounts``'s tokens of at least
474      * `amount`.
475      */
476     function burnFrom(address account, uint256 amount) public virtual {
477         uint256 currentAllowance = allowance(account, _msgSender());
478         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
479         _approve(account, _msgSender(), currentAllowance - amount);
480         _burn(account, amount);
481     }
482 }
483 
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @dev {ERC20} token, including:
490  *
491  *  - Preminted initial supply
492  *  - Ability for holders to burn (destroy) their tokens
493  *  - No access control mechanism (for minting/pausing) and hence no governance
494  *
495  * This contract uses {ERC20Burnable} to include burn capabilities - head to
496  * its documentation for details.
497  *
498  * _Available since v3.4._
499  */
500 contract ZamzamToken is ERC20Burnable {
501     /**
502      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
503      *
504      * See {ERC20-constructor}.
505      */
506     constructor(
507         string memory name,
508         string memory symbol,
509         uint256 initialSupply,
510         address owner
511     ) ERC20(name, symbol) {
512         _mint(owner, initialSupply);
513     }
514 }