1 pragma solidity ^0.4.21;
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
52   function Ownable() public {
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
89  contract PVCCrowdsale is Ownable{
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
101   uint256 public ratePerWei = 1000;
102 
103   // amount of raised money in wei
104   uint256 public weiRaised;
105 
106   uint256 public TOKENS_SOLD;
107   
108   uint256 maxTokensToSale;
109   uint256 TokensForTeamVesting;
110   uint256 TokensForAdvisorVesting;
111   uint256 bonusInPreSalePhase1;
112   uint256 bonusInPreSalePhase2;
113   uint256 bonusInPublicSalePhase1;
114   uint256 bonusInPublicSalePhase2;
115   uint256 bonusInPublicSalePhase3;
116   uint256 bonusInPublicSalePhase4;
117   uint256 bonusInPublicSalePhase5;
118   uint256 bonusInPublicSalePhase6;
119   
120   bool isCrowdsalePaused = false;
121   
122   uint256 totalDurationInDays = 145 days;
123   mapping(address=>bool) isAddressWhiteListed;
124   /**
125    * event for token purchase logging
126    * @param purchaser who paid for the tokens
127    * @param beneficiary who got the tokens
128    * @param value weis paid for purchase
129    * @param amount amount of tokens purchased
130    */
131   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
132 
133   function PVCCrowdsale(uint256 _startTime, address _wallet, address _tokenAddress) public 
134   {
135     
136     require(_wallet != 0x0);
137     startTime = _startTime;  
138     endTime = startTime + totalDurationInDays;
139     require(endTime >= startTime);
140    
141     owner = _wallet;
142     
143     maxTokensToSale = 32500000 * 10 ** 18;
144     TOKENS_SOLD = 346018452900000000000;    // the tokens that have been sold through the previous contract
145                    
146     weiRaised = 285373570000000000;     // the weis that have been raised through the previous contract
147 
148     bonusInPreSalePhase1 = 30;
149     bonusInPreSalePhase2 = 25;
150     bonusInPublicSalePhase1 = 20;
151     bonusInPublicSalePhase2 = 25;
152     bonusInPublicSalePhase3 = 20;
153     bonusInPublicSalePhase4 = 15;
154     bonusInPublicSalePhase5 = 10;
155     bonusInPublicSalePhase6 = 5;
156     
157     TokensForTeamVesting = 7000000 * 10 ** 18;
158     TokensForAdvisorVesting = 3000000 * 10 ** 18;
159     token = TokenInterface(_tokenAddress);
160   }
161   
162   
163    // fallback function can be used to buy tokens
164    function () public  payable {
165      buyTokens(msg.sender);
166     }
167     
168   function determineBonus(uint tokens) internal view returns (uint256 bonus) 
169   {
170         uint256 timeElapsed = now - startTime;
171         uint256 timeElapsedInDays = timeElapsed.div(1 days);
172         
173         //Closed pre-sale phase 1 (8 days starting apr 9)
174         if (timeElapsedInDays <8)
175         {
176             bonus = tokens.mul(bonusInPreSalePhase1); 
177             bonus = bonus.div(100);
178             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
179         }
180         //Closed pre-sale phase 2 (8 days starting apr 17)
181         else if (timeElapsedInDays >=8 && timeElapsedInDays <16)
182         {
183             bonus = tokens.mul(bonusInPreSalePhase2); 
184             bonus = bonus.div(100);
185             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
186         }
187         //Public sale phase 1 original (30 days starting on apr 25)
188         //Public sale phase 1 new (10 days ending may 4)
189         else if (timeElapsedInDays >=16 && timeElapsedInDays <26)
190         {
191             bonus = tokens.mul(bonusInPublicSalePhase1); 
192             bonus = bonus.div(100);
193             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
194         }
195 
196         //Public sale phase 2 (27 days)
197         else if (timeElapsedInDays >=26 && timeElapsedInDays <53)
198         {
199             bonus = tokens.mul(bonusInPublicSalePhase2); 
200             bonus = bonus.div(100);
201             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
202         }
203 
204          //Public sale phase 3 (30 days)
205         else if (timeElapsedInDays >=53 && timeElapsedInDays <83)
206         {
207             bonus = tokens.mul(bonusInPublicSalePhase3); 
208             bonus = bonus.div(100);
209             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
210         }
211         //Public sale phase 4 (15 days)
212         else if (timeElapsedInDays >=83 && timeElapsedInDays <98)
213         {
214             bonus = tokens.mul(bonusInPublicSalePhase4); 
215             bonus = bonus.div(100);
216             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
217         }
218         //Public sale phase 5 (16 days)
219         else if (timeElapsedInDays >=98 && timeElapsedInDays <114)
220         {
221             bonus = tokens.mul(bonusInPublicSalePhase5); 
222             bonus = bonus.div(100);
223             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
224         }
225         //Public sale phase 6 (31 days)
226         else if (timeElapsedInDays >=114 && timeElapsedInDays <145)
227         {
228             bonus = tokens.mul(bonusInPublicSalePhase6); 
229             bonus = bonus.div(100);
230             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
231         }
232         //
233         else 
234         {
235             bonus = 0;
236         }
237 
238 
239     }
240   // low level token purchase function
241   
242   function buyTokens(address beneficiary) public payable {
243     require(beneficiary != 0x0);
244     require(isCrowdsalePaused == false);
245     require(validPurchase());
246     
247     require(TOKENS_SOLD<maxTokensToSale);
248    
249     uint256 weiAmount = msg.value;
250     
251     // calculate token amount to be created
252     uint256 tokens = weiAmount.mul(ratePerWei);
253     uint256 bonus = determineBonus(tokens);
254     tokens = tokens.add(bonus);
255     
256     // update state
257     weiRaised = weiRaised.add(weiAmount);
258     
259     token.transfer(beneficiary,tokens);
260     emit TokenPurchase(owner, beneficiary, weiAmount, tokens);
261     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
262     forwardFunds();
263   }
264 
265   // send ether to the fund collection wallet
266   function forwardFunds() internal {
267     owner.transfer(msg.value);
268   }
269 
270   // @return true if the transaction can buy tokens
271   function validPurchase() internal constant returns (bool) {
272     bool withinPeriod = now >= startTime && now <= endTime;
273     bool nonZeroPurchase = msg.value != 0;
274     return withinPeriod && nonZeroPurchase;
275   }
276 
277   // @return true if crowdsale event has ended
278   function hasEnded() public constant returns (bool) {
279     return now > endTime;
280   }
281   
282    /**
283     * function to change the end timestamp of the ico
284     * can only be called by owner wallet
285     **/
286     function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{
287         endTime = endTimeUnixTimestamp;
288     }
289     
290     /**
291     * function to change the start timestamp of the ico
292     * can only be called by owner wallet
293     **/
294     
295     function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{
296         startTime = startTimeUnixTimestamp;
297     }
298     
299     /**
300     * function to change the rate of tokens
301     * can only be called by owner wallet
302     **/
303     function setPriceRate(uint256 newPrice) public onlyOwner {
304         ratePerWei = newPrice;
305     }
306     
307      /**
308      * function to pause the crowdsale 
309      * can only be called from owner wallet
310      **/
311      
312     function pauseCrowdsale() public onlyOwner {
313         isCrowdsalePaused = true;
314     }
315 
316     /**
317      * function to resume the crowdsale if it is paused
318      * can only be called from owner wallet
319      **/ 
320     function resumeCrowdsale() public onlyOwner {
321         isCrowdsalePaused = false;
322     }
323     
324      /**
325       * function through which owner can take back the tokens from the contract
326       **/ 
327      function takeTokensBack() public onlyOwner
328      {
329          uint remainingTokensInTheContract = token.balanceOf(address(this));
330          token.transfer(owner,remainingTokensInTheContract);
331      }
332      
333      /**
334       * once the ICO has ended, owner can send all the unsold tokens to treasury address 
335       **/ 
336      function sendUnsoldTokensToTreasury(address treasury) public onlyOwner
337      {
338          require(hasEnded());
339          uint remainingTokensInTheContract = token.balanceOf(address(this));
340          token.transfer(treasury,remainingTokensInTheContract);
341      }
342 }