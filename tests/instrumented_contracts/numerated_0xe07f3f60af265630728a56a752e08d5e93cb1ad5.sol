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
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   constructor() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 interface TokenInterface {
77      function totalSupply() external constant returns (uint);
78      function balanceOf(address tokenOwner) external constant returns (uint balance);
79      function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
80      function transfer(address to, uint tokens) external returns (bool success);
81      function approve(address spender, uint tokens) external returns (bool success);
82      function transferFrom(address from, address to, uint tokens) external returns (bool success);
83      function burn(uint256 _value) external; 
84      event Transfer(address indexed from, address indexed to, uint tokens);
85      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
86      event Burn(address indexed burner, uint256 value);
87 }
88 
89  contract KRCICOContract is Ownable{
90   using SafeMath for uint256;
91  
92   // The token being sold
93   TokenInterface public token;
94 
95   // start and end timestamps where investments are allowed (both inclusive)
96   uint256 public startTime;
97   uint256 public endTime;
98 
99 
100   // how many token units a buyer gets per wei
101   uint256 public ratePerWei; 
102 
103   // amount of raised money in wei
104   uint256 public weiRaised;
105 
106   uint256 public TOKENS_SOLD;
107   
108   uint256 maxTokensToSale;
109   
110   uint256 bonusInPhase1;
111   uint256 bonusInPhase2;
112   uint256 bonusInPhase3;
113   
114   uint256 minimumContribution;
115   uint256 maximumContribution;
116   
117   bool isCrowdsalePaused = false;
118   
119   uint256 totalDurationInDays = 45 days;
120   
121   uint256 LongTermFoundationBudgetAccumulated;
122   uint256 LegalContingencyFundsAccumulated;
123   uint256 MarketingAndCommunityOutreachAccumulated;
124   uint256 CashReserveFundAccumulated;
125   uint256 OperationalExpensesAccumulated;
126   uint256 SoftwareProductDevelopmentAccumulated;
127   uint256 FoundersTeamAndAdvisorsAccumulated;
128   
129   uint256 LongTermFoundationBudgetPercentage;
130   uint256 LegalContingencyFundsPercentage;
131   uint256 MarketingAndCommunityOutreachPercentage;
132   uint256 CashReserveFundPercentage;
133   uint256 OperationalExpensesPercentage;
134   uint256 SoftwareProductDevelopmentPercentage;
135   uint256 FoundersTeamAndAdvisorsPercentage;
136   
137   //Whitelist 
138   struct Whitelist {
139     	string Email;
140     }
141     
142     mapping (address => Whitelist) Whitelists;
143     
144     address[] public WhitelistsAccts;
145     
146     function setWhitelist(address _address, string _Email) public  {
147         var whitelist = Whitelists[_address];
148         whitelist.Email = _Email;
149 
150     	WhitelistsAccts.push(_address) -1;
151     }
152     
153     function getWhitelist() view public returns (address[]) {
154     	return WhitelistsAccts;
155     }
156     
157     function searchWhitelist(address _address) view public returns (string){
158         return (Whitelists[_address].Email);
159     }
160     
161     function countWhitelists() view public returns (uint) {
162         return WhitelistsAccts.length;
163     }
164   
165   
166   /**
167    * event for token purchase logging
168    * @param purchaser who paid for the tokens
169    * @param beneficiary who got the tokens
170    * @param value weis paid for purchase
171    * @param amount amount of tokens purchased
172    */
173   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
174 
175   constructor(uint256 _startTime, address _wallet, address _tokenAddress) public 
176   {
177     require(_startTime >=now);
178     require(_wallet != 0x0);
179 
180     startTime = _startTime;  
181     endTime = startTime + totalDurationInDays;
182     require(endTime >= startTime);
183    
184     owner = _wallet;
185     
186     maxTokensToSale = 157500000e18;
187     bonusInPhase1 = 20;
188     bonusInPhase2 = 15;
189     bonusInPhase3 = 10;
190     minimumContribution = 5e17;
191     maximumContribution = 150e18;
192     ratePerWei = 40e18;
193     token = TokenInterface(_tokenAddress);
194     
195     LongTermFoundationBudgetAccumulated = 0;
196     LegalContingencyFundsAccumulated = 0;
197     MarketingAndCommunityOutreachAccumulated = 0;
198     CashReserveFundAccumulated = 0;
199     OperationalExpensesAccumulated = 0;
200     SoftwareProductDevelopmentAccumulated = 0;
201     FoundersTeamAndAdvisorsAccumulated = 0;
202   
203     LongTermFoundationBudgetPercentage = 15;
204     LegalContingencyFundsPercentage = 10;
205     MarketingAndCommunityOutreachPercentage = 10;
206     CashReserveFundPercentage = 20;
207     OperationalExpensesPercentage = 10;
208     SoftwareProductDevelopmentPercentage = 15;
209     FoundersTeamAndAdvisorsPercentage = 20;
210   }
211   
212   
213    // fallback function can be used to buy tokens
214    function () public  payable {
215      var isexist = searchWhitelist(msg.sender);
216      //Check if address is exist 
217      if(bytes(isexist).length > 0){
218         buyTokens(msg.sender);
219      }else{
220          revert();
221      }
222     }
223     
224     function calculateTokens(uint value) internal view returns (uint256 tokens) 
225     {
226         uint256 timeElapsed = now - startTime;
227         uint256 timeElapsedInDays = timeElapsed.div(1 days);
228         uint256 bonus = 0;
229         //Phase 1 (15 days)
230         if (timeElapsedInDays <15)
231         {
232             tokens = value.mul(ratePerWei);
233             bonus = tokens.mul(bonusInPhase1); 
234             bonus = bonus.div(100);
235             tokens = tokens.add(bonus);
236             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
237         }
238         //Phase 2 (15 days)
239         else if (timeElapsedInDays >=15 && timeElapsedInDays <30)
240         {
241             tokens = value.mul(ratePerWei);
242             bonus = tokens.mul(bonusInPhase2); 
243             bonus = bonus.div(100);
244             tokens = tokens.add(bonus);
245             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
246         }
247         //Phase 3 (15 days)
248         else if (timeElapsedInDays >=30 && timeElapsedInDays <45)
249         {
250             tokens = value.mul(ratePerWei);
251             bonus = tokens.mul(bonusInPhase3); 
252             bonus = bonus.div(100);
253             tokens = tokens.add(bonus);
254             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
255         }
256         else 
257         {
258             bonus = 0;
259         }
260     }
261 
262   // low level token purchase function
263   
264   function buyTokens(address beneficiary) public payable {
265     require(beneficiary != 0x0);
266     require(isCrowdsalePaused == false);
267     require(validPurchase());
268 
269     
270     require(TOKENS_SOLD<maxTokensToSale);
271    
272     uint256 weiAmount = msg.value.div(10**16);
273     
274     uint256 tokens = calculateTokens(weiAmount);
275     require(TOKENS_SOLD.add(tokens)<=maxTokensToSale);
276     // update state
277     weiRaised = weiRaised.add(msg.value);
278     
279     token.transfer(beneficiary,tokens);
280     emit TokenPurchase(owner, beneficiary, msg.value, tokens);
281     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
282     distributeFunds();
283   }
284   
285   function distributeFunds() internal {
286       uint received = msg.value;
287       
288       LongTermFoundationBudgetAccumulated = LongTermFoundationBudgetAccumulated
289                                             .add(received.mul(LongTermFoundationBudgetPercentage)
290                                             .div(100));
291       
292       LegalContingencyFundsAccumulated = LegalContingencyFundsAccumulated
293                                          .add(received.mul(LegalContingencyFundsPercentage)
294                                          .div(100));
295       
296       MarketingAndCommunityOutreachAccumulated = MarketingAndCommunityOutreachAccumulated
297                                                  .add(received.mul(MarketingAndCommunityOutreachPercentage)
298                                                  .div(100));
299       
300       CashReserveFundAccumulated = CashReserveFundAccumulated
301                                    .add(received.mul(CashReserveFundPercentage)
302                                    .div(100));
303       
304       OperationalExpensesAccumulated = OperationalExpensesAccumulated
305                                        .add(received.mul(OperationalExpensesPercentage)
306                                        .div(100));
307       
308       SoftwareProductDevelopmentAccumulated = SoftwareProductDevelopmentAccumulated
309                                               .add(received.mul(SoftwareProductDevelopmentPercentage)
310                                               .div(100));
311       
312       FoundersTeamAndAdvisorsAccumulated = FoundersTeamAndAdvisorsAccumulated
313                                             .add(received.mul(FoundersTeamAndAdvisorsPercentage)
314                                             .div(100));
315   }
316 
317   // @return true if the transaction can buy tokens
318   function validPurchase() internal constant returns (bool) {
319     bool withinPeriod = now >= startTime && now <= endTime;
320     bool nonZeroPurchase = msg.value != 0;
321     bool withinContributionLimit = msg.value >= minimumContribution && msg.value <= maximumContribution;
322     return withinPeriod && nonZeroPurchase && withinContributionLimit;
323   }
324 
325   // @return true if crowdsale event has ended
326   function hasEnded() public constant returns (bool) {
327     return now > endTime;
328   }
329   
330    /**
331     * function to change the end timestamp of the ico
332     * can only be called by owner wallet
333     **/
334     function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{
335         endTime = endTimeUnixTimestamp;
336     }
337     
338     /**
339     * function to change the start timestamp of the ico
340     * can only be called by owner wallet
341     **/
342     
343     function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{
344         startTime = startTimeUnixTimestamp;
345     }
346     
347      /**
348      * function to pause the crowdsale 
349      * can only be called from owner wallet
350      **/
351      
352     function pauseCrowdsale() public onlyOwner {
353         isCrowdsalePaused = true;
354     }
355 
356     /**
357      * function to resume the crowdsale if it is paused
358      * can only be called from owner wallet
359      **/ 
360     function resumeCrowdsale() public onlyOwner {
361         isCrowdsalePaused = false;
362     }
363      
364      function takeTokensBack() public onlyOwner
365      {
366          uint remainingTokensInTheContract = token.balanceOf(address(this));
367          token.transfer(owner,remainingTokensInTheContract);
368      }
369      
370     /**
371      * function to change the minimum contribution
372      * can only be called from owner wallet
373      **/ 
374     function changeMinimumContribution(uint256 minContribution) public onlyOwner {
375         minimumContribution = minContribution;
376     }
377     
378     /**
379      * function to change the maximum contribution
380      * can only be called from owner wallet
381      **/ 
382     function changeMaximumContribution(uint256 maxContribution) public onlyOwner {
383         maximumContribution = maxContribution;
384     }
385     
386     /**
387      * function to withdraw LongTermFoundationBudget funds to the owner wallet
388      * can only be called from owner wallet
389      **/  
390     function withdrawLongTermFoundationBudget() public onlyOwner {
391         require(LongTermFoundationBudgetAccumulated > 0);
392         owner.transfer(LongTermFoundationBudgetAccumulated);
393         LongTermFoundationBudgetAccumulated = 0;
394     }
395     
396      /**
397      * function to withdraw LegalContingencyFunds funds to the owner wallet
398      * can only be called from owner wallet
399      **/
400      
401     function withdrawLegalContingencyFunds() public onlyOwner {
402         require(LegalContingencyFundsAccumulated > 0);
403         owner.transfer(LegalContingencyFundsAccumulated);
404         LegalContingencyFundsAccumulated = 0;
405     }
406     
407      /**
408      * function to withdraw MarketingAndCommunityOutreach funds to the owner wallet
409      * can only be called from owner wallet
410      **/
411     function withdrawMarketingAndCommunityOutreach() public onlyOwner {
412         require (MarketingAndCommunityOutreachAccumulated > 0);
413         owner.transfer(MarketingAndCommunityOutreachAccumulated);
414         MarketingAndCommunityOutreachAccumulated = 0;
415     }
416     
417      /**
418      * function to withdraw CashReserveFund funds to the owner wallet
419      * can only be called from owner wallet
420      **/
421     function withdrawCashReserveFund() public onlyOwner {
422         require(CashReserveFundAccumulated > 0);
423         owner.transfer(CashReserveFundAccumulated);
424         CashReserveFundAccumulated = 0;
425     }
426     
427      /**
428      * function to withdraw OperationalExpenses funds to the owner wallet
429      * can only be called from owner wallet
430      **/
431     function withdrawOperationalExpenses() public onlyOwner {
432         require(OperationalExpensesAccumulated > 0);
433         owner.transfer(OperationalExpensesAccumulated);
434         OperationalExpensesAccumulated = 0;
435     }
436     
437      /**
438      * function to withdraw SoftwareProductDevelopment funds to the owner wallet
439      * can only be called from owner wallet
440      **/
441     function withdrawSoftwareProductDevelopment() public onlyOwner {
442         require (SoftwareProductDevelopmentAccumulated > 0);
443         owner.transfer(SoftwareProductDevelopmentAccumulated);
444         SoftwareProductDevelopmentAccumulated = 0;
445     }
446     
447      /**
448      * function to withdraw FoundersTeamAndAdvisors funds to the owner wallet
449      * can only be called from owner wallet
450      **/
451     function withdrawFoundersTeamAndAdvisors() public onlyOwner {
452         require (FoundersTeamAndAdvisorsAccumulated > 0);
453         owner.transfer(FoundersTeamAndAdvisorsAccumulated);
454         FoundersTeamAndAdvisorsAccumulated = 0;
455     }
456     
457      /**
458      * function to withdraw all funds to the owner wallet
459      * can only be called from owner wallet
460      **/
461     function withdrawAllFunds() public onlyOwner {
462         require (address(this).balance > 0);
463         owner.transfer(address(this).balance);
464     }
465 }