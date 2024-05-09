1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
80 
81 pragma solidity ^0.8.0;
82 
83 
84 /**
85  * @dev Interface for the optional metadata functions from the ERC20 standard.
86  *
87  * _Available since v4.1._
88  */
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns (string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns (string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns (uint8);
104 }
105 
106 // File: @openzeppelin/contracts/utils/Context.sol
107 
108 pragma solidity ^0.8.0;
109 
110 /*
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
127         return msg.data;
128     }
129 }
130 
131 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
132 
133 
134 pragma solidity ^0.8.0;
135 
136 
137 
138 
139 /**
140  * @dev Implementation of the {IERC20} interface.
141  *
142  * This implementation is agnostic to the way tokens are created. This means
143  * that a supply mechanism has to be added in a derived contract using {_mint}.
144  * For a generic mechanism see {ERC20PresetMinterPauser}.
145  *
146  * TIP: For a detailed writeup see our guide
147  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
148  * to implement supply mechanisms].
149  *
150  * We have followed general OpenZeppelin guidelines: functions revert instead
151  * of returning `false` on failure. This behavior is nonetheless conventional
152  * and does not conflict with the expectations of ERC20 applications.
153  *
154  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
155  * This allows applications to reconstruct the allowance for all accounts just
156  * by listening to said events. Other implementations of the EIP may not emit
157  * these events, as it isn't required by the specification.
158  *
159  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
160  * functions have been added to mitigate the well-known issues around setting
161  * allowances. See {IERC20-approve}.
162  */
163 contract ERC20 is Context, IERC20, IERC20Metadata {
164     mapping (address => uint256) private _balances;
165 
166     mapping (address => mapping (address => uint256)) private _allowances;
167 
168     uint256 private _totalSupply;
169 
170     string private _name;
171     string private _symbol;
172 
173     /**
174      * @dev Sets the values for {name} and {symbol}.
175      *
176      * The defaut value of {decimals} is 18. To select a different value for
177      * {decimals} you should overload it.
178      *
179      * All two of these values are immutable: they can only be set once during
180      * construction.
181      */
182     constructor (string memory name_, string memory symbol_) {
183         _name = name_;
184         _symbol = symbol_;
185     }
186 
187     /**
188      * @dev Returns the name of the token.
189      */
190     function name() public view virtual override returns (string memory) {
191         return _name;
192     }
193 
194     /**
195      * @dev Returns the symbol of the token, usually a shorter version of the
196      * name.
197      */
198     function symbol() public view virtual override returns (string memory) {
199         return _symbol;
200     }
201 
202     /**
203      * @dev Returns the number of decimals used to get its user representation.
204      * For example, if `decimals` equals `2`, a balance of `505` tokens should
205      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
206      *
207      * Tokens usually opt for a value of 18, imitating the relationship between
208      * Ether and Wei. This is the value {ERC20} uses, unless this function is
209      * overridden;
210      *
211      * NOTE: This information is only used for _display_ purposes: it in
212      * no way affects any of the arithmetic of the contract, including
213      * {IERC20-balanceOf} and {IERC20-transfer}.
214      */
215     function decimals() public view virtual override returns (uint8) {
216         return 18;
217     }
218 
219     /**
220      * @dev See {IERC20-totalSupply}.
221      */
222     function totalSupply() public view virtual override returns (uint256) {
223         return _totalSupply;
224     }
225 
226     /**
227      * @dev See {IERC20-balanceOf}.
228      */
229     function balanceOf(address account) public view virtual override returns (uint256) {
230         return _balances[account];
231     }
232 
233     /**
234      * @dev See {IERC20-transfer}.
235      *
236      * Requirements:
237      *
238      * - `recipient` cannot be the zero address.
239      * - the caller must have a balance of at least `amount`.
240      */
241     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
242         _transfer(_msgSender(), recipient, amount);
243         return true;
244     }
245 
246     /**
247      * @dev See {IERC20-allowance}.
248      */
249     function allowance(address owner, address spender) public view virtual override returns (uint256) {
250         return _allowances[owner][spender];
251     }
252 
253     /**
254      * @dev See {IERC20-approve}.
255      *
256      * Requirements:
257      *
258      * - `spender` cannot be the zero address.
259      */
260     function approve(address spender, uint256 amount) public virtual override returns (bool) {
261         _approve(_msgSender(), spender, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-transferFrom}.
267      *
268      * Emits an {Approval} event indicating the updated allowance. This is not
269      * required by the EIP. See the note at the beginning of {ERC20}.
270      *
271      * Requirements:
272      *
273      * - `sender` and `recipient` cannot be the zero address.
274      * - `sender` must have a balance of at least `amount`.
275      * - the caller must have allowance for ``sender``'s tokens of at least
276      * `amount`.
277      */
278     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
279         _transfer(sender, recipient, amount);
280 
281         uint256 currentAllowance = _allowances[sender][_msgSender()];
282         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
283         _approve(sender, _msgSender(), currentAllowance - amount);
284 
285         return true;
286     }
287 
288     /**
289      * @dev Atomically increases the allowance granted to `spender` by the caller.
290      *
291      * This is an alternative to {approve} that can be used as a mitigation for
292      * problems described in {IERC20-approve}.
293      *
294      * Emits an {Approval} event indicating the updated allowance.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
301         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
302         return true;
303     }
304 
305     /**
306      * @dev Atomically decreases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      * - `spender` must have allowance for the caller of at least
317      * `subtractedValue`.
318      */
319     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
320         uint256 currentAllowance = _allowances[_msgSender()][spender];
321         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
322         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
323 
324         return true;
325     }
326 
327     /**
328      * @dev Moves tokens `amount` from `sender` to `recipient`.
329      *
330      * This is internal function is equivalent to {transfer}, and can be used to
331      * e.g. implement automatic token fees, slashing mechanisms, etc.
332      *
333      * Emits a {Transfer} event.
334      *
335      * Requirements:
336      *
337      * - `sender` cannot be the zero address.
338      * - `recipient` cannot be the zero address.
339      * - `sender` must have a balance of at least `amount`.
340      */
341     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
342         require(sender != address(0), "ERC20: transfer from the zero address");
343         require(recipient != address(0), "ERC20: transfer to the zero address");
344 
345         _beforeTokenTransfer(sender, recipient, amount);
346 
347         uint256 senderBalance = _balances[sender];
348         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
349         _balances[sender] = senderBalance - amount;
350         _balances[recipient] += amount;
351 
352         emit Transfer(sender, recipient, amount);
353     }
354 
355     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
356      * the total supply.
357      *
358      * Emits a {Transfer} event with `from` set to the zero address.
359      *
360      * Requirements:
361      *
362      * - `to` cannot be the zero address.
363      */
364     function _mint(address account, uint256 amount) internal virtual {
365         require(account != address(0), "ERC20: mint to the zero address");
366 
367         _beforeTokenTransfer(address(0), account, amount);
368 
369         _totalSupply += amount;
370         _balances[account] += amount;
371         emit Transfer(address(0), account, amount);
372     }
373 
374     /**
375      * @dev Destroys `amount` tokens from `account`, reducing the
376      * total supply.
377      *
378      * Emits a {Transfer} event with `to` set to the zero address.
379      *
380      * Requirements:
381      *
382      * - `account` cannot be the zero address.
383      * - `account` must have at least `amount` tokens.
384      */
385     function _burn(address account, uint256 amount) internal virtual {
386         require(account != address(0), "ERC20: burn from the zero address");
387 
388         _beforeTokenTransfer(account, address(0), amount);
389 
390         uint256 accountBalance = _balances[account];
391         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
392         _balances[account] = accountBalance - amount;
393         _totalSupply -= amount;
394 
395         emit Transfer(account, address(0), amount);
396     }
397 
398     /**
399      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
400      *
401      * This internal function is equivalent to `approve`, and can be used to
402      * e.g. set automatic allowances for certain subsystems, etc.
403      *
404      * Emits an {Approval} event.
405      *
406      * Requirements:
407      *
408      * - `owner` cannot be the zero address.
409      * - `spender` cannot be the zero address.
410      */
411     function _approve(address owner, address spender, uint256 amount) internal virtual {
412         require(owner != address(0), "ERC20: approve from the zero address");
413         require(spender != address(0), "ERC20: approve to the zero address");
414 
415         _allowances[owner][spender] = amount;
416         emit Approval(owner, spender, amount);
417     }
418 
419     /**
420      * @dev Hook that is called before any transfer of tokens. This includes
421      * minting and burning.
422      *
423      * Calling conditions:
424      *
425      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
426      * will be to transferred to `to`.
427      * - when `from` is zero, `amount` tokens will be minted for `to`.
428      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
429      * - `from` and `to` are never both zero.
430      *
431      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
432      */
433     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
434 }
435 
436 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
437 
438 
439 pragma solidity ^0.8.0;
440 
441 
442 
443 /**
444  * @dev Extension of {ERC20} that allows token holders to destroy both their own
445  * tokens and those that they have an allowance for, in a way that can be
446  * recognized off-chain (via event analysis).
447  */
448 abstract contract ERC20Burnable is Context, ERC20 {
449     /**
450      * @dev Destroys `amount` tokens from the caller.
451      *
452      * See {ERC20-_burn}.
453      */
454     function burn(uint256 amount) public virtual {
455         _burn(_msgSender(), amount);
456     }
457 
458     /**
459      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
460      * allowance.
461      *
462      * See {ERC20-_burn} and {ERC20-allowance}.
463      *
464      * Requirements:
465      *
466      * - the caller must have allowance for ``accounts``'s tokens of at least
467      * `amount`.
468      */
469     function burnFrom(address account, uint256 amount) public virtual {
470         uint256 currentAllowance = allowance(account, _msgSender());
471         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
472         _approve(account, _msgSender(), currentAllowance - amount);
473         _burn(account, amount);
474     }
475 }
476 
477 // File: contracts/BXXToken.sol
478 
479 pragma solidity ^0.8.0;
480 
481 
482 // BXX Token (Baanx) 
483 // Nov 2021
484 
485 contract BXXToken is ERC20Burnable {
486     uint256 constant private INITIAL_AMOUNT_WHOLE_TOKENS = 250e6;
487 
488     constructor (string memory name, string memory symbol) ERC20(name, symbol) {
489         _mint(
490             msg.sender,
491             INITIAL_AMOUNT_WHOLE_TOKENS * (10 ** uint256(decimals()))
492         );
493     }
494 }