1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) public onlyOwner {
68     require(newOwner != address(0));
69     emit OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 
75 interface TokenInterface {
76      function totalSupply() external constant returns (uint);
77      function balanceOf(address tokenOwner) external constant returns (uint balance);
78      function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
79      function transfer(address to, uint tokens) external returns (bool success);
80      function approve(address spender, uint tokens) external returns (bool success);
81      function transferFrom(address from, address to, uint tokens) external returns (bool success);
82      function burn(uint256 _value) external; 
83      event Transfer(address indexed from, address indexed to, uint tokens);
84      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
85      event Burn(address indexed burner, uint256 value);
86 }
87 
88  contract KRCPreSaleContract is Ownable{
89 
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
112 
113   uint256 minimumContribution;
114   uint256 maximumContribution;
115   
116   bool isCrowdsalePaused = false;
117   
118   uint256 totalDurationInDays = 23 days;
119   
120   uint256 LongTermFoundationBudgetAccumulated;
121   uint256 LegalContingencyFundsAccumulated;
122   uint256 MarketingAndCommunityOutreachAccumulated;
123   uint256 CashReserveFundAccumulated;
124   uint256 OperationalExpensesAccumulated;
125   uint256 SoftwareProductDevelopmentAccumulated;
126   uint256 FoundersTeamAndAdvisorsAccumulated;
127   
128   uint256 LongTermFoundationBudgetPercentage;
129   uint256 LegalContingencyFundsPercentage;
130   uint256 MarketingAndCommunityOutreachPercentage;
131   uint256 CashReserveFundPercentage;
132   uint256 OperationalExpensesPercentage;
133   uint256 SoftwareProductDevelopmentPercentage;
134   uint256 FoundersTeamAndAdvisorsPercentage;
135   
136     struct Whitelist {
137     	string Email;
138     }
139     
140     mapping (address => Whitelist) Whitelists;
141     
142     address[] public WhitelistsAccts;
143     
144     function setWhitelist(address _address, string _Email) public  {
145         var whitelist = Whitelists[_address];
146         whitelist.Email = _Email;
147 
148     	WhitelistsAccts.push(_address) -1;
149     }
150     
151     function getWhitelist() view public returns (address[]) {
152     	return WhitelistsAccts;
153     }
154     
155     function searchWhitelist(address _address) view public returns (string){
156         return (Whitelists[_address].Email);
157     }
158     
159     function countWhitelists() view public returns (uint) {
160         return WhitelistsAccts.length;
161     }
162 
163 
164   /**
165    * event for token purchase logging
166    * @param purchaser who paid for the tokens
167    * @param beneficiary who got the tokens
168    * @param value weis paid for purchase
169    * @param amount amount of tokens purchased
170    */
171   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
172 
173   function KRCPreSaleContract(uint256 _startTime, address _wallet, address _tokenAddress) public 
174   {
175     require(_startTime >=now);
176     require(_wallet != 0x0);
177 
178     startTime = _startTime;  
179     
180     endTime = startTime + totalDurationInDays;
181     require(endTime >= startTime);
182    
183     owner = _wallet;
184     
185     maxTokensToSale = 87500000e18;
186     bonusInPhase1 = 10;
187     bonusInPhase2 = 5;
188     minimumContribution = 5e17;
189     maximumContribution = 150e18;
190     ratePerWei = 100e18;
191     token = TokenInterface(_tokenAddress);
192     
193     LongTermFoundationBudgetAccumulated = 0;
194     LegalContingencyFundsAccumulated = 0;
195     MarketingAndCommunityOutreachAccumulated = 0;
196     CashReserveFundAccumulated = 0;
197     OperationalExpensesAccumulated = 0;
198     SoftwareProductDevelopmentAccumulated = 0;
199     FoundersTeamAndAdvisorsAccumulated = 0;
200   
201     LongTermFoundationBudgetPercentage = 15;
202     LegalContingencyFundsPercentage = 10;
203     MarketingAndCommunityOutreachPercentage = 10;
204     CashReserveFundPercentage = 20;
205     OperationalExpensesPercentage = 10;
206     SoftwareProductDevelopmentPercentage = 15;
207     FoundersTeamAndAdvisorsPercentage = 20;
208   }
209   
210   
211    // fallback function can be used to buy tokens
212    function () public  payable {
213      
214      //buyTokens(msg.sender);
215       
216      var isexist = searchWhitelist(msg.sender);
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
247         else 
248         {
249             bonus = 0;
250         }
251     }
252 
253   // low level token purchase function
254   
255   function buyTokens(address beneficiary) public payable {
256     require(beneficiary != 0x0);
257     require(isCrowdsalePaused == false);
258     require(validPurchase());
259 
260     
261     require(TOKENS_SOLD<maxTokensToSale);
262    
263     uint256 weiAmount = msg.value.div(10**16);
264     
265     uint256 tokens = calculateTokens(weiAmount);
266     
267     // update state
268     weiRaised = weiRaised.add(msg.value);
269     
270     token.transfer(beneficiary,tokens);
271     emit TokenPurchase(owner, beneficiary, msg.value, tokens);
272     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
273     distributeFunds();
274   }
275   
276   function distributeFunds() internal {
277       uint received = msg.value;
278       
279       LongTermFoundationBudgetAccumulated = LongTermFoundationBudgetAccumulated
280                                             .add(received.mul(LongTermFoundationBudgetPercentage)
281                                             .div(100));
282       
283       LegalContingencyFundsAccumulated = LegalContingencyFundsAccumulated
284                                          .add(received.mul(LegalContingencyFundsPercentage)
285                                          .div(100));
286       
287       MarketingAndCommunityOutreachAccumulated = MarketingAndCommunityOutreachAccumulated
288                                                  .add(received.mul(MarketingAndCommunityOutreachPercentage)
289                                                  .div(100));
290       
291       CashReserveFundAccumulated = CashReserveFundAccumulated
292                                    .add(received.mul(CashReserveFundPercentage)
293                                    .div(100));
294       
295       OperationalExpensesAccumulated = OperationalExpensesAccumulated
296                                        .add(received.mul(OperationalExpensesPercentage)
297                                        .div(100));
298       
299       SoftwareProductDevelopmentAccumulated = SoftwareProductDevelopmentAccumulated
300                                               .add(received.mul(SoftwareProductDevelopmentPercentage)
301                                               .div(100));
302       
303       FoundersTeamAndAdvisorsAccumulated = FoundersTeamAndAdvisorsAccumulated
304                                             .add(received.mul(FoundersTeamAndAdvisorsPercentage)
305                                             .div(100));
306   }
307 
308   // @return true if the transaction can buy tokens
309   function validPurchase() internal constant returns (bool) {
310     bool withinPeriod = now >= startTime && now <= endTime;
311     bool nonZeroPurchase = msg.value != 0;
312     bool withinContributionLimit = msg.value >= minimumContribution && msg.value <= maximumContribution;
313     return withinPeriod && nonZeroPurchase && withinContributionLimit;
314   }
315 
316   // @return true if crowdsale event has ended
317   function hasEnded() public constant returns (bool) {
318     return now > endTime;
319   }
320   
321    /**
322     * function to change the end timestamp of the ico
323     * can only be called by owner wallet
324     **/
325     function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{
326         endTime = endTimeUnixTimestamp;
327     }
328     
329     /**
330     * function to change the start timestamp of the ico
331     * can only be called by owner wallet
332     **/
333     
334     function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{
335         startTime = startTimeUnixTimestamp;
336     }
337     
338      /**
339      * function to pause the crowdsale 
340      * can only be called from owner wallet
341      **/
342      
343     function pauseCrowdsale() public onlyOwner {
344         isCrowdsalePaused = true;
345     }
346 
347     /**
348      * function to resume the crowdsale if it is paused
349      * can only be called from owner wallet
350      **/ 
351     function resumeCrowdsale() public onlyOwner {
352         isCrowdsalePaused = false;
353     }
354      
355      function takeTokensBack() public onlyOwner
356      {
357          uint remainingTokensInTheContract = token.balanceOf(address(this));
358          token.transfer(owner,remainingTokensInTheContract);
359      }
360      
361     /**
362      * function to change the minimum contribution
363      * can only be called from owner wallet
364      **/ 
365     function changeMinimumContribution(uint256 minContribution) public onlyOwner {
366         minimumContribution = minContribution;
367     }
368     
369     /**
370      * function to change the maximum contribution
371      * can only be called from owner wallet
372      **/ 
373     function changeMaximumContribution(uint256 maxContribution) public onlyOwner {
374         maximumContribution = maxContribution;
375     }
376     
377     /**
378      * function to withdraw LongTermFoundationBudget funds to the owner wallet
379      * can only be called from owner wallet
380      **/  
381     function withdrawLongTermFoundationBudget() public onlyOwner {
382         require(LongTermFoundationBudgetAccumulated > 0);
383         owner.transfer(LongTermFoundationBudgetAccumulated);
384         LongTermFoundationBudgetAccumulated = 0;
385     }
386     
387      /**
388      * function to withdraw LegalContingencyFunds funds to the owner wallet
389      * can only be called from owner wallet
390      **/
391      
392     function withdrawLegalContingencyFunds() public onlyOwner {
393         require(LegalContingencyFundsAccumulated > 0);
394         owner.transfer(LegalContingencyFundsAccumulated);
395         LegalContingencyFundsAccumulated = 0;
396     }
397     
398      /**
399      * function to withdraw MarketingAndCommunityOutreach funds to the owner wallet
400      * can only be called from owner wallet
401      **/
402     function withdrawMarketingAndCommunityOutreach() public onlyOwner {
403         require (MarketingAndCommunityOutreachAccumulated > 0);
404         owner.transfer(MarketingAndCommunityOutreachAccumulated);
405         MarketingAndCommunityOutreachAccumulated = 0;
406     }
407     
408      /**
409      * function to withdraw CashReserveFund funds to the owner wallet
410      * can only be called from owner wallet
411      **/
412     function withdrawCashReserveFund() public onlyOwner {
413         require(CashReserveFundAccumulated > 0);
414         owner.transfer(CashReserveFundAccumulated);
415         CashReserveFundAccumulated = 0;
416     }
417     
418      /**
419      * function to withdraw OperationalExpenses funds to the owner wallet
420      * can only be called from owner wallet
421      **/
422     function withdrawOperationalExpenses() public onlyOwner {
423         require(OperationalExpensesAccumulated > 0);
424         owner.transfer(OperationalExpensesAccumulated);
425         OperationalExpensesAccumulated = 0;
426     }
427     
428      /**
429      * function to withdraw SoftwareProductDevelopment funds to the owner wallet
430      * can only be called from owner wallet
431      **/
432     function withdrawSoftwareProductDevelopment() public onlyOwner {
433         require (SoftwareProductDevelopmentAccumulated > 0);
434         owner.transfer(SoftwareProductDevelopmentAccumulated);
435         SoftwareProductDevelopmentAccumulated = 0;
436     }
437     
438      /**
439      * function to withdraw FoundersTeamAndAdvisors funds to the owner wallet
440      * can only be called from owner wallet
441      **/
442     function withdrawFoundersTeamAndAdvisors() public onlyOwner {
443         require (FoundersTeamAndAdvisorsAccumulated > 0);
444         owner.transfer(FoundersTeamAndAdvisorsAccumulated);
445         FoundersTeamAndAdvisorsAccumulated = 0;
446     }
447     
448      /**
449      * function to withdraw all funds to the owner wallet
450      * can only be called from owner wallet
451      **/
452     function withdrawAllFunds() public onlyOwner {
453         require (address(this).balance > 0);
454         owner.transfer(address(this).balance);
455     }
456 }