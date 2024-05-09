1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-23
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-04-19
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Emitted when `value` tokens are moved from one account (`from`) to
18      * another (`to`).
19      *
20      * Note that `value` may be zero.
21      */
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     /**
25      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
26      * a call to {approve}. `value` is the new allowance.
27      */
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `to`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address to, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `from` to `to` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address from, address to, uint256 amount) external returns (bool);
84 }
85 
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev Provides information about the current execution context, including the
113  * sender of the transaction and its data. While these are generally available
114  * via msg.sender and msg.data, they should not be accessed in such a direct
115  * manner, since when dealing with meta-transactions the account sending and
116  * paying for execution may not be the actual sender (as far as an application
117  * is concerned).
118  *
119  * This contract is only required for intermediate, library-like contracts.
120  */
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address) {
123         return msg.sender;
124     }
125 
126     function _msgData() internal view virtual returns (bytes calldata) {
127         return msg.data;
128     }
129 }
130 
131 /**
132  * @dev Implementation of the {IERC20} interface.
133  *
134  * This implementation is agnostic to the way tokens are created. This means
135  * that a supply mechanism has to be added in a derived contract using {_mint}.
136  * For a generic mechanism see {ERC20PresetMinterPauser}.
137  *
138  * TIP: For a detailed writeup see our guide
139  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
140  * to implement supply mechanisms].
141  *
142  * The default value of {decimals} is 18. To change this, you should override
143  * this function so it returns a different value.
144  *
145  * We have followed general OpenZeppelin Contracts guidelines: functions revert
146  * instead returning `false` on failure. This behavior is nonetheless
147  * conventional and does not conflict with the expectations of ERC20
148  * applications.
149  *
150  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
151  * This allows applications to reconstruct the allowance for all accounts just
152  * by listening to said events. Other implementations of the EIP may not emit
153  * these events, as it isn't required by the specification.
154  *
155  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
156  * functions have been added to mitigate the well-known issues around setting
157  * allowances. See {IERC20-approve}.
158  */
159 contract ERC20 is Context, IERC20, IERC20Metadata {
160     mapping(address => uint256) private _balances;
161 
162     mapping(address => mapping(address => uint256)) private _allowances;
163 
164     uint256 private _totalSupply;
165 
166     string private _name;
167     string private _symbol;
168 
169     /**
170      * @dev Sets the values for {name} and {symbol}.
171      *
172      * All two of these values are immutable: they can only be set once during
173      * construction.
174      */
175     constructor(string memory name_, string memory symbol_) {
176         _name = name_;
177         _symbol = symbol_;
178     }
179 
180     /**
181      * @dev Returns the name of the token.
182      */
183     function name() public view virtual override returns (string memory) {
184         return _name;
185     }
186 
187     /**
188      * @dev Returns the symbol of the token, usually a shorter version of the
189      * name.
190      */
191     function symbol() public view virtual override returns (string memory) {
192         return _symbol;
193     }
194 
195     /**
196      * @dev Returns the number of decimals used to get its user representation.
197      * For example, if `decimals` equals `2`, a balance of `505` tokens should
198      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
199      *
200      * Tokens usually opt for a value of 18, imitating the relationship between
201      * Ether and Wei. This is the default value returned by this function, unless
202      * it's overridden.
203      *
204      * NOTE: This information is only used for _display_ purposes: it in
205      * no way affects any of the arithmetic of the contract, including
206      * {IERC20-balanceOf} and {IERC20-transfer}.
207      */
208     function decimals() public view virtual override returns (uint8) {
209         return 18;
210     }
211 
212     /**
213      * @dev See {IERC20-totalSupply}.
214      */
215     function totalSupply() public view virtual override returns (uint256) {
216         return _totalSupply;
217     }
218 
219     /**
220      * @dev See {IERC20-balanceOf}.
221      */
222     function balanceOf(address account) public view virtual override returns (uint256) {
223         return _balances[account];
224     }
225 
226     /**
227      * @dev See {IERC20-transfer}.
228      *
229      * Requirements:
230      *
231      * - `to` cannot be the zero address.
232      * - the caller must have a balance of at least `amount`.
233      */
234     function transfer(address to, uint256 amount) public virtual override returns (bool) {
235         address owner = _msgSender();
236         _transfer(owner, to, amount);
237         return true;
238     }
239 
240     /**
241      * @dev See {IERC20-allowance}.
242      */
243     function allowance(address owner, address spender) public view virtual override returns (uint256) {
244         return _allowances[owner][spender];
245     }
246 
247     /**
248      * @dev See {IERC20-approve}.
249      *
250      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
251      * `transferFrom`. This is semantically equivalent to an infinite approval.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      */
257     function approve(address spender, uint256 amount) public virtual override returns (bool) {
258         address owner = _msgSender();
259         _approve(owner, spender, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-transferFrom}.
265      *
266      * Emits an {Approval} event indicating the updated allowance. This is not
267      * required by the EIP. See the note at the beginning of {ERC20}.
268      *
269      * NOTE: Does not update the allowance if the current allowance
270      * is the maximum `uint256`.
271      *
272      * Requirements:
273      *
274      * - `from` and `to` cannot be the zero address.
275      * - `from` must have a balance of at least `amount`.
276      * - the caller must have allowance for ``from``'s tokens of at least
277      * `amount`.
278      */
279     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
280         address spender = _msgSender();
281         _spendAllowance(from, spender, amount);
282         _transfer(from, to, amount);
283         return true;
284     }
285 
286     /**
287      * @dev Atomically increases the allowance granted to `spender` by the caller.
288      *
289      * This is an alternative to {approve} that can be used as a mitigation for
290      * problems described in {IERC20-approve}.
291      *
292      * Emits an {Approval} event indicating the updated allowance.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      */
298     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
299         address owner = _msgSender();
300         _approve(owner, spender, allowance(owner, spender) + addedValue);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically decreases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      * - `spender` must have allowance for the caller of at least
316      * `subtractedValue`.
317      */
318     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
319         address owner = _msgSender();
320         uint256 currentAllowance = allowance(owner, spender);
321         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
322         unchecked {
323             _approve(owner, spender, currentAllowance - subtractedValue);
324         }
325 
326         return true;
327     }
328 
329     /**
330      * @dev Moves `amount` of tokens from `from` to `to`.
331      *
332      * This internal function is equivalent to {transfer}, and can be used to
333      * e.g. implement automatic token fees, slashing mechanisms, etc.
334      *
335      * Emits a {Transfer} event.
336      *
337      * Requirements:
338      *
339      * - `from` cannot be the zero address.
340      * - `to` cannot be the zero address.
341      * - `from` must have a balance of at least `amount`.
342      */
343     function _transfer(address from, address to, uint256 amount) internal virtual {
344         require(from != address(0), "ERC20: transfer from the zero address");
345         require(to != address(0), "ERC20: transfer to the zero address");
346 
347         _beforeTokenTransfer(from, to, amount);
348 
349         uint256 fromBalance = _balances[from];
350         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
351         unchecked {
352             _balances[from] = fromBalance - amount;
353             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
354             // decrementing then incrementing.
355             _balances[to] += amount;
356         }
357 
358         emit Transfer(from, to, amount);
359 
360         _afterTokenTransfer(from, to, amount);
361     }
362 
363     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
364      * the total supply.
365      *
366      * Emits a {Transfer} event with `from` set to the zero address.
367      *
368      * Requirements:
369      *
370      * - `account` cannot be the zero address.
371      */
372     function _mint(address account, uint256 amount) internal virtual {
373         require(account != address(0), "ERC20: mint to the zero address");
374 
375         _beforeTokenTransfer(address(0), account, amount);
376 
377         _totalSupply += amount;
378         unchecked {
379             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
380             _balances[account] += amount;
381         }
382         emit Transfer(address(0), account, amount);
383 
384         _afterTokenTransfer(address(0), account, amount);
385     }
386 
387     /**
388      * @dev Destroys `amount` tokens from `account`, reducing the
389      * total supply.
390      *
391      * Emits a {Transfer} event with `to` set to the zero address.
392      *
393      * Requirements:
394      *
395      * - `account` cannot be the zero address.
396      * - `account` must have at least `amount` tokens.
397      */
398     function _burn(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: burn from the zero address");
400 
401         _beforeTokenTransfer(account, address(0), amount);
402 
403         uint256 accountBalance = _balances[account];
404         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
405         unchecked {
406             _balances[account] = accountBalance - amount;
407             // Overflow not possible: amount <= accountBalance <= totalSupply.
408             _totalSupply -= amount;
409         }
410 
411         emit Transfer(account, address(0), amount);
412 
413         _afterTokenTransfer(account, address(0), amount);
414     }
415 
416     /**
417      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
418      *
419      * This internal function is equivalent to `approve`, and can be used to
420      * e.g. set automatic allowances for certain subsystems, etc.
421      *
422      * Emits an {Approval} event.
423      *
424      * Requirements:
425      *
426      * - `owner` cannot be the zero address.
427      * - `spender` cannot be the zero address.
428      */
429     function _approve(address owner, address spender, uint256 amount) internal virtual {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432 
433         _allowances[owner][spender] = amount;
434         emit Approval(owner, spender, amount);
435     }
436 
437     /**
438      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
439      *
440      * Does not update the allowance amount in case of infinite allowance.
441      * Revert if not enough allowance is available.
442      *
443      * Might emit an {Approval} event.
444      */
445     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
446         uint256 currentAllowance = allowance(owner, spender);
447         if (currentAllowance != type(uint256).max) {
448             require(currentAllowance >= amount, "ERC20: insufficient allowance");
449             unchecked {
450                 _approve(owner, spender, currentAllowance - amount);
451             }
452         }
453     }
454 
455     /**
456      * @dev Hook that is called before any transfer of tokens. This includes
457      * minting and burning.
458      *
459      * Calling conditions:
460      *
461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
462      * will be transferred to `to`.
463      * - when `from` is zero, `amount` tokens will be minted for `to`.
464      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
465      * - `from` and `to` are never both zero.
466      *
467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
468      */
469     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
470 
471     /**
472      * @dev Hook that is called after any transfer of tokens. This includes
473      * minting and burning.
474      *
475      * Calling conditions:
476      *
477      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
478      * has been transferred to `to`.
479      * - when `from` is zero, `amount` tokens have been minted for `to`.
480      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
481      * - `from` and `to` are never both zero.
482      *
483      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
484      */
485     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
486 }
487 
488 contract PLUMS is ERC20 {
489     constructor() ERC20("PLUMS", "PLUMS") {
490         _mint(msg.sender,69420420420069*10**18);
491     }
492 }