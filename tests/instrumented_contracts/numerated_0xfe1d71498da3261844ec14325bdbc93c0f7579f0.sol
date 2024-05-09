1 pragma solidity ^0.4.21;
2 
3 // File: source\openzeppelin-solidity\contracts\math\SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
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
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: source\openzeppelin-solidity\contracts\ownership\Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92   /**
93    * @dev Allows the current owner to relinquish control of the contract.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 }
100 
101 // File: source\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/179
107  */
108 contract ERC20Basic {
109   function totalSupply() public view returns (uint256);
110   function balanceOf(address who) public view returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 // File: source\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
116 
117 /**
118  * @title Basic token
119  * @dev Basic version of StandardToken, with no allowances.
120  */
121 contract BasicToken is ERC20Basic {
122   using SafeMath for uint256;
123 
124   mapping(address => uint256) balances;
125 
126   uint256 totalSupply_;
127 
128   /**
129   * @dev total number of tokens in existence
130   */
131   function totalSupply() public view returns (uint256) {
132     return totalSupply_;
133   }
134 
135   /**
136   * @dev transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     balances[msg.sender] = balances[msg.sender].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     emit Transfer(msg.sender, _to, _value);
147     return true;
148   }
149 
150   /**
151   * @dev Gets the balance of the specified address.
152   * @param _owner The address to query the the balance of.
153   * @return An uint256 representing the amount owned by the passed address.
154   */
155   function balanceOf(address _owner) public view returns (uint256) {
156     return balances[_owner];
157   }
158 
159 }
160 
161 // File: source\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
162 
163 /**
164  * @title ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/20
166  */
167 contract ERC20 is ERC20Basic {
168   function allowance(address owner, address spender) public view returns (uint256);
169   function transferFrom(address from, address to, uint256 value) public returns (bool);
170   function approve(address spender, uint256 value) public returns (bool);
171   event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 // File: source\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
175 
176 /**
177  * @title Standard ERC20 token
178  *
179  * @dev Implementation of the basic standard token.
180  * @dev https://github.com/ethereum/EIPs/issues/20
181  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract StandardToken is ERC20, BasicToken {
184 
185   mapping (address => mapping (address => uint256)) internal allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195     require(_to != address(0));
196     require(_value <= balances[_from]);
197     require(_value <= allowed[_from][msg.sender]);
198 
199     balances[_from] = balances[_from].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
202     emit Transfer(_from, _to, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
208    *
209    * Beware that changing an allowance with this method brings the risk that someone may use both the old
210    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
211    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
212    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) public returns (bool) {
217     allowed[msg.sender][_spender] = _value;
218     emit Approval(msg.sender, _spender, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Function to check the amount of tokens that an owner allowed to a spender.
224    * @param _owner address The address which owns the funds.
225    * @param _spender address The address which will spend the funds.
226    * @return A uint256 specifying the amount of tokens still available for the spender.
227    */
228   function allowance(address _owner, address _spender) public view returns (uint256) {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    *
235    * approve should be called when allowed[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _addedValue The amount of tokens to increase the allowance by.
241    */
242   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
243     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248   /**
249    * @dev Decrease the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
259     uint oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue > oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269 }
270 
271 // File: source\CappedMintableToken.sol
272 
273 /**
274  * @title Mintable token with an end-of-mint mechanism and token cap
275  * Based on openzeppelin-solidity MintableToken & CappedToken
276  */
277 contract CappedMintableToken is StandardToken, Ownable {
278   using SafeMath for uint256;
279 
280   event Mint(address indexed to, uint256 amount);
281 
282   modifier canMint() {
283     require(mintEnabled);
284     _;
285   }
286 
287   modifier onlyOwnerOrCrowdsale() {
288     require(msg.sender == owner || msg.sender == crowdsale);
289     _;
290   }
291 
292   bool public mintEnabled;
293   bool public transferEnabled;
294   uint256 public cap;
295   address public crowdsale;
296   
297 
298 	function setCrowdsale(address _crowdsale) public onlyOwner {
299 		crowdsale = _crowdsale;
300 	}
301 
302   function CappedMintableToken(uint256 _cap) public {    
303     require(_cap > 0);
304 
305     mintEnabled = true;
306     transferEnabled = false;
307     cap = _cap;
308   }
309 
310   /**
311    * @dev Function to mint tokens
312    * @param _to The address that will receive the minted tokens.
313    * @param _amount The amount of tokens to mint.
314    * @return A boolean that indicates if the operation was successful.
315    */
316   function mint(address _to, uint256 _amount) onlyOwnerOrCrowdsale canMint public returns (bool) {
317     require(totalSupply_.add(_amount) <= cap);
318     require(_amount > 0);
319 
320     totalSupply_ = totalSupply_.add(_amount);
321     balances[_to] = balances[_to].add(_amount);
322     Mint(_to, _amount);
323     Transfer(address(0), _to, _amount);
324     return true;
325   }
326 
327   
328   function transfer(address _to, uint256 _value) public returns (bool) {
329     require(transferEnabled);
330 
331     return super.transfer(_to, _value);
332   }
333 
334   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
335     require(transferEnabled);
336 
337     return super.transferFrom(_from, _to, _value);
338   }
339   
340 }
341 
342 // File: source\GMBCTokenBuyable.sol
343 
344 contract GMBCTokenBuyable is CappedMintableToken {  
345   bool public payableEnabled; // payable function enabled
346   uint256 public minPurchase; // minimum purchase in wei
347 
348   function () external payable {    
349     buyTokens(msg.sender);
350   }
351 
352   function setPayableEnabled(bool _payableEnabled) onlyOwner external {
353     payableEnabled = _payableEnabled;
354   }
355 
356   function setMinPurchase(uint256 _minPurchase) onlyOwner external {
357     minPurchase = _minPurchase;
358   }
359 
360   function buyTokens(address _beneficiary) public payable {
361     require(payableEnabled);
362 
363     uint256 weiAmount = msg.value;
364     require(_beneficiary != address(0));
365     require(weiAmount >= minPurchase);
366 
367     // calculate token amount to be created
368     uint256 tokens = getTokenAmount(weiAmount);
369     mint(_beneficiary, tokens);
370   }
371 
372   function getTokenAmount(uint256 _weiAmount) public view returns (uint256);
373 
374    /**
375    * @dev Transfer all Ether held by the contract to the owner.
376    */
377   function claimEther(uint256 _weiAmount) external onlyOwner {    
378     owner.transfer(_weiAmount);
379   }
380 }
381 
382 // File: source\openzeppelin-solidity\contracts\ownership\HasNoEther.sol
383 
384 /**
385  * @title Contracts that should not own Ether
386  * @author Remco Bloemen <remco@2π.com>
387  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
388  * in the contract, it will allow the owner to reclaim this ether.
389  * @notice Ether can still be sent to this contract by:
390  * calling functions labeled `payable`
391  * `selfdestruct(contract_address)`
392  * mining directly to the contract address
393  */
394 contract HasNoEther is Ownable {
395 
396   /**
397   * @dev Constructor that rejects incoming Ether
398   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
399   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
400   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
401   * we could use assembly to access msg.value.
402   */
403   function HasNoEther() public payable {
404     require(msg.value == 0);
405   }
406 
407   /**
408    * @dev Disallows direct send by settings a default function without the `payable` flag.
409    */
410   function() external {
411   }
412 
413   /**
414    * @dev Transfer all Ether held by the contract to the owner.
415    */
416   function reclaimEther() external onlyOwner {
417     owner.transfer(this.balance);
418   }
419 }
420 
421 // File: source\GMBCToken.sol
422 
423 contract GMBCToken is GMBCTokenBuyable {
424 	using SafeMath for uint256;
425 
426 	string public constant name = "Gamblica Token";
427 	string public constant symbol = "GMBC";
428 	uint8 public constant decimals = 18;
429 
430 	bool public finalized = false;
431 	uint8 public bonus = 0;				// bonus value in % (0 - 100)
432 	uint256 public basePrice = 10000;	// base GMBC per 1 ETH
433 
434 	/**
435 	 * GMBCToken
436 	 * https://gamblica.com 
437 	 * Official Gamblica Coin (Token)
438 	 */
439 	function GMBCToken() public 
440 		CappedMintableToken( 600000000 * (10 ** uint256(decimals)) ) // 60%, 40% will be minted on finalize
441 	{}
442 
443 	/**
444 	 * Sets current bonus (%)
445 	 */
446 	function setBonus(uint8 _bonus) onlyOwnerOrCrowdsale external {		
447 		require(_bonus >= 0 && _bonus <= 100);
448 		bonus = _bonus;
449 	}
450 
451 	function setBasePrice(uint256 _basePrice) onlyOwner external {
452 		require(_basePrice > 0);
453 		basePrice = _basePrice;
454 	}
455 
456 	/**
457 	 * Returns token amount for wei investment
458 	 */
459 	function getTokenAmount(uint256 _weiAmount) public view returns (uint256) {		
460 		require(decimals == 18);
461 		uint256 gmbc = _weiAmount.mul(basePrice);
462 		return gmbc.add(gmbc.mul(bonus).div(100));
463 	}
464 
465 	/**
466 		Performs the final stage of the token sale, 
467 		mints additional 40% of token fund,
468 		transfers minted tokens to an external fund
469 		(20% game fund, 10% team, 5% advisory board, 3% bounty, 2% founders)
470 	*/
471 	function finalize(address _fund) public onlyOwner returns (bool) {
472 		require(!finalized);		
473 		require(_fund != address(0));
474 
475 		uint256 amount = totalSupply_.mul(4).div(6);	// +40% 
476 
477 		totalSupply_ = totalSupply_.add(amount);
478     	balances[_fund] = balances[_fund].add(amount);
479     	emit Mint(_fund, amount);
480     	emit Transfer(address(0), _fund, amount);
481     
482 		mintEnabled = false;
483 		transferEnabled = true;
484 		finalized = true;
485 
486 		return true;
487 	}
488 
489 
490 	
491 }