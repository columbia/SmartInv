1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174 }
175 
176 /**
177  * @title Ownable
178  * @dev The Ownable contract has an owner address, and provides basic authorization control
179  * functions, this simplifies the implementation of "user permissions".
180  */
181 contract Ownable {
182   address public owner;
183 
184 
185   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187 
188   /**
189    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
190    * account.
191    */
192   function Ownable() public {
193     owner = msg.sender;
194   }
195 
196 
197   /**
198    * @dev Throws if called by any account other than the owner.
199    */
200   modifier onlyOwner() {
201     require(msg.sender == owner);
202     _;
203   }
204 
205 
206   /**
207    * @dev Allows the current owner to transfer control of the contract to a newOwner.
208    * @param newOwner The address to transfer ownership to.
209    */
210   function transferOwnership(address newOwner) public onlyOwner {
211     require(newOwner != address(0));
212     OwnershipTransferred(owner, newOwner);
213     owner = newOwner;
214   }
215 
216 }
217 
218 /**
219  * @title Mintable token
220  * @dev Simple ERC20 Token example, with mintable token creation
221  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
222  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
223  */
224 
225 contract MintableToken is StandardToken, Ownable {
226   event Mint(address indexed to, uint256 amount);
227   event MintFinished();
228 
229   bool public mintingFinished = false;
230 
231 
232   modifier canMint() {
233     require(!mintingFinished);
234     _;
235   }
236 
237   /**
238    * @dev Function to mint tokens
239    * @param _to The address that will receive the minted tokens.
240    * @param _amount The amount of tokens to mint.
241    * @return A boolean that indicates if the operation was successful.
242    */
243   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
244     totalSupply = totalSupply.add(_amount);
245     balances[_to] = balances[_to].add(_amount);
246     Mint(_to, _amount);
247     Transfer(address(0), _to, _amount);
248     return true;
249   }
250 
251   /**
252    * @dev Function to stop minting new tokens.
253    * @return True if the operation was successful.
254    */
255   function finishMinting() onlyOwner canMint public returns (bool) {
256     mintingFinished = true;
257     MintFinished();
258     return true;
259   }
260 }
261 
262 contract RDT is MintableToken {
263   string public name = "Rate Date Token";
264   string public symbol = "RDT";
265   uint8 public decimals = 18;
266   /* 50 000 000 cap for RDT tokens */
267   uint256 public cap = 50000000000000000000000000;
268   /* freeze transfer until 15 Apr 2018 */
269   uint256 transferFreezeUntil = 1523793600;
270   /* End mint 28 Mar 2018(ICO end date) */
271   uint256 endMint = 1522260000;
272   /* freeze team tokens until Mar 2019 */
273   uint256 teamFreeze = 1551398400;
274   address public teamWallet = 0x52853f8189482C059ceA50F5BcFf849FcA311a2A;
275 
276 
277   function RDT() public
278   {
279     uint256 teamTokens = 7500000000000000000000000;
280     uint256 bonusTokens = 2500000000000000000000000;
281     address bonusWallet = 0x9D1Ed168DfD0FdeB78dEa2e25F51E4E77b75315c;
282     uint256 reserveTokens = 3000000000000000000000000;
283     address reserveWallet = 0x997BFceD5B2c1ffce76c953E22AFC3c6af6c497F;
284     mint(teamWallet,teamTokens);
285     mint(bonusWallet,bonusTokens);
286     mint(reserveWallet,reserveTokens);
287   }
288 
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool){
290     require(endMint >= now);
291     require(totalSupply.add(_amount) <= cap);
292     return super.mint(_to, _amount);
293   }
294 
295   modifier notFrozen(){
296     require(transferFreezeUntil <= now);
297     if(msg.sender==teamWallet){
298       require(now >= teamFreeze);
299     }
300     _;
301   }
302 
303   function transfer(address _to, uint256 _value) notFrozen public returns (bool) {
304     return super.transfer(_to, _value);
305   }
306 
307   function transferFrom(address _from, address _to, uint256 _value) notFrozen public returns (bool){
308     return super.transferFrom(_from, _to, _value);
309   }
310 }
311 
312 /**
313  * @title Crowdsale
314  * @dev Crowdsale is a base contract for managing a token crowdsale.
315  * Crowdsales have a start and end timestamps, where investors can make
316  * token purchases and the crowdsale will assign them tokens based
317  * on a token per ETH rate. Funds collected are forwarded to a wallet
318  * as they arrive.
319  */
320 contract Crowdsale {
321   using SafeMath for uint256;
322 
323   // The token being sold
324   MintableToken public token;
325 
326   // start and end timestamps where investments are allowed (both inclusive)
327   uint256 public startTime;
328   uint256 public endTime;
329 
330   // address where funds are collected
331   address public wallet;
332 
333   // how many token units a buyer gets per wei
334   uint256 public rate;
335 
336   // amount of raised money in wei
337   uint256 public weiRaised;
338 
339   /**
340    * event for token purchase logging
341    * @param purchaser who paid for the tokens
342    * @param beneficiary who got the tokens
343    * @param value weis paid for purchase
344    * @param amount amount of tokens purchased
345    */
346   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
347 
348 
349   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
350     require(_startTime >= now);
351     require(_endTime >= _startTime);
352     require(_rate > 0);
353     require(_wallet != address(0));
354 
355     token = createTokenContract();
356     startTime = _startTime;
357     endTime = _endTime;
358     rate = _rate;
359     wallet = _wallet;
360   }
361 
362   // creates the token to be sold.
363   // override this method to have crowdsale of a specific mintable token.
364   function createTokenContract() internal returns (MintableToken) {
365     return new MintableToken();
366   }
367 
368 
369   // fallback function can be used to buy tokens
370   function () external payable {
371     buyTokens(msg.sender);
372   }
373 
374   // Override this method to have a way to add business logic to your crowdsale when buying
375   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
376     return weiAmount.mul(rate);
377   }
378 
379   // low level token purchase function
380   function buyTokens(address beneficiary) public payable {
381     require(beneficiary != address(0));
382     require(validPurchase());
383 
384     uint256 weiAmount = msg.value;
385 
386     // calculate token amount to be created
387     uint256 tokens = getTokenAmount(weiAmount);
388 
389     // update state
390     weiRaised = weiRaised.add(weiAmount);
391 
392     token.mint(beneficiary, tokens);
393     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
394 
395     forwardFunds();
396   }
397 
398   // send ether to the fund collection wallet
399   // override to create custom fund forwarding mechanisms
400   function forwardFunds() internal {
401     wallet.transfer(msg.value);
402   }
403 
404   // @return true if the transaction can buy tokens
405   function validPurchase() internal view returns (bool) {
406     bool withinPeriod = now >= startTime && now <= endTime;
407     bool nonZeroPurchase = msg.value != 0;
408     return withinPeriod && nonZeroPurchase;
409   }
410 
411   // @return true if crowdsale event has ended
412   function hasEnded() public view returns (bool) {
413     return now > endTime;
414   }
415 
416 
417 }
418 
419 /**
420  * @title CappedCrowdsale
421  * @dev Extension of Crowdsale with a max amount of funds raised
422  */
423 contract CappedCrowdsale is Crowdsale {
424   using SafeMath for uint256;
425 
426   uint256 public cap;
427 
428   function CappedCrowdsale(uint256 _cap) public {
429     require(_cap > 0);
430     cap = _cap;
431   }
432 
433   // overriding Crowdsale#validPurchase to add extra cap logic
434   // @return true if investors can buy at the moment
435   function validPurchase() internal view returns (bool) {
436     bool withinCap = weiRaised.add(msg.value) <= cap;
437     return super.validPurchase() && withinCap;
438   }
439 
440   // overriding Crowdsale#hasEnded to add cap logic
441   // @return true if crowdsale event has ended
442   function hasEnded() public view returns (bool) {
443     bool capReached = weiRaised >= cap;
444     return super.hasEnded() || capReached;
445   }
446 
447 }
448 
449 contract PreSale is CappedCrowdsale, Ownable{
450   uint256 public minAmount = 1 ether/10;
451 
452   function PreSale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet) public
453     CappedCrowdsale(_cap)
454     Crowdsale(_startTime, _endTime, _rate, _wallet)
455   {
456   }
457   function validPurchase() internal view returns (bool){
458     bool overMinAmount = msg.value >= minAmount;
459     return super.validPurchase() && overMinAmount;
460   }
461   function createTokenContract() internal returns (MintableToken) {
462     return new RDT();
463   }
464   function startICO(address contractICO) onlyOwner public returns(bool){
465     require(now > endTime);
466     token.transferOwnership(contractICO);
467     return true;
468   }
469 }