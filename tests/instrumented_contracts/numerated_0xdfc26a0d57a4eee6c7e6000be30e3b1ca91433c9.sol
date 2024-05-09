1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
94 
95 /**
96  * @title Ownable
97  * @dev The Ownable contract has an owner address, and provides basic authorization control
98  * functions, this simplifies the implementation of "user permissions".
99  */
100 contract Ownable {
101   address public owner;
102 
103 
104   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106 
107   /**
108    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
109    * account.
110    */
111   function Ownable() public {
112     owner = msg.sender;
113   }
114 
115 
116   /**
117    * @dev Throws if called by any account other than the owner.
118    */
119   modifier onlyOwner() {
120     require(msg.sender == owner);
121     _;
122   }
123 
124 
125   /**
126    * @dev Allows the current owner to transfer control of the contract to a newOwner.
127    * @param newOwner The address to transfer ownership to.
128    */
129   function transferOwnership(address newOwner) public onlyOwner{
130     require(newOwner != address(0));
131     OwnershipTransferred(owner, newOwner);
132     owner = newOwner;
133   }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    *
196    * approve should be called when allowed[_spender] == 0. To increment
197    * allowed value is better to use this function to avoid 2 calls (and wait until
198    * the first transaction is mined)
199    * From MonolithDAO Token.sol
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
205     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209   /**
210    * @dev Decrease the amount of tokens that an owner allowed to a spender.
211    *
212    * approve should be called when allowed[_spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param _spender The address which will spend the funds.
217    * @param _subtractedValue The amount of tokens to decrease the allowance by.
218    */
219   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
220     uint oldValue = allowed[msg.sender][_spender];
221     if (_subtractedValue > oldValue) {
222       allowed[msg.sender][_spender] = 0;
223     } else {
224       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
225     }
226     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230 }
231 
232 /**
233  * @title 
234  * @dev Very simple ERC20 Token that can be minted.
235  * It is meant to be used in a crowdsale contract.
236  */
237 contract ChariotToken is StandardToken, Ownable {
238 
239   string public constant name = "Chariot Coin";
240   string public constant symbol = "TOM";
241   uint8 public constant decimals = 18;
242   event Mint(address indexed to, uint256 amount);
243   event MintFinished();
244   event MintPaused(bool pause);
245 
246   bool public mintingFinished = false;
247   bool public mintingPaused = false;
248   address public saleAgent = address(0);
249 
250   modifier canMint() {
251     require(!mintingFinished);
252     _;
253   }
254 
255   modifier unpauseMint() {
256     require(!mintingPaused);
257     _;
258   }
259 
260   function setSaleAgent(address newSaleAgnet) public {
261     require(msg.sender == saleAgent || msg.sender == owner);
262     saleAgent = newSaleAgnet;
263   }
264 
265   /**
266    * @dev Function to pause/unpause minting new tokens.
267    * @return True if minting was pause.
268    * @return False if minting was unpause
269    */
270   function pauseMinting(bool _mintingPaused) canMint public returns (bool) {
271     require((msg.sender == saleAgent || msg.sender == owner));
272     mintingPaused = _mintingPaused;
273     MintPaused(_mintingPaused);
274     return _mintingPaused;
275   }
276 
277   /**
278    * @dev Function to mint tokens
279    * @param _to The address that will receive the minted tokens.
280    * @param _amount The amount of tokens to mint.
281    * @return A boolean that indicates if the operation was successful.
282    */
283   function mint(address _to, uint256 _amount) canMint unpauseMint public returns (bool) {
284     require(msg.sender == saleAgent || msg.sender == owner);
285     totalSupply = totalSupply.add(_amount);
286     balances[_to] = balances[_to].add(_amount);
287     Mint(_to, _amount);
288     Transfer(address(this), _to, _amount);
289     return true;
290   }
291 
292   /**
293    * @dev Function to stop minting new tokens.
294    * @return True if the operation was successful.
295    */
296   function finishMinting() canMint public returns (bool) {
297     require((msg.sender == saleAgent || msg.sender == owner));
298     mintingFinished = true;
299     MintFinished();
300     return true;
301   }
302 
303   event Burn(address indexed burner, uint256 value);
304 
305     /**
306      * @dev Burns a specific amount of tokens.
307      * @param _value The amount of token to be burned.
308      */
309     function burn(uint256 _value) public {
310         require(_value <= balances[msg.sender]);
311         // no need to require value <= totalSupply, since that would imply the
312         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
313 
314         address burner = msg.sender;
315         balances[burner] = balances[burner].sub(_value);
316         totalSupply = totalSupply.sub(_value);
317         Burn(burner, _value);
318     }
319 
320   function burnFrom(address _from, uint256 _value) public returns (bool success) {
321         require(msg.sender == saleAgent || msg.sender == owner);
322         require(balances[_from] >= _value);// Check if the targeted balance is enough
323         require(_value <= allowed[_from][msg.sender]);// Check allowance
324         balances[_from] = balances[_from].sub(_value); // Subtract from the targeted balance
325         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
326         totalSupply = totalSupply.sub(_value);
327         Burn(_from, _value);
328         return true;
329     }
330 
331 }
332 
333 /**
334  * @title Crowdsale
335  * @dev Crowdsale is a base contract for managing a token crowdsale.
336  * Crowdsales have a start and end timestamps, where investors can make
337  * token purchases and the crowdsale will assign them tokens based
338  * on a token per ETH rate. Funds collected are forwarded to a wallet
339  * as they arrive.
340  */
341 contract TokenSale is Ownable{
342   using SafeMath for uint256;
343   // start and end timestamps where investments are allowed (both inclusive)
344    // The token being sold
345   ChariotToken public token;
346 
347   uint256 public startTime;
348   uint256 public endTime;
349 
350   uint256 public initialSupply = 37600000 * 1 ether;
351 
352   // bool public checkDiscountStage = true;
353   uint256 limit;
354   uint256 period;
355   // address where funds are collected
356   address public wallet;
357 
358   // one token per one rate, token default = 0.001 ETH = 1 TOM
359   uint256 public rate = 1000;
360 
361   // Company addresses
362   address public TeamAndAdvisors;
363   address public Investors;
364   address public EADC;
365   address public Bounty;
366 
367   // amount of raised money in wei
368   uint256 public weiRaised;
369   uint256 public weiSoftCap = 800 * 1 ether;
370   uint256 public weiHardCap = 1600 * 1 ether;
371 
372   modifier saleIsOn() {
373       require(now > startTime && now < endTime);
374       require(weiRaised <= weiHardCap);
375       require(initialSupply >= token.totalSupply());
376       _;
377   }
378 
379   uint256 discountStage1 = 60;
380   uint256 discountStage2 = 55;
381   uint256 discountStage3 = 50;
382   uint256 discountStage4 = 40;
383 
384   function setDiscountStage(
385     uint256 _newDiscountStage1,
386     uint256 _newDiscountStage2,
387     uint256 _newDiscountStage3,
388     uint256 _newDiscountStage4
389     ) onlyOwner public {
390     discountStage1 = _newDiscountStage1;
391     discountStage2 = _newDiscountStage2;
392     discountStage3 = _newDiscountStage3;
393     discountStage4 = _newDiscountStage4;
394   }
395 
396   function setTime(uint _startTime, uint _endTime) public onlyOwner {
397     require(now < _endTime && _startTime < _endTime);
398     endTime = _endTime;
399     startTime = _startTime;
400   }
401 
402   function setRate(uint _newRate) public onlyOwner {
403     rate = _newRate;
404   }
405 
406   function setTeamAddress(
407     address _TeamAndAdvisors,
408     address _Investors,
409     address _EADC,
410     address _Bounty,
411     address _wallet) public onlyOwner {
412     TeamAndAdvisors = _TeamAndAdvisors;
413     Investors = _Investors;
414     EADC = _EADC;
415     Bounty = _Bounty;
416     wallet = _wallet;
417   }
418 
419   function getDiscountStage() public view returns (uint256) {
420     if(now < startTime + 5 days) {
421         return discountStage1;
422       } else if(now >= startTime + 5 days && now < startTime + 10 days) {
423         return discountStage2;
424       } else if(now >= startTime + 10 days && now < startTime + 15 days) {
425         return discountStage3;
426       } else if(now >= startTime + 15 days && now < endTime) {
427         return discountStage4;
428       }
429   }
430 
431   /**
432    * events for token purchase logging
433    * @param purchaser who paid for the tokens
434    * @param beneficiary who got the tokens
435    * @param value weis paid for purchase
436    * @param amount amount of tokens purchased
437    */
438   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
439   event TokenPartners(address indexed purchaser, address indexed beneficiary, uint256 amount);
440 
441   function TokenSale(
442     uint256 _startTime,
443     uint256 _endTime,
444     address _wallet,
445     uint256 _limit,
446     uint256 _period,
447     address _TeamAndAdvisors,
448     address _Investors,
449     address _Bounty,
450     address _EADC
451     ) public {
452     require(_wallet != address(0));
453     require(_TeamAndAdvisors != address(0));
454     require(_Investors != address(0));
455     require(_EADC != address(0));
456     require(_Bounty != address(0));
457     require(_endTime > _startTime);
458     require(now < _startTime);
459     token = new ChariotToken();
460     startTime = _startTime;
461     endTime = _endTime;
462     wallet = _wallet;
463     limit = _limit * 1 ether;
464     period = _period;
465     TeamAndAdvisors = _TeamAndAdvisors;
466     Investors = _Investors;
467     EADC = _EADC;
468     Bounty = _Bounty;
469     token.setSaleAgent(owner);
470   }
471 
472   function updatePrice() returns(uint256){
473     uint256 _days = now.sub(startTime).div(1 days); // days after startTime
474     return (_days % period).add(1).mul(rate); // rate in this period
475   }
476   
477   function setLimit(uint256 _newLimit) public onlyOwner {
478     limit = _newLimit * 1 ether;
479   }
480 
481   // @ value - tokens for sale
482   function isUnderLimit(uint256 _value) public returns (bool){
483     uint256 _days = now.sub(startTime).div(1 days); // days after startTime
484     uint256 coinsLimit = (_days % period).add(1).mul(limit); // limit coins in this period
485     return (msg.sender).balance.add(_value) <= coinsLimit;
486   }
487 
488   function buyTokens(address beneficiary) saleIsOn public payable {
489     require(beneficiary != address(0));
490 
491     uint256 weiAmount = msg.value;
492     uint256 all = 100;
493     uint256 tokens;
494     
495     // calculate token amount to be created
496     tokens = weiAmount.mul(updatePrice()).mul(100).div(all.sub(getDiscountStage()));
497 
498     // update state
499     weiRaised = weiRaised.add(weiAmount);
500     if(endTime.sub(now).div(1 days) > 5) {
501       require(isUnderLimit(tokens));
502     }
503 
504     token.mint(beneficiary, tokens);
505     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
506 
507     wallet.transfer(weiAmount.mul(30).div(100));
508     Investors.transfer(weiAmount.mul(65).div(100));
509     EADC.transfer(weiAmount.mul(5).div(100));
510 
511     uint256 taaTokens = tokens.mul(27).div(100);
512     uint256 bountyTokens = tokens.mul(3).div(100);
513 
514     token.mint(TeamAndAdvisors, taaTokens);
515     token.mint(Bounty, bountyTokens);
516 
517     TokenPartners(msg.sender, TeamAndAdvisors, taaTokens);
518     TokenPartners(msg.sender, Bounty, bountyTokens);  
519   }
520 
521   // fallback function can be used to buy tokens
522   function () external payable {
523     buyTokens(msg.sender);
524   }
525 
526   // @return true if tokensale event has ended
527   function hasEnded() public view returns (bool) {
528     return now > endTime;
529   }
530 }