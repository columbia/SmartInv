1 pragma solidity ^0.4.15;
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
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) onlyOwner {
66     require(newOwner != address(0));
67     owner = newOwner;
68   }
69 
70 }
71 
72 
73 /**
74  * @title Claimable
75  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
76  * This allows the new owner to accept the transfer.
77  */
78 contract Claimable is Ownable {
79   address public pendingOwner;
80 
81   /**
82    * @dev Modifier throws if called by any account other than the pendingOwner.
83    */
84   modifier onlyPendingOwner() {
85     require(msg.sender == pendingOwner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to set the pendingOwner address.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) onlyOwner {
94     pendingOwner = newOwner;
95   }
96 
97   /**
98    * @dev Allows the pendingOwner address to finalize the transfer.
99    */
100   function claimOwnership() onlyPendingOwner {
101     owner = pendingOwner;
102     pendingOwner = 0x0;
103   }
104 }
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   uint256 public totalSupply;
113   function balanceOf(address who) constant returns (uint256);
114   function transfer(address to, uint256 value) returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 is ERC20Basic {
125   function allowance(address owner, address spender) constant returns (uint256);
126   function transferFrom(address from, address to, uint256 value) returns (bool);
127   function approve(address spender, uint256 value) returns (bool);
128   event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) returns (bool) {
147     require(_to != address(0));
148 
149     // SafeMath.sub will throw if there is not enough balance.
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) constant returns (uint256 balance) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
187     require(_to != address(0));
188 
189     var _allowance = allowed[_from][msg.sender];
190 
191     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
192     // require (_value <= _allowance);
193 
194     balances[_from] = balances[_from].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     allowed[_from][msg.sender] = _allowance.sub(_value);
197     Transfer(_from, _to, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) returns (bool) {
207 
208     // To change the approve amount you first have to reduce the addresses`
209     //  allowance to zero by calling `approve(_spender, 0)` if it is not
210     //  already 0 to mitigate the race condition described here:
211     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
213 
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifying the amount of tokens still available for the spender.
224    */
225   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * approve should be called when allowed[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    */
235   function increaseApproval (address _spender, uint _addedValue)
236     returns (bool success) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   function decreaseApproval (address _spender, uint _subtractedValue)
243     returns (bool success) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 
257 /**
258  * @title Mintable token
259  * @dev Simple ERC20 Token example, with mintable token creation
260  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
261  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
262  */
263 
264 contract MintableToken is StandardToken, Ownable {
265   event Mint(address indexed to, uint256 amount);
266   event MintFinished();
267 
268   bool public mintingFinished = false;
269 
270 
271   modifier canMint() {
272     require(!mintingFinished);
273     _;
274   }
275 
276   /**
277    * @dev Function to mint tokens
278    * @param _to The address that will receive the minted tokens.
279    * @param _amount The amount of tokens to mint.
280    * @return A boolean that indicates if the operation was successful.
281    */
282   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
283     totalSupply = totalSupply.add(_amount);
284     balances[_to] = balances[_to].add(_amount);
285     Mint(_to, _amount);
286     Transfer(0x0, _to, _amount);
287     return true;
288   }
289 
290   /**
291    * @dev Function to stop minting new tokens.
292    * @return True if the operation was successful.
293    */
294   function finishMinting() onlyOwner returns (bool) {
295     mintingFinished = true;
296     MintFinished();
297     return true;
298   }
299 }
300 
301 /*
302 * Horizon State Decision Token Contract
303 *
304 * Version 0.9
305 *
306 * Author Nimo Naamani
307 *
308 * This smart contract code is Copyright 2017 Horizon State (https://Horizonstate.com)
309 *
310 * Licensed under the Apache License, version 2.0: http://www.apache.org/licenses/LICENSE-2.0
311 *
312 * @title Horizon State Token
313 * @dev ERC20 Decision Token (HST)
314 * @author Nimo Naamani
315 *
316 * HST tokens have 18 decimal places. The smallest meaningful (and transferable)
317 * unit is therefore 0.000000000000000001 HST. This unit is called a 'danni'.
318 *
319 * 1 HST = 1 * 10**18 = 1000000000000000000 dannis.
320 *
321 * Maximum total HST supply is 1 Billion.
322 * This is equivalent to 1000000000 * 10**18 = 1e27 dannis.
323 *
324 * HST are mintable on demand (as they are being purchased), which means that
325 * 1 Billion is the maximum.
326 */
327 
328 // @title The Horizon State Decision Token (HST)
329 contract DecisionToken is MintableToken, Claimable {
330 
331   using SafeMath for uint256;
332 
333   // Name to appear in ERC20 wallets
334   string public constant name = "Decision Token";
335 
336   // Symbol for the Decision Token to appear in ERC20 wallets
337   string public constant symbol = "HST";
338 
339   // Version of the source contract
340   string public constant version = "1.0";
341 
342   // Number of decimals for token display
343   uint8 public constant decimals = 18;
344 
345   // Release timestamp. As part of the contract, tokens can only be transfered
346   // 10 days after this trigger is set
347   uint256 public triggerTime = 0;
348 
349   // @title modifier to allow actions only when the token can be released
350   modifier onlyWhenReleased() {
351     require(now >= triggerTime);
352     _;
353   }
354 
355 
356   // @dev Constructor for the DecisionToken.
357   // Initialise the trigger (the sale contract will init this to the expected end time)
358   function DecisionToken() MintableToken() {
359     owner = msg.sender;
360   }
361 
362   // @title Transfer tokens.
363   // @dev This contract overrides the transfer() function to only work when released
364   function transfer(address _to, uint256 _value) onlyWhenReleased returns (bool) {
365     return super.transfer(_to, _value);
366   }
367 
368   // @title Allow transfers from
369   // @dev This contract overrides the transferFrom() function to only work when released
370   function transferFrom(address _from, address _to, uint256 _value) onlyWhenReleased returns (bool) {
371     return super.transferFrom(_from, _to, _value);
372   }
373 
374   // @title finish minting of the token.
375   // @dev This contract overrides the finishMinting function to trigger the token lock countdown
376   function finishMinting() onlyOwner returns (bool) {
377     require(triggerTime==0);
378     triggerTime = now.add(10 days);
379     return super.finishMinting();
380   }
381 }
382 
383 /**
384 * Horizon State Token Sale Contract
385 *
386 * Version 0.9
387 *
388 * @author Nimo Naamani
389 *
390 * This smart contract code is Copyright 2017 Horizon State (https://Horizonstate.com)
391 *
392 * Licensed under the Apache License, version 2.0: http://www.apache.org/licenses/LICENSE-2.0
393 *
394 */
395 
396 // @title The DC Token Sale contract
397 // @dev A crowdsale contract with stages of tokens-per-eth based on time elapsed
398 // Capped by maximum number of tokens; Time constrained
399 contract DecisionTokenSale is Claimable {
400   using SafeMath for uint256;
401 
402   // Start timestamp where investments are open to the public.
403   // Before this timestamp - only whitelisted addresses allowed to buy.
404   uint256 public startTime;
405 
406   // End time. investments can only go up to this timestamp.
407   // Note that the sale can end before that, if the token cap is reached.
408   uint256 public endTime;
409 
410   // Presale (whitelist only) buyers receive this many tokens per ETH
411   uint256 public constant presaleTokenRate = 3750;
412 
413   // 1st day buyers receive this many tokens per ETH
414   uint256 public constant earlyBirdTokenRate = 3500;
415 
416   // Day 2-8 buyers receive this many tokens per ETH
417   uint256 public constant secondStageTokenRate = 3250;
418 
419   // Day 9-16 buyers receive this many tokens per ETH
420   uint256 public constant thirdStageTokenRate = 3000;
421 
422   // Maximum total number of tokens ever created, taking into account 18 decimals.
423   uint256 public constant tokenCap =  10**9 * 10**18;
424 
425   // Initial HorizonState allocation (reserve), taking into account 18 decimals.
426   uint256 public constant tokenReserve = 4 * (10**8) * 10**18;
427 
428   // The Decision Token that is sold with this token sale
429   DecisionToken public token;
430 
431   // The address where the funds are kept
432   address public wallet;
433 
434   // Holds the addresses that are whitelisted to participate in the presale.
435   // Sales to these addresses are allowed before saleStart
436   mapping (address => bool) whiteListedForPresale;
437 
438   // @title Event for token purchase logging
439   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
440 
441   // @title Event to log user added to whitelist
442   event LogUserAddedToWhiteList(address indexed user);
443 
444   //@title Event to log user removed from whitelist
445   event LogUserUserRemovedFromWhiteList(address indexed user);
446 
447 
448   // @title Constructor
449   // @param _startTime: A timestamp for when the sale is to start.
450   // @param _wallet - The wallet where the token sale proceeds are to be stored
451   function DecisionTokenSale(uint256 _startTime, address _wallet) {
452     require(_startTime >= now);
453     require(_wallet != 0x0);
454     startTime = _startTime;
455     endTime = startTime.add(14 days);
456     wallet = _wallet;
457 
458     // Create the token contract itself.
459     token = createTokenContract();
460 
461     // Mint the reserve tokens to the owner of the sale contract.
462     token.mint(owner, tokenReserve);
463   }
464 
465   // @title Create the token contract from this sale
466   // @dev Creates the contract for token to be sold.
467   function createTokenContract() internal returns (DecisionToken) {
468     return new DecisionToken();
469   }
470 
471   // @title Buy Decision Tokens
472   // @dev Use this function to buy tokens through the sale
473   function buyTokens() payable {
474     require(msg.sender != 0x0);
475     require(msg.value != 0);
476     require(whiteListedForPresale[msg.sender] || now >= startTime);
477     require(!hasEnded());
478 
479     // Calculate token amount to be created
480     uint256 tokens = calculateTokenAmount(msg.value);
481 
482     if (token.totalSupply().add(tokens) > tokenCap) {
483       revert();
484     }
485 
486     // Add the new tokens to the beneficiary
487     token.mint(msg.sender, tokens);
488 
489     // Notify that a token purchase was performed
490     TokenPurchase(msg.sender, msg.value, tokens);
491 
492     // Put the funds in the token sale wallet
493     wallet.transfer(msg.value);
494   }
495 
496   // @dev This is fallback function can be used to buy tokens
497   function () payable {
498     buyTokens();
499   }
500 
501   // @title Calculate how many tokens per Ether
502   // The token sale has different rates based on time of purchase, as per the token
503   // sale whitepaper and Horizon State's Token Sale page.
504   // Presale:  : 3750 tokens per Ether
505   // Day 1     : 3500 tokens per Ether
506   // Days 2-8  : 3250 tokens per Ether
507   // Days 9-16 : 3000 tokens per Ether
508   //
509   // A note for calculation: As the number of decimals on the token is 18, which
510   // is identical to the wei per eth - the calculation performed here can use the
511   // number of tokens per ETH with no further modification.
512   //
513   // @param _weiAmount : How much wei the buyer wants to spend on tokens
514   // @return the number of tokens for this purchase.
515   function calculateTokenAmount(uint256 _weiAmount) internal constant returns (uint256) {
516     if (now >= startTime + 8 days) {
517       return _weiAmount.mul(thirdStageTokenRate);
518     }
519     if (now >= startTime + 1 days) {
520       return _weiAmount.mul(secondStageTokenRate);
521     }
522     if (now >= startTime) {
523       return _weiAmount.mul(earlyBirdTokenRate);
524     }
525     return _weiAmount.mul(presaleTokenRate);
526   }
527 
528   // @title Check whether this sale has ended.
529   // @dev This is a utility function to help consumers figure out whether the sale
530   // has already ended.
531   // The sale is considered done when the token's minting finished, or when the current
532   // time has passed the sale's end time
533   // @return true if crowdsale event has ended
534   function hasEnded() public constant returns (bool) {
535     return now > endTime;
536   }
537 
538   // @title White list a buyer for the presale.
539   // @dev Allow the owner of this contract to whitelist a buyer.
540   // Whitelisted buyers may buy in the presale, i.e before the sale starts.
541   // @param _buyer : The buyer address to whitelist
542   function whiteListAddress(address _buyer) onlyOwner {
543     require(_buyer != 0x0);
544     whiteListedForPresale[_buyer] = true;
545     LogUserAddedToWhiteList(_buyer);
546   }
547 
548   // @title Whitelist an list of buyers for the presale
549   // @dev Allow the owner of this contract to whitelist multiple buyers in batch.
550   // Whitelisted buyers may buy in the presale, i.e before the sale starts.
551   // @param _buyers : The buyer addresses to whitelist
552   function addWhiteListedAddressesInBatch(address[] _buyers) onlyOwner {
553     require(_buyers.length < 1000);
554     for (uint i = 0; i < _buyers.length; i++) {
555       whiteListAddress(_buyers[i]);
556     }
557   }
558 
559   // @title Remove a buyer from the whitelist.
560   // @dev Allow the owner of this contract to remove a buyer from the white list.
561   // @param _buyer : The buyer address to remove from the whitelist
562   function removeWhiteListedAddress(address _buyer) onlyOwner {
563     whiteListedForPresale[_buyer] = false;
564   }
565 
566   // @title Terminate the contract
567   // @dev Allow the owner of this contract to terminate it
568   // It also transfers the token ownership to the owner of the sale contract.
569   function destroy() onlyOwner {
570     token.finishMinting();
571     token.transferOwnership(msg.sender);
572     selfdestruct(owner);
573   }
574 }