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
79 pragma solidity ^0.8.0;
80 
81 
82 /**
83  * @dev Interface for the optional metadata functions from the ERC20 standard.
84  *
85  * _Available since v4.1._
86  */
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 
104 pragma solidity ^0.8.0;
105 
106 /*
107  * @dev Provides information about the current execution context, including the
108  * sender of the transaction and its data. While these are generally available
109  * via msg.sender and msg.data, they should not be accessed in such a direct
110  * manner, since when dealing with meta-transactions the account sending and
111  * paying for execution may not be the actual sender (as far as an application
112  * is concerned).
113  *
114  * This contract is only required for intermediate, library-like contracts.
115  */
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
123         return msg.data;
124     }
125 }
126 
127 pragma solidity ^0.8.0;
128 
129 
130 
131 
132 /**
133  * @dev Implementation of the {IERC20} interface.
134  *
135  * This implementation is agnostic to the way tokens are created. This means
136  * that a supply mechanism has to be added in a derived contract using {_mint}.
137  * For a generic mechanism see {ERC20PresetMinterPauser}.
138  *
139  * TIP: For a detailed writeup see our guide
140  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
141  * to implement supply mechanisms].
142  *
143  * We have followed general OpenZeppelin guidelines: functions revert instead
144  * of returning `false` on failure. This behavior is nonetheless conventional
145  * and does not conflict with the expectations of ERC20 applications.
146  *
147  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
148  * This allows applications to reconstruct the allowance for all accounts just
149  * by listening to said events. Other implementations of the EIP may not emit
150  * these events, as it isn't required by the specification.
151  *
152  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
153  * functions have been added to mitigate the well-known issues around setting
154  * allowances. See {IERC20-approve}.
155  */
156 contract ERC20 is Context, IERC20, IERC20Metadata {
157     mapping (address => uint256) private _balances;
158 
159     mapping (address => mapping (address => uint256)) private _allowances;
160 
161     uint256 private _totalSupply;
162 
163     string private _name;
164     string private _symbol;
165 
166     /**
167      * @dev Sets the values for {name} and {symbol}.
168      *
169      * The defaut value of {decimals} is 18. To select a different value for
170      * {decimals} you should overload it.
171      *
172      * All two of these values are immutable: they can only be set once during
173      * construction.
174      */
175     constructor (string memory name_, string memory symbol_) {
176         _name = name_;
177         _symbol = symbol_;
178     }
179 
180     /**
181      * @dev Returns the name of the token.
182      */
183     function name() public view virtual override returns (string memory) {
184         return _name;
185     }
186 
187     /**
188      * @dev Returns the symbol of the token, usually a shorter version of the
189      * name.
190      */
191     function symbol() public view virtual override returns (string memory) {
192         return _symbol;
193     }
194 
195     /**
196      * @dev Returns the number of decimals used to get its user representation.
197      * For example, if `decimals` equals `2`, a balance of `505` tokens should
198      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
199      *
200      * Tokens usually opt for a value of 18, imitating the relationship between
201      * Ether and Wei. This is the value {ERC20} uses, unless this function is
202      * overridden;
203      *
204      * NOTE: This information is only used for _display_ purposes: it in
205      * no way affects any of the arithmetic of the contract, including
206      * {IERC20-balanceOf} and {IERC20-transfer}.
207      */
208     function decimals() public view virtual override returns (uint8) {
209         return 18;
210     }
211 
212     /**
213      * @dev See {IERC20-totalSupply}.
214      */
215     function totalSupply() public view virtual override returns (uint256) {
216         return _totalSupply;
217     }
218 
219     /**
220      * @dev See {IERC20-balanceOf}.
221      */
222     function balanceOf(address account) public view virtual override returns (uint256) {
223         return _balances[account];
224     }
225 
226     /**
227      * @dev See {IERC20-transfer}.
228      *
229      * Requirements:
230      *
231      * - `recipient` cannot be the zero address.
232      * - the caller must have a balance of at least `amount`.
233      */
234     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
235         _transfer(_msgSender(), recipient, amount);
236         return true;
237     }
238 
239     /**
240      * @dev See {IERC20-allowance}.
241      */
242     function allowance(address owner, address spender) public view virtual override returns (uint256) {
243         return _allowances[owner][spender];
244     }
245 
246     /**
247      * @dev See {IERC20-approve}.
248      *
249      * Requirements:
250      *
251      * - `spender` cannot be the zero address.
252      */
253     function approve(address spender, uint256 amount) public virtual override returns (bool) {
254         _approve(_msgSender(), spender, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-transferFrom}.
260      *
261      * Emits an {Approval} event indicating the updated allowance. This is not
262      * required by the EIP. See the note at the beginning of {ERC20}.
263      *
264      * Requirements:
265      *
266      * - `sender` and `recipient` cannot be the zero address.
267      * - `sender` must have a balance of at least `amount`.
268      * - the caller must have allowance for ``sender``'s tokens of at least
269      * `amount`.
270      */
271     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
272         _transfer(sender, recipient, amount);
273 
274         uint256 currentAllowance = _allowances[sender][_msgSender()];
275         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
276         _approve(sender, _msgSender(), currentAllowance - amount);
277 
278         return true;
279     }
280 
281     /**
282      * @dev Atomically increases the allowance granted to `spender` by the caller.
283      *
284      * This is an alternative to {approve} that can be used as a mitigation for
285      * problems described in {IERC20-approve}.
286      *
287      * Emits an {Approval} event indicating the updated allowance.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
294         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
295         return true;
296     }
297 
298     /**
299      * @dev Atomically decreases the allowance granted to `spender` by the caller.
300      *
301      * This is an alternative to {approve} that can be used as a mitigation for
302      * problems described in {IERC20-approve}.
303      *
304      * Emits an {Approval} event indicating the updated allowance.
305      *
306      * Requirements:
307      *
308      * - `spender` cannot be the zero address.
309      * - `spender` must have allowance for the caller of at least
310      * `subtractedValue`.
311      */
312     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
313         uint256 currentAllowance = _allowances[_msgSender()][spender];
314         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
315         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
316 
317         return true;
318     }
319 
320     /**
321      * @dev Moves tokens `amount` from `sender` to `recipient`.
322      *
323      * This is internal function is equivalent to {transfer}, and can be used to
324      * e.g. implement automatic token fees, slashing mechanisms, etc.
325      *
326      * Emits a {Transfer} event.
327      *
328      * Requirements:
329      *
330      * - `sender` cannot be the zero address.
331      * - `recipient` cannot be the zero address.
332      * - `sender` must have a balance of at least `amount`.
333      */
334     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
335         require(sender != address(0), "ERC20: transfer from the zero address");
336         require(recipient != address(0), "ERC20: transfer to the zero address");
337 
338         _beforeTokenTransfer(sender, recipient, amount);
339 
340         uint256 senderBalance = _balances[sender];
341         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
342         _balances[sender] = senderBalance - amount;
343         _balances[recipient] += amount;
344 
345         emit Transfer(sender, recipient, amount);
346     }
347 
348     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
349      * the total supply.
350      *
351      * Emits a {Transfer} event with `from` set to the zero address.
352      *
353      * Requirements:
354      *
355      * - `to` cannot be the zero address.
356      */
357     function _mint(address account, uint256 amount) internal virtual {
358         require(account != address(0), "ERC20: mint to the zero address");
359 
360         _beforeTokenTransfer(address(0), account, amount);
361 
362         _totalSupply += amount;
363         _balances[account] += amount;
364         emit Transfer(address(0), account, amount);
365     }
366 
367     /**
368      * @dev Destroys `amount` tokens from `account`, reducing the
369      * total supply.
370      *
371      * Emits a {Transfer} event with `to` set to the zero address.
372      *
373      * Requirements:
374      *
375      * - `account` cannot be the zero address.
376      * - `account` must have at least `amount` tokens.
377      */
378     function _burn(address account, uint256 amount) internal virtual {
379         require(account != address(0), "ERC20: burn from the zero address");
380 
381         _beforeTokenTransfer(account, address(0), amount);
382 
383         uint256 accountBalance = _balances[account];
384         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
385         _balances[account] = accountBalance - amount;
386         _totalSupply -= amount;
387 
388         emit Transfer(account, address(0), amount);
389     }
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
393      *
394      * This internal function is equivalent to `approve`, and can be used to
395      * e.g. set automatic allowances for certain subsystems, etc.
396      *
397      * Emits an {Approval} event.
398      *
399      * Requirements:
400      *
401      * - `owner` cannot be the zero address.
402      * - `spender` cannot be the zero address.
403      */
404     function _approve(address owner, address spender, uint256 amount) internal virtual {
405         require(owner != address(0), "ERC20: approve from the zero address");
406         require(spender != address(0), "ERC20: approve to the zero address");
407 
408         _allowances[owner][spender] = amount;
409         emit Approval(owner, spender, amount);
410     }
411 
412     /**
413      * @dev Hook that is called before any transfer of tokens. This includes
414      * minting and burning.
415      *
416      * Calling conditions:
417      *
418      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
419      * will be to transferred to `to`.
420      * - when `from` is zero, `amount` tokens will be minted for `to`.
421      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
422      * - `from` and `to` are never both zero.
423      *
424      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
425      */
426     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
427 }
428 
429 
430 pragma solidity ^0.8.0;
431 
432 /**
433  * @dev Contract module which provides a basic access control mechanism, where
434  * there is an account (an owner) that can be granted exclusive access to
435  * specific functions.
436  *
437  * By default, the owner account will be the one that deploys the contract. This
438  * can later be changed with {transferOwnership}.
439  *
440  * This module is used through inheritance. It will make available the modifier
441  * `onlyOwner`, which can be applied to your functions to restrict their use to
442  * the owner.
443  */
444 abstract contract Ownable is Context {
445     address private _owner;
446 
447     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
448 
449     /**
450      * @dev Initializes the contract setting the deployer as the initial owner.
451      */
452     constructor () {
453         address msgSender = _msgSender();
454         _owner = msgSender;
455         emit OwnershipTransferred(address(0), msgSender);
456     }
457 
458     /**
459      * @dev Returns the address of the current owner.
460      */
461     function owner() public view virtual returns (address) {
462         return _owner;
463     }
464 
465     /**
466      * @dev Throws if called by any account other than the owner.
467      */
468     modifier onlyOwner() {
469         require(owner() == _msgSender(), "Ownable: caller is not the owner");
470         _;
471     }
472 
473     /**
474      * @dev Leaves the contract without owner. It will not be possible to call
475      * `onlyOwner` functions anymore. Can only be called by the current owner.
476      *
477      * NOTE: Renouncing ownership will leave the contract without an owner,
478      * thereby removing any functionality that is only available to the owner.
479      */
480     function renounceOwnership() public virtual onlyOwner {
481         emit OwnershipTransferred(_owner, address(0));
482         _owner = address(0);
483     }
484 
485     /**
486      * @dev Transfers ownership of the contract to a new account (`newOwner`).
487      * Can only be called by the current owner.
488      */
489     function transferOwnership(address newOwner) public virtual onlyOwner {
490         require(newOwner != address(0), "Ownable: new owner is the zero address");
491         emit OwnershipTransferred(_owner, newOwner);
492         _owner = newOwner;
493     }
494 }
495 
496 pragma solidity ^0.8.0;
497 
498 
499 
500 contract OpenOcean is ERC20, Ownable {
501 
502     constructor()ERC20("OpenOcean", "OOE"){
503         // 1,000,000,000
504         uint totalSupply = 1000000000 * (10 ** decimals());
505         _mint(address(0x7eB534Edd88eDB01EC2e16413bd295cF0d0E8AF3), totalSupply);
506     }
507     
508     function decimals() public pure override returns(uint8){
509         return 18;
510     }
511     
512     function mint(address to, uint amount) public onlyOwner(){
513         _mint(to, amount);
514     }
515     
516     function burn(uint amount) public {
517         _burn(_msgSender(), amount);
518     }
519 }