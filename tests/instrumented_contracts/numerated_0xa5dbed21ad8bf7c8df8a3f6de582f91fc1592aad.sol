1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Withdrawable is Ownable {
107     event ReceiveEther(address _from, uint256 _value);
108     event WithdrawEther(address _to, uint256 _value);
109     event WithdrawToken(address _token, address _to, uint256 _value);
110 
111     /**
112          * @dev recording receiving ether from msn.sender
113          */
114     function () payable public {
115         emit ReceiveEther(msg.sender, msg.value);
116     }
117 
118     /**
119          * @dev withdraw,send ether to target
120          * @param _to is where the ether will be sent to
121          *        _amount is the number of the ether
122          */
123     function withdraw(address _to, uint _amount) public onlyOwner returns (bool) {
124         require(_to != address(0));
125         _to.transfer(_amount);
126         emit WithdrawEther(_to, _amount);
127 
128         return true;
129     }
130 
131     /**
132          * @dev withdraw tokens, send tokens to target
133      *
134      * @param _token the token address that will be withdraw
135          * @param _to is where the tokens will be sent to
136          *        _value is the number of the token
137          */
138     function withdrawToken(address _token, address _to, uint256 _value) public onlyOwner returns (bool) {
139         require(_to != address(0));
140         require(_token != address(0));
141 
142         ERC20 tk = ERC20(_token);
143         tk.transfer(_to, _value);
144         emit WithdrawToken(_token, _to, _value);
145 
146         return true;
147     }
148 
149     /**
150      * @dev receive approval from an ERC20 token contract, and then gain the tokens,
151      *      then take a record
152      *
153      * @param _from address The address which you want to send tokens from
154      * @param _value uint256 the amounts of tokens to be sent
155      * @param _token address the ERC20 token address
156      * @param _extraData bytes the extra data for the record
157      */
158     // function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
159     //     require(_token != address(0));
160     //     require(_from != address(0));
161 
162     //     ERC20 tk = ERC20(_token);
163     //     require(tk.transferFrom(_from, this, _value));
164 
165     //     emit ReceiveDeposit(_from, _value, _token, _extraData);
166     // }
167 }
168 
169 contract Claimable is Ownable {
170   address public pendingOwner;
171 
172   /**
173    * @dev Modifier throws if called by any account other than the pendingOwner.
174    */
175   modifier onlyPendingOwner() {
176     require(msg.sender == pendingOwner);
177     _;
178   }
179 
180   /**
181    * @dev Allows the current owner to set the pendingOwner address.
182    * @param newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address newOwner) public onlyOwner {
185     pendingOwner = newOwner;
186   }
187 
188   /**
189    * @dev Allows the pendingOwner address to finalize the transfer.
190    */
191   function claimOwnership() public onlyPendingOwner {
192     emit OwnershipTransferred(owner, pendingOwner);
193     owner = pendingOwner;
194     pendingOwner = address(0);
195   }
196 }
197 
198 contract LockedStorage is Withdrawable, Claimable {
199     using SafeMath for uint256;
200 
201     /**
202      * account description
203      */
204     struct Account {
205         string name;
206         uint256 balance;
207         uint256 frozen;
208     }
209 
210     // record lock time period and related token amount
211     struct TimeRec {
212         uint256 amount;
213         uint256 remain;
214         uint256 endTime;
215         uint256 releasePeriodEndTime;
216     }
217 
218     mapping (address => Account) accounts;
219     mapping (address => bool) public frozenAccounts;
220     address[] accountAddresses;
221     mapping (address => TimeRec[]) frozenTimes;
222 
223     uint256 public size;
224 
225 
226     /**
227          * @dev add deposit contract address for the default withdraw wallet
228      *
229      * @param _wallet the default withdraw wallet address
230      * @param _name the wallet owner's name
231      * @param _value the balance of the wallet need to be stored in this contract
232          */
233     function addAccount(address _wallet, string _name, uint256 _value) onlyOwner public returns (bool) {
234         require(_wallet != address(0));
235 
236         accounts[_wallet].balance = _value;
237         accounts[_wallet].frozen = 0;
238         accounts[_wallet].name = _name;
239 
240         accountAddresses.push(_wallet);
241         size = size.add(1);
242         return true;
243     }
244 
245     /**
246      * @dev remove an address from the account address list
247      *
248      * @param _wallet the account address in the list
249      */
250     function removeAccountAddress(address _wallet) internal returns (bool) {
251         uint i = 0;
252         for (;i < accountAddresses.length; i = i.add(1)) {
253             if (accountAddresses[i] == _wallet) {
254                 break;
255             }
256         }
257 
258         if (i >= accountAddresses.length) {
259             return false;
260         }
261 
262         while (i < accountAddresses.length.sub(1)) {
263             accountAddresses[i] = accountAddresses[i.add(1)];
264             i = i.add(1);
265         }
266 
267         delete accountAddresses[accountAddresses.length.sub(1)];
268         accountAddresses.length = accountAddresses.length.sub(1);
269         return true;
270     }
271 
272     /**
273          * @dev remove deposit contract address from storage
274      *
275      * @param _wallet the corresponding deposit address
276          */
277     function removeAccount(address _wallet) onlyOwner public returns (bool) {
278         require(_wallet != address(0));
279 
280         delete accounts[_wallet];
281         delete frozenAccounts[_wallet];
282         removeAccountAddress(_wallet);
283 
284         size = size.sub(1);
285         return true;
286     }
287 
288     /**
289      * @dev add a time record of one account
290      *
291      * @param _target the account that holds a list of time records which record the freeze period
292      * @param _value the amount of the tokens
293      * @param _frozenEndTime the end time of the lock period, unit is second
294      * @param _releasePeriod the locking period, unit is second
295      */
296     function addLockedTime(address _target,
297                            uint256 _value,
298                            uint256 _frozenEndTime,
299                            uint256 _releasePeriod) onlyOwner public returns (bool) {
300         require(_target != address(0));
301 
302         TimeRec[] storage lockedTimes = frozenTimes[_target];
303         lockedTimes.push(TimeRec(_value, _value, _frozenEndTime, _frozenEndTime.add(_releasePeriod)));
304 
305         return true;
306     }
307 
308     /**
309      * @dev remove a time records from the time records list of one account
310      *
311      * @param _target the account that holds a list of time records which record the freeze period
312      * @param _ind the account address index
313      */
314     function removeLockedTime(address _target, uint _ind) public returns (bool) {
315         require(_target != address(0));
316 
317         TimeRec[] storage lockedTimes = frozenTimes[_target];
318         require(_ind < lockedTimes.length);
319 
320         uint256 i = _ind;
321         while (i < lockedTimes.length.sub(1)) {
322             lockedTimes[i] = lockedTimes[i.add(1)];
323             i = i.add(1);
324         }
325 
326         delete lockedTimes[lockedTimes.length.sub(1)];
327         lockedTimes.length = lockedTimes.length.sub(1);
328         return true;
329     }
330 
331     /**
332          * @dev increase balance of this deposit address
333      *
334      * @param _wallet the corresponding wallet address
335      * @param _value the amount that the balance will be increased
336          */
337     function increaseBalance(address _wallet, uint256 _value) public returns (bool) {
338         require(_wallet != address(0));
339         uint256 _balance = accounts[_wallet].balance;
340         accounts[_wallet].balance = _balance.add(_value);
341         return true;
342     }
343 
344     /**
345          * @dev decrease balance of this deposit address
346      *
347      * @param _wallet the corresponding wallet address
348      * @param _value the amount that the balance will be decreased
349          */
350     function decreaseBalance(address _wallet, uint256 _value) public returns (bool) {
351         require(_wallet != address(0));
352         uint256 _balance = accounts[_wallet].balance;
353         accounts[_wallet].balance = _balance.sub(_value);
354         return true;
355     }
356 
357     /**
358          * @dev freeze the tokens in the deposit address
359      *
360      * @param _wallet the wallet address
361      * @param _freeze to freeze or release
362      * @param _value the amount of tokens need to be frozen
363          */
364     function freezeTokens(address _wallet, bool _freeze, uint256 _value) onlyOwner public returns (bool) {
365         require(_wallet != address(0));
366         // require(_value <= balanceOf(_deposit));
367 
368         frozenAccounts[_wallet] = _freeze;
369         uint256 _frozen = accounts[_wallet].frozen;
370         uint256 _balance = accounts[_wallet].balance;
371         uint256 freezeAble = _balance.sub(_frozen);
372         if (_freeze) {
373             if (_value > freezeAble) {
374                 _value = freezeAble;
375             }
376             accounts[_wallet].frozen = _frozen.add(_value);
377         } else {
378             if (_value > _frozen) {
379                 _value = _frozen;
380             }
381             accounts[_wallet].frozen = _frozen.sub(_value);
382         }
383 
384         return true;
385     }
386 
387     /**
388          * @dev get the balance of the deposit account
389      *
390      * @param _wallet the wallet address
391          */
392     function isExisted(address _wallet) public view returns (bool) {
393         require(_wallet != address(0));
394         return (accounts[_wallet].balance != 0);
395     }
396 
397     /**
398          * @dev get the wallet name for the deposit address
399      *
400      * @param _wallet the deposit address
401          */
402     function walletName(address _wallet) onlyOwner public view returns (string) {
403         require(_wallet != address(0));
404         return accounts[_wallet].name;
405     }
406 
407     /**
408          * @dev get the balance of the deposit account
409      *
410      * @param _wallet the deposit address
411          */
412     function balanceOf(address _wallet) public view returns (uint256) {
413         require(_wallet != address(0));
414         return accounts[_wallet].balance;
415     }
416 
417     /**
418          * @dev get the frozen amount of the deposit address
419      *
420      * @param _wallet the deposit address
421          */
422     function frozenAmount(address _wallet) public view returns (uint256) {
423         require(_wallet != address(0));
424         return accounts[_wallet].frozen;
425     }
426 
427     /**
428          * @dev get the account address by index
429      *
430      * @param _ind the account address index
431          */
432     function addressByIndex(uint256 _ind) public view returns (address) {
433         return accountAddresses[_ind];
434     }
435 
436     /**
437      * @dev set the new endtime of the released time of an account
438      *
439      * @param _target the owner of some amount of tokens
440      * @param _ind the stage index of the locked stage
441      * @param _newEndTime the new endtime for the lock period
442      */
443     function changeEndTime(address _target, uint256 _ind, uint256 _newEndTime) onlyOwner public returns (bool) {
444         require(_target != address(0));
445         require(_newEndTime > 0);
446 
447         if (isExisted(_target)) {
448             TimeRec storage timePair = frozenTimes[_target][_ind];
449             timePair.endTime = _newEndTime;
450 
451             return true;
452         }
453 
454         return false;
455     }
456 
457     /**
458      * @dev set the new released period end time of an account
459      *
460      * @param _target the owner of some amount of tokens
461      * @param _ind the stage index of the locked stage
462      * @param _newReleaseEndTime the new endtime for the releasing period
463      */
464     function setNewReleaseEndTime(address _target, uint256 _ind, uint256 _newReleaseEndTime) onlyOwner public returns (bool) {
465         require(_target != address(0));
466         require(_newReleaseEndTime > 0);
467 
468         if (isExisted(_target)) {
469             TimeRec storage timePair = frozenTimes[_target][_ind];
470             timePair.releasePeriodEndTime = _newReleaseEndTime;
471 
472             return true;
473         }
474 
475         return false;
476     }
477 
478     /**
479      * @dev decrease the remaining locked amount of an account
480      *
481      * @param _target the owner of some amount of tokens
482      * @param _ind the stage index of the locked stage
483      */
484     function decreaseRemainLockedOf(address _target, uint256 _ind, uint256 _value) onlyOwner public returns (bool) {
485         require(_target != address(0));
486 
487         if (isExisted(_target)) {
488             TimeRec storage timePair = frozenTimes[_target][_ind];
489             timePair.remain = timePair.remain.sub(_value);
490 
491             return true;
492         }
493 
494         return false;
495     }
496 
497     /**
498      * @dev get the locked stages of an account
499      *
500      * @param _target the owner of some amount of tokens
501      */
502     function lockedStagesNum(address _target) public view returns (uint) {
503         require(_target != address(0));
504         return (isExisted(_target) ? frozenTimes[_target].length : 0);
505     }
506 
507     /**
508      * @dev get the endtime of the locked stages of an account
509      *
510      * @param _target the owner of some amount of tokens
511      * @param _ind the stage index of the locked stage
512      */
513     function endTimeOfStage(address _target, uint _ind) public view returns (uint256) {
514         require(_target != address(0));
515 
516         if (isExisted(_target)) {
517             TimeRec memory timePair = frozenTimes[_target][_ind];
518             return timePair.endTime;
519         }
520 
521         return 0;
522     }
523 
524     /**
525      * @dev get the remain unrleased tokens of the locked stages of an account
526      *
527      * @param _target the owner of some amount of tokens
528      * @param _ind the stage index of the locked stage
529      */
530     function remainOfStage(address _target, uint _ind) public view returns (uint256) {
531         require(_target != address(0));
532 
533         if (isExisted(_target)) {
534             TimeRec memory timePair = frozenTimes[_target][_ind];
535             return timePair.remain;
536         }
537 
538         return 0;
539     }
540 
541     /**
542      * @dev get the remain unrleased tokens of the locked stages of an account
543      *
544      * @param _target the owner of some amount of tokens
545      * @param _ind the stage index of the locked stage
546      */
547     function amountOfStage(address _target, uint _ind) public view returns (uint256) {
548         require(_target != address(0));
549 
550         if (isExisted(_target)) {
551             TimeRec memory timePair = frozenTimes[_target][_ind];
552             return timePair.amount;
553         }
554 
555         return 0;
556     }
557 
558     /**
559      * @dev get the remain releasing period end time of an account
560      *
561      * @param _target the owner of some amount of tokens
562      * @param _ind the stage index of the locked stage
563      */
564     function releaseEndTimeOfStage(address _target, uint _ind) public view returns (uint256) {
565         require(_target != address(0));
566 
567         if (isExisted(_target)) {
568             TimeRec memory timePair = frozenTimes[_target][_ind];
569             return timePair.releasePeriodEndTime;
570         }
571 
572         return 0;
573     }
574 }
575 
576 contract ERC20Basic {
577   function totalSupply() public view returns (uint256);
578   function balanceOf(address _who) public view returns (uint256);
579   function transfer(address _to, uint256 _value) public returns (bool);
580   event Transfer(address indexed from, address indexed to, uint256 value);
581 }
582 
583 contract ERC20 is ERC20Basic {
584   function allowance(address _owner, address _spender)
585     public view returns (uint256);
586 
587   function transferFrom(address _from, address _to, uint256 _value)
588     public returns (bool);
589 
590   function approve(address _spender, uint256 _value) public returns (bool);
591   event Approval(
592     address indexed owner,
593     address indexed spender,
594     uint256 value
595   );
596 }