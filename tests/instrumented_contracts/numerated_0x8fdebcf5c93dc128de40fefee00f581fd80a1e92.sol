1 pragma solidity 0.4.19;
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
75     OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79 }
80 
81 interface Token {
82     function transfer(address _to, uint256 _amount) public returns (bool success);
83     function balanceOf(address _owner) public view returns (uint256 balance);
84     function decimals()public view returns (uint8);
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
95     enum State { Active, Closed }
96 
97     mapping (address => uint256) public deposited;
98     address public wallet;
99     State public state;
100 
101     event Closed();
102     event withdrawn(address _wallet);
103     function Vault(address _wallet) public {
104         require(_wallet != 0x0);
105         wallet = _wallet;
106         state = State.Active;
107     }
108 
109     function deposit(address investor) public onlyOwner  payable {
110         require(state == State.Active);
111         deposited[investor] = deposited[investor].add(msg.value);
112     }
113 
114     function close() public onlyOwner {
115         require(state == State.Active);
116         state = State.Closed;
117         Closed();
118     }
119 
120     function withdrawToWallet() onlyOwner public{
121     require(state == State.Closed);
122     wallet.transfer(this.balance);
123     withdrawn(wallet);
124   }
125 }
126 
127 
128 contract COOSCrowdsales is Ownable{
129       using SafeMath for uint256;
130       
131       //Token to be used for this sale
132       Token public token;
133       
134       //All funds will go into this vault
135       Vault public vault;
136       
137       //Total tokens which is on for sale
138       uint256 public crowdSaleHardCap;
139       
140       
141       //There can be 5 tiers and it will contain info about each tier
142       struct TierInfo{
143           uint256 hardcap;
144           uint256 startTime;
145           uint256 endTime;
146           uint256 rate;
147           uint8 bonusPercentage;
148           uint256 weiRaised;
149       }
150       
151       //info of each tier
152       TierInfo[] public tiers;
153       
154       //Total funding
155       uint256 public totalFunding;
156       
157       uint8 public noOfTiers;
158       
159       uint256 public tokensSold;
160     
161       //Keep track whether sales is active or not
162       bool public salesActive;
163       
164       //Keep track of whether the sale has ended or not
165       bool public saleEnded;
166       
167       bool public unspentCreditsWithdrawn;
168       
169       //to make sure contract is poweredup only once
170       bool contractPoweredUp = false;
171       
172       //Event to trigger Sale stop
173       event SaleStopped(address _owner, uint256 time);
174       
175       //Event to trigger normal flow of sale end
176       event Finalized(address _owner, uint256 time);
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
188     modifier _saleActive(){
189         require(salesActive);
190         _;
191     }
192   
193      modifier nonZeroAddress(address _to) {
194         require(_to != 0x0);
195         _;
196     }
197     
198     modifier nonZeroEth() {
199         require(msg.value > 0);
200         _;
201     }
202     
203     modifier _saleEnded() {
204         require(saleEnded);
205         _;
206     }
207     
208     modifier tiersEmpty(){
209         require(noOfTiers==0);
210         _;
211     }
212     
213     function COOSCrowdsales(address _tokenToBeUsed, address _wallet)public nonZeroAddress(_tokenToBeUsed) nonZeroAddress(_wallet){
214         token = Token(_tokenToBeUsed);
215         vault = new Vault(_wallet);
216     }
217     
218     /**
219     *     @dev Check if sale contract has enough tokens on its account balance 
220     *     to reward all possible participations within sale period
221     */
222     function powerUpContract() external onlyOwner {
223         
224         require(!contractPoweredUp);
225         
226         // Contract should not be powered up previously
227         require(!salesActive);
228 
229         // Contract should have enough Parsec credits
230         require(token.balanceOf(this) >= crowdSaleHardCap);
231         
232         //check whether tier information has been entered
233         require(noOfTiers>0 && tiers.length==noOfTiers);
234       
235         //activate the sale process
236         salesActive=true;
237         
238         contractPoweredUp = true;
239     }
240     
241     //for Emergency stop of the sale
242     function emergencyStop() public onlyOwner _saleActive{
243         salesActive = false;
244         saleEnded = true;    
245         vault.close();
246         SaleStopped(msg.sender, now);
247     }
248     
249     /**
250    * @dev Must be called after sale ends, to do some extra finalization
251    * work. Calls the contract's finalization function.
252    */
253     function finalize()public onlyOwner _saleActive{
254         require(saleTimeOver());
255         salesActive = false;
256         saleEnded = true;
257         vault.close();
258         Finalized(msg.sender, now);
259     }
260     
261       // @return true if all the tiers has been ended
262   function saleTimeOver() public view returns (bool) {
263       if(noOfTiers==0){
264           //since no tiers has been provided yet, hence sales has not started to end
265           return false;
266       }
267       //If last tier has ended, it mean all tiers are finished
268     return now > tiers[noOfTiers-1].endTime;
269   }
270   
271     //if crowdsales is over, the money rasied should be transferred to the wallet address
272   function withdrawFunds() public onlyOwner _saleEnded{
273   
274       vault.withdrawToWallet();
275   }
276   
277   /**
278   * @dev Can be called only once. The method to allow owner to set tier information
279   * @param _noOfTiers The integer to set number of tiers
280   * @param _startTimes The array containing start time of each tier
281   * @param _endTimes The array containing end time of each tier
282   * @param _hardCaps The array containing hard cap for each tier
283   * @param _rates The array containing number of tokens per ether for each tier
284   * @param _bonusPercentages The array containing bonus percentage for each tier
285   * The arrays should be in sync with each other. For each index 0 for each of the array should contain info about Tier 1, similarly for Tier2, 3,4 and 5.
286   * Sales hard cap will be the hard cap of last tier
287   */
288   function setTiersInfo(uint8 _noOfTiers, uint256[] _startTimes, uint256[] _endTimes, uint256[] _hardCaps, uint256[] _rates, uint8[] _bonusPercentages)public onlyOwner tiersEmpty{
289     
290     //Minimu number of tiers should be 1 and less than or equal to 5
291     require(_noOfTiers>=1 && _noOfTiers<=5);
292     
293     //Each array should contain info about each tier
294     require(_startTimes.length == _noOfTiers);
295     require(_endTimes.length==_noOfTiers);
296     require(_hardCaps.length==_noOfTiers);
297     require(_rates.length==_noOfTiers);
298     require(_bonusPercentages.length==_noOfTiers);
299     
300     noOfTiers = _noOfTiers;
301     
302     for(uint8 i=0;i<noOfTiers;i++){
303         require(_hardCaps[i]>0);
304         require(_endTimes[i]>_startTimes[i]);
305         require(_rates[i]>0);
306         require(_bonusPercentages[i]>0);
307         if(i>0){
308             
309             //check hard cap for this tier should be greater than the previous tier
310             require(_hardCaps[i] > _hardCaps[i-1]);
311             
312             //start time of this tier should be greater than previous tier
313             require(_startTimes[i]>_endTimes[i-1]);
314             
315             tiers.push(TierInfo({
316                 hardcap:_hardCaps[i].mul( 10 ** uint256(token.decimals())),
317                 startTime:_startTimes[i],
318                 endTime:_endTimes[i],
319                 rate:_rates[i],
320                 bonusPercentage:_bonusPercentages[i],
321                 weiRaised:0
322             }));
323         }
324         else{
325             //start time of tier1 should be greater than current time
326             require(_startTimes[i]>now);
327           
328             tiers.push(TierInfo({
329                 hardcap:_hardCaps[i].mul( 10 ** uint256(token.decimals())), //multiplying with decimal places. So if hard cap is set to 1 it is actually set to 1 * 10^decimals
330                 startTime:_startTimes[i],
331                 endTime:_endTimes[i],
332                 rate:_rates[i],
333                 bonusPercentage:_bonusPercentages[i],
334                 weiRaised:0
335             }));
336         }
337     }
338     crowdSaleHardCap = _hardCaps[noOfTiers-1].mul( 10 ** uint256(token.decimals()));
339   }
340     
341     /**
342     * @dev Allows owner to transfer unsold tokens to his/her address
343     * This method should only be called once the sale has been stopped/ended
344     */
345    function ownerWithdrawUnspentCredits()public onlyOwner _saleEnded{
346         require(!unspentCreditsWithdrawn);
347         unspentCreditsWithdrawn = true;
348         token.transfer(owner, token.balanceOf(this));
349    }
350    
351    //Fallback function used to buytokens
352    function()public payable{
353        buyTokens(msg.sender);
354    }
355    
356    /**
357    * @dev Low level token purchase function
358    * @param beneficiary The address who will receive the tokens for this transaction
359    */
360    function buyTokens(address beneficiary)public _saleActive nonZeroEth nonZeroAddress(beneficiary) payable returns(bool){
361        
362        int8 currentTierIndex = getCurrentlyRunningTier();
363        assert(currentTierIndex>=0);
364        
365        TierInfo storage currentlyRunningTier = tiers[uint256(currentTierIndex)];
366        
367        //hard cap for this tier has not been reached
368        require(tokensSold < currentlyRunningTier.hardcap);
369        
370        uint256 weiAmount = msg.value;
371        
372        uint256 tokens = weiAmount.mul(currentlyRunningTier.rate);
373        
374        uint256 bonusedTokens = applyBonus(tokens, currentlyRunningTier.bonusPercentage);
375        
376        //Total tokens sold including current sale should be less than hard cap of this tier
377        assert(tokensSold.add(bonusedTokens) <= currentlyRunningTier.hardcap);
378        
379        tokensSold = tokensSold.add(bonusedTokens);
380        
381        totalFunding = totalFunding.add(weiAmount);
382        
383        currentlyRunningTier.weiRaised = currentlyRunningTier.weiRaised.add(weiAmount);
384        vault.deposit.value(msg.value)(msg.sender);
385        token.transfer(beneficiary, bonusedTokens);
386        TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
387        
388    }
389    
390      function applyBonus(uint256 tokens, uint8 percent) internal pure returns  (uint256 bonusedTokens) {
391         uint256 tokensToAdd = tokens.mul(percent).div(100);
392         return tokens.add(tokensToAdd);
393     }
394     
395    /**
396     * @dev returns the currently running tier index as per time
397     * Return -1 if no tier is running currently
398     * */
399    function getCurrentlyRunningTier()public view returns(int8){
400       for(uint8 i=0;i<noOfTiers;i++){
401           if(now>=tiers[i].startTime && now<tiers[i].endTime){
402               return int8(i);
403           }
404       }   
405       return -1;
406    }
407    
408    /**
409    * @dev Get functing info of user/address. It will return how much funding the user has made in terms of wei
410    */
411    function getFundingInfoForUser(address _user)public view nonZeroAddress(_user) returns(uint256){
412        return vault.deposited(_user);
413    }
414    
415       
416 }