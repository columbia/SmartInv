1 // File: @openzeppelin/contracts/utils/Context.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity ^0.8.1;
5 
6 // 
7 // 'Billion' token contract
8 //
9 // Symbol      : BLL
10 // Name        : Billion
11 // Total supply: 1000000000
12 // Decimals    : 18
13 //
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
37 pragma solidity ^0.8.1;
38 
39 /**
40  * @dev Interface of the ERC20 standard as defined in the EIP.
41  */
42 interface IERC20 {
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `recipient`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
115 pragma solidity ^0.8.1;
116 
117 
118 /**
119  * @dev Interface for the optional metadata functions from the ERC20 standard.
120  *
121  * _Available since v4.1._
122  */
123 interface IERC20Metadata is IERC20 {
124     /**
125      * @dev Returns the name of the token.
126      */
127     function name() external view returns (string memory);
128 
129     /**
130      * @dev Returns the symbol of the token.
131      */
132     function symbol() external view returns (string memory);
133 
134     /**
135      * @dev Returns the decimals places of the token.
136      */
137     function decimals() external view returns (uint8);
138 }
139 
140 
141 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
142 pragma solidity ^0.8.1;
143 
144 /**
145  * @dev Implementation of the {IERC20} interface.
146  *
147  * This implementation is agnostic to the way tokens are created. This means
148  * that a supply mechanism has to be added in a derived contract using {_mint}.
149  * For a generic mechanism see {ERC20PresetMinterPauser}.
150  *
151  * TIP: For a detailed writeup see our guide
152  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
153  * to implement supply mechanisms].
154  *
155  * We have followed general OpenZeppelin guidelines: functions revert instead
156  * of returning `false` on failure. This behavior is nonetheless conventional
157  * and does not conflict with the expectations of ERC20 applications.
158  *
159  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
160  * This allows applications to reconstruct the allowance for all accounts just
161  * by listening to said events. Other implementations of the EIP may not emit
162  * these events, as it isn't required by the specification.
163  *
164  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
165  * functions have been added to mitigate the well-known issues around setting
166  * allowances. See {IERC20-approve}.
167  */
168 contract ERC20 is Context, IERC20, IERC20Metadata {
169     mapping (address => uint256) private _balances;
170 
171     mapping (address => mapping (address => uint256)) private _allowances;
172 
173     uint256 private _totalSupply;
174 
175     string private _name;
176     string private _symbol;
177 
178     /**
179      * @dev Sets the values for {name} and {symbol}.
180      *
181      * The defaut value of {decimals} is 18. To select a different value for
182      * {decimals} you should overload it.
183      *
184      * All two of these values are immutable: they can only be set once during
185      * construction.
186      */
187     constructor (string memory name_, string memory symbol_) {
188         _name = name_;
189         _symbol = symbol_;
190     }
191 
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() public view virtual override returns (string memory) {
196         return _name;
197     }
198 
199     /**
200      * @dev Returns the symbol of the token, usually a shorter version of the
201      * name.
202      */
203     function symbol() public view virtual override returns (string memory) {
204         return _symbol;
205     }
206 
207     /**
208      * @dev Returns the number of decimals used to get its user representation.
209      * For example, if `decimals` equals `2`, a balance of `505` tokens should
210      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
211      *
212      * Tokens usually opt for a value of 18, imitating the relationship between
213      * Ether and Wei. This is the value {ERC20} uses, unless this function is
214      * overridden;
215      *
216      * NOTE: This information is only used for _display_ purposes: it in
217      * no way affects any of the arithmetic of the contract, including
218      * {IERC20-balanceOf} and {IERC20-transfer}.
219      */
220     function decimals() public view virtual override returns (uint8) {
221         return 18;
222     }
223 
224     /**
225      * @dev See {IERC20-totalSupply}.
226      */
227     function totalSupply() public view virtual override returns (uint256) {
228         return _totalSupply;
229     }
230 
231     /**
232      * @dev See {IERC20-balanceOf}.
233      */
234     function balanceOf(address account) public view virtual override returns (uint256) {
235         return _balances[account];
236     }
237 
238      /**
239      * @dev Destroys `amount` tokens from `account`, reducing the
240      * total supply.
241      *
242      * Emits a {Transfer} event with `to` set to the zero address.
243      *
244      * Requirements:
245      *
246      * - `account` cannot be the zero address.
247      * - `account` must have at least `amount` tokens.
248      */
249     function _burn(address account, uint256 amount) internal virtual {
250         require(account != address(0), "ERC20: burn from the zero address");
251 
252         _beforeTokenTransfer(account, address(0), amount);
253 
254         uint256 accountBalance = _balances[account];
255         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
256         _balances[account] = accountBalance - amount;
257         _totalSupply -= amount;
258 
259         emit Transfer(account, address(0), amount);
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
307     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
308         _transfer(sender, recipient, amount);
309 
310         uint256 currentAllowance = _allowances[sender][_msgSender()];
311         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
312         _approve(sender, _msgSender(), currentAllowance - amount);
313 
314         return true;
315     }
316 
317     /**
318      * @dev Atomically increases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
330         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
331         return true;
332     }
333 
334     /**
335      * @dev Atomically decreases the allowance granted to `spender` by the caller.
336      *
337      * This is an alternative to {approve} that can be used as a mitigation for
338      * problems described in {IERC20-approve}.
339      *
340      * Emits an {Approval} event indicating the updated allowance.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      * - `spender` must have allowance for the caller of at least
346      * `subtractedValue`.
347      */
348     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
349         uint256 currentAllowance = _allowances[_msgSender()][spender];
350         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
351         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
352 
353         return true;
354     }
355 
356     /**
357      * @dev Moves tokens `amount` from `sender` to `recipient`.
358      *
359      * This is internal function is equivalent to {transfer}, and can be used to
360      * e.g. implement automatic token fees, slashing mechanisms, etc.
361      *
362      * Emits a {Transfer} event.
363      *
364      * Requirements:
365      *
366      * - `sender` cannot be the zero address.
367      * - `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      */
370     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
371         require(sender != address(0), "ERC20: transfer from the zero address");
372         require(recipient != address(0), "ERC20: transfer to the zero address");
373 
374         _beforeTokenTransfer(sender, recipient, amount);
375 
376         uint256 senderBalance = _balances[sender];
377         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
378         _balances[sender] = senderBalance - amount;
379         _balances[recipient] += amount;
380 
381         emit Transfer(sender, recipient, amount);
382     }
383 
384     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
385      * the total supply.
386      *
387      * Emits a {Transfer} event with `from` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `to` cannot be the zero address.
392      */
393     function _mint(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: mint to the zero address");
395 
396         _beforeTokenTransfer(address(0), account, amount);
397 
398         _totalSupply += amount;
399         _balances[account] += amount;
400         emit Transfer(address(0), account, amount);
401     }
402 
403 
404     /**
405      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
406      *
407      * This internal function is equivalent to `approve`, and can be used to
408      * e.g. set automatic allowances for certain subsystems, etc.
409      *
410      * Emits an {Approval} event.
411      *
412      * Requirements:
413      *
414      * - `owner` cannot be the zero address.
415      * - `spender` cannot be the zero address.
416      */
417     function _approve(address owner, address spender, uint256 amount) internal virtual {
418         require(owner != address(0), "ERC20: approve from the zero address");
419         require(spender != address(0), "ERC20: approve to the zero address");
420 
421         _allowances[owner][spender] = amount;
422         emit Approval(owner, spender, amount);
423     }
424 
425     /**
426      * @dev Hook that is called before any transfer of tokens. This includes
427      * minting and burning.
428      *
429      * Calling conditions:
430      *
431      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
432      * will be to transferred to `to`.
433      * - when `from` is zero, `amount` tokens will be minted for `to`.
434      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
435      * - `from` and `to` are never both zero.
436      *
437      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
438      */
439     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
443 pragma solidity ^0.8.1;
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
481 // File: @openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol
482 
483 pragma solidity ^0.8.1;
484 
485 
486 /**
487  * @dev {ERC20} token, including:
488  *
489  *  - Preminted initial supply
490  *  - Ability for holders to burn (destroy) their tokens
491  *  - No access control mechanism (for minting/pausing) and hence no governance
492  *
493  * This contract uses {ERC20Burnable} to include burn capabilities - head to
494  * its documentation for details.
495  *
496  * _Available since v3.4._
497  */
498 contract ERC20PresetFixedSupply is ERC20Burnable {
499     /**
500      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
501      *
502      * See {ERC20-constructor}.
503      */
504     constructor(
505         string memory name,
506         string memory symbol,
507         uint256 initialSupply,
508         address owner
509     ) ERC20(name, symbol) {
510         _mint(owner, initialSupply);
511     }
512 }
513 
514 // Billion token
515 pragma solidity ^0.8.1;
516 
517 contract Billion is ERC20PresetFixedSupply {
518     constructor() ERC20PresetFixedSupply("Billion", "BLL", 1000000000 * 10 ** 18, msg.sender) {
519     }
520 }