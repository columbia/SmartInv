1 /**
2  * @title Standard ERC20 token
3  *
4  * @dev Implementation of the basic standard token.
5  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity
6  *
7  * The AFW token contract bases on the ERC20 standard token contracts 
8  * Company Optimum Consulting - Courbevoie
9  * */
10  
11 pragma solidity ^0.4.21;
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return a / b;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   function Ownable() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     require(newOwner != address(0));
91     emit OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 /**
98  * @title ERC20Basic
99  * @dev Simpler version of ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/179
101  */
102 contract ERC20Basic {
103   function totalSupply() public view returns (uint256);
104   function balanceOf(address who) public view returns (uint256);
105   function transfer(address to, uint256 value) public returns (bool);
106   event Transfer(address indexed from, address indexed to, uint256 value);
107 }
108 
109 /**
110  * @title ERC20 interface
111  * @dev see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 /**
121  * @title Basic token
122  * @dev Basic version of StandardToken, with no allowances.
123  */
124 contract BasicToken is ERC20Basic {
125   using SafeMath for uint256;
126 
127   mapping(address => uint256) balances;
128 
129   uint256 totalSupply_;
130 
131   /**
132   * @dev total number of tokens in existence
133   */
134   function totalSupply() public view returns (uint256) {
135     return totalSupply_;
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[msg.sender]);
146 
147     balances[msg.sender] = balances[msg.sender].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149     emit Transfer(msg.sender, _to, _value);
150     return true;
151   }
152 
153   /**
154   * @dev Gets the balance of the specified address.
155   * @param _owner The address to query the the balance of.
156   * @return An uint256 representing the amount owned by the passed address.
157   */
158   function balanceOf(address _owner) public view returns (uint256 balance) {
159     return balances[_owner];
160   }
161 
162 }
163 
164 /**
165  * @title SafeERC20
166  * @dev Wrappers around ERC20 operations that throw on failure.
167  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
168  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
169  */
170 library SafeERC20 {
171   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
172     assert(token.transfer(to, value));
173   }
174 
175   function safeTransferFrom(
176     ERC20 token,
177     address from,
178     address to,
179     uint256 value
180   )
181     internal
182   {
183     assert(token.transferFrom(from, to, value));
184   }
185 
186   function safeApprove(ERC20 token, address spender, uint256 value) internal {
187     assert(token.approve(spender, value));
188   }
189 }
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * @dev Implementation of the basic standard token.
195  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity
196  */
197 contract Pausable is Ownable {
198 
199   uint public endDate;
200 
201   /**
202    * @dev modifier to allow actions only when the contract IS not paused
203    */
204   modifier whenNotPaused() {
205     require(now >= endDate);
206     _;
207   }
208 
209 }
210 
211 contract StandardToken is ERC20, BasicToken, Pausable {
212     using SafeMath for uint256;
213     mapping (address => mapping (address => uint256)) internal allowed;
214 
215   mapping(address => uint256) balances;
216 
217   /**
218   * @dev transfer token for a specified address
219   * @param _to The address to transfer to.
220   * @param _value The amount to be transferred.
221   */
222   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
223     require(_to != address(0));
224     balances[msg.sender] = balances[msg.sender].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     emit Transfer(msg.sender, _to, _value);
227     return true;
228   }
229 
230   /**
231   * @dev Gets the balance of the specified address.
232   * @param _owner The address to query the the balance of.
233   * @return An uint256 representing the amount owned by the passed address.
234   */
235   function balanceOf(address _owner) public constant returns (uint256 balance) {
236     return balances[_owner];
237   }
238 
239 
240   /**
241    * @dev Transfer tokens from one address to another
242    * @param _from address The address which you want to send tokens from
243    * @param _to address The address which you want to transfer to
244    * @param _value uint256 the amount of tokens to be transferred
245    */
246   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
247     require(_to != address(0));
248     require(_value <= allowed[_from][msg.sender]);
249 
250     balances[_from] = balances[_from].sub(_value);
251     balances[_to] = balances[_to].add(_value);
252     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
253     emit Transfer(_from, _to, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
259    *
260    * Beware that changing an allowance with this method brings the risk that someone may use both the old
261    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
262    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
263    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264    * @param _spender The address which will spend the funds.
265    * @param _value The amount of tokens to be spent.
266    */
267   function approve(address _spender, uint256 _value) public returns (bool) {
268     allowed[msg.sender][_spender] = _value;
269     emit Approval(msg.sender, _spender, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Function to check the amount of tokens that an owner allowed to a spender.
275    * @param _owner address The address which owns the funds.
276    * @param _spender address The address which will spend the funds.
277    * @return A uint256 specifying the amount of tokens still available for the spender.
278    */
279   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
280     return allowed[_owner][_spender];
281   }
282 
283   /**
284    * approve should be called when allowed[_spender] == 0. To increment
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    */
289   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
290     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
291     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
292     return true;
293   }
294 
295   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306   }
307  
308 
309 /**
310  * @title Burnable Token
311  * @dev Token that can be irreversibly burned (destroyed).
312  */
313 contract BurnableToken is StandardToken {
314 
315     /**
316      * @dev Burns a specific amount of tokens.
317      * @param _value The amount of token to be burned.
318      */
319     function burn(uint256  _value)
320         public onlyOwner
321     {
322         require(_value > 0);
323 		require(balances[msg.sender] >= _value);
324         address burner = msg.sender;
325         balances[burner] = balances[burner].sub(_value);
326         totalSupply_ = totalSupply_.sub(_value);
327         emit Burn(burner, _value);
328     }
329     event Burn(address indexed burner, uint256  indexed value);
330 } 
331    
332 contract AFWToken is StandardToken , BurnableToken  {
333     using SafeMath for uint256;
334     string public constant name = "All4FW";
335     string public constant symbol = "AFW";
336     uint8 public constant decimals = 18;	
337 	
338 	// wallets address for allocation	
339 	address public Bounties_Wallet = 0xA7135CbD1281d477eef4FC7F0AB19566A47bE759; // 5% : Bounty
340 	address public Team_Wallet = 0xaA1582A5b00fDEc47FeD1CcDDe7e5fA3652B456b; // 8% : Equity & Team
341 	address public OEM_Wallet = 0x51e32712C65AEFAAea9d0b7336A975f400825309; // 10% : Community Builting, Biz Dev
342 	address public LA_wallet = 0xBaC4B80b6C74518bF31b5cE1be80926ffEEBB4db; //8% : Legal & advisors
343     
344 	address public tokenWallet = 0x4CE38c5f44794d6173Dd3BBaf208EeEf2033370A;    
345 	uint256 public constant INITIAL_SUPPLY = 100000000 ether;	
346 	
347 	
348 	/// Base exchange rate is set to 1 ETH = 650 AFW.
349 	uint256 tokenRate = 650; 
350 	
351 	
352     function AFWToken() public {
353         totalSupply_ = INITIAL_SUPPLY;
354 		
355 		// InitialDistribution
356 		// 31% ---> 31000000
357 		balances[Bounties_Wallet] = INITIAL_SUPPLY.mul(5).div(100) ;
358 		balances[Team_Wallet] = INITIAL_SUPPLY.mul(8).div(100);
359 		balances[OEM_Wallet] = INITIAL_SUPPLY.mul(10).div(100) ;
360 		balances[LA_wallet] = INITIAL_SUPPLY.mul(8).div(100) ;
361 		
362 		// 69% ---> 69000000
363         balances[tokenWallet] = INITIAL_SUPPLY.mul(69).div(100);
364 		
365         endDate = _endDate;
366 				
367         emit Transfer(0x0, Bounties_Wallet, balances[Bounties_Wallet]);
368         emit Transfer(0x0, Team_Wallet, balances[Team_Wallet]);
369 		emit Transfer(0x0, OEM_Wallet, balances[OEM_Wallet]);
370         emit Transfer(0x0, LA_wallet, balances[LA_wallet]);
371 				
372 		emit Transfer(0x0, tokenWallet, balances[tokenWallet]);
373     }
374 
375 	///-------------------------------------- Pres-Sale / Main Sale	
376     ///
377     /// startTime                                                      												endTime
378     ///     
379 	///		2 Days		  	5 Days				6 Days			6 Days								1 Month				
380 	///	    750 000 AFW		900 000 AFW1		500 000 AFW		1 850 000 AFW						69 000 000 AFW
381     ///  O--------------O-----------------O------------------O-------------------O--------O------------------------->
382     ///     Disc 20 %     	Disc 10 %          	Disc 5 %        Disc 3 %           Closed            Main Sale 0%			Finalized
383     
384 
385 	/**
386 	******** DATE PReICO - ICO */
387     uint public constant startDate = 1524866399; /// Start Pre-sale - Friday 27 April 2018 23:59:59
388     uint public constant endPreICO = 1526680799;/// Close Pre-Sale - Friday 18 May 2018 23:59:59
389 	
390 	/// HOT sale start time
391     uint constant preSale20 = startDate ; /// Start Pre-sale 20% - Friday 27 April 2018 23:59:59
392     uint constant preSale10 = 1525039200; /// Start Pre-sale 10% - Monday 30 April 2018 00:00:00
393     uint constant preSale5 = 1525471200; /// Start Pre-sale 5% - Saturday 5 May 2018 00:00:00
394 	uint constant preSale3 = 1525989600; /// Start Pre-sale 3% - Friday 11 May 2018 00:00:00  
395 			
396     uint public constant startICO = 1526680800; /// Start Main Sale - Saturday 19 May 2018 00:00:00
397     uint public constant _endDate = 1529186399; /// Close Main Sale - Saturday 16 June 2018 23:59:59 
398 
399     struct Stat {
400         uint currentFundraiser;
401         uint btcAmount;
402         uint ethAmount;
403         uint txCounter;
404     }    
405     Stat public stat;    
406 	
407 	/// Maximum tokens to be allocated on the sale (69% of the hard cap)
408     uint public constant preIcoCap = 5000000 ether;
409     uint public constant IcoCap = 64000000 ether;
410 
411 	/// token caps for each round
412 	uint256[4] private StepCaps = [
413         750000 ether, 	/// 20% 
414         900000 ether, 	/// 10%
415         1500000 ether, 	/// 5%
416         1850000 ether 	/// 3%
417     ];	
418 	uint8[4] private StepDiscount = [20, 10, 5, 3];
419 		
420     /**
421      * @dev modifier to allow actions only when Pre-ICO end date is now
422      */
423     modifier isFinished() {
424         require(now >= endDate);
425         _;
426     }
427 	
428 	/// @return the index of the current discount by date.
429     function currentStepIndexByDate() internal view returns (uint8 roundNum) {
430         require(now <= endPreICO); 
431         if(now > preSale3) return 3;
432         if(now > preSale5) return 2;
433         if(now > preSale10) return 1;
434         if(now > preSale20) return 0;
435         else return 0;
436     }
437 	
438 
439     /// @return integer representing the index of the current sale round
440     function currentStepIndex() internal view returns (uint8 roundNum) {
441         roundNum = currentStepIndexByDate();
442         /// round determined by conjunction of both time and total sold tokens
443         while(roundNum < 3 && stat.currentFundraiser > StepCaps[roundNum]) {
444             roundNum++;
445         }
446     }
447 
448 	/// @dev Function for calculate the price
449 	/// @dev Compute the amount of AFW token that can be purchased.
450     /// @param ethAmount Amount of Ether to purchase AFW.
451     function computeTokenAmount( uint256 ethAmount) internal view returns (uint256) {
452         uint256 tokenBase = ethAmount.mul(tokenRate);
453 		uint8 roundNum = currentStepIndex();
454         uint256 tokens = tokenBase.mul(100)/(100 - (StepDiscount[roundNum]));
455 		return tokens;
456     }
457 
458 	
459 	/// @dev Returns is Pre-Sale.
460     function isPreSale() internal view returns (bool) {
461         if (now >= startDate && now < endPreICO && preIcoCap.sub(stat.currentFundraiser) > 0) {
462             return true;
463         } else {
464             return false;
465         }
466     }
467 
468 	/// @dev Returns is Main Sale.
469     function isMainSale() internal view returns (bool) {
470         if (now >= startICO && now < endDate) {
471             return true;
472         } else {
473             return false;
474         }
475     }
476 
477     /// @notice Buy tokens from contract by sending ether
478     function () payable public {
479         if (msg.value < 0.001 ether || (!isPreSale() && !isMainSale())) revert();
480         buyTokens();
481     }
482 	
483 	/// @return integer representing the index of the current sale round
484     function currentStepIndexAll() internal view returns (uint8 roundNum) {
485         roundNum = currentStepIndexByDate();
486         /// round determined by conjunction of both time and total sold tokens
487         while(roundNum < 3 && StepCaps[roundNum]<= 0) {
488             roundNum++;
489         }
490     }
491 	
492 	/// @dev Compute the amount of AFW token that can be purchased.
493     /// @param ethAmount Amount of Ether to purchase AFW.
494 	function computeTokenAmountAll(uint256 ethAmount) internal returns (uint256) {
495         uint256 tokenBase = ethAmount.mul(tokenRate);
496 		uint8 roundNum = currentStepIndexAll();
497 		uint256 tokens = tokenBase.mul(100)/(100 - (StepDiscount[roundNum]));
498 				
499 		if (roundNum == 3 && (StepCaps[0] > 0 || StepCaps[1] > 0 || StepCaps[2] > 0))
500 		{
501 			/// All unsold pre-sale tokens are made available at the last pre-sale period (3% discount rate)
502 			StepCaps[3] = StepCaps[3] + StepCaps[0] + StepCaps[1] + StepCaps[2];
503 			StepCaps[0] = 0;
504 			StepCaps[1] = 0;
505 			StepCaps[2] = 0;
506 		}				
507 		uint256 balancePreIco = StepCaps[roundNum];		
508 		
509 		if (balancePreIco == 0 && roundNum == 3) {
510 
511 		} else {
512 			/// If tokens available on the pre-sale run out with the order, next pre-sale discount is applied to the remaining ETH
513 			if (balancePreIco < tokens) {			
514 				uint256 toEthCaps = (balancePreIco.mul((100 - (StepDiscount[roundNum]))).div(100)).div(tokenRate);			
515 				uint256 toReturnEth = ethAmount - toEthCaps ;
516 				tokens= balancePreIco;
517 				StepCaps[roundNum]=StepCaps[roundNum]-balancePreIco;		
518 				tokens = tokens + computeTokenAmountAll(toReturnEth);			
519 			} else {
520 				StepCaps[roundNum] = StepCaps[roundNum] - tokens;
521 			}	
522 		}		
523 		return tokens ;
524     }
525 	
526     /// @notice Buy tokens from contract by sending ether
527     function buyTokens() internal {		
528 		/// only accept a minimum amount of ETH?
529         require(msg.value >= 0.001 ether);
530         uint256 tokens ;
531 		uint256 xAmount = msg.value;
532 		uint256 toReturnEth;
533 		uint256 toTokensReturn;
534 		uint256 balanceIco ;
535 		
536 		if(isPreSale()){	
537 			balanceIco = preIcoCap.sub(stat.currentFundraiser);
538 			tokens =computeTokenAmountAll(xAmount);
539 			if (balanceIco < tokens) {	
540 				uint8 roundNum = currentStepIndexAll();
541 				toTokensReturn = tokens.sub(balanceIco);	 
542 				toReturnEth = (toTokensReturn.mul((100 - (StepDiscount[roundNum]))).div(100)).div(tokenRate);			
543 			}			
544 		} else if (isMainSale()) {
545 			balanceIco = IcoCap.add(preIcoCap);
546  			balanceIco = balanceIco.sub(stat.currentFundraiser);	
547 			tokens = xAmount.mul(tokenRate);
548 			if (balanceIco < tokens) {
549 				toTokensReturn = tokens.sub(balanceIco);
550 				toReturnEth = toTokensReturn.mul(tokenRate);
551 			}			
552 		} else {
553             revert();
554         }
555 
556 		if (tokens > 0 )
557 		{
558 			if (balanceIco < tokens) {	
559 				/// return  ETH
560 				msg.sender.transfer(toReturnEth);
561 				_EnvoisTokens(balanceIco, xAmount - toReturnEth);
562 			} else {
563 				_EnvoisTokens(tokens, xAmount);
564 			}
565 		} else {
566             revert();
567 		}
568     }
569 
570 	/// @dev issue tokens for a single buyer
571 	/// @dev Issue token based on Ether received.
572     /// @param _amount the amount of tokens to send
573 	/// @param _ethers the amount of ether it will receive
574     function _EnvoisTokens(uint _amount, uint _ethers) internal {
575 		/// sends tokens AFW to the buyer
576         sendTokens(msg.sender, _amount);
577         stat.currentFundraiser += _amount;
578 		/// sends ether to the seller
579         tokenWallet.transfer(_ethers);
580         stat.ethAmount += _ethers;
581         stat.txCounter += 1;
582     }
583     
584 	/// @dev issue tokens for a single buyer
585 	/// @dev Issue token based on Ether received.
586     /// @param _to address to send to
587 	/// @param _amount the amount of tokens to send
588     function sendTokens(address _to, uint _amount) internal {
589         require(_amount <= balances[tokenWallet]);
590         balances[tokenWallet] -= _amount;
591         balances[_to] += _amount;
592         emit Transfer(tokenWallet, _to, _amount);
593     }
594 
595 	/// @dev issue tokens for a single buyer
596     /// @param _to address to send to
597 	/// @param _amount the amount of tokens to send
598 	/// @param _btcAmount the amount of BitCoin
599     function _sendTokensManually(address _to, uint _amount, uint _btcAmount) public onlyOwner {
600         require(_to != address(0));
601         sendTokens(_to, _amount);
602         stat.currentFundraiser += _amount;
603         stat.btcAmount += _btcAmount;
604         stat.txCounter += 1;
605     }
606 	
607 	/// @dev modify Base exchange rate.
608 	/// @param newTokenRate the new rate. 
609     function setTokenRate(uint newTokenRate) public onlyOwner {
610         tokenRate = newTokenRate;
611     }
612 	
613 	/// @dev Returns the current rate.
614 	function getTokenRate() public constant returns (uint) {
615         return (tokenRate);
616     }    
617 	
618 	/// @dev Returns the current price for 1 ether.
619     function price() public view returns (uint256 tokens) {
620 		uint _amount = 1 ether;
621 		
622 		if(isPreSale()){	
623 			return computeTokenAmount(_amount);
624 		} else if (isMainSale()) {
625 			return _amount.mul(tokenRate);
626 		} else {
627             return 0;
628         }
629     }
630 	/// @dev Returns the current price.
631 	/// @param _amount the amount of ether
632     function EthToAFW(uint _amount) public view returns (uint256 tokens) {
633 		if(isPreSale()){	
634 			return computeTokenAmount(_amount);
635 		} else if (isMainSale()) {
636 			return _amount.mul(tokenRate);
637 		} else {
638             return 0;
639         }
640     }      
641 
642 	/// @dev Returns the current Sale.
643     function GetSale() public constant returns (uint256 tokens) {
644 		if(isPreSale()){	
645 			return 1;
646 		} else if (isMainSale()) {
647 			return 2;
648 		} else {
649             return 0;
650         }
651     }        
652 	
653 	/// @dev Returns the current Cap preIco.
654 	/// @param _roundNum the caps 
655 	function getCapTab(uint _roundNum) public view returns (uint) {			
656 		return (StepCaps[_roundNum]);
657     }
658 	
659 	/// @dev modify Base exchange rate.
660 	/// @param _roundNum pre-sale round
661 	/// @param _value initialize the number of tokens for the indicated pre-sale round
662     function setCapTab(uint _roundNum,uint _value) public onlyOwner {
663         require(_value > 0);
664 		StepCaps[_roundNum] = _value;
665     }	
666 
667 	/// @dev Returns the current Balance of Main Sale.
668 	function getBalanceIco() public constant returns (uint) {
669 		uint balanceIco = IcoCap.add(preIcoCap);
670 		balanceIco = balanceIco.sub(stat.currentFundraiser);	
671         return(balanceIco);
672     } 
673 	
674 	 /**
675      * Overrides the burn function so that it cannot be called until after
676      * transfers have been enabled.
677      *
678      * @param _value    The amount of tokens to burn  
679      */
680    // burn(uint256 _value) public whenNotPaused {
681     function AFWBurn(uint256 _value) public onlyOwner {
682         require(msg.sender == owner);
683         require(balances[msg.sender] >= _value *10**18);
684         super.burn(_value *10**18);
685     }
686 
687 }