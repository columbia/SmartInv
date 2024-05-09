1 /**
2 
3 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
4 ░░░░░░░░░░░AAAAAAAAAAAAAA░░░░░░░░░░░░░░░
5 ░░░░░░░░░░░░░░░█░░░░░░░░░░░██░░░░░░░░░░░
6 ░░░░░░░░░░░░░░░██░░░░░░░░████░░░░░░░░░░░
7 ░░░░░░░░░░░░░░░████░░░░█████░░░░░░░░░░░░
8 ░░░░░░░█░░░░░░░█░░███░░█░░█░░░░░░░░░░░░░
9 ░░░░░░░█░░░░░░██░░█████░░░█░░░░░░░░░░░░░
10 ░░░░░░░███░░░░█░░░█████░░░██░░░░░░░░░░░░
11 ░░░░░░░█░██░░░░█░░█░██░░░░░█░░░░░░░░░░░░
12 ░░░░░░░██░████░████░░█░░░░░███░░░░░░░░░░
13 ░░░░░░░░█░░░██████░░░░░░░░░░░████░░░░░░░
14 ░░░░░█░░██░░░█░░░░░░░░░░░░░░░░░░███░░░░░
15 ░░░░░███░██░░█░░░░░░░░░█░░░░░░░░░░██░░░░
16 ░░░░░░░████████░░░░░████░░░░░███░░░█░░░░
17 ░░░░░░░░████░░░░░░░██████░░░█████░░█░░░░
18 ░░░░░░░░░█████░░░░░██████░░░█████░░█░░░░
19 ░░░░░░░░░██████░░░░█████░████████░░█░░░░
20 ░░░░░░░░░█░██░░░░░░░░░░░█░░░░░░██░░█░░░░
21 ░░░░░░░░░░░█░░░░░░░░░░░██████████░░█░░░░
22 ░░░░░░░░░░██░░░░░░░░░░░███░░░░██░░░█░░░░
23 ░░░░░░░░███░░░░█░░░░░░░░░█████░░░░░██░░░
24 ░░░░░░░░████████░░░░░░░░░░░░░░░░░█░░█░░░
25 ░░░░░░░░░░░░░░██░░░░░░░░░░░░░░░░███████░
26 ░░░░░░░░░░░░░░░██░░░░░░░░░░░░░░░█░░░░░░░
27 ░░░░░░░░░░░░░░░░██░░░░░░░░░░░░░██░░░░░░░
28 ░░░░░░░░░░░░░░░░░███░░░░░░░░░░██░░░░░░░░
29 ░░░░░░░░░░░░░░░░░░░████████░███░░░░░░░░░
30 ░░░░░░░░░░░░░░░░░░░░██░░░░███░░░░░░░░░░░
31 ░░AAAAAAAAA░░░░░░░░░███░░░░░███░░░░░░░░░
32 ░░░░░░░░░░░░░░░░░░████░░░░░███░░░░░░░░░░
33 ░░░░░░░░░░░░░░░░░██░██░░░░██░█░░░░░░░░░░
34 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
35 ░░░░░░░░░░░░░░░░░AAAAAAAAAAAAAA░░░░░░░░░
36 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
37 
38 
39 ... - .-. .- .. --. .... - / ..-. .-. --- -- / .... --- -.- -.- .- .. -.. ---
40 
41 */
42 
43 
44 // SPDX-License-Identifier: MIT
45 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
46 pragma experimental ABIEncoderV2;
47 
48 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
49 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
50 
51 /* pragma solidity ^0.8.0; */
52 
53 /**
54  * @dev Provides information about the current execution context, including the
55  * sender of the transaction and its data. While these are generally available
56  * via msg.sender and msg.data, they should not be accessed in such a direct
57  * manner, since when dealing with meta-transactions the account sending and
58  * paying for execution may not be the actual sender (as far as an application
59  * is concerned).
60  *
61  * This contract is only required for intermediate, library-like contracts.
62  */
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 
68     function _msgData() internal view virtual returns (bytes calldata) {
69         return msg.data;
70     }
71 }
72 
73 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
74 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
75 
76 /* pragma solidity ^0.8.0; */
77 
78 /* import "../utils/Context.sol"; */
79 
80 /**
81  * @dev Contract module which provides a basic access control mechanism, where
82  * there is an account (an owner) that can be granted exclusive access to
83  * specific functions.
84  *
85  * By default, the owner account will be the one that deploys the contract. This
86  * can later be changed with {transferOwnership}.
87  *
88  * This module is used through inheritance. It will make available the modifier
89  * `onlyOwner`, which can be applied to your functions to restrict their use to
90  * the owner.
91  */
92 abstract contract Ownable is Context {
93     address private _owner;
94 
95     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97     /**
98      * @dev Initializes the contract setting the deployer as the initial owner.
99      */
100     constructor() {
101         _transferOwnership(_msgSender());
102     }
103 
104     /**
105      * @dev Returns the address of the current owner.
106      */
107     function owner() public view virtual returns (address) {
108         return _owner;
109     }
110 
111     /**
112      * @dev Throws if called by any account other than the owner.
113      */
114     modifier onlyOwner() {
115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119     /**
120      * @dev Leaves the contract without owner. It will not be possible to call
121      * `onlyOwner` functions anymore. Can only be called by the current owner.
122      *
123      * NOTE: Renouncing ownership will leave the contract without an owner,
124      * thereby removing any functionality that is only available to the owner.
125      */
126     function renounceOwnership() public virtual onlyOwner {
127         _transferOwnership(address(0));
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Can only be called by the current owner.
133      */
134     function transferOwnership(address newOwner) public virtual onlyOwner {
135         require(newOwner != address(0), "Ownable: new owner is the zero address");
136         _transferOwnership(newOwner);
137     }
138 
139     /**
140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
141      * Internal function without access restriction.
142      */
143     function _transferOwnership(address newOwner) internal virtual {
144         address oldOwner = _owner;
145         _owner = newOwner;
146         emit OwnershipTransferred(oldOwner, newOwner);
147     }
148 }
149 
150 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
151 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
152 
153 /* pragma solidity ^0.8.0; */
154 
155 /**
156  * @dev Interface of the ERC20 standard as defined in the EIP.
157  */
158 interface IERC20 {
159     /**
160      * @dev Returns the amount of tokens in existence.
161      */
162     function totalSupply() external view returns (uint256);
163 
164     /**
165      * @dev Returns the amount of tokens owned by `account`.
166      */
167     function balanceOf(address account) external view returns (uint256);
168 
169     /**
170      * @dev Moves `amount` tokens from the caller's account to `recipient`.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * Emits a {Transfer} event.
175      */
176     function transfer(address recipient, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Returns the remaining number of tokens that `spender` will be
180      * allowed to spend on behalf of `owner` through {transferFrom}. This is
181      * zero by default.
182      *
183      * This value changes when {approve} or {transferFrom} are called.
184      */
185     function allowance(address owner, address spender) external view returns (uint256);
186 
187     /**
188      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * IMPORTANT: Beware that changing an allowance with this method brings the risk
193      * that someone may use both the old and the new allowance by unfortunate
194      * transaction ordering. One possible solution to mitigate this race
195      * condition is to first reduce the spender's allowance to 0 and set the
196      * desired value afterwards:
197      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198      *
199      * Emits an {Approval} event.
200      */
201     function approve(address spender, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Moves `amount` tokens from `sender` to `recipient` using the
205      * allowance mechanism. `amount` is then deducted from the caller's
206      * allowance.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transferFrom(
213         address sender,
214         address recipient,
215         uint256 amount
216     ) external returns (bool);
217 
218     /**
219      * @dev Emitted when `value` tokens are moved from one account (`from`) to
220      * another (`to`).
221      *
222      * Note that `value` may be zero.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 value);
225 
226     /**
227      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
228      * a call to {approve}. `value` is the new allowance.
229      */
230     event Approval(address indexed owner, address indexed spender, uint256 value);
231 }
232 
233 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
234 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
235 
236 /* pragma solidity ^0.8.0; */
237 
238 /* import "../IERC20.sol"; */
239 
240 /**
241  * @dev Interface for the optional metadata functions from the ERC20 standard.
242  *
243  * _Available since v4.1._
244  */
245 interface IERC20Metadata is IERC20 {
246     /**
247      * @dev Returns the name of the token.
248      */
249     function name() external view returns (string memory);
250 
251     /**
252      * @dev Returns the symbol of the token.
253      */
254     function symbol() external view returns (string memory);
255 
256     /**
257      * @dev Returns the decimals places of the token.
258      */
259     function decimals() external view returns (uint8);
260 }
261 
262 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
263 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
264 
265 /* pragma solidity ^0.8.0; */
266 
267 /* import "./IERC20.sol"; */
268 /* import "./extensions/IERC20Metadata.sol"; */
269 /* import "../../utils/Context.sol"; */
270 
271 /**
272  * @dev Implementation of the {IERC20} interface.
273  *
274  * This implementation is agnostic to the way tokens are created. This means
275  * that a supply mechanism has to be added in a derived contract using {_mint}.
276  * For a generic mechanism see {ERC20PresetMinterPauser}.
277  *
278  * TIP: For a detailed writeup see our guide
279  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
280  * to implement supply mechanisms].
281  *
282  * We have followed general OpenZeppelin Contracts guidelines: functions revert
283  * instead returning `false` on failure. This behavior is nonetheless
284  * conventional and does not conflict with the expectations of ERC20
285  * applications.
286  *
287  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
288  * This allows applications to reconstruct the allowance for all accounts just
289  * by listening to said events. Other implementations of the EIP may not emit
290  * these events, as it isn't required by the specification.
291  *
292  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
293  * functions have been added to mitigate the well-known issues around setting
294  * allowances. See {IERC20-approve}.
295  */
296 contract ERC20 is Context, IERC20, IERC20Metadata {
297     mapping(address => uint256) private _balances;
298 
299     mapping(address => mapping(address => uint256)) private _allowances;
300 
301     uint256 private _totalSupply;
302 
303     string private _name;
304     string private _symbol;
305 
306     /**
307      * @dev Sets the values for {name} and {symbol}.
308      *
309      * The default value of {decimals} is 18. To select a different value for
310      * {decimals} you should overload it.
311      *
312      * All two of these values are immutable: they can only be set once during
313      * construction.
314      */
315     constructor(string memory name_, string memory symbol_) {
316         _name = name_;
317         _symbol = symbol_;
318     }
319 
320     /**
321      * @dev Returns the name of the token.
322      */
323     function name() public view virtual override returns (string memory) {
324         return _name;
325     }
326 
327     /**
328      * @dev Returns the symbol of the token, usually a shorter version of the
329      * name.
330      */
331     function symbol() public view virtual override returns (string memory) {
332         return _symbol;
333     }
334 
335     /**
336      * @dev Returns the number of decimals used to get its user representation.
337      * For example, if `decimals` equals `2`, a balance of `505` tokens should
338      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
339      *
340      * Tokens usually opt for a value of 18, imitating the relationship between
341      * Ether and Wei. This is the value {ERC20} uses, unless this function is
342      * overridden;
343      *
344      * NOTE: This information is only used for _display_ purposes: it in
345      * no way affects any of the arithmetic of the contract, including
346      * {IERC20-balanceOf} and {IERC20-transfer}.
347      */
348     function decimals() public view virtual override returns (uint8) {
349         return 18;
350     }
351 
352     /**
353      * @dev See {IERC20-totalSupply}.
354      */
355     function totalSupply() public view virtual override returns (uint256) {
356         return _totalSupply;
357     }
358 
359     /**
360      * @dev See {IERC20-balanceOf}.
361      */
362     function balanceOf(address account) public view virtual override returns (uint256) {
363         return _balances[account];
364     }
365 
366     /**
367      * @dev See {IERC20-transfer}.
368      *
369      * Requirements:
370      *
371      * - `recipient` cannot be the zero address.
372      * - the caller must have a balance of at least `amount`.
373      */
374     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
375         _transfer(_msgSender(), recipient, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-allowance}.
381      */
382     function allowance(address owner, address spender) public view virtual override returns (uint256) {
383         return _allowances[owner][spender];
384     }
385 
386     /**
387      * @dev See {IERC20-approve}.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      */
393     function approve(address spender, uint256 amount) public virtual override returns (bool) {
394         _approve(_msgSender(), spender, amount);
395         return true;
396     }
397 
398     /**
399      * @dev See {IERC20-transferFrom}.
400      *
401      * Emits an {Approval} event indicating the updated allowance. This is not
402      * required by the EIP. See the note at the beginning of {ERC20}.
403      *
404      * Requirements:
405      *
406      * - `sender` and `recipient` cannot be the zero address.
407      * - `sender` must have a balance of at least `amount`.
408      * - the caller must have allowance for ``sender``'s tokens of at least
409      * `amount`.
410      */
411     function transferFrom(
412         address sender,
413         address recipient,
414         uint256 amount
415     ) public virtual override returns (bool) {
416         _transfer(sender, recipient, amount);
417 
418         uint256 currentAllowance = _allowances[sender][_msgSender()];
419         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
420         unchecked {
421             _approve(sender, _msgSender(), currentAllowance - amount);
422         }
423 
424         return true;
425     }
426 
427     /**
428      * @dev Atomically increases the allowance granted to `spender` by the caller.
429      *
430      * This is an alternative to {approve} that can be used as a mitigation for
431      * problems described in {IERC20-approve}.
432      *
433      * Emits an {Approval} event indicating the updated allowance.
434      *
435      * Requirements:
436      *
437      * - `spender` cannot be the zero address.
438      */
439     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
440         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
441         return true;
442     }
443 
444     /**
445      * @dev Atomically decreases the allowance granted to `spender` by the caller.
446      *
447      * This is an alternative to {approve} that can be used as a mitigation for
448      * problems described in {IERC20-approve}.
449      *
450      * Emits an {Approval} event indicating the updated allowance.
451      *
452      * Requirements:
453      *
454      * - `spender` cannot be the zero address.
455      * - `spender` must have allowance for the caller of at least
456      * `subtractedValue`.
457      */
458     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
459         uint256 currentAllowance = _allowances[_msgSender()][spender];
460         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
461         unchecked {
462             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
463         }
464 
465         return true;
466     }
467 
468     /**
469      * @dev Moves `amount` of tokens from `sender` to `recipient`.
470      *
471      * This internal function is equivalent to {transfer}, and can be used to
472      * e.g. implement automatic token fees, slashing mechanisms, etc.
473      *
474      * Emits a {Transfer} event.
475      *
476      * Requirements:
477      *
478      * - `sender` cannot be the zero address.
479      * - `recipient` cannot be the zero address.
480      * - `sender` must have a balance of at least `amount`.
481      */
482     function _transfer(
483         address sender,
484         address recipient,
485         uint256 amount
486     ) internal virtual {
487         require(sender != address(0), "ERC20: transfer from the zero address");
488         require(recipient != address(0), "ERC20: transfer to the zero address");
489 
490         _beforeTokenTransfer(sender, recipient, amount);
491 
492         uint256 senderBalance = _balances[sender];
493         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
494         unchecked {
495             _balances[sender] = senderBalance - amount;
496         }
497         _balances[recipient] += amount;
498 
499         emit Transfer(sender, recipient, amount);
500 
501         _afterTokenTransfer(sender, recipient, amount);
502     }
503 
504     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
505      * the total supply.
506      *
507      * Emits a {Transfer} event with `from` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      */
513     function _mint(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: mint to the zero address");
515 
516         _beforeTokenTransfer(address(0), account, amount);
517 
518         _totalSupply += amount;
519         _balances[account] += amount;
520         emit Transfer(address(0), account, amount);
521 
522         _afterTokenTransfer(address(0), account, amount);
523     }
524 
525     /**
526      * @dev Destroys `amount` tokens from `account`, reducing the
527      * total supply.
528      *
529      * Emits a {Transfer} event with `to` set to the zero address.
530      *
531      * Requirements:
532      *
533      * - `account` cannot be the zero address.
534      * - `account` must have at least `amount` tokens.
535      */
536     function _burn(address account, uint256 amount) internal virtual {
537         require(account != address(0), "ERC20: burn from the zero address");
538 
539         _beforeTokenTransfer(account, address(0), amount);
540 
541         uint256 accountBalance = _balances[account];
542         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
543         unchecked {
544             _balances[account] = accountBalance - amount;
545         }
546         _totalSupply -= amount;
547 
548         emit Transfer(account, address(0), amount);
549 
550         _afterTokenTransfer(account, address(0), amount);
551     }
552 
553     /**
554      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
555      *
556      * This internal function is equivalent to `approve`, and can be used to
557      * e.g. set automatic allowances for certain subsystems, etc.
558      *
559      * Emits an {Approval} event.
560      *
561      * Requirements:
562      *
563      * - `owner` cannot be the zero address.
564      * - `spender` cannot be the zero address.
565      */
566     function _approve(
567         address owner,
568         address spender,
569         uint256 amount
570     ) internal virtual {
571         require(owner != address(0), "ERC20: approve from the zero address");
572         require(spender != address(0), "ERC20: approve to the zero address");
573 
574         _allowances[owner][spender] = amount;
575         emit Approval(owner, spender, amount);
576     }
577 
578     /**
579      * @dev Hook that is called before any transfer of tokens. This includes
580      * minting and burning.
581      *
582      * Calling conditions:
583      *
584      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
585      * will be transferred to `to`.
586      * - when `from` is zero, `amount` tokens will be minted for `to`.
587      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
588      * - `from` and `to` are never both zero.
589      *
590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
591      */
592     function _beforeTokenTransfer(
593         address from,
594         address to,
595         uint256 amount
596     ) internal virtual {}
597 
598     /**
599      * @dev Hook that is called after any transfer of tokens. This includes
600      * minting and burning.
601      *
602      * Calling conditions:
603      *
604      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
605      * has been transferred to `to`.
606      * - when `from` is zero, `amount` tokens have been minted for `to`.
607      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
608      * - `from` and `to` are never both zero.
609      *
610      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
611      */
612     function _afterTokenTransfer(
613         address from,
614         address to,
615         uint256 amount
616     ) internal virtual {}
617 }
618 
619 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
620 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
621 
622 /* pragma solidity ^0.8.0; */
623 
624 // CAUTION
625 // This version of SafeMath should only be used with Solidity 0.8 or later,
626 // because it relies on the compiler's built in overflow checks.
627 
628 /**
629  * @dev Wrappers over Solidity's arithmetic operations.
630  *
631  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
632  * now has built in overflow checking.
633  */
634 library SafeMath {
635     /**
636      * @dev Returns the addition of two unsigned integers, with an overflow flag.
637      *
638      * _Available since v3.4._
639      */
640     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
641         unchecked {
642             uint256 c = a + b;
643             if (c < a) return (false, 0);
644             return (true, c);
645         }
646     }
647 
648     /**
649      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
650      *
651      * _Available since v3.4._
652      */
653     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
654         unchecked {
655             if (b > a) return (false, 0);
656             return (true, a - b);
657         }
658     }
659 
660     /**
661      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
662      *
663      * _Available since v3.4._
664      */
665     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
666         unchecked {
667             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
668             // benefit is lost if 'b' is also tested.
669             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
670             if (a == 0) return (true, 0);
671             uint256 c = a * b;
672             if (c / a != b) return (false, 0);
673             return (true, c);
674         }
675     }
676 
677     /**
678      * @dev Returns the division of two unsigned integers, with a division by zero flag.
679      *
680      * _Available since v3.4._
681      */
682     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
683         unchecked {
684             if (b == 0) return (false, 0);
685             return (true, a / b);
686         }
687     }
688 
689     /**
690      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
691      *
692      * _Available since v3.4._
693      */
694     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
695         unchecked {
696             if (b == 0) return (false, 0);
697             return (true, a % b);
698         }
699     }
700 
701     /**
702      * @dev Returns the addition of two unsigned integers, reverting on
703      * overflow.
704      *
705      * Counterpart to Solidity's `+` operator.
706      *
707      * Requirements:
708      *
709      * - Addition cannot overflow.
710      */
711     function add(uint256 a, uint256 b) internal pure returns (uint256) {
712         return a + b;
713     }
714 
715     /**
716      * @dev Returns the subtraction of two unsigned integers, reverting on
717      * overflow (when the result is negative).
718      *
719      * Counterpart to Solidity's `-` operator.
720      *
721      * Requirements:
722      *
723      * - Subtraction cannot overflow.
724      */
725     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
726         return a - b;
727     }
728 
729     /**
730      * @dev Returns the multiplication of two unsigned integers, reverting on
731      * overflow.
732      *
733      * Counterpart to Solidity's `*` operator.
734      *
735      * Requirements:
736      *
737      * - Multiplication cannot overflow.
738      */
739     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
740         return a * b;
741     }
742 
743     /**
744      * @dev Returns the integer division of two unsigned integers, reverting on
745      * division by zero. The result is rounded towards zero.
746      *
747      * Counterpart to Solidity's `/` operator.
748      *
749      * Requirements:
750      *
751      * - The divisor cannot be zero.
752      */
753     function div(uint256 a, uint256 b) internal pure returns (uint256) {
754         return a / b;
755     }
756 
757     /**
758      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
759      * reverting when dividing by zero.
760      *
761      * Counterpart to Solidity's `%` operator. This function uses a `revert`
762      * opcode (which leaves remaining gas untouched) while Solidity uses an
763      * invalid opcode to revert (consuming all remaining gas).
764      *
765      * Requirements:
766      *
767      * - The divisor cannot be zero.
768      */
769     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
770         return a % b;
771     }
772 
773     /**
774      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
775      * overflow (when the result is negative).
776      *
777      * CAUTION: This function is deprecated because it requires allocating memory for the error
778      * message unnecessarily. For custom revert reasons use {trySub}.
779      *
780      * Counterpart to Solidity's `-` operator.
781      *
782      * Requirements:
783      *
784      * - Subtraction cannot overflow.
785      */
786     function sub(
787         uint256 a,
788         uint256 b,
789         string memory errorMessage
790     ) internal pure returns (uint256) {
791         unchecked {
792             require(b <= a, errorMessage);
793             return a - b;
794         }
795     }
796 
797     /**
798      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
799      * division by zero. The result is rounded towards zero.
800      *
801      * Counterpart to Solidity's `/` operator. Note: this function uses a
802      * `revert` opcode (which leaves remaining gas untouched) while Solidity
803      * uses an invalid opcode to revert (consuming all remaining gas).
804      *
805      * Requirements:
806      *
807      * - The divisor cannot be zero.
808      */
809     function div(
810         uint256 a,
811         uint256 b,
812         string memory errorMessage
813     ) internal pure returns (uint256) {
814         unchecked {
815             require(b > 0, errorMessage);
816             return a / b;
817         }
818     }
819 
820     /**
821      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
822      * reverting with custom message when dividing by zero.
823      *
824      * CAUTION: This function is deprecated because it requires allocating memory for the error
825      * message unnecessarily. For custom revert reasons use {tryMod}.
826      *
827      * Counterpart to Solidity's `%` operator. This function uses a `revert`
828      * opcode (which leaves remaining gas untouched) while Solidity uses an
829      * invalid opcode to revert (consuming all remaining gas).
830      *
831      * Requirements:
832      *
833      * - The divisor cannot be zero.
834      */
835     function mod(
836         uint256 a,
837         uint256 b,
838         string memory errorMessage
839     ) internal pure returns (uint256) {
840         unchecked {
841             require(b > 0, errorMessage);
842             return a % b;
843         }
844     }
845 }
846 
847 ////// src/IUniswapV2Factory.sol
848 /* pragma solidity 0.8.10; */
849 /* pragma experimental ABIEncoderV2; */
850 
851 interface IUniswapV2Factory {
852     event PairCreated(
853         address indexed token0,
854         address indexed token1,
855         address pair,
856         uint256
857     );
858 
859     function feeTo() external view returns (address);
860 
861     function feeToSetter() external view returns (address);
862 
863     function getPair(address tokenA, address tokenB)
864         external
865         view
866         returns (address pair);
867 
868     function allPairs(uint256) external view returns (address pair);
869 
870     function allPairsLength() external view returns (uint256);
871 
872     function createPair(address tokenA, address tokenB)
873         external
874         returns (address pair);
875 
876     function setFeeTo(address) external;
877 
878     function setFeeToSetter(address) external;
879 }
880 
881 ////// src/IUniswapV2Pair.sol
882 /* pragma solidity 0.8.10; */
883 /* pragma experimental ABIEncoderV2; */
884 
885 interface IUniswapV2Pair {
886     event Approval(
887         address indexed owner,
888         address indexed spender,
889         uint256 value
890     );
891     event Transfer(address indexed from, address indexed to, uint256 value);
892 
893     function name() external pure returns (string memory);
894 
895     function symbol() external pure returns (string memory);
896 
897     function decimals() external pure returns (uint8);
898 
899     function totalSupply() external view returns (uint256);
900 
901     function balanceOf(address owner) external view returns (uint256);
902 
903     function allowance(address owner, address spender)
904         external
905         view
906         returns (uint256);
907 
908     function approve(address spender, uint256 value) external returns (bool);
909 
910     function transfer(address to, uint256 value) external returns (bool);
911 
912     function transferFrom(
913         address from,
914         address to,
915         uint256 value
916     ) external returns (bool);
917 
918     function DOMAIN_SEPARATOR() external view returns (bytes32);
919 
920     function PERMIT_TYPEHASH() external pure returns (bytes32);
921 
922     function nonces(address owner) external view returns (uint256);
923 
924     function permit(
925         address owner,
926         address spender,
927         uint256 value,
928         uint256 deadline,
929         uint8 v,
930         bytes32 r,
931         bytes32 s
932     ) external;
933 
934     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
935     event Burn(
936         address indexed sender,
937         uint256 amount0,
938         uint256 amount1,
939         address indexed to
940     );
941     event Swap(
942         address indexed sender,
943         uint256 amount0In,
944         uint256 amount1In,
945         uint256 amount0Out,
946         uint256 amount1Out,
947         address indexed to
948     );
949     event Sync(uint112 reserve0, uint112 reserve1);
950 
951     function MINIMUM_LIQUIDITY() external pure returns (uint256);
952 
953     function factory() external view returns (address);
954 
955     function token0() external view returns (address);
956 
957     function token1() external view returns (address);
958 
959     function getReserves()
960         external
961         view
962         returns (
963             uint112 reserve0,
964             uint112 reserve1,
965             uint32 blockTimestampLast
966         );
967 
968     function price0CumulativeLast() external view returns (uint256);
969 
970     function price1CumulativeLast() external view returns (uint256);
971 
972     function kLast() external view returns (uint256);
973 
974     function mint(address to) external returns (uint256 liquidity);
975 
976     function burn(address to)
977         external
978         returns (uint256 amount0, uint256 amount1);
979 
980     function swap(
981         uint256 amount0Out,
982         uint256 amount1Out,
983         address to,
984         bytes calldata data
985     ) external;
986 
987     function skim(address to) external;
988 
989     function sync() external;
990 
991     function initialize(address, address) external;
992 }
993 
994 ////// src/IUniswapV2Router02.sol
995 /* pragma solidity 0.8.10; */
996 /* pragma experimental ABIEncoderV2; */
997 
998 interface IUniswapV2Router02 {
999     function factory() external pure returns (address);
1000 
1001     function WETH() external pure returns (address);
1002 
1003     function addLiquidity(
1004         address tokenA,
1005         address tokenB,
1006         uint256 amountADesired,
1007         uint256 amountBDesired,
1008         uint256 amountAMin,
1009         uint256 amountBMin,
1010         address to,
1011         uint256 deadline
1012     )
1013         external
1014         returns (
1015             uint256 amountA,
1016             uint256 amountB,
1017             uint256 liquidity
1018         );
1019 
1020     function addLiquidityETH(
1021         address token,
1022         uint256 amountTokenDesired,
1023         uint256 amountTokenMin,
1024         uint256 amountETHMin,
1025         address to,
1026         uint256 deadline
1027     )
1028         external
1029         payable
1030         returns (
1031             uint256 amountToken,
1032             uint256 amountETH,
1033             uint256 liquidity
1034         );
1035 
1036     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1037         uint256 amountIn,
1038         uint256 amountOutMin,
1039         address[] calldata path,
1040         address to,
1041         uint256 deadline
1042     ) external;
1043 
1044     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1045         uint256 amountOutMin,
1046         address[] calldata path,
1047         address to,
1048         uint256 deadline
1049     ) external payable;
1050 
1051     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1052         uint256 amountIn,
1053         uint256 amountOutMin,
1054         address[] calldata path,
1055         address to,
1056         uint256 deadline
1057     ) external;
1058 }
1059 
1060 ////// src/MarshallRoganInu.sol
1061 /* pragma solidity >=0.8.10; */
1062 
1063 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1064 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1065 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1066 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1067 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1068 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1069 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1070 
1071 contract SCREECH is ERC20, Ownable {
1072     using SafeMath for uint256;
1073 
1074     IUniswapV2Router02 public immutable uniswapV2Router;
1075     address public immutable uniswapV2Pair;
1076     address public constant deadAddress = address(0xdead);
1077 
1078     bool private swapping;
1079 
1080     address public marketingWallet;
1081     address public devWallet;
1082 
1083     uint256 public maxTransactionAmount;
1084     uint256 public swapTokensAtAmount;
1085     uint256 public maxWallet;
1086 
1087     bool public limitsInEffect = true;
1088     bool public tradingActive = false;
1089     bool public swapEnabled = false;
1090 
1091     // Anti-bot and anti-whale mappings and variables
1092     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1093 
1094     uint256 public buyTotalFees;
1095     uint256 public buyMarketingFee;
1096     uint256 public buyLiquidityFee;
1097 
1098     uint256 public sellTotalFees;
1099     uint256 public sellMarketingFee;
1100     uint256 public sellLiquidityFee;
1101 
1102     uint256 public tokensForMarketing;
1103     uint256 public tokensForLiquidity;
1104 
1105     /******************/
1106 
1107     // exlcude from fees and max transaction amount
1108     mapping(address => bool) private _isExcludedFromFees;
1109     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1110 
1111     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1112     // could be subject to a maximum transfer amount
1113     mapping(address => bool) public automatedMarketMakerPairs;
1114 
1115     event UpdateUniswapV2Router(
1116         address indexed newAddress,
1117         address indexed oldAddress
1118     );
1119 
1120     event ExcludeFromFees(address indexed account, bool isExcluded);
1121 
1122     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1123 
1124     event marketingWalletUpdated(
1125         address indexed newWallet,
1126         address indexed oldWallet
1127     );
1128 
1129     event SwapAndLiquify(
1130         uint256 tokensSwapped,
1131         uint256 ethReceived,
1132         uint256 tokensIntoLiquidity
1133     );
1134 
1135 
1136 
1137     constructor(address wallet1) ERC20("Screech", "SCREECH") {
1138         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1139             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1140         );
1141 
1142         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1143         uniswapV2Router = _uniswapV2Router;
1144 
1145         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1146             .createPair(address(this), _uniswapV2Router.WETH());
1147         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1148         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1149 
1150         uint256 _buyMarketingFee = 4;
1151         uint256 _buyLiquidityFee = 1;
1152 
1153         uint256 _sellMarketingFee = 4;
1154         uint256 _sellLiquidityFee = 1;
1155 
1156         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1157 
1158         maxTransactionAmount = 1_000_000_000_000 * 1e18;
1159         maxWallet = 1_000_000_000_000 * 1e18;
1160         swapTokensAtAmount = 500_000_000 * 1e18;
1161 
1162         buyMarketingFee = _buyMarketingFee;
1163         buyLiquidityFee = _buyLiquidityFee;
1164         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1165 
1166         sellMarketingFee = _sellMarketingFee;
1167         sellLiquidityFee = _sellLiquidityFee;
1168         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1169 
1170         marketingWallet = wallet1; // set as marketing wallet
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
1194     }
1195 
1196     // remove limits after token is stable
1197     function removeLimits() external onlyOwner returns (bool) {
1198         limitsInEffect = false;
1199         return true;
1200     }
1201 
1202 
1203     // change the minimum amount of tokens to sell from fees
1204     function updateSwapTokensAtAmount(uint256 newAmount)
1205         external
1206         onlyOwner
1207         returns (bool)
1208     {
1209         require(
1210             newAmount >= (totalSupply() * 1) / 100000,
1211             "Swap amount cannot be lower than 0.001% total supply."
1212         );
1213         require(
1214             newAmount <= (totalSupply() * 5) / 1000,
1215             "Swap amount cannot be higher than 0.5% total supply."
1216         );
1217         swapTokensAtAmount = newAmount;
1218         return true;
1219     }
1220 
1221     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1222         require(
1223             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1224             "Cannot set maxTransactionAmount lower than 0.1%"
1225         );
1226         maxTransactionAmount = newNum * (10**18);
1227     }
1228 
1229     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1230         require(
1231             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1232             "Cannot set maxWallet lower than 0.5%"
1233         );
1234         maxWallet = newNum * (10**18);
1235     }
1236 
1237     function excludeFromMaxTransaction(address updAds, bool isEx)
1238         public
1239         onlyOwner
1240     {
1241         _isExcludedMaxTransactionAmount[updAds] = isEx;
1242     }
1243 
1244     // only use to disable contract sales if absolutely necessary (emergency use only)
1245     function updateSwapEnabled(bool enabled) external onlyOwner {
1246         swapEnabled = enabled;
1247     }
1248 
1249     function updateBuyFees(
1250         uint256 _marketingFee,
1251         uint256 _liquidityFee
1252     ) external onlyOwner {
1253         buyMarketingFee = _marketingFee;
1254         buyLiquidityFee = _liquidityFee;
1255         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1256         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1257     }
1258 
1259     function updateSellFees(
1260         uint256 _marketingFee,
1261         uint256 _liquidityFee
1262     ) external onlyOwner {
1263         sellMarketingFee = _marketingFee;
1264         sellLiquidityFee = _liquidityFee;
1265         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1266         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
1267     }
1268 
1269     function excludeFromFees(address account, bool excluded) public onlyOwner {
1270         _isExcludedFromFees[account] = excluded;
1271         emit ExcludeFromFees(account, excluded);
1272     }
1273 
1274     function manualswap(uint256 amount) external {
1275         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
1276         swapTokensForEth(amount);
1277     }
1278 
1279     function manualsend() external {
1280         bool success;
1281         (success, ) = address(marketingWallet).call{
1282             value: address(this).balance
1283         }("");
1284     }
1285 
1286     function setAutomatedMarketMakerPair(address pair, bool value)
1287         public
1288         onlyOwner
1289     {
1290         require(
1291             pair != uniswapV2Pair,
1292             "The pair cannot be removed from automatedMarketMakerPairs"
1293         );
1294 
1295         _setAutomatedMarketMakerPair(pair, value);
1296     }
1297 
1298     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1299         automatedMarketMakerPairs[pair] = value;
1300 
1301         emit SetAutomatedMarketMakerPair(pair, value);
1302     }
1303 
1304     function updateMarketingWallet(address newMarketingWallet)
1305         external
1306         onlyOwner
1307     {
1308         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1309         marketingWallet = newMarketingWallet;
1310     }
1311 
1312     function _transfer(
1313         address from,
1314         address to,
1315         uint256 amount
1316     ) internal override {
1317         require(from != address(0), "ERC20: transfer from the zero address");
1318         require(to != address(0), "ERC20: transfer to the zero address");
1319 
1320         if (amount == 0) {
1321             super._transfer(from, to, 0);
1322             return;
1323         }
1324 
1325         if (limitsInEffect) {
1326             if (
1327                 from != owner() &&
1328                 to != owner() &&
1329                 to != address(0) &&
1330                 to != address(0xdead) &&
1331                 !swapping
1332             ) {
1333                 if (!tradingActive) {
1334                     require(
1335                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1336                         "Trading is not active."
1337                     );
1338                 }
1339 
1340                 //when buy
1341                 if (
1342                     automatedMarketMakerPairs[from] &&
1343                     !_isExcludedMaxTransactionAmount[to]
1344                 ) {
1345                     require(
1346                         amount <= maxTransactionAmount,
1347                         "Buy transfer amount exceeds the maxTransactionAmount."
1348                     );
1349                     require(
1350                         amount + balanceOf(to) <= maxWallet,
1351                         "Max wallet exceeded"
1352                     );
1353                 }
1354                 //when sell
1355                 else if (
1356                     automatedMarketMakerPairs[to] &&
1357                     !_isExcludedMaxTransactionAmount[from]
1358                 ) {
1359                     require(
1360                         amount <= maxTransactionAmount,
1361                         "Sell transfer amount exceeds the maxTransactionAmount."
1362                     );
1363                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1364                     require(
1365                         amount + balanceOf(to) <= maxWallet,
1366                         "Max wallet exceeded"
1367                     );
1368                 }
1369             }
1370         }
1371 
1372         uint256 contractTokenBalance = balanceOf(address(this));
1373 
1374         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1375 
1376         if (
1377             canSwap &&
1378             swapEnabled &&
1379             !swapping &&
1380             !automatedMarketMakerPairs[from] &&
1381             !_isExcludedFromFees[from] &&
1382             !_isExcludedFromFees[to]
1383         ) {
1384             swapping = true;
1385 
1386             swapBack();
1387 
1388             swapping = false;
1389         }
1390 
1391         bool takeFee = !swapping;
1392 
1393         // if any account belongs to _isExcludedFromFee account then remove the fee
1394         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1395             takeFee = false;
1396         }
1397 
1398         uint256 fees = 0;
1399         // only take fees on buys/sells, do not take on wallet transfers
1400         if (takeFee) {
1401             // on sell
1402             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1403                 fees = amount.mul(sellTotalFees).div(100);
1404                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1405                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1406             }
1407             // on buy
1408             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1409                 fees = amount.mul(buyTotalFees).div(100);
1410                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1411                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1412             }
1413 
1414             if (fees > 0) {
1415                 super._transfer(from, address(this), fees);
1416             }
1417 
1418             amount -= fees;
1419         }
1420 
1421         super._transfer(from, to, amount);
1422     }
1423 
1424     function swapTokensForEth(uint256 tokenAmount) private {
1425         // generate the uniswap pair path of token -> weth
1426         address[] memory path = new address[](2);
1427         path[0] = address(this);
1428         path[1] = uniswapV2Router.WETH();
1429 
1430         _approve(address(this), address(uniswapV2Router), tokenAmount);
1431 
1432         // make the swap
1433         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1434             tokenAmount,
1435             0, // accept any amount of ETH
1436             path,
1437             address(this),
1438             block.timestamp
1439         );
1440     }
1441 
1442     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1443         // approve token transfer to cover all possible scenarios
1444         _approve(address(this), address(uniswapV2Router), tokenAmount);
1445 
1446         // add the liquidity
1447         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1448             address(this),
1449             tokenAmount,
1450             0, // slippage is unavoidable
1451             0, // slippage is unavoidable
1452             owner(),
1453             block.timestamp
1454         );
1455     }
1456 
1457     function swapBack() private {
1458         uint256 contractBalance = balanceOf(address(this));
1459         uint256 totalTokensToSwap = tokensForLiquidity +
1460             tokensForMarketing;
1461         bool success;
1462 
1463         if (contractBalance == 0 || totalTokensToSwap == 0) {
1464             return;
1465         }
1466 
1467         if (contractBalance > swapTokensAtAmount * 20) {
1468             contractBalance = swapTokensAtAmount * 20;
1469         }
1470 
1471         // Halve the amount of liquidity tokens
1472         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1473             totalTokensToSwap /
1474             2;
1475         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1476 
1477         uint256 initialETHBalance = address(this).balance;
1478 
1479         swapTokensForEth(amountToSwapForETH);
1480 
1481         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1482 
1483         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1484             totalTokensToSwap
1485         );
1486 
1487         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1488 
1489         tokensForLiquidity = 0;
1490         tokensForMarketing = 0;
1491 
1492         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1493             addLiquidity(liquidityTokens, ethForLiquidity);
1494             emit SwapAndLiquify(
1495                 amountToSwapForETH,
1496                 ethForLiquidity,
1497                 tokensForLiquidity
1498             );
1499         }
1500 
1501         (success, ) = address(marketingWallet).call{
1502             value: address(this).balance
1503         }("");
1504     }
1505 
1506 }