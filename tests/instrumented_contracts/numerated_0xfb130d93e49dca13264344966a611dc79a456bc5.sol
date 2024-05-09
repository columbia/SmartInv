1 // SPDX-License-Identifier: Unlicensed
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
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Interface for the optional metadata functions from the ERC20 standard.
84  *
85  * _Available since v4.1._
86  */
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 
104 
105 pragma solidity ^0.8.0;
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
128 
129 pragma solidity ^0.8.0;
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
142  * We have followed general OpenZeppelin guidelines: functions revert instead
143  * of returning `false` on failure. This behavior is nonetheless conventional
144  * and does not conflict with the expectations of ERC20 applications.
145  *
146  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
147  * This allows applications to reconstruct the allowance for all accounts just
148  * by listening to said events. Other implementations of the EIP may not emit
149  * these events, as it isn't required by the specification.
150  *
151  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
152  * functions have been added to mitigate the well-known issues around setting
153  * allowances. See {IERC20-approve}.
154  */
155 contract ERC20 is Context, IERC20, IERC20Metadata {
156     mapping (address => uint256) private _balances;
157 
158     mapping (address => mapping (address => uint256)) private _allowances;
159 
160     uint256 private _totalSupply;
161 
162     string private _name;
163     string private _symbol;
164 
165     /**
166      * @dev Sets the values for {name} and {symbol}.
167      *
168      * The defaut value of {decimals} is 18. To select a different value for
169      * {decimals} you should overload it.
170      *
171      * All two of these values are immutable: they can only be set once during
172      * construction.
173      */
174     constructor (string memory name_, string memory symbol_) {
175         _name = name_;
176         _symbol = symbol_;
177     }
178 
179     /**
180      * @dev Returns the name of the token.
181      */
182     function name() public view virtual override returns (string memory) {
183         return _name;
184     }
185 
186     /**
187      * @dev Returns the symbol of the token, usually a shorter version of the
188      * name.
189      */
190     function symbol() public view virtual override returns (string memory) {
191         return _symbol;
192     }
193 
194     /**
195      * @dev Returns the number of decimals used to get its user representation.
196      * For example, if `decimals` equals `2`, a balance of `505` tokens should
197      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
198      *
199      * Tokens usually opt for a value of 18, imitating the relationship between
200      * Ether and Wei. This is the value {ERC20} uses, unless this function is
201      * overridden;
202      *
203      * NOTE: This information is only used for _display_ purposes: it in
204      * no way affects any of the arithmetic of the contract, including
205      * {IERC20-balanceOf} and {IERC20-transfer}.
206      */
207     function decimals() public view virtual override returns (uint8) {
208         return 18;
209     }
210 
211     /**
212      * @dev See {IERC20-totalSupply}.
213      */
214     function totalSupply() public view virtual override returns (uint256) {
215         return _totalSupply;
216     }
217 
218     /**
219      * @dev See {IERC20-balanceOf}.
220      */
221     function balanceOf(address account) public view virtual override returns (uint256) {
222         return _balances[account];
223     }
224 
225     /**
226      * @dev See {IERC20-transfer}.
227      *
228      * Requirements:
229      *
230      * - `recipient` cannot be the zero address.
231      * - the caller must have a balance of at least `amount`.
232      */
233     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
234         _transfer(_msgSender(), recipient, amount);
235         return true;
236     }
237 
238     /**
239      * @dev See {IERC20-allowance}.
240      */
241     function allowance(address owner, address spender) public view virtual override returns (uint256) {
242         return _allowances[owner][spender];
243     }
244 
245     /**
246      * @dev See {IERC20-approve}.
247      *
248      * Requirements:
249      *
250      * - `spender` cannot be the zero address.
251      */
252     function approve(address spender, uint256 amount) public virtual override returns (bool) {
253         _approve(_msgSender(), spender, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-transferFrom}.
259      *
260      * Emits an {Approval} event indicating the updated allowance. This is not
261      * required by the EIP. See the note at the beginning of {ERC20}.
262      *
263      * Requirements:
264      *
265      * - `sender` and `recipient` cannot be the zero address.
266      * - `sender` must have a balance of at least `amount`.
267      * - the caller must have allowance for ``sender``'s tokens of at least
268      * `amount`.
269      */
270     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
271         _transfer(sender, recipient, amount);
272 
273         uint256 currentAllowance = _allowances[sender][_msgSender()];
274         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
275         _approve(sender, _msgSender(), currentAllowance - amount);
276 
277         return true;
278     }
279 
280     /**
281      * @dev Atomically increases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to {approve} that can be used as a mitigation for
284      * problems described in {IERC20-approve}.
285      *
286      * Emits an {Approval} event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
293         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
294         return true;
295     }
296 
297     /**
298      * @dev Atomically decreases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to {approve} that can be used as a mitigation for
301      * problems described in {IERC20-approve}.
302      *
303      * Emits an {Approval} event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      * - `spender` must have allowance for the caller of at least
309      * `subtractedValue`.
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
312         uint256 currentAllowance = _allowances[_msgSender()][spender];
313         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
314         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
315 
316         return true;
317     }
318 
319     /**
320      * @dev Moves tokens `amount` from `sender` to `recipient`.
321      *
322      * This is internal function is equivalent to {transfer}, and can be used to
323      * e.g. implement automatic token fees, slashing mechanisms, etc.
324      *
325      * Emits a {Transfer} event.
326      *
327      * Requirements:
328      *
329      * - `sender` cannot be the zero address.
330      * - `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `amount`.
332      */
333     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
334         require(sender != address(0), "ERC20: transfer from the zero address");
335         require(recipient != address(0), "ERC20: transfer to the zero address");
336 
337         _beforeTokenTransfer(sender, recipient, amount);
338 
339         uint256 senderBalance = _balances[sender];
340         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
341         _balances[sender] = senderBalance - amount;
342         _balances[recipient] += amount;
343 
344         emit Transfer(sender, recipient, amount);
345     }
346 
347     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
348      * the total supply.
349      *
350      * Emits a {Transfer} event with `from` set to the zero address.
351      *
352      * Requirements:
353      *
354      * - `to` cannot be the zero address.
355      */
356     function _mint(address account, uint256 amount) internal virtual {
357         require(account != address(0), "ERC20: mint to the zero address");
358 
359         _beforeTokenTransfer(address(0), account, amount);
360 
361         _totalSupply += amount;
362         _balances[account] += amount;
363         emit Transfer(address(0), account, amount);
364     }
365 
366     /**
367      * @dev Destroys `amount` tokens from `account`, reducing the
368      * total supply.
369      *
370      * Emits a {Transfer} event with `to` set to the zero address.
371      *
372      * Requirements:
373      *
374      * - `account` cannot be the zero address.
375      * - `account` must have at least `amount` tokens.
376      */
377     function _burn(address account, uint256 amount) internal virtual {
378         require(account != address(0), "ERC20: burn from the zero address");
379 
380         _beforeTokenTransfer(account, address(0), amount);
381 
382         uint256 accountBalance = _balances[account];
383         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
384         _balances[account] = accountBalance - amount;
385         _totalSupply -= amount;
386 
387         emit Transfer(account, address(0), amount);
388     }
389 
390     /**
391      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
392      *
393      * This internal function is equivalent to `approve`, and can be used to
394      * e.g. set automatic allowances for certain subsystems, etc.
395      *
396      * Emits an {Approval} event.
397      *
398      * Requirements:
399      *
400      * - `owner` cannot be the zero address.
401      * - `spender` cannot be the zero address.
402      */
403     function _approve(address owner, address spender, uint256 amount) internal virtual {
404         require(owner != address(0), "ERC20: approve from the zero address");
405         require(spender != address(0), "ERC20: approve to the zero address");
406 
407         _allowances[owner][spender] = amount;
408         emit Approval(owner, spender, amount);
409     }
410 
411     /**
412      * @dev Hook that is called before any transfer of tokens. This includes
413      * minting and burning.
414      *
415      * Calling conditions:
416      *
417      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
418      * will be to transferred to `to`.
419      * - when `from` is zero, `amount` tokens will be minted for `to`.
420      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
421      * - `from` and `to` are never both zero.
422      *
423      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
424      */
425     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
426 }
427 
428 
429 contract DOGEGF is ERC20 {
430     constructor() ERC20("DogeGF", "DOGEGF") {
431         _mint(msg.sender, 69420000000000000 * 10 ** decimals());
432     }
433 }