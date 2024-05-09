1 /**
2 
3 buddy.tech 
4 Telegram: t.me/buddytecheth
5 Twitter: twitter.com/buddytecherc20
6 Website: www.buddytecheth.com
7  
8 The First friend.tech competitor
9 
10 Following the success of friend.tech, Buddy.Tech is its first competitor on the Ethereum Mainnet, with improved characteristics!
11 
12 Buddy.tech is a decentralized social media app that allows holders of the buddy.tech token to tokenize their followers.
13 
14 Anyone can start their own token on our platform and buy and sell shares of your favourite influencers or yourself. 
15 
16 The price of your shares are determined by supply and demand!
17 
18 When a person’s shares are bought and sold, they earn a fee in our proprietary buddy.tech ERC-20 token. 
19 
20 Moreover, any holders of tokens launched and distributed on our platform get the ability to join a private chat with the influencer or person who launched the token!
21 
22 We are the first friend.tech competitor.
23 
24 */
25 
26 // SPDX-License-Identifier: MIT
27 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
28 pragma experimental ABIEncoderV2;
29 
30 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
31 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
32 
33 /* pragma solidity ^0.8.0; */
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
55 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
56 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
57 
58 /* pragma solidity ^0.8.0; */
59 
60 /* import "../utils/Context.sol"; */
61 
62 /**
63  * @dev Contract module which provides a basic access control mechanism, where
64  * there is an account (an owner) that can be granted exclusive access to
65  * specific functions.
66  *
67  * By default, the owner account will be the one that deploys the contract. This
68  * can later be changed with {transferOwnership}.
69  *
70  * This module is used through inheritance. It will make available the modifier
71  * `onlyOwner`, which can be applied to your functions to restrict their use to
72  * the owner.
73  */
74 abstract contract Ownable is Context {
75     address private _owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     /**
80      * @dev Initializes the contract setting the deployer as the initial owner.
81      */
82     constructor() {
83         _transferOwnership(_msgSender());
84     }
85 
86     /**
87      * @dev Returns the address of the current owner.
88      */
89     function owner() public view virtual returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(owner() == _msgSender(), "Ownable: caller is not the owner");
98         _;
99     }
100 
101     /**
102      * @dev Leaves the contract without owner. It will not be possible to call
103      * `onlyOwner` functions anymore. Can only be called by the current owner.
104      *
105      * NOTE: Renouncing ownership will leave the contract without an owner,
106      * thereby removing any functionality that is only available to the owner.
107      */
108     function renounceOwnership() public virtual onlyOwner {
109         _transferOwnership(address(0));
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Can only be called by the current owner.
115      */
116     function transferOwnership(address newOwner) public virtual onlyOwner {
117         require(newOwner != address(0), "Ownable: new owner is the zero address");
118         _transferOwnership(newOwner);
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Internal function without access restriction.
124      */
125     function _transferOwnership(address newOwner) internal virtual {
126         address oldOwner = _owner;
127         _owner = newOwner;
128         emit OwnershipTransferred(oldOwner, newOwner);
129     }
130 }
131 
132 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
133 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
134 
135 /* pragma solidity ^0.8.0; */
136 
137 /**
138  * @dev Interface of the ERC20 standard as defined in the EIP.
139  */
140 interface IERC20 {
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `recipient`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `sender` to `recipient` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) external returns (bool);
199 
200     /**
201      * @dev Emitted when `value` tokens are moved from one account (`from`) to
202      * another (`to`).
203      *
204      * Note that `value` may be zero.
205      */
206     event Transfer(address indexed from, address indexed to, uint256 value);
207 
208     /**
209      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
210      * a call to {approve}. `value` is the new allowance.
211      */
212     event Approval(address indexed owner, address indexed spender, uint256 value);
213 }
214 
215 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
216 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
217 
218 /* pragma solidity ^0.8.0; */
219 
220 /* import "../IERC20.sol"; */
221 
222 /**
223  * @dev Interface for the optional metadata functions from the ERC20 standard.
224  *
225  * _Available since v4.1._
226  */
227 interface IERC20Metadata is IERC20 {
228     /**
229      * @dev Returns the name of the token.
230      */
231     function name() external view returns (string memory);
232 
233     /**
234      * @dev Returns the symbol of the token.
235      */
236     function symbol() external view returns (string memory);
237 
238     /**
239      * @dev Returns the decimals places of the token.
240      */
241     function decimals() external view returns (uint8);
242 }
243 
244 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
245 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
246 
247 /* pragma solidity ^0.8.0; */
248 
249 /* import "./IERC20.sol"; */
250 /* import "./extensions/IERC20Metadata.sol"; */
251 /* import "../../utils/Context.sol"; */
252 
253 /**
254  * @dev Implementation of the {IERC20} interface.
255  *
256  * This implementation is agnostic to the way tokens are created. This means
257  * that a supply mechanism has to be added in a derived contract using {_mint}.
258  * For a generic mechanism see {ERC20PresetMinterPauser}.
259  *
260  * TIP: For a detailed writeup see our guide
261  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
262  * to implement supply mechanisms].
263  *
264  * We have followed general OpenZeppelin Contracts guidelines: functions revert
265  * instead returning `false` on failure. This behavior is nonetheless
266  * conventional and does not conflict with the expectations of ERC20
267  * applications.
268  *
269  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
270  * This allows applications to reconstruct the allowance for all accounts just
271  * by listening to said events. Other implementations of the EIP may not emit
272  * these events, as it isn't required by the specification.
273  *
274  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
275  * functions have been added to mitigate the well-known issues around setting
276  * allowances. See {IERC20-approve}.
277  */
278 contract ERC20 is Context, IERC20, IERC20Metadata {
279     mapping(address => uint256) private _balances;
280 
281     mapping(address => mapping(address => uint256)) private _allowances;
282 
283     uint256 private _totalSupply;
284 
285     string private _name;
286     string private _symbol;
287 
288     /**
289      * @dev Sets the values for {name} and {symbol}.
290      *
291      * The default value of {decimals} is 18. To select a different value for
292      * {decimals} you should overload it.
293      *
294      * All two of these values are immutable: they can only be set once during
295      * construction.
296      */
297     constructor(string memory name_, string memory symbol_) {
298         _name = name_;
299         _symbol = symbol_;
300     }
301 
302     /**
303      * @dev Returns the name of the token.
304      */
305     function name() public view virtual override returns (string memory) {
306         return _name;
307     }
308 
309     /**
310      * @dev Returns the symbol of the token, usually a shorter version of the
311      * name.
312      */
313     function symbol() public view virtual override returns (string memory) {
314         return _symbol;
315     }
316 
317     /**
318      * @dev Returns the number of decimals used to get its user representation.
319      * For example, if `decimals` equals `2`, a balance of `505` tokens should
320      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
321      *
322      * Tokens usually opt for a value of 18, imitating the relationship between
323      * Ether and Wei. This is the value {ERC20} uses, unless this function is
324      * overridden;
325      *
326      * NOTE: This information is only used for _display_ purposes: it in
327      * no way affects any of the arithmetic of the contract, including
328      * {IERC20-balanceOf} and {IERC20-transfer}.
329      */
330     function decimals() public view virtual override returns (uint8) {
331         return 18;
332     }
333 
334     /**
335      * @dev See {IERC20-totalSupply}.
336      */
337     function totalSupply() public view virtual override returns (uint256) {
338         return _totalSupply;
339     }
340 
341     /**
342      * @dev See {IERC20-balanceOf}.
343      */
344     function balanceOf(address account) public view virtual override returns (uint256) {
345         return _balances[account];
346     }
347 
348     /**
349      * @dev See {IERC20-transfer}.
350      *
351      * Requirements:
352      *
353      * - `recipient` cannot be the zero address.
354      * - the caller must have a balance of at least `amount`.
355      */
356     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
357         _transfer(_msgSender(), recipient, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-allowance}.
363      */
364     function allowance(address owner, address spender) public view virtual override returns (uint256) {
365         return _allowances[owner][spender];
366     }
367 
368     /**
369      * @dev See {IERC20-approve}.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      */
375     function approve(address spender, uint256 amount) public virtual override returns (bool) {
376         _approve(_msgSender(), spender, amount);
377         return true;
378     }
379 
380     /**
381      * @dev See {IERC20-transferFrom}.
382      *
383      * Emits an {Approval} event indicating the updated allowance. This is not
384      * required by the EIP. See the note at the beginning of {ERC20}.
385      *
386      * Requirements:
387      *
388      * - `sender` and `recipient` cannot be the zero address.
389      * - `sender` must have a balance of at least `amount`.
390      * - the caller must have allowance for ``sender``'s tokens of at least
391      * `amount`.
392      */
393     function transferFrom(
394         address sender,
395         address recipient,
396         uint256 amount
397     ) public virtual override returns (bool) {
398         _transfer(sender, recipient, amount);
399 
400         uint256 currentAllowance = _allowances[sender][_msgSender()];
401         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
402         unchecked {
403             _approve(sender, _msgSender(), currentAllowance - amount);
404         }
405 
406         return true;
407     }
408 
409     /**
410      * @dev Atomically increases the allowance granted to `spender` by the caller.
411      *
412      * This is an alternative to {approve} that can be used as a mitigation for
413      * problems described in {IERC20-approve}.
414      *
415      * Emits an {Approval} event indicating the updated allowance.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      */
421     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
422         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
423         return true;
424     }
425 
426     /**
427      * @dev Atomically decreases the allowance granted to `spender` by the caller.
428      *
429      * This is an alternative to {approve} that can be used as a mitigation for
430      * problems described in {IERC20-approve}.
431      *
432      * Emits an {Approval} event indicating the updated allowance.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      * - `spender` must have allowance for the caller of at least
438      * `subtractedValue`.
439      */
440     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
441         uint256 currentAllowance = _allowances[_msgSender()][spender];
442         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
443         unchecked {
444             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
445         }
446 
447         return true;
448     }
449 
450     /**
451      * @dev Moves `amount` of tokens from `sender` to `recipient`.
452      *
453      * This internal function is equivalent to {transfer}, and can be used to
454      * e.g. implement automatic token fees, slashing mechanisms, etc.
455      *
456      * Emits a {Transfer} event.
457      *
458      * Requirements:
459      *
460      * - `sender` cannot be the zero address.
461      * - `recipient` cannot be the zero address.
462      * - `sender` must have a balance of at least `amount`.
463      */
464     function _transfer(
465         address sender,
466         address recipient,
467         uint256 amount
468     ) internal virtual {
469         require(sender != address(0), "ERC20: transfer from the zero address");
470         require(recipient != address(0), "ERC20: transfer to the zero address");
471 
472         _beforeTokenTransfer(sender, recipient, amount);
473 
474         uint256 senderBalance = _balances[sender];
475         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
476         unchecked {
477             _balances[sender] = senderBalance - amount;
478         }
479         _balances[recipient] += amount;
480 
481         emit Transfer(sender, recipient, amount);
482 
483         _afterTokenTransfer(sender, recipient, amount);
484     }
485 
486     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
487      * the total supply.
488      *
489      * Emits a {Transfer} event with `from` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `account` cannot be the zero address.
494      */
495     function _mint(address account, uint256 amount) internal virtual {
496         require(account != address(0), "ERC20: mint to the zero address");
497 
498         _beforeTokenTransfer(address(0), account, amount);
499 
500         _totalSupply += amount;
501         _balances[account] += amount;
502         emit Transfer(address(0), account, amount);
503 
504         _afterTokenTransfer(address(0), account, amount);
505     }
506 
507     /**
508      * @dev Destroys `amount` tokens from `account`, reducing the
509      * total supply.
510      *
511      * Emits a {Transfer} event with `to` set to the zero address.
512      *
513      * Requirements:
514      *
515      * - `account` cannot be the zero address.
516      * - `account` must have at least `amount` tokens.
517      */
518     function _burn(address account, uint256 amount) internal virtual {
519         require(account != address(0), "ERC20: burn from the zero address");
520 
521         _beforeTokenTransfer(account, address(0), amount);
522 
523         uint256 accountBalance = _balances[account];
524         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
525         unchecked {
526             _balances[account] = accountBalance - amount;
527         }
528         _totalSupply -= amount;
529 
530         emit Transfer(account, address(0), amount);
531 
532         _afterTokenTransfer(account, address(0), amount);
533     }
534 
535     /**
536      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
537      *
538      * This internal function is equivalent to `approve`, and can be used to
539      * e.g. set automatic allowances for certain subsystems, etc.
540      *
541      * Emits an {Approval} event.
542      *
543      * Requirements:
544      *
545      * - `owner` cannot be the zero address.
546      * - `spender` cannot be the zero address.
547      */
548     function _approve(
549         address owner,
550         address spender,
551         uint256 amount
552     ) internal virtual {
553         require(owner != address(0), "ERC20: approve from the zero address");
554         require(spender != address(0), "ERC20: approve to the zero address");
555 
556         _allowances[owner][spender] = amount;
557         emit Approval(owner, spender, amount);
558     }
559 
560     /**
561      * @dev Hook that is called before any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * will be transferred to `to`.
568      * - when `from` is zero, `amount` tokens will be minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _beforeTokenTransfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal virtual {}
579 
580     /**
581      * @dev Hook that is called after any transfer of tokens. This includes
582      * minting and burning.
583      *
584      * Calling conditions:
585      *
586      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
587      * has been transferred to `to`.
588      * - when `from` is zero, `amount` tokens have been minted for `to`.
589      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
590      * - `from` and `to` are never both zero.
591      *
592      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
593      */
594     function _afterTokenTransfer(
595         address from,
596         address to,
597         uint256 amount
598     ) internal virtual {}
599 }
600 
601 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
602 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
603 
604 /* pragma solidity ^0.8.0; */
605 
606 // CAUTION
607 // This version of SafeMath should only be used with Solidity 0.8 or later,
608 // because it relies on the compiler's built in overflow checks.
609 
610 /**
611  * @dev Wrappers over Solidity's arithmetic operations.
612  *
613  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
614  * now has built in overflow checking.
615  */
616 library SafeMath {
617     /**
618      * @dev Returns the addition of two unsigned integers, with an overflow flag.
619      *
620      * _Available since v3.4._
621      */
622     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
623         unchecked {
624             uint256 c = a + b;
625             if (c < a) return (false, 0);
626             return (true, c);
627         }
628     }
629 
630     /**
631      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
632      *
633      * _Available since v3.4._
634      */
635     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
636         unchecked {
637             if (b > a) return (false, 0);
638             return (true, a - b);
639         }
640     }
641 
642     /**
643      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
644      *
645      * _Available since v3.4._
646      */
647     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
648         unchecked {
649             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
650             // benefit is lost if 'b' is also tested.
651             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
652             if (a == 0) return (true, 0);
653             uint256 c = a * b;
654             if (c / a != b) return (false, 0);
655             return (true, c);
656         }
657     }
658 
659     /**
660      * @dev Returns the division of two unsigned integers, with a division by zero flag.
661      *
662      * _Available since v3.4._
663      */
664     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
665         unchecked {
666             if (b == 0) return (false, 0);
667             return (true, a / b);
668         }
669     }
670 
671     /**
672      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
673      *
674      * _Available since v3.4._
675      */
676     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
677         unchecked {
678             if (b == 0) return (false, 0);
679             return (true, a % b);
680         }
681     }
682 
683     /**
684      * @dev Returns the addition of two unsigned integers, reverting on
685      * overflow.
686      *
687      * Counterpart to Solidity's `+` operator.
688      *
689      * Requirements:
690      *
691      * - Addition cannot overflow.
692      */
693     function add(uint256 a, uint256 b) internal pure returns (uint256) {
694         return a + b;
695     }
696 
697     /**
698      * @dev Returns the subtraction of two unsigned integers, reverting on
699      * overflow (when the result is negative).
700      *
701      * Counterpart to Solidity's `-` operator.
702      *
703      * Requirements:
704      *
705      * - Subtraction cannot overflow.
706      */
707     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
708         return a - b;
709     }
710 
711     /**
712      * @dev Returns the multiplication of two unsigned integers, reverting on
713      * overflow.
714      *
715      * Counterpart to Solidity's `*` operator.
716      *
717      * Requirements:
718      *
719      * - Multiplication cannot overflow.
720      */
721     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
722         return a * b;
723     }
724 
725     /**
726      * @dev Returns the integer division of two unsigned integers, reverting on
727      * division by zero. The result is rounded towards zero.
728      *
729      * Counterpart to Solidity's `/` operator.
730      *
731      * Requirements:
732      *
733      * - The divisor cannot be zero.
734      */
735     function div(uint256 a, uint256 b) internal pure returns (uint256) {
736         return a / b;
737     }
738 
739     /**
740      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
741      * reverting when dividing by zero.
742      *
743      * Counterpart to Solidity's `%` operator. This function uses a `revert`
744      * opcode (which leaves remaining gas untouched) while Solidity uses an
745      * invalid opcode to revert (consuming all remaining gas).
746      *
747      * Requirements:
748      *
749      * - The divisor cannot be zero.
750      */
751     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
752         return a % b;
753     }
754 
755     /**
756      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
757      * overflow (when the result is negative).
758      *
759      * CAUTION: This function is deprecated because it requires allocating memory for the error
760      * message unnecessarily. For custom revert reasons use {trySub}.
761      *
762      * Counterpart to Solidity's `-` operator.
763      *
764      * Requirements:
765      *
766      * - Subtraction cannot overflow.
767      */
768     function sub(
769         uint256 a,
770         uint256 b,
771         string memory errorMessage
772     ) internal pure returns (uint256) {
773         unchecked {
774             require(b <= a, errorMessage);
775             return a - b;
776         }
777     }
778 
779     /**
780      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
781      * division by zero. The result is rounded towards zero.
782      *
783      * Counterpart to Solidity's `/` operator. Note: this function uses a
784      * `revert` opcode (which leaves remaining gas untouched) while Solidity
785      * uses an invalid opcode to revert (consuming all remaining gas).
786      *
787      * Requirements:
788      *
789      * - The divisor cannot be zero.
790      */
791     function div(
792         uint256 a,
793         uint256 b,
794         string memory errorMessage
795     ) internal pure returns (uint256) {
796         unchecked {
797             require(b > 0, errorMessage);
798             return a / b;
799         }
800     }
801 
802     /**
803      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
804      * reverting with custom message when dividing by zero.
805      *
806      * CAUTION: This function is deprecated because it requires allocating memory for the error
807      * message unnecessarily. For custom revert reasons use {tryMod}.
808      *
809      * Counterpart to Solidity's `%` operator. This function uses a `revert`
810      * opcode (which leaves remaining gas untouched) while Solidity uses an
811      * invalid opcode to revert (consuming all remaining gas).
812      *
813      * Requirements:
814      *
815      * - The divisor cannot be zero.
816      */
817     function mod(
818         uint256 a,
819         uint256 b,
820         string memory errorMessage
821     ) internal pure returns (uint256) {
822         unchecked {
823             require(b > 0, errorMessage);
824             return a % b;
825         }
826     }
827 }
828 
829 ////// src/IUniswapV2Factory.sol
830 /* pragma solidity 0.8.10; */
831 /* pragma experimental ABIEncoderV2; */
832 
833 interface IUniswapV2Factory {
834     event PairCreated(
835         address indexed token0,
836         address indexed token1,
837         address pair,
838         uint256
839     );
840 
841     function feeTo() external view returns (address);
842 
843     function feeToSetter() external view returns (address);
844 
845     function getPair(address tokenA, address tokenB)
846         external
847         view
848         returns (address pair);
849 
850     function allPairs(uint256) external view returns (address pair);
851 
852     function allPairsLength() external view returns (uint256);
853 
854     function createPair(address tokenA, address tokenB)
855         external
856         returns (address pair);
857 
858     function setFeeTo(address) external;
859 
860     function setFeeToSetter(address) external;
861 }
862 
863 ////// src/IUniswapV2Pair.sol
864 /* pragma solidity 0.8.10; */
865 /* pragma experimental ABIEncoderV2; */
866 
867 interface IUniswapV2Pair {
868     event Approval(
869         address indexed owner,
870         address indexed spender,
871         uint256 value
872     );
873     event Transfer(address indexed from, address indexed to, uint256 value);
874 
875     function name() external pure returns (string memory);
876 
877     function symbol() external pure returns (string memory);
878 
879     function decimals() external pure returns (uint8);
880 
881     function totalSupply() external view returns (uint256);
882 
883     function balanceOf(address owner) external view returns (uint256);
884 
885     function allowance(address owner, address spender)
886         external
887         view
888         returns (uint256);
889 
890     function approve(address spender, uint256 value) external returns (bool);
891 
892     function transfer(address to, uint256 value) external returns (bool);
893 
894     function transferFrom(
895         address from,
896         address to,
897         uint256 value
898     ) external returns (bool);
899 
900     function DOMAIN_SEPARATOR() external view returns (bytes32);
901 
902     function PERMIT_TYPEHASH() external pure returns (bytes32);
903 
904     function nonces(address owner) external view returns (uint256);
905 
906     function permit(
907         address owner,
908         address spender,
909         uint256 value,
910         uint256 deadline,
911         uint8 v,
912         bytes32 r,
913         bytes32 s
914     ) external;
915 
916     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
917     event Burn(
918         address indexed sender,
919         uint256 amount0,
920         uint256 amount1,
921         address indexed to
922     );
923     event Swap(
924         address indexed sender,
925         uint256 amount0In,
926         uint256 amount1In,
927         uint256 amount0Out,
928         uint256 amount1Out,
929         address indexed to
930     );
931     event Sync(uint112 reserve0, uint112 reserve1);
932 
933     function MINIMUM_LIQUIDITY() external pure returns (uint256);
934 
935     function factory() external view returns (address);
936 
937     function token0() external view returns (address);
938 
939     function token1() external view returns (address);
940 
941     function getReserves()
942         external
943         view
944         returns (
945             uint112 reserve0,
946             uint112 reserve1,
947             uint32 blockTimestampLast
948         );
949 
950     function price0CumulativeLast() external view returns (uint256);
951 
952     function price1CumulativeLast() external view returns (uint256);
953 
954     function kLast() external view returns (uint256);
955 
956     function mint(address to) external returns (uint256 liquidity);
957 
958     function burn(address to)
959         external
960         returns (uint256 amount0, uint256 amount1);
961 
962     function swap(
963         uint256 amount0Out,
964         uint256 amount1Out,
965         address to,
966         bytes calldata data
967     ) external;
968 
969     function skim(address to) external;
970 
971     function sync() external;
972 
973     function initialize(address, address) external;
974 }
975 
976 ////// src/IUniswapV2Router02.sol
977 /* pragma solidity 0.8.10; */
978 /* pragma experimental ABIEncoderV2; */
979 
980 interface IUniswapV2Router02 {
981     function factory() external pure returns (address);
982 
983     function WETH() external pure returns (address);
984 
985     function addLiquidity(
986         address tokenA,
987         address tokenB,
988         uint256 amountADesired,
989         uint256 amountBDesired,
990         uint256 amountAMin,
991         uint256 amountBMin,
992         address to,
993         uint256 deadline
994     )
995         external
996         returns (
997             uint256 amountA,
998             uint256 amountB,
999             uint256 liquidity
1000         );
1001 
1002     function addLiquidityETH(
1003         address token,
1004         uint256 amountTokenDesired,
1005         uint256 amountTokenMin,
1006         uint256 amountETHMin,
1007         address to,
1008         uint256 deadline
1009     )
1010         external
1011         payable
1012         returns (
1013             uint256 amountToken,
1014             uint256 amountETH,
1015             uint256 liquidity
1016         );
1017 
1018     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1019         uint256 amountIn,
1020         uint256 amountOutMin,
1021         address[] calldata path,
1022         address to,
1023         uint256 deadline
1024     ) external;
1025 
1026     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1027         uint256 amountOutMin,
1028         address[] calldata path,
1029         address to,
1030         uint256 deadline
1031     ) external payable;
1032 
1033     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1034         uint256 amountIn,
1035         uint256 amountOutMin,
1036         address[] calldata path,
1037         address to,
1038         uint256 deadline
1039     ) external;
1040 }
1041 
1042 /* pragma solidity >=0.8.10; */
1043 
1044 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1045 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1046 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1047 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1048 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1049 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1050 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1051 
1052 contract BUDDY is ERC20, Ownable {
1053     using SafeMath for uint256;
1054 
1055     IUniswapV2Router02 public immutable uniswapV2Router;
1056     address public immutable uniswapV2Pair;
1057     address public constant deadAddress = address(0xdead);
1058 
1059     bool private swapping;
1060 
1061     address public marketingWallet;
1062     address public devWallet;
1063 
1064     uint256 public maxTransactionAmount;
1065     uint256 public swapTokensAtAmount;
1066     uint256 public maxWallet;
1067 
1068     uint256 public percentForLPBurn = 25; // 25 = .25%
1069     bool public lpBurnEnabled = true;
1070     uint256 public lpBurnFrequency = 3600 seconds;
1071     uint256 public lastLpBurnTime;
1072 
1073     uint256 public manualBurnFrequency = 30 minutes;
1074     uint256 public lastManualLpBurnTime;
1075 
1076     bool public limitsInEffect = true;
1077     bool public tradingActive = false;
1078     bool public swapEnabled = false;
1079 
1080     // Anti-bot and anti-whale mappings and variables
1081     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1082     bool public transferDelayEnabled = true;
1083 
1084     uint256 public buyTotalFees;
1085     uint256 public buyMarketingFee;
1086     uint256 public buyLiquidityFee;
1087     uint256 public buyDevFee;
1088 
1089     uint256 public sellTotalFees;
1090     uint256 public sellMarketingFee;
1091     uint256 public sellLiquidityFee;
1092     uint256 public sellDevFee;
1093 
1094     uint256 public tokensForMarketing;
1095     uint256 public tokensForLiquidity;
1096     uint256 public tokensForDev;
1097 
1098     /******************/
1099 
1100     // exlcude from fees and max transaction amount
1101     mapping(address => bool) private _isExcludedFromFees;
1102     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1103 
1104     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1105     // could be subject to a maximum transfer amount
1106     mapping(address => bool) public automatedMarketMakerPairs;
1107 
1108     event UpdateUniswapV2Router(
1109         address indexed newAddress,
1110         address indexed oldAddress
1111     );
1112 
1113     event ExcludeFromFees(address indexed account, bool isExcluded);
1114 
1115     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1116 
1117     event marketingWalletUpdated(
1118         address indexed newWallet,
1119         address indexed oldWallet
1120     );
1121 
1122     event devWalletUpdated(
1123         address indexed newWallet,
1124         address indexed oldWallet
1125     );
1126 
1127     event SwapAndLiquify(
1128         uint256 tokensSwapped,
1129         uint256 ethReceived,
1130         uint256 tokensIntoLiquidity
1131     );
1132 
1133     event AutoNukeLP();
1134 
1135     event ManualNukeLP();
1136 
1137     constructor() ERC20("buddy.tech", "BUDDY") {
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
1150         uint256 _buyMarketingFee = 10;
1151         uint256 _buyLiquidityFee = 0;
1152         uint256 _buyDevFee = 0;
1153 
1154         uint256 _sellMarketingFee = 40;
1155         uint256 _sellLiquidityFee = 0;
1156         uint256 _sellDevFee = 0;
1157 
1158         uint256 totalSupply = 10_000_000_000 * 1e18;
1159 
1160         maxTransactionAmount = 200_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1161         maxWallet = 200_000_000 * 1e18; // 2% from total supply maxWallet
1162         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1163 
1164         buyMarketingFee = _buyMarketingFee;
1165         buyLiquidityFee = _buyLiquidityFee;
1166         buyDevFee = _buyDevFee;
1167         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1168 
1169         sellMarketingFee = _sellMarketingFee;
1170         sellLiquidityFee = _sellLiquidityFee;
1171         sellDevFee = _sellDevFee;
1172         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1173 
1174         marketingWallet = address(0x5872F0955E21A4a6F243f8316FDA26BFD83dAf5e); // set as marketing wallet
1175         devWallet = address(0x5872F0955E21A4a6F243f8316FDA26BFD83dAf5e); // set as dev wallet
1176 
1177         // exclude from paying fees or having max transaction amount
1178         excludeFromFees(owner(), true);
1179         excludeFromFees(address(this), true);
1180         excludeFromFees(address(0xdead), true);
1181 
1182         excludeFromMaxTransaction(owner(), true);
1183         excludeFromMaxTransaction(address(this), true);
1184         excludeFromMaxTransaction(address(0xdead), true);
1185 
1186         /*
1187             _mint is an internal function in ERC20.sol that is only called here,
1188             and CANNOT be called ever again
1189         */
1190         _mint(msg.sender, totalSupply);
1191     }
1192 
1193     receive() external payable {}
1194 
1195     // once enabled, can never be turned off
1196     function enableTrading() external onlyOwner {
1197         tradingActive = true;
1198         swapEnabled = true;
1199         lastLpBurnTime = block.timestamp;
1200     }
1201 
1202     // remove limits after token is stable
1203     function removeLimits() external onlyOwner returns (bool) {
1204         limitsInEffect = false;
1205         return true;
1206     }
1207 
1208     // disable Transfer delay - cannot be reenabled
1209     function disableTransferDelay() external onlyOwner returns (bool) {
1210         transferDelayEnabled = false;
1211         return true;
1212     }
1213 
1214     // change the minimum amount of tokens to sell from fees
1215     function updateSwapTokensAtAmount(uint256 newAmount)
1216         external
1217         onlyOwner
1218         returns (bool)
1219     {
1220         require(
1221             newAmount >= (totalSupply() * 1) / 100000,
1222             "Swap amount cannot be lower than 0.001% total supply."
1223         );
1224         require(
1225             newAmount <= (totalSupply() * 5) / 1000,
1226             "Swap amount cannot be higher than 0.5% total supply."
1227         );
1228         swapTokensAtAmount = newAmount;
1229         return true;
1230     }
1231 
1232     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1233         require(
1234             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1235             "Cannot set maxTransactionAmount lower than 0.1%"
1236         );
1237         maxTransactionAmount = newNum * (10**18);
1238     }
1239 
1240     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1241         require(
1242             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1243             "Cannot set maxWallet lower than 0.5%"
1244         );
1245         maxWallet = newNum * (10**18);
1246     }
1247 
1248     function excludeFromMaxTransaction(address updAds, bool isEx)
1249         public
1250         onlyOwner
1251     {
1252         _isExcludedMaxTransactionAmount[updAds] = isEx;
1253     }
1254 
1255     // only use to disable contract sales if absolutely necessary (emergency use only)
1256     function updateSwapEnabled(bool enabled) external onlyOwner {
1257         swapEnabled = enabled;
1258     }
1259 
1260     function updateBuyFees(
1261         uint256 _marketingFee,
1262         uint256 _liquidityFee,
1263         uint256 _devFee
1264     ) external onlyOwner {
1265         buyMarketingFee = _marketingFee;
1266         buyLiquidityFee = _liquidityFee;
1267         buyDevFee = _devFee;
1268         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1269         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
1270     }
1271 
1272     function updateSellFees(
1273         uint256 _marketingFee,
1274         uint256 _liquidityFee,
1275         uint256 _devFee
1276     ) external onlyOwner {
1277         sellMarketingFee = _marketingFee;
1278         sellLiquidityFee = _liquidityFee;
1279         sellDevFee = _devFee;
1280         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1281         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
1282     }
1283 
1284     function excludeFromFees(address account, bool excluded) public onlyOwner {
1285         _isExcludedFromFees[account] = excluded;
1286         emit ExcludeFromFees(account, excluded);
1287     }
1288 
1289     function setAutomatedMarketMakerPair(address pair, bool value)
1290         public
1291         onlyOwner
1292     {
1293         require(
1294             pair != uniswapV2Pair,
1295             "The pair cannot be removed from automatedMarketMakerPairs"
1296         );
1297 
1298         _setAutomatedMarketMakerPair(pair, value);
1299     }
1300 
1301     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1302         automatedMarketMakerPairs[pair] = value;
1303 
1304         emit SetAutomatedMarketMakerPair(pair, value);
1305     }
1306 
1307     function updateMarketingWallet(address newMarketingWallet)
1308         external
1309         onlyOwner
1310     {
1311         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1312         marketingWallet = newMarketingWallet;
1313     }
1314 
1315     function updateDevWallet(address newWallet) external onlyOwner {
1316         emit devWalletUpdated(newWallet, devWallet);
1317         devWallet = newWallet;
1318     }
1319 
1320     function isExcludedFromFees(address account) public view returns (bool) {
1321         return _isExcludedFromFees[account];
1322     }
1323 
1324     event BoughtEarly(address indexed sniper);
1325 
1326     function _transfer(
1327         address from,
1328         address to,
1329         uint256 amount
1330     ) internal override {
1331         require(from != address(0), "ERC20: transfer from the zero address");
1332         require(to != address(0), "ERC20: transfer to the zero address");
1333 
1334         if (amount == 0) {
1335             super._transfer(from, to, 0);
1336             return;
1337         }
1338 
1339         if (limitsInEffect) {
1340             if (
1341                 from != owner() &&
1342                 to != owner() &&
1343                 to != address(0) &&
1344                 to != address(0xdead) &&
1345                 !swapping
1346             ) {
1347                 if (!tradingActive) {
1348                     require(
1349                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1350                         "Trading is not active."
1351                     );
1352                 }
1353 
1354                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1355                 if (transferDelayEnabled) {
1356                     if (
1357                         to != owner() &&
1358                         to != address(uniswapV2Router) &&
1359                         to != address(uniswapV2Pair)
1360                     ) {
1361                         require(
1362                             _holderLastTransferTimestamp[tx.origin] <
1363                                 block.number,
1364                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1365                         );
1366                         _holderLastTransferTimestamp[tx.origin] = block.number;
1367                     }
1368                 }
1369 
1370                 //when buy
1371                 if (
1372                     automatedMarketMakerPairs[from] &&
1373                     !_isExcludedMaxTransactionAmount[to]
1374                 ) {
1375                     require(
1376                         amount <= maxTransactionAmount,
1377                         "Buy transfer amount exceeds the maxTransactionAmount."
1378                     );
1379                     require(
1380                         amount + balanceOf(to) <= maxWallet,
1381                         "Max wallet exceeded"
1382                     );
1383                 }
1384                 //when sell
1385                 else if (
1386                     automatedMarketMakerPairs[to] &&
1387                     !_isExcludedMaxTransactionAmount[from]
1388                 ) {
1389                     require(
1390                         amount <= maxTransactionAmount,
1391                         "Sell transfer amount exceeds the maxTransactionAmount."
1392                     );
1393                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1394                     require(
1395                         amount + balanceOf(to) <= maxWallet,
1396                         "Max wallet exceeded"
1397                     );
1398                 }
1399             }
1400         }
1401 
1402         uint256 contractTokenBalance = balanceOf(address(this));
1403 
1404         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1405 
1406         if (
1407             canSwap &&
1408             swapEnabled &&
1409             !swapping &&
1410             !automatedMarketMakerPairs[from] &&
1411             !_isExcludedFromFees[from] &&
1412             !_isExcludedFromFees[to]
1413         ) {
1414             swapping = true;
1415 
1416             swapBack();
1417 
1418             swapping = false;
1419         }
1420 
1421         if (
1422             !swapping &&
1423             automatedMarketMakerPairs[to] &&
1424             lpBurnEnabled &&
1425             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1426             !_isExcludedFromFees[from]
1427         ) {
1428             autoBurnLiquidityPairTokens();
1429         }
1430 
1431         bool takeFee = !swapping;
1432 
1433         // if any account belongs to _isExcludedFromFee account then remove the fee
1434         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1435             takeFee = false;
1436         }
1437 
1438         uint256 fees = 0;
1439         // only take fees on buys/sells, do not take on wallet transfers
1440         if (takeFee) {
1441             // on sell
1442             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1443                 fees = amount.mul(sellTotalFees).div(100);
1444                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1445                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1446                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1447             }
1448             // on buy
1449             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1450                 fees = amount.mul(buyTotalFees).div(100);
1451                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1452                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1453                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1454             }
1455 
1456             if (fees > 0) {
1457                 super._transfer(from, address(this), fees);
1458             }
1459 
1460             amount -= fees;
1461         }
1462 
1463         super._transfer(from, to, amount);
1464     }
1465 
1466     function swapTokensForEth(uint256 tokenAmount) private {
1467         // generate the uniswap pair path of token -> weth
1468         address[] memory path = new address[](2);
1469         path[0] = address(this);
1470         path[1] = uniswapV2Router.WETH();
1471 
1472         _approve(address(this), address(uniswapV2Router), tokenAmount);
1473 
1474         // make the swap
1475         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1476             tokenAmount,
1477             0, // accept any amount of ETH
1478             path,
1479             address(this),
1480             block.timestamp
1481         );
1482     }
1483 
1484     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1485         // approve token transfer to cover all possible scenarios
1486         _approve(address(this), address(uniswapV2Router), tokenAmount);
1487 
1488         // add the liquidity
1489         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1490             address(this),
1491             tokenAmount,
1492             0, // slippage is unavoidable
1493             0, // slippage is unavoidable
1494             deadAddress,
1495             block.timestamp
1496         );
1497     }
1498 
1499     function swapBack() private {
1500         uint256 contractBalance = balanceOf(address(this));
1501         uint256 totalTokensToSwap = tokensForLiquidity +
1502             tokensForMarketing +
1503             tokensForDev;
1504         bool success;
1505 
1506         if (contractBalance == 0 || totalTokensToSwap == 0) {
1507             return;
1508         }
1509 
1510         if (contractBalance > swapTokensAtAmount * 20) {
1511             contractBalance = swapTokensAtAmount * 20;
1512         }
1513 
1514         // Halve the amount of liquidity tokens
1515         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1516             totalTokensToSwap /
1517             2;
1518         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1519 
1520         uint256 initialETHBalance = address(this).balance;
1521 
1522         swapTokensForEth(amountToSwapForETH);
1523 
1524         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1525 
1526         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1527             totalTokensToSwap
1528         );
1529         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1530 
1531         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1532 
1533         tokensForLiquidity = 0;
1534         tokensForMarketing = 0;
1535         tokensForDev = 0;
1536 
1537         (success, ) = address(devWallet).call{value: ethForDev}("");
1538 
1539         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1540             addLiquidity(liquidityTokens, ethForLiquidity);
1541             emit SwapAndLiquify(
1542                 amountToSwapForETH,
1543                 ethForLiquidity,
1544                 tokensForLiquidity
1545             );
1546         }
1547 
1548         (success, ) = address(marketingWallet).call{
1549             value: address(this).balance
1550         }("");
1551     }
1552 
1553     function setAutoLPBurnSettings(
1554         uint256 _frequencyInSeconds,
1555         uint256 _percent,
1556         bool _Enabled
1557     ) external onlyOwner {
1558         require(
1559             _frequencyInSeconds >= 600,
1560             "cannot set buyback more often than every 10 minutes"
1561         );
1562         require(
1563             _percent <= 1000 && _percent >= 0,
1564             "Must set auto LP burn percent between 0% and 10%"
1565         );
1566         lpBurnFrequency = _frequencyInSeconds;
1567         percentForLPBurn = _percent;
1568         lpBurnEnabled = _Enabled;
1569     }
1570 
1571     function autoBurnLiquidityPairTokens() internal returns (bool) {
1572         lastLpBurnTime = block.timestamp;
1573 
1574         // get balance of liquidity pair
1575         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1576 
1577         // calculate amount to burn
1578         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1579             10000
1580         );
1581 
1582         // pull tokens from pancakePair liquidity and move to dead address permanently
1583         if (amountToBurn > 0) {
1584             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1585         }
1586 
1587         //sync price since this is not in a swap transaction!
1588         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1589         pair.sync();
1590         emit AutoNukeLP();
1591         return true;
1592     }
1593 
1594     function manualBurnLiquidityPairTokens(uint256 percent)
1595         external
1596         onlyOwner
1597         returns (bool)
1598     {
1599         require(
1600             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1601             "Must wait for cooldown to finish"
1602         );
1603         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1604         lastManualLpBurnTime = block.timestamp;
1605 
1606         // get balance of liquidity pair
1607         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1608 
1609         // calculate amount to burn
1610         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1611 
1612         // pull tokens from pancakePair liquidity and move to dead address permanently
1613         if (amountToBurn > 0) {
1614             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1615         }
1616 
1617         //sync price since this is not in a swap transaction!
1618         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1619         pair.sync();
1620         emit ManualNukeLP();
1621         return true;
1622     }
1623 }