1 /*
2 Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
3 .*/
4 
5 //SPDX-License-Identifier: UNLICENSED
6 pragma solidity ^0.8.4;
7 
8 
9 
10 
11 
12 
13 
14 
15 
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(
74         address sender,
75         address recipient,
76         uint256 amount
77     ) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 
95 
96 
97 
98 
99 
100 /**
101  * @dev Interface for the optional metadata functions from the ERC20 standard.
102  *
103  * _Available since v4.1._
104  */
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 
123 
124 
125 
126 /*
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 
147 /**
148  * @dev Implementation of the {IERC20} interface.
149  *
150  * This implementation is agnostic to the way tokens are created. This means
151  * that a supply mechanism has to be added in a derived contract using {_mint}.
152  * For a generic mechanism see {ERC20PresetMinterPauser}.
153  *
154  * TIP: For a detailed writeup see our guide
155  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
156  * to implement supply mechanisms].
157  *
158  * We have followed general OpenZeppelin guidelines: functions revert instead
159  * of returning `false` on failure. This behavior is nonetheless conventional
160  * and does not conflict with the expectations of ERC20 applications.
161  *
162  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
163  * This allows applications to reconstruct the allowance for all accounts just
164  * by listening to said events. Other implementations of the EIP may not emit
165  * these events, as it isn't required by the specification.
166  *
167  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
168  * functions have been added to mitigate the well-known issues around setting
169  * allowances. See {IERC20-approve}.
170  */
171 contract ERC20 is Context, IERC20, IERC20Metadata {
172     mapping(address => uint256) private _balances;
173 
174     mapping(address => mapping(address => uint256)) private _allowances;
175 
176     uint256 private _totalSupply;
177 
178     string private _name;
179     string private _symbol;
180 
181     /**
182      * @dev Sets the values for {name} and {symbol}.
183      *
184      * The default value of {decimals} is 18. To select a different value for
185      * {decimals} you should overload it.
186      *
187      * All two of these values are immutable: they can only be set once during
188      * construction.
189      */
190     constructor(string memory name_, string memory symbol_) {
191         _name = name_;
192         _symbol = symbol_;
193     }
194 
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() public view virtual override returns (string memory) {
199         return _name;
200     }
201 
202     /**
203      * @dev Returns the symbol of the token, usually a shorter version of the
204      * name.
205      */
206     function symbol() public view virtual override returns (string memory) {
207         return _symbol;
208     }
209 
210     /**
211      * @dev Returns the number of decimals used to get its user representation.
212      * For example, if `decimals` equals `2`, a balance of `505` tokens should
213      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
214      *
215      * Tokens usually opt for a value of 18, imitating the relationship between
216      * Ether and Wei. This is the value {ERC20} uses, unless this function is
217      * overridden;
218      *
219      * NOTE: This information is only used for _display_ purposes: it in
220      * no way affects any of the arithmetic of the contract, including
221      * {IERC20-balanceOf} and {IERC20-transfer}.
222      */
223     function decimals() public view virtual override returns (uint8) {
224         return 18;
225     }
226 
227     /**
228      * @dev See {IERC20-totalSupply}.
229      */
230     function totalSupply() public view virtual override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235      * @dev See {IERC20-balanceOf}.
236      */
237     function balanceOf(address account) public view virtual override returns (uint256) {
238         return _balances[account];
239     }
240 
241     /**
242      * @dev See {IERC20-transfer}.
243      *
244      * Requirements:
245      *
246      * - `recipient` cannot be the zero address.
247      * - the caller must have a balance of at least `amount`.
248      */
249     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-allowance}.
256      */
257     function allowance(address owner, address spender) public view virtual override returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     /**
262      * @dev See {IERC20-approve}.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function approve(address spender, uint256 amount) public virtual override returns (bool) {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-transferFrom}.
275      *
276      * Emits an {Approval} event indicating the updated allowance. This is not
277      * required by the EIP. See the note at the beginning of {ERC20}.
278      *
279      * Requirements:
280      *
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `amount`.
283      * - the caller must have allowance for ``sender``'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) public virtual override returns (bool) {
291         _transfer(sender, recipient, amount);
292 
293         uint256 currentAllowance = _allowances[sender][_msgSender()];
294         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
295         unchecked {
296             _approve(sender, _msgSender(), currentAllowance - amount);
297         }
298 
299         return true;
300     }
301 
302     /**
303      * @dev Atomically increases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
315         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
316         return true;
317     }
318 
319     /**
320      * @dev Atomically decreases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      * - `spender` must have allowance for the caller of at least
331      * `subtractedValue`.
332      */
333     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
334         uint256 currentAllowance = _allowances[_msgSender()][spender];
335         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
336         unchecked {
337             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
338         }
339 
340         return true;
341     }
342 
343     /**
344      * @dev Moves `amount` of tokens from `sender` to `recipient`.
345      *
346      * This internal function is equivalent to {transfer}, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a {Transfer} event.
350      *
351      * Requirements:
352      *
353      * - `sender` cannot be the zero address.
354      * - `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      */
357     function _transfer(
358         address sender,
359         address recipient,
360         uint256 amount
361     ) internal virtual {
362         require(sender != address(0), "ERC20: transfer from the zero address");
363         require(recipient != address(0), "ERC20: transfer to the zero address");
364 
365         _beforeTokenTransfer(sender, recipient, amount);
366 
367         uint256 senderBalance = _balances[sender];
368         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
369         unchecked {
370             _balances[sender] = senderBalance - amount;
371         }
372         _balances[recipient] += amount;
373 
374         emit Transfer(sender, recipient, amount);
375 
376         _afterTokenTransfer(sender, recipient, amount);
377     }
378 
379     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
380      * the total supply.
381      *
382      * Emits a {Transfer} event with `from` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `account` cannot be the zero address.
387      */
388     function _mint(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: mint to the zero address");
390 
391         _beforeTokenTransfer(address(0), account, amount);
392 
393         _totalSupply += amount;
394         _balances[account] += amount;
395         emit Transfer(address(0), account, amount);
396 
397         _afterTokenTransfer(address(0), account, amount);
398     }
399 
400     /**
401      * @dev Destroys `amount` tokens from `account`, reducing the
402      * total supply.
403      *
404      * Emits a {Transfer} event with `to` set to the zero address.
405      *
406      * Requirements:
407      *
408      * - `account` cannot be the zero address.
409      * - `account` must have at least `amount` tokens.
410      */
411     function _burn(address account, uint256 amount) internal virtual {
412         require(account != address(0), "ERC20: burn from the zero address");
413 
414         _beforeTokenTransfer(account, address(0), amount);
415 
416         uint256 accountBalance = _balances[account];
417         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
418         unchecked {
419             _balances[account] = accountBalance - amount;
420         }
421         _totalSupply -= amount;
422 
423         emit Transfer(account, address(0), amount);
424 
425         _afterTokenTransfer(account, address(0), amount);
426     }
427 
428     /**
429      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
430      *
431      * This internal function is equivalent to `approve`, and can be used to
432      * e.g. set automatic allowances for certain subsystems, etc.
433      *
434      * Emits an {Approval} event.
435      *
436      * Requirements:
437      *
438      * - `owner` cannot be the zero address.
439      * - `spender` cannot be the zero address.
440      */
441     function _approve(
442         address owner,
443         address spender,
444         uint256 amount
445     ) internal virtual {
446         require(owner != address(0), "ERC20: approve from the zero address");
447         require(spender != address(0), "ERC20: approve to the zero address");
448 
449         _allowances[owner][spender] = amount;
450         emit Approval(owner, spender, amount);
451     }
452 
453     /**
454      * @dev Hook that is called before any transfer of tokens. This includes
455      * minting and burning.
456      *
457      * Calling conditions:
458      *
459      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
460      * will be transferred to `to`.
461      * - when `from` is zero, `amount` tokens will be minted for `to`.
462      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
463      * - `from` and `to` are never both zero.
464      *
465      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
466      */
467     function _beforeTokenTransfer(
468         address from,
469         address to,
470         uint256 amount
471     ) internal virtual {}
472 
473     /**
474      * @dev Hook that is called after any transfer of tokens. This includes
475      * minting and burning.
476      *
477      * Calling conditions:
478      *
479      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
480      * has been transferred to `to`.
481      * - when `from` is zero, `amount` tokens have been minted for `to`.
482      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
483      * - `from` and `to` are never both zero.
484      *
485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
486      */
487     function _afterTokenTransfer(
488         address from,
489         address to,
490         uint256 amount
491     ) internal virtual {}
492 }
493 
494 
495 contract RushCoin is ERC20 {
496    constructor(uint256 initialSupply,string memory tokenName,string memory tokenSymbol) ERC20(tokenName,tokenSymbol) {
497         _mint(msg.sender, initialSupply);
498     }
499 }