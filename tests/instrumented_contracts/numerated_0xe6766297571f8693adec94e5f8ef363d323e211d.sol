1 pragma solidity ^0.4.15;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 }
47 
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     if (newOwner != address(0)) {
82       owner = newOwner;
83     }
84   }
85 
86 }
87 
88 
89 
90 
91 /**
92  * @title  
93  * @dev DatTokenSale is a contract for managing a token crowdsale.
94  * DatTokenSale have a start and end date, where investors can make
95  * token purchases and the crowdsale will assign them tokens based
96  * on a token per ETH rate. Funds collected are forwarded to a refundable valut 
97  * as they arrive.
98  */
99 contract DatumTokenSale is  Ownable {
100 
101   using SafeMath for uint256;
102 
103   address public whiteListControllerAddress;
104 
105   //lookup addresses for whitelist
106   mapping (address => bool) public whiteListAddresses;
107 
108   //lookup addresses for special bonuses
109   mapping (address => uint) public bonusAddresses;
110 
111   //loopup for max token amount per user allowed
112   mapping(address => uint256) public maxAmountAddresses;
113 
114   //loopup for balances
115   mapping(address => uint256) public balances;
116 
117   // start and end date where investments are allowed (both inclusive)
118   uint256 public startDate = 1509282000;//29 Oct 2017 13:00:00 +00:00 UTC
119   //uint256 public startDate = 1509210891;//29 Oct 2017 13:00:00 +00:00 UTC
120   
121   uint256 public endDate = 1511960400; //29 Nov 2017 13:00:00 +00:00 UTC
122 
123   // Minimum amount to participate (wei for internal usage)
124   uint256 public minimumParticipationAmount = 300000000000000000 wei; //0.1 ether
125 
126   // Maximum amount to participate
127   uint256 public maximalParticipationAmount = 1000 ether; //1000 ether
128 
129   // address where funds are collected
130   address wallet;
131 
132   // how many token units a buyer gets per ether
133   uint256 rate = 25000;
134 
135   // amount of raised money in wei
136   uint256 private weiRaised;
137 
138   //flag for final of crowdsale
139   bool public isFinalized = false;
140 
141   //cap for the sale in ether
142   uint256 public cap = 61200 ether; //61200 ether
143 
144   //total tokenSupply
145   uint256 public totalTokenSupply = 1530000000 ether;
146 
147   // amount of tokens sold
148   uint256 public tokensInWeiSold;
149 
150   uint private bonus1Rate = 28750;
151   uint private bonus2Rate = 28375;
152   uint private bonus3Rate = 28000;
153   uint private bonus4Rate = 27625;
154   uint private bonus5Rate = 27250;
155   uint private bonus6Rate = 26875;
156   uint private bonus7Rate = 26500;
157   uint private bonus8Rate = 26125;
158   uint private bonus9Rate = 25750;
159   uint private bonus10Rate = 25375;
160    
161   event Finalized();
162   /**
163   * @notice Log an event for each funding contributed during the public phase
164   * @notice Events are not logged when the constructor is being executed during
165   *         deployment, so the preallocations will not be logged
166   */
167   event LogParticipation(address indexed sender, uint256 value);
168   
169 
170   /**
171   * @notice Log an event for each funding contributed converted to earned tokens
172   * @notice Events are not logged when the constructor is being executed during
173   *         deployment, so the preallocations will not be logged
174   */
175   event LogTokenReceiver(address indexed sender, uint256 value);
176 
177 
178   /**
179   * @notice Log an event for each funding contributed converted to earned tokens
180   * @notice Events are not logged when the constructor is being executed during
181   *         deployment, so the preallocations will not be logged
182   */
183   event LogTokenRemover(address indexed sender, uint256 value);
184   
185   function DatumTokenSale(address _wallet) payable {
186     wallet = _wallet;
187   }
188 
189   function () payable {
190     require(whiteListAddresses[msg.sender]);
191     require(validPurchase());
192 
193     buyTokens(msg.value);
194   }
195 
196   // low level token purchase function
197   function buyTokens(uint256 amount) internal {
198     //get ammount in wei
199     uint256 weiAmount = amount;
200 
201     // update state
202     weiRaised = weiRaised.add(weiAmount);
203 
204     // get token amount
205     uint256 tokens = getTokenAmount(weiAmount);
206     tokensInWeiSold = tokensInWeiSold.add(tokens);
207 
208     //fire token receive event
209     LogTokenReceiver(msg.sender, tokens);
210 
211     //update balances for user
212     balances[msg.sender] = balances[msg.sender].add(tokens);
213 
214     //fire eth purchase event
215     LogParticipation(msg.sender,msg.value);
216 
217     //forward funds to wallet
218     forwardFunds(amount);
219   }
220 
221 
222   // manually update the tokens sold count to reserve tokens or update stats if other way bought
223   function reserveTokens(address _address, uint256 amount)
224   {
225     require(msg.sender == whiteListControllerAddress);
226 
227     //update balances for user
228     balances[_address] = balances[_address].add(amount);
229 
230     //fire event
231     LogTokenReceiver(_address, amount);
232 
233     tokensInWeiSold = tokensInWeiSold.add(amount);
234   }
235 
236   //release tokens from sold statistist, used if the account was not verified with KYC
237   function releaseTokens(address _address, uint256 amount)
238   {
239     require(msg.sender == whiteListControllerAddress);
240 
241     balances[_address] = balances[_address].sub(amount);
242 
243     //fire event
244     LogTokenRemover(_address, amount);
245 
246     tokensInWeiSold = tokensInWeiSold.sub(amount);
247   }
248 
249   // send ether to the fund collection wallet
250   // override to create custom fund forwarding mechanisms
251   function forwardFunds(uint256 amount) internal {
252     wallet.transfer(amount);
253   }
254 
255   // should be called after crowdsale ends or to emergency stop the sale
256   function finalize() onlyOwner {
257     require(!isFinalized);
258     Finalized();
259     isFinalized = true;
260   }
261 
262   function setWhitelistControllerAddress(address _controller) onlyOwner
263   {
264      whiteListControllerAddress = _controller;
265   }
266 
267   function addWhitelistAddress(address _addressToAdd)
268   {
269       require(msg.sender == whiteListControllerAddress);
270       whiteListAddresses[_addressToAdd] = true;
271   }
272 
273   function addSpecialBonusConditions(address _address, uint _bonusPercent, uint256 _maxAmount) 
274   {
275       require(msg.sender == whiteListControllerAddress);
276 
277       bonusAddresses[_address] = _bonusPercent;
278       maxAmountAddresses[_address] = _maxAmount;
279   }
280 
281   function removeSpecialBonusConditions(address _address) 
282   {
283       require(msg.sender == whiteListControllerAddress);
284 
285       delete bonusAddresses[_address];
286       delete maxAmountAddresses[_address];
287   }
288 
289   function addWhitelistAddresArray(address[] _addressesToAdd)
290   {
291       require(msg.sender == whiteListControllerAddress);
292 
293       for (uint256 i = 0; i < _addressesToAdd.length;i++) 
294       {
295         whiteListAddresses[_addressesToAdd[i]] = true;
296       }
297       
298   }
299 
300   function removeWhitelistAddress(address _addressToAdd)
301   {
302       require(msg.sender == whiteListControllerAddress);
303 
304       delete whiteListAddresses[_addressToAdd];
305   }
306 
307 
308     function getTokenAmount(uint256 weiAmount) internal returns (uint256 tokens){
309         //add bonus
310         uint256 bonusRate = getBonus();
311 
312         //check for special bonus and override rate if exists
313         if(bonusAddresses[msg.sender] != 0)
314         {
315             uint bonus = bonusAddresses[msg.sender];
316             //TODO: CALUC SHCHECK
317             bonusRate = rate.add((rate.mul(bonus)).div(100));
318         } 
319 
320         // calculate token amount to be created
321         uint256 weiTokenAmount = weiAmount.mul(bonusRate);
322         return weiTokenAmount;
323     }
324 
325 
326     //When a user buys our token they will recieve a bonus depedning on time:,
327     function getBonus() internal constant returns (uint256 amount){
328         uint diffInSeconds = now - startDate;
329         uint diffInHours = (diffInSeconds/60)/60;
330         
331         // 10/29/2017 - 11/1/2017
332         if(diffInHours < 72){
333             return bonus1Rate;
334         }
335 
336         // 11/1/2017 - 11/4/2017
337         if(diffInHours >= 72 && diffInHours < 144){
338             return bonus2Rate;
339         }
340 
341         // 11/4/2017 - 11/7/2017
342         if(diffInHours >= 144 && diffInHours < 216){
343             return bonus3Rate;
344         }
345 
346         // 11/7/2017 - 11/10/2017
347         if(diffInHours >= 216 && diffInHours < 288){
348             return bonus4Rate;
349         }
350 
351          // 11/10/2017 - 11/13/2017
352         if(diffInHours >= 288 && diffInHours < 360){
353             return bonus5Rate;
354         }
355 
356          // 11/13/2017 - 11/16/2017
357         if(diffInHours >= 360 && diffInHours < 432){
358             return bonus6Rate;
359         }
360 
361          // 11/16/2017 - 11/19/2017
362         if(diffInHours >= 432 && diffInHours < 504){
363             return bonus7Rate;
364         }
365 
366          // 11/19/2017 - 11/22/2017
367         if(diffInHours >= 504 && diffInHours < 576){
368             return bonus8Rate;
369         }
370 
371           // 11/22/2017 - 11/25/2017
372         if(diffInHours >= 576 && diffInHours < 648){
373             return bonus9Rate;
374         }
375 
376           // 11/25/2017 - 11/28/2017
377         if(diffInHours >= 648 && diffInHours < 720){
378             return bonus10Rate;
379         }
380 
381         return rate; 
382     }
383 
384   // @return true if the transaction can buy tokens
385   // check for valid time period, min amount and within cap
386   function validPurchase() internal constant returns (bool) {
387     uint256 tokenAmount = getTokenAmount(msg.value);
388     bool withinPeriod = startDate <= now && endDate >= now;
389     bool nonZeroPurchase = msg.value != 0;
390     bool minAmount = msg.value >= minimumParticipationAmount;
391     bool maxAmount = msg.value <= maximalParticipationAmount;
392     bool withTokensSupply = tokensInWeiSold.add(tokenAmount) <= totalTokenSupply;
393     //bool withinCap = weiRaised.add(msg.value) <= cap;
394     bool withMaxAmountForAddress = maxAmountAddresses[msg.sender] == 0 || balances[msg.sender].add(tokenAmount) <= maxAmountAddresses[msg.sender];
395 
396     if(maxAmountAddresses[msg.sender] != 0)
397     {
398       maxAmount = balances[msg.sender].add(tokenAmount) <= maxAmountAddresses[msg.sender];
399     }
400 
401     return withinPeriod && nonZeroPurchase && minAmount && !isFinalized && withTokensSupply && withMaxAmountForAddress && maxAmount;
402   }
403 
404     // @return true if the goal is reached
405   function capReached() public constant returns (bool) {
406     return tokensInWeiSold >= totalTokenSupply;
407   }
408 
409   // @return true if crowdsale event has ended
410   function hasEnded() public constant returns (bool) {
411     return isFinalized;
412   }
413 
414 }