1 pragma solidity ^0.4.15;
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
19   address public owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() {
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
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a * b;
52     assert(a == 0 || c / a == b);
53     return c;
54   }
55   function div(uint256 a, uint256 b) internal constant returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 /**
72  * @title Crowdsale
73  * @dev Crowdsale is a base contract for managing a token crowdsale.
74  * Crowdsales have a start and end timestamps, where investors can make
75  * token purchases and the crowdsale will assign them tokens based
76  * on a token per ETH rate. Funds collected are forwarded to a wallet
77  * as they arrive.
78  */
79 contract Crowdsale {
80   using SafeMath for uint256;
81   // The token being sold
82 //  MintableToken public token;
83   address public tokenAddr;
84   TestTokenA public testTokenA;
85   // start and end timestamps where investments are allowed (both inclusive)
86   uint256 public startTime;
87   uint256 public endTime;
88   // address where funds are collected
89   address public wallet;
90   // how many token units a buyer gets per wei
91   uint256 public rate;
92   // amount of raised money in wei
93   uint256 public weiRaised;
94   /**
95    * event for token purchase logging
96    * @param purchaser who paid for the tokens
97    * @param beneficiary who got the tokens
98    * @param value weis paid for purchase
99    * @param amount amount of tokens purchased
100    */
101   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
102   function Crowdsale(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
103     require(_startTime >= now);
104     require(_endTime >= _startTime);
105     require(_rate > 0);
106     require(_wallet != 0x0);
107     require(_tokenAddress != 0x0);
108 //    createTokenContract(_tokenAddress);
109 //    createTokenContract();
110     tokenAddr = _tokenAddress;
111     startTime = _startTime;
112     endTime = _endTime;
113     rate = _rate;
114     wallet = _wallet;
115   }
116   // creates the token to be sold.
117   // override this method to have crowdsale of a specific mintable token.
118 //  function createTokenContract() internal returns (MintableToken) {
119 //      return new TestTokenA();
120 ////    return MintableToken(_tokenAddress);
121 //  }
122   // fallback function can be used to buy tokens
123   function () payable {
124     buyTokens(msg.sender);
125   }
126   // low level token purchase function
127   function buyTokens(address beneficiary) public payable {
128     require(beneficiary != 0x0);
129     require(validPurchase());
130     uint256 weiAmount = msg.value;
131     // calculate token amount to be created
132     uint256 tokens = weiAmount.mul(rate);
133     // update state
134     weiRaised = weiRaised.add(weiAmount);
135 //    token.mint(beneficiary, tokens);
136 //    bytes4 methodId = bytes4(keccak256("mint(address,uint256)"));
137 //    tokenAddr.call(methodId, beneficiary, tokens);
138     testTokenA = TestTokenA(tokenAddr);
139     testTokenA.mint(beneficiary, tokens);
140     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
141     forwardFunds();
142   }
143   // send ether to the fund collection wallet
144   // override to create custom fund forwarding mechanisms
145   function forwardFunds() internal {
146     wallet.transfer(msg.value);
147   }
148   // @return true if the transaction can buy tokens
149   function validPurchase() internal constant returns (bool) {
150     bool withinPeriod = now >= startTime && now <= endTime;
151     bool nonZeroPurchase = msg.value != 0;
152     return withinPeriod && nonZeroPurchase;
153   }
154   // @return true if crowdsale event has ended
155   function hasEnded() public constant returns (bool) {
156     return now > endTime;
157   }
158 }
159 /**
160  * @title CappedCrowdsale
161  * @dev Extension of Crowdsale with a max amount of funds raised
162  */
163 contract CappedCrowdsale is Crowdsale {
164   using SafeMath for uint256;
165   uint256 public cap;
166   function CappedCrowdsale(uint256 _cap) {
167     require(_cap > 0);
168     cap = _cap;
169   }
170   // overriding Crowdsale#validPurchase to add extra cap logic
171   // @return true if investors can buy at the moment
172   function validPurchase() internal constant returns (bool) {
173     bool withinCap = weiRaised.add(msg.value) <= cap;
174     return super.validPurchase() && withinCap;
175   }
176   // overriding Crowdsale#hasEnded to add cap logic
177   // @return true if crowdsale event has ended
178   function hasEnded() public constant returns (bool) {
179     bool capReached = weiRaised >= cap;
180     return super.hasEnded() || capReached;
181   }
182 }
183 /**
184  * @title Destructible
185  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
186  */
187 contract Destructible is Ownable {
188   function Destructible() payable { }
189   /**
190    * @dev Transfers the current balance to the owner and terminates the contract.
191    */
192   function destroy() onlyOwner public {
193     selfdestruct(owner);
194   }
195   function destroyAndSend(address _recipient) onlyOwner public {
196     selfdestruct(_recipient);
197   }
198 }
199 /**
200  * @title Pausable
201  * @dev Base contract which allows children to implement an emergency stop mechanism.
202  */
203 contract Pausable is Ownable {
204   event Pause();
205   event Unpause();
206   bool public paused = false;
207   /**
208    * @dev Modifier to make a function callable only when the contract is not paused.
209    */
210   modifier whenNotPaused() {
211     require(!paused);
212     _;
213   }
214   /**
215    * @dev Modifier to make a function callable only when the contract is paused.
216    */
217   modifier whenPaused() {
218     require(paused);
219     _;
220   }
221   /**
222    * @dev called by the owner to pause, triggers stopped state
223    */
224   function pause() onlyOwner whenNotPaused public {
225     paused = true;
226     Pause();
227   }
228   /**
229    * @dev called by the owner to unpause, returns to normal state
230    */
231   function unpause() onlyOwner whenPaused public {
232     paused = false;
233     Unpause();
234   }
235 }
236 /**
237  * @title Basic token
238  * @dev Basic version of StandardToken, with no allowances.
239  */
240 contract BasicToken is ERC20Basic {
241   using SafeMath for uint256;
242   mapping(address => uint256) balances;
243   /**
244   * @dev transfer token for a specified address
245   * @param _to The address to transfer to.
246   * @param _value The amount to be transferred.
247   */
248   function transfer(address _to, uint256 _value) public returns (bool) {
249     require(_to != address(0));
250     // SafeMath.sub will throw if there is not enough balance.
251     balances[msg.sender] = balances[msg.sender].sub(_value);
252     balances[_to] = balances[_to].add(_value);
253     Transfer(msg.sender, _to, _value);
254     return true;
255   }
256   /**
257   * @dev Gets the balance of the specified address.
258   * @param _owner The address to query the the balance of.
259   * @return An uint256 representing the amount owned by the passed address.
260   */
261   function balanceOf(address _owner) public constant returns (uint256 balance) {
262     return balances[_owner];
263   }
264 }
265 /**
266  * @title ERC20 interface
267  * @dev see https://github.com/ethereum/EIPs/issues/20
268  */
269 contract ERC20 is ERC20Basic {
270   function allowance(address owner, address spender) public constant returns (uint256);
271   function transferFrom(address from, address to, uint256 value) public returns (bool);
272   function approve(address spender, uint256 value) public returns (bool);
273   event Approval(address indexed owner, address indexed spender, uint256 value);
274 }
275 /**
276  * @title Standard ERC20 token
277  *
278  * @dev Implementation of the basic standard token.
279  * @dev https://github.com/ethereum/EIPs/issues/20
280  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
281  */
282 contract StandardToken is ERC20, BasicToken {
283   mapping (address => mapping (address => uint256)) allowed;
284   /**
285    * @dev Transfer tokens from one address to another
286    * @param _from address The address which you want to send tokens from
287    * @param _to address The address which you want to transfer to
288    * @param _value uint256 the amount of tokens to be transferred
289    */
290   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
291     require(_to != address(0));
292     uint256 _allowance = allowed[_from][msg.sender];
293     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
294     // require (_value <= _allowance);
295     balances[_from] = balances[_from].sub(_value);
296     balances[_to] = balances[_to].add(_value);
297     allowed[_from][msg.sender] = _allowance.sub(_value);
298     Transfer(_from, _to, _value);
299     return true;
300   }
301   /**
302    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
303    *
304    * Beware that changing an allowance with this method brings the risk that someone may use both the old
305    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
306    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
307    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
308    * @param _spender The address which will spend the funds.
309    * @param _value The amount of tokens to be spent.
310    */
311   function approve(address _spender, uint256 _value) public returns (bool) {
312     allowed[msg.sender][_spender] = _value;
313     Approval(msg.sender, _spender, _value);
314     return true;
315   }
316   /**
317    * @dev Function to check the amount of tokens that an owner allowed to a spender.
318    * @param _owner address The address which owns the funds.
319    * @param _spender address The address which will spend the funds.
320    * @return A uint256 specifying the amount of tokens still available for the spender.
321    */
322   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
323     return allowed[_owner][_spender];
324   }
325   /**
326    * approve should be called when allowed[_spender] == 0. To increment
327    * allowed value is better to use this function to avoid 2 calls (and wait until
328    * the first transaction is mined)
329    * From MonolithDAO Token.sol
330    */
331   function increaseApproval (address _spender, uint _addedValue)
332     returns (bool success) {
333     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
334     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337   function decreaseApproval (address _spender, uint _subtractedValue)
338     returns (bool success) {
339     uint oldValue = allowed[msg.sender][_spender];
340     if (_subtractedValue > oldValue) {
341       allowed[msg.sender][_spender] = 0;
342     } else {
343       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
344     }
345     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
346     return true;
347   }
348 }
349 /**
350  * @title Mintable token
351  * @dev Simple ERC20 Token example, with mintable token creation
352  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
353  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
354  */
355 contract MintableToken is StandardToken, Ownable {
356   event Mint(address indexed to, uint256 amount);
357   event MintFinished();
358   bool public mintingFinished = false;
359   modifier canMint() {
360     require(!mintingFinished);
361     _;
362   }
363   /**
364    * @dev Function to mint tokens
365    * @param _to The address that will receive the minted tokens.
366    * @param _amount The amount of tokens to mint.
367    * @return A boolean that indicates if the operation was successful.
368    */
369 //  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
370   function mint(address _to, uint256 _amount) public returns (bool) {
371     totalSupply = totalSupply.add(_amount);
372     balances[_to] = balances[_to].add(_amount);
373     Mint(_to, _amount);
374     Transfer(0x0, _to, _amount);
375     return true;
376   }
377   /**
378    * @dev Function to stop minting new tokens.
379    * @return True if the operation was successful.
380    */
381   function finishMinting() onlyOwner public returns (bool) {
382     mintingFinished = true;
383     MintFinished();
384     return true;
385   }
386 }
387 contract TestTokenA is MintableToken {
388   string public constant name = "TestTokenA";
389   string public constant symbol = "ZNX";
390   uint8 public constant decimals = 18;
391   uint256 public constant initialSupply = 65000000 * (10 ** uint256(decimals));    // number of tokens in reserve
392   /*
393    * gives msg.sender all of existing tokens.
394    */
395   function TestTokenA() {
396     totalSupply = initialSupply;
397     balances[msg.sender] = initialSupply;
398   }
399 }
400 contract TestTokenAICO1 is CappedCrowdsale, Destructible, Pausable {
401   function TestTokenAICO1(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet)
402     CappedCrowdsale(_cap)
403     Crowdsale(_tokenAddress, _startTime, _endTime, _rate, _wallet)
404   {
405   }
406 }