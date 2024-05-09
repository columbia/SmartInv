1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Interface for the optional metadata functions from the ERC20 standard.
109  *
110  * _Available since v4.1._
111  */
112 interface IERC20Metadata is IERC20 {
113     /**
114      * @dev Returns the name of the token.
115      */
116     function name() external view returns (string memory);
117 
118     /**
119      * @dev Returns the symbol of the token.
120      */
121     function symbol() external view returns (string memory);
122 
123     /**
124      * @dev Returns the decimals places of the token.
125      */
126     function decimals() external view returns (uint8);
127 }
128 
129 
130 pragma solidity ^0.8.0;
131 
132 
133 
134 
135 /**
136  * @dev Implementation of the {IERC20} interface.
137  *
138  * This implementation is agnostic to the way tokens are created. This means
139  * that a supply mechanism has to be added in a derived contract using {_mint}.
140  * For a generic mechanism see {ERC20PresetMinterPauser}.
141  *
142  * TIP: For a detailed writeup see our guide
143  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
144  * to implement supply mechanisms].
145  *
146  * We have followed general OpenZeppelin guidelines: functions revert instead
147  * of returning `false` on failure. This behavior is nonetheless conventional
148  * and does not conflict with the expectations of ERC20 applications.
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
160     mapping (address => uint256) private _balances;
161 
162     mapping (address => mapping (address => uint256)) private _allowances;
163 
164     uint256 private _totalSupply;
165 
166     string private _name;
167     string private _symbol;
168 
169     /**
170      * @dev Sets the values for {name} and {symbol}.
171      *
172      * The defaut value of {decimals} is 18. To select a different value for
173      * {decimals} you should overload it.
174      *
175      * All two of these values are immutable: they can only be set once during
176      * construction.
177      */
178     constructor (string memory name_, string memory symbol_) {
179         _name = name_;
180         _symbol = symbol_;
181     }
182 
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() public view virtual override returns (string memory) {
187         return _name;
188     }
189 
190     /**
191      * @dev Returns the symbol of the token, usually a shorter version of the
192      * name.
193      */
194     function symbol() public view virtual override returns (string memory) {
195         return _symbol;
196     }
197 
198     /**
199      * @dev Returns the number of decimals used to get its user representation.
200      * For example, if `decimals` equals `2`, a balance of `505` tokens should
201      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
202      *
203      * Tokens usually opt for a value of 18, imitating the relationship between
204      * Ether and Wei. This is the value {ERC20} uses, unless this function is
205      * overridden;
206      *
207      * NOTE: This information is only used for _display_ purposes: it in
208      * no way affects any of the arithmetic of the contract, including
209      * {IERC20-balanceOf} and {IERC20-transfer}.
210      */
211     function decimals() public view virtual override returns (uint8) {
212         return 18;
213     }
214 
215     /**
216      * @dev See {IERC20-totalSupply}.
217      */
218     function totalSupply() public view virtual override returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223      * @dev See {IERC20-balanceOf}.
224      */
225     function balanceOf(address account) public view virtual override returns (uint256) {
226         return _balances[account];
227     }
228 
229     /**
230      * @dev See {IERC20-transfer}.
231      *
232      * Requirements:
233      *
234      * - `recipient` cannot be the zero address.
235      * - the caller must have a balance of at least `amount`.
236      */
237     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
238         _transfer(_msgSender(), recipient, amount);
239         return true;
240     }
241 
242     /**
243      * @dev See {IERC20-allowance}.
244      */
245     function allowance(address owner, address spender) public view virtual override returns (uint256) {
246         return _allowances[owner][spender];
247     }
248 
249     /**
250      * @dev See {IERC20-approve}.
251      *
252      * Requirements:
253      *
254      * - `spender` cannot be the zero address.
255      */
256     function approve(address spender, uint256 amount) public virtual override returns (bool) {
257         _approve(_msgSender(), spender, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-transferFrom}.
263      *
264      * Emits an {Approval} event indicating the updated allowance. This is not
265      * required by the EIP. See the note at the beginning of {ERC20}.
266      *
267      * Requirements:
268      *
269      * - `sender` and `recipient` cannot be the zero address.
270      * - `sender` must have a balance of at least `amount`.
271      * - the caller must have allowance for ``sender``'s tokens of at least
272      * `amount`.
273      */
274     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
275         _transfer(sender, recipient, amount);
276 
277         uint256 currentAllowance = _allowances[sender][_msgSender()];
278         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
279         _approve(sender, _msgSender(), currentAllowance - amount);
280 
281         return true;
282     }
283 
284     /**
285      * @dev Atomically increases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to {approve} that can be used as a mitigation for
288      * problems described in {IERC20-approve}.
289      *
290      * Emits an {Approval} event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
297         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
298         return true;
299     }
300 
301     /**
302      * @dev Atomically decreases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to {approve} that can be used as a mitigation for
305      * problems described in {IERC20-approve}.
306      *
307      * Emits an {Approval} event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      * - `spender` must have allowance for the caller of at least
313      * `subtractedValue`.
314      */
315     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
316         uint256 currentAllowance = _allowances[_msgSender()][spender];
317         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
318         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
319 
320         return true;
321     }
322 
323     /**
324      * @dev Moves tokens `amount` from `sender` to `recipient`.
325      *
326      * This is internal function is equivalent to {transfer}, and can be used to
327      * e.g. implement automatic token fees, slashing mechanisms, etc.
328      *
329      * Emits a {Transfer} event.
330      *
331      * Requirements:
332      *
333      * - `sender` cannot be the zero address.
334      * - `recipient` cannot be the zero address.
335      * - `sender` must have a balance of at least `amount`.
336      */
337     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
338         require(sender != address(0), "ERC20: transfer from the zero address");
339         require(recipient != address(0), "ERC20: transfer to the zero address");
340 
341         _beforeTokenTransfer(sender, recipient, amount);
342 
343         uint256 senderBalance = _balances[sender];
344         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
345         _balances[sender] = senderBalance - amount;
346         _balances[recipient] += amount;
347 
348         emit Transfer(sender, recipient, amount);
349     }
350 
351     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
352      * the total supply.
353      *
354      * Emits a {Transfer} event with `from` set to the zero address.
355      *
356      * Requirements:
357      *
358      * - `to` cannot be the zero address.
359      */
360     function _mint(address account, uint256 amount) internal virtual {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _beforeTokenTransfer(address(0), account, amount);
364 
365         _totalSupply += amount;
366         _balances[account] += amount;
367         emit Transfer(address(0), account, amount);
368     }
369 
370     /**
371      * @dev Destroys `amount` tokens from `account`, reducing the
372      * total supply.
373      *
374      * Emits a {Transfer} event with `to` set to the zero address.
375      *
376      * Requirements:
377      *
378      * - `account` cannot be the zero address.
379      * - `account` must have at least `amount` tokens.
380      */
381     function _burn(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: burn from the zero address");
383 
384         _beforeTokenTransfer(account, address(0), amount);
385 
386         uint256 accountBalance = _balances[account];
387         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
388         _balances[account] = accountBalance - amount;
389         _totalSupply -= amount;
390 
391         emit Transfer(account, address(0), amount);
392     }
393 
394     /**
395      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
396      *
397      * This internal function is equivalent to `approve`, and can be used to
398      * e.g. set automatic allowances for certain subsystems, etc.
399      *
400      * Emits an {Approval} event.
401      *
402      * Requirements:
403      *
404      * - `owner` cannot be the zero address.
405      * - `spender` cannot be the zero address.
406      */
407     function _approve(address owner, address spender, uint256 amount) internal virtual {
408         require(owner != address(0), "ERC20: approve from the zero address");
409         require(spender != address(0), "ERC20: approve to the zero address");
410 
411         _allowances[owner][spender] = amount;
412         emit Approval(owner, spender, amount);
413     }
414 
415     /**
416      * @dev Hook that is called before any transfer of tokens. This includes
417      * minting and burning.
418      *
419      * Calling conditions:
420      *
421      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
422      * will be to transferred to `to`.
423      * - when `from` is zero, `amount` tokens will be minted for `to`.
424      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
425      * - `from` and `to` are never both zero.
426      *
427      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
428      */
429     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
430 }
431 
432 
433 pragma solidity ^0.8.0;
434 
435 
436 contract RICEToken is ERC20 {
437     constructor(uint256 initialSupply) ERC20("DAOSquare Governance Token", "RICE") {
438         _mint(address(0xf383975B49d2130e3BA0Df9e10dE5FF2Dd7A215a), initialSupply);
439     }
440 }