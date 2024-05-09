1 pragma solidity 0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
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
50   function Ownable() {
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
76 /**
77  * @title Pausable
78  * @dev Base contract which allows children to implement an emergency stop mechanism.
79  */
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     Unpause();
117   }
118 }
119 
120 /**
121  * @title Contactable token
122  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
123  * contact information.
124  */
125 contract Contactable is Ownable{
126 
127     string public contactInformation;
128 
129     /**
130      * @dev Allows the owner to set a string with their contact information.
131      * @param info The contact information to attach to the contract.
132      */
133     function setContactInformation(string info) onlyOwner public {
134          contactInformation = info;
135      }
136 }
137 
138 /**
139  * @title ERC20Basic
140  * @dev Simpler version of ERC20 interface
141  * @dev see https://github.com/ethereum/EIPs/issues/179
142  */
143 contract ERC20Basic {
144   uint256 public totalSupply;
145   function balanceOf(address who) public constant returns (uint256);
146   function transfer(address to, uint256 value) public returns (bool);
147   event Transfer(address indexed from, address indexed to, uint256 value);
148 }
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender) public constant returns (uint256);
156   function transferFrom(address from, address to, uint256 value) public returns (bool);
157   function approve(address spender, uint256 value) public returns (bool);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 contract LockableToken is ERC20 {
162     function addToTimeLockedList(address addr) external returns (bool);
163 }
164 
165 contract PricingStrategy {
166 
167     using SafeMath for uint;
168 
169     uint[6] public limits;
170     uint[6] public rates;
171 
172     function PricingStrategy(
173         uint[6] _limits,
174         uint[6] _rates
175     ) public 
176     {
177         require(_limits.length == _rates.length);
178         
179         limits = _limits;
180         rates = _rates;
181     }
182 
183     /** Interface declaration. */
184     function isPricingStrategy() public constant returns (bool) {
185         return true;
186     }
187 
188     /** Calculate the current price for buy in amount. */
189     function calculateTokenAmount(uint weiAmount, uint tokensSold) public constant returns (uint tokenAmount) {
190         uint rate = 0;
191 
192         for (uint8 i = 0; i < limits.length; i++) {
193             if (tokensSold >= limits[i]) {
194                 rate = rates[i];
195             }
196         }
197 
198         return weiAmount.mul(rate);
199     }
200 }
201 
202 /**
203  * @title Presale
204  * @dev Presale is a contract for managing a token crowdsale.
205  * Presales have a start and end timestamps, where investors can make
206  * token purchases and the crowdsale will assign them tokens based
207  * on a token per ETH rate. Funds collected are forwarded to a wallet
208  * as they arrive.
209  */
210 contract Presale is Pausable, Contactable {
211     using SafeMath for uint;
212   
213     // The token being sold
214     LockableToken public token;
215   
216     // start and end timestamps where investments are allowed (both inclusive)
217     uint public startTime;
218     uint public endTime;
219   
220     // address where funds are collected
221     address public wallet;
222   
223     // the contract, which determine how many token units a buyer gets per wei
224     PricingStrategy public pricingStrategy;
225   
226     // amount of raised money in wei
227     uint public weiRaised;
228 
229     // amount of tokens that was sold on the crowdsale
230     uint public tokensSold;
231 
232     // maximum amount of wei in total, that can be invested
233     uint public weiMaximumGoal;
234 
235     // if weiMinimumGoal will not be reached till endTime, investors will be able to refund ETH
236     uint public weiMinimumGoal;
237 
238     // minimal amount of ether, that investor can invest
239     uint public minAmount;
240 
241     // How many distinct addresses have invested
242     uint public investorCount;
243 
244     // how much wei we have returned back to the contract after a failed crowdfund
245     uint public loadedRefund;
246 
247     // how much wei we have given back to investors
248     uint public weiRefunded;
249 
250     //How much ETH each address has invested to this crowdsale
251     mapping (address => uint) public investedAmountOf;
252 
253     // Addresses that are allowed to invest before ICO offical opens
254     mapping (address => bool) public earlyParticipantWhitelist;
255   
256     /**
257      * event for token purchase logging
258      * @param purchaser who paid for the tokens
259      * @param beneficiary who got the tokens
260      * @param value weis paid for purchase
261      * @param tokenAmount amount of tokens purchased
262      */
263     event TokenPurchase(
264         address indexed purchaser,
265         address indexed beneficiary,
266         uint value,
267         uint tokenAmount
268     );
269 
270     // a refund was processed for an investor
271     event Refund(address investor, uint weiAmount);
272 
273     function Presale(
274         uint _startTime,
275         uint _endTime,
276         PricingStrategy _pricingStrategy,
277         LockableToken _token,
278         address _wallet,
279         uint _weiMaximumGoal,
280         uint _weiMinimumGoal,
281         uint _minAmount
282     ) {
283         require(_startTime >= now);
284         require(_endTime >= _startTime);
285         require(_pricingStrategy.isPricingStrategy());
286         require(address(_token) != 0x0);
287         require(_wallet != 0x0);
288         require(_weiMaximumGoal > 0);
289         require(_weiMinimumGoal > 0);
290 
291         startTime = _startTime;
292         endTime = _endTime;
293         pricingStrategy = _pricingStrategy;
294         token = _token;
295         wallet = _wallet;
296         weiMaximumGoal = _weiMaximumGoal;
297         weiMinimumGoal = _weiMinimumGoal;
298         minAmount = _minAmount;
299 }
300 
301     // fallback function can be used to buy tokens
302     function () external payable {
303         buyTokens(msg.sender);
304     }
305 
306     // low level token purchase function
307     function buyTokens(address beneficiary) public whenNotPaused payable returns (bool) {
308         require(beneficiary != 0x0);
309         require(validPurchase());
310     
311         uint weiAmount = msg.value;
312     
313         // calculate token amount to be created
314         uint tokenAmount = pricingStrategy.calculateTokenAmount(weiAmount, tokensSold);
315     
316         // update state
317         if (investedAmountOf[beneficiary] == 0) {
318             // A new investor
319             investorCount++;
320         }
321         investedAmountOf[beneficiary] = investedAmountOf[beneficiary].add(weiAmount);
322         weiRaised = weiRaised.add(weiAmount);
323         tokensSold = tokensSold.add(tokenAmount);
324     
325         token.transferFrom(owner, beneficiary, tokenAmount);
326         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
327         token.addToTimeLockedList(beneficiary);
328 
329         wallet.transfer(msg.value);
330 
331         return true;
332     }
333 
334     // return true if the transaction can buy tokens
335     function validPurchase() internal constant returns (bool) {
336         bool withinPeriod = (now >= startTime || earlyParticipantWhitelist[msg.sender]) && now <= endTime;
337         bool nonZeroPurchase = msg.value != 0;
338         bool withinCap = weiRaised.add(msg.value) <= weiMaximumGoal;
339         bool moreThenMinimal = msg.value >= minAmount;
340 
341         return withinPeriod && nonZeroPurchase && withinCap && moreThenMinimal;
342     }
343 
344     // return true if crowdsale event has ended
345     function hasEnded() external constant returns (bool) {
346         bool capReached = weiRaised >= weiMaximumGoal;
347         bool afterEndTime = now > endTime;
348         
349         return capReached || afterEndTime;
350     }
351 
352     // get the amount of unsold tokens allocated to this contract;
353     function getWeiLeft() external constant returns (uint) {
354         return weiMaximumGoal - weiRaised;
355     }
356 
357     // return true if the crowdsale has raised enough money to be a successful.
358     function isMinimumGoalReached() public constant returns (bool) {
359         return weiRaised >= weiMinimumGoal;
360     }
361     
362     /**
363      * allows to add and exclude addresses from earlyParticipantWhitelist for owner
364      * @param isWhitelisted is true for adding address into whitelist, false - to exclude
365      */
366     function editEarlyParicipantWhitelist(address addr, bool isWhitelisted) external onlyOwner returns (bool) {
367         earlyParticipantWhitelist[addr] = isWhitelisted;
368         return true;
369     }
370 
371     // allows to update tokens rate for owner
372     function setPricingStrategy(PricingStrategy _pricingStrategy) external onlyOwner returns (bool) {
373         pricingStrategy = _pricingStrategy;
374         return true;
375     }
376 
377     /**
378     * Allow load refunds back on the contract for the refunding.
379     *
380     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
381     */
382     function loadRefund() external payable {
383         require(msg.value > 0);
384         require(!isMinimumGoalReached());
385         
386         loadedRefund = loadedRefund.add(msg.value);
387     }
388 
389     /**
390     * Investors can claim refund.
391     *
392     * Note that any refunds from proxy buyers should be handled separately,
393     * and not through this contract.
394     */
395     function refund() external {
396         require(!isMinimumGoalReached() && loadedRefund > 0);
397         uint256 weiValue = investedAmountOf[msg.sender];
398         require(weiValue > 0);
399         
400         investedAmountOf[msg.sender] = 0;
401         weiRefunded = weiRefunded.add(weiValue);
402         Refund(msg.sender, weiValue);
403         msg.sender.transfer(weiValue);
404     }
405 }