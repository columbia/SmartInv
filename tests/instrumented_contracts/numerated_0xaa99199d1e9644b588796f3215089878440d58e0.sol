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
151     function name() public view virtual returns (string memory) {
152         return _name;
153     }
154 
155     /**
156      * @dev Returns the symbol of the token, usually a shorter version of the
157      * name.
158      */
159     function symbol() public view virtual returns (string memory) {
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
176     function decimals() public view virtual returns (uint8) {
177         return 18;
178     }
179 
180     /**
181      * @dev See {IERC20-totalSupply}.
182      */
183     function totalSupply() public view virtual override returns (uint256) {
184         return _totalSupply;
185     }
186 
187     /**
188      * @dev See {IERC20-balanceOf}.
189      */
190     function balanceOf(address account) public view virtual override returns (uint256) {
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
202     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     /**
208      * @dev See {IERC20-allowance}.
209      */
210     function allowance(address owner, address spender) public view virtual override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     /**
215      * @dev See {IERC20-approve}.
216      *
217      * Requirements:
218      *
219      * - `spender` cannot be the zero address.
220      */
221     function approve(address spender, uint256 amount) public virtual override returns (bool) {
222         _approve(_msgSender(), spender, amount);
223         return true;
224     }
225 
226     /**
227      * @dev See {IERC20-transferFrom}.
228      *
229      * Emits an {Approval} event indicating the updated allowance. This is not
230      * required by the EIP. See the note at the beginning of {ERC20}.
231      *
232      * Requirements:
233      *
234      * - `sender` and `recipient` cannot be the zero address.
235      * - `sender` must have a balance of at least `amount`.
236      * - the caller must have allowance for ``sender``'s tokens of at least
237      * `amount`.
238      */
239     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
240         _transfer(sender, recipient, amount);
241 
242         uint256 currentAllowance = _allowances[sender][_msgSender()];
243         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
244         _approve(sender, _msgSender(), currentAllowance - amount);
245 
246         return true;
247     }
248 
249     /**
250      * @dev Atomically increases the allowance granted to `spender` by the caller.
251      *
252      * This is an alternative to {approve} that can be used as a mitigation for
253      * problems described in {IERC20-approve}.
254      *
255      * Emits an {Approval} event indicating the updated allowance.
256      *
257      * Requirements:
258      *
259      * - `spender` cannot be the zero address.
260      */
261     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
262         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
263         return true;
264     }
265 
266     /**
267      * @dev Atomically decreases the allowance granted to `spender` by the caller.
268      *
269      * This is an alternative to {approve} that can be used as a mitigation for
270      * problems described in {IERC20-approve}.
271      *
272      * Emits an {Approval} event indicating the updated allowance.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      * - `spender` must have allowance for the caller of at least
278      * `subtractedValue`.
279      */
280     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
281         uint256 currentAllowance = _allowances[_msgSender()][spender];
282         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
283         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
284 
285         return true;
286     }
287 
288     /**
289      * @dev Moves tokens `amount` from `sender` to `recipient`.
290      *
291      * This is internal function is equivalent to {transfer}, and can be used to
292      * e.g. implement automatic token fees, slashing mechanisms, etc.
293      *
294      * Emits a {Transfer} event.
295      *
296      * Requirements:
297      *
298      * - `sender` cannot be the zero address.
299      * - `recipient` cannot be the zero address.
300      * - `sender` must have a balance of at least `amount`.
301      */
302     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
303         require(sender != address(0), "ERC20: transfer from the zero address");
304         require(recipient != address(0), "ERC20: transfer to the zero address");
305 
306         _beforeTokenTransfer(sender, recipient, amount);
307 
308         uint256 senderBalance = _balances[sender];
309         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
310         _balances[sender] = senderBalance - amount;
311         _balances[recipient] += amount;
312 
313         emit Transfer(sender, recipient, amount);
314     }
315 
316     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
317      * the total supply.
318      *
319      * Emits a {Transfer} event with `from` set to the zero address.
320      *
321      * Requirements:
322      *
323      * - `to` cannot be the zero address.
324      */
325     function _mint(address account, uint256 amount) internal virtual {
326         require(account != address(0), "ERC20: mint to the zero address");
327 
328         _beforeTokenTransfer(address(0), account, amount);
329 
330         _totalSupply += amount;
331         _balances[account] += amount;
332         emit Transfer(address(0), account, amount);
333     }
334 
335     /**
336      * @dev Destroys `amount` tokens from `account`, reducing the
337      * total supply.
338      *
339      * Emits a {Transfer} event with `to` set to the zero address.
340      *
341      * Requirements:
342      *
343      * - `account` cannot be the zero address.
344      * - `account` must have at least `amount` tokens.
345      */
346     function _burn(address account, uint256 amount) internal virtual {
347         require(account != address(0), "ERC20: burn from the zero address");
348 
349         _beforeTokenTransfer(account, address(0), amount);
350 
351         uint256 accountBalance = _balances[account];
352         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
353         _balances[account] = accountBalance - amount;
354         _totalSupply -= amount;
355 
356         emit Transfer(account, address(0), amount);
357     }
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
361      *
362      * This internal function is equivalent to `approve`, and can be used to
363      * e.g. set automatic allowances for certain subsystems, etc.
364      *
365      * Emits an {Approval} event.
366      *
367      * Requirements:
368      *
369      * - `owner` cannot be the zero address.
370      * - `spender` cannot be the zero address.
371      */
372     function _approve(address owner, address spender, uint256 amount) internal virtual {
373         require(owner != address(0), "ERC20: approve from the zero address");
374         require(spender != address(0), "ERC20: approve to the zero address");
375 
376         _allowances[owner][spender] = amount;
377         emit Approval(owner, spender, amount);
378     }
379 
380     /**
381      * @dev Hook that is called before any transfer of tokens. This includes
382      * minting and burning.
383      *
384      * Calling conditions:
385      *
386      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
387      * will be to transferred to `to`.
388      * - when `from` is zero, `amount` tokens will be minted for `to`.
389      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
390      * - `from` and `to` are never both zero.
391      *
392      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
393      */
394     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
395 }
396 
397 /**
398  * @dev Extension of {ERC20} that allows token holders to destroy both their own
399  * tokens and those that they have an allowance for, in a way that can be
400  * recognized off-chain (via event analysis).
401  */
402 abstract contract ERC20Burnable is Context, ERC20 {
403     /**
404      * @dev Destroys `amount` tokens from the caller.
405      *
406      * See {ERC20-_burn}.
407      */
408     function burn(uint256 amount) public virtual {
409         _burn(_msgSender(), amount);
410     }
411 
412     /**
413      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
414      * allowance.
415      *
416      * See {ERC20-_burn} and {ERC20-allowance}.
417      *
418      * Requirements:
419      *
420      * - the caller must have allowance for ``accounts``'s tokens of at least
421      * `amount`.
422      */
423     function burnFrom(address account, uint256 amount) public virtual {
424         uint256 currentAllowance = allowance(account, _msgSender());
425         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
426         _approve(account, _msgSender(), currentAllowance - amount);
427         _burn(account, amount);
428     }
429 }
430 
431 contract ALPHRToken is ERC20Burnable {
432     /**
433      * @dev Mint 10mln tokens to deplyer
434      */
435     constructor() ERC20("ALPHR", "ALPHR") {
436         _mint(_msgSender(), 10_000_000 * (10**uint256(decimals())));
437     }
438 }