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
75   bool public isTokenReleased = false;
76   
77   address addressSaleContract;
78   event BlacklistUpdated(address badUserAddress, bool registerStatus);
79   event TokenReleased(address tokenOwnerAddress, bool tokenStatus);
80 
81   uint256 totalSupply_;
82 
83   modifier onlyBonusSetter() {
84       require(msg.sender == owner || msg.sender == addressSaleContract);
85       _;
86   }
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103     require(isTokenReleased);
104     require(!blacklist[_to]);
105     require(!blacklist[msg.sender]);
106     
107     if (bonusReleaseTime[msg.sender] > block.timestamp) {
108         require(_value <= balances[msg.sender].sub(bonusTokens[msg.sender]));
109     }
110     
111     balances[msg.sender] = balances[msg.sender].sub(_value);
112     balances[_to] = balances[_to].add(_value);
113     emit Transfer(msg.sender, _to, _value);
114     return true;
115   }
116 
117   /**
118   * @dev Gets the balance of the specified address.
119   * @param _owner The address to query the the balance of.
120   * @return An uint256 representing the amount owned by the passed address.
121   */
122   function balanceOf(address _owner) public view returns (uint256) {
123     require(msg.sender == owner || !blacklist[_owner]);
124     require(!blacklist[msg.sender]);
125     return balances[_owner];
126   }
127 
128   /**
129   * @dev Set the specified address to blacklist.
130   * @param _badUserAddress The address of bad user.
131   */
132   function registerToBlacklist(address _badUserAddress) onlyOwner public {
133       if (blacklist[_badUserAddress] != true) {
134 	  	  blacklist[_badUserAddress] = true;
135 	  }
136       emit BlacklistUpdated(_badUserAddress, blacklist[_badUserAddress]);   
137   }
138   
139   /**
140   * @dev Remove the specified address from blacklist.
141   * @param _badUserAddress The address of bad user.
142   */
143   function unregisterFromBlacklist(address _badUserAddress) onlyOwner public {
144       if (blacklist[_badUserAddress] == true) {
145 	  	  blacklist[_badUserAddress] = false;
146 	  }
147       emit BlacklistUpdated(_badUserAddress, blacklist[_badUserAddress]);
148   }
149 
150   /**
151   * @dev Check the address registered in blacklist.
152   * @param _address The address to check.
153   * @return a bool representing registration of the passed address.
154   */
155   function checkBlacklist (address _address) onlyOwner public view returns (bool) {
156       return blacklist[_address];
157   }
158   
159   /**
160   * @dev Release the token (enable all token functions).
161   */
162   function releaseToken() onlyOwner public {
163       if (isTokenReleased == false) {
164 		isTokenReleased = true;
165 	  }
166       emit TokenReleased(msg.sender, isTokenReleased);
167   }
168   
169   /**
170   * @dev Withhold the token (disable all token functions).
171   */
172   function withholdToken() onlyOwner public {
173       if (isTokenReleased == true) {
174 		isTokenReleased = false;
175       }
176 	  emit TokenReleased(msg.sender, isTokenReleased);
177   }
178   
179   /**
180   * @dev Set bonus token amount and bonus token release time for the specified address.
181   * @param _tokenHolder The address of bonus token holder
182   *        _bonusTokens The bonus token amount
183   *        _holdingPeriodInDays Bonus token holding period (in days) 
184   */  
185   function setBonusTokenInDays(address _tokenHolder, uint256 _bonusTokens, uint256 _holdingPeriodInDays) onlyBonusSetter public {
186       bonusTokens[_tokenHolder] = _bonusTokens;
187       bonusReleaseTime[_tokenHolder] = SafeMath.add(block.timestamp, _holdingPeriodInDays * 1 days);
188   }
189 
190   /**
191   * @dev Set bonus token amount and bonus token release time for the specified address.
192   * @param _tokenHolder The address of bonus token holder
193   *        _bonusTokens The bonus token amount
194   *        _bonusReleaseTime Bonus token release time
195   */  
196   function setBonusToken(address _tokenHolder, uint256 _bonusTokens, uint256 _bonusReleaseTime) onlyBonusSetter public {
197       bonusTokens[_tokenHolder] = _bonusTokens;
198       bonusReleaseTime[_tokenHolder] = _bonusReleaseTime;
199   }
200   
201   /**
202   * @dev Set bonus token amount and bonus token release time for the specified address.
203   * @param _tokenHolders The address of bonus token holder [ ] 
204   *        _bonusTokens The bonus token amount [ ] 
205   *        _bonusReleaseTime Bonus token release time
206   */  
207   function setMultiBonusTokens(address[] _tokenHolders, uint256[] _bonusTokens, uint256 _bonusReleaseTime) onlyBonusSetter public {
208       for (uint i = 0; i < _tokenHolders.length; i++) {
209         bonusTokens[_tokenHolders[i]] = _bonusTokens[i];
210         bonusReleaseTime[_tokenHolders[i]] = _bonusReleaseTime;
211       }
212   }
213 
214   /**
215   * @dev Set the address of the crowd sale contract which can call setBonusToken method.
216   * @param _addressSaleContract The address of the crowd sale contract.
217   */
218   function setBonusSetter(address _addressSaleContract) onlyOwner public {
219       addressSaleContract = _addressSaleContract;
220   }
221   
222   function getBonusSetter() public view returns (address) {
223       require(msg.sender == addressSaleContract || msg.sender == owner);
224       return addressSaleContract;
225   }
226   
227   /**
228   * @dev Display token holder's bonus token amount.
229   * @param _bonusHolderAddress The address of bonus token holder.
230   */
231   function checkBonusTokenAmount (address _bonusHolderAddress) public view returns (uint256) {
232       return bonusTokens[_bonusHolderAddress];
233   }
234   
235   /**
236   * @dev Display token holder's remaining bonus token holding period.
237   * @param _bonusHolderAddress The address of bonus token holder.
238   */
239   function checkBonusTokenHoldingPeriodRemained (address _bonusHolderAddress) public view returns (uint256) {
240       uint256 returnValue = 0;
241       if (bonusReleaseTime[_bonusHolderAddress] > now) {
242           returnValue = bonusReleaseTime[_bonusHolderAddress].sub(now);
243       }
244       return returnValue;
245   }
246 }
247 
248 /**
249  * @title Burnable Token
250  * @dev Token that can be irreversibly burned (destroyed).
251  */
252 contract BurnableToken is BasicToken {
253 
254   event Burn(address indexed burner, uint256 value);
255 
256   /**
257    * @dev Burns a specific amount of tokens.
258    * @param _value The amount of token to be burned.
259    */
260   function burn(uint256 _value) onlyOwner public {
261     _burn(msg.sender, _value);
262   }
263 
264   function _burn(address _who, uint256 _value) onlyOwner internal {
265     require(_value <= balances[_who]);
266     // no need to require value <= totalSupply, since that would imply the
267     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
268 
269     balances[_who] = balances[_who].sub(_value);
270     totalSupply_ = totalSupply_.sub(_value);
271     emit Burn(_who, _value);
272     emit Transfer(_who, address(0), _value);
273   }
274 }
275 
276 /**
277  * @title ERC20 interface
278  * @dev see https://github.com/ethereum/EIPs/issues/20
279  */
280 contract ERC20 is ERC20Basic {
281   function allowance(address owner, address spender) public view returns (uint256);
282   function transferFrom(address from, address to, uint256 value) public returns (bool);
283   function approve(address spender, uint256 value) public returns (bool);
284   event Approval(address indexed owner, address indexed spender, uint256 value);
285 }
286 
287 /**
288  * @title SafeMath
289  * @dev Math operations with safety checks that throw on error
290  */
291 library SafeMath {
292 
293   /**
294   * @dev Multiplies two numbers, throws on overflow.
295   */
296   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
297     if (a == 0) {
298       return 0;
299     }
300     c = a * b;
301     assert(c / a == b);
302     return c;
303   }
304 
305   /**
306   * @dev Integer division of two numbers, truncating the quotient.
307   */
308   function div(uint256 a, uint256 b) internal pure returns (uint256) {
309     // assert(b > 0); // Solidity automatically throws when dividing by 0
310     // uint256 c = a / b;
311     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
312     return a / b;
313   }
314 
315   /**
316   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
317   */
318   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
319     assert(b <= a);
320     return a - b;
321   }
322 
323   /**
324   * @dev Adds two numbers, throws on overflow.
325   */
326   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
327     c = a + b;
328     assert(c >= a);
329     return c;
330   }
331 }
332 
333 /**
334  * @title Standard ERC20 token
335  *
336  * @dev Implementation of the basic standard token.
337  * @dev https://github.com/ethereum/EIPs/issues/20
338  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
339  */
340 contract StandardToken is ERC20, BasicToken {
341   mapping (address => mapping (address => uint256)) internal allowed;
342   
343   /**
344    * @dev Transfer tokens from one address to another
345    * @param _from address The address which you want to send tokens from
346    * @param _to address The address which you want to transfer to
347    * @param _value uint256 the amount of tokens to be transferred
348    */
349   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
350     require(_to != address(0));
351     require(_value <= balances[_from]);
352     require(_value <= allowed[_from][msg.sender]);
353     require(!blacklist[_from]);
354     require(!blacklist[_to]);
355 	require(!blacklist[msg.sender]);
356     require(isTokenReleased);
357 
358     balances[_from] = balances[_from].sub(_value);
359     balances[_to] = balances[_to].add(_value);
360     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
361     emit Transfer(_from, _to, _value);
362     return true;
363   }
364 
365   /**
366    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
367    *
368    * Beware that changing an allowance with this method brings the risk that someone may use both the old
369    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
370    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
371    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
372    * @param _spender The address which will spend the funds.
373    * @param _value The amount of tokens to be spent.
374    */
375   function approve(address _spender, uint256 _value) public returns (bool) {
376     require(isTokenReleased);
377     require(!blacklist[_spender]);
378 	require(!blacklist[msg.sender]);
379 
380     allowed[msg.sender][_spender] = _value;
381     emit Approval(msg.sender, _spender, _value);
382     return true;
383   }
384 
385   /**
386    * @dev Function to check the amount of tokens that an owner allowed to a spender.
387    * @param _owner address The address which owns the funds.
388    * @param _spender address The address which will spend the funds.
389    * @return A uint256 specifying the amount of tokens still available for the spender.
390    */
391   function allowance(address _owner, address _spender) public view returns (uint256) {
392     require(!blacklist[_owner]);
393     require(!blacklist[_spender]);
394 	require(!blacklist[msg.sender]);
395 
396     return allowed[_owner][_spender];
397   }
398 
399   /**
400    * @dev Increase the amount of tokens that an owner allowed to a spender.
401    *
402    * approve should be called when allowed[_spender] == 0. To increment
403    * allowed value is better to use this function to avoid 2 calls (and wait until
404    * the first transaction is mined)
405    * From MonolithDAO Token.sol
406    * @param _spender The address which will spend the funds.
407    * @param _addedValue The amount of tokens to increase the allowance by.
408    */
409   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
410     require(!blacklist[_spender]);
411 	require(!blacklist[msg.sender]);
412 
413     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
414     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
415     return true;
416   }
417 
418   /**
419    * @dev Decrease the amount of tokens that an owner allowed to a spender.
420    *
421    * approve should be called when allowed[_spender] == 0. To decrement
422    * allowed value is better to use this function to avoid 2 calls (and wait until
423    * the first transaction is mined)
424    * From MonolithDAO Token.sol
425    * @param _spender The address which will spend the funds.
426    * @param _subtractedValue The amount of tokens to decrease the allowance by.
427    */
428   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
429     require(!blacklist[_spender]);    
430 	require(!blacklist[msg.sender]);
431 
432     uint oldValue = allowed[msg.sender][_spender];
433     if (_subtractedValue > oldValue) {
434       allowed[msg.sender][_spender] = 0;
435     } else {
436       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
437     }
438     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
439     return true;
440   }
441 }
442 
443 /**
444  * @title TrustVerse Token
445  * @dev Burnable ERC20 standard Token
446  */
447 contract TrustVerseToken is BurnableToken, StandardToken {
448   string public constant name = "TrustVerse"; // solium-disable-line uppercase
449   string public constant symbol = "TVS"; // solium-disable-line uppercase
450   uint8 public constant decimals = 18; // solium-disable-line uppercase
451   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
452   
453   /**
454    * @dev Constructor that gives msg.sender all of existing tokens.
455    */
456   constructor() public {
457     totalSupply_ = INITIAL_SUPPLY;
458     balances[msg.sender] = INITIAL_SUPPLY;
459     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
460   }
461 }