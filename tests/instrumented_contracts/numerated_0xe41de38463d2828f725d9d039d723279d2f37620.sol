1 /* 
2                                                                                         
3     _|_|_|_|_|                            _|            _|    _|  _|                        
4         _|      _|  _|_|    _|_|_|    _|_|_|    _|_|    _|    _|      _|      _|    _|_|    
5         _|      _|_|      _|    _|  _|    _|  _|_|_|_|  _|_|_|_|  _|  _|      _|  _|_|_|_|  
6         _|      _|        _|    _|  _|    _|  _|        _|    _|  _|    _|  _|    _|        
7         _|      _|          _|_|_|    _|_|_|    _|_|_|  _|    _|  _|      _|        _|_|_|  
8                                                                                                                                                                                 
9     TradeHive : Where Innovation Meets Blockchain.
10     Advanced technology and user-friendly interface for modern traders with AI-powered 
11     trading assistant, virtual reality trading, social trading, and NFT marketplace.
12  
13     Telegram: https://t.me/TradeHive
14     Website: https://tradehive.app
15  
16     Total Supply: 1 Billion Tokens
17     Max Transaction: 20 Million Tokens
18     Max Wallet: 20 Million Tokens
19     Set slippage to 5-6%: 1% to LP, 4% Tax for Marketing & Platform Development.
20 
21 */
22 
23 
24 // SPDX-License-Identifier: MIT
25 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
26 pragma experimental ABIEncoderV2;
27 
28 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
29 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
30 
31 /* pragma solidity ^0.8.0; */
32 
33 /**
34  * @dev Provides information about the current execution context, including the
35  * sender of the transaction and its data. While these are generally available
36  * via msg.sender and msg.data, they should not be accessed in such a direct
37  * manner, since when dealing with meta-transactions the account sending and
38  * paying for execution may not be the actual sender (as far as an application
39  * is concerned).
40  *
41  * This contract is only required for intermediate, library-like contracts.
42  */
43 
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes calldata) {
50         return msg.data;
51     }
52 }
53 
54 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
55 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
56 
57 /* pragma solidity ^0.8.0; */
58 
59 /* import "../utils/Context.sol"; */
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
243 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
244 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
245 
246 /* pragma solidity ^0.8.0; */
247 
248 /* import "./IERC20.sol"; */
249 /* import "./extensions/IERC20Metadata.sol"; */
250 /* import "../../utils/Context.sol"; */
251 
252 /**
253  * @dev Implementation of the {IERC20} interface.
254  *
255  * This implementation is agnostic to the way tokens are created. This means
256  * that a supply mechanism has to be added in a derived contract using {_mint}.
257  * For a generic mechanism see {ERC20PresetMinterPauser}.
258  *
259  * TIP: For a detailed writeup see our guide
260  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
261  * to implement supply mechanisms].
262  *
263  * We have followed general OpenZeppelin Contracts guidelines: functions revert
264  * instead returning `false` on failure. This behavior is nonetheless
265  * conventional and does not conflict with the expectations of ERC20
266  * applications.
267  *
268  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
269  * This allows applications to reconstruct the allowance for all accounts just
270  * by listening to said events. Other implementations of the EIP may not emit
271  * these events, as it isn't required by the specification.
272  *
273  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
274  * functions have been added to mitigate the well-known issues around setting
275  * allowances. See {IERC20-approve}.
276  */
277 contract ERC20 is Context, IERC20, IERC20Metadata {
278     mapping(address => uint256) private _balances;
279 
280     mapping(address => mapping(address => uint256)) private _allowances;
281 
282     uint256 private _totalSupply;
283 
284     string private _name;
285     string private _symbol;
286 
287     /**
288      * @dev Sets the values for {name} and {symbol}.
289      *
290      * The default value of {decimals} is 18. To select a different value for
291      * {decimals} you should overload it.
292      *
293      * All two of these values are immutable: they can only be set once during
294      * construction.
295      */
296     constructor(string memory name_, string memory symbol_) {
297         _name = name_;
298         _symbol = symbol_;
299     }
300 
301     /**
302      * @dev Returns the name of the token.
303      */
304     function name() public view virtual override returns (string memory) {
305         return _name;
306     }
307 
308     /**
309      * @dev Returns the symbol of the token, usually a shorter version of the
310      * name.
311      */
312     function symbol() public view virtual override returns (string memory) {
313         return _symbol;
314     }
315 
316     /**
317      * @dev Returns the number of decimals used to get its user representation.
318      * For example, if `decimals` equals `2`, a balance of `505` tokens should
319      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
320      *
321      * Tokens usually opt for a value of 18, imitating the relationship between
322      * Ether and Wei. This is the value {ERC20} uses, unless this function is
323      * overridden;
324      *
325      * NOTE: This information is only used for _display_ purposes: it in
326      * no way affects any of the arithmetic of the contract, including
327      * {IERC20-balanceOf} and {IERC20-transfer}.
328      */
329     function decimals() public view virtual override returns (uint8) {
330         return 18;
331     }
332 
333     /**
334      * @dev See {IERC20-totalSupply}.
335      */
336     function totalSupply() public view virtual override returns (uint256) {
337         return _totalSupply;
338     }
339 
340     /**
341      * @dev See {IERC20-balanceOf}.
342      */
343     function balanceOf(address account) public view virtual override returns (uint256) {
344         return _balances[account];
345     }
346 
347     /**
348      * @dev See {IERC20-transfer}.
349      *
350      * Requirements:
351      *
352      * - `recipient` cannot be the zero address.
353      * - the caller must have a balance of at least `amount`.
354      */
355     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
356         _transfer(_msgSender(), recipient, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-allowance}.
362      */
363     function allowance(address owner, address spender) public view virtual override returns (uint256) {
364         return _allowances[owner][spender];
365     }
366 
367     /**
368      * @dev See {IERC20-approve}.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function approve(address spender, uint256 amount) public virtual override returns (bool) {
375         _approve(_msgSender(), spender, amount);
376         return true;
377     }
378 
379     /**
380      * @dev See {IERC20-transferFrom}.
381      *
382      * Emits an {Approval} event indicating the updated allowance. This is not
383      * required by the EIP. See the note at the beginning of {ERC20}.
384      *
385      * Requirements:
386      *
387      * - `sender` and `recipient` cannot be the zero address.
388      * - `sender` must have a balance of at least `amount`.
389      * - the caller must have allowance for ``sender``'s tokens of at least
390      * `amount`.
391      */
392     function transferFrom(
393         address sender,
394         address recipient,
395         uint256 amount
396     ) public virtual override returns (bool) {
397         _transfer(sender, recipient, amount);
398 
399         uint256 currentAllowance = _allowances[sender][_msgSender()];
400         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
401         unchecked {
402             _approve(sender, _msgSender(), currentAllowance - amount);
403         }
404 
405         return true;
406     }
407 
408     /**
409      * @dev Atomically increases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      */
420     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
421         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
422         return true;
423     }
424 
425     /**
426      * @dev Atomically decreases the allowance granted to `spender` by the caller.
427      *
428      * This is an alternative to {approve} that can be used as a mitigation for
429      * problems described in {IERC20-approve}.
430      *
431      * Emits an {Approval} event indicating the updated allowance.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      * - `spender` must have allowance for the caller of at least
437      * `subtractedValue`.
438      */
439     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
440         uint256 currentAllowance = _allowances[_msgSender()][spender];
441         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
442         unchecked {
443             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
444         }
445 
446         return true;
447     }
448 
449     /**
450      * @dev Moves `amount` of tokens from `sender` to `recipient`.
451      *
452      * This internal function is equivalent to {transfer}, and can be used to
453      * e.g. implement automatic token fees, slashing mechanisms, etc.
454      *
455      * Emits a {Transfer} event.
456      *
457      * Requirements:
458      *
459      * - `sender` cannot be the zero address.
460      * - `recipient` cannot be the zero address.
461      * - `sender` must have a balance of at least `amount`.
462      */
463     function _transfer(
464         address sender,
465         address recipient,
466         uint256 amount
467     ) internal virtual {
468         require(sender != address(0), "ERC20: transfer from the zero address");
469         require(recipient != address(0), "ERC20: transfer to the zero address");
470 
471         _beforeTokenTransfer(sender, recipient, amount);
472 
473         uint256 senderBalance = _balances[sender];
474         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
475         unchecked {
476             _balances[sender] = senderBalance - amount;
477         }
478         _balances[recipient] += amount;
479 
480         emit Transfer(sender, recipient, amount);
481 
482         _afterTokenTransfer(sender, recipient, amount);
483     }
484 
485     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
486      * the total supply.
487      *
488      * Emits a {Transfer} event with `from` set to the zero address.
489      *
490      * Requirements:
491      *
492      * - `account` cannot be the zero address.
493      */
494     function _mint(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: mint to the zero address");
496 
497         _beforeTokenTransfer(address(0), account, amount);
498 
499         _totalSupply += amount;
500         _balances[account] += amount;
501         emit Transfer(address(0), account, amount);
502 
503         _afterTokenTransfer(address(0), account, amount);
504     }
505 
506     /**
507      * @dev Destroys `amount` tokens from `account`, reducing the
508      * total supply.
509      *
510      * Emits a {Transfer} event with `to` set to the zero address.
511      *
512      * Requirements:
513      *
514      * - `account` cannot be the zero address.
515      * - `account` must have at least `amount` tokens.
516      */
517     function _burn(address account, uint256 amount) internal virtual {
518         require(account != address(0), "ERC20: burn from the zero address");
519 
520         _beforeTokenTransfer(account, address(0), amount);
521 
522         uint256 accountBalance = _balances[account];
523         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
524         unchecked {
525             _balances[account] = accountBalance - amount;
526         }
527         _totalSupply -= amount;
528 
529         emit Transfer(account, address(0), amount);
530 
531         _afterTokenTransfer(account, address(0), amount);
532     }
533 
534     /**
535      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
536      *
537      * This internal function is equivalent to `approve`, and can be used to
538      * e.g. set automatic allowances for certain subsystems, etc.
539      *
540      * Emits an {Approval} event.
541      *
542      * Requirements:
543      *
544      * - `owner` cannot be the zero address.
545      * - `spender` cannot be the zero address.
546      */
547     function _approve(
548         address owner,
549         address spender,
550         uint256 amount
551     ) internal virtual {
552         require(owner != address(0), "ERC20: approve from the zero address");
553         require(spender != address(0), "ERC20: approve to the zero address");
554 
555         _allowances[owner][spender] = amount;
556         emit Approval(owner, spender, amount);
557     }
558 
559     /**
560      * @dev Hook that is called before any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * will be transferred to `to`.
567      * - when `from` is zero, `amount` tokens will be minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _beforeTokenTransfer(
574         address from,
575         address to,
576         uint256 amount
577     ) internal virtual {}
578 
579     /**
580      * @dev Hook that is called after any transfer of tokens. This includes
581      * minting and burning.
582      *
583      * Calling conditions:
584      *
585      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
586      * has been transferred to `to`.
587      * - when `from` is zero, `amount` tokens have been minted for `to`.
588      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
589      * - `from` and `to` are never both zero.
590      *
591      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
592      */
593     function _afterTokenTransfer(
594         address from,
595         address to,
596         uint256 amount
597     ) internal virtual {}
598 }
599 
600 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
601 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
602 
603 /* pragma solidity ^0.8.0; */
604 
605 // CAUTION
606 // This version of SafeMath should only be used with Solidity 0.8 or later,
607 // because it relies on the compiler's built in overflow checks.
608 
609 /**
610  * @dev Wrappers over Solidity's arithmetic operations.
611  *
612  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
613  * now has built in overflow checking.
614  */
615 library SafeMath {
616     /**
617      * @dev Returns the addition of two unsigned integers, with an overflow flag.
618      *
619      * _Available since v3.4._
620      */
621     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
622         unchecked {
623             uint256 c = a + b;
624             if (c < a) return (false, 0);
625             return (true, c);
626         }
627     }
628 
629     /**
630      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
631      *
632      * _Available since v3.4._
633      */
634     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
635         unchecked {
636             if (b > a) return (false, 0);
637             return (true, a - b);
638         }
639     }
640 
641     /**
642      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
643      *
644      * _Available since v3.4._
645      */
646     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
647         unchecked {
648             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
649             // benefit is lost if 'b' is also tested.
650             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
651             if (a == 0) return (true, 0);
652             uint256 c = a * b;
653             if (c / a != b) return (false, 0);
654             return (true, c);
655         }
656     }
657 
658     /**
659      * @dev Returns the division of two unsigned integers, with a division by zero flag.
660      *
661      * _Available since v3.4._
662      */
663     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
664         unchecked {
665             if (b == 0) return (false, 0);
666             return (true, a / b);
667         }
668     }
669 
670     /**
671      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
672      *
673      * _Available since v3.4._
674      */
675     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
676         unchecked {
677             if (b == 0) return (false, 0);
678             return (true, a % b);
679         }
680     }
681 
682     /**
683      * @dev Returns the addition of two unsigned integers, reverting on
684      * overflow.
685      *
686      * Counterpart to Solidity's `+` operator.
687      *
688      * Requirements:
689      *
690      * - Addition cannot overflow.
691      */
692     function add(uint256 a, uint256 b) internal pure returns (uint256) {
693         return a + b;
694     }
695 
696     /**
697      * @dev Returns the subtraction of two unsigned integers, reverting on
698      * overflow (when the result is negative).
699      *
700      * Counterpart to Solidity's `-` operator.
701      *
702      * Requirements:
703      *
704      * - Subtraction cannot overflow.
705      */
706     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a - b;
708     }
709 
710     /**
711      * @dev Returns the multiplication of two unsigned integers, reverting on
712      * overflow.
713      *
714      * Counterpart to Solidity's `*` operator.
715      *
716      * Requirements:
717      *
718      * - Multiplication cannot overflow.
719      */
720     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
721         return a * b;
722     }
723 
724     /**
725      * @dev Returns the integer division of two unsigned integers, reverting on
726      * division by zero. The result is rounded towards zero.
727      *
728      * Counterpart to Solidity's `/` operator.
729      *
730      * Requirements:
731      *
732      * - The divisor cannot be zero.
733      */
734     function div(uint256 a, uint256 b) internal pure returns (uint256) {
735         return a / b;
736     }
737 
738     /**
739      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
740      * reverting when dividing by zero.
741      *
742      * Counterpart to Solidity's `%` operator. This function uses a `revert`
743      * opcode (which leaves remaining gas untouched) while Solidity uses an
744      * invalid opcode to revert (consuming all remaining gas).
745      *
746      * Requirements:
747      *
748      * - The divisor cannot be zero.
749      */
750     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
751         return a % b;
752     }
753 
754     /**
755      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
756      * overflow (when the result is negative).
757      *
758      * CAUTION: This function is deprecated because it requires allocating memory for the error
759      * message unnecessarily. For custom revert reasons use {trySub}.
760      *
761      * Counterpart to Solidity's `-` operator.
762      *
763      * Requirements:
764      *
765      * - Subtraction cannot overflow.
766      */
767     function sub(
768         uint256 a,
769         uint256 b,
770         string memory errorMessage
771     ) internal pure returns (uint256) {
772         unchecked {
773             require(b <= a, errorMessage);
774             return a - b;
775         }
776     }
777 
778     /**
779      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
780      * division by zero. The result is rounded towards zero.
781      *
782      * Counterpart to Solidity's `/` operator. Note: this function uses a
783      * `revert` opcode (which leaves remaining gas untouched) while Solidity
784      * uses an invalid opcode to revert (consuming all remaining gas).
785      *
786      * Requirements:
787      *
788      * - The divisor cannot be zero.
789      */
790     function div(
791         uint256 a,
792         uint256 b,
793         string memory errorMessage
794     ) internal pure returns (uint256) {
795         unchecked {
796             require(b > 0, errorMessage);
797             return a / b;
798         }
799     }
800 
801     /**
802      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
803      * reverting with custom message when dividing by zero.
804      *
805      * CAUTION: This function is deprecated because it requires allocating memory for the error
806      * message unnecessarily. For custom revert reasons use {tryMod}.
807      *
808      * Counterpart to Solidity's `%` operator. This function uses a `revert`
809      * opcode (which leaves remaining gas untouched) while Solidity uses an
810      * invalid opcode to revert (consuming all remaining gas).
811      *
812      * Requirements:
813      *
814      * - The divisor cannot be zero.
815      */
816     function mod(
817         uint256 a,
818         uint256 b,
819         string memory errorMessage
820     ) internal pure returns (uint256) {
821         unchecked {
822             require(b > 0, errorMessage);
823             return a % b;
824         }
825     }
826 }
827 
828 ////// src/IUniswapV2Factory.sol
829 /* pragma solidity 0.8.10; */
830 /* pragma experimental ABIEncoderV2; */
831 
832 interface IUniswapV2Factory {
833     event PairCreated(
834         address indexed token0,
835         address indexed token1,
836         address pair,
837         uint256
838     );
839 
840     function feeTo() external view returns (address);
841 
842     function feeToSetter() external view returns (address);
843 
844     function getPair(address tokenA, address tokenB)
845         external
846         view
847         returns (address pair);
848 
849     function allPairs(uint256) external view returns (address pair);
850 
851     function allPairsLength() external view returns (uint256);
852 
853     function createPair(address tokenA, address tokenB)
854         external
855         returns (address pair);
856 
857     function setFeeTo(address) external;
858 
859     function setFeeToSetter(address) external;
860 }
861 
862 ////// src/IUniswapV2Pair.sol
863 /* pragma solidity 0.8.10; */
864 /* pragma experimental ABIEncoderV2; */
865 
866 interface IUniswapV2Pair {
867     event Approval(
868         address indexed owner,
869         address indexed spender,
870         uint256 value
871     );
872     event Transfer(address indexed from, address indexed to, uint256 value);
873 
874     function name() external pure returns (string memory);
875 
876     function symbol() external pure returns (string memory);
877 
878     function decimals() external pure returns (uint8);
879 
880     function totalSupply() external view returns (uint256);
881 
882     function balanceOf(address owner) external view returns (uint256);
883 
884     function allowance(address owner, address spender)
885         external
886         view
887         returns (uint256);
888 
889     function approve(address spender, uint256 value) external returns (bool);
890 
891     function transfer(address to, uint256 value) external returns (bool);
892 
893     function transferFrom(
894         address from,
895         address to,
896         uint256 value
897     ) external returns (bool);
898 
899     function DOMAIN_SEPARATOR() external view returns (bytes32);
900 
901     function PERMIT_TYPEHASH() external pure returns (bytes32);
902 
903     function nonces(address owner) external view returns (uint256);
904 
905     function permit(
906         address owner,
907         address spender,
908         uint256 value,
909         uint256 deadline,
910         uint8 v,
911         bytes32 r,
912         bytes32 s
913     ) external;
914 
915     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
916     event Burn(
917         address indexed sender,
918         uint256 amount0,
919         uint256 amount1,
920         address indexed to
921     );
922     event Swap(
923         address indexed sender,
924         uint256 amount0In,
925         uint256 amount1In,
926         uint256 amount0Out,
927         uint256 amount1Out,
928         address indexed to
929     );
930     event Sync(uint112 reserve0, uint112 reserve1);
931 
932     function MINIMUM_LIQUIDITY() external pure returns (uint256);
933 
934     function factory() external view returns (address);
935 
936     function token0() external view returns (address);
937 
938     function token1() external view returns (address);
939 
940     function getReserves()
941         external
942         view
943         returns (
944             uint112 reserve0,
945             uint112 reserve1,
946             uint32 blockTimestampLast
947         );
948 
949     function price0CumulativeLast() external view returns (uint256);
950 
951     function price1CumulativeLast() external view returns (uint256);
952 
953     function kLast() external view returns (uint256);
954 
955     function mint(address to) external returns (uint256 liquidity);
956 
957     function burn(address to)
958         external
959         returns (uint256 amount0, uint256 amount1);
960 
961     function swap(
962         uint256 amount0Out,
963         uint256 amount1Out,
964         address to,
965         bytes calldata data
966     ) external;
967 
968     function skim(address to) external;
969 
970     function sync() external;
971 
972     function initialize(address, address) external;
973 }
974 
975 ////// src/IUniswapV2Router02.sol
976 /* pragma solidity 0.8.10; */
977 /* pragma experimental ABIEncoderV2; */
978 
979 interface IUniswapV2Router02 {
980     function factory() external pure returns (address);
981 
982     function WETH() external pure returns (address);
983 
984     function addLiquidity(
985         address tokenA,
986         address tokenB,
987         uint256 amountADesired,
988         uint256 amountBDesired,
989         uint256 amountAMin,
990         uint256 amountBMin,
991         address to,
992         uint256 deadline
993     )
994         external
995         returns (
996             uint256 amountA,
997             uint256 amountB,
998             uint256 liquidity
999         );
1000 
1001     function addLiquidityETH(
1002         address token,
1003         uint256 amountTokenDesired,
1004         uint256 amountTokenMin,
1005         uint256 amountETHMin,
1006         address to,
1007         uint256 deadline
1008     )
1009         external
1010         payable
1011         returns (
1012             uint256 amountToken,
1013             uint256 amountETH,
1014             uint256 liquidity
1015         );
1016 
1017     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1018         uint256 amountIn,
1019         uint256 amountOutMin,
1020         address[] calldata path,
1021         address to,
1022         uint256 deadline
1023     ) external;
1024 
1025     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1026         uint256 amountOutMin,
1027         address[] calldata path,
1028         address to,
1029         uint256 deadline
1030     ) external payable;
1031 
1032     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1033         uint256 amountIn,
1034         uint256 amountOutMin,
1035         address[] calldata path,
1036         address to,
1037         uint256 deadline
1038     ) external;
1039 }
1040 
1041 /* pragma solidity >=0.8.10; */
1042 
1043 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1044 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1045 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1046 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1047 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1048 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1049 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1050 
1051 contract TradeHive is ERC20, Ownable {
1052     using SafeMath for uint256;
1053 
1054     IUniswapV2Router02 public immutable uniswapV2Router;
1055     address public immutable uniswapV2Pair;
1056     address public constant deadAddress = address(0xdead);
1057 
1058     bool private swapping;
1059 
1060     address public marketingWallet;
1061     address public devWallet;
1062 
1063     uint256 public maxTransactionAmount;
1064     uint256 public swapTokensAtAmount;
1065     uint256 public maxWallet;
1066 
1067     uint256 public percentForLPBurn = 25; // 25 = .25%
1068     bool public lpBurnEnabled = false;
1069     uint256 public lpBurnFrequency = 3600 seconds;
1070     uint256 public lastLpBurnTime;
1071 
1072     uint256 public manualBurnFrequency = 30 minutes;
1073     uint256 public lastManualLpBurnTime;
1074 
1075     bool public limitsInEffect = true;
1076     bool public tradingActive = false;
1077     bool public swapEnabled = false;
1078 
1079     // Anti-bot and anti-whale mappings and variables
1080     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1081     bool public transferDelayEnabled = true;
1082 
1083     uint256 public buyTotalFees;
1084     uint256 public buyMarketingFee;
1085     uint256 public buyLiquidityFee;
1086     uint256 public buyDevFee;
1087 
1088     uint256 public sellTotalFees;
1089     uint256 public sellMarketingFee;
1090     uint256 public sellLiquidityFee;
1091     uint256 public sellDevFee;
1092 
1093     uint256 public tokensForMarketing;
1094     uint256 public tokensForLiquidity;
1095     uint256 public tokensForDev;
1096 
1097     /******************/
1098 
1099     // exlcude from fees and max transaction amount
1100     mapping(address => bool) private _isExcludedFromFees;
1101     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1102 
1103     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1104     // could be subject to a maximum transfer amount
1105     mapping(address => bool) public automatedMarketMakerPairs;
1106 
1107     event UpdateUniswapV2Router(
1108         address indexed newAddress,
1109         address indexed oldAddress
1110     );
1111 
1112     event ExcludeFromFees(address indexed account, bool isExcluded);
1113 
1114     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1115 
1116     event marketingWalletUpdated(
1117         address indexed newWallet,
1118         address indexed oldWallet
1119     );
1120 
1121     event devWalletUpdated(
1122         address indexed newWallet,
1123         address indexed oldWallet
1124     );
1125 
1126     event SwapAndLiquify(
1127         uint256 tokensSwapped,
1128         uint256 ethReceived,
1129         uint256 tokensIntoLiquidity
1130     );
1131 
1132     event AutoNukeLP();
1133 
1134     event ManualNukeLP();
1135 
1136     constructor() ERC20("TradeHive | TradeHive.app", "THV") {
1137         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1138             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1139         );
1140 
1141         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1142         uniswapV2Router = _uniswapV2Router;
1143 
1144         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1145             .createPair(address(this), _uniswapV2Router.WETH());
1146         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1147         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1148 
1149         uint256 _buyMarketingFee = 30; //Anti-bot measurement at launch.
1150         uint256 _buyLiquidityFee = 0;
1151         uint256 _buyDevFee = 0;
1152 
1153         uint256 _sellMarketingFee = 40; //Anti-bot measurement at launch.
1154         uint256 _sellLiquidityFee = 0;
1155         uint256 _sellDevFee = 0;
1156 
1157         uint256 totalSupply = 1_000_000_000 * 1e18;
1158 
1159         maxTransactionAmount = 20_000_000 * 1e18;
1160         maxWallet = 20_000_000 * 1e18;
1161         swapTokensAtAmount = 4_000_000 * 1e18;
1162 
1163         buyMarketingFee = _buyMarketingFee;
1164         buyLiquidityFee = _buyLiquidityFee;
1165         buyDevFee = _buyDevFee;
1166         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1167 
1168         sellMarketingFee = _sellMarketingFee;
1169         sellLiquidityFee = _sellLiquidityFee;
1170         sellDevFee = _sellDevFee;
1171         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1172 
1173         marketingWallet = address(0xFE5A7c1B1D2b2B57405F76Df1F88AF1455B12DBB); 
1174         devWallet = address(0xFE5A7c1B1D2b2B57405F76Df1F88AF1455B12DBB); 
1175 
1176         // exclude from paying fees or having max transaction amount
1177         excludeFromFees(owner(), true);
1178         excludeFromFees(address(this), true);
1179         excludeFromFees(address(0xdead), true);
1180 
1181         excludeFromMaxTransaction(owner(), true);
1182         excludeFromMaxTransaction(address(this), true);
1183         excludeFromMaxTransaction(address(0xdead), true);
1184 
1185         /*
1186             _mint is an internal function in ERC20.sol that is only called here,
1187             and CANNOT be called ever again
1188         */
1189         _mint(msg.sender, totalSupply);
1190     }
1191 
1192     receive() external payable {}
1193 
1194     // once enabled, can never be turned off
1195     function enableTrading() external onlyOwner {
1196         tradingActive = true;
1197         swapEnabled = true;
1198         lastLpBurnTime = block.timestamp;
1199     }
1200 
1201     // remove limits after token is stable
1202     function removeLimits() external onlyOwner returns (bool) {
1203         limitsInEffect = false;
1204         return true;
1205     }
1206 
1207     // disable Transfer delay - cannot be reenabled
1208     function disableTransferDelay() external onlyOwner returns (bool) {
1209         transferDelayEnabled = false;
1210         return true;
1211     }
1212 
1213     // change the minimum amount of tokens to sell from fees
1214     function updateSwapTokensAtAmount(uint256 newAmount)
1215         external
1216         onlyOwner
1217         returns (bool)
1218     {
1219         require(
1220             newAmount >= (totalSupply() * 1) / 100000,
1221             "Swap amount cannot be lower than 0.001% total supply."
1222         );
1223         require(
1224             newAmount <= (totalSupply() * 5) / 1000,
1225             "Swap amount cannot be higher than 0.5% total supply."
1226         );
1227         swapTokensAtAmount = newAmount;
1228         return true;
1229     }
1230 
1231     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1232         require(
1233             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1234             "Cannot set maxTransactionAmount lower than 0.1%"
1235         );
1236         maxTransactionAmount = newNum * (10**18);
1237     }
1238 
1239     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1240         require(
1241             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1242             "Cannot set maxWallet lower than 0.5%"
1243         );
1244         maxWallet = newNum * (10**18);
1245     }
1246 
1247     function excludeFromMaxTransaction(address updAds, bool isEx)
1248         public
1249         onlyOwner
1250     {
1251         _isExcludedMaxTransactionAmount[updAds] = isEx;
1252     }
1253 
1254     // only use to disable contract sales if absolutely necessary (emergency use only)
1255     function updateSwapEnabled(bool enabled) external onlyOwner {
1256         swapEnabled = enabled;
1257     }
1258 
1259     function updateBuyFees(
1260         uint256 _marketingFee,
1261         uint256 _liquidityFee,
1262         uint256 _devFee
1263     ) external onlyOwner {
1264         buyMarketingFee = _marketingFee;
1265         buyLiquidityFee = _liquidityFee;
1266         buyDevFee = _devFee;
1267         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1268         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
1269     }
1270 
1271     function updateSellFees(
1272         uint256 _marketingFee,
1273         uint256 _liquidityFee,
1274         uint256 _devFee
1275     ) external onlyOwner {
1276         sellMarketingFee = _marketingFee;
1277         sellLiquidityFee = _liquidityFee;
1278         sellDevFee = _devFee;
1279         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1280         require(sellTotalFees <= 5, "Must keep fees at 5% or less");
1281     }
1282 
1283     function excludeFromFees(address account, bool excluded) public onlyOwner {
1284         _isExcludedFromFees[account] = excluded;
1285         emit ExcludeFromFees(account, excluded);
1286     }
1287 
1288     function setAutomatedMarketMakerPair(address pair, bool value)
1289         public
1290         onlyOwner
1291     {
1292         require(
1293             pair != uniswapV2Pair,
1294             "The pair cannot be removed from automatedMarketMakerPairs"
1295         );
1296 
1297         _setAutomatedMarketMakerPair(pair, value);
1298     }
1299 
1300     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1301         automatedMarketMakerPairs[pair] = value;
1302 
1303         emit SetAutomatedMarketMakerPair(pair, value);
1304     }
1305 
1306     function updateMarketingWallet(address newMarketingWallet)
1307         external
1308         onlyOwner
1309     {
1310         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1311         marketingWallet = newMarketingWallet;
1312     }
1313 
1314     function updateDevWallet(address newWallet) external onlyOwner {
1315         emit devWalletUpdated(newWallet, devWallet);
1316         devWallet = newWallet;
1317     }
1318 
1319     function isExcludedFromFees(address account) public view returns (bool) {
1320         return _isExcludedFromFees[account];
1321     }
1322 
1323     event BoughtEarly(address indexed sniper);
1324 
1325     function _transfer(
1326         address from,
1327         address to,
1328         uint256 amount
1329     ) internal override {
1330         require(from != address(0), "ERC20: transfer from the zero address");
1331         require(to != address(0), "ERC20: transfer to the zero address");
1332 
1333         if (amount == 0) {
1334             super._transfer(from, to, 0);
1335             return;
1336         }
1337 
1338         if (limitsInEffect) {
1339             if (
1340                 from != owner() &&
1341                 to != owner() &&
1342                 to != address(0) &&
1343                 to != address(0xdead) &&
1344                 !swapping
1345             ) {
1346                 if (!tradingActive) {
1347                     require(
1348                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1349                         "Trading is not active."
1350                     );
1351                 }
1352 
1353                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1354                 if (transferDelayEnabled) {
1355                     if (
1356                         to != owner() &&
1357                         to != address(uniswapV2Router) &&
1358                         to != address(uniswapV2Pair)
1359                     ) {
1360                         require(
1361                             _holderLastTransferTimestamp[tx.origin] <
1362                                 block.number,
1363                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1364                         );
1365                         _holderLastTransferTimestamp[tx.origin] = block.number;
1366                     }
1367                 }
1368 
1369                 //when buy
1370                 if (
1371                     automatedMarketMakerPairs[from] &&
1372                     !_isExcludedMaxTransactionAmount[to]
1373                 ) {
1374                     require(
1375                         amount <= maxTransactionAmount,
1376                         "Buy transfer amount exceeds the maxTransactionAmount."
1377                     );
1378                     require(
1379                         amount + balanceOf(to) <= maxWallet,
1380                         "Max wallet exceeded"
1381                     );
1382                 }
1383                 //when sell
1384                 else if (
1385                     automatedMarketMakerPairs[to] &&
1386                     !_isExcludedMaxTransactionAmount[from]
1387                 ) {
1388                     require(
1389                         amount <= maxTransactionAmount,
1390                         "Sell transfer amount exceeds the maxTransactionAmount."
1391                     );
1392                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1393                     require(
1394                         amount + balanceOf(to) <= maxWallet,
1395                         "Max wallet exceeded"
1396                     );
1397                 }
1398             }
1399         }
1400 
1401         uint256 contractTokenBalance = balanceOf(address(this));
1402 
1403         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1404 
1405         if (
1406             canSwap &&
1407             swapEnabled &&
1408             !swapping &&
1409             !automatedMarketMakerPairs[from] &&
1410             !_isExcludedFromFees[from] &&
1411             !_isExcludedFromFees[to]
1412         ) {
1413             swapping = true;
1414 
1415             swapBack();
1416 
1417             swapping = false;
1418         }
1419 
1420         if (
1421             !swapping &&
1422             automatedMarketMakerPairs[to] &&
1423             lpBurnEnabled &&
1424             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1425             !_isExcludedFromFees[from]
1426         ) {
1427             autoBurnLiquidityPairTokens();
1428         }
1429 
1430         bool takeFee = !swapping;
1431 
1432         // if any account belongs to _isExcludedFromFee account then remove the fee
1433         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1434             takeFee = false;
1435         }
1436 
1437         uint256 fees = 0;
1438         // only take fees on buys/sells, do not take on wallet transfers
1439         if (takeFee) {
1440             // on sell
1441             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1442                 fees = amount.mul(sellTotalFees).div(100);
1443                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1444                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1445                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1446             }
1447             // on buy
1448             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1449                 fees = amount.mul(buyTotalFees).div(100);
1450                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1451                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1452                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1453             }
1454 
1455             if (fees > 0) {
1456                 super._transfer(from, address(this), fees);
1457             }
1458 
1459             amount -= fees;
1460         }
1461 
1462         super._transfer(from, to, amount);
1463     }
1464 
1465     function swapTokensForEth(uint256 tokenAmount) private {
1466         // generate the uniswap pair path of token -> weth
1467         address[] memory path = new address[](2);
1468         path[0] = address(this);
1469         path[1] = uniswapV2Router.WETH();
1470 
1471         _approve(address(this), address(uniswapV2Router), tokenAmount);
1472 
1473         // make the swap
1474         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1475             tokenAmount,
1476             0, // accept any amount of ETH
1477             path,
1478             address(this),
1479             block.timestamp
1480         );
1481     }
1482 
1483     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1484         // approve token transfer to cover all possible scenarios
1485         _approve(address(this), address(uniswapV2Router), tokenAmount);
1486 
1487         // add the liquidity
1488         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1489             address(this),
1490             tokenAmount,
1491             0, // slippage is unavoidable
1492             0, // slippage is unavoidable
1493             deadAddress,
1494             block.timestamp
1495         );
1496     }
1497 
1498     function swapBack() private {
1499         uint256 contractBalance = balanceOf(address(this));
1500         uint256 totalTokensToSwap = tokensForLiquidity +
1501             tokensForMarketing +
1502             tokensForDev;
1503         bool success;
1504 
1505         if (contractBalance == 0 || totalTokensToSwap == 0) {
1506             return;
1507         }
1508 
1509         if (contractBalance > swapTokensAtAmount * 20) {
1510             contractBalance = swapTokensAtAmount * 20;
1511         }
1512 
1513         // Halve the amount of liquidity tokens
1514         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1515             totalTokensToSwap /
1516             2;
1517         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1518 
1519         uint256 initialETHBalance = address(this).balance;
1520 
1521         swapTokensForEth(amountToSwapForETH);
1522 
1523         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1524 
1525         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1526             totalTokensToSwap
1527         );
1528         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1529 
1530         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1531 
1532         tokensForLiquidity = 0;
1533         tokensForMarketing = 0;
1534         tokensForDev = 0;
1535 
1536         (success, ) = address(devWallet).call{value: ethForDev}("");
1537 
1538         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1539             addLiquidity(liquidityTokens, ethForLiquidity);
1540             emit SwapAndLiquify(
1541                 amountToSwapForETH,
1542                 ethForLiquidity,
1543                 tokensForLiquidity
1544             );
1545         }
1546 
1547         (success, ) = address(marketingWallet).call{
1548             value: address(this).balance
1549         }("");
1550     }
1551 
1552     function setAutoLPBurnSettings(
1553         uint256 _frequencyInSeconds,
1554         uint256 _percent,
1555         bool _Enabled
1556     ) external onlyOwner {
1557         require(
1558             _frequencyInSeconds >= 600,
1559             "cannot set buyback more often than every 10 minutes"
1560         );
1561         require(
1562             _percent <= 1000 && _percent >= 0,
1563             "Must set auto LP burn percent between 0% and 10%"
1564         );
1565         lpBurnFrequency = _frequencyInSeconds;
1566         percentForLPBurn = _percent;
1567         lpBurnEnabled = _Enabled;
1568     }
1569 
1570     function autoBurnLiquidityPairTokens() internal returns (bool) {
1571         lastLpBurnTime = block.timestamp;
1572 
1573         // get balance of liquidity pair
1574         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1575 
1576         // calculate amount to burn
1577         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1578             10000
1579         );
1580 
1581         // pull tokens from pancakePair liquidity and move to dead address permanently
1582         if (amountToBurn > 0) {
1583             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1584         }
1585 
1586         //sync price since this is not in a swap transaction!
1587         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1588         pair.sync();
1589         emit AutoNukeLP();
1590         return true;
1591     }
1592 
1593     function manualBurnLiquidityPairTokens(uint256 percent)
1594         external
1595         onlyOwner
1596         returns (bool)
1597     {
1598         require(
1599             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1600             "Must wait for cooldown to finish"
1601         );
1602         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1603         lastManualLpBurnTime = block.timestamp;
1604 
1605         // get balance of liquidity pair
1606         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1607 
1608         // calculate amount to burn
1609         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1610 
1611         // pull tokens from pancakePair liquidity and move to dead address permanently
1612         if (amountToBurn > 0) {
1613             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1614         }
1615 
1616         //sync price since this is not in a swap transaction!
1617         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1618         pair.sync();
1619         emit ManualNukeLP();
1620         return true;
1621     }
1622 }