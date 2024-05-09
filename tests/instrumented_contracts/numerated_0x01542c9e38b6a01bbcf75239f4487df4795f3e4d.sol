1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-01
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // 
7 //            OOOOOOOOOOO     NNNNNNNN       NNNNNNNNEEEEEEEEEEEEEEEEEEEEEEE
8 //           OO:::::::::OOO  NN:::::::N       N::::::NE::::::::::::::::::::EE
9 //          OO:::::::::::::OO NN::::::::N      N::::::NE::::::::::::::::::::E
10 //         OO:::::::OOO:::::::NN:::::::::N     N::::::NEE::::::EEEEEEEEE::::E
11 //         OO::::::O   O::::::NN::::::::::N    N::::::N  E:::::E       EEEEEE
12 //         OO:::::O     O:::::NN:::::::::::N   N::::::N  E:::::E             
13 //         OO:::::O     O:::::NN:::::::N::::N  N::::::N  E::::::EEEEEEEEEE   
14 //         OO:::::O     O:::::NN::::::N N::::N N::::::N  E:::::::::::::::E   
15 //         OO:::::O     O:::::NN::::::N  N::::N:::::::N  E:::::::::::::::E   
16 //         OO:::::O     O:::::NN::::::N   N:::::::::::N  E::::::EEEEEEEEEE   
17 //         OO:::::O     O:::::NN::::::N    N::::::::::N  E:::::E             
18 //         OO::::::O   O::::::NN::::::N     N:::::::::N  E:::::E      EEEEEEE
19 //         OO:::::::OOO:::::::NN::::::N      N::::::::NEE::::::EEEEEEEE:::::E
20 //         OO::::::::::::::OO NN::::::N       N:::::::NE::::::::::::::::::::E
21 //          OO::::::::::OO   NN::::::N        N::::::NE::::::::::::::::::::EE
22 //           OOOOOOOOOOOO    NNNNNNNNN        NNNNNNNNEEEEEEEEEEEEEEEEEEEEEEE
23 // 
24 // 
25 // ...One Protocol to rule them all, one Protocol to find them, One Protocol to bring them all, and in the darkness bind them.
26 // 
27 //                                          
28 //                                     https://t.me/ONEPROTOCOLETH
29 //                   https://twitter.com/oneprotocoleth?s=21&t=o5IpGo2llaPnWVYN-I2GOA
30 // 
31 //                                          One Protocol Contract
32 //                 The purpose of this is to run the $ONE Protocol to run all Protocols.
33 //                     ETH Trending in perpetuity, just don't jeet like a simpleton
34 //                           Yes, we are serious, yes you will want to hold
35 //                                    No, don't be a jeet ass bitch
36 //                   - 4% to the revenue split helper (20% of revenue to holders)
37 //                                 - 1% to Liquidity Pool (automatic)
38 // 
39 pragma solidity 0.8.20;
40 
41 /**
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes calldata) {
57         return msg.data;
58     }
59 }
60 
61 /**
62  * @dev Contract module which provides a basic access control mechanism, where
63  * there is an account (an owner) that can be granted exclusive access to
64  * specific functions.
65  *
66  * By default, the owner account will be the one that deploys the contract. This
67  * can later be changed with {transferOwnership}.
68  *
69  * This module is used through inheritance. It will make available the modifier
70  * `onlyOwner`, which can be applied to your functions to restrict their use to
71  * the owner.
72  */
73 abstract contract Ownable is Context {
74     address private _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev Initializes the contract setting the deployer as the initial owner.
80      */
81     constructor() {
82         _transferOwnership(_msgSender());
83     }
84 
85     /**
86      * @dev Returns the address of the current owner.
87      */
88     function owner() public view virtual returns (address) {
89         return _owner;
90     }
91 
92     /**
93      * @dev Throws if called by any account other than the owner.
94      */
95     modifier onlyOwner() {
96         require(owner() == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     /**
101      * @dev Leaves the contract without owner. It will not be possible to call
102      * `onlyOwner` functions anymore. Can only be called by the current owner.
103      *
104      * NOTE: Renouncing ownership will leave the contract without an owner,
105      * thereby removing any functionality that is only available to the owner.
106      */
107     function renounceOwnership() public virtual onlyOwner {
108         _transferOwnership(address(0));
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Can only be called by the current owner.
114      */
115     function transferOwnership(address newOwner) public virtual onlyOwner {
116         require(newOwner != address(0), "Ownable: new owner is the zero address");
117         _transferOwnership(newOwner);
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Internal function without access restriction.
123      */
124     function _transferOwnership(address newOwner) internal virtual {
125         address oldOwner = _owner;
126         _owner = newOwner;
127         emit OwnershipTransferred(oldOwner, newOwner);
128     }
129 }
130 
131 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
132 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
133 
134 /* pragma solidity ^0.8.0; */
135 
136 /**
137  * @dev Interface of the ERC20 standard as defined in the EIP.
138  */
139 interface IERC20 {
140     /**
141      * @dev Returns the amount of tokens in existence.
142      */
143     function totalSupply() external view returns (uint256);
144 
145     /**
146      * @dev Returns the amount of tokens owned by `account`.
147      */
148     function balanceOf(address account) external view returns (uint256);
149 
150     /**
151      * @dev Moves `amount` tokens from the caller's account to `recipient`.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transfer(address recipient, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Returns the remaining number of tokens that `spender` will be
161      * allowed to spend on behalf of `owner` through {transferFrom}. This is
162      * zero by default.
163      *
164      * This value changes when {approve} or {transferFrom} are called.
165      */
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     /**
169      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * IMPORTANT: Beware that changing an allowance with this method brings the risk
174      * that someone may use both the old and the new allowance by unfortunate
175      * transaction ordering. One possible solution to mitigate this race
176      * condition is to first reduce the spender's allowance to 0 and set the
177      * desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      *
180      * Emits an {Approval} event.
181      */
182     function approve(address spender, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Moves `amount` tokens from `sender` to `recipient` using the
186      * allowance mechanism. `amount` is then deducted from the caller's
187      * allowance.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(
194         address sender,
195         address recipient,
196         uint256 amount
197     ) external returns (bool);
198 
199     /**
200      * @dev Emitted when `value` tokens are moved from one account (`from`) to
201      * another (`to`).
202      *
203      * Note that `value` may be zero.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 value);
206 
207     /**
208      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
209      * a call to {approve}. `value` is the new allowance.
210      */
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
215 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
216 
217 /* pragma solidity ^0.8.0; */
218 
219 /* import "../IERC20.sol"; */
220 
221 /**
222  * @dev Interface for the optional metadata functions from the ERC20 standard.
223  *
224  * _Available since v4.1._
225  */
226 interface IERC20Metadata is IERC20 {
227     /**
228      * @dev Returns the name of the token.
229      */
230     function name() external view returns (string memory);
231 
232     /**
233      * @dev Returns the symbol of the token.
234      */
235     function symbol() external view returns (string memory);
236 
237     /**
238      * @dev Returns the decimals places of the token.
239      */
240     function decimals() external view returns (uint8);
241 }
242 
243 /**
244  * @dev Implementation of the {IERC20} interface.
245  *
246  * This implementation is agnostic to the way tokens are created. This means
247  * that a supply mechanism has to be added in a derived contract using {_mint}.
248  * For a generic mechanism see {ERC20PresetMinterPauser}.
249  *
250  * TIP: For a detailed writeup see our guide
251  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
252  * to implement supply mechanisms].
253  *
254  * We have followed general OpenZeppelin Contracts guidelines: functions revert
255  * instead returning `false` on failure. This behavior is nonetheless
256  * conventional and does not conflict with the expectations of ERC20
257  * applications.
258  *
259  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See {IERC20-approve}.
267  */
268 contract ERC20 is Context, IERC20, IERC20Metadata {
269     mapping(address => uint256) private _balances;
270 
271     mapping(address => mapping(address => uint256)) private _allowances;
272 
273     uint256 private _totalSupply;
274 
275     string private _name;
276     string private _symbol;
277 
278     /**
279      * @dev Sets the values for {name} and {symbol}.
280      *
281      * The default value of {decimals} is 18. To select a different value for
282      * {decimals} you should overload it.
283      *
284      * All two of these values are immutable: they can only be set once during
285      * construction.
286      */
287     constructor(string memory name_, string memory symbol_) {
288         _name = name_;
289         _symbol = symbol_;
290     }
291 
292     /**
293      * @dev Returns the name of the token.
294      */
295     function name() public view virtual override returns (string memory) {
296         return _name;
297     }
298 
299     /**
300      * @dev Returns the symbol of the token, usually a shorter version of the
301      * name.
302      */
303     function symbol() public view virtual override returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308      * @dev Returns the number of decimals used to get its user representation.
309      * For example, if `decimals` equals `2`, a balance of `505` tokens should
310      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
311      *
312      * Tokens usually opt for a value of 18, imitating the relationship between
313      * Ether and Wei. This is the value {ERC20} uses, unless this function is
314      * overridden;
315      *
316      * NOTE: This information is only used for _display_ purposes: it in
317      * no way affects any of the arithmetic of the contract, including
318      * {IERC20-balanceOf} and {IERC20-transfer}.
319      */
320     function decimals() public view virtual override returns (uint8) {
321         return 18;
322     }
323 
324     /**
325      * @dev See {IERC20-totalSupply}.
326      */
327     function totalSupply() public view virtual override returns (uint256) {
328         return _totalSupply;
329     }
330 
331     /**
332      * @dev See {IERC20-balanceOf}.
333      */
334     function balanceOf(address account) public view virtual override returns (uint256) {
335         return _balances[account];
336     }
337 
338     /**
339      * @dev See {IERC20-transfer}.
340      *
341      * Requirements:
342      *
343      * - `recipient` cannot be the zero address.
344      * - the caller must have a balance of at least `amount`.
345      */
346     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
347         _transfer(_msgSender(), recipient, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-allowance}.
353      */
354     function allowance(address owner, address spender) public view virtual override returns (uint256) {
355         return _allowances[owner][spender];
356     }
357 
358     /**
359      * @dev See {IERC20-approve}.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      */
365     function approve(address spender, uint256 amount) public virtual override returns (bool) {
366         _approve(_msgSender(), spender, amount);
367         return true;
368     }
369 
370     /**
371      * @dev See {IERC20-transferFrom}.
372      *
373      * Emits an {Approval} event indicating the updated allowance. This is not
374      * required by the EIP. See the note at the beginning of {ERC20}.
375      *
376      * Requirements:
377      *
378      * - `sender` and `recipient` cannot be the zero address.
379      * - `sender` must have a balance of at least `amount`.
380      * - the caller must have allowance for ``sender``'s tokens of at least
381      * `amount`.
382      */
383     function transferFrom(
384         address sender,
385         address recipient,
386         uint256 amount
387     ) public virtual override returns (bool) {
388         _transfer(sender, recipient, amount);
389 
390         uint256 currentAllowance = _allowances[sender][_msgSender()];
391         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
392         unchecked {
393             _approve(sender, _msgSender(), currentAllowance - amount);
394         }
395 
396         return true;
397     }
398 
399     /**
400      * @dev Atomically increases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      */
411     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
412         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
413         return true;
414     }
415 
416     /**
417      * @dev Atomically decreases the allowance granted to `spender` by the caller.
418      *
419      * This is an alternative to {approve} that can be used as a mitigation for
420      * problems described in {IERC20-approve}.
421      *
422      * Emits an {Approval} event indicating the updated allowance.
423      *
424      * Requirements:
425      *
426      * - `spender` cannot be the zero address.
427      * - `spender` must have allowance for the caller of at least
428      * `subtractedValue`.
429      */
430     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
431         uint256 currentAllowance = _allowances[_msgSender()][spender];
432         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
433         unchecked {
434             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
435         }
436 
437         return true;
438     }
439 
440     /**
441      * @dev Moves `amount` of tokens from `sender` to `recipient`.
442      *
443      * This internal function is equivalent to {transfer}, and can be used to
444      * e.g. implement automatic token fees, slashing mechanisms, etc.
445      *
446      * Emits a {Transfer} event.
447      *
448      * Requirements:
449      *
450      * - `sender` cannot be the zero address.
451      * - `recipient` cannot be the zero address.
452      * - `sender` must have a balance of at least `amount`.
453      */
454     function _transfer(
455         address sender,
456         address recipient,
457         uint256 amount
458     ) internal virtual {
459         require(sender != address(0), "ERC20: transfer from the zero address");
460         require(recipient != address(0), "ERC20: transfer to the zero address");
461 
462         _beforeTokenTransfer(sender, recipient, amount);
463 
464         uint256 senderBalance = _balances[sender];
465         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
466         unchecked {
467             _balances[sender] = senderBalance - amount;
468         }
469         _balances[recipient] += amount;
470 
471         emit Transfer(sender, recipient, amount);
472 
473         _afterTokenTransfer(sender, recipient, amount);
474     }
475 
476     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
477      * the total supply.
478      *
479      * Emits a {Transfer} event with `from` set to the zero address.
480      *
481      * Requirements:
482      *
483      * - `account` cannot be the zero address.
484      */
485     function _mint(address account, uint256 amount) internal virtual {
486         require(account != address(0), "ERC20: mint to the zero address");
487 
488         _beforeTokenTransfer(address(0), account, amount);
489 
490         _totalSupply += amount;
491         _balances[account] += amount;
492         emit Transfer(address(0), account, amount);
493 
494         _afterTokenTransfer(address(0), account, amount);
495     }
496 
497     /**
498      * @dev Destroys `amount` tokens from `account`, reducing the
499      * total supply.
500      *
501      * Emits a {Transfer} event with `to` set to the zero address.
502      *
503      * Requirements:
504      *
505      * - `account` cannot be the zero address.
506      * - `account` must have at least `amount` tokens.
507      */
508     function _burn(address account, uint256 amount) internal virtual {
509         require(account != address(0), "ERC20: burn from the zero address");
510 
511         _beforeTokenTransfer(account, address(0), amount);
512 
513         uint256 accountBalance = _balances[account];
514         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
515         unchecked {
516             _balances[account] = accountBalance - amount;
517         }
518         _totalSupply -= amount;
519 
520         emit Transfer(account, address(0), amount);
521 
522         _afterTokenTransfer(account, address(0), amount);
523     }
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
527      *
528      * This internal function is equivalent to `approve`, and can be used to
529      * e.g. set automatic allowances for certain subsystems, etc.
530      *
531      * Emits an {Approval} event.
532      *
533      * Requirements:
534      *
535      * - `owner` cannot be the zero address.
536      * - `spender` cannot be the zero address.
537      */
538     function _approve(
539         address owner,
540         address spender,
541         uint256 amount
542     ) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Hook that is called before any transfer of tokens. This includes
552      * minting and burning.
553      *
554      * Calling conditions:
555      *
556      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
557      * will be transferred to `to`.
558      * - when `from` is zero, `amount` tokens will be minted for `to`.
559      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
560      * - `from` and `to` are never both zero.
561      *
562      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
563      */
564     function _beforeTokenTransfer(
565         address from,
566         address to,
567         uint256 amount
568     ) internal virtual {}
569 
570     /**
571      * @dev Hook that is called after any transfer of tokens. This includes
572      * minting and burning.
573      *
574      * Calling conditions:
575      *
576      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
577      * has been transferred to `to`.
578      * - when `from` is zero, `amount` tokens have been minted for `to`.
579      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
580      * - `from` and `to` are never both zero.
581      *
582      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
583      */
584     function _afterTokenTransfer(
585         address from,
586         address to,
587         uint256 amount
588     ) internal virtual {}
589 }
590 
591 /**
592  * @dev Wrappers over Solidity's arithmetic operations.
593  *
594  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
595  * now has built in overflow checking.
596  */
597 library SafeMath {
598     /**
599      * @dev Returns the addition of two unsigned integers, with an overflow flag.
600      *
601      * _Available since v3.4._
602      */
603     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         unchecked {
605             uint256 c = a + b;
606             if (c < a) return (false, 0);
607             return (true, c);
608         }
609     }
610 
611     /**
612      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
613      *
614      * _Available since v3.4._
615      */
616     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
617         unchecked {
618             if (b > a) return (false, 0);
619             return (true, a - b);
620         }
621     }
622 
623     /**
624      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
625      *
626      * _Available since v3.4._
627      */
628     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
629         unchecked {
630             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
631             // benefit is lost if 'b' is also tested.
632             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
633             if (a == 0) return (true, 0);
634             uint256 c = a * b;
635             if (c / a != b) return (false, 0);
636             return (true, c);
637         }
638     }
639 
640     /**
641      * @dev Returns the division of two unsigned integers, with a division by zero flag.
642      *
643      * _Available since v3.4._
644      */
645     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
646         unchecked {
647             if (b == 0) return (false, 0);
648             return (true, a / b);
649         }
650     }
651 
652     /**
653      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
654      *
655      * _Available since v3.4._
656      */
657     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
658         unchecked {
659             if (b == 0) return (false, 0);
660             return (true, a % b);
661         }
662     }
663 
664     /**
665      * @dev Returns the addition of two unsigned integers, reverting on
666      * overflow.
667      *
668      * Counterpart to Solidity's `+` operator.
669      *
670      * Requirements:
671      *
672      * - Addition cannot overflow.
673      */
674     function add(uint256 a, uint256 b) internal pure returns (uint256) {
675         return a + b;
676     }
677 
678     /**
679      * @dev Returns the subtraction of two unsigned integers, reverting on
680      * overflow (when the result is negative).
681      *
682      * Counterpart to Solidity's `-` operator.
683      *
684      * Requirements:
685      *
686      * - Subtraction cannot overflow.
687      */
688     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
689         return a - b;
690     }
691 
692     /**
693      * @dev Returns the multiplication of two unsigned integers, reverting on
694      * overflow.
695      *
696      * Counterpart to Solidity's `*` operator.
697      *
698      * Requirements:
699      *
700      * - Multiplication cannot overflow.
701      */
702     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
703         return a * b;
704     }
705 
706     /**
707      * @dev Returns the integer division of two unsigned integers, reverting on
708      * division by zero. The result is rounded towards zero.
709      *
710      * Counterpart to Solidity's `/` operator.
711      *
712      * Requirements:
713      *
714      * - The divisor cannot be zero.
715      */
716     function div(uint256 a, uint256 b) internal pure returns (uint256) {
717         return a / b;
718     }
719 
720     /**
721      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
722      * reverting when dividing by zero.
723      *
724      * Counterpart to Solidity's `%` operator. This function uses a `revert`
725      * opcode (which leaves remaining gas untouched) while Solidity uses an
726      * invalid opcode to revert (consuming all remaining gas).
727      *
728      * Requirements:
729      *
730      * - The divisor cannot be zero.
731      */
732     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
733         return a % b;
734     }
735 
736     /**
737      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
738      * overflow (when the result is negative).
739      *
740      * CAUTION: This function is deprecated because it requires allocating memory for the error
741      * message unnecessarily. For custom revert reasons use {trySub}.
742      *
743      * Counterpart to Solidity's `-` operator.
744      *
745      * Requirements:
746      *
747      * - Subtraction cannot overflow.
748      */
749     function sub(
750         uint256 a,
751         uint256 b,
752         string memory errorMessage
753     ) internal pure returns (uint256) {
754         unchecked {
755             require(b <= a, errorMessage);
756             return a - b;
757         }
758     }
759 
760     /**
761      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
762      * division by zero. The result is rounded towards zero.
763      *
764      * Counterpart to Solidity's `/` operator. Note: this function uses a
765      * `revert` opcode (which leaves remaining gas untouched) while Solidity
766      * uses an invalid opcode to revert (consuming all remaining gas).
767      *
768      * Requirements:
769      *
770      * - The divisor cannot be zero.
771      */
772     function div(
773         uint256 a,
774         uint256 b,
775         string memory errorMessage
776     ) internal pure returns (uint256) {
777         unchecked {
778             require(b > 0, errorMessage);
779             return a / b;
780         }
781     }
782 
783     /**
784      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
785      * reverting with custom message when dividing by zero.
786      *
787      * CAUTION: This function is deprecated because it requires allocating memory for the error
788      * message unnecessarily. For custom revert reasons use {tryMod}.
789      *
790      * Counterpart to Solidity's `%` operator. This function uses a `revert`
791      * opcode (which leaves remaining gas untouched) while Solidity uses an
792      * invalid opcode to revert (consuming all remaining gas).
793      *
794      * Requirements:
795      *
796      * - The divisor cannot be zero.
797      */
798     function mod(
799         uint256 a,
800         uint256 b,
801         string memory errorMessage
802     ) internal pure returns (uint256) {
803         unchecked {
804             require(b > 0, errorMessage);
805             return a % b;
806         }
807     }
808 }
809 
810 interface IUniswapV2Factory {
811     event PairCreated(
812         address indexed token0,
813         address indexed token1,
814         address pair,
815         uint256
816     );
817 
818     function feeTo() external view returns (address);
819 
820     function feeToSetter() external view returns (address);
821 
822     function getPair(address tokenA, address tokenB)
823         external
824         view
825         returns (address pair);
826 
827     function allPairs(uint256) external view returns (address pair);
828 
829     function allPairsLength() external view returns (uint256);
830 
831     function createPair(address tokenA, address tokenB)
832         external
833         returns (address pair);
834 
835     function setFeeTo(address) external;
836 
837     function setFeeToSetter(address) external;
838 }
839 
840 ////// src/IUniswapV2Pair.sol
841 /* pragma solidity 0.8.10; */
842 /* pragma experimental ABIEncoderV2; */
843 
844 interface IUniswapV2Pair {
845     event Approval(
846         address indexed owner,
847         address indexed spender,
848         uint256 value
849     );
850     event Transfer(address indexed from, address indexed to, uint256 value);
851 
852     function name() external pure returns (string memory);
853 
854     function symbol() external pure returns (string memory);
855 
856     function decimals() external pure returns (uint8);
857 
858     function totalSupply() external view returns (uint256);
859 
860     function balanceOf(address owner) external view returns (uint256);
861 
862     function allowance(address owner, address spender)
863         external
864         view
865         returns (uint256);
866 
867     function approve(address spender, uint256 value) external returns (bool);
868 
869     function transfer(address to, uint256 value) external returns (bool);
870 
871     function transferFrom(
872         address from,
873         address to,
874         uint256 value
875     ) external returns (bool);
876 
877     function DOMAIN_SEPARATOR() external view returns (bytes32);
878 
879     function PERMIT_TYPEHASH() external pure returns (bytes32);
880 
881     function nonces(address owner) external view returns (uint256);
882 
883     function permit(
884         address owner,
885         address spender,
886         uint256 value,
887         uint256 deadline,
888         uint8 v,
889         bytes32 r,
890         bytes32 s
891     ) external;
892 
893     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
894     event Burn(
895         address indexed sender,
896         uint256 amount0,
897         uint256 amount1,
898         address indexed to
899     );
900     event Swap(
901         address indexed sender,
902         uint256 amount0In,
903         uint256 amount1In,
904         uint256 amount0Out,
905         uint256 amount1Out,
906         address indexed to
907     );
908     event Sync(uint112 reserve0, uint112 reserve1);
909 
910     function MINIMUM_LIQUIDITY() external pure returns (uint256);
911 
912     function factory() external view returns (address);
913 
914     function token0() external view returns (address);
915 
916     function token1() external view returns (address);
917 
918     function getReserves()
919         external
920         view
921         returns (
922             uint112 reserve0,
923             uint112 reserve1,
924             uint32 blockTimestampLast
925         );
926 
927     function price0CumulativeLast() external view returns (uint256);
928 
929     function price1CumulativeLast() external view returns (uint256);
930 
931     function kLast() external view returns (uint256);
932 
933     function mint(address to) external returns (uint256 liquidity);
934 
935     function burn(address to)
936         external
937         returns (uint256 amount0, uint256 amount1);
938 
939     function swap(
940         uint256 amount0Out,
941         uint256 amount1Out,
942         address to,
943         bytes calldata data
944     ) external;
945 
946     function skim(address to) external;
947 
948     function sync() external;
949 
950     function initialize(address, address) external;
951 }
952 
953 interface IUniswapV2Router02 {
954     function factory() external pure returns (address);
955 
956     function WETH() external pure returns (address);
957 
958     function addLiquidity(
959         address tokenA,
960         address tokenB,
961         uint256 amountADesired,
962         uint256 amountBDesired,
963         uint256 amountAMin,
964         uint256 amountBMin,
965         address to,
966         uint256 deadline
967     )
968         external
969         returns (
970             uint256 amountA,
971             uint256 amountB,
972             uint256 liquidity
973         );
974 
975     function addLiquidityETH(
976         address token,
977         uint256 amountTokenDesired,
978         uint256 amountTokenMin,
979         uint256 amountETHMin,
980         address to,
981         uint256 deadline
982     )
983         external
984         payable
985         returns (
986             uint256 amountToken,
987             uint256 amountETH,
988             uint256 liquidity
989         );
990 
991     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
992         uint256 amountIn,
993         uint256 amountOutMin,
994         address[] calldata path,
995         address to,
996         uint256 deadline
997     ) external;
998 
999     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1000         uint256 amountOutMin,
1001         address[] calldata path,
1002         address to,
1003         uint256 deadline
1004     ) external payable;
1005 
1006     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1007         uint256 amountIn,
1008         uint256 amountOutMin,
1009         address[] calldata path,
1010         address to,
1011         uint256 deadline
1012     ) external;
1013 }
1014 
1015 contract OneProtocol is ERC20, Ownable {
1016 
1017     IUniswapV2Router02 public immutable uniswapV2Router;
1018     address public immutable uniswapV2Pair;
1019     bool private swapping;
1020 
1021     address public immutable revShareWallet;
1022 
1023     uint256 public maxTransactionAmount;
1024     uint256 immutable public swapTokensAtAmount;
1025     uint256 public maxWallet;
1026 
1027     bool public tradingActive = false;
1028     bool public swapEnabled = true;
1029 
1030     // Anti-bot and anti-whale mappings and variables
1031     mapping(address => bool) blacklisted;
1032 
1033     uint256 public buyTotalFees;
1034     uint256 public buyRevShareFee;
1035     uint256 public buyLiquidityFee;
1036 
1037     uint256 public sellTotalFees;
1038     uint256 public sellRevShareFee;
1039     uint256 public sellLiquidityFee;
1040 
1041     uint256 public tokensForRevShare;
1042     uint256 public tokensForLiquidity;
1043 
1044     // Exclude from fees and max transaction amount
1045     mapping(address => bool) private _isExcludedFromFees;
1046     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1047 
1048     // Store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1049     // could be subject to a maximum transfer amount
1050     mapping(address => bool) public automatedMarketMakerPairs;
1051 
1052     event UpdateUniswapV2Router(
1053         address indexed newAddress,
1054         address indexed oldAddress
1055     );
1056 
1057     event ExcludeFromFees(address indexed account, bool isExcluded);
1058 
1059     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1060 
1061     event SwapAndLiquify(
1062         uint256 tokensSwapped,
1063         uint256 ethReceived,
1064         uint256 tokensIntoLiquidity
1065     );
1066 
1067     constructor() ERC20("One Protocol", "$ONE") {
1068         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1069             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D //Uniswap V2 Router
1070         );
1071 
1072         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1073         uniswapV2Router = _uniswapV2Router;
1074 
1075         // Creates the Uniswap Pair
1076         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1077             .createPair(address(this), _uniswapV2Router.WETH());
1078         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1079         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1080 
1081         uint256 _buyRevShareFee = 6; // Lowered to 4% after launch
1082         uint256 _buyLiquidityFee = 4; // Lowered to 1% after launch
1083 
1084         uint256 _sellRevShareFee = 6; // Lowered to 4% after launch
1085         uint256 _sellLiquidityFee = 4; // Lowered to 1% after launch
1086 
1087         uint256 totalSupply = 1_000_000 * 1e18; // 1 million
1088 
1089         maxTransactionAmount = 2500 * 1e18; // 0.25%
1090         maxWallet = 2500 * 1e18; // 0.25% 
1091         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% 
1092 
1093         buyRevShareFee = _buyRevShareFee;
1094         buyLiquidityFee = _buyLiquidityFee;
1095         buyTotalFees = buyRevShareFee + buyLiquidityFee;
1096 
1097         sellRevShareFee = _sellRevShareFee;
1098         sellLiquidityFee = _sellLiquidityFee;
1099         sellTotalFees = sellRevShareFee + sellLiquidityFee;
1100 
1101         revShareWallet = address(0x78DA7b1b58835D4EB7F37a4ff876fD688dca05F7); // Set as revShare wallet - Helper Contract
1102 
1103         // Exclude from paying fees or having max transaction amount if; is owner, is deployer, is dead address. 
1104         excludeFromFees(owner(), true);
1105         excludeFromFees(address(this), true);
1106         excludeFromFees(address(0xdead), true);
1107 
1108         excludeFromMaxTransaction(owner(), true);
1109         excludeFromMaxTransaction(address(this), true);
1110         excludeFromMaxTransaction(address(0xdead), true);
1111 
1112         /*
1113             _mint is an internal function in ERC20.sol that is only called here,
1114             and CANNOT be called ever again
1115         */
1116         _mint(msg.sender, totalSupply);
1117     }
1118 
1119     receive() external payable {}
1120 
1121     // Will enable trading, once this is toggeled, it will not be able to be turned off.
1122     function enableTrading() external onlyOwner {
1123         tradingActive = true;
1124         swapEnabled = true;
1125     }
1126 
1127     // Trigger this post launch once price is more stable. Made to avoid whales and snipers hogging supply.
1128     function updateLimitsAndFees() external onlyOwner {
1129         maxTransactionAmount = 20_000 * (10**18); // 2%
1130         maxWallet = 20_000 * (10**18); // 2%
1131     
1132         buyRevShareFee = 4; // 4%
1133         buyLiquidityFee = 1; // 1%
1134         buyTotalFees = 5;
1135 
1136         sellRevShareFee = 4; // 4%
1137         sellLiquidityFee = 1; // 1%
1138         sellTotalFees = 5;
1139     }
1140 
1141     function excludeFromMaxTransaction(address updAds, bool isEx)
1142         public
1143         onlyOwner
1144     {
1145         _isExcludedMaxTransactionAmount[updAds] = isEx;
1146     }
1147 
1148     function excludeFromFees(address account, bool excluded) public onlyOwner {
1149         _isExcludedFromFees[account] = excluded;
1150         emit ExcludeFromFees(account, excluded);
1151     }
1152 
1153     function setAutomatedMarketMakerPair(address pair, bool value)
1154         public
1155         onlyOwner
1156     {
1157         require(
1158             pair != uniswapV2Pair,
1159             "The pair cannot be removed from automatedMarketMakerPairs"
1160         );
1161 
1162         _setAutomatedMarketMakerPair(pair, value);
1163     }
1164 
1165     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1166         automatedMarketMakerPairs[pair] = value;
1167 
1168         emit SetAutomatedMarketMakerPair(pair, value);
1169     }
1170 
1171     function isExcludedFromFees(address account) public view returns (bool) {
1172         return _isExcludedFromFees[account];
1173     }
1174 
1175     function isBlacklisted(address account) public view returns (bool) {
1176         return blacklisted[account];
1177     }
1178 
1179     function _transfer(
1180         address from,
1181         address to,
1182         uint256 amount
1183     ) internal override {
1184         require(from != address(0), "ERC20: transfer from the zero address");
1185         require(to != address(0), "ERC20: transfer to the zero address");
1186         require(!blacklisted[from],"Sender blacklisted");
1187         require(!blacklisted[to],"Receiver blacklisted");
1188 
1189         if (amount == 0) {
1190             super._transfer(from, to, 0);
1191             return;
1192         }
1193 
1194         if (
1195                 from != owner() &&
1196                 to != owner() &&
1197                 to != address(0) &&
1198                 to != address(0xdead) &&
1199                 !swapping
1200             ) {
1201                 if (!tradingActive) {
1202                     require(
1203                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1204                         "Trading is not active."
1205                     );
1206                 }
1207 
1208                 // Buying
1209                 if (
1210                     automatedMarketMakerPairs[from] &&
1211                     !_isExcludedMaxTransactionAmount[to]
1212                 ) {
1213                     require(
1214                         amount <= maxTransactionAmount,
1215                         "Buy transfer amount exceeds the maxTransactionAmount."
1216                     );
1217                     require(
1218                         amount + balanceOf(to) <= maxWallet,
1219                         "Max wallet exceeded"
1220                     );
1221                 }
1222                 // Selling
1223                 else if (
1224                     automatedMarketMakerPairs[to] &&
1225                     !_isExcludedMaxTransactionAmount[from]
1226                 ) {
1227                     require(
1228                         amount <= maxTransactionAmount,
1229                         "Sell transfer amount exceeds the maxTransactionAmount."
1230                     );
1231                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1232                     require(
1233                         amount + balanceOf(to) <= maxWallet,
1234                         "Max wallet exceeded"
1235                     );
1236                 }
1237         }
1238 
1239         uint256 contractTokenBalance = balanceOf(address(this));
1240 
1241         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1242 
1243         if (
1244             canSwap &&
1245             swapEnabled &&
1246             !swapping &&
1247             !automatedMarketMakerPairs[from] &&
1248             !_isExcludedFromFees[from] &&
1249             !_isExcludedFromFees[to]
1250         ) {
1251             swapping = true;
1252 
1253             swapBack();
1254 
1255             swapping = false;
1256         }
1257 
1258         bool takeFee = !swapping;
1259 
1260         // If any account belongs to _isExcludedFromFee account then remove the fee
1261         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1262             takeFee = false;
1263         }
1264 
1265         uint256 fees = 0;
1266         // Only take fees on buys/sells, do not take on wallet transfers
1267         if (takeFee) {
1268             // Sell
1269             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1270                 fees = (amount * sellTotalFees) / 100;
1271                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1272                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1273             }
1274             // Buy
1275             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1276                 fees = (amount * buyTotalFees) / 100;
1277                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1278                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1279             }
1280 
1281             if (fees > 0) {
1282                 super._transfer(from, address(this), fees);
1283             }
1284 
1285             amount -= fees;
1286         }
1287 
1288         super._transfer(from, to, amount);
1289     }
1290 
1291     function swapTokensForEth(uint256 tokenAmount) private {
1292         // Generate the uniswap pair path of token -> weth
1293         address[] memory path = new address[](2);
1294         path[0] = address(this);
1295         path[1] = uniswapV2Router.WETH();
1296 
1297         _approve(address(this), address(uniswapV2Router), tokenAmount);
1298 
1299         // Make the swap
1300         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1301             tokenAmount,
1302             0, // Accept any amount of ETH; ignore slippage
1303             path,
1304             address(this),
1305             block.timestamp
1306         );
1307     }
1308 
1309     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1310         // approve token transfer to cover all possible scenarios
1311         _approve(address(this), address(uniswapV2Router), tokenAmount);
1312 
1313         // add the liquidity
1314         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1315             address(this),
1316             tokenAmount,
1317             0, // Slippage is unavoidable
1318             0, // Slippage is unavoidable
1319             owner(),
1320             block.timestamp
1321         );
1322     }
1323 
1324     function swapBack() private {
1325         uint256 contractBalance = balanceOf(address(this));
1326         uint256 totalTokensToSwap = tokensForLiquidity +
1327             tokensForRevShare;
1328         bool success;
1329 
1330         if (contractBalance == 0 || totalTokensToSwap == 0) {
1331             return;
1332         }
1333 
1334         if (contractBalance > swapTokensAtAmount * 20) {
1335             contractBalance = swapTokensAtAmount * 20;
1336         }
1337 
1338         // Halve the amount of liquidity tokens
1339         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1340             totalTokensToSwap /
1341             2;
1342         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1343 
1344         uint256 initialETHBalance = address(this).balance;
1345 
1346         swapTokensForEth(amountToSwapForETH);
1347 
1348         uint256 ethBalance = address(this).balance - initialETHBalance;
1349 
1350         uint256 ethForRevShare = (ethBalance * tokensForRevShare) / (totalTokensToSwap - (tokensForLiquidity / 2));
1351         
1352         uint256 ethForLiquidity = ethBalance - ethForRevShare;
1353 
1354         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1355             addLiquidity(liquidityTokens, ethForLiquidity);
1356             emit SwapAndLiquify(
1357                 amountToSwapForETH,
1358                 ethForLiquidity,
1359                 tokensForLiquidity
1360             );
1361         }
1362 
1363         tokensForLiquidity = 0;
1364         tokensForRevShare = 0;
1365 
1366         (success, ) = address(revShareWallet).call{value: address(this).balance}("");
1367     }
1368         
1369     // The helper contract will also be used to be able to call the 5 functions below. 
1370     // Any functions that have to do with ETH or Tokens will be sent directly to the helper contract. 
1371     // This means that the split of 80% to the team, and 20% to the holders is intact.
1372     modifier onlyHelper() {
1373         require(revShareWallet == _msgSender(), "Token: caller is not the Helper");
1374         _;
1375     }
1376 
1377     // @Helper - Callable by Helper contract in-case tokens get's stuck in the token contract.
1378     function withdrawStuckToken(address _token, address _to) external onlyHelper {
1379         require(_token != address(0), "_token address cannot be 0");
1380         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1381         IERC20(_token).transfer(_to, _contractBalance);
1382     }
1383 
1384     // @Helper - Callable by Helper contract in-case ETH get's stuck in the token contract.
1385     function withdrawStuckEth(address toAddr) external onlyHelper {
1386         (bool success, ) = toAddr.call{
1387             value: address(this).balance
1388         } ("");
1389         require(success);
1390     }
1391 
1392     // @Helper - Blacklist v3 pools; can unblacklist() down the road to suit project and community
1393     function blacklistLiquidityPool(address lpAddress) public onlyHelper {
1394         require(
1395             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1396             "Cannot blacklist token's v2 router or v2 pool."
1397         );
1398         blacklisted[lpAddress] = true;
1399     }
1400 
1401     // @Helper - Unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1402     function unblacklist(address _addr) public onlyHelper {
1403         blacklisted[_addr] = false;
1404     }
1405 
1406 }