1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
3 
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
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 /**
86  * @dev Interface for the optional metadata functions from the ERC20 standard.
87  *
88  * _Available since v4.1._
89  */
90 interface IERC20Metadata is IERC20 {
91     /**
92      * @dev Returns the name of the token.
93      */
94     function name() external view returns (string memory);
95 
96     /**
97      * @dev Returns the symbol of the token.
98      */
99     function symbol() external view returns (string memory);
100 
101     /**
102      * @dev Returns the decimals places of the token.
103      */
104     function decimals() external view returns (uint8);
105 }
106 
107 
108 /**
109  * @dev Provides information about the current execution context, including the
110  * sender of the transaction and its data. While these are generally available
111  * via msg.sender and msg.data, they should not be accessed in such a direct
112  * manner, since when dealing with meta-transactions the account sending and
113  * paying for execution may not be the actual sender (as far as an application
114  * is concerned).
115  *
116  * This contract is only required for intermediate, library-like contracts.
117  */
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {
120         return msg.sender;
121     }
122 
123     function _msgData() internal view virtual returns (bytes calldata) {
124         return msg.data;
125     }
126 }
127 
128 /**
129  * @dev Implementation of the {IERC20} interface.
130  *
131  * This implementation is agnostic to the way tokens are created. This means
132  * that a supply mechanism has to be added in a derived contract using {_mint}.
133  * For a generic mechanism see {ERC20PresetMinterPauser}.
134  *
135  * TIP: For a detailed writeup see our guide
136  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
137  * to implement supply mechanisms].
138  *
139  * We have followed general OpenZeppelin Contracts guidelines: functions revert
140  * instead returning `false` on failure. This behavior is nonetheless
141  * conventional and does not conflict with the expectations of ERC20
142  * applications.
143  *
144  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
145  * This allows applications to reconstruct the allowance for all accounts just
146  * by listening to said events. Other implementations of the EIP may not emit
147  * these events, as it isn't required by the specification.
148  *
149  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
150  * functions have been added to mitigate the well-known issues around setting
151  * allowances. See {IERC20-approve}.
152  */
153 contract ERC20 is Context, IERC20, IERC20Metadata {
154     mapping(address => uint256) private _balances;
155 
156     mapping(address => mapping(address => uint256)) private _allowances;
157 
158     uint256 private _totalSupply;
159 
160     string private _name;
161     string private _symbol;
162 
163     /**
164      * @dev Sets the values for {name} and {symbol}.
165      *
166      * The default value of {decimals} is 18. To select a different value for
167      * {decimals} you should overload it.
168      *
169      * All two of these values are immutable: they can only be set once during
170      * construction.
171      */
172     constructor(string memory name_, string memory symbol_) {
173         _name = name_;
174         _symbol = symbol_;
175     }
176 
177     /**
178      * @dev Returns the name of the token.
179      */
180     function name() public view virtual override returns (string memory) {
181         return _name;
182     }
183 
184     /**
185      * @dev Returns the symbol of the token, usually a shorter version of the
186      * name.
187      */
188     function symbol() public view virtual override returns (string memory) {
189         return _symbol;
190     }
191 
192     /**
193      * @dev Returns the number of decimals used to get its user representation.
194      * For example, if `decimals` equals `2`, a balance of `505` tokens should
195      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
196      *
197      * Tokens usually opt for a value of 18, imitating the relationship between
198      * Ether and Wei. This is the value {ERC20} uses, unless this function is
199      * overridden;
200      *
201      * NOTE: This information is only used for _display_ purposes: it in
202      * no way affects any of the arithmetic of the contract, including
203      * {IERC20-balanceOf} and {IERC20-transfer}.
204      */
205     function decimals() public view virtual override returns (uint8) {
206         return 18;
207     }
208 
209     /**
210      * @dev See {IERC20-totalSupply}.
211      */
212     function totalSupply() public view virtual override returns (uint256) {
213         return _totalSupply;
214     }
215 
216     /**
217      * @dev See {IERC20-balanceOf}.
218      */
219     function balanceOf(address account) public view virtual override returns (uint256) {
220         return _balances[account];
221     }
222 
223     /**
224      * @dev See {IERC20-transfer}.
225      *
226      * Requirements:
227      *
228      * - `recipient` cannot be the zero address.
229      * - the caller must have a balance of at least `amount`.
230      */
231     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
232         _transfer(_msgSender(), recipient, amount);
233         return true;
234     }
235 
236     /**
237      * @dev See {IERC20-allowance}.
238      */
239     function allowance(address owner, address spender) public view virtual override returns (uint256) {
240         return _allowances[owner][spender];
241     }
242 
243     /**
244      * @dev See {IERC20-approve}.
245      *
246      * Requirements:
247      *
248      * - `spender` cannot be the zero address.
249      */
250     function approve(address spender, uint256 amount) public virtual override returns (bool) {
251         _approve(_msgSender(), spender, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-transferFrom}.
257      *
258      * Emits an {Approval} event indicating the updated allowance. This is not
259      * required by the EIP. See the note at the beginning of {ERC20}.
260      *
261      * Requirements:
262      *
263      * - `sender` and `recipient` cannot be the zero address.
264      * - `sender` must have a balance of at least `amount`.
265      * - the caller must have allowance for ``sender``'s tokens of at least
266      * `amount`.
267      */
268     function transferFrom(
269         address sender,
270         address recipient,
271         uint256 amount
272     ) public virtual override returns (bool) {
273         _transfer(sender, recipient, amount);
274 
275         uint256 currentAllowance = _allowances[sender][_msgSender()];
276         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
277         unchecked {
278             _approve(sender, _msgSender(), currentAllowance - amount);
279         }
280 
281         return true;
282     }
283 
284     /**
285      * @dev Atomically increases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to {approve} that can be used as a mitigation for
288      * problems described in {IERC20-approve}.
289      *
290      * Emits an {Approval} event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
297         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
298         return true;
299     }
300 
301     /**
302      * @dev Atomically decreases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      * - `spender` must have allowance for the caller of at least
313      * `subtractedValue`.
314      */
315     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
316         uint256 currentAllowance = _allowances[_msgSender()][spender];
317         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
318         unchecked {
319             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
320         }
321 
322         return true;
323     }
324 
325     /**
326      * @dev Moves `amount` of tokens from `sender` to `recipient`.
327      *
328      * This internal function is equivalent to {transfer}, and can be used to
329      * e.g. implement automatic token fees, slashing mechanisms, etc.
330      *
331      * Emits a {Transfer} event.
332      *
333      * Requirements:
334      *
335      * - `sender` cannot be the zero address.
336      * - `recipient` cannot be the zero address.
337      * - `sender` must have a balance of at least `amount`.
338      */
339     function _transfer(
340         address sender,
341         address recipient,
342         uint256 amount
343     ) internal virtual {
344         require(sender != address(0), "ERC20: transfer from the zero address");
345         require(recipient != address(0), "ERC20: transfer to the zero address");
346 
347         _beforeTokenTransfer(sender, recipient, amount);
348 
349         uint256 senderBalance = _balances[sender];
350         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
351         unchecked {
352             _balances[sender] = senderBalance - amount;
353         }
354         _balances[recipient] += amount;
355 
356         emit Transfer(sender, recipient, amount);
357 
358         _afterTokenTransfer(sender, recipient, amount);
359     }
360 
361     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
362      * the total supply.
363      *
364      * Emits a {Transfer} event with `from` set to the zero address.
365      *
366      * Requirements:
367      *
368      * - `account` cannot be the zero address.
369      */
370     function _mint(address account, uint256 amount) internal virtual {
371         require(account != address(0), "ERC20: mint to the zero address");
372 
373         _beforeTokenTransfer(address(0), account, amount);
374 
375         _totalSupply += amount;
376         _balances[account] += amount;
377         emit Transfer(address(0), account, amount);
378 
379         _afterTokenTransfer(address(0), account, amount);
380     }
381 
382     /**
383      * @dev Destroys `amount` tokens from `account`, reducing the
384      * total supply.
385      *
386      * Emits a {Transfer} event with `to` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      * - `account` must have at least `amount` tokens.
392      */
393     function _burn(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: burn from the zero address");
395 
396         _beforeTokenTransfer(account, address(0), amount);
397 
398         uint256 accountBalance = _balances[account];
399         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
400         unchecked {
401             _balances[account] = accountBalance - amount;
402         }
403         _totalSupply -= amount;
404 
405         emit Transfer(account, address(0), amount);
406 
407         _afterTokenTransfer(account, address(0), amount);
408     }
409 
410     /**
411      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
412      *
413      * This internal function is equivalent to `approve`, and can be used to
414      * e.g. set automatic allowances for certain subsystems, etc.
415      *
416      * Emits an {Approval} event.
417      *
418      * Requirements:
419      *
420      * - `owner` cannot be the zero address.
421      * - `spender` cannot be the zero address.
422      */
423     function _approve(
424         address owner,
425         address spender,
426         uint256 amount
427     ) internal virtual {
428         require(owner != address(0), "ERC20: approve from the zero address");
429         require(spender != address(0), "ERC20: approve to the zero address");
430 
431         _allowances[owner][spender] = amount;
432         emit Approval(owner, spender, amount);
433     }
434 
435     /**
436      * @dev Hook that is called before any transfer of tokens. This includes
437      * minting and burning.
438      *
439      * Calling conditions:
440      *
441      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
442      * will be transferred to `to`.
443      * - when `from` is zero, `amount` tokens will be minted for `to`.
444      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
445      * - `from` and `to` are never both zero.
446      *
447      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
448      */
449     function _beforeTokenTransfer(
450         address from,
451         address to,
452         uint256 amount
453     ) internal virtual {}
454 
455     /**
456      * @dev Hook that is called after any transfer of tokens. This includes
457      * minting and burning.
458      *
459      * Calling conditions:
460      *
461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
462      * has been transferred to `to`.
463      * - when `from` is zero, `amount` tokens have been minted for `to`.
464      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
465      * - `from` and `to` are never both zero.
466      *
467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
468      */
469     function _afterTokenTransfer(
470         address from,
471         address to,
472         uint256 amount
473     ) internal virtual {}
474 }
475 
476 /**
477  * @title SimpleToken
478  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
479  * Note they can later distribute these tokens as they wish using `transfer` and other
480  * `ERC20` functions.
481  */
482 contract Token is ERC20 {
483 
484     constructor () ERC20("UERII", "UERII") {
485         
486         _mint(msg.sender, 100000000000000000);
487     }
488     
489     function mint() public returns (bool) {
490         _mint( msg.sender, 100000000000000000 );
491         return true;
492     }
493     
494     function decimals() public view virtual override returns (uint8) {
495         return 6;
496     }
497 }