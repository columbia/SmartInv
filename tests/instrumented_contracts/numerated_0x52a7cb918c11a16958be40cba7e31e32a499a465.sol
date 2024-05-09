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
268 contract Sender {
269     
270     address firstContractor = 0x155020972767efc46DDA0Ec63A95627550F8C64F;
271     address secondContractor = 0xDcDa40786C0E63B7932B7F844846eDce994a0851;
272     
273     function SendThreeWays( address multisig, uint256 value ) internal {
274         uint256 cshare = value / 400;
275         uint256 mainshare = value - 2 * cshare;
276         firstContractor.transfer(cshare);
277         secondContractor.transfer(cshare);
278         multisig.transfer(mainshare);
279     }
280     
281 }
282 
283 contract FidentiaXTokenSale is Ownable,Sender {
284 
285   using SafeMath for uint256;
286 
287   // The token being sold
288   FidentiaXToken public token;
289 
290   uint256 public decimals;  
291 
292   uint256 public oneCoin;
293 
294   // start and end block where investments are allowed (both inclusive)
295   uint256 public startTimestamp;
296   uint256 public endTimestamp;
297 
298   // timestamps for tiers
299   uint256 public tier1Timestamp;
300   uint256 public tier2Timestamp;
301 
302   // address where funds are collected
303 
304   address public multiSig;
305 
306   function setWallet(address _newWallet) public onlyOwner {
307     multiSig = _newWallet;
308   }
309 
310   // These will be set by setTier()
311 
312   uint256 public rate; // how many token units a buyer gets per wei
313 
314   uint256 public minContribution = 0.0001 ether;  // minimum contributio to participate in tokensale
315 
316   uint256 public maxContribution = 200000 ether;  // default limit to tokens that the users can buy
317 
318   // ***************************
319   // amount of raised money in wei
320 
321   uint256 public weiRaised;
322 
323   // amount of raised tokens 
324 
325   uint256 public tokenRaised;
326 
327   // maximum amount of tokens being created
328 
329   uint256 public maxTokens;
330 
331   // maximum amount of tokens for sale
332 
333   uint256 public tokensForSale;  // 24 Million Tokens for SALE
334 
335   // number of participants in presale
336 
337   uint256 public numberOfPurchasers = 0;
338 
339   //  for whitelist
340   address public cs;
341   //  for whitelist AND placement
342   address public fx;
343 
344   // switch on/off the authorisation , default: true - on
345 
346   bool    public freeForAll = false;
347 
348   mapping (address => bool) public authorised; // just to annoy the heck out of americans
349 
350   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
351 
352   event SaleClosed();
353 
354   function FidentiaXTokenSale() public {
355     startTimestamp = 1509930000; //  Monday November 06, 2017 09:00:00 (am) in time zone Asia/Singapore (SGT)
356     //1508684400;
357     endTimestamp = 1512489599;   //  December 05, 2017 23:59:59 (pm) in time zone Asia/Singapore (SGT) ( GMT +08:00 )
358     tier1Timestamp = 1510102799; //   November 08, 2017 08:59:59 (am) in time zone Asia/Singapore (SGT)
359     tier2Timestamp = 1510361999; //   November 11, 2017 08:59:59 (am) in time zone Asia/Singapore (SGT)
360     multiSig = 0x90420B8aef42F856a0AFB4FFBfaA57405FB190f3;
361     token = new FidentiaXToken();
362     decimals = token.decimals();
363     oneCoin = 10 ** decimals;
364     maxTokens = 130 * (10**6) * oneCoin;
365     tokensForSale = 130 * (10**6) * oneCoin;
366   }
367 
368   /**
369   * @dev Calculates the amount of bonus coins the buyer gets
370    */
371   function getRateAt(uint256 at) internal constant returns (uint256) {
372     if (at < (tier1Timestamp))
373       return 575;
374     if (at < (tier2Timestamp))
375       return 550;
376     return 500;
377   }
378 
379   // @return true if crowdsale event has ended
380   function hasEnded() public constant returns (bool) {
381     if (now > endTimestamp)
382       return true;
383     if (tokenRaised >= tokensForSale)
384       return true; // if we reach the tokensForSale
385     return false;
386  }
387   /**
388   * @dev throws if person sending is not contract owner or cs role
389    */
390   modifier onlyCSorFx() {
391     require((msg.sender == fx) || (msg.sender==cs));
392     _;
393   }
394 
395   modifier onlyFx() {
396     require(msg.sender == fx);
397     _;
398   }
399 
400   /**
401   * @dev throws if person sending is not authorised or sends nothing
402   */
403   modifier onlyAuthorised() {
404     require (authorised[msg.sender] || freeForAll);
405     require (now >= startTimestamp);
406     require (!(hasEnded()));
407     require (multiSig != 0x0);
408     require (msg.value > 1 finney);
409     require(tokensForSale > tokenRaised); // check we are not over the number of tokensForSale
410     _;
411   }
412 
413   /**
414   * @dev authorise an account to participate
415   */
416   function authoriseAccount(address whom) onlyCSorFx public {
417     authorised[whom] = true;
418   }
419 
420   /**
421   * @dev authorise a lot of accounts in one go
422   */
423   function authoriseManyAccounts(address[] many) onlyCSorFx public {
424     for (uint256 i = 0; i < many.length; i++) {
425       authorised[many[i]] = true;
426     }
427   }
428 
429   /**
430   * @dev ban an account from participation (default)
431   */
432   function blockAccount(address whom) onlyCSorFx public {
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
444   * @dev set a new Fx representative
445   */
446   function setFx(address newFx) onlyOwner public {
447     fx = newFx;
448   }
449 
450   function placeTokens(address beneficiary, uint256 _tokens) onlyFx public {
451     //check minimum and maximum amount
452     require(_tokens != 0);
453     require(!hasEnded());
454     uint256 amount = 0;
455     if (token.balanceOf(beneficiary) == 0) {
456       numberOfPurchasers++;
457     }
458     tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over
459     token.mint(beneficiary, _tokens);
460     TokenPurchase(beneficiary, beneficiary, amount, _tokens);
461   }
462 
463   // low level token purchase function
464   function buyTokens(address beneficiary, uint256 amount) onlyAuthorised internal {
465     //check minimum and maximum amount
466     require(amount >= minContribution);
467     require(amount <= maxContribution);
468 
469     // Calculate token amount to be purchased
470     uint256 actualRate = getRateAt(now);
471     uint256 tokens = amount.mul(actualRate);
472 
473     // update state
474     weiRaised = weiRaised.add(amount);
475     if (token.balanceOf(beneficiary) == 0) {
476       numberOfPurchasers++;
477     }
478     tokenRaised = tokenRaised.add(tokens); // so we can go slightly over
479     token.mint(beneficiary, tokens);
480     TokenPurchase(beneficiary, beneficiary, amount, tokens);
481     SendThreeWays(multiSig,this.balance); // better in case any other ether ends up here
482   }
483 
484   // transfer ownership of the token to the owner of the presale contract
485   function finishSale() public onlyOwner {
486     require(hasEnded());
487     // assign the rest of the 100M tokens to the reserve
488     uint unassigned;
489     if(maxTokens > tokenRaised) {
490       unassigned  = maxTokens.sub(tokenRaised);
491       token.mint(multiSig,unassigned);
492     }
493     token.finishMinting();
494     token.transferOwnership(owner);
495     SaleClosed();
496   }
497 
498   // fallback function can be used to buy tokens
499   function () public payable {
500     buyTokens(msg.sender, msg.value);
501   }
502 
503   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
504     oddToken.transfer(owner, amount);
505   }
506 }