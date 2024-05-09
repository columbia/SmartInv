1 pragma solidity 0.4.25;
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
75      emit OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 interface Token {
82     function transfer(address _to, uint256 _amount) external  returns (bool success);
83     function balanceOf(address _owner) external view returns (uint256 balance);
84     function decimals()external view returns (uint8);
85 }
86 
87 /**
88  * @title Vault
89  * @dev This contract is used for storing funds while a crowdsale
90  * is in progress. Funds will be transferred to owner whenever the transaction is initiated
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
111     function withdrawToWallet() onlyOwner public{
112     
113     wallet.transfer(address(this).balance);
114      emit Withdrawn(wallet);
115   }
116 }
117 
118 
119 contract BitUnioTokenSale is Ownable{
120       using SafeMath for uint256;
121       
122       //Token to be used for this sale
123       Token public token;
124       
125       //All funds will go into this vault
126       Vault public vault;
127 
128      // This mapping stores the addresses of whitelisted users
129       mapping(address => bool) public whitelisted;
130   
131       /*
132       *There will be 4 phases
133       * 1. ICO Phase 1
134       * 2. ICO Phase 2
135       * 3. ICO Phase 3
136       * 4. ICO Phase 4
137       */
138       struct PhaseInfo{
139           uint256 cummulativeHardCap;
140           uint256 startTime;
141           uint256 endTime;
142           uint8 bonusPercentages;
143           uint256 weiRaised;
144           uint256 rate;
145       }
146       
147       //info of each phase
148       PhaseInfo[] public phases;
149       
150       //Total funding
151       uint256 public totalFunding;
152       
153       //total tokens available for sale = 10 Billion
154       uint256 tokensAvailableForSale = 10000000000000000000000000000; //considering 18 decimal places
155       
156       
157       uint8 public noOfPhases;
158       
159       
160       //Keep track of whether contract is up or not
161       bool public contractUp;
162       
163       //Keep track of whether the sale has ended or not
164       bool public saleEnded;
165       
166       //Event to trigger Sale stop
167       event SaleStopped(address _owner, uint256 time);
168       
169       //Event to trigger normal flow of sale end
170       event SaleEnded(address _owner, uint256 time);
171       
172       //Event to add user to the whitelist
173       event LogUserAdded(address user);
174 
175       //Event to remove user to the whitelist
176       event LogUserRemoved(address user);
177     
178      /**
179      * event for token purchase logging
180      * @param purchaser who paid for the tokens
181      * @param beneficiary who got the tokens
182      * @param value weis paid for purchase
183      * @param amount amount of tokens purchased
184      */
185      event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
186     
187     //modifiers    
188     modifier _contractUp(){
189         require(contractUp);
190         _;
191     }
192   
193      modifier nonZeroAddress(address _to) {
194         require(_to != address(0));
195         _;
196     }
197     
198         
199     modifier _saleEnded() {
200         require(saleEnded);
201         _;
202     }
203 
204     modifier minEthContribution() {
205         require(msg.value >= 0.1 ether);
206         _;
207     }
208     
209     modifier _saleNotEnded() {
210         require(!saleEnded);
211         _;
212     }
213   
214     
215     /**
216     *     @dev Check if sale contract has enough tokens on its account balance 
217     *     to reward all possible participations within sale period
218     */
219     function powerUpContract() external onlyOwner {
220         // Contract should not be powered up previously
221         require(!contractUp,"Oops, contract already up");
222 
223         // Contract should have enough EST credits
224         require(token.balanceOf(this) >= tokensAvailableForSale);
225         
226         //activate the sale process
227         contractUp = true;
228     }
229     
230     //for Emergency/Hard stop of the sale
231     function emergencyStop() external onlyOwner _contractUp _saleNotEnded{
232     
233       saleEnded = true;    
234         
235       emit SaleStopped(msg.sender, now);
236     }
237     
238     /**
239    * @dev Must be called to end the sale
240    */
241 
242    function endSale() public onlyOwner _contractUp _saleNotEnded {
243 
244        require(saleTimeOver(),"Sale is in progress");
245 
246        saleEnded = true;
247        emit SaleEnded(msg.sender, now);
248    }
249     
250 
251       // @return true if all the tiers has been ended
252   function saleTimeOver() public view returns (bool) {
253     
254     return now > phases[noOfPhases-1].endTime;
255   }
256 
257   
258   /**
259   * @dev Can be called only once. The method to allow owner to set tier information
260   * @param _noOfPhases The integer to set number of tiers
261   * @param _startTimes The array containing start time of each tier
262   * @param _endTimes The array containing end time of each tier
263   * @param _cummulativeHardCaps The array containing cumulative hard cap for each tier
264   * @param _bonusPercentages The array containing bonus percentage for each tier
265   * The arrays should be in sync with each other. For each index 0 for each of the array should contain info about Tier 1, similarly for Tier2, 3 and 4 .
266   * Sales hard cap will be the hard cap of last tier
267   */
268   function setTiersInfo(uint8 _noOfPhases, uint256[] _startTimes, uint256[] _endTimes, uint256[] _cummulativeHardCaps, uint8[4] _bonusPercentages, uint256[] _rates)
269   private {
270     
271     
272     require(_noOfPhases == 4);
273     
274     //Each array should contain info about each tier
275     require(_startTimes.length == _noOfPhases);
276     require(_endTimes.length ==_noOfPhases);
277     require(_cummulativeHardCaps.length ==_noOfPhases);
278     require(_bonusPercentages.length ==_noOfPhases);
279     require(_rates.length == _noOfPhases);
280     
281     noOfPhases = _noOfPhases;
282     
283     for(uint8 i = 0; i < _noOfPhases; i++){
284         require(_cummulativeHardCaps[i] > 0);
285         require(_endTimes[i] > _startTimes[i]);
286         if(i > 0){
287             
288             //start time of this tier should be greater than previous tier
289             require(_startTimes[i] > _endTimes[i-1]);
290             
291             phases.push(PhaseInfo({
292                 cummulativeHardCap:_cummulativeHardCaps[i],
293                 startTime:_startTimes[i],
294                 endTime:_endTimes[i],
295                 bonusPercentages:_bonusPercentages[i],
296                 weiRaised:0,
297                 rate: _rates[i]
298             }));
299         }
300         else{
301             //start time of tier1 should be greater than current time
302             require(_startTimes[i] > now);
303           
304             phases.push(PhaseInfo({
305                 cummulativeHardCap:_cummulativeHardCaps[i],
306                 startTime:_startTimes[i],
307                 endTime:_endTimes[i],
308                 bonusPercentages:_bonusPercentages[i],
309                 weiRaised:0,
310                 rate: _rates[i]
311             }));
312         }
313     }
314   }
315   
316   
317     /**
318     * @dev Constructor method
319     * @param _tokenToBeUsed Address of the token to be used for Sales
320     * @param _wallet Address of the wallet which will receive the collected funds
321     */  
322     constructor (address _tokenToBeUsed, address _wallet)public nonZeroAddress(_tokenToBeUsed) nonZeroAddress(_wallet){
323         
324         token = Token(_tokenToBeUsed);
325         vault = new Vault(_wallet);
326         
327         uint256[] memory startTimes = new uint256[](4);
328         uint256[] memory endTimes = new uint256[](4);
329         uint256[] memory cummulativeHardCaps = new uint256[](4);
330         uint8 [4] memory bonusPercentages;
331         uint256[] memory rates = new uint256[](4);
332         
333         //phase-1
334         startTimes[0] = 1547078400; //JANUARY 10, 2010 12:00:00 AM GMT
335         endTimes[0] = 1549756799; //FEBUARY 09, 2019 11:59:59 PM GMT
336         cummulativeHardCaps[0] = 72727272700000000000000 wei;
337         bonusPercentages[0] = 10;
338         rates[0] = 50000 ;
339         
340         //phase-2
341         startTimes[1] = 1549756800; //FEBUARY 10, 2019 12:00:00 AM GMT 
342         endTimes[1] = 1552175999; //MARCH 09, 2019 11:59:59 PM GMT
343         cummulativeHardCaps[1] = 109090909090900000000000 wei;
344         bonusPercentages[1] = 10;
345         rates[1] = 25000;
346             
347         
348         //phase-3
349         startTimes[2] = 1552176000; //MARCH 10, 2019 12:00:00 AM GMT
350         endTimes[2] = 1554854399; //APRIL 09, 2019 11:59:59 PM GMT
351         cummulativeHardCaps[2] = 109090909090900000000000 wei;
352         bonusPercentages[2] = 10;
353         rates[2] = SafeMath.div(50000,3);
354         
355         //phase-4
356         startTimes[3] = 1554854400; //APRIL 10, 2019 12:00:00 AM GMT
357         endTimes[3] = 1557446399; //MAY 09, 2019 11:59:59 PM GMT
358         cummulativeHardCaps[3] = 72727272700000000000000 wei;
359         bonusPercentages[3] = 10;
360         rates[3] = 12500;
361 
362         setTiersInfo(4, startTimes, endTimes, cummulativeHardCaps, bonusPercentages,rates);
363         
364     }
365     
366 
367    //Fallback function used to buytokens
368    function()public payable{
369        buyTokens(msg.sender);
370    }
371    
372    function getFundingInfoOfPhase(uint8 phase) public view returns (uint256){
373        
374        PhaseInfo storage currentlyRunningPhase = phases[uint256(phase)];
375        
376        return currentlyRunningPhase.weiRaised;
377        
378    } 
379    
380    /**
381    * @dev Low level token purchase function
382    * @param beneficiary The address who will receive the tokens for this transaction
383    */
384    function buyTokens(address beneficiary)public _contractUp _saleNotEnded minEthContribution nonZeroAddress(beneficiary) payable returns(bool){
385        
386        require(whitelisted[beneficiary],"Beneficiary not whitelisted");
387 
388        int8 currentPhaseIndex = getCurrentlyRunningPhase();
389        assert(currentPhaseIndex >= 0);
390        
391         // recheck this for storage and memory
392        PhaseInfo storage currentlyRunningPhase = phases[uint256(currentPhaseIndex)];
393        
394        
395        uint256 weiAmount = msg.value;
396 
397        //Check Hard Cap for this phase has not been reached
398        require(currentlyRunningPhase.weiRaised.add(weiAmount) <= currentlyRunningPhase.cummulativeHardCap,"Hardcap for this phase has reached");
399        
400        
401        uint256 tokens = weiAmount.mul(currentlyRunningPhase.rate);//considering decimal places to be 18 for token
402        
403        uint256 bonusedTokens = applyBonus(tokens, currentlyRunningPhase.bonusPercentages);
404              
405        totalFunding = totalFunding.add(weiAmount);
406        
407        currentlyRunningPhase.weiRaised = currentlyRunningPhase.weiRaised.add(weiAmount);
408        
409        vault.deposit.value(msg.value)(msg.sender);
410        
411        token.transfer(beneficiary, bonusedTokens);
412        
413        emit TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
414 
415        return true;
416        
417    }
418    
419     /**
420     *@dev Method to calculate bonus for the user as per currently running phase and contribution by the user
421     * @param tokens Total tokens purchased by the user
422     * @param percentage  of bonus  for the phase 
423     */
424      function applyBonus(uint256 tokens, uint8 percentage) private pure returns  (uint256) {
425          
426          uint256 tokensToAdd = 0;
427          tokensToAdd = tokens.mul(percentage).div(100);
428          return tokens.add(tokensToAdd);
429     } 
430     
431     
432     //method to start the next phase of the ICO
433     function startNextPhase() public onlyOwner _saleNotEnded _contractUp returns(bool) {
434 
435        int8 currentPhaseIndex = getCurrentlyRunningPhase();
436        
437        phases[uint256(currentPhaseIndex)].endTime = now;
438        phases[uint256(currentPhaseIndex) + 1].startTime = now;
439 
440        return true;
441        
442    }
443     
444    /**
445     * @dev returns the currently running tier index as per time
446     * Return -1 if no tier is running currently
447     * */
448    function getCurrentlyRunningPhase()public view returns(int8){
449       for(uint8 i = 0; i < noOfPhases; i++){
450           if(now >= phases[i].startTime && now <= phases[i].endTime){
451               return int8(i);
452           }
453       }   
454       return -1;
455    }
456    
457    // Add a user to the whitelist
458    function addUser(address user) public nonZeroAddress(user) onlyOwner returns (bool) {
459 
460        require(whitelisted[user] == false);
461        
462        whitelisted[user] = true;
463 
464        emit LogUserAdded(user);
465        
466        return true;
467 
468     }
469 
470     // Remove an user from the whitelist
471     function removeUser(address user) public nonZeroAddress(user) onlyOwner returns(bool){
472       
473         require(whitelisted[user] = true);
474 
475         whitelisted[user] = false;
476         
477         emit LogUserRemoved(user);
478         
479         return true;
480 
481 
482     }
483 
484     // Add many users in one go to the whitelist
485     function addManyUsers(address[] users)public onlyOwner {
486         
487         require(users.length < 100);
488 
489         for (uint8 index = 0; index < users.length; index++) {
490 
491              whitelisted[users[index]] = true;
492 
493              emit LogUserAdded(users[index]);
494 
495         }
496     }
497 
498      //Method to check whether a user is there in the whitelist or not
499     function checkUser(address user) onlyOwner public view  returns (bool){
500         return whitelisted[user];
501     }
502    
503    /**
504    * @dev Get funding info of user/address. It will return how much funding the user has made in terms of wei
505    */
506    function getFundingInfoForUser(address _user)public view nonZeroAddress(_user) returns(uint256){
507        return vault.deposited(_user);
508    }
509    
510    
511    /**
512    *@dev Method to transfer all remanining tokens left to owner left with the sales contract after the sale has ended
513    */
514    function transferRemainingTokens()public onlyOwner _contractUp _saleEnded {
515        
516        token.transfer(msg.sender,address(this).balance);
517       
518    }
519    
520    //method to check how many tokens are left
521    function tokensLeftForSale() public view returns (uint256){
522        return token.balanceOf(address(this));
523    }
524    
525    //method to check the user balance
526    function checkUserTokenBalance(address _user) public view returns(uint256) {
527        return token.balanceOf(_user);
528    }
529    
530    //method to check how many tokens have been sold out till now out of 10 billion
531    function tokensSold() public view returns (uint256) {
532        return tokensAvailableForSale.sub(token.balanceOf(address(this)));
533    }
534    
535    //Allowing owner to transfer the  money rasied to the wallet address
536    function withDrawFunds()public onlyOwner _contractUp {
537       
538        vault.withdrawToWallet();
539     }
540       
541 }