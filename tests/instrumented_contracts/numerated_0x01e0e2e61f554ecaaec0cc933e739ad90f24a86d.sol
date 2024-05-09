1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @dev Interface for the optional metadata functions from the ERC20 standard.
101  *
102  * _Available since v4.1._
103  */
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 /**
122  * @dev Implementation of the {IERC20} interface.
123  *
124  * This implementation is agnostic to the way tokens are created. This means
125  * that a supply mechanism has to be added in a derived contract using {_mint}.
126  * For a generic mechanism see {ERC20PresetMinterPauser}.
127  *
128  * TIP: For a detailed writeup see our guide
129  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
130  * to implement supply mechanisms].
131  *
132  * We have followed general OpenZeppelin guidelines: functions revert instead
133  * of returning `false` on failure. This behavior is nonetheless conventional
134  * and does not conflict with the expectations of ERC20 applications.
135  *
136  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
137  * This allows applications to reconstruct the allowance for all accounts just
138  * by listening to said events. Other implementations of the EIP may not emit
139  * these events, as it isn't required by the specification.
140  *
141  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
142  * functions have been added to mitigate the well-known issues around setting
143  * allowances. See {IERC20-approve}.
144  */
145 contract ERC20 is Context, IERC20, IERC20Metadata {
146     mapping (address => uint256) private _balances;
147 
148     mapping (address => mapping (address => uint256)) private _allowances;
149 
150     uint256 private _totalSupply;
151 
152     string private _name;
153     string private _symbol;
154 
155     /**
156      * @dev Sets the values for {name} and {symbol}.
157      *
158      * The defaut value of {decimals} is 18. To select a different value for
159      * {decimals} you should overload it.
160      *
161      * All two of these values are immutable: they can only be set once during
162      * construction.
163      */
164     constructor (string memory name_, string memory symbol_) {
165         _name = name_;
166         _symbol = symbol_;
167     }
168 
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() public view virtual override returns (string memory) {
173         return _name;
174     }
175 
176     /**
177      * @dev Returns the symbol of the token, usually a shorter version of the
178      * name.
179      */
180     function symbol() public view virtual override returns (string memory) {
181         return _symbol;
182     }
183 
184     /**
185      * @dev Returns the number of decimals used to get its user representation.
186      * For example, if `decimals` equals `2`, a balance of `505` tokens should
187      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
188      *
189      * Tokens usually opt for a value of 18, imitating the relationship between
190      * Ether and Wei. This is the value {ERC20} uses, unless this function is
191      * overridden;
192      *
193      * NOTE: This information is only used for _display_ purposes: it in
194      * no way affects any of the arithmetic of the contract, including
195      * {IERC20-balanceOf} and {IERC20-transfer}.
196      */
197     function decimals() public view virtual override returns (uint8) {
198         return 18;
199     }
200 
201     /**
202      * @dev See {IERC20-totalSupply}.
203      */
204     function totalSupply() public view virtual override returns (uint256) {
205         return _totalSupply;
206     }
207 
208     /**
209      * @dev See {IERC20-balanceOf}.
210      */
211     function balanceOf(address account) public view virtual override returns (uint256) {
212         return _balances[account];
213     }
214 
215     /**
216      * @dev See {IERC20-transfer}.
217      *
218      * Requirements:
219      *
220      * - `recipient` cannot be the zero address.
221      * - the caller must have a balance of at least `amount`.
222      */
223     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
224         _transfer(_msgSender(), recipient, amount);
225         return true;
226     }
227 
228     /**
229      * @dev See {IERC20-allowance}.
230      */
231     function allowance(address owner, address spender) public view virtual override returns (uint256) {
232         return _allowances[owner][spender];
233     }
234 
235     /**
236      * @dev See {IERC20-approve}.
237      *
238      * Requirements:
239      *
240      * - `spender` cannot be the zero address.
241      */
242     function approve(address spender, uint256 amount) public virtual override returns (bool) {
243         _approve(_msgSender(), spender, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See {IERC20-transferFrom}.
249      *
250      * Emits an {Approval} event indicating the updated allowance. This is not
251      * required by the EIP. See the note at the beginning of {ERC20}.
252      *
253      * Requirements:
254      *
255      * - `sender` and `recipient` cannot be the zero address.
256      * - `sender` must have a balance of at least `amount`.
257      * - the caller must have allowance for ``sender``'s tokens of at least
258      * `amount`.
259      */
260     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(sender, recipient, amount);
262 
263         uint256 currentAllowance = _allowances[sender][_msgSender()];
264         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
265         _approve(sender, _msgSender(), currentAllowance - amount);
266 
267         return true;
268     }
269 
270     /**
271      * @dev Atomically increases the allowance granted to `spender` by the caller.
272      *
273      * This is an alternative to {approve} that can be used as a mitigation for
274      * problems described in {IERC20-approve}.
275      *
276      * Emits an {Approval} event indicating the updated allowance.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
283         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
284         return true;
285     }
286 
287     /**
288      * @dev Atomically decreases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      * - `spender` must have allowance for the caller of at least
299      * `subtractedValue`.
300      */
301     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
302         uint256 currentAllowance = _allowances[_msgSender()][spender];
303         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
304         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
305 
306         return true;
307     }
308 
309     /**
310      * @dev Moves tokens `amount` from `sender` to `recipient`.
311      *
312      * This is internal function is equivalent to {transfer}, and can be used to
313      * e.g. implement automatic token fees, slashing mechanisms, etc.
314      *
315      * Emits a {Transfer} event.
316      *
317      * Requirements:
318      *
319      * - `sender` cannot be the zero address.
320      * - `recipient` cannot be the zero address.
321      * - `sender` must have a balance of at least `amount`.
322      */
323     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
324         require(sender != address(0), "ERC20: transfer from the zero address");
325         require(recipient != address(0), "ERC20: transfer to the zero address");
326 
327         _beforeTokenTransfer(sender, recipient, amount);
328 
329         uint256 senderBalance = _balances[sender];
330         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
331         _balances[sender] = senderBalance - amount;
332         _balances[recipient] += amount;
333 
334         emit Transfer(sender, recipient, amount);
335     }
336 
337     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
338      * the total supply.
339      *
340      * Emits a {Transfer} event with `from` set to the zero address.
341      *
342      * Requirements:
343      *
344      * - `to` cannot be the zero address.
345      */
346     function _mint(address account, uint256 amount) internal virtual {
347         require(account != address(0), "ERC20: mint to the zero address");
348 
349         _beforeTokenTransfer(address(0), account, amount);
350 
351         _totalSupply += amount;
352         _balances[account] += amount;
353         emit Transfer(address(0), account, amount);
354     }
355 
356     /**
357      * @dev Destroys `amount` tokens from `account`, reducing the
358      * total supply.
359      *
360      * Emits a {Transfer} event with `to` set to the zero address.
361      *
362      * Requirements:
363      *
364      * - `account` cannot be the zero address.
365      * - `account` must have at least `amount` tokens.
366      */
367     function _burn(address account, uint256 amount) internal virtual {
368         require(account != address(0), "ERC20: burn from the zero address");
369 
370         _beforeTokenTransfer(account, address(0), amount);
371 
372         uint256 accountBalance = _balances[account];
373         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
374         _balances[account] = accountBalance - amount;
375         _totalSupply -= amount;
376 
377         emit Transfer(account, address(0), amount);
378     }
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
382      *
383      * This internal function is equivalent to `approve`, and can be used to
384      * e.g. set automatic allowances for certain subsystems, etc.
385      *
386      * Emits an {Approval} event.
387      *
388      * Requirements:
389      *
390      * - `owner` cannot be the zero address.
391      * - `spender` cannot be the zero address.
392      */
393     function _approve(address owner, address spender, uint256 amount) internal virtual {
394         require(owner != address(0), "ERC20: approve from the zero address");
395         require(spender != address(0), "ERC20: approve to the zero address");
396 
397         _allowances[owner][spender] = amount;
398         emit Approval(owner, spender, amount);
399     }
400 
401     /**
402      * @dev Hook that is called before any transfer of tokens. This includes
403      * minting and burning.
404      *
405      * Calling conditions:
406      *
407      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
408      * will be to transferred to `to`.
409      * - when `from` is zero, `amount` tokens will be minted for `to`.
410      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
411      * - `from` and `to` are never both zero.
412      *
413      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
414      */
415     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
416 }
417 
418 /**
419  * @dev Extension of {ERC20} that allows token holders to destroy both their own
420  * tokens and those that they have an allowance for, in a way that can be
421  * recognized off-chain (via event analysis).
422  */
423 abstract contract ERC20Burnable is Context, ERC20 {
424     /**
425      * @dev Destroys `amount` tokens from the caller.
426      *
427      * See {ERC20-_burn}.
428      */
429     function burn(uint256 amount) public virtual {
430         _burn(_msgSender(), amount);
431     }
432 
433     /**
434      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
435      * allowance.
436      *
437      * See {ERC20-_burn} and {ERC20-allowance}.
438      *
439      * Requirements:
440      *
441      * - the caller must have allowance for ``accounts``'s tokens of at least
442      * `amount`.
443      */
444     function burnFrom(address account, uint256 amount) public virtual {
445         uint256 currentAllowance = allowance(account, _msgSender());
446         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
447         _approve(account, _msgSender(), currentAllowance - amount);
448         _burn(account, amount);
449     }
450 }
451 
452 /**
453  * @dev {ERC20} token, including:
454  *
455  *  - Preminted initial supply
456  *  - Ability for holders to burn (destroy) their tokens
457  *  - No access control mechanism (for minting/pausing) and hence no governance
458  *
459  * This contract uses {ERC20Burnable} to include burn capabilities - head to
460  * its documentation for details.
461  *
462  * _Available since v3.4._
463  */
464 contract ERC20PresetFixedSupply is ERC20Burnable {
465     /**
466      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
467      *
468      * See {ERC20-constructor}.
469      */
470     constructor(
471         string memory name,
472         string memory symbol,
473         uint256 initialSupply,
474         address owner
475     ) ERC20(name, symbol) {
476         _mint(owner, initialSupply);
477     }
478 }