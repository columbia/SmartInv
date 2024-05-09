1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10     * @dev Multiplies two unsigned integers, reverts on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28     */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40     */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49     * @dev Adds two unsigned integers, reverts on overflow.
50     */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60     * reverts when dividing by zero.
61     */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 contract ERC20 {
69 
70     // Get the total token supply
71     function totalSupply() public view returns (uint256);
72 
73     // Get the account balance of another account with address _owner
74     function balanceOf(address who) public view returns (uint256);
75 
76     // Send _value amount of tokens to address _to
77     function transfer(address to, uint256 value) public returns (bool);
78 
79     // Send _value amount of tokens from address _from to address _to
80     function transferFrom(address from, address to, uint256 value) public returns (bool);
81 
82     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
83     // If this function is called again it overwrites the current allowance with _value.
84     // this function is required for some DEX functionality
85     function approve(address spender, uint256 value) public returns (bool);
86 
87     // Returns the amount which _spender is still allowed to withdraw from _owner
88     function allowance(address owner, address spender) public view returns (uint256);
89 
90     // Triggered when tokens are transferred.
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     // Triggered whenever approve(address _spender, uint256 _value) is called.
94     event Approval(address indexed owner,address indexed spender,uint256 value);
95 }
96 
97 /// @title Implementation of basic ERC20 function.
98 /// @notice The only difference from most other ERC20 contracts is that we introduce 2 superusers - the founder and the admin.
99 contract _Base20 is ERC20 {
100   using SafeMath for uint256;
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104   mapping(address => uint256) internal accounts;
105 
106   address internal admin;
107 
108   address payable internal founder;
109 
110   uint256 internal __totalSupply;
111 
112   constructor(uint256 _totalSupply,
113     address payable _founder,
114     address _admin) public {
115       __totalSupply = _totalSupply;
116       admin = _admin;
117       founder = _founder;
118       accounts[founder] = __totalSupply;
119       emit Transfer(address(0), founder, accounts[founder]);
120     }
121 
122     // define onlyAdmin
123     modifier onlyAdmin {
124       require(admin == msg.sender);
125       _;
126     }
127 
128     // define onlyFounder
129     modifier onlyFounder {
130       require(founder == msg.sender);
131       _;
132     }
133 
134     // Change founder
135     function changeFounder(address payable who) onlyFounder public {
136       founder = who;
137     }
138 
139     // show founder address
140     function getFounder() onlyFounder public view returns (address) {
141       return founder;
142     }
143 
144     // Change admin
145     function changeAdmin(address who) public {
146       require(who == founder || who == admin);
147       admin = who;
148     }
149 
150     // show admin address
151     function getAdmin() public view returns (address) {
152       require(msg.sender == founder || msg.sender == admin);
153       return admin;
154     }
155 
156     //
157     // ERC20 spec.
158     //
159     function totalSupply() public view returns (uint256) {
160       return __totalSupply;
161     }
162 
163     // ERC20 spec.
164     function balanceOf(address _owner) public view returns (uint256) {
165       return accounts[_owner];
166     }
167 
168     function _transfer(address _from, address _to, uint256 _value)
169     internal returns (bool) {
170       require(_to != address(0));
171 
172       require(_value <= accounts[_from]);
173 
174       // This should go first. If SafeMath.add fails, the sender's balance is not changed
175       accounts[_to] = accounts[_to].add(_value);
176       accounts[_from] = accounts[_from].sub(_value);
177 
178       emit Transfer(_from, _to, _value);
179 
180       return true;
181     }
182     // ERC20 spec.
183     function transfer(address _to, uint256 _value) public returns (bool) {
184       return _transfer(msg.sender, _to, _value);
185     }
186 
187     // ERC20 spec.
188     function transferFrom(address _from, address _to, uint256 _value)
189     public returns (bool) {
190       require(_value <= allowed[_from][msg.sender]);
191 
192       // _transfer is either successful, or throws.
193       _transfer(_from, _to, _value);
194 
195       allowed[_from][msg.sender] -= _value;
196       emit Approval(_from, msg.sender, allowed[_from][msg.sender]);
197 
198       return true;
199     }
200 
201     // ERC20 spec.
202     function approve(address _spender, uint256 _value) public returns (bool) {
203       allowed[msg.sender][_spender] = _value;
204       emit Approval(msg.sender, _spender, _value);
205       return true;
206     }
207 
208     // ERC20 spec.
209     function allowance(address _owner, address _spender) public view returns (uint256) {
210       return allowed[_owner][_spender];
211     }
212 }
213 
214 /// @title Admin can suspend specific wallets in cases of misbehaving or theft.
215 /// @notice This contract implements methods to lock tranfers, either globally or for specific accounts.
216 contract _Suspendable is _Base20 {
217   /// @dev flag whether transfers are allowed on global scale.
218   ///    When `isTransferable` is `false`, all transfers between wallets are blocked.
219   bool internal isTransferable = false;
220   /// @dev set of suspended wallets.
221   ///   When `suspendedAddresses[wallet]` is `true`, the `wallet` can't both send and receive COLs.
222   mapping(address => bool) internal suspendedAddresses;
223 
224   /// @notice Sets total supply and the addresses of super users - founder and admin.
225   /// @param _totalSupply Total amount of Color Coin tokens available.
226   /// @param _founder Address of the founder wallet
227   /// @param _admin Address of the admin wallet
228   constructor(uint256 _totalSupply,
229     address payable _founder,
230     address _admin) public _Base20(_totalSupply, _founder, _admin)
231   {
232   }
233 
234   /// @dev specifies that the marked method could be used only when transfers are enabled.
235   ///   Founder can always transfer
236   modifier transferable {
237     require(isTransferable || msg.sender == founder);
238     _;
239   }
240 
241   /// @notice Getter for the global flag `isTransferable`.
242   /// @dev Everyone is allowed to view it.
243   function isTransferEnabled() public view returns (bool) {
244     return isTransferable;
245   }
246 
247   /// @notice Enable tranfers globally.
248   ///   Note that suspended acccounts remain to be suspended.
249   /// @dev Sets the global flag `isTransferable` to `true`.
250   function enableTransfer() onlyAdmin public {
251     isTransferable = true;
252   }
253 
254   /// @notice Disable tranfers globally.
255   ///   All transfers between wallets are blocked.
256   /// @dev Sets the global flag `isTransferable` to `false`.
257   function disableTransfer() onlyAdmin public {
258     isTransferable = false;
259   }
260 
261   /// @notice Check whether an address is suspended.
262   /// @dev Everyone can check any address they want.
263   /// @param _address wallet to check
264   /// @return returns `true` if the wallet `who` is suspended.
265   function isSuspended(address _address) public view returns(bool) {
266     return suspendedAddresses[_address];
267   }
268 
269   /// @notice Suspend an individual wallet.
270   /// @dev Neither the founder nor the admin could be suspended.
271   /// @param who  address of the wallet to suspend.
272   function suspend(address who) onlyAdmin public {
273     if (who == founder || who == admin) {
274       return;
275     }
276     suspendedAddresses[who] = true;
277   }
278 
279   /// @notice Unsuspend an individual wallet
280   /// @param who  address of the wallet to unsuspend.
281   function unsuspend(address who) onlyAdmin public {
282     suspendedAddresses[who] = false;
283   }
284 
285   //
286   // Update of ERC20 functions
287   //
288 
289   /// @dev Internal function for transfers updated.
290   ///   Neither source nor destination of the transfer can be suspended.
291   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
292     require(!isSuspended(_to));
293     require(!isSuspended(_from));
294 
295     return super._transfer(_from, _to, _value);
296   }
297 
298   /// @notice `transfer` can't happen when transfers are disabled globally
299   /// @dev added modifier `transferable`.
300   function transfer(address _to, uint256 _value) public transferable returns (bool) {
301     return _transfer(msg.sender, _to, _value);
302   }
303 
304   /// @notice `transferFrom` can't happen when transfers are disabled globally
305   /// @dev added modifier `transferable`.
306   function transferFrom(address _from, address _to, uint256 _value) public transferable returns (bool) {
307     require(!isSuspended(msg.sender));
308     return super.transferFrom(_from, _to, _value);
309   }
310 
311   // ERC20 spec.
312   /// @notice `approve` can't happen when transfers disabled globally
313   ///   Suspended users are not allowed to do approvals as well.
314   /// @dev  Added modifier `transferable`.
315   function approve(address _spender, uint256 _value) public transferable returns (bool) {
316     require(!isSuspended(msg.sender));
317     return super.approve(_spender, _value);
318   }
319 
320   /// @notice Change founder. New founder must not be suspended.
321   function changeFounder(address payable who) onlyFounder public {
322     require(!isSuspended(who));
323     super.changeFounder(who);
324   }
325 
326   /// @notice Change admin. New admin must not be suspended.
327   function changeAdmin(address who) public {
328     require(!isSuspended(who));
329     super.changeAdmin(who);
330   }
331 }
332 
333 /// @title Advanced functions for Color Coin token smart contract.
334 /// @notice Implements functions for private ICO and super users.
335 /// @dev Not intended for reuse.
336 contract ColorCoinBase is _Suspendable {
337 
338   /// @dev Represents a lock-up period.
339   struct LockUp {
340     /// @dev end of the period, in seconds since the epoch.
341     uint256 unlockDate;
342     /// @dev amount of coins to be unlocked at the end of the period.
343     uint256 amount;
344   }
345 
346   /// @dev Represents a wallet with lock-up periods.
347   struct Investor {
348     /// @dev initial amount of locked COLs
349     uint256 initialAmount;
350     /// @dev current amount of locked COLs
351     uint256 lockedAmount;
352     /// @dev current lock-up period, index in the array `lockUpPeriods`
353     uint256 currentLockUpPeriod;
354     /// @dev the list of lock-up periods
355     LockUp[] lockUpPeriods;
356   }
357 
358   /// @dev Entry in the `adminTransferLog`, that stores the history of admin operations.
359   struct AdminTransfer {
360     /// @dev the wallet, where COLs were withdrawn from
361     address from;
362     /// @dev the wallet, where COLs were deposited to
363     address to;
364     /// @dev amount of coins transferred
365     uint256 amount;
366     /// @dev the reason, why super user made this transfer
367     string  reason;
368   }
369 
370   /// @notice The event that is fired when a lock-up period expires for a certain wallet.
371   /// @param  who the wallet where the lock-up period expired
372   /// @param  period  the number of the expired period
373   /// @param  amount  amount of unlocked coins.
374   event Unlock(address who, uint256 period, uint256 amount);
375 
376   /// @notice The event that is fired when a super user makes transfer.
377   /// @param  from the wallet, where COLs were withdrawn from
378   /// @param  to  the wallet, where COLs were deposited to
379   /// @param  requestedAmount  amount of coins, that the super user requested to transfer
380   /// @param  returnedAmount  amount of coins, that were actually transferred
381   /// @param  reason  the reason, why super user made this transfer
382   event SuperAction(address from, address to, uint256 requestedAmount, uint256 returnedAmount, string reason);
383 
384   /// @dev  set of wallets with lock-up periods
385   mapping (address => Investor) internal investors;
386 
387   /// @dev wallet with the supply of Color Coins.
388   ///   It is used to calculate circulating supply.
389   address internal supply;
390   /// @dev amount of Color Coins locked in lock-up wallets.
391   ///   It is used to calculate circulating supply.
392   uint256 internal totalLocked;
393 
394   /// @dev the list of transfers performed by super users
395   AdminTransfer[] internal adminTransferLog;
396 
397   /// @notice Sets total supply and the addresses of super users - founder and admin.
398   /// @param _totalSupply Total amount of Color Coin tokens available.
399   /// @param _founder Address of the founder wallet
400   /// @param _admin Address of the admin wallet
401   constructor(uint256 _totalSupply,
402     address payable _founder,
403     address _admin
404   ) public _Suspendable (_totalSupply, _founder, _admin)
405   {
406     supply = founder;
407   }
408 
409   //
410   // ERC20 spec.
411   //
412 
413   /// @notice Returns the balance of a wallet.
414   ///   For wallets with lock-up the result of this function inludes both free floating and locked COLs.
415   /// @param _owner The address of a wallet.
416   function balanceOf(address _owner) public view returns (uint256) {
417     return accounts[_owner] + investors[_owner].lockedAmount;
418   }
419 
420   /// @dev Performs transfer from one wallet to another.
421   ///   The maximum amount of COLs to transfer equals to `balanceOf(_from) - getLockedAmount(_from)`.
422   ///   This function unlocks COLs if any of lock-up periods expired at the moment
423   ///   of the transaction execution.
424   ///   Calls `Suspendable._transfer` to do the actual transfer.
425   ///   This function is used by ERC20 `transfer` function.
426   /// @param  _from   wallet from which tokens are withdrawn.
427   /// @param  _to   wallet to which tokens are deposited.
428   /// @param  _value  amount of COLs to transfer.
429   function _transfer(address _from, address _to, uint256 _value)
430   internal returns (bool) {
431     if (hasLockup(_from)) {
432       tryUnlock(_from);
433     }
434     super._transfer(_from, _to, _value);
435   }
436 
437   /// @notice The founder sends COLs to early investors and sets lock-up periods.
438   ///   Initially all distributed COL's are locked.
439   /// @dev  Only founder can call this function.
440   /// @param _to  address of the wallet that receives the COls.
441   /// @param _value amount of COLs that founder sends to the investor's wallet.
442   /// @param unlockDates array of lock-up period dates.
443   ///   Each date is in seconds since the epoch. After `unlockDates[i]` is expired,
444   ///   the corresponding `amounts[i]` amount of COLs gets unlocked.
445   ///   After expiring the last date in this array all COLs become unlocked.
446   /// @param amounts array of COL amounts to unlock.
447   function distribute(address _to, uint256 _value,
448       uint256[] memory unlockDates, uint256[] memory amounts
449     ) onlyFounder public returns (bool) {
450     // We distribute invested coins to new wallets only
451     require(balanceOf(_to) == 0);
452     require(_value <= accounts[founder]);
453     require(unlockDates.length == amounts.length);
454 
455     // We don't check that unlock dates strictly increase.
456     // That doesn't matter. It will work out in tryUnlock function.
457 
458     // We don't check that amounts in total equal to _value.
459     // tryUnlock unlocks no more that _value anyway.
460 
461     investors[_to].initialAmount = _value;
462     investors[_to].lockedAmount = _value;
463     investors[_to].currentLockUpPeriod = 0;
464 
465     for (uint256 i=0; i<unlockDates.length; i++) {
466       investors[_to].lockUpPeriods.push(LockUp(unlockDates[i], amounts[i]));
467     }
468 
469     // ensureLockUp(_to);
470     accounts[founder] -= _value;
471     emit Transfer(founder, _to, _value);
472     totalLocked = totalLocked.add(_value);
473     // Check the lock-up periods. If the leading periods are 0 or already expired
474     // unlock corresponding coins.
475     tryUnlock(_to);
476     return true;
477   }
478 
479   /// @notice Returns `true` if the wallet has locked COLs
480   /// @param _address address of the wallet.
481   /// @return `true` if the wallet has locked COLs and `false` otherwise.
482   function hasLockup(address _address) public view returns(bool) {
483     return (investors[_address].lockedAmount > 0);
484   }
485 
486   //
487   // Unlock operations
488   //
489 
490   /// @dev tells whether the wallet still has lockup and number of seconds until unlock date.
491   /// @return locked if `locked` is true, the wallet still has a lockup period, otherwise all lockups expired.
492   /// @return seconds amount of time in seconds until unlock date. Zero means that it has expired,
493   ///   and the user can invoke `doUnlock` to release corresponding coins.
494   function _nextUnlockDate(address who) internal view returns (bool, uint256) {
495     if (!hasLockup(who)) {
496       return (false, 0);
497     }
498 
499     uint256 i = investors[who].currentLockUpPeriod;
500     // This must not happen! but still...
501     // If all lockup periods have expired, but there are still locked coins,
502     // tell the user to unlock.
503     if (i == investors[who].lockUpPeriods.length) return (true, 0);
504 
505     if (now < investors[who].lockUpPeriods[i].unlockDate) {
506       // If the next unlock date is in the future, return the number of seconds left
507       return (true, investors[who].lockUpPeriods[i].unlockDate - now);
508     } else {
509       // The current unlock period has expired.
510       return (true, 0);
511     }
512   }
513 
514   /// @notice tells the wallet owner whether the wallet still has lockup and number of seconds until unlock date.
515   /// @return locked if `locked` is true, the wallet still has a lockup period, otherwise all lockups expired.
516   /// @return seconds amount of time in seconds until unlock date. Zero means that it has expired,
517   ///   and the user can invoke `doUnlock` to release corresponding coins.
518   function nextUnlockDate() public view returns (bool, uint256) {
519     return _nextUnlockDate(msg.sender);
520   }
521 
522   /// @notice tells to the admin whether the wallet still has lockup and number of seconds until unlock date.
523   /// @return locked if `locked` is true, the wallet still has a lockup period, otherwise all lockups expired.
524   /// @return seconds amount of time in seconds until unlock date. Zero means that it has expired,
525   ///   and the user can invoke `doUnlock` to release corresponding coins.
526   function nextUnlockDate_Admin(address who) public view onlyAdmin returns (bool, uint256) {
527     return _nextUnlockDate(who);
528   }
529 
530   /// @notice the wallet owner signals that the next unlock period has passed, and some coins could be unlocked
531   function doUnlock() public {
532     tryUnlock(msg.sender);
533   }
534 
535   /// @notice admin unlocks coins in the wallet, if any
536   /// @param who the wallet to unlock coins
537   function doUnlock_Admin(address who) public onlyAdmin {
538     tryUnlock(who);
539   }
540   /// @notice Returns the amount of locked coins in the wallet.
541   ///   This function tells the amount of coins to the wallet owner only.
542   /// @return amount of locked COLs by `now`.
543   function getLockedAmount() public view returns (uint256) {
544     return investors[msg.sender].lockedAmount;
545   }
546 
547   /// @notice Returns the amount of locked coins in the wallet.
548   /// @return amount of locked COLs by `now`.
549   function getLockedAmount_Admin(address who) public view onlyAdmin returns (uint256) {
550     return investors[who].lockedAmount;
551   }
552 
553   function tryUnlock(address _address) internal {
554     if (!hasLockup(_address)) {
555       return ;
556     }
557 
558     uint256 amount = 0;
559     uint256 i;
560     uint256 start = investors[_address].currentLockUpPeriod;
561     uint256 end = investors[_address].lockUpPeriods.length;
562 
563     for ( i = start;
564           i < end;
565           i++)
566     {
567       if (investors[_address].lockUpPeriods[i].unlockDate <= now) {
568         amount += investors[_address].lockUpPeriods[i].amount;
569       } else {
570         break;
571       }
572     }
573 
574     if (i == investors[_address].lockUpPeriods.length) {
575       // all unlock periods expired. Unlock all
576       amount = investors[_address].lockedAmount;
577     } else if (amount > investors[_address].lockedAmount) {
578       amount = investors[_address].lockedAmount;
579     }
580 
581     if (amount > 0 || i > start) {
582       investors[_address].lockedAmount = investors[_address].lockedAmount.sub(amount);
583       investors[_address].currentLockUpPeriod = i;
584       accounts[_address] = accounts[_address].add(amount);
585       emit Unlock(_address, i, amount);
586       totalLocked = totalLocked.sub(amount);
587     }
588   }
589 
590   //
591   // Admin privileges - return coins in the case of errors or theft
592   //
593 
594   modifier superuser {
595     require(msg.sender == admin || msg.sender == founder);
596     _;
597   }
598 
599   /// @notice Super user (founder or admin) unconditionally transfers COLs from one account to another.
600   ///   This function is designed as the last resort in the case of mistake or theft.
601   ///   Superuser provides verbal description of the reason to perform this operation.
602   ///  @dev   Only superuser can call this function.
603   /// @param from   the wallet, where COLs were withdrawn from
604   /// @param to   the wallet, where COLs were deposited to
605   /// @param amount  amount of coins transferred
606   /// @param reason   description of the reason, why super user invokes this transfer
607   function adminTransfer(address from, address to, uint256 amount, string memory reason) public superuser {
608     if (amount == 0) return;
609 
610     uint256 requested = amount;
611     // Revert as much as possible
612     if (accounts[from] < amount) {
613       amount = accounts[from];
614     }
615 
616     accounts[from] -= amount;
617     accounts[to] = accounts[to].add(amount);
618     emit SuperAction(from, to, requested, amount, reason);
619     adminTransferLog.push(AdminTransfer(from, to, amount, reason));
620   }
621 
622   /// @notice Returns size of the history of super user actions
623   /// @return the number of elements in the log
624   function getAdminTransferLogSize() public view superuser returns (uint256) {
625     return adminTransferLog.length;
626   }
627 
628   /// @notice Returns an element from the history of super user actions
629   /// @param  pos   index of element in the log, the oldest element has index `0`
630   /// @return tuple `(from, to, amount, reason)`. See description of `adminTransfer` function.
631   function getAdminTransferLogItem(uint32 pos) public view superuser
632     returns (address from, address to, uint256 amount, string memory reason)
633   {
634     require(pos < adminTransferLog.length);
635     AdminTransfer storage item = adminTransferLog[pos];
636     return (item.from, item.to, item.amount, item.reason);
637   }
638 
639   //
640   // Circulating supply
641   //
642 
643   /// @notice Returns the circulating supply of Color Coins.
644   ///   It consists of all unlocked coins in user wallets.
645   function circulatingSupply() public view returns(uint256) {
646     return __totalSupply.sub(accounts[supply]).sub(totalLocked);
647   }
648 
649   //
650   // Release contract
651   //
652 
653   /// @notice Calls `selfdestruct` operator and transfers all Ethers to the founder (if any)
654   function destroy() public onlyAdmin {
655     selfdestruct(founder);
656   }
657 }
658 
659 /// @title Dedicated methods for Pixel program
660 /// @notice Pixels are a type of “airdrop” distributed to all Color Coin wallet holders,
661 ///   five Pixels a day. They are awarded on a periodic basis. Starting from Sunday GMT 0:00,
662 ///   the Pixels have a lifespan of 24 hours. Pixels in their original form do not have any value.
663 ///   The only way Pixels have value is by sending them to other wallet holders.
664 ///   Pixels must be sent to another person’s account within 24 hours or they will become void.
665 ///   Each user can send up to five Pixels to a single account per week. Once a wallet holder receives Pixels,
666 ///   the Pixels will become Color Coins. The received Pixels may be converted to Color Coins
667 ///   on weekly basis, after Saturday GMT 24:00.
668 /// @dev Pixel distribution might require thousands and tens of thousands transactions.
669 ///   The methods in this contract consume less gas compared to batch transactions.
670 contract ColorCoinWithPixel is ColorCoinBase {
671 
672   address internal pixelAccount;
673 
674   /// @dev The rate to convert pixels to Color Coins
675   uint256 internal pixelConvRate;
676 
677   /// @dev Methods could be called by either the founder of the dedicated account.
678   modifier pixelOrFounder {
679     require(msg.sender == founder || msg.sender == pixelAccount);
680     _;
681   }
682 
683   function circulatingSupply() public view returns(uint256) {
684     uint256 result = super.circulatingSupply();
685     return result - balanceOf(pixelAccount);
686   }
687 
688   /// @notice Initialises a newly created instance.
689   /// @dev Initialises Pixel-related data and transfers `_pixelCoinSupply` COLs
690   ///   from the `_founder` to `_pixelAccount`.
691   /// @param _totalSupply Total amount of Color Coin tokens available.
692   /// @param _founder Address of the founder wallet
693   /// @param _admin Address of the admin wallet
694   /// @param _pixelCoinSupply Amount of tokens dedicated for Pixel program
695   /// @param _pixelAccount Address of the account that keeps coins for the Pixel program
696   constructor(uint256 _totalSupply,
697     address payable _founder,
698     address _admin,
699     uint256 _pixelCoinSupply,
700     address _pixelAccount
701   ) public ColorCoinBase (_totalSupply, _founder, _admin)
702   {
703     require(_pixelAccount != _founder);
704     require(_pixelAccount != _admin);
705 
706     pixelAccount = _pixelAccount;
707     accounts[pixelAccount] = _pixelCoinSupply;
708     accounts[_founder] = accounts[_founder].sub(_pixelCoinSupply);
709     emit Transfer(founder, pixelAccount, accounts[pixelAccount]);
710   }
711 
712   /// @notice Founder or the pixel account set the pixel conversion rate.
713   ///   Pixel team first sets this conversion rate and then start sending COLs
714   ///   in exchange of pixels that people have received.
715   /// @dev This rate is used in `sendCoinsForPixels` functions to calculate the amount
716   ///   COLs to transfer to pixel holders.
717   function setPixelConversionRate(uint256 _pixelConvRate) public pixelOrFounder {
718     pixelConvRate = _pixelConvRate;
719   }
720 
721   /// @notice Get the conversion rate that was used in the most recent exchange of pixels to COLs.
722   function getPixelConversionRate() public view returns (uint256) {
723     return pixelConvRate;
724   }
725 
726   /// @notice Distribute COL coins for pixels
727   ///   COLs are spent from `pixelAccount` wallet. The amount of COLs is equal to `getPixelConversionRate() * pixels`
728   /// @dev Only founder and pixel account can invoke this function.
729   /// @param pixels       Amount of pixels to exchange into COLs
730   /// @param destination  The wallet that holds the pixels.
731   function sendCoinsForPixels(
732     uint32 pixels, address destination
733   ) public pixelOrFounder {
734     uint256 coins = pixels*pixelConvRate;
735     if (coins == 0) return;
736 
737     require(coins <= accounts[pixelAccount]);
738 
739     accounts[destination] = accounts[destination].add(coins);
740     accounts[pixelAccount] -= coins;
741   }
742 
743   /// @notice Distribute COL coins for pixels to multiple users.
744   ///   This function consumes less gas compared to a batch transaction of `sendCoinsForPixels`.
745   ///   `pixels[i]` specifies the amount of pixels belonging to `destinations[i]` wallet.
746   ///   COLs are spent from `pixelAccount` wallet. The amount of COLs sent to i-th wallet is equal to `getPixelConversionRate() * pixels[i]`
747   /// @dev Only founder and pixel account can invoke this function.
748   /// @param pixels         Array of pixel amounts to exchange into COLs
749   /// @param destinations   Array of addresses of wallets that hold pixels.
750   function sendCoinsForPixels_Batch(
751     uint32[] memory pixels,
752     address[] memory destinations
753   ) public pixelOrFounder {
754     require(pixels.length == destinations.length);
755     uint256 total = 0;
756     for (uint256 i = 0; i < pixels.length; i++) {
757       uint256 coins = pixels[i]*pixelConvRate;
758       address dst = destinations[i];
759       accounts[dst] = accounts[dst].add(coins);
760       total += coins;
761     }
762 
763     require(total <= accounts[pixelAccount]);
764     accounts[pixelAccount] -= total;
765   }
766 
767   /// @notice Distribute COL coins for pixels to multiple users.
768   ///   COLs are spent from `pixelAccount` wallet. The amount of COLs sent to each wallet is equal to `getPixelConversionRate() * pixels`
769   /// @dev The difference between `sendCoinsForPixels_Array` and `sendCoinsForPixels_Batch`
770   ///   is that all destination wallets hold the same amount of pixels.
771   ///   This optimization saves about 10% of gas compared to `sendCoinsForPixels_Batch`
772   ///   with the same amount of recipients.
773   /// @param pixels   Amount of pixels to exchange. All of `recipients` hold the same amount of pixels.
774   /// @param recipients Addresses of wallets, holding `pixels` amount of pixels.
775   function sendCoinsForPixels_Array(
776     uint32 pixels, address[] memory recipients
777   ) public pixelOrFounder {
778     uint256 coins = pixels*pixelConvRate;
779     uint256 total = coins * recipients.length;
780 
781     if (total == 0) return;
782     require(total <= accounts[pixelAccount]);
783 
784     for (uint256 i; i < recipients.length; i++) {
785       address dst = recipients[i];
786       accounts[dst] = accounts[dst].add(coins);
787     }
788 
789     accounts[pixelAccount] -= total;
790   }
791 }
792 
793 
794 /// @title Smart contract for Color Coin token.
795 /// @notice Color is the next generation platform for high-performance sophisticated decentralized applications (dApps). https://www.colors.org/
796 /// @dev Not intended for reuse.
797 contract ColorCoin is ColorCoinWithPixel {
798   /// @notice Token name
799   string public constant name = "Color Coin";
800 
801   /// @notice Token symbol
802   string public constant symbol = "COL";
803 
804   /// @notice Precision in fixed point arithmetics
805   uint8 public constant decimals = 18;
806 
807   /// @notice Initialises a newly created instance
808   /// @param _totalSupply Total amount of Color Coin tokens available.
809   /// @param _founder Address of the founder wallet
810   /// @param _admin Address of the admin wallet
811   /// @param _pixelCoinSupply Amount of tokens dedicated for Pixel program
812   /// @param _pixelAccount Address of the account that keeps coins for the Pixel program
813   constructor(uint256 _totalSupply,
814     address payable _founder,
815     address _admin,
816     uint256 _pixelCoinSupply,
817     address _pixelAccount
818   ) public ColorCoinWithPixel (_totalSupply, _founder, _admin, _pixelCoinSupply, _pixelAccount)
819   {
820   }
821 }