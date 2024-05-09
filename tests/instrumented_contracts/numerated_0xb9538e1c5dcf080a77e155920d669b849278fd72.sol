1 pragma solidity 0.4.15;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract Pausable is Ownable {
41   event Pause();
42   event Unpause();
43 
44   bool public paused = false;
45 
46 
47   /**
48    * @dev Modifier to make a function callable only when the contract is not paused.
49    */
50   modifier whenNotPaused() {
51     require(!paused);
52     _;
53   }
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is paused.
57    */
58   modifier whenPaused() {
59     require(paused);
60     _;
61   }
62 
63   /**
64    * @dev called by the owner to pause, triggers stopped state
65    */
66   function pause() onlyOwner whenNotPaused public {
67     paused = true;
68     Pause();
69   }
70 
71   /**
72    * @dev called by the owner to unpause, returns to normal state
73    */
74   function unpause() onlyOwner whenPaused public {
75     paused = false;
76     Unpause();
77   }
78 }
79 
80 
81 contract Contactable is Ownable{
82 
83     string public contactInformation;
84 
85     /**
86      * @dev Allows the owner to set a string with their contact information.
87      * @param info The contact information to attach to the contract.
88      */
89     function setContactInformation(string info) onlyOwner public {
90          contactInformation = info;
91      }
92 }
93 
94 
95 
96 /**
97  * @title SafeMath
98  * @dev Math operations with safety checks that throw on error
99  */
100 library SafeMath {
101   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
102     uint256 c = a * b;
103     assert(a == 0 || c / a == b);
104     return c;
105   }
106 
107   function div(uint256 a, uint256 b) internal constant returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   function add(uint256 a, uint256 b) internal constant returns (uint256) {
120     uint256 c = a + b;
121     assert(c >= a);
122     return c;
123   }
124 }
125 
126 contract ERC20Basic {
127   uint256 public totalSupply;
128   function balanceOf(address who) public constant returns (uint256);
129   function transfer(address to, uint256 value) public returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender) public constant returns (uint256);
135   function transferFrom(address from, address to, uint256 value) public returns (bool);
136   function approve(address spender, uint256 value) public returns (bool);
137   event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 contract LockableToken is ERC20 {
141     function addToTimeLockedList(address addr) external returns (bool);
142 }
143 
144 contract PricingStrategy {
145 
146     using SafeMath for uint;
147 
148     uint[6] public limits;
149     uint[6] public rates;
150 
151     function PricingStrategy(
152         uint[6] _limits,
153         uint[6] _rates
154     ) public 
155     {
156         require(_limits.length == _rates.length);
157         
158         limits = _limits;
159         rates = _rates;
160     }
161 
162     /** Interface declaration. */
163     function isPricingStrategy() public constant returns (bool) {
164         return true;
165     }
166 
167     /** Calculate the current price for buy in amount. */
168     function calculateTokenAmount(uint weiAmount, uint tokensSold) public constant returns (uint tokenAmount) {
169         uint rate = 0;
170 
171         for (uint8 i = 0; i < limits.length; i++) {
172             if (tokensSold >= limits[i]) {
173                 rate = rates[i];
174             }
175         }
176 
177         return weiAmount.mul(rate);
178     }
179 }
180 
181 
182 /**
183  * @title Preico
184  * @dev Preico is a contract for managing a token crowdsale.
185  * Preicos have a start and end timestamps, where investors can make
186  * token purchases and the crowdsale will assign them tokens based
187  * on a token per ETH rate. Funds collected are forwarded to a wallet
188  * as they arrive.
189  */
190 contract Preico is Pausable, Contactable {
191     using SafeMath for uint;
192   
193     // The token being sold
194     LockableToken public token;
195   
196     // start and end timestamps where investments are allowed (both inclusive)
197     uint public startTime;
198     uint public endTime;
199   
200     // address where funds are collected
201     address public wallet;
202   
203     // the contract, which determine how many token units a buyer gets per wei
204     PricingStrategy public pricingStrategy;
205   
206     // amount of raised money in wei
207     uint public weiRaised;
208 
209     // amount of tokens that was sold on the crowdsale
210     uint public tokensSold;
211 
212     // maximum amount of wei in total, that can be invested
213     uint public weiMaximumGoal;
214 
215     // if weiMinimumGoal will not be reached till endTime, investors will be able to refund ETH
216     uint public weiMinimumGoal;
217 
218     // How many distinct addresses have invested
219     uint public investorCount;
220 
221     // how much wei we have returned back to the contract after a failed crowdfund
222     uint public loadedRefund;
223 
224     // how much wei we have given back to investors
225     uint public weiRefunded;
226 
227     //How much ETH each address has invested to this crowdsale
228     mapping (address => uint) public investedAmountOf;
229 
230     // Addresses that are allowed to invest before ICO offical opens
231     mapping (address => bool) public earlyParticipantWhitelist;
232   
233     /**
234      * event for token purchase logging
235      * @param purchaser who paid for the tokens
236      * @param beneficiary who got the tokens
237      * @param value weis paid for purchase
238      * @param tokenAmount amount of tokens purchased
239      */
240     event TokenPurchase(
241         address indexed purchaser,
242         address indexed beneficiary,
243         uint value,
244         uint tokenAmount
245     );
246 
247     // a refund was processed for an investor
248     event Refund(address investor, uint weiAmount);
249 
250     function Preico(
251         uint _startTime,
252         uint _endTime,
253         PricingStrategy _pricingStrategy,
254         LockableToken _token,
255         address _wallet,
256         uint _weiMaximumGoal,
257         uint _weiMinimumGoal,
258         uint _tokensSold
259     ) {
260         require(_startTime >= now);
261         require(_endTime >= _startTime);
262         require(_pricingStrategy.isPricingStrategy());
263         require(address(_token) != 0x0);
264         require(_wallet != 0x0);
265         require(_weiMaximumGoal > 0);
266         require(_weiMinimumGoal > 0);
267 
268         startTime = _startTime;
269         endTime = _endTime;
270         pricingStrategy = _pricingStrategy;
271         token = _token;
272         wallet = _wallet;
273         weiMaximumGoal = _weiMaximumGoal;
274         weiMinimumGoal = _weiMinimumGoal;
275         tokensSold = _tokensSold;
276 }
277 
278     // fallback function can be used to buy tokens
279     function () external payable {
280         buyTokens(msg.sender);
281     }
282 
283     // low level token purchase function
284     function buyTokens(address beneficiary) public whenNotPaused payable returns (bool) {
285         require(beneficiary != 0x0);
286         require(validPurchase());
287     
288         uint weiAmount = msg.value;
289     
290         // calculate token amount to be created
291         uint tokenAmount = pricingStrategy.calculateTokenAmount(weiAmount, tokensSold);
292     
293         // update state
294         if (investedAmountOf[beneficiary] == 0) {
295             // A new investor
296             investorCount++;
297         }
298         investedAmountOf[beneficiary] = investedAmountOf[beneficiary].add(weiAmount);
299         weiRaised = weiRaised.add(weiAmount);
300         tokensSold = tokensSold.add(tokenAmount);
301     
302         token.transferFrom(owner, beneficiary, tokenAmount);
303         TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
304 
305         wallet.transfer(msg.value);
306 
307         return true;
308     }
309 
310     // return true if the transaction can buy tokens
311     function validPurchase() internal constant returns (bool) {
312         bool withinPeriod = (now >= startTime || earlyParticipantWhitelist[msg.sender]) && now <= endTime;
313         bool nonZeroPurchase = msg.value != 0;
314         bool withinCap = weiRaised.add(msg.value) <= weiMaximumGoal;
315 
316         return withinPeriod && nonZeroPurchase && withinCap;
317     }
318 
319     // return true if crowdsale event has ended
320     function hasEnded() external constant returns (bool) {
321         bool capReached = weiRaised >= weiMaximumGoal;
322         bool afterEndTime = now > endTime;
323         
324         return capReached || afterEndTime;
325     }
326 
327     // get the amount of unsold tokens allocated to this contract;
328     function getWeiLeft() external constant returns (uint) {
329         return weiMaximumGoal - weiRaised;
330     }
331 
332     // return true if the crowdsale has raised enough money to be a successful.
333     function isMinimumGoalReached() public constant returns (bool) {
334         return weiRaised >= weiMinimumGoal;
335     }
336     
337     /**
338      * allows to add and exclude addresses from earlyParticipantWhitelist for owner
339      * @param isWhitelisted is true for adding address into whitelist, false - to exclude
340      */
341     function editEarlyParicipantWhitelist(address addr, bool isWhitelisted) external onlyOwner returns (bool) {
342         earlyParticipantWhitelist[addr] = isWhitelisted;
343         return true;
344     }
345 
346     // allows to update tokens rate for owner
347     function setPricingStrategy(PricingStrategy _pricingStrategy) external onlyOwner returns (bool) {
348         pricingStrategy = _pricingStrategy;
349         return true;
350     }
351 
352     /**
353     * Allow load refunds back on the contract for the refunding.
354     *
355     * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
356     */
357     function loadRefund() external payable {
358         require(msg.value > 0);
359         require(!isMinimumGoalReached());
360         
361         loadedRefund = loadedRefund.add(msg.value);
362     }
363 
364     /**
365     * Investors can claim refund.
366     *
367     * Note that any refunds from proxy buyers should be handled separately,
368     * and not through this contract.
369     */
370     function refund() external {
371         require(!isMinimumGoalReached() && loadedRefund > 0);
372         uint256 weiValue = investedAmountOf[msg.sender];
373         require(weiValue > 0);
374         
375         investedAmountOf[msg.sender] = 0;
376         weiRefunded = weiRefunded.add(weiValue);
377         Refund(msg.sender, weiValue);
378         msg.sender.transfer(weiValue);
379     }
380 }