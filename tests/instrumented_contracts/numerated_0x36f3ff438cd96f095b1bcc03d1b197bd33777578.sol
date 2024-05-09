1 pragma solidity ^0.4.15;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/token/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) public constant returns (uint256);
25   function transferFrom(address from, address to, uint256 value) public returns (bool);
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 // File: contracts/LockableToken.sol
31 
32 contract LockableToken is ERC20 {
33     function addToTimeLockedList(address addr) external returns (bool);
34 }
35 
36 // File: zeppelin-solidity/contracts/math/SafeMath.sol
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that throw on error
41  */
42 library SafeMath {
43   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
44     uint256 c = a * b;
45     assert(a == 0 || c / a == b);
46     return c;
47   }
48 
49   function div(uint256 a, uint256 b) internal constant returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   function add(uint256 a, uint256 b) internal constant returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 // File: contracts/PricingStrategy.sol
69 
70 contract PricingStrategy {
71 
72     using SafeMath for uint;
73 
74     uint[] public rates;
75     uint[] public limits;
76 
77     function PricingStrategy(
78         uint[] _rates,
79         uint[] _limits
80     ) public
81     {
82         require(_rates.length == _limits.length);
83         rates = _rates;
84         limits = _limits;
85     }
86 
87     /** Interface declaration. */
88     function isPricingStrategy() public view returns (bool) {
89         return true;
90     }
91 
92     /** Calculate the current price for buy in amount. */
93     function calculateTokenAmount(uint weiAmount, uint weiRaised) public view returns (uint tokenAmount) {
94         if (weiAmount == 0) {
95             return 0;
96         }
97 
98         var (rate, index) = currentRate(weiRaised);
99         tokenAmount = weiAmount.mul(rate);
100 
101         // if we crossed slot border, recalculate remaining tokens according to next slot price
102         if (weiRaised.add(weiAmount) > limits[index]) {
103             uint currentSlotWei = limits[index].sub(weiRaised);
104             uint currentSlotTokens = currentSlotWei.mul(rate);
105             uint remainingWei = weiAmount.sub(currentSlotWei);
106             tokenAmount = currentSlotTokens.add(calculateTokenAmount(remainingWei, limits[index]));
107         }
108     }
109 
110     function currentRate(uint weiRaised) public view returns (uint rate, uint8 index) {
111         rate = rates[0];
112         index = 0;
113 
114         while (weiRaised >= limits[index]) {
115             rate = rates[++index];
116         }
117     }
118 
119 }
120 
121 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
122 
123 /**
124  * @title Ownable
125  * @dev The Ownable contract has an owner address, and provides basic authorization control
126  * functions, this simplifies the implementation of "user permissions".
127  */
128 contract Ownable {
129   address public owner;
130 
131 
132   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133 
134 
135   /**
136    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
137    * account.
138    */
139   function Ownable() {
140     owner = msg.sender;
141   }
142 
143 
144   /**
145    * @dev Throws if called by any account other than the owner.
146    */
147   modifier onlyOwner() {
148     require(msg.sender == owner);
149     _;
150   }
151 
152 
153   /**
154    * @dev Allows the current owner to transfer control of the contract to a newOwner.
155    * @param newOwner The address to transfer ownership to.
156    */
157   function transferOwnership(address newOwner) onlyOwner public {
158     require(newOwner != address(0));
159     OwnershipTransferred(owner, newOwner);
160     owner = newOwner;
161   }
162 
163 }
164 
165 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
166 
167 /**
168  * @title Pausable
169  * @dev Base contract which allows children to implement an emergency stop mechanism.
170  */
171 contract Pausable is Ownable {
172   event Pause();
173   event Unpause();
174 
175   bool public paused = false;
176 
177 
178   /**
179    * @dev Modifier to make a function callable only when the contract is not paused.
180    */
181   modifier whenNotPaused() {
182     require(!paused);
183     _;
184   }
185 
186   /**
187    * @dev Modifier to make a function callable only when the contract is paused.
188    */
189   modifier whenPaused() {
190     require(paused);
191     _;
192   }
193 
194   /**
195    * @dev called by the owner to pause, triggers stopped state
196    */
197   function pause() onlyOwner whenNotPaused public {
198     paused = true;
199     Pause();
200   }
201 
202   /**
203    * @dev called by the owner to unpause, returns to normal state
204    */
205   function unpause() onlyOwner whenPaused public {
206     paused = false;
207     Unpause();
208   }
209 }
210 
211 // File: zeppelin-solidity/contracts/ownership/Contactable.sol
212 
213 /**
214  * @title Contactable token
215  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
216  * contact information.
217  */
218 contract Contactable is Ownable{
219 
220     string public contactInformation;
221 
222     /**
223      * @dev Allows the owner to set a string with their contact information.
224      * @param info The contact information to attach to the contract.
225      */
226     function setContactInformation(string info) onlyOwner public {
227          contactInformation = info;
228      }
229 }
230 
231 // File: contracts/Sale.sol
232 
233 /**
234  * @title Sale
235  * @dev Sale is a contract for managing a token crowdsale.
236  * Sales have a start and end timestamps, where investors can make
237  * token purchases and the crowdsale will assign them tokens based
238  * on a token per ETH rate. Funds collected are forwarded to a wallet
239  * as they arrive.
240  */
241 contract Sale is Pausable, Contactable {
242     using SafeMath for uint;
243   
244     // The token being sold
245     LockableToken public token;
246   
247     // start and end timestamps where investments are allowed (both inclusive)
248     uint public startTime;
249     uint public endTime;
250   
251     // address where funds are collected
252     address public wallet;
253   
254     // the contract, which determine how many token units a buyer gets per wei
255     PricingStrategy public pricingStrategy;
256   
257     // amount of raised money in wei
258     uint public weiRaised;
259 
260     // amount of tokens that was sold on the crowdsale
261     uint public tokensSold;
262 
263     // maximum amount of wei in total, that can be invested
264     uint public weiMaximumGoal;
265 
266     // if weiMinimumGoal will not be reached till endTime, investors will be able to refund ETH
267     uint public weiMinimumGoal;
268 
269     // minimal amount of ether, that investor can invest
270     uint public minAmount;
271 
272     // How many distinct addresses have invested
273     uint public investorCount;
274 
275     // how much wei we have returned back to the contract after a failed crowdfund
276     uint public loadedRefund;
277 
278     // how much wei we have given back to investors
279     uint public weiRefunded;
280 
281     //How much ETH each address has invested to this crowdsale
282     mapping (address => uint) public investedAmountOf;
283 
284     // Addresses that are allowed to invest before ICO offical opens
285     mapping (address => bool) public earlyParticipantWhitelist;
286 
287     // whether a buyer bought tokens through other currencies
288     mapping (address => bool) public isExternalBuyer;
289 
290     address public admin;
291 
292     modifier onlyOwnerOrAdmin() {
293         require(msg.sender == owner || msg.sender == admin); 
294         _;
295     }
296   
297     /**
298      * event for token purchase logging
299      * @param purchaser who paid for the tokens
300      * @param beneficiary who got the tokens
301      * @param value weis paid for purchase
302      * @param tokenAmount amount of tokens purchased
303      */
304     event TokenPurchase(
305         address indexed purchaser,
306         address indexed beneficiary,
307         uint value,
308         uint tokenAmount
309     );
310 
311     // a refund was processed for an investor
312     event Refund(address investor, uint weiAmount);
313 
314     function Sale(
315         uint _startTime,
316         uint _endTime,
317         PricingStrategy _pricingStrategy,
318         LockableToken _token,
319         address _wallet,
320         uint _weiMaximumGoal,
321         uint _weiMinimumGoal,
322         uint _minAmount
323     ) {
324         require(_startTime >= now);
325         require(_endTime >= _startTime);
326         require(_pricingStrategy.isPricingStrategy());
327         require(address(_token) != 0x0);
328         require(_wallet != 0x0);
329         require(_weiMaximumGoal > 0);
330         require(_weiMinimumGoal > 0);
331 
332         startTime = _startTime;
333         endTime = _endTime;
334         pricingStrategy = _pricingStrategy;
335         token = _token;
336         wallet = _wallet;
337         weiMaximumGoal = _weiMaximumGoal;
338         weiMinimumGoal = _weiMinimumGoal;
339         minAmount = _minAmount;
340 }
341 
342     // fallback function can be used to buy tokens
343     function () external payable {
344         buyTokens(msg.sender);
345     }
346 
347     // low level token purchase function
348     function buyTokens(address beneficiary) public whenNotPaused payable returns (bool) {
349         uint weiAmount = msg.value;
350         
351         require(beneficiary != 0x0);
352         require(validPurchase(weiAmount));
353     
354         transferTokenToBuyer(beneficiary, weiAmount);
355 
356         wallet.transfer(weiAmount);
357 
358         return true;
359     }
360 
361     function transferTokenToBuyer(address beneficiary, uint weiAmount) internal {
362         if (investedAmountOf[beneficiary] == 0) {
363             // A new investor
364             investorCount++;
365         }
366 
367         // calculate token amount to be created
368         uint tokenAmount = pricingStrategy.calculateTokenAmount(weiAmount, weiRaised);
369 
370         investedAmountOf[beneficiary] = investedAmountOf[beneficiary].add(weiAmount);
371         weiRaised = weiRaised.add(weiAmount);
372         tokensSold = tokensSold.add(tokenAmount);
373     
374         token.transferFrom(owner, beneficiary, tokenAmount);
375         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
376     }
377 
378    // return true if the transaction can buy tokens
379     function validPurchase(uint weiAmount) internal view returns (bool) {
380         bool withinPeriod = (now >= startTime || earlyParticipantWhitelist[msg.sender]) && now <= endTime;
381         bool withinCap = weiRaised.add(weiAmount) <= weiMaximumGoal;
382         bool moreThenMinimal = weiAmount >= minAmount;
383 
384         return withinPeriod && withinCap && moreThenMinimal;
385     }
386 
387     // return true if crowdsale event has ended
388     function hasEnded() external view returns (bool) {
389         bool capReached = weiRaised >= weiMaximumGoal;
390         bool afterEndTime = now > endTime;
391         
392         return capReached || afterEndTime;
393     }
394 
395     // get the amount of unsold tokens allocated to this contract;
396     function getWeiLeft() external view returns (uint) {
397         return weiMaximumGoal - weiRaised;
398     }
399 
400     // return true if the crowdsale has raised enough money to be a successful.
401     function isMinimumGoalReached() public view returns (bool) {
402         return weiRaised >= weiMinimumGoal;
403     }
404     
405     /**
406      * allows to add and exclude addresses from earlyParticipantWhitelist for owner
407      * @param isWhitelisted is true for adding address into whitelist, false - to exclude
408      */
409     function editEarlyParicipantWhitelist(address addr, bool isWhitelisted) external onlyOwnerOrAdmin returns (bool) {
410         earlyParticipantWhitelist[addr] = isWhitelisted;
411         return true;
412     }
413 
414     // allows to update tokens rate for owner
415     function setPricingStrategy(PricingStrategy _pricingStrategy) external onlyOwner returns (bool) {
416         pricingStrategy = _pricingStrategy;
417         return true;
418     }
419 
420     /**
421     * Allow load refunds back on the contract for the refunding.
422     *
423     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
424     */
425     function loadRefund() external payable {
426         require(msg.value > 0);
427         require(!isMinimumGoalReached());
428         
429         loadedRefund = loadedRefund.add(msg.value);
430     }
431 
432     /**
433     * Investors can claim refund.
434     *
435     * Note that any refunds from proxy buyers should be handled separately,
436     * and not through this contract.
437     */
438     function refund() external {
439         uint256 weiValue = investedAmountOf[msg.sender];
440         
441         require(!isMinimumGoalReached() && loadedRefund > 0);
442         require(!isExternalBuyer[msg.sender]);
443         require(weiValue > 0);
444         
445         investedAmountOf[msg.sender] = 0;
446         weiRefunded = weiRefunded.add(weiValue);
447         Refund(msg.sender, weiValue);
448         msg.sender.transfer(weiValue);
449     }
450 
451     function registerPayment(address beneficiary, uint weiAmount) external onlyOwnerOrAdmin {
452         require(validPurchase(weiAmount));
453         isExternalBuyer[beneficiary] = true;
454         transferTokenToBuyer(beneficiary, weiAmount);
455     }
456 
457     function setAdmin(address adminAddress) external onlyOwner {
458         admin = adminAddress;
459     }
460 }