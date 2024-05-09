1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20Basic {
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72 
73     // SafeMath.sub will throw if there is not enough balance.
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) public constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112 
113     uint256 _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
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
147   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval (address _spender, uint _addedValue)
158     returns (bool success) {
159     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   function decreaseApproval (address _spender, uint _subtractedValue)
165     returns (bool success) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 
179 /**
180  * @title Ownable
181  * @dev The Ownable contract has an owner address, and provides basic authorization control
182  * functions, this simplifies the implementation of "user permissions".
183  */
184 contract Ownable {
185   address public owner;
186 
187 
188   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191   /**
192    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193    * account.
194    */
195   function Ownable() {
196     owner = msg.sender;
197   }
198 
199 
200   /**
201    * @dev Throws if called by any account other than the owner.
202    */
203   modifier onlyOwner() {
204     require(msg.sender == owner);
205     _;
206   }
207 
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) onlyOwner public {
214     require(newOwner != address(0));
215     OwnershipTransferred(owner, newOwner);
216     owner = newOwner;
217   }
218 
219 }
220 
221 /**
222  * @title Mintable token
223  * @dev Simple ERC20 Token example, with mintable token creation
224  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
225  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
226  */
227 
228 contract MintableToken is StandardToken, Ownable {
229   event Mint(address indexed to, uint256 amount);
230   event MintFinished();
231 
232   bool public mintingFinished = false;
233 
234 
235   modifier canMint() {
236     require(!mintingFinished);
237     _;
238   }
239 
240   /**
241    * @dev Function to mint tokens
242    * @param _to The address that will receive the minted tokens.
243    * @param _amount The amount of tokens to mint.
244    * @return A boolean that indicates if the operation was successful.
245    */
246   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
247     totalSupply = totalSupply.add(_amount);
248     balances[_to] = balances[_to].add(_amount);
249     Mint(_to, _amount);
250     Transfer(0x0, _to, _amount);
251     return true;
252   }
253 
254   /**
255    * @dev Function to stop minting new tokens.
256    * @return True if the operation was successful.
257    */
258   function finishMinting() onlyOwner public returns (bool) {
259     mintingFinished = true;
260     MintFinished();
261     return true;
262   }
263 }
264 
265 /**
266  * @title Crowdsale
267  * @dev Crowdsale is a base contract for managing a token crowdsale.
268  * Crowdsales have a start and end timestamps, where investors can make
269  * token purchases and the crowdsale will assign them tokens based
270  * on a token per ETH rate. Funds collected are forwarded to a wallet
271  * as they arrive.
272  */
273 contract Crowdsale is Ownable  {
274   using SafeMath for uint256;
275 
276   // The token being sold
277   MintableToken public token;
278   
279 
280   // start and end timestamps where investments are allowed (both inclusive)
281   uint256 public startTime;
282   uint256 public endTime;
283 
284   // address where funds are collected
285   address public wallet;
286 
287   // how many token units a buyer gets per wei
288   uint256 public rate;
289 
290   // amount of raised money in wei
291   uint256 public weiRaised;
292 
293   /**
294    * event for token purchase logging
295    * @param purchaser who paid for the tokens
296    * @param beneficiary who got the tokens
297    * @param value weis paid for purchase
298    * @param amount amount of tokens purchased
299    */
300   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
301 
302 
303   function Crowdsale(){
304     
305 
306     token = createTokenContract();
307     startTime = 1513466281;
308     endTime = 15198624000;
309     rate = 300;
310     wallet = 0x0073A4857faA9745bc5123F50beEd3d170fb0979;
311   }
312 
313   // creates the token to be sold.
314   // override this method to have crowdsale of a specific mintable token.
315   function createTokenContract() internal returns (MintableToken) {
316     return new MintableToken();
317   }
318 
319 
320   // fallback function can be used to buy tokens
321   function () payable {
322     buyTokens(msg.sender);
323   }
324   
325   // low level token purchase function
326   function buyTokens(address beneficiary) public payable {
327     require(beneficiary != 0x0);
328     require(validPurchase());
329 
330     address team = 0xF7a2D1f54416E7B39ec6E06FA2EF6d34ACa9f316;
331     address bounty = 0xF7a2D1f54416E7B39ec6E06FA2EF6d34ACa9f316;
332     address reserve = 0xF7a2D1f54416E7B39ec6E06FA2EF6d34ACa9f316;
333 
334     uint256 weiAmount = msg.value;
335 
336     // calculate token amount to be created
337     uint256 tokens = weiAmount.mul(rate);
338     uint256 bountyAmount = weiAmount.mul(50);
339     uint256 teamAmount = weiAmount.mul(100);
340     uint256 reserveAmount = weiAmount.mul(50);
341 
342     // update state
343     weiRaised = weiRaised.add(weiAmount);
344 
345     token.mint(beneficiary, tokens);
346     token.mint(bounty, bountyAmount);
347     token.mint(team, teamAmount);
348     token.mint(reserve, reserveAmount);
349 
350     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
351 
352     forwardFunds();
353   }
354   
355   function mint(address _to, uint256 _amount) onlyOwner {
356     uint256 mintAmount = _amount;
357     token.mint(_to, mintAmount);  
358   }
359 
360   // send ether to the fund collection wallet
361   // override to create custom fund forwarding mechanisms
362   function forwardFunds() internal {
363     wallet.transfer(msg.value);
364   }
365 
366   // @return true if the transaction can buy tokens
367   function validPurchase() internal constant returns (bool) {
368     bool withinPeriod = now >= startTime && now <= endTime;
369     bool nonZeroPurchase = msg.value != 0;
370     return withinPeriod && nonZeroPurchase;
371   }
372 
373   // @return true if crowdsale event has ended
374   function hasEnded() public constant returns (bool) {
375     return now > endTime;
376   }
377 
378 
379 }
380 
381 /**
382  * @title CappedCrowdsale
383  * @dev Extension of Crowdsale with a max amount of funds raised
384  */
385 contract CappedCrowdsale is Crowdsale {
386   using SafeMath for uint256;
387 
388   uint256 public cap;
389 
390   function CappedCrowdsale() {
391     cap = 48275862100000000000000;
392   }
393 
394   // overriding Crowdsale#validPurchase to add extra cap logic
395   // @return true if investors can buy at the moment
396   function validPurchase() internal constant returns (bool) {
397     bool withinCap = weiRaised.add(msg.value) <= cap;
398     return super.validPurchase() && withinCap;
399   }
400 
401   // overriding Crowdsale#hasEnded to add cap logic
402   // @return true if crowdsale event has ended
403   function hasEnded() public constant returns (bool) {
404     bool capReached = weiRaised >= cap;
405     return super.hasEnded() || capReached;
406   }
407 
408 }
409 
410 /**
411  * @title The Titanium BAR Token contract
412  * @dev The Titanium BAR Token contract
413  * @dev inherits from MintableToken and Ownable by Zeppelin
414  * @author James Connolly
415  */
416 contract BARToken is MintableToken {
417 
418   string public constant name = "Generic Token";
419   string public constant symbol = "GEN";
420   uint8 public constant decimals = 18;
421 
422 }
423 
424 /**
425  * @title BARTokenSale
426  * @dev 
427  * We add new features to a base crowdsale using multiple inheritance.
428  * We are using the following extensions:
429  * CappedCrowdsale - sets a max boundary for raised funds
430  
431  *
432  * The code is based on the contracts of Open Zeppelin and we add our contracts: BARTokenSale, and the BAR Token
433  *
434  * @author James Connolly
435  */
436 contract BARTokenSale is CappedCrowdsale {
437 
438 
439   
440 
441   function BARTokenSale()
442     CappedCrowdsale()
443     //FinalizableCrowdsale()
444     Crowdsale()
445   {
446     
447   }
448 
449   function createTokenContract() internal returns (MintableToken) {
450     return new BARToken();
451   }
452 
453 }
454 
455 
456 contract NewTokenSale is BARTokenSale {
457 
458 
459   address public contractAddress = 0x6720F9015a280f8EB210fED2FDEd9745C9248621;
460   
461   function NewTokenSale(){
462     startTime = 1514836800;
463     endTime = 1519862400;
464     rate = 725;
465     wallet = 0x98935ab01caA7a162892FdF9c6423de24b078a4c;
466   }
467   
468   function changeOwner(address _to) public onlyOwner {
469       BARTokenSale target = BARTokenSale(contractAddress);
470       target.transferOwnership(_to);
471   }
472   
473   function mint(address _to, uint256 _amount) public onlyOwner {
474     BARTokenSale target = BARTokenSale(contractAddress);
475     uint256 mintAmount = _amount;
476     target.mint(_to, mintAmount);  
477   }
478   
479   function changeRate(uint256 _newRate) public onlyOwner {
480       rate = _newRate;
481   }
482   
483   // fallback function can be used to buy tokens
484   function () payable {
485     buyTokens(msg.sender);
486   }
487   
488   // low level token purchase function
489   function buyTokens(address beneficiary) public payable {
490     require(beneficiary != 0x0);
491     require(validPurchase());
492     BARTokenSale target = BARTokenSale(contractAddress);
493 
494     address team = 0xBEC6663703B674EAB943CE2011df4c6cf095642E;
495     address bounty = 0x124e46dAD16c1e9aB59D7412142a131d673cB68f;
496     address reserve = 0x417063A7f0417Af1E6c5bE356014c0259d4dE4a1;
497 
498     uint256 weiAmount = msg.value;
499 
500     // calculate token amount to be created
501     uint256 tokens = weiAmount.mul(rate);
502     uint256 bountyAmount = weiAmount.mul(125);
503     uint256 teamAmount = weiAmount.mul(250);
504     uint256 reserveAmount = weiAmount.mul(150);
505 
506     // update state
507     weiRaised = weiRaised.add(weiAmount);
508 
509     target.mint(beneficiary, tokens);
510     target.mint(bounty, bountyAmount);
511     target.mint(team, teamAmount);
512     target.mint(reserve, reserveAmount);
513 
514     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
515 
516     forwardFunds();
517   }
518 
519   // send ether to the fund collection wallet
520   // override to create custom fund forwarding mechanisms
521   function forwardFunds() internal {
522     wallet.transfer(msg.value);
523   }
524 
525   // @return true if the transaction can buy tokens
526   function validPurchase() internal constant returns (bool) {
527     bool withinPeriod = now >= startTime && now <= endTime;
528     bool nonZeroPurchase = msg.value != 0;
529     return withinPeriod && nonZeroPurchase;
530   }
531 
532   // @return true if crowdsale event has ended
533   function hasEnded() public constant returns (bool) {
534     return now > endTime;
535   }
536 
537   
538     
539 
540 }