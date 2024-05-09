1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46 
47 
48   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   constructor () public {
56     owner = msg.sender;
57   }
58 
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) public onlyOwner {
74     require(newOwner != address(0));
75     emit OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 interface Token {
82     function transfer(address _to, uint256 _amount)external returns (bool success);
83     function balanceOf(address _owner) external view returns (uint256 balance);
84     function decimals()external view returns (uint8);
85 }
86 
87 /**
88  * @title Vault
89  * @dev This contract is used for storing funds while a crowdsale
90  * is in progress. Funds will be transferred to owner on adhoc requests
91  */
92 contract Vault is Ownable {
93     using SafeMath for uint256;
94 
95     mapping (address => uint256) public deposited;
96     address public wallet;
97     
98     event Withdrawn(address _wallet);
99     
100     constructor (address _wallet) public {
101         require(_wallet != address(0));
102         wallet = _wallet;
103     }
104 
105     function deposit(address investor) public onlyOwner  payable{
106         
107         deposited[investor] = deposited[investor].add(msg.value);
108         
109     }
110 
111     
112     function withdrawToWallet() public onlyOwner {
113      wallet.transfer(address(this).balance);
114      emit Withdrawn(wallet);
115   }
116   
117 }
118 
119 
120 contract CLXTokenSale is Ownable{
121       using SafeMath for uint256;
122       
123       //Token to be used for this sale
124       Token public token;
125       
126       //All funds will go into this vault
127       Vault public vault;
128       
129      // This mapping stores the addresses of whitelisted users
130       mapping(address => bool) public whitelisted;
131   
132       //rate of token in ether 1ETH = 8000 CLX
133       uint256 public rate = 8000;
134       
135       /*
136       *There will be 2 phases
137       * 1. Pre-sale
138       * 2. ICO Phase 1
139       */
140 
141       struct PhaseInfo{
142           uint256 hardcap;
143           uint256 startTime;
144           uint256 endTime;
145           uint8   bonusPercentages;
146           uint256 minEtherContribution;
147           uint256 weiRaised;
148       }
149       
150          
151       //info of each phase
152       PhaseInfo[] public phases;
153       
154       //Total funding
155       uint256 public totalFunding;
156 
157       //total tokens available for sale considering 8 decimal places
158       uint256 tokensAvailableForSale = 17700000000000000;
159       
160       
161       uint8 public noOfPhases;
162       
163       
164       //Keep track of whether contract is up or not
165       bool public contractUp;
166       
167       //Keep track of whether the sale has ended or not
168       bool public saleEnded;
169 
170        //Keep track of emergency stop
171       bool public ifEmergencyStop ;
172       
173       //Event to trigger Sale stop
174       event SaleStopped(address _owner, uint256 time);
175       
176       //Event to trigger Sale restart
177       event SaleRestarted(address _owner, uint256 time);
178       
179       //Event to trigger normal flow of sale end
180       event Finished(address _owner, uint256 time);
181       
182        //Event to add user to the whitelist
183       event LogUserAdded(address user);
184 
185       //Event to remove user to the whitelist
186       event LogUserRemoved(address user);
187     
188      /**
189      * event for token purchase logging
190      * @param purchaser who paid for the tokens
191      * @param beneficiary who got the tokens
192      * @param value weis paid for purchase
193      * @param amount amount of tokens purchased
194      */
195      event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
196     
197     //modifiers    
198     modifier _contractUp(){
199         require(contractUp);
200         _;
201     }
202   
203      modifier nonZeroAddress(address _to) {
204         require(_to != address(0));
205         _;
206     }
207     
208     modifier _saleEnded() {
209         require(saleEnded);
210         _;
211     }
212     
213     modifier _saleNotEnded() {
214         require(!saleEnded);
215         _;
216     }
217 
218     modifier _ifNotEmergencyStop() {
219         require(!ifEmergencyStop);
220         _;
221     }
222 
223     /**
224     *     @dev Check if sale contract has enough tokens on its account balance 
225     *     to reward all possible participations within sale period
226     */
227     function powerUpContract() external onlyOwner {
228         // Contract should not be powered up previously
229         require(!contractUp);
230 
231         // Contract should have enough CLX credits
232         require(token.balanceOf(this) >= tokensAvailableForSale);
233         
234         //activate the sale process
235         contractUp = true;
236     }
237     
238     //for Emergency stop of the sale
239     function emergencyStop() external onlyOwner _contractUp {
240         require(!ifEmergencyStop);
241  
242         ifEmergencyStop = true;  
243         
244         emit SaleStopped(msg.sender, now);
245     }
246 
247     //to restart the sale after emergency stop
248     function emergencyRestart() external onlyOwner _contractUp  {
249         require(ifEmergencyStop);
250        
251         ifEmergencyStop = false;
252 
253         emit SaleRestarted(msg.sender, now);
254     }
255   
256       // @return true if all the tiers has been ended
257   function saleTimeOver() public view returns (bool) {
258     
259     return (phases[noOfPhases-1].endTime != 0);
260   }
261   
262    
263   /**
264   * @dev Can be called only once. The method to allow owner to set tier information
265   * @param _noOfPhases The integer to set number of tiers
266   * @param _startTimes The array containing start time of each tier
267   * @param _endTimes The array containing end time of each tier
268   * @param _hardCaps The array containing hard cap for each tier
269   * @param _bonusPercentages The array containing bonus percentage for each tier
270   * The arrays should be in sync with each other. For each index 0 for each of the array should contain info about Tier 1, similarly for Tier2, 3 and 4 .
271   * Sales hard cap will be the hard cap of last tier
272   */
273   function setTiersInfo(uint8 _noOfPhases, uint256[] _startTimes, uint256[] _endTimes, uint256[] _hardCaps ,uint256[] _minEtherContribution, uint8[2] _bonusPercentages)private {
274     
275     
276     require(_noOfPhases == 2);
277     
278     //Each array should contain info about each tier
279     require(_startTimes.length ==  2);
280    require(_endTimes.length == _noOfPhases);
281     require(_hardCaps.length == _noOfPhases);
282     require(_bonusPercentages.length == _noOfPhases);
283     
284     noOfPhases = _noOfPhases;
285     
286     for(uint8 i = 0; i < _noOfPhases; i++){
287 
288         require(_hardCaps[i] > 0);
289        
290         if(i>0){
291 
292             phases.push(PhaseInfo({
293                 hardcap:_hardCaps[i],
294                 startTime:_startTimes[i],
295                 endTime:_endTimes[i],
296                 minEtherContribution : _minEtherContribution[i],
297                 bonusPercentages:_bonusPercentages[i],
298                 weiRaised:0
299             }));
300         }
301         else{
302             //start time of tier1 should be greater than current time
303             require(_startTimes[i] > now);
304           
305             phases.push(PhaseInfo({
306                 hardcap:_hardCaps[i],
307                 startTime:_startTimes[i],
308                 minEtherContribution : _minEtherContribution[i],
309                 endTime:_endTimes[i],
310                 bonusPercentages:_bonusPercentages[i],
311                 weiRaised:0
312             }));
313         }
314     }
315   }
316   
317   
318     /**
319     * @dev Constructor method
320     * @param _tokenToBeUsed Address of the token to be used for Sales
321     * @param _wallet Address of the wallet which will receive the collected funds
322     */  
323     constructor (address _tokenToBeUsed, address _wallet)public nonZeroAddress(_tokenToBeUsed) nonZeroAddress(_wallet){
324         
325         token = Token(_tokenToBeUsed);
326         vault = new Vault(_wallet);
327         
328         uint256[] memory startTimes = new uint256[](2);
329         uint256[] memory endTimes = new uint256[](2);
330         uint256[] memory hardCaps = new uint256[](2);
331         uint256[] memory minEtherContribution = new uint256[](2);
332         uint8[2] memory bonusPercentages;
333         
334         //pre-sales
335         startTimes[0] = 1531180800; //JULY 10, 2018 00:00 AM GMT
336         endTimes[0] = 0; //NO END TIME INITIALLY
337         hardCaps[0] = 7500 ether;
338         minEtherContribution[0] = 0.3 ether;
339         bonusPercentages[0] = 20;
340         
341         //phase-1: Public Sale
342         startTimes[1] = 0; //NO START TIME INITIALLY
343         endTimes[1] = 0; //NO END TIME INITIALLY
344         hardCaps[1] = 12500 ether;
345         minEtherContribution[1] = 0.1 ether;
346         bonusPercentages[1] = 5;
347         
348         setTiersInfo(2, startTimes, endTimes, hardCaps, minEtherContribution, bonusPercentages);
349         
350     }
351     
352    //Fallback function used to buytokens
353    function()public payable{
354        buyTokens(msg.sender);
355    }
356 
357    function startNextPhase() public onlyOwner _saleNotEnded _contractUp _ifNotEmergencyStop returns(bool){
358 
359        int8 currentPhaseIndex = getCurrentlyRunningPhase();
360        
361        require(currentPhaseIndex == 0);
362 
363        PhaseInfo storage currentlyRunningPhase = phases[uint256(currentPhaseIndex)];
364        
365        uint256 tokensLeft;
366        uint256 tokensInPreICO = 7200000000000000; //considering 8 decimal places
367              
368        //Checking if tokens are left after the Pre ICO sale, if left, transfer all to the owner   
369        if(currentlyRunningPhase.weiRaised <= 7500 ether) {
370            tokensLeft = tokensInPreICO.sub(currentlyRunningPhase.weiRaised.mul(9600).div(10000000000));
371            token.transfer(msg.sender, tokensLeft);
372        }
373        
374        phases[0].endTime = now;
375        phases[1].startTime = now;
376 
377        return true;
378        
379    }
380 
381    /**
382    * @dev Must be called after sale ends, to do some extra finalization
383    * work. It finishes the sale, sends the unsold tokens to the owner's address 
384    * and transfer the remaining funds in contract to the owner.
385    */
386   function finishSale() public onlyOwner _contractUp _saleNotEnded returns (bool){
387       
388       int8 currentPhaseIndex = getCurrentlyRunningPhase();
389       require(currentPhaseIndex == 1);
390       
391       PhaseInfo storage currentlyRunningPhase = phases[uint256(currentPhaseIndex)];
392        
393       uint256 tokensLeft;
394       uint256 tokensInPublicSale = 10500000000000000; //considering 8 decimal places
395           
396           //Checking if tokens are left after the Public sale, if left, transfer all to the owner   
397        if(currentlyRunningPhase.weiRaised <= 12500 ether) {
398            tokensLeft = tokensInPublicSale.sub(currentlyRunningPhase.weiRaised.mul(8400).div(10000000000));
399            token.transfer(msg.sender, tokensLeft);
400        }
401       //End the sale
402       saleEnded = true;
403       
404       //Set the endTime of Public Sale
405       phases[noOfPhases-1].endTime = now;
406       
407       emit Finished(msg.sender, now);
408       return true;
409   }
410 
411    
412    /**
413    * @dev Low level token purchase function
414    * @param beneficiary The address who will receive the tokens for this transaction
415    */
416    function buyTokens(address beneficiary)public _contractUp _saleNotEnded _ifNotEmergencyStop nonZeroAddress(beneficiary) payable returns(bool){
417        
418        require(whitelisted[beneficiary]);
419 
420        int8 currentPhaseIndex = getCurrentlyRunningPhase();
421        assert(currentPhaseIndex >= 0);
422        
423         // recheck this for storage and memory
424        PhaseInfo storage currentlyRunningPhase = phases[uint256(currentPhaseIndex)];
425        
426        
427        uint256 weiAmount = msg.value;
428 
429        //Check hard cap for this phase has not been reached
430        require(weiAmount.add(currentlyRunningPhase.weiRaised) <= currentlyRunningPhase.hardcap);
431        
432        //check the minimum ether contribution
433        require(weiAmount >= currentlyRunningPhase.minEtherContribution);
434        
435        
436        uint256 tokens = weiAmount.mul(rate).div(10000000000);//considering decimal places to be 8 for token
437        
438        uint256 bonusedTokens = applyBonus(tokens, currentlyRunningPhase.bonusPercentages);
439 
440 
441        totalFunding = totalFunding.add(weiAmount);
442              
443        currentlyRunningPhase.weiRaised = currentlyRunningPhase.weiRaised.add(weiAmount);
444        
445        vault.deposit.value(msg.value)(msg.sender);
446        
447        token.transfer(beneficiary, bonusedTokens);
448        
449        emit TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
450 
451        return true;
452        
453    }
454    
455    //Check balance of token of each phase
456    function tokensLeftInPhase(int8 phase) public view returns(uint256) {
457        
458        PhaseInfo storage currentlyRunningPhase = phases[uint256(phase)];
459        uint256 tokensLeft;
460        
461        if(phase == 0) {
462             uint256 tokensInPreICO= 7200000000000000;
463             tokensLeft = tokensInPreICO.sub(currentlyRunningPhase.weiRaised.mul(9600).div(10000000000));
464             return tokensLeft;
465        }
466        else {
467            uint256 tokensInPublicSale = 10500000000000000;
468            tokensLeft = tokensInPublicSale.sub(currentlyRunningPhase.weiRaised.mul(8400).div(10000000000));
469             return tokensLeft;
470            }
471    }
472    
473     /**
474     *@dev Method to calculate bonus for the user as per currently running phase and contribution by the user
475     * @param tokens Total tokens purchased by the user
476     * @param percentage Array of bonus percentages for the phase
477     */
478      function applyBonus(uint256 tokens, uint8 percentage) private pure returns  (uint256) {
479          
480          uint256 tokensToAdd = 0;
481          tokensToAdd = tokens.mul(percentage).div(100);
482          return tokens.add(tokensToAdd);
483     }
484     
485    /**
486     * @dev returns the currently running tier index as per time
487     * Return -1 if no tier is running currently
488     * */
489    function getCurrentlyRunningPhase()public view returns(int8){
490       for(uint8 i=0;i<noOfPhases;i++){
491 
492           if(phases[i].startTime!=0 && now>=phases[i].startTime && phases[i].endTime == 0){
493               return int8(i);
494           }
495       }   
496       return -1;
497    }
498 
499    
500    // Add a user to the whitelist
501    function addUser(address user) public nonZeroAddress(user) onlyOwner returns (bool) {
502 
503        require(whitelisted[user] == false);
504        
505        whitelisted[user] = true;
506 
507        emit LogUserAdded(user);
508        
509        return true;
510 
511     }
512 
513     // Remove an user from the whitelist
514     function removeUser(address user) public nonZeroAddress(user) onlyOwner returns(bool){
515       
516         require(whitelisted[user] = true);
517 
518         whitelisted[user] = false;
519         
520         emit LogUserRemoved(user);
521         
522         return true;
523 
524 
525     }
526 
527     // Add many users in one go to the whitelist
528     function addManyUsers(address[] users)public onlyOwner {
529         
530         require(users.length < 100);
531 
532         for (uint8 index = 0; index < users.length; index++) {
533 
534              whitelisted[users[index]] = true;
535 
536              emit LogUserAdded(users[index]);
537 
538         }
539     }
540 
541      //Method to check whether a user is there in the whitelist or not
542     function checkUser(address user) onlyOwner public view  returns (bool){
543         return whitelisted[user];
544     }
545    
546    //method to check the user balance
547    function checkUserTokenBalance(address _user) public view returns(uint256) {
548        return token.balanceOf(_user);
549    }
550    
551    /**
552    * @dev Get funding info of user/address.
553    * It will return how much funding the user has made in terms of wei
554    */
555    function getFundingInfoForUser(address _user)public view nonZeroAddress(_user) returns(uint256){
556        return vault.deposited(_user);
557    }
558 
559    /**
560    * @dev Allow owner to withdraw funds to his wallet anytime in between the sale process 
561    */
562 
563     function withDrawFunds()public onlyOwner _contractUp {
564       
565        vault.withdrawToWallet();
566     }
567 }