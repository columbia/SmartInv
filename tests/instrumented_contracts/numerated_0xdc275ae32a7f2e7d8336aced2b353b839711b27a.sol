1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
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
107 /*
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
123         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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
139  * We have followed general OpenZeppelin guidelines: functions revert instead
140  * of returning `false` on failure. This behavior is nonetheless conventional
141  * and does not conflict with the expectations of ERC20 applications.
142  *
143  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
144  * This allows applications to reconstruct the allowance for all accounts just
145  * by listening to said events. Other implementations of the EIP may not emit
146  * these events, as it isn't required by the specification.
147  *
148  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
149  * functions have been added to mitigate the well-known issues around setting
150  * allowances. See {IERC20-approve}.
151  */
152 contract ERC20 is Context, IERC20, IERC20Metadata {
153     mapping(address => uint256) private _balances;
154 
155     mapping(address => mapping(address => uint256)) private _allowances;
156 
157     uint256 private _totalSupply;
158 
159     string private _name;
160     string private _symbol;
161 
162     /**
163      * @dev Sets the values for {name} and {symbol}.
164      *
165      * The defaut value of {decimals} is 18. To select a different value for
166      * {decimals} you should overload it.
167      *
168      * All two of these values are immutable: they can only be set once during
169      * construction.
170      */
171     constructor(string memory name_, string memory symbol_) {
172         _name = name_;
173         _symbol = symbol_;
174     }
175 
176     /**
177      * @dev Returns the name of the token.
178      */
179     function name() public view virtual override returns (string memory) {
180         return _name;
181     }
182 
183     /**
184      * @dev Returns the symbol of the token, usually a shorter version of the
185      * name.
186      */
187     function symbol() public view virtual override returns (string memory) {
188         return _symbol;
189     }
190 
191     /**
192      * @dev Returns the number of decimals used to get its user representation.
193      * For example, if `decimals` equals `2`, a balance of `505` tokens should
194      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
195      *
196      * Tokens usually opt for a value of 18, imitating the relationship between
197      * Ether and Wei. This is the value {ERC20} uses, unless this function is
198      * overridden;
199      *
200      * NOTE: This information is only used for _display_ purposes: it in
201      * no way affects any of the arithmetic of the contract, including
202      * {IERC20-balanceOf} and {IERC20-transfer}.
203      */
204     function decimals() public view virtual override returns (uint8) {
205         return 18;
206     }
207 
208     /**
209      * @dev See {IERC20-totalSupply}.
210      */
211     function totalSupply() public view virtual override returns (uint256) {
212         return _totalSupply;
213     }
214 
215     /**
216      * @dev See {IERC20-balanceOf}.
217      */
218     function balanceOf(address account) public view virtual override returns (uint256) {
219         return _balances[account];
220     }
221 
222     /**
223      * @dev See {IERC20-transfer}.
224      *
225      * Requirements:
226      *
227      * - `recipient` cannot be the zero address.
228      * - the caller must have a balance of at least `amount`.
229      */
230     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     /**
236      * @dev See {IERC20-allowance}.
237      */
238     function allowance(address owner, address spender) public view virtual override returns (uint256) {
239         return _allowances[owner][spender];
240     }
241 
242     /**
243      * @dev See {IERC20-approve}.
244      *
245      * Requirements:
246      *
247      * - `spender` cannot be the zero address.
248      */
249     function approve(address spender, uint256 amount) public virtual override returns (bool) {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-transferFrom}.
256      *
257      * Emits an {Approval} event indicating the updated allowance. This is not
258      * required by the EIP. See the note at the beginning of {ERC20}.
259      *
260      * Requirements:
261      *
262      * - `sender` and `recipient` cannot be the zero address.
263      * - `sender` must have a balance of at least `amount`.
264      * - the caller must have allowance for ``sender``'s tokens of at least
265      * `amount`.
266      */
267     function transferFrom(
268         address sender,
269         address recipient,
270         uint256 amount
271     ) public virtual override returns (bool) {
272         _transfer(sender, recipient, amount);
273 
274         uint256 currentAllowance = _allowances[sender][_msgSender()];
275         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
276         _approve(sender, _msgSender(), currentAllowance - amount);
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
315         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
316 
317         return true;
318     }
319 
320     /**
321      * @dev Moves tokens `amount` from `sender` to `recipient`.
322      *
323      * This is internal function is equivalent to {transfer}, and can be used to
324      * e.g. implement automatic token fees, slashing mechanisms, etc.
325      *
326      * Emits a {Transfer} event.
327      *
328      * Requirements:
329      *
330      * - `sender` cannot be the zero address.
331      * - `recipient` cannot be the zero address.
332      * - `sender` must have a balance of at least `amount`.
333      */
334     function _transfer(
335         address sender,
336         address recipient,
337         uint256 amount
338     ) internal virtual {
339         require(sender != address(0), "ERC20: transfer from the zero address");
340         require(recipient != address(0), "ERC20: transfer to the zero address");
341 
342         _beforeTokenTransfer(sender, recipient, amount);
343 
344         uint256 senderBalance = _balances[sender];
345         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
346         _balances[sender] = senderBalance - amount;
347         _balances[recipient] += amount;
348 
349         emit Transfer(sender, recipient, amount);
350     }
351 
352     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
353      * the total supply.
354      *
355      * Emits a {Transfer} event with `from` set to the zero address.
356      *
357      * Requirements:
358      *
359      * - `to` cannot be the zero address.
360      */
361     function _mint(address account, uint256 amount) internal virtual {
362         require(account != address(0), "ERC20: mint to the zero address");
363 
364         _beforeTokenTransfer(address(0), account, amount);
365 
366         _totalSupply += amount;
367         _balances[account] += amount;
368         emit Transfer(address(0), account, amount);
369     }
370 
371     /**
372      * @dev Destroys `amount` tokens from `account`, reducing the
373      * total supply.
374      *
375      * Emits a {Transfer} event with `to` set to the zero address.
376      *
377      * Requirements:
378      *
379      * - `account` cannot be the zero address.
380      * - `account` must have at least `amount` tokens.
381      */
382     function _burn(address account, uint256 amount) internal virtual {
383         require(account != address(0), "ERC20: burn from the zero address");
384 
385         _beforeTokenTransfer(account, address(0), amount);
386 
387         uint256 accountBalance = _balances[account];
388         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
389         _balances[account] = accountBalance - amount;
390         _totalSupply -= amount;
391 
392         emit Transfer(account, address(0), amount);
393     }
394 
395     /**
396      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
397      *
398      * This internal function is equivalent to `approve`, and can be used to
399      * e.g. set automatic allowances for certain subsystems, etc.
400      *
401      * Emits an {Approval} event.
402      *
403      * Requirements:
404      *
405      * - `owner` cannot be the zero address.
406      * - `spender` cannot be the zero address.
407      */
408     function _approve(
409         address owner,
410         address spender,
411         uint256 amount
412     ) internal virtual {
413         require(owner != address(0), "ERC20: approve from the zero address");
414         require(spender != address(0), "ERC20: approve to the zero address");
415 
416         _allowances[owner][spender] = amount;
417         emit Approval(owner, spender, amount);
418     }
419 
420     /**
421      * @dev Hook that is called before any transfer of tokens. This includes
422      * minting and burning.
423      *
424      * Calling conditions:
425      *
426      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
427      * will be to transferred to `to`.
428      * - when `from` is zero, `amount` tokens will be minted for `to`.
429      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
430      * - `from` and `to` are never both zero.
431      *
432      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
433      */
434     function _beforeTokenTransfer(
435         address from,
436         address to,
437         uint256 amount
438     ) internal virtual {}
439 }
440 
441 interface IPayable {
442     function pay(string memory serviceName) external payable;
443 }
444 
445 /**
446  * @title ServicePayer
447  * @dev Implementation of the ServicePayer
448  */
449 abstract contract ServicePayer {
450     constructor(address payable receiver, string memory serviceName) payable {
451         IPayable(receiver).pay{value: msg.value}(serviceName);
452     }
453 }
454 
455 /**
456  * @title SimpleERC20
457  * @author Veshi
458  * @dev Implementation of the SimpleERC20
459  */
460 contract SimpleERC20 is ERC20, ServicePayer {
461     constructor(
462         string memory name_,
463         string memory symbol_,
464         uint256 initialBalance_,
465         address payable feeReceiver_
466     ) payable ERC20(name_, symbol_) ServicePayer(feeReceiver_, "SimpleERC20") {
467         require(initialBalance_ > 0, "SimpleERC20: Supply cannot be zero");
468         _mint(_msgSender(), initialBalance_);
469     }
470 }
