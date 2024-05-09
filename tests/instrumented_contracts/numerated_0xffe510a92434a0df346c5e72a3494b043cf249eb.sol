1 pragma solidity >0.4.99 <0.6.0;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 /**
10  * @title ERC20 interface
11  * @dev see https://github.com/ethereum/EIPs/issues/20
12  */
13 contract ERC20 is ERC20Basic {
14     function allowance(address owner, address spender)
15         public view returns (uint256);
16 
17     function transferFrom(address from, address to, uint256 value)
18         public returns (bool);
19 
20     function approve(address spender, uint256 value) public returns (bool);
21     
22     event Approval(
23         address indexed owner,
24         address indexed spender,
25         uint256 value
26     );
27 }
28 
29 library SafeERC20 {
30     function safeTransfer(
31         ERC20Basic _token,
32         address _to,
33         uint256 _value
34     ) internal
35     {
36         require(_token.transfer(_to, _value));
37     }
38 
39     function safeTransferFrom(
40         ERC20 _token,
41         address _from,
42         address _to,
43         uint256 _value
44     ) internal
45     {
46         require(_token.transferFrom(_from, _to, _value));
47     }
48 
49     function safeApprove(
50         ERC20 _token,
51         address _spender,
52         uint256 _value
53     ) internal
54     {
55         require(_token.approve(_spender, _value));
56     }
57 }
58 
59 library SafeMath {
60 	/**
61     * @dev Multiplies two numbers, throws on overflow.
62     */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
64 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
65 		// benefit is lost if 'b' is also tested.
66 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67         if(a == 0) {
68             return 0;
69 		}
70         c = a * b;
71         assert(c / a == b);
72         return c;
73     }
74 
75 	/**
76 	* @dev Integer division of two numbers, truncating the quotient.
77 	*/
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79 		// assert(b > 0); // Solidity automatically throws when dividing by 0
80 		// uint256 c = a / b;
81 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
82         return a / b;
83     }
84 
85 	/**
86 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
87 	*/
88     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89         assert(b <= a);
90         return a - b;
91     }
92 	/**
93     * @dev Adds two numbers, throws on overflow.
94     */
95     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
96         c = a + b;
97         assert(c >= a);
98         return c;
99     }
100 }
101 
102 
103 
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  */
108 contract BasicToken is ERC20Basic {
109     using SafeMath for uint256;
110     
111     mapping(address => uint256) balances;
112     
113     uint256 totalSupply_;
114 
115     /**
116     * @dev Total number of tokens in existence
117     */
118     function totalSupply() public view returns (uint256) {
119         return totalSupply_;
120     }
121     /**
122     * @dev Transfer token for a specified address
123     * @param _to The address to transfer to.
124     * @param _value The amount to be transferred.
125     */
126     function transfer(address _to, uint256 _value) public returns (bool) {
127         require(_to != address(0));
128         require(_value <= balances[msg.sender]);
129         balances[msg.sender] = balances[msg.sender].sub(_value);
130         balances[_to] = balances[_to].add(_value);
131         
132         emit Transfer(msg.sender, _to, _value);
133         
134         return true;
135     }
136 
137 	/**
138     * @dev Gets the balance of the specified address.
139     * @param _owner The address to query the the balance of.
140     * @return An uint256 representing the amount owned by the passed address.
141     */
142     function balanceOf(address _owner) public view returns (uint256) {
143         return balances[_owner];
144     }
145 }
146 
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * https://github.com/ethereum/EIPs/issues/20
153  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  */
155 contract StandardToken is ERC20, BasicToken {
156 
157     mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160     /**
161     * @dev Transfer tokens from one address to another
162     * @param _from address The address which you want to send tokens from
163     * @param _to address The address which you want to transfer to
164     * @param _value uint256 the amount of tokens to be transferred
165     */
166     function transferFrom (
167         address _from,
168         address _to,
169         uint256 _value
170     ) public returns (bool)
171     {
172         require(_to != address(0));
173         require(_value <= balances[_from]);
174         require(_value <= allowed[_from][msg.sender]);
175         balances[_from] = balances[_from].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
178         
179         emit Transfer(_from, _to, _value);
180         
181         return true;
182     }
183 
184     /**
185     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186     * Beware that changing an allowance with this method brings the risk that someone may use both the old
187     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190     * @param _spender The address which will spend the funds.
191     * @param _value The amount of tokens to be spent.
192     */
193     function approve(address _spender, uint256 _value) public returns (bool) {
194         allowed[msg.sender][_spender] = _value;
195         
196         emit Approval(msg.sender, _spender, _value);
197         
198         return true;
199     }
200 
201     /**
202     * @dev Function to check the amount of tokens that an owner allowed to a spender.
203     * @param _owner address The address which owns the funds.
204     * @param _spender address The address which will spend the funds.
205     * @return A uint256 specifying the amount of tokens still available for the spender.
206     */
207     function allowance (
208         address _owner,
209         address _spender
210 	)
211 		public
212 		view
213 		returns (uint256)
214 	{
215         return allowed[_owner][_spender];
216     }
217 
218 	/**
219     * @dev Increase the amount of tokens that an owner allowed to a spender.
220     * approve should be called when allowed[_spender] == 0. To increment
221     * allowed value is better to use this function to avoid 2 calls (and wait until
222     * the first transaction is mined)
223     * From MonolithDAO Token.sol
224     * @param _spender The address which will spend the funds.
225     * @param _addedValue The amount of tokens to increase the allowance by.
226     */
227     function increaseApproval(
228         address _spender,
229         uint256 _addedValue
230 	)
231 		public
232 		returns (bool)
233 	{
234         allowed[msg.sender][_spender] = (
235         allowed[msg.sender][_spender].add(_addedValue));
236         
237         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238         
239         return true;
240     }
241 
242 	/**
243     * @dev Decrease the amount of tokens that an owner allowed to a spender.
244     * approve should be called when allowed[_spender] == 0. To decrement
245     * allowed value is better to use this function to avoid 2 calls (and wait until
246     * the first transaction is mined)
247     * From MonolithDAO Token.sol
248     * @param _spender The address which will spend the funds.
249     * @param _subtractedValue The amount of tokens to decrease the allowance by.
250     */
251     function decreaseApproval(
252         address _spender,
253         uint256 _subtractedValue
254 	) public returns (bool)
255 	{
256         uint256 oldValue = allowed[msg.sender][_spender];
257         if (_subtractedValue > oldValue) {
258             allowed[msg.sender][_spender] = 0;
259 		} else {
260             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261 		}
262         
263         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264         
265         return true;
266     }
267 }
268 /**
269  * @title MultiOwnable
270  *
271  * @dev LBXC의 MultiOwnable은 히든오너, 수퍼오너, 버너, 오너, 리클레이머를 설정한다. 권한을 여러명에게 부여할 수 있는 경우
272  * 리스트에 그 값을 넣어 불특정 다수가 확인 할 수 있게 한다.
273  *
274  * LBXC的MultiOwnable可设置HIDDENOWNER，SUPEROWNER，BURNER，OWNER及RECLAIMER。
275  * 其权限可同时赋予多人的情况，在列表中放入该值后可确认其非特定的多人名单。
276  *
277  * MulitOwnable of LBXC sets HIDDENOWNER, SUPEROWNER, BURNER, OWNER, and RECLAIMER. 
278  * If many can be authorized, the value is entered to the list so that it is accessible to unspecified many.
279  *
280  */
281 contract MultiOwnable {
282     uint8 constant MAX_BURN = 3;
283     uint8 constant MAX_OWNER = 15;
284     address payable public hiddenOwner;
285     address payable public superOwner;
286     address payable public reclaimer;
287 
288     address[MAX_BURN] public chkBurnerList;
289     address[MAX_OWNER] public chkOwnerList;
290     
291     mapping(address => bool) public burners;
292     mapping (address => bool) public owners;
293     
294     event AddedBurner(address indexed newBurner);
295     event AddedOwner(address indexed newOwner);
296     event DeletedOwner(address indexed toDeleteOwner);
297     event DeletedBurner(address indexed toDeleteBurner);
298     event ChangedReclaimer(address indexed newReclaimer);
299     event ChangedSuperOwner(address indexed newSuperOwner);
300     event ChangedHiddenOwner(address indexed newHiddenOwner);
301 
302     constructor() public {
303         hiddenOwner = msg.sender;
304         superOwner = msg.sender;
305         reclaimer = msg.sender;
306         owners[msg.sender] = true;
307         chkOwnerList[0] = msg.sender;
308     }
309 
310     modifier onlySuperOwner() {
311         require(superOwner == msg.sender);
312         _;
313     }
314     modifier onlyReclaimer() {
315         require(reclaimer == msg.sender);
316         _;
317     }
318     modifier onlyHiddenOwner() {
319         require(hiddenOwner == msg.sender);
320         _;
321     }
322     modifier onlyOwner() {
323         require(owners[msg.sender]);
324         _;
325     }
326     modifier onlyBurner(){
327         require(burners[msg.sender]);
328         _;
329     }
330 
331     function changeSuperOwnership(address payable newSuperOwner) public onlyHiddenOwner returns(bool) {
332         require(newSuperOwner != address(0));
333         superOwner = newSuperOwner;
334         
335         emit ChangedSuperOwner(superOwner);
336         
337         return true;
338     }
339     
340     function changeHiddenOwnership(address payable newHiddenOwner) public onlyHiddenOwner returns(bool) {
341         require(newHiddenOwner != address(0));
342         hiddenOwner = newHiddenOwner;
343         
344         emit ChangedHiddenOwner(hiddenOwner);
345         
346         return true;
347     }
348     function changeReclaimer(address payable newReclaimer) public onlySuperOwner returns(bool) {
349         require(newReclaimer != address(0));
350         reclaimer = newReclaimer;
351         
352         emit ChangedReclaimer(reclaimer);
353         
354         return true;
355     }
356     function addBurner(address burner, uint8 num) public onlySuperOwner returns (bool) {
357         require(num < MAX_BURN);
358         require(burner != address(0));
359         require(chkBurnerList[num] == address(0));
360         require(burners[burner] == false);
361 
362         burners[burner] = true;
363         chkBurnerList[num] = burner;
364         
365         emit AddedBurner(burner);
366         
367         return true;
368     }
369 
370     function deleteBurner(address burner, uint8 num) public onlySuperOwner returns (bool){
371         require(num < MAX_BURN);
372         require(burner != address(0));
373         require(chkBurnerList[num] == burner);
374         
375         burners[burner] = false;
376 
377         chkBurnerList[num] = address(0);
378         
379         emit DeletedBurner(burner);
380         
381         return true;
382     }
383 
384     function addOwner(address owner, uint8 num) public onlySuperOwner returns (bool) {        
385         require(num < MAX_OWNER);
386         require(owner != address(0));
387         require(chkOwnerList[num] == address(0));
388         require(owners[owner] == false);
389         
390         owners[owner] = true;
391         chkOwnerList[num] = owner;
392         
393         emit AddedOwner(owner);
394         
395         return true;
396     }
397 
398     function deleteOwner(address owner, uint8 num) public onlySuperOwner returns (bool) {
399         require(num < MAX_OWNER);
400         require(owner != address(0));
401         require(chkOwnerList[num] == owner);
402         owners[owner] = false;
403         chkOwnerList[num] = address(0);
404         
405         emit DeletedOwner(owner);
406         
407         return true;
408     }
409 }
410 
411 /**
412  * @title HasNoEther
413  */
414 contract HasNoEther is MultiOwnable {
415     using SafeERC20 for ERC20Basic;
416 
417     event ReclaimToken(address _token);
418     
419     /**
420     * @dev Constructor that rejects incoming Ether
421     * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
422     * leave out payable, then Solidity will allow inheriting contracts to implement a payable
423     * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
424     * we could use assembly to access msg.value.
425     */
426     constructor() public payable {
427         require(msg.value == 0);
428     }
429     /**
430     * @dev Disallows direct send by settings a default function without the `payable` flag.
431     */
432     function() external {
433     }
434     
435 
436     function reclaimToken(ERC20Basic _token) external onlyReclaimer returns(bool){
437         
438         uint256 balance = _token.balanceOf(address(this));
439 
440         _token.safeTransfer(superOwner, balance);
441         
442         emit ReclaimToken(address(_token));
443     
444         
445         return true;
446     }
447 
448 }
449 
450 contract Blacklist is MultiOwnable {
451 
452     mapping(address => bool) blacklisted;
453 
454     event Blacklisted(address indexed blacklist);
455     event Whitelisted(address indexed whitelist);
456     
457     modifier whenPermitted(address node) {
458         require(!blacklisted[node]);
459         _;
460     }
461     
462     function isPermitted(address node) public view returns (bool) {
463         return !blacklisted[node];
464     }
465 
466     function blacklist(address node) public onlyOwner returns (bool) {
467         require(!blacklisted[node]);
468         blacklisted[node] = true;
469         emit Blacklisted(node);
470 
471         return blacklisted[node];
472     }
473    
474     function unblacklist(address node) public onlySuperOwner returns (bool) {
475         require(blacklisted[node]);
476         blacklisted[node] = false;
477         emit Whitelisted(node);
478 
479         return blacklisted[node];
480     }
481 }
482 
483 contract Burnlist is Blacklist {
484     mapping(address => bool) public isburnlist;
485 
486     event Burnlisted(address indexed burnlist, bool signal);
487 
488     modifier isBurnlisted(address who) {
489         require(isburnlist[who]);
490         _;
491     }
492 
493     function addBurnlist(address node) public onlyOwner returns (bool) {
494         require(!isburnlist[node]);
495         
496         isburnlist[node] = true;
497         
498         emit Burnlisted(node, true);
499         
500         return isburnlist[node];
501     }
502 
503     function delBurnlist(address node) public onlyOwner returns (bool) {
504         require(isburnlist[node]);
505         
506         isburnlist[node] = false;
507         
508         emit Burnlisted(node, false);
509         
510         return isburnlist[node];
511     }
512 }
513 
514 
515 contract PausableToken is StandardToken, HasNoEther, Burnlist {
516     
517     uint8 constant MAX_LOCKER = 10;
518     bool public paused = false;
519     bool public timelock = false;
520     uint256 public openingTime;
521     address[MAX_LOCKER] public chkLockerList;
522 
523     mapping(address => bool) public lockerAddrs;
524     mapping(address => uint256) public lockValues;
525 
526     event SetLockValues(address addr, uint256 value);
527     event OnTimeLock(address who);
528     event OffTimeLock(address who);
529     event Paused(address addr);
530     event Unpaused(address addr);
531     event AddLocker(address addr);
532     event DelLocker(address addr);
533     event OpenedTime();
534 
535     constructor() public {
536         openingTime = block.timestamp;
537     }
538     
539     modifier whenNotPaused() {
540         require(!paused || owners[msg.sender]);
541         _;
542     }
543 
544     function addLocker (address locker, uint8 num) public onlySuperOwner returns (bool) {
545         require(num < MAX_LOCKER);
546         require(locker != address(0));
547         require(!lockerAddrs[locker]);
548         require(chkLockerList[num] == address(0));
549 
550         chkLockerList[num] = locker;
551         lockerAddrs[locker] = true;
552         
553         emit AddLocker(locker);
554 
555         return lockerAddrs[locker];
556     }
557 
558     function delLocker (address locker, uint8 num) public onlySuperOwner returns (bool) {
559         require(num < MAX_LOCKER);
560         require(locker != address(0));
561         require(lockerAddrs[locker]);
562         require(chkLockerList[num] == locker);
563 
564         chkLockerList[num] = address(0);
565         lockerAddrs[locker] = false;
566 
567         emit DelLocker(locker);
568 
569         return lockerAddrs[locker];
570     }
571    
572     function pause() public onlySuperOwner returns (bool) {
573         require(!paused);
574 
575         paused = true;
576         
577         emit Paused(msg.sender);
578 
579         return paused;
580     }
581 
582     function unpause() public onlySuperOwner returns (bool) {
583         require(paused);
584 
585         paused = false;
586         
587         emit Unpaused(msg.sender);
588 
589         return paused;
590     }
591 
592     function onTimeLock() public onlySuperOwner returns (bool) {
593         require(!timelock);
594         timelock = true;
595         emit OnTimeLock(msg.sender);
596         
597         return timelock;
598     }
599 
600     function offTimeLock() public onlySuperOwner returns (bool) {
601         require(timelock);
602         timelock = false;
603         emit OffTimeLock(msg.sender);
604         
605         return timelock;
606     }
607 
608     function transfer(address to, uint256 value) public whenNotPaused whenPermitted(msg.sender) returns (bool) {
609         
610         //时间锁定的情况
611         //타임락인경우 
612         //when it is timelock
613         if(timelock) {  
614 
615             //msg.sender为lockerAddrs的情况，接收者将更新被锁定的额度状态。
616             //msg.sender가 lockerAddrs인 경우, 받은 사용자의 락된 발란스 상태를 업데이트해준다.
617             //when msg.sender is lockerAddrs, the recipient’s locked balance is updated.
618             if(lockerAddrs[msg.sender]) {
619                 
620                 //lockerAddrs向to发送的情况，最初金额将成为lockValues。
621 				//lockerAddrs가 to에게 보내는 경우, 최초의 금액이 lockValues가 된다.
622                 //when lockerAddrs sends to to, the initial amount becomes lockValues.
623                 if(lockValues[to] == 0) {
624                     lockValues[to] = value;
625                     
626                     emit SetLockValues(to, value);
627 				}
628 
629                 return super.transfer(to, value);
630            	
631             //发送者为非lockerAddrs的情况，
632 			//보내는 사람이 lockerAddrs가 아닌 경우
633             //when sender is not lockerAddrs
634 			} else {
635                 
636                 //发送者为非lockerAddrs，且存在lockValues的情况
637 				//보내는 사람이 lockerAddrs가 아니며, lockValues가 있는 경우 
638                 //when sender is not lockerAddrs, and has lockValues
639                 if(lockValues[msg.sender] > 0) {
640 
641                     uint256 _totalAmount = balances[msg.sender];
642 
643                     uint256 lockValue = lockValues[msg.sender].div(5);
644                     
645                     //需大于总价值value的限额（总锁定金额 - 已解锁金额）。
646                     //전체 값의 value를 제한 금액이 (전체 락된 금액 - 제한이 풀린 금액)보다 커야한다.
647                     //the amount after subtracting the total value must be greater than (total locked amount – unlocked amount).
648                     require(_totalAmount.sub(value) >= lockValues[msg.sender].sub(lockValue * _timeLimit()));
649 
650                     return super.transfer(to, value);            
651 				
652                 //发送者为非lockerAddrs，且不存在lockValues的情况
653                 //보내는 사람이 lockerAddrs가 아니며, lockValues가 없는 경우
654                 //when sender is not lockerAddrs, and has no lockValues
655                 } else {	 
656                     return super.transfer(to, value);
657                 }
658 			}
659         
660         //非时间锁定的情况
661         //타임락이 아닌 경우 
662         //when it not timelock
663         } else {
664             return super.transfer(to, value);
665         }
666     }
667 
668     function transferFrom(address from, address to, uint256 value) public 
669     whenNotPaused whenPermitted(from) whenPermitted(msg.sender) returns (bool) {
670         require(!lockerAddrs[from]);
671 
672         if(timelock) { 
673             
674             //lockValues[from]大于0的情况
675 			//lockValues[from]이 0보다 큰 경우
676             //when lockValues[from] is greater than 0
677             if(lockValues[from] > 0) {
678                 
679                 uint256 _totalAmount = balances[from];
680                 
681                 uint256 lockValue = lockValues[from].div(5);
682                 
683                 require(_totalAmount.sub(value) >= lockValues[from].sub(lockValue * _timeLimit()));
684 
685                 return super.transferFrom(from, to, value);
686 			
687             //lockValues[from]不存在的情况
688             //lockValues[from]가 없는 경우
689             //when there is no lockValues[from]
690 			} else {
691                 return super.transferFrom(from, to, value);
692             }
693         
694         } else {
695             return super.transferFrom(from, to, value);
696 		}
697     }
698 
699     function _timeLimit() internal view returns (uint256) {
700         uint256 presentTime = block.timestamp;
701         uint256 timeValue = presentTime.sub(openingTime);
702         uint256 _result = timeValue.div(31 days);
703         _result = _result.add(1);
704 
705         return _result;
706     }
707 
708     function setOpeningTime() public onlyHiddenOwner returns(bool) {
709         
710         openingTime = block.timestamp;
711         
712         emit OpenedTime();
713         
714         return true;
715     }
716 
717     function getLimitPeriod() external view returns (uint256) {
718         uint256 presentTime = block.timestamp;
719         uint256 timeValue = presentTime.sub(openingTime);
720         uint256 result = timeValue.div(31 days);
721         result = result.add(1);
722         return result;
723     }  
724     
725     function setLockValue(address to, uint256 value) public onlyOwner returns (bool) {    
726         lockValues[to] = value;
727         
728         emit SetLockValues(to, value);
729         
730         return true;
731     }
732 }
733 /**
734  * @title LBXC
735  *
736  */
737 contract LBXC is PausableToken {
738     
739     event Burn(address indexed burner, uint256 value);
740     event Mint(address indexed minter, uint256 value);
741 
742     string public constant name = "LUXBIO CELL";
743     uint8 public constant decimals = 18;
744     string public constant symbol = "LBXC";
745     uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals)); 
746 
747     constructor() public {
748         totalSupply_ = INITIAL_SUPPLY;
749         balances[msg.sender] = INITIAL_SUPPLY;
750         
751         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
752     }
753 
754     function destory() public onlyHiddenOwner returns (bool) {
755         
756         selfdestruct(superOwner);
757 
758         return true;
759     }
760     /**
761 	* @dev LBXC의 민트는 오직 히든오너만 실행 가능하며, 수퍼오너에게 귀속된다. 
762     * 추가로 발행하려는 토큰과 기존 totalSupply_의 합이 최초 발행된 토큰의 양(INITIAL_SUPPLY)보다 클 수 없다.
763 	*
764     * LBXC的MINT只能由HIDDENOWNER进行执行，其所有权归SUPEROWNER所有。
765     * 追加进行发行的数字货币与totalSupply_的和不可大于最初发行的数字货币(INITIAL_SUPPLY)数量。
766     *
767     * Only the Hiddenowner can mint LBXC, and the minted is reverted to SUPEROWNER.
768     * The sum of additional tokens to be issued and 
769     * the existing totalSupply_ cannot be greater than the initially issued token supply(INITIAL_SUPPLY).
770     */
771     function mint(uint256 _amount) public onlyHiddenOwner returns (bool) {
772         
773         require(INITIAL_SUPPLY >= totalSupply_.add(_amount));
774         
775         totalSupply_ = totalSupply_.add(_amount);
776         
777         balances[superOwner] = balances[superOwner].add(_amount);
778 
779         emit Mint(superOwner, _amount);
780         
781         emit Transfer(address(0), superOwner, _amount);
782         
783         return true;
784     }
785 
786     /**
787 	* @dev LBXC의 번은 오직 버너만 실행 가능하며, Owner가 등록할 수 있는 Burnlist에 등록된 계정만 토큰 번 할 수 있다.
788     * 
789     * LBXC的BURN只能由BURNER进行执行，OWNER只有登记在Burnlist的账户才能对数字货币执行BURN。
790     *
791     * Only the BURNER can burn LBXC, 
792     * and only the tokens that can be burned are those on Burnlist account that Owner can register.
793     */
794     function burn(address _to,uint256 _value) public onlyBurner isBurnlisted(_to) returns(bool) {
795         
796         _burn(_to, _value);
797 		
798         return true;
799     }
800 
801     function _burn(address _who, uint256 _value) internal returns(bool){     
802         require(_value <= balances[_who]);
803         
804 
805         balances[_who] = balances[_who].sub(_value);
806         totalSupply_ = totalSupply_.sub(_value);
807     
808         emit Burn(_who, _value);
809         emit Transfer(_who, address(0), _value);
810 		
811         return true;
812     }
813 }