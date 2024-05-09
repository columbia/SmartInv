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
156     function isWhitelistedAddress(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public returns (bool){
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
200   uint256 public constant forSale = 16250000;
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
230     owner = 0xe46d0049D4a4642bC875164bd9293a05dBa523f1;
231     startTime = now;
232     endTime = 1527811199; //GMT: Thursday, May 31, 2018 11:59:59 PM
233     rate = 500000000000000;                     // 1 Token price: 0.0005 Ether == $0.35 @ Ether prie $700
234     roundOneRate = (rate.mul(6)).div(10);       // price at 40% discount
235     roundTwoRate = (rate.mul(65)).div(100);     // price at 35% discount
236     defaultBonussRate = (rate.mul(8)).div(10);  // price at 20% discount
237     
238     wallet =  0xccB84A750f386bf5A4FC8C29611ad59057968605;
239     token = ERC20(0x1b0cD7c0DC07418296585313a816e0Cb953DEa96);
240     tokenWallet =  0xccB84A750f386bf5A4FC8C29611ad59057968605;
241   }
242 
243   // fallback function can be used to buy tokens
244   function () external payable {
245     buyTokens(msg.sender);
246   }
247 
248   // low level token purchase function
249   function buyTokens(address beneficiary) public payable whenNotPaused {
250     require(beneficiary != address(0));
251 
252     validPurchase();
253 
254     uint256 weiAmount = msg.value;
255 
256     // calculate token amount to be created
257     uint256 tokens = getTokenAmount(weiAmount);
258 
259     // update state
260     weiRaised = weiRaised.add(weiAmount);
261     tokensSold = tokensSold.add(tokens);
262     deposited[msg.sender] = deposited[msg.sender].add(weiAmount);
263     updateRoundLimits(tokens);
264    
265     uint256 lockedFor = assignTokens(beneficiary, tokens);
266     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, lockedFor);
267 
268     forwardFunds();
269   }
270 
271   // @return true if crowdsale event has ended
272   function hasEnded() public view returns (bool) {
273     return now > endTime;
274   }
275   
276    uint256 public roundOneLimit = 9500000 ether;
277    uint256 public roundTwoLimit = 6750000 ether;
278    
279   function updateRoundLimits(uint256 _amount) private {
280       if (roundOneLimit > 0){
281           if(roundOneLimit > _amount){
282                 roundOneLimit = roundOneLimit.sub(_amount);
283                 return;
284           } else {
285               _amount = _amount.sub(roundOneLimit);
286               roundOneLimit = 0;
287           }
288       }
289       roundTwoLimit = roundTwoLimit.sub(_amount);
290   }
291 
292   function getTokenAmount(uint256 weiAmount) public view returns(uint256) {
293   
294       uint256 buffer = 0;
295       uint256 tokens = 0;
296       if(weiAmount < 1 ether)
297       
298         // 20% disount = $0.28 EQUI Price , default category
299         // 1 ETH = 2400 EQUI
300         return (weiAmount.div(defaultBonussRate)).mul(1 ether);
301 
302       else if(weiAmount >= 1 ether) {
303           
304           
305           if(roundOneLimit > 0){
306               
307               uint256 amount = roundOneRate * roundOneLimit;
308               
309               if (weiAmount > amount){
310                   buffer = weiAmount - amount;
311                   tokens =  (amount.div(roundOneRate)).mul(1 ether);
312               }else{
313                   // 40% disount = $0.21 EQUI Price , round one bonuss category
314                   // 1 ETH = 3333
315                   return (weiAmount.div(roundOneRate)).mul(1 ether);
316               }
317         
318           }
319           
320           if(buffer > 0){
321               uint256 roundTwo = (buffer.div(roundTwoRate)).mul(1 ether);
322               return tokens + roundTwo;
323           }
324           
325           return (weiAmount.div(roundTwoRate)).mul(1 ether);
326       }
327   }
328 
329   // send ether to the fund collection wallet
330   function forwardFunds() internal {
331     wallet.transfer(msg.value);
332   }
333 
334   // @return true if the transaction can buy tokens
335   function validPurchase() internal view {
336     require(msg.value != 0);
337     require(remainingTokens() > 0,"contract doesn't have tokens");
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
352     roundOneRate = (rate.mul(6)).div(10);       // price at 40% discount
353     roundTwoRate = (rate.mul(65)).div(100);     // price at 35% discount
354     defaultBonussRate = (rate.mul(8)).div(10);    // price at 20% discount
355   }
356 
357   mapping(address => uint256) balances;
358   mapping(address => uint256) internal deposited;
359 
360   struct account{
361       uint256[] releaseTime;
362       mapping(uint256 => uint256) balance;
363   }
364   mapping(address => account) ledger;
365 
366 
367   function assignTokens(address beneficiary, uint256 amount) private returns(uint256 lockedFor){
368       lockedFor = 1526278800; //September 30, 2018 11:59:59 PM
369 
370       balances[beneficiary] = balances[beneficiary].add(amount);
371 
372       ledger[beneficiary].releaseTime.push(lockedFor);
373       ledger[beneficiary].balance[lockedFor] = amount;
374   }
375 
376   /**
377   * @dev Gets the balance of the specified address.
378   * @param _owner The address to query the the balance of.
379   * @return An uint256 representing the amount owned by the passed address.
380   */
381   function balanceOf(address _owner) public view returns (uint256 balance) {
382     return balances[_owner];
383   }
384 
385   function unlockedBalance(address _owner) public view returns (uint256 amount) {
386     for(uint256 i = 0 ; i < ledger[_owner].releaseTime.length; i++){
387         uint256 time = ledger[_owner].releaseTime[i];
388         if(now >= time) amount +=  ledger[_owner].balance[time];
389     }
390   }
391 
392   /**
393    * @notice Transfers tokens held by timelock to beneficiary.
394    */
395   function releaseEQUITokens(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public whenNotPaused {
396     require(balances[msg.sender] > 0);
397 
398     uint256 amount = 0;
399     for(uint8 i = 0 ; i < ledger[msg.sender].releaseTime.length; i++){
400         uint256 time = ledger[msg.sender].releaseTime[i];
401         if(now >= time && ledger[msg.sender].balance[time] > 0){
402             amount = ledger[msg.sender].balance[time];
403             ledger[msg.sender].balance[time] = 0;
404             continue;
405         }
406     }
407 
408     if(amount <= 0 || balances[msg.sender] < amount){
409         revert();
410     }
411 
412     if(isKYCRequired){
413         require(isWhitelistedAddress(hash, v, r, s));
414         balances[msg.sender] = balances[msg.sender].sub(amount);
415         if(!token.transferFrom(tokenWallet,msg.sender,amount)){
416             revert();
417         }
418         emit TokenReleased(msg.sender,amount);
419     } else {
420 
421         balances[msg.sender] = balances[msg.sender].sub(amount);
422         if(!token.transferFrom(tokenWallet,msg.sender,amount)){
423             revert();
424         }
425         emit TokenReleased(msg.sender,amount);
426     }
427   }
428 
429    /**
430    * @dev Checks the amount of tokens left in the allowance.
431    * @return Amount of tokens left in the allowance
432    */
433   function remainingTokens() public view returns (uint256) {
434     return token.allowance(tokenWallet, this);
435   }
436 }
437 
438 /**
439  * @title RefundVault
440  * @dev This contract is used for storing funds while a crowdsale
441  * is in progress. Supports refunding the money if crowdsale fails,
442  * and forwarding it if crowdsale is successful.
443  */
444 contract Refundable is Crowdsale {
445 
446   uint256 public available; 
447   bool public refunding = false;
448 
449   event RefundStatusUpdated();
450   event Deposited();
451   event Withdraw(uint256 _amount);
452   event Refunded(address indexed beneficiary, uint256 weiAmount);
453   
454   function deposit() onlyOwner public payable {
455     available = available.add(msg.value);
456     emit Deposited();
457   }
458 
459   function tweakRefundStatus() onlyOwner public {
460     refunding = !refunding;
461     emit RefundStatusUpdated();
462   }
463 
464   
465   function refund() public {
466     require(refunding);
467     uint256 depositedValue = deposited[msg.sender];
468     deposited[msg.sender] = 0;
469     msg.sender.transfer(depositedValue);
470     emit Refunded(msg.sender, depositedValue);
471   }
472   
473   function withDrawBack() onlyOwner public{
474       owner.transfer(this.balance);
475   }
476   
477   function Contractbalance() view external returns( uint256){
478       return this.balance;
479   }
480 }