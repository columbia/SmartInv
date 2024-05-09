1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.6;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 /**
80  * @dev Interface for the optional metadata functions from the ERC20 standard.
81  *
82  * _Available since v4.1._
83  */
84 interface IERC20Metadata is IERC20 {
85     /**
86      * @dev Returns the name of the token.
87      */
88     function name() external view returns (string memory);
89 
90     /**
91      * @dev Returns the symbol of the token.
92      */
93     function symbol() external view returns (string memory);
94 
95     /**
96      * @dev Returns the decimals places of the token.
97      */
98     function decimals() external view returns (uint8);
99 }
100 
101 
102 /*
103  * @dev Provides information about the current execution context, including the
104  * sender of the transaction and its data. While these are generally available
105  * via msg.sender and msg.data, they should not be accessed in such a direct
106  * manner, since when dealing with meta-transactions the account sending and
107  * paying for execution may not be the actual sender (as far as an application
108  * is concerned).
109  *
110  * This contract is only required for intermediate, library-like contracts.
111  */
112 abstract contract Context {
113     function _msgSender() internal view virtual returns (address) {
114         return msg.sender;
115     }
116 
117     function _msgData() internal view virtual returns (bytes calldata) {
118         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
119         return msg.data;
120     }
121 }
122 
123 /**
124  * @dev Implementation of the {IERC20} interface.
125  *
126  * This implementation is agnostic to the way tokens are created. This means
127  * that a supply mechanism has to be added in a derived contract using {_mint}.
128  * For a generic mechanism see {ERC20PresetMinterPauser}.
129  *
130  * TIP: For a detailed writeup see our guide
131  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
132  * to implement supply mechanisms].
133  *
134  * We have followed general OpenZeppelin guidelines: functions revert instead
135  * of returning `false` on failure. This behavior is nonetheless conventional
136  * and does not conflict with the expectations of ERC20 applications.
137  *
138  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
139  * This allows applications to reconstruct the allowance for all accounts just
140  * by listening to said events. Other implementations of the EIP may not emit
141  * these events, as it isn't required by the specification.
142  *
143  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
144  * functions have been added to mitigate the well-known issues around setting
145  * allowances. See {IERC20-approve}.
146  */
147 contract ERC20 is Context, IERC20, IERC20Metadata {
148     mapping (address => uint256) private _balances;
149 
150     mapping (address => mapping (address => uint256)) private _allowances;
151 
152     uint256 private _totalSupply;
153 
154     string private _name;
155     string private _symbol;
156 
157     /**
158      * @dev Sets the values for {name} and {symbol}.
159      *
160      * The defaut value of {decimals} is 18. To select a different value for
161      * {decimals} you should overload it.
162      *
163      * All two of these values are immutable: they can only be set once during
164      * construction.
165      */
166     constructor (string memory name_, string memory symbol_) {
167         _name = name_;
168         _symbol = symbol_;
169     }
170 
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() public view virtual override returns (string memory) {
175         return _name;
176     }
177 
178     /**
179      * @dev Returns the symbol of the token, usually a shorter version of the
180      * name.
181      */
182     function symbol() public view virtual override returns (string memory) {
183         return _symbol;
184     }
185 
186     /**
187      * @dev Returns the number of decimals used to get its user representation.
188      * For example, if `decimals` equals `2`, a balance of `505` tokens should
189      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
190      *
191      * Tokens usually opt for a value of 18, imitating the relationship between
192      * Ether and Wei. This is the value {ERC20} uses, unless this function is
193      * overridden;
194      *
195      * NOTE: This information is only used for _display_ purposes: it in
196      * no way affects any of the arithmetic of the contract, including
197      * {IERC20-balanceOf} and {IERC20-transfer}.
198      */
199     function decimals() public view virtual override returns (uint8) {
200         return 18;
201     }
202 
203     /**
204      * @dev See {IERC20-totalSupply}.
205      */
206     function totalSupply() public view virtual override returns (uint256) {
207         return _totalSupply;
208     }
209 
210     /**
211      * @dev See {IERC20-balanceOf}.
212      */
213     function balanceOf(address account) public view virtual override returns (uint256) {
214         return _balances[account];
215     }
216 
217     /**
218      * @dev See {IERC20-transfer}.
219      *
220      * Requirements:
221      *
222      * - `recipient` cannot be the zero address.
223      * - the caller must have a balance of at least `amount`.
224      */
225     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229 
230     /**
231      * @dev See {IERC20-allowance}.
232      */
233     function allowance(address owner, address spender) public view virtual override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     /**
238      * @dev See {IERC20-approve}.
239      *
240      * Requirements:
241      *
242      * - `spender` cannot be the zero address.
243      */
244     function approve(address spender, uint256 amount) public virtual override returns (bool) {
245         _approve(_msgSender(), spender, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See {IERC20-transferFrom}.
251      *
252      * Emits an {Approval} event indicating the updated allowance. This is not
253      * required by the EIP. See the note at the beginning of {ERC20}.
254      *
255      * Requirements:
256      *
257      * - `sender` and `recipient` cannot be the zero address.
258      * - `sender` must have a balance of at least `amount`.
259      * - the caller must have allowance for ``sender``'s tokens of at least
260      * `amount`.
261      */
262     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
263         _transfer(sender, recipient, amount);
264 
265         uint256 currentAllowance = _allowances[sender][_msgSender()];
266         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
267         _approve(sender, _msgSender(), currentAllowance - amount);
268 
269         return true;
270     }
271 
272     /**
273      * @dev Atomically increases the allowance granted to `spender` by the caller.
274      *
275      * This is an alternative to {approve} that can be used as a mitigation for
276      * problems described in {IERC20-approve}.
277      *
278      * Emits an {Approval} event indicating the updated allowance.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
285         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
286         return true;
287     }
288 
289     /**
290      * @dev Atomically decreases the allowance granted to `spender` by the caller.
291      *
292      * This is an alternative to {approve} that can be used as a mitigation for
293      * problems described in {IERC20-approve}.
294      *
295      * Emits an {Approval} event indicating the updated allowance.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      * - `spender` must have allowance for the caller of at least
301      * `subtractedValue`.
302      */
303     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
304         uint256 currentAllowance = _allowances[_msgSender()][spender];
305         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
306         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
307 
308         return true;
309     }
310 
311     /**
312      * @dev Moves tokens `amount` from `sender` to `recipient`.
313      *
314      * This is internal function is equivalent to {transfer}, and can be used to
315      * e.g. implement automatic token fees, slashing mechanisms, etc.
316      *
317      * Emits a {Transfer} event.
318      *
319      * Requirements:
320      *
321      * - `sender` cannot be the zero address.
322      * - `recipient` cannot be the zero address.
323      * - `sender` must have a balance of at least `amount`.
324      */
325     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
326         require(sender != address(0), "ERC20: transfer from the zero address");
327         require(recipient != address(0), "ERC20: transfer to the zero address");
328 
329         _beforeTokenTransfer(sender, recipient, amount);
330 
331         uint256 senderBalance = _balances[sender];
332         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
333         _balances[sender] = senderBalance - amount;
334         _balances[recipient] += amount;
335 
336         emit Transfer(sender, recipient, amount);
337     }
338 
339     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
340      * the total supply.
341      *
342      * Emits a {Transfer} event with `from` set to the zero address.
343      *
344      * Requirements:
345      *
346      * - `to` cannot be the zero address.
347      */
348     function _mint(address account, uint256 amount) internal virtual {
349         require(account != address(0), "ERC20: mint to the zero address");
350 
351         _beforeTokenTransfer(address(0), account, amount);
352 
353         _totalSupply += amount;
354         _balances[account] += amount;
355         emit Transfer(address(0), account, amount);
356     }
357 
358     /**
359      * @dev Destroys `amount` tokens from `account`, reducing the
360      * total supply.
361      *
362      * Emits a {Transfer} event with `to` set to the zero address.
363      *
364      * Requirements:
365      *
366      * - `account` cannot be the zero address.
367      * - `account` must have at least `amount` tokens.
368      */
369     function _burn(address account, uint256 amount) internal virtual {
370         require(account != address(0), "ERC20: burn from the zero address");
371 
372         _beforeTokenTransfer(account, address(0), amount);
373 
374         uint256 accountBalance = _balances[account];
375         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
376         _balances[account] = accountBalance - amount;
377         _totalSupply -= amount;
378 
379         emit Transfer(account, address(0), amount);
380     }
381 
382     /**
383      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
384      *
385      * This internal function is equivalent to `approve`, and can be used to
386      * e.g. set automatic allowances for certain subsystems, etc.
387      *
388      * Emits an {Approval} event.
389      *
390      * Requirements:
391      *
392      * - `owner` cannot be the zero address.
393      * - `spender` cannot be the zero address.
394      */
395     function _approve(address owner, address spender, uint256 amount) internal virtual {
396         require(owner != address(0), "ERC20: approve from the zero address");
397         require(spender != address(0), "ERC20: approve to the zero address");
398 
399         _allowances[owner][spender] = amount;
400         emit Approval(owner, spender, amount);
401     }
402 
403     /**
404      * @dev Hook that is called before any transfer of tokens. This includes
405      * minting and burning.
406      *
407      * Calling conditions:
408      *
409      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
410      * will be to transferred to `to`.
411      * - when `from` is zero, `amount` tokens will be minted for `to`.
412      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
413      * - `from` and `to` are never both zero.
414      *
415      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
416      */
417     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
418 }
419 
420 
421 contract EqiToken is ERC20 {
422 
423     /**
424      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
425      *
426      * See {ERC20-constructor}.
427      */
428     constructor(
429         string memory name,
430         string memory symbol,
431         uint256 initialSupply,
432         address owner
433     ) ERC20(name, symbol) {
434         _mint(owner, initialSupply);
435     }
436 }