1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23 
24   modifier onlyOwner(){
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner public {
34     if (newOwner != address(0)) {
35       owner = newOwner;
36     }
37   }
38 }
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public constant returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
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
63 /**
64  * @title SafeMath
65  * @dev Math operations with safety checks that throw on error
66  */
67 library SafeMath {
68   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a * b;
70     assert(a == 0 || c / a == b);
71     return c;
72   }
73 
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75     // assert(b > 0); // Solidity automatically throws when dividing by 0
76     uint256 c = a / b;
77     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78     return c;
79   }
80 
81   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82     assert(b <= a);
83     return a - b;
84   }
85 
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105     * @param _value The amount to be transferred.
106       */
107   function transfer(address _to, uint256 _value) public returns (bool){
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117     * @return An uint256 representing the amount owned by the passed address.
118     */
119   function balanceOf(address _owner) public constant returns (uint256 balance) {
120     return balances[_owner];
121   }
122 }
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132   mapping (address => mapping (address => uint256)) internal allowed;
133 
134   /**
135   * @dev Transfer tokens from one address to another
136   * @param _from address The address which you want to send tokens from
137   * @param _to address The address which you want to transfer to
138   * @param _value uint256 the amout of tokens to be transfered
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     balances[_to] = balances[_to].add(_value);
143     balances[_from] = balances[_from].sub(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
151   * @param _spender The address which will spend the funds.
152   * @param _value The amount of tokens to be spent.
153    */
154   function approve(address _spender, uint256 _value) public returns (bool) {
155 
156     // To change the approve amount you first have to reduce the addresses`
157     //  allowance to zero by calling `approve(_spender, 0)` if it is not
158     //  already 0 to mitigate the race condition described here:
159     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167   * @dev Function to check the amount of tokens that an owner allowed to a spender.
168   * @param _owner address The address which owns the funds.
169     * @param _spender address The address which will spend the funds.
170     * @return A uint256 specifing the amount of tokens still avaible for the spender.
171    */
172 
173   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
174     return allowed[_owner][_spender];
175   }
176 }
177 
178 /**
179  * @title Mintable token
180  * @dev Simple ERC20 Token example, with mintable token creation
181  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
182  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
183  */
184 contract MintableToken is StandardToken, Ownable {
185 
186   event Mint(address indexed to, uint256 amount);
187   event MintFinished();
188 
189   bool public mintingFinished = false;
190 
191   modifier canMint() {
192     require(!mintingFinished);
193     _;
194   }
195 
196   /**
197   * @dev Function to mint tokens
198   * @param _to The address that will recieve the minted tokens.
199     * @param _amount The amount of tokens to mint.
200     * @return A boolean that indicates if the operation was successful.
201    */
202   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
203     totalSupply = totalSupply.add(_amount);
204     balances[_to] = balances[_to].add(_amount);
205     Transfer(0X0, _to, _amount);
206     return true;
207   }
208 
209   /**
210   * @dev Function to stop minting new tokens.
211   * @return True if the operation was successful.
212    */
213   function finishMinting() onlyOwner public returns (bool) {
214     mintingFinished = true;
215     MintFinished();
216     return true;
217   }
218 }
219 
220 contract FidentiaXToken is MintableToken {
221   // Coin Properties
222   string public name = "fidentiaX";
223   string public symbol = "fdX";
224   uint256 public decimals = 18;
225 
226   // Special propeties
227   bool public tradingStarted = false;
228 
229   /**
230   * @dev modifier that throws if trading has not started yet
231    */
232   modifier hasStartedTrading() {
233     require(tradingStarted);
234     _;
235   }
236 
237   /**
238   * @dev Allows the owner to enable the trading. This can not be undone
239   */
240   function startTrading() public onlyOwner {
241     tradingStarted = true;
242   }
243 
244   /**
245   * @dev Allows anyone to transfer the Change tokens once trading has started
246   * @param _to the recipient address of the tokens.
247   * @param _value number of tokens to be transfered.
248    */
249   function transfer(address _to, uint _value) hasStartedTrading public returns (bool) {
250     return super.transfer(_to, _value);
251   }
252 
253   /**
254   * @dev Allows anyone to transfer the Change tokens once trading has started
255   * @param _from address The address which you want to send tokens from
256   * @param _to address The address which you want to transfer to
257   * @param _value uint the amout of tokens to be transfered
258    */
259   function transferFrom(address _from, address _to, uint _value) hasStartedTrading public returns (bool) {
260     return super.transferFrom(_from, _to, _value);
261   }
262 
263   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
264     oddToken.transfer(owner, amount);
265   }
266 }
267 
268 
269 
270 contract FidentiaXTokenSale is Ownable {
271 
272   using SafeMath for uint256;
273 
274   // The token being sold
275   FidentiaXToken public token;
276 
277   uint256 public decimals;  
278 
279   uint256 public oneCoin;
280 
281   // start and end block where investments are allowed (both inclusive)
282   uint256 public startTimestamp;
283   uint256 public endTimestamp;
284 
285   // timestamps for tiers
286   uint256 public tier1Timestamp;
287   uint256 public tier2Timestamp;
288 
289   // address where funds are collected
290 
291   address public multiSig;
292 
293   function setWallet(address _newWallet) public onlyOwner {
294     multiSig = _newWallet;
295   }
296 
297   // These will be set by setTier()
298 
299   uint256 public rate; // how many token units a buyer gets per wei
300 
301   uint256 public minContribution = 0.0001 ether;  // minimum contributio to participate in tokensale
302 
303   uint256 public maxContribution = 200000 ether;  // default limit to tokens that the users can buy
304 
305   // ***************************
306   // amount of raised money in wei
307 
308   uint256 public weiRaised;
309 
310   // amount of raised tokens 
311 
312   uint256 public tokenRaised;
313 
314   // maximum amount of tokens being created
315 
316   uint256 public maxTokens;
317 
318   // maximum amount of tokens for sale
319 
320   uint256 public tokensForSale;  // 24 Million Tokens for SALE
321 
322   // number of participants in presale
323 
324   uint256 public numberOfPurchasers = 0;
325 
326   //  for whitelist
327   address public cs;
328   //  for whitelist AND placement
329   address public fx;
330 
331   // switch on/off the authorisation , default: true - on
332 
333   bool    public freeForAll = false;
334 
335   mapping (address => bool) public authorised; // just to annoy the heck out of americans
336 
337   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
338 
339   event SaleClosed();
340 
341   function FidentiaXTokenSale() public {
342     startTimestamp = 1509930000; //  Monday November 06, 2017 09:00:00 (am) in time zone Asia/Singapore (SGT)
343     //1508684400;
344     endTimestamp = 1512489599;   //  December 05, 2017 23:59:59 (pm) in time zone Asia/Singapore (SGT) ( GMT +08:00 )
345     tier1Timestamp = 1510102799; //   November 08, 2017 08:59:59 (am) in time zone Asia/Singapore (SGT)
346     tier2Timestamp = 1510361999; //   November 11, 2017 08:59:59 (am) in time zone Asia/Singapore (SGT)
347     token = new FidentiaXToken();
348     decimals = token.decimals();
349     oneCoin = 10 ** decimals;
350     maxTokens = 130 * (10**6) * oneCoin;
351     tokensForSale = 130 * (10**6) * oneCoin;
352   }
353 
354   /**
355   * @dev Calculates the amount of bonus coins the buyer gets
356    */
357   function getRateAt(uint256 at) internal constant returns (uint256) {
358     if (at < (tier1Timestamp))
359       return 575;
360     if (at < (tier2Timestamp))
361       return 550;
362     return 500;
363   }
364 
365   // @return true if crowdsale event has ended
366   function hasEnded() public constant returns (bool) {
367     if (now > endTimestamp)
368       return true;
369     if (tokenRaised >= tokensForSale)
370       return true; // if we reach the tokensForSale
371     return false;
372   }
373 
374   /**
375   * @dev throws if person sending is not contract owner or cs role
376    */
377   modifier onlyCSorFx() {
378     require((msg.sender == fx) || (msg.sender==cs));
379     _;
380   }
381 
382   modifier onlyFx() {
383     require(msg.sender == fx);
384     _;
385   }
386 
387   /**
388   * @dev throws if person sending is not authorised or sends nothing
389   */
390   modifier onlyAuthorised() {
391     require (authorised[msg.sender] || freeForAll);
392     require (now >= startTimestamp);
393     require (!(hasEnded()));
394     require (multiSig != 0x0);
395     require (msg.value > 1 finney);
396     require(tokensForSale > tokenRaised); // check we are not over the number of tokensForSale
397     _;
398   }
399 
400   /**
401   * @dev authorise an account to participate
402   */
403   function authoriseAccount(address whom) onlyCSorFx public {
404     authorised[whom] = true;
405   }
406 
407   /**
408   * @dev authorise a lot of accounts in one go
409   */
410   function authoriseManyAccounts(address[] many) onlyCSorFx public {
411     for (uint256 i = 0; i < many.length; i++) {
412       authorised[many[i]] = true;
413     }
414   }
415 
416   /**
417   * @dev ban an account from participation (default)
418   */
419   function blockAccount(address whom) onlyCSorFx public {
420     authorised[whom] = false;
421   }
422 
423   /**
424   * @dev set a new CS representative
425   */
426   function setCS(address newCS) onlyOwner public {
427     cs = newCS;
428   }
429 
430   /**
431   * @dev set a new Fx representative
432   */
433   function setFx(address newFx) onlyOwner public {
434     fx = newFx;
435   }
436 
437   function placeTokens(address beneficiary, uint256 _tokens) onlyFx public {
438     //check minimum and maximum amount
439     require(_tokens != 0);
440     require(!hasEnded());
441     uint256 amount = 0;
442     if (token.balanceOf(beneficiary) == 0) {
443       numberOfPurchasers++;
444     }
445     tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over
446     token.mint(beneficiary, _tokens);
447     TokenPurchase(beneficiary, beneficiary, amount, _tokens);
448   }
449 
450   // low level token purchase function
451   function buyTokens(address beneficiary, uint256 amount) onlyAuthorised internal {
452     //check minimum and maximum amount
453     require(amount >= minContribution);
454     require(amount <= maxContribution);
455 
456     // Calculate token amount to be purchased
457     uint256 actualRate = getRateAt(now);
458     uint256 tokens = amount.mul(actualRate);
459 
460     // update state
461     weiRaised = weiRaised.add(amount);
462     if (token.balanceOf(beneficiary) == 0) {
463       numberOfPurchasers++;
464     }
465     tokenRaised = tokenRaised.add(tokens); // so we can go slightly over
466     token.mint(beneficiary, tokens);
467     TokenPurchase(beneficiary, beneficiary, amount, tokens);
468     multiSig.transfer(this.balance); // better in case any other ether ends up here
469   }
470 
471   // transfer ownership of the token to the owner of the presale contract
472   function finishSale() public onlyOwner {
473     require(hasEnded());
474     // assign the rest of the 100M tokens to the reserve
475     uint unassigned;
476     if(maxTokens > tokenRaised) {
477       unassigned  = maxTokens.sub(tokenRaised);
478       token.mint(multiSig,unassigned);
479     }
480     token.finishMinting();
481     token.transferOwnership(owner);
482     SaleClosed();
483   }
484 
485   // fallback function can be used to buy tokens
486   function () public payable {
487     buyTokens(msg.sender, msg.value);
488   }
489 
490   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
491     oddToken.transfer(owner, amount);
492   }
493 }