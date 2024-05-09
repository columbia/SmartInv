1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
97 
98 
99 pragma solidity >=0.6.0 <0.8.0;
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP.
103  */
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * IMPORTANT: Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Moves `amount` tokens from `sender` to `recipient` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to {approve}. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 // File: @openzeppelin/contracts/math/SafeMath.sol
176 
177 
178 pragma solidity >=0.6.0 <0.8.0;
179 
180 /**
181  * @dev Wrappers over Solidity's arithmetic operations with added overflow
182  * checks.
183  *
184  * Arithmetic operations in Solidity wrap on overflow. This can easily result
185  * in bugs, because programmers usually assume that an overflow raises an
186  * error, which is the standard behavior in high level programming languages.
187  * `SafeMath` restores this intuition by reverting the transaction when an
188  * operation overflows.
189  *
190  * Using this library instead of the unchecked operations eliminates an entire
191  * class of bugs, so it's recommended to use it always.
192  */
193 library SafeMath {
194     /**
195      * @dev Returns the addition of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `+` operator.
199      *
200      * Requirements:
201      *
202      * - Addition cannot overflow.
203      */
204     function add(uint256 a, uint256 b) internal pure returns (uint256) {
205         uint256 c = a + b;
206         require(c >= a, "SafeMath: addition overflow");
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the subtraction of two unsigned integers, reverting on
213      * overflow (when the result is negative).
214      *
215      * Counterpart to Solidity's `-` operator.
216      *
217      * Requirements:
218      *
219      * - Subtraction cannot overflow.
220      */
221     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
222         return sub(a, b, "SafeMath: subtraction overflow");
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
227      * overflow (when the result is negative).
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      *
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b <= a, errorMessage);
237         uint256 c = a - b;
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the multiplication of two unsigned integers, reverting on
244      * overflow.
245      *
246      * Counterpart to Solidity's `*` operator.
247      *
248      * Requirements:
249      *
250      * - Multiplication cannot overflow.
251      */
252     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
253         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
254         // benefit is lost if 'b' is also tested.
255         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
256         if (a == 0) {
257             return 0;
258         }
259 
260         uint256 c = a * b;
261         require(c / a == b, "SafeMath: multiplication overflow");
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers. Reverts on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         return div(a, b, "SafeMath: division by zero");
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
284      * division by zero. The result is rounded towards zero.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         require(b > 0, errorMessage);
296         uint256 c = a / b;
297         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * Reverts when dividing by zero.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
315         return mod(a, b, "SafeMath: modulo by zero");
316     }
317 
318     /**
319      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
320      * Reverts with custom message when dividing by zero.
321      *
322      * Counterpart to Solidity's `%` operator. This function uses a `revert`
323      * opcode (which leaves remaining gas untouched) while Solidity uses an
324      * invalid opcode to revert (consuming all remaining gas).
325      *
326      * Requirements:
327      *
328      * - The divisor cannot be zero.
329      */
330     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
331         require(b != 0, errorMessage);
332         return a % b;
333     }
334 }
335 
336 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
337 
338 
339 pragma solidity >=0.6.0 <0.8.0;
340 
341 
342 
343 
344 /**
345  * @dev Implementation of the {IERC20} interface.
346  *
347  * This implementation is agnostic to the way tokens are created. This means
348  * that a supply mechanism has to be added in a derived contract using {_mint}.
349  * For a generic mechanism see {ERC20PresetMinterPauser}.
350  *
351  * TIP: For a detailed writeup see our guide
352  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
353  * to implement supply mechanisms].
354  *
355  * We have followed general OpenZeppelin guidelines: functions revert instead
356  * of returning `false` on failure. This behavior is nonetheless conventional
357  * and does not conflict with the expectations of ERC20 applications.
358  *
359  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
360  * This allows applications to reconstruct the allowance for all accounts just
361  * by listening to said events. Other implementations of the EIP may not emit
362  * these events, as it isn't required by the specification.
363  *
364  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
365  * functions have been added to mitigate the well-known issues around setting
366  * allowances. See {IERC20-approve}.
367  */
368 contract ERC20 is Context, IERC20 {
369     using SafeMath for uint256;
370 
371     mapping (address => uint256) private _balances;
372 
373     mapping (address => mapping (address => uint256)) private _allowances;
374 
375     uint256 private _totalSupply;
376 
377     string private _name;
378     string private _symbol;
379     uint8 private _decimals;
380 
381     /**
382      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
383      * a default value of 18.
384      *
385      * To select a different value for {decimals}, use {_setupDecimals}.
386      *
387      * All three of these values are immutable: they can only be set once during
388      * construction.
389      */
390     constructor (string memory name_, string memory symbol_) public {
391         _name = name_;
392         _symbol = symbol_;
393         _decimals = 18;
394     }
395 
396     /**
397      * @dev Returns the name of the token.
398      */
399     function name() public view returns (string memory) {
400         return _name;
401     }
402 
403     /**
404      * @dev Returns the symbol of the token, usually a shorter version of the
405      * name.
406      */
407     function symbol() public view returns (string memory) {
408         return _symbol;
409     }
410 
411     /**
412      * @dev Returns the number of decimals used to get its user representation.
413      * For example, if `decimals` equals `2`, a balance of `505` tokens should
414      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
415      *
416      * Tokens usually opt for a value of 18, imitating the relationship between
417      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
418      * called.
419      *
420      * NOTE: This information is only used for _display_ purposes: it in
421      * no way affects any of the arithmetic of the contract, including
422      * {IERC20-balanceOf} and {IERC20-transfer}.
423      */
424     function decimals() public view returns (uint8) {
425         return _decimals;
426     }
427 
428     /**
429      * @dev See {IERC20-totalSupply}.
430      */
431     function totalSupply() public view override returns (uint256) {
432         return _totalSupply;
433     }
434 
435     /**
436      * @dev See {IERC20-balanceOf}.
437      */
438     function balanceOf(address account) public view override returns (uint256) {
439         return _balances[account];
440     }
441 
442     /**
443      * @dev See {IERC20-transfer}.
444      *
445      * Requirements:
446      *
447      * - `recipient` cannot be the zero address.
448      * - the caller must have a balance of at least `amount`.
449      */
450     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
451         _transfer(_msgSender(), recipient, amount);
452         return true;
453     }
454 
455     /**
456      * @dev See {IERC20-allowance}.
457      */
458     function allowance(address owner, address spender) public view virtual override returns (uint256) {
459         return _allowances[owner][spender];
460     }
461 
462     /**
463      * @dev See {IERC20-approve}.
464      *
465      * Requirements:
466      *
467      * - `spender` cannot be the zero address.
468      */
469     function approve(address spender, uint256 amount) public virtual override returns (bool) {
470         _approve(_msgSender(), spender, amount);
471         return true;
472     }
473 
474     /**
475      * @dev See {IERC20-transferFrom}.
476      *
477      * Emits an {Approval} event indicating the updated allowance. This is not
478      * required by the EIP. See the note at the beginning of {ERC20}.
479      *
480      * Requirements:
481      *
482      * - `sender` and `recipient` cannot be the zero address.
483      * - `sender` must have a balance of at least `amount`.
484      * - the caller must have allowance for ``sender``'s tokens of at least
485      * `amount`.
486      */
487     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
488         _transfer(sender, recipient, amount);
489         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
490         return true;
491     }
492 
493     /**
494      * @dev Atomically increases the allowance granted to `spender` by the caller.
495      *
496      * This is an alternative to {approve} that can be used as a mitigation for
497      * problems described in {IERC20-approve}.
498      *
499      * Emits an {Approval} event indicating the updated allowance.
500      *
501      * Requirements:
502      *
503      * - `spender` cannot be the zero address.
504      */
505     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
507         return true;
508     }
509 
510     /**
511      * @dev Atomically decreases the allowance granted to `spender` by the caller.
512      *
513      * This is an alternative to {approve} that can be used as a mitigation for
514      * problems described in {IERC20-approve}.
515      *
516      * Emits an {Approval} event indicating the updated allowance.
517      *
518      * Requirements:
519      *
520      * - `spender` cannot be the zero address.
521      * - `spender` must have allowance for the caller of at least
522      * `subtractedValue`.
523      */
524     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
525         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
526         return true;
527     }
528 
529     /**
530      * @dev Moves tokens `amount` from `sender` to `recipient`.
531      *
532      * This is internal function is equivalent to {transfer}, and can be used to
533      * e.g. implement automatic token fees, slashing mechanisms, etc.
534      *
535      * Emits a {Transfer} event.
536      *
537      * Requirements:
538      *
539      * - `sender` cannot be the zero address.
540      * - `recipient` cannot be the zero address.
541      * - `sender` must have a balance of at least `amount`.
542      */
543     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
544         require(sender != address(0), "ERC20: transfer from the zero address");
545         require(recipient != address(0), "ERC20: transfer to the zero address");
546 
547         _beforeTokenTransfer(sender, recipient, amount);
548 
549         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
550         _balances[recipient] = _balances[recipient].add(amount);
551         emit Transfer(sender, recipient, amount);
552     }
553 
554     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
555      * the total supply.
556      *
557      * Emits a {Transfer} event with `from` set to the zero address.
558      *
559      * Requirements:
560      *
561      * - `to` cannot be the zero address.
562      */
563     function _mint(address account, uint256 amount) internal virtual {
564         require(account != address(0), "ERC20: mint to the zero address");
565 
566         _beforeTokenTransfer(address(0), account, amount);
567 
568         _totalSupply = _totalSupply.add(amount);
569         _balances[account] = _balances[account].add(amount);
570         emit Transfer(address(0), account, amount);
571     }
572 
573     /**
574      * @dev Destroys `amount` tokens from `account`, reducing the
575      * total supply.
576      *
577      * Emits a {Transfer} event with `to` set to the zero address.
578      *
579      * Requirements:
580      *
581      * - `account` cannot be the zero address.
582      * - `account` must have at least `amount` tokens.
583      */
584     function _burn(address account, uint256 amount) internal virtual {
585         require(account != address(0), "ERC20: burn from the zero address");
586 
587         _beforeTokenTransfer(account, address(0), amount);
588 
589         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
590         _totalSupply = _totalSupply.sub(amount);
591         emit Transfer(account, address(0), amount);
592     }
593 
594     /**
595      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
596      *
597      * This internal function is equivalent to `approve`, and can be used to
598      * e.g. set automatic allowances for certain subsystems, etc.
599      *
600      * Emits an {Approval} event.
601      *
602      * Requirements:
603      *
604      * - `owner` cannot be the zero address.
605      * - `spender` cannot be the zero address.
606      */
607     function _approve(address owner, address spender, uint256 amount) internal virtual {
608         require(owner != address(0), "ERC20: approve from the zero address");
609         require(spender != address(0), "ERC20: approve to the zero address");
610 
611         _allowances[owner][spender] = amount;
612         emit Approval(owner, spender, amount);
613     }
614 
615     /**
616      * @dev Sets {decimals} to a value other than the default one of 18.
617      *
618      * WARNING: This function should only be called from the constructor. Most
619      * applications that interact with token contracts will not expect
620      * {decimals} to ever change, and may work incorrectly if it does.
621      */
622     function _setupDecimals(uint8 decimals_) internal {
623         _decimals = decimals_;
624     }
625 
626     /**
627      * @dev Hook that is called before any transfer of tokens. This includes
628      * minting and burning.
629      *
630      * Calling conditions:
631      *
632      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
633      * will be to transferred to `to`.
634      * - when `from` is zero, `amount` tokens will be minted for `to`.
635      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
636      * - `from` and `to` are never both zero.
637      *
638      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
639      */
640     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
641 }
642 
643 // File: contracts/UniMexToken.sol
644 
645 // SPDX-License-Identifier: UNLICENSED
646 pragma solidity 0.6.12;
647 
648 
649 
650 
651 contract UniMex is ERC20("https://unimex.network/", "UMX"), Ownable {
652  
653     mapping(address => bool) public whitelist;
654     bool public locked;
655     
656     constructor() public {
657         locked = true;
658     }
659 
660     function unlock() public onlyOwner {
661         locked = false;
662     } 
663 
664     function lock() public onlyOwner {
665         locked = true;
666     }
667 
668     function addToWhitelist(address _user) public onlyOwner {
669         whitelist[_user] = true;
670     }
671 
672     function removeFromWhitelist(address _user) public onlyOwner {
673         whitelist[_user] = false;
674     }
675     
676     function mint(address _to, uint256 _amount) public onlyOwner {
677         _mint(_to, _amount);
678     }
679     
680     function transfer(address to, uint256 amount) public override returns (bool) {
681         if(locked) {
682             require(msg.sender == owner() || whitelist[msg.sender]);
683         }
684         return super.transfer(to, amount);
685     }
686 
687     function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
688         if(locked) {
689             require(from == owner() || whitelist[from]);
690         }
691         return super.transferFrom(from, to, amount);
692     }
693 
694 }