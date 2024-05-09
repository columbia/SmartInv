1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // RubleCoin TokenSale. version 1.0
5 //
6 // Enjoy. (c) Slava Brall / Begemot-Begemot Ltd 2018. The MIT Licence.
7 // ----------------------------------------------------------------------------
8  
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 
81 }
82 /**
83  * @title ERC20Basic
84  * @dev Simpler version of ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/179
86  */
87 contract ERC20Basic {
88   uint256 public totalSupply;
89   function balanceOf(address who) public view returns (uint256);
90   function transfer(address to, uint256 value) public returns (bool);
91   event Transfer(address indexed from, address indexed to, uint256 value);
92 }
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) public view returns (uint256);
100   function transferFrom(address from, address to, uint256 value) public returns (bool);
101   function approve(address spender, uint256 value) public returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   mapping(address => uint256) balances;
113 
114   /**
115   * @dev transfer token for a specified address
116   * @param _to The address to transfer to.
117   * @param _value The amount to be transferred.
118   */
119   function transfer(address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[msg.sender]);
122 
123     // SafeMath.sub will throw if there is not enough balance.
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   /**
131   * @dev Gets the balance of the specified address.
132   * @param _owner The address to query the the balance of.
133   * @return An uint256 representing the amount owned by the passed address.
134   */
135   function balanceOf(address _owner) public view returns (uint256 balance) {
136     return balances[_owner];
137   }
138 
139 }
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) internal allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= allowed[_from][msg.sender]);
161 
162     balances[_from] = balances[_from].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165     Transfer(_from, _to, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179   function approve(address _spender, uint256 _value) public returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191   function allowance(address _owner, address _spender) public view returns (uint256) {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    */
201   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
202     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204     return true;
205   }
206 
207   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 /**
220  * @title Mintable token
221  * @dev Simple ERC20 Token example, with mintable token creation
222  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
223  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
224  */
225 
226 contract MintableToken is StandardToken, Ownable {
227   event Mint(address indexed to, uint256 amount);
228   event MintFinished();
229 
230   bool public mintingFinished = false;
231 
232 
233   modifier canMint() {
234     require(!mintingFinished);
235     _;
236   }
237 
238   /**
239    * @dev Function to mint tokens
240    * @param _to The address that will receive the minted tokens.
241    * @param _amount The amount of tokens to mint.
242    * @return A boolean that indicates if the operation was successful.
243    */
244   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
245     totalSupply = totalSupply.add(_amount);
246     balances[_to] = balances[_to].add(_amount);
247     Mint(_to, _amount);
248     Transfer(address(0), _to, _amount);
249     return true;
250   }
251 
252   /**
253    * @dev Function to stop minting new tokens.
254    * @return True if the operation was successful.
255    */
256   function finishMinting() onlyOwner canMint public returns (bool) {
257     mintingFinished = true;
258     MintFinished();
259     return true;
260   }
261 }
262 
263 //Token parameters
264 
265 contract NationalMoney is MintableToken{
266 	string public constant name = "National Money";
267 	string public constant symbol = "RUBC";
268 	uint public constant decimals = 2;
269 
270 	
271 }
272 
273 /**
274  * @title BetonatorCoinCrowdsale
275  * @dev BetonatorCoinCrowdsale is a base contract for managing a token crowdsale.
276  * Crowdsales have a start and end timestamps, where investors can make
277  * token purchases and the crowdsale will assign them tokens based
278  * on a token per ETH rate. Funds collected are forwarded to an owner
279  * as they arrive.
280  */
281 contract RubleCoinCrowdsale is Ownable {
282   string public constant name = "National Money Contract";
283   using SafeMath for uint256;
284 
285   // The token being sold
286   MintableToken public token;
287 
288   uint256 public startTime = 0;
289   uint256 public discountEndTime = 0;
290   uint256 public endTime = 0;
291   
292   bool public isDiscount = true;
293   bool public isRunning = false;
294   
295   address public fundAddress = 0;
296   
297   address public fundAddress2 = 0;
298 
299   // rate is how many ETH cost 10000 packs of 2500 RUBC. 
300   //rate approximately equals 10000 * 400/ (ETH in RUB). It's always an integer!
301   //for example if ETH costs 1100 USD, USD costs 56 RUB, and we want 2500 RUBC cost 400 RUB
302   //2500 RUBC = 400 / (56 *1100) = 0,00649... so we should set rate = 65
303   uint256 public rate;
304 
305   // amount of raised money in wei
306   uint256 public weiRaised;
307   
308   string public contractStatus = "Not started";
309   
310   uint public tokensMinted = 0;
311   
312   uint public minimumSupply = 2500; //minimum token amount to sale at one transaction
313 
314   event TokenPurchase(address indexed purchaser, uint256 value, uint integer_value, uint256 amount, uint integer_amount, uint256 tokensMinted);
315 
316 
317   function RubleCoinCrowdsale(uint256 _rate, address _fundAddress, address _fundAddress2) public {
318     require(_rate > 0);
319 	require (_rate < 1000);
320 
321     token = createTokenContract();
322     startTime = now;
323 	
324     rate = _rate;
325 	fundAddress = _fundAddress;
326 	fundAddress2 = _fundAddress2;
327 	
328 	contractStatus = "Sale with discount";
329 	isDiscount = true;
330 	isRunning = true;
331   }
332   
333   function setRate(uint _rate) public onlyOwner {
334 	  require (isRunning);
335 
336 	  require (_rate > 0);
337 	  require (_rate <=1000);
338 	  rate = _rate;
339   }
340   
341     function fullPriceStage() public onlyOwner {
342 	  require (isRunning);
343 
344 	  isDiscount = false;
345 	  discountEndTime = now;
346 	  contractStatus = "Full price sale";
347   }
348 
349     function finishCrowdsale() public onlyOwner {
350 	  require (isRunning);
351 
352 	  isRunning = false;
353 	  endTime = now;
354 	  contractStatus = "Crowdsale is finished";
355 	  
356   }
357 
358   function createTokenContract() internal returns (NationalMoney) {
359     return new NationalMoney();
360   }
361 
362 
363   // fallback function can be used to buy tokens
364   function () external payable {
365 	require(isRunning);
366 	
367     buyTokens();
368   }
369 
370   // low level token purchase function
371   function buyTokens() public payable {
372     require(validPurchase());
373     require (isRunning);
374 
375     uint256 weiAmount = msg.value;
376 
377 	uint minWeiAmount = rate.mul(10 ** 18).div(10000); // should be additional mul 10
378 	if (isDiscount) {
379 		minWeiAmount = minWeiAmount.mul(3).div(4);
380 	}
381 	
382 	uint tokens = weiAmount.mul(2500).div(minWeiAmount).mul(100);
383 	uint tokensToOwner = tokens.mul(11).div(10000);
384 
385     
386     weiRaised = weiRaised.add(weiAmount);
387 
388     token.mint(msg.sender, tokens);
389 	token.mint(owner, tokensToOwner);
390 	
391 	tokensMinted = tokensMinted.add(tokens);
392 	tokensMinted = tokensMinted.add(tokensToOwner);
393     TokenPurchase(msg.sender, weiAmount, weiAmount.div(10**14), tokens, tokens.div(10**2), tokensMinted);
394 
395     forwardFunds();
396   }
397   
398 
399   function forwardFunds() internal {
400 	uint toOwner = msg.value.div(100);
401 	uint toFund = msg.value.mul(98).div(100);
402 	
403     owner.transfer(toOwner);
404 	fundAddress.transfer(toFund);
405 	fundAddress2.transfer(toOwner);
406 	
407   }
408   
409 
410   // @return true if the transaction can buy tokens
411   function validPurchase() internal view returns (bool) {
412     bool withinPeriod = startTime > 0;
413 	
414 	uint minAmount = (rate - 1).mul(10 ** 18).div(10000); //check the correctness!
415 	if (isDiscount) {
416 		minAmount = minAmount.mul(3).div(4);
417 	}
418 	bool validAmount = msg.value > minAmount;
419 		
420     return withinPeriod && validAmount;
421   }
422 
423 
424 }