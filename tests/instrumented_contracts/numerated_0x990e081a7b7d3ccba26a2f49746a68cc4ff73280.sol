1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9     function totalSupply() public view returns (uint256);
10     function balanceOf(address who) public view returns (uint256);
11     function transfer(address to, uint256 value) public returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21     /**
22     * dev Multiplies two numbers, throws on overflow.
23     */
24     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26         // benefit is lost if 'b' is also tested.
27         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         c = a * b;
33         assert(c / a == b);
34         return c;
35     }
36 
37     /**
38     * dev Integer division of two numbers, truncating the quotient.
39     */
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         // assert(b > 0); // Solidity automatically throws when dividing by 0
42         // uint256 c = a / b;
43         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44         return a / b;
45     }
46 
47     /**
48     * dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49     */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     /**
56     * dev Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59         c = a + b;
60         assert(c >= a);
61         return c;
62     }
63 }
64 
65 /**
66  * @title Basic token
67  * dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70     using SafeMath for uint256;
71 
72     mapping(address => uint256) balances;
73 
74     uint256 totalSupply_;
75 
76     /**
77     * dev Total number of tokens in existence
78     */
79     function totalSupply() public view returns (uint256) {
80         return totalSupply_;
81     }
82 
83     /**
84     * dev Transfer token for a specified address
85     * @param _to The address to transfer to.
86     * @param _value The amount to be transferred.
87     */
88     function transfer(address _to, uint256 _value) public returns (bool) {
89         require(_to != address(0), "Recipient address is zero address(0). Check the address again.");
90         require(_value <= balances[msg.sender], "The balance of account is insufficient.");
91 
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         emit Transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     /**
99     * dev Gets the balance of the specified address.
100     * @param _owner The address to query the the balance of.
101     * @return An uint256 representing the amount owned by the passed address.
102     */
103     function balanceOf(address _owner) public view returns (uint256) {
104         return balances[_owner];
105     }
106 
107 }
108 
109 /**
110  * @title ERC20 interface
111  * dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114     function allowance(address owner, address spender)
115     public view returns (uint256);
116 
117     function transferFrom(address from, address to, uint256 value)
118     public returns (bool);
119 
120     function approve(address spender, uint256 value) public returns (bool);
121     event Approval(
122         address indexed owner,
123         address indexed spender,
124         uint256 value
125     );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/issues/20
133  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137     mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140     /**
141      * dev Transfer tokens from one address to another
142      * @param _from address The address which you want to send tokens from
143      * @param _to address The address which you want to transfer to
144      * @param _value uint256 the amount of tokens to be transferred
145      */
146     function transferFrom(
147         address _from,
148         address _to,
149         uint256 _value
150     )
151     public
152     returns (bool)
153     {
154         require(_to != address(0), "Recipient address is zero address(0). Check the address again.");
155         require(_value <= balances[_from], "The balance of account is insufficient.");
156         require(_value <= allowed[_from][msg.sender], "Insufficient tokens approved from account owner.");
157 
158         balances[_from] = balances[_from].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         emit Transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166      * dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167      * Beware that changing an allowance with this method brings the risk that someone may use both the old
168      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      * @param _spender The address which will spend the funds.
172      * @param _value The amount of tokens to be spent.
173      */
174     function approve(address _spender, uint256 _value) public returns (bool) {
175         allowed[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181      * dev Function to check the amount of tokens that an owner allowed to a spender.
182      * @param _owner address The address which owns the funds.
183      * @param _spender address The address which will spend the funds.
184      * @return A uint256 specifying the amount of tokens still available for the spender.
185      */
186     function allowance(
187         address _owner,
188         address _spender
189     )
190     public
191     view
192     returns (uint256)
193     {
194         return allowed[_owner][_spender];
195     }
196 
197     /**
198      * dev Increase the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed[_spender] == 0. To increment
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * @param _spender The address which will spend the funds.
204      * @param _addedValue The amount of tokens to increase the allowance by.
205      */
206     function increaseApproval(
207         address _spender,
208         uint256 _addedValue
209     )
210     public
211     returns (bool)
212     {
213         allowed[msg.sender][_spender] = (
214         allowed[msg.sender][_spender].add(_addedValue));
215         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218 
219     /**
220      * dev Decrease the amount of tokens that an owner allowed to a spender.
221      * approve should be called when allowed[_spender] == 0. To decrement
222      * allowed value is better to use this function to avoid 2 calls (and wait until
223      * the first transaction is mined)
224      * From MonolithDAO Token.sol
225      * @param _spender The address which will spend the funds.
226      * @param _subtractedValue The amount of tokens to decrease the allowance by.
227      */
228     function decreaseApproval(
229         address _spender,
230         uint256 _subtractedValue
231     )
232     public
233     returns (bool)
234     {
235         uint256 oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245 }
246 
247 /**
248  * Utility library of inline functions on addresses
249  */
250 library AddressUtils {
251 
252     /**
253      * Returns whether the target address is a contract
254      * dev This function will return false if invoked during the constructor of a contract,
255      * as the code is not actually created until after the constructor finishes.
256      * @param addr address to check
257      * @return whether the target address is a contract
258      */
259     function isContract(address addr) internal view returns (bool) {
260         uint256 size;
261         // XXX Currently there is no better way to check if there is a contract in an address
262         // than to check the size of the code at that address.
263         // See https://ethereum.stackexchange.com/a/14016/36603
264         // for more details about how this works.
265         // TODO Check this again before the Serenity release, because all addresses will be
266         // contracts then.
267         // solium-disable-next-line security/no-inline-assembly
268         assembly { size := extcodesize(addr) }
269         return size > 0;
270     }
271 
272 }
273 
274 /**
275  * @title MultiOwnable
276  * dev
277  */
278 contract MultiOwnable {
279     using SafeMath for uint256;
280 
281     address public root; // 혹시 몰라 준비해둔 superOwner 의 백업. 하드웨어 월렛 주소로 세팅할 예정.
282     address public superOwner;
283     mapping (address => bool) public owners;
284     address[] public ownerList;
285 
286     // for changeSuperOwnerByDAO
287     // mapping(address => mapping (address => bool)) public preSuperOwnerMap;
288     mapping(address => address) public candidateSuperOwnerMap;
289 
290 
291     event ChangedRoot(address newRoot);
292     event ChangedSuperOwner(address newSuperOwner);
293     event AddedNewOwner(address newOwner);
294     event DeletedOwner(address deletedOwner);
295 
296     constructor() public {
297         root = msg.sender;
298         superOwner = msg.sender;
299         owners[root] = true;
300 
301         ownerList.push(msg.sender);
302 
303     }
304 
305     modifier onlyRoot() {
306         require(msg.sender == root, "Root privilege is required.");
307         _;
308     }
309 
310     modifier onlySuperOwner() {
311         require(msg.sender == superOwner, "SuperOwner priviledge is required.");
312         _;
313     }
314 
315     modifier onlyOwner() {
316         require(owners[msg.sender], "Owner priviledge is required.");
317         _;
318     }
319 
320     /**
321      * dev root 교체 (root 는 root 와 superOwner 를 교체할 수 있는 권리가 있다.)
322      * dev 기존 루트가 관리자에서 지워지지 않고, 새 루트가 자동으로 관리자에 등록되지 않음을 유의!
323      */
324     function changeRoot(address newRoot) onlyRoot public returns (bool) {
325         require(newRoot != address(0), "This address to be set is zero address(0). Check the input address.");
326 
327         root = newRoot;
328 
329         emit ChangedRoot(newRoot);
330         return true;
331     }
332 
333     /**
334      * dev superOwner 교체 (root 는 root 와 superOwner 를 교체할 수 있는 권리가 있다.)
335      * dev 기존 superOwner 가 관리자에서 지워지지 않고, 새 superOwner 가 자동으로 관리자에 등록되지 않음을 유의!
336      */
337     function changeSuperOwner(address newSuperOwner) onlyRoot public returns (bool) {
338         require(newSuperOwner != address(0), "This address to be set is zero address(0). Check the input address.");
339 
340         superOwner = newSuperOwner;
341 
342         emit ChangedSuperOwner(newSuperOwner);
343         return true;
344     }
345 
346     /**
347      * dev owner 들의 1/2 초과가 합의하면 superOwner 를 교체할 수 있다.
348      */
349     function changeSuperOwnerByDAO(address newSuperOwner) onlyOwner public returns (bool) {
350         require(newSuperOwner != address(0), "This address to be set is zero address(0). Check the input address.");
351         require(newSuperOwner != candidateSuperOwnerMap[msg.sender], "You have already voted for this account.");
352 
353         candidateSuperOwnerMap[msg.sender] = newSuperOwner;
354 
355         uint8 votingNumForSuperOwner = 0;
356         uint8 i = 0;
357 
358         for (i = 0; i < ownerList.length; i++) {
359             if (candidateSuperOwnerMap[ownerList[i]] == newSuperOwner)
360                 votingNumForSuperOwner++;
361         }
362 
363         if (votingNumForSuperOwner > ownerList.length / 2) { // 과반수 이상이면 DAO 성립 => superOwner 교체
364             superOwner = newSuperOwner;
365 
366             // 초기화
367             for (i = 0; i < ownerList.length; i++) {
368                 delete candidateSuperOwnerMap[ownerList[i]];
369             }
370 
371             emit ChangedSuperOwner(newSuperOwner);
372         }
373 
374         return true;
375     }
376 
377     function newOwner(address owner) onlySuperOwner public returns (bool) {
378         require(owner != address(0), "This address to be set is zero address(0). Check the input address.");
379         require(!owners[owner], "This address is already registered.");
380 
381         owners[owner] = true;
382         ownerList.push(owner);
383 
384         emit AddedNewOwner(owner);
385         return true;
386     }
387 
388     function deleteOwner(address owner) onlySuperOwner public returns (bool) {
389         require(owners[owner], "This input address is not a super owner.");
390         delete owners[owner];
391 
392         for (uint256 i = 0; i < ownerList.length; i++) {
393             if (ownerList[i] == owner) {
394                 ownerList[i] = ownerList[ownerList.length.sub(1)];
395                 ownerList.length = ownerList.length.sub(1);
396                 break;
397             }
398         }
399 
400         emit DeletedOwner(owner);
401         return true;
402     }
403 }
404 
405 /**
406  * @title Lockable token
407  */
408 contract LockableToken is StandardToken, MultiOwnable {
409     bool public locked = true;
410     uint256 public constant LOCK_MAX = uint256(-1);
411 
412     /**
413      * dev 락 상태에서도 거래 가능한 언락 계정
414      */
415     mapping(address => bool) public unlockAddrs;
416 
417     /**
418      * dev 계정 별로 lock value 만큼 잔고가 잠김
419      * dev - 값이 0 일 때 : 잔고가 0 이어도 되므로 제한이 없는 것임.
420      * dev - 값이 LOCK_MAX 일 때 : 잔고가 uint256 의 최대값이므로 아예 잠긴 것임.
421      */
422     mapping(address => uint256) public lockValues;
423 
424     event Locked(bool locked, string note);
425     event LockedTo(address indexed addr, bool locked, string note);
426     event SetLockValue(address indexed addr, uint256 value, string note);
427 
428     constructor() public {
429         unlockTo(msg.sender,  "");
430     }
431 
432     modifier checkUnlock (address addr, uint256 value) {
433         require(!locked || unlockAddrs[addr], "The account is currently locked.");
434         require(balances[addr].sub(value) >= lockValues[addr], "Transferable limit exceeded. Check the status of the lock value.");
435         _;
436     }
437 
438     function lock(string note) onlyOwner public {
439         locked = true;
440         emit Locked(locked, note);
441     }
442 
443     function unlock(string note) onlyOwner public {
444         locked = false;
445         emit Locked(locked, note);
446     }
447 
448     function lockTo(address addr, string note) onlyOwner public {
449         setLockValue(addr, LOCK_MAX, note);
450         unlockAddrs[addr] = false;
451 
452         emit LockedTo(addr, true, note);
453     }
454 
455     function unlockTo(address addr, string note) onlyOwner public {
456         if (lockValues[addr] == LOCK_MAX)
457             setLockValue(addr, 0, note);
458         unlockAddrs[addr] = true;
459 
460         emit LockedTo(addr, false, note);
461     }
462 
463     function setLockValue(address addr, uint256 value, string note) onlyOwner public {
464         lockValues[addr] = value;
465         emit SetLockValue(addr, value, note);
466     }
467 
468     /**
469      * dev 이체 가능 금액을 조회한다.
470      */
471     function getMyUnlockValue() public view returns (uint256) {
472         address addr = msg.sender;
473         if ((!locked || unlockAddrs[addr]) && balances[addr] > lockValues[addr])
474             return balances[addr].sub(lockValues[addr]);
475         else
476             return 0;
477     }
478 
479     function transfer(address to, uint256 value) checkUnlock(msg.sender, value) public returns (bool) {
480         return super.transfer(to, value);
481     }
482 
483     function transferFrom(address from, address to, uint256 value) checkUnlock(from, value) public returns (bool) {
484         return super.transferFrom(from, to, value);
485     }
486 }
487 
488 /**
489  * @title DelayLockableToken
490  * dev 보안 차원에서 본인 계좌 잔고에 lock 을 걸 수 있다. 잔고 제한 기준을 낮추면 적용되기까지 12시간을 기다려야 한다.
491  */
492 contract DelayLockableToken is LockableToken {
493     mapping(address => uint256) public delayLockValues;
494     mapping(address => uint256) public delayLockBeforeValues;
495     mapping(address => uint256) public delayLockTimes;
496 
497     event SetDelayLockValue(address indexed addr, uint256 value, uint256 time);
498 
499     modifier checkDelayUnlock (address addr, uint256 value) {
500         if (delayLockTimes[msg.sender] <= now) {
501             require (balances[addr].sub(value) >= delayLockValues[addr], "Transferable limit exceeded. Change the balance lock value first and then use it");
502         } else {
503             require (balances[addr].sub(value) >= delayLockBeforeValues[addr], "Transferable limit exceeded. Please note that the residual lock value has changed and it will take 12 hours to apply.");
504         }
505         _;
506     }
507 
508     /**
509      * dev 자신의 계좌에 잔고 제한을 건다. 더 크게 걸 땐 바로 적용되고, 더 작게 걸 땐 12시간 이후에 변경된다.
510      */
511     function delayLock(uint256 value) public returns (bool) {
512         require (value <= balances[msg.sender], "Your balance is insufficient.");
513 
514         if (value >= delayLockValues[msg.sender])
515             delayLockTimes[msg.sender] = now;
516         else {
517             require (delayLockTimes[msg.sender] <= now, "The remaining money in the account cannot be unlocked continuously. You cannot renew until 12 hours after the first run.");
518             delayLockTimes[msg.sender] = now + 12 hours;
519             delayLockBeforeValues[msg.sender] = delayLockValues[msg.sender];
520         }
521 
522         delayLockValues[msg.sender] = value;
523 
524         emit SetDelayLockValue(msg.sender, value, delayLockTimes[msg.sender]);
525         return true;
526     }
527 
528     /**
529      * dev 자신의 계좌의 잔고 제한을 푼다.
530      */
531     function delayUnlock() public returns (bool) {
532         return delayLock(0);
533     }
534 
535     /**
536      * dev 이체 가능 금액을 조회한다.
537      */
538     function getMyUnlockValue() public view returns (uint256) {
539         uint256 myUnlockValue;
540         address addr = msg.sender;
541         if (delayLockTimes[addr] <= now) {
542             myUnlockValue = balances[addr].sub(delayLockValues[addr]);
543         } else {
544             myUnlockValue = balances[addr].sub(delayLockBeforeValues[addr]);
545         }
546         
547         uint256 superUnlockValue = super.getMyUnlockValue();
548 
549         if (myUnlockValue > superUnlockValue)
550             return superUnlockValue;
551         else
552             return myUnlockValue;
553     }    
554 
555     function transfer(address to, uint256 value) checkDelayUnlock(msg.sender, value) public returns (bool) {
556         return super.transfer(to, value);
557     }
558 
559     function transferFrom(address from, address to, uint256 value) checkDelayUnlock(from, value) public returns (bool) {
560         return super.transferFrom(from, to, value);
561     }
562 }
563 
564 /**
565  * @title KSCBaseToken
566  * dev 트랜잭션 실행 시 메모를 남길 수 있도록 하였음.
567  */
568 contract KSCBaseToken is DelayLockableToken {
569     event KSCTransfer(address indexed from, address indexed to, uint256 value, string note);
570     event KSCTransferFrom(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
571     event KSCApproval(address indexed owner, address indexed spender, uint256 value, string note);
572 
573     event KSCMintTo(address indexed controller, address indexed to, uint256 amount, string note);
574     event KSCBurnFrom(address indexed controller, address indexed from, uint256 value, string note);
575 
576     event KSCBurnWhenMoveToMainnet(address indexed controller, address indexed from, uint256 value, string note);
577 
578     event KSCSell(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
579     event KSCSellByOtherCoin(address indexed owner, address indexed spender, address indexed to, uint256 value,  uint256 processIdHash, uint256 userIdHash, string note);
580 
581     event KSCTransferToTeam(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
582     event KSCTransferToPartner(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
583 
584     event KSCTransferToEcosystem(address indexed owner, address indexed spender, address indexed to, uint256 value, uint256 processIdHash, uint256 userIdHash, string note);
585     event KSCTransferToBounty(address indexed owner, address indexed spender, address indexed to, uint256 value, uint256 processIdHash, uint256 userIdHash, string note);
586 
587     // ERC20 함수들을 오버라이딩하여 super 로 올라가지 않고 무조건 ksc~ 함수로 지나가게 한다.
588     function transfer(address to, uint256 value) public returns (bool ret) {
589         return kscTransfer(to, value, "");
590     }
591 
592     function kscTransfer(address to, uint256 value, string note) public returns (bool ret) {
593         require(to != address(this), "The receive address is the Contact Address of KStarCoin. You cannot send money to this address.");
594 
595         ret = super.transfer(to, value);
596         emit KSCTransfer(msg.sender, to, value, note);
597     }
598 
599     function transferFrom(address from, address to, uint256 value) public returns (bool) {
600         return kscTransferFrom(from, to, value, "");
601     }
602 
603     function kscTransferFrom(address from, address to, uint256 value, string note) public returns (bool ret) {
604         require(to != address(this), "The receive address is the Contact Address of KStarCoin. You cannot send money to this address.");
605 
606         ret = super.transferFrom(from, to, value);
607         emit KSCTransferFrom(from, msg.sender, to, value, note);
608     }
609 
610     function approve(address spender, uint256 value) public returns (bool) {
611         return kscApprove(spender, value, "");
612     }
613 
614     function kscApprove(address spender, uint256 value, string note) public returns (bool ret) {
615         ret = super.approve(spender, value);
616         emit KSCApproval(msg.sender, spender, value, note);
617     }
618 
619     function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
620         return kscIncreaseApproval(spender, addedValue, "");
621     }
622 
623     function kscIncreaseApproval(address spender, uint256 addedValue, string note) public returns (bool ret) {
624         ret = super.increaseApproval(spender, addedValue);
625         emit KSCApproval(msg.sender, spender, allowed[msg.sender][spender], note);
626     }
627 
628     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
629         return kscDecreaseApproval(spender, subtractedValue, "");
630     }
631 
632     function kscDecreaseApproval(address spender, uint256 subtractedValue, string note) public returns (bool ret) {
633         ret = super.decreaseApproval(spender, subtractedValue);
634         emit KSCApproval(msg.sender, spender, allowed[msg.sender][spender], note);
635     }
636 
637     /**
638      * dev 신규 화폐 발행. 반드시 이유를 메모로 남겨라.
639      */
640     function mintTo(address to, uint256 amount) internal returns (bool) {
641         require(to != address(0x0), "This address to be set is zero address(0). Check the input address.");
642 
643         totalSupply_ = totalSupply_.add(amount);
644         balances[to] = balances[to].add(amount);
645 
646         emit Transfer(address(0), to, amount);
647         return true;
648     }
649 
650     function kscMintTo(address to, uint256 amount, string note) onlyOwner public returns (bool ret) {
651         ret = mintTo(to, amount);
652         emit KSCMintTo(msg.sender, to, amount, note);
653     }
654 
655     /**
656      * dev 화폐 소각. 반드시 이유를 메모로 남겨라.
657      */
658     function burnFrom(address from, uint256 value) internal returns (bool) {
659         require(value <= balances[from], "Your balance is insufficient.");
660 
661         balances[from] = balances[from].sub(value);
662         totalSupply_ = totalSupply_.sub(value);
663 
664         emit Transfer(from, address(0), value);
665         return true;
666     }
667 
668     function kscBurnFrom(address from, uint256 value, string note) onlyOwner public returns (bool ret) {
669         ret = burnFrom(from, value);
670         emit KSCBurnFrom(msg.sender, from, value, note);
671     }
672 
673     /**
674      * dev 메인넷으로 이동하며 화폐 소각.
675      */
676     function kscBurnWhenMoveToMainnet(address burner, uint256 value, string note) onlyOwner public returns (bool ret) {
677         ret = burnFrom(burner, value);
678         emit KSCBurnWhenMoveToMainnet(msg.sender, burner, value, note);
679     }
680 
681     function kscBatchBurnWhenMoveToMainnet(address[] burners, uint256[] values, string note) onlyOwner public returns (bool ret) {
682         uint256 length = burners.length;
683         require(length == values.length, "The size of \'burners\' and \'values\' array is different.");
684 
685         ret = true;
686         for (uint256 i = 0; i < length; i++) {
687             ret = ret && kscBurnWhenMoveToMainnet(burners[i], values[i], note);
688         }
689     }
690 
691     /**
692      * dev 이더로 KSC 를 구입하는 경우
693      */
694     function kscSell(
695         address from,
696         address to,
697         uint256 value,
698         string note
699     ) onlyOwner public returns (bool ret) {
700         require(to != address(this), "The receive address is the Contact Address of KStarCoin. You cannot send money to this address.");
701 
702         ret = super.transferFrom(from, to, value);
703         emit KSCSell(from, msg.sender, to, value, note);
704     }
705 
706     /**
707      * dev 비트코인 등의 다른 코인으로 KSC 를 구입하는 경우
708      * dev EOA 가 트랜잭션을 일으켜서 처리해야 하기 때문에 다계좌를 기준으로 한다. (가스비 아끼기 위함)
709      */
710     function kscBatchSellByOtherCoin(
711         address from,
712         address[] to,
713         uint256[] values,
714         uint256 processIdHash,
715         uint256[] userIdHash,
716         string note
717     ) onlyOwner public returns (bool ret) {
718         uint256 length = to.length;
719         require(length == values.length, "The size of \'to\' and \'values\' array is different.");
720         require(length == userIdHash.length, "The size of \'to\' and \'userIdHash\' array is different.");
721 
722         ret = true;
723         for (uint256 i = 0; i < length; i++) {
724             require(to[i] != address(this), "The receive address is the Contact Address of KStarCoin. You cannot send money to this address.");
725 
726             ret = ret && super.transferFrom(from, to[i], values[i]);
727             emit KSCSellByOtherCoin(from, msg.sender, to[i], values[i], processIdHash, userIdHash[i], note);
728         }
729     }
730 
731     /**
732      * dev 팀에게 전송하는 경우
733      */
734     function kscTransferToTeam(
735         address from,
736         address to,
737         uint256 value,
738         string note
739     ) onlyOwner public returns (bool ret) {
740         require(to != address(this), "The receive address is the Contact Address of KStarCoin. You cannot send money to this address.");
741 
742         ret = super.transferFrom(from, to, value);
743         emit KSCTransferToTeam(from, msg.sender, to, value, note);
744     }
745 
746     /**
747      * dev 파트너 및 어드바이저에게 전송하는 경우
748      */
749     function kscTransferToPartner(
750         address from,
751         address to,
752         uint256 value,
753         string note
754     ) onlyOwner public returns (bool ret) {
755         require(to != address(this), "The receive address is the Contact Address of KStarCoin. You cannot send money to this address.");
756 
757         ret = super.transferFrom(from, to, value);
758         emit KSCTransferToPartner(from, msg.sender, to, value, note);
759     }
760 
761     /**
762      * dev 에코시스템(커뮤니티 활동을 통한 보상 등)으로 KSC 지급
763      * dev EOA 가 트랜잭션을 일으켜서 처리해야 하기 때문에 다계좌를 기준으로 한다. (가스비 아끼기 위함)
764      */
765     function kscBatchTransferToEcosystem(
766         address from, address[] to,
767         uint256[] values,
768         uint256 processIdHash,
769         uint256[] userIdHash,
770         string note
771     ) onlyOwner public returns (bool ret) {
772         uint256 length = to.length;
773         require(length == values.length, "The size of \'to\' and \'values\' array is different.");
774         require(length == userIdHash.length, "The size of \'to\' and \'userIdHash\' array is different.");
775 
776         ret = true;
777         for (uint256 i = 0; i < length; i++) {
778             require(to[i] != address(this), "The receive address is the Contact Address of KStarCoin. You cannot send money to this address.");
779 
780             ret = ret && super.transferFrom(from, to[i], values[i]);
781             emit KSCTransferToEcosystem(from, msg.sender, to[i], values[i], processIdHash, userIdHash[i], note);
782         }
783     }
784 
785     /**
786      * dev 바운티 참여자에게 KSC 지급
787      * dev EOA 가 트랜잭션을 일으켜서 처리해야 하기 때문에 다계좌를 기준으로 한다. (가스비 아끼기 위함)
788      */
789     function kscBatchTransferToBounty(
790         address from,
791         address[] to,
792         uint256[] values,
793         uint256 processIdHash,
794         uint256[] userIdHash,
795         string note
796     ) onlyOwner public returns (bool ret) {
797         uint256 length = to.length;
798         require(to.length == values.length, "The size of \'to\' and \'values\' array is different.");
799 
800         ret = true;
801         for (uint256 i = 0; i < length; i++) {
802             require(to[i] != address(this), "The receive address is the Contact Address of KStarCoin. You cannot send money to this address.");
803 
804             ret = ret && super.transferFrom(from, to[i], values[i]);
805             emit KSCTransferToBounty(from, msg.sender, to[i], values[i], processIdHash, userIdHash[i], note);
806         }
807     }
808 
809     function destroy() onlyRoot public {
810         selfdestruct(root);
811     }
812 }
813 
814 /**
815  * @title KStarCoin
816  */
817 contract KStarCoin is KSCBaseToken {
818     using AddressUtils for address;
819 
820     event TransferedToKSCDapp(
821         address indexed owner,
822         address indexed spender,
823         address indexed to, uint256 value, KSCReceiver.KSCReceiveType receiveType);
824 
825     string public constant name = "KStarCoin";
826     string public constant symbol = "KSC";
827     uint8 public constant decimals = 18;
828 
829     uint256 public constant INITIAL_SUPPLY = 1e9 * (10 ** uint256(decimals));
830 
831     constructor() public {
832         totalSupply_ = INITIAL_SUPPLY;
833         balances[msg.sender] = INITIAL_SUPPLY;
834         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
835     }
836 
837     function kscTransfer(address to, uint256 value, string note) public returns (bool ret) {
838         ret = super.kscTransfer(to, value, note);
839         postTransfer(msg.sender, msg.sender, to, value, KSCReceiver.KSCReceiveType.KSC_TRANSFER);
840     }
841 
842     function kscTransferFrom(address from, address to, uint256 value, string note) public returns (bool ret) {
843         ret = super.kscTransferFrom(from, to, value, note);
844         postTransfer(from, msg.sender, to, value, KSCReceiver.KSCReceiveType.KSC_TRANSFER);
845     }
846 
847     function postTransfer(address owner, address spender, address to, uint256 value, KSCReceiver.KSCReceiveType receiveType) internal returns (bool) {
848         if (to.isContract()) {
849             bool callOk = address(to).call(bytes4(keccak256("onKSCReceived(address,address,uint256,uint8)")), owner, spender, value, receiveType);
850             if (callOk) {
851                 emit TransferedToKSCDapp(owner, spender, to, value, receiveType);
852             }
853         }
854 
855         return true;
856     }
857 
858     function kscMintTo(address to, uint256 amount, string note) onlyOwner public returns (bool ret) {
859         ret = super.kscMintTo(to, amount, note);
860         postTransfer(0x0, msg.sender, to, amount, KSCReceiver.KSCReceiveType.KSC_MINT);
861     }
862 
863     function kscBurnFrom(address from, uint256 value, string note) onlyOwner public returns (bool ret) {
864         ret = super.kscBurnFrom(from, value, note);
865         postTransfer(0x0, msg.sender, from, value, KSCReceiver.KSCReceiveType.KSC_BURN);
866     }
867 }
868 
869 
870 /**
871  * @title KStarCoin Receiver
872  */
873 contract KSCReceiver {
874     enum KSCReceiveType { KSC_TRANSFER, KSC_MINT, KSC_BURN }
875     function onKSCReceived(address owner, address spender, uint256 value, KSCReceiveType receiveType) public returns (bool);
876 }
877 
878 /**
879  * @title KSCDappSample
880  */
881 contract KSCDappSample is KSCReceiver {
882     event LogOnReceiveKSC(string message, address indexed owner, address indexed spender, uint256 value, KSCReceiveType receiveType);
883 
884     function onKSCReceived(address owner, address spender, uint256 value, KSCReceiveType receiveType) public returns (bool) {
885         emit LogOnReceiveKSC("I receive KstarCoin.", owner, spender, value, receiveType);
886         return true;
887     }
888 }