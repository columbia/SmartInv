1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title Basic token
19  * @dev Basic version of StandardToken, with no allowances.
20  */
21 contract BasicToken is ERC20Basic {
22   using SafeMath for uint256;
23 
24   mapping(address => uint256) balances;
25 
26   /**
27   * @dev transfer token for a specified address
28   * @param _to The address to transfer to.
29   * @param _value The amount to be transferred.
30   */
31   function transfer(address _to, uint256 _value) public returns (bool) {
32     require(_to != address(0));
33 
34     // SafeMath.sub will throw if there is not enough balance.
35     balances[msg.sender] = balances[msg.sender].sub(_value);
36     balances[_to] = balances[_to].add(_value);
37     Transfer(msg.sender, _to, _value);
38     return true;
39   }
40 
41   /**
42   * @dev Gets the balance of the specified address.
43   * @param _owner The address to query the the balance of.
44   * @return An uint256 representing the amount owned by the passed address.
45   */
46   function balanceOf(address _owner) public constant returns (uint256 balance) {
47     return balances[_owner];
48   }
49 
50 }
51 
52 /**
53  * @title ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/20
55  */
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public constant returns (uint256);
58   function transferFrom(address from, address to, uint256 value) public returns (bool);
59   function approve(address spender, uint256 value) public returns (bool);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 
64 /**
65  * @title Standard ERC20 token
66  *
67  * @dev Implementation of the basic standard token.
68  * @dev https://github.com/ethereum/EIPs/issues/20
69  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
70  */
71 contract StandardToken is ERC20, BasicToken {
72 
73   mapping (address => mapping (address => uint256)) allowed;
74 
75 
76   /**
77    * @dev Transfer tokens from one address to another
78    * @param _from address The address which you want to send tokens from
79    * @param _to address The address which you want to transfer to
80    * @param _value uint256 the amount of tokens to be transferred
81    */
82   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84 
85     uint256 _allowance = allowed[_from][msg.sender];
86 
87     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
88     // require (_value <= _allowance);
89 
90     balances[_from] = balances[_from].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     allowed[_from][msg.sender] = _allowance.sub(_value);
93     Transfer(_from, _to, _value);
94     return true;
95   }
96 
97   /**
98    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
99    *
100    * Beware that changing an allowance with this method brings the risk that someone may use both the old
101    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
102    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
103    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104    * @param _spender The address which will spend the funds.
105    * @param _value The amount of tokens to be spent.
106    */
107   function approve(address _spender, uint256 _value) public returns (bool) {
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   /**
114    * @dev Function to check the amount of tokens that an owner allowed to a spender.
115    * @param _owner address The address which owns the funds.
116    * @param _spender address The address which will spend the funds.
117    * @return A uint256 specifying the amount of tokens still available for the spender.
118    */
119   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
120     return allowed[_owner][_spender];
121   }
122 
123   /**
124    * approve should be called when allowed[_spender] == 0. To increment
125    * allowed value is better to use this function to avoid 2 calls (and wait until
126    * the first transaction is mined)
127    * From MonolithDAO Token.sol
128    */
129   function increaseApproval (address _spender, uint _addedValue)
130     returns (bool success) {
131     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
132     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136   function decreaseApproval (address _spender, uint _subtractedValue)
137     returns (bool success) {
138     uint oldValue = allowed[msg.sender][_spender];
139     if (_subtractedValue > oldValue) {
140       allowed[msg.sender][_spender] = 0;
141     } else {
142       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
143     }
144     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148 }
149 
150 /**
151  * @title Ownable
152  * @dev The Ownable contract has an owner address, and provides basic authorization control
153  * functions, this simplifies the implementation of "user permissions".
154  */
155 contract Ownable {
156   address public owner;
157 
158 
159   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161 
162   /**
163    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
164    * account.
165    */
166   function Ownable() {
167     owner = msg.sender;
168   }
169 
170 
171   /**
172    * @dev Throws if called by any account other than the owner.
173    */
174   modifier onlyOwner() {
175     require(msg.sender == owner);
176     _;
177   }
178 
179 
180   /**
181    * @dev Allows the current owner to transfer control of the contract to a newOwner.
182    * @param newOwner The address to transfer ownership to.
183    */
184   function transferOwnership(address newOwner) onlyOwner public {
185     require(newOwner != address(0));
186     OwnershipTransferred(owner, newOwner);
187     owner = newOwner;
188   }
189 
190 }
191 
192 
193 
194 
195 /**
196  * @title Mintable token
197  * @dev Simple ERC20 Token example, with mintable token creation
198  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
199  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
200  */
201 
202 contract MintableToken is StandardToken, Ownable {
203   event Mint(address indexed to, uint256 amount);
204   event MintFinished();
205 
206   bool public mintingFinished = false;
207 
208 
209   modifier canMint() {
210     require(!mintingFinished);
211     _;
212   }
213 
214   /**
215    * @dev Function to mint tokens
216    * @param _to The address that will receive the minted tokens.
217    * @param _amount The amount of tokens to mint.
218    * @return A boolean that indicates if the operation was successful.
219    */
220   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
221     totalSupply = totalSupply.add(_amount);
222     balances[_to] = balances[_to].add(_amount);
223     Mint(_to, _amount);
224     Transfer(0x0, _to, _amount);
225     return true;
226   }
227 
228   /**
229    * @dev Function to stop minting new tokens.
230    * @return True if the operation was successful.
231    */
232   function finishMinting() onlyOwner public returns (bool) {
233     mintingFinished = true;
234     MintFinished();
235     return true;
236   }
237 }
238 
239 contract PKCT is MintableToken {
240   string public name = "PackageCoin Presale1";
241   string public symbol = "PKCT";
242   uint256 public decimals = 18;
243 }
244 
245 
246 
247 /**
248  * @title SafeMath
249  * @dev Math operations with safety checks that throw on error
250  */
251 library SafeMath {
252   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
253     uint256 c = a * b;
254     assert(a == 0 || c / a == b);
255     return c;
256   }
257 
258   function div(uint256 a, uint256 b) internal constant returns (uint256) {
259     // assert(b > 0); // Solidity automatically throws when dividing by 0
260     uint256 c = a / b;
261     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
262     return c;
263   }
264 
265   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
266     assert(b <= a);
267     return a - b;
268   }
269 
270   function add(uint256 a, uint256 b) internal constant returns (uint256) {
271     uint256 c = a + b;
272     assert(c >= a);
273     return c;
274   }
275 }
276 
277 
278 /**
279  * @title Crowdsale
280  * @dev Crowdsale is a base contract for managing a token crowdsale.
281  * Crowdsales have a start and end timestamps, where investors can make
282  * token purchases and the crowdsale will assign them tokens based
283  * on a token per ETH rate. Funds collected are forwarded to a wallet
284  * as they arrive.
285  */
286 contract Crowdsale {
287   using SafeMath for uint256;
288 
289   // The token being sold
290   MintableToken public token;
291 
292   // start and end timestamps where investments are allowed (both inclusive)
293   uint256 public startTime;
294   uint256 public endTime;
295 
296   // address where funds are collected
297   address public wallet;
298 
299   // how many token units a buyer gets per wei
300   uint256 public rate;
301 
302   // amount of raised money in wei
303   uint256 public weiRaised;
304 
305   /**
306    * event for token purchase logging
307    * @param purchaser who paid for the tokens
308    * @param beneficiary who got the tokens
309    * @param value weis paid for purchase
310    * @param amount amount of tokens purchased
311    */
312   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
313 
314 
315   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
316     require(_startTime >= now);
317     require(_endTime >= _startTime);
318     require(_rate > 0);
319     require(_wallet != 0x0);
320 
321     token = createTokenContract();
322     startTime = _startTime;
323     endTime = _endTime;
324     rate = _rate;
325     wallet = _wallet;
326   }
327 
328   // creates the token to be sold.
329   // override this method to have crowdsale of a specific mintable token.
330   function createTokenContract() internal returns (MintableToken) {
331     return new MintableToken();
332   }
333 
334 
335   // fallback function can be used to buy tokens
336   function () payable {
337     buyTokens(msg.sender);
338   }
339 
340   // low level token purchase function
341   function buyTokens(address beneficiary) public payable {
342     require(beneficiary != 0x0);
343     require(validPurchase());
344 
345     uint256 weiAmount = msg.value;
346 
347     // calculate token amount to be created
348     uint256 tokens = weiAmount.mul(rate);
349 
350     // update state
351     weiRaised = weiRaised.add(weiAmount);
352 
353     token.mint(beneficiary, tokens);
354     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
355 
356     forwardFunds();
357   }
358 
359   // send ether to the fund collection wallet
360   // override to create custom fund forwarding mechanisms
361   function forwardFunds() internal {
362     wallet.transfer(msg.value);
363   }
364 
365   // @return true if the transaction can buy tokens
366   function validPurchase() internal constant returns (bool) {
367     bool withinPeriod = now >= startTime && now <= endTime;
368     bool nonZeroPurchase = msg.value != 0;
369     return withinPeriod && nonZeroPurchase;
370   }
371 
372   // @return true if crowdsale event has ended
373   function hasEnded() public constant returns (bool) {
374     return now > endTime;
375   }
376 
377 
378 }
379 
380 
381 
382 /**
383  * @title CappedCrowdsale
384  * @dev Extension of Crowdsale with a max amount of funds raised
385  */
386 contract CappedCrowdsale is Crowdsale {
387   using SafeMath for uint256;
388 
389   uint256 public cap;
390 
391   function CappedCrowdsale(uint256 _cap) {
392     require(_cap > 0);
393     cap = _cap;
394   }
395 
396   // overriding Crowdsale#validPurchase to add extra cap logic
397   // @return true if investors can buy at the moment
398   function validPurchase() internal constant returns (bool) {
399     bool withinCap = weiRaised.add(msg.value) <= cap;
400     return super.validPurchase() && withinCap;
401   }
402 
403   // overriding Crowdsale#hasEnded to add cap logic
404   // @return true if crowdsale event has ended
405   function hasEnded() public constant returns (bool) {
406     bool capReached = weiRaised >= cap;
407     return super.hasEnded() || capReached;
408   }
409 
410 }
411 
412 
413 
414 
415 contract PackageCoinPresaleOne is Crowdsale, CappedCrowdsale {
416 
417   function PackageCoinPresaleOne(uint256 _startTime, uint256 _endTime) 
418     Crowdsale(_startTime,
419               _endTime,
420               362,                                          // rate: PKCT per Ether
421               0xB787A746ac38140b419bF1E94C0913BDc18bb445)   // wallet address
422     CappedCrowdsale(20000 ether)
423   {
424   }
425 
426   // creates the token to be sold.
427   // override this method to have crowdsale of a specific MintableToken token.
428   function createTokenContract() internal returns (MintableToken) {
429     return new PKCT();
430   }
431 
432 }