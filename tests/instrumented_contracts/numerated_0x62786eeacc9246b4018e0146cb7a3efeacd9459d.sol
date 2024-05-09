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
79 
80 
81 pragma solidity ^0.8.0;
82 
83 
84 /**
85  * @dev Interface for the optional metadata functions from the ERC20 standard.
86  *
87  * _Available since v4.1._
88  */
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns (string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns (string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns (uint8);
104 }
105 
106 
107 
108 pragma solidity ^0.8.0;
109 
110 /*
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
127         return msg.data;
128     }
129 }
130 
131 
132 
133 pragma solidity ^0.8.0;
134 
135 
136 
137 
138 /**
139  * @dev Implementation of the {IERC20} interface.
140  *
141  * This implementation is agnostic to the way tokens are created. This means
142  * that a supply mechanism has to be added in a derived contract using {_mint}.
143  * For a generic mechanism see {ERC20PresetMinterPauser}.
144  *
145  * TIP: For a detailed writeup see our guide
146  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
147  * to implement supply mechanisms].
148  *
149  * We have followed general OpenZeppelin guidelines: functions revert instead
150  * of returning `false` on failure. This behavior is nonetheless conventional
151  * and does not conflict with the expectations of ERC20 applications.
152  *
153  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
154  * This allows applications to reconstruct the allowance for all accounts just
155  * by listening to said events. Other implementations of the EIP may not emit
156  * these events, as it isn't required by the specification.
157  *
158  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
159  * functions have been added to mitigate the well-known issues around setting
160  * allowances. See {IERC20-approve}.
161  */
162 contract ERC20 is Context, IERC20, IERC20Metadata {
163     mapping (address => uint256) private _balances;
164 
165     mapping (address => mapping (address => uint256)) private _allowances;
166 
167     uint256 private _totalSupply;
168 
169     string private _name;
170     string private _symbol;
171 
172     /**
173      * @dev Sets the values for {name} and {symbol}.
174      *
175      * The defaut value of {decimals} is 18. To select a different value for
176      * {decimals} you should overload it.
177      *
178      * All two of these values are immutable: they can only be set once during
179      * construction.
180      */
181     constructor (string memory name_, string memory symbol_) {
182         _name = name_;
183         _symbol = symbol_;
184     }
185 
186     /**
187      * @dev Returns the name of the token.
188      */
189     function name() public view virtual override returns (string memory) {
190         return _name;
191     }
192 
193     /**
194      * @dev Returns the symbol of the token, usually a shorter version of the
195      * name.
196      */
197     function symbol() public view virtual override returns (string memory) {
198         return _symbol;
199     }
200 
201     /**
202      * @dev Returns the number of decimals used to get its user representation.
203      * For example, if `decimals` equals `2`, a balance of `505` tokens should
204      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
205      *
206      * Tokens usually opt for a value of 18, imitating the relationship between
207      * Ether and Wei. This is the value {ERC20} uses, unless this function is
208      * overridden;
209      *
210      * NOTE: This information is only used for _display_ purposes: it in
211      * no way affects any of the arithmetic of the contract, including
212      * {IERC20-balanceOf} and {IERC20-transfer}.
213      */
214     function decimals() public view virtual override returns (uint8) {
215         return 18;
216     }
217 
218     /**
219      * @dev See {IERC20-totalSupply}.
220      */
221     function totalSupply() public view virtual override returns (uint256) {
222         return _totalSupply;
223     }
224 
225     /**
226      * @dev See {IERC20-balanceOf}.
227      */
228     function balanceOf(address account) public view virtual override returns (uint256) {
229         return _balances[account];
230     }
231 
232     /**
233      * @dev See {IERC20-transfer}.
234      *
235      * Requirements:
236      *
237      * - `recipient` cannot be the zero address.
238      * - the caller must have a balance of at least `amount`.
239      */
240     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244 
245     /**
246      * @dev See {IERC20-allowance}.
247      */
248     function allowance(address owner, address spender) public view virtual override returns (uint256) {
249         return _allowances[owner][spender];
250     }
251 
252     /**
253      * @dev See {IERC20-approve}.
254      *
255      * Requirements:
256      *
257      * - `spender` cannot be the zero address.
258      */
259     function approve(address spender, uint256 amount) public virtual override returns (bool) {
260         _approve(_msgSender(), spender, amount);
261         return true;
262     }
263 
264     /**
265      * @dev See {IERC20-transferFrom}.
266      *
267      * Emits an {Approval} event indicating the updated allowance. This is not
268      * required by the EIP. See the note at the beginning of {ERC20}.
269      *
270      * Requirements:
271      *
272      * - `sender` and `recipient` cannot be the zero address.
273      * - `sender` must have a balance of at least `amount`.
274      * - the caller must have allowance for ``sender``'s tokens of at least
275      * `amount`.
276      */
277     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
278         _transfer(sender, recipient, amount);
279 
280         uint256 currentAllowance = _allowances[sender][_msgSender()];
281         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
282         _approve(sender, _msgSender(), currentAllowance - amount);
283 
284         return true;
285     }
286 
287     /**
288      * @dev Atomically increases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
300         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically decreases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      * - `spender` must have allowance for the caller of at least
316      * `subtractedValue`.
317      */
318     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
319         uint256 currentAllowance = _allowances[_msgSender()][spender];
320         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
321         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
322 
323         return true;
324     }
325 
326     /**
327      * @dev Moves tokens `amount` from `sender` to `recipient`.
328      *
329      * This is internal function is equivalent to {transfer}, and can be used to
330      * e.g. implement automatic token fees, slashing mechanisms, etc.
331      *
332      * Emits a {Transfer} event.
333      *
334      * Requirements:
335      *
336      * - `sender` cannot be the zero address.
337      * - `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `amount`.
339      */
340     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
341         require(sender != address(0), "ERC20: transfer from the zero address");
342         require(recipient != address(0), "ERC20: transfer to the zero address");
343 
344         _beforeTokenTransfer(sender, recipient, amount);
345 
346         uint256 senderBalance = _balances[sender];
347         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
348         _balances[sender] = senderBalance - amount;
349         _balances[recipient] += amount;
350 
351         emit Transfer(sender, recipient, amount);
352     }
353 
354     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
355      * the total supply.
356      *
357      * Emits a {Transfer} event with `from` set to the zero address.
358      *
359      * Requirements:
360      *
361      * - `to` cannot be the zero address.
362      */
363     function _mint(address account, uint256 amount) internal virtual {
364         require(account != address(0), "ERC20: mint to the zero address");
365 
366         _beforeTokenTransfer(address(0), account, amount);
367 
368         _totalSupply += amount;
369         _balances[account] += amount;
370         emit Transfer(address(0), account, amount);
371     }
372 
373     /**
374      * @dev Destroys `amount` tokens from `account`, reducing the
375      * total supply.
376      *
377      * Emits a {Transfer} event with `to` set to the zero address.
378      *
379      * Requirements:
380      *
381      * - `account` cannot be the zero address.
382      * - `account` must have at least `amount` tokens.
383      */
384     function _burn(address account, uint256 amount) internal virtual {
385         require(account != address(0), "ERC20: burn from the zero address");
386 
387         _beforeTokenTransfer(account, address(0), amount);
388 
389         uint256 accountBalance = _balances[account];
390         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
391         _balances[account] = accountBalance - amount;
392         _totalSupply -= amount;
393 
394         emit Transfer(account, address(0), amount);
395     }
396 
397     /**
398      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
399      *
400      * This internal function is equivalent to `approve`, and can be used to
401      * e.g. set automatic allowances for certain subsystems, etc.
402      *
403      * Emits an {Approval} event.
404      *
405      * Requirements:
406      *
407      * - `owner` cannot be the zero address.
408      * - `spender` cannot be the zero address.
409      */
410     function _approve(address owner, address spender, uint256 amount) internal virtual {
411         require(owner != address(0), "ERC20: approve from the zero address");
412         require(spender != address(0), "ERC20: approve to the zero address");
413 
414         _allowances[owner][spender] = amount;
415         emit Approval(owner, spender, amount);
416     }
417 
418     /**
419      * @dev Hook that is called before any transfer of tokens. This includes
420      * minting and burning.
421      *
422      * Calling conditions:
423      *
424      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
425      * will be to transferred to `to`.
426      * - when `from` is zero, `amount` tokens will be minted for `to`.
427      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
428      * - `from` and `to` are never both zero.
429      *
430      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
431      */
432     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
433 }
434 
435 
436 
437 pragma solidity ^0.8.0;
438 
439 
440 
441 /**
442  * @dev Extension of {ERC20} that allows token holders to destroy both their own
443  * tokens and those that they have an allowance for, in a way that can be
444  * recognized off-chain (via event analysis).
445  */
446 abstract contract ERC20Burnable is Context, ERC20 {
447     /**
448      * @dev Destroys `amount` tokens from the caller.
449      *
450      * See {ERC20-_burn}.
451      */
452     function burn(uint256 amount) public virtual {
453         _burn(_msgSender(), amount);
454     }
455 
456     /**
457      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
458      * allowance.
459      *
460      * See {ERC20-_burn} and {ERC20-allowance}.
461      *
462      * Requirements:
463      *
464      * - the caller must have allowance for ``accounts``'s tokens of at least
465      * `amount`.
466      */
467     function burnFrom(address account, uint256 amount) public virtual {
468         uint256 currentAllowance = allowance(account, _msgSender());
469         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
470         _approve(account, _msgSender(), currentAllowance - amount);
471         _burn(account, amount);
472     }
473 }
474 
475 
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Contract module which provides a basic access control mechanism, where
481  * there is an account (an owner) that can be granted exclusive access to
482  * specific functions.
483  *
484  * By default, the owner account will be the one that deploys the contract. This
485  * can later be changed with {transferOwnership}.
486  *
487  * This module is used through inheritance. It will make available the modifier
488  * `onlyOwner`, which can be applied to your functions to restrict their use to
489  * the owner.
490  */
491 abstract contract Ownable is Context {
492     address private _owner;
493 
494     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
495 
496     /**
497      * @dev Initializes the contract setting the deployer as the initial owner.
498      */
499     constructor () {
500         address msgSender = _msgSender();
501         _owner = msgSender;
502         emit OwnershipTransferred(address(0), msgSender);
503     }
504 
505     /**
506      * @dev Returns the address of the current owner.
507      */
508     function owner() public view virtual returns (address) {
509         return _owner;
510     }
511 
512     /**
513      * @dev Throws if called by any account other than the owner.
514      */
515     modifier onlyOwner() {
516         require(owner() == _msgSender(), "Ownable: caller is not the owner");
517         _;
518     }
519 
520     /**
521      * @dev Leaves the contract without owner. It will not be possible to call
522      * `onlyOwner` functions anymore. Can only be called by the current owner.
523      *
524      * NOTE: Renouncing ownership will leave the contract without an owner,
525      * thereby removing any functionality that is only available to the owner.
526      */
527     function renounceOwnership() public virtual onlyOwner {
528         emit OwnershipTransferred(_owner, address(0));
529         _owner = address(0);
530     }
531 
532     /**
533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
534      * Can only be called by the current owner.
535      */
536     function transferOwnership(address newOwner) public virtual onlyOwner {
537         require(newOwner != address(0), "Ownable: new owner is the zero address");
538         emit OwnershipTransferred(_owner, newOwner);
539         _owner = newOwner;
540     }
541 }
542 
543 
544 
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev Contract module that helps prevent reentrant calls to a function.
549  *
550  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
551  * available, which can be applied to functions to make sure there are no nested
552  * (reentrant) calls to them.
553  *
554  * Note that because there is a single `nonReentrant` guard, functions marked as
555  * `nonReentrant` may not call one another. This can be worked around by making
556  * those functions `private`, and then adding `external` `nonReentrant` entry
557  * points to them.
558  *
559  * TIP: If you would like to learn more about reentrancy and alternative ways
560  * to protect against it, check out our blog post
561  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
562  */
563 abstract contract ReentrancyGuard {
564     // Booleans are more expensive than uint256 or any type that takes up a full
565     // word because each write operation emits an extra SLOAD to first read the
566     // slot's contents, replace the bits taken up by the boolean, and then write
567     // back. This is the compiler's defense against contract upgrades and
568     // pointer aliasing, and it cannot be disabled.
569 
570     // The values being non-zero value makes deployment a bit more expensive,
571     // but in exchange the refund on every call to nonReentrant will be lower in
572     // amount. Since refunds are capped to a percentage of the total
573     // transaction's gas, it is best to keep them low in cases like this one, to
574     // increase the likelihood of the full refund coming into effect.
575     uint256 private constant _NOT_ENTERED = 1;
576     uint256 private constant _ENTERED = 2;
577 
578     uint256 private _status;
579 
580     constructor () {
581         _status = _NOT_ENTERED;
582     }
583 
584     /**
585      * @dev Prevents a contract from calling itself, directly or indirectly.
586      * Calling a `nonReentrant` function from another `nonReentrant`
587      * function is not supported. It is possible to prevent this from happening
588      * by making the `nonReentrant` function external, and make it call a
589      * `private` function that does the actual work.
590      */
591     modifier nonReentrant() {
592         // On the first call to nonReentrant, _notEntered will be true
593         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
594 
595         // Any calls to nonReentrant after this point will fail
596         _status = _ENTERED;
597 
598         _;
599 
600         // By storing the original value once again, a refund is triggered (see
601         // https://eips.ethereum.org/EIPS/eip-2200)
602         _status = _NOT_ENTERED;
603     }
604 }
605 
606 
607 
608 pragma solidity ^0.8.0;
609 
610 
611 
612 
613 contract LessToken is ERC20Burnable, Ownable, ReentrancyGuard {
614 
615     constructor() ERC20("LessToken", "LESS") {
616         _mint(owner(), 1250000000 * (10**18));
617     }
618 
619     function extractLostCrypto() external onlyOwner {
620         payable(owner()).transfer(address(this).balance);
621     }
622 
623     function extractLostToken(address tokenToExtract) external nonReentrant onlyOwner {
624         IERC20(tokenToExtract).transfer(owner(), IERC20(tokenToExtract).balanceOf(address(this)));
625     }
626 }