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
169       //Event to trigger Sale stop
170       event SaleStopped(address _owner, uint256 time);
171       
172       //Event to trigger normal flow of sale end
173       event Finalized(address _owner, uint256 time);
174     
175      /**
176      * event for token purchase logging
177      * @param purchaser who paid for the tokens
178      * @param beneficiary who got the tokens
179      * @param value weis paid for purchase
180      * @param amount amount of tokens purchased
181      */
182      event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
183     
184     //modifiers    
185     modifier _saleActive(){
186         require(salesActive);
187         _;
188     }
189   
190      modifier nonZeroAddress(address _to) {
191         require(_to != 0x0);
192         _;
193     }
194     
195     modifier nonZeroEth() {
196         require(msg.value > 0);
197         _;
198     }
199     
200     modifier _saleEnded() {
201         require(saleEnded);
202         _;
203     }
204     
205     modifier tiersEmpty(){
206         require(noOfTiers==0);
207         _;
208     }
209     
210     function COOSCrowdsales(address _tokenToBeUsed, address _wallet)public nonZeroAddress(_tokenToBeUsed) nonZeroAddress(_wallet){
211         token = Token(_tokenToBeUsed);
212         vault = new Vault(_wallet);
213     }
214     
215     /**
216     *     @dev Check if sale contract has enough tokens on its account balance 
217     *     to reward all possible participations within sale period
218     */
219     function powerUpContract() external onlyOwner {
220         // Contract should not be powered up previously
221         require(!salesActive);
222 
223         // Contract should have enough Parsec credits
224         require(token.balanceOf(this) >= crowdSaleHardCap);
225         
226         //check whether tier information has been entered
227         require(noOfTiers>0 && tiers.length==noOfTiers);
228       
229         //activate the sale process
230         salesActive=true;
231     }
232     
233     //for Emergency stop of the sale
234     function emergencyStop() public onlyOwner _saleActive{
235         salesActive = false;
236         saleEnded = true;    
237         vault.close();
238         SaleStopped(msg.sender, now);
239     }
240     
241     /**
242    * @dev Must be called after sale ends, to do some extra finalization
243    * work. Calls the contract's finalization function.
244    */
245     function finalize()public onlyOwner _saleActive{
246         require(saleTimeOver());
247         salesActive = false;
248         saleEnded = true;
249         vault.close();
250         Finalized(msg.sender, now);
251     }
252     
253       // @return true if all the tiers has been ended
254   function saleTimeOver() public view returns (bool) {
255       if(noOfTiers==0){
256           //since no tiers has been provided yet, hence sales has not started to end
257           return false;
258       }
259       //If last tier has ended, it mean all tiers are finished
260     return now > tiers[noOfTiers-1].endTime;
261   }
262   
263     //if crowdsales is over, the money rasied should be transferred to the wallet address
264   function withdrawFunds() public onlyOwner _saleEnded{
265   
266       vault.withdrawToWallet();
267   }
268   
269   /**
270   * @dev Can be called only once. The method to allow owner to set tier information
271   * @param _noOfTiers The integer to set number of tiers
272   * @param _startTimes The array containing start time of each tier
273   * @param _endTimes The array containing end time of each tier
274   * @param _hardCaps The array containing hard cap for each tier
275   * @param _rates The array containing number of tokens per ether for each tier
276   * @param _bonusPercentages The array containing bonus percentage for each tier
277   * The arrays should be in sync with each other. For each index 0 for each of the array should contain info about Tier 1, similarly for Tier2, 3,4 and 5.
278   * Sales hard cap will be the hard cap of last tier
279   */
280   function setTiersInfo(uint8 _noOfTiers, uint256[] _startTimes, uint256[] _endTimes, uint256[] _hardCaps, uint256[] _rates, uint8[] _bonusPercentages)public onlyOwner tiersEmpty{
281     
282     //Minimu number of tiers should be 1 and less than or equal to 5
283     require(_noOfTiers>=1 && _noOfTiers<=5);
284     
285     //Each array should contain info about each tier
286     require(_startTimes.length == _noOfTiers);
287     require(_endTimes.length==_noOfTiers);
288     require(_hardCaps.length==_noOfTiers);
289     require(_rates.length==_noOfTiers);
290     require(_bonusPercentages.length==_noOfTiers);
291     
292     noOfTiers = _noOfTiers;
293     
294     for(uint8 i=0;i<noOfTiers;i++){
295         require(_hardCaps[i]>0);
296         require(_endTimes[i]>_startTimes[i]);
297         require(_rates[i]>0);
298         require(_bonusPercentages[i]>0);
299         if(i>0){
300             
301             //check hard cap for this tier should be greater than the previous tier
302             require(_hardCaps[i] > _hardCaps[i-1]);
303             
304             //start time of this tier should be greater than previous tier
305             require(_startTimes[i]>_endTimes[i-1]);
306             
307             tiers.push(TierInfo({
308                 hardcap:_hardCaps[i].mul( 10 ** uint256(token.decimals())),
309                 startTime:_startTimes[i],
310                 endTime:_endTimes[i],
311                 rate:_rates[i],
312                 bonusPercentage:_bonusPercentages[i],
313                 weiRaised:0
314             }));
315         }
316         else{
317             //start time of tier1 should be greater than current time
318             require(_startTimes[i]>now);
319           
320             tiers.push(TierInfo({
321                 hardcap:_hardCaps[i].mul( 10 ** uint256(token.decimals())), //multiplying with decimal places. So if hard cap is set to 1 it is actually set to 1 * 10^decimals
322                 startTime:_startTimes[i],
323                 endTime:_endTimes[i],
324                 rate:_rates[i],
325                 bonusPercentage:_bonusPercentages[i],
326                 weiRaised:0
327             }));
328         }
329     }
330     crowdSaleHardCap = _hardCaps[noOfTiers-1].mul( 10 ** uint256(token.decimals()));
331   }
332     
333     /**
334     * @dev Allows owner to transfer unsold tokens to his/her address
335     * This method should only be called once the sale has been stopped/ended
336     */
337    function ownerWithdrawUnspentCredits()public onlyOwner _saleEnded{
338         require(!unspentCreditsWithdrawn);
339         unspentCreditsWithdrawn = true;
340         token.transfer(owner, token.balanceOf(this));
341    }
342    
343    //Fallback function used to buytokens
344    function()public payable{
345        buyTokens(msg.sender);
346    }
347    
348    /**
349    * @dev Low level token purchase function
350    * @param beneficiary The address who will receive the tokens for this transaction
351    */
352    function buyTokens(address beneficiary)public _saleActive nonZeroEth nonZeroAddress(beneficiary) payable returns(bool){
353        
354        int8 currentTierIndex = getCurrentlyRunningTier();
355        assert(currentTierIndex>=0);
356        
357        TierInfo storage currentlyRunningTier = tiers[uint256(currentTierIndex)];
358        
359        //hard cap for this tier has not been reached
360        require(tokensSold < currentlyRunningTier.hardcap);
361        
362        uint256 weiAmount = msg.value;
363        
364        uint256 tokens = weiAmount.mul(currentlyRunningTier.rate);
365        
366        uint256 bonusedTokens = applyBonus(tokens, currentlyRunningTier.bonusPercentage);
367        
368        //Total tokens sold including current sale should be less than hard cap of this tier
369        assert(tokensSold.add(bonusedTokens) <= currentlyRunningTier.hardcap);
370        
371        tokensSold = tokensSold.add(bonusedTokens);
372        
373        totalFunding = totalFunding.add(weiAmount);
374        
375        currentlyRunningTier.weiRaised = currentlyRunningTier.weiRaised.add(weiAmount);
376        vault.deposit.value(msg.value)(msg.sender);
377        token.transfer(beneficiary, bonusedTokens);
378        TokenPurchase(msg.sender, beneficiary, weiAmount, bonusedTokens);
379        
380    }
381    
382      function applyBonus(uint256 tokens, uint8 percent) internal pure returns  (uint256 bonusedTokens) {
383         uint256 tokensToAdd = tokens.mul(percent).div(100);
384         return tokens.add(tokensToAdd);
385     }
386     
387    /**
388     * @dev returns the currently running tier index as per time
389     * Return -1 if no tier is running currently
390     * */
391    function getCurrentlyRunningTier()public view returns(int8){
392       for(uint8 i=0;i<noOfTiers;i++){
393           if(now>=tiers[i].startTime && now<tiers[i].endTime){
394               return int8(i);
395           }
396       }   
397       return -1;
398    }
399    
400    /**
401    * @dev Get functing info of user/address. It will return how much funding the user has made in terms of wei
402    */
403    function getFundingInfoForUser(address _user)public view nonZeroAddress(_user) returns(uint256){
404        return vault.deposited(_user);
405    }
406    
407       
408 }