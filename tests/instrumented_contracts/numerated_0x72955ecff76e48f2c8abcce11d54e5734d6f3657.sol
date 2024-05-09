1 pragma solidity 0.4.24;
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
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   //event OwnershipRenounced(address indexed previousOwner);
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27 
28   /**
29    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30    * account.
31    */
32   constructor() public {
33     owner = msg.sender;
34   }
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address newOwner) public onlyOwner {
49     require(newOwner != address(0));
50     emit OwnershipTransferred(owner, newOwner);
51     owner = newOwner;
52   }
53 
54   /**
55    * @dev Allows the current owner to relinquish control of the contract.
56    */
57   //function renounceOwnership() public onlyOwner {
58   //  emit OwnershipRenounced(owner);
59   //  owner = address(0);
60   //}
61 }
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic, Ownable {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71   mapping(address => uint256) bonusTokens;
72   mapping(address => uint256) bonusReleaseTime;
73   
74   mapping(address => bool) internal blacklist;
75   address[] internal blacklistHistory;
76   
77   bool public isTokenReleased = false;
78   
79   address addressSaleContract;
80   event BlacklistUpdated(address badUserAddress, bool registerStatus);
81   event TokenReleased(address tokenOwnerAddress, bool tokenStatus);
82 
83   uint256 totalSupply_;
84 
85   modifier onlyBonusSetter() {
86       require(msg.sender == owner || msg.sender == addressSaleContract);
87       _;
88   }
89 
90   /**
91   * @dev total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105     require(isTokenReleased);
106     require(!blacklist[_to]);
107     require(!blacklist[msg.sender]);
108     
109     if (bonusReleaseTime[msg.sender] > block.timestamp) {
110         require(_value <= balances[msg.sender].sub(bonusTokens[msg.sender]));
111     }
112     
113     balances[msg.sender] = balances[msg.sender].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     emit Transfer(msg.sender, _to, _value);
116     return true;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param _owner The address to query the the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address _owner) public view returns (uint256) {
125     require(msg.sender == owner || !blacklist[_owner]);
126     require(!blacklist[msg.sender]);
127     return balances[_owner];
128   }
129 
130   /**
131   * @dev Set the specified address to blacklist.
132   * @param _badUserAddress The address of bad user.
133   */
134   function registerToBlacklist(address _badUserAddress) onlyOwner public {
135       if (blacklist[_badUserAddress] != true) {
136 	  	  blacklist[_badUserAddress] = true;
137           blacklistHistory.push(_badUserAddress);
138 	  }
139       emit BlacklistUpdated(_badUserAddress, blacklist[_badUserAddress]);   
140   }
141   
142   /**
143   * @dev Remove the specified address from blacklist.
144   * @param _badUserAddress The address of bad user.
145   */
146   function unregisterFromBlacklist(address _badUserAddress) onlyOwner public {
147       if (blacklist[_badUserAddress] == true) {
148 	  	  blacklist[_badUserAddress] = false;
149 	  }
150       emit BlacklistUpdated(_badUserAddress, blacklist[_badUserAddress]);
151   }
152 
153   /**
154   * @dev Check the address registered in blacklist.
155   * @param _address The address to check.
156   * @return a bool representing registration of the passed address.
157   */
158   function checkBlacklist (address _address) onlyOwner public view returns (bool) {
159       return blacklist[_address];
160   }
161 
162   function getblacklistHistory() onlyOwner public view returns (address[]) {
163       return blacklistHistory;
164   }
165   
166   /**
167   * @dev Release the token (enable all token functions).
168   */
169   function releaseToken() onlyOwner public {
170       if (isTokenReleased == false) {
171 		isTokenReleased = true;
172 	  }
173       emit TokenReleased(msg.sender, isTokenReleased);
174   }
175   
176   /**
177   * @dev Withhold the token (disable all token functions).
178   */
179   function withholdToken() onlyOwner public {
180       if (isTokenReleased == true) {
181 		isTokenReleased = false;
182       }
183 	  emit TokenReleased(msg.sender, isTokenReleased);
184   }
185   
186   /**
187   * @dev Set bonus token amount and bonus token release time for the specified address.
188   * @param _tokenHolder The address of bonus token holder
189   *        _bonusTokens The bonus token amount
190   *        _holdingPeriodInDays Bonus token holding period (in days) 
191   */  
192   function setBonusTokenInDays(address _tokenHolder, uint256 _bonusTokens, uint256 _holdingPeriodInDays) onlyBonusSetter public {
193       bonusTokens[_tokenHolder] = _bonusTokens;
194       bonusReleaseTime[_tokenHolder] = SafeMath.add(block.timestamp, _holdingPeriodInDays * 1 days);
195   }
196 
197   /**
198   * @dev Set bonus token amount and bonus token release time for the specified address.
199   * @param _tokenHolder The address of bonus token holder
200   *        _bonusTokens The bonus token amount
201   *        _bonusReleaseTime Bonus token release time
202   */  
203   function setBonusToken(address _tokenHolder, uint256 _bonusTokens, uint256 _bonusReleaseTime) onlyBonusSetter public {
204       bonusTokens[_tokenHolder] = _bonusTokens;
205       bonusReleaseTime[_tokenHolder] = _bonusReleaseTime;
206   }
207   
208   /**
209   * @dev Set bonus token amount and bonus token release time for the specified address.
210   * @param _tokenHolders The address of bonus token holder ["0x...", "0x...", ...] 
211   *        _bonusTokens The bonus token amount [0,0, ...] 
212   *        _bonusReleaseTime Bonus token release time
213   */  
214   function setBonusTokens(address[] _tokenHolders, uint256[] _bonusTokens, uint256 _bonusReleaseTime) onlyBonusSetter public {
215       for (uint i = 0; i < _tokenHolders.length; i++) {
216         bonusTokens[_tokenHolders[i]] = _bonusTokens[i];
217         bonusReleaseTime[_tokenHolders[i]] = _bonusReleaseTime;
218       }
219   }
220 
221   function setBonusTokensInDays(address[] _tokenHolders, uint256[] _bonusTokens, uint256 _holdingPeriodInDays) onlyBonusSetter public {
222       for (uint i = 0; i < _tokenHolders.length; i++) {
223         bonusTokens[_tokenHolders[i]] = _bonusTokens[i];
224         bonusReleaseTime[_tokenHolders[i]] = SafeMath.add(block.timestamp, _holdingPeriodInDays * 1 days);
225       }
226   }
227 
228   /**
229   * @dev Set the address of the crowd sale contract which can call setBonusToken method.
230   * @param _addressSaleContract The address of the crowd sale contract.
231   */
232   function setBonusSetter(address _addressSaleContract) onlyOwner public {
233       addressSaleContract = _addressSaleContract;
234   }
235   
236   function getBonusSetter() public view returns (address) {
237       require(msg.sender == addressSaleContract || msg.sender == owner);
238       return addressSaleContract;
239   }
240   
241   /**
242   * @dev Display token holder's bonus token amount.
243   * @param _bonusHolderAddress The address of bonus token holder.
244   */
245   function checkBonusTokenAmount (address _bonusHolderAddress) public view returns (uint256) {
246       return bonusTokens[_bonusHolderAddress];
247   }
248   
249   /**
250   * @dev Display token holder's remaining bonus token holding period.
251   * @param _bonusHolderAddress The address of bonus token holder.
252   */
253   function checkBonusTokenHoldingPeriodRemained (address _bonusHolderAddress) public view returns (uint256) {
254       uint256 returnValue = 0;
255       if (bonusReleaseTime[_bonusHolderAddress] > now) {
256           returnValue = bonusReleaseTime[_bonusHolderAddress].sub(now);
257       }
258       return returnValue;
259   }
260 }
261 
262 /**
263  * @title Burnable Token
264  * @dev Token that can be irreversibly burned (destroyed).
265  */
266 contract BurnableToken is BasicToken {
267 
268   event Burn(address indexed burner, uint256 value);
269 
270   /**
271    * @dev Burns a specific amount of tokens.
272    * @param _value The amount of token to be burned.
273    */
274   function burn(uint256 _value) onlyOwner public {
275     _burn(msg.sender, _value);
276   }
277 
278   function _burn(address _who, uint256 _value) onlyOwner internal {
279     require(_value <= balances[_who]);
280     // no need to require value <= totalSupply, since that would imply the
281     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
282 
283     balances[_who] = balances[_who].sub(_value);
284     totalSupply_ = totalSupply_.sub(_value);
285     emit Burn(_who, _value);
286     emit Transfer(_who, address(0), _value);
287   }
288 }
289 
290 /**
291  * @title ERC20 interface
292  * @dev see https://github.com/ethereum/EIPs/issues/20
293  */
294 contract ERC20 is ERC20Basic {
295   function allowance(address owner, address spender) public view returns (uint256);
296   function transferFrom(address from, address to, uint256 value) public returns (bool);
297   function approve(address spender, uint256 value) public returns (bool);
298   event Approval(address indexed owner, address indexed spender, uint256 value);
299 }
300 
301 /**
302  * @title SafeMath
303  * @dev Math operations with safety checks that throw on error
304  */
305 library SafeMath {
306 
307   /**
308   * @dev Multiplies two numbers, throws on overflow.
309   */
310   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
311     if (a == 0) {
312       return 0;
313     }
314     c = a * b;
315     assert(c / a == b);
316     return c;
317   }
318 
319   /**
320   * @dev Integer division of two numbers, truncating the quotient.
321   */
322   function div(uint256 a, uint256 b) internal pure returns (uint256) {
323     // assert(b > 0); // Solidity automatically throws when dividing by 0
324     // uint256 c = a / b;
325     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
326     return a / b;
327   }
328 
329   /**
330   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
331   */
332   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
333     assert(b <= a);
334     return a - b;
335   }
336 
337   /**
338   * @dev Adds two numbers, throws on overflow.
339   */
340   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
341     c = a + b;
342     assert(c >= a);
343     return c;
344   }
345 }
346 
347 /**
348  * @title Standard ERC20 token
349  *
350  * @dev Implementation of the basic standard token.
351  * @dev https://github.com/ethereum/EIPs/issues/20
352  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
353  */
354 contract StandardToken is ERC20, BasicToken {
355   mapping (address => mapping (address => uint256)) internal allowed;
356   
357   /**
358    * @dev Transfer tokens from one address to another
359    * @param _from address The address which you want to send tokens from
360    * @param _to address The address which you want to transfer to
361    * @param _value uint256 the amount of tokens to be transferred
362    */
363   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
364     require(_to != address(0));
365     require(_value <= balances[_from]);
366     require(_value <= allowed[_from][msg.sender]);
367     require(!blacklist[_from]);
368     require(!blacklist[_to]);
369 	require(!blacklist[msg.sender]);
370     require(isTokenReleased);
371 
372     balances[_from] = balances[_from].sub(_value);
373     balances[_to] = balances[_to].add(_value);
374     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
375     emit Transfer(_from, _to, _value);
376     return true;
377   }
378 
379   /**
380    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
381    *
382    * Beware that changing an allowance with this method brings the risk that someone may use both the old
383    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
384    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
385    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
386    * @param _spender The address which will spend the funds.
387    * @param _value The amount of tokens to be spent.
388    */
389   function approve(address _spender, uint256 _value) public returns (bool) {
390     require(isTokenReleased);
391     require(!blacklist[_spender]);
392 	require(!blacklist[msg.sender]);
393 
394     allowed[msg.sender][_spender] = _value;
395     emit Approval(msg.sender, _spender, _value);
396     return true;
397   }
398 
399   /**
400    * @dev Function to check the amount of tokens that an owner allowed to a spender.
401    * @param _owner address The address which owns the funds.
402    * @param _spender address The address which will spend the funds.
403    * @return A uint256 specifying the amount of tokens still available for the spender.
404    */
405   function allowance(address _owner, address _spender) public view returns (uint256) {
406     require(!blacklist[_owner]);
407     require(!blacklist[_spender]);
408 	require(!blacklist[msg.sender]);
409 
410     return allowed[_owner][_spender];
411   }
412 
413   /**
414    * @dev Increase the amount of tokens that an owner allowed to a spender.
415    *
416    * approve should be called when allowed[_spender] == 0. To increment
417    * allowed value is better to use this function to avoid 2 calls (and wait until
418    * the first transaction is mined)
419    * From MonolithDAO Token.sol
420    * @param _spender The address which will spend the funds.
421    * @param _addedValue The amount of tokens to increase the allowance by.
422    */
423   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
424     require(!blacklist[_spender]);
425 	require(!blacklist[msg.sender]);
426 
427     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
428     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
429     return true;
430   }
431 
432   /**
433    * @dev Decrease the amount of tokens that an owner allowed to a spender.
434    *
435    * approve should be called when allowed[_spender] == 0. To decrement
436    * allowed value is better to use this function to avoid 2 calls (and wait until
437    * the first transaction is mined)
438    * From MonolithDAO Token.sol
439    * @param _spender The address which will spend the funds.
440    * @param _subtractedValue The amount of tokens to decrease the allowance by.
441    */
442   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
443     require(!blacklist[_spender]);    
444 	require(!blacklist[msg.sender]);
445 
446     uint oldValue = allowed[msg.sender][_spender];
447     if (_subtractedValue > oldValue) {
448       allowed[msg.sender][_spender] = 0;
449     } else {
450       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
451     }
452     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
453     return true;
454   }
455 }
456 
457 /**
458  * @title TrustVerse Token
459  * @dev Burnable ERC20 standard Token
460  */
461 contract TrustVerseToken is BurnableToken, StandardToken {
462   string public constant name = "TrustVerse"; // solium-disable-line uppercase
463   string public constant symbol = "TRV"; // solium-disable-line uppercase
464   uint8 public constant decimals = 18; // solium-disable-line uppercase
465   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
466   mapping (address => mapping (address => uint256)) internal EffectiveDateOfAllowance; // Effective date of Lost-proof, Inheritance
467 
468   /**
469    * @dev Constructor that gives msg.sender all of existing tokens.
470    */
471   constructor() public {
472     totalSupply_ = INITIAL_SUPPLY;
473     balances[msg.sender] = INITIAL_SUPPLY;
474     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
475   }
476 
477   /**
478    * @dev Transfer tokens to multiple addresses
479    * @param _to array of address The address which you want to transfer to
480    * @param _value array of uint256 the amount of tokens to be transferred
481    */
482   function transferToMultiAddress(address[] _to, uint256[] _value) public {
483     require(_to.length == _value.length);
484 
485     uint256 transferTokenAmount = 0;
486     uint256 i = 0;
487     for (i = 0; i < _to.length; i++) {
488         transferTokenAmount = transferTokenAmount.add(_value[i]);
489     }
490     require(transferTokenAmount <= balances[msg.sender]);
491 
492     for (i = 0; i < _to.length; i++) {
493         transfer(_to[i], _value[i]);
494     }
495   }
496 
497   /**
498    * @dev Transfer tokens from one address to another
499    * @param _from address The address which you want to send tokens from
500    * @param _to address The address which you want to transfer to
501    * @param _value uint256 the amount of tokens to be transferred
502    */
503   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
504     require(EffectiveDateOfAllowance[_from][msg.sender] <= block.timestamp); 
505     return super.transferFrom(_from, _to, _value);
506   }
507 
508   /**
509    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
510    * @param _spender The address which will spend the funds.
511    * @param _value The amount of tokens to be spent.
512    * @param _effectiveDate Effective date of Lost-proof, Inheritance
513    */
514   function approveWithEffectiveDate(address _spender, uint256 _value, uint256 _effectiveDate) public returns (bool) {
515     require(isTokenReleased);
516     require(!blacklist[_spender]);
517 	require(!blacklist[msg.sender]);
518     
519     EffectiveDateOfAllowance[msg.sender][_spender] = _effectiveDate;
520     return approve(_spender, _value);
521   }
522 
523   /**
524    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
525    * @param _spender The address which will spend the funds.
526    * @param _value The amount of tokens to be spent.
527    * @param _effectiveDateInDays Effective date of Lost-proof, Inheritance
528    */
529   function approveWithEffectiveDateInDays(address _spender, uint256 _value, uint256 _effectiveDateInDays) public returns (bool) {
530     require(isTokenReleased);
531     require(!blacklist[_spender]);
532 	require(!blacklist[msg.sender]);
533     
534     EffectiveDateOfAllowance[msg.sender][_spender] = SafeMath.add(block.timestamp, _effectiveDateInDays * 1 days);
535     return approve(_spender, _value);
536   }  
537 
538   /**
539    * @dev Function to check the Effective date of Lost-proof, Inheritance of tokens that an owner allowed to a spender.
540    * @param _owner address The address which owns the funds.
541    * @param _spender address The address which will spend the funds.
542    * @return A uint256 specifying the amount of tokens still available for the spender.
543    */
544   function allowanceEffectiveDate(address _owner, address _spender) public view returns (uint256) {
545     require(!blacklist[_owner]);
546     require(!blacklist[_spender]);
547 	require(!blacklist[msg.sender]);
548 
549     return EffectiveDateOfAllowance[_owner][_spender];
550   }
551 }