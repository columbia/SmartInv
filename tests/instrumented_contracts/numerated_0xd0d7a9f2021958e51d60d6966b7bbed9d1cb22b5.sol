1 // File: github/OpenZeppelin/openzeppelin-contracts/contracts/utils/Context.sol
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
28 // File: github/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
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
106 // File: github/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
107 
108 pragma solidity ^0.8.0;
109 
110 
111 
112 /**
113  * @dev Implementation of the {IERC20} interface.
114  *
115  * This implementation is agnostic to the way tokens are created. This means
116  * that a supply mechanism has to be added in a derived contract using {_mint}.
117  * For a generic mechanism see {ERC20PresetMinterPauser}.
118  *
119  * TIP: For a detailed writeup see our guide
120  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
121  * to implement supply mechanisms].
122  *
123  * We have followed general OpenZeppelin guidelines: functions revert instead
124  * of returning `false` on failure. This behavior is nonetheless conventional
125  * and does not conflict with the expectations of ERC20 applications.
126  *
127  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
128  * This allows applications to reconstruct the allowance for all accounts just
129  * by listening to said events. Other implementations of the EIP may not emit
130  * these events, as it isn't required by the specification.
131  *
132  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
133  * functions have been added to mitigate the well-known issues around setting
134  * allowances. See {IERC20-approve}.
135  */
136 contract ERC20 is Context, IERC20 {
137     mapping (address => uint256) private _balances;
138 
139     mapping (address => mapping (address => uint256)) private _allowances;
140 
141     uint256 private _totalSupply;
142 
143     string private _name;
144     string private _symbol;
145 
146     /**
147      * @dev Sets the values for {name} and {symbol}.
148      *
149      * The defaut value of {decimals} is 18. To select a different value for
150      * {decimals} you should overload it.
151      *
152      * All three of these values are immutable: they can only be set once during
153      * construction.
154      */
155     constructor (string memory name_, string memory symbol_) {
156         _name = name_;
157         _symbol = symbol_;
158     }
159 
160     /**
161      * @dev Returns the name of the token.
162      */
163     function name() public view virtual returns (string memory) {
164         return _name;
165     }
166 
167     /**
168      * @dev Returns the symbol of the token, usually a shorter version of the
169      * name.
170      */
171     function symbol() public view virtual returns (string memory) {
172         return _symbol;
173     }
174 
175     /**
176      * @dev Returns the number of decimals used to get its user representation.
177      * For example, if `decimals` equals `2`, a balance of `505` tokens should
178      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
179      *
180      * Tokens usually opt for a value of 18, imitating the relationship between
181      * Ether and Wei. This is the value {ERC20} uses, unless this function is
182      * overloaded;
183      *
184      * NOTE: This information is only used for _display_ purposes: it in
185      * no way affects any of the arithmetic of the contract, including
186      * {IERC20-balanceOf} and {IERC20-transfer}.
187      */
188     function decimals() public view virtual returns (uint8) {
189         return 10;
190     }
191 
192     /**
193      * @dev See {IERC20-totalSupply}.
194      */
195     function totalSupply() public view virtual override returns (uint256) {
196         return _totalSupply;
197     }
198 
199     /**
200      * @dev See {IERC20-balanceOf}.
201      */
202     function balanceOf(address account) public view virtual override returns (uint256) {
203         return _balances[account];
204     }
205 
206     /**
207      * @dev See {IERC20-transfer}.
208      *
209      * Requirements:
210      *
211      * - `recipient` cannot be the zero address.
212      * - the caller must have a balance of at least `amount`.
213      */
214     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
215         _transfer(_msgSender(), recipient, amount);
216         return true;
217     }
218 
219     /**
220      * @dev See {IERC20-allowance}.
221      */
222     function allowance(address owner, address spender) public view virtual override returns (uint256) {
223         return _allowances[owner][spender];
224     }
225 
226     /**
227      * @dev See {IERC20-approve}.
228      *
229      * Requirements:
230      *
231      * - `spender` cannot be the zero address.
232      */
233     function approve(address spender, uint256 amount) public virtual override returns (bool) {
234         _approve(_msgSender(), spender, amount);
235         return true;
236     }
237 
238     /**
239      * @dev See {IERC20-transferFrom}.
240      *
241      * Emits an {Approval} event indicating the updated allowance. This is not
242      * required by the EIP. See the note at the beginning of {ERC20}.
243      *
244      * Requirements:
245      *
246      * - `sender` and `recipient` cannot be the zero address.
247      * - `sender` must have a balance of at least `amount`.
248      * - the caller must have allowance for ``sender``'s tokens of at least
249      * `amount`.
250      */
251     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
252         _transfer(sender, recipient, amount);
253 
254         uint256 currentAllowance = _allowances[sender][_msgSender()];
255         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
256         _approve(sender, _msgSender(), currentAllowance - amount);
257 
258         return true;
259     }
260 
261     /**
262      * @dev Atomically increases the allowance granted to `spender` by the caller.
263      *
264      * This is an alternative to {approve} that can be used as a mitigation for
265      * problems described in {IERC20-approve}.
266      *
267      * Emits an {Approval} event indicating the updated allowance.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
274         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
275         return true;
276     }
277 
278     /**
279      * @dev Atomically decreases the allowance granted to `spender` by the caller.
280      *
281      * This is an alternative to {approve} that can be used as a mitigation for
282      * problems described in {IERC20-approve}.
283      *
284      * Emits an {Approval} event indicating the updated allowance.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      * - `spender` must have allowance for the caller of at least
290      * `subtractedValue`.
291      */
292     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
293         uint256 currentAllowance = _allowances[_msgSender()][spender];
294         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
295         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
296 
297         return true;
298     }
299 
300     /**
301      * @dev Moves tokens `amount` from `sender` to `recipient`.
302      *
303      * This is internal function is equivalent to {transfer}, and can be used to
304      * e.g. implement automatic token fees, slashing mechanisms, etc.
305      *
306      * Emits a {Transfer} event.
307      *
308      * Requirements:
309      *
310      * - `sender` cannot be the zero address.
311      * - `recipient` cannot be the zero address.
312      * - `sender` must have a balance of at least `amount`.
313      */
314     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
315         require(sender != address(0), "ERC20: transfer from the zero address");
316         require(recipient != address(0), "ERC20: transfer to the zero address");
317 
318         _beforeTokenTransfer(sender, recipient, amount);
319 
320         uint256 senderBalance = _balances[sender];
321         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
322         _balances[sender] = senderBalance - amount;
323         _balances[recipient] += amount;
324 
325         emit Transfer(sender, recipient, amount);
326     }
327 
328     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
329      * the total supply.
330      *
331      * Emits a {Transfer} event with `from` set to the zero address.
332      *
333      * Requirements:
334      *
335      * - `to` cannot be the zero address.
336      */
337     function _mint(address account, uint256 amount) internal virtual {
338         require(account != address(0), "ERC20: mint to the zero address");
339 
340         _beforeTokenTransfer(address(0), account, amount);
341 
342         _totalSupply += amount;
343         _balances[account] += amount;
344         emit Transfer(address(0), account, amount);
345     }
346 
347     /**
348      * @dev Destroys `amount` tokens from `account`, reducing the
349      * total supply.
350      *
351      * Emits a {Transfer} event with `to` set to the zero address.
352      *
353      * Requirements:
354      *
355      * - `account` cannot be the zero address.
356      * - `account` must have at least `amount` tokens.
357      */
358     function _burn(address account, uint256 amount) internal virtual {
359         require(account != address(0), "ERC20: burn from the zero address");
360 
361         _beforeTokenTransfer(account, address(0), amount);
362 
363         uint256 accountBalance = _balances[account];
364         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
365         _balances[account] = accountBalance - amount;
366         _totalSupply -= amount;
367 
368         emit Transfer(account, address(0), amount);
369     }
370 
371     /**
372      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
373      *
374      * This internal function is equivalent to `approve`, and can be used to
375      * e.g. set automatic allowances for certain subsystems, etc.
376      *
377      * Emits an {Approval} event.
378      *
379      * Requirements:
380      *
381      * - `owner` cannot be the zero address.
382      * - `spender` cannot be the zero address.
383      */
384     function _approve(address owner, address spender, uint256 amount) internal virtual {
385         require(owner != address(0), "ERC20: approve from the zero address");
386         require(spender != address(0), "ERC20: approve to the zero address");
387 
388         _allowances[owner][spender] = amount;
389         emit Approval(owner, spender, amount);
390     }
391 
392     /**
393      * @dev Hook that is called before any transfer of tokens. This includes
394      * minting and burning.
395      *
396      * Calling conditions:
397      *
398      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
399      * will be to transferred to `to`.
400      * - when `from` is zero, `amount` tokens will be minted for `to`.
401      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
402      * - `from` and `to` are never both zero.
403      *
404      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
405      */
406     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
407 }
408 
409 // File: github/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol
410 
411 pragma solidity ^0.8.0;
412 
413 
414 
415 /**
416  * @dev Extension of {ERC20} that allows token holders to destroy both their own
417  * tokens and those that they have an allowance for, in a way that can be
418  * recognized off-chain (via event analysis).
419  */
420 abstract contract ERC20Burnable is Context, ERC20 {
421     /**
422      * @dev Destroys `amount` tokens from the caller.
423      *
424      * See {ERC20-_burn}.
425      */
426     function burn(uint256 amount) public virtual {
427         _burn(_msgSender(), amount);
428     }
429 
430     /**
431      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
432      * allowance.
433      *
434      * See {ERC20-_burn} and {ERC20-allowance}.
435      *
436      * Requirements:
437      *
438      * - the caller must have allowance for ``accounts``'s tokens of at least
439      * `amount`.
440      */
441     function burnFrom(address account, uint256 amount) public virtual {
442         uint256 currentAllowance = allowance(account, _msgSender());
443         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
444         _approve(account, _msgSender(), currentAllowance - amount);
445         _burn(account, amount);
446     }
447 }
448 
449 // File: github/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev {ERC20} token, including:
456  *
457  *  - Preminted initial supply
458  *  - Ability for holders to burn (destroy) their tokens
459  *  - No access control mechanism (for minting/pausing) and hence no governance
460  *
461  * This contract uses {ERC20Burnable} to include burn capabilities - head to
462  * its documentation for details.
463  *
464  * _Available since v3.4._
465  */
466 contract ERC20PresetFixedSupply is ERC20Burnable {
467     /**
468      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
469      *
470      * See {ERC20-constructor}.
471      */
472     constructor(
473         string memory name,
474         string memory symbol,
475         uint256 initialSupply,
476         address owner
477     ) ERC20(name, symbol) {
478         _mint(owner, initialSupply);
479     }
480 }