1 // SPDX-License-Identifier: MIT
2 
3 // FPUTIN TOKEN, designed and developed to help Ukraine with a war that they didn't ask for
4 // Donation Wallet is hard coded to 0x165CD37b4C644C2921454429E7F9358d18A45e14 the official Ukrainian Donation Wallet -- this wallet cannot be altered
5 // https://fuckputin.com
6 
7 
8 //....................../´¯/) 
9 //....................,/¯../ 
10 //.................../..../ 
11 //............./´¯/'...'/´¯¯`·¸ 
12 //........../'/.../..../......./¨¯\ 
13 //........('(...´...´.... ¯~/'...') 
14 //.........\.................'...../ 
15 //..........''...\.......... _.·´ 
16 //............\..............( 
17 //..............\.............\...
18 
19 //⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
20 //⣿⣿⣿⣵⣿⣿⣿⠿⡟⣛⣧⣿⣯⣿⣝⡻⢿⣿⣿⣿⣿⣿⣿⣿
21 //⣿⣿⣿⣿⣿⠋⠁⣴⣶⣿⣿⣿⣿⣿⣿⣿⣦⣍⢿⣿⣿⣿⣿⣿
22 //⣿⣿⣿⣿⢷⠄⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⢼⣿⣿⣿⣿
23 //⢹⣿⣿⢻⠎⠔⣛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣿⣿⣿⣿
24 //⢸⣿⣿⠇⡶⠄⣿⣿⠿⠟⡛⠛⠻⣿⡿⠿⠿⣿⣗⢣⣿⣿⣿⣿
25 //⠐⣿⣿⡿⣷⣾⣿⣿⣿⣾⣶⣶⣶⣿⣁⣔⣤⣀⣼⢲⣿⣿⣿⣿
26 //⠄⣿⣿⣿⣿⣾⣟⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⢟⣾⣿⣿⣿⣿
27 //⠄⣟⣿⣿⣿⡷⣿⣿⣿⣿⣿⣮⣽⠛⢻⣽⣿⡇⣾⣿⣿⣿⣿⣿
28 //⠄⢻⣿⣿⣿⡷⠻⢻⡻⣯⣝⢿⣟⣛⣛⣛⠝⢻⣿⣿⣿⣿⣿⣿
29 //⠄⠸⣿⣿⡟⣹⣦⠄⠋⠻⢿⣶⣶⣶⡾⠃⡂⢾⣿⣿⣿⣿⣿⣿
30 //⠄⠄⠟⠋⠄⢻⣿⣧⣲⡀⡀⠄⠉⠱⣠⣾⡇⠄⠉⠛⢿⣿⣿⣿
31 //⠄⠄⠄⠄⠄⠈⣿⣿⣿⣷⣿⣿⢾⣾⣿⣿⣇⠄⠄⠄⠄⠄⠉⠉
32 //⠄⠄⠄⠄⠄⠄⠸⣿⣿⠟⠃⠄⠄⢈⣻⣿⣿⠄⠄⠄⠄⠄⠄⠄
33 //⠄⠄⠄⠄⠄⠄⠄⢿⣿⣾⣷⡄⠄⢾⣿⣿⣿⡄⠄⠄⠄⠄⠄⠄
34 //⠄⠄⠄⠄⠄⠄⠄⠸⣿⣿⣿⠃⠄⠈⢿⣿⣿⠄⠄⠄⠄⠄⠄⠄
35 
36 
37 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
38 pragma experimental ABIEncoderV2;
39 
40 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
41 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
42 
43 /* pragma solidity ^0.8.0; */
44 
45 /**
46  * @dev Provides information about the current execution context, including the
47  * sender of the transaction and its data. While these are generally available
48  * via msg.sender and msg.data, they should not be accessed in such a direct
49  * manner, since when dealing with meta-transactions the account sending and
50  * paying for execution may not be the actual sender (as far as an application
51  * is concerned).
52  *
53  * This contract is only required for intermediate, library-like contracts.
54  */
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns (bytes calldata) {
61         return msg.data;
62     }
63 }
64 
65 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
66 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
67 
68 /* pragma solidity ^0.8.0; */
69 
70 /* import "../utils/Context.sol"; */
71 
72 /**
73  * @dev Contract module which provides a basic access control mechanism, where
74  * there is an account (an owner) that can be granted exclusive access to
75  * specific functions.
76  *
77  * By default, the owner account will be the one that deploys the contract. This
78  * can later be changed with {transferOwnership}.
79  *
80  * This module is used through inheritance. It will make available the modifier
81  * `onlyOwner`, which can be applied to your functions to restrict their use to
82  * the owner.
83  */
84 abstract contract Ownable is Context {
85     address private _owner;
86 
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     /**
90      * @dev Initializes the contract setting the deployer as the initial owner.
91      */
92     constructor() {
93         _transferOwnership(_msgSender());
94     }
95 
96     /**
97      * @dev Returns the address of the current owner.
98      */
99     function owner() public view virtual returns (address) {
100         return _owner;
101     }
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(owner() == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     /**
112      * @dev Leaves the contract without owner. It will not be possible to call
113      * `onlyOwner` functions anymore. Can only be called by the current owner.
114      *
115      * NOTE: Renouncing ownership will leave the contract without an owner,
116      * thereby removing any functionality that is only available to the owner.
117      */
118     function renounceOwnership() public virtual onlyOwner {
119         _transferOwnership(address(0));
120     }
121 
122     /**
123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
124      * Can only be called by the current owner.
125      */
126     function transferOwnership(address newOwner) public virtual onlyOwner {
127         require(newOwner != address(0), "Ownable: new owner is the zero address");
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Internal function without access restriction.
134      */
135     function _transferOwnership(address newOwner) internal virtual {
136         address oldOwner = _owner;
137         _owner = newOwner;
138         emit OwnershipTransferred(oldOwner, newOwner);
139     }
140 }
141 
142 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
143 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
144 
145 /* pragma solidity ^0.8.0; */
146 
147 /**
148  * @dev Interface of the ERC20 standard as defined in the EIP.
149  */
150 interface IERC20 {
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `recipient`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address recipient, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Returns the remaining number of tokens that `spender` will be
172      * allowed to spend on behalf of `owner` through {transferFrom}. This is
173      * zero by default.
174      *
175      * This value changes when {approve} or {transferFrom} are called.
176      */
177     function allowance(address owner, address spender) external view returns (uint256);
178 
179     /**
180      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * IMPORTANT: Beware that changing an allowance with this method brings the risk
185      * that someone may use both the old and the new allowance by unfortunate
186      * transaction ordering. One possible solution to mitigate this race
187      * condition is to first reduce the spender's allowance to 0 and set the
188      * desired value afterwards:
189      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190      *
191      * Emits an {Approval} event.
192      */
193     function approve(address spender, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Moves `amount` tokens from `sender` to `recipient` using the
197      * allowance mechanism. `amount` is then deducted from the caller's
198      * allowance.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address sender,
206         address recipient,
207         uint256 amount
208     ) external returns (bool);
209 
210     /**
211      * @dev Emitted when `value` tokens are moved from one account (`from`) to
212      * another (`to`).
213      *
214      * Note that `value` may be zero.
215      */
216     event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     /**
219      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
220      * a call to {approve}. `value` is the new allowance.
221      */
222     event Approval(address indexed owner, address indexed spender, uint256 value);
223 }
224 
225 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
226 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
227 
228 /* pragma solidity ^0.8.0; */
229 
230 /* import "../IERC20.sol"; */
231 
232 /**
233  * @dev Interface for the optional metadata functions from the ERC20 standard.
234  *
235  * _Available since v4.1._
236  */
237 interface IERC20Metadata is IERC20 {
238     /**
239      * @dev Returns the name of the token.
240      */
241     function name() external view returns (string memory);
242 
243     /**
244      * @dev Returns the symbol of the token.
245      */
246     function symbol() external view returns (string memory);
247 
248     /**
249      * @dev Returns the decimals places of the token.
250      */
251     function decimals() external view returns (uint8);
252 }
253 
254 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
255 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
256 
257 /* pragma solidity ^0.8.0; */
258 
259 /* import "./IERC20.sol"; */
260 /* import "./extensions/IERC20Metadata.sol"; */
261 /* import "../../utils/Context.sol"; */
262 
263 /**
264  * @dev Implementation of the {IERC20} interface.
265  *
266  * This implementation is agnostic to the way tokens are created. This means
267  * that a supply mechanism has to be added in a derived contract using {_mint}.
268  * For a generic mechanism see {ERC20PresetMinterPauser}.
269  *
270  * TIP: For a detailed writeup see our guide
271  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
272  * to implement supply mechanisms].
273  *
274  * We have followed general OpenZeppelin Contracts guidelines: functions revert
275  * instead returning `false` on failure. This behavior is nonetheless
276  * conventional and does not conflict with the expectations of ERC20
277  * applications.
278  *
279  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
280  * This allows applications to reconstruct the allowance for all accounts just
281  * by listening to said events. Other implementations of the EIP may not emit
282  * these events, as it isn't required by the specification.
283  *
284  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
285  * functions have been added to mitigate the well-known issues around setting
286  * allowances. See {IERC20-approve}.
287  */
288 contract ERC20 is Context, IERC20, IERC20Metadata {
289     mapping(address => uint256) private _balances;
290 
291     mapping(address => mapping(address => uint256)) private _allowances;
292 
293     uint256 private _totalSupply;
294 
295     string private _name;
296     string private _symbol;
297 
298     /**
299      * @dev Sets the values for {name} and {symbol}.
300      *
301      * The default value of {decimals} is 18. To select a different value for
302      * {decimals} you should overload it.
303      *
304      * All two of these values are immutable: they can only be set once during
305      * construction.
306      */
307     constructor(string memory name_, string memory symbol_) {
308         _name = name_;
309         _symbol = symbol_;
310     }
311 
312     /**
313      * @dev Returns the name of the token.
314      */
315     function name() public view virtual override returns (string memory) {
316         return _name;
317     }
318 
319     /**
320      * @dev Returns the symbol of the token, usually a shorter version of the
321      * name.
322      */
323     function symbol() public view virtual override returns (string memory) {
324         return _symbol;
325     }
326 
327     /**
328      * @dev Returns the number of decimals used to get its user representation.
329      * For example, if `decimals` equals `2`, a balance of `505` tokens should
330      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
331      *
332      * Tokens usually opt for a value of 18, imitating the relationship between
333      * Ether and Wei. This is the value {ERC20} uses, unless this function is
334      * overridden;
335      *
336      * NOTE: This information is only used for _display_ purposes: it in
337      * no way affects any of the arithmetic of the contract, including
338      * {IERC20-balanceOf} and {IERC20-transfer}.
339      */
340     function decimals() public view virtual override returns (uint8) {
341         return 18;
342     }
343 
344     /**
345      * @dev See {IERC20-totalSupply}.
346      */
347     function totalSupply() public view virtual override returns (uint256) {
348         return _totalSupply;
349     }
350 
351     /**
352      * @dev See {IERC20-balanceOf}.
353      */
354     function balanceOf(address account) public view virtual override returns (uint256) {
355         return _balances[account];
356     }
357 
358     /**
359      * @dev See {IERC20-transfer}.
360      *
361      * Requirements:
362      *
363      * - `recipient` cannot be the zero address.
364      * - the caller must have a balance of at least `amount`.
365      */
366     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
367         _transfer(_msgSender(), recipient, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-allowance}.
373      */
374     function allowance(address owner, address spender) public view virtual override returns (uint256) {
375         return _allowances[owner][spender];
376     }
377 
378     /**
379      * @dev See {IERC20-approve}.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function approve(address spender, uint256 amount) public virtual override returns (bool) {
386         _approve(_msgSender(), spender, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-transferFrom}.
392      *
393      * Emits an {Approval} event indicating the updated allowance. This is not
394      * required by the EIP. See the note at the beginning of {ERC20}.
395      *
396      * Requirements:
397      *
398      * - `sender` and `recipient` cannot be the zero address.
399      * - `sender` must have a balance of at least `amount`.
400      * - the caller must have allowance for ``sender``'s tokens of at least
401      * `amount`.
402      */
403     function transferFrom(
404         address sender,
405         address recipient,
406         uint256 amount
407     ) public virtual override returns (bool) {
408         _transfer(sender, recipient, amount);
409 
410         uint256 currentAllowance = _allowances[sender][_msgSender()];
411         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
412         unchecked {
413             _approve(sender, _msgSender(), currentAllowance - amount);
414         }
415 
416         return true;
417     }
418 
419     /**
420      * @dev Atomically increases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
432         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
433         return true;
434     }
435 
436     /**
437      * @dev Atomically decreases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to {approve} that can be used as a mitigation for
440      * problems described in {IERC20-approve}.
441      *
442      * Emits an {Approval} event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      * - `spender` must have allowance for the caller of at least
448      * `subtractedValue`.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
451         uint256 currentAllowance = _allowances[_msgSender()][spender];
452         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
453         unchecked {
454             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
455         }
456 
457         return true;
458     }
459 
460     /**
461      * @dev Moves `amount` of tokens from `sender` to `recipient`.
462      *
463      * This internal function is equivalent to {transfer}, and can be used to
464      * e.g. implement automatic token fees, slashing mechanisms, etc.
465      *
466      * Emits a {Transfer} event.
467      *
468      * Requirements:
469      *
470      * - `sender` cannot be the zero address.
471      * - `recipient` cannot be the zero address.
472      * - `sender` must have a balance of at least `amount`.
473      */
474     function _transfer(
475         address sender,
476         address recipient,
477         uint256 amount
478     ) internal virtual {
479         require(sender != address(0), "ERC20: transfer from the zero address");
480         require(recipient != address(0), "ERC20: transfer to the zero address");
481 
482         _beforeTokenTransfer(sender, recipient, amount);
483 
484         uint256 senderBalance = _balances[sender];
485         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
486         unchecked {
487             _balances[sender] = senderBalance - amount;
488         }
489         _balances[recipient] += amount;
490 
491         emit Transfer(sender, recipient, amount);
492 
493         _afterTokenTransfer(sender, recipient, amount);
494     }
495 
496     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
497      * the total supply.
498      *
499      * Emits a {Transfer} event with `from` set to the zero address.
500      *
501      * Requirements:
502      *
503      * - `account` cannot be the zero address.
504      */
505     function _mint(address account, uint256 amount) internal virtual {
506         require(account != address(0), "ERC20: mint to the zero address");
507 
508         _beforeTokenTransfer(address(0), account, amount);
509 
510         _totalSupply += amount;
511         _balances[account] += amount;
512         emit Transfer(address(0), account, amount);
513 
514         _afterTokenTransfer(address(0), account, amount);
515     }
516 
517     /**
518      * @dev Destroys `amount` tokens from `account`, reducing the
519      * total supply.
520      *
521      * Emits a {Transfer} event with `to` set to the zero address.
522      *
523      * Requirements:
524      *
525      * - `account` cannot be the zero address.
526      * - `account` must have at least `amount` tokens.
527      */
528     function _burn(address account, uint256 amount) internal virtual {
529         require(account != address(0), "ERC20: burn from the zero address");
530 
531         _beforeTokenTransfer(account, address(0), amount);
532 
533         uint256 accountBalance = _balances[account];
534         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
535         unchecked {
536             _balances[account] = accountBalance - amount;
537         }
538         _totalSupply -= amount;
539 
540         emit Transfer(account, address(0), amount);
541 
542         _afterTokenTransfer(account, address(0), amount);
543     }
544 
545     /**
546      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
547      *
548      * This internal function is equivalent to `approve`, and can be used to
549      * e.g. set automatic allowances for certain subsystems, etc.
550      *
551      * Emits an {Approval} event.
552      *
553      * Requirements:
554      *
555      * - `owner` cannot be the zero address.
556      * - `spender` cannot be the zero address.
557      */
558     function _approve(
559         address owner,
560         address spender,
561         uint256 amount
562     ) internal virtual {
563         require(owner != address(0), "ERC20: approve from the zero address");
564         require(spender != address(0), "ERC20: approve to the zero address");
565 
566         _allowances[owner][spender] = amount;
567         emit Approval(owner, spender, amount);
568     }
569 
570     /**
571      * @dev Hook that is called before any transfer of tokens. This includes
572      * minting and burning.
573      *
574      * Calling conditions:
575      *
576      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
577      * will be transferred to `to`.
578      * - when `from` is zero, `amount` tokens will be minted for `to`.
579      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
580      * - `from` and `to` are never both zero.
581      *
582      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
583      */
584     function _beforeTokenTransfer(
585         address from,
586         address to,
587         uint256 amount
588     ) internal virtual {}
589 
590     /**
591      * @dev Hook that is called after any transfer of tokens. This includes
592      * minting and burning.
593      *
594      * Calling conditions:
595      *
596      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
597      * has been transferred to `to`.
598      * - when `from` is zero, `amount` tokens have been minted for `to`.
599      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
600      * - `from` and `to` are never both zero.
601      *
602      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
603      */
604     function _afterTokenTransfer(
605         address from,
606         address to,
607         uint256 amount
608     ) internal virtual {}
609 }
610 
611 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
612 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
613 
614 /* pragma solidity ^0.8.0; */
615 
616 // CAUTION
617 // This version of SafeMath should only be used with Solidity 0.8 or later,
618 // because it relies on the compiler's built in overflow checks.
619 
620 /**
621  * @dev Wrappers over Solidity's arithmetic operations.
622  *
623  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
624  * now has built in overflow checking.
625  */
626 library SafeMath {
627     /**
628      * @dev Returns the addition of two unsigned integers, with an overflow flag.
629      *
630      * _Available since v3.4._
631      */
632     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         unchecked {
634             uint256 c = a + b;
635             if (c < a) return (false, 0);
636             return (true, c);
637         }
638     }
639 
640     /**
641      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
642      *
643      * _Available since v3.4._
644      */
645     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
646         unchecked {
647             if (b > a) return (false, 0);
648             return (true, a - b);
649         }
650     }
651 
652     /**
653      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
654      *
655      * _Available since v3.4._
656      */
657     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
658         unchecked {
659             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
660             // benefit is lost if 'b' is also tested.
661             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
662             if (a == 0) return (true, 0);
663             uint256 c = a * b;
664             if (c / a != b) return (false, 0);
665             return (true, c);
666         }
667     }
668 
669     /**
670      * @dev Returns the division of two unsigned integers, with a division by zero flag.
671      *
672      * _Available since v3.4._
673      */
674     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
675         unchecked {
676             if (b == 0) return (false, 0);
677             return (true, a / b);
678         }
679     }
680 
681     /**
682      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
683      *
684      * _Available since v3.4._
685      */
686     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
687         unchecked {
688             if (b == 0) return (false, 0);
689             return (true, a % b);
690         }
691     }
692 
693     /**
694      * @dev Returns the addition of two unsigned integers, reverting on
695      * overflow.
696      *
697      * Counterpart to Solidity's `+` operator.
698      *
699      * Requirements:
700      *
701      * - Addition cannot overflow.
702      */
703     function add(uint256 a, uint256 b) internal pure returns (uint256) {
704         return a + b;
705     }
706 
707     /**
708      * @dev Returns the subtraction of two unsigned integers, reverting on
709      * overflow (when the result is negative).
710      *
711      * Counterpart to Solidity's `-` operator.
712      *
713      * Requirements:
714      *
715      * - Subtraction cannot overflow.
716      */
717     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
718         return a - b;
719     }
720 
721     /**
722      * @dev Returns the multiplication of two unsigned integers, reverting on
723      * overflow.
724      *
725      * Counterpart to Solidity's `*` operator.
726      *
727      * Requirements:
728      *
729      * - Multiplication cannot overflow.
730      */
731     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a * b;
733     }
734 
735     /**
736      * @dev Returns the integer division of two unsigned integers, reverting on
737      * division by zero. The result is rounded towards zero.
738      *
739      * Counterpart to Solidity's `/` operator.
740      *
741      * Requirements:
742      *
743      * - The divisor cannot be zero.
744      */
745     function div(uint256 a, uint256 b) internal pure returns (uint256) {
746         return a / b;
747     }
748 
749     /**
750      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
751      * reverting when dividing by zero.
752      *
753      * Counterpart to Solidity's `%` operator. This function uses a `revert`
754      * opcode (which leaves remaining gas untouched) while Solidity uses an
755      * invalid opcode to revert (consuming all remaining gas).
756      *
757      * Requirements:
758      *
759      * - The divisor cannot be zero.
760      */
761     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
762         return a % b;
763     }
764 
765     /**
766      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
767      * overflow (when the result is negative).
768      *
769      * CAUTION: This function is deprecated because it requires allocating memory for the error
770      * message unnecessarily. For custom revert reasons use {trySub}.
771      *
772      * Counterpart to Solidity's `-` operator.
773      *
774      * Requirements:
775      *
776      * - Subtraction cannot overflow.
777      */
778     function sub(
779         uint256 a,
780         uint256 b,
781         string memory errorMessage
782     ) internal pure returns (uint256) {
783         unchecked {
784             require(b <= a, errorMessage);
785             return a - b;
786         }
787     }
788 
789     /**
790      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
791      * division by zero. The result is rounded towards zero.
792      *
793      * Counterpart to Solidity's `/` operator. Note: this function uses a
794      * `revert` opcode (which leaves remaining gas untouched) while Solidity
795      * uses an invalid opcode to revert (consuming all remaining gas).
796      *
797      * Requirements:
798      *
799      * - The divisor cannot be zero.
800      */
801     function div(
802         uint256 a,
803         uint256 b,
804         string memory errorMessage
805     ) internal pure returns (uint256) {
806         unchecked {
807             require(b > 0, errorMessage);
808             return a / b;
809         }
810     }
811 
812     /**
813      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
814      * reverting with custom message when dividing by zero.
815      *
816      * CAUTION: This function is deprecated because it requires allocating memory for the error
817      * message unnecessarily. For custom revert reasons use {tryMod}.
818      *
819      * Counterpart to Solidity's `%` operator. This function uses a `revert`
820      * opcode (which leaves remaining gas untouched) while Solidity uses an
821      * invalid opcode to revert (consuming all remaining gas).
822      *
823      * Requirements:
824      *
825      * - The divisor cannot be zero.
826      */
827     function mod(
828         uint256 a,
829         uint256 b,
830         string memory errorMessage
831     ) internal pure returns (uint256) {
832         unchecked {
833             require(b > 0, errorMessage);
834             return a % b;
835         }
836     }
837 }
838 
839 ////// src/IUniswapV2Factory.sol
840 /* pragma solidity 0.8.10; */
841 /* pragma experimental ABIEncoderV2; */
842 
843 interface IUniswapV2Factory {
844     event PairCreated(
845         address indexed token0,
846         address indexed token1,
847         address pair,
848         uint256
849     );
850 
851     function feeTo() external view returns (address);
852 
853     function feeToSetter() external view returns (address);
854 
855     function getPair(address tokenA, address tokenB)
856         external
857         view
858         returns (address pair);
859 
860     function allPairs(uint256) external view returns (address pair);
861 
862     function allPairsLength() external view returns (uint256);
863 
864     function createPair(address tokenA, address tokenB)
865         external
866         returns (address pair);
867 
868     function setFeeTo(address) external;
869 
870     function setFeeToSetter(address) external;
871 }
872 
873 ////// src/IUniswapV2Pair.sol
874 /* pragma solidity 0.8.10; */
875 /* pragma experimental ABIEncoderV2; */
876 
877 interface IUniswapV2Pair {
878     event Approval(
879         address indexed owner,
880         address indexed spender,
881         uint256 value
882     );
883     event Transfer(address indexed from, address indexed to, uint256 value);
884 
885     function name() external pure returns (string memory);
886 
887     function symbol() external pure returns (string memory);
888 
889     function decimals() external pure returns (uint8);
890 
891     function totalSupply() external view returns (uint256);
892 
893     function balanceOf(address owner) external view returns (uint256);
894 
895     function allowance(address owner, address spender)
896         external
897         view
898         returns (uint256);
899 
900     function approve(address spender, uint256 value) external returns (bool);
901 
902     function transfer(address to, uint256 value) external returns (bool);
903 
904     function transferFrom(
905         address from,
906         address to,
907         uint256 value
908     ) external returns (bool);
909 
910     function DOMAIN_SEPARATOR() external view returns (bytes32);
911 
912     function PERMIT_TYPEHASH() external pure returns (bytes32);
913 
914     function nonces(address owner) external view returns (uint256);
915 
916     function permit(
917         address owner,
918         address spender,
919         uint256 value,
920         uint256 deadline,
921         uint8 v,
922         bytes32 r,
923         bytes32 s
924     ) external;
925 
926     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
927     event Burn(
928         address indexed sender,
929         uint256 amount0,
930         uint256 amount1,
931         address indexed to
932     );
933     event Swap(
934         address indexed sender,
935         uint256 amount0In,
936         uint256 amount1In,
937         uint256 amount0Out,
938         uint256 amount1Out,
939         address indexed to
940     );
941     event Sync(uint112 reserve0, uint112 reserve1);
942 
943     function MINIMUM_LIQUIDITY() external pure returns (uint256);
944 
945     function factory() external view returns (address);
946 
947     function token0() external view returns (address);
948 
949     function token1() external view returns (address);
950 
951     function getReserves()
952         external
953         view
954         returns (
955             uint112 reserve0,
956             uint112 reserve1,
957             uint32 blockTimestampLast
958         );
959 
960     function price0CumulativeLast() external view returns (uint256);
961 
962     function price1CumulativeLast() external view returns (uint256);
963 
964     function kLast() external view returns (uint256);
965 
966     function mint(address to) external returns (uint256 liquidity);
967 
968     function burn(address to)
969         external
970         returns (uint256 amount0, uint256 amount1);
971 
972     function swap(
973         uint256 amount0Out,
974         uint256 amount1Out,
975         address to,
976         bytes calldata data
977     ) external;
978 
979     function skim(address to) external;
980 
981     function sync() external;
982 
983     function initialize(address, address) external;
984 }
985 
986 ////// src/IUniswapV2Router02.sol
987 /* pragma solidity 0.8.10; */
988 /* pragma experimental ABIEncoderV2; */
989 
990 interface IUniswapV2Router02 {
991     function factory() external pure returns (address);
992 
993     function WETH() external pure returns (address);
994 
995     function addLiquidity(
996         address tokenA,
997         address tokenB,
998         uint256 amountADesired,
999         uint256 amountBDesired,
1000         uint256 amountAMin,
1001         uint256 amountBMin,
1002         address to,
1003         uint256 deadline
1004     )
1005         external
1006         returns (
1007             uint256 amountA,
1008             uint256 amountB,
1009             uint256 liquidity
1010         );
1011 
1012     function addLiquidityETH(
1013         address token,
1014         uint256 amountTokenDesired,
1015         uint256 amountTokenMin,
1016         uint256 amountETHMin,
1017         address to,
1018         uint256 deadline
1019     )
1020         external
1021         payable
1022         returns (
1023             uint256 amountToken,
1024             uint256 amountETH,
1025             uint256 liquidity
1026         );
1027 
1028     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1029         uint256 amountIn,
1030         uint256 amountOutMin,
1031         address[] calldata path,
1032         address to,
1033         uint256 deadline
1034     ) external;
1035 
1036     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1037         uint256 amountOutMin,
1038         address[] calldata path,
1039         address to,
1040         uint256 deadline
1041     ) external payable;
1042 
1043     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1044         uint256 amountIn,
1045         uint256 amountOutMin,
1046         address[] calldata path,
1047         address to,
1048         uint256 deadline
1049     ) external;
1050 }
1051 
1052 /* pragma solidity >=0.8.10; */
1053 
1054 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1055 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1056 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1057 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1058 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1059 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1060 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1061 
1062 contract FPUTIN is ERC20, Ownable {
1063     using SafeMath for uint256;
1064 
1065     IUniswapV2Router02 public immutable uniswapV2Router;
1066     address public immutable uniswapV2Pair;
1067     address public constant deadAddress = address(0xdead);
1068 
1069     bool private swapping;
1070 
1071     address public donationWallet;
1072     address public devWallet;
1073 
1074     uint256 public maxTransactionAmount;
1075     uint256 public swapTokensAtAmount;
1076     uint256 public maxWallet;
1077 
1078     uint256 public percentForLPBurn = 25; // 25 = .25%
1079     bool public lpBurnEnabled = true;
1080     uint256 public lpBurnFrequency = 3600 seconds;
1081     uint256 public lastLpBurnTime;
1082 
1083     uint256 public manualBurnFrequency = 30 minutes;
1084     uint256 public lastManualLpBurnTime;
1085 
1086     bool public limitsInEffect = true;
1087     bool public tradingActive = false;
1088     bool public swapEnabled = false;
1089 
1090     // Anti-bot and anti-whale mappings and variables
1091     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1092     bool public transferDelayEnabled = true;
1093 
1094     uint256 public buyTotalFees;
1095     uint256 public buyDonationFee;
1096     uint256 public buyLiquidityFee;
1097     uint256 public buyDevFee;
1098 
1099     uint256 public sellTotalFees;
1100     uint256 public sellDonationFee;
1101     uint256 public sellLiquidityFee;
1102     uint256 public sellDevFee;
1103 
1104     uint256 public tokensForDonation;
1105     uint256 public tokensForLiquidity;
1106     uint256 public tokensForDev;
1107 
1108     /******************/
1109 
1110     // exlcude from fees and max transaction amount
1111     mapping(address => bool) private _isExcludedFromFees;
1112     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1113 
1114     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1115     // could be subject to a maximum transfer amount
1116     mapping(address => bool) public automatedMarketMakerPairs;
1117 
1118     event UpdateUniswapV2Router(
1119         address indexed newAddress,
1120         address indexed oldAddress
1121     );
1122 
1123     event ExcludeFromFees(address indexed account, bool isExcluded);
1124 
1125     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1126 
1127     event devWalletUpdated(
1128         address indexed newWallet,
1129         address indexed oldWallet
1130     );
1131 
1132     event SwapAndLiquify(
1133         uint256 tokensSwapped,
1134         uint256 ethReceived,
1135         uint256 tokensIntoLiquidity
1136     );
1137 
1138     event AutoNukeLP();
1139 
1140     event ManualNukeLP();
1141 
1142     constructor() ERC20("FPUTIN Token", "FPUTIN") {
1143         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1144             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1145         );
1146 
1147         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1148         uniswapV2Router = _uniswapV2Router;
1149 
1150         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1151             .createPair(address(this), _uniswapV2Router.WETH());
1152         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1153         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1154 
1155         uint256 _buyDonationFee = 2;
1156         uint256 _buyLiquidityFee = 6;
1157         uint256 _buyDevFee = 2;
1158 
1159         uint256 _sellDonationFee = 11;
1160         uint256 _sellLiquidityFee = 2;
1161         uint256 _sellDevFee = 2;
1162 
1163         uint256 totalSupply = 1_000_000_000 * 1e18;
1164 
1165         maxTransactionAmount = 7_600_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1166         maxWallet = 15_000_000 * 1e18; // 2% from total supply maxWallet
1167         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1168 
1169         buyDonationFee = _buyDonationFee;
1170         buyLiquidityFee = _buyLiquidityFee;
1171         buyDevFee = _buyDevFee;
1172         buyTotalFees = buyDonationFee + buyLiquidityFee + buyDevFee;
1173 
1174         sellDonationFee = _sellDonationFee;
1175         sellLiquidityFee = _sellLiquidityFee;
1176         sellDevFee = _sellDevFee;
1177         sellTotalFees = sellDonationFee + sellLiquidityFee + sellDevFee;
1178 
1179         donationWallet = address(0x165CD37b4C644C2921454429E7F9358d18A45e14); // hardcoded as ukraine donation wallet
1180         devWallet = address(0x825C5e0a62CFBD1D8A1D951e99Dd8d65c77C3924); // set as dev wallet
1181 
1182         // exclude from paying fees or having max transaction amount
1183         excludeFromFees(owner(), true);
1184         excludeFromFees(address(this), true);
1185         excludeFromFees(address(0xdead), true);
1186 
1187         excludeFromMaxTransaction(owner(), true);
1188         excludeFromMaxTransaction(address(this), true);
1189         excludeFromMaxTransaction(address(0xdead), true);
1190 
1191         /*
1192             _mint is an internal function in ERC20.sol that is only called here,
1193             and CANNOT be called ever again
1194         */
1195         _mint(msg.sender, totalSupply);
1196     }
1197 
1198     receive() external payable {}
1199 
1200     // once enabled, can never be turned off
1201     function enableTrading() external onlyOwner {
1202         tradingActive = true;
1203         swapEnabled = true;
1204         lastLpBurnTime = block.timestamp;
1205     }
1206 
1207     // remove limits after token is stable
1208     function removeLimits() external onlyOwner returns (bool) {
1209         limitsInEffect = false;
1210         return true;
1211     }
1212 
1213     // disable Transfer delay - cannot be reenabled
1214     function disableTransferDelay() external onlyOwner returns (bool) {
1215         transferDelayEnabled = false;
1216         return true;
1217     }
1218 
1219     // change the minimum amount of tokens to sell from fees
1220     function updateSwapTokensAtAmount(uint256 newAmount)
1221         external
1222         onlyOwner
1223         returns (bool)
1224     {
1225         require(
1226             newAmount >= (totalSupply() * 1) / 100000,
1227             "Swap amount cannot be lower than 0.001% total supply."
1228         );
1229         require(
1230             newAmount <= (totalSupply() * 5) / 1000,
1231             "Swap amount cannot be higher than 0.5% total supply."
1232         );
1233         swapTokensAtAmount = newAmount;
1234         return true;
1235     }
1236 
1237     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1238         require(
1239             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1240             "Cannot set maxTransactionAmount lower than 0.1%"
1241         );
1242         maxTransactionAmount = newNum * (10**18);
1243     }
1244 
1245     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1246         require(
1247             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1248             "Cannot set maxWallet lower than 0.5%"
1249         );
1250         maxWallet = newNum * (10**18);
1251     }
1252 
1253     function excludeFromMaxTransaction(address updAds, bool isEx)
1254         public
1255         onlyOwner
1256     {
1257         _isExcludedMaxTransactionAmount[updAds] = isEx;
1258     }
1259 
1260     // only use to disable contract sales if absolutely necessary (emergency use only)
1261     function updateSwapEnabled(bool enabled) external onlyOwner {
1262         swapEnabled = enabled;
1263     }
1264 
1265     function updateBuyFees(
1266         uint256 _donationFee,
1267         uint256 _liquidityFee,
1268         uint256 _devFee
1269     ) external onlyOwner {
1270         buyDonationFee = _donationFee;
1271         buyLiquidityFee = _liquidityFee;
1272         buyDevFee = _devFee;
1273         buyTotalFees = buyDonationFee + buyLiquidityFee + buyDevFee;
1274         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1275     }
1276 
1277     function updateSellFees(
1278         uint256 _donationFee,
1279         uint256 _liquidityFee,
1280         uint256 _devFee
1281     ) external onlyOwner {
1282         sellDonationFee = _donationFee;
1283         sellLiquidityFee = _liquidityFee;
1284         sellDevFee = _devFee;
1285         sellTotalFees = sellDonationFee + sellLiquidityFee + sellDevFee;
1286         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1287     }
1288 
1289     function excludeFromFees(address account, bool excluded) public onlyOwner {
1290         _isExcludedFromFees[account] = excluded;
1291         emit ExcludeFromFees(account, excluded);
1292     }
1293 
1294     function setAutomatedMarketMakerPair(address pair, bool value)
1295         public
1296         onlyOwner
1297     {
1298         require(
1299             pair != uniswapV2Pair,
1300             "The pair cannot be removed from automatedMarketMakerPairs"
1301         );
1302 
1303         _setAutomatedMarketMakerPair(pair, value);
1304     }
1305 
1306     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1307         automatedMarketMakerPairs[pair] = value;
1308 
1309         emit SetAutomatedMarketMakerPair(pair, value);
1310     }
1311 
1312     function updateDevWallet(address newWallet) external onlyOwner {
1313         emit devWalletUpdated(newWallet, devWallet);
1314         devWallet = newWallet;
1315     }
1316 
1317     function isExcludedFromFees(address account) public view returns (bool) {
1318         return _isExcludedFromFees[account];
1319     }
1320 
1321     event BoughtEarly(address indexed sniper);
1322 
1323     function _transfer(
1324         address from,
1325         address to,
1326         uint256 amount
1327     ) internal override {
1328         require(from != address(0), "ERC20: transfer from the zero address");
1329         require(to != address(0), "ERC20: transfer to the zero address");
1330 
1331         if (amount == 0) {
1332             super._transfer(from, to, 0);
1333             return;
1334         }
1335 
1336         if (limitsInEffect) {
1337             if (
1338                 from != owner() &&
1339                 to != owner() &&
1340                 to != address(0) &&
1341                 to != address(0xdead) &&
1342                 !swapping
1343             ) {
1344                 if (!tradingActive) {
1345                     require(
1346                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1347                         "Trading is not active."
1348                     );
1349                 }
1350 
1351                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1352                 if (transferDelayEnabled) {
1353                     if (
1354                         to != owner() &&
1355                         to != address(uniswapV2Router) &&
1356                         to != address(uniswapV2Pair)
1357                     ) {
1358                         require(
1359                             _holderLastTransferTimestamp[tx.origin] <
1360                                 block.number,
1361                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1362                         );
1363                         _holderLastTransferTimestamp[tx.origin] = block.number;
1364                     }
1365                 }
1366 
1367                 //when buy
1368                 if (
1369                     automatedMarketMakerPairs[from] &&
1370                     !_isExcludedMaxTransactionAmount[to]
1371                 ) {
1372                     require(
1373                         amount <= maxTransactionAmount,
1374                         "Buy transfer amount exceeds the maxTransactionAmount."
1375                     );
1376                     require(
1377                         amount + balanceOf(to) <= maxWallet,
1378                         "Max wallet exceeded"
1379                     );
1380                 }
1381                 //when sell
1382                 else if (
1383                     automatedMarketMakerPairs[to] &&
1384                     !_isExcludedMaxTransactionAmount[from]
1385                 ) {
1386                     require(
1387                         amount <= maxTransactionAmount,
1388                         "Sell transfer amount exceeds the maxTransactionAmount."
1389                     );
1390                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1391                     require(
1392                         amount + balanceOf(to) <= maxWallet,
1393                         "Max wallet exceeded"
1394                     );
1395                 }
1396             }
1397         }
1398 
1399         uint256 contractTokenBalance = balanceOf(address(this));
1400 
1401         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1402 
1403         if (
1404             canSwap &&
1405             swapEnabled &&
1406             !swapping &&
1407             !automatedMarketMakerPairs[from] &&
1408             !_isExcludedFromFees[from] &&
1409             !_isExcludedFromFees[to]
1410         ) {
1411             swapping = true;
1412 
1413             swapBack();
1414 
1415             swapping = false;
1416         }
1417 
1418         if (
1419             !swapping &&
1420             automatedMarketMakerPairs[to] &&
1421             lpBurnEnabled &&
1422             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1423             !_isExcludedFromFees[from]
1424         ) {
1425             autoBurnLiquidityPairTokens();
1426         }
1427 
1428         bool takeFee = !swapping;
1429 
1430         // if any account belongs to _isExcludedFromFee account then remove the fee
1431         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1432             takeFee = false;
1433         }
1434 
1435         uint256 fees = 0;
1436         // only take fees on buys/sells, do not take on wallet transfers
1437         if (takeFee) {
1438             // on sell
1439             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1440                 fees = amount.mul(sellTotalFees).div(100);
1441                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1442                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1443                 tokensForDonation += (fees * sellDonationFee) / sellTotalFees;
1444             }
1445             // on buy
1446             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1447                 fees = amount.mul(buyTotalFees).div(100);
1448                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1449                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1450                 tokensForDonation += (fees * buyDonationFee) / buyTotalFees;
1451             }
1452 
1453             if (fees > 0) {
1454                 super._transfer(from, address(this), fees);
1455             }
1456 
1457             amount -= fees;
1458         }
1459 
1460         super._transfer(from, to, amount);
1461     }
1462 
1463     function swapTokensForEth(uint256 tokenAmount) private {
1464         // generate the uniswap pair path of token -> weth
1465         address[] memory path = new address[](2);
1466         path[0] = address(this);
1467         path[1] = uniswapV2Router.WETH();
1468 
1469         _approve(address(this), address(uniswapV2Router), tokenAmount);
1470 
1471         // make the swap
1472         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1473             tokenAmount,
1474             0, // accept any amount of ETH
1475             path,
1476             address(this),
1477             block.timestamp
1478         );
1479     }
1480 
1481     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1482         // approve token transfer to cover all possible scenarios
1483         _approve(address(this), address(uniswapV2Router), tokenAmount);
1484 
1485         // add the liquidity
1486         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1487             address(this),
1488             tokenAmount,
1489             0, // slippage is unavoidable
1490             0, // slippage is unavoidable
1491             deadAddress,
1492             block.timestamp
1493         );
1494     }
1495 
1496     function swapBack() private {
1497         uint256 contractBalance = balanceOf(address(this));
1498         uint256 totalTokensToSwap = tokensForLiquidity +
1499             tokensForDonation +
1500             tokensForDev;
1501         bool success;
1502 
1503         if (contractBalance == 0 || totalTokensToSwap == 0) {
1504             return;
1505         }
1506 
1507         if (contractBalance > swapTokensAtAmount * 20) {
1508             contractBalance = swapTokensAtAmount * 20;
1509         }
1510 
1511         // Halve the amount of liquidity tokens
1512         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1513             totalTokensToSwap /
1514             2;
1515         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1516 
1517         uint256 initialETHBalance = address(this).balance;
1518 
1519         swapTokensForEth(amountToSwapForETH);
1520 
1521         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1522 
1523         uint256 ethForDonation = ethBalance.mul(tokensForDonation).div(
1524             totalTokensToSwap
1525         );
1526         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1527 
1528         uint256 ethForLiquidity = ethBalance - ethForDonation - ethForDev;
1529 
1530         tokensForLiquidity = 0;
1531         tokensForDonation = 0;
1532         tokensForDev = 0;
1533 
1534         (success, ) = address(devWallet).call{value: ethForDev}("");
1535 
1536         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1537             addLiquidity(liquidityTokens, ethForLiquidity);
1538             emit SwapAndLiquify(
1539                 amountToSwapForETH,
1540                 ethForLiquidity,
1541                 tokensForLiquidity
1542             );
1543         }
1544 
1545         (success, ) = address(donationWallet).call{
1546             value: address(this).balance
1547         }("");
1548     }
1549 
1550     function setAutoLPBurnSettings(
1551         uint256 _frequencyInSeconds,
1552         uint256 _percent,
1553         bool _Enabled
1554     ) external onlyOwner {
1555         require(
1556             _frequencyInSeconds >= 600,
1557             "cannot set buyback more often than every 10 minutes"
1558         );
1559         require(
1560             _percent <= 1000 && _percent >= 0,
1561             "Must set auto LP burn percent between 0% and 10%"
1562         );
1563         lpBurnFrequency = _frequencyInSeconds;
1564         percentForLPBurn = _percent;
1565         lpBurnEnabled = _Enabled;
1566     }
1567 
1568     function autoBurnLiquidityPairTokens() internal returns (bool) {
1569         lastLpBurnTime = block.timestamp;
1570 
1571         // get balance of liquidity pair
1572         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1573 
1574         // calculate amount to burn
1575         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1576             10000
1577         );
1578 
1579         // pull tokens from pancakePair liquidity and move to dead address permanently
1580         if (amountToBurn > 0) {
1581             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1582         }
1583 
1584         //sync price since this is not in a swap transaction!
1585         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1586         pair.sync();
1587         emit AutoNukeLP();
1588         return true;
1589     }
1590 
1591     function manualBurnLiquidityPairTokens(uint256 percent)
1592         external
1593         onlyOwner
1594         returns (bool)
1595     {
1596         require(
1597             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1598             "Must wait for cooldown to finish"
1599         );
1600         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1601         lastManualLpBurnTime = block.timestamp;
1602 
1603         // get balance of liquidity pair
1604         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1605 
1606         // calculate amount to burn
1607         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1608 
1609         // pull tokens from pancakePair liquidity and move to dead address permanently
1610         if (amountToBurn > 0) {
1611             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1612         }
1613 
1614         //sync price since this is not in a swap transaction!
1615         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1616         pair.sync();
1617         emit ManualNukeLP();
1618         return true;
1619     }
1620 }