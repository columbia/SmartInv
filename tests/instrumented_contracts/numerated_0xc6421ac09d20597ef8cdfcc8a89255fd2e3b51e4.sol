1 pragma solidity ^0.4.21;
2 
3 // File: contracts\zeppelin-solidity\contracts\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts\zeppelin-solidity\contracts\lifecycle\Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57   /**
58    * @dev Modifier to make a function callable only when the contract is not paused.
59    */
60   modifier whenNotPaused() {
61     require(!paused);
62     _;
63   }
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is paused.
67    */
68   modifier whenPaused() {
69     require(paused);
70     _;
71   }
72 
73   /**
74    * @dev called by the owner to pause, triggers stopped state
75    */
76   function pause() onlyOwner whenNotPaused public {
77     paused = true;
78     Pause();
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused public {
85     paused = false;
86     Unpause();
87   }
88 }
89 
90 // File: contracts\zeppelin-solidity\contracts\math\SafeMath.sol
91 
92 /**
93  * @title SafeMath
94  * @dev Math operations with safety checks that throw on error
95  */
96 library SafeMath {
97 
98   /**
99   * @dev Multiplies two numbers, throws on overflow.
100   */
101   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102     if (a == 0) {
103       return 0;
104     }
105     uint256 c = a * b;
106     assert(c / a == b);
107     return c;
108   }
109 
110   /**
111   * @dev Integer division of two numbers, truncating the quotient.
112   */
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114     // assert(b > 0); // Solidity automatically throws when dividing by 0
115     uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117     return c;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   /**
129   * @dev Adds two numbers, throws on overflow.
130   */
131   function add(uint256 a, uint256 b) internal pure returns (uint256) {
132     uint256 c = a + b;
133     assert(c >= a);
134     return c;
135   }
136 }
137 
138 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
139 
140 /**
141  * @title ERC20Basic
142  * @dev Simpler version of ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/179
144  */
145 contract ERC20Basic {
146   function totalSupply() public view returns (uint256);
147   function balanceOf(address who) public view returns (uint256);
148   function transfer(address to, uint256 value) public returns (bool);
149   event Transfer(address indexed from, address indexed to, uint256 value);
150 }
151 
152 // File: contracts\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
153 
154 /**
155  * @title Basic token
156  * @dev Basic version of StandardToken, with no allowances.
157  */
158 contract BasicToken is ERC20Basic {
159   using SafeMath for uint256;
160 
161   mapping(address => uint256) balances;
162 
163   uint256 totalSupply_;
164 
165   /**
166   * @dev total number of tokens in existence
167   */
168   function totalSupply() public view returns (uint256) {
169     return totalSupply_;
170   }
171 
172   /**
173   * @dev transfer token for a specified address
174   * @param _to The address to transfer to.
175   * @param _value The amount to be transferred.
176   */
177   function transfer(address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[msg.sender]);
180 
181     // SafeMath.sub will throw if there is not enough balance.
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256 balance) {
194     return balances[_owner];
195   }
196 
197 }
198 
199 // File: contracts\zeppelin-solidity\contracts\token\ERC20\BurnableToken.sol
200 
201 /**
202  * @title Burnable Token
203  * @dev Token that can be irreversibly burned (destroyed).
204  */
205 contract BurnableToken is BasicToken {
206 
207   event Burn(address indexed burner, uint256 value);
208 
209   /**
210    * @dev Burns a specific amount of tokens.
211    * @param _value The amount of token to be burned.
212    */
213   function burn(uint256 _value) public {
214     require(_value <= balances[msg.sender]);
215     // no need to require value <= totalSupply, since that would imply the
216     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
217 
218     address burner = msg.sender;
219     balances[burner] = balances[burner].sub(_value);
220     totalSupply_ = totalSupply_.sub(_value);
221     Burn(burner, _value);
222     Transfer(burner, address(0), _value);
223   }
224 }
225 
226 // File: contracts\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
227 
228 /**
229  * @title ERC20 interface
230  * @dev see https://github.com/ethereum/EIPs/issues/20
231  */
232 contract ERC20 is ERC20Basic {
233   function allowance(address owner, address spender) public view returns (uint256);
234   function transferFrom(address from, address to, uint256 value) public returns (bool);
235   function approve(address spender, uint256 value) public returns (bool);
236   event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 // File: contracts\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
240 
241 /**
242  * @title Standard ERC20 token
243  *
244  * @dev Implementation of the basic standard token.
245  * @dev https://github.com/ethereum/EIPs/issues/20
246  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
247  */
248 contract StandardToken is ERC20, BasicToken {
249 
250   mapping (address => mapping (address => uint256)) internal allowed;
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
260     require(_to != address(0));
261     require(_value <= balances[_from]);
262     require(_value <= allowed[_from][msg.sender]);
263 
264     balances[_from] = balances[_from].sub(_value);
265     balances[_to] = balances[_to].add(_value);
266     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
267     Transfer(_from, _to, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273    *
274    * Beware that changing an allowance with this method brings the risk that someone may use both the old
275    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
276    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
277    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
278    * @param _spender The address which will spend the funds.
279    * @param _value The amount of tokens to be spent.
280    */
281   function approve(address _spender, uint256 _value) public returns (bool) {
282     allowed[msg.sender][_spender] = _value;
283     Approval(msg.sender, _spender, _value);
284     return true;
285   }
286 
287   /**
288    * @dev Function to check the amount of tokens that an owner allowed to a spender.
289    * @param _owner address The address which owns the funds.
290    * @param _spender address The address which will spend the funds.
291    * @return A uint256 specifying the amount of tokens still available for the spender.
292    */
293   function allowance(address _owner, address _spender) public view returns (uint256) {
294     return allowed[_owner][_spender];
295   }
296 
297   /**
298    * @dev Increase the amount of tokens that an owner allowed to a spender.
299    *
300    * approve should be called when allowed[_spender] == 0. To increment
301    * allowed value is better to use this function to avoid 2 calls (and wait until
302    * the first transaction is mined)
303    * From MonolithDAO Token.sol
304    * @param _spender The address which will spend the funds.
305    * @param _addedValue The amount of tokens to increase the allowance by.
306    */
307   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
308     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
309     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313   /**
314    * @dev Decrease the amount of tokens that an owner allowed to a spender.
315    *
316    * approve should be called when allowed[_spender] == 0. To decrement
317    * allowed value is better to use this function to avoid 2 calls (and wait until
318    * the first transaction is mined)
319    * From MonolithDAO Token.sol
320    * @param _spender The address which will spend the funds.
321    * @param _subtractedValue The amount of tokens to decrease the allowance by.
322    */
323   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
324     uint oldValue = allowed[msg.sender][_spender];
325     if (_subtractedValue > oldValue) {
326       allowed[msg.sender][_spender] = 0;
327     } else {
328       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
329     }
330     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
331     return true;
332   }
333 
334 }
335 
336 // File: contracts\zeppelin-solidity\contracts\token\ERC20\MintableToken.sol
337 
338 /**
339  * @title Mintable token
340  * @dev Simple ERC20 Token example, with mintable token creation
341  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
342  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
343  */
344 contract MintableToken is StandardToken, Ownable {
345   event Mint(address indexed to, uint256 amount);
346   event MintFinished();
347 
348   bool public mintingFinished = false;
349 
350 
351   modifier canMint() {
352     require(!mintingFinished);
353     _;
354   }
355 
356   /**
357    * @dev Function to mint tokens
358    * @param _to The address that will receive the minted tokens.
359    * @param _amount The amount of tokens to mint.
360    * @return A boolean that indicates if the operation was successful.
361    */
362   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
363     totalSupply_ = totalSupply_.add(_amount);
364     balances[_to] = balances[_to].add(_amount);
365     Mint(_to, _amount);
366     Transfer(address(0), _to, _amount);
367     return true;
368   }
369 
370   /**
371    * @dev Function to stop minting new tokens.
372    * @return True if the operation was successful.
373    */
374   function finishMinting() onlyOwner canMint public returns (bool) {
375     mintingFinished = true;
376     MintFinished();
377     return true;
378   }
379 }
380 
381 // File: contracts\RECORDToken.sol
382 
383 /**
384  *   RECORD token contract
385  */
386 contract RECORDToken is MintableToken, BurnableToken, Pausable {
387     using SafeMath for uint256;
388     string public name = "RECORD";
389     string public symbol = "RCD";
390     uint256 public decimals = 18;
391 
392     mapping (address => bool) public lockedAddresses;
393 
394     function isAddressLocked(address _adr) internal returns (bool) {
395         if (lockedAddresses[_adr] == true) {
396             return true;
397         } else {
398             return false;
399         }
400     }
401     function lockAddress(address _adr) onlyOwner public {
402         lockedAddresses[_adr] = true;
403     }
404     function unlockAddress(address _adr) onlyOwner public {
405         delete lockedAddresses[_adr];
406     }
407     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
408         lockAddress(_to);
409         return super.mint(_to, _amount);
410     }
411 
412     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
413         require(isAddressLocked(_to) == false);
414         return super.transfer(_to, _value);
415     }
416 
417     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
418         require(isAddressLocked(_from) == false);
419         require(isAddressLocked(_to) == false);
420         return super.transferFrom(_from, _to, _value);
421     }
422 
423     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
424         require(isAddressLocked(_spender) == false);
425         return super.approve(_spender, _value);
426     }
427 
428     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
429         require(isAddressLocked(_spender) == false);
430         return super.increaseApproval(_spender, _addedValue);
431     }
432 
433     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
434         require(isAddressLocked(_spender) == false);
435         return super.decreaseApproval(_spender, _subtractedValue);
436     }
437 }
438 
439 // File: contracts\RECORDICO.sol
440 
441 /**
442 *  takes funds from users and issues tokens
443 */
444 contract RECORDICO {
445     // RCD - RECORD token contract
446     RECORDToken public RCD = new RECORDToken();
447     using SafeMath for uint256;
448 
449     // Token price parameters
450     // These parametes can be changed only by manager of contract
451     uint256 public Rate_Eth = 690; // Rate USD per ETH
452 
453     // Crowdfunding parameters
454     uint256 public currentInitPart = 0;
455     uint256 public constant RECORDPart = 18; // 18% of TotalSupply for Record Team
456     uint256 public constant EcosystemPart = 15; // 15% of TotalSupply for Ecosystem
457     uint256 public constant InvestorPart = 5; // 5% of TotalSupply for Investors
458     uint256 public constant AdvisorPart = 8; // 8% of TotalSupply for Advisors & Ambassadors
459     uint256 public constant BountyPart = 4; // 4% of TotalSupply for Bounty
460     uint256 public constant icoPart = 50; // 50% of TotalSupply for PublicICO and PrivateOffer
461     uint256 public constant PreSaleHardCap = 15000000 * 1e18;
462     uint256 public constant RoundAHardCap = 45000000 * 1e18;
463     uint256 public constant RoundBHardCap = 45000000 * 1e18;
464     uint256 public constant RoundCHardCap = 45000000 * 1e18;
465     uint256 public constant totalAmountOnICO = 300000000 * 1e18;
466 
467     uint256 public PreSaleSold = 0;
468     uint256 public RoundASold = 0;
469     uint256 public RoundBSold = 0;
470     uint256 public RoundCSold = 0;
471     uint256 public EthGet = 0;
472     uint256 public RcdGet = 0;
473 
474     // Output ethereum addresses
475     address Company;
476     address Manager; // Manager controls contract
477 
478     uint256 public PreSaleStartTime;
479     uint256 public PreSaleCloseTime;
480     uint256 public IcoStartTime;
481     uint256 public IcoCloseTime;
482 
483     // Allows execution by the contract manager only
484     modifier managerOnly {
485         require(msg.sender == Manager);
486         _;
487     }
488 
489     /**
490      *   @dev Contract constructor function
491      */
492     function RECORDICO(
493         address _Company,
494         address _Manager,
495         uint256 _PreSaleStartTime,
496         uint256 _PreSaleCloseTime,
497         uint256 _IcoStartTime,
498         uint256 _IcoCloseTime
499     )
500     public {
501         Company = _Company;
502         Manager = _Manager;
503         PreSaleStartTime = _PreSaleStartTime;
504         PreSaleCloseTime = _PreSaleCloseTime;
505         IcoStartTime = _IcoStartTime;
506         IcoCloseTime = _IcoCloseTime;
507         RCD.pause(); // ICO중에는 token transfer가 되어서는 안된다.
508     }
509 
510     function getMinMaxInvest() public returns(uint256, uint256) {
511         uint256 _min = 0;
512         uint256 _max = 0;
513         uint256 stage = getStage();
514         if (stage == 1) {
515             _min = 5000 * 1e18;
516             _max = 10000000 * 1e18;
517         } else if (stage == 3 || stage == 4 || stage == 5) {
518             _min = 5000 * 1e18;
519             _max = 50000000 * 1e18;
520         }
521         return (_min, _max);
522     }
523     function getRcdExchange(uint256 _ethValue) public returns(uint256, bool) {
524         uint256 stage = getStage();
525         uint256 _rcdValue = 0;
526         uint256 _usdValue = _ethValue.mul(Rate_Eth);
527         uint256 _rcdValue_Numerator = _usdValue.mul(1000);
528         bool exchangeSuccess = false;
529         if (stage == 1 || stage == 3 || stage == 4 || stage == 5 || stage == 6) {
530             if (stage == 1) {
531                 _rcdValue = _rcdValue_Numerator.div(80);
532             } else if (stage == 3) {
533                 _rcdValue = _rcdValue_Numerator.div(90);
534             } else if (stage == 4) {
535                 _rcdValue = _rcdValue_Numerator.div(95);
536             } else if (stage == 5) {
537                 _rcdValue = _rcdValue_Numerator.div(100);
538             } else {
539                 _rcdValue = 0;
540             }
541         }
542         if (_rcdValue > 0) {
543             exchangeSuccess = true;
544         }
545         return (_rcdValue, exchangeSuccess);
546     }
547     function getStage() public returns(uint256) {
548         // 0: 프리세일 전
549         // 1: 프리세일 중
550         // 2: 프리세일 끝 / ICO 전
551         // 3: RoundA
552         // 4: RoundB
553         // 5: RoundC
554         // 6: Finish
555         // 0. 프리세일 기간 전
556         if (now < PreSaleStartTime) {
557             return 0;
558         }
559         // 1. 프리세일 기간 중
560         if (PreSaleStartTime <= now && now <= PreSaleCloseTime) {
561             if (PreSaleSold < PreSaleHardCap) {
562                 return 1;
563             } else {
564                 return 2;
565             }
566         }
567         // 2. 프리세일 기간 끝
568         if (PreSaleCloseTime <= now && now <= IcoStartTime) {
569             return 2;
570         }
571         // ICO 기간 중
572         if (IcoStartTime <= now && now <= IcoCloseTime) {
573             // 3. RoundA
574             if (RoundASold < RoundAHardCap) {
575                 return 3;
576             }
577             // 4. RoundB
578             else if (RoundAHardCap <= RoundASold && RoundBSold < RoundBHardCap) {
579                 return 4;
580             }
581             // 5. RoundC
582             else if (RoundBHardCap <= RoundBSold && RoundCSold < RoundCHardCap) {
583                 return 5;
584             }
585             // 6. Finish
586             else {
587                 return 6;
588             }
589         }
590         // 6. ICO기간 끝
591         if (IcoCloseTime < now) {
592             return 6;
593         }
594         return 10;
595     }
596 
597     /**
598      *   @dev Set rate of ETH and update token price
599      *   @param _RateEth       current ETH rate
600      */
601     function setRate(uint256 _RateEth) external managerOnly {
602         Rate_Eth = _RateEth;
603     }
604     function setIcoCloseTime(uint256 _IcoCloseTime) external managerOnly {
605         IcoCloseTime = _IcoCloseTime;
606     }
607 
608     function lockAddress(address _adr) managerOnly external {
609         RCD.lockAddress(_adr);
610     }
611 
612     function unlockAddress(address _adr) managerOnly external {
613         RCD.unlockAddress(_adr);
614     }
615 
616     /**
617      *   @dev Enable token transfers
618      */
619     function unfreeze() external managerOnly {
620         RCD.unpause();
621     }
622 
623     /**
624      *   @dev Disable token transfers
625      */
626     function freeze() external managerOnly {
627         RCD.pause();
628     }
629 
630     /**
631      *   @dev Fallback function calls buyTokens() function to buy tokens
632      *        when investor sends ETH to address of ICO contract
633      */
634     function() external payable {
635         buyTokens(msg.sender, msg.value);
636     }
637     /**
638      *   @dev Issue tokens for investors who paid in ether
639      *   @param _investor     address which the tokens will be issued to
640      *   @param _ethValue     number of Ether
641      */
642     function buyTokens(address _investor, uint256 _ethValue) internal {
643         uint256 _rcdValue;
644         bool _rcdExchangeSuccess;
645         uint256 _min;
646         uint256 _max;
647 
648         (_rcdValue, _rcdExchangeSuccess) = getRcdExchange(_ethValue);
649         (_min, _max) = getMinMaxInvest();
650         require (
651             _rcdExchangeSuccess == true &&
652             _min <= _rcdValue &&
653             _rcdValue <= _max
654         );
655         mintICOTokens(_investor, _rcdValue, _ethValue);
656     }
657     function mintICOTokens(address _investor, uint256 _rcdValue, uint256 _ethValue) internal{
658         uint256 stage = getStage();
659         require (
660             stage == 1 ||
661             stage == 3 ||
662             stage == 4 ||
663             stage == 5
664         );
665         if (stage == 1) {
666             require(PreSaleSold.add(_rcdValue) <= PreSaleHardCap);
667             PreSaleSold = PreSaleSold.add(_rcdValue);
668         }
669         if (stage == 3) {
670             if (RoundASold.add(_rcdValue) <= RoundAHardCap) {
671                 RoundASold = RoundASold.add(_rcdValue);
672             } else {
673                 RoundBSold = RoundASold.add(_rcdValue) - RoundAHardCap;
674                 RoundASold = RoundAHardCap;
675             }
676         }
677         if (stage == 4) {
678             if (RoundBSold.add(_rcdValue) <= RoundBHardCap) {
679                 RoundBSold = RoundBSold.add(_rcdValue);
680             } else {
681                 RoundCSold = RoundBSold.add(_rcdValue) - RoundBHardCap;
682                 RoundBSold = RoundBHardCap;
683             }
684         }
685         if (stage == 5) {
686             require(RoundCSold.add(_rcdValue) <= RoundCHardCap);
687             RoundCSold = RoundCSold.add(_rcdValue);
688         }
689         RCD.mint(_investor, _rcdValue);
690         RcdGet = RcdGet.add(_rcdValue);
691         EthGet = EthGet.add(_ethValue);
692     }
693 
694     function mintICOTokensFromExternal(address _investor, uint256 _rcdValue) external managerOnly{
695         mintICOTokens(_investor, _rcdValue, 0);
696     }
697 
698     /*
699      *   @dev Allows Company withdraw investments when round is over
700     */
701     function withdrawEther() external managerOnly{
702         Company.transfer(address(this).balance);
703     }
704 
705     function mintInitialTokens(address _adr, uint256 rate) external managerOnly {
706         require (currentInitPart.add(rate) <= 50);
707         RCD.mint(_adr, rate.mul(totalAmountOnICO).div(100));
708         currentInitPart = currentInitPart.add(rate);
709     }
710 
711     function transferOwnership(address newOwner) external managerOnly{
712         RCD.transferOwnership(newOwner);
713     }
714 }