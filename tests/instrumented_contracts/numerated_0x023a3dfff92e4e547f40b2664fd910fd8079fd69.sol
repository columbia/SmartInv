1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     if (a == 0) {
30       return 0;
31     }
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     emit Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
222 
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229   address public owner;
230 
231 
232   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234 
235   /**
236    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
237    * account.
238    */
239   function Ownable() public {
240     owner = msg.sender;
241   }
242 
243   /**
244    * @dev Throws if called by any account other than the owner.
245    */
246   modifier onlyOwner() {
247     require(msg.sender == owner);
248     _;
249   }
250 
251   /**
252    * @dev Allows the current owner to transfer control of the contract to a newOwner.
253    * @param newOwner The address to transfer ownership to.
254    */
255   function transferOwnership(address newOwner) public onlyOwner {
256     require(newOwner != address(0));
257     emit OwnershipTransferred(owner, newOwner);
258     owner = newOwner;
259   }
260 
261 }
262 
263 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
264 
265 /**
266  * @title Mintable token
267  * @dev Simple ERC20 Token example, with mintable token creation
268  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
269  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
270  */
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   /**
284    * @dev Function to mint tokens
285    * @param _to The address that will receive the minted tokens.
286    * @param _amount The amount of tokens to mint.
287    * @return A boolean that indicates if the operation was successful.
288    */
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290     totalSupply_ = totalSupply_.add(_amount);
291     balances[_to] = balances[_to].add(_amount);
292     emit Mint(_to, _amount);
293     emit Transfer(address(0), _to, _amount);
294     return true;
295   }
296 
297   /**
298    * @dev Function to stop minting new tokens.
299    * @return True if the operation was successful.
300    */
301   function finishMinting() onlyOwner canMint public returns (bool) {
302     mintingFinished = true;
303     emit MintFinished();
304     return true;
305   }
306 }
307 
308 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
309 
310 /**
311  * @title Burnable Token
312  * @dev Token that can be irreversibly burned (destroyed).
313  */
314 contract BurnableToken is BasicToken {
315 
316   event Burn(address indexed burner, uint256 value);
317 
318   /**
319    * @dev Burns a specific amount of tokens.
320    * @param _value The amount of token to be burned.
321    */
322   function burn(uint256 _value) public {
323     _burn(msg.sender, _value);
324   }
325 
326   function _burn(address _who, uint256 _value) internal {
327     require(_value <= balances[_who]);
328     // no need to require value <= totalSupply, since that would imply the
329     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
330 
331     balances[_who] = balances[_who].sub(_value);
332     totalSupply_ = totalSupply_.sub(_value);
333     emit Burn(_who, _value);
334     emit Transfer(_who, address(0), _value);
335   }
336 }
337 
338 // File: contracts/robonomics/XRT.sol
339 
340 contract XRT is MintableToken, BurnableToken {
341     string public constant name     = "Robonomics Beta";
342     string public constant symbol   = "XRT";
343     uint   public constant decimals = 9;
344 
345     uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
346 
347     constructor() public {
348         totalSupply_ = INITIAL_SUPPLY;
349         balances[msg.sender] = INITIAL_SUPPLY;
350         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
351     }
352 }
353 
354 // File: contracts/robonomics/DutchAuction.sol
355 
356 /// @title Dutch auction contract - distribution of XRT tokens using an auction.
357 /// @author Stefan George - <stefan.george@consensys.net>
358 /// @author Airalab - <research@aira.life> 
359 contract DutchAuction {
360 
361     /*
362      *  Events
363      */
364     event BidSubmission(address indexed sender, uint256 amount);
365 
366     /*
367      *  Constants
368      */
369     uint constant public MAX_TOKENS_SOLD = 8000 * 10**9; // 8M XRT = 10M - 1M (Foundation) - 1M (Early investors base)
370     uint constant public WAITING_PERIOD = 0; // 1 days;
371 
372     /*
373      *  Storage
374      */
375     XRT     public xrt;
376     address public ambix;
377     address public wallet;
378     address public owner;
379     uint public ceiling;
380     uint public priceFactor;
381     uint public startBlock;
382     uint public endTime;
383     uint public totalReceived;
384     uint public finalPrice;
385     mapping (address => uint) public bids;
386     Stages public stage;
387 
388     /*
389      *  Enums
390      */
391     enum Stages {
392         AuctionDeployed,
393         AuctionSetUp,
394         AuctionStarted,
395         AuctionEnded,
396         TradingStarted
397     }
398 
399     /*
400      *  Modifiers
401      */
402     modifier atStage(Stages _stage) {
403         // Contract on stage
404         require(stage == _stage);
405         _;
406     }
407 
408     modifier isOwner() {
409         // Only owner is allowed to proceed
410         require(msg.sender == owner);
411         _;
412     }
413 
414     modifier isWallet() {
415         // Only wallet is allowed to proceed
416         require(msg.sender == wallet);
417         _;
418     }
419 
420     modifier isValidPayload() {
421         require(msg.data.length == 4 || msg.data.length == 36);
422         _;
423     }
424 
425     modifier timedTransitions() {
426         if (stage == Stages.AuctionStarted && calcTokenPrice() <= calcStopPrice())
427             finalizeAuction();
428         if (stage == Stages.AuctionEnded && now > endTime + WAITING_PERIOD)
429             stage = Stages.TradingStarted;
430         _;
431     }
432 
433     /*
434      *  Public functions
435      */
436     /// @dev Contract constructor function sets owner.
437     /// @param _wallet Multisig wallet.
438     /// @param _ceiling Auction ceiling.
439     /// @param _priceFactor Auction price factor.
440     constructor(address _wallet, uint _ceiling, uint _priceFactor)
441         public
442     {
443         require(_wallet != 0 && _ceiling != 0 && _priceFactor != 0);
444         owner = msg.sender;
445         wallet = _wallet;
446         ceiling = _ceiling;
447         priceFactor = _priceFactor;
448         stage = Stages.AuctionDeployed;
449     }
450 
451     /// @dev Setup function sets external contracts' addresses.
452     /// @param _xrt Robonomics token address.
453     /// @param _ambix Distillation cube address.
454     function setup(address _xrt, address _ambix)
455         public
456         isOwner
457         atStage(Stages.AuctionDeployed)
458     {
459         // Validate argument
460         require(_xrt != 0 && _ambix != 0);
461         xrt = XRT(_xrt);
462         ambix = _ambix;
463 
464         // Validate token balance
465         require(xrt.balanceOf(this) == MAX_TOKENS_SOLD);
466 
467         stage = Stages.AuctionSetUp;
468     }
469 
470     /// @dev Starts auction and sets startBlock.
471     function startAuction()
472         public
473         isWallet
474         atStage(Stages.AuctionSetUp)
475     {
476         stage = Stages.AuctionStarted;
477         startBlock = block.number;
478     }
479 
480     /// @dev Changes auction ceiling and start price factor before auction is started.
481     /// @param _ceiling Updated auction ceiling.
482     /// @param _priceFactor Updated start price factor.
483     function changeSettings(uint _ceiling, uint _priceFactor)
484         public
485         isWallet
486         atStage(Stages.AuctionSetUp)
487     {
488         ceiling = _ceiling;
489         priceFactor = _priceFactor;
490     }
491 
492     /// @dev Calculates current token price.
493     /// @return Returns token price.
494     function calcCurrentTokenPrice()
495         public
496         timedTransitions
497         returns (uint)
498     {
499         if (stage == Stages.AuctionEnded || stage == Stages.TradingStarted)
500             return finalPrice;
501         return calcTokenPrice();
502     }
503 
504     /// @dev Returns correct stage, even if a function with timedTransitions modifier has not yet been called yet.
505     /// @return Returns current auction stage.
506     function updateStage()
507         public
508         timedTransitions
509         returns (Stages)
510     {
511         return stage;
512     }
513 
514     /// @dev Allows to send a bid to the auction.
515     /// @param receiver Bid will be assigned to this address if set.
516     function bid(address receiver)
517         public
518         payable
519         isValidPayload
520         timedTransitions
521         atStage(Stages.AuctionStarted)
522         returns (uint amount)
523     {
524         require(msg.value > 0);
525         amount = msg.value;
526 
527         // If a bid is done on behalf of a user via ShapeShift, the receiver address is set.
528         if (receiver == 0)
529             receiver = msg.sender;
530 
531         // Prevent that more than 90% of tokens are sold. Only relevant if cap not reached.
532         uint maxWei = MAX_TOKENS_SOLD * calcTokenPrice() / 10**9 - totalReceived;
533         uint maxWeiBasedOnTotalReceived = ceiling - totalReceived;
534         if (maxWeiBasedOnTotalReceived < maxWei)
535             maxWei = maxWeiBasedOnTotalReceived;
536 
537         // Only invest maximum possible amount.
538         if (amount > maxWei) {
539             amount = maxWei;
540             // Send change back to receiver address. In case of a ShapeShift bid the user receives the change back directly.
541             receiver.transfer(msg.value - amount);
542         }
543 
544         // Forward funding to ether wallet
545         wallet.transfer(amount);
546 
547         bids[receiver] += amount;
548         totalReceived += amount;
549         BidSubmission(receiver, amount);
550 
551         // Finalize auction when maxWei reached
552         if (amount == maxWei)
553             finalizeAuction();
554     }
555 
556     /// @dev Claims tokens for bidder after auction.
557     /// @param receiver Tokens will be assigned to this address if set.
558     function claimTokens(address receiver)
559         public
560         isValidPayload
561         timedTransitions
562         atStage(Stages.TradingStarted)
563     {
564         if (receiver == 0)
565             receiver = msg.sender;
566         uint tokenCount = bids[receiver] * 10**9 / finalPrice;
567         bids[receiver] = 0;
568         require(xrt.transfer(receiver, tokenCount));
569     }
570 
571     /// @dev Calculates stop price.
572     /// @return Returns stop price.
573     function calcStopPrice()
574         view
575         public
576         returns (uint)
577     {
578         return totalReceived * 10**9 / MAX_TOKENS_SOLD + 1;
579     }
580 
581     /// @dev Calculates token price.
582     /// @return Returns token price.
583     function calcTokenPrice()
584         view
585         public
586         returns (uint)
587     {
588         return priceFactor * 10**18 / (block.number - startBlock + 7500) + 1;
589     }
590 
591     /*
592      *  Private functions
593      */
594     function finalizeAuction()
595         private
596     {
597         stage = Stages.AuctionEnded;
598         finalPrice = totalReceived == ceiling ? calcTokenPrice() : calcStopPrice();
599         uint soldTokens = totalReceived * 10**9 / finalPrice;
600 
601         if (totalReceived == ceiling) {
602             // Auction contract transfers all unsold tokens to Ambix contract
603             require(xrt.transfer(ambix, MAX_TOKENS_SOLD - soldTokens));
604         } else {
605             // Auction contract burn all unsold tokens
606             xrt.burn(MAX_TOKENS_SOLD - soldTokens);
607         }
608 
609         endTime = now;
610     }
611 }