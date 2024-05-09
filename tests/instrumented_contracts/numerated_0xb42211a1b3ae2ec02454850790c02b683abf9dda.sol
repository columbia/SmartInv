1 pragma solidity 0.4.23;
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
55   function Ownable() public {
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
83     function balanceOf(address _owner) external returns (uint256 balance);
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
100     function Vault(address _wallet) public {
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
113      wallet.transfer(this.balance);
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
129       //rate of token in ether 1ETH = 8000 CLX
130       uint256 public rate = 8000;
131       
132       /*
133       *There will be 2 phases
134       * 1. Pre-sale
135       * 2. ICO Phase 1
136       */
137 
138       struct PhaseInfo{
139           uint256 hardcap;
140           uint256 startTime;
141           uint256 endTime;
142           uint8   bonusPercentages;
143           uint256 minEtherContribution;
144           uint256 weiRaised;
145       }
146       
147          
148       //info of each phase
149       PhaseInfo[] public phases;
150       
151       //Total funding
152       uint256 public totalFunding;
153 
154       //total tokens available for sale considering 8 decimal places
155       uint256 tokensAvailableForSale = 17700000000000000;
156       
157       
158       uint8 public noOfPhases;
159       
160       
161       //Keep track of whether contract is up or not
162       bool public contractUp;
163       
164       //Keep track of whether the sale has ended or not
165       bool public saleEnded;
166 
167        //Keep track of emergency stop
168       bool public ifEmergencyStop ;
169       
170       //Event to trigger Sale stop
171       event SaleStopped(address _owner, uint256 time);
172       
173       //Event to trigger Sale restart
174       event SaleRestarted(address _owner, uint256 time);
175       
176       //Event to trigger normal flow of sale end
177       event Finished(address _owner, uint256 time);
178     
179      /**
180      * event for token purchase logging
181      * @param purchaser who paid for the tokens
182      * @param beneficiary who got the tokens
183      * @param value weis paid for purchase
184      * @param amount amount of tokens purchased
185      */
186      event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
187     
188     //modifiers    
189     modifier _contractUp(){
190         require(contractUp);
191         _;
192     }
193   
194      modifier nonZeroAddress(address _to) {
195         require(_to != address(0));
196         _;
197     }
198     
199     modifier _saleEnded() {
200         require(saleEnded);
201         _;
202     }
203     
204     modifier _saleNotEnded() {
205         require(!saleEnded);
206         _;
207     }
208 
209     modifier _ifNotEmergencyStop() {
210         require(!ifEmergencyStop);
211         _;
212     }
213 
214     /**
215     *     @dev Check if sale contract has enough tokens on its account balance 
216     *     to reward all possible participations within sale period
217     */
218     function powerUpContract() external onlyOwner {
219         // Contract should not be powered up previously
220         require(!contractUp);
221 
222         // Contract should have enough CLX credits
223         require(token.balanceOf(this) >= tokensAvailableForSale);
224         
225         //activate the sale process
226         contractUp = true;
227     }
228     
229     //for Emergency stop of the sale
230     function emergencyStop() external onlyOwner _contractUp _ifNotEmergencyStop {
231        
232         ifEmergencyStop = true;  
233         
234         emit SaleStopped(msg.sender, now);
235     }
236 
237     //to restart the sale after emergency stop
238     function emergencyRestart() external onlyOwner _contractUp  {
239         require(ifEmergencyStop);
240        
241         ifEmergencyStop = false;
242 
243         emit SaleRestarted(msg.sender, now);
244     }
245   
246       // @return true if all the tiers has been ended
247   function saleTimeOver() public view returns (bool) {
248     
249     return (phases[noOfPhases-1].endTime != 0);
250   }
251   
252    
253   /**
254   * @dev Can be called only once. The method to allow owner to set tier information
255   * @param _noOfPhases The integer to set number of tiers
256   * @param _startTimes The array containing start time of each tier
257   * @param _endTimes The array containing end time of each tier
258   * @param _hardCaps The array containing hard cap for each tier
259   * @param _bonusPercentages The array containing bonus percentage for each tier
260   * The arrays should be in sync with each other. For each index 0 for each of the array should contain info about Tier 1, similarly for Tier2, 3 and 4 .
261   * Sales hard cap will be the hard cap of last tier
262   */
263   function setTiersInfo(uint8 _noOfPhases, uint256[] _startTimes, uint256[] _endTimes, uint256[] _hardCaps ,uint256[] _minEtherContribution, uint8[2] _bonusPercentages)private {
264     
265     
266     require(_noOfPhases == 2);
267     
268     //Each array should contain info about each tier
269     require(_startTimes.length ==  2);
270    require(_endTimes.length == _noOfPhases);
271     require(_hardCaps.length == _noOfPhases);
272     require(_bonusPercentages.length == _noOfPhases);
273     
274     noOfPhases = _noOfPhases;
275     
276     for(uint8 i = 0; i < _noOfPhases; i++){
277 
278         require(_hardCaps[i] > 0);
279        
280         if(i>0){
281 
282             phases.push(PhaseInfo({
283                 hardcap:_hardCaps[i],
284                 startTime:_startTimes[i],
285                 endTime:_endTimes[i],
286                 minEtherContribution : _minEtherContribution[i],
287                 bonusPercentages:_bonusPercentages[i],
288                 weiRaised:0
289             }));
290         }
291         else{
292             //start time of tier1 should be greater than current time
293             require(_startTimes[i] > now);
294           
295             phases.push(PhaseInfo({
296                 hardcap:_hardCaps[i],
297                 startTime:_startTimes[i],
298                 minEtherContribution : _minEtherContribution[i],
299                 endTime:_endTimes[i],
300                 bonusPercentages:_bonusPercentages[i],
301                 weiRaised:0
302             }));
303         }
304     }
305   }
306   
307   
308     /**
309     * @dev Constructor method
310     * @param _tokenToBeUsed Address of the token to be used for Sales
311     * @param _wallet Address of the wallet which will receive the collected funds
312     */  
313     function CLXTokenSale(address _tokenToBeUsed, address _wallet)public nonZeroAddress(_tokenToBeUsed) nonZeroAddress(_wallet){
314         
315         token = Token(_tokenToBeUsed);
316         vault = new Vault(_wallet);
317         
318         uint256[] memory startTimes = new uint256[](2);
319         uint256[] memory endTimes = new uint256[](2);
320         uint256[] memory hardCaps = new uint256[](2);
321         uint256[] memory minEtherContribution = new uint256[](2);
322         uint8[2] memory bonusPercentages;
323         
324         //pre-sales
325         startTimes[0] = 1525910400; //MAY 10, 2018 00:00 AM GMT
326         endTimes[0] = 0; //NO END TIME INITIALLY
327         hardCaps[0] = 7500 ether;
328         minEtherContribution[0] = 0.3 ether;
329         bonusPercentages[0] = 20;
330         
331         //phase-1: Public Sale
332         startTimes[1] = 0; //NO START TIME INITIALLY
333         endTimes[1] = 0; //NO END TIME INITIALLY
334         hardCaps[1] = 12500 ether;
335         minEtherContribution[1] = 0.1 ether;
336         bonusPercentages[1] = 5;
337         
338         setTiersInfo(2, startTimes, endTimes, hardCaps, minEtherContribution, bonusPercentages);
339         
340     }
341     
342    //Fallback function used to buytokens
343    function()public payable{
344        buyTokens(msg.sender);
345    }
346 
347    function startNextPhase() public onlyOwner _saleNotEnded _contractUp _ifNotEmergencyStop returns(bool){
348 
349        int8 currentPhaseIndex = getCurrentlyRunningPhase();
350        
351        require(currentPhaseIndex == 0);
352 
353        PhaseInfo storage currentlyRunningPhase = phases[uint256(currentPhaseIndex)];
354        
355        uint256 tokensLeft;
356        uint256 tokensInPreICO = 7200000000000000; //considering 8 decimal places
357              
358        //Checking if tokens are left after the Pre ICO sale, if left, transfer all to the owner   
359        if(currentlyRunningPhase.weiRaised <= 7500 ether) {
360            tokensLeft = tokensInPreICO.sub(currentlyRunningPhase.weiRaised.mul(9600).div(10000000000));
361            token.transfer(msg.sender, tokensLeft);
362        }
363        
364        phases[0].endTime = now;
365        phases[1].startTime = now;
366 
367        return true;
368        
369    }
370 
371    /**
372    * @dev Must be called to end the sale, to do some extra finalization
373    * work. It finishes the sale, sends the unsold tokens to the owner's address
374    * IMP : Call withdrawFunds() before finishing the sale 
375    */
376   function finishSale() public onlyOwner _contractUp _saleNotEnded returns (bool){
377       
378       int8 currentPhaseIndex = getCurrentlyRunningPhase();
379       require(currentPhaseIndex == 1);
380       
381       PhaseInfo storage currentlyRunningPhase = phases[uint256(currentPhaseIndex)];
382        
383       uint256 tokensLeft;
384       uint256 tokensInPublicSale = 10500000000000000; //considering 8 decimal places
385           
386           //Checking if tokens are left after the Public sale, if left, transfer all to the owner   
387        if(currentlyRunningPhase.weiRaised <= 12500 ether) {
388            tokensLeft = tokensInPublicSale.sub(currentlyRunningPhase.weiRaised.mul(8400).div(10000000000));
389            token.transfer(msg.sender, tokensLeft);
390        }
391       //End the sale
392       saleEnded = true;
393       
394       //Set the endTime of Public Sale
395       phases[noOfPhases-1].endTime = now;
396       
397       emit Finished(msg.sender, now);
398       return true;
399   }
400 
401    
402    /**
403    * @dev Low level token purchase function
404    * @param beneficiary The address who will receive the tokens for this transaction
405    */
406    function buyTokens(address beneficiary)public _contractUp _saleNotEnded _ifNotEmergencyStop nonZeroAddress(beneficiary) payable returns(bool){
407        
408        int8 currentPhaseIndex = getCurrentlyRunningPhase();
409        assert(currentPhaseIndex >= 0);
410        
411         // recheck this for storage and memory
412        PhaseInfo storage currentlyRunningPhase = phases[uint256(currentPhaseIndex)];
413        
414        
415        uint256 weiAmount = msg.value;
416 
417        //Check hard cap for this phase has not been reached
418        require(weiAmount.add(currentlyRunningPhase.weiRaised) <= currentlyRunningPhase.hardcap);
419        
420        //check the minimum ether contribution
421        require(weiAmount >= currentlyRunningPhase.minEtherContribution);
422        
423        
424        uint256 tokens = weiAmount.mul(rate).div(10000000000);//considering decimal places to be 8 for token
425        
426        uint256 bonusedTokens = applyBonus(tokens, currentlyRunningPhase.bonusPercentages);
427 
428 
429        totalFunding = totalFunding.add(weiAmount);
430              
431        currentlyRunningPhase.weiRaised = currentlyRunningPhase.weiRaised.add(weiAmount);
432        
433        vault.deposit.value(msg.value)(msg.sender);
434        
435        token.transfer(beneficiary, bonusedTokens);
436        
437        emit TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
438 
439        return true;
440        
441    }
442    
443     /**
444     *@dev Method to calculate bonus for the user as per currently running phase and contribution by the user
445     * @param tokens Total tokens purchased by the user
446     * @param percentage Array of bonus percentages for the phase
447     */
448      function applyBonus(uint256 tokens, uint8 percentage) private pure returns  (uint256) {
449          
450          uint256 tokensToAdd = 0;
451          tokensToAdd = tokens.mul(percentage).div(100);
452          return tokens.add(tokensToAdd);
453     }
454     
455    /**
456     * @dev returns the currently running tier index as per time
457     * Return -1 if no tier is running currently
458     * */
459    function getCurrentlyRunningPhase()public view returns(int8){
460       for(uint8 i=0;i<noOfPhases;i++){
461 
462           if(phases[i].startTime!=0 && now>=phases[i].startTime && phases[i].endTime == 0){
463               return int8(i);
464           }
465       }   
466       return -1;
467    }
468    
469    
470    /**
471    * @dev Get funding info of user/address.
472    * It will return how much funding the user has made in terms of wei
473    */
474    function getFundingInfoForUser(address _user)public view nonZeroAddress(_user) returns(uint256){
475        return vault.deposited(_user);
476    }
477 
478    /**
479    * @dev Allow owner to withdraw funds to his wallet anytime in between the sale process 
480    */
481 
482     function withDrawFunds()public onlyOwner _saleNotEnded _contractUp {
483       
484        vault.withdrawToWallet();
485     }
486 }