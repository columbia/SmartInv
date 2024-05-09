1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/ownership/Ownable.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Contract module which provides a basic access control mechanism, where
116  * there is an account (an owner) that can be granted exclusive access to
117  * specific functions.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor () internal {
132         address msgSender = _msgSender();
133         _owner = msgSender;
134         emit OwnershipTransferred(address(0), msgSender);
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         require(isOwner(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     /**
153      * @dev Returns true if the caller is the current owner.
154      */
155     function isOwner() public view returns (bool) {
156         return _msgSender() == _owner;
157     }
158 
159     /**
160      * @dev Leaves the contract without owner. It will not be possible to call
161      * `onlyOwner` functions anymore. Can only be called by the current owner.
162      *
163      * NOTE: Renouncing ownership will leave the contract without an owner,
164      * thereby removing any functionality that is only available to the owner.
165      */
166     function renounceOwnership() public onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public onlyOwner {
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      */
182     function _transferOwnership(address newOwner) internal {
183         require(newOwner != address(0), "Ownable: new owner is the zero address");
184         emit OwnershipTransferred(_owner, newOwner);
185         _owner = newOwner;
186     }
187 }
188 
189 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Detailed.sol
190 
191 pragma solidity ^0.5.0;
192 
193 
194 /**
195  * @dev Optional functions from the ERC20 standard.
196  */
197 contract ERC20Detailed is IERC20 {
198     string private _name;
199     string private _symbol;
200     uint8 private _decimals;
201 
202     /**
203      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
204      * these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor (string memory name, string memory symbol, uint8 decimals) public {
208         _name = name;
209         _symbol = symbol;
210         _decimals = decimals;
211     }
212 
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() public view returns (string memory) {
217         return _name;
218     }
219 
220     /**
221      * @dev Returns the symbol of the token, usually a shorter version of the
222      * name.
223      */
224     function symbol() public view returns (string memory) {
225         return _symbol;
226     }
227 
228     /**
229      * @dev Returns the number of decimals used to get its user representation.
230      * For example, if `decimals` equals `2`, a balance of `505` tokens should
231      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
232      *
233      * Tokens usually opt for a value of 18, imitating the relationship between
234      * Ether and Wei.
235      *
236      * NOTE: This information is only used for _display_ purposes: it in
237      * no way affects any of the arithmetic of the contract, including
238      * {IERC20-balanceOf} and {IERC20-transfer}.
239      */
240     function decimals() public view returns (uint8) {
241         return _decimals;
242     }
243 }
244 
245 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/math/SafeMath.sol
246 
247 pragma solidity ^0.5.0;
248 
249 /**
250  * @dev Wrappers over Solidity's arithmetic operations with added overflow
251  * checks.
252  *
253  * Arithmetic operations in Solidity wrap on overflow. This can easily result
254  * in bugs, because programmers usually assume that an overflow raises an
255  * error, which is the standard behavior in high level programming languages.
256  * `SafeMath` restores this intuition by reverting the transaction when an
257  * operation overflows.
258  *
259  * Using this library instead of the unchecked operations eliminates an entire
260  * class of bugs, so it's recommended to use it always.
261  */
262 library SafeMath {
263     /**
264      * @dev Returns the addition of two unsigned integers, reverting on
265      * overflow.
266      *
267      * Counterpart to Solidity's `+` operator.
268      *
269      * Requirements:
270      * - Addition cannot overflow.
271      */
272     function add(uint256 a, uint256 b) internal pure returns (uint256) {
273         uint256 c = a + b;
274         require(c >= a, "SafeMath: addition overflow");
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the subtraction of two unsigned integers, reverting on
281      * overflow (when the result is negative).
282      *
283      * Counterpart to Solidity's `-` operator.
284      *
285      * Requirements:
286      * - Subtraction cannot overflow.
287      */
288     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
289         return sub(a, b, "SafeMath: subtraction overflow");
290     }
291 
292     /**
293      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
294      * overflow (when the result is negative).
295      *
296      * Counterpart to Solidity's `-` operator.
297      *
298      * Requirements:
299      * - Subtraction cannot overflow.
300      *
301      * _Available since v2.4.0._
302      */
303     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b <= a, errorMessage);
305         uint256 c = a - b;
306 
307         return c;
308     }
309 
310     /**
311      * @dev Returns the multiplication of two unsigned integers, reverting on
312      * overflow.
313      *
314      * Counterpart to Solidity's `*` operator.
315      *
316      * Requirements:
317      * - Multiplication cannot overflow.
318      */
319     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
320         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
321         // benefit is lost if 'b' is also tested.
322         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
323         if (a == 0) {
324             return 0;
325         }
326 
327         uint256 c = a * b;
328         require(c / a == b, "SafeMath: multiplication overflow");
329 
330         return c;
331     }
332 
333     /**
334      * @dev Returns the integer division of two unsigned integers. Reverts on
335      * division by zero. The result is rounded towards zero.
336      *
337      * Counterpart to Solidity's `/` operator. Note: this function uses a
338      * `revert` opcode (which leaves remaining gas untouched) while Solidity
339      * uses an invalid opcode to revert (consuming all remaining gas).
340      *
341      * Requirements:
342      * - The divisor cannot be zero.
343      */
344     function div(uint256 a, uint256 b) internal pure returns (uint256) {
345         return div(a, b, "SafeMath: division by zero");
346     }
347 
348     /**
349      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
350      * division by zero. The result is rounded towards zero.
351      *
352      * Counterpart to Solidity's `/` operator. Note: this function uses a
353      * `revert` opcode (which leaves remaining gas untouched) while Solidity
354      * uses an invalid opcode to revert (consuming all remaining gas).
355      *
356      * Requirements:
357      * - The divisor cannot be zero.
358      *
359      * _Available since v2.4.0._
360      */
361     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
362         // Solidity only automatically asserts when dividing by 0
363         require(b > 0, errorMessage);
364         uint256 c = a / b;
365         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
366 
367         return c;
368     }
369 
370     /**
371      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
372      * Reverts when dividing by zero.
373      *
374      * Counterpart to Solidity's `%` operator. This function uses a `revert`
375      * opcode (which leaves remaining gas untouched) while Solidity uses an
376      * invalid opcode to revert (consuming all remaining gas).
377      *
378      * Requirements:
379      * - The divisor cannot be zero.
380      */
381     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
382         return mod(a, b, "SafeMath: modulo by zero");
383     }
384 
385     /**
386      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
387      * Reverts with custom message when dividing by zero.
388      *
389      * Counterpart to Solidity's `%` operator. This function uses a `revert`
390      * opcode (which leaves remaining gas untouched) while Solidity uses an
391      * invalid opcode to revert (consuming all remaining gas).
392      *
393      * Requirements:
394      * - The divisor cannot be zero.
395      *
396      * _Available since v2.4.0._
397      */
398     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
399         require(b != 0, errorMessage);
400         return a % b;
401     }
402 }
403 
404 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20.sol
405 
406 pragma solidity ^0.5.0;
407 
408 
409 
410 
411 /**
412  * @dev Implementation of the {IERC20} interface.
413  *
414  * This implementation is agnostic to the way tokens are created. This means
415  * that a supply mechanism has to be added in a derived contract using {_mint}.
416  * For a generic mechanism see {ERC20Mintable}.
417  *
418  * TIP: For a detailed writeup see our guide
419  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
420  * to implement supply mechanisms].
421  *
422  * We have followed general OpenZeppelin guidelines: functions revert instead
423  * of returning `false` on failure. This behavior is nonetheless conventional
424  * and does not conflict with the expectations of ERC20 applications.
425  *
426  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
427  * This allows applications to reconstruct the allowance for all accounts just
428  * by listening to said events. Other implementations of the EIP may not emit
429  * these events, as it isn't required by the specification.
430  *
431  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
432  * functions have been added to mitigate the well-known issues around setting
433  * allowances. See {IERC20-approve}.
434  */
435 contract ERC20 is Context, IERC20 {
436     using SafeMath for uint256;
437 
438     mapping (address => uint256) private _balances;
439 
440     mapping (address => mapping (address => uint256)) private _allowances;
441 
442     uint256 private _totalSupply;
443 
444     /**
445      * @dev See {IERC20-totalSupply}.
446      */
447     function totalSupply() public view returns (uint256) {
448         return _totalSupply;
449     }
450 
451     /**
452      * @dev See {IERC20-balanceOf}.
453      */
454     function balanceOf(address account) public view returns (uint256) {
455         return _balances[account];
456     }
457 
458     /**
459      * @dev See {IERC20-transfer}.
460      *
461      * Requirements:
462      *
463      * - `recipient` cannot be the zero address.
464      * - the caller must have a balance of at least `amount`.
465      */
466     function transfer(address recipient, uint256 amount) public returns (bool) {
467         _transfer(_msgSender(), recipient, amount);
468         return true;
469     }
470 
471     /**
472      * @dev See {IERC20-allowance}.
473      */
474     function allowance(address owner, address spender) public view returns (uint256) {
475         return _allowances[owner][spender];
476     }
477 
478     /**
479      * @dev See {IERC20-approve}.
480      *
481      * Requirements:
482      *
483      * - `spender` cannot be the zero address.
484      */
485     function approve(address spender, uint256 amount) public returns (bool) {
486         _approve(_msgSender(), spender, amount);
487         return true;
488     }
489 
490     /**
491      * @dev See {IERC20-transferFrom}.
492      *
493      * Emits an {Approval} event indicating the updated allowance. This is not
494      * required by the EIP. See the note at the beginning of {ERC20};
495      *
496      * Requirements:
497      * - `sender` and `recipient` cannot be the zero address.
498      * - `sender` must have a balance of at least `amount`.
499      * - the caller must have allowance for `sender`'s tokens of at least
500      * `amount`.
501      */
502     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
503         _transfer(sender, recipient, amount);
504         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
505         return true;
506     }
507 
508     /**
509      * @dev Atomically increases the allowance granted to `spender` by the caller.
510      *
511      * This is an alternative to {approve} that can be used as a mitigation for
512      * problems described in {IERC20-approve}.
513      *
514      * Emits an {Approval} event indicating the updated allowance.
515      *
516      * Requirements:
517      *
518      * - `spender` cannot be the zero address.
519      */
520     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
521         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
522         return true;
523     }
524 
525     /**
526      * @dev Atomically decreases the allowance granted to `spender` by the caller.
527      *
528      * This is an alternative to {approve} that can be used as a mitigation for
529      * problems described in {IERC20-approve}.
530      *
531      * Emits an {Approval} event indicating the updated allowance.
532      *
533      * Requirements:
534      *
535      * - `spender` cannot be the zero address.
536      * - `spender` must have allowance for the caller of at least
537      * `subtractedValue`.
538      */
539     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
540         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
541         return true;
542     }
543 
544     /**
545      * @dev Moves tokens `amount` from `sender` to `recipient`.
546      *
547      * This is internal function is equivalent to {transfer}, and can be used to
548      * e.g. implement automatic token fees, slashing mechanisms, etc.
549      *
550      * Emits a {Transfer} event.
551      *
552      * Requirements:
553      *
554      * - `sender` cannot be the zero address.
555      * - `recipient` cannot be the zero address.
556      * - `sender` must have a balance of at least `amount`.
557      */
558     function _transfer(address sender, address recipient, uint256 amount) internal {
559         require(sender != address(0), "ERC20: transfer from the zero address");
560         require(recipient != address(0), "ERC20: transfer to the zero address");
561 
562         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
563         _balances[recipient] = _balances[recipient].add(amount);
564         emit Transfer(sender, recipient, amount);
565     }
566 
567     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
568      * the total supply.
569      *
570      * Emits a {Transfer} event with `from` set to the zero address.
571      *
572      * Requirements
573      *
574      * - `to` cannot be the zero address.
575      */
576     function _mint(address account, uint256 amount) internal {
577         require(account != address(0), "ERC20: mint to the zero address");
578 
579         _totalSupply = _totalSupply.add(amount);
580         _balances[account] = _balances[account].add(amount);
581         emit Transfer(address(0), account, amount);
582     }
583 
584     /**
585      * @dev Destroys `amount` tokens from `account`, reducing the
586      * total supply.
587      *
588      * Emits a {Transfer} event with `to` set to the zero address.
589      *
590      * Requirements
591      *
592      * - `account` cannot be the zero address.
593      * - `account` must have at least `amount` tokens.
594      */
595     function _burn(address account, uint256 amount) internal {
596         require(account != address(0), "ERC20: burn from the zero address");
597 
598         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
599         _totalSupply = _totalSupply.sub(amount);
600         emit Transfer(account, address(0), amount);
601     }
602 
603     /**
604      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
605      *
606      * This is internal function is equivalent to `approve`, and can be used to
607      * e.g. set automatic allowances for certain subsystems, etc.
608      *
609      * Emits an {Approval} event.
610      *
611      * Requirements:
612      *
613      * - `owner` cannot be the zero address.
614      * - `spender` cannot be the zero address.
615      */
616     function _approve(address owner, address spender, uint256 amount) internal {
617         require(owner != address(0), "ERC20: approve from the zero address");
618         require(spender != address(0), "ERC20: approve to the zero address");
619 
620         _allowances[owner][spender] = amount;
621         emit Approval(owner, spender, amount);
622     }
623 
624     /**
625      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
626      * from the caller's allowance.
627      *
628      * See {_burn} and {_approve}.
629      */
630     function _burnFrom(address account, uint256 amount) internal {
631         _burn(account, amount);
632         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
633     }
634 }
635 
636 // File: contracts/Grano.sol
637 
638 pragma solidity ^0.5.0;
639 
640 /**
641  * @title Grano Protocol ERC20 Token Contract
642  * @dev Implementation of the Grano Protocol.
643  */
644 
645 contract Grano is ERC20, ERC20Detailed, Ownable {
646     
647     mapping (address => bool) private faucetAddress;
648     uint256 private faucetAmount;
649     uint32 private faucetTotalAddresses;
650     
651     struct Record {
652 		uint256 tokens_amount; 
653 		uint256 burn_date;   
654 		uint256 lock_period; 
655 		bool minted; 
656 	}
657 	
658 	mapping (address => Record[]) private user;
659 	
660 	event Burn(address indexed _user, uint256 indexed _record, uint256 tokens_amount, uint256 burn_date, uint256 lock_period);
661 	event Mint(address indexed _user, uint256 indexed _record, uint256 tokens_amount, uint256 mint_date);
662 	event Faucet(address indexed _user, uint256 tokens_amount, uint256 faucet_date);
663 	
664 	constructor (string memory _name, string memory _symbol, uint8 _decimals, uint32 _initial_supply) public ERC20Detailed(_name, _symbol, _decimals) {
665 	    faucetAmount = (_initial_supply/_initial_supply) * (10 ** 17);
666         _mint(_msgSender(), _initial_supply * (10 ** uint256(decimals())));
667     }
668 
669     function burn(uint256 _amount, uint256 _period) external  returns (bool) {
670         require(_amount > 0, "The amount should be greater than zero.");
671         require(_period > 0, "The period should not be less than 1 day.");
672         require(balanceOf(_msgSender()) >= _amount, "Your balance does not have enough tokens.");
673         user[_msgSender()].push(Record(_amount,now,_period,false));
674         _burn(_msgSender(), _amount);
675         emit Burn(_msgSender(), user[_msgSender()].length.sub(1), _amount, now, _period);
676     }
677     
678     function mint(uint256 _record) external returns (bool) {
679         require(_record  >= 0  && _record < user[_msgSender()].length, "Record does not exist.");
680         require(!user[_msgSender()][_record].minted, "Record already minted.");
681         require((user[_msgSender()][_record].burn_date.add(user[_msgSender()][_record].lock_period.mul(86400))) <= now, "Record cannot be minted before the lock period ends.");
682         user[_msgSender()][_record].minted = true;
683         uint256 period = user[_msgSender()][_record].lock_period ** 2;
684         uint256 multiplier = period.div(10000);
685         uint256 compensation = multiplier.mul(user[_msgSender()][_record].tokens_amount);
686         uint256 amount = compensation.add(user[_msgSender()][_record].tokens_amount);
687         _mint(_msgSender(), amount);
688         emit Mint(_msgSender(), _record, amount, now);
689     }
690     
691     function getRecordsCount(address _user) public view returns (uint256) {
692         return user[_user].length;
693     }
694     
695     function getRecord(address _user, uint256 _record) public view returns (uint256, uint256, uint256, bool) {
696         Record memory r = user[_user][_record];
697         return (r.tokens_amount, r.burn_date, r.lock_period, r.minted);
698     }
699     
700     function faucet() external returns (bool) {
701         require(!faucetAddress[_msgSender()], "Limit exceeded.");
702         if (faucetTotalAddresses == 100000) {
703             faucetAmount = faucetAmount.div(2);
704             faucetTotalAddresses = 0;
705         }
706         faucetAddress[_msgSender()] = true;
707         faucetTotalAddresses++;
708         _mint(_msgSender(), faucetAmount);
709         emit Faucet(_msgSender(), faucetAmount, now);
710     }
711     
712     function getFaucetAddress(address _user) public view returns (bool) {
713         return faucetAddress[_user];
714     }
715 
716 }