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
286     // for changeRootByDAO
287     mapping(address => address) public candidateRootMap;
288 
289 
290     event ChangedRoot(address newRoot);
291     event ChangedSuperOwner(address newSuperOwner);
292     event AddedNewOwner(address newOwner);
293     event DeletedOwner(address deletedOwner);
294 
295     constructor() public {
296         root = msg.sender;
297         superOwner = msg.sender;
298         owners[root] = true;
299 
300         ownerList.push(msg.sender);
301 
302     }
303 
304     modifier onlyRoot() {
305         require(msg.sender == root, "Root privilege is required.");
306         _;
307     }
308 
309     modifier onlySuperOwner() {
310         require(msg.sender == superOwner, "SuperOwner priviledge is required.");
311         _;
312     }
313 
314     modifier onlyOwner() {
315         require(owners[msg.sender], "Owner priviledge is required.");
316         _;
317     }
318 
319     /**
320      * dev root 교체 (root 는 root 와 superOwner 를 교체할 수 있는 권리가 있다.)
321      * dev 기존 루트가 관리자에서 지워지지 않고, 새 루트가 자동으로 관리자에 등록되지 않음을 유의!
322      */
323     function changeRoot(address newRoot) onlyRoot public returns (bool) {
324         require(newRoot != address(0), "This address to be set is zero address(0). Check the input address.");
325 
326         root = newRoot;
327 
328         emit ChangedRoot(newRoot);
329         return true;
330     }
331 
332     /**
333      * dev superOwner 교체 (root 는 root 와 superOwner 를 교체할 수 있는 권리가 있다.)
334      * dev 기존 superOwner 가 관리자에서 지워지지 않고, 새 superOwner 가 자동으로 관리자에 등록되지 않음을 유의!
335      */
336     function changeSuperOwner(address newSuperOwner) onlyRoot public returns (bool) {
337         require(newSuperOwner != address(0), "This address to be set is zero address(0). Check the input address.");
338 
339         superOwner = newSuperOwner;
340 
341         emit ChangedSuperOwner(newSuperOwner);
342         return true;
343     }
344 
345     /**
346      * dev owner 들의 1/2 초과가 합의하면 root 를 교체할 수 있다.
347      */
348     function changeRootByDAO(address newRoot) onlyOwner public returns (bool) {
349         require(newRoot != address(0), "This address to be set is zero address(0). Check the input address.");
350         require(newRoot != candidateRootMap[msg.sender], "You have already voted for this account.");
351 
352         candidateRootMap[msg.sender] = newRoot;
353 
354         uint8 votingNumForRoot = 0;
355         uint8 i = 0;
356 
357         for (i = 0; i < ownerList.length; i++) {
358             if (candidateRootMap[ownerList[i]] == newRoot)
359                 votingNumForRoot++;
360         }
361 
362         if (votingNumForRoot > ownerList.length / 2) { // 과반수 이상이면 DAO 성립 => root 교체
363             root = newRoot;
364 
365             // 초기화
366             for (i = 0; i < ownerList.length; i++) {
367                 delete candidateRootMap[ownerList[i]];
368             }
369 
370             emit ChangedRoot(newRoot);
371         }
372 
373         return true;
374     }
375 
376     function newOwner(address owner) onlySuperOwner public returns (bool) {
377         require(owner != address(0), "This address to be set is zero address(0). Check the input address.");
378         require(!owners[owner], "This address is already registered.");
379 
380         owners[owner] = true;
381         ownerList.push(owner);
382 
383         emit AddedNewOwner(owner);
384         return true;
385     }
386 
387     function deleteOwner(address owner) onlySuperOwner public returns (bool) {
388         require(owners[owner], "This input address is not a super owner.");
389         delete owners[owner];
390 
391         for (uint256 i = 0; i < ownerList.length; i++) {
392             if (ownerList[i] == owner) {
393                 ownerList[i] = ownerList[ownerList.length.sub(1)];
394                 ownerList.length = ownerList.length.sub(1);
395                 break;
396             }
397         }
398 
399         emit DeletedOwner(owner);
400         return true;
401     }
402 }
403 
404 /**
405  * @title Lockable token
406  */
407 contract LockableToken is StandardToken, MultiOwnable {
408     bool public locked = true;
409     uint256 public constant LOCK_MAX = uint256(-1);
410 
411     /**
412      * dev 락 상태에서도 거래 가능한 언락 계정
413      */
414     mapping(address => bool) public unlockAddrs;
415 
416     /**
417      * dev 계정 별로 lock value 만큼 잔고가 잠김
418      * dev - 값이 0 일 때 : 잔고가 0 이어도 되므로 제한이 없는 것임.
419      * dev - 값이 LOCK_MAX 일 때 : 잔고가 uint256 의 최대값이므로 아예 잠긴 것임.
420      */
421     mapping(address => uint256) public lockValues;
422 
423     event Locked(bool locked, string note);
424     event LockedTo(address indexed addr, bool locked, string note);
425     event SetLockValue(address indexed addr, uint256 value, string note);
426 
427     constructor() public {
428         unlockTo(msg.sender,  "");
429     }
430 
431     modifier checkUnlock (address addr, uint256 value) {
432         require(!locked || unlockAddrs[addr], "The account is currently locked.");
433         require(balances[addr].sub(value) >= lockValues[addr], "Transferable limit exceeded. Check the status of the lock value.");
434         _;
435     }
436 
437     function lock(string note) onlyOwner public {
438         locked = true;
439         emit Locked(locked, note);
440     }
441 
442     function unlock(string note) onlyOwner public {
443         locked = false;
444         emit Locked(locked, note);
445     }
446 
447     function lockTo(address addr, string note) onlyOwner public {
448         setLockValue(addr, LOCK_MAX, note);
449         unlockAddrs[addr] = false;
450 
451         emit LockedTo(addr, true, note);
452     }
453 
454     function unlockTo(address addr, string note) onlyOwner public {
455         if (lockValues[addr] == LOCK_MAX)
456             setLockValue(addr, 0, note);
457         unlockAddrs[addr] = true;
458 
459         emit LockedTo(addr, false, note);
460     }
461 
462     function setLockValue(address addr, uint256 value, string note) onlyOwner public {
463         lockValues[addr] = value;
464         emit SetLockValue(addr, value, note);
465     }
466 
467     /**
468      * dev 이체 가능 금액을 조회한다.
469      */
470     function getMyUnlockValue() public view returns (uint256) {
471         address addr = msg.sender;
472         if ((!locked || unlockAddrs[addr]) && balances[addr] > lockValues[addr])
473             return balances[addr].sub(lockValues[addr]);
474         else
475             return 0;
476     }
477 
478     function transfer(address to, uint256 value) checkUnlock(msg.sender, value) public returns (bool) {
479         return super.transfer(to, value);
480     }
481 
482     function transferFrom(address from, address to, uint256 value) checkUnlock(from, value) public returns (bool) {
483         return super.transferFrom(from, to, value);
484     }
485 }
486 
487 /**
488  * @title DelayLockableToken
489  * dev 보안 차원에서 본인 계좌 잔고에 lock 을 걸 수 있다. 잔고 제한 기준을 낮추면 적용되기까지 12시간을 기다려야 한다.
490  */
491 contract DelayLockableToken is LockableToken {
492     mapping(address => uint256) public delayLockValues;
493     mapping(address => uint256) public delayLockBeforeValues;
494     mapping(address => uint256) public delayLockTimes;
495 
496     event SetDelayLockValue(address indexed addr, uint256 value, uint256 time);
497 
498     modifier checkDelayUnlock (address addr, uint256 value) {
499         if (delayLockTimes[msg.sender] <= now) {
500             require (balances[addr].sub(value) >= delayLockValues[addr], "Transferable limit exceeded. Change the balance lock value first and then use it");
501         } else {
502             require (balances[addr].sub(value) >= delayLockBeforeValues[addr], "Transferable limit exceeded. Please note that the residual lock value has changed and it will take 12 hours to apply.");
503         }
504         _;
505     }
506 
507     /**
508      * dev 자신의 계좌에 잔고 제한을 건다. 더 크게 걸 땐 바로 적용되고, 더 작게 걸 땐 12시간 이후에 변경된다.
509      */
510     function delayLock(uint256 value) public returns (bool) {
511         require (value <= balances[msg.sender], "Your balance is insufficient.");
512 
513         if (value >= delayLockValues[msg.sender])
514             delayLockTimes[msg.sender] = now;
515         else {
516             require (delayLockTimes[msg.sender] <= now, "The remaining money in the account cannot be unlocked continuously. You cannot renew until 12 hours after the first run.");
517             delayLockTimes[msg.sender] = now + 12 hours;
518             delayLockBeforeValues[msg.sender] = delayLockValues[msg.sender];
519         }
520 
521         delayLockValues[msg.sender] = value;
522 
523         emit SetDelayLockValue(msg.sender, value, delayLockTimes[msg.sender]);
524         return true;
525     }
526 
527     /**
528      * dev 자신의 계좌의 잔고 제한을 푼다.
529      */
530     function delayUnlock() public returns (bool) {
531         return delayLock(0);
532     }
533 
534     /**
535      * dev 이체 가능 금액을 조회한다.
536      */
537     function getMyUnlockValue() public view returns (uint256) {
538         uint256 myUnlockValue;
539         address addr = msg.sender;
540         if (delayLockTimes[addr] <= now) {
541             myUnlockValue = balances[addr].sub(delayLockValues[addr]);
542         } else {
543             myUnlockValue = balances[addr].sub(delayLockBeforeValues[addr]);
544         }
545         
546         uint256 superUnlockValue = super.getMyUnlockValue();
547 
548         if (myUnlockValue > superUnlockValue)
549             return superUnlockValue;
550         else
551             return myUnlockValue;
552     }    
553 
554     function transfer(address to, uint256 value) checkDelayUnlock(msg.sender, value) public returns (bool) {
555         return super.transfer(to, value);
556     }
557 
558     function transferFrom(address from, address to, uint256 value) checkDelayUnlock(from, value) public returns (bool) {
559         return super.transferFrom(from, to, value);
560     }
561 }
562 
563 /**
564  * @title LBKBaseToken
565  * dev 트랜잭션 실행 시 메모를 남길 수 있도록 하였음.
566  */
567 contract LBKBaseToken is DelayLockableToken {
568     event LBKTransfer(address indexed from, address indexed to, uint256 value, string note);
569     event LBKTransferFrom(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
570     event LBKApproval(address indexed owner, address indexed spender, uint256 value, string note);
571 
572     event LBKMintTo(address indexed controller, address indexed to, uint256 amount, string note);
573     event LBKBurnFrom(address indexed controller, address indexed from, uint256 value, string note);
574 
575     event LBKBurnWhenMoveToMainnet(address indexed controller, address indexed from, uint256 value, string note);
576 
577     event LBKSell(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
578     event LBKSellByOtherCoin(address indexed owner, address indexed spender, address indexed to, uint256 value,  uint256 processIdHash, uint256 userIdHash, string note);
579 
580     event LBKTransferToTeam(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
581     event LBKTransferToPartner(address indexed owner, address indexed spender, address indexed to, uint256 value, string note);
582 
583     event LBKTransferToEcosystem(address indexed owner, address indexed spender, address indexed to, uint256 value, uint256 processIdHash, uint256 userIdHash, string note);
584     event LBKTransferToBounty(address indexed owner, address indexed spender, address indexed to, uint256 value, uint256 processIdHash, uint256 userIdHash, string note);
585 
586     // ERC20 함수들을 오버라이딩하여 super 로 올라가지 않고 무조건 lbk~ 함수로 지나가게 한다.
587     function transfer(address to, uint256 value) public returns (bool ret) {
588         return lbkTransfer(to, value, "");
589     }
590 
591     function lbkTransfer(address to, uint256 value, string note) public returns (bool ret) {
592         require(to != address(this), "The receive address is the Contact Address of LEGALBLOCK. You cannot send money to this address.");
593 
594         ret = super.transfer(to, value);
595         emit LBKTransfer(msg.sender, to, value, note);
596     }
597 
598     function transferFrom(address from, address to, uint256 value) public returns (bool) {
599         return lbkTransferFrom(from, to, value, "");
600     }
601 
602     function lbkTransferFrom(address from, address to, uint256 value, string note) public returns (bool ret) {
603         require(to != address(this), "The receive address is the Contact Address of LEGALBLOCK. You cannot send money to this address.");
604 
605         ret = super.transferFrom(from, to, value);
606         emit LBKTransferFrom(from, msg.sender, to, value, note);
607     }
608 
609     function approve(address spender, uint256 value) public returns (bool) {
610         return lbkApprove(spender, value, "");
611     }
612 
613     function lbkApprove(address spender, uint256 value, string note) public returns (bool ret) {
614         ret = super.approve(spender, value);
615         emit LBKApproval(msg.sender, spender, value, note);
616     }
617 
618     function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
619         return lbkIncreaseApproval(spender, addedValue, "");
620     }
621 
622     function lbkIncreaseApproval(address spender, uint256 addedValue, string note) public returns (bool ret) {
623         ret = super.increaseApproval(spender, addedValue);
624         emit LBKApproval(msg.sender, spender, allowed[msg.sender][spender], note);
625     }
626 
627     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
628         return lbkDecreaseApproval(spender, subtractedValue, "");
629     }
630 
631     function lbkDecreaseApproval(address spender, uint256 subtractedValue, string note) public returns (bool ret) {
632         ret = super.decreaseApproval(spender, subtractedValue);
633         emit LBKApproval(msg.sender, spender, allowed[msg.sender][spender], note);
634     }
635 
636     /**
637      * dev 신규 화폐 발행. 반드시 이유를 메모로 남겨라.
638      */
639     function mintTo(address to, uint256 amount) internal returns (bool) {
640         require(to != address(0x0), "This address to be set is zero address(0). Check the input address.");
641 
642         totalSupply_ = totalSupply_.add(amount);
643         balances[to] = balances[to].add(amount);
644 
645         emit Transfer(address(0), to, amount);
646         return true;
647     }
648 
649     function lbkMintTo(address to, uint256 amount, string note) onlySuperOwner public returns (bool ret) {
650         ret = mintTo(to, amount);
651         emit LBKMintTo(msg.sender, to, amount, note);
652     }
653 
654     /**
655      * dev 화폐 소각. 반드시 이유를 메모로 남겨라.
656      */
657     function burnFrom(address from, uint256 value) internal returns (bool) {
658         require(value <= balances[from], "Your balance is insufficient.");
659 
660         balances[from] = balances[from].sub(value);
661         totalSupply_ = totalSupply_.sub(value);
662 
663         emit Transfer(from, address(0), value);
664         return true;
665     }
666 
667     function lbkBurnFrom(address from, uint256 value, string note) onlyOwner public returns (bool ret) {
668         ret = burnFrom(from, value);
669         emit LBKBurnFrom(msg.sender, from, value, note);
670     }
671 
672     /**
673      * dev 메인넷으로 이동하며 화폐 소각.
674      */
675     function lbkBurnWhenMoveToMainnet(address burner, uint256 value, string note) onlyOwner public returns (bool ret) {
676         ret = burnFrom(burner, value);
677         emit LBKBurnWhenMoveToMainnet(msg.sender, burner, value, note);
678     }
679 
680     function lbkBatchBurnWhenMoveToMainnet(address[] burners, uint256[] values, string note) onlyOwner public returns (bool ret) {
681         uint256 length = burners.length;
682         require(length == values.length, "The size of \'burners\' and \'values\' array is different.");
683 
684         ret = true;
685         for (uint256 i = 0; i < length; i++) {
686             ret = ret && lbkBurnWhenMoveToMainnet(burners[i], values[i], note);
687         }
688     }
689 
690     /**
691      * dev 이더로 LBK 를 구입하는 경우
692      */
693     function lbkSell(
694         address from,
695         address to,
696         uint256 value,
697         string note
698     ) onlyOwner public returns (bool ret) {
699         require(to != address(this), "The receive address is the Contact Address of LEGALBLOCK. You cannot send money to this address.");
700 
701         ret = super.transferFrom(from, to, value);
702         emit LBKSell(from, msg.sender, to, value, note);
703     }
704 
705     /**
706      * dev 비트코인 등의 다른 코인으로 LBK 를 구입하는 경우
707      * dev EOA 가 트랜잭션을 일으켜서 처리해야 하기 때문에 다계좌를 기준으로 한다. (가스비 아끼기 위함)
708      */
709     function lbkBatchSellByOtherCoin(
710         address from,
711         address[] to,
712         uint256[] values,
713         uint256 processIdHash,
714         uint256[] userIdHash,
715         string note
716     ) onlyOwner public returns (bool ret) {
717         uint256 length = to.length;
718         require(length == values.length, "The size of \'to\' and \'values\' array is different.");
719         require(length == userIdHash.length, "The size of \'to\' and \'userIdHash\' array is different.");
720 
721         ret = true;
722         for (uint256 i = 0; i < length; i++) {
723             require(to[i] != address(this), "The receive address is the Contact Address of LEGALBLOCK. You cannot send money to this address.");
724 
725             ret = ret && super.transferFrom(from, to[i], values[i]);
726             emit LBKSellByOtherCoin(from, msg.sender, to[i], values[i], processIdHash, userIdHash[i], note);
727         }
728     }
729 
730     /**
731      * dev 팀에게 전송하는 경우
732      */
733     function lbkTransferToTeam(
734         address from,
735         address to,
736         uint256 value,
737         string note
738     ) onlyOwner public returns (bool ret) {
739         require(to != address(this), "The receive address is the Contact Address of LEGALBLOCK. You cannot send money to this address.");
740 
741         ret = super.transferFrom(from, to, value);
742         emit LBKTransferToTeam(from, msg.sender, to, value, note);
743     }
744 
745     /**
746      * dev 파트너 및 어드바이저에게 전송하는 경우
747      */
748     function lbkTransferToPartner(
749         address from,
750         address to,
751         uint256 value,
752         string note
753     ) onlyOwner public returns (bool ret) {
754         require(to != address(this), "The receive address is the Contact Address of LEGALBLOCK. You cannot send money to this address.");
755 
756         ret = super.transferFrom(from, to, value);
757         emit LBKTransferToPartner(from, msg.sender, to, value, note);
758     }
759 
760     /**
761      * dev 에코시스템(커뮤니티 활동을 통한 보상 등)으로 LBK 지급
762      * dev EOA 가 트랜잭션을 일으켜서 처리해야 하기 때문에 다계좌를 기준으로 한다. (가스비 아끼기 위함)
763      */
764     function lbkBatchTransferToEcosystem(
765         address from, address[] to,
766         uint256[] values,
767         uint256 processIdHash,
768         uint256[] userIdHash,
769         string note
770     ) onlyOwner public returns (bool ret) {
771         uint256 length = to.length;
772         require(length == values.length, "The size of \'to\' and \'values\' array is different.");
773         require(length == userIdHash.length, "The size of \'to\' and \'userIdHash\' array is different.");
774 
775         ret = true;
776         for (uint256 i = 0; i < length; i++) {
777             require(to[i] != address(this), "The receive address is the Contact Address of LEGALBLOCK. You cannot send money to this address.");
778 
779             ret = ret && super.transferFrom(from, to[i], values[i]);
780             emit LBKTransferToEcosystem(from, msg.sender, to[i], values[i], processIdHash, userIdHash[i], note);
781         }
782     }
783 
784     /**
785      * dev 바운티 참여자에게 LBK 지급
786      * dev EOA 가 트랜잭션을 일으켜서 처리해야 하기 때문에 다계좌를 기준으로 한다. (가스비 아끼기 위함)
787      */
788     function lbkBatchTransferToBounty(
789         address from,
790         address[] to,
791         uint256[] values,
792         uint256 processIdHash,
793         uint256[] userIdHash,
794         string note
795     ) onlyOwner public returns (bool ret) {
796         uint256 length = to.length;
797         require(to.length == values.length, "The size of \'to\' and \'values\' array is different.");
798 
799         ret = true;
800         for (uint256 i = 0; i < length; i++) {
801             require(to[i] != address(this), "The receive address is the Contact Address of LEGALBLOCK. You cannot send money to this address.");
802 
803             ret = ret && super.transferFrom(from, to[i], values[i]);
804             emit LBKTransferToBounty(from, msg.sender, to[i], values[i], processIdHash, userIdHash[i], note);
805         }
806     }
807 
808     function destroy() onlyRoot public {
809         selfdestruct(root);
810     }
811 }
812 
813 /**
814  * @title LEGALBLOCK
815  */
816 contract LEGALBLOCK is LBKBaseToken {
817     using AddressUtils for address;
818 
819     event TransferedToLBKDapp(
820         address indexed owner,
821         address indexed spender,
822         address indexed to, uint256 value, LBKReceiver.LBKReceiveType receiveType);
823 
824     string public constant name = "LEGALBLOCK";
825     string public constant symbol = "LBK";
826     uint8 public constant decimals = 18;
827 
828     uint256 public constant INITIAL_SUPPLY = 15e9 * (10 ** uint256(decimals));
829 
830     constructor() public {
831         totalSupply_ = INITIAL_SUPPLY;
832         balances[msg.sender] = INITIAL_SUPPLY;
833         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
834     }
835 
836     function lbkTransfer(address to, uint256 value, string note) public returns (bool ret) {
837         ret = super.lbkTransfer(to, value, note);
838         postTransfer(msg.sender, msg.sender, to, value, LBKReceiver.LBKReceiveType.LBK_TRANSFER);
839     }
840 
841     function lbkTransferFrom(address from, address to, uint256 value, string note) public returns (bool ret) {
842         ret = super.lbkTransferFrom(from, to, value, note);
843         postTransfer(from, msg.sender, to, value, LBKReceiver.LBKReceiveType.LBK_TRANSFER);
844     }
845 
846     function postTransfer(address owner, address spender, address to, uint256 value, LBKReceiver.LBKReceiveType receiveType) internal returns (bool) {
847         if (to.isContract()) {
848             bool callOk = address(to).call(bytes4(keccak256("onLBKReceived(address,address,uint256,uint8)")), owner, spender, value, receiveType);
849             if (callOk) {
850                 emit TransferedToLBKDapp(owner, spender, to, value, receiveType);
851             }
852         }
853 
854         return true;
855     }
856 
857     function lbkMintTo(address to, uint256 amount, string note) onlySuperOwner public returns (bool ret) {
858         ret = super.lbkMintTo(to, amount, note);
859         postTransfer(0x0, msg.sender, to, amount, LBKReceiver.LBKReceiveType.LBK_MINT);
860     }
861 
862     function lbkBurnFrom(address from, uint256 value, string note) onlyOwner public returns (bool ret) {
863         ret = super.lbkBurnFrom(from, value, note);
864         postTransfer(0x0, msg.sender, from, value, LBKReceiver.LBKReceiveType.LBK_BURN);
865     }
866 }
867 
868 
869 /**
870  * @title LEGALBLOCK Receiver
871  */
872 contract LBKReceiver {
873     enum LBKReceiveType { LBK_TRANSFER, LBK_MINT, LBK_BURN }
874     function onLBKReceived(address owner, address spender, uint256 value, LBKReceiveType receiveType) public returns (bool);
875 }
876 
877 /**
878  * @title LBKDappSample
879  */
880 contract LBKDappSample is LBKReceiver {
881     event LogOnReceiveLBK(string message, address indexed owner, address indexed spender, uint256 value, LBKReceiveType receiveType);
882 
883     function onLBKReceived(address owner, address spender, uint256 value, LBKReceiveType receiveType) public returns (bool) {
884         emit LogOnReceiveLBK("I receive LEGALBLOCK.", owner, spender, value, receiveType);
885         return true;
886     }
887 }