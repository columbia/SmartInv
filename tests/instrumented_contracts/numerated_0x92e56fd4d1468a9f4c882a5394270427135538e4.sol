1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 // File: contracts/PentacoreToken.sol
223 
224 /**
225  * @title Smart Contract which defines the token managed by the Pentacore Hedge Fund.
226  * @author Jordan Stojanovski
227  */
228 contract PentacoreToken is StandardToken {
229   using SafeMath for uint256;
230 
231   string public name = 'PentacoreToken';
232   string public symbol = 'PENT';
233   uint256 public constant million = 1000000;
234   uint256 public constant tokenCap = 1000 * million; // one billion tokens
235   bool public isPaused = true;
236 
237   // Unlike the common practice to put the whitelist checks in the crowdsale,
238   // the PentacoreToken does these tests itself.  This is mandated by legal
239   // issues, as follows:
240   // - The exchange can be anywhere and it should not be concerned with
241   //   Pentacore's whitelisting methods.  If the exchange desires, it can
242   //   perform its own KYC.
243   // - Even after the Crowdsale / ICO if a whitelisted owner tries to sell
244   //   their tokens to a non-whitelisted buyer (address), the seller shall be
245   //   directed to the KYC process to be whitelisted before the sale can proceed.
246   //   This prevents against selling tokens to buyers under embargo.
247   // - If the seller is removed from the whitelist prior to the sale attempt,
248   //   the corresponding sale should be reported to the authorities instead of
249   //   allowing the seller to proceed.  This is subject of further discussion.
250   mapping(address => bool) public whitelist;
251 
252   // If set to true, allow transfers between any addresses regardless of whitelist.
253   // However, sale and/or redemption would still be not allowed regardless of this flag.
254   // In the future, if it is determined that it is legal to transfer but not sell and/or redeem,
255   // we could turn this flag on.
256   bool public isFreeTransferAllowed = false;
257 
258   uint256 public tokenNAVMicroUSD; // Net Asset Value per token in MicroUSD (millionths of 1 US$)
259   uint256 public weiPerUSD; // How many Wei is one US$
260 
261   // Who's Who
262   address public owner; // The owner of this contract.
263   address public kycAdmin; // The address of the caller which can update the KYC status of an address.
264   address public navAdmin; // The address of the caller which can update the NAV/USD and ETH/USD values.
265   address public crowdsale; //The address of the crowdsale contract.
266   address public redemption; // The address of the redemption contract.
267   address public distributedAutonomousExchange; // The address of the exchange contract.
268 
269   event Mint(address indexed to, uint256 amount);
270   event Burn(uint256 amount);
271   event AddToWhitelist(address indexed beneficiary);
272   event RemoveFromWhitelist(address indexed beneficiary);
273 
274   function PentacoreToken() public {
275     owner = msg.sender;
276     tokenNAVMicroUSD = million; // Initially 1 PENT = 1 US$ (a million millionths)
277     isFreeTransferAllowed = false;
278     isPaused = true;
279     totalSupply_ = 0; // No tokens exist at creation.  They are minted as sold.
280   }
281 
282   /**
283    * @dev Throws if called by any account other than the authorized one.
284    * @param authorized the address of the authorized caller.
285    */
286   modifier onlyBy(address authorized) {
287     require(authorized != address(0));
288     require(msg.sender == authorized);
289     _;
290   }
291 
292   /**
293    * @dev Pauses / unpauses the transferability of the token.
294    * @param _pause pause if true; unpause if false
295    */
296   function setPaused(bool _pause) public {
297     require(owner != address(0));
298     require(msg.sender == owner);
299 
300     isPaused = _pause;
301   }
302 
303   modifier notPaused() {
304     require(!isPaused);
305     _;
306   }
307 
308   /**
309    * @dev Sets the address of the owner.
310    * @param _address The address of the new owner of the Token Contract.
311    */
312   function transferOwnership(address _address) external onlyBy(owner) {
313     require(_address != address(0)); // Prevent rendering it unusable
314     owner = _address;
315   }
316 
317   /**
318    * @dev Sets the address of the PentacoreCrowdsale contract.
319    * @param _address PentacoreCrowdsale contract address.
320    */
321   function setKYCAdmin(address _address) external onlyBy(owner) {
322     kycAdmin = _address;
323   }
324 
325   /**
326    * @dev Sets the address of the PentacoreCrowdsale contract.
327    * @param _address PentacoreCrowdsale contract address.
328    */
329   function setNAVAdmin(address _address) external onlyBy(owner) {
330     navAdmin = _address;
331   }
332 
333   /**
334    * @dev Sets the address of the PentacoreCrowdsale contract.
335    * @param _address PentacoreCrowdsale contract address.
336    */
337   function setCrowdsaleContract(address _address) external onlyBy(owner) {
338     crowdsale = _address;
339   }
340 
341   /**
342    * @dev Sets the address of the PentacoreRedemption contract.
343    * @param _address PentacoreRedemption contract address.
344    */
345   function setRedemptionContract(address _address) external onlyBy(owner) {
346     redemption = _address;
347   }
348 
349   /**
350     * @dev Sets the address of the DistributedAutonomousExchange contract.
351     * @param _address DistributedAutonomousExchange contract address.
352     */
353   function setDistributedAutonomousExchange(address _address) external onlyBy(owner) {
354     distributedAutonomousExchange = _address;
355   }
356 
357   /**
358    * @dev Sets the token price in US$.  Set by owner to reflect NAV/token.
359    * @param _price PentacoreToken price in USD.
360    */
361   function setTokenNAVMicroUSD(uint256 _price) external onlyBy(navAdmin) {
362     tokenNAVMicroUSD = _price;
363   }
364 
365   /**
366    * @dev Sets the token price in US$.  Set by owner to reflect NAV/token.
367    * @param _price PentacoreToken price in USD.
368    */
369   function setWeiPerUSD(uint256 _price) external onlyBy(navAdmin) {
370     weiPerUSD = _price;
371   }
372 
373   /**
374    * @dev Calculate the amount of Wei for a given token amount.  The result is rounded down (floored) to a millionth of a US$)
375    * @param _tokenAmount Whole number of tokens to be converted to Wei
376    * @return amount of Wei for the given amount of tokens
377    */
378   function tokensToWei(uint256 _tokenAmount) public view returns (uint256) {
379     require(tokenNAVMicroUSD != uint256(0));
380     require(weiPerUSD != uint256(0));
381     return _tokenAmount.mul(tokenNAVMicroUSD).mul(weiPerUSD).div(million);
382   }
383 
384   /**
385    * @dev Calculate the amount tokens for a given Wei amount and the amount of change in Wei.
386    * @param _weiAmount Whole number of Wei to be converted to tokens
387    * @return whole amount of tokens for the given amount in Wei
388    * @return change in Wei that is not sufficient to buy a whole token
389    */
390   function weiToTokens(uint256 _weiAmount) public view returns (uint256, uint256) {
391     require(tokenNAVMicroUSD != uint256(0));
392     require(weiPerUSD != uint256(0));
393     uint256 tokens = _weiAmount.mul(million).div(weiPerUSD).div(tokenNAVMicroUSD);
394     uint256 changeWei = _weiAmount.sub(tokensToWei(tokens));
395     return (tokens, changeWei);
396   }
397 
398   /**
399    * @dev Allows / disallows free transferability of tokens regardless of whitelist.
400    * @param _isFreeTransferAllowed disregard whitelist if true; not if false
401    */
402   function setFreeTransferAllowed(bool _isFreeTransferAllowed) public {
403     require(owner != address(0));
404     require(msg.sender == owner);
405 
406     isFreeTransferAllowed = _isFreeTransferAllowed;
407   }
408 
409   /**
410    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
411    * @param _beneficiary the address which must be whitelisted by the KYC process in order to pass.
412    */
413   modifier isWhitelisted(address _beneficiary) {
414     require(whitelist[_beneficiary]);
415     _;
416   }
417 
418   /**
419    * @dev Reverts if beneficiary is not whitelisted and isFreeTransferAllowed is false. Can be used when extending this contract.
420    * @param _beneficiary the address which must be whitelisted by the KYC process in order to pass unless isFreeTransferAllowed.
421    */
422   modifier isWhitelistedOrFreeTransferAllowed(address _beneficiary) {
423     require(isFreeTransferAllowed || whitelist[_beneficiary]);
424     _;
425   }
426 
427   /**
428    * @dev Adds single address to whitelist.
429    * @param _beneficiary Address to be added to the whitelist
430    */
431   function addToWhitelist(address _beneficiary) public onlyBy(kycAdmin) {
432     whitelist[_beneficiary] = true;
433     emit AddToWhitelist(_beneficiary);
434   }
435 
436   /**
437    * @dev Adds list of addresses to whitelist.
438    * @param _beneficiaries List of addresses to be added to the whitelist
439    */
440   function addManyToWhitelist(address[] _beneficiaries) external onlyBy(kycAdmin) {
441     for (uint256 i = 0; i < _beneficiaries.length; i++) addToWhitelist(_beneficiaries[i]);
442   }
443 
444   /**
445    * @dev Removes single address from whitelist.
446    * @param _beneficiary Address to be removed to the whitelist
447    */
448   function removeFromWhitelist(address _beneficiary) public onlyBy(kycAdmin) {
449     whitelist[_beneficiary] = false;
450     emit RemoveFromWhitelist(_beneficiary);
451   }
452 
453   /**
454    * @dev Removes list of addresses from whitelist.
455    * @param _beneficiaries List of addresses to be removed to the whitelist
456    */
457   function removeManyFromWhitelist(address[] _beneficiaries) external onlyBy(kycAdmin) {
458     for (uint256 i = 0; i < _beneficiaries.length; i++) removeFromWhitelist(_beneficiaries[i]);
459   }
460 
461   /**
462    * @dev Function to mint tokens. We mint as we sell tokens (actually the PentacoreCrowdsale contract does).
463    * @dev The recipient should be whitelisted.
464    * @param _to The address that will receive the minted tokens.
465    * @param _amount The amount of tokens to mint.
466    * @return A boolean that indicates if the operation was successful.
467    */
468   function mint(address _to, uint256 _amount) public onlyBy(crowdsale) isWhitelisted(_to) returns (bool) {
469     // Should run even when the token is paused.
470     require(tokenNAVMicroUSD != uint256(0));
471     require(weiPerUSD != uint256(0));
472     require(totalSupply_.add(_amount) <= tokenCap);
473     totalSupply_ = totalSupply_.add(_amount);
474     balances[_to] = balances[_to].add(_amount);
475     emit Mint(_to, _amount);
476     return true;
477   }
478 
479   /**
480    * @dev Function to burn tokens. We burn as owners redeem tokens (actually the PentacoreRedemptions contract does).
481    * @param _amount The amount of tokens to burn.
482    * @return A boolean that indicates if the operation was successful.
483    */
484   function burn(uint256 _amount) public onlyBy(redemption) returns (bool) {
485     // Should run even when the token is paused.
486     require(balances[redemption].sub(_amount) >= uint256(0));
487     require(totalSupply_.sub(_amount) >= uint256(0));
488     balances[redemption] = balances[redemption].sub(_amount);
489     totalSupply_ = totalSupply_.sub(_amount);
490     emit Burn(_amount);
491     return true;
492   }
493 
494   /**
495    * @dev transfer token for a specified address
496    * @dev Both the sender and the recipient should be whitelisted.
497    * @param _to The address to transfer to.
498    * @param _value The amount to be transferred.
499    */
500   function transfer(address _to, uint256 _value) public notPaused isWhitelistedOrFreeTransferAllowed(msg.sender) isWhitelistedOrFreeTransferAllowed(_to) returns (bool) {
501     return super.transfer(_to, _value);
502   }
503 
504   /**
505    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
506    * @dev The sender should be whitelisted.
507    *
508    * Beware that changing an allowance with this method brings the risk that someone may use both the old
509    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
510    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
511    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
512    * @param _spender The address which will spend the funds.
513    * @param _value The amount of tokens to be spent.
514    */
515   function approve(address _spender, uint256 _value) public notPaused isWhitelistedOrFreeTransferAllowed(msg.sender) returns (bool) {
516     return super.approve(_spender, _value);
517   }
518 
519   /**
520    * @dev Increase the amount of tokens that an owner allowed to a spender.
521    * @dev The sender should be whitelisted.
522    *
523    * approve should be called when allowed[_spender] == 0. To increment
524    * allowed value is better to use this function to avoid 2 calls (and wait until
525    * the first transaction is mined)
526    * From MonolithDAO Token.sol
527    * @param _spender The address which will spend the funds.
528    * @param _addedValue The amount of tokens to increase the allowance by.
529    */
530   function increaseApproval(address _spender, uint _addedValue) public notPaused isWhitelistedOrFreeTransferAllowed(msg.sender) returns (bool) {
531     return super.increaseApproval(_spender, _addedValue);
532   }
533 
534   /**
535    * @dev Decrease the amount of tokens that an owner allowed to a spender.
536    *
537    * approve should be called when allowed[_spender] == 0. To decrement
538    * allowed value is better to use this function to avoid 2 calls (and wait until
539    * the first transaction is mined)
540    * From MonolithDAO Token.sol
541    *
542    * @dev The sender does not need to be whitelisted.  This is in case they are removed from white list and no longer agree to sell at an exchange.
543    * @dev This function stays untouched (directly inherited), but it's re-defined for clarity:
544    *
545    * @param _spender The address which will spend the funds.
546    * @param _subtractedValue The amount of tokens to decrease the allowance by.
547    */
548   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
549     return super.decreaseApproval(_spender, _subtractedValue);
550   }
551 
552   /**
553    * @dev Transfer tokens from one address to another
554    * @dev Both the sender and the recipient should be whitelisted.
555    * @param _from address The address which you want to send tokens from
556    * @param _to address The address which you want to transfer to
557    * @param _value uint256 the amount of tokens to be transferred
558    */
559   function transferFrom(address _from, address _to, uint256 _value) public notPaused isWhitelistedOrFreeTransferAllowed(_from) isWhitelistedOrFreeTransferAllowed(_to) returns (bool) {
560     return super.transferFrom(_from, _to, _value);
561   }
562 }