1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.2;
3 
4 
5 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/utils/math/SafeMath.sol
6 // CAUTION - only use with Solidity 0.8 +
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations.
10  *
11  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
12  * now has built in overflow checking.
13  */
14 library SafeMath {
15     /**
16      * @dev Returns the addition of two unsigned integers, with an overflow flag.
17      *
18      * _Available since v3.4._
19      */
20     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21         unchecked {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25         }
26     }
27 
28     /**
29      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             if (b > a) return (false, 0);
36             return (true, a - b);
37         }
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48             // benefit is lost if 'b' is also tested.
49             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
50             if (a == 0) return (true, 0);
51             uint256 c = a * b;
52             if (c / a != b) return (false, 0);
53             return (true, c);
54         }
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             if (b == 0) return (false, 0);
65             return (true, a / b);
66         }
67     }
68 
69     /**
70      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             if (b == 0) return (false, 0);
77             return (true, a % b);
78         }
79     }
80 
81     /**
82      * @dev Returns the addition of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `+` operator.
86      *
87      * Requirements:
88      *
89      * - Addition cannot overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         return a + b;
93     }
94 
95     /**
96      * @dev Returns the subtraction of two unsigned integers, reverting on
97      * overflow (when the result is negative).
98      *
99      * Counterpart to Solidity's `-` operator.
100      *
101      * Requirements:
102      *
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a - b;
107     }
108 
109     /**
110      * @dev Returns the multiplication of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `*` operator.
114      *
115      * Requirements:
116      *
117      * - Multiplication cannot overflow.
118      */
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a * b;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator.
128      *
129      * Requirements:
130      *
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a / b;
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * reverting when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return a % b;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * CAUTION: This function is deprecated because it requires allocating memory for the error
158      * message unnecessarily. For custom revert reasons use {trySub}.
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         unchecked {
168             require(b <= a, errorMessage);
169             return a - b;
170         }
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         unchecked {
191             require(b > 0, errorMessage);
192             return a / b;
193         }
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * reverting with custom message when dividing by zero.
199      *
200      * CAUTION: This function is deprecated because it requires allocating memory for the error
201      * message unnecessarily. For custom revert reasons use {tryMod}.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a % b;
215         }
216     }
217 }
218 
219 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC20/IERC20.sol
220 /**
221  * @dev Interface of the ERC20 standard as defined in the EIP.
222  */
223 interface IERC20 {
224     /**
225      * @dev Returns the amount of tokens in existence.
226      */
227     function totalSupply() external view returns (uint256);
228 
229     /**
230      * @dev Returns the amount of tokens owned by `account`.
231      */
232     function balanceOf(address account) external view returns (uint256);
233 
234     /**
235      * @dev Moves `amount` tokens from the caller's account to `recipient`.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transfer(address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Returns the remaining number of tokens that `spender` will be
245      * allowed to spend on behalf of `owner` through {transferFrom}. This is
246      * zero by default.
247      *
248      * This value changes when {approve} or {transferFrom} are called.
249      */
250     function allowance(address owner, address spender) external view returns (uint256);
251 
252     /**
253      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * IMPORTANT: Beware that changing an allowance with this method brings the risk
258      * that someone may use both the old and the new allowance by unfortunate
259      * transaction ordering. One possible solution to mitigate this race
260      * condition is to first reduce the spender's allowance to 0 and set the
261      * desired value afterwards:
262      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address spender, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Moves `amount` tokens from `sender` to `recipient` using the
270      * allowance mechanism. `amount` is then deducted from the caller's
271      * allowance.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
278 
279     /**
280      * @dev Emitted when `value` tokens are moved from one account (`from`) to
281      * another (`to`).
282      *
283      * Note that `value` may be zero.
284      */
285     event Transfer(address indexed from, address indexed to, uint256 value);
286 
287     /**
288      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
289      * a call to {approve}. `value` is the new allowance.
290      */
291     event Approval(address indexed owner, address indexed spender, uint256 value);
292 }
293 
294 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/utils/Context.sol
295 /*
296  * @dev Provides information about the current execution context, including the
297  * sender of the transaction and its data. While these are generally available
298  * via msg.sender and msg.data, they should not be accessed in such a direct
299  * manner, since when dealing with meta-transactions the account sending and
300  * paying for execution may not be the actual sender (as far as an application
301  * is concerned).
302  *
303  * This contract is only required for intermediate, library-like contracts.
304  */
305 abstract contract Context {
306     function _msgSender() internal view virtual returns (address) {
307         return msg.sender;
308     }
309 
310     function _msgData() internal view virtual returns (bytes calldata) {
311         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
312         return msg.data;
313     }
314 }
315 
316 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/access/Ownable.sol
317 /**
318  * @dev Contract module which provides a basic access control mechanism, where
319  * there is an account (an owner) that can be granted exclusive access to
320  * specific functions.
321  *
322  * By default, the owner account will be the one that deploys the contract. This
323  * can later be changed with {transferOwnership}.
324  *
325  * This module is used through inheritance. It will make available the modifier
326  * `onlyOwner`, which can be applied to your functions to restrict their use to
327  * the owner.
328  */
329 abstract contract Ownable is Context {
330     address private _owner;
331 
332     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
333 
334     /**
335      * @dev Initializes the contract setting the deployer as the initial owner.
336      */
337     constructor () {
338         address msgSender = _msgSender();
339         _owner = msgSender;
340         emit OwnershipTransferred(address(0), msgSender);
341     }
342 
343     /**
344      * @dev Returns the address of the current owner.
345      */
346     function owner() public view virtual returns (address) {
347         return _owner;
348     }
349 
350     /**
351      * @dev Throws if called by any account other than the owner.
352      */
353     modifier onlyOwner() {
354         require(owner() == _msgSender(), "Ownable: caller is not the owner");
355         _;
356     }
357 
358     /**
359      * @dev Leaves the contract without owner. It will not be possible to call
360      * `onlyOwner` functions anymore. Can only be called by the current owner.
361      *
362      * NOTE: Renouncing ownership will leave the contract without an owner,
363      * thereby removing any functionality that is only available to the owner.
364      */
365     function renounceOwnership() public virtual onlyOwner {
366         emit OwnershipTransferred(_owner, address(0));
367         _owner = address(0);
368     }
369 
370     /**
371      * @dev Transfers ownership of the contract to a new account (`newOwner`).
372      * Can only be called by the current owner.
373      */
374     function transferOwnership(address newOwner) public virtual onlyOwner {
375         require(newOwner != address(0), "Ownable: new owner is the zero address");
376         emit OwnershipTransferred(_owner, newOwner);
377         _owner = newOwner;
378     }
379 }
380 
381 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.0/contracts/token/ERC20/ERC20.sol
382 /**
383  * @dev Implementation of the {IERC20} interface.
384  *
385  * This implementation is agnostic to the way tokens are created. This means
386  * that a supply mechanism has to be added in a derived contract using {_mint}.
387  * For a generic mechanism see {ERC20PresetMinterPauser}.
388  *
389  * TIP: For a detailed writeup see our guide
390  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
391  * to implement supply mechanisms].
392  *
393  * We have followed general OpenZeppelin guidelines: functions revert instead
394  * of returning `false` on failure. This behavior is nonetheless conventional
395  * and does not conflict with the expectations of ERC20 applications.
396  *
397  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
398  * This allows applications to reconstruct the allowance for all accounts just
399  * by listening to said events. Other implementations of the EIP may not emit
400  * these events, as it isn't required by the specification.
401  *
402  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
403  * functions have been added to mitigate the well-known issues around setting
404  * allowances. See {IERC20-approve}.
405  */
406 contract ERC20 is Context, IERC20 {
407     mapping (address => uint256) private _balances;
408 
409     mapping (address => mapping (address => uint256)) private _allowances;
410 
411     uint256 private _totalSupply;
412 
413     string private _name;
414     string private _symbol;
415 
416     /**
417      * @dev Sets the values for {name} and {symbol}.
418      *
419      * The defaut value of {decimals} is 18. To select a different value for
420      * {decimals} you should overload it.
421      *
422      * All three of these values are immutable: they can only be set once during
423      * construction.
424      */
425     constructor (string memory name_, string memory symbol_) {
426         _name = name_;
427         _symbol = symbol_;
428     }
429 
430     /**
431      * @dev Returns the name of the token.
432      */
433     function name() public view virtual returns (string memory) {
434         return _name;
435     }
436 
437     /**
438      * @dev Returns the symbol of the token, usually a shorter version of the
439      * name.
440      */
441     function symbol() public view virtual returns (string memory) {
442         return _symbol;
443     }
444 
445     /**
446      * @dev Returns the number of decimals used to get its user representation.
447      * For example, if `decimals` equals `2`, a balance of `505` tokens should
448      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
449      *
450      * Tokens usually opt for a value of 18, imitating the relationship between
451      * Ether and Wei. This is the value {ERC20} uses, unless this function is
452      * overloaded;
453      *
454      * NOTE: This information is only used for _display_ purposes: it in
455      * no way affects any of the arithmetic of the contract, including
456      * {IERC20-balanceOf} and {IERC20-transfer}.
457      */
458     function decimals() public view virtual returns (uint8) {
459         return 18;
460     }
461 
462     /**
463      * @dev See {IERC20-totalSupply}.
464      */
465     function totalSupply() public view virtual override returns (uint256) {
466         return _totalSupply;
467     }
468 
469     /**
470      * @dev See {IERC20-balanceOf}.
471      */
472     function balanceOf(address account) public view virtual override returns (uint256) {
473         return _balances[account];
474     }
475 
476     /**
477      * @dev See {IERC20-transfer}.
478      *
479      * Requirements:
480      *
481      * - `recipient` cannot be the zero address.
482      * - the caller must have a balance of at least `amount`.
483      */
484     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
485         _transfer(_msgSender(), recipient, amount);
486         return true;
487     }
488 
489     /**
490      * @dev See {IERC20-allowance}.
491      */
492     function allowance(address owner, address spender) public view virtual override returns (uint256) {
493         return _allowances[owner][spender];
494     }
495 
496     /**
497      * @dev See {IERC20-approve}.
498      *
499      * Requirements:
500      *
501      * - `spender` cannot be the zero address.
502      */
503     function approve(address spender, uint256 amount) public virtual override returns (bool) {
504         _approve(_msgSender(), spender, amount);
505         return true;
506     }
507 
508     /**
509      * @dev See {IERC20-transferFrom}.
510      *
511      * Emits an {Approval} event indicating the updated allowance. This is not
512      * required by the EIP. See the note at the beginning of {ERC20}.
513      *
514      * Requirements:
515      *
516      * - `sender` and `recipient` cannot be the zero address.
517      * - `sender` must have a balance of at least `amount`.
518      * - the caller must have allowance for ``sender``'s tokens of at least
519      * `amount`.
520      */
521     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
522         _transfer(sender, recipient, amount);
523 
524         uint256 currentAllowance = _allowances[sender][_msgSender()];
525         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
526         _approve(sender, _msgSender(), currentAllowance - amount);
527 
528         return true;
529     }
530 
531     /**
532      * @dev Atomically increases the allowance granted to `spender` by the caller.
533      *
534      * This is an alternative to {approve} that can be used as a mitigation for
535      * problems described in {IERC20-approve}.
536      *
537      * Emits an {Approval} event indicating the updated allowance.
538      *
539      * Requirements:
540      *
541      * - `spender` cannot be the zero address.
542      */
543     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
544         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
545         return true;
546     }
547 
548     /**
549      * @dev Atomically decreases the allowance granted to `spender` by the caller.
550      *
551      * This is an alternative to {approve} that can be used as a mitigation for
552      * problems described in {IERC20-approve}.
553      *
554      * Emits an {Approval} event indicating the updated allowance.
555      *
556      * Requirements:
557      *
558      * - `spender` cannot be the zero address.
559      * - `spender` must have allowance for the caller of at least
560      * `subtractedValue`.
561      */
562     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
563         uint256 currentAllowance = _allowances[_msgSender()][spender];
564         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
565         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
566 
567         return true;
568     }
569 
570     /**
571      * @dev Moves tokens `amount` from `sender` to `recipient`.
572      *
573      * This is internal function is equivalent to {transfer}, and can be used to
574      * e.g. implement automatic token fees, slashing mechanisms, etc.
575      *
576      * Emits a {Transfer} event.
577      *
578      * Requirements:
579      *
580      * - `sender` cannot be the zero address.
581      * - `recipient` cannot be the zero address.
582      * - `sender` must have a balance of at least `amount`.
583      */
584     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
585         require(sender != address(0), "ERC20: transfer from the zero address");
586         require(recipient != address(0), "ERC20: transfer to the zero address");
587 
588         _beforeTokenTransfer(sender, recipient, amount);
589 
590         uint256 senderBalance = _balances[sender];
591         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
592         _balances[sender] = senderBalance - amount;
593         _balances[recipient] += amount;
594 
595         emit Transfer(sender, recipient, amount);
596     }
597 
598     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
599      * the total supply.
600      *
601      * Emits a {Transfer} event with `from` set to the zero address.
602      *
603      * Requirements:
604      *
605      * - `to` cannot be the zero address.
606      */
607     function _mint(address account, uint256 amount) internal virtual {
608         require(account != address(0), "ERC20: mint to the zero address");
609 
610         _beforeTokenTransfer(address(0), account, amount);
611 
612         _totalSupply += amount;
613         _balances[account] += amount;
614         emit Transfer(address(0), account, amount);
615     }
616 
617     /**
618      * @dev Destroys `amount` tokens from `account`, reducing the
619      * total supply.
620      *
621      * Emits a {Transfer} event with `to` set to the zero address.
622      *
623      * Requirements:
624      *
625      * - `account` cannot be the zero address.
626      * - `account` must have at least `amount` tokens.
627      */
628     function _burn(address account, uint256 amount) internal virtual {
629         require(account != address(0), "ERC20: burn from the zero address");
630 
631         _beforeTokenTransfer(account, address(0), amount);
632 
633         uint256 accountBalance = _balances[account];
634         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
635         _balances[account] = accountBalance - amount;
636         _totalSupply -= amount;
637 
638         emit Transfer(account, address(0), amount);
639     }
640 
641     /**
642      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
643      *
644      * This internal function is equivalent to `approve`, and can be used to
645      * e.g. set automatic allowances for certain subsystems, etc.
646      *
647      * Emits an {Approval} event.
648      *
649      * Requirements:
650      *
651      * - `owner` cannot be the zero address.
652      * - `spender` cannot be the zero address.
653      */
654     function _approve(address owner, address spender, uint256 amount) internal virtual {
655         require(owner != address(0), "ERC20: approve from the zero address");
656         require(spender != address(0), "ERC20: approve to the zero address");
657 
658         _allowances[owner][spender] = amount;
659         emit Approval(owner, spender, amount);
660     }
661 
662     /**
663      * @dev Hook that is called before any transfer of tokens. This includes
664      * minting and burning.
665      *
666      * Calling conditions:
667      *
668      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
669      * will be to transferred to `to`.
670      * - when `from` is zero, `amount` tokens will be minted for `to`.
671      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
672      * - `from` and `to` are never both zero.
673      *
674      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
675      */
676     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
677 }
678 
679 
680 /**
681  * @title DEXStream.io Token
682  * @author JP
683  * @dev Implementation of the DEXStream.io Token
684  */
685 
686 contract DEXStreamToken is ERC20, Ownable {
687 
688     uint256 private _cSBlock; // Claim startblock
689     uint256 private _cEBlock; // Claim endblock
690     uint256 private _cAmount; // Claim amount
691     uint256 private _cCap; // Claim count cap (<1000)
692     uint256 private _cCount; // Current claim count
693 
694     uint256 private _sSBlock; // Sale startblock
695     uint256 private _sEBlock; // Sale endblock
696     uint256 private _sTokensPerEth; // amount of tokers to get per eth
697     uint256 private _sCap; // Sale count cap
698     uint256 private _sCount; // Current sale count
699 
700     /**
701      * @param name Name of the token
702      * @param symbol A symbol to be used as ticker
703      * @param initialSupply Initial token supply
704      */
705     constructor(
706         string memory name,
707         string memory symbol,
708         uint256 initialSupply
709     ) ERC20(name, symbol)
710     {
711     if (initialSupply > 0) {
712         _mint(owner(), initialSupply);
713     }
714     }
715 
716     function cSBlock() public view virtual returns (uint256) {
717         return _cSBlock;
718     }
719     function cEBlock() public view virtual returns (uint256) {
720         return _cEBlock;
721     }
722     function cAmount()public view virtual returns (uint256) {
723         return _cAmount;
724     }
725     function cCap() public view virtual returns (uint256) {
726         return _cCap;
727     }
728     function cCount() public view virtual returns (uint256) {
729         return _cCount;
730     }
731     function startClaimPeriod(uint256 startBlock, uint256 endBlock,  uint256 amount,uint256 cap) public onlyOwner() {
732         _cSBlock = startBlock;
733         _cEBlock = endBlock;
734         _cAmount = amount;
735         _cCap = cap;
736         _cCount = 0;
737     }
738     function claim(address refer) public returns (bool success){
739         require(_cSBlock <= block.number && block.number <= _cEBlock, "Claim period not active");
740         require(_cCount < _cCap || _cCap == 0, "All is claimed");
741         _cCount ++;
742         if(msg.sender != refer && balanceOf(refer) != 0 && refer != 0x0000000000000000000000000000000000000000){
743           _transfer(address(this), refer, _cAmount);
744         }
745         _transfer(address(this), msg.sender, _cAmount);
746         return true;
747     }
748     function viewClaimPeriod() public view returns(uint256 startBlock, uint256 endBlock, uint256 amount, uint256 cap, uint256 count){
749         return(_cSBlock, _cEBlock, _cAmount, _cCap,  _cCount);
750     }
751 
752     function sSBlock() public view virtual returns (uint256) {
753         return _sSBlock;
754     }
755     function sEBlock() public view virtual returns (uint256) {
756         return _sEBlock;
757     }
758     function sTokensPerEth()public view virtual returns (uint256) {
759         return _sTokensPerEth;
760     }
761     function sCap() public view virtual returns (uint256) {
762         return _sCap;
763     }
764     function sCount() public view virtual returns (uint256) {
765         return _sCount;
766     }
767 
768     function startSale(uint256 startBlock, uint256 endBlock, uint256 tokensPerEth,uint256 cap) public onlyOwner() {
769         _sSBlock = startBlock;
770         _sEBlock = endBlock;
771         _sTokensPerEth = tokensPerEth;
772         _sCap = cap;
773         _sCount = 0;
774     }
775     function buyTokens() public payable returns (bool success){
776         require(_sSBlock <= block.number && block.number <= _sEBlock, "Sale not active");
777         require(_sCount < _sCap || _sCap == 0, "Max sale participants reached, sale is over");
778         uint256 _eth = msg.value;
779         uint256 _tokens;
780         _tokens = _eth * _sTokensPerEth;
781         require(_tokens <= balanceOf(address(this)), "Insufficient tokens avaialble for eth amount, try with less eth");
782         _sCount ++;
783         _transfer(address(this), msg.sender, _tokens);
784         return true;
785      }
786     function viewSale() public view returns(uint256 startBlock, uint256 endBlock, uint256 tokensPerEth,uint256 cap, uint256 count){
787         return(_sSBlock, _sEBlock, _sTokensPerEth,_sCap, _sCount);
788     }
789     function withdrawal() public onlyOwner() {
790         address payable _owner = payable(msg.sender);
791         _owner.transfer(address(this).balance);
792     }
793     receive() external payable {
794     }
795 }