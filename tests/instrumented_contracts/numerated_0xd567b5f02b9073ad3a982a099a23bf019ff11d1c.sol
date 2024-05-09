1 // Sources flattened with hardhat v2.4.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.2.0
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 
115 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
116 
117 pragma solidity ^0.8.0;
118 
119 /*
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138 
139 
140 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.2.0
141 
142 pragma solidity ^0.8.0;
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
171     mapping(address => uint256) private _balances;
172 
173     mapping(address => mapping(address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     /**
181      * @dev Sets the values for {name} and {symbol}.
182      *
183      * The default value of {decimals} is 18. To select a different value for
184      * {decimals} you should overload it.
185      *
186      * All two of these values are immutable: they can only be set once during
187      * construction.
188      */
189     constructor(string memory name_, string memory symbol_) {
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
285     function transferFrom(
286         address sender,
287         address recipient,
288         uint256 amount
289     ) public virtual override returns (bool) {
290         _transfer(sender, recipient, amount);
291 
292         uint256 currentAllowance = _allowances[sender][_msgSender()];
293         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
294         unchecked {
295             _approve(sender, _msgSender(), currentAllowance - amount);
296         }
297 
298         return true;
299     }
300 
301     /**
302      * @dev Atomically increases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      */
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
315         return true;
316     }
317 
318     /**
319      * @dev Atomically decreases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      * - `spender` must have allowance for the caller of at least
330      * `subtractedValue`.
331      */
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         uint256 currentAllowance = _allowances[_msgSender()][spender];
334         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
335         unchecked {
336             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
337         }
338 
339         return true;
340     }
341 
342     /**
343      * @dev Moves `amount` of tokens from `sender` to `recipient`.
344      *
345      * This internal function is equivalent to {transfer}, and can be used to
346      * e.g. implement automatic token fees, slashing mechanisms, etc.
347      *
348      * Emits a {Transfer} event.
349      *
350      * Requirements:
351      *
352      * - `sender` cannot be the zero address.
353      * - `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      */
356     function _transfer(
357         address sender,
358         address recipient,
359         uint256 amount
360     ) internal virtual {
361         require(sender != address(0), "ERC20: transfer from the zero address");
362         require(recipient != address(0), "ERC20: transfer to the zero address");
363 
364         _beforeTokenTransfer(sender, recipient, amount);
365 
366         uint256 senderBalance = _balances[sender];
367         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
368         unchecked {
369             _balances[sender] = senderBalance - amount;
370         }
371         _balances[recipient] += amount;
372 
373         emit Transfer(sender, recipient, amount);
374 
375         _afterTokenTransfer(sender, recipient, amount);
376     }
377 
378     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
379      * the total supply.
380      *
381      * Emits a {Transfer} event with `from` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      */
387     function _mint(address account, uint256 amount) internal virtual {
388         require(account != address(0), "ERC20: mint to the zero address");
389 
390         _beforeTokenTransfer(address(0), account, amount);
391 
392         _totalSupply += amount;
393         _balances[account] += amount;
394         emit Transfer(address(0), account, amount);
395 
396         _afterTokenTransfer(address(0), account, amount);
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
417         unchecked {
418             _balances[account] = accountBalance - amount;
419         }
420         _totalSupply -= amount;
421 
422         emit Transfer(account, address(0), amount);
423 
424         _afterTokenTransfer(account, address(0), amount);
425     }
426 
427     /**
428      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
429      *
430      * This internal function is equivalent to `approve`, and can be used to
431      * e.g. set automatic allowances for certain subsystems, etc.
432      *
433      * Emits an {Approval} event.
434      *
435      * Requirements:
436      *
437      * - `owner` cannot be the zero address.
438      * - `spender` cannot be the zero address.
439      */
440     function _approve(
441         address owner,
442         address spender,
443         uint256 amount
444     ) internal virtual {
445         require(owner != address(0), "ERC20: approve from the zero address");
446         require(spender != address(0), "ERC20: approve to the zero address");
447 
448         _allowances[owner][spender] = amount;
449         emit Approval(owner, spender, amount);
450     }
451 
452     /**
453      * @dev Hook that is called before any transfer of tokens. This includes
454      * minting and burning.
455      *
456      * Calling conditions:
457      *
458      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
459      * will be transferred to `to`.
460      * - when `from` is zero, `amount` tokens will be minted for `to`.
461      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
462      * - `from` and `to` are never both zero.
463      *
464      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
465      */
466     function _beforeTokenTransfer(
467         address from,
468         address to,
469         uint256 amount
470     ) internal virtual {}
471 
472     /**
473      * @dev Hook that is called after any transfer of tokens. This includes
474      * minting and burning.
475      *
476      * Calling conditions:
477      *
478      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
479      * has been transferred to `to`.
480      * - when `from` is zero, `amount` tokens have been minted for `to`.
481      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
482      * - `from` and `to` are never both zero.
483      *
484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
485      */
486     function _afterTokenTransfer(
487         address from,
488         address to,
489         uint256 amount
490     ) internal virtual {}
491 }
492 
493 
494 // File contracts/GameCoin.sol
495 
496 // contracts/GameCoin.sol
497 pragma solidity ^0.8.0;
498 
499 //import "hardhat/console.sol";
500 contract GameCoin is ERC20 {
501     constructor() ERC20("Game Coin", "GAME") {
502         _mint(msg.sender, 100_000_000e5);
503     }
504 
505     function decimals() public view virtual override returns (uint8) {
506         return 5;
507     }
508 }