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
45 /**
46  * @title HazzaTokenInterface
47 */
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54   mapping(address => uint256) balances;
55   /**
56   * @dev transfer token for a specified address
57   * @param _to The address to transfer to.
58   * @param _value The amount to be transferred.
59   */
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68   /**
69   * @dev Gets the balance of the specified address.
70   * @param _owner The address to query the the balance of.
71   * @return An uint256 representing the amount owned by the passed address.
72   */
73   function balanceOf(address _owner) public constant returns (uint256 balance) {
74     return balances[_owner];
75   }
76 }
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) public constant returns (uint256);
83   function transferFrom(address from, address to, uint256 value) public returns (bool);
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 /**
88  * @title Standard ERC20 token
89  *
90  * @dev Implementation of the basic standard token.
91  * @dev https://github.com/ethereum/EIPs/issues/20
92  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
93  */
94 contract StandardToken is ERC20, BasicToken {
95   mapping (address => mapping (address => uint256)) allowed;
96   /**
97    * @dev Transfer tokens from one address to another
98    * @param _from address The address which you want to send tokens from
99    * @param _to address The address which you want to transfer to
100    * @param _value uint256 the amount of tokens to be transferred
101    */
102   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     uint256 _allowance = allowed[_from][msg.sender];
105     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
106     // require (_value <= _allowance);
107     balances[_from] = balances[_from].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     allowed[_from][msg.sender] = _allowance.sub(_value);
110     Transfer(_from, _to, _value);
111     return true;
112   }
113   /**
114    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
115    *
116    * Beware that changing an allowance with this method brings the risk that someone may use both the old
117    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
118    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
119    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120    * @param _spender The address which will spend the funds.
121    * @param _value The amount of tokens to be spent.
122    */
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128   /**
129    * @dev Function to check the amount of tokens that an owner allowed to a spender.
130    * @param _owner address The address which owns the funds.
131    * @param _spender address The address which will spend the funds.
132    * @return A uint256 specifying the amount of tokens still available for the spender.
133    */
134   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
135     return allowed[_owner][_spender];
136   }
137   /**
138    * approve should be called when allowed[_spender] == 0. To increment
139    * allowed value is better to use this function to avoid 2 calls (and wait until
140    * the first transaction is mined)
141    * From MonolithDAO Token.sol
142    */
143   function increaseApproval (address _spender, uint _addedValue)
144     returns (bool success) {
145     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
146     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149   function decreaseApproval (address _spender, uint _subtractedValue)
150     returns (bool success) {
151     uint oldValue = allowed[msg.sender][_spender];
152     if (_subtractedValue > oldValue) {
153       allowed[msg.sender][_spender] = 0;
154     } else {
155       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
156     }
157     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 }
161 /**
162  * @title Mintable token
163  * @dev Simple ERC20 Token example, with mintable token creation
164  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
165  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
166  */
167 contract MintableToken is StandardToken, Ownable {
168   event Mint(address indexed to, uint256 amount);
169   event MintFinished();
170   bool public mintingFinished = false;
171   modifier canMint() {
172     require(!mintingFinished);
173     _;
174   }
175   /**
176    * @dev Function to mint tokens
177    * @param _to The address that will receive the minted tokens.
178    * @param _amount The amount of tokens to mint.
179    * @return A boolean that indicates if the operation was successful.
180    */
181   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
182     //totalSupply = totalSupply.add(_amount);
183     balances[_to] = balances[_to].add(_amount);
184     Mint(_to, _amount);
185     Transfer(msg.sender, _to, _amount);
186     return true;
187   }
188   /**
189    * @dev Function to stop minting new tokens.
190    * @return True if the operation was successful.
191    */
192   function finishMinting() onlyOwner public returns (bool) {
193     mintingFinished = true;
194     MintFinished();
195     return true;
196   }
197   function burnTokens(uint256 _unsoldTokens) onlyOwner public returns (bool) {
198     totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);
199   }
200 }
201 /**
202  * @title Pausable
203  * @dev Base contract which allows children to implement an emergency stop mechanism.
204  */
205 contract Pausable is Ownable {
206   event Pause();
207   event Unpause();
208   bool public paused = false;
209   /**
210    * @dev Modifier to make a function callable only when the contract is not paused.
211    */
212   modifier whenNotPaused() {
213     require(!paused);
214     _;
215   }
216   /**
217    * @dev Modifier to make a function callable only when the contract is paused.
218    */
219   modifier whenPaused() {
220     require(paused);
221     _;
222   }
223   /**
224    * @dev called by the owner to pause, triggers stopped state
225    */
226   function pause() onlyOwner whenNotPaused public {
227     paused = true;
228     Pause();
229   }
230   /**
231    * @dev called by the owner to unpause, returns to normal state
232    */
233   function unpause() onlyOwner whenPaused public {
234     paused = false;
235     Unpause();
236   }
237 }
238 /**
239  * @title HazzaToken TokenFunctions
240  */
241 contract TokenFunctions is Ownable, Pausable {
242   using SafeMath for uint256;
243   /**
244    *  @MintableToken token - Token Object
245   */
246   MintableToken internal token;
247   struct PrivatePurchaserStruct {
248     uint privatePurchaserTimeLock;
249     uint256 privatePurchaserTokens;
250     uint256 privatePurchaserBonus;
251   }
252   struct AdvisorStruct {
253     uint advisorTimeLock;
254     uint256 advisorTokens;
255   }
256   struct BackerStruct {
257     uint backerTimeLock;
258     uint256 backerTokens;
259   }
260   struct FounderStruct {
261     uint founderTimeLock;
262     uint256 founderTokens;
263   }
264   struct FoundationStruct {
265     uint foundationTimeLock;
266     uint256 foundationBonus;
267     uint256 foundationTokens;
268   }
269   mapping (address => AdvisorStruct) advisor;
270   mapping (address => BackerStruct) backer;
271   mapping (address => FounderStruct) founder;
272   mapping (address => FoundationStruct) foundation;
273   mapping (address => PrivatePurchaserStruct) privatePurchaser;
274   /**
275    *  @uint256 totalSupply - Total supply of tokens 
276    *  @uint256 publicSupply - Total public Supply 
277    *  @uint256 bountySupply - Total Bounty Supply 
278    *  @uint256 privateSupply - Total Private Supply 
279    *  @uint256 advisorSupply - Total Advisor Supply 
280    *  @uint256 backerSupply - Total Backer Supply
281    *  @uint256 founderSupply - Total Founder Supply 
282    *  @uint256 foundationSupply - Total Foundation Supply 
283   */
284       
285   uint256 public totalTokens = 105926908800000000000000000; 
286   uint256 internal publicSupply = 775353800000000000000000; 
287   uint256 internal bountySupply = 657896000000000000000000;
288   uint256 internal privateSupply = 52589473690000000000000000;  
289   uint256 internal advisorSupply = 2834024170000000000000000;
290   uint256 internal backerSupply = 317780730000000000000000;
291   uint256 internal founderSupply = 10592690880000000000000000;
292   uint256 internal foundationSupply = 38159689530000000000000000; 
293   event AdvisorTokenTransfer (address indexed beneficiary, uint256 amount);
294   event BackerTokenTransfer (address indexed beneficiary, uint256 amount);
295   event FoundationTokenTransfer (address indexed beneficiary, uint256 amount);
296   event FounderTokenTransfer (address indexed beneficiary, uint256 amount);
297   event PrivatePurchaserTokenTransfer (address indexed beneficiary, uint256 amount);
298   event AddAdvisor (address indexed advisorAddress, uint timeLock, uint256 advisorToken);
299   event AddBacker (address indexed backerAddress, uint timeLock, uint256 backerToken);
300   event AddFoundation (address indexed foundationAddress, uint timeLock, uint256 foundationToken, uint256 foundationBonus);
301   event AddFounder (address indexed founderAddress, uint timeLock, uint256 founderToken);
302   event BountyTokenTransfer (address indexed beneficiary, uint256 amount);
303   event PublicTokenTransfer (address indexed beneficiary, uint256 amount);
304   event AddPrivatePurchaser (address indexed privatePurchaserAddress, uint timeLock, uint256 privatePurchaserTokens, uint256 privatePurchaserBonus);
305   function addAdvisors (address advisorAddress, uint timeLock, uint256 advisorToken) onlyOwner public returns(bool acknowledgement) {
306       
307       require(now < timeLock || timeLock == 0);
308       require(advisorToken > 0);
309       require(advisorAddress != 0x0);
310       require(advisorSupply >= advisorToken);
311       advisorSupply = SafeMath.sub(advisorSupply,advisorToken);
312       
313       advisor[advisorAddress].advisorTimeLock = timeLock;
314       advisor[advisorAddress].advisorTokens = advisorToken;
315       
316       AddAdvisor(advisorAddress, timeLock, advisorToken);
317       return true;
318         
319   }
320   function getAdvisorStatus (address addr) public view returns(address, uint, uint256) {
321         return (addr, advisor[addr].advisorTimeLock, advisor[addr].advisorTokens);
322   } 
323   function addBackers (address backerAddress, uint timeLock, uint256 backerToken) onlyOwner public returns(bool acknowledgement) {
324       
325       require(now < timeLock || timeLock == 0);
326       require(backerToken > 0);
327       require(backerAddress != 0x0);
328       require(backerSupply >= backerToken);
329       backerSupply = SafeMath.sub(backerSupply,backerToken);
330            
331       backer[backerAddress].backerTimeLock = timeLock;
332       backer[backerAddress].backerTokens = backerToken;
333       
334       AddBacker(backerAddress, timeLock, backerToken);
335       return true;
336         
337   }
338   function getBackerStatus(address addr) public view returns(address, uint, uint256) {
339         return (addr, backer[addr].backerTimeLock, backer[addr].backerTokens);
340   } 
341   function addFounder(address founderAddress, uint timeLock, uint256 founderToken) onlyOwner public returns(bool acknowledgement) {
342       
343       require(now < timeLock || timeLock == 0);
344       require(founderToken > 0);
345       require(founderAddress != 0x0);
346       require(founderSupply >= founderToken);
347       founderSupply = SafeMath.sub(founderSupply,founderToken);  
348       founder[founderAddress].founderTimeLock = timeLock;
349       founder[founderAddress].founderTokens = founderToken;
350       
351       AddFounder(founderAddress, timeLock, founderToken);
352       return true;
353         
354   }
355   function getFounderStatus(address addr) public view returns(address, uint, uint256) {
356         return (addr, founder[addr].founderTimeLock, founder[addr].founderTokens);
357   }
358   function addFoundation(address foundationAddress, uint timeLock, uint256 foundationToken, uint256 foundationBonus) onlyOwner public returns(bool acknowledgement) {
359       
360       require(now < timeLock || timeLock == 0);
361       require(foundationToken > 0);
362       require(foundationBonus > 0);
363       require(foundationAddress != 0x0);
364       uint256 totalTokens = SafeMath.add(foundationToken, foundationBonus);
365       require(foundationSupply >= totalTokens);
366       foundationSupply = SafeMath.sub(foundationSupply, totalTokens);  
367       foundation[foundationAddress].foundationBonus = foundationBonus;
368       foundation[foundationAddress].foundationTimeLock = timeLock;
369       foundation[foundationAddress].foundationTokens = foundationToken;
370       
371       AddFoundation(foundationAddress, timeLock, foundationToken, foundationBonus);
372       return true;
373         
374   }
375   function getFoundationStatus(address addr) public view returns(address, uint, uint256, uint256) {
376         return (addr, foundation[addr].foundationTimeLock, foundation[addr].foundationBonus, foundation[addr].foundationTokens);
377   }
378   function addPrivatePurchaser(address privatePurchaserAddress, uint timeLock, uint256 privatePurchaserToken, uint256 privatePurchaserBonus) onlyOwner public returns(bool acknowledgement) {
379       
380       require(now < timeLock || timeLock == 0);
381       require(privatePurchaserToken > 0);
382       require(privatePurchaserBonus > 0);
383       require(privatePurchaserAddress != 0x0);
384       uint256 totalTokens = SafeMath.add(privatePurchaserToken, privatePurchaserBonus);
385       require(privateSupply >= totalTokens);
386       privateSupply = SafeMath.sub(privateSupply, totalTokens);        
387       privatePurchaser[privatePurchaserAddress].privatePurchaserTimeLock = timeLock;
388       privatePurchaser[privatePurchaserAddress].privatePurchaserTokens = privatePurchaserToken;
389       privatePurchaser[privatePurchaserAddress].privatePurchaserBonus = privatePurchaserBonus;
390       
391       AddPrivatePurchaser(privatePurchaserAddress, timeLock, privatePurchaserToken, privatePurchaserBonus);
392       return true;
393         
394   }
395   function getPrivatePurchaserStatus(address addr) public view returns(address, uint256, uint, uint) {
396         return (addr, privatePurchaser[addr].privatePurchaserTimeLock, privatePurchaser[addr].privatePurchaserTokens, privatePurchaser[addr].privatePurchaserBonus);
397   }
398   function TokenFunctions() internal {
399     token = createTokenContract();
400   }
401   /**
402    * function createTokenContract - Mintable Token Created
403    */
404   function createTokenContract() internal returns (MintableToken) {
405     return new MintableToken();
406   }
407   
408   /** 
409    * function getTokenAddress - Get Token Address 
410    */
411   function getTokenAddress() onlyOwner public returns (address) {
412     return token;
413   }
414 }
415 /**
416  * @title HazzaToken 
417  */
418  
419 contract HazzaToken is MintableToken {
420     /**
421     *  @string name - Token Name
422     *  @string symbol - Token Symbol
423     *  @uint8 decimals - Token Decimals
424     *  @uint256 _totalSupply - Token Total Supply
425     */
426     string public constant name = "HAZZA";
427     string public constant symbol = "HAZ";
428     uint8 public constant decimals = 18;
429     uint256 public constant _totalSupply = 105926908800000000000000000;
430   
431     /** Constructor HazzaToken */
432     function HazzaToken() {
433         totalSupply = _totalSupply;
434     }
435 }
436 /**
437  * @title SafeMath
438  * @dev Math operations with safety checks that throw on error
439  */
440 library SafeMath {
441   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
442     uint256 c = a * b;
443     assert(a == 0 || c / a == b);
444     return c;
445   }
446   function div(uint256 a, uint256 b) internal constant returns (uint256) {
447     // assert(b > 0); // Solidity automatically throws when dividing by 0
448     uint256 c = a / b;
449     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
450     return c;
451   }
452   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
453     assert(b <= a);
454     return a - b;
455   }
456   function add(uint256 a, uint256 b) internal constant returns (uint256) {
457     uint256 c = a + b;
458     assert(c >= a);
459     return c;
460   }
461 }
462 contract TokenDistribution is TokenFunctions {
463   /** 
464   * function grantAdvisorToken - Transfer advisor tokens 
465   */
466     function grantAdvisorToken() public returns(bool response) {
467         require(advisor[msg.sender].advisorTokens > 0);
468         require(now > advisor[msg.sender].advisorTimeLock);
469         uint256 transferToken = advisor[msg.sender].advisorTokens;
470         advisor[msg.sender].advisorTokens = 0;
471         token.mint(msg.sender, transferToken);
472         AdvisorTokenTransfer(msg.sender, transferToken);
473         
474         return true;
475       
476     }
477   /** 
478   * function grantBackerToken - Transfer backer tokens
479   */
480     function grantBackerToken() public returns(bool response) {
481         require(backer[msg.sender].backerTokens > 0);
482         require(now > backer[msg.sender].backerTimeLock);
483         uint256 transferToken = backer[msg.sender].backerTokens;
484         backer[msg.sender].backerTokens = 0;
485         token.mint(msg.sender, transferToken);
486         BackerTokenTransfer(msg.sender, transferToken);
487         
488         return true;
489       
490     }
491   /** 
492   * function grantFoundationToken - Transfer foundation tokens  
493   */
494     function grantFoundationToken() public returns(bool response) {
495   
496         if (now > foundation[msg.sender].foundationTimeLock) {
497                 require(foundation[msg.sender].foundationTokens > 0);
498                 uint256 transferToken = foundation[msg.sender].foundationTokens;
499                 foundation[msg.sender].foundationTokens = 0;
500                 token.mint(msg.sender, transferToken);
501                 FoundationTokenTransfer(msg.sender, transferToken);
502         }
503         
504         if (foundation[msg.sender].foundationBonus > 0) {
505                 uint256 transferTokenBonus = foundation[msg.sender].foundationBonus;
506                 foundation[msg.sender].foundationBonus = 0;
507                 token.mint(msg.sender, transferTokenBonus);
508                 FoundationTokenTransfer(msg.sender, transferTokenBonus);
509         }
510         return true;
511       
512     }
513   /** 
514   * function grantFounderToken - Transfer founder tokens  
515   */
516     function grantFounderToken() public returns(bool response) {
517         require(founder[msg.sender].founderTokens > 0);
518         require(now > founder[msg.sender].founderTimeLock);
519         uint256 transferToken = founder[msg.sender].founderTokens;
520         founder[msg.sender].founderTokens = 0;
521         token.mint(msg.sender, transferToken);
522         FounderTokenTransfer(msg.sender, transferToken);
523         
524         return true;
525       
526     }
527   /** 
528   * function grantPrivatePurchaserToken - Transfer Private Purchasers tokens
529   */
530     function grantPrivatePurchaserToken() public returns(bool response) {
531         if (now > privatePurchaser[msg.sender].privatePurchaserTimeLock) {
532                 require(privatePurchaser[msg.sender].privatePurchaserTokens > 0);
533                 uint256 transferToken = privatePurchaser[msg.sender].privatePurchaserTokens;
534                 privatePurchaser[msg.sender].privatePurchaserTokens = 0;
535                 token.mint(msg.sender, transferToken);
536                 PrivatePurchaserTokenTransfer(msg.sender, transferToken);
537         }
538         
539         if (privatePurchaser[msg.sender].privatePurchaserBonus > 0) {
540                 uint256 transferBonusToken = privatePurchaser[msg.sender].privatePurchaserBonus;
541                 privatePurchaser[msg.sender].privatePurchaserBonus = 0;
542                 token.mint(msg.sender, transferBonusToken);
543                 PrivatePurchaserTokenTransfer(msg.sender, transferBonusToken);
544         }
545         return true;
546       
547     }
548     /** 
549     * function bountyFunds - Transfer bounty tokens via AirDrop
550     * @param beneficiary address where owner wants to transfer tokens
551     * @param tokens value of token
552     */
553     function bountyTransferToken(address[] beneficiary, uint256[] tokens) onlyOwner public {
554         for (uint i = 0; i < beneficiary.length; i++) {
555         require(bountySupply >= tokens[i]);
556         bountySupply = SafeMath.sub(bountySupply, tokens[i]);
557         token.mint(beneficiary[i], tokens[i]);
558         BountyTokenTransfer(beneficiary[i], tokens[i]);
559         
560         }
561     }
562         /** 
563     * function publicTransferToken - Transfer public tokens via AirDrop
564     * @param beneficiary address where owner wants to transfer tokens
565     * @param tokens value of token
566     */
567     function publicTransferToken(address[] beneficiary, uint256[] tokens) onlyOwner public {
568         for (uint i = 0; i < beneficiary.length; i++) {
569         
570         require(publicSupply >= tokens[i]);
571         publicSupply = SafeMath.sub(publicSupply,tokens[i]);
572         token.mint(beneficiary[i], tokens[i]);
573         PublicTokenTransfer(beneficiary[i], tokens[i]);
574         }
575     }
576 }
577 contract HazzaTokenInterface is TokenFunctions, TokenDistribution {
578   
579     /** Constructor HazzaTokenInterface */
580     function HazzaTokenInterface() public TokenFunctions() {
581     }
582     
583     /** HazzaToken Contract */
584     function createTokenContract() internal returns (MintableToken) {
585         return new HazzaToken();
586     }
587 }