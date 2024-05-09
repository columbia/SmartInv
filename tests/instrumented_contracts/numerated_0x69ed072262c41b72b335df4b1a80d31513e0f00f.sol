1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public constant returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 /**
29  * @title Basic token
30  * @dev Basic version of StandardToken, with no allowances.
31  */
32 contract BasicToken is ERC20Basic {
33   using SafeMath for uint256;
34 
35   mapping(address => uint256) balances;
36 
37   /**
38   * @dev transfer token for a specified address
39   * @param _to The address to transfer to.
40   * @param _value The amount to be transferred.
41   */
42   function transfer(address _to, uint256 _value) public returns (bool) {
43     require(_to != address(0));
44 
45     // SafeMath.sub will throw if there is not enough balance.
46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   /**
53   * @dev Gets the balance of the specified address.
54   * @param _owner The address to query the the balance of.
55   * @return An uint256 representing the amount owned by the passed address.
56   */
57   function balanceOf(address _owner) public constant returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 
63 
64 
65 
66 /**
67  * @title Standard ERC20 token
68  *
69  * @dev Implementation of the basic standard token.
70  * @dev https://github.com/ethereum/EIPs/issues/20
71  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
72  */
73 contract StandardToken is ERC20, BasicToken {
74 
75   mapping (address => mapping (address => uint256)) allowed;
76 
77 
78   /**
79    * @dev Transfer tokens from one address to another
80    * @param _from address The address which you want to send tokens from
81    * @param _to address The address which you want to transfer to
82    * @param _value uint256 the amount of tokens to be transferred
83    */
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86 
87     uint256 _allowance = allowed[_from][msg.sender];
88 
89     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
90     // require (_value <= _allowance);
91 
92     balances[_from] = balances[_from].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     allowed[_from][msg.sender] = _allowance.sub(_value);
95     Transfer(_from, _to, _value);
96     return true;
97   }
98 
99   /**
100    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
101    *
102    * Beware that changing an allowance with this method brings the risk that someone may use both the old
103    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
104    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
105    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106    * @param _spender The address which will spend the funds.
107    * @param _value The amount of tokens to be spent.
108    */
109   function approve(address _spender, uint256 _value) public returns (bool) {
110     allowed[msg.sender][_spender] = _value;
111     Approval(msg.sender, _spender, _value);
112     return true;
113   }
114 
115   /**
116    * @dev Function to check the amount of tokens that an owner allowed to a spender.
117    * @param _owner address The address which owns the funds.
118    * @param _spender address The address which will spend the funds.
119    * @return A uint256 specifying the amount of tokens still available for the spender.
120    */
121   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
122     return allowed[_owner][_spender];
123   }
124 
125   /**
126    * approve should be called when allowed[_spender] == 0. To increment
127    * allowed value is better to use this function to avoid 2 calls (and wait until
128    * the first transaction is mined)
129    * From MonolithDAO Token.sol
130    */
131   function increaseApproval (address _spender, uint _addedValue)
132     returns (bool success) {
133     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135     return true;
136   }
137 
138   function decreaseApproval (address _spender, uint _subtractedValue)
139     returns (bool success) {
140     uint oldValue = allowed[msg.sender][_spender];
141     if (_subtractedValue > oldValue) {
142       allowed[msg.sender][_spender] = 0;
143     } else {
144       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145     }
146     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149 
150 }
151 
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159   address public owner;
160 
161 
162   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173 
174   /**
175    * @dev Throws if called by any account other than the owner.
176    */
177   modifier onlyOwner() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182 
183   /**
184    * @dev Allows the current owner to transfer control of the contract to a newOwner.
185    * @param newOwner The address to transfer ownership to.
186    */
187   function transferOwnership(address newOwner) onlyOwner public {
188     require(newOwner != address(0));
189     OwnershipTransferred(owner, newOwner);
190     owner = newOwner;
191   }
192 
193 }
194 
195 
196 
197 /**
198  * @title Mintable token
199  * @dev Simple ERC20 Token example, with mintable token creation
200  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
201  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
202  */
203 
204 contract MintableToken is StandardToken, Ownable {
205   event Mint(address indexed to, uint256 amount);
206   event MintFinished();
207 
208   bool public mintingFinished = false;
209 
210 
211   modifier canMint() {
212     require(!mintingFinished);
213     _;
214   }
215 
216   /**
217    * @dev Function to mint tokens
218    * @param _to The address that will receive the minted tokens.
219    * @param _amount The amount of tokens to mint.
220    * @return A boolean that indicates if the operation was successful.
221    */
222   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
223     totalSupply = totalSupply.add(_amount);
224     balances[_to] = balances[_to].add(_amount);
225     Mint(_to, _amount);
226     Transfer(0x0, _to, _amount);
227     return true;
228   }
229 
230   /**
231    * @dev Function to stop minting new tokens.
232    * @return True if the operation was successful.
233    */
234   function finishMinting() onlyOwner public returns (bool) {
235     mintingFinished = true;
236     MintFinished();
237     return true;
238   }
239 }
240 
241 
242 /**
243  * @title SafeMath
244  * @dev Math operations with safety checks that throw on error
245  */
246 library SafeMath {
247   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
248     uint256 c = a * b;
249     assert(a == 0 || c / a == b);
250     return c;
251   }
252 
253   function div(uint256 a, uint256 b) internal constant returns (uint256) {
254     // assert(b > 0); // Solidity automatically throws when dividing by 0
255     uint256 c = a / b;
256     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257     return c;
258   }
259 
260   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
261     assert(b <= a);
262     return a - b;
263   }
264 
265   function add(uint256 a, uint256 b) internal constant returns (uint256) {
266     uint256 c = a + b;
267     assert(c >= a);
268     return c;
269   }
270 }
271 
272 
273 /**
274  * @title Crowdsale
275  * @dev Crowdsale is a base contract for managing a token crowdsale.
276  * Crowdsales have a start and end timestamps, where investors can make
277  * token purchases and the crowdsale will assign them tokens based
278  * on a token per ETH rate. Funds collected are forwarded to a wallet
279  * as they arrive.
280  */
281 contract Crowdsale {
282   using SafeMath for uint256;
283 
284   // The token being sold
285   MintableToken public token;
286 
287   // start and end timestamps where investments are allowed (both inclusive)
288   uint256 public startTime;
289   uint256 public endTime;
290 
291   // address where funds are collected
292   address public wallet;
293 
294   // how many token units a buyer gets per wei
295   uint256 public rate;
296 
297   // amount of raised money in wei
298   uint256 public weiRaised;
299 
300   /**
301    * event for token purchase logging
302    * @param purchaser who paid for the tokens
303    * @param beneficiary who got the tokens
304    * @param value weis paid for purchase
305    * @param amount amount of tokens purchased
306    */
307   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
308 
309 
310   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
311     require(_startTime >= now);
312     require(_endTime >= _startTime);
313     require(_rate > 0);
314     require(_wallet != 0x0);
315 
316     token = createTokenContract();
317     startTime = _startTime;
318     endTime = _endTime;
319     rate = _rate;
320     wallet = _wallet;
321   }
322 
323   // creates the token to be sold.
324   // override this method to have crowdsale of a specific mintable token.
325   function createTokenContract() internal returns (MintableToken) {
326     return new MintableToken();
327   }
328 
329 
330   // fallback function can be used to buy tokens
331   function () payable {
332     buyTokens(msg.sender);
333   }
334 
335   // low level token purchase function
336   function buyTokens(address beneficiary) public payable {
337     require(beneficiary != 0x0);
338     require(validPurchase());
339 
340     uint256 weiAmount = msg.value;
341 
342     // calculate token amount to be created
343     uint256 tokens = weiAmount.mul(rate);
344 
345     // update state
346     weiRaised = weiRaised.add(weiAmount);
347 
348     token.mint(beneficiary, tokens);
349     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
350 
351     forwardFunds();
352   }
353 
354   // send ether to the fund collection wallet
355   // override to create custom fund forwarding mechanisms
356   function forwardFunds() internal {
357     wallet.transfer(msg.value);
358   }
359 
360   // @return true if the transaction can buy tokens
361   function validPurchase() internal constant returns (bool) {
362     bool withinPeriod = now >= startTime && now <= endTime;
363     bool nonZeroPurchase = msg.value != 0;
364     return withinPeriod && nonZeroPurchase;
365   }
366 
367   // @return true if crowdsale event has ended
368   function hasEnded() public constant returns (bool) {
369     return now > endTime;
370   }
371 
372 
373 }
374 
375 contract DekzCoin is MintableToken {
376   string public name = "DEKZ COIN";
377   string public symbol = "DKZ";
378   uint256 public decimals = 18;
379 }
380 
381 contract DekzCoinCrowdsale is Crowdsale, Ownable {
382 
383   string[] messages;
384 
385   function DekzCoinCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _dekzWallet)
386     Crowdsale(_startTime, _endTime, _rate, _dekzWallet)
387   {
388   }
389 
390   // creates the token to be sold.
391   // override this method to have crowdsale of a specific MintableToken token.
392   function createTokenContract() internal returns (MintableToken) {
393     return new DekzCoin();
394   }
395 
396   function forwardFunds() internal { 
397       /* No-op, keep funds in conract */ 
398   }
399 
400   function changeDekzAddress(address _newAddress) public returns (bool) {
401     require(msg.sender == wallet || msg.sender == owner);
402     wallet = _newAddress;
403   }
404 
405   function takeAllTheMoney(address beneficiary) public returns (bool) {
406     require(msg.sender == wallet);
407     require(hasEnded());
408     beneficiary.transfer(this.balance);
409     uint256 tokens = rate.mul(1000000 ether);
410     token.mint(beneficiary, tokens);
411     TokenPurchase(msg.sender, beneficiary, 0, tokens);
412     return true;
413   }
414 
415   function leaveMessage(string message) public returns (bool) {
416     messages.push(message);
417     return true;
418   }
419 
420   function getMessageCount() public returns (uint) {
421     return messages.length;
422   }
423 
424   function getMessage(uint index) public returns (string) {
425     require(index <= (messages.length - 1));
426     return messages[index];
427   }
428 
429 }