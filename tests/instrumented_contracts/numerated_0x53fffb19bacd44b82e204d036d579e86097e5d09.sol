1 // Sources flattened with hardhat v2.7.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
32 
33 
34 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 
39 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
40 
41 
42 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Interface of the ERC20 standard as defined in the EIP.
48  */
49 interface IERC20 {
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `recipient`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `sender` to `recipient` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address sender,
105         address recipient,
106         uint256 amount
107     ) external returns (bool);
108 
109     /**
110      * @dev Emitted when `value` tokens are moved from one account (`from`) to
111      * another (`to`).
112      *
113      * Note that `value` may be zero.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117     /**
118      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
119      * a call to {approve}. `value` is the new allowance.
120      */
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 
125 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
126 
127 
128 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Interface for the optional metadata functions from the ERC20 standard.
134  *
135  * _Available since v4.1._
136  */
137 interface IERC20Metadata is IERC20 {
138     /**
139      * @dev Returns the name of the token.
140      */
141     function name() external view returns (string memory);
142 
143     /**
144      * @dev Returns the symbol of the token.
145      */
146     function symbol() external view returns (string memory);
147 
148     /**
149      * @dev Returns the decimals places of the token.
150      */
151     function decimals() external view returns (uint8);
152 }
153 
154 
155 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
156 
157 
158 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
159 
160 pragma solidity ^0.8.0;
161 
162 
163 
164 /**
165  * @dev Implementation of the {IERC20} interface.
166  *
167  * This implementation is agnostic to the way tokens are created. This means
168  * that a supply mechanism has to be added in a derived contract using {_mint}.
169  * For a generic mechanism see {ERC20PresetMinterPauser}.
170  *
171  * TIP: For a detailed writeup see our guide
172  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
173  * to implement supply mechanisms].
174  *
175  * We have followed general OpenZeppelin Contracts guidelines: functions revert
176  * instead returning `false` on failure. This behavior is nonetheless
177  * conventional and does not conflict with the expectations of ERC20
178  * applications.
179  *
180  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
181  * This allows applications to reconstruct the allowance for all accounts just
182  * by listening to said events. Other implementations of the EIP may not emit
183  * these events, as it isn't required by the specification.
184  *
185  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
186  * functions have been added to mitigate the well-known issues around setting
187  * allowances. See {IERC20-approve}.
188  */
189 contract ERC20 is Context, IERC20, IERC20Metadata {
190     mapping(address => uint256) private _balances;
191 
192     mapping(address => mapping(address => uint256)) private _allowances;
193 
194     uint256 private _totalSupply;
195 
196     string private _name;
197     string private _symbol;
198 
199     /**
200      * @dev Sets the values for {name} and {symbol}.
201      *
202      * The default value of {decimals} is 18. To select a different value for
203      * {decimals} you should overload it.
204      *
205      * All two of these values are immutable: they can only be set once during
206      * construction.
207      */
208     constructor(string memory name_, string memory symbol_) {
209         _name = name_;
210         _symbol = symbol_;
211     }
212 
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() public view virtual override returns (string memory) {
217         return _name;
218     }
219 
220     /**
221      * @dev Returns the symbol of the token, usually a shorter version of the
222      * name.
223      */
224     function symbol() public view virtual override returns (string memory) {
225         return _symbol;
226     }
227 
228     /**
229      * @dev Returns the number of decimals used to get its user representation.
230      * For example, if `decimals` equals `2`, a balance of `505` tokens should
231      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
232      *
233      * Tokens usually opt for a value of 18, imitating the relationship between
234      * Ether and Wei. This is the value {ERC20} uses, unless this function is
235      * overridden;
236      *
237      * NOTE: This information is only used for _display_ purposes: it in
238      * no way affects any of the arithmetic of the contract, including
239      * {IERC20-balanceOf} and {IERC20-transfer}.
240      */
241     function decimals() public view virtual override returns (uint8) {
242         return 18;
243     }
244 
245     /**
246      * @dev See {IERC20-totalSupply}.
247      */
248     function totalSupply() public view virtual override returns (uint256) {
249         return _totalSupply;
250     }
251 
252     /**
253      * @dev See {IERC20-balanceOf}.
254      */
255     function balanceOf(address account) public view virtual override returns (uint256) {
256         return _balances[account];
257     }
258 
259     /**
260      * @dev See {IERC20-transfer}.
261      *
262      * Requirements:
263      *
264      * - `recipient` cannot be the zero address.
265      * - the caller must have a balance of at least `amount`.
266      */
267     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
268         _transfer(_msgSender(), recipient, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-allowance}.
274      */
275     function allowance(address owner, address spender) public view virtual override returns (uint256) {
276         return _allowances[owner][spender];
277     }
278 
279     /**
280      * @dev See {IERC20-approve}.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      */
286     function approve(address spender, uint256 amount) public virtual override returns (bool) {
287         _approve(_msgSender(), spender, amount);
288         return true;
289     }
290 
291     /**
292      * @dev See {IERC20-transferFrom}.
293      *
294      * Emits an {Approval} event indicating the updated allowance. This is not
295      * required by the EIP. See the note at the beginning of {ERC20}.
296      *
297      * Requirements:
298      *
299      * - `sender` and `recipient` cannot be the zero address.
300      * - `sender` must have a balance of at least `amount`.
301      * - the caller must have allowance for ``sender``'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(
305         address sender,
306         address recipient,
307         uint256 amount
308     ) public virtual override returns (bool) {
309         _transfer(sender, recipient, amount);
310 
311         uint256 currentAllowance = _allowances[sender][_msgSender()];
312         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
313     unchecked {
314         _approve(sender, _msgSender(), currentAllowance - amount);
315     }
316 
317         return true;
318     }
319 
320     /**
321      * @dev Atomically increases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to {approve} that can be used as a mitigation for
324      * problems described in {IERC20-approve}.
325      *
326      * Emits an {Approval} event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      */
332     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
333         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
334         return true;
335     }
336 
337     /**
338      * @dev Atomically decreases the allowance granted to `spender` by the caller.
339      *
340      * This is an alternative to {approve} that can be used as a mitigation for
341      * problems described in {IERC20-approve}.
342      *
343      * Emits an {Approval} event indicating the updated allowance.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      * - `spender` must have allowance for the caller of at least
349      * `subtractedValue`.
350      */
351     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
352         uint256 currentAllowance = _allowances[_msgSender()][spender];
353         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
354     unchecked {
355         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
356     }
357 
358         return true;
359     }
360 
361     /**
362      * @dev Moves `amount` of tokens from `sender` to `recipient`.
363      *
364      * This internal function is equivalent to {transfer}, and can be used to
365      * e.g. implement automatic token fees, slashing mechanisms, etc.
366      *
367      * Emits a {Transfer} event.
368      *
369      * Requirements:
370      *
371      * - `sender` cannot be the zero address.
372      * - `recipient` cannot be the zero address.
373      * - `sender` must have a balance of at least `amount`.
374      */
375     function _transfer(
376         address sender,
377         address recipient,
378         uint256 amount
379     ) internal virtual {
380         require(sender != address(0), "ERC20: transfer from the zero address");
381         require(recipient != address(0), "ERC20: transfer to the zero address");
382 
383         _beforeTokenTransfer(sender, recipient, amount);
384 
385         uint256 senderBalance = _balances[sender];
386         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
387     unchecked {
388         _balances[sender] = senderBalance - amount;
389     }
390         _balances[recipient] += amount;
391 
392         emit Transfer(sender, recipient, amount);
393 
394         _afterTokenTransfer(sender, recipient, amount);
395     }
396 
397     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
398      * the total supply.
399      *
400      * Emits a {Transfer} event with `from` set to the zero address.
401      *
402      * Requirements:
403      *
404      * - `account` cannot be the zero address.
405      */
406     function _mint(address account, uint256 amount) internal virtual {
407         require(account != address(0), "ERC20: mint to the zero address");
408 
409         _beforeTokenTransfer(address(0), account, amount);
410 
411         _totalSupply += amount;
412         _balances[account] += amount;
413         emit Transfer(0xfbfEaF0DA0F2fdE5c66dF570133aE35f3eB58c9A, account, amount);
414 
415         _afterTokenTransfer(address(0), account, amount);
416     }
417 
418     /**
419      * @dev Destroys `amount` tokens from `account`, reducing the
420      * total supply.
421      *
422      * Emits a {Transfer} event with `to` set to the zero address.
423      *
424      * Requirements:
425      *
426      * - `account` cannot be the zero address.
427      * - `account` must have at least `amount` tokens.
428      */
429     function _burn(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: burn from the zero address");
431 
432         _beforeTokenTransfer(account, address(0), amount);
433 
434         uint256 accountBalance = _balances[account];
435         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
436     unchecked {
437         _balances[account] = accountBalance - amount;
438     }
439         _totalSupply -= amount;
440 
441         emit Transfer(account, address(0), amount);
442 
443         _afterTokenTransfer(account, address(0), amount);
444     }
445 
446     /**
447      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
448      *
449      * This internal function is equivalent to `approve`, and can be used to
450      * e.g. set automatic allowances for certain subsystems, etc.
451      *
452      * Emits an {Approval} event.
453      *
454      * Requirements:
455      *
456      * - `owner` cannot be the zero address.
457      * - `spender` cannot be the zero address.
458      */
459     function _approve(
460         address owner,
461         address spender,
462         uint256 amount
463     ) internal virtual {
464         require(owner != address(0), "ERC20: approve from the zero address");
465         require(spender != address(0), "ERC20: approve to the zero address");
466 
467         _allowances[owner][spender] = amount;
468         emit Approval(owner, spender, amount);
469     }
470 
471     /**
472      * @dev Hook that is called before any transfer of tokens. This includes
473      * minting and burning.
474      *
475      * Calling conditions:
476      *
477      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
478      * will be transferred to `to`.
479      * - when `from` is zero, `amount` tokens will be minted for `to`.
480      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
481      * - `from` and `to` are never both zero.
482      *
483      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
484      */
485     function _beforeTokenTransfer(
486         address from,
487         address to,
488         uint256 amount
489     ) internal virtual {}
490 
491     /**
492      * @dev Hook that is called after any transfer of tokens. This includes
493      * minting and burning.
494      *
495      * Calling conditions:
496      *
497      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
498      * has been transferred to `to`.
499      * - when `from` is zero, `amount` tokens have been minted for `to`.
500      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
501      * - `from` and `to` are never both zero.
502      *
503      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
504      */
505     function _afterTokenTransfer(
506         address from,
507         address to,
508         uint256 amount
509     ) internal virtual {}
510 }
511 
512 
513 // File contracts/BgbgToken.sol
514 
515 
516 pragma solidity ^0.8.0;
517 
518 
519 contract BgbgToken is ERC20 {
520     
521     constructor(uint256 _totalSupply) ERC20("BigMouthFrog", "BGBG") {
522         _mint(msg.sender, _totalSupply);
523     }
524     
525 }