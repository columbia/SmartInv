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
90  * is in progress. Funds will be transferred to owner once sale ends
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
119 contract ESTTokenSale is Ownable{
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
131       //rate of token :  1 EST = 0.00005804 ETH
132       uint256 public rate = 58040000000000;
133       /*
134       *There will be 4 phases
135       * 1. Pre-sale
136       * 2. ICO Phase 1
137       * 3. ICO Phase 2
138       * 4. ICO Phase 3
139       */
140       struct PhaseInfo{
141           uint256 cummulativeHardCap;
142           uint256 startTime;
143           uint256 endTime;
144           uint8 bonusPercentages;
145           uint256 weiRaised;
146       }
147       
148       //info of each phase
149       PhaseInfo[] public phases;
150       
151       //Total funding
152       uint256 public totalFunding;
153       
154       //total tokens available for sale
155       uint256 tokensAvailableForSale = 45050000000000000; //considering 8 decimal places
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
167       //Event to trigger Sale stop
168       event SaleStopped(address _owner, uint256 time);
169       
170       //Event to trigger normal flow of sale end
171       event SaleEnded(address _owner, uint256 time);
172       
173       //Event to add user to the whitelist
174       event LogUserAdded(address user);
175 
176       //Event to remove user to the whitelist
177       event LogUserRemoved(address user);
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
199         
200     modifier _saleEnded() {
201         require(saleEnded);
202         _;
203     }
204     
205     modifier _saleNotEnded() {
206         require(!saleEnded);
207         _;
208     }
209   
210     
211     /**
212     *     @dev Check if sale contract has enough tokens on its account balance 
213     *     to reward all possible participations within sale period
214     */
215     function powerUpContract() external onlyOwner {
216         // Contract should not be powered up previously
217         require(!contractUp);
218 
219         // Contract should have enough EST credits
220         require(token.balanceOf(this) >= tokensAvailableForSale);
221         
222         //activate the sale process
223         contractUp = true;
224     }
225     
226     //for Emergency/Hard stop of the sale
227     function emergencyStop() external onlyOwner _contractUp _saleNotEnded{
228     
229       saleEnded = true;    
230         
231       emit SaleStopped(msg.sender, now);
232     }
233     
234     /**
235    * @dev Must be called to end the sale
236    */
237 
238    function endSale() public onlyOwner _contractUp _saleNotEnded {
239 
240        require(saleTimeOver());
241 
242        saleEnded = true;
243        emit SaleEnded(msg.sender, now);
244    }
245     
246 
247       // @return true if all the tiers has been ended
248   function saleTimeOver() public view returns (bool) {
249     
250     return now > phases[noOfPhases-1].endTime;
251   }
252 
253   
254   /**
255   * @dev Can be called only once. The method to allow owner to set tier information
256   * @param _noOfPhases The integer to set number of tiers
257   * @param _startTimes The array containing start time of each tier
258   * @param _endTimes The array containing end time of each tier
259   * @param _cummulativeHardCaps The array containing cumulative hard cap for each tier
260   * @param _bonusPercentages The array containing bonus percentage for each tier
261   * The arrays should be in sync with each other. For each index 0 for each of the array should contain info about Tier 1, similarly for Tier2, 3 and 4 .
262   * Sales hard cap will be the hard cap of last tier
263   */
264   function setTiersInfo(uint8 _noOfPhases, uint256[] _startTimes, uint256[] _endTimes, uint256[] _cummulativeHardCaps, uint8[4] _bonusPercentages)private {
265     
266     
267     require(_noOfPhases == 4);
268     
269     //Each array should contain info about each tier
270     require(_startTimes.length == _noOfPhases);
271     require(_endTimes.length ==_noOfPhases);
272     require(_cummulativeHardCaps.length ==_noOfPhases);
273     require(_bonusPercentages.length ==_noOfPhases);
274     
275     noOfPhases = _noOfPhases;
276     
277     for(uint8 i = 0; i < _noOfPhases; i++){
278         require(_cummulativeHardCaps[i] > 0);
279         require(_endTimes[i] > _startTimes[i]);
280         if(i > 0){
281             
282             //start time of this tier should be greater than previous tier
283             require(_startTimes[i] > _endTimes[i-1]);
284             
285             phases.push(PhaseInfo({
286                 cummulativeHardCap:_cummulativeHardCaps[i],
287                 startTime:_startTimes[i],
288                 endTime:_endTimes[i],
289                 bonusPercentages:_bonusPercentages[i],
290                 weiRaised:0
291             }));
292         }
293         else{
294             //start time of tier1 should be greater than current time
295             require(_startTimes[i] > now);
296           
297             phases.push(PhaseInfo({
298                 cummulativeHardCap:_cummulativeHardCaps[i],
299                 startTime:_startTimes[i],
300                 endTime:_endTimes[i],
301                 bonusPercentages:_bonusPercentages[i],
302                 weiRaised:0
303             }));
304         }
305     }
306   }
307   
308   
309     /**
310     * @dev Constructor method
311     * @param _tokenToBeUsed Address of the token to be used for Sales
312     * @param _wallet Address of the wallet which will receive the collected funds
313     */  
314     constructor (address _tokenToBeUsed, address _wallet)public nonZeroAddress(_tokenToBeUsed) nonZeroAddress(_wallet){
315         
316         token = Token(_tokenToBeUsed);
317         vault = new Vault(_wallet);
318         
319         uint256[] memory startTimes = new uint256[](4);
320         uint256[] memory endTimes = new uint256[](4);
321         uint256[] memory cummulativeHardCaps = new uint256[](4);
322         uint8 [4] memory bonusPercentages;
323         
324         //pre-sales
325         startTimes[0] = 1532044800; //JULY 20, 2018 12:00:00 AM GMT
326         endTimes[0] = 1535759999; //AUGUST 31, 2018 11:59:59 PM GMT
327         cummulativeHardCaps[0] = 2107040600000000000000 wei;
328         bonusPercentages[0] = 67;
329         
330         //phase-1
331         startTimes[1] = 1535846400; //SEPTEMBER 02, 2018 12:00:00 AM GMT 
332         endTimes[1] = 1539647999; //OCTOBER 15, 2018 11:59:59 PM GMT
333         cummulativeHardCaps[1] = 7766345900000000000000 wei;
334         bonusPercentages[1] = 33;
335         
336         
337         //phase-2
338         startTimes[2] = 1539648000; //OCTOBER 16, 2018 12:00:00 AM GMT
339         endTimes[2] = 1543622399; //NOVEMBER 30, 2018 11:59:59 PM GMT
340         cummulativeHardCaps[2] = 14180545900000000000000 wei;
341         bonusPercentages[2] = 18;
342         
343         //phase-3
344         startTimes[3] = 1543622400; //DECEMBER 01, 2018 12:00:00 AM GMT
345         endTimes[3] = 1546300799; //DECEMBER 31, 2018 11:59:59 PM GMT
346         cummulativeHardCaps[3] = 21197987200000000000000 wei;
347         bonusPercentages[3] = 8;
348 
349         setTiersInfo(4, startTimes, endTimes, cummulativeHardCaps, bonusPercentages);
350         
351     }
352     
353 
354    //Fallback function used to buytokens
355    function()public payable{
356        buyTokens(msg.sender);
357    }
358    
359    function getFundingInfoOfPhase(uint8 phase) public view returns (uint256){
360        
361        PhaseInfo storage currentlyRunningPhase = phases[uint256(phase)];
362        
363        return currentlyRunningPhase.weiRaised;
364        
365    } 
366    
367    /**
368    * @dev Low level token purchase function
369    * @param beneficiary The address who will receive the tokens for this transaction
370    */
371    function buyTokens(address beneficiary)public _contractUp _saleNotEnded nonZeroAddress(beneficiary) payable returns(bool){
372        
373        require(whitelisted[beneficiary]);
374 
375        int8 currentPhaseIndex = getCurrentlyRunningPhase();
376        assert(currentPhaseIndex >= 0);
377        
378         // recheck this for storage and memory
379        PhaseInfo storage currentlyRunningPhase = phases[uint256(currentPhaseIndex)];
380        
381        
382        uint256 weiAmount = msg.value;
383 
384        //Check cummulative Hard Cap for this phase has not been reached
385        require(weiAmount.add(totalFunding) <= currentlyRunningPhase.cummulativeHardCap);
386        
387        
388        uint256 tokens = weiAmount.div(rate).mul(100000000);//considering decimal places to be 8 for token
389        
390        uint256 bonusedTokens = applyBonus(tokens, currentlyRunningPhase.bonusPercentages);
391              
392        totalFunding = totalFunding.add(weiAmount);
393        
394        currentlyRunningPhase.weiRaised = currentlyRunningPhase.weiRaised.add(weiAmount);
395        
396        vault.deposit.value(msg.value)(msg.sender);
397        
398        token.transfer(beneficiary, bonusedTokens);
399        
400        emit TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
401 
402        return true;
403        
404    }
405    
406     /**
407     *@dev Method to calculate bonus for the user as per currently running phase and contribution by the user
408     * @param tokens Total tokens purchased by the user
409     * @param percentage  of bonus  for the phase 
410     */
411      function applyBonus(uint256 tokens, uint8 percentage) private pure returns  (uint256) {
412          
413          uint256 tokensToAdd = 0;
414          tokensToAdd = tokens.mul(percentage).div(100);
415          return tokens.add(tokensToAdd);
416     } 
417     
418    /**
419     * @dev returns the currently running tier index as per time
420     * Return -1 if no tier is running currently
421     * */
422    function getCurrentlyRunningPhase()public view returns(int8){
423       for(uint8 i = 0; i < noOfPhases; i++){
424           if(now >= phases[i].startTime && now <= phases[i].endTime){
425               return int8(i);
426           }
427       }   
428       return -1;
429    }
430    
431    // Add a user to the whitelist
432    function addUser(address user) public nonZeroAddress(user) onlyOwner returns (bool) {
433 
434        require(whitelisted[user] == false);
435        
436        whitelisted[user] = true;
437 
438        emit LogUserAdded(user);
439        
440        return true;
441 
442     }
443 
444     // Remove an user from the whitelist
445     function removeUser(address user) public nonZeroAddress(user) onlyOwner returns(bool){
446       
447         require(whitelisted[user] = true);
448 
449         whitelisted[user] = false;
450         
451         emit LogUserRemoved(user);
452         
453         return true;
454 
455 
456     }
457 
458     // Add many users in one go to the whitelist
459     function addManyUsers(address[] users)public onlyOwner {
460         
461         require(users.length < 100);
462 
463         for (uint8 index = 0; index < users.length; index++) {
464 
465              whitelisted[users[index]] = true;
466 
467              emit LogUserAdded(users[index]);
468 
469         }
470     }
471 
472      //Method to check whether a user is there in the whitelist or not
473     function checkUser(address user) onlyOwner public view  returns (bool){
474         return whitelisted[user];
475     }
476    
477    /**
478    * @dev Get funding info of user/address. It will return how much funding the user has made in terms of wei
479    */
480    function getFundingInfoForUser(address _user)public view nonZeroAddress(_user) returns(uint256){
481        return vault.deposited(_user);
482    }
483    
484    
485    /**
486    *@dev Method to transfer all remanining tokens left to owner left with the sales contract after the sale has ended
487    */
488    function transferRemainingTokens()public onlyOwner _contractUp _saleEnded {
489        
490        token.transfer(msg.sender,address(this).balance);
491       
492    }
493    
494    //method to check how many tokens are left
495    function tokensLeftForSale() public view returns (uint256){
496        return token.balanceOf(address(this));
497    }
498    
499    //method to check the user balance
500    function checkUserTokenBalance(address _user) public view returns(uint256) {
501        return token.balanceOf(_user);
502    }
503    
504    //method to check how many tokens have been sold out till now out of 450.5 Million
505    function tokensSold() public view returns (uint256) {
506        return tokensAvailableForSale.sub(token.balanceOf(address(this)));
507    }
508    
509    //Allowing owner to transfer the  money rasied to the wallet address
510    function withDrawFunds()public onlyOwner _contractUp {
511       
512        vault.withdrawToWallet();
513     }
514       
515 }