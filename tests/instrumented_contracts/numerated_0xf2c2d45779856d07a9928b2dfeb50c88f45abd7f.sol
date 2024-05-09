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
119   uint256 totalDurationInDays = 56 days;
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
137   /**
138    * event for token purchase logging
139    * @param purchaser who paid for the tokens
140    * @param beneficiary who got the tokens
141    * @param value weis paid for purchase
142    * @param amount amount of tokens purchased
143    */
144   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
145 
146   constructor(uint256 _startTime, address _wallet, address _tokenAddress) public 
147   {
148     require(_startTime >=now);
149     require(_wallet != 0x0);
150 
151     startTime = _startTime;  
152     endTime = startTime + totalDurationInDays;
153     require(endTime >= startTime);
154    
155     owner = _wallet;
156     
157     maxTokensToSale = 157500000e18;
158     bonusInPhase1 = 20;
159     bonusInPhase2 = 15;
160     bonusInPhase3 = 10;
161     minimumContribution = 5e17;
162     maximumContribution = 150e18;
163     ratePerWei = 40e18;
164     token = TokenInterface(_tokenAddress);
165     
166     LongTermFoundationBudgetAccumulated = 0;
167     LegalContingencyFundsAccumulated = 0;
168     MarketingAndCommunityOutreachAccumulated = 0;
169     CashReserveFundAccumulated = 0;
170     OperationalExpensesAccumulated = 0;
171     SoftwareProductDevelopmentAccumulated = 0;
172     FoundersTeamAndAdvisorsAccumulated = 0;
173   
174     LongTermFoundationBudgetPercentage = 15;
175     LegalContingencyFundsPercentage = 10;
176     MarketingAndCommunityOutreachPercentage = 10;
177     CashReserveFundPercentage = 20;
178     OperationalExpensesPercentage = 10;
179     SoftwareProductDevelopmentPercentage = 15;
180     FoundersTeamAndAdvisorsPercentage = 20;
181   }
182   
183   
184    // fallback function can be used to buy tokens
185    function () public  payable {
186     buyTokens(msg.sender);
187     }
188     
189     function calculateTokens(uint value) internal view returns (uint256 tokens) 
190     {
191         uint256 timeElapsed = now - startTime;
192         uint256 timeElapsedInDays = timeElapsed.div(1 days);
193         uint256 bonus = 0;
194         //Phase 1 (15 days)
195         if (timeElapsedInDays <15)
196         {
197             tokens = value.mul(ratePerWei);
198             bonus = tokens.mul(bonusInPhase1); 
199             bonus = bonus.div(100);
200             tokens = tokens.add(bonus);
201             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
202         }
203         //Phase 2 (15 days)
204         else if (timeElapsedInDays >=15 && timeElapsedInDays <30)
205         {
206             tokens = value.mul(ratePerWei);
207             bonus = tokens.mul(bonusInPhase2); 
208             bonus = bonus.div(100);
209             tokens = tokens.add(bonus);
210             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
211         }
212         //Phase 3 (15 days)
213         else if (timeElapsedInDays >=30 && timeElapsedInDays <45)
214         {
215             tokens = value.mul(ratePerWei);
216             bonus = tokens.mul(bonusInPhase3); 
217             bonus = bonus.div(100);
218             tokens = tokens.add(bonus);
219             require (TOKENS_SOLD.add(tokens) <= maxTokensToSale);
220         }
221         else 
222         {
223             bonus = 0;
224         }
225     }
226 
227   // low level token purchase function
228   
229   function buyTokens(address beneficiary) public payable {
230     require(beneficiary != 0x0);
231     require(isCrowdsalePaused == false);
232     require(validPurchase());
233 
234     
235     require(TOKENS_SOLD<maxTokensToSale);
236    
237     uint256 weiAmount = msg.value.div(10**16);
238     
239     uint256 tokens = calculateTokens(weiAmount);
240     require(TOKENS_SOLD.add(tokens)<=maxTokensToSale);
241     // update state
242     weiRaised = weiRaised.add(msg.value);
243     
244     token.transfer(beneficiary,tokens);
245     emit TokenPurchase(owner, beneficiary, msg.value, tokens);
246     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
247     distributeFunds();
248   }
249   
250   function distributeFunds() internal {
251       uint received = msg.value;
252       
253       LongTermFoundationBudgetAccumulated = LongTermFoundationBudgetAccumulated
254                                             .add(received.mul(LongTermFoundationBudgetPercentage)
255                                             .div(100));
256       
257       LegalContingencyFundsAccumulated = LegalContingencyFundsAccumulated
258                                          .add(received.mul(LegalContingencyFundsPercentage)
259                                          .div(100));
260       
261       MarketingAndCommunityOutreachAccumulated = MarketingAndCommunityOutreachAccumulated
262                                                  .add(received.mul(MarketingAndCommunityOutreachPercentage)
263                                                  .div(100));
264       
265       CashReserveFundAccumulated = CashReserveFundAccumulated
266                                    .add(received.mul(CashReserveFundPercentage)
267                                    .div(100));
268       
269       OperationalExpensesAccumulated = OperationalExpensesAccumulated
270                                        .add(received.mul(OperationalExpensesPercentage)
271                                        .div(100));
272       
273       SoftwareProductDevelopmentAccumulated = SoftwareProductDevelopmentAccumulated
274                                               .add(received.mul(SoftwareProductDevelopmentPercentage)
275                                               .div(100));
276       
277       FoundersTeamAndAdvisorsAccumulated = FoundersTeamAndAdvisorsAccumulated
278                                             .add(received.mul(FoundersTeamAndAdvisorsPercentage)
279                                             .div(100));
280   }
281 
282   // @return true if the transaction can buy tokens
283   function validPurchase() internal constant returns (bool) {
284     bool withinPeriod = now >= startTime && now <= endTime;
285     bool nonZeroPurchase = msg.value != 0;
286     bool withinContributionLimit = msg.value >= minimumContribution && msg.value <= maximumContribution;
287     return withinPeriod && nonZeroPurchase && withinContributionLimit;
288   }
289 
290   // @return true if crowdsale event has ended
291   function hasEnded() public constant returns (bool) {
292     return now > endTime;
293   }
294   
295    /**
296     * function to change the end timestamp of the ico
297     * can only be called by owner wallet
298     **/
299     function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{
300         endTime = endTimeUnixTimestamp;
301     }
302     
303     /**
304     * function to change the start timestamp of the ico
305     * can only be called by owner wallet
306     **/
307     
308     function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{
309         startTime = startTimeUnixTimestamp;
310     }
311     
312      /**
313      * function to pause the crowdsale 
314      * can only be called from owner wallet
315      **/
316      
317     function pauseCrowdsale() public onlyOwner {
318         isCrowdsalePaused = true;
319     }
320 
321     /**
322      * function to resume the crowdsale if it is paused
323      * can only be called from owner wallet
324      **/ 
325     function resumeCrowdsale() public onlyOwner {
326         isCrowdsalePaused = false;
327     }
328      
329      function takeTokensBack() public onlyOwner
330      {
331          uint remainingTokensInTheContract = token.balanceOf(address(this));
332          token.transfer(owner,remainingTokensInTheContract);
333      }
334      
335     /**
336      * function to change the minimum contribution
337      * can only be called from owner wallet
338      **/ 
339     function changeMinimumContribution(uint256 minContribution) public onlyOwner {
340         minimumContribution = minContribution;
341     }
342     
343     /**
344      * function to change the maximum contribution
345      * can only be called from owner wallet
346      **/ 
347     function changeMaximumContribution(uint256 maxContribution) public onlyOwner {
348         maximumContribution = maxContribution;
349     }
350     
351     /**
352      * function to withdraw LongTermFoundationBudget funds to the owner wallet
353      * can only be called from owner wallet
354      **/  
355     function withdrawLongTermFoundationBudget() public onlyOwner {
356         require(LongTermFoundationBudgetAccumulated > 0);
357         owner.transfer(LongTermFoundationBudgetAccumulated);
358         LongTermFoundationBudgetAccumulated = 0;
359     }
360     
361      /**
362      * function to withdraw LegalContingencyFunds funds to the owner wallet
363      * can only be called from owner wallet
364      **/
365      
366     function withdrawLegalContingencyFunds() public onlyOwner {
367         require(LegalContingencyFundsAccumulated > 0);
368         owner.transfer(LegalContingencyFundsAccumulated);
369         LegalContingencyFundsAccumulated = 0;
370     }
371     
372      /**
373      * function to withdraw MarketingAndCommunityOutreach funds to the owner wallet
374      * can only be called from owner wallet
375      **/
376     function withdrawMarketingAndCommunityOutreach() public onlyOwner {
377         require (MarketingAndCommunityOutreachAccumulated > 0);
378         owner.transfer(MarketingAndCommunityOutreachAccumulated);
379         MarketingAndCommunityOutreachAccumulated = 0;
380     }
381     
382      /**
383      * function to withdraw CashReserveFund funds to the owner wallet
384      * can only be called from owner wallet
385      **/
386     function withdrawCashReserveFund() public onlyOwner {
387         require(CashReserveFundAccumulated > 0);
388         owner.transfer(CashReserveFundAccumulated);
389         CashReserveFundAccumulated = 0;
390     }
391     
392      /**
393      * function to withdraw OperationalExpenses funds to the owner wallet
394      * can only be called from owner wallet
395      **/
396     function withdrawOperationalExpenses() public onlyOwner {
397         require(OperationalExpensesAccumulated > 0);
398         owner.transfer(OperationalExpensesAccumulated);
399         OperationalExpensesAccumulated = 0;
400     }
401     
402      /**
403      * function to withdraw SoftwareProductDevelopment funds to the owner wallet
404      * can only be called from owner wallet
405      **/
406     function withdrawSoftwareProductDevelopment() public onlyOwner {
407         require (SoftwareProductDevelopmentAccumulated > 0);
408         owner.transfer(SoftwareProductDevelopmentAccumulated);
409         SoftwareProductDevelopmentAccumulated = 0;
410     }
411     
412      /**
413      * function to withdraw FoundersTeamAndAdvisors funds to the owner wallet
414      * can only be called from owner wallet
415      **/
416     function withdrawFoundersTeamAndAdvisors() public onlyOwner {
417         require (FoundersTeamAndAdvisorsAccumulated > 0);
418         owner.transfer(FoundersTeamAndAdvisorsAccumulated);
419         FoundersTeamAndAdvisorsAccumulated = 0;
420     }
421     
422      /**
423      * function to withdraw all funds to the owner wallet
424      * can only be called from owner wallet
425      **/
426     function withdrawAllFunds() public onlyOwner {
427         require (address(this).balance > 0);
428         owner.transfer(address(this).balance);
429     }
430 }