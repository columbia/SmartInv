1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Emitted when `value` tokens are moved from one account (`from`) to
10      * another (`to`).
11      *
12      * Note that `value` may be zero.
13      */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /**
17      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
18      * a call to {approve}. `value` is the new allowance.
19      */
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `to`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address to, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `from` to `to` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address from,
77         address to,
78         uint256 amount
79     ) external returns (bool);
80 }
81 
82 interface IERC20Metadata is IERC20 {
83     /**
84      * @dev Returns the name of the token.
85      */
86     function name() external view returns (string memory);
87 
88     /**
89      * @dev Returns the symbol of the token.
90      */
91     function symbol() external view returns (string memory);
92 
93     /**
94      * @dev Returns the decimals places of the token.
95      */
96     function decimals() external view returns (uint8);
97 }
98 
99 /**
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes calldata) {
115         return msg.data;
116     }
117 }
118 
119 /**
120  * @dev Implementation of the {IERC20} interface.
121  *
122  * This implementation is agnostic to the way tokens are created. This means
123  * that a supply mechanism has to be added in a derived contract using {_mint}.
124  * For a generic mechanism see {ERC20PresetMinterPauser}.
125  *
126  * TIP: For a detailed writeup see our guide
127  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
128  * to implement supply mechanisms].
129  *
130  * We have followed general OpenZeppelin Contracts guidelines: functions revert
131  * instead returning `false` on failure. This behavior is nonetheless
132  * conventional and does not conflict with the expectations of ERC20
133  * applications.
134  *
135  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
136  * This allows applications to reconstruct the allowance for all accounts just
137  * by listening to said events. Other implementations of the EIP may not emit
138  * these events, as it isn't required by the specification.
139  *
140  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
141  * functions have been added to mitigate the well-known issues around setting
142  * allowances. See {IERC20-approve}.
143  */
144 contract ERC20 is Context, IERC20, IERC20Metadata {
145     mapping(address => uint256) private _balances;
146 
147     mapping(address => mapping(address => uint256)) private _allowances;
148 
149     uint256 private _totalSupply;
150 
151     string private _name;
152     string private _symbol;
153 
154     /**
155      * @dev Sets the values for {name} and {symbol}.
156      *
157      * The default value of {decimals} is 18. To select a different value for
158      * {decimals} you should overload it.
159      *
160      * All two of these values are immutable: they can only be set once during
161      * construction.
162      */
163     constructor(string memory name_, string memory symbol_) {
164         _name = name_;
165         _symbol = symbol_;
166     }
167 
168     /**
169      * @dev Returns the name of the token.
170      */
171     function name() public view virtual override returns (string memory) {
172         return _name;
173     }
174 
175     /**
176      * @dev Returns the symbol of the token, usually a shorter version of the
177      * name.
178      */
179     function symbol() public view virtual override returns (string memory) {
180         return _symbol;
181     }
182 
183     /**
184      * @dev Returns the number of decimals used to get its user representation.
185      * For example, if `decimals` equals `2`, a balance of `505` tokens should
186      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
187      *
188      * Tokens usually opt for a value of 18, imitating the relationship between
189      * Ether and Wei. This is the value {ERC20} uses, unless this function is
190      * overridden;
191      *
192      * NOTE: This information is only used for _display_ purposes: it in
193      * no way affects any of the arithmetic of the contract, including
194      * {IERC20-balanceOf} and {IERC20-transfer}.
195      */
196     function decimals() public view virtual override returns (uint8) {
197         return 18;
198     }
199 
200     /**
201      * @dev See {IERC20-totalSupply}.
202      */
203     function totalSupply() public view virtual override returns (uint256) {
204         return _totalSupply;
205     }
206 
207     /**
208      * @dev See {IERC20-balanceOf}.
209      */
210     function balanceOf(address account) public view virtual override returns (uint256) {
211         return _balances[account];
212     }
213 
214     /**
215      * @dev See {IERC20-transfer}.
216      *
217      * Requirements:
218      *
219      * - `to` cannot be the zero address.
220      * - the caller must have a balance of at least `amount`.
221      */
222     function transfer(address to, uint256 amount) public virtual override returns (bool) {
223         address owner = _msgSender();
224         _transfer(owner, to, amount);
225         return true;
226     }
227 
228     /**
229      * @dev See {IERC20-allowance}.
230      */
231     function allowance(address owner, address spender) public view virtual override returns (uint256) {
232         return _allowances[owner][spender];
233     }
234 
235     /**
236      * @dev See {IERC20-approve}.
237      *
238      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
239      * `transferFrom`. This is semantically equivalent to an infinite approval.
240      *
241      * Requirements:
242      *
243      * - `spender` cannot be the zero address.
244      */
245     function approve(address spender, uint256 amount) public virtual override returns (bool) {
246         address owner = _msgSender();
247         _approve(owner, spender, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-transferFrom}.
253      *
254      * Emits an {Approval} event indicating the updated allowance. This is not
255      * required by the EIP. See the note at the beginning of {ERC20}.
256      *
257      * NOTE: Does not update the allowance if the current allowance
258      * is the maximum `uint256`.
259      *
260      * Requirements:
261      *
262      * - `from` and `to` cannot be the zero address.
263      * - `from` must have a balance of at least `amount`.
264      * - the caller must have allowance for ``from``'s tokens of at least
265      * `amount`.
266      */
267     function transferFrom(
268         address from,
269         address to,
270         uint256 amount
271     ) public virtual override returns (bool) {
272         address spender = _msgSender();
273         _spendAllowance(from, spender, amount);
274         _transfer(from, to, amount);
275         return true;
276     }
277 
278     /**
279      * @dev Atomically increases the allowance granted to `spender` by the caller.
280      *
281      * This is an alternative to {approve} that can be used as a mitigation for
282      * problems described in {IERC20-approve}.
283      *
284      * Emits an {Approval} event indicating the updated allowance.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
291         address owner = _msgSender();
292         _approve(owner, spender, allowance(owner, spender) + addedValue);
293         return true;
294     }
295 
296     /**
297      * @dev Atomically decreases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      * - `spender` must have allowance for the caller of at least
308      * `subtractedValue`.
309      */
310     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
311         address owner = _msgSender();
312         uint256 currentAllowance = allowance(owner, spender);
313         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
314         unchecked {
315             _approve(owner, spender, currentAllowance - subtractedValue);
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
331      * - `from` cannot be the zero address.
332      * - `to` cannot be the zero address.
333      * - `from` must have a balance of at least `amount`.
334      */
335     function _transfer(
336         address from,
337         address to,
338         uint256 amount
339     ) internal virtual {
340         require(from != address(0), "ERC20: transfer from the zero address");
341         require(to != address(0), "ERC20: transfer to the zero address");
342 
343         _beforeTokenTransfer(from, to, amount);
344 
345         uint256 fromBalance = _balances[from];
346         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
347         unchecked {
348             _balances[from] = fromBalance - amount;
349         }
350         _balances[to] += amount;
351 
352         emit Transfer(from, to, amount);
353 
354         _afterTokenTransfer(from, to, amount);
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
432      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
433      *
434      * Does not update the allowance amount in case of infinite allowance.
435      * Revert if not enough allowance is available.
436      *
437      * Might emit an {Approval} event.
438      */
439     function _spendAllowance(
440         address owner,
441         address spender,
442         uint256 amount
443     ) internal virtual {
444         uint256 currentAllowance = allowance(owner, spender);
445         if (currentAllowance != type(uint256).max) {
446             require(currentAllowance >= amount, "ERC20: insufficient allowance");
447             unchecked {
448                 _approve(owner, spender, currentAllowance - amount);
449             }
450         }
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
494 contract MyToken1 is ERC20 {
495     constructor() ERC20("MEGA Project", "MEGA") {
496         _mint(0xD794ACc27BFC83a43522f480eaA57dB56812C14E, 7900000000 * 10 ** decimals());
497     }
498 }