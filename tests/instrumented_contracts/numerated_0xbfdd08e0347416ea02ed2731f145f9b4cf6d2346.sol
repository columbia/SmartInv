1 pragma solidity ^0.5.2;
2 
3 
4 /** @title A contract for issuing, redeeming and transfering Sila StableCoins
5   *
6   * @author www.silamoney.com
7   * Email: contact@silamoney.com
8   *
9   */
10 
11 /**Run
12  * @title SafeMath
13  * @dev Math operations with safety checks that revert on error
14  */
15  
16 library SafeMath{
17     
18     
19   /**
20   * @dev Multiplies two numbers, reverts on overflow.
21   */
22   
23   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
24     
25     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27 
28     
29     if (_a == 0) {
30       return 0;
31     }
32 
33     uint256 c = _a * _b;
34     require(c / _a == _b);
35 
36     return c;
37   }
38 
39  
40    /**
41   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
42   */
43  
44   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     
46     require(_b > 0); // Solidity only automatically asserts when dividing by 0
47     uint256 c = _a / _b;
48     
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50 
51     return c;
52   }
53   
54   
55  
56    /**
57   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   
60   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
61     require(_b <= _a);
62     uint256 c = _a - _b;
63 
64     return c;
65   }
66 
67 
68   /**
69   * @dev Adds two numbers, reverts on overflow.
70   */
71   
72   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
73     uint256 c = _a + _b;
74     require(c >= _a);
75 
76     return c;
77   }
78 
79     
80 }
81 
82 /**
83  * @title Ownable
84  * @dev The Ownable contract hotOwner and ColdOwner, and provides authorization control
85  * functions, this simplifies the implementation of "user permissions".
86  */
87 
88 contract Ownable {
89     
90     // hot and cold wallet addresses
91     
92     address public hotOwner=0xCd39203A332Ff477a35dA3AD2AD7761cDBEAb7F0;
93 
94     address public coldOwner=0x1Ba688e70bb4F3CB266b8D721b5597bFbCCFF957;
95     
96     
97     //events
98     
99     event OwnershipTransferred(address indexed _newHotOwner,address indexed _newColdOwner,address indexed _oldColdOwner);
100 
101 
102     /**
103    * @dev Reverts if called by any account other than the hotOwner.
104    */
105    
106     modifier onlyHotOwner() {
107         require(msg.sender == hotOwner);
108         _;
109     }
110     
111      /**
112    * @dev Reverts if called by any account other than the coldOwner.
113    */
114     
115     modifier onlyColdOwner() {
116         require(msg.sender == coldOwner);
117         _;
118     }
119     
120      /**
121    * @dev Function assigns new hotowner and coldOwner
122    * @param _newHotOwner address The address which owns the funds.
123    * @param _newColdOwner address The address which can change the hotOwner.
124    */
125     
126     function transferOwnership(address _newHotOwner,address _newColdOwner) public onlyColdOwner returns (bool) {
127         require(_newHotOwner != address(0));
128         require(_newColdOwner!= address(0));
129         hotOwner = _newHotOwner;
130         coldOwner = _newColdOwner;
131         emit OwnershipTransferred(_newHotOwner,_newColdOwner,msg.sender);
132         return true;
133         
134         
135     }
136 
137 }
138 
139 /**
140  * @title Authorizable
141  * @dev The Authorizable contract can be used to authorize addresses to control silatoken main functions
142  * functions, this will provide more flexibility in terms of signing trasactions
143  */
144 
145 contract Authorizable is Ownable {
146     
147     //map to check if the address is authorized to issue, redeem sila
148     mapping(address => bool) authorized;
149     
150     //events for when address is added or removed
151     event AuthorityAdded(address indexed _toAdd);
152     event AuthorityRemoved(address indexed _toRemove);
153     
154     //array of authorized address to check for all the authorized addresses
155     address[] public authorizedAddresses;
156 
157     
158     modifier onlyAuthorized() {
159         require(authorized[msg.sender] || hotOwner == msg.sender);
160         _;
161     }
162     
163     
164      
165      /**
166    * @dev Function addAuthorized adds addresses that can issue,redeem and transfer silas
167    * @param _toAdd address of the added authority
168    */
169 
170     function addAuthorized(address _toAdd) onlyHotOwner public returns(bool) {
171         require(_toAdd != address(0));
172         require(!authorized[_toAdd]);
173         authorized[_toAdd] = true;
174         authorizedAddresses.push(_toAdd);
175         emit AuthorityAdded(_toAdd);
176         return true;
177     }
178     
179     /**
180    * @dev Function RemoveAuthorized removes addresses that can issue and redeem silas
181    * @param _toRemove address of the added authority
182    */
183 
184     function removeAuthorized(address _toRemove,uint _toRemoveIndex) onlyHotOwner public returns(bool) {
185         require(_toRemove != address(0));
186         require(authorized[_toRemove]);
187         authorized[_toRemove] = false;
188         authorizedAddresses[_toRemoveIndex] = authorizedAddresses[authorizedAddresses.length-1];
189         authorizedAddresses.pop();
190         emit AuthorityRemoved(_toRemove);
191         return true;
192     }
193     
194     
195     // view all the authorized addresses
196     function viewAuthorized() external view returns(address[] memory _authorizedAddresses){
197         return authorizedAddresses;
198     }
199     
200     
201     // check if the address is authorized
202     
203     function isAuthorized(address _authorized) external view returns(bool _isauthorized){
204         return authorized[_authorized];
205     }
206     
207     
208   
209 
210 }
211 
212 
213 
214 
215 /**
216  * @title EmergencyToggle
217  * @dev The EmergencyToggle contract provides a way to pause the contract in emergency
218  */
219 
220 contract EmergencyToggle is Ownable{
221      
222     //variable to pause the entire contract if true
223     bool public emergencyFlag; 
224 
225     //constructor
226     constructor () public{
227       emergencyFlag = false;                            
228       
229     }
230   
231   
232    /**
233     * @dev onlyHotOwner can can pause the usage of issue,redeem, transfer functions
234     */
235     
236     function emergencyToggle() external onlyHotOwner{
237       emergencyFlag = !emergencyFlag;
238     }
239 
240     
241  
242  }
243  
244  /**
245  * @title  Token is Betalist,Blacklist
246  */
247  contract Betalist is Authorizable,EmergencyToggle{
248      
249     //maps for betalisted and blacklisted addresses
250     mapping(address=>bool) betalisted;
251     mapping(address=>bool) blacklisted;
252 
253     //events for betalist and blacklist
254     event BetalistedAddress (address indexed _betalisted);
255     event BlacklistedAddress (address indexed _blacklisted);
256     event RemovedFromBlacklist(address indexed _toRemoveBlacklist);
257     event RemovedFromBetalist(address indexed _toRemoveBetalist);
258     
259     //variable to check if betalist is required when calling several functions on smart contract
260     bool public requireBetalisted;
261 
262 
263     //constructor
264     constructor () public{
265         requireBetalisted=true;
266         
267     }
268     
269     
270    /**
271   * @dev betaList the specified address
272   * @param _toBetalist the address to betalist
273   */
274     function betalistAddress(address _toBetalist) public onlyAuthorized returns(bool){
275         require(!emergencyFlag);
276         require(_toBetalist != address(0));
277         require(!blacklisted[_toBetalist]);
278         require(!betalisted[_toBetalist]);
279         betalisted[_toBetalist]=true;
280         emit BetalistedAddress(_toBetalist);
281         return true;
282         
283     }
284     
285      /**
286   * @dev remove from betaList the specified address
287   * @param _toRemoveBetalist The address to be removed
288   */
289     function removeAddressFromBetalist(address _toRemoveBetalist) public onlyAuthorized returns(bool){
290         require(!emergencyFlag);
291         require(_toRemoveBetalist != address(0));
292         require(betalisted[_toRemoveBetalist]);
293         betalisted[_toRemoveBetalist]=false;
294         emit RemovedFromBetalist(_toRemoveBetalist);
295         return true;
296         
297     }
298     
299       
300     /**
301   * @dev blackList the specified address
302   * @param _toBlacklist The address to blacklist
303   */
304     function blacklistAddress(address _toBlacklist) public onlyAuthorized returns(bool){
305         require(!emergencyFlag);
306         require(_toBlacklist != address(0));
307         require(!blacklisted[_toBlacklist]);
308         blacklisted[_toBlacklist]=true;
309         emit RemovedFromBlacklist(_toBlacklist);
310         return true;
311         
312     }
313     
314      /**
315   * @dev remove from blackList the specified address
316   * @param _toRemoveBlacklist The address to blacklist
317   */
318     function removeAddressFromBlacklist(address _toRemoveBlacklist) public onlyAuthorized returns(bool){
319         require(!emergencyFlag);
320         require(_toRemoveBlacklist != address(0));
321         require(blacklisted[_toRemoveBlacklist]);
322         blacklisted[_toRemoveBlacklist]=false;
323         emit RemovedFromBlacklist(_toRemoveBlacklist);
324         return true;
325         
326     }
327  
328       /**
329   * @dev check the specified address if isBetaListed
330   * @param _betalisted The address to transfer to.
331   */
332     function isBetaListed(address _betalisted) external view returns(bool){
333             return (betalisted[_betalisted]);
334     }
335     
336      
337       /**
338   * @dev check the specified address isBlackListed
339   * @param _blacklisted The address to transfer to.
340   */
341     function isBlackListed(address _blacklisted) external view returns(bool){
342         return (blacklisted[_blacklisted]);
343         
344     }
345     
346     
347 }
348 
349 /**
350  * @title  Token is token Interface
351  */
352 
353 contract Token{
354     
355     function balanceOf(address _owner) public view returns (uint256 balance);
356     function transfer(address _to, uint256 _value) public returns (bool success);
357     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
358     function approve(address _spender, uint256 _value) public returns (bool success);
359     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
360     event Transfer(address indexed _from, address indexed _to, uint256 _value);
361     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
362 }
363 
364 
365 /**
366  *@title StandardToken
367  *@dev Implementation of the basic standard token.
368  */
369 
370 contract StandardToken is Token,Betalist{
371   using SafeMath for uint256;
372 
373   mapping (address => uint256)  balances;
374 
375   mapping (address => mapping (address => uint256)) allowed;
376   
377   uint256 public totalSupply;
378 
379 
380  
381   
382   
383   /**
384   * @dev Gets the balance of the specified address.
385   * @return An uint256 representing the amount owned by the passed address.
386   */
387 
388   function balanceOf(address _owner) public view returns (uint256) {
389         return balances[_owner];
390   }
391 
392   
393   
394   /**
395    * @dev Function to check the amount of tokens that an owner allowed to a spender.
396    * @param _owner address The address which owns the funds.
397    * @param _spender address The address which will spend the funds.
398    * @return A uint256 specifying the amount of tokens still available for the spender.
399    */
400   
401   function allowance(address _owner,address _spender)public view returns (uint256){
402         return allowed[_owner][_spender];
403   }
404 
405  
406   /**
407   * @dev Transfer token for a specified address
408   * @param _to The address to transfer to.
409   * @param _value The amount to be transferred.
410   */
411   
412   function transfer(address _to, uint256 _value) public returns (bool) {
413     require(!emergencyFlag);
414     require(_value <= balances[msg.sender]);
415     require(_to != address(0));
416     if (requireBetalisted){
417         require(betalisted[_to]);
418         require(betalisted[msg.sender]);
419     }
420     require(!blacklisted[msg.sender]);
421     require(!blacklisted[_to]);
422     balances[msg.sender] = balances[msg.sender].sub(_value);
423     balances[_to] = balances[_to].add(_value);
424     emit Transfer(msg.sender, _to, _value);
425     return true;
426 
427   }
428   
429   
430     /**
431    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
432    * Beware that changing an allowance with this method brings the risk that someone may use both the old
433    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
434    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
435    * @param _value The amount of tokens to be spent.
436    */
437 
438   function approve(address _spender, uint256 _value) public returns (bool) {
439     require(!emergencyFlag);
440     if (requireBetalisted){
441         require(betalisted[msg.sender]);
442         require(betalisted[_spender]);
443     }
444     require(!blacklisted[msg.sender]);
445     require(!blacklisted[_spender]);
446     allowed[msg.sender][_spender] = _value;
447     emit Approval(msg.sender, _spender, _value);
448     return true;
449 
450   }
451   
452   
453     /**
454    * @dev Transfer tokens from one address to another
455    * @param _from address The address which you want to send tokens from
456    * @param _to address The address which you want to transfer to
457    * @param _value uint256 the amount of tokens to be transferred
458    */
459 
460   function transferFrom(address _from,address _to,uint256 _value)public returns (bool){
461     require(!emergencyFlag);
462     require(_value <= balances[_from]);
463     require(_value <= allowed[_from][msg.sender]);
464     require(_to != address(0));
465     if (requireBetalisted){
466         require(betalisted[_to]);
467         require(betalisted[_from]);
468         require(betalisted[msg.sender]);
469     }
470     require(!blacklisted[_to]);
471     require(!blacklisted[_from]);
472     require(!blacklisted[msg.sender]);
473     balances[_from] = balances[_from].sub(_value);
474     balances[_to] = balances[_to].add(_value);
475     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
476     emit Transfer(_from, _to, _value);
477     return true;
478     
479   }
480 
481 }
482 
483 contract AssignOperator is StandardToken{
484     
485     //mappings
486     
487     mapping(address=>mapping(address=>bool)) isOperator;
488     
489     
490     //Events
491     event AssignedOperator (address indexed _operator,address indexed _for);
492     event OperatorTransfer (address indexed _developer,address indexed _from,address indexed _to,uint _amount);
493     event RemovedOperator  (address indexed _operator,address indexed _for);
494     
495     
496     /**
497    * @dev AssignedOperator to transfer tokens on users behalf
498    * @param _developer address The address which is allowed to transfer tokens on users behalf
499    * @param _user address The address which developer want to transfer from
500    */
501     
502     function assignOperator(address _developer,address _user) public onlyAuthorized returns(bool){
503         require(!emergencyFlag);
504         require(_developer != address(0));
505         require(_user != address(0));
506         require(!isOperator[_developer][_user]);
507         if(requireBetalisted){
508             require(betalisted[_user]);
509             require(betalisted[_developer]);
510         }
511         require(!blacklisted[_developer]);
512         require(!blacklisted[_user]);
513         isOperator[_developer][_user]=true;
514         emit AssignedOperator(_developer,_user);
515         return true;
516     }
517     
518     /**
519    * @dev RemoveOperator allowed to transfer tokens on users behalf
520    * @param _developer address The address which is allowed to trasnfer tokens on users behalf
521    * @param _user address The address which developer want to transfer from
522    */
523     function removeOperator(address _developer,address _user) public onlyAuthorized returns(bool){
524         require(!emergencyFlag);
525         require(_developer != address(0));
526         require(_user != address(0));
527         require(isOperator[_developer][_user]);
528         isOperator[_developer][_user]=false;
529         emit RemovedOperator(_developer,_user);
530         return true;
531         
532     }
533     
534     /**
535    * @dev Operatransfer for developer to transfer tokens on users behalf without requiring ethers in managed  ethereum accounts
536    * @param _from address the address to transfer tokens from
537    * @param _to address The address which developer want to transfer to
538    * @param _amount the amount of tokens user wants to transfer
539    */
540     
541     function operatorTransfer(address _from,address _to,uint _amount) public returns (bool){
542         require(!emergencyFlag);
543         require(isOperator[msg.sender][_from]);
544         require(_amount <= balances[_from]);
545         require(_from != address(0));
546         require(_to != address(0));
547         if (requireBetalisted){
548             require(betalisted[_to]);
549             require(betalisted[_from]);
550             require(betalisted[msg.sender]);
551         }
552         require(!blacklisted[_to]);
553         require(!blacklisted[_from]);
554         require(!blacklisted[msg.sender]);
555         balances[_from] = balances[_from].sub(_amount);
556         balances[_to] = balances[_to].add(_amount);
557         emit OperatorTransfer(msg.sender,_from, _to, _amount);
558         emit Transfer(_from,_to,_amount);
559         return true;
560         
561         
562     }
563     
564      /**
565    * @dev checkIsOperator is developer an operator allowed to transfer tokens on users behalf
566    * @param _developer the address allowed to trasnfer tokens 
567    * @param _for address The address which developer want to transfer from
568    */
569     
570     function checkIsOperator(address _developer,address _for) external view returns (bool){
571             return (isOperator[_developer][_for]);
572     }
573 
574     
575 }
576 
577 
578 
579  /**
580  *@title SilaToken
581  *@dev Implementation for sila issue,redeem,protectedTransfer and batch functions
582  */
583 
584 contract SilaToken is AssignOperator{
585     using SafeMath for uint256;
586     
587     // parameters for silatoken
588     string  public constant name = "SilaToken";
589     string  public constant symbol = "SILA";
590     uint256 public constant decimals = 18;
591     string  public version = "1.0";
592     
593      
594     //Events fired during successfull execution of main silatoken functions
595     event Issued(address indexed _to,uint256 _value);
596     event Redeemed(address indexed _from,uint256 _amount);
597     event ProtectedTransfer(address indexed _from,address indexed _to,uint256 _amount);
598     event ProtectedApproval(address indexed _owner,address indexed _spender,uint256 _amount);
599     event GlobalLaunchSila(address indexed _launcher);
600     
601     
602 
603     /**
604    * @dev issue tokens from sila  to _to address
605    * @dev onlyAuthorized  addresses can call this function
606    * @param _to address The address which you want to transfer to
607    * @param _amount uint256 the amount of tokens to be issued
608    */
609 
610     function issue(address _to, uint256 _amount) public onlyAuthorized returns (bool) {
611         require(!emergencyFlag);
612         require(_to !=address(0));
613         if (requireBetalisted){
614             require(betalisted[_to]);
615         }
616         require(!blacklisted[_to]);
617         totalSupply = totalSupply.add(_amount);
618         balances[_to] = balances[_to].add(_amount);                 
619         emit Issued(_to, _amount);                     
620         return true;
621     }
622     
623     
624       
625    /**
626    * @dev redeem tokens from _from address
627    * @dev onlyAuthorized  addresses can call this function
628    * @param _from address is the address from which tokens are burnt
629    * @param _amount uint256 the amount of tokens to be burnt
630    */
631 
632     function redeem(address _from,uint256 _amount) public onlyAuthorized returns(bool){
633         require(!emergencyFlag);
634         require(_from != address(0));
635         require(_amount <= balances[_from]);
636         if(requireBetalisted){
637             require(betalisted[_from]);
638         }
639         require(!blacklisted[_from]);
640         balances[_from] = balances[_from].sub(_amount);   
641         totalSupply = totalSupply.sub(_amount);
642         emit Redeemed(_from,_amount);
643         return true;
644             
645 
646     }
647     
648     
649     /**
650    * @dev Transfer tokens from one address to another
651    * @dev onlyAuthorized  addresses can call this function
652    * @param _from address The address which you want to send tokens from
653    * @param _to address The address which you want to transfer to
654    * @param _amount uint256 the amount of tokens to be transferred
655    */
656 
657     function protectedTransfer(address _from,address _to,uint256 _amount) public onlyAuthorized returns(bool){
658         require(!emergencyFlag);
659         require(_amount <= balances[_from]);
660         require(_from != address(0));
661         require(_to != address(0));
662         if (requireBetalisted){
663             require(betalisted[_to]);
664             require(betalisted[_from]);
665         }
666         require(!blacklisted[_to]);
667         require(!blacklisted[_from]);
668         balances[_from] = balances[_from].sub(_amount);
669         balances[_to] = balances[_to].add(_amount);
670         emit ProtectedTransfer(_from, _to, _amount);
671         emit Transfer(_from,_to,_amount);
672         return true;
673         
674     }
675     
676     
677     /**
678     * @dev Launch sila for global transfers to work as standard
679     */
680     
681     function globalLaunchSila() public onlyHotOwner{
682             require(!emergencyFlag);
683             require(requireBetalisted);
684             requireBetalisted=false;
685             emit GlobalLaunchSila(msg.sender);
686     }
687     
688     
689     
690      /**
691    * @dev batchissue , isuue tokens in batches to multiple addresses at a time
692    * @param _amounts The amount of tokens to be issued.
693    * @param _toAddresses tokens to be issued to these addresses respectively
694     */
695     
696     function batchIssue(address[] memory _toAddresses,uint256[]  memory _amounts) public onlyAuthorized returns(bool) {
697             require(!emergencyFlag);
698             require(_toAddresses.length==_amounts.length);
699             for(uint i = 0; i < _toAddresses.length; i++) {
700                 bool check=issue(_toAddresses[i],_amounts[i]);
701                 require(check);
702             }
703             return true;
704             
705     }
706     
707     
708     /**
709     * @dev batchredeem , redeem tokens in batches from multiple addresses at a time
710     * @param _amounts The amount of tokens to be redeemed.
711     * @param _fromAddresses tokens to be redeemed to from addresses respectively
712      */
713     
714     function batchRedeem(address[] memory  _fromAddresses,uint256[]  memory _amounts) public onlyAuthorized returns(bool){
715             require(!emergencyFlag);
716             require(_fromAddresses.length==_amounts.length);
717             for(uint i = 0; i < _fromAddresses.length; i++) {
718                 bool check=redeem(_fromAddresses[i],_amounts[i]);
719                 require(check);
720             }  
721             return true;
722         
723     }
724     
725     
726       /**
727     * @dev batchTransfer, transfer tokens in batches between multiple addresses at a time
728     * @param _fromAddresses tokens to be transfered to these addresses respectively
729     * @param _toAddresses tokens to be transfered to these addresses respectively
730     * @param _amounts The amount of tokens to be transfered
731      */
732     function protectedBatchTransfer(address[] memory _fromAddresses,address[]  memory _toAddresses,uint256[] memory  _amounts) public onlyAuthorized returns(bool){
733             require(!emergencyFlag);
734             require(_fromAddresses.length==_amounts.length);
735             require(_toAddresses.length==_amounts.length);
736             require(_fromAddresses.length==_toAddresses.length);
737             for(uint i = 0; i < _fromAddresses.length; i++) {
738                 bool check=protectedTransfer(_fromAddresses[i],_toAddresses[i],_amounts[i]);
739                 require(check);
740                
741             }
742             return true;
743         
744     } 
745     
746     
747     
748 
749     
750     
751 }