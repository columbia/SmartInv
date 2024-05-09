1 /*
2 This space has moved away from its glorious past. There was a time when degens weren't afraid to hold more than 10 minutes. 
3 They held weeks. Months. A time when developers simply launched a token and a community gathered around it, ready to work.
4 The opium was powerful. 
5 And yet everyone knew that SHIBA, FLOKI, SAFEMOON, and so on, would never have any use. The name was cool, the community was thrilling. 
6 Everyone understood that the success of their investment was in their hands. They worked hard. 
7 They were not aiming for 300% gains before moving to the next one. People had ambition.
8 They understood that in order to grow they had to look after each others. Preserve others bag, so people would feel confident into joining the party.
9 They spent countless hours working on their bag.. Prospecting every forums, subreddits and more importantly foreign communities. 
10 They understood that an international collective was way stronger than a weak, single timezone and language one. 
11 It almost sounds innovative in this market where shilling has turned into posting in the same Telegram groups with the exact same people. 
12 Mentionning the same couple of accounts on twitter.
13 Everything was simple. Straight forward. Powerful.
14 They did not need "revolutionary" ponzinomics. They did not need "utility". They did not need rogue influencers waiting their followers to have exit liquidity.
15 They had less. And yet they had so much more...
16 
17 
18 Max tx: 1%
19 Max wallet: 2%
20 Taxes: 5/5 for buybacks only
21 */ 
22 
23 // SPDX-License-Identifier: MIT
24 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
25 pragma experimental ABIEncoderV2;
26 
27 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
28 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
29 
30 /* pragma solidity ^0.8.0; */
31 
32 /**
33  * @dev Provides information about the current execution context, including the
34  * sender of the transaction and its data. While these are generally available
35  * via msg.sender and msg.data, they should not be accessed in such a direct
36  * manner, since when dealing with meta-transactions the account sending and
37  * paying for execution may not be the actual sender (as far as an application
38  * is concerned).
39  *
40  * This contract is only required for intermediate, library-like contracts.
41  */
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address) {
44         return msg.sender;
45     }
46 
47     function _msgData() internal view virtual returns (bytes calldata) {
48         return msg.data;
49     }
50 }
51 
52 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
53 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
54 
55 /* pragma solidity ^0.8.0; */
56 
57 /* import "../utils/Context.sol"; */
58 
59 /**
60  * @dev Contract module which provides a basic access control mechanism, where
61  * there is an account (an owner) that can be granted exclusive access to
62  * specific functions.
63  *
64  * By default, the owner account will be the one that deploys the contract. This
65  * can later be changed with {transferOwnership}.
66  *
67  * This module is used through inheritance. It will make available the modifier
68  * `onlyOwner`, which can be applied to your functions to restrict their use to
69  * the owner.
70  */
71 abstract contract Ownable is Context {
72     address private _owner;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /**
77      * @dev Initializes the contract setting the deployer as the initial owner.
78      */
79     constructor() {
80         _transferOwnership(_msgSender());
81     }
82 
83     /**
84      * @dev Returns the address of the current owner.
85      */
86     function owner() public view virtual returns (address) {
87         return _owner;
88     }
89 
90     /**
91      * @dev Throws if called by any account other than the owner.
92      */
93     modifier onlyOwner() {
94         require(owner() == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     /**
99      * @dev Leaves the contract without owner. It will not be possible to call
100      * `onlyOwner` functions anymore. Can only be called by the current owner.
101      *
102      * NOTE: Renouncing ownership will leave the contract without an owner,
103      * thereby removing any functionality that is only available to the owner.
104      */
105     function renounceOwnership() public virtual onlyOwner {
106         _transferOwnership(address(0));
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Can only be called by the current owner.
112      */
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(newOwner != address(0), "Ownable: new owner is the zero address");
115         _transferOwnership(newOwner);
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Internal function without access restriction.
121      */
122     function _transferOwnership(address newOwner) internal virtual {
123         address oldOwner = _owner;
124         _owner = newOwner;
125         emit OwnershipTransferred(oldOwner, newOwner);
126     }
127 }
128 
129 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
130 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
131 
132 /* pragma solidity ^0.8.0; */
133 
134 /**
135  * @dev Interface of the ERC20 standard as defined in the EIP.
136  */
137 interface IERC20 {
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `recipient`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address recipient, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `sender` to `recipient` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(
192         address sender,
193         address recipient,
194         uint256 amount
195     ) external returns (bool);
196 
197     /**
198      * @dev Emitted when `value` tokens are moved from one account (`from`) to
199      * another (`to`).
200      *
201      * Note that `value` may be zero.
202      */
203     event Transfer(address indexed from, address indexed to, uint256 value);
204 
205     /**
206      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
207      * a call to {approve}. `value` is the new allowance.
208      */
209     event Approval(address indexed owner, address indexed spender, uint256 value);
210 }
211 
212 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
213 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
214 
215 /* pragma solidity ^0.8.0; */
216 
217 /* import "../IERC20.sol"; */
218 
219 /**
220  * @dev Interface for the optional metadata functions from the ERC20 standard.
221  *
222  * _Available since v4.1._
223  */
224 interface IERC20Metadata is IERC20 {
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the symbol of the token.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the decimals places of the token.
237      */
238     function decimals() external view returns (uint8);
239 }
240 
241 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
242 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
243 
244 /* pragma solidity ^0.8.0; */
245 
246 /* import "./IERC20.sol"; */
247 /* import "./extensions/IERC20Metadata.sol"; */
248 /* import "../../utils/Context.sol"; */
249 
250 /**
251  * @dev Implementation of the {IERC20} interface.
252  *
253  * This implementation is agnostic to the way tokens are created. This means
254  * that a supply mechanism has to be added in a derived contract using {_mint}.
255  * For a generic mechanism see {ERC20PresetMinterPauser}.
256  *
257  * TIP: For a detailed writeup see our guide
258  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
259  * to implement supply mechanisms].
260  *
261  * We have followed general OpenZeppelin Contracts guidelines: functions revert
262  * instead returning `false` on failure. This behavior is nonetheless
263  * conventional and does not conflict with the expectations of ERC20
264  * applications.
265  *
266  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
267  * This allows applications to reconstruct the allowance for all accounts just
268  * by listening to said events. Other implementations of the EIP may not emit
269  * these events, as it isn't required by the specification.
270  *
271  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
272  * functions have been added to mitigate the well-known issues around setting
273  * allowances. See {IERC20-approve}.
274  */
275 contract ERC20 is Context, IERC20, IERC20Metadata {
276     mapping(address => uint256) private _balances;
277 
278     mapping(address => mapping(address => uint256)) private _allowances;
279 
280     uint256 private _totalSupply;
281 
282     string private _name;
283     string private _symbol;
284 
285     /**
286      * @dev Sets the values for {name} and {symbol}.
287      *
288      * The default value of {decimals} is 18. To select a different value for
289      * {decimals} you should overload it.
290      *
291      * All two of these values are immutable: they can only be set once during
292      * construction.
293      */
294     constructor(string memory name_, string memory symbol_) {
295         _name = name_;
296         _symbol = symbol_;
297     }
298 
299     /**
300      * @dev Returns the name of the token.
301      */
302     function name() public view virtual override returns (string memory) {
303         return _name;
304     }
305 
306     /**
307      * @dev Returns the symbol of the token, usually a shorter version of the
308      * name.
309      */
310     function symbol() public view virtual override returns (string memory) {
311         return _symbol;
312     }
313 
314     /**
315      * @dev Returns the number of decimals used to get its user representation.
316      * For example, if `decimals` equals `2`, a balance of `505` tokens should
317      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
318      *
319      * Tokens usually opt for a value of 18, imitating the relationship between
320      * Ether and Wei. This is the value {ERC20} uses, unless this function is
321      * overridden;
322      *
323      * NOTE: This information is only used for _display_ purposes: it in
324      * no way affects any of the arithmetic of the contract, including
325      * {IERC20-balanceOf} and {IERC20-transfer}.
326      */
327     function decimals() public view virtual override returns (uint8) {
328         return 18;
329     }
330 
331     /**
332      * @dev See {IERC20-totalSupply}.
333      */
334     function totalSupply() public view virtual override returns (uint256) {
335         return _totalSupply;
336     }
337 
338     /**
339      * @dev See {IERC20-balanceOf}.
340      */
341     function balanceOf(address account) public view virtual override returns (uint256) {
342         return _balances[account];
343     }
344 
345     /**
346      * @dev See {IERC20-transfer}.
347      *
348      * Requirements:
349      *
350      * - `recipient` cannot be the zero address.
351      * - the caller must have a balance of at least `amount`.
352      */
353     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
354         _transfer(_msgSender(), recipient, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-allowance}.
360      */
361     function allowance(address owner, address spender) public view virtual override returns (uint256) {
362         return _allowances[owner][spender];
363     }
364 
365     /**
366      * @dev See {IERC20-approve}.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function approve(address spender, uint256 amount) public virtual override returns (bool) {
373         _approve(_msgSender(), spender, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-transferFrom}.
379      *
380      * Emits an {Approval} event indicating the updated allowance. This is not
381      * required by the EIP. See the note at the beginning of {ERC20}.
382      *
383      * Requirements:
384      *
385      * - `sender` and `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      * - the caller must have allowance for ``sender``'s tokens of at least
388      * `amount`.
389      */
390     function transferFrom(
391         address sender,
392         address recipient,
393         uint256 amount
394     ) public virtual override returns (bool) {
395         _transfer(sender, recipient, amount);
396 
397         uint256 currentAllowance = _allowances[sender][_msgSender()];
398         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
399         unchecked {
400             _approve(sender, _msgSender(), currentAllowance - amount);
401         }
402 
403         return true;
404     }
405 
406     /**
407      * @dev Atomically increases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      */
418     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
419         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
420         return true;
421     }
422 
423     /**
424      * @dev Atomically decreases the allowance granted to `spender` by the caller.
425      *
426      * This is an alternative to {approve} that can be used as a mitigation for
427      * problems described in {IERC20-approve}.
428      *
429      * Emits an {Approval} event indicating the updated allowance.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      * - `spender` must have allowance for the caller of at least
435      * `subtractedValue`.
436      */
437     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
438         uint256 currentAllowance = _allowances[_msgSender()][spender];
439         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
440         unchecked {
441             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
442         }
443 
444         return true;
445     }
446 
447     /**
448      * @dev Moves `amount` of tokens from `sender` to `recipient`.
449      *
450      * This internal function is equivalent to {transfer}, and can be used to
451      * e.g. implement automatic token fees, slashing mechanisms, etc.
452      *
453      * Emits a {Transfer} event.
454      *
455      * Requirements:
456      *
457      * - `sender` cannot be the zero address.
458      * - `recipient` cannot be the zero address.
459      * - `sender` must have a balance of at least `amount`.
460      */
461     function _transfer(
462         address sender,
463         address recipient,
464         uint256 amount
465     ) internal virtual {
466         require(sender != address(0), "ERC20: transfer from the zero address");
467         require(recipient != address(0), "ERC20: transfer to the zero address");
468 
469         _beforeTokenTransfer(sender, recipient, amount);
470 
471         uint256 senderBalance = _balances[sender];
472         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
473         unchecked {
474             _balances[sender] = senderBalance - amount;
475         }
476         _balances[recipient] += amount;
477 
478         emit Transfer(sender, recipient, amount);
479 
480         _afterTokenTransfer(sender, recipient, amount);
481     }
482 
483     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
484      * the total supply.
485      *
486      * Emits a {Transfer} event with `from` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      */
492     function _mint(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: mint to the zero address");
494 
495         _beforeTokenTransfer(address(0), account, amount);
496 
497         _totalSupply += amount;
498         _balances[account] += amount;
499         emit Transfer(address(0), account, amount);
500 
501         _afterTokenTransfer(address(0), account, amount);
502     }
503 
504     /**
505      * @dev Destroys `amount` tokens from `account`, reducing the
506      * total supply.
507      *
508      * Emits a {Transfer} event with `to` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      * - `account` must have at least `amount` tokens.
514      */
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         uint256 accountBalance = _balances[account];
521         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
522         unchecked {
523             _balances[account] = accountBalance - amount;
524         }
525         _totalSupply -= amount;
526 
527         emit Transfer(account, address(0), amount);
528 
529         _afterTokenTransfer(account, address(0), amount);
530     }
531 
532     /**
533      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
534      *
535      * This internal function is equivalent to `approve`, and can be used to
536      * e.g. set automatic allowances for certain subsystems, etc.
537      *
538      * Emits an {Approval} event.
539      *
540      * Requirements:
541      *
542      * - `owner` cannot be the zero address.
543      * - `spender` cannot be the zero address.
544      */
545     function _approve(
546         address owner,
547         address spender,
548         uint256 amount
549     ) internal virtual {
550         require(owner != address(0), "ERC20: approve from the zero address");
551         require(spender != address(0), "ERC20: approve to the zero address");
552 
553         _allowances[owner][spender] = amount;
554         emit Approval(owner, spender, amount);
555     }
556 
557     /**
558      * @dev Hook that is called before any transfer of tokens. This includes
559      * minting and burning.
560      *
561      * Calling conditions:
562      *
563      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
564      * will be transferred to `to`.
565      * - when `from` is zero, `amount` tokens will be minted for `to`.
566      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
567      * - `from` and `to` are never both zero.
568      *
569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
570      */
571     function _beforeTokenTransfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal virtual {}
576 
577     /**
578      * @dev Hook that is called after any transfer of tokens. This includes
579      * minting and burning.
580      *
581      * Calling conditions:
582      *
583      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
584      * has been transferred to `to`.
585      * - when `from` is zero, `amount` tokens have been minted for `to`.
586      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
587      * - `from` and `to` are never both zero.
588      *
589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
590      */
591     function _afterTokenTransfer(
592         address from,
593         address to,
594         uint256 amount
595     ) internal virtual {}
596 }
597 
598 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
599 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
600 
601 /* pragma solidity ^0.8.0; */
602 
603 // CAUTION
604 // This version of SafeMath should only be used with Solidity 0.8 or later,
605 // because it relies on the compiler's built in overflow checks.
606 
607 /**
608  * @dev Wrappers over Solidity's arithmetic operations.
609  *
610  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
611  * now has built in overflow checking.
612  */
613 library SafeMath {
614     /**
615      * @dev Returns the addition of two unsigned integers, with an overflow flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             uint256 c = a + b;
622             if (c < a) return (false, 0);
623             return (true, c);
624         }
625     }
626 
627     /**
628      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
629      *
630      * _Available since v3.4._
631      */
632     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         unchecked {
634             if (b > a) return (false, 0);
635             return (true, a - b);
636         }
637     }
638 
639     /**
640      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
641      *
642      * _Available since v3.4._
643      */
644     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
647             // benefit is lost if 'b' is also tested.
648             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
649             if (a == 0) return (true, 0);
650             uint256 c = a * b;
651             if (c / a != b) return (false, 0);
652             return (true, c);
653         }
654     }
655 
656     /**
657      * @dev Returns the division of two unsigned integers, with a division by zero flag.
658      *
659      * _Available since v3.4._
660      */
661     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
662         unchecked {
663             if (b == 0) return (false, 0);
664             return (true, a / b);
665         }
666     }
667 
668     /**
669      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
670      *
671      * _Available since v3.4._
672      */
673     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
674         unchecked {
675             if (b == 0) return (false, 0);
676             return (true, a % b);
677         }
678     }
679 
680     /**
681      * @dev Returns the addition of two unsigned integers, reverting on
682      * overflow.
683      *
684      * Counterpart to Solidity's `+` operator.
685      *
686      * Requirements:
687      *
688      * - Addition cannot overflow.
689      */
690     function add(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a + b;
692     }
693 
694     /**
695      * @dev Returns the subtraction of two unsigned integers, reverting on
696      * overflow (when the result is negative).
697      *
698      * Counterpart to Solidity's `-` operator.
699      *
700      * Requirements:
701      *
702      * - Subtraction cannot overflow.
703      */
704     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
705         return a - b;
706     }
707 
708     /**
709      * @dev Returns the multiplication of two unsigned integers, reverting on
710      * overflow.
711      *
712      * Counterpart to Solidity's `*` operator.
713      *
714      * Requirements:
715      *
716      * - Multiplication cannot overflow.
717      */
718     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
719         return a * b;
720     }
721 
722     /**
723      * @dev Returns the integer division of two unsigned integers, reverting on
724      * division by zero. The result is rounded towards zero.
725      *
726      * Counterpart to Solidity's `/` operator.
727      *
728      * Requirements:
729      *
730      * - The divisor cannot be zero.
731      */
732     function div(uint256 a, uint256 b) internal pure returns (uint256) {
733         return a / b;
734     }
735 
736     /**
737      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
738      * reverting when dividing by zero.
739      *
740      * Counterpart to Solidity's `%` operator. This function uses a `revert`
741      * opcode (which leaves remaining gas untouched) while Solidity uses an
742      * invalid opcode to revert (consuming all remaining gas).
743      *
744      * Requirements:
745      *
746      * - The divisor cannot be zero.
747      */
748     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
749         return a % b;
750     }
751 
752     /**
753      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
754      * overflow (when the result is negative).
755      *
756      * CAUTION: This function is deprecated because it requires allocating memory for the error
757      * message unnecessarily. For custom revert reasons use {trySub}.
758      *
759      * Counterpart to Solidity's `-` operator.
760      *
761      * Requirements:
762      *
763      * - Subtraction cannot overflow.
764      */
765     function sub(
766         uint256 a,
767         uint256 b,
768         string memory errorMessage
769     ) internal pure returns (uint256) {
770         unchecked {
771             require(b <= a, errorMessage);
772             return a - b;
773         }
774     }
775 
776     /**
777      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
778      * division by zero. The result is rounded towards zero.
779      *
780      * Counterpart to Solidity's `/` operator. Note: this function uses a
781      * `revert` opcode (which leaves remaining gas untouched) while Solidity
782      * uses an invalid opcode to revert (consuming all remaining gas).
783      *
784      * Requirements:
785      *
786      * - The divisor cannot be zero.
787      */
788     function div(
789         uint256 a,
790         uint256 b,
791         string memory errorMessage
792     ) internal pure returns (uint256) {
793         unchecked {
794             require(b > 0, errorMessage);
795             return a / b;
796         }
797     }
798 
799     /**
800      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
801      * reverting with custom message when dividing by zero.
802      *
803      * CAUTION: This function is deprecated because it requires allocating memory for the error
804      * message unnecessarily. For custom revert reasons use {tryMod}.
805      *
806      * Counterpart to Solidity's `%` operator. This function uses a `revert`
807      * opcode (which leaves remaining gas untouched) while Solidity uses an
808      * invalid opcode to revert (consuming all remaining gas).
809      *
810      * Requirements:
811      *
812      * - The divisor cannot be zero.
813      */
814     function mod(
815         uint256 a,
816         uint256 b,
817         string memory errorMessage
818     ) internal pure returns (uint256) {
819         unchecked {
820             require(b > 0, errorMessage);
821             return a % b;
822         }
823     }
824 }
825 
826 ////// src/IUniswapV2Factory.sol
827 /* pragma solidity 0.8.10; */
828 /* pragma experimental ABIEncoderV2; */
829 
830 interface IUniswapV2Factory {
831     event PairCreated(
832         address indexed token0,
833         address indexed token1,
834         address pair,
835         uint256
836     );
837 
838     function feeTo() external view returns (address);
839 
840     function feeToSetter() external view returns (address);
841 
842     function getPair(address tokenA, address tokenB)
843         external
844         view
845         returns (address pair);
846 
847     function allPairs(uint256) external view returns (address pair);
848 
849     function allPairsLength() external view returns (uint256);
850 
851     function createPair(address tokenA, address tokenB)
852         external
853         returns (address pair);
854 
855     function setFeeTo(address) external;
856 
857     function setFeeToSetter(address) external;
858 }
859 
860 ////// src/IUniswapV2Pair.sol
861 /* pragma solidity 0.8.10; */
862 /* pragma experimental ABIEncoderV2; */
863 
864 interface IUniswapV2Pair {
865     event Approval(
866         address indexed owner,
867         address indexed spender,
868         uint256 value
869     );
870     event Transfer(address indexed from, address indexed to, uint256 value);
871 
872     function name() external pure returns (string memory);
873 
874     function symbol() external pure returns (string memory);
875 
876     function decimals() external pure returns (uint8);
877 
878     function totalSupply() external view returns (uint256);
879 
880     function balanceOf(address owner) external view returns (uint256);
881 
882     function allowance(address owner, address spender)
883         external
884         view
885         returns (uint256);
886 
887     function approve(address spender, uint256 value) external returns (bool);
888 
889     function transfer(address to, uint256 value) external returns (bool);
890 
891     function transferFrom(
892         address from,
893         address to,
894         uint256 value
895     ) external returns (bool);
896 
897     function DOMAIN_SEPARATOR() external view returns (bytes32);
898 
899     function PERMIT_TYPEHASH() external pure returns (bytes32);
900 
901     function nonces(address owner) external view returns (uint256);
902 
903     function permit(
904         address owner,
905         address spender,
906         uint256 value,
907         uint256 deadline,
908         uint8 v,
909         bytes32 r,
910         bytes32 s
911     ) external;
912 
913     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
914     event Burn(
915         address indexed sender,
916         uint256 amount0,
917         uint256 amount1,
918         address indexed to
919     );
920     event Swap(
921         address indexed sender,
922         uint256 amount0In,
923         uint256 amount1In,
924         uint256 amount0Out,
925         uint256 amount1Out,
926         address indexed to
927     );
928     event Sync(uint112 reserve0, uint112 reserve1);
929 
930     function MINIMUM_LIQUIDITY() external pure returns (uint256);
931 
932     function factory() external view returns (address);
933 
934     function token0() external view returns (address);
935 
936     function token1() external view returns (address);
937 
938     function getReserves()
939         external
940         view
941         returns (
942             uint112 reserve0,
943             uint112 reserve1,
944             uint32 blockTimestampLast
945         );
946 
947     function price0CumulativeLast() external view returns (uint256);
948 
949     function price1CumulativeLast() external view returns (uint256);
950 
951     function kLast() external view returns (uint256);
952 
953     function mint(address to) external returns (uint256 liquidity);
954 
955     function burn(address to)
956         external
957         returns (uint256 amount0, uint256 amount1);
958 
959     function swap(
960         uint256 amount0Out,
961         uint256 amount1Out,
962         address to,
963         bytes calldata data
964     ) external;
965 
966     function skim(address to) external;
967 
968     function sync() external;
969 
970     function initialize(address, address) external;
971 }
972 
973 ////// src/IUniswapV2Router02.sol
974 /* pragma solidity 0.8.10; */
975 /* pragma experimental ABIEncoderV2; */
976 
977 interface IUniswapV2Router02 {
978     function factory() external pure returns (address);
979 
980     function WETH() external pure returns (address);
981 
982     function addLiquidity(
983         address tokenA,
984         address tokenB,
985         uint256 amountADesired,
986         uint256 amountBDesired,
987         uint256 amountAMin,
988         uint256 amountBMin,
989         address to,
990         uint256 deadline
991     )
992         external
993         returns (
994             uint256 amountA,
995             uint256 amountB,
996             uint256 liquidity
997         );
998 
999     function addLiquidityETH(
1000         address token,
1001         uint256 amountTokenDesired,
1002         uint256 amountTokenMin,
1003         uint256 amountETHMin,
1004         address to,
1005         uint256 deadline
1006     )
1007         external
1008         payable
1009         returns (
1010             uint256 amountToken,
1011             uint256 amountETH,
1012             uint256 liquidity
1013         );
1014 
1015     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1016         uint256 amountIn,
1017         uint256 amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint256 deadline
1021     ) external;
1022 
1023     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1024         uint256 amountOutMin,
1025         address[] calldata path,
1026         address to,
1027         uint256 deadline
1028     ) external payable;
1029 
1030     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1031         uint256 amountIn,
1032         uint256 amountOutMin,
1033         address[] calldata path,
1034         address to,
1035         uint256 deadline
1036     ) external;
1037 }
1038 
1039 /* pragma solidity >=0.8.10; */
1040 
1041 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1042 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1043 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1044 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1045 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1046 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1047 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1048 
1049 contract Reset is ERC20, Ownable {
1050     using SafeMath for uint256;
1051 
1052     IUniswapV2Router02 public immutable uniswapV2Router;
1053     address public immutable uniswapV2Pair;
1054     address public constant deadAddress = address(0xdead);
1055 
1056     bool private swapping;
1057 
1058     address payable public marketingWallet;
1059     address payable public devWallet;
1060 
1061     uint256 public maxTransactionAmount;
1062     uint256 public swapTokensAtAmount;
1063     uint256 public maxWallet;
1064 
1065     uint256 public percentForLPBurn = 25; // 25 = .25%
1066     bool public lpBurnEnabled = false;
1067     uint256 public lpBurnFrequency = 3600 seconds;
1068     uint256 public lastLpBurnTime;
1069 
1070     uint256 public manualBurnFrequency = 30 minutes;
1071     uint256 public lastManualLpBurnTime;
1072 
1073     bool public limitsInEffect = true;
1074     bool public tradingActive = false;
1075     bool public swapEnabled = false;
1076 
1077     // Anti-bot and anti-whale mappings and variables
1078     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1079     bool public transferDelayEnabled = true;
1080 
1081     uint256 public buyTotalFees;
1082     uint256 public buyBBFee;
1083     uint256 public buyDevFee;
1084 
1085     uint256 public sellTotalFees;
1086     uint256 public sellBBFee;
1087     uint256 public sellDevFee;
1088 
1089     uint256 public tokensForMarketing;
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
1112     event marketingWalletUpdated(
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
1132     constructor() ERC20("The Past", "RESET") {
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
1145         uint256 _buyBBFee = 5;
1146         uint256 _buyDevFee = 0;
1147 
1148         uint256 _sellBBFee = 5;
1149         uint256 _sellDevFee = 0;
1150 
1151         uint256 totalSupply = 1_000_000 * 1e18;
1152 
1153         maxTransactionAmount = 10_001 * 1e18; // 1% from total supply maxTransactionAmountTxn
1154         maxWallet = 20_001 * 1e18; // 2% from total supply maxWallet
1155         swapTokensAtAmount = (totalSupply * 10) / 10000; 
1156 
1157         buyBBFee = _buyBBFee;
1158         buyDevFee = _buyDevFee;
1159         buyTotalFees = buyBBFee + buyDevFee;
1160 
1161         sellBBFee = _sellBBFee;
1162         sellDevFee = _sellDevFee;
1163         sellTotalFees = sellBBFee + sellDevFee;
1164 
1165         marketingWallet = payable(0x9DF389B8Dc1035bD9e59851640E13FaF24101D19); // set as marketing wallet
1166         devWallet = payable(0x9DF389B8Dc1035bD9e59851640E13FaF24101D19); // set as dev wallet
1167         // exclude from paying fees or having max transaction amount
1168         excludeFromFees(owner(), true);
1169         excludeFromFees(address(this), true);
1170         excludeFromFees(address(0xdead), true);
1171 
1172         excludeFromMaxTransaction(owner(), true);
1173         excludeFromMaxTransaction(address(this), true);
1174         excludeFromMaxTransaction(address(0xdead), true);
1175 
1176         /*
1177             _mint is an internal function in ERC20.sol that is only called here,
1178             and CANNOT be called ever again
1179         */
1180         _mint(msg.sender, totalSupply);
1181     }
1182 
1183     receive() external payable {}
1184 
1185     function sendETHToFee(uint256 amount) private {
1186 devWallet.transfer(amount);
1187     }
1188 
1189     // once enabled, can never be turned off
1190     function enableTrading() external onlyOwner {
1191         tradingActive = true;
1192         swapEnabled = true;
1193         lastLpBurnTime = block.timestamp;
1194     }
1195 
1196     function manualswap() external {
1197         require(_msgSender() == marketingWallet);
1198         uint256 contractBalance = balanceOf(address(this));
1199         swapTokensForEth(contractBalance);
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
1262         uint256 _devFee
1263     ) external onlyOwner {
1264         buyBBFee = _marketingFee;
1265         buyDevFee = _devFee;
1266         buyTotalFees = buyBBFee + buyDevFee;
1267         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
1268     }
1269 
1270     function updateSellFees(
1271         uint256 _marketingFee,
1272         uint256 _devFee
1273     ) external onlyOwner {
1274         sellBBFee = _marketingFee;
1275         sellDevFee = _devFee;
1276         sellTotalFees = sellBBFee + sellDevFee;
1277         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1278     }
1279 
1280     function excludeFromFees(address account, bool excluded) public onlyOwner {
1281         _isExcludedFromFees[account] = excluded;
1282         emit ExcludeFromFees(account, excluded);
1283     }
1284 
1285     function setAutomatedMarketMakerPair(address pair, bool value)
1286         public
1287         onlyOwner
1288     {
1289         require(
1290             pair != uniswapV2Pair,
1291             "The pair cannot be removed from automatedMarketMakerPairs"
1292         );
1293 
1294         _setAutomatedMarketMakerPair(pair, value);
1295     }
1296 
1297     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1298         automatedMarketMakerPairs[pair] = value;
1299 
1300         emit SetAutomatedMarketMakerPair(pair, value);
1301     }
1302 
1303     function updateMarketingWallet(address newMarketingWallet)
1304         external
1305         onlyOwner
1306     {
1307         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1308         marketingWallet = payable(newMarketingWallet);
1309     }
1310 
1311     function updateDevWallet(address newWallet) external onlyOwner {
1312         emit devWalletUpdated(newWallet, devWallet);
1313         devWallet = payable(newWallet);
1314     }
1315 
1316     function isExcludedFromFees(address account) public view returns (bool) {
1317         return _isExcludedFromFees[account];
1318     }
1319 
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
1399         if (
1400             swapEnabled &&
1401             !swapping &&
1402             !automatedMarketMakerPairs[from] &&
1403             !_isExcludedFromFees[from] &&
1404             !_isExcludedFromFees[to]
1405         ) {
1406             swapTokensForEth(contractTokenBalance);
1407             uint256 contractETHBalance = address(this).balance; 
1408             if(contractETHBalance > 0) {
1409                 sendETHToFee(address(this).balance);
1410             }
1411         }
1412 
1413         bool takeFee = !swapping;
1414 
1415         // if any account belongs to _isExcludedFromFee account then remove the fee
1416         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1417             takeFee = false;
1418         }
1419 
1420         uint256 fees = 0;
1421         // only take fees on buys/sells, do not take on wallet transfers
1422         if (takeFee) {
1423             // on sell
1424             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1425                 fees = amount.mul(sellTotalFees).div(100);
1426                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1427                 tokensForMarketing += (fees * sellBBFee) / sellTotalFees;
1428             }
1429             // on buy
1430             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1431                 fees = amount.mul(buyTotalFees).div(100);
1432                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1433                 tokensForMarketing += (fees * buyBBFee) / buyTotalFees;
1434             }
1435 
1436             if (fees > 0) {
1437                 super._transfer(from, address(this), fees);
1438             }
1439 
1440             amount -= fees;
1441         }
1442 
1443         super._transfer(from, to, amount);
1444     }
1445 
1446     function swapTokensForEth(uint256 tokenAmount) private {
1447         // generate the uniswap pair path of token -> weth
1448         address[] memory path = new address[](2);
1449         path[0] = address(this);
1450         path[1] = uniswapV2Router.WETH();
1451 
1452         _approve(address(this), address(uniswapV2Router), tokenAmount);
1453 
1454         // make the swap
1455         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1456             tokenAmount,
1457             0, // accept any amount of ETH
1458             path,
1459             address(this),
1460             block.timestamp
1461         );
1462     }
1463 
1464     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1465         // approve token transfer to cover all possible scenarios
1466         _approve(address(this), address(uniswapV2Router), tokenAmount);
1467 
1468         // add the liquidity
1469         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1470             address(this),
1471             tokenAmount,
1472             0, // slippage is unavoidable
1473             0, // slippage is unavoidable
1474             deadAddress,
1475             block.timestamp
1476         );
1477     }
1478 }