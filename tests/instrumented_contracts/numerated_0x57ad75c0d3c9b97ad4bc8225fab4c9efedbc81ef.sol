1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Emitted when `value` tokens are moved from one account (`from`) to
9      * another (`to`).
10      *
11      * Note that `value` may be zero.
12      */
13     event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     /**
16      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
17      * a call to {approve}. `value` is the new allowance.
18      */
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `to`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address to, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `from` to `to` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address from,
76         address to,
77         uint256 amount
78     ) external returns (bool);
79 }
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Interface for the optional metadata functions from the ERC20 standard.
85  *
86  * _Available since v4.1._
87  */
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  *
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 abstract contract Context {
118     function _msgSender() internal view virtual returns (address) {
119         return msg.sender;
120     }
121 
122     function _msgData() internal view virtual returns (bytes calldata) {
123         return msg.data;
124     }
125 }
126 
127 pragma solidity ^0.8.0;
128 
129 
130 
131 /**
132  * @dev Implementation of the {IERC20} interface.
133  *
134  * This implementation is agnostic to the way tokens are created. This means
135  * that a supply mechanism has to be added in a derived contract using {_mint}.
136  * For a generic mechanism see {ERC20PresetMinterPauser}.
137  *
138  * TIP: For a detailed writeup see our guide
139  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
140  * to implement supply mechanisms].
141  *
142  * We have followed general OpenZeppelin Contracts guidelines: functions revert
143  * instead returning `false` on failure. This behavior is nonetheless
144  * conventional and does not conflict with the expectations of ERC20
145  * applications.
146  *
147  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
148  * This allows applications to reconstruct the allowance for all accounts just
149  * by listening to said events. Other implementations of the EIP may not emit
150  * these events, as it isn't required by the specification.
151  *
152  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
153  * functions have been added to mitigate the well-known issues around setting
154  * allowances. See {IERC20-approve}.
155  */
156 contract ERC20 is Context, IERC20, IERC20Metadata {
157     mapping(address => uint256) private _balances;
158 
159     mapping(address => mapping(address => uint256)) private _allowances;
160 
161     uint256 private _totalSupply;
162 
163     string private _name;
164     string private _symbol;
165 
166     /**
167      * @dev Sets the values for {name} and {symbol}.
168      *
169      * The default value of {decimals} is 18. To select a different value for
170      * {decimals} you should overload it.
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
201      * Ether and Wei. This is the value {ERC20} uses, unless this function is
202      * overridden;
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
279     function transferFrom(
280         address from,
281         address to,
282         uint256 amount
283     ) public virtual override returns (bool) {
284         address spender = _msgSender();
285         _spendAllowance(from, spender, amount);
286         _transfer(from, to, amount);
287         return true;
288     }
289 
290     /**
291      * @dev Atomically increases the allowance granted to `spender` by the caller.
292      *
293      * This is an alternative to {approve} that can be used as a mitigation for
294      * problems described in {IERC20-approve}.
295      *
296      * Emits an {Approval} event indicating the updated allowance.
297      *
298      * Requirements:
299      *
300      * - `spender` cannot be the zero address.
301      */
302     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
303         address owner = _msgSender();
304         _approve(owner, spender, allowance(owner, spender) + addedValue);
305         return true;
306     }
307 
308     /**
309      * @dev Atomically decreases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      * - `spender` must have allowance for the caller of at least
320      * `subtractedValue`.
321      */
322     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
323         address owner = _msgSender();
324         uint256 currentAllowance = allowance(owner, spender);
325         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
326         unchecked {
327             _approve(owner, spender, currentAllowance - subtractedValue);
328         }
329 
330         return true;
331     }
332 
333     /**
334      * @dev Moves `amount` of tokens from `from` to `to`.
335      *
336      * This internal function is equivalent to {transfer}, and can be used to
337      * e.g. implement automatic token fees, slashing mechanisms, etc.
338      *
339      * Emits a {Transfer} event.
340      *
341      * Requirements:
342      *
343      * - `from` cannot be the zero address.
344      * - `to` cannot be the zero address.
345      * - `from` must have a balance of at least `amount`.
346      */
347     function _transfer(
348         address from,
349         address to,
350         uint256 amount
351     ) internal virtual {
352         require(from != address(0), "ERC20: transfer from the zero address");
353         require(to != address(0), "ERC20: transfer to the zero address");
354 
355         _beforeTokenTransfer(from, to, amount);
356 
357         uint256 fromBalance = _balances[from];
358         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
359         unchecked {
360             _balances[from] = fromBalance - amount;
361         }
362         _balances[to] += amount;
363 
364         emit Transfer(from, to, amount);
365 
366         _afterTokenTransfer(from, to, amount);
367     }
368 
369     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
370      * the total supply.
371      *
372      * Emits a {Transfer} event with `from` set to the zero address.
373      *
374      * Requirements:
375      *
376      * - `account` cannot be the zero address.
377      */
378     function _mint(address account, uint256 amount) internal virtual {
379         require(account != address(0), "ERC20: mint to the zero address");
380 
381         _beforeTokenTransfer(address(0), account, amount);
382 
383         _totalSupply += amount;
384         _balances[account] += amount;
385         emit Transfer(address(0), account, amount);
386 
387         _afterTokenTransfer(address(0), account, amount);
388     }
389 
390     /**
391      * @dev Destroys `amount` tokens from `account`, reducing the
392      * total supply.
393      *
394      * Emits a {Transfer} event with `to` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      * - `account` must have at least `amount` tokens.
400      */
401     function _burn(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: burn from the zero address");
403 
404         _beforeTokenTransfer(account, address(0), amount);
405 
406         uint256 accountBalance = _balances[account];
407         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
408         unchecked {
409             _balances[account] = accountBalance - amount;
410         }
411         _totalSupply -= amount;
412 
413         emit Transfer(account, address(0), amount);
414 
415         _afterTokenTransfer(account, address(0), amount);
416     }
417 
418     /**
419      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
420      *
421      * This internal function is equivalent to `approve`, and can be used to
422      * e.g. set automatic allowances for certain subsystems, etc.
423      *
424      * Emits an {Approval} event.
425      *
426      * Requirements:
427      *
428      * - `owner` cannot be the zero address.
429      * - `spender` cannot be the zero address.
430      */
431     function _approve(
432         address owner,
433         address spender,
434         uint256 amount
435     ) internal virtual {
436         require(owner != address(0), "ERC20: approve from the zero address");
437         require(spender != address(0), "ERC20: approve to the zero address");
438 
439         _allowances[owner][spender] = amount;
440         emit Approval(owner, spender, amount);
441     }
442 
443     /**
444      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
445      *
446      * Does not update the allowance amount in case of infinite allowance.
447      * Revert if not enough allowance is available.
448      *
449      * Might emit an {Approval} event.
450      */
451     function _spendAllowance(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         uint256 currentAllowance = allowance(owner, spender);
457         if (currentAllowance != type(uint256).max) {
458             require(currentAllowance >= amount, "ERC20: insufficient allowance");
459             unchecked {
460                 _approve(owner, spender, currentAllowance - amount);
461             }
462         }
463     }
464 
465     /**
466      * @dev Hook that is called before any transfer of tokens. This includes
467      * minting and burning.
468      *
469      * Calling conditions:
470      *
471      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
472      * will be transferred to `to`.
473      * - when `from` is zero, `amount` tokens will be minted for `to`.
474      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
475      * - `from` and `to` are never both zero.
476      *
477      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
478      */
479     function _beforeTokenTransfer(
480         address from,
481         address to,
482         uint256 amount
483     ) internal virtual {}
484 
485     /**
486      * @dev Hook that is called after any transfer of tokens. This includes
487      * minting and burning.
488      *
489      * Calling conditions:
490      *
491      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
492      * has been transferred to `to`.
493      * - when `from` is zero, `amount` tokens have been minted for `to`.
494      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
495      * - `from` and `to` are never both zero.
496      *
497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
498      */
499     function _afterTokenTransfer(
500         address from,
501         address to,
502         uint256 amount
503     ) internal virtual {}
504 }
505 
506 
507 pragma solidity ^0.8.0;
508 
509 contract WaffleStay is ERC20 {
510 
511     constructor(
512         string memory _name,
513         string memory _symbol,
514         address[] memory addressList) public ERC20(_name, _symbol) {
515 
516         super._mint(addressList[0], 15000000000000000000000000);
517         super._mint(addressList[1], 10000000000000000000000000);
518         super._mint(addressList[2], 75000000000000000000000000);
519 
520     }
521 
522 }