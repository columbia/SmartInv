1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Math
17  * @dev Assorted math operations
18  */
19 library Math {
20   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
21     return a >= b ? a : b;
22   }
23 
24   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
25     return a < b ? a : b;
26   }
27 
28   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
29     return a >= b ? a : b;
30   }
31 
32   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
33     return a < b ? a : b;
34   }
35 }
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization control
40  * functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 /**
78  * @title SafeMath
79  * @dev Math operations with safety checks that throw on error
80  */
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     if (a == 0) {
88       return 0;
89     }
90     uint256 c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return c;
103   }
104 
105   /**
106   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 /**
124  * @title Basic token
125  * @dev Basic version of StandardToken, with no allowances.
126  */
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   uint256 totalSupply_;
133 
134   /**
135   * @dev total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     // SafeMath.sub will throw if there is not enough balance.
151     balances[msg.sender] = balances[msg.sender].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     Transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   /**
158   * @dev Gets the balance of the specified address.
159   * @param _owner The address to query the the balance of.
160   * @return An uint256 representing the amount owned by the passed address.
161   */
162   function balanceOf(address _owner) public view returns (uint256 balance) {
163     return balances[_owner];
164   }
165 
166 }
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender) public view returns (uint256);
174   function transferFrom(address from, address to, uint256 value) public returns (bool);
175   function approve(address spender, uint256 value) public returns (bool);
176   event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 /**
180  * @title Standard ERC20 token
181  *
182  * @dev Implementation of the basic standard token.
183  * @dev https://github.com/ethereum/EIPs/issues/20
184  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
185  */
186 contract StandardToken is ERC20, BasicToken {
187 
188   mapping (address => mapping (address => uint256)) internal allowed;
189 
190 
191   /**
192    * @dev Transfer tokens from one address to another
193    * @param _from address The address which you want to send tokens from
194    * @param _to address The address which you want to transfer to
195    * @param _value uint256 the amount of tokens to be transferred
196    */
197   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201 
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205     Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    *
212    * Beware that changing an allowance with this method brings the risk that someone may use both the old
213    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216    * @param _spender The address which will spend the funds.
217    * @param _value The amount of tokens to be spent.
218    */
219   function approve(address _spender, uint256 _value) public returns (bool) {
220     allowed[msg.sender][_spender] = _value;
221     Approval(msg.sender, _spender, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Function to check the amount of tokens that an owner allowed to a spender.
227    * @param _owner address The address which owns the funds.
228    * @param _spender address The address which will spend the funds.
229    * @return A uint256 specifying the amount of tokens still available for the spender.
230    */
231   function allowance(address _owner, address _spender) public view returns (uint256) {
232     return allowed[_owner][_spender];
233   }
234 
235   /**
236    * @dev Increase the amount of tokens that an owner allowed to a spender.
237    *
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    * @param _spender The address which will spend the funds.
243    * @param _addedValue The amount of tokens to increase the allowance by.
244    */
245   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
246     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
247     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248     return true;
249   }
250 
251   /**
252    * @dev Decrease the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
262     uint oldValue = allowed[msg.sender][_spender];
263     if (_subtractedValue > oldValue) {
264       allowed[msg.sender][_spender] = 0;
265     } else {
266       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
267     }
268     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272 }
273 
274 contract Auscoin is StandardToken, Ownable {
275   // Publicly listed name
276   string public name = "AUSCOIN COIN";
277   // Symbol under which token will be trading
278   string public symbol = "AUSC";
279   // 1 ETH consists of 10^18 Wei, which is the smallest ETH unit
280   uint8 public decimals = 18;
281   // Defining the value of a million for easy calculations - order of declaration matters (hoisting)
282   uint256 million = 1000000 * (uint256(10) ** decimals);
283   // We are offering a total of 100 Million Auscoin Tokens to distribute
284   uint256 public totalSupply = 100 * million;
285   // This is established on contract deployment in relevance to the (at the time) ETH/USD exchange rate
286   uint256 public exchangeRate;
287   // Initialized to 0, this value tracks the total amount of ETH sent to the smart contract
288   uint256 public totalEthRaised = 0;
289   // The time at which the ICO allows for buy interactions, 12th Feb 6PM
290   uint256 public startTime;
291   // The time at which the ICO stops buy interactions, 12th Feb 6PM + 28 days, after this only transfers and withdrawals are allowed
292   uint256 public endTime;
293   // The AusGroup token allocation will not be available to AusGroup until this date
294   uint256 public ausGroupReleaseDate;
295   // Address where the ether raised is transfered to and address where the token balance is stored within the balances mapping
296   address public fundsWallet;
297   // Address where the bonus tokens are transferred to and held
298   address public bonusWallet;
299   // Address where AusGroup tokens are held
300   address public ausGroup;
301   // Whitelister - the entity with permission to add addresses to the whiteList mapping
302   address public whiteLister;
303 
304   // Initial Allocation amounts
305   uint256 public ausGroupAllocation = 50 * million;
306   uint256 public bountyAllocation = 1 * million;
307   uint256 public preSeedAllocation = 3 * million;
308   uint256 public bonusAllocation = 6 * million;
309 
310   // Whitelisted mapping - the addresses which have participated in the ICO and are allowed to transact after the ICO.
311   // ICO Participants need to be verify their identity before they can use AusCoin
312   mapping (address => bool) public whiteListed;
313 
314   // ICO Participant
315   mapping (address => bool) isICOParticipant;
316 
317   // Constants
318   uint256 numberOfMillisecsPerYear = 365 * 24 * 60 * 60 * 1000;
319   uint256 amountPerYearAvailableToAusGroup = 5 * million;
320 
321   function Auscoin(
322     uint256 _startTime,
323     uint256 _endTime,
324     uint256 _ausGroupReleaseDate,
325     uint256 _exchangeRate,
326     address _bonusWallet,
327     address _ausGroup,
328     address _bounty,
329     address _preSeedFund,
330     address _whiteLister
331   )
332     public
333   {
334     fundsWallet = owner;
335     bonusWallet = _bonusWallet;
336     startTime = _startTime;
337     endTime = _endTime; // 4 weeks
338     ausGroupReleaseDate = _ausGroupReleaseDate;
339     exchangeRate = _exchangeRate;
340     ausGroup = _ausGroup;
341     whiteLister = _whiteLister;
342 
343     // Assign total supply to funds wallet
344     // https://github.com/OpenZeppelin/zeppelin-solidity/issues/494
345     // A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.
346     balances[fundsWallet] = totalSupply;
347     Transfer(0x0, fundsWallet, totalSupply);
348 
349     // Allocate bonus tokens
350     // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/BasicToken.sol
351     // The inherited transfer method from the StandardToken which inherits from BasicToken emits Transfer events and subtracts/adds respective
352     // amounts to respective accounts
353     super.transfer(bonusWallet, bonusAllocation);
354 
355     // Transfer pre-allocated funds
356     super.transfer(_ausGroup, ausGroupAllocation);
357 
358     // Allocate bounty funds
359     super.transfer(_bounty, bountyAllocation);
360 
361     // Allocate pre-seed funds
362     super.transfer(_preSeedFund, preSeedAllocation);
363   }
364 
365   // Time utility function
366   function currentTime() public view returns (uint256) {
367     return now * 1000;
368   }
369 
370   // calculateBonusAmount, view tag attached as it does not manipulate state
371   function calculateBonusAmount(uint256 amount) view internal returns (uint256) {
372     uint256 totalAvailableDuringICO = totalSupply - (bonusAllocation + ausGroupAllocation + bountyAllocation + preSeedAllocation);
373     uint256 sold = totalAvailableDuringICO - balances[fundsWallet];
374 
375     uint256 amountForThirtyBonusBracket = int256((10 * million) - sold) > 0 ? (10 * million) - sold : 0;
376     uint256 amountForTwentyBonusBracket = int256((20 * million) - sold) > 0 ? (20 * million) - sold : 0;
377     uint256 amountForTenBonusBracket = int256((30 * million) - sold) > 0 ? (30 * million) - sold : 0;
378 
379     uint256 thirtyBonusBracket = Math.min256(Math.max256(0, amountForThirtyBonusBracket), Math.min256(amount, (10 * million)));
380     uint256 twentyBonusBracket = Math.min256(Math.max256(0, amountForTwentyBonusBracket), Math.min256(amount - thirtyBonusBracket, (10 * million)));
381     uint256 tenBonusBracket = Math.min256(Math.max256(0, amountForTenBonusBracket), Math.min256(amount - twentyBonusBracket - thirtyBonusBracket, (10 * million)));
382 
383     uint256 totalBonus = thirtyBonusBracket.mul(30).div(100) + twentyBonusBracket.mul(20).div(100) + tenBonusBracket.mul(10).div(100);
384 
385     return totalBonus;
386   }
387 
388   // Payable functions. Fall out and low level buy
389   // isIcoOpen modifier ensures ETH payments can only be made if the ICO is 'open', after start and before end date (or if all tokens are sold)
390   // payable is needed on the fallback function in order to receive Ether
391   // Reference: http://solidity.readthedocs.io/en/develop/contracts.html
392   function() isIcoOpen payable public {
393     buyTokens();
394   }
395 
396   function buyTokens() isIcoOpen payable public {
397     // Use the exchange rate set at deployment to calculate the amount of tokens the transferred ETH converts to
398     uint256 tokenAmount = msg.value.mul(exchangeRate);
399     // Calculate the bonus the sender will receive based on which Tier the current Smart Contract is sitting on
400     uint256 bonusAmount = calculateBonusAmount(tokenAmount);
401     // Ensure that the tokenAmount is greater than the total funds currently present
402     require(balances[fundsWallet] >= tokenAmount);
403     // Ensure that the bonusAmount is greater than the total bonus currently availbale in the bonusWallet
404     require(balances[bonusWallet] >= bonusAmount);
405 
406     // Add to the state level ETH raised value
407     totalEthRaised = totalEthRaised.add(msg.value);
408 
409     // Deduct the said amount from the relevant wallet addresses in the balance map
410     balances[bonusWallet] = balances[bonusWallet].sub(bonusAmount);
411     balances[fundsWallet] = balances[fundsWallet].sub(tokenAmount);
412     // Add the sold tokens to the sender's wallet address in the balance map for them to claim after ICO
413     balances[msg.sender] = balances[msg.sender].add(tokenAmount.add(bonusAmount));
414 
415     // Add them to the isICOParticipant mapping
416     isICOParticipant[msg.sender] = true;
417 
418     fundsWallet.transfer(msg.value);
419 
420     // Since we did not use the transfer method, we manually emit the Transfer event
421     Transfer(fundsWallet, msg.sender, tokenAmount);
422     Transfer(bonusWallet, msg.sender, bonusAmount);
423   }
424 
425   function addToWhiteList(address _purchaser) canAddToWhiteList public {
426     whiteListed[_purchaser] = true;
427   }
428 
429   function setWhiteLister(address _newWhiteLister) onlyOwner public {
430     whiteLister = _newWhiteLister;
431   }
432 
433   // Transfers
434   function transfer(address _to, uint _value) isIcoClosed public returns (bool success) {
435     require(msg.sender != ausGroup);
436     if (isICOParticipant[msg.sender]) {
437       require(whiteListed[msg.sender]);
438     }
439     return super.transfer(_to, _value);
440   }
441 
442   function ausgroupTransfer(address _to, uint _value) timeRestrictedAccess isValidAusGroupTransfer(_value) public returns (bool success) {
443     require(msg.sender == ausGroup);
444     require(balances[ausGroup] >= _value);
445     return super.transfer(_to, _value);
446   }
447 
448   // Override to enforce modifier that ensures that ICO is closed before the following function is invoked
449   function transferFrom(address _from, address _to, uint _value) isIcoClosed public returns (bool success) {
450     require(_from != ausGroup);
451     if (isICOParticipant[_from]) {
452       require(whiteListed[_from]);
453     }
454     return super.transferFrom(_from, _to, _value);
455   }
456 
457   function burnUnsoldTokens() isIcoClosed onlyOwner public {
458     uint256 bonusLeft = balances[bonusWallet];
459     uint256 fundsLeft = balances[fundsWallet];
460     // Burn anything in our balances map
461     balances[bonusWallet] = 0;
462     balances[fundsWallet] = 0;
463     Transfer(bonusWallet, 0, bonusLeft);
464     Transfer(fundsWallet, 0, fundsLeft);
465   }
466 
467   // Modifiers
468   modifier isIcoOpen() {
469     require(currentTime() >= startTime);
470     require(currentTime() < endTime);
471     _;
472   }
473 
474   modifier isIcoClosed() {
475     require(currentTime() >= endTime);
476     _;
477   }
478 
479   modifier timeRestrictedAccess() {
480     require(currentTime() >= ausGroupReleaseDate);
481     _;
482   }
483 
484   modifier canAddToWhiteList() {
485     require(msg.sender == whiteLister);
486     _;
487   }
488 
489   modifier isValidAusGroupTransfer(uint256 _value) {
490     uint256 yearsAfterRelease = ((currentTime() - ausGroupReleaseDate) / numberOfMillisecsPerYear) + 1;
491     uint256 cumulativeTotalAvailable = yearsAfterRelease * amountPerYearAvailableToAusGroup;
492     require(cumulativeTotalAvailable > 0);
493     uint256 amountAlreadyTransferred = ausGroupAllocation - balances[ausGroup];
494     uint256 amountAvailable = cumulativeTotalAvailable - amountAlreadyTransferred;
495     require(_value <= amountAvailable);
496     _;
497   }
498 }