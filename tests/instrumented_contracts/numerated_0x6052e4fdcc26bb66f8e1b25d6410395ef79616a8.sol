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
95     emit Transfer(msg.sender, _to, _value);
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
136     emit Transfer(_from, _to, _value);
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
152     emit Approval(msg.sender, _spender, _value);
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
174     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
185     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
228     emit OwnershipTransferred(owner, newOwner);
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
269         emit Pause();
270     }
271     
272 
273     /**
274     * @dev called by the owner to unpause, returns to normal state
275     */
276     function unpause() public onlyOwner whenPaused {
277         paused = false;
278         emit Unpause();
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
324     emit Mint(_to, _amount);
325     emit Transfer(address(0), _to, _amount);
326     return true;
327   }
328 
329   function finishMinting() public onlyOwner canMint returns (bool) {
330     mintingFinished = true;
331     emit MintFinished();
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
349         name = "Fox Trading";
350         symbol = "FOXT";
351         decimals = 18;
352         totalSupply = 3000000e18;
353         founder = 0x698825d0CfeeD6F65E981FFB543ef5196A5C2A5A;
354         balances[founder] = totalSupply;
355         emit Transfer(0x0, founder, totalSupply);
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
368         emit NewFounderAddress(founder, _newFounder);
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
381         emit TokensBurned(msg.sender, _partner, _tokens);
382     }
383 }
384 
385 
386 contract Crowdsale is Ownable {
387 
388     using SafeMath for uint256;
389 
390     FoxTradingToken public token;
391 
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
402     bool public ICOpaused;
403 
404     uint256[4] public ICObonusStages;
405 
406     uint256 public tokensSold;
407 
408     /**
409     * event for token purchase logging
410     * @param purchaser who paid for the tokens
411     * @param beneficiary who got the tokens
412     * @param value weis paid for purchase
413     * @param amount amount of tokens purchased
414     */
415     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
416     event ICOSaleExtended(uint256 newEndTime);
417 
418     function Crowdsale() public {
419         token = new FoxTradingToken();  
420         startTime = now; 
421         rate = 1200;
422         wallet = 0x698825d0CfeeD6F65E981FFB543ef5196A5C2A5A;
423         totalTokensForSale = 6200000e18;
424         tokensSold = 0;
425 
426         tokenCapForFirstMainStage = 1000000e18;
427         tokenCapForSecondMainStage = 2000000e18;  
428         tokenCapForThirdMainStage = 3000000e18;  
429         tokenCapForFourthMainStage = 6200000e18; 
430     
431         ICObonusStages[0] = now.add(7 days);
432         for (uint y = 1; y < ICObonusStages.length; y++) {
433             ICObonusStages[y] = ICObonusStages[y - 1].add(7 days);
434         }
435         
436         endTime = ICObonusStages[3];
437         
438         ICOpaused = false;
439     }
440     
441     modifier whenNotPaused {
442         require(!ICOpaused);
443         _;
444     }
445 
446     function() external payable {
447         buyTokens(msg.sender);
448     }
449 
450     function buyTokens(address _addr) public payable whenNotPaused {
451         require(validPurchase() && tokensSold < totalTokensForSale);
452         require(_addr != 0x0 && msg.value >= 100 finney);  
453         uint256 toMint;
454         toMint = msg.value.mul(getRateWithBonus());
455         tokensSold = tokensSold.add(toMint);
456         token.mint(_addr, toMint);
457         forwardFunds();
458     }
459 
460     function forwardFunds() internal {
461         wallet.transfer(msg.value);
462     }
463 
464     function processOfflinePurchase(address _to, uint256 _toMint) public onlyOwner {
465         require(tokensSold.add(_toMint) <= totalTokensForSale);
466         require(_toMint > 0 && _to != 0x0);
467         tokensSold = tokensSold.add(_toMint);
468         token.mint(_to, _toMint);
469     }
470     
471     
472     /**
473      * @param _addrs The array of ETH addresses
474      * @param _values The amount of tokens to send to each address
475      * */
476     function airDrop(address[] _addrs, uint256[] _values) public onlyOwner {
477         //require(_addrs.length > 0);
478         for (uint i = 0; i < _addrs.length; i++) {
479             if (_addrs[i] != 0x0 && _values[i] > 0) {
480                 token.mint(_addrs[i], _values[i]);
481             }
482         }
483     }
484 
485 
486     function validPurchase() internal view returns (bool) {
487         bool withinPeriod = now >= startTime && now <= endTime; 
488         bool nonZeroPurchase = msg.value != 0; 
489         return withinPeriod && nonZeroPurchase;
490     }
491 
492     
493     function finishMinting() public onlyOwner {
494         token.finishMinting();
495     }
496     
497     function getRateWithBonus() internal view returns (uint256 rateWithDiscount) {
498         if (tokensSold < totalTokensForSale) {
499             return rate.mul(getCurrentBonus()).div(100).add(rate);
500             return rateWithDiscount;
501         }
502         return rate;
503     }
504 
505     /**
506     * Function is called when the buy function is invoked  only after the pre sale duration and returns 
507     * the current discount in percentage.
508     *
509     * day 31 - 37   / week 1: 20%
510     * day 38 - 44   / week 2: 15%
511     * day 45 - 51   / week 3: 10%
512     * day 52 - 58   / week 4:  0%
513     */
514     function getCurrentBonus() internal view returns (uint256 discount) {
515         require(tokensSold < tokenCapForFourthMainStage);
516         uint256 timeStamp = now;
517         uint256 stage;
518 
519         for (uint i = 0; i < ICObonusStages.length; i++) {
520             if (timeStamp <= ICObonusStages[i]) {
521                 stage = i + 1;
522                 break;
523             } 
524         } 
525 
526         if(stage == 1 && tokensSold < tokenCapForFirstMainStage) { discount = 20; }
527         if(stage == 1 && tokensSold >= tokenCapForFirstMainStage) { discount = 15; }
528         if(stage == 1 && tokensSold >= tokenCapForSecondMainStage) { discount = 10; }
529         if(stage == 1 && tokensSold >= tokenCapForThirdMainStage) { discount = 0; }
530 
531         if(stage == 2 && tokensSold < tokenCapForSecondMainStage) { discount = 15; }
532         if(stage == 2 && tokensSold >= tokenCapForSecondMainStage) { discount = 10; }
533         if(stage == 2 && tokensSold >= tokenCapForThirdMainStage) { discount = 0; }
534 
535         if(stage == 3 && tokensSold < tokenCapForThirdMainStage) { discount = 10; }
536         if(stage == 3 && tokensSold >= tokenCapForThirdMainStage) { discount = 0; }
537 
538         if(stage == 4) { discount = 0; }
539 
540         return discount;
541     }
542 
543 
544 
545     function extendDuration(uint256 _newEndTime) public onlyOwner {
546         require(endTime < _newEndTime);
547         endTime = _newEndTime;
548         emit ICOSaleExtended(_newEndTime);
549     }
550 
551 
552     function hasEnded() public view returns (bool) { 
553         return now > endTime;
554     }
555 
556     /**
557     * Allows the owner of the ICO contract to unpause the token contract. This function is needed
558     * because the ICO contract deploys a new instance of the token contract, and by default the 
559     * ETH address which deploys a contract which is Ownable is assigned ownership of the contract,
560     * so the ICO contract is the owner of the token contract. Since unpause is a function which can
561     * only be executed by the owner, by adding this function here, then the owner of the ICO contract
562     * can call this and then the ICO contract will invoke the unpause function of the token contract
563     * and thus the token contract will successfully unpause as its owner the ICO contract invokend
564     * the the function. 
565     */
566     function unpauseToken() public onlyOwner {
567         token.unpause();
568     }
569     
570     function pauseUnpauseICO() public onlyOwner {
571         if (ICOpaused) {
572             ICOpaused = false;
573         } else {
574             ICOpaused = true;
575         }
576     }
577 }