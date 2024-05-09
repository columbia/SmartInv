1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal constant returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal constant returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45     /**
46      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47      * account.
48      */
49     function Ownable() {
50         owner = msg.sender;
51     }
52 
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) onlyOwner public {
68         require(newOwner != address(0));
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81     uint256 public totalSupply;
82     function balanceOf(address who) public constant returns (uint256);
83     function transfer(address to, uint256 value) public returns (bool);
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92     function allowance(address owner, address spender) public constant returns (uint256);
93     function transferFrom(address from, address to, uint256 value) public returns (bool);
94     function approve(address spender, uint256 value) public returns (bool);
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103     using SafeMath for uint256;
104 
105     mapping(address => uint256) balances;
106 
107     /**
108     * @dev transfer token for a specified address
109     * @param _to The address to transfer to.
110     * @param _value The amount to be transferred.
111     */
112     function transfer(address _to, uint256 _value) public returns (bool) {
113         require(_to != address(0));
114 
115         // SafeMath.sub will throw if there is not enough balance.
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     /**
123     * @dev Gets the balance of the specified address.
124     * @param _owner The address to query the the balance of.
125     * @return An uint256 representing the amount owned by the passed address.
126     */
127     function balanceOf(address _owner) public constant returns (uint256 balance) {
128         return balances[_owner];
129     }
130 
131 }
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implementation of the basic standard token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is ERC20, BasicToken {
141 
142     mapping (address => mapping (address => uint256)) allowed;
143 
144 
145     /**
146      * @dev Transfer tokens from one address to another
147      * @param _from address The address which you want to send tokens from
148      * @param _to address The address which you want to transfer to
149      * @param _value uint256 the amount of tokens to be transferred
150      */
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
152         require(_to != address(0));
153 
154         uint256 _allowance = allowed[_from][msg.sender];
155 
156         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
157         // require (_value <= _allowance);
158 
159         balances[_from] = balances[_from].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         allowed[_from][msg.sender] = _allowance.sub(_value);
162         Transfer(_from, _to, _value);
163         return true;
164     }
165 
166     /**
167      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168      *
169      * Beware that changing an allowance with this method brings the risk that someone may use both the old
170      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      * @param _spender The address which will spend the funds.
174      * @param _value The amount of tokens to be spent.
175      */
176     function approve(address _spender, uint256 _value) public returns (bool) {
177         allowed[msg.sender][_spender] = _value;
178         Approval(msg.sender, _spender, _value);
179         return true;
180     }
181 
182     /**
183      * @dev Function to check the amount of tokens that an owner allowed to a spender.
184      * @param _owner address The address which owns the funds.
185      * @param _spender address The address which will spend the funds.
186      * @return A uint256 specifying the amount of tokens still available for the spender.
187      */
188     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
189         return allowed[_owner][_spender];
190     }
191 
192     /**
193      * approve should be called when allowed[_spender] == 0. To increment
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * From MonolithDAO Token.sol
197      */
198     function increaseApproval (address _spender, uint _addedValue)
199     returns (bool success) {
200         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 
205     function decreaseApproval (address _spender, uint _subtractedValue)
206     returns (bool success) {
207         uint oldValue = allowed[msg.sender][_spender];
208         if (_subtractedValue > oldValue) {
209             allowed[msg.sender][_spender] = 0;
210         } else {
211             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
212         }
213         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         return true;
215     }
216 
217 }
218 
219 /**
220  * @title Pausable
221  * @dev Base contract which allows children to implement an emergency stop mechanism.
222  */
223 contract Pausable is Ownable {
224     event Pause();
225     event Unpause();
226 
227     bool public paused = false;
228 
229 
230     /**
231      * @dev Modifier to make a function callable only when the contract is not paused.
232      */
233     modifier whenNotPaused() {
234         require(!paused);
235         _;
236     }
237 
238     /**
239      * @dev Modifier to make a function callable only when the contract is paused.
240      */
241     modifier whenPaused() {
242         require(paused);
243         _;
244     }
245 
246     /**
247      * @dev called by the owner to pause, triggers stopped state
248      */
249     function pause() onlyOwner whenNotPaused public {
250         paused = true;
251         Pause();
252     }
253 
254     /**
255      * @dev called by the owner to unpause, returns to normal state
256      */
257     function unpause() onlyOwner whenPaused public {
258         paused = false;
259         Unpause();
260     }
261 }
262 
263 /**
264  * @title Pausable token
265  *
266  * @dev StandardToken modified with pausable transfers.
267  **/
268 contract PausableToken is StandardToken, Pausable {
269 
270     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
271         return super.transfer(_to, _value);
272     }
273 
274     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
275         return super.transferFrom(_from, _to, _value);
276     }
277 
278     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
279         return super.approve(_spender, _value);
280     }
281 
282     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
283         return super.increaseApproval(_spender, _addedValue);
284     }
285 
286     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
287         return super.decreaseApproval(_spender, _subtractedValue);
288     }
289 }
290 
291 /**
292  * @title Mintable token
293  * @dev Simple ERC20 Token example, with mintable token creation
294  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
295  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
296  */
297 contract MintableToken is StandardToken, Ownable {
298     event Mint(address indexed to, uint256 amount);
299     event MintFinished();
300 
301     bool public mintingFinished = false;
302 
303 
304     modifier canMint() {
305         require(!mintingFinished);
306         _;
307     }
308 
309     /**
310      * @dev Function to mint tokens
311      * @param _to The address that will receive the minted tokens.
312      * @param _amount The amount of tokens to mint.
313      * @return A boolean that indicates if the operation was successful.
314      */
315     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
316         totalSupply = totalSupply.add(_amount);
317         balances[_to] = balances[_to].add(_amount);
318         Mint(_to, _amount);
319         Transfer(address(0), _to, _amount);
320         return true;
321     }
322 
323     /**
324      * @dev Function to stop minting new tokens.
325      * @return True if the operation was successful.
326      */
327     function finishMinting() onlyOwner canMint public returns (bool) {
328         mintingFinished = true;
329         MintFinished();
330         return true;
331     }
332 }
333 
334 contract BethereumToken is MintableToken, PausableToken {
335     string public constant name = "Bethereum";
336     string public constant symbol = "BTHR";
337     uint256 public constant decimals = 18;
338 
339     function BethereumToken(){
340         pause();
341     }
342 
343 }
344 
345 /**
346  * @title Crowdsale
347  * @dev Crowdsale is a base contract for managing a token crowdsale.
348  * Crowdsales have a start and end timestamps, where investors can make
349  * token purchases and the crowdsale will assign them tokens based
350  * on a token per ETH rate. Funds collected are forwarded to a wallet
351  * as they arrive.
352  */
353 contract Crowdsale {
354     using SafeMath for uint256;
355 
356     // The token being sold
357     MintableToken public token;
358 
359     // start and end timestamps where investments are allowed (both inclusive)
360     uint256 public startTime;
361     uint256 public endTime;
362 
363     // address where funds are collected
364     address public wallet;
365 
366     // amount of raised money in wei
367     uint256 public weiRaised;
368 
369     /**
370      * event for token purchase logging
371      * @param purchaser who paid for the tokens
372      * @param beneficiary who got the tokens
373      * @param value weis paid for purchase
374      * @param amount amount of tokens purchased
375      */
376     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
377 
378 
379     function Crowdsale(uint256 _endTime, address _wallet) {
380 
381         require(_endTime >= now);
382         require(_wallet != 0x0);
383 
384         token = createTokenContract();
385         endTime = _endTime;
386         wallet = _wallet;
387     }
388 
389     // creates the token to be sold.
390     // override this method to have crowdsale of a specific mintable token.
391     function createTokenContract() internal returns (BethereumToken) {
392         return new BethereumToken();
393     }
394 
395 
396     // fallback function can be used to buy tokens
397     function () payable {
398         buyTokens(msg.sender);
399     }
400 
401     // low level token purchase function
402     function buyTokens(address beneficiary) public payable {  }
403 
404     // send ether to the fund collection wallet
405     // override to create custom fund forwarding mechanisms
406     function forwardFunds() internal {
407         wallet.transfer(msg.value);
408     }
409 
410     // @return true if the transaction can buy tokens
411     function validPurchase() internal constant returns (bool) {
412         bool withinPeriod = now >= startTime && now <= endTime;
413         bool nonZeroPurchase = msg.value != 0;
414         return withinPeriod && nonZeroPurchase;
415     }
416 
417     // @return true if crowdsale event has ended
418     function hasEnded() public constant returns (bool) {
419         return now > endTime;
420     }
421 }
422 
423 /**
424  * @title FinalizableCrowdsale
425  * @dev Extension of Crowdsale where an owner can do extra work
426  * after finishing.
427  */
428 contract FinalizableCrowdsale is Crowdsale, Ownable {
429     using SafeMath for uint256;
430 
431     bool public isFinalized = false;
432     
433     bool public weiCapReached = false;
434 
435     event Finalized();
436 
437     /**
438      * @dev Must be called after crowdsale ends, to do some extra finalization
439      * work. Calls the contract's finalization function.
440      */
441     function finalize() onlyOwner public {
442         require(!isFinalized);
443         
444         finalization();
445         Finalized();
446 
447         isFinalized = true;
448     }
449 
450     /**
451      * @dev Can be overridden to add finalization logic. The overriding function
452      * should call super.finalization() to ensure the chain of finalization is
453      * executed entirely.
454      */
455     function finalization() internal {
456     }
457 }
458 
459 contract BTHRTokenSale is FinalizableCrowdsale {
460     using SafeMath for uint256;
461 
462     // Define sale
463     uint public constant RATE = 17500;
464     uint public constant TOKEN_SALE_LIMIT = 25000 * 1000000000000000000;
465 
466     uint256 public constant TOKENS_FOR_OPERATIONS = 400000000*(10**18);
467     uint256 public constant TOKENS_FOR_SALE = 600000000*(10**18);
468 
469     uint public constant TOKENS_FOR_PRESALE = 315000000*(1 ether / 1 wei);
470 
471     uint public constant FRST_CRWDSALE_RATIO = TOKENS_FOR_PRESALE + 147875000*(1 ether / 1 wei);//30% bonus
472     uint public constant SCND_CRWDSALE_RATIO = FRST_CRWDSALE_RATIO + 110687500*(1 ether / 1 wei);//15% bonus
473 
474     enum Phase {
475         Created,//Inital phase after deploy
476         PresaleRunning, //Presale phase
477         Paused, //Pause phase between pre-sale and main token sale or emergency pause function
478         ICORunning, //Crowdsale phase
479         FinishingICO //Final phase when crowdsale is closed and time is up
480     }
481 
482     Phase public currentPhase = Phase.Created;
483 
484     event LogPhaseSwitch(Phase phase);
485 
486     // Constructor
487     function BTHRTokenSale(uint256 _end, address _wallet)
488     FinalizableCrowdsale()
489     Crowdsale(_end, _wallet) {
490     }
491 
492     /// @dev Lets buy you some tokens.
493     function buyTokens(address _buyer) public payable {
494         // Available only if presale or crowdsale is running.
495         require((currentPhase == Phase.PresaleRunning) || (currentPhase == Phase.ICORunning));
496         require(_buyer != address(0));
497         require(msg.value > 0);
498         require(validPurchase());
499 
500         uint tokensWouldAddTo = 0;
501         uint weiWouldAddTo = 0;
502         
503         uint256 weiAmount = msg.value;
504         
505         uint newTokens = msg.value.mul(RATE);
506         
507         weiWouldAddTo = weiRaised.add(weiAmount);
508         
509         require(weiWouldAddTo <= TOKEN_SALE_LIMIT);
510 
511         newTokens = addBonusTokens(token.totalSupply(), newTokens);
512         
513         tokensWouldAddTo = newTokens.add(token.totalSupply());
514         require(tokensWouldAddTo <= TOKENS_FOR_SALE);
515         
516         token.mint(_buyer, newTokens);
517         TokenPurchase(msg.sender, _buyer, weiAmount, newTokens);
518         
519         weiRaised = weiWouldAddTo;
520         forwardFunds();
521         if (weiRaised == TOKENS_FOR_SALE){
522             weiCapReached = true;
523         }
524     }
525 
526     // @dev Adds bonus tokens by token supply bought by user
527     // @param _totalSupply total supply of token bought during pre-sale/crowdsale
528     // @param _newTokens tokens currently bought by user
529     function addBonusTokens(uint256 _totalSupply, uint256 _newTokens) internal view returns (uint256) {
530 
531         uint returnTokens = 0;
532         uint tokensToAdd = 0;
533         uint tokensLeft = _newTokens;
534 
535         if(currentPhase == Phase.PresaleRunning){
536             if(_totalSupply < TOKENS_FOR_PRESALE){
537                 if(_totalSupply + tokensLeft + tokensLeft.mul(50).div(100) > TOKENS_FOR_PRESALE){
538                     tokensToAdd = TOKENS_FOR_PRESALE.sub(_totalSupply);
539                     tokensToAdd = tokensToAdd.mul(100).div(150);
540                     
541                     returnTokens = returnTokens.add(tokensToAdd);
542                     returnTokens = returnTokens.add(tokensToAdd.mul(50).div(100));
543                     tokensLeft = tokensLeft.sub(tokensToAdd);
544                     _totalSupply = _totalSupply.add(tokensToAdd.add(tokensToAdd.mul(50).div(100)));
545                 } else { 
546                     returnTokens = returnTokens.add(tokensLeft).add(tokensLeft.mul(50).div(100));
547                     tokensLeft = tokensLeft.sub(tokensLeft);
548                 }
549             }
550         } 
551         
552         if (tokensLeft > 0 && _totalSupply < FRST_CRWDSALE_RATIO) {
553             
554             if(_totalSupply + tokensLeft + tokensLeft.mul(30).div(100)> FRST_CRWDSALE_RATIO){
555                 tokensToAdd = FRST_CRWDSALE_RATIO.sub(_totalSupply);
556                 tokensToAdd = tokensToAdd.mul(100).div(130);
557                 returnTokens = returnTokens.add(tokensToAdd).add(tokensToAdd.mul(30).div(100));
558                 tokensLeft = tokensLeft.sub(tokensToAdd);
559                 _totalSupply = _totalSupply.add(tokensToAdd.add(tokensToAdd.mul(30).div(100)));
560                 
561             } else { 
562                 returnTokens = returnTokens.add(tokensLeft);
563                 returnTokens = returnTokens.add(tokensLeft.mul(30).div(100));
564                 tokensLeft = tokensLeft.sub(tokensLeft);
565             }
566         }
567         
568         if (tokensLeft > 0 && _totalSupply < SCND_CRWDSALE_RATIO) {
569             
570             if(_totalSupply + tokensLeft + tokensLeft.mul(15).div(100) > SCND_CRWDSALE_RATIO){
571 
572                 tokensToAdd = SCND_CRWDSALE_RATIO.sub(_totalSupply);
573                 tokensToAdd = tokensToAdd.mul(100).div(115);
574                 returnTokens = returnTokens.add(tokensToAdd).add(tokensToAdd.mul(15).div(100));
575                 tokensLeft = tokensLeft.sub(tokensToAdd);
576                 _totalSupply = _totalSupply.add(tokensToAdd.add(tokensToAdd.mul(15).div(100)));
577             } else { 
578                 returnTokens = returnTokens.add(tokensLeft);
579                 returnTokens = returnTokens.add(tokensLeft.mul(15).div(100));
580                 tokensLeft = tokensLeft.sub(tokensLeft);
581             }
582         }
583         
584         if (tokensLeft > 0)  {
585             returnTokens = returnTokens.add(tokensLeft);
586             tokensLeft = tokensLeft.sub(tokensLeft);
587         }
588         return returnTokens;
589     }
590 
591     function validPurchase() internal view returns (bool) {
592         bool withinPeriod = now <= endTime;
593         bool nonZeroPurchase = msg.value != 0;
594         bool isRunning = ((currentPhase == Phase.ICORunning) || (currentPhase == Phase.PresaleRunning));
595         return withinPeriod && nonZeroPurchase && isRunning;
596     }
597 
598     function setSalePhase(Phase _nextPhase) public onlyOwner {
599     
600         bool canSwitchPhase
601         =  (currentPhase == Phase.Created && _nextPhase == Phase.PresaleRunning)
602         || (currentPhase == Phase.PresaleRunning && _nextPhase == Phase.Paused)
603         || ((currentPhase == Phase.PresaleRunning || currentPhase == Phase.Paused)
604         && _nextPhase == Phase.ICORunning)
605         || (currentPhase == Phase.ICORunning && _nextPhase == Phase.Paused)
606         || (currentPhase == Phase.Paused && _nextPhase == Phase.PresaleRunning)
607         || (currentPhase == Phase.Paused && _nextPhase == Phase.FinishingICO)
608         || (currentPhase == Phase.ICORunning && _nextPhase == Phase.FinishingICO);
609 
610         require(canSwitchPhase);
611         currentPhase = _nextPhase;
612         LogPhaseSwitch(_nextPhase);
613     }
614 
615     // Finalize
616     function finalization() internal {
617         uint256 toMint = TOKENS_FOR_OPERATIONS;
618         token.mint(wallet, toMint);
619         token.finishMinting();
620         token.transferOwnership(wallet);
621     }
622 }