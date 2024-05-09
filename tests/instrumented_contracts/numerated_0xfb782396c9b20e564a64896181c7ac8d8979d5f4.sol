1 // Sources flattened with hardhat v2.2.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.1.0
85 
86 // SPD-License-Identifier: MIT
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 
113 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
114 
115 // SPD-License-Identifier: MIT
116 
117 pragma solidity ^0.8.0;
118 
119 /*
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133 
134     function _msgData() internal view virtual returns (bytes calldata) {
135         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
136         return msg.data;
137     }
138 }
139 
140 
141 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.1.0
142 
143 // SPD-License-Identifier: MIT
144 
145 pragma solidity ^0.8.0;
146 
147 
148 
149 /**
150  * @dev Implementation of the {IERC20} interface.
151  *
152  * This implementation is agnostic to the way tokens are created. This means
153  * that a supply mechanism has to be added in a derived contract using {_mint}.
154  * For a generic mechanism see {ERC20PresetMinterPauser}.
155  *
156  * TIP: For a detailed writeup see our guide
157  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
158  * to implement supply mechanisms].
159  *
160  * We have followed general OpenZeppelin guidelines: functions revert instead
161  * of returning `false` on failure. This behavior is nonetheless conventional
162  * and does not conflict with the expectations of ERC20 applications.
163  *
164  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
165  * This allows applications to reconstruct the allowance for all accounts just
166  * by listening to said events. Other implementations of the EIP may not emit
167  * these events, as it isn't required by the specification.
168  *
169  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
170  * functions have been added to mitigate the well-known issues around setting
171  * allowances. See {IERC20-approve}.
172  */
173 contract ERC20 is Context, IERC20, IERC20Metadata {
174     mapping (address => uint256) private _balances;
175 
176     mapping (address => mapping (address => uint256)) private _allowances;
177 
178     uint256 private _totalSupply;
179 
180     string private _name;
181     string private _symbol;
182 
183     /**
184      * @dev Sets the values for {name} and {symbol}.
185      *
186      * The defaut value of {decimals} is 18. To select a different value for
187      * {decimals} you should overload it.
188      *
189      * All two of these values are immutable: they can only be set once during
190      * construction.
191      */
192     constructor (string memory name_, string memory symbol_) {
193         _name = name_;
194         _symbol = symbol_;
195     }
196 
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() public view virtual override returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @dev Returns the symbol of the token, usually a shorter version of the
206      * name.
207      */
208     function symbol() public view virtual override returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @dev Returns the number of decimals used to get its user representation.
214      * For example, if `decimals` equals `2`, a balance of `505` tokens should
215      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
216      *
217      * Tokens usually opt for a value of 18, imitating the relationship between
218      * Ether and Wei. This is the value {ERC20} uses, unless this function is
219      * overridden;
220      *
221      * NOTE: This information is only used for _display_ purposes: it in
222      * no way affects any of the arithmetic of the contract, including
223      * {IERC20-balanceOf} and {IERC20-transfer}.
224      */
225     function decimals() public view virtual override returns (uint8) {
226         return 18;
227     }
228 
229     /**
230      * @dev See {IERC20-totalSupply}.
231      */
232     function totalSupply() public view virtual override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See {IERC20-balanceOf}.
238      */
239     function balanceOf(address account) public view virtual override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See {IERC20-transfer}.
245      *
246      * Requirements:
247      *
248      * - `recipient` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-allowance}.
258      */
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See {IERC20-approve}.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 amount) public virtual override returns (bool) {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-transferFrom}.
277      *
278      * Emits an {Approval} event indicating the updated allowance. This is not
279      * required by the EIP. See the note at the beginning of {ERC20}.
280      *
281      * Requirements:
282      *
283      * - `sender` and `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `amount`.
285      * - the caller must have allowance for ``sender``'s tokens of at least
286      * `amount`.
287      */
288     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
289         _transfer(sender, recipient, amount);
290 
291         uint256 currentAllowance = _allowances[sender][_msgSender()];
292         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
293         _approve(sender, _msgSender(), currentAllowance - amount);
294 
295         return true;
296     }
297 
298     /**
299      * @dev Atomically increases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to {approve} that can be used as a mitigation for
302      * problems described in {IERC20-approve}.
303      *
304      * Emits an {Approval} event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      */
310     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
311         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
312         return true;
313     }
314 
315     /**
316      * @dev Atomically decreases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      * - `spender` must have allowance for the caller of at least
327      * `subtractedValue`.
328      */
329     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
330         uint256 currentAllowance = _allowances[_msgSender()][spender];
331         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
332         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
333 
334         return true;
335     }
336 
337     /**
338      * @dev Moves tokens `amount` from `sender` to `recipient`.
339      *
340      * This is internal function is equivalent to {transfer}, and can be used to
341      * e.g. implement automatic token fees, slashing mechanisms, etc.
342      *
343      * Emits a {Transfer} event.
344      *
345      * Requirements:
346      *
347      * - `sender` cannot be the zero address.
348      * - `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      */
351     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
352         require(sender != address(0), "ERC20: transfer from the zero address");
353         require(recipient != address(0), "ERC20: transfer to the zero address");
354 
355         _beforeTokenTransfer(sender, recipient, amount);
356 
357         uint256 senderBalance = _balances[sender];
358         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
359         _balances[sender] = senderBalance - amount;
360         _balances[recipient] += amount;
361 
362         emit Transfer(sender, recipient, amount);
363     }
364 
365     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
366      * the total supply.
367      *
368      * Emits a {Transfer} event with `from` set to the zero address.
369      *
370      * Requirements:
371      *
372      * - `to` cannot be the zero address.
373      */
374     function _mint(address account, uint256 amount) internal virtual {
375         require(account != address(0), "ERC20: mint to the zero address");
376 
377         _beforeTokenTransfer(address(0), account, amount);
378 
379         _totalSupply += amount;
380         _balances[account] += amount;
381         emit Transfer(address(0), account, amount);
382     }
383 
384     /**
385      * @dev Destroys `amount` tokens from `account`, reducing the
386      * total supply.
387      *
388      * Emits a {Transfer} event with `to` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      * - `account` must have at least `amount` tokens.
394      */
395     function _burn(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: burn from the zero address");
397 
398         _beforeTokenTransfer(account, address(0), amount);
399 
400         uint256 accountBalance = _balances[account];
401         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
402         _balances[account] = accountBalance - amount;
403         _totalSupply -= amount;
404 
405         emit Transfer(account, address(0), amount);
406     }
407 
408     /**
409      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
410      *
411      * This internal function is equivalent to `approve`, and can be used to
412      * e.g. set automatic allowances for certain subsystems, etc.
413      *
414      * Emits an {Approval} event.
415      *
416      * Requirements:
417      *
418      * - `owner` cannot be the zero address.
419      * - `spender` cannot be the zero address.
420      */
421     function _approve(address owner, address spender, uint256 amount) internal virtual {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424 
425         _allowances[owner][spender] = amount;
426         emit Approval(owner, spender, amount);
427     }
428 
429     /**
430      * @dev Hook that is called before any transfer of tokens. This includes
431      * minting and burning.
432      *
433      * Calling conditions:
434      *
435      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
436      * will be to transferred to `to`.
437      * - when `from` is zero, `amount` tokens will be minted for `to`.
438      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
439      * - `from` and `to` are never both zero.
440      *
441      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
442      */
443     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
444 }
445 
446 
447 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.1.0
448 
449 // SPD-License-Identifier: MIT
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Extension of {ERC20} that allows token holders to destroy both their own
456  * tokens and those that they have an allowance for, in a way that can be
457  * recognized off-chain (via event analysis).
458  */
459 abstract contract ERC20Burnable is Context, ERC20 {
460     /**
461      * @dev Destroys `amount` tokens from the caller.
462      *
463      * See {ERC20-_burn}.
464      */
465     function burn(uint256 amount) public virtual {
466         _burn(_msgSender(), amount);
467     }
468 
469     /**
470      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
471      * allowance.
472      *
473      * See {ERC20-_burn} and {ERC20-allowance}.
474      *
475      * Requirements:
476      *
477      * - the caller must have allowance for ``accounts``'s tokens of at least
478      * `amount`.
479      */
480     function burnFrom(address account, uint256 amount) public virtual {
481         uint256 currentAllowance = allowance(account, _msgSender());
482         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
483         _approve(account, _msgSender(), currentAllowance - amount);
484         _burn(account, amount);
485     }
486 }
487 
488 
489 // File contracts/token/Diver.sol
490 
491 // SPD-License-Identifier: MIT
492 
493 pragma solidity ^0.8.0;
494 
495 contract Diver is ERC20Burnable {
496     constructor() ERC20("DivergenceProtocol", "DIVER") {
497         _mint(msg.sender, 1000000000e18);
498     }
499 
500     function _beforeTokenTransfer(
501         address from,
502         address to,
503         uint256 amount
504     ) internal override {
505         super._beforeTokenTransfer(from, to, amount);
506         require(to != address(this), "Diver::address to is token contract");
507     }
508 }