1 pragma solidity ^0.4.23;
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
89  contract EthereumTravelCrowdsale is Ownable{
90   using SafeMath for uint256;
91  
92   // The token being sold
93   TokenInterface public token;
94   
95   // Hardcaps & Softcaps
96   uint Hardcap = 100000;
97   uint Softcap = 10000;
98 
99   // start and end timestamps where investments are allowed (both inclusive)
100   uint256 public startTime;
101   uint256 public endTime;
102 
103 
104   // how many token units a buyer gets per wei
105   uint256 public ratePerWei = 10000;
106 
107   // amount of raised money in wei
108   uint256 public weiRaised;
109   uint256 public weiRaisedInPreICO;
110   uint256 maxTokensToSale;
111   
112   uint256 public TOKENS_SOLD;
113   
114 
115   uint256 bonusPercInICOPhase1;
116   uint256 bonusPercInICOPhase2;
117   uint256 bonusPercInICOPhase3;
118   
119   bool isCrowdsalePaused = false;
120   
121   uint256 totalDurationInDays = 57 days;
122   
123   mapping(address=>uint)  EthSentAgainstAddress;
124   address[] usersAddressForPreICO;
125   
126   /**
127    * event for token purchase logging
128    * @param purchaser who paid for the tokens
129    * @param beneficiary who got the tokens
130    * @param value weis paid for purchase
131    * @param amount amount of tokens purchased
132    */
133   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
134 
135   function EthereumTravelCrowdsale(uint256 _startTime, address _wallet, address _tokenAddress) public 
136   {
137     //require(_startTime >=now);
138     require(_wallet != 0x0);
139     
140     weiRaised=0;
141     weiRaisedInPreICO=0;
142     startTime = _startTime;  
143     //startTime = now;
144     endTime = startTime + totalDurationInDays;
145     require(endTime >= startTime);
146    
147     owner = _wallet;
148 
149     bonusPercInICOPhase1 = 30;
150     bonusPercInICOPhase2 = 20;
151     bonusPercInICOPhase3 = 10;
152     
153     token = TokenInterface(_tokenAddress);
154     maxTokensToSale=(token.totalSupply().mul(60)).div(100);
155     
156   }
157   
158   
159    // fallback function can be used to buy tokens
160    function () public  payable {
161      buyTokens(msg.sender);
162     }
163     
164     function determineBonus(uint tokens) internal view returns (uint256 bonus) 
165     {
166         uint256 timeElapsed = now - startTime;
167         uint256 timeElapsedInDays = timeElapsed.div(1 days);
168 
169         //Pre ICO Phase ( June 05 - 15 i.e. 11 days)
170        if (timeElapsedInDays <12)
171         {
172             bonus = 0;
173         }
174         //Break ( June 16 - July 30 i.e. 10 days)
175       else if (timeElapsedInDays >= 12 && timeElapsedInDays <27)
176         {
177             revert();
178         }
179         
180         //ICO phase 1 ( July 1 - July 10 i.e. 10 days)
181         else if (timeElapsedInDays >= 27 && timeElapsedInDays <37)
182         {
183             bonus = tokens.mul(bonusPercInICOPhase1); 
184             bonus = bonus.div(100);
185             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
186         }
187         
188         //ICO phase 2 ( July 11- July 20 i.e. 10 days)
189         else if (timeElapsedInDays >= 37 && timeElapsedInDays<47)
190         {
191             bonus = tokens.mul(bonusPercInICOPhase2); 
192             bonus = bonus.div(100);
193             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
194         }
195         
196         //ICO phase 3 ( July 21- July 30 i.e. 10 days)
197         else if (timeElapsedInDays >= 47 && timeElapsedInDays<57)
198         {
199             bonus = tokens.mul(bonusPercInICOPhase3); 
200             bonus = bonus.div(100);
201             require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
202         }
203         
204         else 
205         {
206             bonus = 0;
207         }
208     }
209 
210   // low level token purchase function
211   
212   function buyTokens(address beneficiary) public payable {
213     require(beneficiary != 0x0);
214     require(isCrowdsalePaused == false);
215     require(validPurchase());
216     require(msg.value>=1*10**18);
217     
218     require(TOKENS_SOLD<maxTokensToSale);
219    
220     uint256 weiAmount = msg.value;
221     uint256 timeElapsed = now - startTime;
222     uint256 timeElapsedInDays = timeElapsed.div(1 days);
223 
224         //Pre ICO Phase ( June 05 - 15 i.e. 11 days)
225        if (timeElapsedInDays <12)
226         {
227             require(usersAddressForPreICO.length<=5000);
228             // checks if the user is sending eths the firt time
229             if(EthSentAgainstAddress[beneficiary]==0)
230             {
231                 usersAddressForPreICO.push(beneficiary);
232             }
233             EthSentAgainstAddress[beneficiary]+=weiAmount; 
234             // update state
235             weiRaised = weiRaised.add(weiAmount);
236             weiRaisedInPreICO = weiRaisedInPreICO.add(weiAmount);
237             forwardFunds();
238         }
239         //Break ( June 16 - July 30 i.e. 15 days)
240       else if (timeElapsedInDays >= 12 && timeElapsedInDays <27)
241         {
242             revert();
243         }
244       else {
245           
246            // calculate token amount to be created
247             uint256 tokens = weiAmount.mul(ratePerWei);
248             uint256 bonus = determineBonus(tokens);
249             tokens = tokens.add(bonus);
250             require(TOKENS_SOLD.add(tokens)<=maxTokensToSale);
251             
252             // update state
253             weiRaised = weiRaised.add(weiAmount);
254             
255             token.transfer(beneficiary,tokens);
256             emit TokenPurchase(owner, beneficiary, weiAmount, tokens);
257             TOKENS_SOLD = TOKENS_SOLD.add(tokens);
258             forwardFunds();
259         
260        }
261    
262   
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
297         changeEndDate(startTime+totalDurationInDays);
298     }
299     
300     /**
301     * function to change the rate of tokens
302     * can only be called by owner wallet
303     **/
304     function setPriceRate(uint256 newPrice) public onlyOwner {
305         ratePerWei = newPrice;
306     }
307     
308    
309      /**
310      * function to pause the crowdsale 
311      * can only be called from owner wallet
312      **/
313      
314     function pauseCrowdsale() public onlyOwner {
315         isCrowdsalePaused = true;
316     }
317 
318     /**
319      * function to resume the crowdsale if it is paused
320      * can only be called from owner wallet
321      **/ 
322     function resumeCrowdsale() public onlyOwner {
323         isCrowdsalePaused = false;
324     }
325     
326   
327      
328      // ------------------------------------------------------------------------
329      // Remaining tokens for sale
330      // ------------------------------------------------------------------------
331      function remainingTokensForSale() public constant returns (uint) {
332          return maxTokensToSale.sub(TOKENS_SOLD);
333      }
334     
335      
336      function burnUnsoldTokens() public onlyOwner 
337      {
338          require(hasEnded());
339          uint value = remainingTokensForSale();
340          token.burn(value);
341          TOKENS_SOLD = maxTokensToSale;
342      }
343      
344     /**
345       * function through which owner can take back the tokens from the contract
346       **/ 
347      function takeTokensBack() public onlyOwner
348      {
349          uint remainingTokensInTheContract = token.balanceOf(address(this));
350          token.transfer(owner,remainingTokensInTheContract);
351      }
352      
353      /**
354      * send PreICO bonus tokens in bulk to 5000 addresses
355      **/ 
356     function BulkTransfer() public onlyOwner {
357         for(uint i = 0; i<usersAddressForPreICO.length; i++)
358         {
359             uint tks=(EthSentAgainstAddress[usersAddressForPreICO[i]].mul(1000000000*10**18)).div(weiRaisedInPreICO);            
360             token.transfer(usersAddressForPreICO[i],tks);
361         }
362     }
363  }