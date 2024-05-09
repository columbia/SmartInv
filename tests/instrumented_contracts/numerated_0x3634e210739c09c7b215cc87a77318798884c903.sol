1 pragma solidity ^0.5.11;
2 
3 /** @title A contract for issuing, redeeming and transfering SilaUSD StableCoin
4 * 
5 * @author www.silamoney.com
6 * Email: contact@silamoney.com
7 *
8 */
9 
10 /**Run
11 * @title SafeMath
12 * @dev Math operations with safety checks that revert on error
13 */
14  
15 library SafeMath{
16     
17   /**
18   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
19   */
20   
21   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
22     require(_b <= _a);
23     uint256 c = _a - _b;
24 
25     return c;
26   }
27 
28   /**
29   * @dev Adds two numbers, reverts on overflow.
30   */
31   
32   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
33     uint256 c = _a + _b;
34     require(c >= _a);
35 
36     return c;
37   }
38 
39 }
40 
41 /**
42 * @title Arrays
43 * @dev  overload array operations
44 */
45 
46 library Arrays{
47     
48   function arr(address _a) internal pure returns (address[] memory _arr) {
49     _arr = new address[](1);
50     _arr[0] = _a; 
51   }
52 
53   function arr(address _a, address _b) internal pure returns (address[] memory _arr) {
54     _arr = new address[](2);
55     _arr[0] = _a; 
56     _arr[1] = _b;
57   }
58 
59   function arr(address _a, address _b, address _c) internal pure returns (address[] memory _arr) {
60     _arr = new address[](3);
61     _arr[0] = _a; 
62     _arr[1] = _b; 
63     _arr[2] = _c; 
64   }
65 
66 }
67 
68 /**
69 * @title Ownable
70 * @dev The Ownable contract hotOwner and ColdOwner, and provides authorization control
71 * functions, this simplifies the implementation of "user permissions".
72 */
73 
74 contract Ownable{
75     
76     // hot and cold wallet addresses
77     
78     address public hotOwner = 0xCd39203A332Ff477a35dA3AD2AD7761cDBEAb7F0;
79 
80     address public coldOwner = 0x1Ba688e70bb4F3CB266b8D721b5597bFbCCFF957;
81     
82     // event for ownership transfer
83     
84     event OwnershipTransferred(address indexed _newHotOwner, address indexed _newColdOwner, address indexed _oldColdOwner);
85 
86    /**
87    * @dev Reverts if called by any account other than the hotOwner.
88    */
89    
90     modifier onlyHotOwner() {
91         require(msg.sender == hotOwner);
92         _;
93     }
94     
95    /**
96    * @dev Reverts if called by any account other than the coldOwner.
97    */
98     
99     modifier onlyColdOwner() {
100         require(msg.sender == coldOwner);
101         _;
102     }
103     
104    /**
105    * @dev Assigns new hotowner and coldOwner
106    * @param _newHotOwner address The address which is a new hot owner.
107    * @param _newColdOwner address The address which can change the hotOwner.
108    */
109     
110     function transferOwnership(address _newHotOwner, address _newColdOwner) public onlyColdOwner {
111         require(_newHotOwner != address(0));
112         require(_newColdOwner!= address(0));
113         hotOwner = _newHotOwner;
114         coldOwner = _newColdOwner;
115         emit OwnershipTransferred(_newHotOwner, _newColdOwner, msg.sender);
116     }
117 
118 }
119 
120 /**
121 * @title EmergencyToggle
122 * @dev The EmergencyToggle contract provides a way to pause the contract in emergency
123 */
124 
125 contract EmergencyToggle is Ownable{
126      
127     // pause the entire contract if true
128     bool public emergencyFlag; 
129 
130     // constructor
131     constructor () public{
132       emergencyFlag = false;                            
133     }
134   
135     /**
136     * @dev onlyHotOwner can can pause the usage of issue,redeem, transfer functions
137     */
138     
139     function emergencyToggle() external onlyHotOwner {
140       emergencyFlag = !emergencyFlag;
141     }
142 
143 }
144 
145 /**
146 * @title Authorizable
147 * @dev The Authorizable contract can be used to authorize addresses to control silausd main
148 * functions, this will provide more flexibility in terms of signing trasactions
149 */
150 
151 contract Authorizable is Ownable, EmergencyToggle {
152     using SafeMath for uint256;
153       
154     // map to check if the address is authorized to issue, redeem and betalist sila
155     mapping(address => bool) authorized;
156 
157     // events for when address is added or removed 
158     event AuthorityAdded(address indexed _toAdd);
159     event AuthorityRemoved(address indexed _toRemove);
160     
161     // modifier allowing only authorized addresses and hotOwner to call certain functions
162     modifier onlyAuthorized() {
163         require(authorized[msg.sender] || hotOwner == msg.sender);
164         _;
165     }
166     
167    /**
168    * @dev Function addAuthorized adds addresses that can betalist, transfer, issue and redeem
169    * @param _toAdd address of the added authority
170    */
171 
172     function addAuthorized(address _toAdd) public onlyHotOwner {
173         require (!emergencyFlag);
174         require(_toAdd != address(0));
175         require(!authorized[_toAdd]);
176         authorized[_toAdd] = true;
177         emit AuthorityAdded(_toAdd);
178     }
179     
180    /**
181    * @dev Function RemoveAuthorized removes addresses that can betalist and transfer 
182    * @param _toRemove address of the added authority
183    */
184 
185     function removeAuthorized(address _toRemove) public onlyHotOwner {
186         require (!emergencyFlag);
187         require(_toRemove != address(0));
188         require(authorized[_toRemove]);
189         authorized[_toRemove] = false;
190         emit AuthorityRemoved(_toRemove);
191     }
192     
193    /**
194    * @dev check the specified address is authorized to do sila transactions
195    * @param _authorized The address to be checked for authority
196    */
197    
198     function isAuthorized(address _authorized) external view returns(bool _isauthorized) {
199         return authorized[_authorized];
200     }
201     
202 }
203 
204 /**
205 * @title  Token is Betalist,Blacklist
206 */
207  
208  contract Betalist is Authorizable {
209 
210     // maps for betalisted and blacklisted addresses
211     mapping(address => bool) betalisted;
212     mapping(address => bool) blacklisted;
213 
214     // events for betalist and blacklist
215     event BetalistedAddress (address indexed _betalisted);
216     event BlacklistedAddress (address indexed _blacklisted);
217     event RemovedAddressFromBlacklist(address indexed _toRemoveBlacklist);
218     event RemovedAddressFromBetalist(address indexed _toRemoveBetalist);
219 
220     // variable to check if betalist is required when calling several functions on smart contract
221     bool public requireBetalisted;
222  
223     // constructor
224     constructor () public {
225         requireBetalisted = true;
226     }
227     
228     // modifier to check acceptableTransactor addresses
229     
230     modifier acceptableTransactors(address[] memory addresses) {
231         require(!emergencyFlag);
232         if (requireBetalisted){
233           for(uint i = 0; i < addresses.length; i++) require( betalisted[addresses[i]] );
234         }
235         for(uint i = 0; i < addresses.length; i++) {
236           address addr = addresses[i];
237           require(addr != address(0));
238           require(!blacklisted[addr]);
239         }
240         _;
241     }
242     
243     /**
244     * @dev betaList the specified address
245     * @param _toBetalist The address to betalist
246     */
247   
248     function betalistAddress(address _toBetalist) public onlyAuthorized returns(bool) {
249         require(!emergencyFlag);
250         require(_toBetalist != address(0));
251         require(!blacklisted[_toBetalist]);
252         require(!betalisted[_toBetalist]);
253         betalisted[_toBetalist] = true;
254         emit BetalistedAddress(_toBetalist);
255         return true;
256     }
257     
258     /**
259     * @dev remove from betaList the specified address
260     * @param _toRemoveBetalist The address to be removed
261     */
262   
263     function removeAddressFromBetalist(address _toRemoveBetalist) public onlyAuthorized {
264         require(!emergencyFlag);
265         require(_toRemoveBetalist != address(0));
266         require(betalisted[_toRemoveBetalist]);
267         betalisted[_toRemoveBetalist] = false;
268         emit RemovedAddressFromBetalist(_toRemoveBetalist);
269     }
270     
271     /**
272     * @dev blackList the specified address
273     * @param _toBlacklist The address to blacklist
274     */
275 
276     function blacklistAddress(address _toBlacklist) public onlyAuthorized returns(bool) {
277         require(!emergencyFlag);
278         require(_toBlacklist != address(0));
279         require(!blacklisted[_toBlacklist]);
280         blacklisted[_toBlacklist] = true;
281         emit BlacklistedAddress(_toBlacklist);
282         return true;
283     }
284         
285     /**
286     * @dev remove from blackList the specified address
287     * @param _toRemoveBlacklist The address to blacklist
288     */
289   
290     function removeAddressFromBlacklist(address _toRemoveBlacklist) public onlyAuthorized {
291         require(!emergencyFlag);
292         require(_toRemoveBlacklist != address(0));
293         require(blacklisted[_toRemoveBlacklist]);
294         blacklisted[_toRemoveBlacklist] = false;
295         emit RemovedAddressFromBlacklist(_toRemoveBlacklist);
296     }
297         
298     /**
299     * @dev    BlackList addresses in batches 
300     * @param _toBlacklistAddresses array of addresses to be blacklisted
301     */
302 
303     function batchBlacklistAddresses(address[] memory _toBlacklistAddresses) public onlyAuthorized returns(bool) {
304         for(uint i = 0; i < _toBlacklistAddresses.length; i++) {
305             bool check = blacklistAddress(_toBlacklistAddresses[i]);
306             require(check);
307         }
308         return true;
309     }
310     
311     /**
312     * @dev    Betalist addresses in batches 
313     * @param _toBetalistAddresses array of addresses to be betalisted 
314     */
315 
316     function batchBetalistAddresses(address[] memory _toBetalistAddresses) public onlyAuthorized returns(bool) {
317         for(uint i = 0; i < _toBetalistAddresses.length; i++) {
318             bool check = betalistAddress(_toBetalistAddresses[i]);
319             require(check);
320         }
321         return true;
322     }
323         
324     /**
325     * @dev check the specified address if isBetaListed
326     * @param _betalisted The address to be checked for betalisting
327     */
328   
329     function isBetalisted(address _betalisted) external view returns(bool) {
330             return (betalisted[_betalisted]);
331     }
332     
333     /**
334     * @dev check the specified address isBlackListed
335     * @param _blacklisted The address to be checked for blacklisting
336     */
337 
338     function isBlacklisted(address _blacklisted) external view returns(bool) {
339         return (blacklisted[_blacklisted]);
340     }
341     
342 }
343 
344 /**
345 * @title  Token is token Interface
346 */
347 
348 contract Token{
349     
350     function balanceOf(address _owner) public view returns (uint256 balance);
351     function transfer(address _to, uint256 _value) public returns (bool success);
352     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
353     function approve(address _spender, uint256 _value) public returns (bool success);
354     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
355     event Transfer(address indexed _from, address indexed _to, uint256 _value);
356     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
357 }
358 
359 /**
360 *@title StandardToken
361 *@dev Implementation of the basic standard token.
362 */
363 
364 contract StandardToken is Token, Betalist{
365   using SafeMath for uint256;
366 
367     // maps to store balances and allowances
368     mapping (address => uint256)  balances;
369     
370     mapping (address => mapping (address => uint256)) allowed;
371     
372     uint256 public totalSupply;
373     
374     /**
375     * @dev Gets the balance of the specified address.
376     * @return An uint256 representing the amount owned by the passed address.
377     */
378     
379     function balanceOf(address _owner) public view returns (uint256) {
380         return balances[_owner];
381     }
382 
383     /**
384     * @dev Function to check the amount of tokens that an owner allowed to a spender.
385     * @param _owner address The address which owns the funds.
386     * @param _spender address The address which will spend the funds.
387     * @return A uint256 specifying the amount of tokens still available for the spender.
388     */
389   
390     function allowance(address _owner,address _spender)public view returns (uint256) {
391         return allowed[_owner][_spender];
392     }
393 
394     /**
395     * @dev Transfer token for a specified address
396     * @param _to The address to transfer to.
397     * @param _value The amount to be transferred.
398     */
399 
400     function transfer(address _to, uint256 _value) public acceptableTransactors(Arrays.arr(_to, msg.sender)) returns (bool) {
401         require(_value <= balances[msg.sender]);
402         balances[msg.sender] = balances[msg.sender].sub(_value);
403         balances[_to] = balances[_to].add(_value);
404         emit Transfer(msg.sender, _to, _value);
405         return true;
406     }
407   
408     /**
409     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
410     * Beware that changing an allowance with this method brings the risk that someone may use both the old
411     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
412     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
413     * @param _value The amount of tokens to be spent.
414     */
415     
416     function approve(address _spender, uint256 _value) public acceptableTransactors(Arrays.arr(_spender, msg.sender)) returns (bool) {
417         allowed[msg.sender][_spender] = _value;
418         emit Approval(msg.sender, _spender, _value);
419         return true;
420     }
421   
422     /**
423     * @dev Transfer tokens from one address to another
424     * @param _from address The address which you want to send tokens from
425     * @param _to address The address which you want to transfer to
426     * @param _value uint256 the amount of tokens to be transferred
427     */
428     
429     function transferFrom(address _from, address _to, uint256 _value) public acceptableTransactors(Arrays.arr(_from, _to, msg.sender)) returns (bool) {
430         require(_value <= balances[_from]);
431         require(_value <= allowed[_from][msg.sender]);
432         balances[_from] = balances[_from].sub(_value);
433         balances[_to] = balances[_to].add(_value);
434         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
435         emit Transfer(_from, _to, _value);
436         return true;
437     }
438 
439 }
440 
441 /**
442 *@title AuthroizeDeveloper
443 *@dev Implementation of the authorize developer contract to authorize developers 
444 * to control the users sila balance registered under an app
445 */
446 
447 contract AuthorizeDeveloper is StandardToken{
448     
449     // mapping to store authorization for DeveloperTransfer
450     mapping(address => mapping(address => bool)) isAuthorizedDeveloper;
451     
452     // Events
453     event SilaAuthorizedDeveloper (address indexed _developer, address indexed _user);
454     event DeveloperTransfer (address indexed _developer, address indexed _from, address indexed _to, uint _amount);
455     event SilaRemovedDeveloper (address indexed _developer, address indexed _user);
456     event UserAuthorizedDeveloper (address indexed _developer, address indexed _user);
457     event UserRemovedDeveloper (address indexed _developer, address indexed _user);
458 
459    /**
460    * @dev silaAuthorizeDeveloper to transfer tokens on users behalf
461    * @param _developer address The address which is allowed to transfer tokens on users behalf
462    * @param _user address The address which developer want to transfer from
463    */
464     
465     function silaAuthorizeDeveloper(address _developer, address _user) public acceptableTransactors(Arrays.arr(_developer, _user)) onlyAuthorized {
466         require(!isAuthorizedDeveloper[_developer][_user]);
467         isAuthorizedDeveloper[_developer][_user] = true;
468         emit SilaAuthorizedDeveloper(_developer,_user);
469     }
470     
471    /**
472    * @dev user can Authorize Developer to transfer tokens on their behalf
473    * @param _developer address The address which is allowed to transfer tokens on users behalf
474    */
475     
476     function userAuthorizeDeveloper(address _developer) public acceptableTransactors(Arrays.arr(_developer, msg.sender)) {
477         require(!isAuthorizedDeveloper[_developer][msg.sender]);
478         isAuthorizedDeveloper[_developer][msg.sender] = true;
479         emit UserAuthorizedDeveloper(_developer, msg.sender);
480     }
481     
482    /**
483    * @dev RemoveDeveloper allowed to transfer tokens on users behalf
484    * @param _developer address The address which is allowed to transfer tokens on users behalf
485    * @param _user address The address which developer want to transfer from
486    */
487     
488     function silaRemoveDeveloper(address _developer, address _user) public onlyAuthorized {
489         require(!emergencyFlag);
490         require(_developer != address(0));
491         require(_user != address(0));
492         require(isAuthorizedDeveloper[_developer][_user]);
493         isAuthorizedDeveloper[_developer][_user] = false;
494         emit SilaRemovedDeveloper(_developer, _user);
495     }
496     
497    /**
498    * @dev userRemovDeveloper to remove the developer allowed to transfer sila
499    * @param _developer, The address which is allowed to transfer tokens on users behalf
500    */
501     
502     function userRemoveDeveloper(address _developer) public {
503         require(!emergencyFlag);
504         require(_developer != address(0));
505         require(isAuthorizedDeveloper[_developer][msg.sender]);
506         isAuthorizedDeveloper[_developer][msg.sender] = false;
507         emit UserRemovedDeveloper(_developer,msg.sender);
508     }
509     
510    /**
511    * @dev developerTransfer for developer to transfer tokens on users behalf without requiring ethers in managed  ethereum accounts
512    * @param _from address the address to transfer tokens from
513    * @param _to address The address which developer want to transfer to
514    * @param _amount the amount of tokens user wants to transfer
515    */
516     
517     function developerTransfer(address _from, address _to, uint _amount) public acceptableTransactors(Arrays.arr(_from, _to, msg.sender)) {
518         require(isAuthorizedDeveloper[msg.sender][_from]);
519         require(_amount <= balances[_from]);
520         balances[_from] = balances[_from].sub(_amount);
521         balances[_to] = balances[_to].add(_amount);
522         emit DeveloperTransfer(msg.sender, _from, _to, _amount);
523         emit Transfer(_from, _to, _amount);
524     }
525     
526    /**
527    * @dev check if developer is allowed to transfer tokens on users behalf
528    * @param _developer the address allowed to transfer tokens 
529    * @param _for address The user address which developer want to transfer from
530    */
531     
532     function checkIsAuthorizedDeveloper(address _developer, address _for) external view returns (bool) {
533         return (isAuthorizedDeveloper[_developer][_for]);
534     }
535 
536 }
537 
538 /**
539 *@title SilaUsd
540 *@dev Implementation for sila issue,redeem,protectedTransfer and batch functions
541 */
542 
543 contract SilaUsd is AuthorizeDeveloper{
544     using SafeMath for uint256;
545     
546     // parameters for silatoken
547     string  public constant name = "SILAUSD";
548     string  public constant symbol = "SILA";
549     uint256 public constant decimals = 18;
550     string  public constant version = "2.0";
551     
552     // Events fired during successfull execution of main silatoken functions
553     event Issued(address indexed _to, uint256 _value);
554     event Redeemed(address indexed _from, uint256 _amount);
555     event ProtectedTransfer(address indexed _from, address indexed _to, uint256 _amount);
556     event GlobalLaunchSila(address indexed _launcher);
557     event DestroyedBlackFunds(address _blackListedUser, uint _dirtyFunds);
558 
559    /**
560    * @dev issue tokens from sila  to _to address
561    * @dev only authorized addresses are allowed to call this function
562    * @param _to address The address which you want to transfer to
563    * @param _amount uint256 the amount of tokens to be issued
564    */
565 
566    function issue(address _to, uint256 _amount) public acceptableTransactors(Arrays.arr(_to)) onlyAuthorized returns (bool) {
567         totalSupply = totalSupply.add(_amount);
568         balances[_to] = balances[_to].add(_amount);                 
569         emit Issued(_to, _amount);                     
570         return true;
571     }
572     
573    /**
574    * @dev redeem tokens from _from address
575    * @dev onlyAuthorized  addresses can call this function
576    * @param _from address is the address from which tokens are burnt
577    * @param _amount uint256 the amount of tokens to be burnt
578    */
579 
580     function redeem(address _from, uint256 _amount) public acceptableTransactors(Arrays.arr(_from)) onlyAuthorized returns(bool) {
581         require(_amount <= balances[_from]);
582         balances[_from] = balances[_from].sub(_amount);   
583         totalSupply = totalSupply.sub(_amount);
584         emit Redeemed(_from, _amount);
585         return true;
586     }
587     
588    /**
589    * @dev Transfer tokens from one address to another
590    * @dev onlyAuthorized  addresses can call this function
591    * @param _from address The address which you want to send tokens from
592    * @param _to address The address which you want to transfer to
593    * @param _amount uint256 the amount of tokens to be transferred
594    */
595 
596     function protectedTransfer(address _from, address _to, uint256 _amount) public acceptableTransactors(Arrays.arr(_from, _to)) onlyAuthorized returns(bool) {
597         require(_amount <= balances[_from]);
598         balances[_from] = balances[_from].sub(_amount);
599         balances[_to] = balances[_to].add(_amount);
600         emit ProtectedTransfer(_from, _to, _amount);
601         emit Transfer(_from, _to, _amount);
602         return true;
603     }    
604     
605     /**
606      * @dev destroy the funds of a blacklisted address
607      * @param _blackListedUser the blacklisted user address for which the funds need to be destroyed
608     */
609     
610     function destroyBlackFunds(address _blackListedUser) public onlyAuthorized {
611         require(blacklisted[_blackListedUser]);
612         uint dirtyFunds = balanceOf(_blackListedUser);
613         balances[_blackListedUser] = 0;
614         totalSupply = totalSupply.sub(dirtyFunds);
615         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
616     }
617     
618     /**
619     * @dev Launch sila for global transfer function to work as standard
620     */
621     
622     function globalLaunchSila() public onlyHotOwner {
623         require(!emergencyFlag);
624         require(requireBetalisted);
625         requireBetalisted = false;
626         emit GlobalLaunchSila(msg.sender);
627     }
628     
629     /**
630     * @dev batchissue , isuue tokens in batches to multiple addresses at a time
631     * @param _amounts The amount of tokens to be issued.
632     * @param _toAddresses tokens to be issued to these addresses respectively
633     */
634     
635     function batchIssue(address[] memory _toAddresses, uint256[]  memory _amounts) public onlyAuthorized returns(bool) {
636         require(_toAddresses.length == _amounts.length);
637         for(uint i = 0; i < _toAddresses.length; i++) {
638             bool check = issue(_toAddresses[i],_amounts[i]);
639             require(check);
640         }
641         return true;
642     }
643     
644     /**
645     * @dev batchredeem , redeem tokens in batches from multiple addresses at a time
646     * @param _amounts array of amount of tokens to be redeemed.
647     * @param _fromAddresses array of addresses from which tokens to be redeemed respectively
648     */
649     
650     function batchRedeem(address[] memory  _fromAddresses, uint256[]  memory _amounts) public onlyAuthorized returns(bool) {
651         require(_fromAddresses.length == _amounts.length);
652         for(uint i = 0; i < _fromAddresses.length; i++) {
653             bool check = redeem(_fromAddresses[i],_amounts[i]);
654             require(check);
655         }  
656         return true;
657     }
658     
659     /**
660     * @dev batchTransfer, transfer tokens in batches between multiple addresses at a time
661     * @param _fromAddresses tokens to be transfered to these addresses respectively
662     * @param _toAddresses tokens to be transfered to these addresses respectively
663     * @param _amounts The amount of tokens to be transfered
664     */
665     
666     function protectedBatchTransfer(address[] memory _fromAddresses, address[]  memory _toAddresses, uint256[] memory  _amounts) public onlyAuthorized returns(bool) {
667         require(_fromAddresses.length == _amounts.length);
668         require(_toAddresses.length == _amounts.length);
669         require(_fromAddresses.length == _toAddresses.length);
670         for(uint i = 0; i < _fromAddresses.length; i++) {
671             bool check = protectedTransfer(_fromAddresses[i], _toAddresses[i], _amounts[i]);
672             require(check);
673         }
674         return true;
675     } 
676     
677 }