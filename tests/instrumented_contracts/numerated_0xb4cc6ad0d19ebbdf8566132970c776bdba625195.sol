1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances.
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   uint256 totalSupply_;
84 
85   /**
86   * @dev total number of tokens in existence
87   */
88   function totalSupply() public view returns (uint256) {
89     return totalSupply_;
90   }
91 
92   /**
93   * @dev transfer token for a specified address
94   * @param _to The address to transfer to.
95   * @param _value The amount to be transferred.
96   */
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     // SafeMath.sub will throw if there is not enough balance.
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     emit Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   /**
109   * @dev Gets the balance of the specified address.
110   * @param _owner The address to query the the balance of.
111   * @return An uint256 representing the amount owned by the passed address.
112   */
113   function balanceOf(address _owner) public view returns (uint256 balance) {
114     return balances[_owner];
115   }
116 
117 }
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     emit Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     emit Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 /**
215  * @title Ownable
216  * @dev The Ownable contract has an owner address, and provides basic authorization control
217  * functions, this simplifies the implementation of "user permissions".
218  */
219 contract Ownable {
220   address public owner;
221 
222 
223   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
224 
225 
226   /**
227    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228    * account.
229    */
230   constructor() public {
231     owner = msg.sender;
232   }
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(msg.sender == owner);
239     _;
240   }
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) public onlyOwner {
247     require(newOwner != address(0));
248     emit OwnershipTransferred(owner, newOwner);
249     owner = newOwner;
250   }
251 
252 }
253 
254 
255 
256 /**
257  * @title Mintable token
258  * @dev Simple ERC20 Token example, with mintable token creation
259  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
260  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
261  */
262 contract MintableToken is StandardToken, Ownable {
263   event Mint(address indexed to, uint256 amount);
264   event MintFinished();
265 
266   bool public mintingFinished = false;
267 
268 
269   modifier canMint() {
270     require(!mintingFinished);
271     _;
272   }
273 
274   /**
275    * @dev Function to mint tokens
276    * @param _to The address that will receive the minted tokens.
277    * @param _amount The amount of tokens to mint.
278    * @return A boolean that indicates if the operation was successful.
279    */
280   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
281     totalSupply_ = totalSupply_.add(_amount);
282     balances[_to] = balances[_to].add(_amount);
283     emit Mint(_to, _amount);
284     emit Transfer(address(0), _to, _amount);
285     return true;
286   }
287 
288   /**
289    * @dev Function to stop minting new tokens.
290    * @return True if the operation was successful.
291    */
292   function finishMinting() onlyOwner canMint public returns (bool) {
293     mintingFinished = true;
294     emit MintFinished();
295     return true;
296   }
297 }
298 
299 contract TimedCappedMintedCrowdsale is Ownable {
300   using SafeMath for uint256;
301 
302   // The token being sold
303   ERC20 public token;
304 
305   // Address where funds are collected
306   address public wallet;
307 
308   // How many token units a buyer gets per wei
309   uint256 public rate;
310 
311   // Amount of wei raised
312   uint256 public weiRaised;
313 
314   uint256 public openingTime;
315   uint256 public closingTime;
316   uint256 public cap;
317   mapping(address => bool) public whitelist;
318 
319   /**
320    * Event for token purchase logging
321    * @param purchaser who paid for the tokens
322    * @param beneficiary who got the tokens
323    * @param value weis paid for purchase
324    * @param amount amount of tokens purchased
325    */
326   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
327 
328   /**
329    * @param _rate Number of token units a buyer gets per wei
330    * @param _wallet Address where collected funds will be forwarded to
331    * @param _token Address of the token being sold
332    */
333   constructor(uint256 _openingTime, uint256 _closingTime, uint256 _cap, uint256 _rate, address _wallet, ERC20 _token) public {
334     require(_closingTime >= _openingTime);
335     require(_cap > 0);
336     require(_rate > 0);
337     require(_wallet != address(0));
338     require(_token != address(0));   
339     
340     openingTime = _openingTime;
341     closingTime = _closingTime;
342     cap = _cap;
343     rate = _rate;
344     wallet = _wallet;
345     token = _token;    
346   }
347 
348   // -----------------------------------------
349   // Crowdsale external interface
350   // -----------------------------------------
351 
352   /**
353    * @dev fallback function ***DO NOT OVERRIDE***
354    */
355   function () external payable {
356     buyTokens(msg.sender);
357   }
358 
359   /**
360    * @dev Reverts if not in crowdsale time range. 
361    */
362   modifier onlyWhileOpen {
363     //require(now >= openingTime && now <= closingTime);
364     require(now <= closingTime);
365     _;
366   }
367 
368     /**
369    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
370    * @return Whether crowdsale period has elapsed
371    */
372   function hasClosed() public view returns (bool) {
373     return now > closingTime;
374   }
375   
376 
377   /**
378    * @dev Checks whether the cap has been reached. 
379    * @return Whether the cap was reached
380    */
381   function capReached() public view returns (bool) {
382     return weiRaised >= cap;
383   }
384   /**
385    * @dev low level token purchase ***DO NOT OVERRIDE***
386    * @param _beneficiary Address performing the token purchase
387    */
388   function buyTokens(address _beneficiary) public payable {
389 
390     uint256 weiAmount = msg.value;
391     
392     require(_beneficiary != address(0));
393     require(weiAmount != 0);
394     
395     _preValidatePurchase(_beneficiary, weiAmount);
396     
397     
398     // calculate token amount to be created
399     uint256 tokens = _getTokenAmount(weiAmount);
400 
401     // update state
402     weiRaised = weiRaised.add(weiAmount);
403 
404     _processPurchase(_beneficiary, tokens);
405     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
406 
407     //_updatePurchasingState(_beneficiary, weiAmount);
408 
409     _forwardFunds();
410     //_postValidatePurchase(_beneficiary, weiAmount);
411   }
412 
413   // -----------------------------------------
414   // Internal interface (extensible)
415   // -----------------------------------------
416 
417   /**
418    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
419    * @param _beneficiary Address performing the token purchase
420    * @param _weiAmount Value in wei involved in the purchase
421    */
422    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen onlyIfWhitelisted(_beneficiary){
423      require(_beneficiary != address(0));
424      require(_weiAmount != 0);
425      require(weiRaised.add(_weiAmount) <= cap);
426    }
427 
428   /**
429    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
430    */
431   modifier onlyIfWhitelisted(address _beneficiary) {
432     require(whitelist[_beneficiary]);
433     _;
434   }
435 
436   function isWhitelisted(address _beneficiary) public view returns (bool) {
437     return (whitelist[_beneficiary]);
438   }
439 
440   /**
441    * @dev Adds single address to whitelist.
442    * @param _beneficiary Address to be added to the whitelist
443    */
444   function addToWhitelist(address _beneficiary) external onlyOwner {
445     whitelist[_beneficiary] = true;
446   }
447 
448   /**
449    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
450    * @param _beneficiaries Addresses to be added to the whitelist
451    */
452   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
453     for (uint256 i = 0; i < _beneficiaries.length; i++) {
454       whitelist[_beneficiaries[i]] = true;
455     }
456   }
457 
458   /**
459    * @dev Removes single address from whitelist.
460    * @param _beneficiary Address to be removed to the whitelist
461    */
462   function removeFromWhitelist(address _beneficiary) external onlyOwner {
463     whitelist[_beneficiary] = false;
464   }
465 
466   /**
467    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
468    * @param _beneficiary Address performing the token purchase
469    * @param _weiAmount Value in wei involved in the purchase
470    */
471   // function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
472   //   // optional override
473   // }
474 
475   /**
476    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
477    * @param _beneficiary Address performing the token purchase
478    * @param _tokenAmount Number of tokens to be emitted
479    */
480   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
481     //token.transfer(_beneficiary, _tokenAmount);
482     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
483   }
484 
485   /**
486    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
487    * @param _beneficiary Address receiving the tokens
488    * @param _tokenAmount Number of tokens to be purchased
489    */
490   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
491     _deliverTokens(_beneficiary, _tokenAmount);
492   }
493 
494   /**
495    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
496    * @param _beneficiary Address receiving the tokens
497    * @param _weiAmount Value in wei involved in the purchase
498    */
499   // function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
500   //   // optional override
501   // }
502 
503   /**
504    * @dev Override to extend the way in which ether is converted to tokens.
505    * @param _weiAmount Value in wei to be converted into tokens
506    * @return Number of tokens that can be purchased with the specified _weiAmount
507    */
508   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
509     return _weiAmount.mul(rate);
510   }
511 
512   /**
513    * @dev Determines how ETH is stored/forwarded on purchases.
514    */
515   function _forwardFunds() internal {
516     wallet.transfer(msg.value);
517   }
518 }
519 
520 contract FrieseCoinCrowdsale is TimedCappedMintedCrowdsale {
521     constructor
522         (
523             uint256 _openingTime,
524             uint256 _closingTime,
525             uint256 _cap,
526             uint256 _rate,
527             address _wallet,
528             MintableToken _token
529         )
530         TimedCappedMintedCrowdsale(_openingTime, _closingTime, _cap, _rate, _wallet, _token) public{
531 
532         }
533 }