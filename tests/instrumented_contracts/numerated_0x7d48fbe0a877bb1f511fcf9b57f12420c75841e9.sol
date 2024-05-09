1 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
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
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @dev Interface for the optional metadata functions from the ERC20 standard.
83  *
84  * _Available since v4.1._
85  */
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns (string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns (string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns (uint8);
101 }
102 
103 /*
104  * @dev Provides information about the current execution context, including the
105  * sender of the transaction and its data. While these are generally available
106  * via msg.sender and msg.data, they should not be accessed in such a direct
107  * manner, since when dealing with meta-transactions the account sending and
108  * paying for execution may not be the actual sender (as far as an application
109  * is concerned).
110  *
111  * This contract is only required for intermediate, library-like contracts.
112  */
113 abstract contract Context {
114     function _msgSender() internal view virtual returns (address) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view virtual returns (bytes calldata) {
119         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
120         return msg.data;
121     }
122 }
123 
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
136  * We have followed general OpenZeppelin guidelines: functions revert instead
137  * of returning `false` on failure. This behavior is nonetheless conventional
138  * and does not conflict with the expectations of ERC20 applications.
139  *
140  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
141  * This allows applications to reconstruct the allowance for all accounts just
142  * by listening to said events. Other implementations of the EIP may not emit
143  * these events, as it isn't required by the specification.
144  *
145  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
146  * functions have been added to mitigate the well-known issues around setting
147  * allowances. See {IERC20-approve}.
148  */
149 contract ERC20 is Context, IERC20, IERC20Metadata {
150     mapping (address => uint256) private _balances;
151 
152     mapping (address => mapping (address => uint256)) private _allowances;
153 
154     uint256 private _totalSupply;
155 
156     string private _name;
157     string private _symbol;
158 
159     /**
160      * @dev Sets the values for {name} and {symbol}.
161      *
162      * The defaut value of {decimals} is 18. To select a different value for
163      * {decimals} you should overload it.
164      *
165      * All two of these values are immutable: they can only be set once during
166      * construction.
167      */
168     constructor (string memory name_, string memory symbol_) {
169         _name = name_;
170         _symbol = symbol_;
171     }
172 
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() public view virtual override returns (string memory) {
177         return _name;
178     }
179 
180     /**
181      * @dev Returns the symbol of the token, usually a shorter version of the
182      * name.
183      */
184     function symbol() public view virtual override returns (string memory) {
185         return _symbol;
186     }
187 
188     /**
189      * @dev Returns the number of decimals used to get its user representation.
190      * For example, if `decimals` equals `2`, a balance of `505` tokens should
191      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
192      *
193      * Tokens usually opt for a value of 18, imitating the relationship between
194      * Ether and Wei. This is the value {ERC20} uses, unless this function is
195      * overridden;
196      *
197      * NOTE: This information is only used for _display_ purposes: it in
198      * no way affects any of the arithmetic of the contract, including
199      * {IERC20-balanceOf} and {IERC20-transfer}.
200      */
201     function decimals() public view virtual override returns (uint8) {
202         return 18;
203     }
204 
205     /**
206      * @dev See {IERC20-totalSupply}.
207      */
208     function totalSupply() public view virtual override returns (uint256) {
209         return _totalSupply;
210     }
211 
212     /**
213      * @dev See {IERC20-balanceOf}.
214      */
215     function balanceOf(address account) public view virtual override returns (uint256) {
216         return _balances[account];
217     }
218 
219     /**
220      * @dev See {IERC20-transfer}.
221      *
222      * Requirements:
223      *
224      * - `recipient` cannot be the zero address.
225      * - the caller must have a balance of at least `amount`.
226      */
227     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     /**
233      * @dev See {IERC20-allowance}.
234      */
235     function allowance(address owner, address spender) public view virtual override returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     /**
240      * @dev See {IERC20-approve}.
241      *
242      * Requirements:
243      *
244      * - `spender` cannot be the zero address.
245      */
246     function approve(address spender, uint256 amount) public virtual override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-transferFrom}.
253      *
254      * Emits an {Approval} event indicating the updated allowance. This is not
255      * required by the EIP. See the note at the beginning of {ERC20}.
256      *
257      * Requirements:
258      *
259      * - `sender` and `recipient` cannot be the zero address.
260      * - `sender` must have a balance of at least `amount`.
261      * - the caller must have allowance for ``sender``'s tokens of at least
262      * `amount`.
263      */
264     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
265         _transfer(sender, recipient, amount);
266 
267         uint256 currentAllowance = _allowances[sender][_msgSender()];
268         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
269         _approve(sender, _msgSender(), currentAllowance - amount);
270 
271         return true;
272     }
273 
274     /**
275      * @dev Atomically increases the allowance granted to `spender` by the caller.
276      *
277      * This is an alternative to {approve} that can be used as a mitigation for
278      * problems described in {IERC20-approve}.
279      *
280      * Emits an {Approval} event indicating the updated allowance.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      */
286     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
287         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
288         return true;
289     }
290 
291     /**
292      * @dev Atomically decreases the allowance granted to `spender` by the caller.
293      *
294      * This is an alternative to {approve} that can be used as a mitigation for
295      * problems described in {IERC20-approve}.
296      *
297      * Emits an {Approval} event indicating the updated allowance.
298      *
299      * Requirements:
300      *
301      * - `spender` cannot be the zero address.
302      * - `spender` must have allowance for the caller of at least
303      * `subtractedValue`.
304      */
305     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
306         uint256 currentAllowance = _allowances[_msgSender()][spender];
307         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
308         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
309 
310         return true;
311     }
312 
313     /**
314      * @dev Moves tokens `amount` from `sender` to `recipient`.
315      *
316      * This is internal function is equivalent to {transfer}, and can be used to
317      * e.g. implement automatic token fees, slashing mechanisms, etc.
318      *
319      * Emits a {Transfer} event.
320      *
321      * Requirements:
322      *
323      * - `sender` cannot be the zero address.
324      * - `recipient` cannot be the zero address.
325      * - `sender` must have a balance of at least `amount`.
326      */
327     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
328         require(sender != address(0), "ERC20: transfer from the zero address");
329         require(recipient != address(0), "ERC20: transfer to the zero address");
330 
331         _beforeTokenTransfer(sender, recipient, amount);
332 
333         uint256 senderBalance = _balances[sender];
334         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
335         _balances[sender] = senderBalance - amount;
336         _balances[recipient] += amount;
337 
338         emit Transfer(sender, recipient, amount);
339     }
340 
341     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
342      * the total supply.
343      *
344      * Emits a {Transfer} event with `from` set to the zero address.
345      *
346      * Requirements:
347      *
348      * - `to` cannot be the zero address.
349      */
350     function _mint(address account, uint256 amount) internal virtual {
351         require(account != address(0), "ERC20: mint to the zero address");
352 
353         _beforeTokenTransfer(address(0), account, amount);
354 
355         _totalSupply += amount;
356         _balances[account] += amount;
357         emit Transfer(address(0), account, amount);
358     }
359 
360     /**
361      * @dev Destroys `amount` tokens from `account`, reducing the
362      * total supply.
363      *
364      * Emits a {Transfer} event with `to` set to the zero address.
365      *
366      * Requirements:
367      *
368      * - `account` cannot be the zero address.
369      * - `account` must have at least `amount` tokens.
370      */
371     function _burn(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: burn from the zero address");
373 
374         _beforeTokenTransfer(account, address(0), amount);
375 
376         uint256 accountBalance = _balances[account];
377         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
378         _balances[account] = accountBalance - amount;
379         _totalSupply -= amount;
380 
381         emit Transfer(account, address(0), amount);
382     }
383 
384     /**
385      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
386      *
387      * This internal function is equivalent to `approve`, and can be used to
388      * e.g. set automatic allowances for certain subsystems, etc.
389      *
390      * Emits an {Approval} event.
391      *
392      * Requirements:
393      *
394      * - `owner` cannot be the zero address.
395      * - `spender` cannot be the zero address.
396      */
397     function _approve(address owner, address spender, uint256 amount) internal virtual {
398         require(owner != address(0), "ERC20: approve from the zero address");
399         require(spender != address(0), "ERC20: approve to the zero address");
400 
401         _allowances[owner][spender] = amount;
402         emit Approval(owner, spender, amount);
403     }
404 
405     /**
406      * @dev Hook that is called before any transfer of tokens. This includes
407      * minting and burning.
408      *
409      * Calling conditions:
410      *
411      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
412      * will be to transferred to `to`.
413      * - when `from` is zero, `amount` tokens will be minted for `to`.
414      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
415      * - `from` and `to` are never both zero.
416      *
417      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
418      */
419     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
420 }
421 
422 contract DOOR is ERC20 {
423     constructor() ERC20("DOOR", "DOOR") {
424         uint256 initialSupply = 4000000000 * (10 ** 18);
425         _mint(msg.sender, initialSupply);
426     }
427 }