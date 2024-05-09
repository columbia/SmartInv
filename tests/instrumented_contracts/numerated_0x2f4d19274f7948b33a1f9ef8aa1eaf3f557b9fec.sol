1 // hevm: flattened sources of src/FLIXtoken.sol
2 // SPDX-License-Identifier: MIT
3 
4 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 //⠀⠀⠀⠀⠀⢀⣠⣴⣾⡿⠿⠟⠛⠿⠿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 //⠀⠀⠀⢀⣴⣿⢿⣿⣿⣧⠀⠀⠀⠀⢠⣿⣿⣿⢿⣷⡄⠱⣦⡀⠀⠀⠀⠀⠀⠀
7 //⠀⠀⢀⣾⠏⠀⠀⠙⢿⣿⣧⡀⠀⣠⣿⣿⠟⠁⠀⠹⣿⣆⠈⠻⣦⡀⠀⠀⠀⠀
8 //⠀⠀⣾⡏⠀⠀⠀⠀⠈⣿⣿⣷⣾⣿⣿⡏⠀⠀⠀⠀⢸⣿⡆⠀⠈⢻⣄⠀⠀⠀
9 //⠀⢸⣿⣷⣤⣤⣤⣤⣴⣿⠋⣠⣤⡈⢻⣷⣤⣤⣤⣤⣴⣿⣷⠀⠀⠀⢻⣆⠀⠀
10 //⠀⢸⣿⣿⠿⠿⠿⠿⠿⣿⡀⠻⠿⠃⣸⡿⠿⠿⠿⠿⢿⣿⣿⠀⠀⠀⠀⢿⡄⠀
11 //⠀⠀⣿⣇⠀⠀⠀⠀⠀⣿⣿⣶⣶⣾⣿⡇⠀⠀⠀⠀⢰⣿⡇⠀⠀⠀⠀⢸⡇⠀
12 //⠀⠀⠘⣿⣆⠀⠀⢀⣼⣿⡟⠁⠈⠻⣿⣿⣄⠀⠀⢠⣾⡟⠀⠀⠀⠀⠀⢸⡇⠀
13 //⠀⠀⠀⠘⢿⣷⣶⣿⣿⡟⠀⠀⠀⠀⠘⣿⣿⣷⣶⣿⠏⠀⠀⠀⠀⠀⠀⢸⡇⠀
14 //⠀⠀⠀⠀⠀⠉⠻⢿⣿⣷⣤⣤⣤⣤⣴⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⣿⠃⠀
15 //⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠛⠛⠛⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠀⠀
16 //⠀⠀⠀⠀⠀⣀⣤⣴⠶⠶⠶⠷⠶⠶⢶⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⢠⡿⠀⠀⠀
17 //⠀⢀⣠⡶⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠳⢶⣤⣄⣀⣴⠟⠁⠀⠀⠀
18 //⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀
19 
20 
21 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
22 pragma experimental ABIEncoderV2;
23 
24 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
25 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
26 
27 /* pragma solidity ^0.8.0; */
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
50 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
51 
52 /* pragma solidity ^0.8.0; */
53 
54 /* import "../utils/Context.sol"; */
55 
56 /**
57  * @dev Contract module which provides a basic access control mechanism, where
58  * there is an account (an owner) that can be granted exclusive access to
59  * specific functions.
60  *
61  * By default, the owner account will be the one that deploys the contract. This
62  * can later be changed with {transferOwnership}.
63  *
64  * This module is used through inheritance. It will make available the modifier
65  * `onlyOwner`, which can be applied to your functions to restrict their use to
66  * the owner.
67  */
68 abstract contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     /**
74      * @dev Initializes the contract setting the deployer as the initial owner.
75      */
76     constructor() {
77         _transferOwnership(_msgSender());
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view virtual returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(owner() == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions anymore. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public virtual onlyOwner {
103         _transferOwnership(address(0));
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         _transferOwnership(newOwner);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Internal function without access restriction.
118      */
119     function _transferOwnership(address newOwner) internal virtual {
120         address oldOwner = _owner;
121         _owner = newOwner;
122         emit OwnershipTransferred(oldOwner, newOwner);
123     }
124 }
125 
126 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
127 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
128 
129 /* pragma solidity ^0.8.0; */
130 
131 /**
132  * @dev Interface of the ERC20 standard as defined in the EIP.
133  */
134 interface IERC20 {
135     /**
136      * @dev Returns the amount of tokens in existence.
137      */
138     function totalSupply() external view returns (uint256);
139 
140     /**
141      * @dev Returns the amount of tokens owned by `account`.
142      */
143     function balanceOf(address account) external view returns (uint256);
144 
145     /**
146      * @dev Moves `amount` tokens from the caller's account to `recipient`.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transfer(address recipient, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Returns the remaining number of tokens that `spender` will be
156      * allowed to spend on behalf of `owner` through {transferFrom}. This is
157      * zero by default.
158      *
159      * This value changes when {approve} or {transferFrom} are called.
160      */
161     function allowance(address owner, address spender) external view returns (uint256);
162 
163     /**
164      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * IMPORTANT: Beware that changing an allowance with this method brings the risk
169      * that someone may use both the old and the new allowance by unfortunate
170      * transaction ordering. One possible solution to mitigate this race
171      * condition is to first reduce the spender's allowance to 0 and set the
172      * desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      *
175      * Emits an {Approval} event.
176      */
177     function approve(address spender, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Moves `amount` tokens from `sender` to `recipient` using the
181      * allowance mechanism. `amount` is then deducted from the caller's
182      * allowance.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transferFrom(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) external returns (bool);
193 
194     /**
195      * @dev Emitted when `value` tokens are moved from one account (`from`) to
196      * another (`to`).
197      *
198      * Note that `value` may be zero.
199      */
200     event Transfer(address indexed from, address indexed to, uint256 value);
201 
202     /**
203      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
204      * a call to {approve}. `value` is the new allowance.
205      */
206     event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
210 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
211 
212 /* pragma solidity ^0.8.0; */
213 
214 /* import "../IERC20.sol"; */
215 
216 /**
217  * @dev Interface for the optional metadata functions from the ERC20 standard.
218  *
219  * _Available since v4.1._
220  */
221 interface IERC20Metadata is IERC20 {
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() external view returns (string memory);
226 
227     /**
228      * @dev Returns the symbol of the token.
229      */
230     function symbol() external view returns (string memory);
231 
232     /**
233      * @dev Returns the decimals places of the token.
234      */
235     function decimals() external view returns (uint8);
236 }
237 
238 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
239 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
240 
241 /* pragma solidity ^0.8.0; */
242 
243 /* import "./IERC20.sol"; */
244 /* import "./extensions/IERC20Metadata.sol"; */
245 /* import "../../utils/Context.sol"; */
246 
247 /**
248  * @dev Implementation of the {IERC20} interface.
249  *
250  * This implementation is agnostic to the way tokens are created. This means
251  * that a supply mechanism has to be added in a derived contract using {_mint}.
252  * For a generic mechanism see {ERC20PresetMinterPauser}.
253  *
254  * TIP: For a detailed writeup see our guide
255  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
256  * to implement supply mechanisms].
257  *
258  * We have followed general OpenZeppelin Contracts guidelines: functions revert
259  * instead returning `false` on failure. This behavior is nonetheless
260  * conventional and does not conflict with the expectations of ERC20
261  * applications.
262  *
263  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
264  * This allows applications to reconstruct the allowance for all accounts just
265  * by listening to said events. Other implementations of the EIP may not emit
266  * these events, as it isn't required by the specification.
267  *
268  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
269  * functions have been added to mitigate the well-known issues around setting
270  * allowances. See {IERC20-approve}.
271  */
272 contract ERC20 is Context, IERC20, IERC20Metadata {
273     mapping(address => uint256) private _balances;
274 
275     mapping(address => mapping(address => uint256)) private _allowances;
276 
277     uint256 private _totalSupply;
278 
279     string private _name;
280     string private _symbol;
281 
282     /**
283      * @dev Sets the values for {name} and {symbol}.
284      *
285      * The default value of {decimals} is 18. To select a different value for
286      * {decimals} you should overload it.
287      *
288      * All two of these values are immutable: they can only be set once during
289      * construction.
290      */
291     constructor(string memory name_, string memory symbol_) {
292         _name = name_;
293         _symbol = symbol_;
294     }
295 
296     /**
297      * @dev Returns the name of the token.
298      */
299     function name() public view virtual override returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @dev Returns the symbol of the token, usually a shorter version of the
305      * name.
306      */
307     function symbol() public view virtual override returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @dev Returns the number of decimals used to get its user representation.
313      * For example, if `decimals` equals `2`, a balance of `505` tokens should
314      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
315      *
316      * Tokens usually opt for a value of 18, imitating the relationship between
317      * Ether and Wei. This is the value {ERC20} uses, unless this function is
318      * overridden;
319      *
320      * NOTE: This information is only used for _display_ purposes: it in
321      * no way affects any of the arithmetic of the contract, including
322      * {IERC20-balanceOf} and {IERC20-transfer}.
323      */
324     function decimals() public view virtual override returns (uint8) {
325         return 18;
326     }
327 
328     /**
329      * @dev See {IERC20-totalSupply}.
330      */
331     function totalSupply() public view virtual override returns (uint256) {
332         return _totalSupply;
333     }
334 
335     /**
336      * @dev See {IERC20-balanceOf}.
337      */
338     function balanceOf(address account) public view virtual override returns (uint256) {
339         return _balances[account];
340     }
341 
342     /**
343      * @dev See {IERC20-transfer}.
344      *
345      * Requirements:
346      *
347      * - `recipient` cannot be the zero address.
348      * - the caller must have a balance of at least `amount`.
349      */
350     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
351         _transfer(_msgSender(), recipient, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-allowance}.
357      */
358     function allowance(address owner, address spender) public view virtual override returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     /**
363      * @dev See {IERC20-approve}.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function approve(address spender, uint256 amount) public virtual override returns (bool) {
370         _approve(_msgSender(), spender, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-transferFrom}.
376      *
377      * Emits an {Approval} event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of {ERC20}.
379      *
380      * Requirements:
381      *
382      * - `sender` and `recipient` cannot be the zero address.
383      * - `sender` must have a balance of at least `amount`.
384      * - the caller must have allowance for ``sender``'s tokens of at least
385      * `amount`.
386      */
387     function transferFrom(
388         address sender,
389         address recipient,
390         uint256 amount
391     ) public virtual override returns (bool) {
392         _transfer(sender, recipient, amount);
393 
394         uint256 currentAllowance = _allowances[sender][_msgSender()];
395         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
396         unchecked {
397             _approve(sender, _msgSender(), currentAllowance - amount);
398         }
399 
400         return true;
401     }
402 
403     /**
404      * @dev Atomically increases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      */
415     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
416         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
417         return true;
418     }
419 
420     /**
421      * @dev Atomically decreases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      * - `spender` must have allowance for the caller of at least
432      * `subtractedValue`.
433      */
434     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
435         uint256 currentAllowance = _allowances[_msgSender()][spender];
436         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
437         unchecked {
438             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
439         }
440 
441         return true;
442     }
443 
444     /**
445      * @dev Moves `amount` of tokens from `sender` to `recipient`.
446      *
447      * This internal function is equivalent to {transfer}, and can be used to
448      * e.g. implement automatic token fees, slashing mechanisms, etc.
449      *
450      * Emits a {Transfer} event.
451      *
452      * Requirements:
453      *
454      * - `sender` cannot be the zero address.
455      * - `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      */
458     function _transfer(
459         address sender,
460         address recipient,
461         uint256 amount
462     ) internal virtual {
463         require(sender != address(0), "ERC20: transfer from the zero address");
464         require(recipient != address(0), "ERC20: transfer to the zero address");
465 
466         _beforeTokenTransfer(sender, recipient, amount);
467 
468         uint256 senderBalance = _balances[sender];
469         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
470         unchecked {
471             _balances[sender] = senderBalance - amount;
472         }
473         _balances[recipient] += amount;
474 
475         emit Transfer(sender, recipient, amount);
476 
477         _afterTokenTransfer(sender, recipient, amount);
478     }
479 
480     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
481      * the total supply.
482      *
483      * Emits a {Transfer} event with `from` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `account` cannot be the zero address.
488      */
489     function _mint(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: mint to the zero address");
491 
492         _beforeTokenTransfer(address(0), account, amount);
493 
494         _totalSupply += amount;
495         _balances[account] += amount;
496         emit Transfer(address(0), account, amount);
497 
498         _afterTokenTransfer(address(0), account, amount);
499     }
500 
501     /**
502      * @dev Destroys `amount` tokens from `account`, reducing the
503      * total supply.
504      *
505      * Emits a {Transfer} event with `to` set to the zero address.
506      *
507      * Requirements:
508      *
509      * - `account` cannot be the zero address.
510      * - `account` must have at least `amount` tokens.
511      */
512     function _burn(address account, uint256 amount) internal virtual {
513         require(account != address(0), "ERC20: burn from the zero address");
514 
515         _beforeTokenTransfer(account, address(0), amount);
516 
517         uint256 accountBalance = _balances[account];
518         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
519         unchecked {
520             _balances[account] = accountBalance - amount;
521         }
522         _totalSupply -= amount;
523 
524         emit Transfer(account, address(0), amount);
525 
526         _afterTokenTransfer(account, address(0), amount);
527     }
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
531      *
532      * This internal function is equivalent to `approve`, and can be used to
533      * e.g. set automatic allowances for certain subsystems, etc.
534      *
535      * Emits an {Approval} event.
536      *
537      * Requirements:
538      *
539      * - `owner` cannot be the zero address.
540      * - `spender` cannot be the zero address.
541      */
542     function _approve(
543         address owner,
544         address spender,
545         uint256 amount
546     ) internal virtual {
547         require(owner != address(0), "ERC20: approve from the zero address");
548         require(spender != address(0), "ERC20: approve to the zero address");
549 
550         _allowances[owner][spender] = amount;
551         emit Approval(owner, spender, amount);
552     }
553 
554     /**
555      * @dev Hook that is called before any transfer of tokens. This includes
556      * minting and burning.
557      *
558      * Calling conditions:
559      *
560      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
561      * will be transferred to `to`.
562      * - when `from` is zero, `amount` tokens will be minted for `to`.
563      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
564      * - `from` and `to` are never both zero.
565      *
566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
567      */
568     function _beforeTokenTransfer(
569         address from,
570         address to,
571         uint256 amount
572     ) internal virtual {}
573 
574     /**
575      * @dev Hook that is called after any transfer of tokens. This includes
576      * minting and burning.
577      *
578      * Calling conditions:
579      *
580      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
581      * has been transferred to `to`.
582      * - when `from` is zero, `amount` tokens have been minted for `to`.
583      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
584      * - `from` and `to` are never both zero.
585      *
586      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
587      */
588     function _afterTokenTransfer(
589         address from,
590         address to,
591         uint256 amount
592     ) internal virtual {}
593 }
594 
595 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
596 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
597 
598 /* pragma solidity ^0.8.0; */
599 
600 // CAUTION
601 // This version of SafeMath should only be used with Solidity 0.8 or later,
602 // because it relies on the compiler's built in overflow checks.
603 
604 /**
605  * @dev Wrappers over Solidity's arithmetic operations.
606  *
607  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
608  * now has built in overflow checking.
609  */
610 library SafeMath {
611     /**
612      * @dev Returns the addition of two unsigned integers, with an overflow flag.
613      *
614      * _Available since v3.4._
615      */
616     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
617         unchecked {
618             uint256 c = a + b;
619             if (c < a) return (false, 0);
620             return (true, c);
621         }
622     }
623 
624     /**
625      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
626      *
627      * _Available since v3.4._
628      */
629     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
630         unchecked {
631             if (b > a) return (false, 0);
632             return (true, a - b);
633         }
634     }
635 
636     /**
637      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
638      *
639      * _Available since v3.4._
640      */
641     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
642         unchecked {
643             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
644             // benefit is lost if 'b' is also tested.
645             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
646             if (a == 0) return (true, 0);
647             uint256 c = a * b;
648             if (c / a != b) return (false, 0);
649             return (true, c);
650         }
651     }
652 
653     /**
654      * @dev Returns the division of two unsigned integers, with a division by zero flag.
655      *
656      * _Available since v3.4._
657      */
658     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
659         unchecked {
660             if (b == 0) return (false, 0);
661             return (true, a / b);
662         }
663     }
664 
665     /**
666      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
667      *
668      * _Available since v3.4._
669      */
670     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
671         unchecked {
672             if (b == 0) return (false, 0);
673             return (true, a % b);
674         }
675     }
676 
677     /**
678      * @dev Returns the addition of two unsigned integers, reverting on
679      * overflow.
680      *
681      * Counterpart to Solidity's `+` operator.
682      *
683      * Requirements:
684      *
685      * - Addition cannot overflow.
686      */
687     function add(uint256 a, uint256 b) internal pure returns (uint256) {
688         return a + b;
689     }
690 
691     /**
692      * @dev Returns the subtraction of two unsigned integers, reverting on
693      * overflow (when the result is negative).
694      *
695      * Counterpart to Solidity's `-` operator.
696      *
697      * Requirements:
698      *
699      * - Subtraction cannot overflow.
700      */
701     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a - b;
703     }
704 
705     /**
706      * @dev Returns the multiplication of two unsigned integers, reverting on
707      * overflow.
708      *
709      * Counterpart to Solidity's `*` operator.
710      *
711      * Requirements:
712      *
713      * - Multiplication cannot overflow.
714      */
715     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a * b;
717     }
718 
719     /**
720      * @dev Returns the integer division of two unsigned integers, reverting on
721      * division by zero. The result is rounded towards zero.
722      *
723      * Counterpart to Solidity's `/` operator.
724      *
725      * Requirements:
726      *
727      * - The divisor cannot be zero.
728      */
729     function div(uint256 a, uint256 b) internal pure returns (uint256) {
730         return a / b;
731     }
732 
733     /**
734      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
735      * reverting when dividing by zero.
736      *
737      * Counterpart to Solidity's `%` operator. This function uses a `revert`
738      * opcode (which leaves remaining gas untouched) while Solidity uses an
739      * invalid opcode to revert (consuming all remaining gas).
740      *
741      * Requirements:
742      *
743      * - The divisor cannot be zero.
744      */
745     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
746         return a % b;
747     }
748 
749     /**
750      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
751      * overflow (when the result is negative).
752      *
753      * CAUTION: This function is deprecated because it requires allocating memory for the error
754      * message unnecessarily. For custom revert reasons use {trySub}.
755      *
756      * Counterpart to Solidity's `-` operator.
757      *
758      * Requirements:
759      *
760      * - Subtraction cannot overflow.
761      */
762     function sub(
763         uint256 a,
764         uint256 b,
765         string memory errorMessage
766     ) internal pure returns (uint256) {
767         unchecked {
768             require(b <= a, errorMessage);
769             return a - b;
770         }
771     }
772 
773     /**
774      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
775      * division by zero. The result is rounded towards zero.
776      *
777      * Counterpart to Solidity's `/` operator. Note: this function uses a
778      * `revert` opcode (which leaves remaining gas untouched) while Solidity
779      * uses an invalid opcode to revert (consuming all remaining gas).
780      *
781      * Requirements:
782      *
783      * - The divisor cannot be zero.
784      */
785     function div(
786         uint256 a,
787         uint256 b,
788         string memory errorMessage
789     ) internal pure returns (uint256) {
790         unchecked {
791             require(b > 0, errorMessage);
792             return a / b;
793         }
794     }
795 
796     /**
797      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
798      * reverting with custom message when dividing by zero.
799      *
800      * CAUTION: This function is deprecated because it requires allocating memory for the error
801      * message unnecessarily. For custom revert reasons use {tryMod}.
802      *
803      * Counterpart to Solidity's `%` operator. This function uses a `revert`
804      * opcode (which leaves remaining gas untouched) while Solidity uses an
805      * invalid opcode to revert (consuming all remaining gas).
806      *
807      * Requirements:
808      *
809      * - The divisor cannot be zero.
810      */
811     function mod(
812         uint256 a,
813         uint256 b,
814         string memory errorMessage
815     ) internal pure returns (uint256) {
816         unchecked {
817             require(b > 0, errorMessage);
818             return a % b;
819         }
820     }
821 }
822 
823 ////// src/IUniswapV2Factory.sol
824 /* pragma solidity 0.8.10; */
825 /* pragma experimental ABIEncoderV2; */
826 
827 interface IUniswapV2Factory {
828     event PairCreated(
829         address indexed token0,
830         address indexed token1,
831         address pair,
832         uint256
833     );
834 
835     function feeTo() external view returns (address);
836 
837     function feeToSetter() external view returns (address);
838 
839     function getPair(address tokenA, address tokenB)
840         external
841         view
842         returns (address pair);
843 
844     function allPairs(uint256) external view returns (address pair);
845 
846     function allPairsLength() external view returns (uint256);
847 
848     function createPair(address tokenA, address tokenB)
849         external
850         returns (address pair);
851 
852     function setFeeTo(address) external;
853 
854     function setFeeToSetter(address) external;
855 }
856 
857 ////// src/IUniswapV2Pair.sol
858 /* pragma solidity 0.8.10; */
859 /* pragma experimental ABIEncoderV2; */
860 
861 interface IUniswapV2Pair {
862     event Approval(
863         address indexed owner,
864         address indexed spender,
865         uint256 value
866     );
867     event Transfer(address indexed from, address indexed to, uint256 value);
868 
869     function name() external pure returns (string memory);
870 
871     function symbol() external pure returns (string memory);
872 
873     function decimals() external pure returns (uint8);
874 
875     function totalSupply() external view returns (uint256);
876 
877     function balanceOf(address owner) external view returns (uint256);
878 
879     function allowance(address owner, address spender)
880         external
881         view
882         returns (uint256);
883 
884     function approve(address spender, uint256 value) external returns (bool);
885 
886     function transfer(address to, uint256 value) external returns (bool);
887 
888     function transferFrom(
889         address from,
890         address to,
891         uint256 value
892     ) external returns (bool);
893 
894     function DOMAIN_SEPARATOR() external view returns (bytes32);
895 
896     function PERMIT_TYPEHASH() external pure returns (bytes32);
897 
898     function nonces(address owner) external view returns (uint256);
899 
900     function permit(
901         address owner,
902         address spender,
903         uint256 value,
904         uint256 deadline,
905         uint8 v,
906         bytes32 r,
907         bytes32 s
908     ) external;
909 
910     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
911     event Burn(
912         address indexed sender,
913         uint256 amount0,
914         uint256 amount1,
915         address indexed to
916     );
917     event Swap(
918         address indexed sender,
919         uint256 amount0In,
920         uint256 amount1In,
921         uint256 amount0Out,
922         uint256 amount1Out,
923         address indexed to
924     );
925     event Sync(uint112 reserve0, uint112 reserve1);
926 
927     function MINIMUM_LIQUIDITY() external pure returns (uint256);
928 
929     function factory() external view returns (address);
930 
931     function token0() external view returns (address);
932 
933     function token1() external view returns (address);
934 
935     function getReserves()
936         external
937         view
938         returns (
939             uint112 reserve0,
940             uint112 reserve1,
941             uint32 blockTimestampLast
942         );
943 
944     function price0CumulativeLast() external view returns (uint256);
945 
946     function price1CumulativeLast() external view returns (uint256);
947 
948     function kLast() external view returns (uint256);
949 
950     function mint(address to) external returns (uint256 liquidity);
951 
952     function burn(address to)
953         external
954         returns (uint256 amount0, uint256 amount1);
955 
956     function swap(
957         uint256 amount0Out,
958         uint256 amount1Out,
959         address to,
960         bytes calldata data
961     ) external;
962 
963     function skim(address to) external;
964 
965     function sync() external;
966 
967     function initialize(address, address) external;
968 }
969 
970 ////// src/IUniswapV2Router02.sol
971 /* pragma solidity 0.8.10; */
972 /* pragma experimental ABIEncoderV2; */
973 
974 interface IUniswapV2Router02 {
975     function factory() external pure returns (address);
976 
977     function WETH() external pure returns (address);
978 
979     function addLiquidity(
980         address tokenA,
981         address tokenB,
982         uint256 amountADesired,
983         uint256 amountBDesired,
984         uint256 amountAMin,
985         uint256 amountBMin,
986         address to,
987         uint256 deadline
988     )
989         external
990         returns (
991             uint256 amountA,
992             uint256 amountB,
993             uint256 liquidity
994         );
995 
996     function addLiquidityETH(
997         address token,
998         uint256 amountTokenDesired,
999         uint256 amountTokenMin,
1000         uint256 amountETHMin,
1001         address to,
1002         uint256 deadline
1003     )
1004         external
1005         payable
1006         returns (
1007             uint256 amountToken,
1008             uint256 amountETH,
1009             uint256 liquidity
1010         );
1011 
1012     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1013         uint256 amountIn,
1014         uint256 amountOutMin,
1015         address[] calldata path,
1016         address to,
1017         uint256 deadline
1018     ) external;
1019 
1020     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1021         uint256 amountOutMin,
1022         address[] calldata path,
1023         address to,
1024         uint256 deadline
1025     ) external payable;
1026 
1027     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1028         uint256 amountIn,
1029         uint256 amountOutMin,
1030         address[] calldata path,
1031         address to,
1032         uint256 deadline
1033     ) external;
1034 }
1035 
1036 ////// src/FLIXtoken.sol
1037 /* pragma solidity >=0.8.10; */
1038 
1039 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1040 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1041 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1042 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1043 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1044 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1045 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1046 
1047 contract FLIX is ERC20, Ownable {
1048     using SafeMath for uint256;
1049 
1050     IUniswapV2Router02 public immutable uniswapV2Router;
1051     address public immutable uniswapV2Pair;
1052     address public constant deadAddress = address(0xdead);
1053 
1054     bool private swapping;
1055 
1056     address public filmFundWallet;
1057     address public devWallet;
1058 
1059     uint256 public maxTransactionAmount;
1060     uint256 public swapTokensAtAmount;
1061     uint256 public maxWallet;
1062 
1063     uint256 public percentForLPBurn = 25; // 25 = .25%
1064     bool public lpBurnEnabled = true;
1065     uint256 public lpBurnFrequency = 3600 seconds;
1066     uint256 public lastLpBurnTime;
1067 
1068     uint256 public manualBurnFrequency = 30 minutes;
1069     uint256 public lastManualLpBurnTime;
1070 
1071     bool public limitsInEffect = true;
1072     bool public tradingActive = false;
1073     bool public swapEnabled = false;
1074 
1075     // Anti-bot and anti-whale mappings and variables
1076     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1077     bool public transferDelayEnabled = true;
1078 
1079     uint256 public buyTotalFees;
1080     uint256 public buyfilmFundFee;
1081     uint256 public buyLiquidityFee;
1082     uint256 public buyDevFee;
1083 
1084     uint256 public sellTotalFees;
1085     uint256 public sellfilmFundFee;
1086     uint256 public sellLiquidityFee;
1087     uint256 public sellDevFee;
1088 
1089     uint256 public tokensForfilmFund;
1090     uint256 public tokensForLiquidity;
1091     uint256 public tokensForDev;
1092 
1093     /******************/
1094 
1095     // exlcude from fees and max transaction amount
1096     mapping(address => bool) private _isExcludedFromFees;
1097     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1098 
1099     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1100     // could be subject to a maximum transfer amount
1101     mapping(address => bool) public automatedMarketMakerPairs;
1102 
1103     event UpdateUniswapV2Router(
1104         address indexed newAddress,
1105         address indexed oldAddress
1106     );
1107 
1108     event ExcludeFromFees(address indexed account, bool isExcluded);
1109 
1110     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1111 
1112     event filmFundWalletUpdated(
1113         address indexed newWallet,
1114         address indexed oldWallet
1115     );
1116 
1117     event devWalletUpdated(
1118         address indexed newWallet,
1119         address indexed oldWallet
1120     );
1121 
1122     event SwapAndLiquify(
1123         uint256 tokensSwapped,
1124         uint256 ethReceived,
1125         uint256 tokensIntoLiquidity
1126     );
1127 
1128     event AutoNukeLP();
1129 
1130     event ManualNukeLP();
1131 
1132     constructor() ERC20("FLIX Token", "FLIX") {
1133         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1134             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1135         );
1136 
1137         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1138         uniswapV2Router = _uniswapV2Router;
1139 
1140         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1141             .createPair(address(this), _uniswapV2Router.WETH());
1142         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1143         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1144 
1145         uint256 _buyfilmFundFee = 5;
1146         uint256 _buyLiquidityFee = 3;
1147         uint256 _buyDevFee = 2;
1148 
1149         uint256 _sellfilmFundFee = 10;
1150         uint256 _sellLiquidityFee = 3;
1151         uint256 _sellDevFee = 2;
1152 
1153         uint256 totalSupply = 1_000_000_000 * 1e18;
1154 
1155         maxTransactionAmount = 4_321_111 * 1e18; // 1% from total supply maxTransactionAmountTxn
1156         maxWallet = 9_981_111 * 1e18; // 2% from total supply maxWallet
1157         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1158 
1159         buyfilmFundFee = _buyfilmFundFee;
1160         buyLiquidityFee = _buyLiquidityFee;
1161         buyDevFee = _buyDevFee;
1162         buyTotalFees = buyfilmFundFee + buyLiquidityFee + buyDevFee;
1163 
1164         sellfilmFundFee = _sellfilmFundFee;
1165         sellLiquidityFee = _sellLiquidityFee;
1166         sellDevFee = _sellDevFee;
1167         sellTotalFees = sellfilmFundFee + sellLiquidityFee + sellDevFee;
1168 
1169         filmFundWallet = address(0x1e2d09DeDEf500f8A57E0259023989456D98add4); // set as filmFund wallet
1170         devWallet = address(0x62c00dbf129A6439bA97F5d59A0b7cA6eb5b13Cf); // set as dev wallet
1171 
1172         // exclude from paying fees or having max transaction amount
1173         excludeFromFees(owner(), true);
1174         excludeFromFees(address(this), true);
1175         excludeFromFees(address(0xdead), true);
1176 
1177         excludeFromMaxTransaction(owner(), true);
1178         excludeFromMaxTransaction(address(this), true);
1179         excludeFromMaxTransaction(address(0xdead), true);
1180 
1181         /*
1182             _mint is an internal function in ERC20.sol that is only called here,
1183             and CANNOT be called ever again
1184         */
1185         _mint(msg.sender, totalSupply);
1186     }
1187 
1188     receive() external payable {}
1189 
1190     // once enabled, can never be turned off
1191     function enableTrading() external onlyOwner {
1192         tradingActive = true;
1193         swapEnabled = true;
1194         lastLpBurnTime = block.timestamp;
1195     }
1196 
1197     // remove limits after token is stable
1198     function removeLimits() external onlyOwner returns (bool) {
1199         limitsInEffect = false;
1200         return true;
1201     }
1202 
1203     // disable Transfer delay - cannot be reenabled
1204     function disableTransferDelay() external onlyOwner returns (bool) {
1205         transferDelayEnabled = false;
1206         return true;
1207     }
1208 
1209     // change the minimum amount of tokens to sell from fees
1210     function updateSwapTokensAtAmount(uint256 newAmount)
1211         external
1212         onlyOwner
1213         returns (bool)
1214     {
1215         require(
1216             newAmount >= (totalSupply() * 1) / 100000,
1217             "Swap amount cannot be lower than 0.001% total supply."
1218         );
1219         require(
1220             newAmount <= (totalSupply() * 5) / 1000,
1221             "Swap amount cannot be higher than 0.5% total supply."
1222         );
1223         swapTokensAtAmount = newAmount;
1224         return true;
1225     }
1226 
1227     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1228         require(
1229             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1230             "Cannot set maxTransactionAmount lower than 0.1%"
1231         );
1232         maxTransactionAmount = newNum * (10**18);
1233     }
1234 
1235     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1236         require(
1237             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1238             "Cannot set maxWallet lower than 0.5%"
1239         );
1240         maxWallet = newNum * (10**18);
1241     }
1242 
1243     function excludeFromMaxTransaction(address updAds, bool isEx)
1244         public
1245         onlyOwner
1246     {
1247         _isExcludedMaxTransactionAmount[updAds] = isEx;
1248     }
1249 
1250     // only use to disable contract sales if absolutely necessary (emergency use only)
1251     function updateSwapEnabled(bool enabled) external onlyOwner {
1252         swapEnabled = enabled;
1253     }
1254 
1255     function updateBuyFees(
1256         uint256 _filmFundFee,
1257         uint256 _liquidityFee,
1258         uint256 _devFee
1259     ) external onlyOwner {
1260         buyfilmFundFee = _filmFundFee;
1261         buyLiquidityFee = _liquidityFee;
1262         buyDevFee = _devFee;
1263         buyTotalFees = buyfilmFundFee + buyLiquidityFee + buyDevFee;
1264         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1265     }
1266 
1267     function updateSellFees(
1268         uint256 _filmFundFee,
1269         uint256 _liquidityFee,
1270         uint256 _devFee
1271     ) external onlyOwner {
1272         sellfilmFundFee = _filmFundFee;
1273         sellLiquidityFee = _liquidityFee;
1274         sellDevFee = _devFee;
1275         sellTotalFees = sellfilmFundFee + sellLiquidityFee + sellDevFee;
1276         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1277     }
1278 
1279     function excludeFromFees(address account, bool excluded) public onlyOwner {
1280         _isExcludedFromFees[account] = excluded;
1281         emit ExcludeFromFees(account, excluded);
1282     }
1283 
1284     function setAutomatedMarketMakerPair(address pair, bool value)
1285         public
1286         onlyOwner
1287     {
1288         require(
1289             pair != uniswapV2Pair,
1290             "The pair cannot be removed from automatedMarketMakerPairs"
1291         );
1292 
1293         _setAutomatedMarketMakerPair(pair, value);
1294     }
1295 
1296     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1297         automatedMarketMakerPairs[pair] = value;
1298 
1299         emit SetAutomatedMarketMakerPair(pair, value);
1300     }
1301 
1302     function updatefilmFundWallet(address newfilmFundWallet)
1303         external
1304         onlyOwner
1305     {
1306         emit filmFundWalletUpdated(newfilmFundWallet, filmFundWallet);
1307         filmFundWallet = newfilmFundWallet;
1308     }
1309 
1310     function updateDevWallet(address newWallet) external onlyOwner {
1311         emit devWalletUpdated(newWallet, devWallet);
1312         devWallet = newWallet;
1313     }
1314 
1315     function isExcludedFromFees(address account) public view returns (bool) {
1316         return _isExcludedFromFees[account];
1317     }
1318 
1319     event BoughtEarly(address indexed sniper);
1320 
1321     function _transfer(
1322         address from,
1323         address to,
1324         uint256 amount
1325     ) internal override {
1326         require(from != address(0), "ERC20: transfer from the zero address");
1327         require(to != address(0), "ERC20: transfer to the zero address");
1328 
1329         if (amount == 0) {
1330             super._transfer(from, to, 0);
1331             return;
1332         }
1333 
1334         if (limitsInEffect) {
1335             if (
1336                 from != owner() &&
1337                 to != owner() &&
1338                 to != address(0) &&
1339                 to != address(0xdead) &&
1340                 !swapping
1341             ) {
1342                 if (!tradingActive) {
1343                     require(
1344                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1345                         "Trading is not active."
1346                     );
1347                 }
1348 
1349                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1350                 if (transferDelayEnabled) {
1351                     if (
1352                         to != owner() &&
1353                         to != address(uniswapV2Router) &&
1354                         to != address(uniswapV2Pair)
1355                     ) {
1356                         require(
1357                             _holderLastTransferTimestamp[tx.origin] <
1358                                 block.number,
1359                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1360                         );
1361                         _holderLastTransferTimestamp[tx.origin] = block.number;
1362                     }
1363                 }
1364 
1365                 //when buy
1366                 if (
1367                     automatedMarketMakerPairs[from] &&
1368                     !_isExcludedMaxTransactionAmount[to]
1369                 ) {
1370                     require(
1371                         amount <= maxTransactionAmount,
1372                         "Buy transfer amount exceeds the maxTransactionAmount."
1373                     );
1374                     require(
1375                         amount + balanceOf(to) <= maxWallet,
1376                         "Max wallet exceeded"
1377                     );
1378                 }
1379                 //when sell
1380                 else if (
1381                     automatedMarketMakerPairs[to] &&
1382                     !_isExcludedMaxTransactionAmount[from]
1383                 ) {
1384                     require(
1385                         amount <= maxTransactionAmount,
1386                         "Sell transfer amount exceeds the maxTransactionAmount."
1387                     );
1388                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1389                     require(
1390                         amount + balanceOf(to) <= maxWallet,
1391                         "Max wallet exceeded"
1392                     );
1393                 }
1394             }
1395         }
1396 
1397         uint256 contractTokenBalance = balanceOf(address(this));
1398 
1399         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1400 
1401         if (
1402             canSwap &&
1403             swapEnabled &&
1404             !swapping &&
1405             !automatedMarketMakerPairs[from] &&
1406             !_isExcludedFromFees[from] &&
1407             !_isExcludedFromFees[to]
1408         ) {
1409             swapping = true;
1410 
1411             swapBack();
1412 
1413             swapping = false;
1414         }
1415 
1416         if (
1417             !swapping &&
1418             automatedMarketMakerPairs[to] &&
1419             lpBurnEnabled &&
1420             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1421             !_isExcludedFromFees[from]
1422         ) {
1423             autoBurnLiquidityPairTokens();
1424         }
1425 
1426         bool takeFee = !swapping;
1427 
1428         // if any account belongs to _isExcludedFromFee account then remove the fee
1429         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1430             takeFee = false;
1431         }
1432 
1433         uint256 fees = 0;
1434         // only take fees on buys/sells, do not take on wallet transfers
1435         if (takeFee) {
1436             // on sell
1437             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1438                 fees = amount.mul(sellTotalFees).div(100);
1439                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1440                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1441                 tokensForfilmFund += (fees * sellfilmFundFee) / sellTotalFees;
1442             }
1443             // on buy
1444             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1445                 fees = amount.mul(buyTotalFees).div(100);
1446                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1447                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1448                 tokensForfilmFund += (fees * buyfilmFundFee) / buyTotalFees;
1449             }
1450 
1451             if (fees > 0) {
1452                 super._transfer(from, address(this), fees);
1453             }
1454 
1455             amount -= fees;
1456         }
1457 
1458         super._transfer(from, to, amount);
1459     }
1460 
1461     function swapTokensForEth(uint256 tokenAmount) private {
1462         // generate the uniswap pair path of token -> weth
1463         address[] memory path = new address[](2);
1464         path[0] = address(this);
1465         path[1] = uniswapV2Router.WETH();
1466 
1467         _approve(address(this), address(uniswapV2Router), tokenAmount);
1468 
1469         // make the swap
1470         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1471             tokenAmount,
1472             0, // accept any amount of ETH
1473             path,
1474             address(this),
1475             block.timestamp
1476         );
1477     }
1478 
1479     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1480         // approve token transfer to cover all possible scenarios
1481         _approve(address(this), address(uniswapV2Router), tokenAmount);
1482 
1483         // add the liquidity
1484         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1485             address(this),
1486             tokenAmount,
1487             0, // slippage is unavoidable
1488             0, // slippage is unavoidable
1489             deadAddress,
1490             block.timestamp
1491         );
1492     }
1493 
1494     function swapBack() private {
1495         uint256 contractBalance = balanceOf(address(this));
1496         uint256 totalTokensToSwap = tokensForLiquidity +
1497             tokensForfilmFund +
1498             tokensForDev;
1499         bool success;
1500 
1501         if (contractBalance == 0 || totalTokensToSwap == 0) {
1502             return;
1503         }
1504 
1505         if (contractBalance > swapTokensAtAmount * 20) {
1506             contractBalance = swapTokensAtAmount * 20;
1507         }
1508 
1509         // Halve the amount of liquidity tokens
1510         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1511             totalTokensToSwap /
1512             2;
1513         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1514 
1515         uint256 initialETHBalance = address(this).balance;
1516 
1517         swapTokensForEth(amountToSwapForETH);
1518 
1519         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1520 
1521         uint256 ethForfilmFund = ethBalance.mul(tokensForfilmFund).div(
1522             totalTokensToSwap
1523         );
1524         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1525 
1526         uint256 ethForLiquidity = ethBalance - ethForfilmFund - ethForDev;
1527 
1528         tokensForLiquidity = 0;
1529         tokensForfilmFund = 0;
1530         tokensForDev = 0;
1531 
1532         (success, ) = address(devWallet).call{value: ethForDev}("");
1533 
1534         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1535             addLiquidity(liquidityTokens, ethForLiquidity);
1536             emit SwapAndLiquify(
1537                 amountToSwapForETH,
1538                 ethForLiquidity,
1539                 tokensForLiquidity
1540             );
1541         }
1542 
1543         (success, ) = address(filmFundWallet).call{
1544             value: address(this).balance
1545         }("");
1546     }
1547 
1548     function setAutoLPBurnSettings(
1549         uint256 _frequencyInSeconds,
1550         uint256 _percent,
1551         bool _Enabled
1552     ) external onlyOwner {
1553         require(
1554             _frequencyInSeconds >= 600,
1555             "cannot set buyback more often than every 10 minutes"
1556         );
1557         require(
1558             _percent <= 1000 && _percent >= 0,
1559             "Must set auto LP burn percent between 0% and 10%"
1560         );
1561         lpBurnFrequency = _frequencyInSeconds;
1562         percentForLPBurn = _percent;
1563         lpBurnEnabled = _Enabled;
1564     }
1565 
1566     function autoBurnLiquidityPairTokens() internal returns (bool) {
1567         lastLpBurnTime = block.timestamp;
1568 
1569         // get balance of liquidity pair
1570         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1571 
1572         // calculate amount to burn
1573         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1574             10000
1575         );
1576 
1577         // pull tokens from pancakePair liquidity and move to dead address permanently
1578         if (amountToBurn > 0) {
1579             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1580         }
1581 
1582         //sync price since this is not in a swap transaction!
1583         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1584         pair.sync();
1585         emit AutoNukeLP();
1586         return true;
1587     }
1588 
1589     function manualBurnLiquidityPairTokens(uint256 percent)
1590         external
1591         onlyOwner
1592         returns (bool)
1593     {
1594         require(
1595             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1596             "Must wait for cooldown to finish"
1597         );
1598         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1599         lastManualLpBurnTime = block.timestamp;
1600 
1601         // get balance of liquidity pair
1602         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1603 
1604         // calculate amount to burn
1605         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1606 
1607         // pull tokens from pancakePair liquidity and move to dead address permanently
1608         if (amountToBurn > 0) {
1609             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1610         }
1611 
1612         //sync price since this is not in a swap transaction!
1613         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1614         pair.sync();
1615         emit ManualNukeLP();
1616         return true;
1617     }
1618 }