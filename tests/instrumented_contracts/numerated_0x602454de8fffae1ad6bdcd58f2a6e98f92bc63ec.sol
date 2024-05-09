1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 {
54   function allowance(address owner, address spender) public view returns (uint256);
55   function transferFrom(address from, address to, uint256 value) public returns (bool);
56 }
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68   /**
69    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
70    * account.
71    */
72   constructor() public {
73     owner = msg.sender;
74   }
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84    /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) public onlyOwner {
89     require(newOwner != address(0));
90     emit OwnershipTransferred(owner, newOwner);
91     owner = newOwner;
92   }
93 }
94 
95 /**
96  * @title Pausable
97  * @dev Base contract which allows children to implement an emergency stop mechanism.
98  */
99 contract Pausable is Ownable {
100   event Pause();
101   event Unpause();
102 
103   bool public paused = false;
104 
105 
106   /**
107    * @dev Modifier to make a function callable only when the contract is not paused.
108    */
109   modifier whenNotPaused() {
110     require(!paused);
111     _;
112   }
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is paused.
116    */
117   modifier whenPaused() {
118     require(paused);
119     _;
120   }
121 
122   /**
123    * @dev called by the owner to pause, triggers stopped state
124    */
125   function pause() onlyOwner whenNotPaused public {
126     paused = true;
127     emit Pause();
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() onlyOwner whenPaused public {
134     paused = false;
135     emit Unpause();
136   }
137 }
138 
139 contract KYCCrowdsale is Ownable{
140 
141     bool public isKYCRequired = false;
142 
143     mapping (bytes32 => address) public whiteListed;
144 
145     function enableKYC() external onlyOwner {
146         require(!isKYCRequired); // kyc is not enabled
147         isKYCRequired = true;
148     }
149 
150     function disableKYC() external onlyOwner {
151         require(isKYCRequired); // kyc is enabled
152         isKYCRequired = false; 
153     }
154 
155     //TODO: handle single address can be whiteListed multiple time using unique signed hashes
156         function isWhitelistedAddress(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public returns (bool){
157         assert( whiteListed[hash] == address(0x0)); // verify hash is unique
158         require(owner == ecrecover(hash, v, r, s));
159         whiteListed[hash] = msg.sender;
160         return true;
161     }
162 }
163 
164 /**
165  * @title Crowdsale
166  * @dev Crowdsale is a base contract for managing a token crowdsale.
167  * Crowdsales have a start and end timestamps, where investors can make
168  * token purchases and the crowdsale will assign them tokens based
169  * on a token per ETH rate. Funds collected are forwarded to a wallet
170  * as they arrive.
171  */
172 contract Crowdsale is Pausable, KYCCrowdsale{
173   using SafeMath for uint256;
174     
175   // The token interface
176   ERC20 public token;
177 
178   // The address of token holder that allowed allowance to contract
179   address public tokenWallet;
180 
181   // start and end timestamps where investments are allowed (both inclusive)
182   uint256 public startTime;
183   uint256 public endTime;
184 
185   // address where funds are collected
186   address public wallet;
187 
188   // token rate in wei
189   uint256 public rate;
190   
191   uint256 public roundOneRate;
192   uint256 public roundTwoRate;
193   uint256 public defaultBonussRate;
194 
195   // amount of raised money in wei
196   uint256 public weiRaised;
197 
198   uint256 public tokensSold;
199 
200   uint256 public constant forSale = 16250000 ether;
201 
202   /**
203    * event for token purchase logging
204    * @param purchaser who paid for the tokens
205    * @param beneficiary who got the tokens
206    * @param value weis paid for purchase
207    * @param amount amount of tokens purchased
208    * @param releaseTime tokens unlock time
209    */
210   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 releaseTime);
211 
212   /**
213    * event upon endTime updated
214    */
215   event EndTimeUpdated();
216 
217   /**
218    * EQUI token price updated
219    */
220   event EQUIPriceUpdated(uint256 oldPrice, uint256 newPrice);
221 
222   /**
223    * event for token releasing
224    * @param holder who is releasing his tokens
225    */
226   event TokenReleased(address indexed holder, uint256 amount);
227 
228   constructor() public
229    {
230     owner = address(0xe46d0049D4a4642bC875164bd9293a05dBa523f1);
231     
232     startTime = now;
233     endTime = 1527811199; //GMT: Thursday, May 31, 2018 11:59:59 PM
234     rate = 500000000000000;                     // 1 Token price: 0.0005 Ether == $0.35 @ Ether prie $700
235     roundOneRate = (rate.mul(6)).div(10);       // price at 40% discount
236     roundTwoRate = (rate.mul(65)).div(100);     // price at 35% discount
237     defaultBonussRate = (rate.mul(8)).div(10);  // price at 20% discount
238     
239     wallet =  address(0xccB84A750f386bf5A4FC8C29611ad59057968605);
240     token = ERC20(0xE6FF2834b6Cf56DC23282A5444B297fAcCcA1b28);
241     tokenWallet =  address(0x4AA48F9cF25eB7d2c425780653c321cfaC458FA4);
242     
243   }
244 
245   // fallback function can be used to buy tokens
246   function () external payable {
247     buyTokens(msg.sender);
248   }
249 
250   // low level token purchase function
251   function buyTokens(address beneficiary) public payable whenNotPaused {
252     require(beneficiary != address(0));
253 
254     validPurchase();
255 
256     uint256 weiAmount = msg.value;
257 
258     // calculate token amount to be created
259     uint256 tokens = getTokenAmount(weiAmount);
260 
261     // update state
262     weiRaised = weiRaised.add(weiAmount);
263     tokensSold = tokensSold.add(tokens);
264 
265     balances[beneficiary] = balances[beneficiary].add(tokens);
266     deposited[msg.sender] = deposited[msg.sender].add(weiAmount);
267     
268     updateRoundLimits(tokens);
269     
270     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, releaseTime);
271 
272     forwardFunds();
273   }
274 
275   // @return true if crowdsale event has ended
276   function hasEnded() public view returns (bool) {
277     return now > endTime;
278   }
279   
280    uint256 public roundOneLimit = 9500000 ether;
281    uint256 public roundTwoLimit = 6750000 ether;
282    
283   function updateRoundLimits(uint256 _amount) private {
284       if (roundOneLimit > 0){
285           if(roundOneLimit > _amount){
286                 roundOneLimit = roundOneLimit.sub(_amount);
287                 return;
288           } else {
289               _amount = _amount.sub(roundOneLimit);
290               roundOneLimit = 0;
291           }
292       }
293       roundTwoLimit = roundTwoLimit.sub(_amount);
294   }
295 
296   function getTokenAmount(uint256 weiAmount) public view returns(uint256) {
297   
298       uint256 buffer = 0;
299       uint256 tokens = 0;
300       if(weiAmount < 1 ether)
301       
302         return (weiAmount.mul(1 ether)).div(defaultBonussRate);
303 
304       else if(weiAmount >= 1 ether) {
305           
306           
307           if(roundOneLimit > 0){
308               
309               uint256 amount = roundOneRate * roundOneLimit;
310               
311               if (weiAmount > amount){
312                   buffer = weiAmount - amount;
313                   tokens =  (amount.mul(1 ether)).div(roundOneRate);
314               }else{
315                   
316                   return (weiAmount.mul(1 ether)).div(roundOneRate);
317               }
318         
319           }
320           
321           if(buffer > 0){
322               uint256 roundTwo = (buffer.mul(1 ether)).div(roundTwoRate);
323               return tokens + roundTwo;
324           }
325           
326           return (weiAmount.mul(1 ether)).div(roundTwoRate);
327       }
328   }
329 
330   // send ether to the fund collection wallet
331   function forwardFunds() internal {
332     wallet.transfer(msg.value);
333   }
334 
335   // @return true if the transaction can buy tokens
336   function validPurchase() internal view {
337     require(msg.value != 0);
338     require(now >= startTime && now <= endTime);
339   }
340 
341   function updateEndTime(uint256 newTime) onlyOwner external {
342     require(newTime > startTime);
343     endTime = newTime;
344     emit EndTimeUpdated();
345   }
346 
347   function updateEQUIPrice(uint256 weiAmount) onlyOwner external {
348     require(weiAmount > 0);
349     assert((1 ether) % weiAmount == 0);
350     emit EQUIPriceUpdated(rate, weiAmount);
351     rate = weiAmount;
352     roundOneRate = (weiAmount.mul(6)).div(10);       // price at 40% discount
353     roundTwoRate = (weiAmount.mul(65)).div(100);     // price at 35% discount
354     defaultBonussRate = (weiAmount.mul(8)).div(10);    // price at 20% discount
355   }
356 
357   mapping(address => uint256) balances;
358   mapping(address => uint256) internal deposited;
359   
360   uint256 public releaseTime = 1538351999; //September 30, 2018 11:59:59 PM
361   /**
362   * @dev Gets the balance of the specified address.
363   * @param _owner The address to query the the balance of.
364   * @return An uint256 representing the amount owned by the passed address.
365   */
366   function balanceOf(address _owner) public view returns (uint256 balance) {
367     return balances[_owner];
368   }
369 
370   /**
371    * @notice Transfers tokens held by timelock to beneficiary.
372    */
373   function releaseEQUITokens(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public whenNotPaused {
374     require(now >= releaseTime);
375     
376     require(balances[msg.sender] > 0);
377     uint256 amount = balances[msg.sender];
378     balances[msg.sender] = 0;
379 
380    require(isWhitelistedAddress(hash, v, r, s));
381     if(!token.transferFrom(tokenWallet,msg.sender,amount)){
382         revert();
383     }
384     emit TokenReleased(msg.sender,amount);
385    
386   }
387   
388   function releaseEQUIWihtoutKYC() public whenNotPaused {
389     require(now >= releaseTime);
390     require(isKYCRequired == false);
391     require(balances[msg.sender] > 0);
392     
393     uint256 amount = balances[msg.sender];
394     balances[msg.sender] = 0;
395 
396     if(!token.transferFrom(tokenWallet,msg.sender,amount)){
397         revert();
398     }
399     emit TokenReleased(msg.sender,amount);
400     
401   }
402 
403    /**
404    * @dev Checks the amount of tokens left in the allowance.
405    * @return Amount of tokens left in the allowance
406    */
407   function allowanceBalance() public view returns (uint256) {
408     return token.allowance(tokenWallet, this);
409   }
410 }
411 
412 /**
413  * @title RefundVault
414  * @dev This contract is used for storing funds while a crowdsale
415  * is in progress. Supports refunding the money if crowdsale fails,
416  * and forwarding it if crowdsale is successful.
417  */
418 contract Refundable is Crowdsale {
419 
420   uint256 public availableBalance; 
421   bool public refunding = false;
422 
423   event RefundStatusUpdated();
424   event Deposited();
425   event Withdraw(uint256 _amount);
426   event Refunded(address indexed beneficiary, uint256 weiAmount);
427   
428   function deposit() onlyOwner public payable {
429     availableBalance = availableBalance.add(msg.value);
430     emit Deposited();
431   }
432   
433   function tweakRefundStatus() onlyOwner public {
434     refunding = !refunding;
435     emit RefundStatusUpdated();
436   }
437 
438   
439   function refund() public {
440     require(refunding);
441     uint256 depositedValue = deposited[msg.sender];
442     deposited[msg.sender] = 0;
443     msg.sender.transfer(depositedValue);
444     emit Refunded(msg.sender, depositedValue);
445   }
446   
447   function withDrawBack() onlyOwner public{
448       owner.transfer(contractbalance());
449   }
450   
451   function contractbalance() view public returns( uint256){
452       return address(this).balance;
453   }
454 }