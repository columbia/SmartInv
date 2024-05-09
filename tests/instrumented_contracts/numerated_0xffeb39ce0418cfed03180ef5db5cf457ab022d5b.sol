1 pragma solidity 0.4.17;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address internal owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 /**
46  * @title AutoCoinICO
47  * @dev AutoCoinCrowdsale is a base contract for managing a token crowdsale.
48  * Crowdsales have a start and end timestamps, where investors can make
49  * token purchases and the crowdsale will assign them ATC tokens based
50  * on a ATC token per ETH rate. Funds collected are forwarded to a wallet
51  * as they arrive.
52  */
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59   mapping(address => uint256) balances;
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public constant returns (uint256 balance) {
79     return balances[_owner];
80   }
81 }
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) public constant returns (uint256);
88   function transferFrom(address from, address to, uint256 value) public returns (bool);
89   function approve(address spender, uint256 value) public returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100   mapping (address => mapping (address => uint256)) allowed;
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amount of tokens to be transferred
106    */
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     uint256 _allowance = allowed[_from][msg.sender];
110     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111     // require (_value <= _allowance);
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118   /**
119    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
120    *
121    * Beware that changing an allowance with this method brings the risk that someone may use both the old
122    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
123    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
124    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128   function approve(address _spender, uint256 _value) public returns (bool) {
129     allowed[msg.sender][_spender] = _value;
130     Approval(msg.sender, _spender, _value);
131     return true;
132   }
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
140     return allowed[_owner][_spender];
141   }
142   /**
143    * approve should be called when allowed[_spender] == 0. To increment
144    * allowed value is better to use this function to avoid 2 calls (and wait until
145    * the first transaction is mined)
146    * From MonolithDAO Token.sol
147    */
148   function increaseApproval (address _spender, uint _addedValue)
149     returns (bool success) {
150     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152     return true;
153   }
154   function decreaseApproval (address _spender, uint _subtractedValue)
155     returns (bool success) {
156     uint oldValue = allowed[msg.sender][_spender];
157     if (_subtractedValue > oldValue) {
158       allowed[msg.sender][_spender] = 0;
159     } else {
160       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
161     }
162     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163     return true;
164   }
165 }
166 /**
167  * @title Mintable token
168  * @dev Simple ERC20 Token example, with mintable token creation
169  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
170  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
171  */
172 contract MintableToken is StandardToken, Ownable {
173   event Mint(address indexed to, uint256 amount);
174   event MintFinished();
175   bool public mintingFinished = false;
176   modifier canMint() {
177     require(!mintingFinished);
178     _;
179   }
180   /**
181    * @dev Function to mint tokens
182    * @param _to The address that will receive the minted tokens.
183    * @param _amount The amount of tokens to mint.
184    * @return A boolean that indicates if the operation was successful.
185    */
186   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
187     //totalSupply = totalSupply.add(_amount);
188     balances[_to] = balances[_to].add(_amount);
189     Mint(_to, _amount);
190     Transfer(msg.sender, _to, _amount);
191     return true;
192   }
193   /**
194    * @dev Function to stop minting new tokens.
195    * @return True if the operation was successful.
196    */
197   function finishMinting() onlyOwner public returns (bool) {
198     mintingFinished = true;
199     MintFinished();
200     return true;
201   }
202   function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {
203     totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);
204   }
205 }
206 /**
207  * @title Pausable
208  * @dev Base contract which allows children to implement an emergency stop mechanism.
209  */
210 contract Pausable is Ownable {
211   event Pause();
212   event Unpause();
213   bool public paused = false;
214   /**
215    * @dev Modifier to make a function callable only when the contract is not paused.
216    */
217   modifier whenNotPaused() {
218     require(!paused);
219     _;
220   }
221   /**
222    * @dev Modifier to make a function callable only when the contract is paused.
223    */
224   modifier whenPaused() {
225     require(paused);
226     _;
227   }
228   /**
229    * @dev called by the owner to pause, triggers stopped state
230    */
231   function pause() onlyOwner whenNotPaused public {
232     paused = true;
233     Pause();
234   }
235   /**
236    * @dev called by the owner to unpause, returns to normal state
237    */
238   function unpause() onlyOwner whenPaused public {
239     paused = false;
240     Unpause();
241   }
242 }
243 /**
244  * @title AutoCoin Crowdsale
245  * @dev Crowdsale is a base contract for managing a token crowdsale.
246  * Crowdsales have a start and end timestamps, where investors can make
247  * token purchases and the crowdsale will assign them tokens based
248  * on a token per ETH rate. Funds collected are forwarded to a wallet
249  * as they arrive.0
250  */
251 contract Crowdsale is Ownable, Pausable {
252   using SafeMath for uint256;
253   /**
254    *  @MintableToken token - Token Object
255    *  @address wallet - Wallet Address
256    *  @uint8 rate - Tokens per Ether
257    *  @uint256 weiRaised - Total funds raised in Ethers
258   */
259   MintableToken internal token;
260   address internal wallet;
261   uint256 public rate;
262   uint256 internal weiRaised;
263   /**
264    *  @uint256 privateSaleStartTime - Private-Sale Start Time
265    *  @uint256 privateSaleEndTime - Private-Sale End Time
266   */
267   uint256 public privateSaleStartTime;
268   uint256 public privateSaleEndTime;
269   
270   /**
271    *  @uint privateBonus - Private Bonus
272   */
273   uint internal privateSaleBonus;
274   /**
275    *  @uint256 totalSupply - Total supply of tokens 
276    *  @uint256 privateSupply - Total Private Supply from Public Supply
277   */
278   uint256 public totalSupply = SafeMath.mul(400000000, 1 ether);
279   uint256 internal privateSaleSupply = SafeMath.mul(SafeMath.div(totalSupply,100),20);
280   /**
281    *  @bool checkUnsoldTokens - 
282   */
283   bool internal checkUnsoldTokens;
284   /**
285    * event for token purchase logging
286    * @param purchaser who paid for the tokens
287    * @param beneficiary who got the tokens
288    * @param value Wei's paid for purchase
289    * @param amount amount of tokens purchased
290    */
291   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
292   /**
293    * function Crowdsale - Parameterized Constructor
294    * @param _startTime - StartTime of Crowdsale
295    * @param _endTime - EndTime of Crowdsale
296    * @param _rate - Tokens against Ether
297    * @param _wallet - MultiSignature Wallet Address
298    */
299   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) internal {
300     
301     require(_wallet != 0x0);
302     token = createTokenContract();
303     privateSaleStartTime = _startTime;
304     privateSaleEndTime = _endTime;
305     rate = _rate;
306     wallet = _wallet;
307     privateSaleBonus = SafeMath.div(SafeMath.mul(rate,50),100);
308     
309   }
310   /**
311    * function createTokenContract - Mintable Token Created
312    */
313   function createTokenContract() internal returns (MintableToken) {
314     return new MintableToken();
315   }
316   
317   /**
318    * function Fallback - Receives Ethers
319    */
320   function () payable {
321     buyTokens(msg.sender);
322   }
323     /**
324    * function preSaleTokens - Calculate Tokens in PreSale
325    */
326   function privateSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
327         
328     require(privateSaleSupply > 0);
329     tokens = SafeMath.add(tokens, weiAmount.mul(privateSaleBonus));
330     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
331     require(privateSaleSupply >= tokens);
332     privateSaleSupply = privateSaleSupply.sub(tokens);        
333     return tokens;
334   }
335   /**
336   * function buyTokens - Collect Ethers and transfer tokens
337   */
338   function buyTokens(address beneficiary) whenNotPaused public payable {
339     require(beneficiary != 0x0);
340     require(validPurchase());
341     uint256 accessTime = now;
342     uint256 tokens = 0;
343     uint256 weiAmount = msg.value;
344     require((weiAmount >= (100000000000000000)) && (weiAmount <= (20000000000000000000)));
345     if ((accessTime >= privateSaleStartTime) && (accessTime < privateSaleEndTime)) {
346       tokens = privateSaleTokens(weiAmount, tokens);
347     } else {
348       revert();
349     }
350     
351     privateSaleSupply = privateSaleSupply.sub(tokens);
352     weiRaised = weiRaised.add(weiAmount);
353     token.mint(beneficiary, tokens);
354     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
355     forwardFunds();
356   }
357   /**
358    * function forwardFunds - Transfer funds to wallet
359    */
360   function forwardFunds() internal {
361     wallet.transfer(msg.value);
362   }
363   /**
364    * function validPurchase - Checks the purchase is valid or not
365    * @return true - Purchase is withPeriod and nonZero
366    */
367   function validPurchase() internal constant returns (bool) {
368     bool withinPeriod = now >= privateSaleStartTime && now <= privateSaleEndTime;
369     bool nonZeroPurchase = msg.value != 0;
370     return withinPeriod && nonZeroPurchase;
371   }
372   /**
373    * function hasEnded - Checks the ICO ends or not
374    * @return true - ICO Ends
375    */
376   
377   function hasEnded() public constant returns (bool) {
378     return now > privateSaleEndTime;
379   }
380   /** 
381    * function getTokenAddress - Get Token Address 
382    */
383   function getTokenAddress() onlyOwner public returns (address) {
384     return token;
385   }
386 }
387 /**
388  * @title AutoCoin 
389  */
390  
391 contract AutoCoinToken is MintableToken {
392   /**
393    *  @string name - Token Name
394    *  @string symbol - Token Symbol
395    *  @uint8 decimals - Token Decimals
396    *  @uint256 _totalSupply - Token Total Supply
397   */
398   string public constant name = "Auto Coin";
399   string public constant symbol = "Auto Coin";
400   uint8 public constant decimals = 18;
401   uint256 public constant _totalSupply = 400000000 * 1 ether;
402   
403 /** Constructor AutoCoinToken */
404   function AutoCoinToken() {
405     totalSupply = _totalSupply;
406   }
407 }
408 /**
409  * @title SafeMath
410  * @dev Math operations with safety checks that throw on error
411  */
412 library SafeMath {
413   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
414     uint256 c = a * b;
415     assert(a == 0 || c / a == b);
416     return c;
417   }
418   function div(uint256 a, uint256 b) internal constant returns (uint256) {
419     // assert(b > 0); // Solidity automatically throws when dividing by 0
420     uint256 c = a / b;
421     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
422     return c;
423   }
424   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
425     assert(b <= a);
426     return a - b;
427   }
428   function add(uint256 a, uint256 b) internal constant returns (uint256) {
429     uint256 c = a + b;
430     assert(c >= a);
431     return c;
432   }
433 }
434 contract CrowdsaleFunctions is Crowdsale {
435  /** 
436   * function transferAirdropTokens - Transfer private tokens via AirDrop
437   * @param beneficiary address where owner wants to transfer tokens
438   * @param tokens value of token
439   */
440   function transferAirdropTokens(address[] beneficiary, uint256[] tokens) onlyOwner public {
441     for (uint256 i = 0; i < beneficiary.length; i++) {
442       tokens[i] = SafeMath.mul(tokens[i], 1 ether); 
443       require(privateSaleSupply >= tokens[i]);
444       privateSaleSupply = SafeMath.sub(privateSaleSupply, tokens[i]);
445       token.mint(beneficiary[i], tokens[i]);
446     }
447   }
448 /** 
449  *.function transferTokens - Used to transfer tokens to investors who pays us other than Ethers
450  * @param beneficiary - Address where owner wants to transfer tokens
451  * @param tokens -  Number of tokens
452  */
453   function transferTokens(address beneficiary, uint256 tokens) onlyOwner public {
454     require(privateSaleSupply > 0);
455     tokens = SafeMath.mul(tokens,1 ether);
456     require(privateSaleSupply >= tokens);
457     privateSaleSupply = SafeMath.sub(privateSaleSupply, tokens);
458     token.mint(beneficiary, tokens);
459   }
460 }
461 contract AutoCoinICO is Crowdsale, CrowdsaleFunctions {
462   
463     /** Constructor AutoCoinICO */
464     function AutoCoinICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) 
465     Crowdsale(_startTime,_endTime,_rate,_wallet) 
466     {
467         
468     }
469     
470     /** AutoCoinToken Contract */
471     function createTokenContract() internal returns (MintableToken) {
472         return new AutoCoinToken();
473     }
474 }