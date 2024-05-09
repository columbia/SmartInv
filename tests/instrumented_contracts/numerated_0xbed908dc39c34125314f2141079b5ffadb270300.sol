1 pragma solidity 0.4.21;
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
82     function transfer(address _to, uint256 _amount) public returns (bool success);
83     function balanceOf(address _owner) public view returns (uint256 balance);
84     function decimals()public view returns (uint8);
85     function burnAllTokens() public;
86 }
87 
88 /**
89  * @title Vault
90  * @dev This contract is used for storing funds while a crowdsale
91  * is in progress. Funds will be transferred to owner once sale ends
92  */
93 contract Vault is Ownable {
94     using SafeMath for uint256;
95 
96     enum State { Active, Refunding, Withdraw }
97 
98     mapping (address => uint256) public deposited;
99     address public wallet;
100     State public state;
101 
102     event Withdraw();
103     event RefundsEnabled();
104     event Withdrawn(address _wallet);
105     event Refunded(address indexed beneficiary, uint256 weiAmount);
106       
107     function Vault(address _wallet) public {
108         require(_wallet != address(0));
109         wallet = _wallet;
110         state = State.Active;
111     }
112 
113     function deposit(address investor) public onlyOwner  payable{
114         
115         require(state == State.Active || state == State.Withdraw);//allowing to deposit even in withdraw state since withdraw state will be started once totalFunding reaches 10,000 ether
116         deposited[investor] = deposited[investor].add(msg.value);
117         
118     }
119 
120     function activateWithdrawal() public onlyOwner {
121         if(state == State.Active){
122           state = State.Withdraw;
123           emit Withdraw();
124         }
125     }
126     
127     function activateRefund()public onlyOwner {
128         require(state == State.Active);
129         state = State.Refunding;
130         emit RefundsEnabled();
131     }
132     
133     function withdrawToWallet() onlyOwner public{
134     require(state == State.Withdraw);
135     wallet.transfer(this.balance);
136     emit Withdrawn(wallet);
137   }
138   
139    function refund(address investor) public {
140     require(state == State.Refunding);
141     uint256 depositedValue = deposited[investor];
142     deposited[investor] = 0;
143     investor.transfer(depositedValue);
144     emit Refunded(investor, depositedValue);
145   }
146   
147  function isRefunding()public onlyOwner view returns(bool) {
148      return (state == State.Refunding);
149  }
150 }
151 
152 
153 contract DroneTokenSale is Ownable{
154       using SafeMath for uint256;
155       
156       //Token to be used for this sale
157       Token public token;
158       
159       //All funds will go into this vault
160       Vault public vault;
161   
162       //rate of token in ether 1eth = 20000 DRONE
163       uint256 public rate = 20000;
164       /*
165       *There will be 4 phases
166       * 1. Pre-sale
167       * 2. ICO Phase 1
168       * 3. ICO Phase 2
169       * 4. ICO Phase 3
170       */
171       struct PhaseInfo{
172           uint256 hardcap;
173           uint256 startTime;
174           uint256 endTime;
175           uint8 [3] bonusPercentages;//3 type of bonuses above 100eth, 10-100ether, less than 10ether
176           uint256 weiRaised;
177       }
178       
179       //info of each phase
180       PhaseInfo[] public phases;
181       
182       //Total funding
183       uint256 public totalFunding;
184       
185       //total tokesn available for sale
186       uint256 tokensAvailableForSale = 3000000000;
187       
188       
189       uint8 public noOfPhases;
190       
191       
192       //Keep track of whether contract is up or not
193       bool public contractUp;
194       
195       //Keep track of whether the sale has ended or not
196       bool public saleEnded;
197       
198       //Event to trigger Sale stop
199       event SaleStopped(address _owner, uint256 time);
200       
201       //Event to trigger normal flow of sale end
202       event Finalized(address _owner, uint256 time);
203     
204      /**
205      * event for token purchase logging
206      * @param purchaser who paid for the tokens
207      * @param beneficiary who got the tokens
208      * @param value weis paid for purchase
209      * @param amount amount of tokens purchased
210      */
211      event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
212     
213     //modifiers    
214     modifier _contractUp(){
215         require(contractUp);
216         _;
217     }
218   
219      modifier nonZeroAddress(address _to) {
220         require(_to != address(0));
221         _;
222     }
223     
224     modifier minEthContribution() {
225         require(msg.value >= 0.1 ether);
226         _;
227     }
228     
229     modifier _saleEnded() {
230         require(saleEnded);
231         _;
232     }
233     
234     modifier _saleNotEnded() {
235         require(!saleEnded);
236         _;
237     }
238   
239     
240     /**
241     *     @dev Check if sale contract has enough tokens on its account balance 
242     *     to reward all possible participations within sale period
243     */
244     function powerUpContract() external onlyOwner {
245         // Contract should not be powered up previously
246         require(!contractUp);
247 
248         // Contract should have enough DRONE credits
249         require(token.balanceOf(this) >= tokensAvailableForSale);
250         
251         
252       
253         //activate the sale process
254         contractUp = true;
255     }
256     
257     //for Emergency/Hard stop of the sale
258     function emergencyStop() external onlyOwner _contractUp _saleNotEnded{
259         saleEnded = true;    
260         
261      if(totalFunding < 10000 ether){
262             vault.activateRefund();
263         }
264         else{
265             vault.activateWithdrawal();
266         }
267         
268       emit SaleStopped(msg.sender, now);
269     }
270     
271     /**
272    * @dev Must be called after sale ends, to do some extra finalization
273    * work. Calls the contract's finalization function.
274    */
275     function finalize()public onlyOwner _contractUp _saleNotEnded{
276         require(saleTimeOver());
277         
278         saleEnded = true;
279         
280         if(totalFunding < 10000 ether){
281             vault.activateRefund();
282         }
283         else{
284             vault.activateWithdrawal();
285         }
286        
287        emit Finalized(msg.sender, now);
288     }
289     
290       // @return true if all the tiers has been ended
291   function saleTimeOver() public view returns (bool) {
292     
293     return now > phases[noOfPhases-1].endTime;
294   }
295   
296     //if crowdsales is over, the money rasied should be transferred to the wallet address
297   function withdrawFunds() public onlyOwner{
298   
299       vault.withdrawToWallet();
300   }
301   
302   //method to refund money
303   function getRefund()public {
304       
305       vault.refund(msg.sender);
306   }
307   
308   /**
309   * @dev Can be called only once. The method to allow owner to set tier information
310   * @param _noOfPhases The integer to set number of tiers
311   * @param _startTimes The array containing start time of each tier
312   * @param _endTimes The array containing end time of each tier
313   * @param _hardCaps The array containing hard cap for each tier
314   * @param _bonusPercentages The array containing bonus percentage for each tier
315   * The arrays should be in sync with each other. For each index 0 for each of the array should contain info about Tier 1, similarly for Tier2, 3 and 4 .
316   * Sales hard cap will be the hard cap of last tier
317   */
318   function setTiersInfo(uint8 _noOfPhases, uint256[] _startTimes, uint256[] _endTimes, uint256[] _hardCaps, uint8[3][4] _bonusPercentages)private {
319     
320     
321     require(_noOfPhases==4);
322     
323     //Each array should contain info about each tier
324     require(_startTimes.length == _noOfPhases);
325     require(_endTimes.length==_noOfPhases);
326     require(_hardCaps.length==_noOfPhases);
327     require(_bonusPercentages.length==_noOfPhases);
328     
329     noOfPhases = _noOfPhases;
330     
331     for(uint8 i=0;i<_noOfPhases;i++){
332         require(_hardCaps[i]>0);
333         require(_endTimes[i]>_startTimes[i]);
334         if(i>0){
335             
336         
337             
338             //start time of this tier should be greater than previous tier
339             require(_startTimes[i] > _endTimes[i-1]);
340             
341             phases.push(PhaseInfo({
342                 hardcap:_hardCaps[i],
343                 startTime:_startTimes[i],
344                 endTime:_endTimes[i],
345                 bonusPercentages:_bonusPercentages[i],
346                 weiRaised:0
347             }));
348         }
349         else{
350             //start time of tier1 should be greater than current time
351             require(_startTimes[i]>now);
352           
353             phases.push(PhaseInfo({
354                 hardcap:_hardCaps[i],
355                 startTime:_startTimes[i],
356                 endTime:_endTimes[i],
357                 bonusPercentages:_bonusPercentages[i],
358                 weiRaised:0
359             }));
360         }
361     }
362   }
363   
364   
365     /**
366     * @dev Constructor method
367     * @param _tokenToBeUsed Address of the token to be used for Sales
368     * @param _wallet Address of the wallet which will receive the collected funds
369     */  
370     function DroneTokenSale(address _tokenToBeUsed, address _wallet)public nonZeroAddress(_tokenToBeUsed) nonZeroAddress(_wallet){
371         
372         token = Token(_tokenToBeUsed);
373         vault = new Vault(_wallet);
374         
375         uint256[] memory startTimes = new uint256[](4);
376         uint256[] memory endTimes = new uint256[](4);
377         uint256[] memory hardCaps = new uint256[](4);
378         uint8[3] [4] memory bonusPercentages;
379         
380         //pre-sales
381         startTimes[0] = 1522321200; //MARCH 29, 2018 11:00 AM GMT
382         endTimes[0] = 1523790000; //APRIL 15, 2018 11:00 AM GMT
383         hardCaps[0] = 10000 ether;
384         bonusPercentages[0][0] = 35;
385         bonusPercentages[0][1] = 30;
386         bonusPercentages[0][2] = 25;
387         
388         //phase-1
389         startTimes[1] = 1525172460; //MAY 01, 2018 11:01 AM GMT 
390         endTimes[1] = 1526382000; //MAY 15, 2018 11:00 AM GMT
391         hardCaps[1] = 20000 ether;
392         bonusPercentages[1][0] = 25;// above 100 ether
393         bonusPercentages[1][1] = 20;// 10<=x<=100
394         bonusPercentages[1][2] = 15;// less than 10 ether
395         
396         
397         //phase-2
398         startTimes[2] = 1526382060; //MAY 15, 2018 11:01 AM GMT
399         endTimes[2] = 1527850800; //JUNE 01, 2018 11:00 AM GMT
400         hardCaps[2] = 30000 ether;
401         bonusPercentages[2][0] = 15;
402         bonusPercentages[2][1] = 10;
403         bonusPercentages[2][2] = 5;
404         
405         //phase-3
406         startTimes[3] = 1527850860; //JUNE 01, 2018 11:01 AM GMT
407         endTimes[3] = 1533034800; //JULY 31, 2018 11:OO AM GMT
408         hardCaps[3] = 75000 ether;
409         bonusPercentages[3][0] = 0;
410         bonusPercentages[3][1] = 0;
411         bonusPercentages[3][2] = 0;
412 
413         setTiersInfo(4, startTimes, endTimes, hardCaps, bonusPercentages);
414         
415     }
416     
417 
418    //Fallback function used to buytokens
419    function()public payable{
420        buyTokens(msg.sender);
421    }
422    
423    /**
424    * @dev Low level token purchase function
425    * @param beneficiary The address who will receive the tokens for this transaction
426    */
427    function buyTokens(address beneficiary)public _contractUp _saleNotEnded minEthContribution nonZeroAddress(beneficiary) payable returns(bool){
428        
429        int8 currentPhaseIndex = getCurrentlyRunningPhase();
430        assert(currentPhaseIndex>=0);
431        
432         // recheck this for storage and memory
433        PhaseInfo storage currentlyRunningPhase = phases[uint256(currentPhaseIndex)];
434        
435        
436        uint256 weiAmount = msg.value;
437 
438        //Check hard cap for this phase has not been reached
439        require(weiAmount.add(currentlyRunningPhase.weiRaised) <= currentlyRunningPhase.hardcap);
440        
441        
442        uint256 tokens = weiAmount.mul(rate).div(1000000000000000000);//considering decimal places to be zero for token
443        
444        uint256 bonusedTokens = applyBonus(tokens, currentlyRunningPhase.bonusPercentages, weiAmount);
445        
446       
447        
448       
449        totalFunding = totalFunding.add(weiAmount);
450        
451        currentlyRunningPhase.weiRaised = currentlyRunningPhase.weiRaised.add(weiAmount);
452        
453        vault.deposit.value(msg.value)(msg.sender);
454        
455        token.transfer(beneficiary, bonusedTokens);
456        
457        emit TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
458 
459        return true;
460        
461    }
462    
463     /**
464     *@dev Method to calculate bonus for the user as per currently running phase and contribution by the user
465     * @param tokens Total tokens purchased by the user
466     * @param percentages Array of bonus percentages for the phase as per ethers sent
467     * @param weiSent Amount of ethers(in form of wei) sent by the user
468     */
469      function applyBonus(uint256 tokens, uint8 [3]percentages, uint256 weiSent) private pure returns  (uint256) {
470          
471          uint256 tokensToAdd = 0;
472          
473          if(weiSent<10 ether){
474              tokensToAdd = tokens.mul(percentages[2]).div(100);
475          }
476          else if(weiSent>=10 ether && weiSent<=100 ether){
477               tokensToAdd = tokens.mul(percentages[1]).div(100);
478          }
479          
480          else{
481               tokensToAdd = tokens.mul(percentages[0]).div(100);
482          }
483         
484         return tokens.add(tokensToAdd);
485     }
486     
487    /**
488     * @dev returns the currently running tier index as per time
489     * Return -1 if no tier is running currently
490     * */
491    function getCurrentlyRunningPhase()public view returns(int8){
492       for(uint8 i=0;i<noOfPhases;i++){
493           if(now>=phases[i].startTime && now<=phases[i].endTime){
494               return int8(i);
495           }
496       }   
497       return -1;
498    }
499    
500    
501    
502    /**
503    * @dev Get functing info of user/address. It will return how much funding the user has made in terms of wei
504    */
505    function getFundingInfoForUser(address _user)public view nonZeroAddress(_user) returns(uint256){
506        return vault.deposited(_user);
507    }
508    
509    /**
510    *@dev Method to check whether refund process has been initiated or not by the contract.
511    */
512    function isRefunding()public view returns(bool) {
513        return vault.isRefunding();
514    }
515    
516    /**
517    *@dev Method to burn all remanining tokens left with the sales contract after the sale has ended
518    */
519    function burnRemainingTokens()public onlyOwner _contractUp _saleEnded {
520        
521        token.burnAllTokens();
522    }
523    
524    /**
525    * @dev Method to activate withdrawal of funds even in between of sale. The WIthdrawal will only be activate iff totalFunding has reached 10,000 ether
526    */
527    function activateWithdrawal()public onlyOwner _saleNotEnded _contractUp {
528        
529        require(totalFunding >= 10000 ether);
530        vault.activateWithdrawal();
531        
532    }
533       
534 }