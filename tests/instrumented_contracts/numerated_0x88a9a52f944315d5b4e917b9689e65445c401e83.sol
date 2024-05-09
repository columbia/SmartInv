1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.6;
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
79 /*
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes calldata) {
95         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
96         return msg.data;
97     }
98 }
99 
100 /**
101  * @dev Implementation of the {IERC20} interface.
102  *
103  * This implementation is agnostic to the way tokens are created. This means
104  * that a supply mechanism has to be added in a derived contract using {_mint}.
105  * For a generic mechanism see {ERC20PresetMinterPauser}.
106  *
107  * TIP: For a detailed writeup see our guide
108  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
109  * to implement supply mechanisms].
110  *
111  * We have followed general OpenZeppelin guidelines: functions revert instead
112  * of returning `false` on failure. This behavior is nonetheless conventional
113  * and does not conflict with the expectations of ERC20 applications.
114  *
115  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
116  * This allows applications to reconstruct the allowance for all accounts just
117  * by listening to said events. Other implementations of the EIP may not emit
118  * these events, as it isn't required by the specification.
119  *
120  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
121  * functions have been added to mitigate the well-known issues around setting
122  * allowances. See {IERC20-approve}.
123  */
124 contract ERC20 is Context, IERC20 {
125     mapping (address => uint256) private _balances;
126 
127     mapping (address => mapping (address => uint256)) private _allowances;
128 
129     uint256 private _totalSupply;
130 
131     string private _name;
132     string private _symbol;
133 
134     /**
135      * @dev Sets the values for {name} and {symbol}.
136      *
137      * The defaut value of {decimals} is 18. To select a different value for
138      * {decimals} you should overload it.
139      *
140      * All three of these values are immutable: they can only be set once during
141      * construction.
142      */
143     constructor (string memory name_, string memory symbol_) {
144         _name = name_;
145         _symbol = symbol_;
146     }
147 
148     /**
149      * @dev Returns the name of the token.
150      */
151     function name() external view virtual returns (string memory) {
152         return _name;
153     }
154 
155     /**
156      * @dev Returns the symbol of the token, usually a shorter version of the
157      * name.
158      */
159     function symbol() external view virtual returns (string memory) {
160         return _symbol;
161     }
162 
163     /**
164      * @dev Returns the number of decimals used to get its user representation.
165      * For example, if `decimals` equals `2`, a balance of `505` tokens should
166      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
167      *
168      * Tokens usually opt for a value of 18, imitating the relationship between
169      * Ether and Wei. This is the value {ERC20} uses, unless this function is
170      * overloaded;
171      *
172      * NOTE: This information is only used for _display_ purposes: it in
173      * no way affects any of the arithmetic of the contract, including
174      * {IERC20-balanceOf} and {IERC20-transfer}.
175      */
176     function decimals() external view virtual returns (uint8) {
177         return 18;
178     }
179 
180     /**
181      * @dev See {IERC20-totalSupply}.
182      */
183     function totalSupply() external view virtual override returns (uint256) {
184         return _totalSupply;
185     }
186 
187     /**
188      * @dev See {IERC20-balanceOf}.
189      */
190     function balanceOf(address account) external view virtual override returns (uint256) {
191         return _balances[account];
192     }
193 
194     /**
195      * @dev See {IERC20-transfer}.
196      *
197      * Requirements:
198      *
199      * - `recipient` cannot be the zero address.
200      * - the caller must have a balance of at least `amount`.
201      */
202     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     /**
208      * @dev See {IERC20-allowance}.
209      */
210     function allowance(address owner, address spender)
211         external view virtual override returns (uint256) {
212         return _allowances[owner][spender];
213     }
214 
215     /**
216      * @dev See {IERC20-approve}.
217      *
218      * Requirements:
219      *
220      * - `spender` cannot be the zero address.
221      */
222     function approve(address spender, uint256 amount) external virtual override returns (bool) {
223         _approve(_msgSender(), spender, amount);
224         return true;
225     }
226 
227     /**
228      * @dev See {IERC20-transferFrom}.
229      *
230      * Emits an {Approval} event indicating the updated allowance. This is not
231      * required by the EIP. See the note at the beginning of {ERC20}.
232      *
233      * Requirements:
234      *
235      * - `sender` and `recipient` cannot be the zero address.
236      * - `sender` must have a balance of at least `amount`.
237      * - the caller must have allowance for ``sender``'s tokens of at least
238      * `amount`.
239      */
240     function transferFrom(address sender, address recipient, uint256 amount)
241         external virtual override returns (bool) {
242         _transfer(sender, recipient, amount);
243 
244         uint256 currentAllowance = _allowances[sender][_msgSender()];
245         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
246         _approve(sender, _msgSender(), currentAllowance - amount);
247 
248         return true;
249     }
250 
251     /**
252      * @dev Atomically increases the allowance granted to `spender` by the caller.
253      *
254      * This is an alternative to {approve} that can be used as a mitigation for
255      * problems described in {IERC20-approve}.
256      *
257      * Emits an {Approval} event indicating the updated allowance.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      */
263     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
264         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
265         return true;
266     }
267 
268     /**
269      * @dev Atomically decreases the allowance granted to `spender` by the caller.
270      *
271      * This is an alternative to {approve} that can be used as a mitigation for
272      * problems described in {IERC20-approve}.
273      *
274      * Emits an {Approval} event indicating the updated allowance.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      * - `spender` must have allowance for the caller of at least
280      * `subtractedValue`.
281      */
282     function decreaseAllowance(address spender, uint256 subtractedValue)
283         external virtual returns (bool) {
284         uint256 currentAllowance = _allowances[_msgSender()][spender];
285         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
286         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
287 
288         return true;
289     }
290 
291     /**
292      * @dev Moves tokens `amount` from `sender` to `recipient`.
293      *
294      * This is internal function is equivalent to {transfer}, and can be used to
295      * e.g. implement automatic token fees, slashing mechanisms, etc.
296      *
297      * Emits a {Transfer} event.
298      *
299      * Requirements:
300      *
301      * - `sender` cannot be the zero address.
302      * - `recipient` cannot be the zero address.
303      * - `sender` must have a balance of at least `amount`.
304      */
305     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
306         require(sender != address(0), "ERC20: transfer from the zero address");
307         require(recipient != address(0), "ERC20: transfer to the zero address");
308 
309         _beforeTokenTransfer(sender, recipient, amount);
310 
311         uint256 senderBalance = _balances[sender];
312         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
313         _balances[sender] = senderBalance - amount;
314         _balances[recipient] += amount;
315 
316         emit Transfer(sender, recipient, amount);
317     }
318 
319     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
320      * the total supply.
321      *
322      * Emits a {Transfer} event with `from` set to the zero address.
323      *
324      * Requirements:
325      *
326      * - `to` cannot be the zero address.
327      */
328     function _mint(address account, uint256 amount) internal virtual {
329         require(account != address(0), "ERC20: mint to the zero address");
330 
331         _beforeTokenTransfer(address(0), account, amount);
332 
333         _totalSupply += amount;
334         _balances[account] += amount;
335         emit Transfer(address(0), account, amount);
336     }
337 
338     /**
339      * @dev Destroys `amount` tokens from `account`, reducing the
340      * total supply.
341      *
342      * Emits a {Transfer} event with `to` set to the zero address.
343      *
344      * Requirements:
345      *
346      * - `account` cannot be the zero address.
347      * - `account` must have at least `amount` tokens.
348      */
349     function _burn(address account, uint256 amount) internal virtual {
350         require(account != address(0), "ERC20: burn from the zero address");
351 
352         _beforeTokenTransfer(account, address(0), amount);
353 
354         uint256 accountBalance = _balances[account];
355         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
356         _balances[account] = accountBalance - amount;
357         _totalSupply -= amount;
358 
359         emit Transfer(account, address(0), amount);
360     }
361 
362     /**
363      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
364      *
365      * This internal function is equivalent to `approve`, and can be used to
366      * e.g. set automatic allowances for certain subsystems, etc.
367      *
368      * Emits an {Approval} event.
369      *
370      * Requirements:
371      *
372      * - `owner` cannot be the zero address.
373      * - `spender` cannot be the zero address.
374      */
375     function _approve(address owner, address spender, uint256 amount) internal virtual {
376         require(owner != address(0), "ERC20: approve from the zero address");
377         require(spender != address(0), "ERC20: approve to the zero address");
378 
379         _allowances[owner][spender] = amount;
380         emit Approval(owner, spender, amount);
381     }
382 
383     /**
384      * @dev Hook that is called before any transfer of tokens. This includes
385      * minting and burning.
386      *
387      * Calling conditions:
388      *
389      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
390      * will be to transferred to `to`.
391      * - when `from` is zero, `amount` tokens will be minted for `to`.
392      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
393      * - `from` and `to` are never both zero.
394      *
395      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
396      */
397     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
398 }
399 
400 /**
401  * @title Fear
402  * @dev Implementation of Fear NFTs
403  */
404 contract Fear  is ERC20 {
405     constructor (
406         string memory name,
407         string memory symbol,
408         uint256 initialBalance
409     ) ERC20(name, symbol) {
410         _mint(msg.sender, initialBalance);
411     }
412 }