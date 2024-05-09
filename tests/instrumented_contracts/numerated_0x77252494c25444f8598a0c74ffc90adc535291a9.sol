1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-17
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * Nemesis @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * Nemesis @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * Nemesis @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * Nemesis @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * Nemesis @dev Moves `amount` tokens from the caller's account to `recipient`.
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
67      * Nemesis @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
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
83      * Nemesis @dev Moves `amount` tokens from `sender` to `recipient` using the
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
94      * Nemesis @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * Nemesis @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 
110 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
111 
112 pragma solidity ^0.8.0;
113 
114 
115 /**
116  * Nemesis @dev Interface for the optional metadata functions from the ERC20 standard.
117  *
118  * _Available since v4.1._
119  */
120 interface IERC20Metadata is IERC20 {
121     /**
122      * Nemesis @dev Returns the name of the token.
123      */
124     function name() external view returns (string memory);
125 
126     /**
127      * Nemesis @dev Returns the symbol of the token.
128      */
129     function symbol() external view returns (string memory);
130 
131     /**
132      * Nemesis @dev Returns the decimals places of the token.
133      */
134     function decimals() external view returns (uint8);
135 }
136 
137 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
138 
139 pragma solidity ^0.8.0;
140 
141 
142 
143 
144 /**
145  * Nemesis @dev Implementation of the {IERC20} interface.
146  *
147  * This implementation is agnostic to the way tokens are created. This means
148  * that a supply mechanism has to be added in a derived contract using {_mint}.
149  * For a generic mechanism see {ERC20PresetMinterPauser}.
150  *
151  * TIP: For a detailed writeup see our guide
152  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
153  * to implement supply mechanisms].
154  *
155  * We have followed general OpenZeppelin guidelines: functions revert instead
156  * of returning `false` on failure. This behavior is nonetheless conventional
157  * and does not conflict with the expectations of ERC20 applications.
158  *
159  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
160  * This allows applications to reconstruct the allowance for all accounts just
161  * by listening to said events. Other implementations of the EIP may not emit
162  * these events, as it isn't required by the specification.
163  *
164  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
165  * functions have been added to mitigate the well-known issues around setting
166  * allowances. See {IERC20-approve}.
167  */
168 contract ERC20 is Context, IERC20, IERC20Metadata {
169     mapping (address => uint256) private _balances;
170 
171     mapping (address => mapping (address => uint256)) private _allowances;
172 
173     uint256 private _totalSupply;
174 
175     string private _name;
176     string private _symbol;
177 
178     /**
179      * Nemesis @dev Sets the values for {name} and {symbol}.
180      *
181      * The defaut value of {decimals} is 18. To select a different value for
182      * {decimals} you should overload it.
183      *
184      * All two of these values are immutable: they can only be set once during
185      * construction.
186      */
187     constructor (string memory name_, string memory symbol_) {
188         _name = name_;
189         _symbol = symbol_;
190     }
191 
192     /**
193      * Nemesis @dev Returns the name of the token.
194      */
195     function name() public view virtual override returns (string memory) {
196         return _name;
197     }
198 
199     /**
200      * Nemesis @dev Returns the symbol of the token, usually a shorter version of the
201      * name.
202      */
203     function symbol() public view virtual override returns (string memory) {
204         return _symbol;
205     }
206 
207     /**
208      * Nemesis @dev Returns the number of decimals used to get its user representation.
209      * For example, if `decimals` equals `2`, a balance of `505` tokens should
210      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
211      *
212      * Tokens usually opt for a value of 18, imitating the relationship between
213      * Ether and Wei. This is the value {ERC20} uses, unless this function is
214      * overridden;
215      *
216      * NOTE: This information is only used for _display_ purposes: it in
217      * no way affects any of the arithmetic of the contract, including
218      * {IERC20-balanceOf} and {IERC20-transfer}.
219      */
220     function decimals() public view virtual override returns (uint8) {
221         return 18;
222     }
223 
224     /**
225      * Nemesis @dev See {IERC20-totalSupply}.
226      */
227     function totalSupply() public view virtual override returns (uint256) {
228         return _totalSupply;
229     }
230 
231     /**
232      * Nemesis @dev See {IERC20-balanceOf}.
233      */
234     function balanceOf(address account) public view virtual override returns (uint256) {
235         return _balances[account];
236     }
237 
238     /**
239      * Nemesis @dev See {IERC20-transfer}.
240      *
241      * Requirements:
242      *
243      * - `recipient` cannot be the zero address.
244      * - the caller must have a balance of at least `amount`.
245      */
246     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250 
251     /**
252      * Nemesis @dev See {IERC20-allowance}.
253      */
254     function allowance(address owner, address spender) public view virtual override returns (uint256) {
255         return _allowances[owner][spender];
256     }
257 
258     /**
259      * Nemesis @dev See {IERC20-approve}.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      */
265     function approve(address spender, uint256 amount) public virtual override returns (bool) {
266         _approve(_msgSender(), spender, amount);
267         return true;
268     }
269 
270     /**
271      * Nemesis @dev See {IERC20-transferFrom}.
272      *
273      * Emits an {Approval} event indicating the updated allowance. This is not
274      * required by the EIP. See the note at the beginning of {ERC20}.
275      *
276      * Requirements:
277      *
278      * - `sender` and `recipient` cannot be the zero address.
279      * - `sender` must have a balance of at least `amount`.
280      * - the caller must have allowance for ``sender``'s tokens of at least
281      * `amount`.
282      */
283     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
284         _transfer(sender, recipient, amount);
285 
286         uint256 currentAllowance = _allowances[sender][_msgSender()];
287         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
288         _approve(sender, _msgSender(), currentAllowance - amount);
289 
290         return true;
291     }
292 
293     /**
294      * Nemesis @dev Atomically increases the allowance granted to `spender` by the caller.
295      *
296      * This is an alternative to {approve} that can be used as a mitigation for
297      * problems described in {IERC20-approve}.
298      *
299      * Emits an {Approval} event indicating the updated allowance.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      */
305     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
306         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
307         return true;
308     }
309 
310     /**
311      * Nemesis @dev Atomically decreases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      * - `spender` must have allowance for the caller of at least
322      * `subtractedValue`.
323      */
324     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
325         uint256 currentAllowance = _allowances[_msgSender()][spender];
326         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
327         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
328 
329         return true;
330     }
331 
332     /**
333      * Nemesis @dev Moves tokens `amount` from `sender` to `recipient`.
334      *
335      * This is internal function is equivalent to {transfer}, and can be used to
336      * e.g. implement automatic token fees, slashing mechanisms, etc.
337      *
338      * Emits a {Transfer} event.
339      *
340      * Requirements:
341      *
342      * - `sender` cannot be the zero address.
343      * - `recipient` cannot be the zero address.
344      * - `sender` must have a balance of at least `amount`.
345      */
346     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
347         require(sender != address(0), "ERC20: transfer from the zero address");
348         require(recipient != address(0), "ERC20: transfer to the zero address");
349 
350         _beforeTokenTransfer(sender, recipient, amount);
351 
352         uint256 senderBalance = _balances[sender];
353         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
354         _balances[sender] = senderBalance - amount;
355         _balances[recipient] += amount;
356 
357         emit Transfer(sender, recipient, amount);
358     }
359 
360     /** Nemesis @dev Creates `amount` tokens and assigns them to `account`, increasing
361      * the total supply.
362      *
363      * Emits a {Transfer} event with `from` set to the zero address.
364      *
365      * Requirements:
366      *
367      * - `to` cannot be the zero address.
368      */
369     function _mint(address account, uint256 amount) internal virtual {
370         require(account != address(0), "ERC20: mint to the zero address");
371 
372         _beforeTokenTransfer(address(0), account, amount);
373 
374         _totalSupply += amount;
375         _balances[account] += amount;
376         emit Transfer(address(0), account, amount);
377     }
378 
379     /**
380      * Nemesis @dev Destroys `amount` tokens from `account`, reducing the
381      * total supply.
382      *
383      * Emits a {Transfer} event with `to` set to the zero address.
384      *
385      * Requirements:
386      *
387      * - `account` cannot be the zero address.
388      * - `account` must have at least `amount` tokens.
389      */
390     function _burn(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: burn from the zero address");
392 
393         _beforeTokenTransfer(account, address(0), amount);
394 
395         uint256 accountBalance = _balances[account];
396         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
397         _balances[account] = accountBalance - amount;
398         _totalSupply -= amount;
399 
400         emit Transfer(account, address(0), amount);
401     }
402 
403     /**
404      * Nemesis @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
405      *
406      * This internal function is equivalent to `approve`, and can be used to
407      * e.g. set automatic allowances for certain subsystems, etc.
408      *
409      * Emits an {Approval} event.
410      *
411      * Requirements:
412      *
413      * - `owner` cannot be the zero address.
414      * - `spender` cannot be the zero address.
415      */
416     function _approve(address owner, address spender, uint256 amount) internal virtual {
417         require(owner != address(0), "ERC20: approve from the zero address");
418         require(spender != address(0), "ERC20: approve to the zero address");
419 
420         _allowances[owner][spender] = amount;
421         emit Approval(owner, spender, amount);
422     }
423 
424     /**
425      * Nemesis @dev Hook that is called before any transfer of tokens. This includes
426      * minting and burning.
427      *
428      * Calling conditions:
429      *
430      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
431      * will be to transferred to `to`.
432      * - when `from` is zero, `amount` tokens will be minted for `to`.
433      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
434      * - `from` and `to` are never both zero.
435      *
436      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
437      */
438     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
439 }
440 
441 // File: contracts/NemesisToken.sol
442 
443 //SPDX-License-Identifier: MIT
444 pragma solidity ^0.8.0;
445 
446 
447 contract NemesisToken is ERC20 {
448     constructor() ERC20("Nemesis", "NMS") {
449         _mint(msg.sender, 275000000 * 10 ** decimals());
450     }
451 }