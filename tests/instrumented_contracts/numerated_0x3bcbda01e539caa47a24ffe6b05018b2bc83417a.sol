1 pragma solidity ^0.4.13;
2 
3 contract Crowdsale {
4   using SafeMath for uint256;
5 
6   // The token being sold
7   ERC20 public token;
8 
9   // Address where funds are collected
10   address public wallet;
11 
12   // How many token units a buyer gets per wei
13   uint256 public rate;
14 
15   // Amount of wei raised
16   uint256 public weiRaised;
17 
18   /**
19    * Event for token purchase logging
20    * @param purchaser who paid for the tokens
21    * @param beneficiary who got the tokens
22    * @param value weis paid for purchase
23    * @param amount amount of tokens purchased
24    */
25   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
26 
27   /**
28    * @param _rate Number of token units a buyer gets per wei
29    * @param _wallet Address where collected funds will be forwarded to
30    * @param _token Address of the token being sold
31    */
32   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
33     require(_rate > 0);
34     require(_wallet != address(0));
35     require(_token != address(0));
36 
37     rate = _rate;
38     wallet = _wallet;
39     token = _token;
40   }
41 
42   // -----------------------------------------
43   // Crowdsale external interface
44   // -----------------------------------------
45 
46   /**
47    * @dev fallback function ***DO NOT OVERRIDE***
48    */
49   function () external payable {
50     buyTokens(msg.sender);
51   }
52 
53   /**
54    * @dev low level token purchase ***DO NOT OVERRIDE***
55    * @param _beneficiary Address performing the token purchase
56    */
57   function buyTokens(address _beneficiary) public payable {
58 
59     uint256 weiAmount = msg.value;
60     _preValidatePurchase(_beneficiary, weiAmount);
61 
62     // calculate token amount to be created
63     uint256 tokens = _getTokenAmount(weiAmount);
64 
65     // update state
66     weiRaised = weiRaised.add(weiAmount);
67 
68     _processPurchase(_beneficiary, tokens);
69     emit TokenPurchase(
70       msg.sender,
71       _beneficiary,
72       weiAmount,
73       tokens
74     );
75 
76     _updatePurchasingState(_beneficiary, weiAmount);
77 
78     _forwardFunds();
79     _postValidatePurchase(_beneficiary, weiAmount);
80   }
81 
82   // -----------------------------------------
83   // Internal interface (extensible)
84   // -----------------------------------------
85 
86   /**
87    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
88    * @param _beneficiary Address performing the token purchase
89    * @param _weiAmount Value in wei involved in the purchase
90    */
91   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
92     require(_beneficiary != address(0));
93     require(_weiAmount != 0);
94   }
95 
96   /**
97    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
98    * @param _beneficiary Address performing the token purchase
99    * @param _weiAmount Value in wei involved in the purchase
100    */
101   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
102     // optional override
103   }
104 
105   /**
106    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
107    * @param _beneficiary Address performing the token purchase
108    * @param _tokenAmount Number of tokens to be emitted
109    */
110   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
111     token.transfer(_beneficiary, _tokenAmount);
112   }
113 
114   /**
115    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
116    * @param _beneficiary Address receiving the tokens
117    * @param _tokenAmount Number of tokens to be purchased
118    */
119   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
120     _deliverTokens(_beneficiary, _tokenAmount);
121   }
122 
123   /**
124    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
125    * @param _beneficiary Address receiving the tokens
126    * @param _weiAmount Value in wei involved in the purchase
127    */
128   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
129     // optional override
130   }
131 
132   /**
133    * @dev Override to extend the way in which ether is converted to tokens.
134    * @param _weiAmount Value in wei to be converted into tokens
135    * @return Number of tokens that can be purchased with the specified _weiAmount
136    */
137   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
138     return _weiAmount.mul(rate);
139   }
140 
141   /**
142    * @dev Determines how ETH is stored/forwarded on purchases.
143    */
144   function _forwardFunds() internal {
145     wallet.transfer(msg.value);
146   }
147 }
148 
149 contract AllowanceCrowdsale is Crowdsale {
150   using SafeMath for uint256;
151 
152   address public tokenWallet;
153 
154   /**
155    * @dev Constructor, takes token wallet address.
156    * @param _tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
157    */
158   function AllowanceCrowdsale(address _tokenWallet) public {
159     require(_tokenWallet != address(0));
160     tokenWallet = _tokenWallet;
161   }
162 
163   /**
164    * @dev Checks the amount of tokens left in the allowance.
165    * @return Amount of tokens left in the allowance
166    */
167   function remainingTokens() public view returns (uint256) {
168     return token.allowance(tokenWallet, this);
169   }
170 
171   /**
172    * @dev Overrides parent behavior by transferring tokens from wallet.
173    * @param _beneficiary Token purchaser
174    * @param _tokenAmount Amount of tokens purchased
175    */
176   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
177     token.transferFrom(tokenWallet, _beneficiary, _tokenAmount);
178   }
179 }
180 
181 library SafeMath {
182 
183   /**
184   * @dev Multiplies two numbers, throws on overflow.
185   */
186   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
187     if (a == 0) {
188       return 0;
189     }
190     c = a * b;
191     assert(c / a == b);
192     return c;
193   }
194 
195   /**
196   * @dev Integer division of two numbers, truncating the quotient.
197   */
198   function div(uint256 a, uint256 b) internal pure returns (uint256) {
199     // assert(b > 0); // Solidity automatically throws when dividing by 0
200     // uint256 c = a / b;
201     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202     return a / b;
203   }
204 
205   /**
206   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
207   */
208   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
209     assert(b <= a);
210     return a - b;
211   }
212 
213   /**
214   * @dev Adds two numbers, throws on overflow.
215   */
216   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
217     c = a + b;
218     assert(c >= a);
219     return c;
220   }
221 }
222 
223 contract Ownable {
224   address public owner;
225 
226 
227   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229 
230   /**
231    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
232    * account.
233    */
234   function Ownable() public {
235     owner = msg.sender;
236   }
237 
238   /**
239    * @dev Throws if called by any account other than the owner.
240    */
241   modifier onlyOwner() {
242     require(msg.sender == owner);
243     _;
244   }
245 
246   /**
247    * @dev Allows the current owner to transfer control of the contract to a newOwner.
248    * @param newOwner The address to transfer ownership to.
249    */
250   function transferOwnership(address newOwner) public onlyOwner {
251     require(newOwner != address(0));
252     emit OwnershipTransferred(owner, newOwner);
253     owner = newOwner;
254   }
255 
256 }
257 
258 contract IndividuallyCappedCrowdsale is Crowdsale, Ownable {
259   using SafeMath for uint256;
260 
261   mapping(address => uint256) public contributions;
262   mapping(address => uint256) public caps;
263 
264   /**
265    * @dev Sets a specific user's maximum contribution.
266    * @param _beneficiary Address to be capped
267    * @param _cap Wei limit for individual contribution
268    */
269   function setUserCap(address _beneficiary, uint256 _cap) external onlyOwner {
270     caps[_beneficiary] = _cap;
271   }
272 
273   /**
274    * @dev Sets a group of users' maximum contribution.
275    * @param _beneficiaries List of addresses to be capped
276    * @param _cap Wei limit for individual contribution
277    */
278   function setGroupCap(address[] _beneficiaries, uint256 _cap) external onlyOwner {
279     for (uint256 i = 0; i < _beneficiaries.length; i++) {
280       caps[_beneficiaries[i]] = _cap;
281     }
282   }
283 
284   /**
285    * @dev Returns the cap of a specific user.
286    * @param _beneficiary Address whose cap is to be checked
287    * @return Current cap for individual user
288    */
289   function getUserCap(address _beneficiary) public view returns (uint256) {
290     return caps[_beneficiary];
291   }
292 
293   /**
294    * @dev Returns the amount contributed so far by a sepecific user.
295    * @param _beneficiary Address of contributor
296    * @return User contribution so far
297    */
298   function getUserContribution(address _beneficiary) public view returns (uint256) {
299     return contributions[_beneficiary];
300   }
301 
302   /**
303    * @dev Extend parent behavior requiring purchase to respect the user's funding cap.
304    * @param _beneficiary Token purchaser
305    * @param _weiAmount Amount of wei contributed
306    */
307   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
308     super._preValidatePurchase(_beneficiary, _weiAmount);
309     require(contributions[_beneficiary].add(_weiAmount) <= caps[_beneficiary]);
310   }
311 
312   /**
313    * @dev Extend parent behavior to update user contributions
314    * @param _beneficiary Token purchaser
315    * @param _weiAmount Amount of wei contributed
316    */
317   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
318     super._updatePurchasingState(_beneficiary, _weiAmount);
319     contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
320   }
321 
322 }
323 
324 contract ERC20Basic {
325   function totalSupply() public view returns (uint256);
326   function balanceOf(address who) public view returns (uint256);
327   function transfer(address to, uint256 value) public returns (bool);
328   event Transfer(address indexed from, address indexed to, uint256 value);
329 }
330 
331 contract BasicToken is ERC20Basic {
332   using SafeMath for uint256;
333 
334   mapping(address => uint256) balances;
335 
336   uint256 totalSupply_;
337 
338   /**
339   * @dev total number of tokens in existence
340   */
341   function totalSupply() public view returns (uint256) {
342     return totalSupply_;
343   }
344 
345   /**
346   * @dev transfer token for a specified address
347   * @param _to The address to transfer to.
348   * @param _value The amount to be transferred.
349   */
350   function transfer(address _to, uint256 _value) public returns (bool) {
351     require(_to != address(0));
352     require(_value <= balances[msg.sender]);
353 
354     balances[msg.sender] = balances[msg.sender].sub(_value);
355     balances[_to] = balances[_to].add(_value);
356     emit Transfer(msg.sender, _to, _value);
357     return true;
358   }
359 
360   /**
361   * @dev Gets the balance of the specified address.
362   * @param _owner The address to query the the balance of.
363   * @return An uint256 representing the amount owned by the passed address.
364   */
365   function balanceOf(address _owner) public view returns (uint256) {
366     return balances[_owner];
367   }
368 
369 }
370 
371 contract ERC20 is ERC20Basic {
372   function allowance(address owner, address spender) public view returns (uint256);
373   function transferFrom(address from, address to, uint256 value) public returns (bool);
374   function approve(address spender, uint256 value) public returns (bool);
375   event Approval(address indexed owner, address indexed spender, uint256 value);
376 }
377 
378 contract StandardToken is ERC20, BasicToken {
379 
380   mapping (address => mapping (address => uint256)) internal allowed;
381 
382 
383   /**
384    * @dev Transfer tokens from one address to another
385    * @param _from address The address which you want to send tokens from
386    * @param _to address The address which you want to transfer to
387    * @param _value uint256 the amount of tokens to be transferred
388    */
389   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
390     require(_to != address(0));
391     require(_value <= balances[_from]);
392     require(_value <= allowed[_from][msg.sender]);
393 
394     balances[_from] = balances[_from].sub(_value);
395     balances[_to] = balances[_to].add(_value);
396     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
397     emit Transfer(_from, _to, _value);
398     return true;
399   }
400 
401   /**
402    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
403    *
404    * Beware that changing an allowance with this method brings the risk that someone may use both the old
405    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
406    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
407    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
408    * @param _spender The address which will spend the funds.
409    * @param _value The amount of tokens to be spent.
410    */
411   function approve(address _spender, uint256 _value) public returns (bool) {
412     allowed[msg.sender][_spender] = _value;
413     emit Approval(msg.sender, _spender, _value);
414     return true;
415   }
416 
417   /**
418    * @dev Function to check the amount of tokens that an owner allowed to a spender.
419    * @param _owner address The address which owns the funds.
420    * @param _spender address The address which will spend the funds.
421    * @return A uint256 specifying the amount of tokens still available for the spender.
422    */
423   function allowance(address _owner, address _spender) public view returns (uint256) {
424     return allowed[_owner][_spender];
425   }
426 
427   /**
428    * @dev Increase the amount of tokens that an owner allowed to a spender.
429    *
430    * approve should be called when allowed[_spender] == 0. To increment
431    * allowed value is better to use this function to avoid 2 calls (and wait until
432    * the first transaction is mined)
433    * From MonolithDAO Token.sol
434    * @param _spender The address which will spend the funds.
435    * @param _addedValue The amount of tokens to increase the allowance by.
436    */
437   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
438     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
439     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
440     return true;
441   }
442 
443   /**
444    * @dev Decrease the amount of tokens that an owner allowed to a spender.
445    *
446    * approve should be called when allowed[_spender] == 0. To decrement
447    * allowed value is better to use this function to avoid 2 calls (and wait until
448    * the first transaction is mined)
449    * From MonolithDAO Token.sol
450    * @param _spender The address which will spend the funds.
451    * @param _subtractedValue The amount of tokens to decrease the allowance by.
452    */
453   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
454     uint oldValue = allowed[msg.sender][_spender];
455     if (_subtractedValue > oldValue) {
456       allowed[msg.sender][_spender] = 0;
457     } else {
458       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
459     }
460     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
461     return true;
462   }
463 
464 }
465 
466 contract PrivateSale is AllowanceCrowdsale, IndividuallyCappedCrowdsale {
467     function PrivateSale(
468         address _tokenWallet,
469         address _fundWallet,
470         StandardToken _token
471     ) public
472         Crowdsale(1, _fundWallet, _token)
473         AllowanceCrowdsale(_tokenWallet)
474         IndividuallyCappedCrowdsale()
475     { }
476 
477     function setRate(uint256 _rate) external onlyOwner {
478         rate = _rate;
479     }
480 
481     function getRate() public view returns (uint256) {
482         return rate;
483     }
484 }