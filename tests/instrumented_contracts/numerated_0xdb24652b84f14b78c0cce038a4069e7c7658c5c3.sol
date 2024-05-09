1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
82 
83 pragma solidity ^0.8.0;
84 
85 
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 // File: @openzeppelin/contracts/utils/Context.sol
109 
110 pragma solidity ^0.8.0;
111 
112 /*
113  * @dev Provides information about the current execution context, including the
114  * sender of the transaction and its data. While these are generally available
115  * via msg.sender and msg.data, they should not be accessed in such a direct
116  * manner, since when dealing with meta-transactions the account sending and
117  * paying for execution may not be the actual sender (as far as an application
118  * is concerned).
119  *
120  * This contract is only required for intermediate, library-like contracts.
121  */
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view virtual returns (bytes calldata) {
128         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
129         return msg.data;
130     }
131 }
132 
133 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
134 
135 pragma solidity ^0.8.0;
136 
137 
138 
139 
140 /**
141  * @dev Implementation of the {IERC20} interface.
142  *
143  * This implementation is agnostic to the way tokens are created. This means
144  * that a supply mechanism has to be added in a derived contract using {_mint}.
145  * For a generic mechanism see {ERC20PresetMinterPauser}.
146  *
147  * TIP: For a detailed writeup see our guide
148  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
149  * to implement supply mechanisms].
150  *
151  * We have followed general OpenZeppelin guidelines: functions revert instead
152  * of returning `false` on failure. This behavior is nonetheless conventional
153  * and does not conflict with the expectations of ERC20 applications.
154  *
155  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
156  * This allows applications to reconstruct the allowance for all accounts just
157  * by listening to said events. Other implementations of the EIP may not emit
158  * these events, as it isn't required by the specification.
159  *
160  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
161  * functions have been added to mitigate the well-known issues around setting
162  * allowances. See {IERC20-approve}.
163  */
164 contract ERC20 is Context, IERC20, IERC20Metadata {
165     mapping (address => uint256) private _balances;
166 
167     mapping (address => mapping (address => uint256)) private _allowances;
168 
169     uint256 private _totalSupply;
170 
171     string private _name;
172     string private _symbol;
173 
174     /**
175      * @dev Sets the values for {name} and {symbol}.
176      *
177      * The defaut value of {decimals} is 18. To select a different value for
178      * {decimals} you should overload it.
179      *
180      * All two of these values are immutable: they can only be set once during
181      * construction.
182      */
183     constructor (string memory name_, string memory symbol_) {
184         _name = name_;
185         _symbol = symbol_;
186     }
187 
188     /**
189      * @dev Returns the name of the token.
190      */
191     function name() public view virtual override returns (string memory) {
192         return _name;
193     }
194 
195     /**
196      * @dev Returns the symbol of the token, usually a shorter version of the
197      * name.
198      */
199     function symbol() public view virtual override returns (string memory) {
200         return _symbol;
201     }
202 
203     /**
204      * @dev Returns the number of decimals used to get its user representation.
205      * For example, if `decimals` equals `2`, a balance of `505` tokens should
206      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
207      *
208      * Tokens usually opt for a value of 18, imitating the relationship between
209      * Ether and Wei. This is the value {ERC20} uses, unless this function is
210      * overridden;
211      *
212      * NOTE: This information is only used for _display_ purposes: it in
213      * no way affects any of the arithmetic of the contract, including
214      * {IERC20-balanceOf} and {IERC20-transfer}.
215      */
216     function decimals() public view virtual override returns (uint8) {
217         return 18;
218     }
219 
220     /**
221      * @dev See {IERC20-totalSupply}.
222      */
223     function totalSupply() public view virtual override returns (uint256) {
224         return _totalSupply;
225     }
226 
227     /**
228      * @dev See {IERC20-balanceOf}.
229      */
230     function balanceOf(address account) public view virtual override returns (uint256) {
231         return _balances[account];
232     }
233 
234     /**
235      * @dev See {IERC20-transfer}.
236      *
237      * Requirements:
238      *
239      * - `recipient` cannot be the zero address.
240      * - the caller must have a balance of at least `amount`.
241      */
242     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See {IERC20-allowance}.
249      */
250     function allowance(address owner, address spender) public view virtual override returns (uint256) {
251         return _allowances[owner][spender];
252     }
253 
254     /**
255      * @dev See {IERC20-approve}.
256      *
257      * Requirements:
258      *
259      * - `spender` cannot be the zero address.
260      */
261     function approve(address spender, uint256 amount) public virtual override returns (bool) {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265 
266     /**
267      * @dev See {IERC20-transferFrom}.
268      *
269      * Emits an {Approval} event indicating the updated allowance. This is not
270      * required by the EIP. See the note at the beginning of {ERC20}.
271      *
272      * Requirements:
273      *
274      * - `sender` and `recipient` cannot be the zero address.
275      * - `sender` must have a balance of at least `amount`.
276      * - the caller must have allowance for ``sender``'s tokens of at least
277      * `amount`.
278      */
279     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
280         _transfer(sender, recipient, amount);
281 
282         uint256 currentAllowance = _allowances[sender][_msgSender()];
283         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
284         _approve(sender, _msgSender(), currentAllowance - amount);
285 
286         return true;
287     }
288 
289     /**
290      * @dev Atomically increases the allowance granted to `spender` by the caller.
291      *
292      * This is an alternative to {approve} that can be used as a mitigation for
293      * problems described in {IERC20-approve}.
294      *
295      * Emits an {Approval} event indicating the updated allowance.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      */
301     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
302         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
303         return true;
304     }
305 
306     /**
307      * @dev Atomically decreases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      * - `spender` must have allowance for the caller of at least
318      * `subtractedValue`.
319      */
320     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
321         uint256 currentAllowance = _allowances[_msgSender()][spender];
322         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
323         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
324 
325         return true;
326     }
327 
328     /**
329      * @dev Moves tokens `amount` from `sender` to `recipient`.
330      *
331      * This is internal function is equivalent to {transfer}, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a {Transfer} event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
343         require(sender != address(0), "ERC20: transfer from the zero address");
344         require(recipient != address(0), "ERC20: transfer to the zero address");
345 
346         _beforeTokenTransfer(sender, recipient, amount);
347 
348         uint256 senderBalance = _balances[sender];
349         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
350         _balances[sender] = senderBalance - amount;
351         _balances[recipient] += amount;
352 
353         emit Transfer(sender, recipient, amount);
354     }
355 
356     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
357      * the total supply.
358      *
359      * Emits a {Transfer} event with `from` set to the zero address.
360      *
361      * Requirements:
362      *
363      * - `to` cannot be the zero address.
364      */
365     function _mint(address account, uint256 amount) internal virtual {
366         require(account != address(0), "ERC20: mint to the zero address");
367 
368         _beforeTokenTransfer(address(0), account, amount);
369 
370         _totalSupply += amount;
371         _balances[account] += amount;
372         emit Transfer(address(0), account, amount);
373     }
374 
375     /**
376      * @dev Destroys `amount` tokens from `account`, reducing the
377      * total supply.
378      *
379      * Emits a {Transfer} event with `to` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      * - `account` must have at least `amount` tokens.
385      */
386     function _burn(address account, uint256 amount) internal virtual {
387         require(account != address(0), "ERC20: burn from the zero address");
388 
389         _beforeTokenTransfer(account, address(0), amount);
390 
391         uint256 accountBalance = _balances[account];
392         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
393         _balances[account] = accountBalance - amount;
394         _totalSupply -= amount;
395 
396         emit Transfer(account, address(0), amount);
397     }
398 
399     /**
400      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
401      *
402      * This internal function is equivalent to `approve`, and can be used to
403      * e.g. set automatic allowances for certain subsystems, etc.
404      *
405      * Emits an {Approval} event.
406      *
407      * Requirements:
408      *
409      * - `owner` cannot be the zero address.
410      * - `spender` cannot be the zero address.
411      */
412     function _approve(address owner, address spender, uint256 amount) internal virtual {
413         require(owner != address(0), "ERC20: approve from the zero address");
414         require(spender != address(0), "ERC20: approve to the zero address");
415 
416         _allowances[owner][spender] = amount;
417         emit Approval(owner, spender, amount);
418     }
419 
420     /**
421      * @dev Hook that is called before any transfer of tokens. This includes
422      * minting and burning.
423      *
424      * Calling conditions:
425      *
426      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
427      * will be to transferred to `to`.
428      * - when `from` is zero, `amount` tokens will be minted for `to`.
429      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
430      * - `from` and `to` are never both zero.
431      *
432      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
433      */
434     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
435 }
436 
437 // File: @openzeppelin/contracts/access/Ownable.sol
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Contract module which provides a basic access control mechanism, where
443  * there is an account (an owner) that can be granted exclusive access to
444  * specific functions.
445  *
446  * By default, the owner account will be the one that deploys the contract. This
447  * can later be changed with {transferOwnership}.
448  *
449  * This module is used through inheritance. It will make available the modifier
450  * `onlyOwner`, which can be applied to your functions to restrict their use to
451  * the owner.
452  */
453 abstract contract Ownable is Context {
454     address private _owner;
455 
456     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
457 
458     /**
459      * @dev Initializes the contract setting the deployer as the initial owner.
460      */
461     constructor () {
462         address msgSender = _msgSender();
463         _owner = msgSender;
464         emit OwnershipTransferred(address(0), msgSender);
465     }
466 
467     /**
468      * @dev Returns the address of the current owner.
469      */
470     function owner() public view virtual returns (address) {
471         return _owner;
472     }
473 
474     /**
475      * @dev Throws if called by any account other than the owner.
476      */
477     modifier onlyOwner() {
478         require(owner() == _msgSender(), "Ownable: caller is not the owner");
479         _;
480     }
481 
482     /**
483      * @dev Leaves the contract without owner. It will not be possible to call
484      * `onlyOwner` functions anymore. Can only be called by the current owner.
485      *
486      * NOTE: Renouncing ownership will leave the contract without an owner,
487      * thereby removing any functionality that is only available to the owner.
488      */
489     function renounceOwnership() public virtual onlyOwner {
490         emit OwnershipTransferred(_owner, address(0));
491         _owner = address(0);
492     }
493 
494     /**
495      * @dev Transfers ownership of the contract to a new account (`newOwner`).
496      * Can only be called by the current owner.
497      */
498     function transferOwnership(address newOwner) public virtual onlyOwner {
499         require(newOwner != address(0), "Ownable: new owner is the zero address");
500         emit OwnershipTransferred(_owner, newOwner);
501         _owner = newOwner;
502     }
503 }
504 
505 // File: contracts/SakeInu.sol
506 
507 pragma solidity ^0.8.0;
508 
509 
510 
511 contract SakeInu is ERC20, Ownable {
512     constructor() ERC20("Sake Inu", "SAKEINU") {
513         _mint(msg.sender, 1000000000000 * 10 ** decimals());
514     }
515 }