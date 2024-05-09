1 /*
2 
3     /     |  __    / ____|
4    /      | |__) | | |
5   / /    |  _  /  | |
6  / ____   | |    | |____
7 /_/    _ |_|  _  _____|
8 
9 * ARC: token/ArcxToken.sol
10 *
11 * Latest source (may be newer): https://github.com/arcxgame/contracts/blob/master/contracts/token/ArcxToken.sol
12 *
13 * Contract Dependencies: 
14 *	- BaseERC20
15 *	- Context
16 *	- IERC20
17 *	- IMintableToken
18 *	- Ownable
19 * Libraries: 
20 *	- SafeMath
21 *
22 * MIT License
23 * ===========
24 *
25 * Copyright (c) 2020 ARC
26 *
27 * Permission is hereby granted, free of charge, to any person obtaining a copy
28 * of this software and associated documentation files (the "Software"), to deal
29 * in the Software without restriction, including without limitation the rights
30 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
31 * copies of the Software, and to permit persons to whom the Software is
32 * furnished to do so, subject to the following conditions:
33 *
34 * The above copyright notice and this permission notice shall be included in all
35 * copies or substantial portions of the Software.
36 *
37 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
38 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
39 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
40 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
41 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
42 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
43 */
44 
45 /* ===============================================
46 * Flattened with Solidifier by Coinage
47 * 
48 * https://solidifier.coina.ge
49 * ===============================================
50 */
51 
52 
53 pragma solidity ^0.5.0;
54 
55 /*
56  * @dev Provides information about the current execution context, including the
57  * sender of the transaction and its data. While these are generally available
58  * via msg.sender and msg.data, they should not be accessed in such a direct
59  * manner, since when dealing with GSN meta-transactions the account sending and
60  * paying for execution may not be the actual sender (as far as an application
61  * is concerned).
62  *
63  * This contract is only required for intermediate, library-like contracts.
64  */
65 contract Context {
66     // Empty internal constructor, to prevent people from mistakenly deploying
67     // an instance of this contract, which should be used via inheritance.
68     constructor () internal { }
69     // solhint-disable-previous-line no-empty-blocks
70 
71     function _msgSender() internal view returns (address payable) {
72         return msg.sender;
73     }
74 
75     function _msgData() internal view returns (bytes memory) {
76         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
77         return msg.data;
78     }
79 }
80 
81 
82 /**
83  * @dev Contract module which provides a basic access control mechanism, where
84  * there is an account (an owner) that can be granted exclusive access to
85  * specific functions.
86  *
87  * This module is used through inheritance. It will make available the modifier
88  * `onlyOwner`, which can be applied to your functions to restrict their use to
89  * the owner.
90  */
91 contract Ownable is Context {
92     address private _owner;
93 
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96     /**
97      * @dev Initializes the contract setting the deployer as the initial owner.
98      */
99     constructor () internal {
100         address msgSender = _msgSender();
101         _owner = msgSender;
102         emit OwnershipTransferred(address(0), msgSender);
103     }
104 
105     /**
106      * @dev Returns the address of the current owner.
107      */
108     function owner() public view returns (address) {
109         return _owner;
110     }
111 
112     /**
113      * @dev Throws if called by any account other than the owner.
114      */
115     modifier onlyOwner() {
116         require(isOwner(), "Ownable: caller is not the owner");
117         _;
118     }
119 
120     /**
121      * @dev Returns true if the caller is the current owner.
122      */
123     function isOwner() public view returns (bool) {
124         return _msgSender() == _owner;
125     }
126 
127     /**
128      * @dev Leaves the contract without owner. It will not be possible to call
129      * `onlyOwner` functions anymore. Can only be called by the current owner.
130      *
131      * NOTE: Renouncing ownership will leave the contract without an owner,
132      * thereby removing any functionality that is only available to the owner.
133      */
134     function renounceOwnership() public onlyOwner {
135         emit OwnershipTransferred(_owner, address(0));
136         _owner = address(0);
137     }
138 
139     /**
140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
141      * Can only be called by the current owner.
142      */
143     function transferOwnership(address newOwner) public onlyOwner {
144         _transferOwnership(newOwner);
145     }
146 
147     /**
148      * @dev Transfers ownership of the contract to a new account (`newOwner`).
149      */
150     function _transferOwnership(address newOwner) internal {
151         require(newOwner != address(0), "Ownable: new owner is the zero address");
152         emit OwnershipTransferred(_owner, newOwner);
153         _owner = newOwner;
154     }
155 }
156 
157 
158 // SPDX-License-Identifier: MIT
159 
160 
161 interface IMintableToken {
162 
163     function mint(
164         address to,
165         uint256 value
166     )
167         external;
168 
169     function burn(
170         address to,
171         uint256 value
172     )
173         external;
174 
175 }
176 
177 
178 /**
179  * @dev Wrappers over Solidity's arithmetic operations with added overflow
180  * checks.
181  *
182  * Arithmetic operations in Solidity wrap on overflow. This can easily result
183  * in bugs, because programmers usually assume that an overflow raises an
184  * error, which is the standard behavior in high level programming languages.
185  * `SafeMath` restores this intuition by reverting the transaction when an
186  * operation overflows.
187  *
188  * Using this library instead of the unchecked operations eliminates an entire
189  * class of bugs, so it's recommended to use it always.
190  */
191 library SafeMath {
192     /**
193      * @dev Returns the addition of two unsigned integers, reverting on
194      * overflow.
195      *
196      * Counterpart to Solidity's `+` operator.
197      *
198      * Requirements:
199      * - Addition cannot overflow.
200      */
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         require(c >= a, "SafeMath: addition overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the subtraction of two unsigned integers, reverting on
210      * overflow (when the result is negative).
211      *
212      * Counterpart to Solidity's `-` operator.
213      *
214      * Requirements:
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         return sub(a, b, "SafeMath: subtraction overflow");
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      * - Subtraction cannot overflow.
229      *
230      * _Available since v2.4.0._
231      */
232     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b <= a, errorMessage);
234         uint256 c = a - b;
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the multiplication of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `*` operator.
244      *
245      * Requirements:
246      * - Multiplication cannot overflow.
247      */
248     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
250         // benefit is lost if 'b' is also tested.
251         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
252         if (a == 0) {
253             return 0;
254         }
255 
256         uint256 c = a * b;
257         require(c / a == b, "SafeMath: multiplication overflow");
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers. Reverts on
264      * division by zero. The result is rounded towards zero.
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b) internal pure returns (uint256) {
274         return div(a, b, "SafeMath: division by zero");
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      * - The divisor cannot be zero.
287      *
288      * _Available since v2.4.0._
289      */
290     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
291         // Solidity only automatically asserts when dividing by 0
292         require(b > 0, errorMessage);
293         uint256 c = a / b;
294         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
301      * Reverts when dividing by zero.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      * - The divisor cannot be zero.
309      */
310     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
311         return mod(a, b, "SafeMath: modulo by zero");
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts with custom message when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      * - The divisor cannot be zero.
324      *
325      * _Available since v2.4.0._
326      */
327     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b != 0, errorMessage);
329         return a % b;
330     }
331 }
332 
333 
334 /**
335  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
336  * the optional functions; to access them see {ERC20Detailed}.
337  */
338 interface IERC20 {
339     /**
340      * @dev Returns the amount of tokens in existence.
341      */
342     function totalSupply() external view returns (uint256);
343 
344     /**
345      * @dev Returns the amount of tokens owned by `account`.
346      */
347     function balanceOf(address account) external view returns (uint256);
348 
349     /**
350      * @dev Moves `amount` tokens from the caller's account to `recipient`.
351      *
352      * Returns a boolean value indicating whether the operation succeeded.
353      *
354      * Emits a {Transfer} event.
355      */
356     function transfer(address recipient, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Returns the remaining number of tokens that `spender` will be
360      * allowed to spend on behalf of `owner` through {transferFrom}. This is
361      * zero by default.
362      *
363      * This value changes when {approve} or {transferFrom} are called.
364      */
365     function allowance(address owner, address spender) external view returns (uint256);
366 
367     /**
368      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * IMPORTANT: Beware that changing an allowance with this method brings the risk
373      * that someone may use both the old and the new allowance by unfortunate
374      * transaction ordering. One possible solution to mitigate this race
375      * condition is to first reduce the spender's allowance to 0 and set the
376      * desired value afterwards:
377      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
378      *
379      * Emits an {Approval} event.
380      */
381     function approve(address spender, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Moves `amount` tokens from `sender` to `recipient` using the
385      * allowance mechanism. `amount` is then deducted from the caller's
386      * allowance.
387      *
388      * Returns a boolean value indicating whether the operation succeeded.
389      *
390      * Emits a {Transfer} event.
391      */
392     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Emitted when `value` tokens are moved from one account (`from`) to
396      * another (`to`).
397      *
398      * Note that `value` may be zero.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 value);
401 
402     /**
403      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
404      * a call to {approve}. `value` is the new allowance.
405      */
406     event Approval(address indexed owner, address indexed spender, uint256 value);
407 }
408 
409 
410 // SPDX-License-Identifier: MIT
411 
412 
413 /**
414  * @title ERC20 Token
415  *
416  * Basic ERC20 Implementation
417  */
418 contract BaseERC20 is IERC20 {
419 
420     using SafeMath for uint256;
421 
422     mapping (address => uint256) private _balances;
423 
424     mapping (address => mapping (address => uint256)) private _allowances;
425 
426     uint256 private _totalSupply;
427 
428     string private _name;
429     string private _symbol;
430     uint8 private _decimals;
431 
432     /**
433      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
434      * a default value of 18.
435      *
436      * To select a different value for {decimals}, use {_setupDecimals}.
437      *
438      * All three of these values are immutable: they can only be set once during
439      * construction.
440      */
441     constructor (
442         string memory name,
443         string memory symbol
444     )
445         public
446     {
447         _name = name;
448         _symbol = symbol;
449         _decimals = 18;
450     }
451 
452     /**
453      * @dev Returns the name of the token.
454      */
455     function name()
456         public
457         view
458         returns (string memory)
459     {
460         return _name;
461     }
462 
463     /**
464      * @dev Returns the symbol of the token, usually a shorter version of the
465      * name.
466      */
467     function symbol()
468         public
469         view
470         returns (string memory)
471     {
472         return _symbol;
473     }
474 
475     /**
476      * @dev Returns the number of decimals used to get its user representation.
477      * For example, if `decimals` equals `2`, a balance of `505` tokens should
478      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
479      *
480      * Tokens usually opt for a value of 18, imitating the relationship between
481      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
482      * called.
483      *
484      * NOTE: This information is only used for _display_ purposes: it in
485      * no way affects any of the arithmetic of the contract, including
486      * {IERC20-balanceOf} and {IERC20-transfer}.
487      */
488     function decimals()
489         public
490         view
491         returns (uint8)
492     {
493         return _decimals;
494     }
495 
496     /**
497      * @dev See {IERC20-totalSupply}.
498      */
499     function totalSupply()
500         public
501         view
502         returns (uint256)
503     {
504         return _totalSupply;
505     }
506 
507     /**
508      * @dev See {IERC20-balanceOf}.
509      */
510     function balanceOf(
511         address account
512     )
513         public
514         view
515         returns (uint256)
516     {
517         return _balances[account];
518     }
519 
520     /**
521      * @dev See {IERC20-transfer}.
522      *
523      * Requirements:
524      *
525      * - `recipient` cannot be the zero address.
526      * - the caller must have a balance of at least `amount`.
527      */
528     function transfer(
529         address recipient,
530         uint256 amount
531     )
532         public
533         returns (bool)
534     {
535         _transfer(msg.sender, recipient, amount);
536         return true;
537     }
538 
539     /**
540      * @dev See {IERC20-allowance}.
541      */
542     function allowance(
543         address owner,
544         address spender
545     )
546         public
547         view
548         returns (uint256)
549     {
550         return _allowances[owner][spender];
551     }
552 
553     /**
554      * @dev See {IERC20-approve}.
555      *
556      * Requirements:
557      *
558      * - `spender` cannot be the zero address.
559      */
560     function approve(
561         address spender,
562         uint256 amount
563     )
564         public
565         returns (bool)
566     {
567         _approve(msg.sender, spender, amount);
568         return true;
569     }
570 
571     /**
572      * @dev See {IERC20-transferFrom}.
573      *
574      * Emits an {Approval} event indicating the updated allowance. This is not
575      * required by the EIP. See the note at the beginning of {ERC20};
576      *
577      * Requirements:
578      * - `sender` and `recipient` cannot be the zero address.
579      * - `sender` must have a balance of at least `amount`.
580      * - the caller must have allowance for ``sender``'s tokens of at least
581      * `amount`.
582      */
583     function transferFrom(
584         address sender,
585         address recipient,
586         uint256 amount
587     )
588         public
589         returns (bool)
590     {
591         _transfer(sender, recipient, amount);
592         _approve(
593             sender,
594             msg.sender,
595             _allowances[sender][msg.sender].sub(
596                 amount, "ERC20: transfer amount exceeds allowance"
597             )
598         );
599 
600         return true;
601     }
602 
603     /**
604      * @dev Atomically increases the allowance granted to `spender` by the caller.
605      *
606      * This is an alternative to {approve} that can be used as a mitigation for
607      * problems described in {IERC20-approve}.
608      *
609      * Emits an {Approval} event indicating the updated allowance.
610      *
611      * Requirements:
612      *
613      * - `spender` cannot be the zero address.
614      */
615     function increaseAllowance(
616         address spender,
617         uint256 addedValue
618     )
619         public
620         returns (bool)
621     {
622         _approve(
623             msg.sender,
624             spender,
625             _allowances[msg.sender][spender].add(addedValue)
626         );
627 
628         return true;
629     }
630 
631     /**
632      * @dev Atomically decreases the allowance granted to `spender` by the caller.
633      *
634      * This is an alternative to {approve} that can be used as a mitigation for
635      * problems described in {IERC20-approve}.
636      *
637      * Emits an {Approval} event indicating the updated allowance.
638      *
639      * Requirements:
640      *
641      * - `spender` cannot be the zero address.
642      * - `spender` must have allowance for the caller of at least
643      * `subtractedValue`.
644      */
645     function decreaseAllowance(
646         address spender,
647         uint256 subtractedValue
648     )
649         public
650         returns (bool)
651     {
652         _approve(
653             msg.sender,
654             spender,
655             _allowances[msg.sender][spender].sub(
656                 subtractedValue, "ERC20: decreased allowance below zero"
657             )
658         );
659 
660         return true;
661     }
662 
663     /**
664      * @dev Moves tokens `amount` from `sender` to `recipient`.
665      *
666      * This is internal function is equivalent to {transfer}, and can be used to
667      * e.g. implement automatic token fees, slashing mechanisms, etc.
668      *
669      * Emits a {Transfer} event.
670      *
671      * Requirements:
672      *
673      * - `sender` cannot be the zero address.
674      * - `recipient` cannot be the zero address.
675      * - `sender` must have a balance of at least `amount`.
676      */
677     function _transfer(
678         address sender,
679         address recipient,
680         uint256 amount
681     )
682         internal
683     {
684         require(
685             sender != address(0),
686             "ERC20: transfer from the zero address"
687         );
688 
689         require(
690             recipient != address(0),
691             "ERC20: transfer to the zero address"
692         );
693 
694         _beforeTokenTransfer(sender, recipient, amount);
695 
696         _balances[sender] = _balances[sender].sub(
697             amount,
698             "ERC20: transfer amount exceeds balance"
699         );
700 
701         _balances[recipient] = _balances[recipient].add(amount);
702         emit Transfer(sender, recipient, amount);
703     }
704 
705     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
706      * the total supply.
707      *
708      * Emits a {Transfer} event with `from` set to the zero address.
709      *
710      * Requirements
711      *
712      * - `to` cannot be the zero address.
713      */
714     function _mint(
715         address account,
716         uint256 amount
717     )
718         internal
719     {
720         require(account != address(0), "ERC20: mint to the zero address");
721 
722         _beforeTokenTransfer(address(0), account, amount);
723 
724         _totalSupply = _totalSupply.add(amount);
725         _balances[account] = _balances[account].add(amount);
726         emit Transfer(address(0), account, amount);
727     }
728 
729     /**
730      * @dev Destroys `amount` tokens from `account`, reducing the
731      * total supply.
732      *
733      * Emits a {Transfer} event with `to` set to the zero address.
734      *
735      * Requirements
736      *
737      * - `account` cannot be the zero address.
738      * - `account` must have at least `amount` tokens.
739      */
740     function _burn(
741         address account,
742         uint256 amount
743     )
744         internal
745     {
746         require(account != address(0), "ERC20: burn from the zero address");
747 
748         _beforeTokenTransfer(account, address(0), amount);
749 
750         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
751         _totalSupply = _totalSupply.sub(amount);
752         emit Transfer(account, address(0), amount);
753     }
754 
755     /**
756      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
757      *
758      * This internal function is equivalent to `approve`, and can be used to
759      * e.g. set automatic allowances for certain subsystems, etc.
760      *
761      * Emits an {Approval} event.
762      *
763      * Requirements:
764      *
765      * - `owner` cannot be the zero address.
766      * - `spender` cannot be the zero address.
767      */
768     function _approve(
769         address owner,
770         address spender,
771         uint256 amount
772     )
773         internal
774     {
775         require(owner != address(0), "ERC20: approve from the zero address");
776         require(spender != address(0), "ERC20: approve to the zero address");
777 
778         _allowances[owner][spender] = amount;
779         emit Approval(owner, spender, amount);
780     }
781 
782     /**
783      * @dev Sets {decimals} to a value other than the default one of 18.
784      *
785      * WARNING: This function should only be called from the constructor. Most
786      * applications that interact with token contracts will not expect
787      * {decimals} to ever change, and may work incorrectly if it does.
788      */
789     function _setupDecimals(uint8 decimals_) internal {
790         _decimals = decimals_;
791     }
792 
793     /**
794      * @dev Hook that is called before any transfer of tokens. This includes
795      * minting and burning.
796      *
797      * Calling conditions:
798      *
799      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
800      * will be to transferred to `to`.
801      * - when `from` is zero, `amount` tokens will be minted for `to`.
802      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
803      * - `from` and `to` are never both zero.
804      *
805      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
806      */
807     function _beforeTokenTransfer(
808         address from,
809         address to,
810         uint256 amount
811     ) internal { }
812 
813 }
814 
815 
816 // SPDX-License-Identifier: MIT
817 
818 
819 contract ArcxToken is BaseERC20, IMintableToken, Ownable {
820 
821     // ============ Constructor ============
822 
823     constructor()
824         public
825         BaseERC20("ARC Governance Token", "ARCX")
826     { }
827 
828     // ============ Core Functions ============
829 
830     function mint(
831         address to,
832         uint256 value
833     )
834         external
835         onlyOwner
836     {
837         _mint(to, value);
838     }
839 
840     function burn(
841         address to,
842         uint256 value
843     )
844         external
845         onlyOwner
846     {
847         _burn(to, value);
848     }
849 
850 }