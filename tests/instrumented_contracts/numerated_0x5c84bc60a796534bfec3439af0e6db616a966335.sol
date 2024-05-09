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
14 
15 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
16 
17 /**
18  * @dev Wrappers over Solidity's arithmetic operations with added overflow
19  * checks.
20  *
21  * Arithmetic operations in Solidity wrap on overflow. This can easily result
22  * in bugs, because programmers usually assume that an overflow raises an
23  * error, which is the standard behavior in high level programming languages.
24  * `SafeMath` restores this intuition by reverting the transaction when an
25  * operation overflows.
26  *
27  * Using this library instead of the unchecked operations eliminates an entire
28  * class of bugs, so it's recommended to use it always.
29  */
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b <= a, "SafeMath: subtraction overflow");
40         uint256 c = a - b;
41 
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55 
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Solidity only automatically asserts when dividing by 0
61         require(b > 0, "SafeMath: division by zero");
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64 
65         return c;
66     }
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         require(b != 0, "SafeMath: modulo by zero");
69         return a % b;
70     }
71 }
72 
73 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
74 
75 /**
76  * @dev Implementation of the `IERC20` interface.
77  *
78  * This implementation is agnostic to the way tokens are created. This means
79  * that a supply mechanism has to be added in a derived contract using `_mint`.
80  * For a generic mechanism see `ERC20Mintable`.
81  *
82  * *For a detailed writeup see our guide [How to implement supply
83  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
84  *
85  * We have followed general OpenZeppelin guidelines: functions revert instead
86  * of returning `false` on failure. This behavior is nonetheless conventional
87  * and does not conflict with the expectations of ERC20 applications.
88  *
89  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
90  * This allows applications to reconstruct the allowance for all accounts just
91  * by listening to said events. Other implementations of the EIP may not emit
92  * these events, as it isn't required by the specification.
93  *
94  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
95  * functions have been added to mitigate the well-known issues around setting
96  * allowances. See `IERC20.approve`.
97  */
98 contract ERC20 is IERC20 {
99     using SafeMath for uint256;
100 
101     mapping (address => uint256) internal _balances;
102 
103     mapping (address => mapping (address => uint256)) private _allowances;
104 
105     uint256 private _totalSupply;
106     function totalSupply() public view returns (uint256) {
107         return _totalSupply;
108     }
109     function balanceOf(address account) public view returns (uint256) {
110         return _balances[account];
111     }
112 
113     /**
114      * @dev See `IERC20.transfer`.
115      *
116      * Requirements:
117      *
118      * - `recipient` cannot be the zero address.
119      * - the caller must have a balance of at least `amount`.
120      */
121     function transfer(address recipient, uint256 amount) public returns (bool) {
122         _transfer(msg.sender, recipient, amount);
123         return true;
124     }
125 
126     /**
127      * @dev See `IERC20.allowance`.
128      */
129     function allowance(address owner, address spender) public view returns (uint256) {
130         return _allowances[owner][spender];
131     }
132 
133     /**
134      * @dev See `IERC20.approve`.
135      *
136      * Requirements:
137      *
138      * - `spender` cannot be the zero address.
139      */
140     function approve(address spender, uint256 value) public returns (bool) {
141         _approve(msg.sender, spender, value);
142         return true;
143     }
144 
145     /**
146      * @dev See `IERC20.transferFrom`.
147      *
148      * Emits an `Approval` event indicating the updated allowance. This is not
149      * required by the EIP. See the note at the beginning of `ERC20`;
150      *
151      * Requirements:
152      * - `sender` and `recipient` cannot be the zero address.
153      * - `sender` must have a balance of at least `value`.
154      * - the caller must have allowance for `sender`'s tokens of at least
155      * `amount`.
156      */
157     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
158         _transfer(sender, recipient, amount);
159         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
160         return true;
161     }
162 
163     /**
164      * @dev Atomically increases the allowance granted to `spender` by the caller.
165      *
166      * This is an alternative to `approve` that can be used as a mitigation for
167      * problems described in `IERC20.approve`.
168      *
169      * Emits an `Approval` event indicating the updated allowance.
170      *
171      * Requirements:
172      *
173      * - `spender` cannot be the zero address.
174      */
175     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
176         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
177         return true;
178     }
179 
180     /**
181      * @dev Atomically decreases the allowance granted to `spender` by the caller.
182      *
183      * This is an alternative to `approve` that can be used as a mitigation for
184      * problems described in `IERC20.approve`.
185      *
186      * Emits an `Approval` event indicating the updated allowance.
187      *
188      * Requirements:
189      *
190      * - `spender` cannot be the zero address.
191      * - `spender` must have allowance for the caller of at least
192      * `subtractedValue`.
193      */
194     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
195         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
196         return true;
197     }
198 
199     /**
200      * @dev Moves tokens `amount` from `sender` to `recipient`.
201      *
202      * This is internal function is equivalent to `transfer`, and can be used to
203      * e.g. implement automatic token fees, slashing mechanisms, etc.
204      *
205      * Emits a `Transfer` event.
206      *
207      * Requirements:
208      *
209      * - `sender` cannot be the zero address.
210      * - `recipient` cannot be the zero address.
211      * - `sender` must have a balance of at least `amount`.
212      */
213     function _transfer(address sender, address recipient, uint256 amount) internal {
214         require(sender != address(0), "ERC20: transfer from the zero address");
215         require(recipient != address(0), "ERC20: transfer to the zero address");
216 
217         _balances[sender] = _balances[sender].sub(amount);
218         _balances[recipient] = _balances[recipient].add(amount);
219         emit Transfer(sender, recipient, amount);
220     }
221 
222     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
223      * the total supply.
224      *
225      * Emits a `Transfer` event with `from` set to the zero address.
226      *
227      * Requirements
228      *
229      * - `to` cannot be the zero address.
230      */
231     function _mint(address account, uint256 amount) internal {
232         require(account != address(0), "ERC20: mint to the zero address");
233 
234         _totalSupply = _totalSupply.add(amount);
235         _balances[account] = _balances[account].add(amount);
236         emit Transfer(address(0), account, amount);
237     }
238 
239      /**
240      * @dev Destoys `amount` tokens from `account`, reducing the
241      * total supply.
242      *
243      * Emits a `Transfer` event with `to` set to the zero address.
244      *
245      * Requirements
246      *
247      * - `account` cannot be the zero address.
248      * - `account` must have at least `amount` tokens.
249      */
250     function _burn(address account, uint256 value) internal {
251         require(account != address(0), "ERC20: burn from the zero address");
252 
253         _totalSupply = _totalSupply.sub(value);
254         _balances[account] = _balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
260      *
261      * This is internal function is equivalent to `approve`, and can be used to
262      * e.g. set automatic allowances for certain subsystems, etc.
263      *
264      * Emits an `Approval` event.
265      *
266      * Requirements:
267      *
268      * - `owner` cannot be the zero address.
269      * - `spender` cannot be the zero address.
270      */
271     function _approve(address owner, address spender, uint256 value) internal {
272         require(owner != address(0), "ERC20: approve from the zero address");
273         require(spender != address(0), "ERC20: approve to the zero address");
274 
275         _allowances[owner][spender] = value;
276         emit Approval(owner, spender, value);
277     }
278 
279     /**
280      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
281      * from the caller's allowance.
282      *
283      * See `_burn` and `_approve`.
284      */
285     function _burnFrom(address account, uint256 amount) internal {
286         _burn(account, amount);
287         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
288     }
289 }
290 
291 
292 
293 contract Bone is ERC20 {
294     string public constant name = "Bone";
295     string public constant symbol = "Bone";
296     uint8 public constant decimals = 18;
297     uint256 public constant initialSupply = 1000000000 * (10 ** uint256(decimals));
298     bool public _lockStatus = false;
299     bool private isValue;
300     constructor() public {
301         super._mint(msg.sender, initialSupply);
302         owner = msg.sender;
303     }
304     mapping (address => uint256) private time;
305     mapping (address => uint256) private _lockedAmount;
306 
307     //ownership
308     address public owner;
309 
310     event OwnershipRenounced(address indexed previousOwner);
311     event OwnershipTransferred(
312      address indexed previousOwner,
313      address indexed newOwner
314     );
315 
316     modifier onlyOwner() {
317         require(msg.sender == owner, "Not owner");
318         _;
319     }
320 
321   /**
322    * @dev Allows the current owner to relinquish control of the contract.
323    * @notice Renouncing to ownership will leave the contract without an owner.
324    * It will not be possible to call the functions with the `onlyOwner`
325    * modifier anymore.
326    */
327     function renounceOwnership() public onlyOwner {
328         emit OwnershipRenounced(owner);
329         owner = address(0);
330     }
331 
332   /**
333    * @dev Allows the current owner to transfer control of the contract to a newOwner.
334    * @param _newOwner The address to transfer ownership to.
335    */
336     function transferOwnership(address _newOwner) public onlyOwner {
337         _transferOwnership(_newOwner);
338     }
339 
340   /**
341    * @dev Transfers control of the contract to a newOwner.
342    * @param _newOwner The address to transfer ownership to.
343    */
344     function _transferOwnership(address _newOwner) internal {
345         require(_newOwner != address(0), "Already owner");
346         emit OwnershipTransferred(owner, _newOwner);
347         owner = _newOwner;
348     }
349 
350     //pausable
351     event Pause();
352     event Unpause();
353 
354     bool public paused = false;
355 
356     /**
357     * @dev Modifier to make a function callable only when the contract is not paused.
358     */
359     modifier whenNotPaused() {
360         require(!paused, "Paused by owner");
361         _;
362     }
363 
364     /**
365     * @dev Modifier to make a function callable only when the contract is paused.
366     */
367     modifier whenPaused() {
368         require(paused, "Not paused now");
369         _;
370     }
371 
372     /**
373     * @dev called by the owner to pause, triggers stopped state
374     */
375     function pause() public onlyOwner whenNotPaused {
376         paused = true;
377         emit Pause();
378     }
379 
380     /**
381     * @dev called by the owner to unpause, returns to normal state
382     */
383     function unpause() public onlyOwner whenPaused {
384         paused = false;
385         emit Unpause();
386     }
387 
388     //freezable
389     event Frozen(address target);
390     event Unfrozen(address target);
391 
392     mapping(address => bool) internal freezes;
393 
394     modifier whenNotFrozen() {
395         require(!freezes[msg.sender], "Sender account is locked.");
396         _;
397     }
398 
399     function freeze(address _target) public onlyOwner {
400         freezes[_target] = true;
401         emit Frozen(_target);
402     }
403 
404     function unfreeze(address _target) public onlyOwner {
405         freezes[_target] = false;
406         emit Unfrozen(_target);
407     }
408 
409     function isFrozen(address _target) public view returns (bool) {
410         return freezes[_target];
411     }
412 
413 
414     /* ----------------------------------------------------------------------------
415      * Locking functions
416      * ----------------------------------------------------------------------------
417      */
418 
419     /**
420      * @dev Lock all transfer functions of the contract
421      * @return request status
422      */
423     function setAllTransfersLockStatus(bool RunningStatusLock) external onlyOwner returns (bool)
424     {
425         _lockStatus = RunningStatusLock;
426         return true;
427     }
428 
429     /**
430      * @dev check lock status of all transfers
431      * @return lock status
432      */
433     function getAllTransfersLockStatus() public view returns (bool)
434     {
435         return _lockStatus;
436     }
437 
438     /**
439      * @dev time calculator for locked tokens
440      */
441      function addLockingTime(address lockingAddress,uint8 lockingTime, uint256 amount) internal returns (bool){
442         time[lockingAddress] = now + (lockingTime * 1 days);
443         _lockedAmount[lockingAddress] = amount;
444         return true;
445      }
446 
447        function transferByOwner(address to, uint256 value, uint8 lockingTime) public AllTransfersLockStatus onlyOwner returns (bool) {
448         addLockingTime(to,lockingTime,value);
449         _transfer(msg.sender, to, value);
450         return true;
451     }
452 
453      /**
454       * @dev check for time based lock
455       * @param _address address to check for locking time
456       * @return time in block format
457       */
458       function checkLockingTimeByAddress(address _address) public view returns(uint256){
459          return time[_address];
460       }
461       /**
462        * @dev return locking status
463        * @param userAddress address of to check
464        * @return locking status in true or false
465        */
466        function getLockingStatus(address userAddress) public view returns(bool){
467            if (now < time[userAddress]){
468                return true;
469            }
470            else{
471                return false;
472            }
473        }
474 
475     /**
476      * @dev  Decreaese locking time
477      * @param _affectiveAddress Address of the locked address
478      * @param _decreasedTime Time in days to be affected
479      */
480     function decreaseLockingTimeByAddress(address _affectiveAddress, uint _decreasedTime) external onlyOwner returns(bool){
481           require(_decreasedTime > 0 && time[_affectiveAddress] > now, "Please check address status or Incorrect input");
482           time[_affectiveAddress] = time[_affectiveAddress] - (_decreasedTime * 1 days);
483           return true;
484       }
485 
486       /**
487      * @dev Increase locking time
488      * @param _affectiveAddress Address of the locked address
489      * @param _increasedTime Time in days to be affected
490      */
491     function increaseLockingTimeByAddress(address _affectiveAddress, uint _increasedTime) external onlyOwner returns(bool){
492           require(_increasedTime > 0 && time[_affectiveAddress] > now, "Please check address status or Incorrect input");
493           time[_affectiveAddress] = time[_affectiveAddress] + (_increasedTime * 1 days);
494           return true;
495       }
496 
497     /**
498      * @dev modifier to check validation of lock status of smart contract
499      */
500     modifier AllTransfersLockStatus()
501     {
502         require(_lockStatus == false,"All transactions are locked for this contract");
503         _;
504     }
505 
506     /**
507      * @dev modifier to check locking amount
508      * @param _address address to check
509      * @param requestedAmount Amount to check
510      * @return status
511      */
512      modifier checkLocking(address _address,uint256 requestedAmount){
513          if(now < time[_address]){
514          require(!( _balances[_address] - _lockedAmount[_address] < requestedAmount), "Insufficient unlocked balance");
515          }
516         else{
517             require(1 == 1,"Transfer can not be processed");
518         }
519         _;
520      }
521 
522     function transfer(
523         address _to,
524         uint256 _value
525     )
526       public
527       AllTransfersLockStatus
528       checkLocking(msg.sender,_value)
529       whenNotFrozen
530       whenNotPaused
531       returns (bool)
532     {
533         releaseLock(msg.sender);
534         return super.transfer(_to, _value);
535     }
536 
537     function transferFrom(
538         address _from,
539         address _to,
540         uint256 _value
541     )
542       public
543       AllTransfersLockStatus
544       checkLocking(_from,_value)
545       whenNotPaused
546       returns (bool)
547      {
548         require(!freezes[_from], "From account is locked.");
549         releaseLock(_from);
550         return super.transferFrom(_from, _to, _value);
551      }
552 
553     //mintable
554     event Mint(address indexed to, uint256 amount);
555 
556     function mint(
557         address _to,
558         uint256 _amount
559     )
560       public
561       onlyOwner
562       returns (bool)
563     {
564         super._mint(_to, _amount);
565         emit Mint(_to, _amount);
566         return true;
567     }
568 
569     //burnable
570     event Burn(address indexed burner, uint256 value);
571 
572     function burn(address _who, uint256 _value) public
573     onlyOwner
574     checkLocking(msg.sender,_value)
575     {
576         require(_value <= super.balanceOf(_who), "Balance is too small.");
577 
578         _burn(_who, _value);
579         emit Burn(_who, _value);
580     }
581 
582     //lockable
583     struct LockInfo {
584         uint256 releaseTime;
585         uint256 balance;
586     }
587     mapping(address => LockInfo[]) internal lockInfo;
588 
589     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
590     event Unlock(address indexed holder, uint256 value);
591 
592     function balanceOf(address _holder) public view returns (uint256 balance) {
593         uint256 lockedBalance = 0;
594         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
595             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
596         }
597         return super.balanceOf(_holder).add(lockedBalance);
598     }
599 
600     function releaseLock(address _holder) internal {
601 
602         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
603             if (lockInfo[_holder][i].releaseTime <= now) {
604                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
605                 emit Unlock(_holder, lockInfo[_holder][i].balance);
606                 lockInfo[_holder][i].balance = 0;
607 
608                 if (i != lockInfo[_holder].length - 1) {
609                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
610                     i--;
611                 }
612                 lockInfo[_holder].length--;
613 
614             }
615         }
616     }
617     function lockCount(address _holder) public view returns (uint256) {
618         return lockInfo[_holder].length;
619     }
620     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
621         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
622     }
623 
624     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
625         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
626         _balances[_holder] = _balances[_holder].sub(_amount);
627         lockInfo[_holder].push(
628             LockInfo(_releaseTime, _amount)
629         );
630         emit Lock(_holder, _amount, _releaseTime);
631     }
632 
633 
634     function lockAfter(address _holder, uint256 _amount, uint256 _afterTime) public onlyOwner {
635         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
636         _balances[_holder] = _balances[_holder].sub(_amount);
637         lockInfo[_holder].push(
638             LockInfo(now + _afterTime, _amount)
639         );
640         emit Lock(_holder, _amount, now + _afterTime);
641     }
642 
643     function unlock(address _holder, uint256 i) public onlyOwner {
644         require(i < lockInfo[_holder].length, "No lock information.");
645 
646         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
647         emit Unlock(_holder, lockInfo[_holder][i].balance);
648         lockInfo[_holder][i].balance = 0;
649 
650         if (i != lockInfo[_holder].length - 1) {
651             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
652         }
653         lockInfo[_holder].length--;
654     }
655 
656     function transferLockedTokens(address from, address to, uint256 value) external onlyOwner returns (bool){
657         require((_lockedAmount[from] >= value) && (now < time[from]), "Insufficient unlocked balance");
658         require(from != address(0) && to != address(0), "Invalid address");
659         _lockedAmount[from] = _lockedAmount[from] - value;
660         _transfer(from,to,value);
661      }
662 
663     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
664         require(_to != address(0), "wrong address");
665         require(_value <= super.balanceOf(owner), "Not enough balance");
666 
667         _balances[owner] = _balances[owner].sub(_value);
668         lockInfo[_to].push(
669             LockInfo(_releaseTime, _value)
670         );
671         emit Transfer(owner, _to, _value);
672         emit Lock(_to, _value, _releaseTime);
673 
674         return true;
675     }
676 
677     function transferWithLockAfter(address _to, uint256 _value, uint256 _afterTime) public onlyOwner returns (bool) {
678         require(_to != address(0), "wrong address");
679         require(_value <= super.balanceOf(owner), "Not enough balance");
680 
681         _balances[owner] = _balances[owner].sub(_value);
682         lockInfo[_to].push(
683             LockInfo(now + _afterTime, _value)
684         );
685         emit Transfer(owner, _to, _value);
686         emit Lock(_to, _value, now + _afterTime);
687 
688         return true;
689     }
690 
691     function currentTime() public view returns (uint256) {
692         return now;
693     }
694 
695     function afterTime(uint256 _value) public view returns (uint256) {
696         return now + _value;
697     }
698 
699     //airdrop
700     mapping (address => uint256) public airDropHistory;
701     event AirDrop(address _receiver, uint256 _amount);
702 
703     function airdropByOwner(address[] memory receivers, uint256[] memory values) public AllTransfersLockStatus onlyOwner {
704     require(receivers.length != 0);
705     require(receivers.length == values.length);
706 
707     for (uint256 i = 0; i < receivers.length; i++) {
708       address receiver = receivers[i];
709       uint256 amount = values[i];
710 
711       transfer(receiver, amount);
712       airDropHistory[receiver] += amount;
713 
714       emit AirDrop(receiver, amount);
715     }
716   }
717 }