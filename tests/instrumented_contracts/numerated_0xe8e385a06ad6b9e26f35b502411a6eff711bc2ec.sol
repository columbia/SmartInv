1 // SPDX-License-Identifier: MIT
2 /* 
3     Bebe the Pepe Protector - Pepe psyop
4     https://twitter.com/BebeEthcoin
5     https://t.me/bebeethcoin
6 */ 
7 
8 pragma solidity ^0.8.20;
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
31 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
32 
33 
34 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
35 
36 pragma solidity ^0.8.20;
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address sender,
97         address recipient,
98         uint256 amount
99     ) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 
117 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
118 
119 
120 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
121 
122 pragma solidity ^0.8.20;
123 
124 /**
125  * @dev Interface for the optional metadata functions from the ERC20 standard.
126  *
127  * _Available since v4.1._
128  */
129 interface IERC20Metadata is IERC20 {
130     /**
131      * @dev Returns the name of the token.
132      */
133     function name() external view returns (string memory);
134 
135     /**
136      * @dev Returns the symbol of the token.
137      */
138     function symbol() external view returns (string memory);
139 
140     /**
141      * @dev Returns the decimals places of the token.
142      */
143     function decimals() external view returns (uint8);
144 }
145 
146 
147 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
148 
149 
150 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
151 
152 pragma solidity ^0.8.20;
153 
154 
155 
156 /**
157  * @dev Implementation of the {IERC20} interface.
158  *
159  * This implementation is agnostic to the way tokens are created. This means
160  * that a supply mechanism has to be added in a derived contract using {_mint}.
161  * For a generic mechanism see {ERC20PresetMinterPauser}.
162  *
163  * TIP: For a detailed writeup see our guide
164  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
165  * to implement supply mechanisms].
166  *
167  * We have followed general OpenZeppelin Contracts guidelines: functions revert
168  * instead returning `false` on failure. This behavior is nonetheless
169  * conventional and does not conflict with the expectations of ERC20
170  * applications.
171  *
172  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
173  * This allows applications to reconstruct the allowance for all accounts just
174  * by listening to said events. Other implementations of the EIP may not emit
175  * these events, as it isn't required by the specification.
176  *
177  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
178  * functions have been added to mitigate the well-known issues around setting
179  * allowances. See {IERC20-approve}.
180  */
181 contract ERC20 is Context, IERC20, IERC20Metadata {
182     mapping(address => uint256) private _balances;
183 
184     mapping(address => mapping(address => uint256)) private _allowances;
185 
186     uint256 private _totalSupply;
187 
188     string private _name;
189     string private _symbol;
190 
191     /**
192      * @dev Sets the values for {name} and {symbol}.
193      *
194      * The default value of {decimals} is 18. To select a different value for
195      * {decimals} you should overload it.
196      *
197      * All two of these values are immutable: they can only be set once during
198      * construction.
199      */
200     constructor(string memory name_, string memory symbol_) {
201         _name = name_;
202         _symbol = symbol_;
203     }
204 
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() public view virtual override returns (string memory) {
209         return _name;
210     }
211 
212     /**
213      * @dev Returns the symbol of the token, usually a shorter version of the
214      * name.
215      */
216     function symbol() public view virtual override returns (string memory) {
217         return _symbol;
218     }
219 
220     /**
221      * @dev Returns the number of decimals used to get its user representation.
222      * For example, if `decimals` equals `2`, a balance of `505` tokens should
223      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
224      *
225      * Tokens usually opt for a value of 18, imitating the relationship between
226      * Ether and Wei. This is the value {ERC20} uses, unless this function is
227      * overridden;
228      *
229      * NOTE: This information is only used for _display_ purposes: it in
230      * no way affects any of the arithmetic of the contract, including
231      * {IERC20-balanceOf} and {IERC20-transfer}.
232      */
233     function decimals() public view virtual override returns (uint8) {
234         return 18;
235     }
236 
237     /**
238      * @dev See {IERC20-totalSupply}.
239      */
240     function totalSupply() public view virtual override returns (uint256) {
241         return _totalSupply;
242     }
243 
244     /**
245      * @dev See {IERC20-balanceOf}.
246      */
247     function balanceOf(address account) public view virtual override returns (uint256) {
248         return _balances[account];
249     }
250 
251     /**
252      * @dev See {IERC20-transfer}.
253      *
254      * Requirements:
255      *
256      * - `recipient` cannot be the zero address.
257      * - the caller must have a balance of at least `amount`.
258      */
259     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
260         _transfer(_msgSender(), recipient, amount);
261         return true;
262     }
263 
264     /**
265      * @dev See {IERC20-allowance}.
266      */
267     function allowance(address owner, address spender) public view virtual override returns (uint256) {
268         return _allowances[owner][spender];
269     }
270 
271     /**
272      * @dev See {IERC20-approve}.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function approve(address spender, uint256 amount) public virtual override returns (bool) {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * Requirements:
290      *
291      * - `sender` and `recipient` cannot be the zero address.
292      * - `sender` must have a balance of at least `amount`.
293      * - the caller must have allowance for ``sender``'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(
297         address sender,
298         address recipient,
299         uint256 amount
300     ) public virtual override returns (bool) {
301         _transfer(sender, recipient, amount);
302 
303         uint256 currentAllowance = _allowances[sender][_msgSender()];
304         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
305         unchecked {
306             _approve(sender, _msgSender(), currentAllowance - amount);
307         }
308 
309         return true;
310     }
311 
312     /**
313      * @dev Atomically increases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
326         return true;
327     }
328 
329     /**
330      * @dev Atomically decreases the allowance granted to `spender` by the caller.
331      *
332      * This is an alternative to {approve} that can be used as a mitigation for
333      * problems described in {IERC20-approve}.
334      *
335      * Emits an {Approval} event indicating the updated allowance.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      * - `spender` must have allowance for the caller of at least
341      * `subtractedValue`.
342      */
343     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
344         uint256 currentAllowance = _allowances[_msgSender()][spender];
345         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
346         unchecked {
347             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
348         }
349 
350         return true;
351     }
352 
353     /**
354      * @dev Moves `amount` of tokens from `sender` to `recipient`.
355      *
356      * This internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `sender` cannot be the zero address.
364      * - `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) internal virtual {
372         require(sender != address(0), "ERC20: transfer from the zero address");
373         require(recipient != address(0), "ERC20: transfer to the zero address");
374 
375         _beforeTokenTransfer(sender, recipient, amount);
376 
377         uint256 senderBalance = _balances[sender];
378         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
379         unchecked {
380             _balances[sender] = senderBalance - amount;
381         }
382         _balances[recipient] += amount;
383 
384         emit Transfer(sender, recipient, amount);
385 
386         _afterTokenTransfer(sender, recipient, amount);
387     }
388 
389     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
390      * the total supply.
391      *
392      * Emits a {Transfer} event with `from` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `account` cannot be the zero address.
397      */
398     function _mint(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: mint to the zero address");
400 
401         _beforeTokenTransfer(address(0), account, amount);
402 
403         _totalSupply += amount;
404         _balances[account] += amount;
405         emit Transfer(address(0), account, amount);
406 
407         _afterTokenTransfer(address(0), account, amount);
408     }
409 
410     /**
411      * @dev Destroys `amount` tokens from `account`, reducing the
412      * total supply.
413      *
414      * Emits a {Transfer} event with `to` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      * - `account` must have at least `amount` tokens.
420      */
421     function _burn(address account, uint256 amount) internal virtual {
422         require(account != address(0), "ERC20: burn from the zero address");
423 
424         _beforeTokenTransfer(account, address(0), amount);
425 
426         uint256 accountBalance = _balances[account];
427         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
428         unchecked {
429             _balances[account] = accountBalance - amount;
430         }
431         _totalSupply -= amount;
432 
433         emit Transfer(account, address(0), amount);
434 
435         _afterTokenTransfer(account, address(0), amount);
436     }
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
440      *
441      * This internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an {Approval} event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         require(owner != address(0), "ERC20: approve from the zero address");
457         require(spender != address(0), "ERC20: approve to the zero address");
458 
459         _allowances[owner][spender] = amount;
460         emit Approval(owner, spender, amount);
461     }
462 
463     /**
464      * @dev Hook that is called before any transfer of tokens. This includes
465      * minting and burning.
466      *
467      * Calling conditions:
468      *
469      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
470      * will be transferred to `to`.
471      * - when `from` is zero, `amount` tokens will be minted for `to`.
472      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
473      * - `from` and `to` are never both zero.
474      *
475      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
476      */
477     function _beforeTokenTransfer(
478         address from,
479         address to,
480         uint256 amount
481     ) internal virtual {}
482 
483     /**
484      * @dev Hook that is called after any transfer of tokens. This includes
485      * minting and burning.
486      *
487      * Calling conditions:
488      *
489      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
490      * has been transferred to `to`.
491      * - when `from` is zero, `amount` tokens have been minted for `to`.
492      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
493      * - `from` and `to` are never both zero.
494      *
495      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
496      */
497     function _afterTokenTransfer(
498         address from,
499         address to,
500         uint256 amount
501     ) internal virtual {}
502 }
503 
504 pragma solidity ^0.8.20;
505 
506 contract BEBE is ERC20 { 
507     constructor() ERC20("Bebe", "BEBE") {
508         _mint(msg.sender, 420690000 * 10 ** decimals());
509     }
510 }