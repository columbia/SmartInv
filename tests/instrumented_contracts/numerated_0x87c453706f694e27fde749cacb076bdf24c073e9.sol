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
108   uint256 minimumContributionPresalePhase1 = 2 * 10 ** 18; //2 eth is the minimum contribution in presale phase 1
109   uint256 minimumContributionPresalePhase2 = 1 * 10 ** 18; //1 eth is the minimum contribution in presale phase 2
110   
111   uint256 maxTokensToSaleInClosedPreSale;
112   
113   uint256 bonusInPreSalePhase1;
114   uint256 bonusInPreSalePhase2;
115   
116   bool isCrowdsalePaused = false;
117   
118   uint256 totalDurationInDays = 31 days;
119   
120   /**
121    * event for token purchase logging
122    * @param purchaser who paid for the tokens
123    * @param beneficiary who got the tokens
124    * @param value weis paid for purchase
125    * @param amount amount of tokens purchased
126    */
127   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
128 
129   constructor(uint256 _startTime, address _wallet, address _tokenAddress) public 
130   {
131     
132     require(_wallet != 0x0);
133     require(_startTime >=now);
134     startTime = _startTime;  
135 
136     endTime = startTime + totalDurationInDays;
137     require(endTime >= startTime);
138    
139     owner = _wallet;
140     
141     maxTokensToSaleInClosedPreSale = 60000000 * 10 ** 18;
142     bonusInPreSalePhase1 = 50;
143     bonusInPreSalePhase2 = 40;
144     token = TokenInterface(_tokenAddress);
145   }
146   
147   
148    // fallback function can be used to buy tokens
149    function () public  payable {
150      buyTokens(msg.sender);
151     }
152     
153     function determineBonus(uint tokens) internal view returns (uint256 bonus) 
154     {
155         uint256 timeElapsed = now - startTime;
156         uint256 timeElapsedInDays = timeElapsed.div(1 days);
157         
158         //Closed pre-sale phase 1 (15 days)
159         if (timeElapsedInDays <15)
160         {
161             bonus = tokens.mul(bonusInPreSalePhase1); 
162             bonus = bonus.div(100);
163             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInClosedPreSale);
164         }
165         //Closed pre-sale phase 2 (16 days)
166         else if (timeElapsedInDays >=15 && timeElapsedInDays <31)
167         {
168             bonus = tokens.mul(bonusInPreSalePhase2); 
169             bonus = bonus.div(100);
170             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInClosedPreSale);
171         }
172         else 
173         {
174             bonus = 0;
175         }
176     }
177 
178   // low level token purchase function
179   
180   function buyTokens(address beneficiary) public payable {
181     require(beneficiary != 0x0);
182     require(isCrowdsalePaused == false);
183     require(validPurchase());
184     
185     require(isWithinContributionRange());
186     
187     require(TOKENS_SOLD<maxTokensToSaleInClosedPreSale);
188    
189     uint256 weiAmount = msg.value;
190     
191     // calculate token amount to be created
192     uint256 tokens = weiAmount.mul(ratePerWei);
193     uint256 bonus = determineBonus(tokens);
194     tokens = tokens.add(bonus);
195     
196     // update state
197     weiRaised = weiRaised.add(weiAmount);
198     
199     token.transfer(beneficiary,tokens);
200     emit TokenPurchase(owner, beneficiary, weiAmount, tokens);
201     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
202     forwardFunds();
203   }
204 
205   // send ether to the fund collection wallet
206   function forwardFunds() internal {
207     owner.transfer(msg.value);
208   }
209 
210   // @return true if the transaction can buy tokens
211   function validPurchase() internal constant returns (bool) {
212     bool withinPeriod = now >= startTime && now <= endTime;
213     bool nonZeroPurchase = msg.value != 0;
214     return withinPeriod && nonZeroPurchase;
215   }
216 
217   // @return true if crowdsale event has ended
218   function hasEnded() public constant returns (bool) {
219     return now > endTime;
220   }
221   
222    /**
223     * function to change the end timestamp of the ico
224     * can only be called by owner wallet
225     **/
226     function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner{
227         endTime = endTimeUnixTimestamp;
228     }
229     
230     /**
231     * function to change the start timestamp of the ico
232     * can only be called by owner wallet
233     **/
234     
235     function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner{
236         startTime = startTimeUnixTimestamp;
237     }
238     
239     /**
240     * function to change the rate of tokens
241     * can only be called by owner wallet
242     **/
243     function setPriceRate(uint256 newPrice) public onlyOwner {
244         ratePerWei = newPrice;
245     }
246     
247      /**
248      * function to pause the crowdsale 
249      * can only be called from owner wallet
250      **/
251      
252     function pauseCrowdsale() public onlyOwner {
253         isCrowdsalePaused = true;
254     }
255 
256     /**
257      * function to resume the crowdsale if it is paused
258      * can only be called from owner wallet
259      **/ 
260     function resumeCrowdsale() public onlyOwner {
261         isCrowdsalePaused = false;
262     }
263     
264     /**
265      * function to check whether the sent amount is within contribution range or not
266      **/ 
267     function isWithinContributionRange() internal constant returns (bool)
268     {
269         uint timePassed = now.sub(startTime);
270         timePassed = timePassed.div(1 days);
271 
272         if (timePassed<15)
273             require(msg.value>=minimumContributionPresalePhase1);
274         else if (timePassed>=15 && timePassed<31)
275             require(msg.value>=minimumContributionPresalePhase2);
276         else
277             revert();   // off time - no sales during other time periods
278             
279         return true;
280      }
281      
282      /**
283       * function through which owner can take back the tokens from the contract
284       **/ 
285      function takeTokensBack() public onlyOwner
286      {
287          uint remainingTokensInTheContract = token.balanceOf(address(this));
288          token.transfer(owner,remainingTokensInTheContract);
289      }
290      
291      /**
292       * function through which owner can transfer the tokens to any address
293       * use this which to properly display the tokens that have been sold via ether or other payments
294       **/ 
295      function manualTokenTransfer(address receiver, uint value) public onlyOwner
296      {
297          token.transfer(receiver,value);
298          TOKENS_SOLD = TOKENS_SOLD.add(value);
299      }
300 }