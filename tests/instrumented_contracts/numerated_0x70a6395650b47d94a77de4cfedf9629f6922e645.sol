1 // SPDX-License-Identifier: GPL-3.0-only
2 
3 pragma solidity ^0.5.0;
4 
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
16 contract Context {
17     // Empty internal constructor, to prevent people from mistakenly deploying
18     // an instance of this contract, which should be used via inheritance.
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
34  * the optional functions; to access them see {ERC20Detailed}.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 library SafeMath {
121     /**
122      * @dev Returns the addition of two unsigned integers, reverting on
123      * overflow.
124      *
125      * Counterpart to Solidity's `+` operator.
126      *
127      * Requirements:
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      * - Subtraction cannot overflow.
158      *
159      * _Available since v2.4.0._
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      * - The divisor cannot be zero.
216      *
217      * _Available since v2.4.0._
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         // Solidity only automatically asserts when dividing by 0
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      * - The divisor cannot be zero.
253      *
254      * _Available since v2.4.0._
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 /**
263  * @dev Implementation of the {IERC20} interface.
264  *
265  * This implementation is agnostic to the way tokens are created. This means
266  * that a supply mechanism has to be added in a derived contract using {_mint}.
267  * For a generic mechanism see {ERC20Mintable}.
268  *
269  * TIP: For a detailed writeup see our guide
270  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
271  * to implement supply mechanisms].
272  *
273  * We have followed general OpenZeppelin guidelines: functions revert instead
274  * of returning `false` on failure. This behavior is nonetheless conventional
275  * and does not conflict with the expectations of ERC20 applications.
276  *
277  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
278  * This allows applications to reconstruct the allowance for all accounts just
279  * by listening to said events. Other implementations of the EIP may not emit
280  * these events, as it isn't required by the specification.
281  *
282  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
283  * functions have been added to mitigate the well-known issues around setting
284  * allowances. See {IERC20-approve}.
285  */
286 contract ERC20 is Context, IERC20 {
287     using SafeMath for uint256;
288 
289     mapping (address => uint256) private _balances;
290 
291     mapping (address => mapping (address => uint256)) private _allowances;
292 
293     uint256 private _totalSupply;
294 
295     /**
296      * @dev See {IERC20-totalSupply}.
297      */
298     function totalSupply() public view returns (uint256) {
299         return _totalSupply;
300     }
301 
302     /**
303      * @dev See {IERC20-balanceOf}.
304      */
305     function balanceOf(address account) public view returns (uint256) {
306         return _balances[account];
307     }
308 
309     /**
310      * @dev See {IERC20-transfer}.
311      *
312      * Requirements:
313      *
314      * - `recipient` cannot be the zero address.
315      * - the caller must have a balance of at least `amount`.
316      */
317     function transfer(address recipient, uint256 amount) public returns (bool) {
318         _transfer(_msgSender(), recipient, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-allowance}.
324      */
325     function allowance(address owner, address spender) public view returns (uint256) {
326         return _allowances[owner][spender];
327     }
328 
329     /**
330      * @dev See {IERC20-approve}.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      */
336     function approve(address spender, uint256 amount) public returns (bool) {
337         _approve(_msgSender(), spender, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-transferFrom}.
343      *
344      * Emits an {Approval} event indicating the updated allowance. This is not
345      * required by the EIP. See the note at the beginning of {ERC20};
346      *
347      * Requirements:
348      * - `sender` and `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      * - the caller must have allowance for `sender`'s tokens of at least
351      * `amount`.
352      */
353     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
354         _transfer(sender, recipient, amount);
355         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
356         return true;
357     }
358 
359     /**
360      * @dev Atomically increases the allowance granted to `spender` by the caller.
361      *
362      * This is an alternative to {approve} that can be used as a mitigation for
363      * problems described in {IERC20-approve}.
364      *
365      * Emits an {Approval} event indicating the updated allowance.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
372         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
373         return true;
374     }
375 
376     /**
377      * @dev Atomically decreases the allowance granted to `spender` by the caller.
378      *
379      * This is an alternative to {approve} that can be used as a mitigation for
380      * problems described in {IERC20-approve}.
381      *
382      * Emits an {Approval} event indicating the updated allowance.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      * - `spender` must have allowance for the caller of at least
388      * `subtractedValue`.
389      */
390     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
391         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
392         return true;
393     }
394 
395     /**
396      * @dev Moves tokens `amount` from `sender` to `recipient`.
397      *
398      * This is internal function is equivalent to {transfer}, and can be used to
399      * e.g. implement automatic token fees, slashing mechanisms, etc.
400      *
401      * Emits a {Transfer} event.
402      *
403      * Requirements:
404      *
405      * - `sender` cannot be the zero address.
406      * - `recipient` cannot be the zero address.
407      * - `sender` must have a balance of at least `amount`.
408      */
409     function _transfer(address sender, address recipient, uint256 amount) internal {
410         require(sender != address(0), "ERC20: transfer from the zero address");
411         require(recipient != address(0), "ERC20: transfer to the zero address");
412 
413         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
414         _balances[recipient] = _balances[recipient].add(amount);
415         emit Transfer(sender, recipient, amount);
416     }
417 
418     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
419      * the total supply.
420      *
421      * Emits a {Transfer} event with `from` set to the zero address.
422      *
423      * Requirements
424      *
425      * - `to` cannot be the zero address.
426      */
427     function _mint(address account, uint256 amount) internal {
428         require(account != address(0), "ERC20: mint to the zero address");
429 
430         _totalSupply = _totalSupply.add(amount);
431         _balances[account] = _balances[account].add(amount);
432         emit Transfer(address(0), account, amount);
433     }
434 
435     /**
436      * @dev Destroys `amount` tokens from `account`, reducing the
437      * total supply.
438      *
439      * Emits a {Transfer} event with `to` set to the zero address.
440      *
441      * Requirements
442      *
443      * - `account` cannot be the zero address.
444      * - `account` must have at least `amount` tokens.
445      */
446     function _burn(address account, uint256 amount) internal {
447         require(account != address(0), "ERC20: burn from the zero address");
448 
449         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
450         _totalSupply = _totalSupply.sub(amount);
451         emit Transfer(account, address(0), amount);
452     }
453 
454     /**
455      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
456      *
457      * This is internal function is equivalent to `approve`, and can be used to
458      * e.g. set automatic allowances for certain subsystems, etc.
459      *
460      * Emits an {Approval} event.
461      *
462      * Requirements:
463      *
464      * - `owner` cannot be the zero address.
465      * - `spender` cannot be the zero address.
466      */
467     function _approve(address owner, address spender, uint256 amount) internal {
468         require(owner != address(0), "ERC20: approve from the zero address");
469         require(spender != address(0), "ERC20: approve to the zero address");
470 
471         _allowances[owner][spender] = amount;
472         emit Approval(owner, spender, amount);
473     }
474 
475     /**
476      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
477      * from the caller's allowance.
478      *
479      * See {_burn} and {_approve}.
480      */
481     function _burnFrom(address account, uint256 amount) internal {
482         _burn(account, amount);
483         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
484     }
485 }
486 
487 /**
488  * @dev Optional functions from the ERC20 standard.
489  */
490 contract ERC20Detailed is IERC20 {
491     string private _name;
492     string private _symbol;
493     uint8 private _decimals;
494 
495     /**
496      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
497      * these values are immutable: they can only be set once during
498      * construction.
499      */
500     constructor (string memory name, string memory symbol, uint8 decimals) public {
501         _name = name;
502         _symbol = symbol;
503         _decimals = decimals;
504     }
505 
506     /**
507      * @dev Returns the name of the token.
508      */
509     function name() public view returns (string memory) {
510         return _name;
511     }
512 
513     /**
514      * @dev Returns the symbol of the token, usually a shorter version of the
515      * name.
516      */
517     function symbol() public view returns (string memory) {
518         return _symbol;
519     }
520 
521     /**
522      * @dev Returns the number of decimals used to get its user representation.
523      * For example, if `decimals` equals `2`, a balance of `505` tokens should
524      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
525      *
526      * Tokens usually opt for a value of 18, imitating the relationship between
527      * Ether and Wei.
528      *
529      * NOTE: This information is only used for _display_ purposes: it in
530      * no way affects any of the arithmetic of the contract, including
531      * {IERC20-balanceOf} and {IERC20-transfer}.
532      */
533     function decimals() public view returns (uint8) {
534         return _decimals;
535     }
536 }
537 
538 /**
539  * @dev Contract module which provides a basic access control mechanism, where
540  * there is an account (an owner) that can be granted exclusive access to
541  * specific functions.
542  *
543  * This module is used through inheritance. It will make available the modifier
544  * `onlyOwner`, which can be applied to your functions to restrict their use to
545  * the owner.
546  */
547 contract Ownable is Context {
548     address private _owner;
549 
550     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
551 
552     /**
553      * @dev Initializes the contract setting the deployer as the initial owner.
554      */
555     constructor () internal {
556         address msgSender = _msgSender();
557         _owner = msgSender;
558         emit OwnershipTransferred(address(0), msgSender);
559     }
560 
561     /**
562      * @dev Returns the address of the current owner.
563      */
564     function owner() public view returns (address) {
565         return _owner;
566     }
567 
568     /**
569      * @dev Throws if called by any account other than the owner.
570      */
571     modifier onlyOwner() {
572         require(isOwner(), "Ownable: caller is not the owner");
573         _;
574     }
575 
576     /**
577      * @dev Returns true if the caller is the current owner.
578      */
579     function isOwner() public view returns (bool) {
580         return _msgSender() == _owner;
581     }
582 
583     /**
584      * @dev Leaves the contract without owner. It will not be possible to call
585      * `onlyOwner` functions anymore. Can only be called by the current owner.
586      *
587      * NOTE: Renouncing ownership will leave the contract without an owner,
588      * thereby removing any functionality that is only available to the owner.
589      */
590     function renounceOwnership() public onlyOwner {
591         emit OwnershipTransferred(_owner, address(0));
592         _owner = address(0);
593     }
594 
595     /**
596      * @dev Transfers ownership of the contract to a new account (`newOwner`).
597      * Can only be called by the current owner.
598      */
599     function transferOwnership(address newOwner) public onlyOwner {
600         _transferOwnership(newOwner);
601     }
602 
603     /**
604      * @dev Transfers ownership of the contract to a new account (`newOwner`).
605      */
606     function _transferOwnership(address newOwner) internal {
607         require(newOwner != address(0), "Ownable: new owner is the zero address");
608         emit OwnershipTransferred(_owner, newOwner);
609         _owner = newOwner;
610     }
611 }
612 
613 /**
614  * @dev Interface of the ERC777Token standard as defined in the EIP.
615  *
616  * This contract uses the
617  * [ERC1820 registry standard](https://eips.ethereum.org/EIPS/eip-1820) to let
618  * token holders and recipients react to token movements by using setting implementers
619  * for the associated interfaces in said registry. See `IERC1820Registry` and
620  * `ERC1820Implementer`.
621  */
622 contract IERC223 {
623     /**
624      * @dev Returns the total supply of the token.
625      */
626     uint public _totalSupply;
627 
628     /**
629      * @dev Returns the balance of the `who` address.
630      */
631     function balanceOf(address who) public view returns (uint);
632 
633     /**
634      * @dev Transfers `value` tokens from `msg.sender` to `to` address
635      * and returns `true` on success.
636      */
637     function transfer(address to, uint value) public returns (bool success);
638 
639     /**
640      * @dev Transfers `value` tokens from `msg.sender` to `to` address with `data` parameter
641      * and returns `true` on success.
642      */
643     function transfer(address to, uint value, bytes32 data) public returns (bool success);
644 
645      /**
646      * @dev Event that is fired on successful transfer.
647      */
648     event Transfer(address indexed from, address indexed to, uint value, bytes32 data);
649 }
650 
651 /**
652  * @title Contract that will work with ERC223 tokens.
653  */
654 contract IERC223Recipient {
655 /**
656  * @dev Standard ERC223 function that will handle incoming token transfers.
657  *
658  * @param _from  Token sender address.
659  * @param _value Amount of tokens.
660  * @param _data  Transaction metadata.
661  */
662     function tokenFallback(address _from, uint _value, bytes32 _data) external;
663 }
664 
665 contract WSATT is ERC20Detailed, ERC20, Ownable, IERC223Recipient
666 {
667     IERC223 public sattAddr;
668 
669     event TokenSwapped(address indexed user, uint256  amount);
670     event TokenReturned(address indexed user, uint256 amount);
671 
672     constructor (IERC223 _sattAddr)
673         public
674         ERC20Detailed("Wrapped Smart Advertising Transaction Token", "WSATT", 18)
675     {
676         sattAddr = _sattAddr;
677     }
678 
679     function tokenFallback(address _from, uint _value, bytes32 _data) external
680     {
681         if (_msgSender() == address(sattAddr))
682         {
683             _mint(_from, _value);
684 
685             emit TokenSwapped(_from, _value);
686         }
687     }
688 
689     function contributeWSATT(uint256 value) public
690     {
691         _burn(_msgSender(), value);
692         sattAddr.transfer(_msgSender(), value);
693 
694         emit TokenReturned(_msgSender(), value);
695     }
696 
697 }