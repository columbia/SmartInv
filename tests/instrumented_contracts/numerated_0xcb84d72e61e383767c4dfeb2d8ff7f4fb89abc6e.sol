1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.1;
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
79 
80 /**
81  * @dev Implementation of the {IERC20} interface.
82  *
83  * This implementation is agnostic to the way tokens are created. This means
84  * that a supply mechanism has to be added in a derived contract using {_mint}.
85  * For a generic mechanism see {ERC20PresetMinterPauser}.
86  *
87  * TIP: For a detailed writeup see our guide
88  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
89  * to implement supply mechanisms].
90  *
91  * We have followed general OpenZeppelin guidelines: functions revert instead
92  * of returning `false` on failure. This behavior is nonetheless conventional
93  * and does not conflict with the expectations of ERC20 applications.
94  *
95  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
96  * This allows applications to reconstruct the allowance for all accounts just
97  * by listening to said events. Other implementations of the EIP may not emit
98  * these events, as it isn't required by the specification.
99  *
100  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
101  * functions have been added to mitigate the well-known issues around setting
102  * allowances. See {IERC20-approve}.
103  */
104 contract ERC20 is IERC20 {
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowances;
108 
109     uint256 private _totalSupply;
110 
111     string private _name;
112     string private _symbol;
113 
114     /**
115     * brought in function from Context
116     */
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     /**
122      * @dev Sets the values for {name} and {symbol}.
123      *
124      * The defaut value of {decimals} is 18. To select a different value for
125      * {decimals} you should overload it.
126      *
127      * All three of these values are immutable: they can only be set once during
128      * construction.
129      */
130     constructor (string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135     /**
136      * @dev Returns the name of the token.
137      */
138     function name() public view virtual returns (string memory) {
139         return _name;
140     }
141 
142     /**
143      * @dev Returns the symbol of the token, usually a shorter version of the
144      * name.
145      */
146     function symbol() public view virtual returns (string memory) {
147         return _symbol;
148     }
149 
150     /**
151      * @dev Returns the number of decimals used to get its user representation.
152      * For example, if `decimals` equals `2`, a balance of `505` tokens should
153      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
154      *
155      * Tokens usually opt for a value of 18, imitating the relationship between
156      * Ether and Wei. This is the value {ERC20} uses, unless this function is
157      * overloaded;
158      *
159      * NOTE: This information is only used for _display_ purposes: it in
160      * no way affects any of the arithmetic of the contract, including
161      * {IERC20-balanceOf} and {IERC20-transfer}.
162      */
163     function decimals() public view virtual returns (uint8) {
164         return 18;
165     }
166 
167     /**
168      * @dev See {IERC20-totalSupply}.
169      */
170     function totalSupply() public view virtual override returns (uint256) {
171         return _totalSupply;
172     }
173 
174     /**
175      * @dev See {IERC20-balanceOf}.
176      */
177     function balanceOf(address account) public view virtual override returns (uint256) {
178         return _balances[account];
179     }
180 
181     /**
182      * @dev See {IERC20-transfer}.
183      *
184      * Requirements:
185      *
186      * - `recipient` cannot be the zero address.
187      * - the caller must have a balance of at least `amount`.
188      */
189     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     /**
195      * @dev See {IERC20-allowance}.
196      */
197     function allowance(address owner, address spender) public view virtual override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     /**
202      * @dev See {IERC20-approve}.
203      *
204      * Requirements:
205      *
206      * - `spender` cannot be the zero address.
207      */
208     function approve(address spender, uint256 amount) public virtual override returns (bool) {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212 
213     /**
214      * @dev See {IERC20-transferFrom}.
215      *
216      * Emits an {Approval} event indicating the updated allowance. This is not
217      * required by the EIP. See the note at the beginning of {ERC20}.
218      *
219      * Requirements:
220      *
221      * - `sender` and `recipient` cannot be the zero address.
222      * - `sender` must have a balance of at least `amount`.
223      * - the caller must have allowance for ``sender``'s tokens of at least
224      * `amount`.
225      */
226     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
227         _transfer(sender, recipient, amount);
228 
229         uint256 currentAllowance = _allowances[sender][_msgSender()];
230         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
231         _approve(sender, _msgSender(), currentAllowance - amount);
232 
233         return true;
234     }
235 
236     /**
237      * @dev Atomically increases the allowance granted to `spender` by the caller.
238      *
239      * This is an alternative to {approve} that can be used as a mitigation for
240      * problems described in {IERC20-approve}.
241      *
242      * Emits an {Approval} event indicating the updated allowance.
243      *
244      * Requirements:
245      *
246      * - `spender` cannot be the zero address.
247      */
248     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
249         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
250         return true;
251     }
252 
253     /**
254      * @dev Atomically decreases the allowance granted to `spender` by the caller.
255      *
256      * This is an alternative to {approve} that can be used as a mitigation for
257      * problems described in {IERC20-approve}.
258      *
259      * Emits an {Approval} event indicating the updated allowance.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      * - `spender` must have allowance for the caller of at least
265      * `subtractedValue`.
266      */
267     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
268         uint256 currentAllowance = _allowances[_msgSender()][spender];
269         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
270         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
271 
272         return true;
273     }
274 
275     /**
276      * @dev Moves tokens `amount` from `sender` to `recipient`.
277      *
278      * This is internal function is equivalent to {transfer}, and can be used to
279      * e.g. implement automatic token fees, slashing mechanisms, etc.
280      *
281      * Emits a {Transfer} event.
282      *
283      * Requirements:
284      *
285      * - `sender` cannot be the zero address.
286      * - `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `amount`.
288      */
289     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
290         require(sender != address(0), "ERC20: transfer from the zero address");
291         require(recipient != address(0), "ERC20: transfer to the zero address");
292 
293         _beforeTokenTransfer(sender, recipient, amount);
294 
295         uint256 senderBalance = _balances[sender];
296         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
297         _balances[sender] = senderBalance - amount;
298         _balances[recipient] += amount;
299 
300         emit Transfer(sender, recipient, amount);
301     }
302 
303     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
304      * the total supply.
305      *
306      * Emits a {Transfer} event with `from` set to the zero address.
307      *
308      * Requirements:
309      *
310      * - `to` cannot be the zero address.
311      */
312     function _mint(address account, uint256 amount) internal virtual {
313         require(account != address(0), "ERC20: mint to the zero address");
314 
315         _beforeTokenTransfer(address(0), account, amount);
316 
317         _totalSupply += amount;
318         _balances[account] += amount;
319         emit Transfer(address(0), account, amount);
320     }
321 
322     /**
323      * @dev Destroys `amount` tokens from `account`, reducing the
324      * total supply.
325      *
326      * Emits a {Transfer} event with `to` set to the zero address.
327      *
328      * Requirements:
329      *
330      * - `account` cannot be the zero address.
331      * - `account` must have at least `amount` tokens.
332      */
333     function _burn(address account, uint256 amount) internal virtual {
334         require(account != address(0), "ERC20: burn from the zero address");
335 
336         _beforeTokenTransfer(account, address(0), amount);
337 
338         uint256 accountBalance = _balances[account];
339         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
340         _balances[account] = accountBalance - amount;
341         _totalSupply -= amount;
342 
343         emit Transfer(account, address(0), amount);
344     }
345 
346     /**
347      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
348      *
349      * This internal function is equivalent to `approve`, and can be used to
350      * e.g. set automatic allowances for certain subsystems, etc.
351      *
352      * Emits an {Approval} event.
353      *
354      * Requirements:
355      *
356      * - `owner` cannot be the zero address.
357      * - `spender` cannot be the zero address.
358      */
359     function _approve(address owner, address spender, uint256 amount) internal virtual {
360         require(owner != address(0), "ERC20: approve from the zero address");
361         require(spender != address(0), "ERC20: approve to the zero address");
362 
363         _allowances[owner][spender] = amount;
364         emit Approval(owner, spender, amount);
365     }
366 
367     /**
368      * @dev Hook that is called before any transfer of tokens. This includes
369      * minting and burning.
370      *
371      * Calling conditions:
372      *
373      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
374      * will be to transferred to `to`.
375      * - when `from` is zero, `amount` tokens will be minted for `to`.
376      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
377      * - `from` and `to` are never both zero.
378      *
379      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
380      */
381     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
382 }
383 
384 
385 
386 /// @title Vega 2 Token
387 /// @author Vega Protocol
388 /// @notice This contract is the Vega V2 ERC20 token that replaces the initial VEGA token
389 contract Vega_2 is ERC20 {
390 
391   event Controller_Changed(address indexed new_controller);
392 
393   /// @notice Timestamp of when mint becomes available to the current controller of the token
394   uint256 public mint_lock_expiry;
395   /// @notice Address of the controller of this contract (similar to "owner" in other contracts)
396   address public controller;
397 
398   /// @notice Constructor mints and issues total_supply_to the address that deploys the contract
399   /// @dev Runs ERC20 _mint function
400   /// @param total_supply_ The initial supply to mint, these will be the only tokens minted until after mint_lock_expiry
401   /// @param mint_lock_expiry_ The timestamp of when the mint_and_issue function becomes available to the controller
402   /// @param name_ The name of the ERC20 token
403   /// @param symbol_ The symbol of the ERC20 token
404   /// @dev emits Controller_Changed event
405   constructor(uint256 total_supply_, uint256 mint_lock_expiry_, string memory name_, string memory symbol_) ERC20 (name_, symbol_) {
406       //mint and issue
407       mint_lock_expiry = mint_lock_expiry_;
408       _mint(msg.sender, total_supply_);
409       controller = msg.sender;
410       emit Controller_Changed(controller);
411   }
412 
413   /// @notice This function allows the controller to assign a new controller
414   /// @dev Emits Controller_Changed event
415   /// @param new_controller Address of the new controller
416   function change_controller(address new_controller) public {
417     require(msg.sender == controller, "only controller");
418     controller = new_controller;
419     emit Controller_Changed(new_controller);
420   }
421 
422   /// @notice This function allows the controller to mint and issue tokens to the target address
423   /// @notice This function is locked until mint_lock_expiry
424   /// @dev Runs ERC20 _mint function
425   /// @param target Target address for the newly minted tokens
426   /// @param amount Amount of tokens to mint and issue
427   function mint_and_issue(address target, uint256 amount) public {
428     require(block.timestamp > mint_lock_expiry, "minting is locked");
429     require(msg.sender == controller, "only controller");
430     _mint(target, amount);
431   }
432 }
433 
434 /**
435 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
436 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
437 MMMMWEMMMMMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
438 MMMMMMLOVEMMMMMMMMMMMMMMMMMMMMMM...............MMMMMMMMMMMMM
439 MMMMMMMMMMHIXELMMMMMMMMMMMM....................MMMMMNNMMMMMM
440 MMMMMMMMMMMMMMMMMMMMMMMMMMM....................MMMMMMMMMMMMM
441 MMMMMMMMMMMMMMMMMMMMMM88=........................+MMMMMMMMMM
442 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
443 MMMMMMMMMMMMMMMMM....................MMMMM...MMMMMMMMMMMMMMM
444 MMMMMMMMMMMM.........................MM+..MMM....+MMMMMMMMMM
445 MMMMMMMMMNMM...................... ..MM?..MMM.. .+MMMMMMMMMM
446 MMMMNDDMM+........................+MM........MM..+MMMMMMMMMM
447 MMMMZ.............................+MM....................MMM
448 MMMMZ.............................+MM....................MMM
449 MMMMZ.............................+MM....................DDD
450 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
451 MMMMZ.............................+MM..ZMMMMMMMMMMMMMMMMMMMM
452 MM..............................MMZ....ZMMMMMMMMMMMMMMMMMMMM
453 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
454 MM............................MM.......ZMMMMMMMMMMMMMMMMMMMM
455 MM......................ZMMMMM.......MMMMMMMMMMMMMMMMMMMMMMM
456 MM............... ......ZMMMMM.... ..MMMMMMMMMMMMMMMMMMMMMMM
457 MM...............MMMMM88~.........+MM..ZMMMMMMMMMMMMMMMMMMMM
458 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
459 MM.......$DDDDDDD.......$DDDDD..DDNMM..ZMMMMMMMMMMMMMMMMMMMM
460 MM.......ZMMMMMMM.......ZMMMMM..MMMMM..ZMMMMMMMMMMMMMMMMMMMM
461 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
462 MMMMMMMMM+.......MMMMM88NMMMMM..MMMMMMMMMMMMMMMMMMMMMMMMMMMM
463 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
464 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM*/