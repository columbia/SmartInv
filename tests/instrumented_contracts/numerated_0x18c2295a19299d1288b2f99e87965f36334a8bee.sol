1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
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
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _setOwner(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _setOwner(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _setOwner(newOwner);
81     }
82 
83     function _setOwner(address newOwner) private {
84         address oldOwner = _owner;
85         _owner = newOwner;
86         emit OwnershipTransferred(oldOwner, newOwner);
87     }
88 }
89 
90 /**
91  * @dev Interface of the ERC20 standard as defined in the EIP.
92  */
93 interface IERC20 {
94     /**
95      * @dev Returns the amount of tokens in existence.
96      */
97     function totalSupply() external view returns (uint256);
98 
99     /**
100      * @dev Returns the amount of tokens owned by `account`.
101      */
102     function balanceOf(address account) external view returns (uint256);
103 
104     /**
105      * @dev Moves `amount` tokens from the caller's account to `recipient`.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transfer(address recipient, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     function allowance(address owner, address spender) external view returns (uint256);
121 
122     /**
123      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * IMPORTANT: Beware that changing an allowance with this method brings the risk
128      * that someone may use both the old and the new allowance by unfortunate
129      * transaction ordering. One possible solution to mitigate this race
130      * condition is to first reduce the spender's allowance to 0 and set the
131      * desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      *
134      * Emits an {Approval} event.
135      */
136     function approve(address spender, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Moves `amount` tokens from `sender` to `recipient` using the
140      * allowance mechanism. `amount` is then deducted from the caller's
141      * allowance.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(
148         address sender,
149         address recipient,
150         uint256 amount
151     ) external returns (bool);
152 
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 /**
169  * @dev Interface for the optional metadata functions from the ERC20 standard.
170  *
171  * _Available since v4.1._
172  */
173 interface IERC20Metadata is IERC20 {
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() external view returns (string memory);
178 
179     /**
180      * @dev Returns the symbol of the token.
181      */
182     function symbol() external view returns (string memory);
183 
184     /**
185      * @dev Returns the decimals places of the token.
186      */
187     function decimals() external view returns (uint8);
188 }
189 
190 /**
191  * @dev Implementation of the {IERC20} interface.
192  *
193  * This implementation is agnostic to the way tokens are created. This means
194  * that a supply mechanism has to be added in a derived contract using {_mint}.
195  * For a generic mechanism see {ERC20PresetMinterPauser}.
196  *
197  * TIP: For a detailed writeup see our guide
198  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
199  * to implement supply mechanisms].
200  *
201  * We have followed general OpenZeppelin Contracts guidelines: functions revert
202  * instead returning `false` on failure. This behavior is nonetheless
203  * conventional and does not conflict with the expectations of ERC20
204  * applications.
205  *
206  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
207  * This allows applications to reconstruct the allowance for all accounts just
208  * by listening to said events. Other implementations of the EIP may not emit
209  * these events, as it isn't required by the specification.
210  *
211  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
212  * functions have been added to mitigate the well-known issues around setting
213  * allowances. See {IERC20-approve}.
214  */
215 contract ERC20 is Context, IERC20, IERC20Metadata {
216     mapping(address => uint256) private _balances;
217 
218     mapping(address => mapping(address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply;
221 
222     string private _name;
223     string private _symbol;
224 
225     /**
226      * @dev Sets the values for {name} and {symbol}.
227      *
228      * The default value of {decimals} is 18. To select a different value for
229      * {decimals} you should overload it.
230      *
231      * All two of these values are immutable: they can only be set once during
232      * construction.
233      */
234     constructor(string memory name_, string memory symbol_) {
235         _name = name_;
236         _symbol = symbol_;
237     }
238 
239     /**
240      * @dev Returns the name of the token.
241      */
242     function name() public view virtual override returns (string memory) {
243         return _name;
244     }
245 
246     /**
247      * @dev Returns the symbol of the token, usually a shorter version of the
248      * name.
249      */
250     function symbol() public view virtual override returns (string memory) {
251         return _symbol;
252     }
253 
254     /**
255      * @dev Returns the number of decimals used to get its user representation.
256      * For example, if `decimals` equals `2`, a balance of `505` tokens should
257      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
258      *
259      * Tokens usually opt for a value of 18, imitating the relationship between
260      * Ether and Wei. This is the value {ERC20} uses, unless this function is
261      * overridden;
262      *
263      * NOTE: This information is only used for _display_ purposes: it in
264      * no way affects any of the arithmetic of the contract, including
265      * {IERC20-balanceOf} and {IERC20-transfer}.
266      */
267     function decimals() public view virtual override returns (uint8) {
268         return 18;
269     }
270 
271     /**
272      * @dev See {IERC20-totalSupply}.
273      */
274     function totalSupply() public view virtual override returns (uint256) {
275         return _totalSupply;
276     }
277 
278     /**
279      * @dev See {IERC20-balanceOf}.
280      */
281     function balanceOf(address account) public view virtual override returns (uint256) {
282         return _balances[account];
283     }
284 
285     /**
286      * @dev See {IERC20-transfer}.
287      *
288      * Requirements:
289      *
290      * - `recipient` cannot be the zero address.
291      * - the caller must have a balance of at least `amount`.
292      */
293     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
294         _transfer(_msgSender(), recipient, amount);
295         return true;
296     }
297 
298     /**
299      * @dev See {IERC20-allowance}.
300      */
301     function allowance(address owner, address spender) public view virtual override returns (uint256) {
302         return _allowances[owner][spender];
303     }
304 
305     /**
306      * @dev See {IERC20-approve}.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function approve(address spender, uint256 amount) public virtual override returns (bool) {
313         _approve(_msgSender(), spender, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-transferFrom}.
319      *
320      * Emits an {Approval} event indicating the updated allowance. This is not
321      * required by the EIP. See the note at the beginning of {ERC20}.
322      *
323      * Requirements:
324      *
325      * - `sender` and `recipient` cannot be the zero address.
326      * - `sender` must have a balance of at least `amount`.
327      * - the caller must have allowance for ``sender``'s tokens of at least
328      * `amount`.
329      */
330     function transferFrom(
331         address sender,
332         address recipient,
333         uint256 amount
334     ) public virtual override returns (bool) {
335         _transfer(sender, recipient, amount);
336 
337         uint256 currentAllowance = _allowances[sender][_msgSender()];
338         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
339         unchecked {
340             _approve(sender, _msgSender(), currentAllowance - amount);
341         }
342 
343         return true;
344     }
345 
346     /**
347      * @dev Atomically increases the allowance granted to `spender` by the caller.
348      *
349      * This is an alternative to {approve} that can be used as a mitigation for
350      * problems described in {IERC20-approve}.
351      *
352      * Emits an {Approval} event indicating the updated allowance.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
359         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
360         return true;
361     }
362 
363     /**
364      * @dev Atomically decreases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      * - `spender` must have allowance for the caller of at least
375      * `subtractedValue`.
376      */
377     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
378         uint256 currentAllowance = _allowances[_msgSender()][spender];
379         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
380         unchecked {
381             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
382         }
383 
384         return true;
385     }
386 
387     /**
388      * @dev Moves `amount` of tokens from `sender` to `recipient`.
389      *
390      * This internal function is equivalent to {transfer}, and can be used to
391      * e.g. implement automatic token fees, slashing mechanisms, etc.
392      *
393      * Emits a {Transfer} event.
394      *
395      * Requirements:
396      *
397      * - `sender` cannot be the zero address.
398      * - `recipient` cannot be the zero address.
399      * - `sender` must have a balance of at least `amount`.
400      */
401     function _transfer(
402         address sender,
403         address recipient,
404         uint256 amount
405     ) internal virtual {
406         require(sender != address(0), "ERC20: transfer from the zero address");
407         require(recipient != address(0), "ERC20: transfer to the zero address");
408 
409         _beforeTokenTransfer(sender, recipient, amount);
410 
411         uint256 senderBalance = _balances[sender];
412         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
413         unchecked {
414             _balances[sender] = senderBalance - amount;
415         }
416         _balances[recipient] += amount;
417 
418         emit Transfer(sender, recipient, amount);
419 
420         _afterTokenTransfer(sender, recipient, amount);
421     }
422 
423     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
424      * the total supply.
425      *
426      * Emits a {Transfer} event with `from` set to the zero address.
427      *
428      * Requirements:
429      *
430      * - `account` cannot be the zero address.
431      */
432     function _mint(address account, uint256 amount) internal virtual {
433         require(account != address(0), "ERC20: mint to the zero address");
434 
435         _beforeTokenTransfer(address(0), account, amount);
436 
437         _totalSupply += amount;
438         _balances[account] += amount;
439         emit Transfer(address(0), account, amount);
440 
441         _afterTokenTransfer(address(0), account, amount);
442     }
443 
444     /**
445      * @dev Destroys `amount` tokens from `account`, reducing the
446      * total supply.
447      *
448      * Emits a {Transfer} event with `to` set to the zero address.
449      *
450      * Requirements:
451      *
452      * - `account` cannot be the zero address.
453      * - `account` must have at least `amount` tokens.
454      */
455     function _burn(address account, uint256 amount) internal virtual {
456         require(account != address(0), "ERC20: burn from the zero address");
457 
458         _beforeTokenTransfer(account, address(0), amount);
459 
460         uint256 accountBalance = _balances[account];
461         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
462         unchecked {
463             _balances[account] = accountBalance - amount;
464         }
465         _totalSupply -= amount;
466 
467         emit Transfer(account, address(0), amount);
468 
469         _afterTokenTransfer(account, address(0), amount);
470     }
471 
472     /**
473      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
474      *
475      * This internal function is equivalent to `approve`, and can be used to
476      * e.g. set automatic allowances for certain subsystems, etc.
477      *
478      * Emits an {Approval} event.
479      *
480      * Requirements:
481      *
482      * - `owner` cannot be the zero address.
483      * - `spender` cannot be the zero address.
484      */
485     function _approve(
486         address owner,
487         address spender,
488         uint256 amount
489     ) internal virtual {
490         require(owner != address(0), "ERC20: approve from the zero address");
491         require(spender != address(0), "ERC20: approve to the zero address");
492 
493         _allowances[owner][spender] = amount;
494         emit Approval(owner, spender, amount);
495     }
496 
497     /**
498      * @dev Hook that is called before any transfer of tokens. This includes
499      * minting and burning.
500      *
501      * Calling conditions:
502      *
503      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
504      * will be transferred to `to`.
505      * - when `from` is zero, `amount` tokens will be minted for `to`.
506      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
507      * - `from` and `to` are never both zero.
508      *
509      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
510      */
511     function _beforeTokenTransfer(
512         address from,
513         address to,
514         uint256 amount
515     ) internal virtual {}
516 
517     /**
518      * @dev Hook that is called after any transfer of tokens. This includes
519      * minting and burning.
520      *
521      * Calling conditions:
522      *
523      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
524      * has been transferred to `to`.
525      * - when `from` is zero, `amount` tokens have been minted for `to`.
526      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
527      * - `from` and `to` are never both zero.
528      *
529      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
530      */
531     function _afterTokenTransfer(
532         address from,
533         address to,
534         uint256 amount
535     ) internal virtual {}
536 }
537 
538 /*
539 ⠀*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
540 ⠀*⠀⠀⠀⠀⢀⣀⣀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⣀⣀⡀⠀⠀⠀⠀⠀
541 ⠀*⠀⠀⠀⠀⢸⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⣿⡇⠀⠀⠀⠀⠀
542 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⣿⣿⣿⣿⡿⠟⠁⠀⠀⣀⣾⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀
543 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⣿⣿⡿⠋⠀⠀⠀⣠⣾⣿⡿⠋⠁⠀⣿⡇⠀⠀⠀⠀⠀
544 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⠟⠉⠀⠀⢀⣴⣾⣿⠿⠋⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀
545 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⣠⣴⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀
546 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⣠⣾⣿⡿⠋⠁⠀⠀⠀⠀⠀⣠⣶⠀⣿⡇⠀⠀⠀⠀⠀
547 ⠀*⠀⠀⠀⠀⢸⣿⠀⢸⣿⠿⠋⠀⠀⠀⠀⠀⢀⣠⣾⡿⠟⠀⣿⡇⠀⠀⠀⠀⠀
548 ⠀*⠀⠀⠀⠀⢸⣿⠀⠘⠁⠀⠀⠀⠀⠀⢀⣴⣿⡿⠋⣠⣴⠀⣿⡇⠀⠀⠀⠀⠀
549 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⣠⣾⣿⠟⢁⣠⣾⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀
550 ⠀*⠀⠀⠀⠀⢸⣿⠀⠀⠀⢀⣠⣾⡿⠋⢁⣴⣿⣿⣿⣿⣿⠀⣿⡇⠀⠀⠀⠀⠀
551 ⠀*⠀⠀⠀⠀⢸⣿⣀⣀⣀⣈⣉⣉⣀⣀⣉⣉⣉⣉⣉⣉⣉⣀⣿⡇⠀⠀⠀⠀⠀
552 ⠀*⠀⠀⠀⠀⠘⠛⠛⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠛⠛⠃⠀⠀⠀⠀⠀
553 ⠀*⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠛⠛⠛⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
554  *          MIRRORPASS.XYZ
555  */
556 contract Shards is ERC20, Ownable {
557     uint256 public shardRate = 10 ether;
558     uint256 public shardsDay = 1 days;
559     uint256 private teamRate = 0;
560     mapping(address => bool) public adminAddresses;
561 
562     modifier onlyAdmins() {
563         require(adminAddresses[msg.sender], "You're not authorized to call this");
564         _;
565     }
566 
567     constructor() ERC20("Shards", "Shards") {}
568 
569     function setAdminAddresses(address contractAddress, bool state) public onlyOwner {
570         adminAddresses[contractAddress] = state;
571     }
572 
573     function changeShardRate(uint256 newRate) public onlyOwner {
574         shardRate = newRate;
575     }
576 
577     function changeShardDay(uint256 day) public onlyOwner {
578         shardsDay = day;
579     }
580 
581     function determineYield(uint256 timestamp) public view returns(uint256) {
582         return shardRate * (block.timestamp - timestamp) / shardsDay;
583     }
584 
585     function mintShards(address wallet, uint256 amount) public onlyAdmins {
586         _mint(wallet, amount);
587     }
588 
589     function burnShards(address wallet, uint256 amount) public onlyAdmins {
590         _burn(wallet, amount);
591     }
592 
593     function setTeamRate(uint256 newRate) public onlyOwner {
594         teamRate = newRate;
595     }
596 
597     function getTeamRate() public view returns(uint256) {
598         return teamRate;
599     }
600 }