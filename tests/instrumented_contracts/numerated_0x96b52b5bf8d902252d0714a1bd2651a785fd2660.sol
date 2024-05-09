1 pragma solidity 0.5.8;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
15 
16 /**
17  * @dev Wrappers over Solidity's arithmetic operations with added overflow
18  * checks.
19  *
20  * Arithmetic operations in Solidity wrap on overflow. This can easily result
21  * in bugs, because programmers usually assume that an overflow raises an
22  * error, which is the standard behavior in high level programming languages.
23  * `SafeMath` restores this intuition by reverting the transaction when an
24  * operation overflows.
25  *
26  * Using this library instead of the unchecked operations eliminates an entire
27  * class of bugs, so it's recommended to use it always.
28  */
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b <= a, "SafeMath: subtraction overflow");
39         uint256 c = a - b;
40 
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48         if (a == 0) {
49             return 0;
50         }
51 
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54 
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0, "SafeMath: division by zero");
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b != 0, "SafeMath: modulo by zero");
68         return a % b;
69     }
70 }
71 
72 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
73 
74 /**
75  * @dev Implementation of the `IERC20` interface.
76  *
77  * This implementation is agnostic to the way tokens are created. This means
78  * that a supply mechanism has to be added in a derived contract using `_mint`.
79  * For a generic mechanism see `ERC20Mintable`.
80  *
81  * *For a detailed writeup see our guide [How to implement supply
82  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
83  *
84  * We have followed general OpenZeppelin guidelines: functions revert instead
85  * of returning `false` on failure. This behavior is nonetheless conventional
86  * and does not conflict with the expectations of ERC20 applications.
87  *
88  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
89  * This allows applications to reconstruct the allowance for all accounts just
90  * by listening to said events. Other implementations of the EIP may not emit
91  * these events, as it isn't required by the specification.
92  *
93  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
94  * functions have been added to mitigate the well-known issues around setting
95  * allowances. See `IERC20.approve`.
96  */
97 contract ERC20 is IERC20 {
98     using SafeMath for uint256;
99 
100     mapping (address => uint256) internal _balances;
101 
102     mapping (address => mapping (address => uint256)) private _allowances;
103 
104     uint256 private _totalSupply;
105     function totalSupply() public view returns (uint256) {
106         return _totalSupply;
107     }
108     function balanceOf(address account) public view returns (uint256) {
109         return _balances[account];
110     }
111 
112     /**
113      * @dev See `IERC20.transfer`.
114      *
115      * Requirements:
116      *
117      * - `recipient` cannot be the zero address.
118      * - the caller must have a balance of at least `amount`.
119      */
120     function transfer(address recipient, uint256 amount) public returns (bool) {
121         _transfer(msg.sender, recipient, amount);
122         return true;
123     }
124 
125     /**
126      * @dev See `IERC20.allowance`.
127      */
128     function allowance(address owner, address spender) public view returns (uint256) {
129         return _allowances[owner][spender];
130     }
131 
132     /**
133      * @dev See `IERC20.approve`.
134      *
135      * Requirements:
136      *
137      * - `spender` cannot be the zero address.
138      */
139     function approve(address spender, uint256 value) public returns (bool) {
140         _approve(msg.sender, spender, value);
141         return true;
142     }
143 
144     /**
145      * @dev See `IERC20.transferFrom`.
146      *
147      * Emits an `Approval` event indicating the updated allowance. This is not
148      * required by the EIP. See the note at the beginning of `ERC20`;
149      *
150      * Requirements:
151      * - `sender` and `recipient` cannot be the zero address.
152      * - `sender` must have a balance of at least `value`.
153      * - the caller must have allowance for `sender`'s tokens of at least
154      * `amount`.
155      */
156     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
157         _transfer(sender, recipient, amount);
158         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
159         return true;
160     }
161 
162     /**
163      * @dev Atomically increases the allowance granted to `spender` by the caller.
164      *
165      * This is an alternative to `approve` that can be used as a mitigation for
166      * problems described in `IERC20.approve`.
167      *
168      * Emits an `Approval` event indicating the updated allowance.
169      *
170      * Requirements:
171      *
172      * - `spender` cannot be the zero address.
173      */
174     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
175         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
176         return true;
177     }
178 
179     /**
180      * @dev Atomically decreases the allowance granted to `spender` by the caller.
181      *
182      * This is an alternative to `approve` that can be used as a mitigation for
183      * problems described in `IERC20.approve`.
184      *
185      * Emits an `Approval` event indicating the updated allowance.
186      *
187      * Requirements:
188      *
189      * - `spender` cannot be the zero address.
190      * - `spender` must have allowance for the caller of at least
191      * `subtractedValue`.
192      */
193     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
194         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
195         return true;
196     }
197 
198     /**
199      * @dev Moves tokens `amount` from `sender` to `recipient`.
200      *
201      * This is internal function is equivalent to `transfer`, and can be used to
202      * e.g. implement automatic token fees, slashing mechanisms, etc.
203      *
204      * Emits a `Transfer` event.
205      *
206      * Requirements:
207      *
208      * - `sender` cannot be the zero address.
209      * - `recipient` cannot be the zero address.
210      * - `sender` must have a balance of at least `amount`.
211      */
212     function _transfer(address sender, address recipient, uint256 amount) internal {
213         require(sender != address(0), "ERC20: transfer from the zero address");
214         require(recipient != address(0), "ERC20: transfer to the zero address");
215 
216         _balances[sender] = _balances[sender].sub(amount);
217         _balances[recipient] = _balances[recipient].add(amount);
218         emit Transfer(sender, recipient, amount);
219     }
220 
221     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
222      * the total supply.
223      *
224      * Emits a `Transfer` event with `from` set to the zero address.
225      *
226      * Requirements
227      *
228      * - `to` cannot be the zero address.
229      */
230     function _mint(address account, uint256 amount) internal {
231         require(account != address(0), "ERC20: mint to the zero address");
232 
233         _totalSupply = _totalSupply.add(amount);
234         _balances[account] = _balances[account].add(amount);
235         emit Transfer(address(0), account, amount);
236     }
237 
238      /**
239      * @dev Destoys `amount` tokens from `account`, reducing the
240      * total supply.
241      *
242      * Emits a `Transfer` event with `to` set to the zero address.
243      *
244      * Requirements
245      *
246      * - `account` cannot be the zero address.
247      * - `account` must have at least `amount` tokens.
248      */
249     function _burn(address account, uint256 value) internal {
250         require(account != address(0), "ERC20: burn from the zero address");
251 
252         _totalSupply = _totalSupply.sub(value);
253         _balances[account] = _balances[account].sub(value);
254         emit Transfer(account, address(0), value);
255     }
256 
257     /**
258      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
259      *
260      * This is internal function is equivalent to `approve`, and can be used to
261      * e.g. set automatic allowances for certain subsystems, etc.
262      *
263      * Emits an `Approval` event.
264      *
265      * Requirements:
266      *
267      * - `owner` cannot be the zero address.
268      * - `spender` cannot be the zero address.
269      */
270     function _approve(address owner, address spender, uint256 value) internal {
271         require(owner != address(0), "ERC20: approve from the zero address");
272         require(spender != address(0), "ERC20: approve to the zero address");
273 
274         _allowances[owner][spender] = value;
275         emit Approval(owner, spender, value);
276     }
277 
278     /**
279      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
280      * from the caller's allowance.
281      *
282      * See `_burn` and `_approve`.
283      */
284     function _burnFrom(address account, uint256 amount) internal {
285         _burn(account, amount);
286         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
287     }
288 }
289 
290 
291 
292 contract EtherBone is ERC20 {
293     string public constant name = "EtherBone";
294     string public constant symbol = "ETHBN";
295     uint8 public constant decimals = 18;
296     uint256 public constant initialSupply = 1000000000 * (10 ** uint256(decimals));
297     bool public _lockStatus = false;
298     bool private isValue;
299     constructor() public {
300         super._mint(msg.sender, initialSupply);
301         owner = msg.sender;
302     }
303     mapping (address => uint256) private time;
304     mapping (address => uint256) private _lockedAmount;
305 
306     //ownership
307     address public owner;
308 
309     event OwnershipRenounced(address indexed previousOwner);
310     event OwnershipTransferred(
311      address indexed previousOwner,
312      address indexed newOwner
313     );
314 
315     modifier onlyOwner() {
316         require(msg.sender == owner, "Not owner");
317         _;
318     }
319 
320   /**
321    * @dev Allows the current owner to relinquish control of the contract.
322    * @notice Renouncing to ownership will leave the contract without an owner.
323    * It will not be possible to call the functions with the `onlyOwner`
324    * modifier anymore.
325    */
326     function renounceOwnership() public onlyOwner {
327         emit OwnershipRenounced(owner);
328         owner = address(0);
329     }
330 
331   /**
332    * @dev Allows the current owner to transfer control of the contract to a newOwner.
333    * @param _newOwner The address to transfer ownership to.
334    */
335     function transferOwnership(address _newOwner) public onlyOwner {
336         _transferOwnership(_newOwner);
337     }
338 
339   /**
340    * @dev Transfers control of the contract to a newOwner.
341    * @param _newOwner The address to transfer ownership to.
342    */
343     function _transferOwnership(address _newOwner) internal {
344         require(_newOwner != address(0), "Already owner");
345         emit OwnershipTransferred(owner, _newOwner);
346         owner = _newOwner;
347     }
348 
349     //pausable
350     event Pause();
351     event Unpause();
352 
353     bool public paused = false;
354 
355     /**
356     * @dev Modifier to make a function callable only when the contract is not paused.
357     */
358     modifier whenNotPaused() {
359         require(!paused, "Paused by owner");
360         _;
361     }
362 
363     /**
364     * @dev Modifier to make a function callable only when the contract is paused.
365     */
366     modifier whenPaused() {
367         require(paused, "Not paused now");
368         _;
369     }
370 
371     /**
372     * @dev called by the owner to pause, triggers stopped state
373     */
374     function pause() public onlyOwner whenNotPaused {
375         paused = true;
376         emit Pause();
377     }
378 
379     /**
380     * @dev called by the owner to unpause, returns to normal state
381     */
382     function unpause() public onlyOwner whenPaused {
383         paused = false;
384         emit Unpause();
385     }
386 
387     //freezable
388     event Frozen(address target);
389     event Unfrozen(address target);
390 
391     mapping(address => bool) internal freezes;
392 
393     modifier whenNotFrozen() {
394         require(!freezes[msg.sender], "Sender account is locked.");
395         _;
396     }
397 
398     function freeze(address _target) public onlyOwner {
399         freezes[_target] = true;
400         emit Frozen(_target);
401     }
402 
403     function unfreeze(address _target) public onlyOwner {
404         freezes[_target] = false;
405         emit Unfrozen(_target);
406     }
407 
408     function isFrozen(address _target) public view returns (bool) {
409         return freezes[_target];
410     }
411 
412 
413     /* ----------------------------------------------------------------------------
414      * Locking functions
415      * ----------------------------------------------------------------------------
416      */
417 
418     /**
419      * @dev Lock all transfer functions of the contract
420      * @return request status
421      */
422     function setAllTransfersLockStatus(bool RunningStatusLock) external onlyOwner returns (bool)
423     {
424         _lockStatus = RunningStatusLock;
425         return true;
426     }
427 
428     /**
429      * @dev check lock status of all transfers
430      * @return lock status
431      */
432     function getAllTransfersLockStatus() public view returns (bool)
433     {
434         return _lockStatus;
435     }
436 
437     /**
438      * @dev time calculator for locked tokens
439      */
440      function addLockingTime(address lockingAddress,uint8 lockingTime, uint256 amount) internal returns (bool){
441         time[lockingAddress] = now + (lockingTime * 1 days);
442         _lockedAmount[lockingAddress] = amount;
443         return true;
444      }
445 
446        function transferByOwner(address to, uint256 value, uint8 lockingTime) public AllTransfersLockStatus onlyOwner returns (bool) {
447         addLockingTime(to,lockingTime,value);
448         _transfer(msg.sender, to, value);
449         return true;
450     }
451 
452      /**
453       * @dev check for time based lock
454       * @param _address address to check for locking time
455       * @return time in block format
456       */
457       function checkLockingTimeByAddress(address _address) public view returns(uint256){
458          return time[_address];
459       }
460       /**
461        * @dev return locking status
462        * @param userAddress address of to check
463        * @return locking status in true or false
464        */
465        function getLockingStatus(address userAddress) public view returns(bool){
466            if (now < time[userAddress]){
467                return true;
468            }
469            else{
470                return false;
471            }
472        }
473 
474     /**
475      * @dev  Decreaese locking time
476      * @param _affectiveAddress Address of the locked address
477      * @param _decreasedTime Time in days to be affected
478      */
479     function decreaseLockingTimeByAddress(address _affectiveAddress, uint _decreasedTime) external onlyOwner returns(bool){
480           require(_decreasedTime > 0 && time[_affectiveAddress] > now, "Please check address status or Incorrect input");
481           time[_affectiveAddress] = time[_affectiveAddress] - (_decreasedTime * 1 days);
482           return true;
483       }
484 
485       /**
486      * @dev Increase locking time
487      * @param _affectiveAddress Address of the locked address
488      * @param _increasedTime Time in days to be affected
489      */
490     function increaseLockingTimeByAddress(address _affectiveAddress, uint _increasedTime) external onlyOwner returns(bool){
491           require(_increasedTime > 0 && time[_affectiveAddress] > now, "Please check address status or Incorrect input");
492           time[_affectiveAddress] = time[_affectiveAddress] + (_increasedTime * 1 days);
493           return true;
494       }
495 
496     /**
497      * @dev modifier to check validation of lock status of smart contract
498      */
499     modifier AllTransfersLockStatus()
500     {
501         require(_lockStatus == false,"All transactions are locked for this contract");
502         _;
503     }
504 
505     /**
506      * @dev modifier to check locking amount
507      * @param _address address to check
508      * @param requestedAmount Amount to check
509      * @return status
510      */
511      modifier checkLocking(address _address,uint256 requestedAmount){
512          if(now < time[_address]){
513          require(!( _balances[_address] - _lockedAmount[_address] < requestedAmount), "Insufficient unlocked balance");
514          }
515         else{
516             require(1 == 1,"Transfer can not be processed");
517         }
518         _;
519      }
520 
521     function transfer(
522         address _to,
523         uint256 _value
524     )
525       public
526       AllTransfersLockStatus
527       checkLocking(msg.sender,_value)
528       whenNotFrozen
529       whenNotPaused
530       returns (bool)
531     {
532         releaseLock(msg.sender);
533         return super.transfer(_to, _value);
534     }
535 
536     function transferFrom(
537         address _from,
538         address _to,
539         uint256 _value
540     )
541       public
542       AllTransfersLockStatus
543       checkLocking(_from,_value)
544       whenNotPaused
545       returns (bool)
546      {
547         require(!freezes[_from], "From account is locked.");
548         releaseLock(_from);
549         return super.transferFrom(_from, _to, _value);
550      }
551 
552     //mintable
553     event Mint(address indexed to, uint256 amount);
554 
555     function mint(
556         address _to,
557         uint256 _amount
558     )
559       public
560       onlyOwner
561       returns (bool)
562     {
563         super._mint(_to, _amount);
564         emit Mint(_to, _amount);
565         return true;
566     }
567 
568     //burnable
569     event Burn(address indexed burner, uint256 value);
570 
571     function burn(address _who, uint256 _value) public
572     onlyOwner
573     checkLocking(msg.sender,_value)
574     {
575         require(_value <= super.balanceOf(_who), "Balance is too small.");
576 
577         _burn(_who, _value);
578         emit Burn(_who, _value);
579     }
580 
581     //lockable
582     struct LockInfo {
583         uint256 releaseTime;
584         uint256 balance;
585     }
586     mapping(address => LockInfo[]) internal lockInfo;
587 
588     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
589     event Unlock(address indexed holder, uint256 value);
590 
591     function balanceOf(address _holder) public view returns (uint256 balance) {
592         uint256 lockedBalance = 0;
593         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
594             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
595         }
596         return super.balanceOf(_holder).add(lockedBalance);
597     }
598 
599     function releaseLock(address _holder) internal {
600 
601         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
602             if (lockInfo[_holder][i].releaseTime <= now) {
603                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
604                 emit Unlock(_holder, lockInfo[_holder][i].balance);
605                 lockInfo[_holder][i].balance = 0;
606 
607                 if (i != lockInfo[_holder].length - 1) {
608                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
609                     i--;
610                 }
611                 lockInfo[_holder].length--;
612 
613             }
614         }
615     }
616     function lockCount(address _holder) public view returns (uint256) {
617         return lockInfo[_holder].length;
618     }
619     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
620         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
621     }
622 
623     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
624         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
625         _balances[_holder] = _balances[_holder].sub(_amount);
626         lockInfo[_holder].push(
627             LockInfo(_releaseTime, _amount)
628         );
629         emit Lock(_holder, _amount, _releaseTime);
630     }
631 
632 
633     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
634         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
635         _balances[_holder] = _balances[_holder].sub(_amount);
636         lockInfo[_holder].push(
637             LockInfo(now + _afterTime, _amount)
638         );
639         emit Lock(_holder, _amount, now + _afterTime);
640     }
641 
642     function unlock(address _holder, uint256 i) public onlyOwner {
643         require(i < lockInfo[_holder].length, "No lock information.");
644 
645         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
646         emit Unlock(_holder, lockInfo[_holder][i].balance);
647         lockInfo[_holder][i].balance = 0;
648 
649         if (i != lockInfo[_holder].length - 1) {
650             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
651         }
652         lockInfo[_holder].length--;
653     }
654 
655     function transferLockedTokens(address from, address to, uint256 value) external onlyOwner returns (bool){
656         require((_lockedAmount[from] >= value) && (now < time[from]), "Insufficient unlocked balance");
657         require(from != address(0) && to != address(0), "Invalid address");
658         _lockedAmount[from] = _lockedAmount[from] - value;
659         _transfer(from,to,value);
660      }
661 
662     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
663         require(_to != address(0), "wrong address");
664         require(_value <= super.balanceOf(owner), "Not enough balance");
665 
666         _balances[owner] = _balances[owner].sub(_value);
667         lockInfo[_to].push(
668             LockInfo(_releaseTime, _value)
669         );
670         emit Transfer(owner, _to, _value);
671         emit Lock(_to, _value, _releaseTime);
672 
673         return true;
674     }
675 
676     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
677         require(_to != address(0), "wrong address");
678         require(_value <= super.balanceOf(owner), "Not enough balance");
679 
680         _balances[owner] = _balances[owner].sub(_value);
681         lockInfo[_to].push(
682             LockInfo(now + _afterTime, _value)
683         );
684         emit Transfer(owner, _to, _value);
685         emit Lock(_to, _value, now + _afterTime);
686 
687         return true;
688     }
689 
690     function currentTime() public view returns (uint256) {
691         return now;
692     }
693 
694     function afterTime(uint256 _value) public view returns (uint256) {
695         return now + _value;
696     }
697 
698     //airdrop
699     mapping (address => uint256) public airDropHistory;
700     event AirDrop(address _receiver, uint256 _amount);
701 
702     function airdropByOwner(address[] memory receivers, uint256[] memory values) public AllTransfersLockStatus onlyOwner {
703     require(receivers.length != 0);
704     require(receivers.length == values.length);
705 
706     for (uint256 i = 0; i < receivers.length; i++) {
707       address receiver = receivers[i];
708       uint256 amount = values[i];
709 
710       transfer(receiver, amount);
711       airDropHistory[receiver] += amount;
712 
713       emit AirDrop(receiver, amount);
714     }
715   }
716 }