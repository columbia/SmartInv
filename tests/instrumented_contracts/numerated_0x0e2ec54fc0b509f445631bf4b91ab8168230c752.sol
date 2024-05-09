1 /*
2 
3     /     |  __    / ____|
4    /      | |__) | | |
5   / /    |  _  /  | |
6  / ____   | |    | |____
7 /_/    _ |_|  _  _____|
8 
9 * ARC: token/SyntheticToken.sol
10 *
11 * Latest source (may be newer): https://github.com/arcxgame/contracts/blob/master/contracts/token/SyntheticToken.sol
12 *
13 * Contract Dependencies: 
14 *	- BaseERC20
15 *	- Context
16 *	- IERC20
17 *	- ISyntheticToken
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
161 interface ISyntheticToken {
162 
163     function symbolKey()
164         external
165         view
166         returns (bytes32);
167 
168     function mint(
169         address to,
170         uint256 value
171     )
172         external;
173 
174     function burn(
175         address to,
176         uint256 value
177     )
178         external;
179 
180     function transferCollateral(
181         address token,
182         address to,
183         uint256 value
184     )
185         external
186         returns (bool);
187 
188 
189 }
190 
191 
192 /**
193  * @dev Wrappers over Solidity's arithmetic operations with added overflow
194  * checks.
195  *
196  * Arithmetic operations in Solidity wrap on overflow. This can easily result
197  * in bugs, because programmers usually assume that an overflow raises an
198  * error, which is the standard behavior in high level programming languages.
199  * `SafeMath` restores this intuition by reverting the transaction when an
200  * operation overflows.
201  *
202  * Using this library instead of the unchecked operations eliminates an entire
203  * class of bugs, so it's recommended to use it always.
204  */
205 library SafeMath {
206     /**
207      * @dev Returns the addition of two unsigned integers, reverting on
208      * overflow.
209      *
210      * Counterpart to Solidity's `+` operator.
211      *
212      * Requirements:
213      * - Addition cannot overflow.
214      */
215     function add(uint256 a, uint256 b) internal pure returns (uint256) {
216         uint256 c = a + b;
217         require(c >= a, "SafeMath: addition overflow");
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      * - Subtraction cannot overflow.
230      */
231     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232         return sub(a, b, "SafeMath: subtraction overflow");
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      * - Subtraction cannot overflow.
243      *
244      * _Available since v2.4.0._
245      */
246     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b <= a, errorMessage);
248         uint256 c = a - b;
249 
250         return c;
251     }
252 
253     /**
254      * @dev Returns the multiplication of two unsigned integers, reverting on
255      * overflow.
256      *
257      * Counterpart to Solidity's `*` operator.
258      *
259      * Requirements:
260      * - Multiplication cannot overflow.
261      */
262     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
263         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
264         // benefit is lost if 'b' is also tested.
265         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
266         if (a == 0) {
267             return 0;
268         }
269 
270         uint256 c = a * b;
271         require(c / a == b, "SafeMath: multiplication overflow");
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers. Reverts on
278      * division by zero. The result is rounded towards zero.
279      *
280      * Counterpart to Solidity's `/` operator. Note: this function uses a
281      * `revert` opcode (which leaves remaining gas untouched) while Solidity
282      * uses an invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      * - The divisor cannot be zero.
286      */
287     function div(uint256 a, uint256 b) internal pure returns (uint256) {
288         return div(a, b, "SafeMath: division by zero");
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
293      * division by zero. The result is rounded towards zero.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      *
302      * _Available since v2.4.0._
303      */
304     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         // Solidity only automatically asserts when dividing by 0
306         require(b > 0, errorMessage);
307         uint256 c = a / b;
308         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
315      * Reverts when dividing by zero.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      * - The divisor cannot be zero.
323      */
324     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
325         return mod(a, b, "SafeMath: modulo by zero");
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * Reverts with custom message when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      * - The divisor cannot be zero.
338      *
339      * _Available since v2.4.0._
340      */
341     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         require(b != 0, errorMessage);
343         return a % b;
344     }
345 }
346 
347 
348 /**
349  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
350  * the optional functions; to access them see {ERC20Detailed}.
351  */
352 interface IERC20 {
353     /**
354      * @dev Returns the amount of tokens in existence.
355      */
356     function totalSupply() external view returns (uint256);
357 
358     /**
359      * @dev Returns the amount of tokens owned by `account`.
360      */
361     function balanceOf(address account) external view returns (uint256);
362 
363     /**
364      * @dev Moves `amount` tokens from the caller's account to `recipient`.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * Emits a {Transfer} event.
369      */
370     function transfer(address recipient, uint256 amount) external returns (bool);
371 
372     /**
373      * @dev Returns the remaining number of tokens that `spender` will be
374      * allowed to spend on behalf of `owner` through {transferFrom}. This is
375      * zero by default.
376      *
377      * This value changes when {approve} or {transferFrom} are called.
378      */
379     function allowance(address owner, address spender) external view returns (uint256);
380 
381     /**
382      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * IMPORTANT: Beware that changing an allowance with this method brings the risk
387      * that someone may use both the old and the new allowance by unfortunate
388      * transaction ordering. One possible solution to mitigate this race
389      * condition is to first reduce the spender's allowance to 0 and set the
390      * desired value afterwards:
391      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
392      *
393      * Emits an {Approval} event.
394      */
395     function approve(address spender, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Moves `amount` tokens from `sender` to `recipient` using the
399      * allowance mechanism. `amount` is then deducted from the caller's
400      * allowance.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Emitted when `value` tokens are moved from one account (`from`) to
410      * another (`to`).
411      *
412      * Note that `value` may be zero.
413      */
414     event Transfer(address indexed from, address indexed to, uint256 value);
415 
416     /**
417      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
418      * a call to {approve}. `value` is the new allowance.
419      */
420     event Approval(address indexed owner, address indexed spender, uint256 value);
421 }
422 
423 
424 // SPDX-License-Identifier: MIT
425 
426 
427 /**
428  * @title ERC20 Token
429  *
430  * Basic ERC20 Implementation
431  */
432 contract BaseERC20 is IERC20 {
433 
434     using SafeMath for uint256;
435 
436     mapping (address => uint256) private _balances;
437 
438     mapping (address => mapping (address => uint256)) private _allowances;
439 
440     uint256 private _totalSupply;
441 
442     string private _name;
443     string private _symbol;
444     uint8 private _decimals;
445 
446     /**
447      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
448      * a default value of 18.
449      *
450      * To select a different value for {decimals}, use {_setupDecimals}.
451      *
452      * All three of these values are immutable: they can only be set once during
453      * construction.
454      */
455     constructor (
456         string memory name,
457         string memory symbol
458     )
459         public
460     {
461         _name = name;
462         _symbol = symbol;
463         _decimals = 18;
464     }
465 
466     /**
467      * @dev Returns the name of the token.
468      */
469     function name()
470         public
471         view
472         returns (string memory)
473     {
474         return _name;
475     }
476 
477     /**
478      * @dev Returns the symbol of the token, usually a shorter version of the
479      * name.
480      */
481     function symbol()
482         public
483         view
484         returns (string memory)
485     {
486         return _symbol;
487     }
488 
489     /**
490      * @dev Returns the number of decimals used to get its user representation.
491      * For example, if `decimals` equals `2`, a balance of `505` tokens should
492      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
493      *
494      * Tokens usually opt for a value of 18, imitating the relationship between
495      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
496      * called.
497      *
498      * NOTE: This information is only used for _display_ purposes: it in
499      * no way affects any of the arithmetic of the contract, including
500      * {IERC20-balanceOf} and {IERC20-transfer}.
501      */
502     function decimals()
503         public
504         view
505         returns (uint8)
506     {
507         return _decimals;
508     }
509 
510     /**
511      * @dev See {IERC20-totalSupply}.
512      */
513     function totalSupply()
514         public
515         view
516         returns (uint256)
517     {
518         return _totalSupply;
519     }
520 
521     /**
522      * @dev See {IERC20-balanceOf}.
523      */
524     function balanceOf(
525         address account
526     )
527         public
528         view
529         returns (uint256)
530     {
531         return _balances[account];
532     }
533 
534     /**
535      * @dev See {IERC20-transfer}.
536      *
537      * Requirements:
538      *
539      * - `recipient` cannot be the zero address.
540      * - the caller must have a balance of at least `amount`.
541      */
542     function transfer(
543         address recipient,
544         uint256 amount
545     )
546         public
547         returns (bool)
548     {
549         _transfer(msg.sender, recipient, amount);
550         return true;
551     }
552 
553     /**
554      * @dev See {IERC20-allowance}.
555      */
556     function allowance(
557         address owner,
558         address spender
559     )
560         public
561         view
562         returns (uint256)
563     {
564         return _allowances[owner][spender];
565     }
566 
567     /**
568      * @dev See {IERC20-approve}.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      */
574     function approve(
575         address spender,
576         uint256 amount
577     )
578         public
579         returns (bool)
580     {
581         _approve(msg.sender, spender, amount);
582         return true;
583     }
584 
585     /**
586      * @dev See {IERC20-transferFrom}.
587      *
588      * Emits an {Approval} event indicating the updated allowance. This is not
589      * required by the EIP. See the note at the beginning of {ERC20};
590      *
591      * Requirements:
592      * - `sender` and `recipient` cannot be the zero address.
593      * - `sender` must have a balance of at least `amount`.
594      * - the caller must have allowance for ``sender``'s tokens of at least
595      * `amount`.
596      */
597     function transferFrom(
598         address sender,
599         address recipient,
600         uint256 amount
601     )
602         public
603         returns (bool)
604     {
605         _transfer(sender, recipient, amount);
606         _approve(
607             sender,
608             msg.sender,
609             _allowances[sender][msg.sender].sub(
610                 amount, "ERC20: transfer amount exceeds allowance"
611             )
612         );
613 
614         return true;
615     }
616 
617     /**
618      * @dev Atomically increases the allowance granted to `spender` by the caller.
619      *
620      * This is an alternative to {approve} that can be used as a mitigation for
621      * problems described in {IERC20-approve}.
622      *
623      * Emits an {Approval} event indicating the updated allowance.
624      *
625      * Requirements:
626      *
627      * - `spender` cannot be the zero address.
628      */
629     function increaseAllowance(
630         address spender,
631         uint256 addedValue
632     )
633         public
634         returns (bool)
635     {
636         _approve(
637             msg.sender,
638             spender,
639             _allowances[msg.sender][spender].add(addedValue)
640         );
641 
642         return true;
643     }
644 
645     /**
646      * @dev Atomically decreases the allowance granted to `spender` by the caller.
647      *
648      * This is an alternative to {approve} that can be used as a mitigation for
649      * problems described in {IERC20-approve}.
650      *
651      * Emits an {Approval} event indicating the updated allowance.
652      *
653      * Requirements:
654      *
655      * - `spender` cannot be the zero address.
656      * - `spender` must have allowance for the caller of at least
657      * `subtractedValue`.
658      */
659     function decreaseAllowance(
660         address spender,
661         uint256 subtractedValue
662     )
663         public
664         returns (bool)
665     {
666         _approve(
667             msg.sender,
668             spender,
669             _allowances[msg.sender][spender].sub(
670                 subtractedValue, "ERC20: decreased allowance below zero"
671             )
672         );
673 
674         return true;
675     }
676 
677     /**
678      * @dev Moves tokens `amount` from `sender` to `recipient`.
679      *
680      * This is internal function is equivalent to {transfer}, and can be used to
681      * e.g. implement automatic token fees, slashing mechanisms, etc.
682      *
683      * Emits a {Transfer} event.
684      *
685      * Requirements:
686      *
687      * - `sender` cannot be the zero address.
688      * - `recipient` cannot be the zero address.
689      * - `sender` must have a balance of at least `amount`.
690      */
691     function _transfer(
692         address sender,
693         address recipient,
694         uint256 amount
695     )
696         internal
697     {
698         require(
699             sender != address(0),
700             "ERC20: transfer from the zero address"
701         );
702 
703         require(
704             recipient != address(0),
705             "ERC20: transfer to the zero address"
706         );
707 
708         _beforeTokenTransfer(sender, recipient, amount);
709 
710         _balances[sender] = _balances[sender].sub(
711             amount,
712             "ERC20: transfer amount exceeds balance"
713         );
714 
715         _balances[recipient] = _balances[recipient].add(amount);
716         emit Transfer(sender, recipient, amount);
717     }
718 
719     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
720      * the total supply.
721      *
722      * Emits a {Transfer} event with `from` set to the zero address.
723      *
724      * Requirements
725      *
726      * - `to` cannot be the zero address.
727      */
728     function _mint(
729         address account,
730         uint256 amount
731     )
732         internal
733     {
734         require(account != address(0), "ERC20: mint to the zero address");
735 
736         _beforeTokenTransfer(address(0), account, amount);
737 
738         _totalSupply = _totalSupply.add(amount);
739         _balances[account] = _balances[account].add(amount);
740         emit Transfer(address(0), account, amount);
741     }
742 
743     /**
744      * @dev Destroys `amount` tokens from `account`, reducing the
745      * total supply.
746      *
747      * Emits a {Transfer} event with `to` set to the zero address.
748      *
749      * Requirements
750      *
751      * - `account` cannot be the zero address.
752      * - `account` must have at least `amount` tokens.
753      */
754     function _burn(
755         address account,
756         uint256 amount
757     )
758         internal
759     {
760         require(account != address(0), "ERC20: burn from the zero address");
761 
762         _beforeTokenTransfer(account, address(0), amount);
763 
764         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
765         _totalSupply = _totalSupply.sub(amount);
766         emit Transfer(account, address(0), amount);
767     }
768 
769     /**
770      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
771      *
772      * This internal function is equivalent to `approve`, and can be used to
773      * e.g. set automatic allowances for certain subsystems, etc.
774      *
775      * Emits an {Approval} event.
776      *
777      * Requirements:
778      *
779      * - `owner` cannot be the zero address.
780      * - `spender` cannot be the zero address.
781      */
782     function _approve(
783         address owner,
784         address spender,
785         uint256 amount
786     )
787         internal
788     {
789         require(owner != address(0), "ERC20: approve from the zero address");
790         require(spender != address(0), "ERC20: approve to the zero address");
791 
792         _allowances[owner][spender] = amount;
793         emit Approval(owner, spender, amount);
794     }
795 
796     /**
797      * @dev Sets {decimals} to a value other than the default one of 18.
798      *
799      * WARNING: This function should only be called from the constructor. Most
800      * applications that interact with token contracts will not expect
801      * {decimals} to ever change, and may work incorrectly if it does.
802      */
803     function _setupDecimals(uint8 decimals_) internal {
804         _decimals = decimals_;
805     }
806 
807     /**
808      * @dev Hook that is called before any transfer of tokens. This includes
809      * minting and burning.
810      *
811      * Calling conditions:
812      *
813      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
814      * will be to transferred to `to`.
815      * - when `from` is zero, `amount` tokens will be minted for `to`.
816      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
817      * - `from` and `to` are never both zero.
818      *
819      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
820      */
821     function _beforeTokenTransfer(
822         address from,
823         address to,
824         uint256 amount
825     ) internal { }
826 
827 }
828 
829 
830 // SPDX-License-Identifier: MIT
831 
832 
833 contract SyntheticToken is BaseERC20, ISyntheticToken, Ownable {
834 
835     // ============ Variables ============
836 
837     bytes32 private _symbolKey;
838 
839     address[] public mintersArray;
840 
841     mapping(address => bool) public minters;
842 
843     /* ========== EVENTS ========== */
844 
845     event MinterAdded(address _minter);
846     event MinterRemoved(address _minter);
847 
848     // ============ Modifier ============
849 
850     modifier onlyMinter() {
851         require(
852             minters[msg.sender] == true,
853             "SyntheticToken: only callable by minter"
854         );
855         _;
856     }
857 
858     // ============ Constructor ============
859 
860     constructor(
861         string memory _name,
862         string memory _symbol
863     )
864         public
865         BaseERC20(_name, _symbol)
866     {
867         _symbolKey = keccak256(
868             abi.encode(_symbol)
869         );
870     }
871 
872     /* ========== VIEW FUNCTIONS ========== */
873 
874     function getAllMinters()
875         external
876         view
877         returns (address[] memory)
878     {
879         return mintersArray;
880     }
881 
882     function isValidMinter(
883         address _minter
884     )
885         external
886         view
887         returns (bool)
888     {
889         return minters[_minter];
890     }
891 
892 
893     function symbolKey()
894         external
895         view
896         returns (bytes32)
897     {
898         return _symbolKey;
899     }
900 
901     // ============ Admin Functions ============
902 
903     function addMinter(
904         address _minter
905     )
906         external
907         onlyOwner
908     {
909         require(
910             minters[_minter] != true,
911             "Synth already exists"
912         );
913 
914         mintersArray.push(_minter);
915         minters[_minter] = true;
916 
917         emit MinterAdded(_minter);
918     }
919 
920     function removeMinter(
921         address _minter
922     )
923         external
924         onlyOwner
925     {
926         require(
927             minters[_minter] == true,
928             "Minter does not exist"
929         );
930 
931 
932         // Remove the synth from the availableSynths array.
933         for (uint i = 0; i < mintersArray.length; i++) {
934             if (address(mintersArray[i]) == _minter) {
935                 delete mintersArray[i];
936 
937                 // Copy the last synth into the place of the one we just deleted
938                 // If there's only one synth, this is synths[0] = synths[0].
939                 // If we're deleting the last one, it's also a NOOP in the same way.
940                 mintersArray[i] = mintersArray[mintersArray.length - 1];
941 
942                 // Decrease the size of the array by one.
943                 mintersArray.length--;
944 
945                 break;
946             }
947         }
948 
949         // And remove it from the minters mapping
950         delete minters[_minter];
951 
952         emit MinterRemoved(_minter);
953     }
954 
955     // ============ Minter Functions ============
956 
957     function mint(
958         address to,
959         uint256 value
960     )
961         external
962         onlyMinter
963     {
964         _mint(to, value);
965     }
966 
967     function burn(
968         address to,
969         uint256 value
970     )
971         external
972         onlyMinter
973     {
974         _burn(to, value);
975     }
976 
977     function transferCollateral(
978         address token,
979         address to,
980         uint256 value
981     )
982         external
983         onlyMinter
984         returns (bool)
985     {
986         return BaseERC20(token).transfer(
987             to,
988             value
989         );
990     }
991 
992 }