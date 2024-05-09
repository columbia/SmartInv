1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
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
40 
41 /**
42  * @title Pausable
43  * @dev Base contract which allows children to implement an emergency stop mechanism.
44  */
45 contract Pausable is Ownable {
46   event Pause();
47   event Unpause();
48 
49   bool public paused = false;
50 
51 
52   /**
53    * @dev modifier to allow actions only when the contract IS paused
54    */
55   modifier whenNotPaused() {
56     require (!paused);
57     _;
58   }
59 
60   /**
61    * @dev modifier to allow actions only when the contract IS NOT paused
62    */
63   modifier whenPaused {
64     require (paused) ;
65     _;
66   }
67 
68   /**
69    * @dev called by the owner to pause, triggers stopped state
70    */
71   function pause() onlyOwner whenNotPaused  public returns (bool) {
72     paused = true;
73     Pause();
74     return true;
75   }
76 
77   /**
78    * @dev called by the owner to unpause, returns to normal state
79    */
80   function unpause() onlyOwner whenPaused public returns (bool) {
81     paused = false;
82     Unpause();
83     return true;
84   }
85 }
86 /**
87  * @title ERC20Basic
88  * @dev Simpler version of ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/179
90  */
91 contract ERC20Basic {
92   uint256 public totalSupply;
93   function balanceOf(address who) public constant returns (uint256);
94   function transfer(address to, uint256 value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public constant returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 /**
110  * @title SafeMath
111  * @dev Math operations with safety checks that throw on error
112  */
113 library SafeMath {
114   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a * b;
116     assert(a == 0 || c / a == b);
117     return c;
118   }
119 
120   function div(uint256 a, uint256 b) internal pure returns (uint256) {
121     // assert(b > 0); // Solidity automatically throws when dividing by 0
122     uint256 c = a / b;
123     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124     return c;
125   }
126 
127   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128     assert(b <= a);
129     return a - b;
130   }
131 
132   function add(uint256 a, uint256 b) internal pure returns (uint256) {
133     uint256 c = a + b;
134     assert(c >= a);
135     return c;
136   }
137 }
138 
139 /**
140  * @title Basic token
141  * @dev Basic version of StandardToken, with no allowances.
142  */
143 contract BasicToken is ERC20Basic {
144   using SafeMath for uint256;
145 
146   mapping(address => uint256) balances;
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151     * @param _value The amount to be transferred.
152    */
153   function transfer(address _to, uint256 _value) public returns (bool){
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164    */
165   function balanceOf(address _owner) public constant returns (uint256 balance) {
166     return balances[_owner];
167   }
168 }
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180   /**
181   * @dev Transfer tokens from one address to another
182   * @param _from address The address which you want to send tokens from
183   * @param _to address The address which you want to transfer to
184   * @param _value uint256 the amout of tokens to be transfered
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188 
189     balances[_to] = balances[_to].add(_value);
190     balances[_from] = balances[_from].sub(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
198   * @param _spender The address which will spend the funds.
199   * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202 
203     // To change the approve amount you first have to reduce the addresses`
204     //  allowance to zero by calling `approve(_spender, 0)` if it is not
205     //  already 0 to mitigate the race condition described here:
206     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
208 
209     allowed[msg.sender][_spender] = _value;
210     Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215   * @dev Function to check the amount of tokens that an owner allowed to a spender.
216   * @param _owner address The address which owns the funds.
217     * @param _spender address The address which will spend the funds.
218     * @return A uint256 specifing the amount of tokens still avaible for the spender.
219    */
220   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
221     return allowed[_owner][_spender];
222   }
223 }
224 
225 /**
226  * @title Mintable token
227  * @dev Simple ERC20 Token example, with mintable token creation
228  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
229  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
230  */
231 
232 contract MintableToken is StandardToken, Ownable {
233   event Mint(address indexed to, uint256 amount);
234   event MintFinished();
235 
236   bool public mintingFinished = false;
237 
238   modifier canMint() {
239     require(!mintingFinished);
240     _;
241   }
242 
243   /**
244   * @dev Function to mint tokens
245   * @param _to The address that will recieve the minted tokens.
246     * @param _amount The amount of tokens to mint.
247     * @return A boolean that indicates if the operation was successful.
248    */
249   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
250     totalSupply = totalSupply.add(_amount);
251     balances[_to] = balances[_to].add(_amount);
252     Transfer(0X0, _to, _amount);
253     return true;
254   }
255 
256   /**
257   * @dev Function to stop minting new tokens.
258   * @return True if the operation was successful.
259    */
260   function finishMinting() onlyOwner public returns (bool) {
261     mintingFinished = true;
262     MintFinished();
263     return true;
264   }
265 }
266 
267 contract ReporterToken is MintableToken, Pausable{
268   string public name = "Reporter Token";
269   string public symbol = "NEWS";
270   uint256 public decimals = 18;
271 
272   bool public tradingStarted = false;
273 
274   /**
275   * @dev modifier that throws if trading has not started yet
276    */
277   modifier hasStartedTrading() {
278     require(tradingStarted);
279     _;
280   }
281 
282   /**
283   * @dev Allows the owner to enable the trading. This can not be undone
284   */
285   function startTrading() public onlyOwner {
286     tradingStarted = true;
287   }
288 
289   /**
290    * @dev Allows anyone to transfer the Reporter tokens once trading has started
291    * @param _to the recipient address of the tokens.
292    * @param _value number of tokens to be transfered.
293    */
294   function transfer(address _to, uint _value) hasStartedTrading whenNotPaused public returns (bool) {
295     return super.transfer(_to, _value);
296   }
297 
298   /**
299   * @dev Allows anyone to transfer the Reporter tokens once trading has started
300   * @param _from address The address which you want to send tokens from
301   * @param _to address The address which you want to transfer to
302   * @param _value uint the amout of tokens to be transfered
303    */
304   function transferFrom(address _from, address _to, uint _value) hasStartedTrading whenNotPaused public returns (bool) {
305     return super.transferFrom(_from, _to, _value);
306   }
307 
308   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
309     oddToken.transfer(owner, amount);
310   }
311 }
312 
313 contract ReporterTokenSale is Ownable, Pausable{
314   using SafeMath for uint256;
315 
316   // The token being sold
317   ReporterToken public token;
318 
319   uint256 public decimals;  
320   uint256 public oneCoin;
321 
322   // start and end block where investments are allowed (both inclusive)
323   uint256 public startTimestamp;
324   uint256 public endTimestamp;
325 
326   // address where funds are collected
327   address public multiSig;
328 
329   function setWallet(address _newWallet) public onlyOwner {
330     multiSig = _newWallet;
331   }
332 
333   // These will be set by setTier()
334   uint256 public rate; // how many token units a buyer gets per wei
335   uint256 public minContribution = 0.0001 ether;  // minimum contributio to participate in tokensale
336   uint256 public maxContribution = 200000 ether;  // default limit to tokens that the users can buy
337 
338   // ***************************
339 
340   // amount of raised money in wei
341   uint256 public weiRaised;
342 
343   // amount of raised tokens 
344   uint256 public tokenRaised;
345 
346   // maximum amount of tokens being created
347   uint256 public maxTokens;
348 
349   // maximum amount of tokens for sale
350   uint256 public tokensForSale;  // 36 Million Tokens for SALE
351 
352   // number of participants in presale
353   uint256 public numberOfPurchasers = 0;
354 
355   //  for whitelist
356   address public cs;
357 
358  //  for rate
359   uint public r;
360 
361 
362   // switch on/off the authorisation , default: false
363   bool    public freeForAll = false;
364 
365   mapping (address => bool) public authorised; // just to annoy the heck out of americans
366 
367   event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
368   event SaleClosed();
369 
370   function ReporterTokenSale() public {
371     startTimestamp = 1508684400; // 22 Oct. 2017. 15:00 UTC
372     endTimestamp = 1521126000;   // 15 Marc. 2018. 15:00 UTC  1521126000
373     multiSig = 0xD00d085F125EAFEA9e8c5D3f4bc25e6D0c93Af0e;
374 
375     token = new ReporterToken();
376     decimals = token.decimals();
377     oneCoin = 10 ** decimals;
378     maxTokens = 60 * (10**6) * oneCoin;
379     tokensForSale = 36 * (10**6) * oneCoin;
380   }
381 
382   /**
383   * @dev Calculates the amount of bonus coins the buyer gets
384   */
385   function setTier(uint newR) internal {
386     // first 9M tokens get extra 42% of tokens, next half get 17%
387     if (tokenRaised <= 9000000 * oneCoin) {
388       rate = newR * 142/100;
389       //minContribution = 100 ether;
390       //maxContribution = 1000000 ether;
391     } else if (tokenRaised <= 18000000 * oneCoin) {
392       rate = newR *117/100;
393       //minContribution = 5 ether;
394       //maxContribution = 1000000 ether;
395     } else {
396       rate = newR * 1;
397       //minContribution = 0.01 ether;
398       //maxContribution = 100 ether;
399     }
400   }
401 
402   // @return true if crowdsale event has ended
403   function hasEnded() public constant returns (bool) {
404     if (now > endTimestamp)
405       return true;
406     if (tokenRaised >= tokensForSale)
407       return true; // if we reach the tokensForSale
408     return false;
409   }
410 
411   /**
412   * @dev throws if person sending is not contract owner or cs role
413    */
414   modifier onlyCSorOwner() {
415     require((msg.sender == owner) || (msg.sender==cs));
416     _;
417   }
418    modifier onlyCS() {
419     require(msg.sender == cs);
420     _;
421   }
422 
423   /**
424   * @dev throws if person sending is not authorised or sends nothing
425   */
426   modifier onlyAuthorised() {
427     require (authorised[msg.sender] || freeForAll);
428     require (now >= startTimestamp);
429     require (!(hasEnded()));
430     require (multiSig != 0x0);
431     require(tokensForSale > tokenRaised); // check we are not over the number of tokensForSale
432     _;
433   }
434 
435   /**
436   * @dev authorise an account to participate
437   */
438   function authoriseAccount(address whom) onlyCSorOwner public {
439     authorised[whom] = true;
440   }
441 
442   /**
443   * @dev authorise a lot of accounts in one go
444   */
445   function authoriseManyAccounts(address[] many) onlyCSorOwner public {
446     for (uint256 i = 0; i < many.length; i++) {
447       authorised[many[i]] = true;
448     }
449   }
450 
451   /**
452   * @dev ban an account from participation (default)
453   */
454   function blockAccount(address whom) onlyCSorOwner public {
455     authorised[whom] = false;
456    }  
457     
458   /**
459   * @dev set a new CS representative
460   */
461   function setCS(address newCS) onlyOwner public {
462     cs = newCS;
463   }
464 
465    /**
466   * @dev set a newRate if have a big different in ether/dollar rate 
467   */
468   function setRate(uint newRate) onlyCSorOwner public {
469     require( 0 < newRate && newRate < 8000); 
470     r = newRate;
471   }
472 
473 
474   function placeTokens(address beneficiary, uint256 _tokens) onlyCS public {
475     //check minimum and maximum amount
476     require(_tokens != 0);
477     require(!hasEnded());
478     uint256 amount = 0;
479     if (token.balanceOf(beneficiary) == 0) {
480       numberOfPurchasers++;
481     }
482     tokenRaised = tokenRaised.add(_tokens); // so we can go slightly over
483     token.mint(beneficiary, _tokens);
484     TokenPurchase(beneficiary, amount, _tokens);
485   }
486 
487   // low level token purchase function
488   function buyTokens(address beneficiary, uint256 amount) onlyAuthorised whenNotPaused internal {
489 
490     setTier(r);
491 
492     //check minimum and maximum amount
493     require(amount >= minContribution);
494     require(amount <= maxContribution);
495 
496     // calculate token amount to be created
497     uint256 tokens = amount.mul(rate);
498 
499     // update state
500     weiRaised = weiRaised.add(amount);
501     if (token.balanceOf(beneficiary) == 0) {
502       numberOfPurchasers++;
503     }
504     tokenRaised = tokenRaised.add(tokens); // so we can go slightly over
505     token.mint(beneficiary, tokens);
506     TokenPurchase(beneficiary, amount, tokens);
507     multiSig.transfer(this.balance); // better in case any other ether ends up here
508   }
509 
510   // transfer ownership of the token to the owner of the presale contract
511   function finishSale() public onlyOwner {
512     require(hasEnded());
513 
514     // assign the rest of the 60M tokens to the reserve
515     uint unassigned;
516     if(maxTokens > tokenRaised) {
517       unassigned  = maxTokens.sub(tokenRaised);
518       token.mint(multiSig,unassigned);
519     }
520     token.finishMinting();
521     token.transferOwnership(owner);
522     SaleClosed();
523   }
524 
525   // fallback function can be used to buy tokens
526   function () public payable {
527     buyTokens(msg.sender, msg.value);
528   }
529 
530   function emergencyERC20Drain( ERC20 oddToken, uint amount ) public {
531     oddToken.transfer(owner, amount);
532   }
533 }