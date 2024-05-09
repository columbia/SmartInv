1 pragma solidity ^0.4.11;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address newOwner) onlyOwner public {
55     require(newOwner != address(0));
56     OwnershipTransferred(owner, newOwner);
57     owner = newOwner;
58   }
59 }
60 /**
61  * @title Pausable
62  * @dev Base contract which allows children to implement an emergency stop mechanism.
63  */
64 contract Pausable is Ownable {
65   event Pause();
66   event Unpause();
67   bool public paused = false;
68   /**
69    * @dev Modifier to make a function callable only when the contract is not paused.
70    */
71   modifier whenNotPaused() {
72     require(!paused);
73     _;
74   }
75   /**
76    * @dev Modifier to make a function callable only when the contract is paused.
77    */
78   modifier whenPaused() {
79     require(paused);
80     _;
81   }
82   /**
83    * @dev called by the owner to pause, triggers stopped state
84    */
85   function pause() onlyOwner whenNotPaused public {
86     paused = true;
87     Pause();
88   }
89   /**
90    * @dev called by the owner to unpause, returns to normal state
91    */
92   function unpause() onlyOwner whenPaused public {
93     paused = false;
94     Unpause();
95   }
96 }
97 /**
98  * The QuantstampSale smart contract is used for selling QuantstampToken
99  * tokens (QSP). It does so by converting ETH received into a quantity of
100  * tokens that are transferred to the contributor via the ERC20-compatible
101  * transferFrom() function.
102  */
103 contract QuantstampSale is Pausable {
104     using SafeMath for uint256;
105     // The beneficiary is the future recipient of the funds
106     address public beneficiary;
107     // The crowdsale has a funding goal, cap, deadline, and minimum contribution
108     uint public fundingCap;
109     uint public minContribution;
110     bool public fundingCapReached = false;
111     bool public saleClosed = false;
112     // Whitelist data
113     mapping(address => bool) public registry;
114     // For each user, specifies the cap (in wei) that can be contributed for each tier
115     // Tiers are filled in the order 3, 2, 1, 4
116     mapping(address => uint256) public cap1;        // 100% bonus
117     mapping(address => uint256) public cap2;        // 40% bonus
118     mapping(address => uint256) public cap3;        // 20% bonus
119     mapping(address => uint256) public cap4;        // 0% bonus
120     // Stores the amount contributed for each tier for a given address
121     mapping(address => uint256) public contributed1;
122     mapping(address => uint256) public contributed2;
123     mapping(address => uint256) public contributed3;
124     mapping(address => uint256) public contributed4;
125     // Conversion rate by tier (QSP : ETHER)
126     uint public rate1 = 10000;
127     uint public rate2 = 7000;
128     uint public rate3 = 6000;
129     uint public rate4 = 5000;
130     // Time period of sale (UNIX timestamps)
131     uint public startTime;
132     uint public endTime;
133     // Keeps track of the amount of wei raised
134     uint public amountRaised;
135     // prevent certain functions from being recursively called
136     bool private rentrancy_lock = false;
137     // The token being sold
138     // QuantstampToken public tokenReward;
139     // A map that tracks the amount of wei contributed by address
140     mapping(address => uint256) public balanceOf;
141     // A map that tracks the amount of QSP tokens that should be allocated to each address
142     mapping(address => uint256) public tokenBalanceOf;
143     // Events
144     event CapReached(address _beneficiary, uint _amountRaised);
145     event FundTransfer(address _backer, uint _amount, bool _isContribution);
146     event RegistrationStatusChanged(address target, bool isRegistered, uint c1, uint c2, uint c3, uint c4);
147     // Modifiers
148     modifier beforeDeadline()   { require (currentTime() < endTime); _; }
149     // modifier afterDeadline()    { require (currentTime() >= endTime); _; } no longer used without fundingGoal
150     modifier afterStartTime()    { require (currentTime() >= startTime); _; }
151     modifier saleNotClosed()    { require (!saleClosed); _; }
152     modifier nonReentrant() {
153         require(!rentrancy_lock);
154         rentrancy_lock = true;
155         _;
156         rentrancy_lock = false;
157     }
158     /**
159      * Constructor for a crowdsale of QuantstampToken tokens.
160      *
161      * @param ifSuccessfulSendTo            the beneficiary of the fund
162      * @param fundingCapInEthers            the cap (maximum) size of the fund
163      * @param minimumContributionInWei      minimum contribution (in wei)
164      * @param start                         the start time (UNIX timestamp)
165      * @param durationInMinutes             the duration of the crowdsale in minutes
166      */
167     function QuantstampSale(
168         address ifSuccessfulSendTo,
169         uint fundingCapInEthers,
170         uint minimumContributionInWei,
171         uint start,
172         uint durationInMinutes
173         // address addressOfTokenUsedAsReward
174     ) {
175         require(ifSuccessfulSendTo != address(0) && ifSuccessfulSendTo != address(this));
176         //require(addressOfTokenUsedAsReward != address(0) && addressOfTokenUsedAsReward != address(this));
177         require(durationInMinutes > 0);
178         beneficiary = ifSuccessfulSendTo;
179         fundingCap = fundingCapInEthers * 1 ether;
180         minContribution = minimumContributionInWei;
181         startTime = start;
182         endTime = start + (durationInMinutes * 1 minutes);
183         // tokenReward = QuantstampToken(addressOfTokenUsedAsReward);
184     }
185     /**
186      * This function is called whenever Ether is sent to the
187      * smart contract. It can only be executed when the crowdsale is
188      * not paused, not closed, and before the deadline has been reached.
189      *
190      * This function will update state variables for whether or not the
191      * funding goal or cap have been reached. It also ensures that the
192      * tokens are transferred to the sender, and that the correct
193      * number of tokens are sent according to the current rate.
194      */
195     function () payable {
196         buy();
197     }
198     function buy ()
199         payable public
200         whenNotPaused
201         beforeDeadline
202         afterStartTime
203         saleNotClosed
204         nonReentrant
205     {
206         require(msg.value >= minContribution);
207         uint amount = msg.value;
208         // ensure that the user adheres to whitelist restrictions
209         require(registry[msg.sender]);
210         uint numTokens = computeTokenAmount(msg.sender, amount);
211         assert(numTokens > 0);
212         // update the total amount raised
213         amountRaised = amountRaised.add(amount);
214         require(amountRaised <= fundingCap);
215         // update the sender's balance of wei contributed
216         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
217         // add to the token balance of the sender
218         tokenBalanceOf[msg.sender] = tokenBalanceOf[msg.sender].add(numTokens);
219         FundTransfer(msg.sender, amount, true);
220         updateFundingCap();
221     }
222     /**
223     * Computes the amount of QSP that should be issued for the given transaction.
224     * Contribution tiers are filled up in the order 3, 2, 1, 4.
225     * @param addr      The wallet address of the contributor
226     * @param amount    Amount of wei for payment
227     */
228     function computeTokenAmount(address addr, uint amount) internal
229         returns (uint){
230         require(amount > 0);
231         uint r3 = cap3[addr].sub(contributed3[addr]);
232         uint r2 = cap2[addr].sub(contributed2[addr]);
233         uint r1 = cap1[addr].sub(contributed1[addr]);
234         uint r4 = cap4[addr].sub(contributed4[addr]);
235         uint numTokens = 0;
236         // cannot contribute more than the remaining sum
237         assert(amount <= r3.add(r2).add(r1).add(r4));
238         // Compute tokens for tier 3
239         if(r3 > 0){
240             if(amount <= r3){
241                 contributed3[addr] = contributed3[addr].add(amount);
242                 return rate3.mul(amount);
243             }
244             else{
245                 numTokens = rate3.mul(r3);
246                 amount = amount.sub(r3);
247                 contributed3[addr] = cap3[addr];
248             }
249         }
250         // Compute tokens for tier 2
251         if(r2 > 0){
252             if(amount <= r2){
253                 contributed2[addr] = contributed2[addr].add(amount);
254                 return numTokens.add(rate2.mul(amount));
255             }
256             else{
257                 numTokens = numTokens.add(rate2.mul(r2));
258                 amount = amount.sub(r2);
259                 contributed2[addr] = cap2[addr];
260             }
261         }
262         // Compute tokens for tier 1
263         if(r1 > 0){
264             if(amount <= r1){
265                 contributed1[addr] = contributed1[addr].add(amount);
266                 return numTokens.add(rate1.mul(amount));
267             }
268             else{
269                 numTokens = numTokens.add(rate1.mul(r1));
270                 amount = amount.sub(r1);
271                 contributed1[addr] = cap1[addr];
272             }
273         }
274         // Compute tokens for tier 4 (overflow)
275         contributed4[addr] = contributed4[addr].add(amount);
276         return numTokens.add(rate4.mul(amount));
277     }
278     /**
279      * @dev Check if a contributor was at any point registered.
280      *
281      * @param contributor Address that will be checked.
282      */
283     function hasPreviouslyRegistered(address contributor)
284         internal
285         constant
286         onlyOwner returns (bool)
287     {
288         // if caps for this customer exist, then the customer has previously been registered
289         return (cap1[contributor].add(cap2[contributor]).add(cap3[contributor]).add(cap4[contributor])) > 0;
290     }
291     /*
292     * If the user was already registered, ensure that the new caps do not conflict previous contributions
293     *
294     * NOTE: cannot use SafeMath here, because it exceeds the local variable stack limit.
295     * Should be ok since it is onlyOwner, and conditionals should guard the subtractions from underflow.
296     */
297     function validateUpdatedRegistration(address addr, uint c1, uint c2, uint c3, uint c4)
298         internal
299         constant
300         onlyOwner returns(bool)
301     {
302         return (contributed3[addr] <= c3) && (contributed2[addr] <= c2)
303             && (contributed1[addr] <= c1) && (contributed4[addr] <= c4);
304     }
305     /**
306      * @dev Sets registration status of an address for participation.
307      *
308      * @param contributor Address that will be registered/deregistered.
309      * @param c1 The maximum amount of wei that the user can contribute in tier 1.
310      * @param c2 The maximum amount of wei that the user can contribute in tier 2.
311      * @param c3 The maximum amount of wei that the user can contribute in tier 3.
312      * @param c4 The maximum amount of wei that the user can contribute in tier 4.
313      */
314     function registerUser(address contributor, uint c1, uint c2, uint c3, uint c4)
315         public
316         onlyOwner
317     {
318         require(contributor != address(0));
319         // if the user was already registered ensure that the new caps do not contradict their current contributions
320         if(hasPreviouslyRegistered(contributor)){
321             require(validateUpdatedRegistration(contributor, c1, c2, c3, c4));
322         }
323         require(c1.add(c2).add(c3).add(c4) >= minContribution);
324         registry[contributor] = true;
325         cap1[contributor] = c1;
326         cap2[contributor] = c2;
327         cap3[contributor] = c3;
328         cap4[contributor] = c4;
329         RegistrationStatusChanged(contributor, true, c1, c2, c3, c4);
330     }
331      /**
332      * @dev Remove registration status of an address for participation.
333      *
334      * NOTE: if the user made initial contributions to the crowdsale,
335      *       this will not return the previously allotted tokens.
336      *
337      * @param contributor Address to be unregistered.
338      */
339     function deactivate(address contributor)
340         public
341         onlyOwner
342     {
343         require(registry[contributor]);
344         registry[contributor] = false;
345         RegistrationStatusChanged(contributor, false, cap1[contributor], cap2[contributor], cap3[contributor], cap4[contributor]);
346     }
347     /**
348      * @dev Re-registers an already existing contributor
349      *
350      * @param contributor Address to be unregistered.
351      */
352     function reactivate(address contributor)
353         public
354         onlyOwner
355     {
356         require(hasPreviouslyRegistered(contributor));
357         registry[contributor] = true;
358         RegistrationStatusChanged(contributor, true, cap1[contributor], cap2[contributor], cap3[contributor], cap4[contributor]);
359     }
360     /**
361      * @dev Sets registration statuses of addresses for participation.
362      * @param contributors Addresses that will be registered/deregistered.
363      * @param caps1 The maximum amount of wei that each user can contribute to cap1, in the same order as the addresses.
364      * @param caps2 The maximum amount of wei that each user can contribute to cap2, in the same order as the addresses.
365      * @param caps3 The maximum amount of wei that each user can contribute to cap3, in the same order as the addresses.
366      * @param caps4 The maximum amount of wei that each user can contribute to cap4, in the same order as the addresses.
367      */
368     function registerUsers(address[] contributors,
369                            uint[] caps1,
370                            uint[] caps2,
371                            uint[] caps3,
372                            uint[] caps4)
373         external
374         onlyOwner
375     {
376         // check that all arrays have the same length
377         require(contributors.length == caps1.length);
378         require(contributors.length == caps2.length);
379         require(contributors.length == caps3.length);
380         require(contributors.length == caps4.length);
381         for (uint i = 0; i < contributors.length; i++) {
382             registerUser(contributors[i], caps1[i], caps2[i], caps3[i], caps4[i]);
383         }
384     }
385     /**
386      * The owner can terminate the crowdsale at any time.
387      */
388     function terminate() external onlyOwner {
389         saleClosed = true;
390     }
391     /**
392      * The owner can allocate the specified amount of tokens from the
393      * crowdsale allowance to the recipient addresses.
394      *
395      * NOTE: be extremely careful to get the amounts correct, which
396      * are in units of wei and mini-QSP. Every digit counts.
397      *
398      * @param addrs          the recipient addresses
399      * @param weiAmounts     the amounts contributed in wei
400      * @param miniQspAmounts the amounts of tokens transferred in mini-QSP
401      */
402     function ownerAllocateTokensForList(address[] addrs, uint[] weiAmounts, uint[] miniQspAmounts)
403             external onlyOwner
404     {
405         require(addrs.length == weiAmounts.length);
406         require(addrs.length == miniQspAmounts.length);
407         for(uint i = 0; i < addrs.length; i++){
408             ownerAllocateTokens(addrs[i], weiAmounts[i], miniQspAmounts[i]);
409         }
410     }
411     /**
412      *
413      * The owner can allocate the specified amount of tokens from the
414      * crowdsale allowance to the recipient (_to).
415      *
416      *
417      *
418      * NOTE: be extremely careful to get the amounts correct, which
419      * are in units of wei and mini-QSP. Every digit counts.
420      *
421      * @param _to            the recipient of the tokens
422      * @param amountWei     the amount contributed in wei
423      * @param amountMiniQsp the amount of tokens transferred in mini-QSP
424      */
425     function ownerAllocateTokens(address _to, uint amountWei, uint amountMiniQsp)
426             onlyOwner nonReentrant
427     {
428         // don't allocate tokens for the admin
429         // require(tokenReward.adminAddr() != _to);
430         amountRaised = amountRaised.add(amountWei);
431         require(amountRaised <= fundingCap);
432         tokenBalanceOf[_to] = tokenBalanceOf[_to].add(amountMiniQsp);
433         balanceOf[_to] = balanceOf[_to].add(amountWei);
434         FundTransfer(_to, amountWei, true);
435         updateFundingCap();
436     }
437     /**
438      * The owner can call this function to withdraw the funds that
439      * have been sent to this contract for the crowdsale subject to
440      * the funding goal having been reached. The funds will be sent
441      * to the beneficiary specified when the crowdsale was created.
442      */
443     function ownerSafeWithdrawal() external onlyOwner nonReentrant {
444         uint balanceToSend = this.balance;
445         beneficiary.transfer(balanceToSend);
446         FundTransfer(beneficiary, balanceToSend, false);
447     }
448     /**
449      * Checks if the funding cap has been reached. If it has, then
450      * the CapReached event is triggered.
451      */
452     function updateFundingCap() internal {
453         assert (amountRaised <= fundingCap);
454         if (amountRaised == fundingCap) {
455             // Check if the funding cap has been reached
456             fundingCapReached = true;
457             saleClosed = true;
458             CapReached(beneficiary, amountRaised);
459         }
460     }
461     /**
462      * Returns the current time.
463      * Useful to abstract calls to "now" for tests.
464     */
465     function currentTime() constant returns (uint _currentTime) {
466         return now;
467     }
468 }