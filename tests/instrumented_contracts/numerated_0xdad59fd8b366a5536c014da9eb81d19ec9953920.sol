1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a `Transfer` event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a, "SafeMath: subtraction overflow");
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Solidity only automatically asserts when dividing by 0
160         require(b > 0, "SafeMath: division by zero");
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b != 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 }
183 
184 /**
185  * @dev Implementation of the `IERC20` interface.
186  *
187  * This implementation is agnostic to the way tokens are created. This means
188  * that a supply mechanism has to be added in a derived contract using `_mint`.
189  * For a generic mechanism see `ERC20Mintable`.
190  *
191  * *For a detailed writeup see our guide [How to implement supply
192  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
193  *
194  * We have followed general OpenZeppelin guidelines: functions revert instead
195  * of returning `false` on failure. This behavior is nonetheless conventional
196  * and does not conflict with the expectations of ERC20 applications.
197  *
198  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
199  * This allows applications to reconstruct the allowance for all accounts just
200  * by listening to said events. Other implementations of the EIP may not emit
201  * these events, as it isn't required by the specification.
202  *
203  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
204  * functions have been added to mitigate the well-known issues around setting
205  * allowances. See `IERC20.approve`.
206  */
207 contract ERC20 is IERC20 {
208     using SafeMath for uint256;
209 
210     mapping (address => uint256) private _balances;
211 
212     mapping (address => mapping (address => uint256)) private _allowances;
213 
214     uint256 private _totalSupply;
215 
216     /**
217      * @dev See `IERC20.totalSupply`.
218      */
219     function totalSupply() public view returns (uint256) {
220         return _totalSupply;
221     }
222 
223     /**
224      * @dev See `IERC20.balanceOf`.
225      */
226     function balanceOf(address account) public view returns (uint256) {
227         return _balances[account];
228     }
229 
230     /**
231      * @dev See `IERC20.transfer`.
232      *
233      * Requirements:
234      *
235      * - `recipient` cannot be the zero address.
236      * - the caller must have a balance of at least `amount`.
237      */
238     function transfer(address recipient, uint256 amount) public returns (bool) {
239         _transfer(msg.sender, recipient, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See `IERC20.allowance`.
245      */
246     function allowance(address owner, address spender) public view returns (uint256) {
247         return _allowances[owner][spender];
248     }
249 
250     /**
251      * @dev See `IERC20.approve`.
252      *
253      * Requirements:
254      *
255      * - `spender` cannot be the zero address.
256      */
257     function approve(address spender, uint256 value) public returns (bool) {
258         _approve(msg.sender, spender, value);
259         return true;
260     }
261 
262     /**
263      * @dev See `IERC20.transferFrom`.
264      *
265      * Emits an `Approval` event indicating the updated allowance. This is not
266      * required by the EIP. See the note at the beginning of `ERC20`;
267      *
268      * Requirements:
269      * - `sender` and `recipient` cannot be the zero address.
270      * - `sender` must have a balance of at least `value`.
271      * - the caller must have allowance for `sender`'s tokens of at least
272      * `amount`.
273      */
274     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
275         _transfer(sender, recipient, amount);
276         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
277         return true;
278     }
279 
280     /**
281      * @dev Atomically increases the allowance granted to `spender` by the caller.
282      *
283      * This is an alternative to `approve` that can be used as a mitigation for
284      * problems described in `IERC20.approve`.
285      *
286      * Emits an `Approval` event indicating the updated allowance.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
293         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
294         return true;
295     }
296 
297     /**
298      * @dev Atomically decreases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to `approve` that can be used as a mitigation for
301      * problems described in `IERC20.approve`.
302      *
303      * Emits an `Approval` event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      * - `spender` must have allowance for the caller of at least
309      * `subtractedValue`.
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
312         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
313         return true;
314     }
315 
316     /**
317      * @dev Moves tokens `amount` from `sender` to `recipient`.
318      *
319      * This is internal function is equivalent to `transfer`, and can be used to
320      * e.g. implement automatic token fees, slashing mechanisms, etc.
321      *
322      * Emits a `Transfer` event.
323      *
324      * Requirements:
325      *
326      * - `sender` cannot be the zero address.
327      * - `recipient` cannot be the zero address.
328      * - `sender` must have a balance of at least `amount`.
329      */
330     function _transfer(address sender, address recipient, uint256 amount) internal {
331         require(sender != address(0), "ERC20: transfer from the zero address");
332         require(recipient != address(0), "ERC20: transfer to the zero address");
333 
334         _balances[sender] = _balances[sender].sub(amount);
335         _balances[recipient] = _balances[recipient].add(amount);
336         emit Transfer(sender, recipient, amount);
337     }
338 
339     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
340      * the total supply.
341      *
342      * Emits a `Transfer` event with `from` set to the zero address.
343      *
344      * Requirements
345      *
346      * - `to` cannot be the zero address.
347      */
348     function _mint(address account, uint256 amount) internal {
349         require(account != address(0), "ERC20: mint to the zero address");
350 
351         _totalSupply = _totalSupply.add(amount);
352         _balances[account] = _balances[account].add(amount);
353         emit Transfer(address(0), account, amount);
354     }
355 
356      /**
357      * @dev Destoys `amount` tokens from `account`, reducing the
358      * total supply.
359      *
360      * Emits a `Transfer` event with `to` set to the zero address.
361      *
362      * Requirements
363      *
364      * - `account` cannot be the zero address.
365      * - `account` must have at least `amount` tokens.
366      */
367     function _burn(address account, uint256 value) internal {
368         require(account != address(0), "ERC20: burn from the zero address");
369 
370         _totalSupply = _totalSupply.sub(value);
371         _balances[account] = _balances[account].sub(value);
372         emit Transfer(account, address(0), value);
373     }
374 
375     /**
376      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
377      *
378      * This is internal function is equivalent to `approve`, and can be used to
379      * e.g. set automatic allowances for certain subsystems, etc.
380      *
381      * Emits an `Approval` event.
382      *
383      * Requirements:
384      *
385      * - `owner` cannot be the zero address.
386      * - `spender` cannot be the zero address.
387      */
388     function _approve(address owner, address spender, uint256 value) internal {
389         require(owner != address(0), "ERC20: approve from the zero address");
390         require(spender != address(0), "ERC20: approve to the zero address");
391 
392         _allowances[owner][spender] = value;
393         emit Approval(owner, spender, value);
394     }
395 
396     /**
397      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
398      * from the caller's allowance.
399      *
400      * See `_burn` and `_approve`.
401      */
402     function _burnFrom(address account, uint256 amount) internal {
403         _burn(account, amount);
404         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
405     }
406 }
407 
408 /**
409  * @title Mintable token
410  * @dev Simple ERC20 Token example, with mintable token creation
411  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
412  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
413  */
414 contract MintableToken is ERC20 {
415   event Mint(address indexed to, uint256 amount);
416   event MintFinished();
417 
418   bool public mintingFinished = false;
419 
420 
421   modifier canMint() {
422     require(!mintingFinished);
423     _;
424   }
425 
426   /**
427    * @dev Function to mint tokens
428    * @param _to The address that will receive the minted tokens.
429    * @param _amount The amount of tokens to mint.
430    * @return A boolean that indicates if the operation was successful.
431    */
432   function mint(address _to, uint256 _amount) canMint internal returns (bool) {
433     _mint(_to, _amount);
434     return true;
435   }
436 
437   /**
438    * @dev Function to stop minting new tokens.
439    * @return True if the operation was successful.
440    */
441   function finishMinting() canMint internal returns (bool) {
442     mintingFinished = true;
443     emit MintFinished();
444     return true;
445   }
446 }
447 
448 /**
449  * @title Roles
450  * @dev Library for managing addresses assigned to a Role.
451  */
452 library Roles {
453     struct Role {
454         mapping (address => bool) bearer;
455     }
456 
457     /**
458      * @dev Give an account access to this role.
459      */
460     function add(Role storage role, address account) internal {
461         require(!has(role, account), "Roles: account already has role");
462         role.bearer[account] = true;
463     }
464 
465     /**
466      * @dev Remove an account's access to this role.
467      */
468     function remove(Role storage role, address account) internal {
469         require(has(role, account), "Roles: account does not have role");
470         role.bearer[account] = false;
471     }
472 
473     /**
474      * @dev Check if an account has this role.
475      * @return bool
476      */
477     function has(Role storage role, address account) internal view returns (bool) {
478         require(account != address(0), "Roles: account is the zero address");
479         return role.bearer[account];
480     }
481 }
482 
483 contract PauserRole {
484     using Roles for Roles.Role;
485 
486     event PauserAdded(address indexed account);
487     event PauserRemoved(address indexed account);
488 
489     Roles.Role private _pausers;
490 
491     constructor () internal {
492         _addPauser(msg.sender);
493     }
494 
495     modifier onlyPauser() {
496         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
497         _;
498     }
499 
500     function isPauser(address account) public view returns (bool) {
501         return _pausers.has(account);
502     }
503 
504     function addPauser(address account) public onlyPauser {
505         _addPauser(account);
506     }
507 
508     function renouncePauser() public {
509         _removePauser(msg.sender);
510     }
511 
512     function _addPauser(address account) internal {
513         _pausers.add(account);
514         emit PauserAdded(account);
515     }
516 
517     function _removePauser(address account) internal {
518         _pausers.remove(account);
519         emit PauserRemoved(account);
520     }
521 }
522 
523 /**
524  * @dev Contract module which allows children to implement an emergency stop
525  * mechanism that can be triggered by an authorized account.
526  *
527  * This module is used through inheritance. It will make available the
528  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
529  * the functions of your contract. Note that they will not be pausable by
530  * simply including this module, only once the modifiers are put in place.
531  */
532 contract Pausable is PauserRole {
533     /**
534      * @dev Emitted when the pause is triggered by a pauser (`account`).
535      */
536     event Paused(address account);
537 
538     /**
539      * @dev Emitted when the pause is lifted by a pauser (`account`).
540      */
541     event Unpaused(address account);
542 
543     bool private _paused;
544 
545     /**
546      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
547      * to the deployer.
548      */
549     constructor () internal {
550         _paused = false;
551     }
552 
553     /**
554      * @dev Returns true if the contract is paused, and false otherwise.
555      */
556     function paused() public view returns (bool) {
557         return _paused;
558     }
559 
560     /**
561      * @dev Modifier to make a function callable only when the contract is not paused.
562      */
563     modifier whenNotPaused() {
564         require(!_paused, "Pausable: paused");
565         _;
566     }
567 
568     /**
569      * @dev Modifier to make a function callable only when the contract is paused.
570      */
571     modifier whenPaused() {
572         require(_paused, "Pausable: not paused");
573         _;
574     }
575 
576     /**
577      * @dev Called by a pauser to pause, triggers stopped state.
578      */
579     function pause() public onlyPauser whenNotPaused {
580         _paused = true;
581         emit Paused(msg.sender);
582     }
583 
584     /**
585      * @dev Called by a pauser to unpause, returns to normal state.
586      */
587     function unpause() public onlyPauser whenPaused {
588         _paused = false;
589         emit Unpaused(msg.sender);
590     }
591 }
592 
593 /**
594  * @dev Contract module which provides a basic access control mechanism, where
595  * there is an account (an owner) that can be granted exclusive access to
596  * specific functions.
597  *
598  * This module is used through inheritance. It will make available the modifier
599  * `onlyOwner`, which can be aplied to your functions to restrict their use to
600  * the owner.
601  */
602 contract Ownable {
603     address private _owner;
604 
605     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
606 
607     /**
608      * @dev Initializes the contract setting the deployer as the initial owner.
609      */
610     constructor () internal {
611         _owner = msg.sender;
612         emit OwnershipTransferred(address(0), _owner);
613     }
614 
615     /**
616      * @dev Returns the address of the current owner.
617      */
618     function owner() public view returns (address) {
619         return _owner;
620     }
621 
622     /**
623      * @dev Throws if called by any account other than the owner.
624      */
625     modifier onlyOwner() {
626         require(isOwner(), "Ownable: caller is not the owner");
627         _;
628     }
629 
630     /**
631      * @dev Returns true if the caller is the current owner.
632      */
633     function isOwner() public view returns (bool) {
634         return msg.sender == _owner;
635     }
636 
637     /**
638      * @dev Leaves the contract without owner. It will not be possible to call
639      * `onlyOwner` functions anymore. Can only be called by the current owner.
640      *
641      * > Note: Renouncing ownership will leave the contract without an owner,
642      * thereby removing any functionality that is only available to the owner.
643      */
644     function renounceOwnership() public onlyOwner {
645         emit OwnershipTransferred(_owner, address(0));
646         _owner = address(0);
647     }
648 
649     /**
650      * @dev Transfers ownership of the contract to a new account (`newOwner`).
651      * Can only be called by the current owner.
652      */
653     function transferOwnership(address newOwner) public onlyOwner {
654         _transferOwnership(newOwner);
655     }
656 
657     /**
658      * @dev Transfers ownership of the contract to a new account (`newOwner`).
659      */
660     function _transferOwnership(address newOwner) internal {
661         require(newOwner != address(0), "Ownable: new owner is the zero address");
662         emit OwnershipTransferred(_owner, newOwner);
663         _owner = newOwner;
664     }
665 }
666 
667 contract FLINT is MintableToken, Ownable, Pausable {
668 
669     using SafeMath for uint256;
670     //The name of the  token
671     string public constant name = "MintFlint Token";
672     //The token symbol
673     string public constant symbol = "FLINT";
674     //The precision used in the balance calculations in contract
675     uint8 public constant decimals = 18;
676     // DEV fund address that holds the 21.9152% of total FLINT supply
677     address public devFund = 0xD674719E383Dab1626c83a5D5A1956dA2F5b3b05;
678     // Sambhav's address that holds the 20.06% of total FLINT supply
679     address public sambhav = 0xcFc43257606C6a642d9438dCd82bf5b39A17dbAB;
680     // Pondsea's address that holds the 6.0174% of total FLINT supply
681     address public pondsea = 0xEf628A29668C00d5C7C4D915F07188dC96cF24eb;
682     // Austin's address that holds the 1% of total FLINT supply
683     address public austin = 0x6801c3f0BdCA16E0B3206b8c804e94F5d01cA835;
684     // Artem's address that holds the 1% of total FLINT supply
685     address public artem = 0x3C7AAD7b693E94f13b61d4Be4ABaeaf802b2E3B5;
686     // Kiran's address that holds the 0.0074% of total FLINT supply
687     address public kiran = 0x3a312D7D725BB257b725c2EC5F945304E9EcF17B;
688 
689     constructor() public {
690 
691     }
692 
693     // Standard mint that doesn't increase the balance of "special" holders
694     function mintStandard(address _to, uint256 _amount) public whenNotPaused onlyOwner canMint returns (bool) {
695         return mint(_to, _amount);
696     }
697 
698     // Standard mint that increase the balance of "special" holders according to their total share of FLINT tokens
699     function mintSpecial(address _to, uint256 _amount) public whenNotPaused onlyOwner canMint returns (bool) {
700         // to keep the proper share of special addresses we should calculate the resulting_amount of total supply increase
701         // to do this we should mul the amount by 2, total special holders share is 50%, so it's result of equation
702         // resulting_amount = _amount + 0,5 * resulting_amount, which turns to resulting_amount = 2 * _amount
703         uint256 resulting_amount = _amount.mul(2);
704         require(mint(devFund, resulting_amount.mul(219152).div(1000000)));
705         require(mint(sambhav, resulting_amount.mul(2006).div(10000)));
706         require(mint(pondsea, resulting_amount.mul(60174).div(1000000)));
707         require(mint(austin, resulting_amount.div(100)));
708         require(mint(artem, resulting_amount.div(100)));
709         require(mint(kiran, resulting_amount.mul(74).div(1000000)));
710         return mint(_to, _amount);
711     }
712 
713     // Finish minting in case we'd like to stop it
714     function finishMint() public onlyOwner canMint returns (bool) {
715         return finishMinting();
716     }
717 
718     function setDevFund(address _new) public onlyOwner {
719         devFund = _new;
720     }
721 
722     function setSambhav(address _new) public onlyOwner {
723         sambhav = _new;
724     }
725 
726     function setPondsea(address _new) public onlyOwner {
727         pondsea = _new;
728     }
729 
730     function setAustin(address _new) public onlyOwner {
731         austin = _new;
732     }
733 
734     function setArtem(address _new) public onlyOwner {
735         artem = _new;
736     }
737 
738     function setKiran(address _new) public onlyOwner {
739         kiran = _new;
740     }
741 
742     function transfer(address recipient, uint256 amount) whenNotPaused public returns (bool) {
743         return super.transfer(recipient, amount);
744     }
745 
746     function transferFrom(address sender, address recipient, uint256 amount) whenNotPaused public returns (bool) {
747         return super.transferFrom(sender, recipient, amount);
748     }
749 }