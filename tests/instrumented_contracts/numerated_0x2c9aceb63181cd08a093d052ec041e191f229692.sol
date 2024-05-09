1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
109 
110 
111 
112 pragma solidity ^0.8.0;
113 
114 
115 /**
116  * @dev Interface for the optional metadata functions from the ERC20 standard.
117  *
118  * _Available since v4.1._
119  */
120 interface IERC20Metadata is IERC20 {
121     /**
122      * @dev Returns the name of the token.
123      */
124     function name() external view returns (string memory);
125 
126     /**
127      * @dev Returns the symbol of the token.
128      */
129     function symbol() external view returns (string memory);
130 
131     /**
132      * @dev Returns the decimals places of the token.
133      */
134     function decimals() external view returns (uint8);
135 }
136 
137 
138 
139 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
140 
141 
142 
143 pragma solidity ^0.8.0;
144 
145 
146 
147 
148 /**
149  * @dev Implementation of the {IERC20} interface.
150  *
151  * This implementation is agnostic to the way tokens are created. This means
152  * that a supply mechanism has to be added in a derived contract using {_mint}.
153  * For a generic mechanism see {ERC20PresetMinterPauser}.
154  *
155  * TIP: For a detailed writeup see our guide
156  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
157  * to implement supply mechanisms].
158  *
159  * We have followed general OpenZeppelin guidelines: functions revert instead
160  * of returning `false` on failure. This behavior is nonetheless conventional
161  * and does not conflict with the expectations of ERC20 applications.
162  *
163  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
164  * This allows applications to reconstruct the allowance for all accounts just
165  * by listening to said events. Other implementations of the EIP may not emit
166  * these events, as it isn't required by the specification.
167  *
168  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
169  * functions have been added to mitigate the well-known issues around setting
170  * allowances. See {IERC20-approve}.
171  */
172 contract ERC20 is Context, IERC20, IERC20Metadata {
173     mapping (address => uint256) private _balances;
174 
175     mapping (address => mapping (address => uint256)) private _allowances;
176 
177     uint256 private _totalSupply;
178 
179     string private _name;
180     string private _symbol;
181 
182     /**
183      * @dev Sets the values for {name} and {symbol}.
184      *
185      * The defaut value of {decimals} is 18. To select a different value for
186      * {decimals} you should overload it.
187      *
188      * All two of these values are immutable: they can only be set once during
189      * construction.
190      */
191     constructor (string memory name_, string memory symbol_) {
192         _name = name_;
193         _symbol = symbol_;
194     }
195 
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() public view virtual override returns (string memory) {
200         return _name;
201     }
202 
203     /**
204      * @dev Returns the symbol of the token, usually a shorter version of the
205      * name.
206      */
207     function symbol() public view virtual override returns (string memory) {
208         return _symbol;
209     }
210 
211     /**
212      * @dev Returns the number of decimals used to get its user representation.
213      * For example, if `decimals` equals `2`, a balance of `505` tokens should
214      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
215      *
216      * Tokens usually opt for a value of 18, imitating the relationship between
217      * Ether and Wei. This is the value {ERC20} uses, unless this function is
218      * overridden;
219      *
220      * NOTE: This information is only used for _display_ purposes: it in
221      * no way affects any of the arithmetic of the contract, including
222      * {IERC20-balanceOf} and {IERC20-transfer}.
223      */
224     function decimals() public view virtual override returns (uint8) {
225         return 18;
226     }
227 
228     /**
229      * @dev See {IERC20-totalSupply}.
230      */
231     function totalSupply() public view virtual override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See {IERC20-balanceOf}.
237      */
238     function balanceOf(address account) public view virtual override returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See {IERC20-transfer}.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See {IERC20-allowance}.
257      */
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See {IERC20-approve}.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 amount) public virtual override returns (bool) {
270         _approve(_msgSender(), spender, amount);
271         return true;
272     }
273 
274     /**
275      * @dev See {IERC20-transferFrom}.
276      *
277      * Emits an {Approval} event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of {ERC20}.
279      *
280      * Requirements:
281      *
282      * - `sender` and `recipient` cannot be the zero address.
283      * - `sender` must have a balance of at least `amount`.
284      * - the caller must have allowance for ``sender``'s tokens of at least
285      * `amount`.
286      */
287     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
288         _transfer(sender, recipient, amount);
289 
290         uint256 currentAllowance = _allowances[sender][_msgSender()];
291         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
292         _approve(sender, _msgSender(), currentAllowance - amount);
293 
294         return true;
295     }
296 
297     /**
298      * @dev Atomically increases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to {approve} that can be used as a mitigation for
301      * problems described in {IERC20-approve}.
302      *
303      * Emits an {Approval} event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      */
309     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
310         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
311         return true;
312     }
313 
314     /**
315      * @dev Atomically decreases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      * - `spender` must have allowance for the caller of at least
326      * `subtractedValue`.
327      */
328     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
329         uint256 currentAllowance = _allowances[_msgSender()][spender];
330         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
331         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
332 
333         return true;
334     }
335 
336     /**
337      * @dev Moves tokens `amount` from `sender` to `recipient`.
338      *
339      * This is internal function is equivalent to {transfer}, and can be used to
340      * e.g. implement automatic token fees, slashing mechanisms, etc.
341      *
342      * Emits a {Transfer} event.
343      *
344      * Requirements:
345      *
346      * - `sender` cannot be the zero address.
347      * - `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      */
350     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
351         require(sender != address(0), "ERC20: transfer from the zero address");
352         require(recipient != address(0), "ERC20: transfer to the zero address");
353 
354         _beforeTokenTransfer(sender, recipient, amount);
355 
356         uint256 senderBalance = _balances[sender];
357         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
358         _balances[sender] = senderBalance - amount;
359         _balances[recipient] += amount;
360 
361         emit Transfer(sender, recipient, amount);
362     }
363 
364     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
365      * the total supply.
366      *
367      * Emits a {Transfer} event with `from` set to the zero address.
368      *
369      * Requirements:
370      *
371      * - `to` cannot be the zero address.
372      */
373     function _mint(address account, uint256 amount) internal virtual {
374         require(account != address(0), "ERC20: mint to the zero address");
375 
376         _beforeTokenTransfer(address(0), account, amount);
377 
378         _totalSupply += amount;
379         _balances[account] += amount;
380         emit Transfer(address(0), account, amount);
381     }
382 
383     /**
384      * @dev Destroys `amount` tokens from `account`, reducing the
385      * total supply.
386      *
387      * Emits a {Transfer} event with `to` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      * - `account` must have at least `amount` tokens.
393      */
394     function _burn(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: burn from the zero address");
396 
397         _beforeTokenTransfer(account, address(0), amount);
398 
399         uint256 accountBalance = _balances[account];
400         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
401         _balances[account] = accountBalance - amount;
402         _totalSupply -= amount;
403 
404         emit Transfer(account, address(0), amount);
405     }
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
409      *
410      * This internal function is equivalent to `approve`, and can be used to
411      * e.g. set automatic allowances for certain subsystems, etc.
412      *
413      * Emits an {Approval} event.
414      *
415      * Requirements:
416      *
417      * - `owner` cannot be the zero address.
418      * - `spender` cannot be the zero address.
419      */
420     function _approve(address owner, address spender, uint256 amount) internal virtual {
421         require(owner != address(0), "ERC20: approve from the zero address");
422         require(spender != address(0), "ERC20: approve to the zero address");
423 
424         _allowances[owner][spender] = amount;
425         emit Approval(owner, spender, amount);
426     }
427 
428     /**
429      * @dev Hook that is called before any transfer of tokens. This includes
430      * minting and burning.
431      *
432      * Calling conditions:
433      *
434      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
435      * will be to transferred to `to`.
436      * - when `from` is zero, `amount` tokens will be minted for `to`.
437      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
438      * - `from` and `to` are never both zero.
439      *
440      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
441      */
442     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
443 }
444 
445 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
446 
447 
448 
449 pragma solidity ^0.8.0;
450 
451 
452 
453 /**
454  * @dev Extension of {ERC20} that allows token holders to destroy both their own
455  * tokens and those that they have an allowance for, in a way that can be
456  * recognized off-chain (via event analysis).
457  */
458 abstract contract ERC20Burnable is Context, ERC20 {
459     /**
460      * @dev Destroys `amount` tokens from the caller.
461      *
462      * See {ERC20-_burn}.
463      */
464     function burn(uint256 amount) public virtual {
465         _burn(_msgSender(), amount);
466     }
467 
468     /**
469      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
470      * allowance.
471      *
472      * See {ERC20-_burn} and {ERC20-allowance}.
473      *
474      * Requirements:
475      *
476      * - the caller must have allowance for ``accounts``'s tokens of at least
477      * `amount`.
478      */
479     function burnFrom(address account, uint256 amount) public virtual {
480         uint256 currentAllowance = allowance(account, _msgSender());
481         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
482         _approve(account, _msgSender(), currentAllowance - amount);
483         _burn(account, amount);
484     }
485 }
486 
487 // File: contracts/AngryToken.sol
488 
489 
490 pragma solidity ^0.8.4;
491 
492 
493 contract AngryToken is ERC20, ERC20Burnable {
494     uint8 private _decimals;
495     
496     constructor (uint256 _initialSupply, string memory _tokenName, string memory _tokenSymbol, uint8 _tokenDecimals)
497         ERC20(_tokenName,_tokenSymbol) ERC20Burnable() {
498         _decimals = _tokenDecimals;
499         _mint(msg.sender, _initialSupply * 10 ** uint256(_decimals));
500     }
501     
502     function decimals() public view virtual override returns (uint8) {
503         return _decimals;
504     }
505 }