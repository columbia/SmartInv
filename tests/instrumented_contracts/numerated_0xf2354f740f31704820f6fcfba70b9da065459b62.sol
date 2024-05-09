1 /**
2  *Submitted for verification at Etherscan.io on 2019-01-31
3 */
4 pragma solidity >0.4.99 <0.6.0;
5 
6 contract Context {
7   function _msgSender() internal view returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 contract ERC20Basic {
13     function totalSupply() public view returns (uint256);
14     function balanceOf(address who) public view returns (uint256);
15     function transfer(address to, uint256 value) public returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 /**
19  * @title ERC20 interface
20  * @dev see https://github.com/ethereum/EIPs/issues/20
21  */
22 contract ERC20 is ERC20Basic {
23     function allowance(address owner, address spender)
24         public view returns (uint256);
25 
26     function transferFrom(address from, address to, uint256 value)
27         public returns (bool);
28 
29     function approve(address spender, uint256 value) public returns (bool);
30     
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 library SafeERC20 {
39     function safeTransfer(
40         ERC20Basic _token,
41         address _to,
42         uint256 _value
43     ) internal
44     {
45         require(_token.transfer(_to, _value));
46     }
47 
48     function safeTransferFrom(
49         ERC20 _token,
50         address _from,
51         address _to,
52         uint256 _value
53     ) internal
54     {
55         require(_token.transferFrom(_from, _to, _value));
56     }
57 
58     function safeApprove(
59         ERC20 _token,
60         address _spender,
61         uint256 _value
62     ) internal
63     {
64         require(_token.approve(_spender, _value));
65     }
66 }
67 
68 library SafeMath {
69 	/**
70     * @dev Multiplies two numbers, throws on overflow.
71     */
72     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
73 		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
74 		// benefit is lost if 'b' is also tested.
75 		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
76         if(a == 0) {
77             return 0;
78 		}
79         c = a * b;
80         assert(c / a == b);
81         return c;
82     }
83 
84 	/**
85 	* @dev Integer division of two numbers, truncating the quotient.
86 	*/
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88 		// assert(b > 0); // Solidity automatically throws when dividing by 0
89 		// uint256 c = a / b;
90 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
91         return a / b;
92     }
93 
94 	/**
95 	* @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96 	*/
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         assert(b <= a);
99         return a - b;
100     }
101 	/**
102     * @dev Adds two numbers, throws on overflow.
103     */
104     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
105         c = a + b;
106         assert(c >= a);
107         return c;
108     }
109 }
110 
111 
112 
113 /**
114  * @title Basic token
115  * @dev Basic version of StandardToken, with no allowances.
116  */
117 contract BasicToken is ERC20Basic, Context {
118     using SafeMath for uint256;
119     
120     mapping(address => uint256) balances;
121     
122     uint256 totalSupply_;
123 
124     /**
125     * @dev Total number of tokens in existence
126     */
127     function totalSupply() public view returns (uint256) {
128         return totalSupply_;
129     }
130     /**
131     * @dev Transfer token for a specified address
132     * @param _to The address to transfer to.
133     * @param _value The amount to be transferred.
134     */
135     function transfer(address _to, uint256 _value) public returns (bool) {
136         require(_to != address(0),"[transfer]is not valid address");
137         require(_value <= balances[_msgSender()], "[transfer]value is too much");
138         balances[_msgSender()] = balances[_msgSender()].sub(_value);
139         balances[_to] = balances[_to].add(_value);
140         
141         emit Transfer(msg.sender, _to, _value);
142         
143         return true;
144     }
145 
146 	/**
147     * @dev Gets the balance of the specified address.
148     * @param _owner The address to query the the balance of.
149     * @return An uint256 representing the amount owned by the passed address.
150     */
151     function balanceOf(address _owner) public view returns (uint256) {
152         return balances[_owner];
153     }
154 }
155 
156 
157 /**
158  * @title Standard ERC20 token
159  *
160  * @dev Implementation of the basic standard token.
161  * https://github.com/ethereum/EIPs/issues/20
162  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
163  */
164 contract StandardToken is ERC20, BasicToken {
165 
166     mapping (address => mapping (address => uint256)) internal allowed;
167 
168 
169     /**
170     * @dev Transfer tokens from one address to another
171     * @param _from address The address which you want to send tokens from
172     * @param _to address The address which you want to transfer to
173     * @param _value uint256 the amount of tokens to be transferred
174     */
175     function transferFrom (
176         address _from,
177         address _to,
178         uint256 _value
179     ) public returns (bool)
180     {
181         require(_to != address(0));
182         require(_value <= balances[_from]);
183         require(_value <= allowed[_from][_msgSender()]);
184         balances[_from] = balances[_from].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         allowed[_from][_msgSender()] = allowed[_from][_msgSender()].sub(_value);
187         
188         emit Transfer(_from, _to, _value);
189         
190         return true;
191     }
192 
193     /**
194     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195     * Beware that changing an allowance with this method brings the risk that someone may use both the old
196     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199     * @param _spender The address which will spend the funds.
200     * @param _value The amount of tokens to be spent.
201     */
202     function approve(address _spender, uint256 _value) public returns (bool) {
203         allowed[_msgSender()][_spender] = _value;
204         
205         emit Approval(_msgSender(), _spender, _value);
206         
207         return true;
208     }
209 
210     /**
211     * @dev Function to check the amount of tokens that an owner allowed to a spender.
212     * @param _owner address The address which owns the funds.
213     * @param _spender address The address which will spend the funds.
214     * @return A uint256 specifying the amount of tokens still available for the spender.
215     */
216     function allowance (
217         address _owner,
218         address _spender
219 	)
220 		public
221 		view
222 		returns (uint256)
223 	{
224         return allowed[_owner][_spender];
225     }
226 
227 	/**
228     * @dev Increase the amount of tokens that an owner allowed to a spender.
229     * approve should be called when allowed[_spender] == 0. To increment
230     * allowed value is better to use this function to avoid 2 calls (and wait until
231     * the first transaction is mined)
232     * From MonolithDAO Token.sol
233     * @param _spender The address which will spend the funds.
234     * @param _addedValue The amount of tokens to increase the allowance by.
235     */
236     function increaseApproval(
237         address _spender,
238         uint256 _addedValue
239 	)
240 		public
241 		returns (bool)
242 	{
243         allowed[_msgSender()][_spender] = (
244         allowed[_msgSender()][_spender].add(_addedValue));
245         
246         emit Approval(_msgSender(), _spender, allowed[_msgSender()][_spender]);
247         
248         return true;
249     }
250 
251 	/**
252     * @dev Decrease the amount of tokens that an owner allowed to a spender.
253     * approve should be called when allowed[_spender] == 0. To decrement
254     * allowed value is better to use this function to avoid 2 calls (and wait until
255     * the first transaction is mined)
256     * From MonolithDAO Token.sol
257     * @param _spender The address which will spend the funds.
258     * @param _subtractedValue The amount of tokens to decrease the allowance by.
259     */
260     function decreaseApproval(
261         address _spender,
262         uint256 _subtractedValue
263 	) public returns (bool)
264 	{
265         uint256 oldValue = allowed[_msgSender()][_spender];
266         if (_subtractedValue > oldValue) {
267             allowed[_msgSender()][_spender] = 0;
268 		} else {
269             allowed[_msgSender()][_spender] = oldValue.sub(_subtractedValue);
270 		}
271         
272         emit Approval(_msgSender(), _spender, allowed[_msgSender()][_spender]);
273         
274         return true;
275     }
276 }
277 
278 contract MultiOwnable {
279     uint8 constant MAX_BURN = 3;
280     uint8 constant MAX_OWNER = 15;
281     uint8 constant MAX_JUDGE = 3;
282     address payable public hiddenOwner;
283     address payable public superOwner;
284     address payable public reclaimer;
285     address payable public tokenManager;
286     address payable public withdrawalWallet;
287     address payable public bank;
288     address[MAX_JUDGE] public chkJudgeList;
289     address[MAX_BURN] public chkBurnerList;
290     address[MAX_OWNER] public chkOwnerList;
291 
292     mapping(address => bool) public judges;
293     mapping(address => bool) public depositWallet;
294     mapping(address => bool) public burners;
295     mapping (address => bool) public owners;
296 
297     event AddedBurner(address indexed newBurner);
298     event AddedOwner(address indexed newOwner);
299     event DeletedOwner(address indexed toDeleteOwner);
300     event DeletedBurner(address indexed toDeleteBurner);
301     event ChangedReclaimer(address indexed newReclaimer);
302     event ChangedBank(address indexed newBank);
303     event ChangedSuperOwner(address indexed newSuperOwner);
304     event ChangedHiddenOwner(address indexed newHiddenOwner);
305     event ChangedTokenManager(address indexed newTokenManager);
306     event ChangedWithdrawalWallet(address indexed newWithdrawalWallet);
307     event SetDepositWallet(address indexed _wallet);
308     event DelDepositWallet(address indexed _wallet);
309     event AddedJudge(address indexed _newJudge, uint8 _number);
310     event DeletedJudge(address indexed _newJudge, uint8 _number);
311 
312     constructor() public {
313         hiddenOwner = msg.sender;
314         superOwner = msg.sender;
315         reclaimer = msg.sender;
316         owners[msg.sender] = true;
317         chkOwnerList[0] = msg.sender;
318         withdrawalWallet = msg.sender;
319     }
320 
321     modifier onlySuperOwner() {
322         require(superOwner == msg.sender, "[mdf]is not SuperOwner");
323         _;
324     }
325 
326     modifier onlyJudge(address _from) {
327         require(judges[_from] == true, "[mdf]is not Judge");
328         _;
329     }
330 
331     modifier onlyBank() {
332         require(bank == msg.sender);
333         _;
334     }
335     modifier onlyNotBank(address _from) {
336         require(bank != _from);
337         _;
338     }
339 
340     modifier onlyReclaimer() {
341         require(reclaimer == msg.sender, "[mdf]is not Reclaimer");
342         _;
343     }
344 
345     modifier onlyHiddenOwner() {
346         require(hiddenOwner == msg.sender, "[mdf]is not HiddenOwner");
347         _;
348     }
349 
350     modifier onlyOwner() {
351         require(owners[msg.sender], "[mdf]is not Owner");
352         _;
353     }
354 
355     modifier onlyBurner(){
356         require(burners[msg.sender], "[mdf]is not Burner");
357         _;
358     }
359 
360     modifier onlyDepositWallet(address _who) {
361       require(depositWallet[_who] == true, "[mdf]is not DepositWallet");
362       _;
363     }
364 
365     modifier onlyNotDepositWallet(address _who) {
366       require(depositWallet[_who] == false, "[mdf]is DepositWallet");
367       _;
368     }
369 
370     modifier onlyTokenManager() {
371       require(msg.sender == tokenManager, "[mdf]is not tokenManager");
372       _;
373     }
374 
375     modifier onlyNotwWallet() {
376       require(msg.sender != withdrawalWallet, "[mdf]is withdrawalWallet");
377       _;
378     }
379 
380     function transferWithdrawalWallet(address payable _wallet) public onlySuperOwner returns (bool) {
381         
382         require(withdrawalWallet != _wallet);
383         
384         withdrawalWallet = _wallet;
385         
386         emit ChangedWithdrawalWallet(_wallet);
387         
388         return true;
389         
390     }
391 
392     function transferTokenManagerRole(address payable _newTokenManager) public onlySuperOwner returns (bool) {
393         require(tokenManager != _newTokenManager);
394 
395         tokenManager = _newTokenManager;
396 
397         emit ChangedTokenManager(_newTokenManager);
398 
399         return true;
400     }
401 
402     function transferBankOwnership(address payable _newBank) public onlySuperOwner returns (bool) {
403         
404         require(bank != _newBank);
405         
406         bank = _newBank;
407         
408         emit ChangedBank(_newBank);
409         
410         return true;
411         
412     }
413 
414     function addJudge(address _newJudge, uint8 _num) public onlySuperOwner returns (bool) {
415         require(_num < MAX_JUDGE);
416         require(_newJudge != address(0));
417         require(chkJudgeList[_num] == address(0));
418         require(judges[_newJudge] == false);
419 
420         judges[_newJudge] = true;
421         chkJudgeList[_num] = _newJudge;
422         
423         emit AddedJudge(_newJudge, _num);
424         
425         return true;
426     }
427 
428     function deleteJudge(address _toDeleteJudge, uint8 _num) public
429     onlySuperOwner returns (bool) {
430         require(_num < MAX_JUDGE);
431         require(_toDeleteJudge != address(0));
432         require(chkJudgeList[_num] == _toDeleteJudge);
433         
434         judges[_toDeleteJudge] = false;
435 
436         chkJudgeList[_num] = address(0);
437         
438         emit DeletedJudge(_toDeleteJudge, _num);
439         
440         return true;
441     }
442 
443     function setDepositWallet(address _depositWallet) public
444     onlyTokenManager returns (bool) {
445         
446         require(depositWallet[_depositWallet] == false);
447         
448         depositWallet[_depositWallet] = true;
449         
450         emit SetDepositWallet(_depositWallet);
451         
452         return true;
453     }
454 
455     function delDepositWallet(address _depositWallet) public
456     onlyTokenManager returns (bool) {
457         
458         require(depositWallet[_depositWallet] == true);
459         
460         depositWallet[_depositWallet] = false;
461         
462         emit DelDepositWallet(_depositWallet);
463         
464         return true;
465     }
466 
467     function changeSuperOwnership(address payable newSuperOwner) public onlyHiddenOwner returns(bool) {
468         require(newSuperOwner != address(0));
469         
470         superOwner = newSuperOwner;
471         
472         emit ChangedSuperOwner(superOwner);
473         
474         return true;
475     }
476     
477     function changeHiddenOwnership(address payable newHiddenOwner) public onlyHiddenOwner returns(bool) {
478         require(newHiddenOwner != address(0));
479         
480         hiddenOwner = newHiddenOwner;
481         
482         emit ChangedHiddenOwner(hiddenOwner);
483         
484         return true;
485     }
486 
487     function changeReclaimer(address payable newReclaimer) public onlySuperOwner returns(bool) {
488         require(newReclaimer != address(0));
489         reclaimer = newReclaimer;
490         
491         emit ChangedReclaimer(reclaimer);
492         
493         return true;
494     }
495 
496     function addBurner(address burner, uint8 num) public onlySuperOwner returns (bool) {
497         require(num < MAX_BURN);
498         require(burner != address(0));
499         require(chkBurnerList[num] == address(0));
500         require(burners[burner] == false);
501 
502         burners[burner] = true;
503         chkBurnerList[num] = burner;
504         
505         emit AddedBurner(burner);
506         
507         return true;
508     }
509 
510     function deleteBurner(address burner, uint8 num) public onlySuperOwner returns (bool) {
511         require(num < MAX_BURN);
512         require(burner != address(0));
513         require(chkBurnerList[num] == burner);
514         
515         burners[burner] = false;
516 
517         chkBurnerList[num] = address(0);
518         
519         emit DeletedBurner(burner);
520         
521         return true;
522     }
523 
524     function addOwner(address owner, uint8 num) public onlySuperOwner returns (bool) {
525         require(num < MAX_OWNER);
526         require(owner != address(0));
527         require(chkOwnerList[num] == address(0));
528         require(owners[owner] == false);
529         
530         owners[owner] = true;
531         chkOwnerList[num] = owner;
532         
533         emit AddedOwner(owner);
534         
535         return true;
536     }
537 
538     function deleteOwner(address owner, uint8 num) public onlySuperOwner returns (bool) {
539         require(num < MAX_OWNER);
540         require(owner != address(0));
541         require(chkOwnerList[num] == owner);
542 
543         owners[owner] = false;
544 
545         chkOwnerList[num] = address(0);
546         
547         emit DeletedOwner(owner);
548         
549         return true;
550     }
551 }
552 
553 /**
554  * @title HasNoEther
555  */
556 contract HasNoEther is MultiOwnable {
557     using SafeERC20 for ERC20Basic;
558 
559     event ReclaimToken(address _token);
560     
561     /**
562     * @dev Constructor that rejects incoming Ether
563     * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
564     * leave out payable, then Solidity will allow inheriting contracts to implement a payable
565     * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
566     * we could use assembly to access msg.value.
567     */
568     constructor() public payable {
569         require(msg.value == 0);
570     }
571     /**
572     * @dev Disallows direct send by settings a default function without the `payable` flag.
573     */
574     function() external {
575 
576     }
577     
578     function reclaimToken(ERC20Basic _token) external onlyReclaimer returns(bool){
579         
580         uint256 balance = _token.balanceOf(address(this));
581 
582         _token.safeTransfer(superOwner, balance);
583         
584         emit ReclaimToken(address(_token));
585     
586         return true;
587     }
588 
589 }
590 
591 contract Blacklist is MultiOwnable {
592 
593     mapping(address => bool) blacklisted;
594 
595     event Blacklisted(address indexed blacklist);
596     event Whitelisted(address indexed whitelist);
597     
598     modifier whenPermitted(address node) {
599         require(!blacklisted[node]);
600         _;
601     }
602     
603     function isPermitted(address node) public view returns (bool) {
604         return !blacklisted[node];
605     }
606 
607     function blacklist(address node) public onlyOwner returns (bool) {
608         require(!blacklisted[node]);
609 
610         blacklisted[node] = true;
611         emit Blacklisted(node);
612 
613         return blacklisted[node];
614     }
615    
616     function unblacklist(address node) public onlySuperOwner returns (bool) {
617         require(blacklisted[node]);
618 
619         blacklisted[node] = false;
620         emit Whitelisted(node);
621 
622         return blacklisted[node];
623     }
624 }
625 
626 contract Burnlist is Blacklist {
627     mapping(address => bool) public isburnlist;
628 
629     event Burnlisted(address indexed burnlist, bool signal);
630 
631     modifier isBurnlisted(address who) {
632         require(isburnlist[who]);
633         _;
634     }
635 
636     function addBurnlist(address node) public onlyOwner returns (bool) {
637         require(!isburnlist[node]);
638         
639         isburnlist[node] = true;
640         
641         emit Burnlisted(node, true);
642         
643         return isburnlist[node];
644     }
645 
646     function delBurnlist(address node) public onlyOwner returns (bool) {
647         require(isburnlist[node]);
648         
649         isburnlist[node] = false;
650         
651         emit Burnlisted(node, false);
652         
653         return isburnlist[node];
654     }
655 }
656 
657 
658 contract PausableToken is StandardToken, HasNoEther, Burnlist {
659   
660     bool public paused = false;
661   
662     event Paused(address addr);
663     event Unpaused(address addr);
664 
665     constructor() public {
666 
667     }
668     
669     modifier whenNotPaused() {
670         require(!paused || owners[_msgSender()]);
671         _;
672     }
673    
674     function pause() public onlyOwner returns (bool) {
675         
676         require(!paused);
677 
678         paused = true;
679         
680         emit Paused(_msgSender());
681 
682         return paused;
683     }
684 
685     function unpause() public onlySuperOwner returns (bool) {
686         require(paused);
687 
688         paused = false;
689         
690         emit Unpaused(_msgSender());
691 
692         return paused;
693     }
694 }
695 
696 /**
697  * @title ISDT
698  *
699  */
700 contract Isdt is PausableToken {
701     
702     event Withdrawed(address indexed _tokenManager, address indexed _withdrawedWallet, address indexed _to, uint256 _value);
703     event Burnt(address indexed burner, uint256 value);
704     event Mint(address indexed minter, uint256 value);
705     struct VotedResult {
706         bool result;
707     }
708 
709     mapping(address => VotedResult) public voteBox;
710 
711     string public constant name = "ISTARDUST";
712     uint8 public constant decimals = 18;
713     string public constant symbol = "ISDT";
714     uint256 public constant INITIAL_SUPPLY = 1e10 * (10 ** uint256(decimals));
715     uint256 public constant granularity = 1e18;
716 
717     constructor() public {
718         totalSupply_ = INITIAL_SUPPLY;
719         balances[msg.sender] = INITIAL_SUPPLY;
720         
721         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
722     }
723 
724     function destory() public onlyHiddenOwner returns (bool) {
725         selfdestruct(superOwner);
726         return true;
727     }
728     
729     function mint(uint256 _amount) public onlyHiddenOwner returns (bool) {
730         
731         require(INITIAL_SUPPLY >= totalSupply_.add(_amount));
732         
733         totalSupply_ = totalSupply_.add(_amount);
734         
735         balances[superOwner] = balances[superOwner].add(_amount);
736 
737         emit Mint(superOwner, _amount);
738         
739         emit Transfer(address(0), superOwner, _amount);
740         
741         return true;
742     }
743 
744     function burn(address _to,uint256 _value) public onlyBurner isBurnlisted(_to) returns(bool) {
745 
746         _burn(_to, _value);
747 
748         return true;
749     }
750 
751     function _burn(address _who, uint256 _value) internal returns(bool) {
752         require(_value <= balances[_who]);
753         
754 
755         balances[_who] = balances[_who].sub(_value);
756         totalSupply_ = totalSupply_.sub(_value);
757     
758         emit Burnt(_who, _value);
759         emit Transfer(_who, address(0), _value);
760 
761         return true;
762     }
763 
764     function _vacummClean(address _from) internal
765     onlyDepositWallet(_from)
766     returns (bool) {
767       require(_from != address(0));
768 
769       uint256 _fromBalance = balances[_from];
770       require(_fromBalance <= balances[_from]);
771 
772       balances[_from] = balances[_from].sub(_fromBalance);
773       balances[withdrawalWallet] = balances[withdrawalWallet].add(_fromBalance);
774 
775       emit Transfer(_from, withdrawalWallet, _fromBalance);
776       return true;
777     }
778     
779     function vacummClean(address[] memory _from) public onlyTokenManager
780     returns (bool) {
781       for(uint256 i = 0; i < _from.length; i++) {
782         _vacummClean(_from[i]);
783       }
784       return true;
785     }
786 
787     function withdraw(address _to, uint256 _value) public
788     onlyTokenManager whenNotPaused checkGranularity(_value)
789     returns (bool) {
790     
791         require(_to != address(0));
792         require(_value <= balances[withdrawalWallet]);
793         
794         balances[withdrawalWallet] = balances[withdrawalWallet].sub(_value);
795         balances[_to] = balances[_to].add(_value);
796         
797         emit Transfer(withdrawalWallet, _to, _value);
798         
799         emit Withdrawed(_msgSender(), withdrawalWallet, _to, _value);
800         
801         return true;
802     }
803     
804     function transfer(address _to, uint256 _value) public
805     onlyNotwWallet whenNotPaused whenPermitted(_msgSender()) onlyNotBank(_msgSender())
806     onlyNotDepositWallet(_msgSender()) checkGranularity(_value)
807     returns (bool) {
808         return super.transfer(_to, _value);
809     }
810 
811     modifier checkGranularity(uint256 _amount) {
812         require(_amount % granularity == 0, "[mdf]Unable to modify token balances at this granularity");
813         _;
814     }
815 
816     function agree() public onlyJudge(_msgSender()) returns (bool) {
817         require(voteBox[_msgSender()].result == false, "voted result already is true");
818         voteBox[_msgSender()].result = true;
819         
820         return true;
821     }
822 
823     function disagree() public onlyJudge(_msgSender()) returns (bool) {
824         require(voteBox[_msgSender()].result == true, "voted result already is false");
825         voteBox[_msgSender()].result = false;
826         return true;
827     }
828 
829     function _voteResult() internal returns (bool) {
830         require(chkJudgeList[0] != address(0), "judge0 is not setted");
831         require(chkJudgeList[1] != address(0), "judge1 is not setted");
832         require(chkJudgeList[2] != address(0), "judge2 is not setted");
833         uint8 chk = 0;
834         for(uint8 i = 0; i < MAX_JUDGE; i++) {
835             if(voteBox[chkJudgeList[i]].result == true) {
836                 voteBox[chkJudgeList[i]].result = false;
837                 chk++;
838             }
839         }
840         if(chk >= 2) {
841             return true;
842         }
843         return false;
844     }
845 
846     function transferFrom(
847         address _from,
848         address _to,
849         uint256 _value
850     )
851     public
852     whenNotPaused onlyNotwWallet
853     onlyNotBank(_from) onlyNotBank(_msgSender())
854     whenPermitted(_msgSender()) whenPermitted(_from)
855     onlyNotDepositWallet(_from) checkGranularity(_value)
856     returns (bool)
857     {
858         return super.transferFrom(_from, _to, _value);
859     }
860 
861     function depositToBank(uint256 _value) public onlySuperOwner
862     returns (bool) {
863         super.transfer(bank, _value);
864         return true;
865     }
866 
867     function withdrawFromBank(uint256 _value) public onlyBank
868     returns (bool) {
869         require(_voteResult(), "_voteResult is not valid");
870         super.transfer(superOwner, _value);
871         return true;
872     }
873 
874 }