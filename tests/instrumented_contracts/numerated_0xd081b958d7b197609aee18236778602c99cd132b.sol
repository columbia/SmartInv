1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.7;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(
62         address sender,
63         address recipient,
64         uint256 amount
65     ) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @dev Interface for the optional metadata functions from the ERC20 standard.
84  *
85  * _Available since v4.1._
86  */
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 
104 /**
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         return msg.data;
121     }
122 }
123 
124 /**
125  * @dev Implementation of the {IERC20} interface.
126  *
127  * This implementation is agnostic to the way tokens are created. This means
128  * that a supply mechanism has to be added in a derived contract using {_mint}.
129  * For a generic mechanism see {ERC20PresetMinterPauser}.
130  *
131  * TIP: For a detailed writeup see our guide
132  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
133  * to implement supply mechanisms].
134  *
135  * We have followed general OpenZeppelin Contracts guidelines: functions revert
136  * instead returning `false` on failure. This behavior is nonetheless
137  * conventional and does not conflict with the expectations of ERC20
138  * applications.
139  *
140  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
141  * This allows applications to reconstruct the allowance for all accounts just
142  * by listening to said events. Other implementations of the EIP may not emit
143  * these events, as it isn't required by the specification.
144  *
145  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
146  * functions have been added to mitigate the well-known issues around setting
147  * allowances. See {IERC20-approve}.
148  */
149 contract ERC20 is Context, IERC20, IERC20Metadata {
150     mapping(address => uint256) private _balances;
151 
152     mapping(address => mapping(address => uint256)) private _allowances;
153 
154     uint256 private _totalSupply;
155 
156     string private _name;
157     string private _symbol;
158 
159     /**
160      * @dev Sets the values for {name} and {symbol}.
161      *
162      * The default value of {decimals} is 18. To select a different value for
163      * {decimals} you should overload it.
164      *
165      * All two of these values are immutable: they can only be set once during
166      * construction.
167      */
168     constructor(string memory name_, string memory symbol_) {
169         _name = name_;
170         _symbol = symbol_;
171     }
172 
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() public view virtual override returns (string memory) {
177         return _name;
178     }
179 
180     /**
181      * @dev Returns the symbol of the token, usually a shorter version of the
182      * name.
183      */
184     function symbol() public view virtual override returns (string memory) {
185         return _symbol;
186     }
187 
188     /**
189      * @dev Returns the number of decimals used to get its user representation.
190      * For example, if `decimals` equals `2`, a balance of `505` tokens should
191      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
192      *
193      * Tokens usually opt for a value of 18, imitating the relationship between
194      * Ether and Wei. This is the value {ERC20} uses, unless this function is
195      * overridden;
196      *
197      * NOTE: This information is only used for _display_ purposes: it in
198      * no way affects any of the arithmetic of the contract, including
199      * {IERC20-balanceOf} and {IERC20-transfer}.
200      */
201     function decimals() public view virtual override returns (uint8) {
202         return 18;
203     }
204 
205     /**
206      * @dev See {IERC20-totalSupply}.
207      */
208     function totalSupply() public view virtual override returns (uint256) {
209         return _totalSupply;
210     }
211 
212     /**
213      * @dev See {IERC20-balanceOf}.
214      */
215     function balanceOf(address account) public view virtual override returns (uint256) {
216         return _balances[account];
217     }
218 
219     /**
220      * @dev See {IERC20-transfer}.
221      *
222      * Requirements:
223      *
224      * - `recipient` cannot be the zero address.
225      * - the caller must have a balance of at least `amount`.
226      */
227     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     /**
233      * @dev See {IERC20-allowance}.
234      */
235     function allowance(address owner, address spender) public view virtual override returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     /**
240      * @dev See {IERC20-approve}.
241      *
242      * Requirements:
243      *
244      * - `spender` cannot be the zero address.
245      */
246     function approve(address spender, uint256 amount) public virtual override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-transferFrom}.
253      *
254      * Emits an {Approval} event indicating the updated allowance. This is not
255      * required by the EIP. See the note at the beginning of {ERC20}.
256      *
257      * Requirements:
258      *
259      * - `sender` and `recipient` cannot be the zero address.
260      * - `sender` must have a balance of at least `amount`.
261      * - the caller must have allowance for ``sender``'s tokens of at least
262      * `amount`.
263      */
264     function transferFrom(
265         address sender,
266         address recipient,
267         uint256 amount
268     ) public virtual override returns (bool) {
269         _transfer(sender, recipient, amount);
270 
271         uint256 currentAllowance = _allowances[sender][_msgSender()];
272         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
273         unchecked {
274             _approve(sender, _msgSender(), currentAllowance - amount);
275         }
276 
277         return true;
278     }
279 
280     /**
281      * @dev Atomically increases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to {approve} that can be used as a mitigation for
284      * problems described in {IERC20-approve}.
285      *
286      * Emits an {Approval} event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
293         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
294         return true;
295     }
296 
297     /**
298      * @dev Atomically decreases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to {approve} that can be used as a mitigation for
301      * problems described in {IERC20-approve}.
302      *
303      * Emits an {Approval} event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      * - `spender` must have allowance for the caller of at least
309      * `subtractedValue`.
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
312         uint256 currentAllowance = _allowances[_msgSender()][spender];
313         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
314         unchecked {
315             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
316         }
317 
318         return true;
319     }
320 
321     /**
322      * @dev Moves `amount` of tokens from `sender` to `recipient`.
323      *
324      * This internal function is equivalent to {transfer}, and can be used to
325      * e.g. implement automatic token fees, slashing mechanisms, etc.
326      *
327      * Emits a {Transfer} event.
328      *
329      * Requirements:
330      *
331      * - `sender` cannot be the zero address.
332      * - `recipient` cannot be the zero address.
333      * - `sender` must have a balance of at least `amount`.
334      */
335     function _transfer(
336         address sender,
337         address recipient,
338         uint256 amount
339     ) internal virtual {
340         require(sender != address(0), "ERC20: transfer from the zero address");
341         require(recipient != address(0), "ERC20: transfer to the zero address");
342 
343         _beforeTokenTransfer(sender, recipient, amount);
344 
345         uint256 senderBalance = _balances[sender];
346         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
347         unchecked {
348             _balances[sender] = senderBalance - amount;
349         }
350         _balances[recipient] += amount;
351 
352         emit Transfer(sender, recipient, amount);
353 
354         _afterTokenTransfer(sender, recipient, amount);
355     }
356 
357     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
358      * the total supply.
359      *
360      * Emits a {Transfer} event with `from` set to the zero address.
361      *
362      * Requirements:
363      *
364      * - `account` cannot be the zero address.
365      */
366     function _mint(address account, uint256 amount) internal virtual {
367         require(account != address(0), "ERC20: mint to the zero address");
368 
369         _beforeTokenTransfer(address(0), account, amount);
370 
371         _totalSupply += amount;
372         _balances[account] += amount;
373         emit Transfer(address(0), account, amount);
374 
375         _afterTokenTransfer(address(0), account, amount);
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
396         unchecked {
397             _balances[account] = accountBalance - amount;
398         }
399         _totalSupply -= amount;
400 
401         emit Transfer(account, address(0), amount);
402 
403         _afterTokenTransfer(account, address(0), amount);
404     }
405 
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
408      *
409      * This internal function is equivalent to `approve`, and can be used to
410      * e.g. set automatic allowances for certain subsystems, etc.
411      *
412      * Emits an {Approval} event.
413      *
414      * Requirements:
415      *
416      * - `owner` cannot be the zero address.
417      * - `spender` cannot be the zero address.
418      */
419     function _approve(
420         address owner,
421         address spender,
422         uint256 amount
423     ) internal virtual {
424         require(owner != address(0), "ERC20: approve from the zero address");
425         require(spender != address(0), "ERC20: approve to the zero address");
426 
427         _allowances[owner][spender] = amount;
428         emit Approval(owner, spender, amount);
429     }
430 
431     /**
432      * @dev Hook that is called before any transfer of tokens. This includes
433      * minting and burning.
434      *
435      * Calling conditions:
436      *
437      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
438      * will be transferred to `to`.
439      * - when `from` is zero, `amount` tokens will be minted for `to`.
440      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
441      * - `from` and `to` are never both zero.
442      *
443      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
444      */
445     function _beforeTokenTransfer(
446         address from,
447         address to,
448         uint256 amount
449     ) internal virtual {}
450 
451     /**
452      * @dev Hook that is called after any transfer of tokens. This includes
453      * minting and burning.
454      *
455      * Calling conditions:
456      *
457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
458      * has been transferred to `to`.
459      * - when `from` is zero, `amount` tokens have been minted for `to`.
460      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
461      * - `from` and `to` are never both zero.
462      *
463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
464      */
465     function _afterTokenTransfer(
466         address from,
467         address to,
468         uint256 amount
469     ) internal virtual {}
470 }
471 
472 contract sMCAP is ERC20 {
473 
474     ERC20 public immutable MCAP;
475 
476     constructor(ERC20 _MCAP) ERC20("sMCAP", "sMCAP") {
477         MCAP = _MCAP;
478     }
479 
480     function decimals() public view override returns (uint8) {
481         return MCAP.decimals();
482     }
483 
484     function transfer(address, uint256) public pure override returns (bool) {
485         revert("Not allowed");
486     }
487 
488     function allowance(address, address) public pure override returns (uint256) {
489         revert("Not allowed");
490     }
491 
492     function approve(address, uint256) public pure override returns (bool) {
493         revert("Not allowed");
494     }
495 
496     function transferFrom(address, address, uint256) public pure override returns (bool) {
497         revert("Not allowed");
498     }
499 
500     // View function to see pending rewards.
501     function pendingRewards(address account) external view returns (uint256) {
502         uint256 totalStaked = MCAP.balanceOf(address(this));
503         uint256 totalShares = totalSupply();
504         return (balanceOf(account) * totalStaked) / totalShares;
505     }
506 
507     // Deposit staking tokens.
508     function deposit(uint256 _amount) external {
509         uint256 totalStaked = MCAP.balanceOf(address(this));
510         uint256 totalShares = totalSupply();
511         uint256 actualAmount = _receiveMCAP(msg.sender, _amount);
512 
513         if (totalShares == 0 || totalStaked == 0) {
514             _mint(msg.sender, actualAmount);
515         } else {
516             uint256 what = (actualAmount * totalShares) / totalStaked;
517             _mint(msg.sender, what);
518         }
519     }
520 
521     // Withdraw staked MCAP + rewards
522     function withdraw(uint256 _share) external {
523         uint256 totalShares = totalSupply();
524         uint256 what = (_share * MCAP.balanceOf(address(this))) / totalShares;
525         _burn(msg.sender, _share);
526         MCAP.transfer(msg.sender, what);
527     }
528 
529     // Receive a token with tax on transfer
530     function _receiveMCAP(address from, uint256 amount) internal returns (uint256) {
531         uint256 balanceBefore = MCAP.balanceOf(address(this));
532         MCAP.transferFrom(from, address(this), amount);
533         return MCAP.balanceOf(address(this)) - balanceBefore;
534     }
535 }