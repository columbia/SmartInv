1 pragma solidity ^0.4.15;
2 
3 /**
4  * Pulsar token contract.
5  * Date: 2017-11-14.
6  */
7 
8 
9 contract Ownable {
10 
11   address public owner;   // The owner of the contract
12 
13   event OwnershipTransferred ( address indexed prev_owner, address indexed new_owner );
14 
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   modifier onlyOwner {
20     require(msg.sender == owner);
21     _;
22   }
23 
24   function transferOwnership (address new_owner) onlyOwner public {
25     require(new_owner != address(0));
26     OwnershipTransferred(owner, new_owner);
27     owner = new_owner;
28   }
29 
30 
31 } // Ownable
32 
33 
34 /******************************************/
35 /*       PULSAR TOKEN STARTS HERE         */
36 /******************************************/
37 
38 contract PulsarToken is Ownable {
39 
40   /******** Public constants ********/
41 
42   // Token decimal scale is the same as Ether to Wei scale = 10^18 (18 decimal digits)
43   uint public constant TOKEN_SCALE = 1 ether / 1 wei; // (10 ** 18)
44 
45   // Total amount of tokens
46   uint public constant TOTAL_SUPPLY = 34540000 * TOKEN_SCALE;
47 
48   // 2017-11-13 08:13:00 UTC = 00:13:00 PST
49   uint public constant ICO_START_TIME = 1510560780;
50 
51   // Minimum accepted contribution is 0.1 Ether
52   uint public constant MIN_ACCEPTED_VALUE = 100000000000000000 wei; // 0.1 ether
53 
54   // Minimum buyback amount of tokens
55   uint public constant MIN_BUYBACK_VALUE = 1 * TOKEN_SCALE;
56 
57   // Public identifiers of the token
58   string public constant NAME = "Pulsar";       // token name
59   string public constant SYMBOL = "PVC";        // token symbol
60 
61 
62   /**
63    * Contract state machine.                           _____________
64    *                                                  ↓             |
65    * Deployed -> ICOStarted -> ICOStopped -> BuybackEnabled -> BuybackPaused -> Destroyed.
66    */
67   enum ContractState { Deployed, ICOStarted, ICOStopped, BuybackEnabled, BuybackPaused, Destroyed }
68 
69   // Current state of the contract
70   ContractState private contractState = ContractState.Deployed;
71 
72   // Contract state change event
73   event State ( ContractState state );
74 
75   // This generates a public event on the blockchain that will notify clients
76   event Transfer ( address indexed from, address indexed to, uint value );
77 
78 
79   /******** Public variables *********/
80 
81   // This creates an array with all balances
82   mapping (address => uint) public balanceOf;
83 
84   // Reserved bounty tokens
85   uint public bountyTokens = 40000 * TOKEN_SCALE;
86 
87   // Selling price of tokens in Wei
88   uint public sellingPrice = 0;
89 
90   // Buyback price of tokens in Wei
91   uint public buybackPrice = 0;
92 
93   // Amount of Ether the contract ever received
94   uint public etherAccumulator = 0;
95 
96   // ICO start time
97   uint public icoStartTime = ICO_START_TIME;
98 
99   // Trusted (authorized) sender of tokens
100   address public trustedSender = address(0);
101 
102 
103   /******** Private variables ********/
104 
105   uint8[4] private bonuses = [ uint8(15), uint8(10), uint8(5), uint8(3) ];  // these are percents
106   uint[4]  private staging = [ 1 weeks,   2 weeks,   3 weeks,  4 weeks ];   // timeframe when the bonuses are effective
107 
108 
109   /**
110    * The constructor initializes the contract.
111    */
112   function PulsarToken() public
113   {
114     // intentionally left empty
115   }
116 
117 
118   /******** Helper functions ********/
119 
120   /* Calculate current bonus percent. */
121   function calcBonusPercent() public view returns (uint8) {
122     uint8 _bonus = 0;
123     uint _elapsed = now - icoStartTime;
124 
125     for (uint8 i = 0; i < staging.length; i++) {
126       if (_elapsed <= staging[i]) {
127           _bonus = bonuses[i];
128           break;
129       }
130     }
131     return _bonus;
132   }
133 
134   /* Add bonus to the amount, for example 200 + 15% bonus = 230. */
135   function calcAmountWithBonus(uint token_value, uint8 bonus) public view returns (uint) {
136     return  (token_value * (100 + bonus)) / 100;
137   }
138 
139   /* Convert amount in Wei to tokens. */
140   function calcEthersToTokens(uint ether_value, uint8 bonus) public view returns (uint) {
141     return calcAmountWithBonus(TOKEN_SCALE * ether_value/sellingPrice, bonus);
142   }
143 
144   /* Convert amount in tokens to Wei. */
145   function calcTokensToEthers(uint token_value) public view returns (uint) {
146       return (buybackPrice * token_value) / TOKEN_SCALE;
147   }
148 
149   /**
150    * Internal transfer of tokens, only can be called from within this contract.
151    *
152    * @param _from   Source address
153    * @param _to     Destination address
154    * @param _value  Amount of tokens (do not forget to multiply by scale 10^18)
155    */
156   function _transfer(address _from, address _to, uint _value) internal
157   {
158     require(_to != address(0x0));                       // prevent transfer to 0x0 address
159     require(_value > 0);                                // check if the value is greater than zero
160     require(balanceOf[_from] >= _value);                // check if the sender has enough tokens
161     require(balanceOf[_to] + _value > balanceOf[_to]);  // check for overflows
162 
163     balanceOf[_from]  -= _value;                        // subtract from the sender
164     balanceOf[_to]    += _value;                        // add the same to the recipient
165 
166     Transfer(_from, _to, _value);                       // fire the event
167   }
168 
169 
170   /************************* Public interface ********************************/
171 
172   /**
173    * View current state of the contract.
174    *
175    * Returns: Current state of the contract as uint8, starting from 0.
176    */
177   function getContractState() public view returns (uint8) {
178     return uint8(contractState);
179   }
180 
181   /**
182    * View current token balance of the contract.
183    *
184    * Returns: Current amount of tokens in the contract.
185    */
186   function getContractTokenBalance() public view returns (uint) {
187     return balanceOf[this];
188   }
189 
190   /**
191    * View current token balance of the given address.
192    *
193    * Returns: Current amount of tokens hold by the address
194    *
195    * @param holder_address Holder of tokens
196    */
197   function getTokenBalance(address holder_address) public view returns (uint) {
198     require(holder_address != address(0));
199     return balanceOf[holder_address];
200   }
201 
202   /**
203    * View total amount of currently distributed tokens.
204    *
205    * Returns: Total amount of distributed tokens.
206    */
207   function getDistributedTokens() public view returns (uint) {
208       return TOTAL_SUPPLY - balanceOf[this];
209   }
210 
211   /**
212    * View current Ether balance of the contract.
213    *
214    * Returns: Current amount of Wei at the contract's address.
215    */
216   function getContractEtherBalance() public view returns (uint) {
217     return this.balance;
218   }
219 
220   /**
221    * View current Ether balance of the given address.
222    *
223    * Returns: Current amount of Wei at the given address.
224    */
225   function getEtherBalance(address holder_address) public view returns (uint) {
226     require(holder_address != address(0));
227     return holder_address.balance;
228   }
229 
230 
231   /**
232    * Buy tokens for Ether.
233    * State must be only ICOStarted.
234    */
235   function invest() public payable
236   {
237     require(contractState == ContractState.ICOStarted);   // check state
238     require(now >= icoStartTime);                         // check time
239     require(msg.value >= MIN_ACCEPTED_VALUE);             // check amount of contribution
240 
241     uint8 _bonus  = calcBonusPercent();
242     uint  _tokens = calcEthersToTokens(msg.value, _bonus);
243 
244     require(balanceOf[this] >= _tokens);                  // check amount of tokens
245 
246     _transfer(this, msg.sender, _tokens);                 // tranfer tokens to the investor
247 
248     etherAccumulator += msg.value;      // finally update the counter of received Ether
249   }
250 
251 
252   // Default fallback function handles sending Ether to the contract.
253   function () public payable {
254     invest();
255   }
256 
257   /**
258    * Token holders withdraw Ether in exchange of their tokens.
259    * 
260    * @param token_value Amount of tokens being returned (do not forget to multiply by scale 10^18)
261    */
262   function buyback(uint token_value) public
263   {
264     require(contractState == ContractState.BuybackEnabled);   // check current state
265     require(buybackPrice > 0);                                // buyback price must be set
266     require(token_value >= MIN_BUYBACK_VALUE);                // minimum allowed amount of tokens
267     require(msg.sender != owner);                             // the owner can't buyback
268 
269     uint _ethers = calcTokensToEthers(token_value);
270 
271     // Check if the contract has enough ether to buyback the tokens
272     require(this.balance >= _ethers);
273 
274     // Transfer the tokens back to the contract
275     _transfer(msg.sender, this, token_value);
276 
277     // Send ether to the seller. It's important to do this last to avoid recursion attacks.
278     msg.sender.transfer(_ethers);
279   }
280 
281   /************************** Owner's interface *****************************/
282 
283   /**
284    * Set ICO start time
285    *
286    * Restricted to the owner.
287    *
288    * @param start_time New start time as number of seconds from Unix Epoch
289    */
290   function setICOStartTime(uint start_time) onlyOwner external {
291     icoStartTime = start_time;
292   }
293 
294   /**
295    * Set token selling price in Wei.
296    *
297    * Restricted to the owner.
298    *
299    * @param selling_price New selling price in Wei
300    */
301   function setSellingPrice(uint selling_price) onlyOwner public {
302     require(selling_price != 0);
303     sellingPrice = selling_price;
304   }
305 
306   /**
307    * Start selling tokens.
308    *
309    * Restricted to the owner.
310    *
311    * @param selling_price New selling price in Wei
312    */
313   function startICO(uint selling_price) onlyOwner external {
314     require(contractState == ContractState.Deployed);
315     setSellingPrice(selling_price);
316 
317     balanceOf[this] = TOTAL_SUPPLY;
318 
319     contractState = ContractState.ICOStarted;
320     State(contractState);
321   }
322 
323   /**
324    * Stop selling tokens.
325    * Restricted to the owner.
326    */
327   function stopICO() onlyOwner external {
328     require(contractState == ContractState.ICOStarted);
329 
330     contractState = ContractState.ICOStopped;
331     State(contractState);
332   }
333 
334   /**
335    * Transfer Ether from the contract to the owner.
336    * Restricted to the owner.
337    *
338    * @param ether_value Amount in Wei
339    */
340   function transferEthersToOwner(uint ether_value) onlyOwner external {
341     require(this.balance >= ether_value);
342     msg.sender.transfer(ether_value);
343   }
344 
345   /**
346    * Set the trusted sender of tokens.
347    * Pass (0) to remove the truster sender.
348    * Restricted to the owner.
349    *
350    * @param trusted_address New trusted sender
351    */
352   function setTrustedSender(address trusted_address) onlyOwner external {
353     trustedSender = trusted_address;
354   }
355 
356   /**
357    * Transfer tokens to an address.
358    * Restricted to the owner or to the trusted address.
359    *
360    * @param recipient_address Recipient address
361    * @param token_value Amount of tokens (do not forget to multiply by scale 10^18)
362    */
363   function transferTokens(address recipient_address, uint token_value) external {
364     require( (msg.sender == owner) || (msg.sender == trustedSender) );  // Restricted to the owner or to trustedSender
365     require(contractState == ContractState.ICOStarted);                 // check state
366     require(now >= icoStartTime);                                       // check time
367 
368     _transfer(this, recipient_address, token_value);
369   }
370 
371   /**
372    * Grant bounty tokens to an address.
373    * Restricted to the owner.
374    * State must be ICOStarted or ICOStopped.
375    *
376    * @param recipient_address Recipient address
377    * @param token_value Amount of tokens (do not forget to multiply by scale 10^18)
378    */
379   function grantBounty(address recipient_address, uint token_value) onlyOwner external {
380     require((contractState == ContractState.ICOStarted) || (contractState == ContractState.ICOStopped));  // check the state
381     require(bountyTokens >= token_value);  // check remaining amount of bounty tokens
382     require(now >= icoStartTime);     // check time
383 
384     _transfer(this, recipient_address, token_value);
385     bountyTokens -= token_value;
386   }
387 
388   /**
389    * Refund investment by transferring all tokens back to the contract and sending Ether to the investor.
390    *
391    * This function is a necessary measure, because maximum 99 accredited US investors are allowed 
392    * under exemptions from registration with the U.S. Securities and Exchange Commission 
393    * pursuant to Regulation D, Section 506(c) of the Securities Act of 1933, as amended (the “Securities Act”).
394    * 
395    * We will select 99 accredited US investors and refund investments to all other US accredited investors to comply with this regulation.
396    *
397    * Investors from other countries (non-US investors) will not be affected.
398    *
399    * State must be ICOStopped or BuybackPaused.
400    *
401    * Restricted to the owner.
402    *
403    * @param investor_address The address of the investor
404    * @param ether_value The amount in Wei
405    */
406   function refundInvestment(address investor_address, uint ether_value) onlyOwner external {
407     require((contractState == ContractState.ICOStopped) || (contractState == ContractState.BuybackPaused));   // check the state
408 
409     require(investor_address != owner);                   // do not refund to the owner
410     require(investor_address != address(this));           // do not refund to the contract
411     require(balanceOf[investor_address] > 0);             // investor's token balance must be greater than zero
412     require(this.balance >= ether_value);                 // the contract must have enough ether
413 
414     // Transfer the tokens back to the contract
415     _transfer(investor_address, this, balanceOf[investor_address]);
416 
417     // Send ether to the investor. It's important to do this last to avoid recursion attacks.
418     investor_address.transfer(ether_value);
419   }
420 
421   /**
422    * Set token buyback price in Wei.
423    *
424    * Restricted to the owner.
425    *
426    * @param buyback_price New buyback price in Wei
427    */
428   function setBuybackPrice(uint buyback_price) onlyOwner public {
429     require(buyback_price > 0);
430     buybackPrice = buyback_price;
431   }
432 
433   /**
434    * Enable buyback.
435    * State must be ICOStopped or BuybackPaused.
436    * Buyback can be paused with pauseBuyback().
437    *
438    * Restricted to the owner.
439    *
440    * @param buyback_price New buyback price in Wei
441    */
442   function enableBuyback(uint buyback_price) onlyOwner external {
443     require((contractState == ContractState.ICOStopped) || (contractState == ContractState.BuybackPaused));
444     setBuybackPrice(buyback_price);
445 
446     contractState = ContractState.BuybackEnabled;
447     State(contractState);
448   }
449 
450   /**
451    * Pause buyback.
452    * State must be BuybackEnabled.
453    * Buyback can be re-enabled with enableBuyback().
454    *
455    * Restricted to the owner.
456    */
457   function pauseBuyback() onlyOwner external {
458       require(contractState == ContractState.BuybackEnabled);
459 
460       contractState = ContractState.BuybackPaused;
461       State(contractState);
462   }
463 
464   /**
465    * Destroy the contract and send all Ether to the owner.
466    * The contract must be in the BuybackPaused state.
467    *
468    * Restricted to the owner.
469    */
470   function destroyContract() onlyOwner external {
471       require(contractState == ContractState.BuybackPaused);
472 
473       contractState = ContractState.Destroyed;
474       State(contractState);
475 
476       selfdestruct(owner);  // send all money to the owner and destroy the contract!
477   }
478 
479 } /* ------------------------ end of contract ---------------------- */