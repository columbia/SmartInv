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
116   
117   bool isCrowdsalePaused = false;
118   
119   uint256 totalDurationInDays = 75 days;
120   mapping(address=>bool) isAddressWhiteListed;
121   /**
122    * event for token purchase logging
123    * @param purchaser who paid for the tokens
124    * @param beneficiary who got the tokens
125    * @param value weis paid for purchase
126    * @param amount amount of tokens purchased
127    */
128   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
129 
130   function PVCCrowdsale(uint256 _startTime, address _wallet, address _tokenAddress) public 
131   {
132     
133     require(_wallet != 0x0);
134     //TODO: Uncomment the following before deployment on main network
135     require(_startTime >=now);
136     startTime = _startTime;  
137     
138     //TODO: Comment the following when deploying on main network
139     //startTime = now;
140     endTime = startTime + totalDurationInDays;
141     require(endTime >= startTime);
142    
143     owner = _wallet;
144     
145     maxTokensToSale = 32500000 * 10 ** 18;
146     
147     bonusInPreSalePhase1 = 30;
148     bonusInPreSalePhase2 = 25;
149     bonusInPublicSalePhase1 = 20;
150     bonusInPreSalePhase2 = 10;
151     bonusInPublicSalePhase3 = 5;
152     
153     TokensForTeamVesting = 7000000 * 10 ** 18;
154     TokensForAdvisorVesting = 3000000 * 10 ** 18;
155     token = TokenInterface(_tokenAddress);
156   }
157   
158   
159    // fallback function can be used to buy tokens
160    function () public  payable {
161      buyTokens(msg.sender);
162     }
163     
164   function determineBonus(uint tokens) internal view returns (uint256 bonus) 
165     {
166         uint256 timeElapsed = now - startTime;
167         uint256 timeElapsedInDays = timeElapsed.div(1 days);
168         
169         //Closed pre-sale phase 1 (8 days)
170         if (timeElapsedInDays <8)
171         {
172             bonus = tokens.mul(bonusInPreSalePhase1); 
173             bonus = bonus.div(100);
174             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
175         }
176         //Closed pre-sale phase 2 (8 days)
177         else if (timeElapsedInDays >=8 && timeElapsedInDays <16)
178         {
179             bonus = tokens.mul(bonusInPreSalePhase2); 
180             bonus = bonus.div(100);
181             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
182         }
183         //Public sale phase 1 (30 days)
184         else if (timeElapsedInDays >=16 && timeElapsedInDays <46)
185         {
186             bonus = tokens.mul(bonusInPublicSalePhase1); 
187             bonus = bonus.div(100);
188             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
189         }
190          //Public sale phase 2 (11 days)
191         else if (timeElapsedInDays >=46 && timeElapsedInDays <57)
192         {
193             bonus = tokens.mul(bonusInPublicSalePhase2); 
194             bonus = bonus.div(100);
195             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
196         }
197         //Public sale phase 3 (6 days)
198         else if (timeElapsedInDays >=57 && timeElapsedInDays <63)
199         {
200             bonus = tokens.mul(bonusInPublicSalePhase3); 
201             bonus = bonus.div(100);
202             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
203         }
204         //Public sale phase 4 (11 days)
205         else 
206         {
207             bonus = 0;
208         }
209     }
210   // low level token purchase function
211   
212   function buyTokens(address beneficiary) public payable {
213     require(beneficiary != 0x0);
214     require(isCrowdsalePaused == false);
215     require(isAddressWhiteListed[beneficiary] == true);
216     require(validPurchase());
217     
218     require(TOKENS_SOLD<maxTokensToSale);
219    
220     uint256 weiAmount = msg.value;
221     
222     // calculate token amount to be created
223     uint256 tokens = weiAmount.mul(ratePerWei);
224     uint256 bonus = determineBonus(tokens);
225     tokens = tokens.add(bonus);
226     
227     // update state
228     weiRaised = weiRaised.add(weiAmount);
229     
230     token.transfer(beneficiary,tokens);
231     emit TokenPurchase(owner, beneficiary, weiAmount, tokens);
232     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
233     forwardFunds();
234   }
235 
236   // send ether to the fund collection wallet
237   function forwardFunds() internal {
238     owner.transfer(msg.value);
239   }
240 
241   // @return true if the transaction can buy tokens
242   function validPurchase() internal constant returns (bool) {
243     bool withinPeriod = now >= startTime && now <= endTime;
244     bool nonZeroPurchase = msg.value != 0;
245     return withinPeriod && nonZeroPurchase;
246   }
247 
248   // @return true if crowdsale event has ended
249   function hasEnded() public constant returns (bool) {
250     return now > endTime;
251   }
252   
253    /**
254     * function to change the end timestamp of the ico
255     * can only be called by owner wallet
256     **/
257     function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{
258         endTime = endTimeUnixTimestamp;
259     }
260     
261     /**
262     * function to change the start timestamp of the ico
263     * can only be called by owner wallet
264     **/
265     
266     function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{
267         startTime = startTimeUnixTimestamp;
268     }
269     
270     /**
271     * function to change the rate of tokens
272     * can only be called by owner wallet
273     **/
274     function setPriceRate(uint256 newPrice) public onlyOwner {
275         ratePerWei = newPrice;
276     }
277     
278      /**
279      * function to pause the crowdsale 
280      * can only be called from owner wallet
281      **/
282      
283     function pauseCrowdsale() public onlyOwner {
284         isCrowdsalePaused = true;
285     }
286 
287     /**
288      * function to resume the crowdsale if it is paused
289      * can only be called from owner wallet
290      **/ 
291     function resumeCrowdsale() public onlyOwner {
292         isCrowdsalePaused = false;
293     }
294     
295     /**
296      * function through which owner can remove an address from whitelisting
297     **/ 
298     function addAddressToWhitelist(address _whitelist) public onlyOwner
299     {
300         isAddressWhiteListed[_whitelist]= true;
301     }
302     /**
303       * function through which owner can whitelist an address
304       **/ 
305     function removeAddressToWhitelist(address _whitelist) public onlyOwner
306     {
307         isAddressWhiteListed[_whitelist]= false;
308     }
309      /**
310       * function through which owner can take back the tokens from the contract
311       **/ 
312      function takeTokensBack() public onlyOwner
313      {
314          uint remainingTokensInTheContract = token.balanceOf(address(this));
315          token.transfer(owner,remainingTokensInTheContract);
316      }
317      
318      /**
319       * once the ICO has ended, owner can send all the unsold tokens to treasury address 
320       **/ 
321      function sendUnsoldTokensToTreasury(address treasury) public onlyOwner
322      {
323          require(hasEnded());
324          uint remainingTokensInTheContract = token.balanceOf(address(this));
325          token.transfer(treasury,remainingTokensInTheContract);
326      }
327 }