1 pragma solidity ^0.4.17;
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
220 contract DeBuNeToken is MintableToken {
221   // Coin Properties
222   string public name = "DeBuNe";
223   string public symbol = "DBN";
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
268 contract DeBuNETokenSale is Ownable {
269 
270   using SafeMath for uint256;
271 
272   // The token being sold
273   DeBuNeToken public token;
274 
275   uint256 public decimals;  
276 
277   uint256 public oneCoin;
278 
279   // start and end block where investments are allowed (both inclusive)
280   uint256 public startTimestamp;
281   uint256 public endTimestamp;
282 
283   // timestamps for tiers
284   uint256 public tier1Timestamp;
285   uint256 public tier2Timestamp;
286   uint256 public tier3Timestamp;
287 
288   // address where funds are collected
289 
290   address public HardwareWallet;
291 
292   function setWallet(address _newWallet) public onlyOwner {
293     HardwareWallet = _newWallet;
294   }
295 
296   // These will be set by setTier()
297 
298   uint256 public rate; // how many token units a buyer gets per wei
299 
300   uint256 public minContribution;  // minimum contributio to participate in tokensale
301 
302   uint256 public maxContribution;  // default limit to tokens that the users can buy
303 
304   // ***************************
305   // amount of raised money in wei
306 
307   uint256 public weiRaised;
308 
309   // amount of raised tokens 
310 
311   uint256 public tokenRaised;
312 
313   // maximum amount of tokens being created
314 
315   uint256 public maxTokens;
316 
317   // maximum amount of tokens for sale
318 
319   uint256 public tokensForSale;  // 40 Million Tokens for SALE
320 
321   // number of participants in presale
322 
323   uint256 public numberOfPurchasers = 0;
324 
325   //  for whitelist
326   address public cs;
327   //  for whitelist AND placement
328   address public Admin;
329 
330   // switch on/off the authorisation , default: true - on
331 
332   bool    public freeForAll = false;
333 
334   mapping (address => bool) public authorised; // just to annoy the heck out of americans
335 
336   event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
337 
338   event SaleClosed();
339 
340  function DeBuNETokenSale() public {
341     startTimestamp = 1521126000; //   2018/03/15 15:00 GMT
342     endTimestamp =  1525046400;   //  2018/04/30 00:00 GMT
343     tier1Timestamp = 1522454400; //  2018/03/31 00:00 GMT
344     tier2Timestamp = 1523750400; //  2018/04/15 00:00 GMT
345     tier3Timestamp = 1525046400; //  2018/04/30 00:00 GMT
346 
347 
348 
349 // *************************************
350 
351     HardwareWallet = 0xf651e2409120f1FbB0e47812d759e883b5B68A60;
352 
353 //**************************************    
354 
355     token = new DeBuNeToken();
356     decimals = token.decimals();
357     oneCoin = 10 ** decimals;
358     maxTokens = 100 * (10**6) * oneCoin;  // max number of tokens what we will create
359     tokensForSale = 40 * (10**6) * oneCoin; // max number of tokens what we want to sell now
360 
361 }
362     /**
363   * @dev Calculates the amount of bonus coins the buyer gets
364    */
365   function getRateAt(uint256 at) internal returns (uint256) {
366     if (at < (tier1Timestamp))
367       return 100;
368       minContribution = 50 ether;  
369       maxContribution = 5000 ether;
370     if (at < (tier2Timestamp))
371       return 67;
372       minContribution = 25 ether;
373       maxContribution = 2500 ether;
374      if (at < (tier3Timestamp))
375       return 50;
376       minContribution = 1 ether;
377       maxContribution = 100 ether;
378     return 40;
379   }
380 
381   // @return true if crowdsale event has ended
382   function hasEnded() public constant returns (bool) {
383     if (now > endTimestamp)
384       return true;
385     if (tokenRaised >= tokensForSale)
386       return true; // if we reach the tokensForSale
387     return false;
388  }
389 
390   /**
391   * @dev throws if person sending is not contract owner or cs role
392    */
393   modifier onlyCSorAdmin() {
394     require((msg.sender == Admin) || (msg.sender==cs));
395     _;
396   }
397   modifier onlyAdmin() {
398     require(msg.sender == Admin);
399     _;
400   }
401   /**
402   * @dev throws if person sending is not authorised or sends nothing
403   */
404   modifier onlyAuthorised() {
405     require (authorised[msg.sender] || freeForAll);
406     require (now >= startTimestamp);
407     require (!(hasEnded()));
408     require (HardwareWallet != 0x0);
409     require (msg.value > 1 finney);
410     require(tokensForSale > tokenRaised); // check we are not over the number of tokensForSale
411     _;
412   }
413   /**
414   * @dev authorise an account to participate
415   */
416   function authoriseAccount(address whom) onlyCSorAdmin public {
417     authorised[whom] = true;
418   }
419 
420   /**
421   * @dev authorise a lot of accounts in one go
422   */
423   function authoriseManyAccounts(address[] many) onlyCSorAdmin public {
424     for (uint256 i = 0; i < many.length; i++) {
425       authorised[many[i]] = true;
426     }
427   }
428 
429   /**
430   * @dev ban an account from participation (default)
431   */
432   function blockAccount(address whom) onlyCSorAdmin public {
433     authorised[whom] = false;
434   }
435 
436   /**
437   * @dev set a new CS representative
438   */
439   function setCS(address newCS) onlyOwner public {
440     cs = newCS;
441   }
442 
443   /**
444   * @dev set a new Admin representative
445   */
446   function setAdmin(address newAdmin) onlyOwner public {
447     Admin = newAdmin;
448   }
449 
450   function placeTokens(address beneficiary, uint256 _tokens) onlyAdmin public {
451     //check minimum and maximum amount
452     require(_tokens != 0);
453     require(!hasEnded());
454     uint256 amount = 0;
455     if (token.balanceOf(beneficiary) == 0) {
456       numberOfPurchasers++;
457     }
458     tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over
459     token.mint(beneficiary, _tokens);
460     TokenPurchase(beneficiary, amount, _tokens);
461   }
462 
463   // low level token purchase function
464   function buyTokens(address beneficiary, uint256 amount) onlyAuthorised internal {
465     //check minimum and maximum amount , we check it now in the tiers
466     
467     // Calculate token amount to be purchased
468     uint256 actualRate = getRateAt(now);
469     uint256 tokens = amount.mul(actualRate);
470 
471     // update state
472     weiRaised = weiRaised.add(amount);
473     if (token.balanceOf(beneficiary) == 0) {
474       numberOfPurchasers++;
475     }
476     tokenRaised = tokenRaised.add(tokens); // so we can go slightly over
477  
478     // mint the tokens to the buyer
479     token.mint(beneficiary, tokens);
480     TokenPurchase(beneficiary, amount, tokens);
481 
482     // send the ether to the hardwarewallet
483     HardwareWallet.transfer(this.balance); // better in case any other ether ends up here
484   }
485 
486   // transfer ownership of the token to the owner of the presale contract
487   function finishSale() public onlyOwner {
488     require(hasEnded());
489     // assign the rest of the 100M tokens to the reserve
490     uint unassigned;
491     if(maxTokens > tokenRaised) {
492       unassigned  = maxTokens.sub(tokenRaised);
493       token.mint(HardwareWallet,unassigned);
494     }
495     token.finishMinting();
496     token.transferOwnership(owner);
497     SaleClosed();
498   }
499 
500   // fallback function can be used to buy tokens
501   function () public payable {
502     buyTokens(msg.sender, msg.value);
503   }
504 
505   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
506     oddToken.transfer(owner, amount);
507   }
508 }