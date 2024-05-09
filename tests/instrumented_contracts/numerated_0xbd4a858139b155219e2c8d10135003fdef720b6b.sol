1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 /**
78  * @dev Interface for the optional metadata functions from the ERC20 standard.
79  */
80 interface IERC20Metadata is IERC20 {
81     /**
82      * @dev Returns the name of the token.
83      */
84     function name() external view returns (string memory);
85 
86     /**
87      * @dev Returns the symbol of the token.
88      */
89     function symbol() external view returns (string memory);
90 
91     /**
92      * @dev Returns the decimals places of the token.
93      */
94     function decimals() external view returns (uint8);
95 }
96 
97 // SPDX-License-Identifier: MIT
98 
99 pragma solidity ^0.8.0;
100 
101 /*
102  * @dev Provides information about the current execution context, including the
103  * sender of the transaction and its data. While these are generally available
104  * via msg.sender and msg.data, they should not be accessed in such a direct
105  * manner, since when dealing with meta-transactions the account sending and
106  * paying for execution may not be the actual sender (as far as an application
107  * is concerned).
108  *
109  * This contract is only required for intermediate, library-like contracts.
110  */
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
118         return msg.data;
119     }
120 }
121 
122 /**
123  * @dev Implementation of the {IERC20} interface.
124  *
125  * This implementation is agnostic to the way tokens are created. This means
126  * that a supply mechanism has to be added in a derived contract using {_mint}.
127  * For a generic mechanism see {ERC20PresetMinterPauser}.
128  *
129  * TIP: For a detailed writeup see our guide
130  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
131  * to implement supply mechanisms].
132  *
133  * We have followed general OpenZeppelin guidelines: functions revert instead
134  * of returning `false` on failure. This behavior is nonetheless conventional
135  * and does not conflict with the expectations of ERC20 applications.
136  *
137  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
138  * This allows applications to reconstruct the allowance for all accounts just
139  * by listening to said events. Other implementations of the EIP may not emit
140  * these events, as it isn't required by the specification.
141  *
142  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
143  * functions have been added to mitigate the well-known issues around setting
144  * allowances. See {IERC20-approve}.
145  */
146 contract ERC20 is Context, IERC20, IERC20Metadata {
147     mapping (address => uint256) private _balances;
148 
149     mapping (address => mapping (address => uint256)) private _allowances;
150 
151     uint256 private _totalSupply;
152 
153     string private _name;
154     string private _symbol;
155 
156     /**
157      * @dev Sets the values for {name} and {symbol}.
158      *
159      * The defaut value of {decimals} is 18. To select a different value for
160      * {decimals} you should overload it.
161      *
162      * All two of these values are immutable: they can only be set once during
163      * construction.
164      */
165     constructor (string memory name_, string memory symbol_) {
166         _name = name_;
167         _symbol = symbol_;
168     }
169 
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() public view virtual override returns (string memory) {
174         return _name;
175     }
176 
177     /**
178      * @dev Returns the symbol of the token, usually a shorter version of the
179      * name.
180      */
181     function symbol() public view virtual override returns (string memory) {
182         return _symbol;
183     }
184 
185     /**
186      * @dev Returns the number of decimals used to get its user representation.
187      * For example, if `decimals` equals `2`, a balance of `505` tokens should
188      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
189      *
190      * Tokens usually opt for a value of 18, imitating the relationship between
191      * Ether and Wei. This is the value {ERC20} uses, unless this function is
192      * overridden;
193      *
194      * NOTE: This information is only used for _display_ purposes: it in
195      * no way affects any of the arithmetic of the contract, including
196      * {IERC20-balanceOf} and {IERC20-transfer}.
197      */
198     function decimals() public view virtual override returns (uint8) {
199         return 18;
200     }
201 
202     /**
203      * @dev See {IERC20-totalSupply}.
204      */
205     function totalSupply() public view virtual override returns (uint256) {
206         return _totalSupply;
207     }
208 
209     /**
210      * @dev See {IERC20-balanceOf}.
211      */
212     function balanceOf(address account) public view virtual override returns (uint256) {
213         return _balances[account];
214     }
215 
216     /**
217      * @dev See {IERC20-transfer}.
218      *
219      * Requirements:
220      *
221      * - `recipient` cannot be the zero address.
222      * - the caller must have a balance of at least `amount`.
223      */
224     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
225         _transfer(_msgSender(), recipient, amount);
226         return true;
227     }
228 
229     /**
230      * @dev See {IERC20-allowance}.
231      */
232     function allowance(address owner, address spender) public view virtual override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     /**
237      * @dev See {IERC20-approve}.
238      *
239      * Requirements:
240      *
241      * - `spender` cannot be the zero address.
242      */
243     function approve(address spender, uint256 amount) public virtual override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-transferFrom}.
250      *
251      * Emits an {Approval} event indicating the updated allowance. This is not
252      * required by the EIP. See the note at the beginning of {ERC20}.
253      *
254      * Requirements:
255      *
256      * - `sender` and `recipient` cannot be the zero address.
257      * - `sender` must have a balance of at least `amount`.
258      * - the caller must have allowance for ``sender``'s tokens of at least
259      * `amount`.
260      */
261     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
262         _transfer(sender, recipient, amount);
263 
264         uint256 currentAllowance = _allowances[sender][_msgSender()];
265         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
266         _approve(sender, _msgSender(), currentAllowance - amount);
267 
268         return true;
269     }
270 
271     /**
272      * @dev Atomically increases the allowance granted to `spender` by the caller.
273      *
274      * This is an alternative to {approve} that can be used as a mitigation for
275      * problems described in {IERC20-approve}.
276      *
277      * Emits an {Approval} event indicating the updated allowance.
278      *
279      * Requirements:
280      *
281      * - `spender` cannot be the zero address.
282      */
283     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
284         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
285         return true;
286     }
287 
288     /**
289      * @dev Atomically decreases the allowance granted to `spender` by the caller.
290      *
291      * This is an alternative to {approve} that can be used as a mitigation for
292      * problems described in {IERC20-approve}.
293      *
294      * Emits an {Approval} event indicating the updated allowance.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      * - `spender` must have allowance for the caller of at least
300      * `subtractedValue`.
301      */
302     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
303         uint256 currentAllowance = _allowances[_msgSender()][spender];
304         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
305         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
306 
307         return true;
308     }
309 
310     /**
311      * @dev Moves tokens `amount` from `sender` to `recipient`.
312      *
313      * This is internal function is equivalent to {transfer}, and can be used to
314      * e.g. implement automatic token fees, slashing mechanisms, etc.
315      *
316      * Emits a {Transfer} event.
317      *
318      * Requirements:
319      *
320      * - `sender` cannot be the zero address.
321      * - `recipient` cannot be the zero address.
322      * - `sender` must have a balance of at least `amount`.
323      */
324     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
325         require(sender != address(0), "ERC20: transfer from the zero address");
326         require(recipient != address(0), "ERC20: transfer to the zero address");
327 
328         _beforeTokenTransfer(sender, recipient, amount);
329 
330         uint256 senderBalance = _balances[sender];
331         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
332         _balances[sender] = senderBalance - amount;
333         _balances[recipient] += amount;
334 
335         emit Transfer(sender, recipient, amount);
336     }
337 
338     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
339      * the total supply.
340      *
341      * Emits a {Transfer} event with `from` set to the zero address.
342      *
343      * Requirements:
344      *
345      * - `to` cannot be the zero address.
346      */
347     function _mint(address account, uint256 amount) internal virtual {
348         require(account != address(0), "ERC20: mint to the zero address");
349 
350         _beforeTokenTransfer(address(0), account, amount);
351 
352         _totalSupply += amount;
353         _balances[account] += amount;
354         emit Transfer(address(0), account, amount);
355     }
356 
357     /**
358      * @dev Destroys `amount` tokens from `account`, reducing the
359      * total supply.
360      *
361      * Emits a {Transfer} event with `to` set to the zero address.
362      *
363      * Requirements:
364      *
365      * - `account` cannot be the zero address.
366      * - `account` must have at least `amount` tokens.
367      */
368     function _burn(address account, uint256 amount) internal virtual {
369         require(account != address(0), "ERC20: burn from the zero address");
370 
371         _beforeTokenTransfer(account, address(0), amount);
372 
373         uint256 accountBalance = _balances[account];
374         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
375         _balances[account] = accountBalance - amount;
376         _totalSupply -= amount;
377 
378         emit Transfer(account, address(0), amount);
379     }
380 
381     /**
382      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
383      *
384      * This internal function is equivalent to `approve`, and can be used to
385      * e.g. set automatic allowances for certain subsystems, etc.
386      *
387      * Emits an {Approval} event.
388      *
389      * Requirements:
390      *
391      * - `owner` cannot be the zero address.
392      * - `spender` cannot be the zero address.
393      */
394     function _approve(address owner, address spender, uint256 amount) internal virtual {
395         require(owner != address(0), "ERC20: approve from the zero address");
396         require(spender != address(0), "ERC20: approve to the zero address");
397 
398         _allowances[owner][spender] = amount;
399         emit Approval(owner, spender, amount);
400     }
401 
402     /**
403      * @dev Hook that is called before any transfer of tokens. This includes
404      * minting and burning.
405      *
406      * Calling conditions:
407      *
408      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
409      * will be to transferred to `to`.
410      * - when `from` is zero, `amount` tokens will be minted for `to`.
411      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
412      * - `from` and `to` are never both zero.
413      *
414      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
415      */
416     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
417 }
418 
419 contract SARToken is ERC20 {
420     constructor() public ERC20("Saren", "SAR") {
421         _mint(msg.sender, 1000000000 * (10 ** uint256(decimals())));
422     }
423 }