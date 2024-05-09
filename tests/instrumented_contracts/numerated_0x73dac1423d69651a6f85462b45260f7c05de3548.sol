1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11           return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public constant returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances. 
65  */
66 contract BasicToken is ERC20Basic {
67 
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   /**
73   * Modifier avoids short address attacks.
74   * For more info check: https://ericrafaloff.com/analyzing-the-erc20-short-address-attack/
75   */
76   modifier onlyPayloadSize(uint size) {
77       if (msg.data.length < size + 4) {
78       revert();
79       }
80       _;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91     
92     // SafeMath.sub will throw if there is not enough balance.
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of. 
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public constant returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is ERC20, BasicToken {
119 
120   mapping (address => mapping (address => uint256)) allowed;
121 
122 
123   /**
124    * @dev Transfer tokens from one address to another
125    * @param _from address The address which you want to send tokens from
126    * @param _to address The address which you want to transfer to
127    * @param _value uint256 the amount of tokens to be transferred
128    */
129   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
130     require(_to != address(0));
131     require(allowed[_from][msg.sender] >= _value);
132     require(balances[_from] >= _value);
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136     Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142    * @param _spender The address which will spend the funds.
143    * @param _value The amount of tokens to be spent.
144    */
145   function approve(address _spender, uint256 _value) public returns (bool) {
146     // To change the approve amount you first have to reduce the addresses`
147     //  allowance to zero by calling `approve(_spender, 0)` if it is not
148     //  already 0 to mitigate the race condition described here:
149     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
151     allowed[msg.sender][_spender] = _value;
152     Approval(msg.sender, _spender, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158    * @param _owner address The address which owns the funds.
159    * @param _spender address The address which will spend the funds.
160    * @return A uint256 specifying the amount of tokens still available for the spender.
161    */
162   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
163     return allowed[_owner][_spender];
164   }
165   
166   /**
167    * approve should be called when allowed[_spender] == 0. To increment
168    * allowed value is better to use this function to avoid 2 calls (and wait until 
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    */
172   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
173     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
174     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
179     uint oldValue = allowed[msg.sender][_spender];
180     if (_subtractedValue > oldValue) {
181       allowed[msg.sender][_spender] = 0;
182     } else {
183       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184     }
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189 }
190 
191 
192 /**
193  * @title Ownable
194  * @dev The Ownable contract has an owner address, and provides basic authorization control
195  * functions, this simplifies the implementation of "user permissions".
196  */
197 contract Ownable {
198   address public owner;
199 
200 
201   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   function Ownable() internal {
209     owner = msg.sender;
210   }
211 
212 
213   /**
214    * @dev Throws if called by any account other than the owner.
215    */
216   modifier onlyOwner() {
217     require(msg.sender == owner);
218     _;
219   }
220 
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address newOwner) public onlyOwner {
227     require(newOwner != address(0));
228     OwnershipTransferred(owner, newOwner);
229     owner = newOwner;
230   }
231 
232 }
233 
234 /**
235  * @title Pausable
236  * @dev Base contract which allows children to implement an emergency stop mechanism.
237  */
238 contract Pausable is Ownable  {
239     event Pause();
240     event Unpause();
241     event Freeze ();
242     event LogFreeze();
243 
244     bool public paused = false;
245 
246     address public founder;
247     
248     /**
249     * @dev modifier to allow actions only when the contract IS paused
250     */
251     modifier whenNotPaused() {
252         require(!paused || msg.sender == founder);
253         _;
254     }
255 
256     /**
257     * @dev modifier to allow actions only when the contract IS NOT paused
258     */
259     modifier whenPaused() {
260         require(paused);
261         _;
262     }
263 
264     /**
265     * @dev called by the owner to pause, triggers stopped state
266     */
267     function pause() public onlyOwner whenNotPaused {
268         paused = true;
269         Pause();
270     }
271     
272 
273     /**
274     * @dev called by the owner to unpause, returns to normal state
275     */
276     function unpause() public onlyOwner whenPaused {
277         paused = false;
278         Unpause();
279     }
280 }
281 
282 contract PausableToken is StandardToken, Pausable {
283 
284   function transfer(address _to, uint256 _value) public whenNotPaused onlyPayloadSize(2 * 32) returns (bool) {
285     return super.transfer(_to, _value);
286   }
287 
288   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused onlyPayloadSize(3 * 32) returns (bool) {
289     return super.transferFrom(_from, _to, _value);
290   }
291 
292   //The functions below surve no real purpose. Even if one were to approve another to spend
293   //tokens on their behalf, those tokens will still only be transferable when the token contract
294   //is not paused.
295 
296   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
297     return super.approve(_spender, _value);
298   }
299 
300   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
301     return super.increaseApproval(_spender, _addedValue);
302   }
303 
304   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
305     return super.decreaseApproval(_spender, _subtractedValue);
306   }
307 }
308 
309 contract MintableToken is PausableToken {
310   event Mint(address indexed to, uint256 amount);
311   event MintFinished();
312 
313   bool public mintingFinished = false;
314 
315 
316   modifier canMint() {
317     require(!mintingFinished);
318     _;
319   }
320 
321   function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
322     totalSupply = totalSupply.add(_amount);
323     balances[_to] = balances[_to].add(_amount);
324     Mint(_to, _amount);
325     Transfer(address(0), _to, _amount);
326     return true;
327   }
328 
329   function finishMinting() public onlyOwner canMint returns (bool) {
330     mintingFinished = true;
331     MintFinished();
332     return true;
333   }
334 }
335 
336 contract FoxTradingToken is MintableToken {
337 
338   string public name;
339   string public symbol;
340   uint8 public decimals;
341 
342   event TokensBurned(address initiatior, address indexed _partner, uint256 _tokens);
343  
344 
345   /**
346    * @dev Constructor that gives the founder all of the existing tokens.
347    */
348     function FoxTradingToken() public {
349         name = "FoxTrading";
350         symbol = "FOXT";
351         decimals = 18;
352         totalSupply = 15000000e18;
353         founder = 0x47dE58a352e40d7FC57Efe57944836a0173206c2;
354         balances[founder] = totalSupply;
355         Transfer(0x0, founder, 15000000e18);
356         pause();
357     }
358 
359     modifier onlyFounder {
360       require(msg.sender == founder);
361       _;
362     }
363 
364     event NewFounderAddress(address indexed from, address indexed to);
365 
366     function changeFounderAddress(address _newFounder) public onlyFounder {
367         require(_newFounder != 0x0);
368         NewFounderAddress(founder, _newFounder);
369         founder = _newFounder;
370     }
371 
372     /*
373     * @dev Token burn function to be called at the time of token swap
374     * @param _partner address to use for token balance buring
375     * @param _tokens uint256 amount of tokens to burn
376     */
377     function burnTokens(address _partner, uint256 _tokens) public onlyFounder {
378         require(balances[_partner] >= _tokens);
379         balances[_partner] = balances[_partner].sub(_tokens);
380         totalSupply = totalSupply.sub(_tokens);
381         TokensBurned(msg.sender, _partner, _tokens);
382     }
383 }
384 
385 
386 contract Crowdsale is Ownable {
387 
388     using SafeMath for uint256;
389 
390     FoxTradingToken public token;
391     uint256 public tokensForPreICO;
392     uint256 public tokenCapForFirstMainStage;
393     uint256 public tokenCapForSecondMainStage;
394     uint256 public tokenCapForThirdMainStage;
395     uint256 public tokenCapForFourthMainStage;
396     uint256 public totalTokensForSale;
397     uint256 public startTime;
398     uint256 public endTime;
399     address public wallet;
400     uint256 public rate;
401     uint256 public weiRaised;
402 
403     uint256[4] public ICObonusStages;
404 
405     uint256 public preICOduration;
406     bool public mainSaleActive;
407 
408     uint256 public tokensSold;
409 
410     /**
411     * event for token purchase logging
412     * @param purchaser who paid for the tokens
413     * @param beneficiary who got the tokens
414     * @param value weis paid for purchase
415     * @param amount amount of tokens purchased
416     */
417     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
418     event ICOSaleExtended(uint256 newEndTime);
419 
420     function Crowdsale() public {
421         token = new FoxTradingToken();  
422         startTime = now; 
423         rate = 1200;
424         wallet = 0x47dE58a352e40d7FC57Efe57944836a0173206c2;
425         tokensForPreICO = 4500000e18;
426 
427         tokenCapForFirstMainStage = 11500000e18;  //7,000,000 + 4,500,000
428         tokenCapForSecondMainStage = 18500000e18;  //11,500,000 + 7,000,000
429         tokenCapForThirdMainStage = 25500000e18;  //18,500,000 + 7,000,000
430         tokenCapForFourthMainStage = 35000000e18;  //25,500,000 + 9,500,000
431 
432         totalTokensForSale = 35000000e18;
433         tokensSold = 0;
434 
435         preICOduration = now.add(31 days);
436         endTime = preICOduration;
437 
438         mainSaleActive = false;
439     }
440 
441     function() external payable {
442         buyTokens(msg.sender);
443     }
444 
445     function buyTokens(address _addr) public payable {
446         require(validPurchase() && tokensSold < totalTokensForSale);
447         require(_addr != 0x0 && msg.value >= 100 finney);  
448         uint256 toMint;
449         if(now <= preICOduration) {
450             if(tokensSold >= tokensForPreICO) { revert(); }
451             toMint = msg.value.mul(rate.mul(2));
452         } else {
453             if(!mainSaleActive) { revert(); }
454             toMint = msg.value.mul(getRateWithBonus());
455         }
456         tokensSold = tokensSold.add(toMint);
457         token.mint(_addr, toMint);
458         forwardFunds();
459     }
460 
461     function forwardFunds() internal {
462         wallet.transfer(msg.value);
463     }
464 
465     function processOfflinePurchase(address _to, uint256 _toMint) public onlyOwner {
466         require(tokensSold.add(_toMint) <= totalTokensForSale);
467         require(_toMint > 0 && _to != 0x0);
468         tokensSold = tokensSold.add(_toMint);
469         token.mint(_to, _toMint);
470     }
471 
472     function validPurchase() internal view returns (bool) {
473         bool withinPeriod = now >= startTime && now <= endTime; 
474         bool nonZeroPurchase = msg.value != 0; 
475         return withinPeriod && nonZeroPurchase;
476     }
477 
478     
479     function finishMinting() public onlyOwner {
480         token.finishMinting();
481     }
482 
483 
484     function getRateWithBonus() internal view returns (uint256 rateWithDiscount) {
485         if (now > preICOduration && tokensSold < totalTokensForSale) {
486             return rate.mul(getCurrentBonus()).div(100).add(rate);
487             return rateWithDiscount;
488         }
489         return rate;
490     }
491 
492     /**
493     * Function is called when the buy function is invoked  only after the pre sale duration and returns 
494     * the current discount in percentage.
495     *
496     * day 31 - 37   / week 1: 20%
497     * day 38 - 44   / week 2: 15%
498     * day 45 - 51   / week 3: 10%
499     * day 52 - 58   / week 4:  0%
500     */
501     function getCurrentBonus() internal view returns (uint256 discount) {
502         require(tokensSold < tokenCapForFourthMainStage);
503         uint256 timeStamp = now;
504         uint256 stage;
505 
506         for (uint i = 0; i < ICObonusStages.length; i++) {
507             if (timeStamp <= ICObonusStages[i]) {
508                 stage = i + 1;
509                 break;
510             } 
511         } 
512 
513         if(stage == 1 && tokensSold < tokenCapForFirstMainStage) { discount = 20; }
514         if(stage == 1 && tokensSold >= tokenCapForFirstMainStage) { discount = 15; }
515         if(stage == 1 && tokensSold >= tokenCapForSecondMainStage) { discount = 10; }
516         if(stage == 1 && tokensSold >= tokenCapForThirdMainStage) { discount = 0; }
517 
518         if(stage == 2 && tokensSold < tokenCapForSecondMainStage) { discount = 15; }
519         if(stage == 2 && tokensSold >= tokenCapForSecondMainStage) { discount = 10; }
520         if(stage == 2 && tokensSold >= tokenCapForThirdMainStage) { discount = 0; }
521 
522         if(stage == 3 && tokensSold < tokenCapForThirdMainStage) { discount = 10; }
523         if(stage == 3 && tokensSold >= tokenCapForThirdMainStage) { discount = 0; }
524 
525         if(stage == 4) { discount = 0; }
526 
527         return discount;
528     }
529 
530 
531     
532     /**
533     * Function activates the main ICO only when the duration of the preICO hass finished. This function
534     * can only be called by the owner of the contract. Once called, the bonus stages will be set as such:
535     * week 1 will have 20% bonus, week 2 will have 15% bonus, week 3 will have 10% bonus and week 4 will 
536     * have no bonus.
537     **/
538     function activateMainSale() public onlyOwner {
539         require(now > preICOduration || tokensSold >= tokensForPreICO);
540         require(!mainSaleActive);
541         if(now < preICOduration) { preICOduration = now; }
542         mainSaleActive = true;
543         ICObonusStages[0] = now.add(7 days);
544 
545         for (uint y = 1; y < ICObonusStages.length; y++) {
546             ICObonusStages[y] = ICObonusStages[y - 1].add(7 days);
547         }
548 
549         endTime = ICObonusStages[3];
550     }
551 
552     function extendDuration(uint256 _newEndTime) public onlyOwner {
553         require(endTime < _newEndTime && mainSaleActive);
554         endTime = _newEndTime;
555         ICOSaleExtended(_newEndTime);
556     }
557 
558 
559     function hasEnded() public view returns (bool) { 
560         return now > endTime;
561     }
562 
563     /**
564     * Allows the owner of the ICO contract to unpause the token contract. This function is needed
565     * because the ICO contract deploys a new instance of the token contract, and by default the 
566     * ETH address which deploys a contract which is Ownable is assigned ownership of the contract,
567     * so the ICO contract is the owner of the token contract. Since unpause is a function which can
568     * only be executed by the owner, by adding this function here, then the owner of the ICO contract
569     * can call this and then the ICO contract will invoke the unpause function of the token contract
570     * and thus the token contract will successfully unpause as its owner the ICO contract invokend
571     * the the function. 
572     */
573     function unpauseToken() public onlyOwner {
574         token.unpause();
575     }
576 }