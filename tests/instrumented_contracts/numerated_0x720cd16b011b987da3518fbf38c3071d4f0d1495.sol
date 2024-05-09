1 /**
2  * Flux (FLUX)
3  * Run On Flux
4  * runonflux.io home.runonflux.io api.runonflux.io docs.runonflux.io
5  */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
153     mapping (address => uint256) private _balances;
154 
155     mapping (address => mapping (address => uint256)) private _allowances;
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
171     constructor (string memory name_, string memory symbol_) {
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
267     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
268         _transfer(sender, recipient, amount);
269 
270         uint256 currentAllowance = _allowances[sender][_msgSender()];
271         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
272         _approve(sender, _msgSender(), currentAllowance - amount);
273 
274         return true;
275     }
276 
277     /**
278      * @dev Atomically increases the allowance granted to `spender` by the caller.
279      *
280      * This is an alternative to {approve} that can be used as a mitigation for
281      * problems described in {IERC20-approve}.
282      *
283      * Emits an {Approval} event indicating the updated allowance.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
290         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
291         return true;
292     }
293 
294     /**
295      * @dev Atomically decreases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to {approve} that can be used as a mitigation for
298      * problems described in {IERC20-approve}.
299      *
300      * Emits an {Approval} event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      * - `spender` must have allowance for the caller of at least
306      * `subtractedValue`.
307      */
308     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
309         uint256 currentAllowance = _allowances[_msgSender()][spender];
310         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
311         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
312 
313         return true;
314     }
315 
316     /**
317      * @dev Moves tokens `amount` from `sender` to `recipient`.
318      *
319      * This is internal function is equivalent to {transfer}, and can be used to
320      * e.g. implement automatic token fees, slashing mechanisms, etc.
321      *
322      * Emits a {Transfer} event.
323      *
324      * Requirements:
325      *
326      * - `sender` cannot be the zero address.
327      * - `recipient` cannot be the zero address.
328      * - `sender` must have a balance of at least `amount`.
329      */
330     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
331         require(sender != address(0), "ERC20: transfer from the zero address");
332         require(recipient != address(0), "ERC20: transfer to the zero address");
333 
334         _beforeTokenTransfer(sender, recipient, amount);
335 
336         uint256 senderBalance = _balances[sender];
337         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
338         _balances[sender] = senderBalance - amount;
339         _balances[recipient] += amount;
340 
341         emit Transfer(sender, recipient, amount);
342     }
343 
344     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
345      * the total supply.
346      *
347      * Emits a {Transfer} event with `from` set to the zero address.
348      *
349      * Requirements:
350      *
351      * - `to` cannot be the zero address.
352      */
353     function _mint(address account, uint256 amount) internal virtual {
354         require(account != address(0), "ERC20: mint to the zero address");
355 
356         _beforeTokenTransfer(address(0), account, amount);
357 
358         _totalSupply += amount;
359         _balances[account] += amount;
360         emit Transfer(address(0), account, amount);
361     }
362 
363     /**
364      * @dev Destroys `amount` tokens from `account`, reducing the
365      * total supply.
366      *
367      * Emits a {Transfer} event with `to` set to the zero address.
368      *
369      * Requirements:
370      *
371      * - `account` cannot be the zero address.
372      * - `account` must have at least `amount` tokens.
373      */
374     function _burn(address account, uint256 amount) internal virtual {
375         require(account != address(0), "ERC20: burn from the zero address");
376 
377         _beforeTokenTransfer(account, address(0), amount);
378 
379         uint256 accountBalance = _balances[account];
380         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
381         _balances[account] = accountBalance - amount;
382         _totalSupply -= amount;
383 
384         emit Transfer(account, address(0), amount);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
389      *
390      * This internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an {Approval} event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(address owner, address spender, uint256 amount) internal virtual {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = amount;
405         emit Approval(owner, spender, amount);
406     }
407 
408     /**
409      * @dev Hook that is called before any transfer of tokens. This includes
410      * minting and burning.
411      *
412      * Calling conditions:
413      *
414      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
415      * will be to transferred to `to`.
416      * - when `from` is zero, `amount` tokens will be minted for `to`.
417      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
418      * - `from` and `to` are never both zero.
419      *
420      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
421      */
422     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
423 }
424 
425 contract Flux is ERC20 {
426     constructor() ERC20("Flux", "FLUX") {
427         _mint(msg.sender, 440000000 * 10 ** decimals());
428     }
429     
430     function decimals() public view virtual override returns (uint8) {
431         return 8;
432     }
433 }