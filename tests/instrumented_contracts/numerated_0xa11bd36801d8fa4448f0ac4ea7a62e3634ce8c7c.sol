1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
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
105 /**
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         return msg.data;
122     }
123 }
124 
125 /**
126  * @dev Implementation of the {IERC20} interface.
127  *
128  * This implementation is agnostic to the way tokens are created. This means
129  * that a supply mechanism has to be added in a derived contract using {_mint}.
130  * For a generic mechanism see {ERC20PresetMinterPauser}.
131  *
132  * TIP: For a detailed writeup see our guide
133  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
134  * to implement supply mechanisms].
135  *
136  * We have followed general OpenZeppelin Contracts guidelines: functions revert
137  * instead returning `false` on failure. This behavior is nonetheless
138  * conventional and does not conflict with the expectations of ERC20
139  * applications.
140  *
141  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
142  * This allows applications to reconstruct the allowance for all accounts just
143  * by listening to said events. Other implementations of the EIP may not emit
144  * these events, as it isn't required by the specification.
145  *
146  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
147  * functions have been added to mitigate the well-known issues around setting
148  * allowances. See {IERC20-approve}.
149  */
150 contract ERC20 is Context, IERC20, IERC20Metadata {
151     mapping(address => uint256) private _balances;
152 
153     mapping(address => mapping(address => uint256)) private _allowances;
154 
155     uint256 private _totalSupply;
156 
157     string private _name;
158     string private _symbol;
159 
160     /**
161      * @dev Sets the values for {name} and {symbol}.
162      *
163      * The default value of {decimals} is 18. To select a different value for
164      * {decimals} you should overload it.
165      *
166      * All two of these values are immutable: they can only be set once during
167      * construction.
168      */
169     constructor(string memory name_, string memory symbol_) {
170         _name = name_;
171         _symbol = symbol_;
172     }
173 
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() public view virtual override returns (string memory) {
178         return _name;
179     }
180 
181     /**
182      * @dev Returns the symbol of the token, usually a shorter version of the
183      * name.
184      */
185     function symbol() public view virtual override returns (string memory) {
186         return _symbol;
187     }
188 
189     /**
190      * @dev Returns the number of decimals used to get its user representation.
191      * For example, if `decimals` equals `2`, a balance of `505` tokens should
192      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
193      *
194      * Tokens usually opt for a value of 18, imitating the relationship between
195      * Ether and Wei. This is the value {ERC20} uses, unless this function is
196      * overridden;
197      *
198      * NOTE: This information is only used for _display_ purposes: it in
199      * no way affects any of the arithmetic of the contract, including
200      * {IERC20-balanceOf} and {IERC20-transfer}.
201      */
202     function decimals() public view virtual override returns (uint8) {
203         return 18;
204     }
205 
206     /**
207      * @dev See {IERC20-totalSupply}.
208      */
209     function totalSupply() public view virtual override returns (uint256) {
210         return _totalSupply;
211     }
212 
213     /**
214      * @dev See {IERC20-balanceOf}.
215      */
216     function balanceOf(address account) public view virtual override returns (uint256) {
217         return _balances[account];
218     }
219 
220     /**
221      * @dev See {IERC20-transfer}.
222      *
223      * Requirements:
224      *
225      * - `recipient` cannot be the zero address.
226      * - the caller must have a balance of at least `amount`.
227      */
228     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
229         _transfer(_msgSender(), recipient, amount);
230         return true;
231     }
232 
233     /**
234      * @dev See {IERC20-allowance}.
235      */
236     function allowance(address owner, address spender) public view virtual override returns (uint256) {
237         return _allowances[owner][spender];
238     }
239 
240     /**
241      * @dev See {IERC20-approve}.
242      *
243      * Requirements:
244      *
245      * - `spender` cannot be the zero address.
246      */
247     function approve(address spender, uint256 amount) public virtual override returns (bool) {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251 
252     /**
253      * @dev See {IERC20-transferFrom}.
254      *
255      * Emits an {Approval} event indicating the updated allowance. This is not
256      * required by the EIP. See the note at the beginning of {ERC20}.
257      *
258      * Requirements:
259      *
260      * - `sender` and `recipient` cannot be the zero address.
261      * - `sender` must have a balance of at least `amount`.
262      * - the caller must have allowance for ``sender``'s tokens of at least
263      * `amount`.
264      */
265     function transferFrom(
266         address sender,
267         address recipient,
268         uint256 amount
269     ) public virtual override returns (bool) {
270         _transfer(sender, recipient, amount);
271 
272         uint256 currentAllowance = _allowances[sender][_msgSender()];
273         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
274         unchecked {
275             _approve(sender, _msgSender(), currentAllowance - amount);
276         }
277 
278         return true;
279     }
280 
281     /**
282      * @dev Atomically increases the allowance granted to `spender` by the caller.
283      *
284      * This is an alternative to {approve} that can be used as a mitigation for
285      * problems described in {IERC20-approve}.
286      *
287      * Emits an {Approval} event indicating the updated allowance.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
294         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
295         return true;
296     }
297 
298     /**
299      * @dev Atomically decreases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to {approve} that can be used as a mitigation for
302      * problems described in {IERC20-approve}.
303      *
304      * Emits an {Approval} event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      * - `spender` must have allowance for the caller of at least
310      * `subtractedValue`.
311      */
312     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
313         uint256 currentAllowance = _allowances[_msgSender()][spender];
314         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
315         unchecked {
316             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
317         }
318 
319         return true;
320     }
321 
322     /**
323      * @dev Moves `amount` of tokens from `sender` to `recipient`.
324      *
325      * This internal function is equivalent to {transfer}, and can be used to
326      * e.g. implement automatic token fees, slashing mechanisms, etc.
327      *
328      * Emits a {Transfer} event.
329      *
330      * Requirements:
331      *
332      * - `sender` cannot be the zero address.
333      * - `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `amount`.
335      */
336     function _transfer(
337         address sender,
338         address recipient,
339         uint256 amount
340     ) internal virtual {
341         require(sender != address(0), "ERC20: transfer from the zero address");
342         require(recipient != address(0), "ERC20: transfer to the zero address");
343 
344         _beforeTokenTransfer(sender, recipient, amount);
345 
346         uint256 senderBalance = _balances[sender];
347         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
348         unchecked {
349             _balances[sender] = senderBalance - amount;
350         }
351         _balances[recipient] += amount;
352 
353         emit Transfer(sender, recipient, amount);
354 
355         _afterTokenTransfer(sender, recipient, amount);
356     }
357 
358     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
359      * the total supply.
360      *
361      * Emits a {Transfer} event with `from` set to the zero address.
362      *
363      * Requirements:
364      *
365      * - `account` cannot be the zero address.
366      */
367     function _mint(address account, uint256 amount) internal virtual {
368         require(account != address(0), "ERC20: mint to the zero address");
369 
370         _beforeTokenTransfer(address(0), account, amount);
371 
372         _totalSupply += amount;
373         _balances[account] += amount;
374         emit Transfer(address(0), account, amount);
375 
376         _afterTokenTransfer(address(0), account, amount);
377     }
378 
379     /**
380      * @dev Destroys `amount` tokens from `account`, reducing the
381      * total supply.
382      *
383      * Emits a {Transfer} event with `to` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      * - `account` must have at least `amount` tokens.
389      */
390     function _burn(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: burn from the zero address");
392 
393         _beforeTokenTransfer(account, address(0), amount);
394 
395         uint256 accountBalance = _balances[account];
396         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
397         unchecked {
398             _balances[account] = accountBalance - amount;
399         }
400         _totalSupply -= amount;
401 
402         emit Transfer(account, address(0), amount);
403 
404         _afterTokenTransfer(account, address(0), amount);
405     }
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
409      *
410      * This internal function is equivalent to `approve`, and can be used to
411      * e.g. set automatic allowances for certain subsystems, etc.
412      *
413      * Emits an {Approval} event.
414      *
415      * Requirements:
416      *
417      * - `owner` cannot be the zero address.
418      * - `spender` cannot be the zero address.
419      */
420     function _approve(
421         address owner,
422         address spender,
423         uint256 amount
424     ) internal virtual {
425         require(owner != address(0), "ERC20: approve from the zero address");
426         require(spender != address(0), "ERC20: approve to the zero address");
427 
428         _allowances[owner][spender] = amount;
429         emit Approval(owner, spender, amount);
430     }
431 
432     /**
433      * @dev Hook that is called before any transfer of tokens. This includes
434      * minting and burning.
435      *
436      * Calling conditions:
437      *
438      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
439      * will be transferred to `to`.
440      * - when `from` is zero, `amount` tokens will be minted for `to`.
441      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
442      * - `from` and `to` are never both zero.
443      *
444      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
445      */
446     function _beforeTokenTransfer(
447         address from,
448         address to,
449         uint256 amount
450     ) internal virtual {}
451 
452     /**
453      * @dev Hook that is called after any transfer of tokens. This includes
454      * minting and burning.
455      *
456      * Calling conditions:
457      *
458      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
459      * has been transferred to `to`.
460      * - when `from` is zero, `amount` tokens have been minted for `to`.
461      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
462      * - `from` and `to` are never both zero.
463      *
464      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
465      */
466     function _afterTokenTransfer(
467         address from,
468         address to,
469         uint256 amount
470     ) internal virtual {}
471 }
472 
473 contract Token is ERC20 {
474 
475     uint256 constant private TOTAL_SUPPLY = 100000000 ether;
476 
477     constructor() ERC20("Allbridge", "ABR") {
478         _mint(_msgSender(), TOTAL_SUPPLY);
479     }
480 }