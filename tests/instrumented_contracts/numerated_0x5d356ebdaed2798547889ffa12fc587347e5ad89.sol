1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract ERC20Basic {
29   uint256 public totalSupply;
30   function balanceOf(address who) public constant returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) public constant returns (uint256);
36   function transferFrom(address from, address to, uint256 value) public returns (bool);
37   function approve(address spender, uint256 value) public returns (bool);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42 
43   mapping(address => uint256) balances;
44 
45   /**
46   * @dev transfer token for a specified address
47   * @param _to The address to transfer to.
48   * @param _value The amount to be transferred.
49   */
50   function transfer(address _to, uint256 _value) public returns (bool) {
51     require(_to != address(0));
52 
53     // SafeMath.sub will throw if there is not enough balance.
54     balances[msg.sender] = balances[msg.sender].sub(_value);
55     balances[_to] = balances[_to].add(_value);
56     Transfer(msg.sender, _to, _value);
57     return true;
58   }
59 
60   /**
61   * @dev Gets the balance of the specified address.
62   * @param _owner The address to query the the balance of.
63   * @return An uint256 representing the amount owned by the passed address.
64   */
65   function balanceOf(address _owner) public constant returns (uint256 balance) {
66     return balances[_owner];
67   }
68 
69 }
70 contract StandardToken is ERC20, BasicToken {
71 
72   mapping (address => mapping (address => uint256)) allowed;
73 
74 
75   /**
76    * @dev Transfer tokens from one address to another
77    * @param _from address The address which you want to send tokens from
78    * @param _to address The address which you want to transfer to
79    * @param _value uint256 the amount of tokens to be transferred
80    */
81   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83 
84     uint256 _allowance = allowed[_from][msg.sender];
85 
86     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
87     // require (_value <= _allowance);
88 
89     balances[_from] = balances[_from].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     allowed[_from][msg.sender] = _allowance.sub(_value);
92     Transfer(_from, _to, _value);
93     return true;
94   }
95 
96   /**
97    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
98    *
99    * Beware that changing an allowance with this method brings the risk that someone may use both the old
100    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
101    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
102    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103    * @param _spender The address which will spend the funds.
104    * @param _value The amount of tokens to be spent.
105    */
106   function approve(address _spender, uint256 _value) public returns (bool) {
107     allowed[msg.sender][_spender] = _value;
108     Approval(msg.sender, _spender, _value);
109     return true;
110   }
111 
112   /**
113    * @dev Function to check the amount of tokens that an owner allowed to a spender.
114    * @param _owner address The address which owns the funds.
115    * @param _spender address The address which will spend the funds.
116    * @return A uint256 specifying the amount of tokens still available for the spender.
117    */
118   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
119     return allowed[_owner][_spender];
120   }
121 
122   /**
123    * approve should be called when allowed[_spender] == 0. To increment
124    * allowed value is better to use this function to avoid 2 calls (and wait until
125    * the first transaction is mined)
126    * From MonolithDAO Token.sol
127    */
128   function increaseApproval (address _spender, uint _addedValue)
129     returns (bool success) {
130     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
131     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135   function decreaseApproval (address _spender, uint _subtractedValue)
136     returns (bool success) {
137     uint oldValue = allowed[msg.sender][_spender];
138     if (_subtractedValue > oldValue) {
139       allowed[msg.sender][_spender] = 0;
140     } else {
141       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
142     }
143     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144     return true;
145   }
146 
147 }
148 contract Ownable {
149   address public owner;
150 
151 
152   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
153 
154 
155   /**
156    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
157    * account.
158    */
159   function Ownable() {
160     owner = msg.sender;
161   }
162 
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172 
173   /**
174    * @dev Allows the current owner to transfer control of the contract to a newOwner.
175    * @param newOwner The address to transfer ownership to.
176    */
177   function transferOwnership(address newOwner) onlyOwner public {
178     require(newOwner != address(0));
179     OwnershipTransferred(owner, newOwner);
180     owner = newOwner;
181   }
182 
183 }
184 contract MintableToken is StandardToken, Ownable {
185   event Mint(address indexed to, uint256 amount);
186   event MintFinished();
187 
188   bool public mintingFinished = false;
189 
190 
191   modifier canMint() {
192     require(!mintingFinished);
193     _;
194   }
195 
196   /**
197    * @dev Function to mint tokens
198    * @param _to The address that will receive the minted tokens.
199    * @param _amount The amount of tokens to mint.
200    * @return A boolean that indicates if the operation was successful.
201    */
202 
203   function mint(address _to, uint256 _amount) 
204   onlyOwner
205   canMint
206   public
207   returns (bool) {
208 
209     totalSupply = totalSupply.add(_amount);
210     balances[_to] = balances[_to].add(_amount);
211     Mint(_to, _amount);
212     Transfer(0x0, _to, _amount);
213     return true;
214   }
215 
216   /**
217    * @dev Function to stop minting new tokens.
218    * @return True if the operation was successful.
219    */
220   function finishMinting() onlyOwner public returns (bool) {
221     mintingFinished = true;
222     MintFinished();
223     return true;
224   }
225 }
226 contract BurnableToken is StandardToken {
227 
228     event Burn(address indexed burner, uint256 value);
229 
230     /**
231      * @dev Burns a specific amount of tokens.
232      * @param _value The amount of token to be burned.
233      */
234     function burn(uint256 _value) public {
235         require(_value > 0);
236 
237         address burner = msg.sender;
238         balances[burner] = balances[burner].sub(_value);
239         totalSupply = totalSupply.sub(_value);
240         Burn(burner, _value);
241     }
242 }
243 contract Crowdsale {
244 
245 
246   using SafeMath for uint256;
247 
248   // The token being sold
249   MintableToken public token;
250 
251   // start and end timestamps where investments are allowed (both inclusive)
252   uint256 public startTime;
253   uint256 public endTime;
254 
255   // address where funds are collected
256   address public wallet;
257 
258   // how many token units a buyer gets per wei
259   uint256 public rate;
260 
261   // amount of raised money in wei
262   uint256 public weiRaised;
263 
264   /**
265    * event for token purchase logging
266    * @param purchaser who paid for the tokens
267    * @param beneficiary who got the tokens
268    * @param value weis paid for purchase
269    * @param amount amount of tokens purchased
270    */
271   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
272 
273   function Crowdsale (uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) {
274     require(_startTime >= now);
275     require(_endTime >= _startTime);
276     require(_rate > 0);
277     require(_wallet != 0x0);
278 
279     token = createTokenContract(_token);
280     startTime = _startTime;
281     endTime = _endTime;
282     rate = _rate;
283     wallet = _wallet;
284   }
285 
286   // creates the token to be sold.
287   // override this method to have crowdsale of a specific mintable token.
288   function createTokenContract(address tokenAddress) internal returns (MintableToken) {
289     return MintableToken(tokenAddress);
290   }
291 
292 
293   // fallback function can be used to buy tokens
294   function () payable {
295     buyTokens(msg.sender);
296   }
297 
298   // low level token purchase function
299   function buyTokens(address beneficiary) public payable {
300     require(beneficiary != 0x0);
301     require(validPurchase());
302 
303     uint256 weiAmount = msg.value;
304 
305     // calculate token amount to be created
306     uint256 tokens = weiAmount.mul(rate);
307 
308     // update state
309     weiRaised = weiRaised.add(weiAmount);
310 
311     token.mint(beneficiary, tokens);
312     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
313 
314     forwardFunds();
315   }
316 
317   // send ether to the fund collection wallet
318   // override to create custom fund forwarding mechanisms
319   function forwardFunds() internal {
320     wallet.transfer(msg.value);
321   }
322 
323   // @return true if the transaction can buy tokens
324   function validPurchase() internal constant returns (bool) {
325     bool withinPeriod = now >= startTime && now <= endTime;
326     bool nonZeroPurchase = msg.value != 0;
327     return withinPeriod && nonZeroPurchase;
328   }
329 
330   // @return true if crowdsale event has ended
331   function hasEnded() public constant returns (bool) {
332     return now > endTime;
333   }
334 
335 
336 }
337 contract FinalizableCrowdsale is Crowdsale, Ownable {
338   using SafeMath for uint256;
339 
340   bool public isFinalized = false;
341 
342   event Finalized();
343 
344   /**
345    * @dev Must be called after crowdsale ends, to do some extra finalization
346    * work. Calls the contract's finalization function.
347    */
348   function finalize() onlyOwner public {
349     require(!isFinalized);
350     require(hasEnded());
351 
352     finalization();
353     Finalized();
354 
355     isFinalized = true;
356   }
357 
358   /**
359    * @dev Can be overridden to add finalization logic. The overriding function
360    * should call super.finalization() to ensure the chain of finalization is
361    * executed entirely.
362    */
363   function finalization() internal {
364   }
365 }
366 contract CappedCrowdsale is Crowdsale {
367   using SafeMath for uint256;
368 
369   uint256 public cap;
370 
371   function CappedCrowdsale(uint256 _cap) {
372     require(_cap > 0);
373     cap = _cap;
374   }
375 
376   // overriding Crowdsale#validPurchase to add extra cap logic
377   // @return true if investors can buy at the moment
378   function validPurchase() internal constant returns (bool) {
379     bool withinCap = weiRaised.add(msg.value) <= cap;
380     return super.validPurchase() && withinCap;
381   }
382 
383   // overriding Crowdsale#hasEnded to add cap logic
384   // @return true if crowdsale event has ended
385   function hasEnded() public constant returns (bool) {
386     bool capReached = weiRaised >= cap;
387     return super.hasEnded() || capReached;
388   }
389 
390 }
391 contract FortitudeRanchCrowdsale is FinalizableCrowdsale, CappedCrowdsale {
392 
393 	function FortitudeRanchCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token)
394 		FinalizableCrowdsale()
395 		CappedCrowdsale(150000000000000000000000)
396 		Crowdsale(_startTime, _endTime, _rate, _wallet, _token)
397 	{
398 	}
399 	function buyTokens(address beneficiary) public payable {
400 	    require(beneficiary != 0x0);
401 	    require(validPurchase());
402 
403 	    uint256 weiAmount = msg.value;
404 
405 	    // calculate token amount to be created
406 	    if(now < (startTime + 1 days)){
407 	    	uint256 discountRate = rate.mul(12000000);
408 	    	discountRate = discountRate.div(10000);
409 	    	uint256 tokens = weiAmount.mul(discountRate).div(1000 ether);
410 	    } else { 
411 	    	 tokens = (weiAmount.mul(rate)).div(1 ether);
412 		}
413 	    // update state
414 	    weiRaised = weiRaised.add(weiAmount);
415 
416 	    token.mint(beneficiary, tokens);
417 	    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
418 
419 	    forwardFunds();
420 	}
421 	function offChainMint(address beneficiary, uint256 tokenAmount)
422 	onlyOwner
423 	{
424 	    require(beneficiary != 0x0);
425 	    bool withinCap = token.totalSupply().add(tokenAmount) <= cap;
426 	    require(withinCap);
427     	token.mint(beneficiary, tokenAmount);
428     	TokenPurchase(msg.sender, beneficiary, 0, tokenAmount);
429 
430 
431 	}
432 	function validPurchase() internal constant returns (bool) {
433 		require(msg.value >= 100000000000000000);
434 	    if(now < (startTime + 1 days)){
435 	    	uint256 discountRate = rate.mul(12000000);
436 	    	discountRate = discountRate.div(10000);
437 	    	uint256 tokens = (msg.value).mul(discountRate).div(1000 ether);
438 	    } else { 
439 	    	 tokens = (msg.value.mul(rate)).div(1 ether);
440 		}
441 		bool withinCap = token.totalSupply().add(tokens) <= cap;
442 		return super.validPurchase() && withinCap;
443 
444 	}
445 	function hasEnded() public constant returns (bool) {
446 		bool capReached = token.totalSupply() >= cap;
447 		return super.hasEnded() || capReached;
448 	}
449 	function finalization() internal {
450 		uint256 tokensAmount = token.totalSupply();
451 		tokensAmount = tokensAmount.mul(2);
452 		tokensAmount = tokensAmount.div(10);
453 		token.mint(0xE746Bb9d6Db2eBBF02c12E2f64D0dfa155377895, tokensAmount);
454 		token.finishMinting();
455 
456 		super.finalization();
457 
458 
459 	}
460 
461 }