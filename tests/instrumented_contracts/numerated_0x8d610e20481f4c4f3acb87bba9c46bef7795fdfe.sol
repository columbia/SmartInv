1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
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
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
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
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Interface for the optional metadata functions from the ERC20 standard.
108  *
109  * _Available since v4.1._
110  */
111 interface IERC20Metadata is IERC20 {
112     /**
113      * @dev Returns the name of the token.
114      */
115     function name() external view returns (string memory);
116 
117     /**
118      * @dev Returns the symbol of the token.
119      */
120     function symbol() external view returns (string memory);
121 
122     /**
123      * @dev Returns the decimals places of the token.
124      */
125     function decimals() external view returns (uint8);
126 }
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Implementation of the {IERC20} interface.
132  *
133  * This implementation is agnostic to the way tokens are created. This means
134  * that a supply mechanism has to be added in a derived contract using {_mint}.
135  * For a generic mechanism see {ERC20PresetMinterPauser}.
136  *
137  * TIP: For a detailed writeup see our guide
138  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
139  * to implement supply mechanisms].
140  *
141  * We have followed general OpenZeppelin guidelines: functions revert instead
142  * of returning `false` on failure. This behavior is nonetheless conventional
143  * and does not conflict with the expectations of ERC20 applications.
144  *
145  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
146  * This allows applications to reconstruct the allowance for all accounts just
147  * by listening to said events. Other implementations of the EIP may not emit
148  * these events, as it isn't required by the specification.
149  *
150  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
151  * functions have been added to mitigate the well-known issues around setting
152  * allowances. See {IERC20-approve}.
153  */
154 contract ERC20 is Context, IERC20, IERC20Metadata {
155     mapping(address => uint256) private _balances;
156 
157     mapping(address => mapping(address => uint256)) private _allowances;
158 
159     uint256 private _totalSupply;
160 
161     string private _name;
162     string private _symbol;
163 
164     /**
165      * @dev Sets the values for {name} and {symbol}.
166      *
167      * The default value of {decimals} is 18. To select a different value for
168      * {decimals} you should overload it.
169      *
170      * All two of these values are immutable: they can only be set once during
171      * construction.
172      */
173     constructor(string memory name_, string memory symbol_) {
174         _name = name_;
175         _symbol = symbol_;
176     }
177 
178     /**
179      * @dev Returns the name of the token.
180      */
181     function name() public view virtual override returns (string memory) {
182         return _name;
183     }
184 
185     /**
186      * @dev Returns the symbol of the token, usually a shorter version of the
187      * name.
188      */
189     function symbol() public view virtual override returns (string memory) {
190         return _symbol;
191     }
192 
193     /**
194      * @dev Returns the number of decimals used to get its user representation.
195      * For example, if `decimals` equals `2`, a balance of `505` tokens should
196      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
197      *
198      * Tokens usually opt for a value of 18, imitating the relationship between
199      * Ether and Wei. This is the value {ERC20} uses, unless this function is
200      * overridden;
201      *
202      * NOTE: This information is only used for _display_ purposes: it in
203      * no way affects any of the arithmetic of the contract, including
204      * {IERC20-balanceOf} and {IERC20-transfer}.
205      */
206     function decimals() public view virtual override returns (uint8) {
207         return 18;
208     }
209 
210     /**
211      * @dev See {IERC20-totalSupply}.
212      */
213     function totalSupply() public view virtual override returns (uint256) {
214         return _totalSupply;
215     }
216 
217     /**
218      * @dev See {IERC20-balanceOf}.
219      */
220     function balanceOf(address account) public view virtual override returns (uint256) {
221         return _balances[account];
222     }
223 
224     /**
225      * @dev See {IERC20-transfer}.
226      *
227      * Requirements:
228      *
229      * - `recipient` cannot be the zero address.
230      * - the caller must have a balance of at least `amount`.
231      */
232     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
233         _transfer(_msgSender(), recipient, amount);
234         return true;
235     }
236 
237     /**
238      * @dev See {IERC20-allowance}.
239      */
240     function allowance(address owner, address spender) public view virtual override returns (uint256) {
241         return _allowances[owner][spender];
242     }
243 
244     /**
245      * @dev See {IERC20-approve}.
246      *
247      * Requirements:
248      *
249      * - `spender` cannot be the zero address.
250      */
251     function approve(address spender, uint256 amount) public virtual override returns (bool) {
252         _approve(_msgSender(), spender, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-transferFrom}.
258      *
259      * Emits an {Approval} event indicating the updated allowance. This is not
260      * required by the EIP. See the note at the beginning of {ERC20}.
261      *
262      * Requirements:
263      *
264      * - `sender` and `recipient` cannot be the zero address.
265      * - `sender` must have a balance of at least `amount`.
266      * - the caller must have allowance for ``sender``'s tokens of at least
267      * `amount`.
268      */
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) public virtual override returns (bool) {
274         _transfer(sender, recipient, amount);
275 
276         uint256 currentAllowance = _allowances[sender][_msgSender()];
277         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
278         unchecked {
279             _approve(sender, _msgSender(), currentAllowance - amount);
280         }
281 
282         return true;
283     }
284 
285     /**
286      * @dev Atomically increases the allowance granted to `spender` by the caller.
287      *
288      * This is an alternative to {approve} that can be used as a mitigation for
289      * problems described in {IERC20-approve}.
290      *
291      * Emits an {Approval} event indicating the updated allowance.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      */
297     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
298         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
299         return true;
300     }
301 
302     /**
303      * @dev Atomically decreases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      * - `spender` must have allowance for the caller of at least
314      * `subtractedValue`.
315      */
316     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
317         uint256 currentAllowance = _allowances[_msgSender()][spender];
318         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
319         unchecked {
320             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
321         }
322 
323         return true;
324     }
325 
326     /**
327      * @dev Moves `amount` of tokens from `sender` to `recipient`.
328      *
329      * This internal function is equivalent to {transfer}, and can be used to
330      * e.g. implement automatic token fees, slashing mechanisms, etc.
331      *
332      * Emits a {Transfer} event.
333      *
334      * Requirements:
335      *
336      * - `sender` cannot be the zero address.
337      * - `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `amount`.
339      */
340     function _transfer(
341         address sender,
342         address recipient,
343         uint256 amount
344     ) internal virtual {
345         require(sender != address(0), "ERC20: transfer from the zero address");
346         require(recipient != address(0), "ERC20: transfer to the zero address");
347 
348         _beforeTokenTransfer(sender, recipient, amount);
349 
350         uint256 senderBalance = _balances[sender];
351         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
352         unchecked {
353             _balances[sender] = senderBalance - amount;
354         }
355         _balances[recipient] += amount;
356 
357         emit Transfer(sender, recipient, amount);
358 
359         _afterTokenTransfer(sender, recipient, amount);
360     }
361 
362     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
363      * the total supply.
364      *
365      * Emits a {Transfer} event with `from` set to the zero address.
366      *
367      * Requirements:
368      *
369      * - `account` cannot be the zero address.
370      */
371     function _mint(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: mint to the zero address");
373 
374         _beforeTokenTransfer(address(0), account, amount);
375 
376         _totalSupply += amount;
377         _balances[account] += amount;
378         emit Transfer(address(0), account, amount);
379 
380         _afterTokenTransfer(address(0), account, amount);
381     }
382 
383     /**
384      * @dev Destroys `amount` tokens from `account`, reducing the
385      * total supply.
386      *
387      * Emits a {Transfer} event with `to` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      * - `account` must have at least `amount` tokens.
393      */
394     function _burn(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: burn from the zero address");
396 
397         _beforeTokenTransfer(account, address(0), amount);
398 
399         uint256 accountBalance = _balances[account];
400         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
401         unchecked {
402             _balances[account] = accountBalance - amount;
403         }
404         _totalSupply -= amount;
405 
406         emit Transfer(account, address(0), amount);
407 
408         _afterTokenTransfer(account, address(0), amount);
409     }
410 
411     /**
412      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
413      *
414      * This internal function is equivalent to `approve`, and can be used to
415      * e.g. set automatic allowances for certain subsystems, etc.
416      *
417      * Emits an {Approval} event.
418      *
419      * Requirements:
420      *
421      * - `owner` cannot be the zero address.
422      * - `spender` cannot be the zero address.
423      */
424     function _approve(
425         address owner,
426         address spender,
427         uint256 amount
428     ) internal virtual {
429         require(owner != address(0), "ERC20: approve from the zero address");
430         require(spender != address(0), "ERC20: approve to the zero address");
431 
432         _allowances[owner][spender] = amount;
433         emit Approval(owner, spender, amount);
434     }
435 
436     /**
437      * @dev Hook that is called before any transfer of tokens. This includes
438      * minting and burning.
439      *
440      * Calling conditions:
441      *
442      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
443      * will be transferred to `to`.
444      * - when `from` is zero, `amount` tokens will be minted for `to`.
445      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
446      * - `from` and `to` are never both zero.
447      *
448      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
449      */
450     function _beforeTokenTransfer(
451         address from,
452         address to,
453         uint256 amount
454     ) internal virtual {}
455 
456     /**
457      * @dev Hook that is called after any transfer of tokens. This includes
458      * minting and burning.
459      *
460      * Calling conditions:
461      *
462      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
463      * has been transferred to `to`.
464      * - when `from` is zero, `amount` tokens have been minted for `to`.
465      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
466      * - `from` and `to` are never both zero.
467      *
468      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
469      */
470     function _afterTokenTransfer(
471         address from,
472         address to,
473         uint256 amount
474     ) internal virtual {}
475 }
476 
477 
478 pragma solidity ^0.8.0;
479 // SPDX-License-Identifier: MIT
480 
481 contract UnityNetwork is ERC20 {
482     
483     constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
484         _mint(msg.sender, 9983000 * 10 ** decimals());
485     }
486     
487 }