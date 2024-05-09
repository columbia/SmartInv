1 // SPDX-License-Identifier: MIT
2 // 
3 //          NNNNNNNN        NNNNNNNN     OOOOOOOOO     NNNNNNNN        NNNNNNNNEEEEEEEEEEEEEEEEEEEEEE
4 //          N:::::::N       N::::::N   OO:::::::::OO   N:::::::N       N::::::NE::::::::::::::::::::E
5 //          N::::::::N      N::::::N OO:::::::::::::OO N::::::::N      N::::::NE::::::::::::::::::::E
6 //          N:::::::::N     N::::::NO:::::::OOO:::::::ON:::::::::N     N::::::NEE::::::EEEEEEEEE::::E
7 //          N::::::::::N    N::::::NO::::::O   O::::::ON::::::::::N    N::::::N  E:::::E       EEEEEE
8 //          N:::::::::::N   N::::::NO:::::O     O:::::ON:::::::::::N   N::::::N  E:::::E             
9 //          N:::::::N::::N  N::::::NO:::::O     O:::::ON:::::::N::::N  N::::::N  E::::::EEEEEEEEEE   
10 //          N::::::N N::::N N::::::NO:::::O     O:::::ON::::::N N::::N N::::::N  E:::::::::::::::E   
11 //          N::::::N  N::::N:::::::NO:::::O     O:::::ON::::::N  N::::N:::::::N  E:::::::::::::::E   
12 //          N::::::N   N:::::::::::NO:::::O     O:::::ON::::::N   N:::::::::::N  E::::::EEEEEEEEEE   
13 //          N::::::N    N::::::::::NO:::::O     O:::::ON::::::N    N::::::::::N  E:::::E             
14 //          N::::::N     N:::::::::NO::::::O   O::::::ON::::::N     N:::::::::N  E:::::E       EEEEEE
15 //          N::::::N      N::::::::NO:::::::OOO:::::::ON::::::N      N::::::::NEE::::::EEEEEEEE:::::E
16 //          N::::::N       N:::::::N OO:::::::::::::OO N::::::N       N:::::::NE::::::::::::::::::::E
17 //          N::::::N        N::::::N   OO:::::::::OO   N::::::N        N::::::NE::::::::::::::::::::E
18 //          NNNNNNNN         NNNNNNN     OOOOOOOOO     NNNNNNNN         NNNNNNNEEEEEEEEEEEEEEEEEEEEEE
19 // 
20 // 
21 //                  An enterprise level discord based NFT and shitcoin trading tool...
22 // 
23 //                                          https://noneth.io
24 //                                        https://docs.noneth.io
25 //                                      https://discord.gg/noneth
26 //                                     https://twitter.com/nonethio
27 // 
28 //                                          None Token Contract
29 //                      The purpose of this contract is run the $NONE token on it.
30 //                      - 4% to the revenue split helper (20% of revenue to holders)
31 //                                  - 1% to Liquidity Pool (automatic)
32 // 
33 pragma solidity 0.8.20;
34 
35 /**
36  * @dev Provides information about the current execution context, including the
37  * sender of the transaction and its data. While these are generally available
38  * via msg.sender and msg.data, they should not be accessed in such a direct
39  * manner, since when dealing with meta-transactions the account sending and
40  * paying for execution may not be the actual sender (as far as an application
41  * is concerned).
42  *
43  * This contract is only required for intermediate, library-like contracts.
44  */
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes calldata) {
51         return msg.data;
52     }
53 }
54 
55 /**
56  * @dev Contract module which provides a basic access control mechanism, where
57  * there is an account (an owner) that can be granted exclusive access to
58  * specific functions.
59  *
60  * By default, the owner account will be the one that deploys the contract. This
61  * can later be changed with {transferOwnership}.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 abstract contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor() {
76         _transferOwnership(_msgSender());
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions anymore. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby removing any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         _transferOwnership(address(0));
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Can only be called by the current owner.
108      */
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         _transferOwnership(newOwner);
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Internal function without access restriction.
117      */
118     function _transferOwnership(address newOwner) internal virtual {
119         address oldOwner = _owner;
120         _owner = newOwner;
121         emit OwnershipTransferred(oldOwner, newOwner);
122     }
123 }
124 
125 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
126 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
127 
128 /* pragma solidity ^0.8.0; */
129 
130 /**
131  * @dev Interface of the ERC20 standard as defined in the EIP.
132  */
133 interface IERC20 {
134     /**
135      * @dev Returns the amount of tokens in existence.
136      */
137     function totalSupply() external view returns (uint256);
138 
139     /**
140      * @dev Returns the amount of tokens owned by `account`.
141      */
142     function balanceOf(address account) external view returns (uint256);
143 
144     /**
145      * @dev Moves `amount` tokens from the caller's account to `recipient`.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transfer(address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Returns the remaining number of tokens that `spender` will be
155      * allowed to spend on behalf of `owner` through {transferFrom}. This is
156      * zero by default.
157      *
158      * This value changes when {approve} or {transferFrom} are called.
159      */
160     function allowance(address owner, address spender) external view returns (uint256);
161 
162     /**
163      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * IMPORTANT: Beware that changing an allowance with this method brings the risk
168      * that someone may use both the old and the new allowance by unfortunate
169      * transaction ordering. One possible solution to mitigate this race
170      * condition is to first reduce the spender's allowance to 0 and set the
171      * desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      *
174      * Emits an {Approval} event.
175      */
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Moves `amount` tokens from `sender` to `recipient` using the
180      * allowance mechanism. `amount` is then deducted from the caller's
181      * allowance.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) external returns (bool);
192 
193     /**
194      * @dev Emitted when `value` tokens are moved from one account (`from`) to
195      * another (`to`).
196      *
197      * Note that `value` may be zero.
198      */
199     event Transfer(address indexed from, address indexed to, uint256 value);
200 
201     /**
202      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
203      * a call to {approve}. `value` is the new allowance.
204      */
205     event Approval(address indexed owner, address indexed spender, uint256 value);
206 }
207 
208 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
209 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
210 
211 /* pragma solidity ^0.8.0; */
212 
213 /* import "../IERC20.sol"; */
214 
215 /**
216  * @dev Interface for the optional metadata functions from the ERC20 standard.
217  *
218  * _Available since v4.1._
219  */
220 interface IERC20Metadata is IERC20 {
221     /**
222      * @dev Returns the name of the token.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the symbol of the token.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the decimals places of the token.
233      */
234     function decimals() external view returns (uint8);
235 }
236 
237 /**
238  * @dev Implementation of the {IERC20} interface.
239  *
240  * This implementation is agnostic to the way tokens are created. This means
241  * that a supply mechanism has to be added in a derived contract using {_mint}.
242  * For a generic mechanism see {ERC20PresetMinterPauser}.
243  *
244  * TIP: For a detailed writeup see our guide
245  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
246  * to implement supply mechanisms].
247  *
248  * We have followed general OpenZeppelin Contracts guidelines: functions revert
249  * instead returning `false` on failure. This behavior is nonetheless
250  * conventional and does not conflict with the expectations of ERC20
251  * applications.
252  *
253  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
254  * This allows applications to reconstruct the allowance for all accounts just
255  * by listening to said events. Other implementations of the EIP may not emit
256  * these events, as it isn't required by the specification.
257  *
258  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
259  * functions have been added to mitigate the well-known issues around setting
260  * allowances. See {IERC20-approve}.
261  */
262 contract ERC20 is Context, IERC20, IERC20Metadata {
263     mapping(address => uint256) private _balances;
264 
265     mapping(address => mapping(address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     string private _name;
270     string private _symbol;
271 
272     /**
273      * @dev Sets the values for {name} and {symbol}.
274      *
275      * The default value of {decimals} is 18. To select a different value for
276      * {decimals} you should overload it.
277      *
278      * All two of these values are immutable: they can only be set once during
279      * construction.
280      */
281     constructor(string memory name_, string memory symbol_) {
282         _name = name_;
283         _symbol = symbol_;
284     }
285 
286     /**
287      * @dev Returns the name of the token.
288      */
289     function name() public view virtual override returns (string memory) {
290         return _name;
291     }
292 
293     /**
294      * @dev Returns the symbol of the token, usually a shorter version of the
295      * name.
296      */
297     function symbol() public view virtual override returns (string memory) {
298         return _symbol;
299     }
300 
301     /**
302      * @dev Returns the number of decimals used to get its user representation.
303      * For example, if `decimals` equals `2`, a balance of `505` tokens should
304      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
305      *
306      * Tokens usually opt for a value of 18, imitating the relationship between
307      * Ether and Wei. This is the value {ERC20} uses, unless this function is
308      * overridden;
309      *
310      * NOTE: This information is only used for _display_ purposes: it in
311      * no way affects any of the arithmetic of the contract, including
312      * {IERC20-balanceOf} and {IERC20-transfer}.
313      */
314     function decimals() public view virtual override returns (uint8) {
315         return 18;
316     }
317 
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view virtual override returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(address account) public view virtual override returns (uint256) {
329         return _balances[account];
330     }
331 
332     /**
333      * @dev See {IERC20-transfer}.
334      *
335      * Requirements:
336      *
337      * - `recipient` cannot be the zero address.
338      * - the caller must have a balance of at least `amount`.
339      */
340     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
341         _transfer(_msgSender(), recipient, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-allowance}.
347      */
348     function allowance(address owner, address spender) public view virtual override returns (uint256) {
349         return _allowances[owner][spender];
350     }
351 
352     /**
353      * @dev See {IERC20-approve}.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      */
359     function approve(address spender, uint256 amount) public virtual override returns (bool) {
360         _approve(_msgSender(), spender, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-transferFrom}.
366      *
367      * Emits an {Approval} event indicating the updated allowance. This is not
368      * required by the EIP. See the note at the beginning of {ERC20}.
369      *
370      * Requirements:
371      *
372      * - `sender` and `recipient` cannot be the zero address.
373      * - `sender` must have a balance of at least `amount`.
374      * - the caller must have allowance for ``sender``'s tokens of at least
375      * `amount`.
376      */
377     function transferFrom(
378         address sender,
379         address recipient,
380         uint256 amount
381     ) public virtual override returns (bool) {
382         _transfer(sender, recipient, amount);
383 
384         uint256 currentAllowance = _allowances[sender][_msgSender()];
385         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
386         unchecked {
387             _approve(sender, _msgSender(), currentAllowance - amount);
388         }
389 
390         return true;
391     }
392 
393     /**
394      * @dev Atomically increases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
407         return true;
408     }
409 
410     /**
411      * @dev Atomically decreases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      * - `spender` must have allowance for the caller of at least
422      * `subtractedValue`.
423      */
424     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
425         uint256 currentAllowance = _allowances[_msgSender()][spender];
426         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
427         unchecked {
428             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
429         }
430 
431         return true;
432     }
433 
434     /**
435      * @dev Moves `amount` of tokens from `sender` to `recipient`.
436      *
437      * This internal function is equivalent to {transfer}, and can be used to
438      * e.g. implement automatic token fees, slashing mechanisms, etc.
439      *
440      * Emits a {Transfer} event.
441      *
442      * Requirements:
443      *
444      * - `sender` cannot be the zero address.
445      * - `recipient` cannot be the zero address.
446      * - `sender` must have a balance of at least `amount`.
447      */
448     function _transfer(
449         address sender,
450         address recipient,
451         uint256 amount
452     ) internal virtual {
453         require(sender != address(0), "ERC20: transfer from the zero address");
454         require(recipient != address(0), "ERC20: transfer to the zero address");
455 
456         _beforeTokenTransfer(sender, recipient, amount);
457 
458         uint256 senderBalance = _balances[sender];
459         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
460         unchecked {
461             _balances[sender] = senderBalance - amount;
462         }
463         _balances[recipient] += amount;
464 
465         emit Transfer(sender, recipient, amount);
466 
467         _afterTokenTransfer(sender, recipient, amount);
468     }
469 
470     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
471      * the total supply.
472      *
473      * Emits a {Transfer} event with `from` set to the zero address.
474      *
475      * Requirements:
476      *
477      * - `account` cannot be the zero address.
478      */
479     function _mint(address account, uint256 amount) internal virtual {
480         require(account != address(0), "ERC20: mint to the zero address");
481 
482         _beforeTokenTransfer(address(0), account, amount);
483 
484         _totalSupply += amount;
485         _balances[account] += amount;
486         emit Transfer(address(0), account, amount);
487 
488         _afterTokenTransfer(address(0), account, amount);
489     }
490 
491     /**
492      * @dev Destroys `amount` tokens from `account`, reducing the
493      * total supply.
494      *
495      * Emits a {Transfer} event with `to` set to the zero address.
496      *
497      * Requirements:
498      *
499      * - `account` cannot be the zero address.
500      * - `account` must have at least `amount` tokens.
501      */
502     function _burn(address account, uint256 amount) internal virtual {
503         require(account != address(0), "ERC20: burn from the zero address");
504 
505         _beforeTokenTransfer(account, address(0), amount);
506 
507         uint256 accountBalance = _balances[account];
508         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
509         unchecked {
510             _balances[account] = accountBalance - amount;
511         }
512         _totalSupply -= amount;
513 
514         emit Transfer(account, address(0), amount);
515 
516         _afterTokenTransfer(account, address(0), amount);
517     }
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
521      *
522      * This internal function is equivalent to `approve`, and can be used to
523      * e.g. set automatic allowances for certain subsystems, etc.
524      *
525      * Emits an {Approval} event.
526      *
527      * Requirements:
528      *
529      * - `owner` cannot be the zero address.
530      * - `spender` cannot be the zero address.
531      */
532     function _approve(
533         address owner,
534         address spender,
535         uint256 amount
536     ) internal virtual {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     /**
545      * @dev Hook that is called before any transfer of tokens. This includes
546      * minting and burning.
547      *
548      * Calling conditions:
549      *
550      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
551      * will be transferred to `to`.
552      * - when `from` is zero, `amount` tokens will be minted for `to`.
553      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
554      * - `from` and `to` are never both zero.
555      *
556      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
557      */
558     function _beforeTokenTransfer(
559         address from,
560         address to,
561         uint256 amount
562     ) internal virtual {}
563 
564     /**
565      * @dev Hook that is called after any transfer of tokens. This includes
566      * minting and burning.
567      *
568      * Calling conditions:
569      *
570      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
571      * has been transferred to `to`.
572      * - when `from` is zero, `amount` tokens have been minted for `to`.
573      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
574      * - `from` and `to` are never both zero.
575      *
576      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
577      */
578     function _afterTokenTransfer(
579         address from,
580         address to,
581         uint256 amount
582     ) internal virtual {}
583 }
584 
585 /**
586  * @dev Wrappers over Solidity's arithmetic operations.
587  *
588  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
589  * now has built in overflow checking.
590  */
591 library SafeMath {
592     /**
593      * @dev Returns the addition of two unsigned integers, with an overflow flag.
594      *
595      * _Available since v3.4._
596      */
597     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
598         unchecked {
599             uint256 c = a + b;
600             if (c < a) return (false, 0);
601             return (true, c);
602         }
603     }
604 
605     /**
606      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
607      *
608      * _Available since v3.4._
609      */
610     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
611         unchecked {
612             if (b > a) return (false, 0);
613             return (true, a - b);
614         }
615     }
616 
617     /**
618      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
619      *
620      * _Available since v3.4._
621      */
622     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
623         unchecked {
624             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
625             // benefit is lost if 'b' is also tested.
626             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
627             if (a == 0) return (true, 0);
628             uint256 c = a * b;
629             if (c / a != b) return (false, 0);
630             return (true, c);
631         }
632     }
633 
634     /**
635      * @dev Returns the division of two unsigned integers, with a division by zero flag.
636      *
637      * _Available since v3.4._
638      */
639     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
640         unchecked {
641             if (b == 0) return (false, 0);
642             return (true, a / b);
643         }
644     }
645 
646     /**
647      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
648      *
649      * _Available since v3.4._
650      */
651     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
652         unchecked {
653             if (b == 0) return (false, 0);
654             return (true, a % b);
655         }
656     }
657 
658     /**
659      * @dev Returns the addition of two unsigned integers, reverting on
660      * overflow.
661      *
662      * Counterpart to Solidity's `+` operator.
663      *
664      * Requirements:
665      *
666      * - Addition cannot overflow.
667      */
668     function add(uint256 a, uint256 b) internal pure returns (uint256) {
669         return a + b;
670     }
671 
672     /**
673      * @dev Returns the subtraction of two unsigned integers, reverting on
674      * overflow (when the result is negative).
675      *
676      * Counterpart to Solidity's `-` operator.
677      *
678      * Requirements:
679      *
680      * - Subtraction cannot overflow.
681      */
682     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
683         return a - b;
684     }
685 
686     /**
687      * @dev Returns the multiplication of two unsigned integers, reverting on
688      * overflow.
689      *
690      * Counterpart to Solidity's `*` operator.
691      *
692      * Requirements:
693      *
694      * - Multiplication cannot overflow.
695      */
696     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
697         return a * b;
698     }
699 
700     /**
701      * @dev Returns the integer division of two unsigned integers, reverting on
702      * division by zero. The result is rounded towards zero.
703      *
704      * Counterpart to Solidity's `/` operator.
705      *
706      * Requirements:
707      *
708      * - The divisor cannot be zero.
709      */
710     function div(uint256 a, uint256 b) internal pure returns (uint256) {
711         return a / b;
712     }
713 
714     /**
715      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
716      * reverting when dividing by zero.
717      *
718      * Counterpart to Solidity's `%` operator. This function uses a `revert`
719      * opcode (which leaves remaining gas untouched) while Solidity uses an
720      * invalid opcode to revert (consuming all remaining gas).
721      *
722      * Requirements:
723      *
724      * - The divisor cannot be zero.
725      */
726     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
727         return a % b;
728     }
729 
730     /**
731      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
732      * overflow (when the result is negative).
733      *
734      * CAUTION: This function is deprecated because it requires allocating memory for the error
735      * message unnecessarily. For custom revert reasons use {trySub}.
736      *
737      * Counterpart to Solidity's `-` operator.
738      *
739      * Requirements:
740      *
741      * - Subtraction cannot overflow.
742      */
743     function sub(
744         uint256 a,
745         uint256 b,
746         string memory errorMessage
747     ) internal pure returns (uint256) {
748         unchecked {
749             require(b <= a, errorMessage);
750             return a - b;
751         }
752     }
753 
754     /**
755      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
756      * division by zero. The result is rounded towards zero.
757      *
758      * Counterpart to Solidity's `/` operator. Note: this function uses a
759      * `revert` opcode (which leaves remaining gas untouched) while Solidity
760      * uses an invalid opcode to revert (consuming all remaining gas).
761      *
762      * Requirements:
763      *
764      * - The divisor cannot be zero.
765      */
766     function div(
767         uint256 a,
768         uint256 b,
769         string memory errorMessage
770     ) internal pure returns (uint256) {
771         unchecked {
772             require(b > 0, errorMessage);
773             return a / b;
774         }
775     }
776 
777     /**
778      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
779      * reverting with custom message when dividing by zero.
780      *
781      * CAUTION: This function is deprecated because it requires allocating memory for the error
782      * message unnecessarily. For custom revert reasons use {tryMod}.
783      *
784      * Counterpart to Solidity's `%` operator. This function uses a `revert`
785      * opcode (which leaves remaining gas untouched) while Solidity uses an
786      * invalid opcode to revert (consuming all remaining gas).
787      *
788      * Requirements:
789      *
790      * - The divisor cannot be zero.
791      */
792     function mod(
793         uint256 a,
794         uint256 b,
795         string memory errorMessage
796     ) internal pure returns (uint256) {
797         unchecked {
798             require(b > 0, errorMessage);
799             return a % b;
800         }
801     }
802 }
803 
804 interface IUniswapV2Factory {
805     event PairCreated(
806         address indexed token0,
807         address indexed token1,
808         address pair,
809         uint256
810     );
811 
812     function feeTo() external view returns (address);
813 
814     function feeToSetter() external view returns (address);
815 
816     function getPair(address tokenA, address tokenB)
817         external
818         view
819         returns (address pair);
820 
821     function allPairs(uint256) external view returns (address pair);
822 
823     function allPairsLength() external view returns (uint256);
824 
825     function createPair(address tokenA, address tokenB)
826         external
827         returns (address pair);
828 
829     function setFeeTo(address) external;
830 
831     function setFeeToSetter(address) external;
832 }
833 
834 ////// src/IUniswapV2Pair.sol
835 /* pragma solidity 0.8.10; */
836 /* pragma experimental ABIEncoderV2; */
837 
838 interface IUniswapV2Pair {
839     event Approval(
840         address indexed owner,
841         address indexed spender,
842         uint256 value
843     );
844     event Transfer(address indexed from, address indexed to, uint256 value);
845 
846     function name() external pure returns (string memory);
847 
848     function symbol() external pure returns (string memory);
849 
850     function decimals() external pure returns (uint8);
851 
852     function totalSupply() external view returns (uint256);
853 
854     function balanceOf(address owner) external view returns (uint256);
855 
856     function allowance(address owner, address spender)
857         external
858         view
859         returns (uint256);
860 
861     function approve(address spender, uint256 value) external returns (bool);
862 
863     function transfer(address to, uint256 value) external returns (bool);
864 
865     function transferFrom(
866         address from,
867         address to,
868         uint256 value
869     ) external returns (bool);
870 
871     function DOMAIN_SEPARATOR() external view returns (bytes32);
872 
873     function PERMIT_TYPEHASH() external pure returns (bytes32);
874 
875     function nonces(address owner) external view returns (uint256);
876 
877     function permit(
878         address owner,
879         address spender,
880         uint256 value,
881         uint256 deadline,
882         uint8 v,
883         bytes32 r,
884         bytes32 s
885     ) external;
886 
887     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
888     event Burn(
889         address indexed sender,
890         uint256 amount0,
891         uint256 amount1,
892         address indexed to
893     );
894     event Swap(
895         address indexed sender,
896         uint256 amount0In,
897         uint256 amount1In,
898         uint256 amount0Out,
899         uint256 amount1Out,
900         address indexed to
901     );
902     event Sync(uint112 reserve0, uint112 reserve1);
903 
904     function MINIMUM_LIQUIDITY() external pure returns (uint256);
905 
906     function factory() external view returns (address);
907 
908     function token0() external view returns (address);
909 
910     function token1() external view returns (address);
911 
912     function getReserves()
913         external
914         view
915         returns (
916             uint112 reserve0,
917             uint112 reserve1,
918             uint32 blockTimestampLast
919         );
920 
921     function price0CumulativeLast() external view returns (uint256);
922 
923     function price1CumulativeLast() external view returns (uint256);
924 
925     function kLast() external view returns (uint256);
926 
927     function mint(address to) external returns (uint256 liquidity);
928 
929     function burn(address to)
930         external
931         returns (uint256 amount0, uint256 amount1);
932 
933     function swap(
934         uint256 amount0Out,
935         uint256 amount1Out,
936         address to,
937         bytes calldata data
938     ) external;
939 
940     function skim(address to) external;
941 
942     function sync() external;
943 
944     function initialize(address, address) external;
945 }
946 
947 interface IUniswapV2Router02 {
948     function factory() external pure returns (address);
949 
950     function WETH() external pure returns (address);
951 
952     function addLiquidity(
953         address tokenA,
954         address tokenB,
955         uint256 amountADesired,
956         uint256 amountBDesired,
957         uint256 amountAMin,
958         uint256 amountBMin,
959         address to,
960         uint256 deadline
961     )
962         external
963         returns (
964             uint256 amountA,
965             uint256 amountB,
966             uint256 liquidity
967         );
968 
969     function addLiquidityETH(
970         address token,
971         uint256 amountTokenDesired,
972         uint256 amountTokenMin,
973         uint256 amountETHMin,
974         address to,
975         uint256 deadline
976     )
977         external
978         payable
979         returns (
980             uint256 amountToken,
981             uint256 amountETH,
982             uint256 liquidity
983         );
984 
985     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
986         uint256 amountIn,
987         uint256 amountOutMin,
988         address[] calldata path,
989         address to,
990         uint256 deadline
991     ) external;
992 
993     function swapExactETHForTokensSupportingFeeOnTransferTokens(
994         uint256 amountOutMin,
995         address[] calldata path,
996         address to,
997         uint256 deadline
998     ) external payable;
999 
1000     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1001         uint256 amountIn,
1002         uint256 amountOutMin,
1003         address[] calldata path,
1004         address to,
1005         uint256 deadline
1006     ) external;
1007 }
1008 
1009 contract None is ERC20, Ownable {
1010 
1011     IUniswapV2Router02 public immutable uniswapV2Router;
1012     address public immutable uniswapV2Pair;
1013     bool private swapping;
1014 
1015     address public immutable revShareWallet;
1016 
1017     uint256 public maxTransactionAmount;
1018     uint256 immutable public swapTokensAtAmount;
1019     uint256 public maxWallet;
1020 
1021     bool public tradingActive = false;
1022     bool public swapEnabled = false;
1023 
1024     // Anti-bot and anti-whale mappings and variables
1025     mapping(address => bool) blacklisted;
1026 
1027     uint256 public buyTotalFees;
1028     uint256 public buyRevShareFee;
1029     uint256 public buyLiquidityFee;
1030 
1031     uint256 public sellTotalFees;
1032     uint256 public sellRevShareFee;
1033     uint256 public sellLiquidityFee;
1034 
1035     uint256 public tokensForRevShare;
1036     uint256 public tokensForLiquidity;
1037 
1038     // Exclude from fees and max transaction amount
1039     mapping(address => bool) private _isExcludedFromFees;
1040     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1041 
1042     // Store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1043     // could be subject to a maximum transfer amount
1044     mapping(address => bool) public automatedMarketMakerPairs;
1045 
1046     event UpdateUniswapV2Router(
1047         address indexed newAddress,
1048         address indexed oldAddress
1049     );
1050 
1051     event ExcludeFromFees(address indexed account, bool isExcluded);
1052 
1053     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1054 
1055     event SwapAndLiquify(
1056         uint256 tokensSwapped,
1057         uint256 ethReceived,
1058         uint256 tokensIntoLiquidity
1059     );
1060 
1061     constructor() ERC20("None Trading", "NONE") {
1062         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1063             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D //Uniswap V2 Router
1064         );
1065 
1066         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1067         uniswapV2Router = _uniswapV2Router;
1068 
1069         // Creates the Uniswap Pair
1070         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1071             .createPair(address(this), _uniswapV2Router.WETH());
1072         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1073         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1074 
1075         uint256 _buyRevShareFee = 8; // Lowered to 4% after launch
1076         uint256 _buyLiquidityFee = 2; // Lowered to 1% after launch
1077 
1078         uint256 _sellRevShareFee = 8; // Lowered to 4% after launch
1079         uint256 _sellLiquidityFee = 2; // Lowered to 1% after launch
1080 
1081         uint256 totalSupply = 1_000_000 * 1e18; // 1 million
1082 
1083         maxTransactionAmount = 2500 * 1e18; // 0.25%
1084         maxWallet = 2500 * 1e18; // 0.25% 
1085         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% 
1086 
1087         buyRevShareFee = _buyRevShareFee;
1088         buyLiquidityFee = _buyLiquidityFee;
1089         buyTotalFees = buyRevShareFee + buyLiquidityFee;
1090 
1091         sellRevShareFee = _sellRevShareFee;
1092         sellLiquidityFee = _sellLiquidityFee;
1093         sellTotalFees = sellRevShareFee + sellLiquidityFee;
1094 
1095         revShareWallet = address(0x17272b36596DD16041a6Aea49304B7BfEc221A15); // Set as revShare wallet - Helper Contract
1096 
1097         // Exclude from paying fees or having max transaction amount if; is owner, is deployer, is dead address. 
1098         excludeFromFees(owner(), true);
1099         excludeFromFees(address(this), true);
1100         excludeFromFees(address(0xdead), true);
1101 
1102         excludeFromMaxTransaction(owner(), true);
1103         excludeFromMaxTransaction(address(this), true);
1104         excludeFromMaxTransaction(address(0xdead), true);
1105 
1106         /*
1107             _mint is an internal function in ERC20.sol that is only called here,
1108             and CANNOT be called ever again
1109         */
1110         _mint(msg.sender, totalSupply);
1111     }
1112 
1113     receive() external payable {}
1114 
1115     // Will enable trading, once this is toggeled, it will not be able to be turned off.
1116     function enableTrading() external onlyOwner {
1117         tradingActive = true;
1118         swapEnabled = true;
1119     }
1120 
1121     // Trigger this post launch once price is more stable. Made to avoid whales and snipers hogging supply.
1122     function updateLimitsAndFees() external onlyOwner {
1123         maxTransactionAmount = 10_000 * (10**18); // 1%
1124         maxWallet = 25_000 * (10**18); // 2.5%
1125     
1126         buyRevShareFee = 4; // 4%
1127         buyLiquidityFee = 1; // 1%
1128         buyTotalFees = 5;
1129 
1130         sellRevShareFee = 4; // 4%
1131         sellLiquidityFee = 1; // 1%
1132         sellTotalFees = 5;
1133     }
1134 
1135     function excludeFromMaxTransaction(address updAds, bool isEx)
1136         public
1137         onlyOwner
1138     {
1139         _isExcludedMaxTransactionAmount[updAds] = isEx;
1140     }
1141 
1142     function excludeFromFees(address account, bool excluded) public onlyOwner {
1143         _isExcludedFromFees[account] = excluded;
1144         emit ExcludeFromFees(account, excluded);
1145     }
1146 
1147     function setAutomatedMarketMakerPair(address pair, bool value)
1148         public
1149         onlyOwner
1150     {
1151         require(
1152             pair != uniswapV2Pair,
1153             "The pair cannot be removed from automatedMarketMakerPairs"
1154         );
1155 
1156         _setAutomatedMarketMakerPair(pair, value);
1157     }
1158 
1159     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1160         automatedMarketMakerPairs[pair] = value;
1161 
1162         emit SetAutomatedMarketMakerPair(pair, value);
1163     }
1164 
1165     function isExcludedFromFees(address account) public view returns (bool) {
1166         return _isExcludedFromFees[account];
1167     }
1168 
1169     function isBlacklisted(address account) public view returns (bool) {
1170         return blacklisted[account];
1171     }
1172 
1173     function _transfer(
1174         address from,
1175         address to,
1176         uint256 amount
1177     ) internal override {
1178         require(from != address(0), "ERC20: transfer from the zero address");
1179         require(to != address(0), "ERC20: transfer to the zero address");
1180         require(!blacklisted[from],"Sender blacklisted");
1181         require(!blacklisted[to],"Receiver blacklisted");
1182 
1183         if (amount == 0) {
1184             super._transfer(from, to, 0);
1185             return;
1186         }
1187 
1188         if (
1189                 from != owner() &&
1190                 to != owner() &&
1191                 to != address(0) &&
1192                 to != address(0xdead) &&
1193                 !swapping
1194             ) {
1195                 if (!tradingActive) {
1196                     require(
1197                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1198                         "Trading is not active."
1199                     );
1200                 }
1201 
1202                 // Buying
1203                 if (
1204                     automatedMarketMakerPairs[from] &&
1205                     !_isExcludedMaxTransactionAmount[to]
1206                 ) {
1207                     require(
1208                         amount <= maxTransactionAmount,
1209                         "Buy transfer amount exceeds the maxTransactionAmount."
1210                     );
1211                     require(
1212                         amount + balanceOf(to) <= maxWallet,
1213                         "Max wallet exceeded"
1214                     );
1215                 }
1216                 // Selling
1217                 else if (
1218                     automatedMarketMakerPairs[to] &&
1219                     !_isExcludedMaxTransactionAmount[from]
1220                 ) {
1221                     require(
1222                         amount <= maxTransactionAmount,
1223                         "Sell transfer amount exceeds the maxTransactionAmount."
1224                     );
1225                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1226                     require(
1227                         amount + balanceOf(to) <= maxWallet,
1228                         "Max wallet exceeded"
1229                     );
1230                 }
1231         }
1232 
1233         uint256 contractTokenBalance = balanceOf(address(this));
1234 
1235         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1236 
1237         if (
1238             canSwap &&
1239             swapEnabled &&
1240             !swapping &&
1241             !automatedMarketMakerPairs[from] &&
1242             !_isExcludedFromFees[from] &&
1243             !_isExcludedFromFees[to]
1244         ) {
1245             swapping = true;
1246 
1247             swapBack();
1248 
1249             swapping = false;
1250         }
1251 
1252         bool takeFee = !swapping;
1253 
1254         // If any account belongs to _isExcludedFromFee account then remove the fee
1255         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1256             takeFee = false;
1257         }
1258 
1259         uint256 fees = 0;
1260         // Only take fees on buys/sells, do not take on wallet transfers
1261         if (takeFee) {
1262             // Sell
1263             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1264                 fees = (amount * sellTotalFees) / 100;
1265                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1266                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1267             }
1268             // Buy
1269             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1270                 fees = (amount * buyTotalFees) / 100;
1271                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1272                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1273             }
1274 
1275             if (fees > 0) {
1276                 super._transfer(from, address(this), fees);
1277             }
1278 
1279             amount -= fees;
1280         }
1281 
1282         super._transfer(from, to, amount);
1283     }
1284 
1285     function swapTokensForEth(uint256 tokenAmount) private {
1286         // Generate the uniswap pair path of token -> weth
1287         address[] memory path = new address[](2);
1288         path[0] = address(this);
1289         path[1] = uniswapV2Router.WETH();
1290 
1291         _approve(address(this), address(uniswapV2Router), tokenAmount);
1292 
1293         // Make the swap
1294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1295             tokenAmount,
1296             0, // Accept any amount of ETH; ignore slippage
1297             path,
1298             address(this),
1299             block.timestamp
1300         );
1301     }
1302 
1303     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1304         // approve token transfer to cover all possible scenarios
1305         _approve(address(this), address(uniswapV2Router), tokenAmount);
1306 
1307         // add the liquidity
1308         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1309             address(this),
1310             tokenAmount,
1311             0, // Slippage is unavoidable
1312             0, // Slippage is unavoidable
1313             owner(),
1314             block.timestamp
1315         );
1316     }
1317 
1318     function swapBack() private {
1319         uint256 contractBalance = balanceOf(address(this));
1320         uint256 totalTokensToSwap = tokensForLiquidity +
1321             tokensForRevShare;
1322         bool success;
1323 
1324         if (contractBalance == 0 || totalTokensToSwap == 0) {
1325             return;
1326         }
1327 
1328         if (contractBalance > swapTokensAtAmount * 20) {
1329             contractBalance = swapTokensAtAmount * 20;
1330         }
1331 
1332         // Halve the amount of liquidity tokens
1333         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1334             totalTokensToSwap /
1335             2;
1336         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
1337 
1338         uint256 initialETHBalance = address(this).balance;
1339 
1340         swapTokensForEth(amountToSwapForETH);
1341 
1342         uint256 ethBalance = address(this).balance - initialETHBalance;
1343 
1344         uint256 ethForRevShare = (ethBalance * tokensForRevShare) / (totalTokensToSwap - (tokensForLiquidity / 2));
1345         
1346         uint256 ethForLiquidity = ethBalance - ethForRevShare;
1347 
1348         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1349             addLiquidity(liquidityTokens, ethForLiquidity);
1350             emit SwapAndLiquify(
1351                 amountToSwapForETH,
1352                 ethForLiquidity,
1353                 tokensForLiquidity
1354             );
1355         }
1356 
1357         tokensForLiquidity = 0;
1358         tokensForRevShare = 0;
1359 
1360         (success, ) = address(revShareWallet).call{value: address(this).balance}("");
1361     }
1362         
1363     // The helper contract will also be used to be able to call the 5 functions below. 
1364     // Any functions that have to do with ETH or Tokens will be sent directly to the helper contract. 
1365     // This means that the split of 80% to the team, and 20% to the holders is intact.
1366     modifier onlyHelper() {
1367         require(revShareWallet == _msgSender(), "Token: caller is not the Helper");
1368         _;
1369     }
1370 
1371     // @Helper - Callable by Helper contract in-case tokens get's stuck in the token contract.
1372     function withdrawStuckToken(address _token, address _to) external onlyHelper {
1373         require(_token != address(0), "_token address cannot be 0");
1374         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1375         IERC20(_token).transfer(_to, _contractBalance);
1376     }
1377 
1378     // @Helper - Callable by Helper contract in-case ETH get's stuck in the token contract.
1379     function withdrawStuckEth(address toAddr) external onlyHelper {
1380         (bool success, ) = toAddr.call{
1381             value: address(this).balance
1382         } ("");
1383         require(success);
1384     }
1385 
1386     // @Helper - Blacklist v3 pools; can unblacklist() down the road to suit project and community
1387     function blacklistLiquidityPool(address lpAddress) public onlyHelper {
1388         require(
1389             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1390             "Cannot blacklist token's v2 router or v2 pool."
1391         );
1392         blacklisted[lpAddress] = true;
1393     }
1394 
1395     // @Helper - Unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1396     function unblacklist(address _addr) public onlyHelper {
1397         blacklisted[_addr] = false;
1398     }
1399 
1400 }