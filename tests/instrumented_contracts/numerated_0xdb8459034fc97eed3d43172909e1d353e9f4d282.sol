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
89  contract URUNCrowdsale is Ownable{
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
101   uint256 public ratePerWei = 800;
102 
103   // amount of raised money in wei
104   uint256 public weiRaised;
105 
106   uint256 public TOKENS_SOLD;
107   
108   uint256 public minimumContributionPresalePhase1 = uint(2).mul(10 ** 18); //2 eth is the minimum contribution in presale phase 1
109   uint256 public minimumContributionPresalePhase2 = uint(1).mul(10 ** 18); //1 eth is the minimum contribution in presale phase 2
110   
111   uint256 public maxTokensToSaleInClosedPreSale;
112   
113   uint256 public bonusInPreSalePhase1;
114   uint256 public bonusInPreSalePhase2;
115   
116   bool public isCrowdsalePaused = false;
117   
118   uint256 public totalDurationInDays = 31 days;
119   
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
130   constructor(uint256 _startTime, address _wallet, address _tokenAddress) public 
131   {
132     
133     require(_wallet != 0x0);
134     require(_startTime >=now);
135     startTime = _startTime;  
136     
137     endTime = startTime + totalDurationInDays;
138     require(endTime >= startTime);
139    
140     owner = _wallet;
141     
142     maxTokensToSaleInClosedPreSale = 60000000 * 10 ** 18;
143     bonusInPreSalePhase1 = 50;
144     bonusInPreSalePhase2 = 40;
145     token = TokenInterface(_tokenAddress);
146   }
147   
148   
149    // fallback function can be used to buy tokens
150    function () public  payable {
151      buyTokens(msg.sender);
152     }
153     
154     function determineBonus(uint tokens) internal view returns (uint256 bonus) 
155     {
156         uint256 timeElapsed = now - startTime;
157         uint256 timeElapsedInDays = timeElapsed.div(1 days);
158         
159         //Closed pre-sale phase 1 (15 days)
160         if (timeElapsedInDays <15)
161         {
162             bonus = tokens.mul(bonusInPreSalePhase1); 
163             bonus = bonus.div(100);
164             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInClosedPreSale);
165         }
166         //Closed pre-sale phase 2 (16 days)
167         else if (timeElapsedInDays >=15 && timeElapsedInDays <31)
168         {
169             bonus = tokens.mul(bonusInPreSalePhase2); 
170             bonus = bonus.div(100);
171             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInClosedPreSale);
172         }
173         else 
174         {
175             bonus = 0;
176         }
177     }
178 
179   // low level token purchase function
180   
181   function buyTokens(address beneficiary) public payable {
182     require(beneficiary != 0x0);
183     require(isCrowdsalePaused == false);
184     require(isAddressWhiteListed[beneficiary]);
185     require(validPurchase());
186     
187     require(isWithinContributionRange());
188     
189     require(TOKENS_SOLD<maxTokensToSaleInClosedPreSale);
190    
191     uint256 weiAmount = msg.value;
192     
193     // calculate token amount to be created
194     uint256 tokens = weiAmount.mul(ratePerWei);
195     uint256 bonus = determineBonus(tokens);
196     tokens = tokens.add(bonus);
197     
198     // update state
199     weiRaised = weiRaised.add(weiAmount);
200     
201     token.transfer(beneficiary,tokens);
202     emit TokenPurchase(owner, beneficiary, weiAmount, tokens);
203     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
204     forwardFunds();
205   }
206 
207   // send ether to the fund collection wallet
208   function forwardFunds() internal {
209     owner.transfer(msg.value);
210   }
211 
212   // @return true if the transaction can buy tokens
213   function validPurchase() internal constant returns (bool) {
214     bool withinPeriod = now >= startTime && now <= endTime;
215     bool nonZeroPurchase = msg.value != 0;
216     return withinPeriod && nonZeroPurchase;
217   }
218 
219   // @return true if crowdsale event has ended
220   function hasEnded() public constant returns (bool) {
221     return now > endTime;
222   }
223   
224     /**
225     * function to change the end time and start time of the ICO
226     * can only be called by owner wallet
227     **/
228     function changeStartAndEndDate (uint256 startTimeUnixTimestamp, uint256 endTimeUnixTimestamp) public onlyOwner
229     {
230         require (startTimeUnixTimestamp!=0 && endTimeUnixTimestamp!=0);
231         require(endTimeUnixTimestamp>startTimeUnixTimestamp);
232         require(endTimeUnixTimestamp.sub(startTimeUnixTimestamp) >=totalDurationInDays);
233         startTime = startTimeUnixTimestamp;
234         endTime = endTimeUnixTimestamp;
235     }
236     
237     /**
238     * function to change the rate of tokens
239     * can only be called by owner wallet
240     **/
241     function setPriceRate(uint256 newPrice) public onlyOwner {
242         ratePerWei = newPrice;
243     }
244     
245      /**
246      * function to pause the crowdsale 
247      * can only be called from owner wallet
248      **/
249      
250     function pauseCrowdsale() public onlyOwner {
251         isCrowdsalePaused = true;
252     }
253 
254     /**
255      * function to resume the crowdsale if it is paused
256      * can only be called from owner wallet
257      **/ 
258     function resumeCrowdsale() public onlyOwner {
259         isCrowdsalePaused = false;
260     }
261     
262     /**
263      * function to check whether the sent amount is within contribution range or not
264      **/ 
265     function isWithinContributionRange() internal constant returns (bool)
266     {
267         uint timePassed = now.sub(startTime);
268         timePassed = timePassed.div(1 days);
269 
270         if (timePassed<15)
271             require(msg.value>=minimumContributionPresalePhase1);
272         else if (timePassed>=15 && timePassed<31)
273             require(msg.value>=minimumContributionPresalePhase2);
274         else
275             revert();   // off time - no sales during other time periods
276             
277         return true;
278      }
279      
280      /**
281       * function through which owner can take back the tokens from the contract
282       **/ 
283      function takeTokensBack() public onlyOwner
284      {
285          uint remainingTokensInTheContract = token.balanceOf(address(this));
286          token.transfer(owner,remainingTokensInTheContract);
287      }
288      
289      /**
290       * function through which owner can transfer the tokens to any address
291       * use this which to properly display the tokens that have been sold via ether or other payments
292       **/ 
293      function manualTokenTransfer(address receiver, uint value) public onlyOwner
294      {
295          token.transfer(receiver,value);
296          TOKENS_SOLD = TOKENS_SOLD.add(value);
297      }
298      
299      /**
300       * Function to add a single address to whitelist
301       * Can only be called by owner wallet address
302       **/ 
303      function addSingleAddressToWhitelist(address whitelistedAddr) public onlyOwner
304      {
305          isAddressWhiteListed[whitelistedAddr] = true;
306      }
307      
308      /**
309       * Function to add multiple addresses to whitelist
310       * Can only be called by owner wallet address
311       **/ 
312      function addMultipleAddressesToWhitelist(address[] whitelistedAddr) public onlyOwner
313      {
314          for (uint i=0;i<whitelistedAddr.length;i++)
315          {
316             isAddressWhiteListed[whitelistedAddr[i]] = true;
317          }
318      }
319      
320      /**
321       * Function to remove an address from whitelist 
322       * Can only be called by owner wallet address 
323       **/ 
324      function removeSingleAddressFromWhitelist(address whitelistedAddr) public onlyOwner
325      {
326          isAddressWhiteListed[whitelistedAddr] = false;
327      }
328      
329      /**
330      * Function to remove multiple addresses from whitelist 
331      * Can only be called by owner wallet address 
332      **/ 
333      function removeMultipleAddressesFromWhitelist(address[] whitelistedAddr) public onlyOwner
334      {
335         for (uint i=0;i<whitelistedAddr.length;i++)
336          {
337             isAddressWhiteListed[whitelistedAddr[i]] = false;
338          }
339      }
340      
341      /**
342       * Function to check if an address is whitelisted 
343       **/ 
344      function checkIfAddressIsWhiteListed(address whitelistedAddr) public view returns (bool)
345      {
346          return isAddressWhiteListed[whitelistedAddr];
347      }
348 }