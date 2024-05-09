1 pragma solidity 0.4.20;
2 
3 /**
4  * @title Crowdsale
5  * @dev Crowdsale is a base contract for managing a token crowdsale.
6  * Crowdsales have a start and end timestamps, where investors can make
7  * token purchases and the crowdsale will assign them tokens based
8  * on a token per ETH rate. Funds collected are forwarded to a wallet
9  * as they arrive.
10  */
11  
12  
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20  function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   function Ownable() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 
74 }
75 
76 interface ERC20Interface {
77      function totalSupply() external constant returns (uint);
78      function balanceOf(address tokenOwner) external constant returns (uint balance);
79      function allowance(address tokenOwner, address spender) external constant returns (uint remaining);
80      function transfer(address to, uint tokens) external returns (bool success);
81      function approve(address spender, uint tokens) external returns (bool success);
82      function transferFrom(address from, address to, uint tokens) external returns (bool success);
83      event Transfer(address indexed from, address indexed to, uint tokens);
84      event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
85 }
86 
87 contract BaapPayCrowdsale is Ownable{
88   using SafeMath for uint256;
89  
90   // The token being sold
91   ERC20Interface public token;
92 
93   // start and end timestamps where investments are allowed (both inclusive)
94   uint256 public startTime;
95   uint256 public endTime;
96 
97 
98   // how many token units a buyer gets per wei
99   uint256 public ratePerWei = 4200;
100 
101   // amount of raised money in wei
102   uint256 public weiRaised;
103 
104   uint256 TOKENS_SOLD;
105   uint256 minimumContribution = 1 * 10 ** 16; //0.01 eth is the minimum contribution
106   
107   uint256 maxTokensToSaleInPreICOPhase = 3000000;
108   uint256 maxTokensToSaleInICOPhase = 83375000;
109   uint256 maxTokensToSale = 94000000;
110   
111   bool isCrowdsalePaused = false;
112   
113   struct Buyers 
114   {
115       address buyerAddress;
116       uint tokenAmount;
117   }
118    Buyers[] tokenBuyers;
119    Buyers buyer;
120   /**
121    * event for token purchase logging
122    * @param purchaser who paid for the tokens
123    * @param beneficiary who got the tokens
124    * @param value weis paid for purchase
125    * @param amount amount of tokens purchased
126    */
127   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
128 
129    modifier checkSize(uint numwords) {
130         assert(msg.data.length >= (numwords * 32) + 4);
131         _;
132     }     
133     
134   function BaapPayCrowdsale(uint256 _startTime, address _wallet, address _tokenToBeUsed) public 
135   {
136     //require(_startTime >=now);
137     require(_wallet != 0x0);
138 
139     //startTime = _startTime;  
140     startTime = now;
141     endTime = startTime + 61 days;
142     require(endTime >= startTime);
143    
144     owner = _wallet;
145     
146     maxTokensToSaleInPreICOPhase = maxTokensToSaleInPreICOPhase.mul(10**18);
147     maxTokensToSaleInICOPhase = maxTokensToSaleInICOPhase.mul(10**18);
148     maxTokensToSale = maxTokensToSale.mul(10**18);
149     
150     token = ERC20Interface(_tokenToBeUsed);
151   }
152   
153   // fallback function can be used to buy tokens
154   function () public  payable {
155     buyTokens(msg.sender);
156   }
157     function determineBonus(uint tokens) internal view returns (uint256 bonus) 
158     {
159         uint256 timeElapsed = now - startTime;
160         uint256 timeElapsedInDays = timeElapsed.div(1 days);
161         if (timeElapsedInDays <20)
162         {
163             if (TOKENS_SOLD <maxTokensToSaleInPreICOPhase)
164             {
165                 bonus = tokens.mul(20); //20% bonus
166                 bonus = bonus.div(100);
167                 require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInPreICOPhase);
168             }
169             else if (TOKENS_SOLD >= maxTokensToSaleInPreICOPhase && TOKENS_SOLD < maxTokensToSale)
170             {
171                 bonus = tokens.mul(15); //15% bonus
172                 bonus = bonus.div(100);
173                 require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
174             }
175             else 
176             {
177                 bonus = 0;
178             }
179         }
180         else if (timeElapsedInDays >= 20 && timeElapsedInDays <27)
181         {
182             revert();  //no sale during this time, so revert this transaction
183         }
184         else if (timeElapsedInDays >= 27 && timeElapsedInDays<36)
185         {
186             if (TOKENS_SOLD < maxTokensToSaleInICOPhase)
187             {
188                 bonus = tokens.mul(15); //15% bonus
189                 bonus = bonus.div(100);
190                 require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInICOPhase);
191             }
192             else if (TOKENS_SOLD >= maxTokensToSaleInICOPhase && TOKENS_SOLD < maxTokensToSale)
193             {
194                 bonus = tokens.mul(10); //10% bonus
195                 bonus = bonus.div(100);
196                 require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
197             }
198         }
199         else if (timeElapsedInDays >= 36 && timeElapsedInDays<46)
200         {
201             if (TOKENS_SOLD < maxTokensToSaleInICOPhase)
202             {
203                 bonus = tokens.mul(10); //10% bonus
204                 bonus = bonus.div(100);
205                 require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInICOPhase);
206             }
207             else if (TOKENS_SOLD >= maxTokensToSaleInICOPhase && TOKENS_SOLD < maxTokensToSale)
208             {
209                 bonus = tokens.mul(5); //5% bonus
210                 bonus = bonus.div(100);
211                 require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSale);
212             }
213         }
214         else if (timeElapsedInDays >= 46 && timeElapsedInDays<56)
215         {
216             if (TOKENS_SOLD < maxTokensToSaleInICOPhase)
217             {
218                 bonus = tokens.mul(5); //5% bonus
219                 bonus = bonus.div(100);
220                 require (TOKENS_SOLD.add(tokens.add(bonus)) <= maxTokensToSaleInICOPhase);
221             }
222             else if (TOKENS_SOLD >= maxTokensToSaleInICOPhase && TOKENS_SOLD < maxTokensToSale)
223             {
224                 bonus = 0;
225             }
226         }
227         else 
228         {
229             bonus = 0;
230         }
231     }
232 
233   // low level token purchase function
234   
235   function buyTokens(address beneficiary) public payable {
236     require(beneficiary != 0x0);
237     require(isCrowdsalePaused == false);
238     require(validPurchase());
239     require(msg.value>= minimumContribution);
240     require(TOKENS_SOLD<maxTokensToSale);
241    
242     uint256 weiAmount = msg.value;
243     
244     // calculate token amount to be created
245     uint256 tokens = weiAmount.mul(ratePerWei);
246     uint256 bonus = determineBonus(tokens);
247     tokens = tokens.add(bonus);
248     require(TOKENS_SOLD.add(tokens)<=maxTokensToSale);
249     
250     // update state
251     weiRaised = weiRaised.add(weiAmount);
252     
253     buyer = Buyers({buyerAddress:beneficiary,tokenAmount:tokens});
254     tokenBuyers.push(buyer);
255     TokenPurchase(owner, beneficiary, weiAmount, tokens);
256     TOKENS_SOLD = TOKENS_SOLD.add(tokens);
257     forwardFunds();
258   }
259 
260   // send ether to the fund collection wallet
261   function forwardFunds() internal {
262     owner.transfer(msg.value);
263   }
264 
265   // @return true if the transaction can buy tokens
266   function validPurchase() internal constant returns (bool) {
267     bool withinPeriod = now >= startTime && now <= endTime;
268     bool nonZeroPurchase = msg.value != 0;
269     return withinPeriod && nonZeroPurchase;
270   }
271 
272   // @return true if crowdsale event has ended
273   function hasEnded() public constant returns (bool) {
274     return now > endTime;
275   }
276   
277    
278     function changeEndDate(uint256 endTimeUnixTimestamp) public onlyOwner returns(bool) {
279         endTime = endTimeUnixTimestamp;
280     }
281     
282     function changeStartDate(uint256 startTimeUnixTimestamp) public onlyOwner returns(bool) {
283         startTime = startTimeUnixTimestamp;
284     }
285     
286     function setPriceRate(uint256 newPrice) public onlyOwner returns (bool) {
287         ratePerWei = newPrice;
288     }
289     
290     function changeMinimumContribution(uint256 minContribution) public onlyOwner returns (bool) {
291         minimumContribution = minContribution.mul(10 ** 15);
292     }
293      /**
294      * function to pause the crowdsale 
295      * can only be called from owner wallet
296      **/
297      
298     function pauseCrowdsale() public onlyOwner returns(bool) {
299         isCrowdsalePaused = true;
300     }
301 
302     /**
303      * function to resume the crowdsale if it is paused
304      * can only be called from owner wallet
305      * if the crowdsale has been stopped, this function would not resume it
306      **/ 
307     function resumeCrowdsale() public onlyOwner returns (bool) {
308         isCrowdsalePaused = false;
309     }
310     
311      // ------------------------------------------------------------------------
312      // Remaining tokens for sale
313      // ------------------------------------------------------------------------
314      function remainingTokensForSale() public constant returns (uint) {
315          return maxTokensToSale.sub(TOKENS_SOLD);
316      }
317      
318      function showMyTokenBalance() public constant returns (uint) {
319          return token.balanceOf(msg.sender);
320      }
321      
322      function pullTokensBack() public onlyOwner {
323         token.transfer(owner,token.balanceOf(address(this))); 
324      }
325      
326      function sendTokensToBuyers() public onlyOwner {
327          require(hasEnded());
328          for (uint i=0;i<tokenBuyers.length;i++)
329          {
330              token.transfer(tokenBuyers[i].buyerAddress,tokenBuyers[i].tokenAmount);
331          }
332      }
333 }