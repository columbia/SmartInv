1 /* 
2 Anole has finally found a friend, the well-known Shiba.
3 
4 Anole had been trying to make friends with Shiba for a while but Shiba was proving too arrogant to respond.
5 That was until Anole brought him a present. He brought Shiba a shiny bitcoin. That was the beginning of a beautiful friendship.
6 They laugh together, hang together, trade together and as best friends do, sometimes fight together.
7 
8 Their friendship was real and with every coming day became stronger.
9 
10 One day Shiba got into trouble with several dogs, among them was Doge, Corgi, Yuki and Kishu.
11 To be able to fight them and beat them once and for all he needed all his power, but how will he be able to find it?
12 
13 Anole came up with a solution but he knew Shiba was not going to like it.
14 He went to see Shiba and started to explain "Shiba, to defeat these dogs you need more strength,
15 I am not a ordinary Anole, inside of me are superpowers which you cannot fantom, but to gain this you have to eat me."
16 
17 "WHAT!?" said Shiba, he couldn't believe that his friend would say that, how could he eat his best friend? He turned around and walked away.
18 But on his way he ran into the group of dogs and received a tremendous beating, all bruised up he walked back home and went to sleep.
19 Anole heard what happened to him and went to see his friend to check how he was doing, he saw Shiba was in a really bad shape and had taken a heavy beating.
20 He decided to do what was right, not for himself but for Shiba, his life couldn't continue like this. So Anole crawled into his mouth.
21 
22 https://t.me/AnoleINU
23 https://anoleinu.com
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
45 
46 abstract contract Context {
47     function _msgSender() internal view virtual returns (address) {
48         return msg.sender;
49     }
50 
51     function _msgData() internal view virtual returns (bytes calldata) {
52         return msg.data;
53     }
54 }
55 
56 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
57 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
58 
59 /* pragma solidity ^0.8.0; */
60 
61 /* import "../utils/Context.sol"; */
62 
63 /**
64  * @dev Contract module which provides a basic access control mechanism, where
65  * there is an account (an owner) that can be granted exclusive access to
66  * specific functions.
67  *
68  * By default, the owner account will be the one that deploys the contract. This
69  * can later be changed with {transferOwnership}.
70  *
71  * This module is used through inheritance. It will make available the modifier
72  * `onlyOwner`, which can be applied to your functions to restrict their use to
73  * the owner.
74  */
75 abstract contract Ownable is Context {
76     address private _owner;
77 
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     /**
81      * @dev Initializes the contract setting the deployer as the initial owner.
82      */
83     constructor() {
84         _transferOwnership(_msgSender());
85     }
86 
87     /**
88      * @dev Returns the address of the current owner.
89      */
90     function owner() public view virtual returns (address) {
91         return _owner;
92     }
93 
94     /**
95      * @dev Throws if called by any account other than the owner.
96      */
97     modifier onlyOwner() {
98         require(owner() == _msgSender(), "Ownable: caller is not the owner");
99         _;
100     }
101 
102     /**
103      * @dev Leaves the contract without owner. It will not be possible to call
104      * `onlyOwner` functions anymore. Can only be called by the current owner.
105      *
106      * NOTE: Renouncing ownership will leave the contract without an owner,
107      * thereby removing any functionality that is only available to the owner.
108      */
109     function renounceOwnership() public virtual onlyOwner {
110         _transferOwnership(address(0));
111     }
112 
113     /**
114      * @dev Transfers ownership of the contract to a new account (`newOwner`).
115      * Can only be called by the current owner.
116      */
117     function transferOwnership(address newOwner) public virtual onlyOwner {
118         require(newOwner != address(0), "Ownable: new owner is the zero address");
119         _transferOwnership(newOwner);
120     }
121 
122     /**
123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
124      * Internal function without access restriction.
125      */
126     function _transferOwnership(address newOwner) internal virtual {
127         address oldOwner = _owner;
128         _owner = newOwner;
129         emit OwnershipTransferred(oldOwner, newOwner);
130     }
131 }
132 
133 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
134 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
135 
136 /* pragma solidity ^0.8.0; */
137 
138 /**
139  * @dev Interface of the ERC20 standard as defined in the EIP.
140  */
141 interface IERC20 {
142     /**
143      * @dev Returns the amount of tokens in existence.
144      */
145     function totalSupply() external view returns (uint256);
146 
147     /**
148      * @dev Returns the amount of tokens owned by `account`.
149      */
150     function balanceOf(address account) external view returns (uint256);
151 
152     /**
153      * @dev Moves `amount` tokens from the caller's account to `recipient`.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transfer(address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Returns the remaining number of tokens that `spender` will be
163      * allowed to spend on behalf of `owner` through {transferFrom}. This is
164      * zero by default.
165      *
166      * This value changes when {approve} or {transferFrom} are called.
167      */
168     function allowance(address owner, address spender) external view returns (uint256);
169 
170     /**
171      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * IMPORTANT: Beware that changing an allowance with this method brings the risk
176      * that someone may use both the old and the new allowance by unfortunate
177      * transaction ordering. One possible solution to mitigate this race
178      * condition is to first reduce the spender's allowance to 0 and set the
179      * desired value afterwards:
180      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181      *
182      * Emits an {Approval} event.
183      */
184     function approve(address spender, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Moves `amount` tokens from `sender` to `recipient` using the
188      * allowance mechanism. `amount` is then deducted from the caller's
189      * allowance.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address sender,
197         address recipient,
198         uint256 amount
199     ) external returns (bool);
200 
201     /**
202      * @dev Emitted when `value` tokens are moved from one account (`from`) to
203      * another (`to`).
204      *
205      * Note that `value` may be zero.
206      */
207     event Transfer(address indexed from, address indexed to, uint256 value);
208 
209     /**
210      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
211      * a call to {approve}. `value` is the new allowance.
212      */
213     event Approval(address indexed owner, address indexed spender, uint256 value);
214 }
215 
216 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
217 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
218 
219 /* pragma solidity ^0.8.0; */
220 
221 /* import "../IERC20.sol"; */
222 
223 /**
224  * @dev Interface for the optional metadata functions from the ERC20 standard.
225  *
226  * _Available since v4.1._
227  */
228 interface IERC20Metadata is IERC20 {
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() external view returns (string memory);
233 
234     /**
235      * @dev Returns the symbol of the token.
236      */
237     function symbol() external view returns (string memory);
238 
239     /**
240      * @dev Returns the decimals places of the token.
241      */
242     function decimals() external view returns (uint8);
243 }
244 
245 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
246 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
247 
248 /* pragma solidity ^0.8.0; */
249 
250 /* import "./IERC20.sol"; */
251 /* import "./extensions/IERC20Metadata.sol"; */
252 /* import "../../utils/Context.sol"; */
253 
254 /**
255  * @dev Implementation of the {IERC20} interface.
256  *
257  * This implementation is agnostic to the way tokens are created. This means
258  * that a supply mechanism has to be added in a derived contract using {_mint}.
259  * For a generic mechanism see {ERC20PresetMinterPauser}.
260  *
261  * TIP: For a detailed writeup see our guide
262  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
263  * to implement supply mechanisms].
264  *
265  * We have followed general OpenZeppelin Contracts guidelines: functions revert
266  * instead returning `false` on failure. This behavior is nonetheless
267  * conventional and does not conflict with the expectations of ERC20
268  * applications.
269  *
270  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
271  * This allows applications to reconstruct the allowance for all accounts just
272  * by listening to said events. Other implementations of the EIP may not emit
273  * these events, as it isn't required by the specification.
274  *
275  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
276  * functions have been added to mitigate the well-known issues around setting
277  * allowances. See {IERC20-approve}.
278  */
279 contract ERC20 is Context, IERC20, IERC20Metadata {
280     mapping(address => uint256) private _balances;
281 
282     mapping(address => mapping(address => uint256)) private _allowances;
283 
284     uint256 private _totalSupply;
285 
286     string private _name;
287     string private _symbol;
288 
289     /**
290      * @dev Sets the values for {name} and {symbol}.
291      *
292      * The default value of {decimals} is 18. To select a different value for
293      * {decimals} you should overload it.
294      *
295      * All two of these values are immutable: they can only be set once during
296      * construction.
297      */
298     constructor(string memory name_, string memory symbol_) {
299         _name = name_;
300         _symbol = symbol_;
301     }
302 
303     /**
304      * @dev Returns the name of the token.
305      */
306     function name() public view virtual override returns (string memory) {
307         return _name;
308     }
309 
310     /**
311      * @dev Returns the symbol of the token, usually a shorter version of the
312      * name.
313      */
314     function symbol() public view virtual override returns (string memory) {
315         return _symbol;
316     }
317 
318     /**
319      * @dev Returns the number of decimals used to get its user representation.
320      * For example, if `decimals` equals `2`, a balance of `505` tokens should
321      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
322      *
323      * Tokens usually opt for a value of 18, imitating the relationship between
324      * Ether and Wei. This is the value {ERC20} uses, unless this function is
325      * overridden;
326      *
327      * NOTE: This information is only used for _display_ purposes: it in
328      * no way affects any of the arithmetic of the contract, including
329      * {IERC20-balanceOf} and {IERC20-transfer}.
330      */
331     function decimals() public view virtual override returns (uint8) {
332         return 18;
333     }
334 
335     /**
336      * @dev See {IERC20-totalSupply}.
337      */
338     function totalSupply() public view virtual override returns (uint256) {
339         return _totalSupply;
340     }
341 
342     /**
343      * @dev See {IERC20-balanceOf}.
344      */
345     function balanceOf(address account) public view virtual override returns (uint256) {
346         return _balances[account];
347     }
348 
349     /**
350      * @dev See {IERC20-transfer}.
351      *
352      * Requirements:
353      *
354      * - `recipient` cannot be the zero address.
355      * - the caller must have a balance of at least `amount`.
356      */
357     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
358         _transfer(_msgSender(), recipient, amount);
359         return true;
360     }
361 
362     /**
363      * @dev See {IERC20-allowance}.
364      */
365     function allowance(address owner, address spender) public view virtual override returns (uint256) {
366         return _allowances[owner][spender];
367     }
368 
369     /**
370      * @dev See {IERC20-approve}.
371      *
372      * Requirements:
373      *
374      * - `spender` cannot be the zero address.
375      */
376     function approve(address spender, uint256 amount) public virtual override returns (bool) {
377         _approve(_msgSender(), spender, amount);
378         return true;
379     }
380 
381     /**
382      * @dev See {IERC20-transferFrom}.
383      *
384      * Emits an {Approval} event indicating the updated allowance. This is not
385      * required by the EIP. See the note at the beginning of {ERC20}.
386      *
387      * Requirements:
388      *
389      * - `sender` and `recipient` cannot be the zero address.
390      * - `sender` must have a balance of at least `amount`.
391      * - the caller must have allowance for ``sender``'s tokens of at least
392      * `amount`.
393      */
394     function transferFrom(
395         address sender,
396         address recipient,
397         uint256 amount
398     ) public virtual override returns (bool) {
399         _transfer(sender, recipient, amount);
400 
401         uint256 currentAllowance = _allowances[sender][_msgSender()];
402         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
403         unchecked {
404             _approve(sender, _msgSender(), currentAllowance - amount);
405         }
406 
407         return true;
408     }
409 
410     /**
411      * @dev Atomically increases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      */
422     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
423         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
424         return true;
425     }
426 
427     /**
428      * @dev Atomically decreases the allowance granted to `spender` by the caller.
429      *
430      * This is an alternative to {approve} that can be used as a mitigation for
431      * problems described in {IERC20-approve}.
432      *
433      * Emits an {Approval} event indicating the updated allowance.
434      *
435      * Requirements:
436      *
437      * - `spender` cannot be the zero address.
438      * - `spender` must have allowance for the caller of at least
439      * `subtractedValue`.
440      */
441     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
442         uint256 currentAllowance = _allowances[_msgSender()][spender];
443         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
444         unchecked {
445             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
446         }
447 
448         return true;
449     }
450 
451     /**
452      * @dev Moves `amount` of tokens from `sender` to `recipient`.
453      *
454      * This internal function is equivalent to {transfer}, and can be used to
455      * e.g. implement automatic token fees, slashing mechanisms, etc.
456      *
457      * Emits a {Transfer} event.
458      *
459      * Requirements:
460      *
461      * - `sender` cannot be the zero address.
462      * - `recipient` cannot be the zero address.
463      * - `sender` must have a balance of at least `amount`.
464      */
465     function _transfer(
466         address sender,
467         address recipient,
468         uint256 amount
469     ) internal virtual {
470         require(sender != address(0), "ERC20: transfer from the zero address");
471         require(recipient != address(0), "ERC20: transfer to the zero address");
472 
473         _beforeTokenTransfer(sender, recipient, amount);
474 
475         uint256 senderBalance = _balances[sender];
476         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
477         unchecked {
478             _balances[sender] = senderBalance - amount;
479         }
480         _balances[recipient] += amount;
481 
482         emit Transfer(sender, recipient, amount);
483 
484         _afterTokenTransfer(sender, recipient, amount);
485     }
486 
487     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
488      * the total supply.
489      *
490      * Emits a {Transfer} event with `from` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      */
496     function _mint(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: mint to the zero address");
498 
499         _beforeTokenTransfer(address(0), account, amount);
500 
501         _totalSupply += amount;
502         _balances[account] += amount;
503         emit Transfer(address(0), account, amount);
504 
505         _afterTokenTransfer(address(0), account, amount);
506     }
507 
508     /**
509      * @dev Destroys `amount` tokens from `account`, reducing the
510      * total supply.
511      *
512      * Emits a {Transfer} event with `to` set to the zero address.
513      *
514      * Requirements:
515      *
516      * - `account` cannot be the zero address.
517      * - `account` must have at least `amount` tokens.
518      */
519     function _burn(address account, uint256 amount) internal virtual {
520         require(account != address(0), "ERC20: burn from the zero address");
521 
522         _beforeTokenTransfer(account, address(0), amount);
523 
524         uint256 accountBalance = _balances[account];
525         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
526         unchecked {
527             _balances[account] = accountBalance - amount;
528         }
529         _totalSupply -= amount;
530 
531         emit Transfer(account, address(0), amount);
532 
533         _afterTokenTransfer(account, address(0), amount);
534     }
535 
536     /**
537      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
538      *
539      * This internal function is equivalent to `approve`, and can be used to
540      * e.g. set automatic allowances for certain subsystems, etc.
541      *
542      * Emits an {Approval} event.
543      *
544      * Requirements:
545      *
546      * - `owner` cannot be the zero address.
547      * - `spender` cannot be the zero address.
548      */
549     function _approve(
550         address owner,
551         address spender,
552         uint256 amount
553     ) internal virtual {
554         require(owner != address(0), "ERC20: approve from the zero address");
555         require(spender != address(0), "ERC20: approve to the zero address");
556 
557         _allowances[owner][spender] = amount;
558         emit Approval(owner, spender, amount);
559     }
560 
561     /**
562      * @dev Hook that is called before any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * will be transferred to `to`.
569      * - when `from` is zero, `amount` tokens will be minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _beforeTokenTransfer(
576         address from,
577         address to,
578         uint256 amount
579     ) internal virtual {}
580 
581     /**
582      * @dev Hook that is called after any transfer of tokens. This includes
583      * minting and burning.
584      *
585      * Calling conditions:
586      *
587      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
588      * has been transferred to `to`.
589      * - when `from` is zero, `amount` tokens have been minted for `to`.
590      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
591      * - `from` and `to` are never both zero.
592      *
593      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
594      */
595     function _afterTokenTransfer(
596         address from,
597         address to,
598         uint256 amount
599     ) internal virtual {}
600 }
601 
602 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
603 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
604 
605 /* pragma solidity ^0.8.0; */
606 
607 // CAUTION
608 // This version of SafeMath should only be used with Solidity 0.8 or later,
609 // because it relies on the compiler's built in overflow checks.
610 
611 /**
612  * @dev Wrappers over Solidity's arithmetic operations.
613  *
614  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
615  * now has built in overflow checking.
616  */
617 library SafeMath {
618     /**
619      * @dev Returns the addition of two unsigned integers, with an overflow flag.
620      *
621      * _Available since v3.4._
622      */
623     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
624         unchecked {
625             uint256 c = a + b;
626             if (c < a) return (false, 0);
627             return (true, c);
628         }
629     }
630 
631     /**
632      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
633      *
634      * _Available since v3.4._
635      */
636     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
637         unchecked {
638             if (b > a) return (false, 0);
639             return (true, a - b);
640         }
641     }
642 
643     /**
644      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
645      *
646      * _Available since v3.4._
647      */
648     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
649         unchecked {
650             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
651             // benefit is lost if 'b' is also tested.
652             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
653             if (a == 0) return (true, 0);
654             uint256 c = a * b;
655             if (c / a != b) return (false, 0);
656             return (true, c);
657         }
658     }
659 
660     /**
661      * @dev Returns the division of two unsigned integers, with a division by zero flag.
662      *
663      * _Available since v3.4._
664      */
665     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
666         unchecked {
667             if (b == 0) return (false, 0);
668             return (true, a / b);
669         }
670     }
671 
672     /**
673      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
674      *
675      * _Available since v3.4._
676      */
677     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
678         unchecked {
679             if (b == 0) return (false, 0);
680             return (true, a % b);
681         }
682     }
683 
684     /**
685      * @dev Returns the addition of two unsigned integers, reverting on
686      * overflow.
687      *
688      * Counterpart to Solidity's `+` operator.
689      *
690      * Requirements:
691      *
692      * - Addition cannot overflow.
693      */
694     function add(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a + b;
696     }
697 
698     /**
699      * @dev Returns the subtraction of two unsigned integers, reverting on
700      * overflow (when the result is negative).
701      *
702      * Counterpart to Solidity's `-` operator.
703      *
704      * Requirements:
705      *
706      * - Subtraction cannot overflow.
707      */
708     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
709         return a - b;
710     }
711 
712     /**
713      * @dev Returns the multiplication of two unsigned integers, reverting on
714      * overflow.
715      *
716      * Counterpart to Solidity's `*` operator.
717      *
718      * Requirements:
719      *
720      * - Multiplication cannot overflow.
721      */
722     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
723         return a * b;
724     }
725 
726     /**
727      * @dev Returns the integer division of two unsigned integers, reverting on
728      * division by zero. The result is rounded towards zero.
729      *
730      * Counterpart to Solidity's `/` operator.
731      *
732      * Requirements:
733      *
734      * - The divisor cannot be zero.
735      */
736     function div(uint256 a, uint256 b) internal pure returns (uint256) {
737         return a / b;
738     }
739 
740     /**
741      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
742      * reverting when dividing by zero.
743      *
744      * Counterpart to Solidity's `%` operator. This function uses a `revert`
745      * opcode (which leaves remaining gas untouched) while Solidity uses an
746      * invalid opcode to revert (consuming all remaining gas).
747      *
748      * Requirements:
749      *
750      * - The divisor cannot be zero.
751      */
752     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
753         return a % b;
754     }
755 
756     /**
757      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
758      * overflow (when the result is negative).
759      *
760      * CAUTION: This function is deprecated because it requires allocating memory for the error
761      * message unnecessarily. For custom revert reasons use {trySub}.
762      *
763      * Counterpart to Solidity's `-` operator.
764      *
765      * Requirements:
766      *
767      * - Subtraction cannot overflow.
768      */
769     function sub(
770         uint256 a,
771         uint256 b,
772         string memory errorMessage
773     ) internal pure returns (uint256) {
774         unchecked {
775             require(b <= a, errorMessage);
776             return a - b;
777         }
778     }
779 
780     /**
781      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
782      * division by zero. The result is rounded towards zero.
783      *
784      * Counterpart to Solidity's `/` operator. Note: this function uses a
785      * `revert` opcode (which leaves remaining gas untouched) while Solidity
786      * uses an invalid opcode to revert (consuming all remaining gas).
787      *
788      * Requirements:
789      *
790      * - The divisor cannot be zero.
791      */
792     function div(
793         uint256 a,
794         uint256 b,
795         string memory errorMessage
796     ) internal pure returns (uint256) {
797         unchecked {
798             require(b > 0, errorMessage);
799             return a / b;
800         }
801     }
802 
803     /**
804      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
805      * reverting with custom message when dividing by zero.
806      *
807      * CAUTION: This function is deprecated because it requires allocating memory for the error
808      * message unnecessarily. For custom revert reasons use {tryMod}.
809      *
810      * Counterpart to Solidity's `%` operator. This function uses a `revert`
811      * opcode (which leaves remaining gas untouched) while Solidity uses an
812      * invalid opcode to revert (consuming all remaining gas).
813      *
814      * Requirements:
815      *
816      * - The divisor cannot be zero.
817      */
818     function mod(
819         uint256 a,
820         uint256 b,
821         string memory errorMessage
822     ) internal pure returns (uint256) {
823         unchecked {
824             require(b > 0, errorMessage);
825             return a % b;
826         }
827     }
828 }
829 
830 ////// src/IUniswapV2Factory.sol
831 /* pragma solidity 0.8.10; */
832 /* pragma experimental ABIEncoderV2; */
833 
834 interface IUniswapV2Factory {
835     event PairCreated(
836         address indexed token0,
837         address indexed token1,
838         address pair,
839         uint256
840     );
841 
842     function feeTo() external view returns (address);
843 
844     function feeToSetter() external view returns (address);
845 
846     function getPair(address tokenA, address tokenB)
847         external
848         view
849         returns (address pair);
850 
851     function allPairs(uint256) external view returns (address pair);
852 
853     function allPairsLength() external view returns (uint256);
854 
855     function createPair(address tokenA, address tokenB)
856         external
857         returns (address pair);
858 
859     function setFeeTo(address) external;
860 
861     function setFeeToSetter(address) external;
862 }
863 
864 ////// src/IUniswapV2Pair.sol
865 /* pragma solidity 0.8.10; */
866 /* pragma experimental ABIEncoderV2; */
867 
868 interface IUniswapV2Pair {
869     event Approval(
870         address indexed owner,
871         address indexed spender,
872         uint256 value
873     );
874     event Transfer(address indexed from, address indexed to, uint256 value);
875 
876     function name() external pure returns (string memory);
877 
878     function symbol() external pure returns (string memory);
879 
880     function decimals() external pure returns (uint8);
881 
882     function totalSupply() external view returns (uint256);
883 
884     function balanceOf(address owner) external view returns (uint256);
885 
886     function allowance(address owner, address spender)
887         external
888         view
889         returns (uint256);
890 
891     function approve(address spender, uint256 value) external returns (bool);
892 
893     function transfer(address to, uint256 value) external returns (bool);
894 
895     function transferFrom(
896         address from,
897         address to,
898         uint256 value
899     ) external returns (bool);
900 
901     function DOMAIN_SEPARATOR() external view returns (bytes32);
902 
903     function PERMIT_TYPEHASH() external pure returns (bytes32);
904 
905     function nonces(address owner) external view returns (uint256);
906 
907     function permit(
908         address owner,
909         address spender,
910         uint256 value,
911         uint256 deadline,
912         uint8 v,
913         bytes32 r,
914         bytes32 s
915     ) external;
916 
917     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
918     event Burn(
919         address indexed sender,
920         uint256 amount0,
921         uint256 amount1,
922         address indexed to
923     );
924     event Swap(
925         address indexed sender,
926         uint256 amount0In,
927         uint256 amount1In,
928         uint256 amount0Out,
929         uint256 amount1Out,
930         address indexed to
931     );
932     event Sync(uint112 reserve0, uint112 reserve1);
933 
934     function MINIMUM_LIQUIDITY() external pure returns (uint256);
935 
936     function factory() external view returns (address);
937 
938     function token0() external view returns (address);
939 
940     function token1() external view returns (address);
941 
942     function getReserves()
943         external
944         view
945         returns (
946             uint112 reserve0,
947             uint112 reserve1,
948             uint32 blockTimestampLast
949         );
950 
951     function price0CumulativeLast() external view returns (uint256);
952 
953     function price1CumulativeLast() external view returns (uint256);
954 
955     function kLast() external view returns (uint256);
956 
957     function mint(address to) external returns (uint256 liquidity);
958 
959     function burn(address to)
960         external
961         returns (uint256 amount0, uint256 amount1);
962 
963     function swap(
964         uint256 amount0Out,
965         uint256 amount1Out,
966         address to,
967         bytes calldata data
968     ) external;
969 
970     function skim(address to) external;
971 
972     function sync() external;
973 
974     function initialize(address, address) external;
975 }
976 
977 ////// src/IUniswapV2Router02.sol
978 /* pragma solidity 0.8.10; */
979 /* pragma experimental ABIEncoderV2; */
980 
981 interface IUniswapV2Router02 {
982     function factory() external pure returns (address);
983 
984     function WETH() external pure returns (address);
985 
986     function addLiquidity(
987         address tokenA,
988         address tokenB,
989         uint256 amountADesired,
990         uint256 amountBDesired,
991         uint256 amountAMin,
992         uint256 amountBMin,
993         address to,
994         uint256 deadline
995     )
996         external
997         returns (
998             uint256 amountA,
999             uint256 amountB,
1000             uint256 liquidity
1001         );
1002 
1003     function addLiquidityETH(
1004         address token,
1005         uint256 amountTokenDesired,
1006         uint256 amountTokenMin,
1007         uint256 amountETHMin,
1008         address to,
1009         uint256 deadline
1010     )
1011         external
1012         payable
1013         returns (
1014             uint256 amountToken,
1015             uint256 amountETH,
1016             uint256 liquidity
1017         );
1018 
1019     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1020         uint256 amountIn,
1021         uint256 amountOutMin,
1022         address[] calldata path,
1023         address to,
1024         uint256 deadline
1025     ) external;
1026 
1027     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1028         uint256 amountOutMin,
1029         address[] calldata path,
1030         address to,
1031         uint256 deadline
1032     ) external payable;
1033 
1034     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1035         uint256 amountIn,
1036         uint256 amountOutMin,
1037         address[] calldata path,
1038         address to,
1039         uint256 deadline
1040     ) external;
1041 }
1042 
1043 /* pragma solidity >=0.8.10; */
1044 
1045 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1046 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1047 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1048 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1049 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1050 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1051 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1052 
1053 contract ANOLEINU is ERC20, Ownable {
1054     using SafeMath for uint256;
1055 
1056     IUniswapV2Router02 public immutable uniswapV2Router;
1057     address public immutable uniswapV2Pair;
1058     address public constant deadAddress = address(0xdead);
1059 
1060     bool private swapping;
1061 
1062     address public marketingWallet;
1063     address public devWallet;
1064 
1065     uint256 public maxTransactionAmount;
1066     uint256 public swapTokensAtAmount;
1067     uint256 public maxWallet;
1068 
1069     uint256 public percentForLPBurn = 25; // 25 = .25%
1070     bool public lpBurnEnabled = false;
1071     uint256 public lpBurnFrequency = 3600 seconds;
1072     uint256 public lastLpBurnTime;
1073 
1074     uint256 public manualBurnFrequency = 30 minutes;
1075     uint256 public lastManualLpBurnTime;
1076 
1077     bool public limitsInEffect = true;
1078     bool public tradingActive = false;
1079     bool public swapEnabled = false;
1080 
1081     // Anti-bot and anti-whale mappings and variables
1082     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1083     bool public transferDelayEnabled = true;
1084 
1085     uint256 public buyTotalFees;
1086     uint256 public buyMarketingFee;
1087     uint256 public buyLiquidityFee;
1088     uint256 public buyDevFee;
1089 
1090     uint256 public sellTotalFees;
1091     uint256 public sellMarketingFee;
1092     uint256 public sellLiquidityFee;
1093     uint256 public sellDevFee;
1094 
1095     uint256 public tokensForMarketing;
1096     uint256 public tokensForLiquidity;
1097     uint256 public tokensForDev;
1098 
1099     /******************/
1100 
1101     // exlcude from fees and max transaction amount
1102     mapping(address => bool) private _isExcludedFromFees;
1103     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1104 
1105     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1106     // could be subject to a maximum transfer amount
1107     mapping(address => bool) public automatedMarketMakerPairs;
1108 
1109     event UpdateUniswapV2Router(
1110         address indexed newAddress,
1111         address indexed oldAddress
1112     );
1113 
1114     event ExcludeFromFees(address indexed account, bool isExcluded);
1115 
1116     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1117 
1118     event marketingWalletUpdated(
1119         address indexed newWallet,
1120         address indexed oldWallet
1121     );
1122 
1123     event devWalletUpdated(
1124         address indexed newWallet,
1125         address indexed oldWallet
1126     );
1127 
1128     event SwapAndLiquify(
1129         uint256 tokensSwapped,
1130         uint256 ethReceived,
1131         uint256 tokensIntoLiquidity
1132     );
1133 
1134     event AutoNukeLP();
1135 
1136     event ManualNukeLP();
1137 
1138     constructor() ERC20("ANOLE INU", "ANOLE") {
1139         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1140             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1141         );
1142 
1143         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1144         uniswapV2Router = _uniswapV2Router;
1145 
1146         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1147             .createPair(address(this), _uniswapV2Router.WETH());
1148         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1149         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1150 
1151         uint256 _buyMarketingFee = 0;
1152         uint256 _buyLiquidityFee = 0;
1153         uint256 _buyDevFee = 0;
1154 
1155         uint256 _sellMarketingFee = 0;
1156         uint256 _sellLiquidityFee = 0;
1157         uint256 _sellDevFee = 0;
1158 
1159         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1160 
1161         maxTransactionAmount = 20_000_000_000 * 1e18;
1162         maxWallet = 20_000_000_000 * 1e18;
1163         swapTokensAtAmount = (totalSupply * 5) / 10000;
1164 
1165         buyMarketingFee = _buyMarketingFee;
1166         buyLiquidityFee = _buyLiquidityFee;
1167         buyDevFee = _buyDevFee;
1168         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1169 
1170         sellMarketingFee = _sellMarketingFee;
1171         sellLiquidityFee = _sellLiquidityFee;
1172         sellDevFee = _sellDevFee;
1173         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1174 
1175         marketingWallet = address(0x09027A11baE9C4FAB107fd775793AFa2b3959132); 
1176         devWallet = address(0x09027A11baE9C4FAB107fd775793AFa2b3959132); 
1177 
1178         // exclude from paying fees or having max transaction amount
1179         excludeFromFees(owner(), true);
1180         excludeFromFees(address(this), true);
1181         excludeFromFees(address(0xdead), true);
1182 
1183         excludeFromMaxTransaction(owner(), true);
1184         excludeFromMaxTransaction(address(this), true);
1185         excludeFromMaxTransaction(address(0xdead), true);
1186 
1187         /*
1188             _mint is an internal function in ERC20.sol that is only called here,
1189             and CANNOT be called ever again
1190         */
1191         _mint(msg.sender, totalSupply);
1192     }
1193 
1194     receive() external payable {}
1195 
1196     // once enabled, can never be turned off
1197     function enableTrading() external onlyOwner {
1198         tradingActive = true;
1199         swapEnabled = true;
1200         lastLpBurnTime = block.timestamp;
1201     }
1202 
1203     // remove limits after token is stable
1204     function removeLimits() external onlyOwner returns (bool) {
1205         limitsInEffect = false;
1206         return true;
1207     }
1208 
1209     // disable Transfer delay - cannot be reenabled
1210     function disableTransferDelay() external onlyOwner returns (bool) {
1211         transferDelayEnabled = false;
1212         return true;
1213     }
1214 
1215     // change the minimum amount of tokens to sell from fees
1216     function updateSwapTokensAtAmount(uint256 newAmount)
1217         external
1218         onlyOwner
1219         returns (bool)
1220     {
1221         require(
1222             newAmount >= (totalSupply() * 1) / 100000,
1223             "Swap amount cannot be lower than 0.001% total supply."
1224         );
1225         require(
1226             newAmount <= (totalSupply() * 5) / 1000,
1227             "Swap amount cannot be higher than 0.5% total supply."
1228         );
1229         swapTokensAtAmount = newAmount;
1230         return true;
1231     }
1232 
1233     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1234         require(
1235             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1236             "Cannot set maxTransactionAmount lower than 0.1%"
1237         );
1238         maxTransactionAmount = newNum * (10**18);
1239     }
1240 
1241     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1242         require(
1243             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1244             "Cannot set maxWallet lower than 0.5%"
1245         );
1246         maxWallet = newNum * (10**18);
1247     }
1248 
1249     function excludeFromMaxTransaction(address updAds, bool isEx)
1250         public
1251         onlyOwner
1252     {
1253         _isExcludedMaxTransactionAmount[updAds] = isEx;
1254     }
1255 
1256     // only use to disable contract sales if absolutely necessary (emergency use only)
1257     function updateSwapEnabled(bool enabled) external onlyOwner {
1258         swapEnabled = enabled;
1259     }
1260 
1261     function updateBuyFees(
1262         uint256 _marketingFee,
1263         uint256 _liquidityFee,
1264         uint256 _devFee
1265     ) external onlyOwner {
1266         buyMarketingFee = _marketingFee;
1267         buyLiquidityFee = _liquidityFee;
1268         buyDevFee = _devFee;
1269         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1270         require(buyTotalFees <= 1, "Must keep fees at 2% or less");
1271     }
1272 
1273     function updateSellFees(
1274         uint256 _marketingFee,
1275         uint256 _liquidityFee,
1276         uint256 _devFee
1277     ) external onlyOwner {
1278         sellMarketingFee = _marketingFee;
1279         sellLiquidityFee = _liquidityFee;
1280         sellDevFee = _devFee;
1281         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1282         require(sellTotalFees <= 1, "Must keep fees at 2% or less");
1283     }
1284 
1285     function excludeFromFees(address account, bool excluded) public onlyOwner {
1286         _isExcludedFromFees[account] = excluded;
1287         emit ExcludeFromFees(account, excluded);
1288     }
1289 
1290     function setAutomatedMarketMakerPair(address pair, bool value)
1291         public
1292         onlyOwner
1293     {
1294         require(
1295             pair != uniswapV2Pair,
1296             "The pair cannot be removed from automatedMarketMakerPairs"
1297         );
1298 
1299         _setAutomatedMarketMakerPair(pair, value);
1300     }
1301 
1302     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1303         automatedMarketMakerPairs[pair] = value;
1304 
1305         emit SetAutomatedMarketMakerPair(pair, value);
1306     }
1307 
1308     function updateMarketingWallet(address newMarketingWallet)
1309         external
1310         onlyOwner
1311     {
1312         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1313         marketingWallet = newMarketingWallet;
1314     }
1315 
1316     function updateDevWallet(address newWallet) external onlyOwner {
1317         emit devWalletUpdated(newWallet, devWallet);
1318         devWallet = newWallet;
1319     }
1320 
1321     function isExcludedFromFees(address account) public view returns (bool) {
1322         return _isExcludedFromFees[account];
1323     }
1324 
1325     event BoughtEarly(address indexed sniper);
1326 
1327     function _transfer(
1328         address from,
1329         address to,
1330         uint256 amount
1331     ) internal override {
1332         require(from != address(0), "ERC20: transfer from the zero address");
1333         require(to != address(0), "ERC20: transfer to the zero address");
1334 
1335         if (amount == 0) {
1336             super._transfer(from, to, 0);
1337             return;
1338         }
1339 
1340         if (limitsInEffect) {
1341             if (
1342                 from != owner() &&
1343                 to != owner() &&
1344                 to != address(0) &&
1345                 to != address(0xdead) &&
1346                 !swapping
1347             ) {
1348                 if (!tradingActive) {
1349                     require(
1350                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1351                         "Trading is not active."
1352                     );
1353                 }
1354 
1355                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1356                 if (transferDelayEnabled) {
1357                     if (
1358                         to != owner() &&
1359                         to != address(uniswapV2Router) &&
1360                         to != address(uniswapV2Pair)
1361                     ) {
1362                         require(
1363                             _holderLastTransferTimestamp[tx.origin] <
1364                                 block.number,
1365                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1366                         );
1367                         _holderLastTransferTimestamp[tx.origin] = block.number;
1368                     }
1369                 }
1370 
1371                 //when buy
1372                 if (
1373                     automatedMarketMakerPairs[from] &&
1374                     !_isExcludedMaxTransactionAmount[to]
1375                 ) {
1376                     require(
1377                         amount <= maxTransactionAmount,
1378                         "Buy transfer amount exceeds the maxTransactionAmount."
1379                     );
1380                     require(
1381                         amount + balanceOf(to) <= maxWallet,
1382                         "Max wallet exceeded"
1383                     );
1384                 }
1385                 //when sell
1386                 else if (
1387                     automatedMarketMakerPairs[to] &&
1388                     !_isExcludedMaxTransactionAmount[from]
1389                 ) {
1390                     require(
1391                         amount <= maxTransactionAmount,
1392                         "Sell transfer amount exceeds the maxTransactionAmount."
1393                     );
1394                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1395                     require(
1396                         amount + balanceOf(to) <= maxWallet,
1397                         "Max wallet exceeded"
1398                     );
1399                 }
1400             }
1401         }
1402 
1403         uint256 contractTokenBalance = balanceOf(address(this));
1404 
1405         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1406 
1407         if (
1408             canSwap &&
1409             swapEnabled &&
1410             !swapping &&
1411             !automatedMarketMakerPairs[from] &&
1412             !_isExcludedFromFees[from] &&
1413             !_isExcludedFromFees[to]
1414         ) {
1415             swapping = true;
1416 
1417             swapBack();
1418 
1419             swapping = false;
1420         }
1421 
1422         if (
1423             !swapping &&
1424             automatedMarketMakerPairs[to] &&
1425             lpBurnEnabled &&
1426             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1427             !_isExcludedFromFees[from]
1428         ) {
1429             autoBurnLiquidityPairTokens();
1430         }
1431 
1432         bool takeFee = !swapping;
1433 
1434         // if any account belongs to _isExcludedFromFee account then remove the fee
1435         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1436             takeFee = false;
1437         }
1438 
1439         uint256 fees = 0;
1440         // only take fees on buys/sells, do not take on wallet transfers
1441         if (takeFee) {
1442             // on sell
1443             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1444                 fees = amount.mul(sellTotalFees).div(100);
1445                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1446                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1447                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1448             }
1449             // on buy
1450             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1451                 fees = amount.mul(buyTotalFees).div(100);
1452                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1453                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1454                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1455             }
1456 
1457             if (fees > 0) {
1458                 super._transfer(from, address(this), fees);
1459             }
1460 
1461             amount -= fees;
1462         }
1463 
1464         super._transfer(from, to, amount);
1465     }
1466 
1467     function swapTokensForEth(uint256 tokenAmount) private {
1468         // generate the uniswap pair path of token -> weth
1469         address[] memory path = new address[](2);
1470         path[0] = address(this);
1471         path[1] = uniswapV2Router.WETH();
1472 
1473         _approve(address(this), address(uniswapV2Router), tokenAmount);
1474 
1475         // make the swap
1476         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1477             tokenAmount,
1478             0, // accept any amount of ETH
1479             path,
1480             address(this),
1481             block.timestamp
1482         );
1483     }
1484 
1485     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1486         // approve token transfer to cover all possible scenarios
1487         _approve(address(this), address(uniswapV2Router), tokenAmount);
1488 
1489         // add the liquidity
1490         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1491             address(this),
1492             tokenAmount,
1493             0, // slippage is unavoidable
1494             0, // slippage is unavoidable
1495             deadAddress,
1496             block.timestamp
1497         );
1498     }
1499 
1500     function swapBack() private {
1501         uint256 contractBalance = balanceOf(address(this));
1502         uint256 totalTokensToSwap = tokensForLiquidity +
1503             tokensForMarketing +
1504             tokensForDev;
1505         bool success;
1506 
1507         if (contractBalance == 0 || totalTokensToSwap == 0) {
1508             return;
1509         }
1510 
1511         if (contractBalance > swapTokensAtAmount * 20) {
1512             contractBalance = swapTokensAtAmount * 20;
1513         }
1514 
1515         // Halve the amount of liquidity tokens
1516         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1517             totalTokensToSwap /
1518             2;
1519         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1520 
1521         uint256 initialETHBalance = address(this).balance;
1522 
1523         swapTokensForEth(amountToSwapForETH);
1524 
1525         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1526 
1527         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1528             totalTokensToSwap
1529         );
1530         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1531 
1532         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1533 
1534         tokensForLiquidity = 0;
1535         tokensForMarketing = 0;
1536         tokensForDev = 0;
1537 
1538         (success, ) = address(devWallet).call{value: ethForDev}("");
1539 
1540         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1541             addLiquidity(liquidityTokens, ethForLiquidity);
1542             emit SwapAndLiquify(
1543                 amountToSwapForETH,
1544                 ethForLiquidity,
1545                 tokensForLiquidity
1546             );
1547         }
1548 
1549         (success, ) = address(marketingWallet).call{
1550             value: address(this).balance
1551         }("");
1552     }
1553 
1554     function setAutoLPBurnSettings(
1555         uint256 _frequencyInSeconds,
1556         uint256 _percent,
1557         bool _Enabled
1558     ) external onlyOwner {
1559         require(
1560             _frequencyInSeconds >= 600,
1561             "cannot set buyback more often than every 10 minutes"
1562         );
1563         require(
1564             _percent <= 1000 && _percent >= 0,
1565             "Must set auto LP burn percent between 0% and 10%"
1566         );
1567         lpBurnFrequency = _frequencyInSeconds;
1568         percentForLPBurn = _percent;
1569         lpBurnEnabled = _Enabled;
1570     }
1571 
1572     function autoBurnLiquidityPairTokens() internal returns (bool) {
1573         lastLpBurnTime = block.timestamp;
1574 
1575         // get balance of liquidity pair
1576         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1577 
1578         // calculate amount to burn
1579         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1580             10000
1581         );
1582 
1583         // pull tokens from pancakePair liquidity and move to dead address permanently
1584         if (amountToBurn > 0) {
1585             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1586         }
1587 
1588         //sync price since this is not in a swap transaction!
1589         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1590         pair.sync();
1591         emit AutoNukeLP();
1592         return true;
1593     }
1594 
1595     function manualBurnLiquidityPairTokens(uint256 percent)
1596         external
1597         onlyOwner
1598         returns (bool)
1599     {
1600         require(
1601             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1602             "Must wait for cooldown to finish"
1603         );
1604         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1605         lastManualLpBurnTime = block.timestamp;
1606 
1607         // get balance of liquidity pair
1608         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1609 
1610         // calculate amount to burn
1611         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1612 
1613         // pull tokens from pancakePair liquidity and move to dead address permanently
1614         if (amountToBurn > 0) {
1615             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1616         }
1617 
1618         //sync price since this is not in a swap transaction!
1619         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1620         pair.sync();
1621         emit ManualNukeLP();
1622         return true;
1623     }
1624 }