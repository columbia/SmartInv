1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 contract ERC20 {
68 
69     // Get the total token supply
70     function totalSupply() public view returns (uint256);
71 
72     // Get the account balance of another account with address _owner
73     function balanceOf(address who) public view returns (uint256);
74 
75     // Send _value amount of tokens to address _to
76     function transfer(address to, uint256 value) public returns (bool);
77 
78     // Send _value amount of tokens from address _from to address _to
79     function transferFrom(address from, address to, uint256 value) public returns (bool);
80 
81     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
82     // If this function is called again it overwrites the current allowance with _value.
83     // this function is required for some DEX functionality
84     function approve(address spender, uint256 value) public returns (bool);
85 
86     // Returns the amount which _spender is still allowed to withdraw from _owner
87     function allowance(address owner, address spender) public view returns (uint256);
88 
89     // Triggered when tokens are transferred.
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     // Triggered whenever approve(address _spender, uint256 _value) is called.
93     event Approval(address indexed owner,address indexed spender,uint256 value);
94 }
95 
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
214 
215 /// @title Admin can suspend specific wallets in cases of misbehaving or theft.
216 /// @notice This contract implements methods to lock tranfers, either globally or for specific accounts.
217 contract _Suspendable is _Base20 {
218   /// @dev flag whether transfers are allowed on global scale.
219   ///    When `isTransferable` is `false`, all transfers between wallets are blocked.
220   bool internal isTransferable = false;
221   /// @dev set of suspended wallets.
222   ///   When `suspendedAddresses[wallet]` is `true`, the `wallet` can't both send and receive COLs.
223   mapping(address => bool) internal suspendedAddresses;
224 
225   /// @notice Sets total supply and the addresses of super users - founder and admin.
226   /// @param _totalSupply Total amount of Color Coin tokens available.
227   /// @param _founder Address of the founder wallet
228   /// @param _admin Address of the admin wallet
229   constructor(uint256 _totalSupply,
230     address payable _founder,
231     address _admin) public _Base20(_totalSupply, _founder, _admin)
232   {
233   }
234 
235   /// @dev specifies that the marked method could be used only when transfers are enabled.
236   ///   Founder can always transfer
237   modifier transferable {
238     require(isTransferable || msg.sender == founder);
239     _;
240   }
241 
242   /// @notice Getter for the global flag `isTransferable`.
243   /// @dev Everyone is allowed to view it.
244   function isTransferEnabled() public view returns (bool) {
245     return isTransferable;
246   }
247 
248   /// @notice Enable tranfers globally.
249   ///   Note that suspended acccounts remain to be suspended.
250   /// @dev Sets the global flag `isTransferable` to `true`.
251   function enableTransfer() onlyAdmin public {
252     isTransferable = true;
253   }
254 
255   /// @notice Disable tranfers globally.
256   ///   All transfers between wallets are blocked.
257   /// @dev Sets the global flag `isTransferable` to `false`.
258   function disableTransfer() onlyAdmin public {
259     isTransferable = false;
260   }
261 
262   /// @notice Check whether an address is suspended.
263   /// @dev Everyone can check any address they want.
264   /// @param _address wallet to check
265   /// @return returns `true` if the wallet `who` is suspended.
266   function isSuspended(address _address) public view returns(bool) {
267     return suspendedAddresses[_address];
268   }
269 
270   /// @notice Suspend an individual wallet.
271   /// @dev Neither the founder nor the admin could be suspended.
272   /// @param who  address of the wallet to suspend.
273   function suspend(address who) onlyAdmin public {
274     if (who == founder || who == admin) {
275       return;
276     }
277     suspendedAddresses[who] = true;
278   }
279 
280   /// @notice Unsuspend an individual wallet
281   /// @param who  address of the wallet to unsuspend.
282   function unsuspend(address who) onlyAdmin public {
283     suspendedAddresses[who] = false;
284   }
285 
286   //
287   // Update of ERC20 functions
288   //
289 
290   /// @dev Internal function for transfers updated.
291   ///   Neither source nor destination of the transfer can be suspended.
292   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
293     require(!isSuspended(_to));
294     require(!isSuspended(_from));
295 
296     return super._transfer(_from, _to, _value);
297   }
298 
299   /// @notice `transfer` can't happen when transfers are disabled globally
300   /// @dev added modifier `transferable`.
301   function transfer(address _to, uint256 _value) public transferable returns (bool) {
302     return _transfer(msg.sender, _to, _value);
303   }
304 
305   /// @notice `transferFrom` can't happen when transfers are disabled globally
306   /// @dev added modifier `transferable`.
307   function transferFrom(address _from, address _to, uint256 _value) public transferable returns (bool) {
308     require(!isSuspended(msg.sender));
309     return super.transferFrom(_from, _to, _value);
310   }
311 
312   // ERC20 spec.
313   /// @notice `approve` can't happen when transfers disabled globally
314   ///   Suspended users are not allowed to do approvals as well.
315   /// @dev  Added modifier `transferable`.
316   function approve(address _spender, uint256 _value) public transferable returns (bool) {
317     require(!isSuspended(msg.sender));
318     return super.approve(_spender, _value);
319   }
320 
321   /// @notice Change founder. New founder must not be suspended.
322   function changeFounder(address payable who) onlyFounder public {
323     require(!isSuspended(who));
324     super.changeFounder(who);
325   }
326 
327   /// @notice Change admin. New admin must not be suspended.
328   function changeAdmin(address who) public {
329     require(!isSuspended(who));
330     super.changeAdmin(who);
331   }
332 }
333 
334 
335 /// @title Advanced functions for Color Coin token smart contract.
336 /// @notice Implements functions for private ICO and super users.
337 /// @dev Not intended for reuse.
338 contract ColorCoinBase is _Suspendable {
339 
340   /// @dev Represents a lock-up period.
341   struct LockUp {
342     /// @dev end of the period, in seconds since the epoch.
343     uint256 unlockDate;
344     /// @dev amount of coins to be unlocked at the end of the period.
345     uint256 amount;
346   }
347 
348   /// @dev Represents a wallet with lock-up periods.
349   struct Investor {
350     /// @dev initial amount of locked COLs
351     uint256 initialAmount;
352     /// @dev current amount of locked COLs
353     uint256 lockedAmount;
354     /// @dev current lock-up period, index in the array `lockUpPeriods`
355     uint256 currentLockUpPeriod;
356     /// @dev the list of lock-up periods
357     LockUp[] lockUpPeriods;
358   }
359 
360   /// @dev Entry in the `adminTransferLog`, that stores the history of admin operations.
361   struct AdminTransfer {
362     /// @dev the wallet, where COLs were withdrawn from
363     address from;
364     /// @dev the wallet, where COLs were deposited to
365     address to;
366     /// @dev amount of coins transferred
367     uint256 amount;
368     /// @dev the reason, why super user made this transfer
369     string  reason;
370   }
371 
372   /// @notice The event that is fired when a lock-up period expires for a certain wallet.
373   /// @param  who the wallet where the lock-up period expired
374   /// @param  period  the number of the expired period
375   /// @param  amount  amount of unlocked coins.
376   event Unlock(address who, uint256 period, uint256 amount);
377 
378   /// @notice The event that is fired when a super user makes transfer.
379   /// @param  from the wallet, where COLs were withdrawn from
380   /// @param  to  the wallet, where COLs were deposited to
381   /// @param  requestedAmount  amount of coins, that the super user requested to transfer
382   /// @param  returnedAmount  amount of coins, that were actually transferred
383   /// @param  reason  the reason, why super user made this transfer
384   event SuperAction(address from, address to, uint256 requestedAmount, uint256 returnedAmount, string reason);
385 
386   /// @dev  set of wallets with lock-up periods
387   mapping (address => Investor) internal investors;
388 
389   /// @dev amount of Color Coins locked in lock-up wallets.
390   ///   It is used to calculate circulating supply.
391   uint256 internal totalLocked;
392 
393   /// @dev the list of transfers performed by super users
394   AdminTransfer[] internal adminTransferLog;
395 
396   /// @notice Sets total supply and the addresses of super users - founder and admin.
397   /// @param _totalSupply Total amount of Color Coin tokens available.
398   /// @param _founder Address of the founder wallet
399   /// @param _admin Address of the admin wallet
400   constructor(uint256 _totalSupply,
401     address payable _founder,
402     address _admin
403   ) public _Suspendable (_totalSupply, _founder, _admin)
404   {
405   }
406 
407   //
408   // ERC20 spec.
409   //
410 
411   /// @notice Returns the balance of a wallet.
412   ///   For wallets with lock-up the result of this function inludes both free floating and locked COLs.
413   /// @param _owner The address of a wallet.
414   function balanceOf(address _owner) public view returns (uint256) {
415     return accounts[_owner] + investors[_owner].lockedAmount;
416   }
417 
418   /// @dev Performs transfer from one wallet to another.
419   ///   The maximum amount of COLs to transfer equals to `balanceOf(_from) - getLockedAmount(_from)`.
420   ///   This function unlocks COLs if any of lock-up periods expired at the moment
421   ///   of the transaction execution.
422   ///   Calls `Suspendable._transfer` to do the actual transfer.
423   ///   This function is used by ERC20 `transfer` function.
424   /// @param  _from   wallet from which tokens are withdrawn.
425   /// @param  _to   wallet to which tokens are deposited.
426   /// @param  _value  amount of COLs to transfer.
427   function _transfer(address _from, address _to, uint256 _value)
428   internal returns (bool) {
429     if (hasLockup(_from)) {
430       tryUnlock(_from);
431     }
432     super._transfer(_from, _to, _value);
433   }
434 
435   /// @notice The founder sends COLs to early investors and sets lock-up periods.
436   ///   Initially all distributed COL's are locked.
437   /// @dev  Only founder can call this function.
438   /// @param _to  address of the wallet that receives the COls.
439   /// @param _value amount of COLs that founder sends to the investor's wallet.
440   /// @param unlockDates array of lock-up period dates.
441   ///   Each date is in seconds since the epoch. After `unlockDates[i]` is expired,
442   ///   the corresponding `amounts[i]` amount of COLs gets unlocked.
443   ///   After expiring the last date in this array all COLs become unlocked.
444   /// @param amounts array of COL amounts to unlock.
445   function distribute(address _to, uint256 _value,
446       uint256[] memory unlockDates, uint256[] memory amounts
447     ) onlyFounder public returns (bool) {
448     // We distribute invested coins to new wallets only
449     require(balanceOf(_to) == 0);
450     require(_value <= accounts[founder]);
451     require(unlockDates.length == amounts.length);
452 
453     // We don't check that unlock dates strictly increase.
454     // That doesn't matter. It will work out in tryUnlock function.
455 
456     // We don't check that amounts in total equal to _value.
457     // tryUnlock unlocks no more that _value anyway.
458 
459     investors[_to].initialAmount = _value;
460     investors[_to].lockedAmount = _value;
461     investors[_to].currentLockUpPeriod = 0;
462 
463     for (uint256 i=0; i<unlockDates.length; i++) {
464       investors[_to].lockUpPeriods.push(LockUp(unlockDates[i], amounts[i]));
465     }
466 
467     // ensureLockUp(_to);
468     accounts[founder] -= _value;
469     emit Transfer(founder, _to, _value);
470     totalLocked = totalLocked.add(_value);
471     // Check the lock-up periods. If the leading periods are 0 or already expired
472     // unlock corresponding coins.
473     tryUnlock(_to);
474     return true;
475   }
476 
477   /// @notice Returns `true` if the wallet has locked COLs
478   /// @param _address address of the wallet.
479   /// @return `true` if the wallet has locked COLs and `false` otherwise.
480   function hasLockup(address _address) public view returns(bool) {
481     return (investors[_address].lockedAmount > 0);
482   }
483 
484   //
485   // Unlock operations
486   //
487 
488   /// @dev tells whether the wallet still has lockup and number of seconds until unlock date.
489   /// @return locked if `locked` is true, the wallet still has a lockup period, otherwise all lockups expired.
490   /// @return seconds amount of time in seconds until unlock date. Zero means that it has expired,
491   ///   and the user can invoke `doUnlock` to release corresponding coins.
492   function _nextUnlockDate(address who) internal view returns (bool, uint256) {
493     if (!hasLockup(who)) {
494       return (false, 0);
495     }
496 
497     uint256 i = investors[who].currentLockUpPeriod;
498     // This must not happen! but still...
499     // If all lockup periods have expired, but there are still locked coins,
500     // tell the user to unlock.
501     if (i == investors[who].lockUpPeriods.length) return (true, 0);
502 
503     if (now < investors[who].lockUpPeriods[i].unlockDate) {
504       // If the next unlock date is in the future, return the number of seconds left
505       return (true, investors[who].lockUpPeriods[i].unlockDate - now);
506     } else {
507       // The current unlock period has expired.
508       return (true, 0);
509     }
510   }
511 
512   /// @notice tells the wallet owner whether the wallet still has lockup and number of seconds until unlock date.
513   /// @return locked if `locked` is true, the wallet still has a lockup period, otherwise all lockups expired.
514   /// @return seconds amount of time in seconds until unlock date. Zero means that it has expired,
515   ///   and the user can invoke `doUnlock` to release corresponding coins.
516   function nextUnlockDate() public view returns (bool, uint256) {
517     return _nextUnlockDate(msg.sender);
518   }
519 
520   /// @notice tells to the admin whether the wallet still has lockup and number of seconds until unlock date.
521   /// @return locked if `locked` is true, the wallet still has a lockup period, otherwise all lockups expired.
522   /// @return seconds amount of time in seconds until unlock date. Zero means that it has expired,
523   ///   and the user can invoke `doUnlock` to release corresponding coins.
524   function nextUnlockDate_Admin(address who) public view onlyAdmin returns (bool, uint256) {
525     return _nextUnlockDate(who);
526   }
527 
528   /// @notice the wallet owner signals that the next unlock period has passed, and some coins could be unlocked
529   function doUnlock() public {
530     tryUnlock(msg.sender);
531   }
532 
533   /// @notice admin unlocks coins in the wallet, if any
534   /// @param who the wallet to unlock coins
535   function doUnlock_Admin(address who) public onlyAdmin {
536     tryUnlock(who);
537   }
538   /// @notice Returns the amount of locked coins in the wallet.
539   ///   This function tells the amount of coins to the wallet owner only.
540   /// @return amount of locked COLs by `now`.
541   function getLockedAmount() public view returns (uint256) {
542     return investors[msg.sender].lockedAmount;
543   }
544 
545   /// @notice Returns the amount of locked coins in the wallet.
546   /// @return amount of locked COLs by `now`.
547   function getLockedAmount_Admin(address who) public view onlyAdmin returns (uint256) {
548     return investors[who].lockedAmount;
549   }
550 
551   function tryUnlock(address _address) internal {
552     if (!hasLockup(_address)) {
553       return ;
554     }
555 
556     uint256 amount = 0;
557     uint256 i;
558     uint256 start = investors[_address].currentLockUpPeriod;
559     uint256 end = investors[_address].lockUpPeriods.length;
560 
561     for ( i = start;
562           i < end;
563           i++)
564     {
565       if (investors[_address].lockUpPeriods[i].unlockDate <= now) {
566         amount += investors[_address].lockUpPeriods[i].amount;
567       } else {
568         break;
569       }
570     }
571 
572     if (i == investors[_address].lockUpPeriods.length) {
573       // all unlock periods expired. Unlock all
574       amount = investors[_address].lockedAmount;
575     } else if (amount > investors[_address].lockedAmount) {
576       amount = investors[_address].lockedAmount;
577     }
578 
579     if (amount > 0 || i > start) {
580       investors[_address].lockedAmount = investors[_address].lockedAmount.sub(amount);
581       investors[_address].currentLockUpPeriod = i;
582       accounts[_address] = accounts[_address].add(amount);
583       emit Unlock(_address, i, amount);
584       totalLocked = totalLocked.sub(amount);
585     }
586   }
587 
588   //
589   // Circulating supply
590   //
591 
592   /// @notice Returns the circulating supply of Color Coins.
593   ///   It consists of all unlocked coins in user wallets.
594   function circulatingSupply() public view returns(uint256) {
595     return __totalSupply.sub(accounts[founder]).sub(totalLocked);
596   }
597 
598   //
599   // Release contract
600   //
601 
602   /// @notice Calls `selfdestruct` operator and transfers all Ethers to the founder (if any)
603   function destroy() public onlyAdmin {
604     selfdestruct(founder);
605   }
606 }
607 
608 
609 /// @title Dedicated methods for Pixel program
610 /// @notice Pixels are a type of “airdrop” distributed to all Color Coin wallet holders,
611 ///   five Pixels a day. They are awarded on a periodic basis. Starting from Sunday GMT 0:00,
612 ///   the Pixels have a lifespan of 24 hours. Pixels in their original form do not have any value.
613 ///   The only way Pixels have value is by sending them to other wallet holders.
614 ///   Pixels must be sent to another person’s account within 24 hours or they will become void.
615 ///   Each user can send up to five Pixels to a single account per week. Once a wallet holder receives Pixels,
616 ///   the Pixels will become Color Coins. The received Pixels may be converted to Color Coins
617 ///   on weekly basis, after Saturday GMT 24:00.
618 /// @dev Pixel distribution might require thousands and tens of thousands transactions.
619 ///   The methods in this contract consume less gas compared to batch transactions.
620 contract ColorCoinWithPixel is ColorCoinBase {
621 
622   address internal pixelAccount;
623 
624   /// @dev The rate to convert pixels to Color Coins
625   uint256 internal pixelConvRate;
626 
627   /// @dev Methods could be called by either the founder of the dedicated account.
628   modifier pixelOrFounder {
629     require(msg.sender == founder || msg.sender == pixelAccount);
630     _;
631   }
632 
633   function circulatingSupply() public view returns(uint256) {
634     uint256 result = super.circulatingSupply();
635     return result - balanceOf(pixelAccount);
636   }
637 
638   /// @notice Initialises a newly created instance.
639   /// @dev Initialises Pixel-related data and transfers `_pixelCoinSupply` COLs
640   ///   from the `_founder` to `_pixelAccount`.
641   /// @param _totalSupply Total amount of Color Coin tokens available.
642   /// @param _founder Address of the founder wallet
643   /// @param _admin Address of the admin wallet
644   /// @param _pixelCoinSupply Amount of tokens dedicated for Pixel program
645   /// @param _pixelAccount Address of the account that keeps coins for the Pixel program
646   constructor(uint256 _totalSupply,
647     address payable _founder,
648     address _admin,
649     uint256 _pixelCoinSupply,
650     address _pixelAccount
651   ) public ColorCoinBase (_totalSupply, _founder, _admin)
652   {
653     require(_pixelAccount != _founder);
654     require(_pixelAccount != _admin);
655 
656     pixelAccount = _pixelAccount;
657     accounts[pixelAccount] = _pixelCoinSupply;
658     accounts[_founder] = accounts[_founder].sub(_pixelCoinSupply);
659     emit Transfer(founder, pixelAccount, accounts[pixelAccount]);
660   }
661 
662   /// @notice Founder or the pixel account set the pixel conversion rate.
663   ///   Pixel team first sets this conversion rate and then start sending COLs
664   ///   in exchange of pixels that people have received.
665   /// @dev This rate is used in `sendCoinsForPixels` functions to calculate the amount
666   ///   COLs to transfer to pixel holders.
667   function setPixelConversionRate(uint256 _pixelConvRate) public pixelOrFounder {
668     pixelConvRate = _pixelConvRate;
669   }
670 
671   /// @notice Get the conversion rate that was used in the most recent exchange of pixels to COLs.
672   function getPixelConversionRate() public view returns (uint256) {
673     return pixelConvRate;
674   }
675 
676   /// @notice Distribute COL coins for pixels
677   ///   COLs are spent from `pixelAccount` wallet. The amount of COLs is equal to `getPixelConversionRate() * pixels`
678   /// @dev Only founder and pixel account can invoke this function.
679   /// @param pixels       Amount of pixels to exchange into COLs
680   /// @param destination  The wallet that holds the pixels.
681   function sendCoinsForPixels(
682     uint32 pixels, address destination
683   ) public pixelOrFounder {
684     uint256 coins = pixels*pixelConvRate;
685     if (coins == 0) return;
686 
687     require(coins <= accounts[pixelAccount]);
688 
689     accounts[destination] = accounts[destination].add(coins);
690     accounts[pixelAccount] -= coins;
691     emit Transfer(pixelAccount, destination, coins);
692   }
693 
694   /// @notice Distribute COL coins for pixels to multiple users.
695   ///   This function consumes less gas compared to a batch transaction of `sendCoinsForPixels`.
696   ///   `pixels[i]` specifies the amount of pixels belonging to `destinations[i]` wallet.
697   ///   COLs are spent from `pixelAccount` wallet. The amount of COLs sent to i-th wallet is equal to `getPixelConversionRate() * pixels[i]`
698   /// @dev Only founder and pixel account can invoke this function.
699   /// @param pixels         Array of pixel amounts to exchange into COLs
700   /// @param destinations   Array of addresses of wallets that hold pixels.
701   function sendCoinsForPixels_Batch(
702     uint32[] memory pixels,
703     address[] memory destinations
704   ) public pixelOrFounder {
705     require(pixels.length == destinations.length);
706     uint256 total = 0;
707     for (uint256 i = 0; i < pixels.length; i++) {
708       uint256 coins = pixels[i]*pixelConvRate;
709       address dst = destinations[i];
710       accounts[dst] = accounts[dst].add(coins);
711       emit Transfer(pixelAccount, dst, coins);
712       total += coins;
713     }
714 
715     require(total <= accounts[pixelAccount]);
716     accounts[pixelAccount] -= total;
717   }
718 
719   /// @notice Distribute COL coins for pixels to multiple users.
720   ///   COLs are spent from `pixelAccount` wallet. The amount of COLs sent to each wallet is equal to `getPixelConversionRate() * pixels`
721   /// @dev The difference between `sendCoinsForPixels_Array` and `sendCoinsForPixels_Batch`
722   ///   is that all destination wallets hold the same amount of pixels.
723   ///   This optimization saves about 10% of gas compared to `sendCoinsForPixels_Batch`
724   ///   with the same amount of recipients.
725   /// @param pixels   Amount of pixels to exchange. All of `recipients` hold the same amount of pixels.
726   /// @param recipients Addresses of wallets, holding `pixels` amount of pixels.
727   function sendCoinsForPixels_Array(
728     uint32 pixels, address[] memory recipients
729   ) public pixelOrFounder {
730     uint256 coins = pixels*pixelConvRate;
731     uint256 total = coins * recipients.length;
732 
733     if (total == 0) return;
734     require(total <= accounts[pixelAccount]);
735 
736     for (uint256 i; i < recipients.length; i++) {
737       address dst = recipients[i];
738       accounts[dst] = accounts[dst].add(coins);
739       emit Transfer(pixelAccount, dst, coins);
740     }
741 
742     accounts[pixelAccount] -= total;
743   }
744 }
745 
746 
747 /// @title Smart contract for Color Coin token.
748 /// @notice Color is the next generation platform for high-performance sophisticated decentralized applications (dApps). https://www.colors.org/
749 /// @dev Not intended for reuse.
750 contract ColorCoin is ColorCoinWithPixel {
751   /// @notice Token name
752   string public constant name = "Color Coin";
753 
754   /// @notice Token symbol
755   string public constant symbol = "CLR";
756 
757   /// @notice Precision in fixed point arithmetics
758   uint8 public constant decimals = 18;
759 
760   /// @notice Initialises a newly created instance
761   /// @param _totalSupply Total amount of Color Coin tokens available.
762   /// @param _founder Address of the founder wallet
763   /// @param _admin Address of the admin wallet
764   /// @param _pixelCoinSupply Amount of tokens dedicated for Pixel program
765   /// @param _pixelAccount Address of the account that keeps coins for the Pixel program
766   constructor(uint256 _totalSupply,
767     address payable _founder,
768     address _admin,
769     uint256 _pixelCoinSupply,
770     address _pixelAccount
771   ) public ColorCoinWithPixel (_totalSupply, _founder, _admin, _pixelCoinSupply, _pixelAccount)
772   {
773   }
774 }