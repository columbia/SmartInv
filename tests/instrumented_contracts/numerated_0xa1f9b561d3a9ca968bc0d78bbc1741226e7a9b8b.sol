1 pragma solidity ^0.4.18;
2 
3 
4 /**
5 Mockup object 
6 */
7 contract ElementhToken {
8     
9   bool public mintingFinished = false;
10     function mint(address _to, uint256 _amount) public returns (bool) {
11     if(_to != address(0)) mintingFinished = false;
12     if(_amount != 0) mintingFinished = false;
13     return true;
14     }
15 }
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     mapping(address => bool)  internal owners;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65      * account.
66      */
67     function Ownable() public{
68         owners[msg.sender] = true;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owners[msg.sender] == true);
76         _;
77     }
78 
79     function addOwner(address newAllowed) onlyOwner public {
80         owners[newAllowed] = true;
81     }
82 
83     function removeOwner(address toRemove) onlyOwner public {
84         owners[toRemove] = false;
85     }
86 
87     function isOwner() public view returns(bool){
88         return owners[msg.sender] == true;
89     }
90 
91 }
92 
93 
94 /**
95  * @title Crowdsale
96  * @dev Crowdsale is a base contract for managing a token crowdsale.
97  * Crowdsales have a start and end timestamps, where investors can make
98  * token purchases and the crowdsale will assign them tokens based
99  * on a token per ETH rate. Funds collected are forwarded to a wallet
100  * as they arrive.
101  */
102 contract Crowdsale {
103   using SafeMath for uint256;
104 
105   // The token being sold
106   ElementhToken public token;
107 
108   // start and end timestamps where investments are allowed (both inclusive)
109   uint256 public startTime;
110   uint256 public endTime;
111 
112   // address where funds are collected
113   address public wallet;
114 
115   // how many token units a buyer gets per wei
116   uint256 public rate;
117 
118   // amount of raised money in wei
119   uint256 public weiRaised;
120 
121   
122 
123   /**
124    * event for token purchase logging
125    * @param purchaser who paid for the tokens
126    * @param beneficiary who got the tokens
127    * @param value weis paid for purchase
128    * @param amount amount of tokens purchased
129    */
130   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
131 
132 
133   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, ElementhToken _token) public {
134     require(_startTime >= now);
135     require(_endTime >= _startTime);
136     require(_rate > 0);
137     require(_wallet != address(0));
138     require(_token != address(0));
139 
140     token = _token;
141     startTime = _startTime;
142     endTime = _endTime;
143     rate = _rate;
144     wallet = _wallet;
145   }
146 
147 
148   // @return true if the transaction can buy tokens
149   function validPurchase(bool isBtc) internal view returns (bool) {
150     bool withinPeriod = now >= startTime && now <= endTime;
151     bool nonZeroPurchase = msg.value != 0 || isBtc;
152     return withinPeriod && nonZeroPurchase;
153   }
154 
155   // @return true if crowdsale event has ended
156   function hasEnded() public view returns (bool) {
157     return now > endTime;
158   }
159 
160 
161 
162 
163 }
164 
165 /**
166  * @title CappedCrowdsale
167  * @dev Extension of Crowdsale with a max amount of funds raised
168  */
169 contract CappedCrowdsale is Crowdsale {
170   using SafeMath for uint256;
171 
172   uint256 public cap;
173 
174   function CappedCrowdsale(uint256 _cap) public {
175     require(_cap > 0);
176     cap = _cap * 1 ether;
177   }
178 
179   // overriding Crowdsale#validPurchase to add extra cap logic
180   // @return true if investors can buy at the moment
181   function validPurchase(bool isBtc) internal view returns (bool) {
182     bool withinCap = weiRaised.add(msg.value) <= cap;
183     return super.validPurchase(isBtc) && withinCap;
184   }
185 
186   // overriding Crowdsale#hasEnded to add cap logic
187   // @return true if crowdsale event has ended
188   function hasEnded() public view returns (bool) {
189     bool capReached = weiRaised >= cap;
190     return super.hasEnded() || capReached;
191   }
192 
193 }
194 
195 
196 
197 /**
198  * @title FinalizableCrowdsale
199  * @dev Extension of Crowdsale where an owner can do extra work
200  * after finishing.
201  */
202 contract FinalizableCrowdsale is Crowdsale, Ownable {
203   using SafeMath for uint256;
204 
205   bool public isFinalized = false;
206 
207   event Finalized();
208 
209   /**
210    * @dev Must be called after crowdsale ends, to do some extra finalization
211    * work. Calls the contract's finalization function.
212    */
213   function finalize() onlyOwner public {
214     require(!isFinalized);
215     require(hasEnded());
216 
217     finalization();
218     Finalized();
219 
220     isFinalized = true;
221   }
222 
223   /**
224    * @dev Can be overridden to add finalization logic. The overriding function
225    * should call super.finalization() to ensure the chain of finalization is
226    * executed entirely.
227    */
228   function finalization() internal {
229       Finalized();
230   }
231 }
232 
233 
234 
235 
236 /**
237  * @title RefundableCrowdsale
238  * @dev Extension of Crowdsale contract that adds a funding goal, and
239  * the possibility of users getting a refund if goal is not met.
240  * Uses a RefundVault as the crowdsale's vault.
241  */
242 contract RefundableCrowdsale is FinalizableCrowdsale {
243   using SafeMath for uint256;
244 
245   // minimum amount of funds to be raised in weis
246   uint256 public goal;
247 
248   mapping (address => bool) refunded;
249   mapping (address => uint256) saleBalances;  
250   mapping (address => bool) claimed;
251 
252   event Refunded(address indexed holder, uint256 amount);
253 
254   function RefundableCrowdsale(uint256 _goal) public {
255     goal = _goal * 1 ether;
256   }
257 
258   // if crowdsale is unsuccessful, investors can claim refunds here
259   function claimRefund() public {
260     require(isFinalized);
261     require(!goalReached());
262     require(!refunded[msg.sender]);
263     require(saleBalances[msg.sender] != 0);
264 
265     uint refund = saleBalances[msg.sender];
266     require (msg.sender.send(refund));
267     refunded[msg.sender] = true;
268 
269     Refunded(msg.sender, refund);
270   }
271 
272   function goalReached() public view returns (bool) {
273     return weiRaised >= goal;
274   }
275 
276 }
277 
278 
279 
280 /**
281  * @title SampleCrowdsale
282  * @dev This is an example of a fully fledged crowdsale.
283  * The way to add new features to a base crowdsale is by multiple inheritance.
284  * In this example we are providing following extensions:
285  * CappedCrowdsale - sets a max boundary for raised funds
286  * RefundableCrowdsale - set a min goal to be reached and returns funds if it's not met
287  *
288  * After adding multiple features it's good practice to run integration tests
289  * to ensure that subcontracts works together as intended.
290  */
291 contract ElementhCrowdsale is CappedCrowdsale, RefundableCrowdsale {
292 
293   struct BTCTransaction {
294     uint256 amount;
295     bytes16 hash;
296     address wallet;
297   }
298 
299   // stage of ICO Crowdsale (1 - Closed PreSale, 2 - pre ICO)
300   uint8 public stage;
301 
302 
303   uint256 public bonusStage1;
304   uint256 public bonusStage2FirstDay;
305   uint256 public bonusStage2SecondDay;
306 
307   mapping (bytes16 => BTCTransaction) public BTCTransactions;
308 
309   // amount of raised money in satoshi
310   uint256 public satoshiRaised;
311   uint256 public BTCRate;
312 
313 
314   function ElementhCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _capETH, uint256 _goalETH, address _wallet, uint256 _BTCRate, ElementhToken _token) public
315     CappedCrowdsale(_capETH)
316     FinalizableCrowdsale()
317     RefundableCrowdsale(_goalETH)
318     Crowdsale(_startTime, _endTime, _rate, _wallet, _token){
319       BTCRate = _BTCRate;
320       bonusStage1 = 50;
321       bonusStage2FirstDay = 30;
322       bonusStage2SecondDay = 15;
323       stage = 1;
324     }
325 
326 
327   function setStartTime(uint256 _startTime) public onlyOwner{
328     startTime = _startTime;
329   }
330 
331   function setEndTime(uint256 _endTime) public onlyOwner{
332     endTime = _endTime;
333   }
334 
335   function setRate(uint256 _rate) public onlyOwner{
336     rate = _rate;
337   }
338 
339   function setGoalETH(uint256 _goalETH) public onlyOwner{
340     goal = _goalETH * 1 ether;
341   }
342 
343   function setCapETH(uint256 _capETH) public onlyOwner{
344     cap = _capETH * 1 ether;
345   }
346 
347   function setStage(uint8 _stage) public onlyOwner{
348     stage = _stage;
349   }
350 
351   function setBTCRate(uint _BTCRate) public onlyOwner{
352     BTCRate = _BTCRate;
353   }
354 
355   function setWallet(address _wallet) public onlyOwner{
356     wallet = _wallet;
357   }
358 
359   function setBonuses(uint256 _bonusStage1, uint256 _bonusStage2FirstDay, uint256 _bonusStage2SecondDay) public onlyOwner{
360     bonusStage1 = _bonusStage1;
361     bonusStage2FirstDay = _bonusStage2FirstDay;
362     bonusStage2SecondDay = _bonusStage2SecondDay;
363   }
364 
365   // fallback function can be used to buy tokens
366   function () external payable {
367     buyTokens(msg.sender);
368   }
369 
370   // low level token purchase function
371   function buyTokens(address beneficiary) public payable {
372     require(beneficiary != address(0));
373     require(stage !=0);
374     require(validPurchase(false));
375     if(stage == 1) {
376       require(msg.value >= 10 ether);
377     }
378 
379     if(stage == 2) {
380       require(msg.value >= 1 ether);
381     }
382     
383     uint256 weiAmount = msg.value;
384 
385     uint256 tokens = getTokenAmount(weiAmount);
386 
387     // update state
388     weiRaised = weiRaised.add(weiAmount);
389 
390     token.mint(beneficiary, tokens);
391     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
392 
393     forwardFunds();
394   }
395 
396   // send ether to the fund collection wallet
397   // override to create custom fund forwarding mechanisms
398   function forwardFunds() internal {
399     wallet.transfer(msg.value);
400     saleBalances[msg.sender] = saleBalances[msg.sender].add(msg.value);
401   }
402 
403 
404   function addBTCTransaction(uint256 _amountSatoshi, bytes16 _hashTransaction, address _walletETH) public onlyOwner{
405     require(BTCTransactions[_hashTransaction].amount == 0);
406     require(_walletETH != address(0));
407     require(validPurchase(true));
408 
409     BTCTransactions[_hashTransaction] = BTCTransaction(_amountSatoshi, _hashTransaction, _walletETH);
410 
411     uint256 weiAmount = _amountSatoshi * BTCRate;
412     uint256 tokens = getTokenAmount(weiAmount);
413 
414     // update state
415     weiRaised = weiRaised.add(weiAmount);
416     satoshiRaised = satoshiRaised.add(_amountSatoshi);
417 
418     token.mint(_walletETH, tokens);
419     TokenPurchase(_walletETH, _walletETH, weiAmount, tokens);
420 
421   }
422 
423   function getTokenAmount(uint256 _weiAmount) public view returns (uint256){
424     // calculate token amount to be created + bonus
425     uint256 tokens = _weiAmount.mul(rate);
426 
427     // bonuses
428     if(stage == 1){
429       tokens = tokens.mul(100 + bonusStage1).div(100);
430     }
431 
432     if(stage == 2){
433       if(now - startTime < 1 days){
434         tokens = tokens.mul(100 + bonusStage2FirstDay).div(100);
435       }
436       if(now - startTime < 2 days && now - startTime > 1 days){
437         tokens = tokens.mul(100 + bonusStage2SecondDay).div(100);
438       }
439     }
440 
441     return tokens;
442   }
443 
444   function withdraw() public onlyOwner{
445     wallet.transfer(this.balance);
446   }
447 
448   function deposit() public payable onlyOwner{
449 
450   }
451 
452 }