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
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 /**
90  * @dev Interface of the ERC20 standard as defined in the EIP.
91  */
92 interface IERC20 {
93     /**
94      * @dev Returns the amount of tokens in existence.
95      */
96     function totalSupply() external view returns (uint256);
97 
98     /**
99      * @dev Returns the amount of tokens owned by `account`.
100      */
101     function balanceOf(address account) external view returns (uint256);
102 
103     /**
104      * @dev Moves `amount` tokens from the caller's account to `recipient`.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transfer(address recipient, uint256 amount) external returns (bool);
111 
112     /**
113      * @dev Returns the remaining number of tokens that `spender` will be
114      * allowed to spend on behalf of `owner` through {transferFrom}. This is
115      * zero by default.
116      *
117      * This value changes when {approve} or {transferFrom} are called.
118      */
119     function allowance(address owner, address spender) external view returns (uint256);
120 
121     /**
122      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * IMPORTANT: Beware that changing an allowance with this method brings the risk
127      * that someone may use both the old and the new allowance by unfortunate
128      * transaction ordering. One possible solution to mitigate this race
129      * condition is to first reduce the spender's allowance to 0 and set the
130      * desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      *
133      * Emits an {Approval} event.
134      */
135     function approve(address spender, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Moves `amount` tokens from `sender` to `recipient` using the
139      * allowance mechanism. `amount` is then deducted from the caller's
140      * allowance.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Emitted when `value` tokens are moved from one account (`from`) to
150      * another (`to`).
151      *
152      * Note that `value` may be zero.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 value);
155 
156     /**
157      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
158      * a call to {approve}. `value` is the new allowance.
159      */
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 /**
164  * @dev Implementation of the {IERC20} interface.
165  *
166  * This implementation is agnostic to the way tokens are created. This means
167  * that a supply mechanism has to be added in a derived contract using {_mint}.
168  * For a generic mechanism see {ERC20PresetMinterPauser}.
169  *
170  * TIP: For a detailed writeup see our guide
171  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
172  * to implement supply mechanisms].
173  *
174  * We have followed general OpenZeppelin guidelines: functions revert instead
175  * of returning `false` on failure. This behavior is nonetheless conventional
176  * and does not conflict with the expectations of ERC20 applications.
177  *
178  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
179  * This allows applications to reconstruct the allowance for all accounts just
180  * by listening to said events. Other implementations of the EIP may not emit
181  * these events, as it isn't required by the specification.
182  *
183  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
184  * functions have been added to mitigate the well-known issues around setting
185  * allowances. See {IERC20-approve}.
186  */
187 contract ERC20 is Context, IERC20 {
188     mapping (address => uint256) private _balances;
189 
190     mapping (address => mapping (address => uint256)) private _allowances;
191 
192     uint256 private _totalSupply;
193 
194     string private _name;
195     string private _symbol;
196 
197     /**
198      * @dev Sets the values for {name} and {symbol}.
199      *
200      * The defaut value of {decimals} is 18. To select a different value for
201      * {decimals} you should overload it.
202      *
203      * All three of these values are immutable: they can only be set once during
204      * construction.
205      */
206     constructor (string memory name_, string memory symbol_) {
207         _name = name_;
208         _symbol = symbol_;
209     }
210 
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() public view virtual returns (string memory) {
215         return _name;
216     }
217 
218     /**
219      * @dev Returns the symbol of the token, usually a shorter version of the
220      * name.
221      */
222     function symbol() public view virtual returns (string memory) {
223         return _symbol;
224     }
225 
226     /**
227      * @dev Returns the number of decimals used to get its user representation.
228      * For example, if `decimals` equals `2`, a balance of `505` tokens should
229      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
230      *
231      * Tokens usually opt for a value of 18, imitating the relationship between
232      * Ether and Wei. This is the value {ERC20} uses, unless this function is
233      * overloaded;
234      *
235      * NOTE: This information is only used for _display_ purposes: it in
236      * no way affects any of the arithmetic of the contract, including
237      * {IERC20-balanceOf} and {IERC20-transfer}.
238      */
239     function decimals() public view virtual returns (uint8) {
240         return 18;
241     }
242 
243     /**
244      * @dev See {IERC20-totalSupply}.
245      */
246     function totalSupply() public view virtual override returns (uint256) {
247         return _totalSupply;
248     }
249 
250     /**
251      * @dev See {IERC20-balanceOf}.
252      */
253     function balanceOf(address account) public view virtual override returns (uint256) {
254         return _balances[account];
255     }
256 
257     /**
258      * @dev See {IERC20-transfer}.
259      *
260      * Requirements:
261      *
262      * - `recipient` cannot be the zero address.
263      * - the caller must have a balance of at least `amount`.
264      */
265     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
266         _transfer(_msgSender(), recipient, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See {IERC20-allowance}.
272      */
273     function allowance(address owner, address spender) public view virtual override returns (uint256) {
274         return _allowances[owner][spender];
275     }
276 
277     /**
278      * @dev See {IERC20-approve}.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function approve(address spender, uint256 amount) public virtual override returns (bool) {
285         _approve(_msgSender(), spender, amount);
286         return true;
287     }
288 
289     /**
290      * @dev See {IERC20-transferFrom}.
291      *
292      * Emits an {Approval} event indicating the updated allowance. This is not
293      * required by the EIP. See the note at the beginning of {ERC20}.
294      *
295      * Requirements:
296      *
297      * - `sender` and `recipient` cannot be the zero address.
298      * - `sender` must have a balance of at least `amount`.
299      * - the caller must have allowance for ``sender``'s tokens of at least
300      * `amount`.
301      */
302     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
303         _transfer(sender, recipient, amount);
304 
305         uint256 currentAllowance = _allowances[sender][_msgSender()];
306         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
307         _approve(sender, _msgSender(), currentAllowance - amount);
308 
309         return true;
310     }
311 
312     /**
313      * @dev Atomically increases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
326         return true;
327     }
328 
329     /**
330      * @dev Atomically decreases the allowance granted to `spender` by the caller.
331      *
332      * This is an alternative to {approve} that can be used as a mitigation for
333      * problems described in {IERC20-approve}.
334      *
335      * Emits an {Approval} event indicating the updated allowance.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      * - `spender` must have allowance for the caller of at least
341      * `subtractedValue`.
342      */
343     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
344         uint256 currentAllowance = _allowances[_msgSender()][spender];
345         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
346         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
347 
348         return true;
349     }
350 
351     /**
352      * @dev Moves tokens `amount` from `sender` to `recipient`.
353      *
354      * This is internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `sender` cannot be the zero address.
362      * - `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      */
365     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
366         require(sender != address(0), "ERC20: transfer from the zero address");
367         require(recipient != address(0), "ERC20: transfer to the zero address");
368 
369         _beforeTokenTransfer(sender, recipient, amount);
370 
371         uint256 senderBalance = _balances[sender];
372         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
373         _balances[sender] = senderBalance - amount;
374         _balances[recipient] += amount;
375 
376         emit Transfer(sender, recipient, amount);
377     }
378 
379     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
380      * the total supply.
381      *
382      * Emits a {Transfer} event with `from` set to the zero address.
383      *
384      * Requirements:
385      *
386      * - `to` cannot be the zero address.
387      */
388     function _mint(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: mint to the zero address");
390 
391         _beforeTokenTransfer(address(0), account, amount);
392 
393         _totalSupply += amount;
394         _balances[account] += amount;
395         emit Transfer(address(0), account, amount);
396     }
397 
398     /**
399      * @dev Destroys `amount` tokens from `account`, reducing the
400      * total supply.
401      *
402      * Emits a {Transfer} event with `to` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `account` cannot be the zero address.
407      * - `account` must have at least `amount` tokens.
408      */
409     function _burn(address account, uint256 amount) internal virtual {
410         require(account != address(0), "ERC20: burn from the zero address");
411 
412         _beforeTokenTransfer(account, address(0), amount);
413 
414         uint256 accountBalance = _balances[account];
415         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
416         _balances[account] = accountBalance - amount;
417         _totalSupply -= amount;
418 
419         emit Transfer(account, address(0), amount);
420     }
421 
422     /**
423      * @dev Sets `amount` as the allowance of `smpender` over the `owner` s tokens.
424      *
425      * This internal function is equivalent to `approve`, and can be used to
426      * e.g. set automatic allowances for certain subsystems, etc.
427      *
428      * Emits an {Approval} event.
429      *
430      * Requirements:
431      *
432      * - `owner` cannot be the zero address.
433      * - `spender` cannot be the zero address.
434      */
435     function _approve(address owner, address spender, uint256 amount) internal virtual {
436         require(owner != address(0), "ERC20: approve from the zero address");
437         require(spender != address(0), "ERC20: approve to the zero address");
438 
439         _allowances[owner][spender] = amount;
440         emit Approval(owner, spender, amount);
441     }
442 
443     /**
444      * @dev Hook that is called before any transfer of tokens. This includes
445      * minting and burning.
446      *
447      * Calling conditions:
448      *
449      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
450      * will be to transferred to `to`.
451      * - when `from` is zero, `amount` tokens will be minted for `to`.
452      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
453      * - `from` and `to` are never both zero.
454      *
455      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
456      */
457     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
458 }
459 
460 contract ApuToken is ERC20, Ownable {
461     mapping (address => bool) public blacklist;
462     mapping (address => bool) public exemptedAddresses;
463     uint256 public maxTxAmount = 13370000000 * (10 ** 18);
464     uint256 public maxWalletToken = 13370000000 * (10 ** 18);
465     bool public tradingEnabled = false;
466 
467     constructor() ERC20("ApuToken", "APU") {
468         _mint(msg.sender, 1337000000000 * (10 ** 18));
469     }
470 
471     function transfer(address recipient, uint256 amount) public override returns (bool) {
472        require(tradingEnabled, "Trading is not enabled.");
473         require(!blacklist[msg.sender], "You are blacklisted!");
474 
475         if (!exemptedAddresses[msg.sender]) {
476             require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
477             require(balanceOf(recipient) + amount <= maxWalletToken, "Exceeds maximum wallet token amount.");
478         }
479 
480         return super.transfer(recipient, amount);
481     }
482 
483     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
484         require(tradingEnabled, "Trading is not enabled.");
485         require(!blacklist[sender], "Sender is blacklisted!");
486 
487         if (!exemptedAddresses[sender]) {
488             require(amount <= maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
489             require(balanceOf(recipient) + amount <= maxWalletToken, "Exceeds maximum wallet token amount.");
490         }
491 
492         return super.transferFrom(sender, recipient, amount);
493     }
494 
495     function addToBlacklist(address account) public onlyOwner {
496         blacklist[account] = true;
497     }
498 
499     function removeFromBlacklist(address account) public onlyOwner {
500         blacklist[account] = false;
501     }
502 
503     function addExemptedAddress(address account) public onlyOwner {
504         exemptedAddresses[account] = true;
505     }
506 
507     function removeExemptedAddress(address account) public onlyOwner {
508         exemptedAddresses[account] = false;
509     }
510 
511     function setMaxTxAmount(uint256 maxTxTokens) external onlyOwner() {
512         maxTxAmount = maxTxTokens * (10 ** 18);
513     }
514 
515     function setMaxWalletToken(uint256 maxWalletTokens) external onlyOwner() {
516         maxWalletToken = maxWalletTokens * (10 ** 18);
517     }
518 
519         function enableTrading() external onlyOwner() {
520         tradingEnabled = true;
521     }
522 
523     function disableTrading() external onlyOwner() {
524         tradingEnabled = false;
525     }
526 }