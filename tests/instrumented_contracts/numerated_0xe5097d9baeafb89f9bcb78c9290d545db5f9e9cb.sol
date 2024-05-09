1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/IERC20Metadata.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  *
91  * _Available since v4.1._
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         return msg.data;
131     }
132 }
133 
134 
135 // OpenZeppelin Contracts v4.3.2 (token/ERC20/ERC20.sol)
136 
137 pragma solidity ^0.8.0;
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
150  * We have followed general OpenZeppelin Contracts guidelines: functions revert
151  * instead returning `false` on failure. This behavior is nonetheless
152  * conventional and does not conflict with the expectations of ERC20
153  * applications.
154  *
155  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
156  * This allows applications to reconstruct the allowance for all accounts just
157  * by listening to said events. Other implementations of the EIP may not emit
158  * these events, as it isn't required by the specification.
159  *
160  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
161  * functions have been added to mitigate the well-known issues around setting
162  * allowances. See {IERC20-approve}.
163  */
164 contract ERC20 is Context, IERC20, IERC20Metadata {
165     mapping(address => uint256) private _balances;
166 
167     mapping(address => mapping(address => uint256)) private _allowances;
168 
169     uint256 private _totalSupply;
170 
171     string private _name;
172     string private _symbol;
173 
174     /**
175      * @dev Sets the values for {name} and {symbol}.
176      *
177      * The default value of {decimals} is 18. To select a different value for
178      * {decimals} you should overload it.
179      *
180      * All two of these values are immutable: they can only be set once during
181      * construction.
182      */
183     constructor(string memory name_, string memory symbol_) {
184         _name = name_;
185         _symbol = symbol_;
186     }
187 
188     /**
189      * @dev Returns the name of the token.
190      */
191     function name() public view virtual override returns (string memory) {
192         return _name;
193     }
194 
195     /**
196      * @dev Returns the symbol of the token, usually a shorter version of the
197      * name.
198      */
199     function symbol() public view virtual override returns (string memory) {
200         return _symbol;
201     }
202 
203     /**
204      * @dev Returns the number of decimals used to get its user representation.
205      * For example, if `decimals` equals `2`, a balance of `505` tokens should
206      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
207      *
208      * Tokens usually opt for a value of 18, imitating the relationship between
209      * Ether and Wei. This is the value {ERC20} uses, unless this function is
210      * overridden;
211      *
212      * NOTE: This information is only used for _display_ purposes: it in
213      * no way affects any of the arithmetic of the contract, including
214      * {IERC20-balanceOf} and {IERC20-transfer}.
215      */
216     function decimals() public view virtual override returns (uint8) {
217         return 18;
218     }
219 
220     /**
221      * @dev See {IERC20-totalSupply}.
222      */
223     function totalSupply() public view virtual override returns (uint256) {
224         return _totalSupply;
225     }
226 
227     /**
228      * @dev See {IERC20-balanceOf}.
229      */
230     function balanceOf(address account) public view virtual override returns (uint256) {
231         return _balances[account];
232     }
233 
234     /**
235      * @dev See {IERC20-transfer}.
236      *
237      * Requirements:
238      *
239      * - `recipient` cannot be the zero address.
240      * - the caller must have a balance of at least `amount`.
241      */
242     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See {IERC20-allowance}.
249      */
250     function allowance(address owner, address spender) public view virtual override returns (uint256) {
251         return _allowances[owner][spender];
252     }
253 
254     /**
255      * @dev See {IERC20-approve}.
256      *
257      * Requirements:
258      *
259      * - `spender` cannot be the zero address.
260      */
261     function approve(address spender, uint256 amount) public virtual override returns (bool) {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265 
266     /**
267      * @dev See {IERC20-transferFrom}.
268      *
269      * Emits an {Approval} event indicating the updated allowance. This is not
270      * required by the EIP. See the note at the beginning of {ERC20}.
271      *
272      * Requirements:
273      *
274      * - `sender` and `recipient` cannot be the zero address.
275      * - `sender` must have a balance of at least `amount`.
276      * - the caller must have allowance for ``sender``'s tokens of at least
277      * `amount`.
278      */
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public virtual override returns (bool) {
284         _transfer(sender, recipient, amount);
285 
286         uint256 currentAllowance = _allowances[sender][_msgSender()];
287         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
288         unchecked {
289             _approve(sender, _msgSender(), currentAllowance - amount);
290         }
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
329         unchecked {
330             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
331         }
332 
333         return true;
334     }
335 
336     /**
337      * @dev Moves `amount` of tokens from `sender` to `recipient`.
338      *
339      * This internal function is equivalent to {transfer}, and can be used to
340      * e.g. implement automatic token fees, slashing mechanisms, etc.
341      *
342      * Emits a {Transfer} event.
343      *
344      * Requirements:
345      *
346      * - `sender` cannot be the zero address.
347      * - `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      */
350     function _transfer(
351         address sender,
352         address recipient,
353         uint256 amount
354     ) internal virtual {
355         require(sender != address(0), "ERC20: transfer from the zero address");
356         require(recipient != address(0), "ERC20: transfer to the zero address");
357 
358         _beforeTokenTransfer(sender, recipient, amount);
359 
360         uint256 senderBalance = _balances[sender];
361         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
362         unchecked {
363             _balances[sender] = senderBalance - amount;
364         }
365         _balances[recipient] += amount;
366 
367         emit Transfer(sender, recipient, amount);
368 
369         _afterTokenTransfer(sender, recipient, amount);
370     }
371 
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with `from` set to the zero address.
376      *
377      * Requirements:
378      *
379      * - `account` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _beforeTokenTransfer(address(0), account, amount);
385 
386         _totalSupply += amount;
387         _balances[account] += amount;
388         emit Transfer(address(0), account, amount);
389 
390         _afterTokenTransfer(address(0), account, amount);
391     }
392 
393     /**
394      * @dev Destroys `amount` tokens from `account`, reducing the
395      * total supply.
396      *
397      * Emits a {Transfer} event with `to` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      * - `account` must have at least `amount` tokens.
403      */
404     function _burn(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: burn from the zero address");
406 
407         _beforeTokenTransfer(account, address(0), amount);
408 
409         uint256 accountBalance = _balances[account];
410         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
411         unchecked {
412             _balances[account] = accountBalance - amount;
413         }
414         _totalSupply -= amount;
415 
416         emit Transfer(account, address(0), amount);
417 
418         _afterTokenTransfer(account, address(0), amount);
419     }
420 
421     /**
422      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
423      *
424      * This internal function is equivalent to `approve`, and can be used to
425      * e.g. set automatic allowances for certain subsystems, etc.
426      *
427      * Emits an {Approval} event.
428      *
429      * Requirements:
430      *
431      * - `owner` cannot be the zero address.
432      * - `spender` cannot be the zero address.
433      */
434     function _approve(
435         address owner,
436         address spender,
437         uint256 amount
438     ) internal virtual {
439         require(owner != address(0), "ERC20: approve from the zero address");
440         require(spender != address(0), "ERC20: approve to the zero address");
441 
442         _allowances[owner][spender] = amount;
443         emit Approval(owner, spender, amount);
444     }
445 
446     /**
447      * @dev Hook that is called before any transfer of tokens. This includes
448      * minting and burning.
449      *
450      * Calling conditions:
451      *
452      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
453      * will be transferred to `to`.
454      * - when `from` is zero, `amount` tokens will be minted for `to`.
455      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
456      * - `from` and `to` are never both zero.
457      *
458      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
459      */
460     function _beforeTokenTransfer(
461         address from,
462         address to,
463         uint256 amount
464     ) internal virtual {}
465 
466     /**
467      * @dev Hook that is called after any transfer of tokens. This includes
468      * minting and burning.
469      *
470      * Calling conditions:
471      *
472      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
473      * has been transferred to `to`.
474      * - when `from` is zero, `amount` tokens have been minted for `to`.
475      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
476      * - `from` and `to` are never both zero.
477      *
478      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
479      */
480     function _afterTokenTransfer(
481         address from,
482         address to,
483         uint256 amount
484     ) internal virtual {}
485 }
486 
487 pragma solidity ^0.8.2;
488 
489 contract HummingbotGovernanceToken is ERC20 {
490     constructor() ERC20("Hummingbot Governance Token", "HBOT") {
491         _mint(msg.sender, 1000000000 * 10 ** decimals());
492     }
493 }