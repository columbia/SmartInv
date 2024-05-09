1 pragma solidity 0.5.0;
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
78 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b <= a, "SafeMath: subtraction overflow");
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the multiplication of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `*` operator.
131      *
132      * Requirements:
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers. Reverts on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      * - The divisor cannot be zero.
159      */
160     function div(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Solidity only automatically asserts when dividing by 0
162         require(b > 0, "SafeMath: division by zero");
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      */
180     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
181         require(b != 0, "SafeMath: modulo by zero");
182         return a % b;
183     }
184 }
185 
186 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
187 
188 /**
189  * @dev Implementation of the `IERC20` interface.
190  *
191  * This implementation is agnostic to the way tokens are created. This means
192  * that a supply mechanism has to be added in a derived contract using `_mint`.
193  * For a generic mechanism see `ERC20Mintable`.
194  *
195  * *For a detailed writeup see our guide [How to implement supply
196  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
197  *
198  * We have followed general OpenZeppelin guidelines: functions revert instead
199  * of returning `false` on failure. This behavior is nonetheless conventional
200  * and does not conflict with the expectations of ERC20 applications.
201  *
202  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
203  * This allows applications to reconstruct the allowance for all accounts just
204  * by listening to said events. Other implementations of the EIP may not emit
205  * these events, as it isn't required by the specification.
206  *
207  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
208  * functions have been added to mitigate the well-known issues around setting
209  * allowances. See `IERC20.approve`.
210  */
211 contract ERC20 is IERC20 {
212     using SafeMath for uint256;
213 
214     mapping (address => uint256) internal _balances;
215 
216     mapping (address => mapping (address => uint256)) private _allowances;
217 
218     uint256 private _totalSupply;
219 
220     /**
221      * @dev See `IERC20.totalSupply`.
222      */
223     function totalSupply() public view returns (uint256) {
224         return _totalSupply;
225     }
226 
227     /**
228      * @dev See `IERC20.balanceOf`.
229      */
230     function balanceOf(address account) public view returns (uint256) {
231         return _balances[account];
232     }
233 
234     /**
235      * @dev See `IERC20.transfer`.
236      *
237      * Requirements:
238      *
239      * - `recipient` cannot be the zero address.
240      * - the caller must have a balance of at least `amount`.
241      */
242     function transfer(address recipient, uint256 amount) public returns (bool) {
243         _transfer(msg.sender, recipient, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See `IERC20.allowance`.
249      */
250     function allowance(address owner, address spender) public view returns (uint256) {
251         return _allowances[owner][spender];
252     }
253 
254     /**
255      * @dev See `IERC20.approve`.
256      *
257      * Requirements:
258      *
259      * - `spender` cannot be the zero address.
260      */
261     function approve(address spender, uint256 value) public returns (bool) {
262         _approve(msg.sender, spender, value);
263         return true;
264     }
265 
266     /**
267      * @dev See `IERC20.transferFrom`.
268      *
269      * Emits an `Approval` event indicating the updated allowance. This is not
270      * required by the EIP. See the note at the beginning of `ERC20`;
271      *
272      * Requirements:
273      * - `sender` and `recipient` cannot be the zero address.
274      * - `sender` must have a balance of at least `value`.
275      * - the caller must have allowance for `sender`'s tokens of at least
276      * `amount`.
277      */
278     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
279         _transfer(sender, recipient, amount);
280         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
281         return true;
282     }
283 
284     /**
285      * @dev Atomically increases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to `approve` that can be used as a mitigation for
288      * problems described in `IERC20.approve`.
289      *
290      * Emits an `Approval` event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
297         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
298         return true;
299     }
300 
301     /**
302      * @dev Atomically decreases the allowance granted to `spender` by the caller.
303      *
304      * This is an alternative to `approve` that can be used as a mitigation for
305      * problems described in `IERC20.approve`.
306      *
307      * Emits an `Approval` event indicating the updated allowance.
308      *
309      * Requirements:
310      *
311      * - `spender` cannot be the zero address.
312      * - `spender` must have allowance for the caller of at least
313      * `subtractedValue`.
314      */
315     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
316         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
317         return true;
318     }
319 
320     /**
321      * @dev Moves tokens `amount` from `sender` to `recipient`.
322      *
323      * This is internal function is equivalent to `transfer`, and can be used to
324      * e.g. implement automatic token fees, slashing mechanisms, etc.
325      *
326      * Emits a `Transfer` event.
327      *
328      * Requirements:
329      *
330      * - `sender` cannot be the zero address.
331      * - `recipient` cannot be the zero address.
332      * - `sender` must have a balance of at least `amount`.
333      */
334     function _transfer(address sender, address recipient, uint256 amount) internal {
335         require(sender != address(0), "ERC20: transfer from the zero address");
336         require(recipient != address(0), "ERC20: transfer to the zero address");
337 
338         _balances[sender] = _balances[sender].sub(amount);
339         _balances[recipient] = _balances[recipient].add(amount);
340         emit Transfer(sender, recipient, amount);
341     }
342 
343     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
344      * the total supply.
345      *
346      * Emits a `Transfer` event with `from` set to the zero address.
347      *
348      * Requirements
349      *
350      * - `to` cannot be the zero address.
351      */
352     function _mint(address account, uint256 amount) internal {
353         require(account != address(0), "ERC20: mint to the zero address");
354 
355         _totalSupply = _totalSupply.add(amount);
356         _balances[account] = _balances[account].add(amount);
357         emit Transfer(address(0), account, amount);
358     }
359 
360      /**
361      * @dev Destoys `amount` tokens from `account`, reducing the
362      * total supply.
363      *
364      * Emits a `Transfer` event with `to` set to the zero address.
365      *
366      * Requirements
367      *
368      * - `account` cannot be the zero address.
369      * - `account` must have at least `amount` tokens.
370      */
371     function _burn(address account, uint256 value) internal {
372         require(account != address(0), "ERC20: burn from the zero address");
373 
374         _totalSupply = _totalSupply.sub(value);
375         _balances[account] = _balances[account].sub(value);
376         emit Transfer(account, address(0), value);
377     }
378 
379     /**
380      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
381      *
382      * This is internal function is equivalent to `approve`, and can be used to
383      * e.g. set automatic allowances for certain subsystems, etc.
384      *
385      * Emits an `Approval` event.
386      *
387      * Requirements:
388      *
389      * - `owner` cannot be the zero address.
390      * - `spender` cannot be the zero address.
391      */
392     function _approve(address owner, address spender, uint256 value) internal {
393         require(owner != address(0), "ERC20: approve from the zero address");
394         require(spender != address(0), "ERC20: approve to the zero address");
395 
396         _allowances[owner][spender] = value;
397         emit Approval(owner, spender, value);
398     }
399 
400     /**
401      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
402      * from the caller's allowance.
403      *
404      * See `_burn` and `_approve`.
405      */
406     function _burnFrom(address account, uint256 amount) internal {
407         _burn(account, amount);
408         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
409     }
410 }
411 
412 contract GhostToken is ERC20 {
413     string public name = ""; // solium-disable-line uppercase
414     string public symbol = ""; // solium-disable-line uppercase
415     uint8 public constant decimals = 18; // solium-disable-line uppercase
416     uint256 public initialSupply = 0;
417 
418     constructor(string memory _name, string memory _symbol, uint256 _initialSupply) public {
419         name = _name;
420         symbol = _symbol;
421         initialSupply = _initialSupply * 10**uint256(decimals);
422         super._mint(msg.sender, initialSupply);
423         owner = msg.sender;
424     }
425 
426     //ownership
427     address public owner;
428 
429     event OwnershipRenounced(address indexed previousOwner);
430     event OwnershipTransferred(
431     address indexed previousOwner,
432     address indexed newOwner
433     );
434 
435     modifier onlyOwner() {
436         require(msg.sender == owner, "Not owner");
437         _;
438     }
439 
440  /**
441    * @dev Allows the current owner to relinquish control of the contract.
442    * @notice Renouncing to ownership will leave the contract without an owner.
443    * It will not be possible to call the functions with the `onlyOwner`
444    * modifier anymore.
445    */
446     function renounceOwnership() public onlyOwner {
447         emit OwnershipRenounced(owner);
448         owner = address(0);
449     }
450 
451   /**
452    * @dev Allows the current owner to transfer control of the contract to a newOwner.
453    * @param _newOwner The address to transfer ownership to.
454    */
455     function transferOwnership(address _newOwner) public onlyOwner {
456         _transferOwnership(_newOwner);
457     }
458 
459   /**
460    * @dev Transfers control of the contract to a newOwner.
461    * @param _newOwner The address to transfer ownership to.
462    */
463     function _transferOwnership(address _newOwner) internal {
464         require(_newOwner != address(0), "Already owner");
465         emit OwnershipTransferred(owner, _newOwner);
466         owner = _newOwner;
467     }
468 
469     //crc contract
470     address public crc;
471 
472     event CrcTransferred(
473     address indexed previousCrc,
474     address indexed newCrc
475     );
476 
477     function transferCrc(address _newCrc) public onlyOwner {
478         require(_newCrc != address(0), "Invalid Address");
479         emit CrcTransferred(crc, _newCrc);
480         crc = _newCrc;
481     }
482     
483     modifier onlyCrc() {
484         require(msg.sender == crc, "Not crc");
485         _;
486     }
487 
488     //mintable
489     event Mint(address indexed to, uint256 amount);
490 
491     function mint(
492         address _to,
493         uint256 _amount
494     )
495       public onlyCrc
496       returns (bool)
497     {
498         super._mint(_to, _amount);
499         emit Mint(_to, _amount);
500         return true;
501     }
502 
503     //burnable
504     event Burn(address indexed burner, uint256 value);
505 
506     function burn(address _who, uint256 _value) public onlyCrc returns (bool) {
507         require(_value <= super.balanceOf(_who), "Balance is too small.");
508 
509         super._burn(_who, _value);
510         emit Burn(_who, _value);
511 
512         return true;
513     }
514 }
515 
516 contract Ghost is ERC20 {
517     string public constant name = "GHOST"; // solium-disable-line uppercase
518     string public constant symbol = "GST"; // solium-disable-line uppercase
519     uint8 public constant decimals = 18; // solium-disable-line uppercase
520     uint256 public constant initialSupply = 2500000000 * (10 ** uint256(decimals));
521 
522     address[] public stakeHolders;
523 
524     struct ProposalInfo {
525         uint8 mode;
526         uint256 amount;
527         GhostToken ct;
528         mapping (address => bool) agreement;
529     }
530     mapping (address => ProposalInfo) public proposals;
531     
532     event AddStakeHolder(address indexed stakeHolder);
533     event RemoveStakeHolder(address indexed stakeHolder);
534     
535     event MakeProposal(address indexed target, uint8 mode, uint256 amount, address token);
536     event AgreeProposal(address indexed target, address stakeHolder);
537 
538     constructor() public {
539         super._mint(msg.sender, initialSupply);
540         owner = msg.sender;
541     }
542 
543     modifier onlyStakeHolder() {
544         bool validation = false;
545         for (uint i=0; i < stakeHolders.length; i++){
546             if (stakeHolders[i] == msg.sender) {
547                 validation = true;
548                 break;
549             }
550         }
551         require(validation, "Not stake holder");
552         _;
553     }
554 
555     function addStakeHolder(address newStakeHolder) public onlyOwner {
556         bool flag = false;
557         for (uint i=0; i < stakeHolders.length; i++){
558             if (stakeHolders[i] == newStakeHolder) flag = true;
559         }
560         require(!flag, "Already stake holder");
561         stakeHolders.push(newStakeHolder);
562         emit AddStakeHolder(newStakeHolder);
563     }
564 
565     function removeStakeHolder(address oldStakeHolder) public onlyOwner {
566         for (uint i=0; i < stakeHolders.length; i++){
567             if (stakeHolders[i] == oldStakeHolder) {
568                 stakeHolders[i] = stakeHolders[stakeHolders.length - 1];
569                 stakeHolders.length--;
570                 emit RemoveStakeHolder(oldStakeHolder);
571                 break;
572             }
573         }
574     }
575 
576     function makeProposal(address target, uint8 mode, uint256 amount, address token) public onlyOwner {
577         proposals[target] = ProposalInfo(mode, amount, GhostToken(token));
578         for (uint i=0; i < stakeHolders.length; i++){
579             proposals[target].agreement[stakeHolders[i]] = false;
580         }
581         emit MakeProposal(target, mode, amount, token);
582     }
583 
584     function agreeProposal(address target) public onlyStakeHolder {
585         proposals[target].agreement[msg.sender] = true;
586         emit AgreeProposal(target, msg.sender);
587         if (_checkAgreement(target)) {
588             if (proposals[target].mode == 1) {
589                 mint(target, proposals[target].amount, proposals[target].ct);
590                 proposals[target].mode = 3;
591             }
592             else if (proposals[target].mode == 2) {
593                 burn(target, proposals[target].amount, proposals[target].ct);
594                 proposals[target].mode = 4;
595             }
596         }
597     }
598 
599     
600     function _checkAgreement(address target) internal view returns (bool) {
601         uint num = 0;
602         for (uint i=0; i < stakeHolders.length; i++){
603             if (proposals[target].agreement[stakeHolders[i]]) {
604               num++;
605             }
606         }
607         if (stakeHolders.length == num) return true;
608         else return false;
609     }
610 
611     //token wallet contract
612     address public tokenWallet;
613 
614     event TokenWalletTransferred(
615     address indexed previousTokenWallet,
616     address indexed newTokenWallet
617     );
618 
619     function transferTokenWallet(address _newTokenWallet) public onlyOwner {
620         require(_newTokenWallet != address(0), "Invalid Address");
621         emit TokenWalletTransferred(tokenWallet, _newTokenWallet);
622         tokenWallet = _newTokenWallet;
623     }
624 
625     //ownership
626     address public owner;
627 
628     event OwnershipRenounced(address indexed previousOwner);
629     event OwnershipTransferred(
630     address indexed previousOwner,
631     address indexed newOwner
632     );
633 
634     modifier onlyOwner() {
635         require(msg.sender == owner, "Not owner");
636         _;
637     }
638 
639  /**
640    * @dev Allows the current owner to relinquish control of the contract.
641    * @notice Renouncing to ownership will leave the contract without an owner.
642    * It will not be possible to call the functions with the `onlyOwner`
643    * modifier anymore.
644    */
645     function renounceOwnership() public onlyOwner {
646         emit OwnershipRenounced(owner);
647         owner = address(0);
648     }
649 
650   /**
651    * @dev Allows the current owner to transfer control of the contract to a newOwner.
652    * @param _newOwner The address to transfer ownership to.
653    */
654     function transferOwnership(address _newOwner) public onlyOwner {
655         _transferOwnership(_newOwner);
656     }
657 
658   /**
659    * @dev Transfers control of the contract to a newOwner.
660    * @param _newOwner The address to transfer ownership to.
661    */
662     function _transferOwnership(address _newOwner) internal {
663         require(_newOwner != address(0), "Already owner");
664         emit OwnershipTransferred(owner, _newOwner);
665         owner = _newOwner;
666     }
667 
668     //pausable
669     event Pause();
670     event Unpause();
671 
672     bool public paused = false;
673     
674     /**
675     * @dev Modifier to make a function callable only when the contract is not paused.
676     */
677     modifier whenNotPaused() {
678         require(!paused, "Paused by owner");
679         _;
680     }
681 
682     /**
683     * @dev Modifier to make a function callable only when the contract is paused.
684     */
685     modifier whenPaused() {
686         require(paused, "Not paused now");
687         _;
688     }
689 
690     /**
691     * @dev called by the owner to pause, triggers stopped state
692     */
693     function pause() public onlyOwner whenNotPaused {
694         paused = true;
695         emit Pause();
696     }
697 
698     /**
699     * @dev called by the owner to unpause, returns to normal state
700     */
701     function unpause() public onlyOwner whenPaused {
702         paused = false;
703         emit Unpause();
704     }
705 
706     //freezable
707     event Frozen(address target);
708     event Unfrozen(address target);
709 
710     mapping(address => bool) internal freezes;
711 
712     modifier whenNotFrozen() {
713         require(!freezes[msg.sender], "Sender account is locked.");
714         _;
715     }
716 
717     function freeze(address _target) public onlyOwner {
718         freezes[_target] = true;
719         emit Frozen(_target);
720     }
721 
722     function unfreeze(address _target) public onlyOwner {
723         freezes[_target] = false;
724         emit Unfrozen(_target);
725     }
726 
727     function isFrozen(address _target) public view returns (bool) {
728         return freezes[_target];
729     }
730 
731     function transfer(
732         address _to,
733         uint256 _value
734     )
735       public
736       whenNotFrozen
737       whenNotPaused
738       returns (bool)
739     {
740         releaseLock(msg.sender);
741         return super.transfer(_to, _value);
742     }
743 
744     function transferFrom(
745         address _from,
746         address _to,
747         uint256 _value
748     )
749       public
750       whenNotPaused
751       returns (bool)
752     {
753         require(!freezes[_from], "From account is locked.");
754         releaseLock(_from);
755         return super.transferFrom(_from, _to, _value);
756     }
757 
758     //mintable
759     event Mint(address indexed to, uint256 amount);
760 
761     function mint(
762         address _to,
763         uint256 _amount,
764         GhostToken ct
765     )
766       internal
767       returns (bool)
768     {
769         require(tokenWallet != address(0), "token wallet is not set");
770         ct.mint(tokenWallet, _amount*10);
771         // crt.call(abi.encodeWithSignature("mint(address,uint256)",_to, _amount*10));
772         super._mint(_to, _amount);
773         emit Mint(_to, _amount);
774         
775         return true;
776     }
777 
778     //burnable
779     event Burn(address indexed burner, uint256 value);
780 
781     function burn(address _who, uint256 _value, GhostToken ct) internal {
782         require(_value <= super.balanceOf(_who), "Balance is too small.");
783         require(tokenWallet != address(0), "token wallet is not set");
784 
785         ct.burn(tokenWallet, _value*10);
786         _burn(_who, _value);
787         emit Burn(_who, _value);
788     }
789 
790     //lockable
791     struct LockInfo {
792         uint256 releaseTime;
793         uint256 balance;
794     }
795     mapping(address => LockInfo[]) internal lockInfo;
796 
797     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
798     event Unlock(address indexed holder, uint256 value);
799 
800     function balanceOf(address _holder) public view returns (uint256 balance) {
801         uint256 lockedBalance = 0;
802         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
803             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
804         }
805         return super.balanceOf(_holder).add(lockedBalance);
806     }
807 
808     function releaseLock(address _holder) internal {
809 
810         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
811             if (lockInfo[_holder][i].releaseTime <= now) {
812                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
813                 emit Unlock(_holder, lockInfo[_holder][i].balance);
814                 lockInfo[_holder][i].balance = 0;
815 
816                 if (i != lockInfo[_holder].length - 1) {
817                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
818                     i--;
819                 }
820                 lockInfo[_holder].length--;
821 
822             }
823         }
824     }
825     function lockCount(address _holder) public view returns (uint256) {
826         return lockInfo[_holder].length;
827     }
828     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
829         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
830     }
831 
832     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
833         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
834         _balances[_holder] = _balances[_holder].sub(_amount);
835         lockInfo[_holder].push(
836             LockInfo(_releaseTime, _amount)
837         );
838         emit Lock(_holder, _amount, _releaseTime);
839     }
840 
841     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
842         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
843         _balances[_holder] = _balances[_holder].sub(_amount);
844         lockInfo[_holder].push(
845             LockInfo(now + _afterTime, _amount)
846         );
847         emit Lock(_holder, _amount, now + _afterTime);
848     }
849 
850     function unlock(address _holder, uint256 i) public onlyOwner {
851         require(i < lockInfo[_holder].length, "No lock information.");
852 
853         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
854         emit Unlock(_holder, lockInfo[_holder][i].balance);
855         lockInfo[_holder][i].balance = 0;
856 
857         if (i != lockInfo[_holder].length - 1) {
858             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
859         }
860         lockInfo[_holder].length--;
861     }
862 
863     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
864         require(_to != address(0), "wrong address");
865         require(_value <= super.balanceOf(owner), "Not enough balance");
866 
867         _balances[owner] = _balances[owner].sub(_value);
868         lockInfo[_to].push(
869             LockInfo(_releaseTime, _value)
870         );
871         emit Transfer(owner, _to, _value);
872         emit Lock(_to, _value, _releaseTime);
873 
874         return true;
875     }
876 
877     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
878         require(_to != address(0), "wrong address");
879         require(_value <= super.balanceOf(owner), "Not enough balance");
880 
881         _balances[owner] = _balances[owner].sub(_value);
882         lockInfo[_to].push(
883             LockInfo(now + _afterTime, _value)
884         );
885         emit Transfer(owner, _to, _value);
886         emit Lock(_to, _value, now + _afterTime);
887 
888         return true;
889     }
890 
891     function currentTime() public view returns (uint256) {
892         return now;
893     }
894 
895     function afterTime(uint256 _value) public view returns (uint256) {
896         return now + _value;
897     }
898 }