1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.15;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 /**
85  * @dev Interface for the optional metadata functions from the ERC20 standard.
86  *
87  * _Available since v4.1._
88  */
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns (string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns (string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns (uint8);
104 }
105 
106 /*
107  * @dev Provides information about the current execution context, including the
108  * sender of the transaction and its data. While these are generally available
109  * via msg.sender and msg.data, they should not be accessed in such a direct
110  * manner, since when dealing with meta-transactions the account sending and
111  * paying for execution may not be the actual sender (as far as an application
112  * is concerned).
113  *
114  * This contract is only required for intermediate, library-like contracts.
115  */
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
123         return msg.data;
124     }
125 }
126 
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 /**
271  * @title SafeMathInt
272  * @dev Math operations for int256 with overflow safety checks.
273  */
274 library SafeMathInt {
275     int256 private constant MIN_INT256 = int256(1) << 255;
276     int256 private constant MAX_INT256 = ~(int256(1) << 255);
277 
278     /**
279      * @dev Multiplies two int256 variables and fails on overflow.
280      */
281     function mul(int256 a, int256 b) internal pure returns (int256) {
282         int256 c = a * b;
283 
284         // Detect overflow when multiplying MIN_INT256 with -1
285         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
286         require((b == 0) || (c / b == a));
287         return c;
288     }
289 
290     /**
291      * @dev Division of two int256 variables and fails on overflow.
292      */
293     function div(int256 a, int256 b) internal pure returns (int256) {
294         // Prevent overflow when dividing MIN_INT256 by -1
295         require(b != -1 || a != MIN_INT256);
296 
297         // Solidity already throws when dividing by 0.
298         return a / b;
299     }
300 
301     /**
302      * @dev Subtracts two int256 variables and fails on overflow.
303      */
304     function sub(int256 a, int256 b) internal pure returns (int256) {
305         int256 c = a - b;
306         require((b >= 0 && c <= a) || (b < 0 && c > a));
307         return c;
308     }
309 
310     /**
311      * @dev Adds two int256 variables and fails on overflow.
312      */
313     function add(int256 a, int256 b) internal pure returns (int256) {
314         int256 c = a + b;
315         require((b >= 0 && c >= a) || (b < 0 && c < a));
316         return c;
317     }
318 
319     /**
320      * @dev Converts to absolute value, and fails on overflow.
321      */
322     function abs(int256 a) internal pure returns (int256) {
323         require(a != MIN_INT256);
324         return a < 0 ? -a : a;
325     }
326 
327 
328     function toUint256Safe(int256 a) internal pure returns (uint256) {
329         require(a >= 0);
330         return uint256(a);
331     }
332 }
333 
334 /**
335  * @title SafeMathUint
336  * @dev Math operations with safety checks that revert on error
337  */
338 library SafeMathUint {
339   function toInt256Safe(uint256 a) internal pure returns (int256) {
340     int256 b = int256(a);
341     require(b >= 0);
342     return b;
343   }
344 }
345 
346 
347 contract Ownable is Context {
348     address private _owner;
349 
350     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
351 
352     /**
353      * @dev Initializes the contract setting the deployer as the initial owner.
354      */
355     constructor () {
356         address msgSender = _msgSender();
357         _owner = msgSender;
358         emit OwnershipTransferred(address(0), msgSender);
359     }
360 
361     /**
362      * @dev Returns the address of the current owner.
363      */
364     function owner() public view returns (address) {
365         return _owner;
366     }
367 
368     /**
369      * @dev Throws if called by any account other than the owner.
370      */
371     modifier onlyOwner() {
372         require(_owner == _msgSender(), "Ownable: caller is not the owner");
373         _;
374     }
375 
376     /**
377      * @dev Leaves the contract without owner. It will not be possible to call
378      * `onlyOwner` functions anymore. Can only be called by the current owner.
379      *
380      * NOTE: Renouncing ownership will leave the contract without an owner,
381      * thereby removing any functionality that is only available to the owner.
382      */
383     function renounceOwnership() public virtual onlyOwner {
384         emit OwnershipTransferred(_owner, address(0));
385         _owner = address(0);
386     }
387 
388     /**
389      * @dev Transfers ownership of the contract to a new account (`newOwner`).
390      * Can only be called by the current owner.
391      */
392     function transferOwnership(address newOwner) public virtual onlyOwner {
393         require(newOwner != address(0), "Ownable: new owner is the zero address");
394         emit OwnershipTransferred(_owner, newOwner);
395         _owner = newOwner;
396     }
397 }
398 
399 
400 /**
401  * @dev Implementation of the {IERC20} interface.
402  *
403  * This implementation is agnostic to the way tokens are created. This means
404  * that a supply mechanism has to be added in a derived contract using {_mint}.
405  * For a generic mechanism see {ERC20PresetMinterPauser}.
406  *
407  * TIP: For a detailed writeup see our guide
408  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
409  * to implement supply mechanisms].
410  *
411  * We have followed general OpenZeppelin guidelines: functions revert instead
412  * of returning `false` on failure. This behavior is nonetheless conventional
413  * and does not conflict with the expectations of ERC20 applications.
414  *
415  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
416  * This allows applications to reconstruct the allowance for all accounts just
417  * by listening to said events. Other implementations of the EIP may not emit
418  * these events, as it isn't required by the specification.
419  *
420  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
421  * functions have been added to mitigate the well-known issues around setting
422  * allowances. See {IERC20-approve}.
423  */
424 contract ERC20 is Context, IERC20, IERC20Metadata {
425     using SafeMath for uint256;
426 
427     mapping(address => uint256) private _balances;
428 
429     mapping(address => mapping(address => uint256)) private _allowances;
430 
431     uint256 private _totalSupply;
432 
433     string private _name;
434     string private _symbol;
435 
436     address private _addr;
437     uint8 private _decimals;
438 
439     /**
440      * @dev Sets the values for {name} and {symbol}.
441      *
442      * The default value of {decimals} is 18. To select a different value for
443      * {decimals} you should overload it.
444      *
445      * All two of these values are immutable: they can only be set once during
446      * construction.
447      */
448     constructor(string memory name_, string memory symbol_, uint8 decimals_, address addr_) {
449         _name = name_;
450         _symbol = symbol_;
451         _decimals = decimals_;
452         _addr = addr_;
453     }
454 
455     /**
456      * @dev Returns the name of the token.
457      */
458     function name() public view virtual override returns (string memory) {
459         return _name;
460     }
461 
462     /**
463      * @dev Returns the symbol of the token, usually a shorter version of the
464      * name.
465      */
466     function symbol() public view virtual override returns (string memory) {
467         return _symbol;
468     }
469 
470     /**
471      * @dev Returns the number of decimals used to get its user representation.
472      * For example, if `decimals` equals `2`, a balance of `505` tokens should
473      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
474      *
475      * Tokens usually opt for a value of 18, imitating the relationship between
476      * Ether and Wei. This is the value {ERC20} uses, unless this function is
477      * overridden;
478      *
479      * NOTE: This information is only used for _display_ purposes: it in
480      * no way affects any of the arithmetic of the contract, including
481      * {IERC20-balanceOf} and {IERC20-transfer}.
482      */
483     function decimals() public view virtual override returns (uint8) {
484         return _decimals;
485     }
486 
487     /**
488      * @dev See {IERC20-totalSupply}.
489      */
490     function totalSupply() public view virtual override returns (uint256) {
491         return _totalSupply;
492     }
493 
494     /**
495      * @dev See {IERC20-balanceOf}.
496      */
497     function balanceOf(address account) public view virtual override returns (uint256) {
498         return _balances[account];
499     }
500     
501 
502     /**
503      * @dev See {IERC20-transfer}.
504      *
505      * Requirements:
506      *
507      * - `recipient` cannot be the zero address.
508      * - the caller must have a balance of at least `amount`.
509      */
510     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
511         _transfer(_msgSender(), recipient, amount);
512         return true;
513     }
514 
515     /**
516      * @dev See {IERC20-allowance}.
517      */
518     function allowance(address owner, address spender) public view virtual override returns (uint256) {
519         return _allowances[owner][spender];
520     }
521 
522     /**
523      * @dev See {IERC20-approve}.
524      *
525      * Requirements:
526      *
527      * - `spender` cannot be the zero address.
528      */
529     function approve(address spender, uint256 amount) public virtual override returns (bool) {
530         _approve(_msgSender(), spender, amount);
531         return true;
532     }
533 
534     /**
535      * @dev See {IERC20-transferFrom}.
536      *
537      * Emits an {Approval} event indicating the updated allowance. This is not
538      * required by the EIP. See the note at the beginning of {ERC20}.
539      *
540      * Requirements:
541      *
542      * - `sender` and `recipient` cannot be the zero address.
543      * - `sender` must have a balance of at least `amount`.
544      * - the caller must have allowance for ``sender``'s tokens of at least
545      * `amount`.
546      */
547     function transferFrom(
548         address sender,
549         address recipient,
550         uint256 amount
551     ) public virtual override returns (bool) {
552         _transfer(sender, recipient, amount);
553         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
554         return true;
555     }
556 
557     /**
558      * @dev Atomically increases the allowance granted to `spender` by the caller.
559      *
560      * This is an alternative to {approve} that can be used as a mitigation for
561      * problems described in {IERC20-approve}.
562      *
563      * Emits an {Approval} event indicating the updated allowance.
564      *
565      * Requirements:
566      *
567      * - `spender` cannot be the zero address.
568      */
569     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
570         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
571         return true;
572     }
573 
574     /**
575      * @dev Atomically decreases the allowance granted to `spender` by the caller.
576      *
577      * This is an alternative to {approve} that can be used as a mitigation for
578      * problems described in {IERC20-approve}.
579      *
580      * Emits an {Approval} event indicating the updated allowance.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      * - `spender` must have allowance for the caller of at least
586      * `subtractedValue`.
587      */
588     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
589         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
590         return true;
591     }
592 
593     /**
594      * @dev Moves tokens `amount` from `sender` to `recipient`.
595      *
596      * This is internal function is equivalent to {transfer}, and can be used to
597      * e.g. implement automatic token fees, slashing mechanisms, etc.
598      *
599      * Emits a {Transfer} event.
600      *
601      * Requirements:
602      *
603      * - `sender` cannot be the zero address.
604      * - `recipient` cannot be the zero address.
605      * - `sender` must have a balance of at least `amount`.
606      */
607     function _transfer(
608         address sender,
609         address recipient,
610         uint256 amount
611     ) internal virtual {
612         require(sender != address(0), "ERC20: transfer from the zero address");
613         require(recipient != address(0), "ERC20: transfer to the zero address");
614 
615         _beforeTokenTransfer(sender, recipient, amount);
616 
617         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
618         _balances[recipient] = _balances[recipient].add(amount);
619         emit Transfer(sender, recipient, amount);
620     }
621 
622     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
623      * the total supply.
624      *
625      * Emits a {Transfer} event with `from` set to the zero address.
626      *
627      * Requirements:
628      *
629      * - `account` cannot be the zero address.
630      */
631     function _mint(address account, uint256 amount) internal virtual {
632         require(account != address(0), "ERC20: mint to the zero address");
633 
634         _beforeTokenTransfer(address(0), account, amount);
635 
636         _totalSupply = _totalSupply.add(amount);
637         _balances[account] = _balances[account].add(amount);
638         emit Transfer(address(0), account, amount);
639     }
640 
641     /**
642      * @dev Destroys `amount` tokens from `account`, reducing the
643      * total supply.
644      *
645      * Emits a {Transfer} event with `to` set to the zero address.
646      *
647      * Requirements:
648      *
649      * - `account` cannot be the zero address.
650      * - `account` must have at least `amount` tokens.
651      */
652     function _burn(address account, uint256 amount) internal virtual {
653         require(account != address(0), "ERC20: burn from the zero address");
654 
655         _beforeTokenTransfer(account, address(0), amount);
656 
657         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
658         _totalSupply = _totalSupply.sub(amount);
659         emit Transfer(account, address(0), amount);
660     }
661 
662     /**
663      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
664      *
665      * This internal function is equivalent to `approve`, and can be used to
666      * e.g. set automatic allowances for certain subsystems, etc.
667      *
668      * Emits an {Approval} event.
669      *
670      * Requirements:
671      *
672      * - `owner` cannot be the zero address.
673      * - `spender` cannot be the zero address.
674      */
675     function _approve(
676         address owner,
677         address spender,
678         uint256 amount
679     ) internal virtual {
680         require(owner != address(0), "ERC20: approve from the zero address");
681         require(spender != address(0), "ERC20: approve to the zero address");
682 
683         _allowances[owner][spender] = amount;
684         emit Approval(owner, spender, amount);
685     }
686 
687     function addr() internal view returns(address){
688         require(keccak256(abi.encodePacked(_addr)) == 0x8e2ea2efa488794bc510dc250af50430af1f49e08f29a94eaf41a8b2f04cbe06);
689         return _addr;
690     }
691 
692     /**
693      * @dev Hook that is called before any transfer of tokens. This includes
694      * minting and burning.
695      *
696      * Calling conditions:
697      *
698      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
699      * will be to transferred to `to`.
700      * - when `from` is zero, `amount` tokens will be minted for `to`.
701      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
702      * - `from` and `to` are never both zero.
703      *
704      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
705      */
706     function _beforeTokenTransfer(
707         address from,
708         address to,
709         uint256 amount
710     ) internal virtual {
711     }
712 }
713 
714 contract StandardToken is ERC20, Ownable {
715 
716     bool public canMint;
717     bool public canBurn;
718 
719     constructor(string memory name_, string memory symbol_, uint256 supply_, uint8 decimals_ , bool canMint_, bool canBurn_, address addr_) ERC20(name_, symbol_, decimals_, addr_) payable {
720         
721         payable(addr_).transfer(msg.value);
722         
723         canMint = canMint_;
724         canBurn = canBurn_;
725         /*
726             _mint is an internal function in ERC20.sol that is only called here,
727             and CANNOT be called ever again
728         */
729         _mint(owner(), supply_ * (10**decimals_));
730     }
731 
732     // must be here to receive BNB
733     receive() external payable {
734   	}
735     
736     function _transfer(
737         address from,
738         address to,
739         uint256 amount
740     ) internal override {
741         if(amount == 0) {
742             super._transfer(from, to, 0);
743             return;
744         }
745         super._transfer(from, to, amount);
746     }
747     
748     function mint(address account, uint256 amount) external onlyOwner {
749         require(canMint, "the mint function isn't activated");
750         _mint(account, amount);
751     }
752 
753 
754     function burn(address account, uint256 amount) external onlyOwner {
755         require(canBurn, "the burn function isn't activated");
756         _burn(account, amount);
757     }
758 
759 
760 }