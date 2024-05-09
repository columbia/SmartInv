1 /**
2 */
3 
4 // SPDX-License-Identifier: MIT
5 
6 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
7 
8 
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
87 
88 
89 
90 pragma solidity ^0.8.0;
91 
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 // File: @openzeppelin/contracts/utils/Context.sol
116 
117 
118 
119 pragma solidity ^0.8.0;
120 
121 /*
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
138         return msg.data;
139     }
140 }
141 
142 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
143 
144 
145 
146 pragma solidity ^0.8.0;
147 
148 
149 
150 
151 /**
152  * @dev Implementation of the {IERC20} interface.
153  *
154  * This implementation is agnostic to the way tokens are created. This means
155  * that a supply mechanism has to be added in a derived contract using {_mint}.
156  * For a generic mechanism see {ERC20PresetMinterPauser}.
157  *
158  * TIP: For a detailed writeup see our guide
159  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
160  * to implement supply mechanisms].
161  *
162  * We have followed general OpenZeppelin guidelines: functions revert instead
163  * of returning `false` on failure. This behavior is nonetheless conventional
164  * and does not conflict with the expectations of ERC20 applications.
165  *
166  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
167  * This allows applications to reconstruct the allowance for all accounts just
168  * by listening to said events. Other implementations of the EIP may not emit
169  * these events, as it isn't required by the specification.
170  *
171  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
172  * functions have been added to mitigate the well-known issues around setting
173  * allowances. See {IERC20-approve}.
174  */
175 contract ERC20 is Context, IERC20, IERC20Metadata {
176     mapping (address => uint256) private _balances;
177 
178     mapping (address => mapping (address => uint256)) private _allowances;
179 
180     uint256 private _totalSupply;
181 
182     string private _name;
183     string private _symbol;
184 
185     /**
186      * @dev Sets the values for {name} and {symbol}.
187      *
188      * The defaut value of {decimals} is 18. To select a different value for
189      * {decimals} you should overload it.
190      *
191      * All two of these values are immutable: they can only be set once during
192      * construction.
193      */
194     constructor (string memory name_, string memory symbol_) {
195         _name = name_;
196         _symbol = symbol_;
197     }
198 
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() public view virtual override returns (string memory) {
203         return _name;
204     }
205 
206     /**
207      * @dev Returns the symbol of the token, usually a shorter version of the
208      * name.
209      */
210     function symbol() public view virtual override returns (string memory) {
211         return _symbol;
212     }
213 
214     /**
215      * @dev Returns the number of decimals used to get its user representation.
216      * For example, if `decimals` equals `2`, a balance of `505` tokens should
217      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
218      *
219      * Tokens usually opt for a value of 18, imitating the relationship between
220      * Ether and Wei. This is the value {ERC20} uses, unless this function is
221      * overridden;
222      *
223      * NOTE: This information is only used for _display_ purposes: it in
224      * no way affects any of the arithmetic of the contract, including
225      * {IERC20-balanceOf} and {IERC20-transfer}.
226      */
227     function decimals() public view virtual override returns (uint8) {
228         return 18;
229     }
230 
231     /**
232      * @dev See {IERC20-totalSupply}.
233      */
234     function totalSupply() public view virtual override returns (uint256) {
235         return _totalSupply;
236     }
237 
238     /**
239      * @dev See {IERC20-balanceOf}.
240      */
241     function balanceOf(address account) public view virtual override returns (uint256) {
242         return _balances[account];
243     }
244 
245     /**
246      * @dev See {IERC20-transfer}.
247      *
248      * Requirements:
249      *
250      * - `recipient` cannot be the zero address.
251      * - the caller must have a balance of at least `amount`.
252      */
253     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
254         _transfer(_msgSender(), recipient, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      */
272     function approve(address spender, uint256 amount) public virtual override returns (bool) {
273         _approve(_msgSender(), spender, amount);
274         return true;
275     }
276 
277     /**
278      * @dev See {IERC20-transferFrom}.
279      *
280      * Emits an {Approval} event indicating the updated allowance. This is not
281      * required by the EIP. See the note at the beginning of {ERC20}.
282      *
283      * Requirements:
284      *
285      * - `sender` and `recipient` cannot be the zero address.
286      * - `sender` must have a balance of at least `amount`.
287      * - the caller must have allowance for ``sender``'s tokens of at least
288      * `amount`.
289      */
290     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
291         _transfer(sender, recipient, amount);
292 
293         uint256 currentAllowance = _allowances[sender][_msgSender()];
294         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
295         _approve(sender, _msgSender(), currentAllowance - amount);
296 
297         return true;
298     }
299 
300     /**
301      * @dev Atomically increases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to {approve} that can be used as a mitigation for
304      * problems described in {IERC20-approve}.
305      *
306      * Emits an {Approval} event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
313         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
314         return true;
315     }
316 
317     /**
318      * @dev Atomically decreases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      * - `spender` must have allowance for the caller of at least
329      * `subtractedValue`.
330      */
331     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
332         uint256 currentAllowance = _allowances[_msgSender()][spender];
333         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
334         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
335 
336         return true;
337     }
338 
339     /**
340      * @dev Moves tokens `amount` from `sender` to `recipient`.
341      *
342      * This is internal function is equivalent to {transfer}, and can be used to
343      * e.g. implement automatic token fees, slashing mechanisms, etc.
344      *
345      * Emits a {Transfer} event.
346      *
347      * Requirements:
348      *
349      * - `sender` cannot be the zero address.
350      * - `recipient` cannot be the zero address.
351      * - `sender` must have a balance of at least `amount`.
352      */
353     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
354         require(sender != address(0), "ERC20: transfer from the zero address");
355         require(recipient != address(0), "ERC20: transfer to the zero address");
356 
357         _beforeTokenTransfer(sender, recipient, amount);
358 
359         uint256 senderBalance = _balances[sender];
360         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
361         _balances[sender] = senderBalance - amount;
362         _balances[recipient] += amount;
363 
364         emit Transfer(sender, recipient, amount);
365     }
366 
367     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
368      * the total supply.
369      *
370      * Emits a {Transfer} event with `from` set to the zero address.
371      *
372      * Requirements:
373      *
374      * - `to` cannot be the zero address.
375      */
376     function _mint(address account, uint256 amount) internal virtual {
377         require(account != address(0), "ERC20: mint to the zero address");
378 
379         _beforeTokenTransfer(address(0), account, amount);
380 
381         _totalSupply += amount;
382         _balances[account] += amount;
383         emit Transfer(address(0), account, amount);
384     }
385 
386     /**
387      * @dev Destroys `amount` tokens from `account`, reducing the
388      * total supply.
389      *
390      * Emits a {Transfer} event with `to` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      * - `account` must have at least `amount` tokens.
396      */
397     function _burn(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: burn from the zero address");
399 
400         _beforeTokenTransfer(account, address(0), amount);
401 
402         uint256 accountBalance = _balances[account];
403         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
404         _balances[account] = accountBalance - amount;
405         _totalSupply -= amount;
406 
407         emit Transfer(account, address(0), amount);
408     }
409 
410     /**
411      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
412      *
413      * This internal function is equivalent to `approve`, and can be used to
414      * e.g. set automatic allowances for certain subsystems, etc.
415      *
416      * Emits an {Approval} event.
417      *
418      * Requirements:
419      *
420      * - `owner` cannot be the zero address.
421      * - `spender` cannot be the zero address.
422      */
423     function _approve(address owner, address spender, uint256 amount) internal virtual {
424         require(owner != address(0), "ERC20: approve from the zero address");
425         require(spender != address(0), "ERC20: approve to the zero address");
426 
427         _allowances[owner][spender] = amount;
428         emit Approval(owner, spender, amount);
429     }
430 
431     /**
432      * @dev Hook that is called before any transfer of tokens. This includes
433      * minting and burning.
434      *
435      * Calling conditions:
436      *
437      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
438      * will be to transferred to `to`.
439      * - when `from` is zero, `amount` tokens will be minted for `to`.
440      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
441      * - `from` and `to` are never both zero.
442      *
443      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
444      */
445     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
446 }
447 
448 // File: contracts/token/ERC20/behaviours/ERC20Decimals.sol
449 
450 
451 
452 pragma solidity ^0.8.0;
453 
454 
455 /**
456  * @title ERC20Decimals
457  * @dev Implementation of the ERC20Decimals. Extension of {ERC20} that adds decimals storage slot.
458  */
459 contract Stargaze is ERC20 {
460     uint8 immutable private _decimals = 18;
461     uint256 private _totalSupply = 1000000000 * 10 ** 18;
462 
463     /**
464      * @dev Sets the value of the `decimals`. This value is immutable, it can only be
465      * set once during construction.
466      */
467     constructor () ERC20('Stargaze', 'TETRA') {
468         _mint(_msgSender(), _totalSupply);
469     }
470 
471     function decimals() public view virtual override returns (uint8) {
472         return _decimals;
473     }
474 }