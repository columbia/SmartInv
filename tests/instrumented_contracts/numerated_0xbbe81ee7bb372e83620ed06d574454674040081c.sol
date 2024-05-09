1 pragma solidity 0.4.17;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address internal owner;
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   function Ownable() public {
26     owner = msg.sender;
27   }
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 }
45 /*
46  * @title AutoCoinICO
47  * @dev AutoCoinCrowdsale is a base contract for managing a token crowdsale.
48  * Crowdsales have a start and end timestamps, where investors can make
49  * token purchases and the crowdsale will assign them ATC tokens based
50  * on a ATC token per ETH rate. Funds collected are forwarded to a wallet
51  * as they arrive.
52  */
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59   mapping(address => uint256) balances;
60   mapping(address => bool) blockListed;
61   /**
62   * @dev transfer token for a specified address
63   * @param _to The address to transfer to.
64   * @param _value The amount to be transferred.
65   */
66   function transfer(address _to, uint256 _value) public returns (bool) {
67     require(_to != address(0));
68     
69     require(
70         balances[msg.sender] >= _value
71         && _value > 0
72         && !blockListed[_to]
73         && !blockListed[msg.sender]
74     );
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 }
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public constant returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108   mapping (address => mapping (address => uint256)) allowed;
109   /**
110    * @dev Transfer tokens from one address to another
111    * @param _from address The address which you want to send tokens from
112    * @param _to address The address which you want to transfer to
113    * @param _value uint256 the amount of tokens to be transferred
114    */
115   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(
118             balances[msg.sender] >= _value
119             && balances[_from] >= _value
120             && _value > 0
121             && !blockListed[_to]
122             && !blockListed[msg.sender]
123     );
124     uint256 _allowance = allowed[_from][msg.sender];
125     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
126     // require (_value <= _allowance);
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133   /**
134    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135    *
136    * Beware that changing an allowance with this method brings the risk that someone may use both the old
137    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140    * @param _spender The address which will spend the funds.
141    * @param _value The amount of tokens to be spent.
142    */
143   function approve(address _spender, uint256 _value) public returns (bool) {
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifying the amount of tokens still available for the spender.
153    */
154   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
155     return allowed[_owner][_spender];
156   }
157 }
158 /**
159  * @title Mintable token
160  * @dev Simple ERC20 Token example, with mintable token creation
161  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
162  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
163  */
164 contract MintableToken is StandardToken, Ownable {
165   event Mint(address indexed to, uint256 amount);
166   event MintFinished();
167   bool public mintingFinished = false;
168   modifier canMint() {
169     require(!mintingFinished);
170     _;
171   }
172   /**
173    * @dev Function to mint tokens
174    * @param _to The address that will receive the minted tokens.
175    * @param _amount The amount of tokens to mint.
176    * @return A boolean that indicates if the operation was successful.
177    */
178   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
179     balances[_to] = balances[_to].add(_amount);
180     Mint(_to, _amount);
181     Transfer(msg.sender, _to, _amount);
182     return true;
183   }
184   /**
185    * @dev Function to stop minting new tokens.
186    * @return True if the operation was successful.
187    */
188   function finishMinting() onlyOwner public returns (bool) {
189     mintingFinished = true;
190     MintFinished();
191     return true;
192   }
193     function addBlockeddUser(address user) public onlyOwner {
194         blockListed[user] = true;
195     }
196     function removeBlockeddUser(address user) public onlyOwner  {
197         blockListed[user] = false;
198     }
199 }
200 /**
201  * @title Pausable
202  * @dev Base contract which allows children to implement an emergency stop mechanism.
203  */
204 contract Pausable is Ownable {
205   event Pause();
206   event Unpause();
207   bool public paused = false;
208   /**
209    * @dev Modifier to make a function callable only when the contract is not paused.
210    */
211   modifier whenNotPaused() {
212     require(!paused);
213     _;
214   }
215   /**
216    * @dev Modifier to make a function callable only when the contract is paused.
217    */
218   modifier whenPaused() {
219     require(paused);
220     _;
221   }
222   /**
223    * @dev called by the owner to pause, triggers stopped state
224    */
225   function pause() onlyOwner whenNotPaused public {
226     paused = true;
227     Pause();
228   }
229   /**
230    * @dev called by the owner to unpause, returns to normal state
231    */
232   function unpause() onlyOwner whenPaused public {
233     paused = false;
234     Unpause();
235   }
236 }
237 /*
238  * @title AutoCoin Crowdsale
239  * @dev Crowdsale is a base contract for managing a token crowdsale.
240  * Crowdsales have a start and end timestamps, where investors can make
241  * token purchases and the crowdsale will assign them tokens based
242  * on a token per ETH rate. Funds collected are forwarded to a wallet
243  * as they arrive.
244  */
245 contract Crowdsale is Ownable, Pausable {
246   using SafeMath for uint256;
247   /*
248    *  @MintableToken token - Token Object
249    *  @address wallet - Wallet Address
250    *  @uint8 rate - Tokens per Ether
251    *  @uint256 weiRaised - Total funds raised in Ethers
252   */
253   MintableToken internal token;
254   address internal wallet;
255   uint256 public rate;
256   uint256 internal weiRaised;
257   /*
258    *  @uint256 privateSaleStartTime - Private-Sale Start Time
259    *  @uint256 privateSaleEndTime - Private-Sale End Time
260    *  @uint256 preSaleStartTime - Pre-Sale Start Time
261    *  @uint256 preSaleEndTime - Pre-Sale End Time
262    *  @uint256 preICOStartTime - Pre-ICO Start Time
263    *  @uint256 preICOEndTime - Pre-ICO End Time
264    *  @uint256 ICOstartTime - ICO Start Time
265    *  @uint256 ICOEndTime - ICO End Time
266   */
267   
268   uint256 public privateSaleStartTime;
269   uint256 public privateSaleEndTime;
270   uint256 public preSaleStartTime;
271   uint256 public preSaleEndTime;
272   uint256 public preICOStartTime;
273   uint256 public preICOEndTime;
274   uint256 public ICOstartTime;
275   uint256 public ICOEndTime;
276   
277   /*
278    *  @uint privateBonus - Private Bonus
279    *  @uint preSaleBonus - Pre-Sale Bonus
280    *  @uint preICOBonus - Pre-Sale Bonus
281    *  @uint firstWeekBonus - ICO 1st Week Bonus
282    *  @uint secondWeekBonus - ICO 2nd Week Bonus
283    *  @uint thirdWeekBonus - ICO 3rd Week Bonus
284    *  @uint forthWeekBonus - ICO 4th Week Bonus
285    *  @uint fifthWeekBonus - ICO 5th Week Bonus
286   */
287   uint256 internal privateSaleBonus;
288   uint256 internal preSaleBonus;
289   uint256 internal preICOBonus;
290   uint256 internal firstWeekBonus;
291   uint256 internal secondWeekBonus;
292   uint256 internal thirdWeekBonus;
293   uint256 internal forthWeekBonus;
294   uint256 internal fifthWeekBonus;
295   uint256 internal weekOne;
296   uint256 internal weekTwo;
297   uint256 internal weekThree;
298   uint256 internal weekFour;
299   uint256 internal weekFive;
300   uint256 internal privateSaleTarget;
301   uint256 public preSaleTarget;
302   uint256 internal preICOTarget;
303   /*
304    *  @uint256 totalSupply - Total supply of tokens 
305    *  @uint256 publicSupply - Total public Supply 
306    *  @uint256 bountySupply - Total Bounty Supply
307    *  @uint256 reservedSupply - Total Reserved Supply 
308    *  @uint256 privateSaleSupply - Total Private Supply from Public Supply  
309    *  @uint256 preSaleSupply - Total PreSale Supply from Public Supply 
310    *  @uint256 preICOSupply - Total PreICO Supply from Public Supply
311    *  @uint256 icoSupply - Total ICO Supply from Public Supply
312   */
313   uint256 public totalSupply = SafeMath.mul(400000000, 1 ether);
314   uint256 internal publicSupply = SafeMath.mul(SafeMath.div(totalSupply,100),55);
315   uint256 internal bountySupply = SafeMath.mul(SafeMath.div(totalSupply,100),6);
316   uint256 internal reservedSupply = SafeMath.mul(SafeMath.div(totalSupply,100),39);
317   uint256 internal privateSaleSupply = SafeMath.mul(24750000, 1 ether);
318   uint256 public preSaleSupply = SafeMath.mul(39187500, 1 ether);
319   uint256 internal preICOSupply = SafeMath.mul(39187500, 1 ether);
320   uint256 internal icoSupply = SafeMath.mul(116875000, 1 ether);
321   /*
322    *  @bool checkUnsoldTokens - Tokens will be added to bounty supply
323    *  @bool upgradePreSaleSupply - Boolean variable updates when the PrivateSale tokens added to PreSale supply
324    *  @bool upgradePreICOSupply - Boolean variable updates when the PreSale tokens added to PreICO supply
325    *  @bool upgradeICOSupply - Boolean variable updates when the PreICO tokens added to ICO supply
326    *  @bool grantFounderTeamSupply - Boolean variable updates when Team and Founder tokens minted
327   */
328   bool public checkUnsoldTokens;
329   bool internal upgradePreSaleSupply;
330   bool internal upgradePreICOSupply;
331   bool internal upgradeICOSupply;
332   /*
333    * event for token purchase logging
334    * @param purchaser who paid for the tokens
335    * @param beneficiary who got the tokens
336    * @param value Wei's paid for purchase
337    * @param amount amount of tokens purchased
338    */
339   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
340   /*
341    * function Crowdsale - Parameterized Constructor
342    * @param _startTime - StartTime of Crowdsale
343    * @param _endTime - EndTime of Crowdsale
344    * @param _rate - Tokens against Ether
345    * @param _wallet - MultiSignature Wallet Address
346    */
347   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) internal {
348     
349     require(_wallet != 0x0);
350     token = createTokenContract();
351     //privateSaleStartTime = _startTime;
352     //privateSaleEndTime = 1537952399;
353     preSaleStartTime = _startTime;
354     preSaleEndTime = 1541581199;
355     preICOStartTime = 1541581200;
356     preICOEndTime = 1544000399; 
357     ICOstartTime = 1544000400;
358     ICOEndTime = _endTime;
359     rate = _rate;
360     wallet = _wallet;
361     //privateSaleBonus = SafeMath.div(SafeMath.mul(rate,50),100);
362     preSaleBonus = SafeMath.div(SafeMath.mul(rate,30),100);
363     preICOBonus = SafeMath.div(SafeMath.mul(rate,30),100);
364     firstWeekBonus = SafeMath.div(SafeMath.mul(rate,20),100);
365     secondWeekBonus = SafeMath.div(SafeMath.mul(rate,15),100);
366     thirdWeekBonus = SafeMath.div(SafeMath.mul(rate,10),100);
367     forthWeekBonus = SafeMath.div(SafeMath.mul(rate,5),100);
368     
369     weekOne = SafeMath.add(ICOstartTime, 14 days);
370     weekTwo = SafeMath.add(weekOne, 14 days);
371     weekThree = SafeMath.add(weekTwo, 14 days);
372     weekFour = SafeMath.add(weekThree, 14 days);
373     weekFive = SafeMath.add(weekFour, 14 days);
374     privateSaleTarget = SafeMath.mul(4500, 1 ether);
375     preSaleTarget = SafeMath.mul(7125, 1 ether);
376     preICOTarget = SafeMath.mul(7125, 1 ether);
377     checkUnsoldTokens = false;
378     upgradeICOSupply = false;
379     upgradePreICOSupply = false;
380     upgradePreSaleSupply = false;
381   
382   }
383   /*
384    * function createTokenContract - Mintable Token Created
385    */
386   function createTokenContract() internal returns (MintableToken) {
387     return new MintableToken();
388   }
389   
390   /*
391    * function Fallback - Receives Ethers
392    */
393   function () payable {
394     buyTokens(msg.sender);
395   }
396     /*
397    * function preSaleTokens - Calculate Tokens in PreSale
398    */
399   // function privateSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
400         
401   //   require(privateSaleSupply > 0);
402   //   require(weiAmount <= privateSaleTarget);
403   //   tokens = SafeMath.add(tokens, weiAmount.mul(privateSaleBonus));
404   //   tokens = SafeMath.add(tokens, weiAmount.mul(rate));
405   //   require(privateSaleSupply >= tokens);
406   //   privateSaleSupply = privateSaleSupply.sub(tokens);        
407   //   privateSaleTarget = privateSaleTarget.sub(weiAmount);
408   //   return tokens;
409   // }
410   /*
411    * function preSaleTokens - Calculate Tokens in PreSale
412    */
413   function preSaleTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
414         
415     require(preSaleSupply > 0);
416     require(weiAmount <= preSaleTarget);
417     if (!upgradePreSaleSupply) {
418       preSaleSupply = SafeMath.add(preSaleSupply, privateSaleSupply);
419       preSaleTarget = SafeMath.add(preSaleTarget, privateSaleTarget);
420       upgradePreSaleSupply = true;
421     }
422     tokens = SafeMath.add(tokens, weiAmount.mul(preSaleBonus));
423     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
424     require(preSaleSupply >= tokens);
425     preSaleSupply = preSaleSupply.sub(tokens);        
426     preSaleTarget = preSaleTarget.sub(weiAmount);
427     return tokens;
428   }
429   /*
430     * function preICOTokens - Calculate Tokens in PreICO
431     */
432   function preICOTokens(uint256 weiAmount, uint256 tokens) internal returns (uint256) {
433         
434     require(preICOSupply > 0);
435     require(weiAmount <= preICOTarget);
436     if (!upgradePreICOSupply) {
437       preICOSupply = SafeMath.add(preICOSupply, preSaleSupply);
438       preICOTarget = SafeMath.add(preICOTarget, preSaleTarget);
439       upgradePreICOSupply = true;
440     }
441     tokens = SafeMath.add(tokens, weiAmount.mul(preICOBonus));
442     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
443     
444     require(preICOSupply >= tokens);
445     
446     preICOSupply = preICOSupply.sub(tokens);        
447     preICOTarget = preICOTarget.sub(weiAmount);
448     return tokens;
449   }
450   /*
451    * function icoTokens - Calculate Tokens in ICO
452    */
453   
454   function icoTokens(uint256 weiAmount, uint256 tokens, uint256 accessTime) internal returns (uint256) {
455         
456     require(icoSupply > 0);
457     if (!upgradeICOSupply) {
458       icoSupply = SafeMath.add(icoSupply,preICOSupply);
459       upgradeICOSupply = true;
460     }
461     
462     if (accessTime <= weekOne) {
463       tokens = SafeMath.add(tokens, weiAmount.mul(firstWeekBonus));
464     } else if (accessTime <= weekTwo) {
465       tokens = SafeMath.add(tokens, weiAmount.mul(secondWeekBonus));
466     } else if ( accessTime < weekThree ) {
467       tokens = SafeMath.add(tokens, weiAmount.mul(thirdWeekBonus));
468     } else if ( accessTime < weekFour ) {
469       tokens = SafeMath.add(tokens, weiAmount.mul(forthWeekBonus));
470     } else if ( accessTime < weekFive ) {
471       tokens = SafeMath.add(tokens, weiAmount.mul(fifthWeekBonus));
472     }
473     
474     tokens = SafeMath.add(tokens, weiAmount.mul(rate));
475     icoSupply = icoSupply.sub(tokens);        
476     return tokens;
477   }
478   /*
479   * function buyTokens - Collect Ethers and transfer tokens
480   */
481   function buyTokens(address beneficiary) whenNotPaused internal {
482     require(beneficiary != 0x0);
483     require(validPurchase());
484     uint256 accessTime = now;
485     uint256 tokens = 0;
486     uint256 weiAmount = msg.value;
487     require((weiAmount >= (100000000000000000)) && (weiAmount <= (20000000000000000000)));
488     if ((accessTime >= preSaleStartTime) && (accessTime < preSaleEndTime)) {
489       tokens = preSaleTokens(weiAmount, tokens);
490     } else if ((accessTime >= preICOStartTime) && (accessTime < preICOEndTime)) {
491       tokens = preICOTokens(weiAmount, tokens);
492     } else if ((accessTime >= ICOstartTime) && (accessTime <= ICOEndTime)) { 
493       tokens = icoTokens(weiAmount, tokens, accessTime);
494     } else {
495       revert();
496     }
497     
498     publicSupply = publicSupply.sub(tokens);
499     weiRaised = weiRaised.add(weiAmount);
500     token.mint(beneficiary, tokens);
501     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
502     forwardFunds();
503   }
504   /*
505    * function forwardFunds - Transfer funds to wallet
506    */
507   function forwardFunds() internal {
508     wallet.transfer(msg.value);
509   }
510   /*
511    * function validPurchase - Checks the purchase is valid or not
512    * @return true - Purchase is withPeriod and nonZero
513    */
514   function validPurchase() internal constant returns (bool) {
515     bool withinPeriod = now >= privateSaleStartTime && now <= ICOEndTime;
516     bool nonZeroPurchase = msg.value != 0;
517     return withinPeriod && nonZeroPurchase;
518   }
519   /*
520    * function hasEnded - Checks the ICO ends or not
521    * @return true - ICO Ends
522    */
523   
524   function hasEnded() public constant returns (bool) {
525     return now > ICOEndTime;
526   }
527   /*
528    * function unsoldToken - Function used to transfer all 
529    *               unsold public tokens to reserve supply
530    */
531   function unsoldToken() onlyOwner public {
532     require(hasEnded());
533     require(!checkUnsoldTokens);
534     
535     checkUnsoldTokens = true;
536     bountySupply = SafeMath.add(bountySupply, publicSupply);
537     publicSupply = 0;
538   }
539   /* 
540    * function getTokenAddress - Get Token Address 
541    */
542   function getTokenAddress() onlyOwner public returns (address) {
543     return token;
544   }
545 }
546 /*
547  * @title AutoCoinToken 
548  */
549  
550 contract AutoCoinToken is MintableToken {
551   /*
552    *  @string name - Token Name
553    *  @string symbol - Token Symbol
554    *  @uint8 decimals - Token Decimals
555    *  @uint256 _totalSupply - Token Total Supply
556   */
557     string public constant name = "AUTO COIN";
558     string public constant symbol = "AUTO COIN";
559     uint8 public constant decimals = 18;
560     uint256 public constant _totalSupply = 400000000000000000000000000;
561   
562 /* Constructor AutoCoinToken */
563     function AutoCoinToken() public {
564         totalSupply = _totalSupply;
565     }
566 }
567 /**
568  * @title SafeMath
569  * @dev Math operations with safety checks that throw on error
570  */
571 library SafeMath {
572   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
573     uint256 c = a * b;
574     assert(a == 0 || c / a == b);
575     return c;
576   }
577   function div(uint256 a, uint256 b) internal constant returns (uint256) {
578     // assert(b > 0); // Solidity automatically throws when dividing by 0
579     uint256 c = a / b;
580     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
581     return c;
582   }
583   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
584     assert(b <= a);
585     return a - b;
586   }
587   function add(uint256 a, uint256 b) internal constant returns (uint256) {
588     uint256 c = a + b;
589     assert(c >= a);
590     return c;
591   }
592 }
593 contract CrowdsaleFunctions is Crowdsale {
594  /* 
595   * function bountyFunds - Transfer bounty tokens via AirDrop
596   * @param beneficiary address where owner wants to transfer tokens
597   * @param tokens value of token
598   */
599     function bountyFunds(address[] beneficiary, uint256[] tokens) public onlyOwner {
600         for (uint256 i = 0; i < beneficiary.length; i++) {
601             tokens[i] = SafeMath.mul(tokens[i],1 ether); 
602             require(beneficiary[i] != 0x0);
603             require(bountySupply >= tokens[i]);
604             
605             bountySupply = SafeMath.sub(bountySupply,tokens[i]);
606             token.mint(beneficiary[i], tokens[i]);
607         }
608     }
609   /* 
610    * function grantReservedToken - Transfer advisor,team and founder tokens  
611    */
612     function grantReservedToken(address beneficiary, uint256 tokens) public onlyOwner {
613         require(beneficiary != 0x0);
614         require(reservedSupply > 0);
615         tokens = SafeMath.mul(tokens,1 ether);
616         require(reservedSupply >= tokens);
617         reservedSupply = SafeMath.sub(reservedSupply,tokens);
618         token.mint(beneficiary, tokens);
619       
620     }
621 /* 
622  *.function transferToken - Used to transfer tokens to investors who pays us other than Ethers
623  * @param beneficiary - Address where owner wants to transfer tokens
624  * @param tokens -  Number of tokens
625  */
626     function singleTransferToken(address beneficiary, uint256 tokens) onlyOwner public {
627         
628         require(beneficiary != 0x0);
629         require(publicSupply > 0);
630         tokens = SafeMath.mul(tokens,1 ether);
631         require(publicSupply >= tokens);
632         publicSupply = SafeMath.sub(publicSupply,tokens);
633         token.mint(beneficiary, tokens);
634     }
635   /* 
636    * function multiTransferToken - Transfer tokens on multiple addresses 
637    */
638     function multiTransferToken(address[] beneficiary, uint256[] tokens) public onlyOwner {
639         for (uint256 i = 0; i < beneficiary.length; i++) {
640             tokens[i] = SafeMath.mul(tokens[i],1 ether); 
641             require(beneficiary[i] != 0x0);
642             require(publicSupply >= tokens[i]);
643             
644             publicSupply = SafeMath.sub(publicSupply,tokens[i]);
645             token.mint(beneficiary[i], tokens[i]);
646         }
647     }
648     function addBlockListed(address user) public onlyOwner {
649         token.addBlockeddUser(user);
650     }
651     
652     function removeBlockListed(address user) public onlyOwner {
653         token.removeBlockeddUser(user);
654     }
655 }
656 contract AutoCoinICO is Crowdsale, CrowdsaleFunctions {
657   
658     /* Constructor AutoCoinICO */
659     function AutoCoinICO(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet)   
660     Crowdsale(_startTime,_endTime,_rate,_wallet) 
661     {
662     }
663     
664     /* AutoCoinToken Contract */
665     function createTokenContract() internal returns (MintableToken) {
666         return new AutoCoinToken();
667     }
668 }