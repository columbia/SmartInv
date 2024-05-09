1 /**
2  * @title Standard ERC20 token
3  *
4  * @dev Implementation of the basic standard token.
5  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity
6  *
7  * The ODEEP token contract bases on the ERC20 standard token contracts 
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
161 }
162 
163 /**
164  * @title SafeERC20
165  * @dev Wrappers around ERC20 operations that throw on failure.
166  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
167  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
168  */
169 library SafeERC20 {
170   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
171     assert(token.transfer(to, value));
172   }
173 
174   function safeTransferFrom(
175     ERC20 token,
176     address from,
177     address to,
178     uint256 value
179   )
180     internal
181   {
182     assert(token.transferFrom(from, to, value));
183   }
184 
185   function safeApprove(ERC20 token, address spender, uint256 value) internal {
186     assert(token.approve(spender, value));
187   }
188 }
189 
190 /**
191  * @title Standard ERC20 token
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity
195  */
196 contract Pausable is Ownable {
197 
198   uint public endDate;
199 
200   /**
201    * @dev modifier to allow actions only when the contract IS not paused
202    */
203   modifier whenNotPaused() {
204     require(now >= endDate);
205     _;
206   }
207 
208 }
209 
210 contract StandardToken is ERC20, BasicToken, Pausable {
211     using SafeMath for uint256;
212     mapping (address => mapping (address => uint256)) internal allowed;
213 
214   mapping(address => uint256) balances;
215 
216   /**
217   * @dev transfer token for a specified address
218   * @param _to The address to transfer to.
219   * @param _value The amount to be transferred.
220   */
221   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
222     require(_to != address(0));
223     balances[msg.sender] = balances[msg.sender].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     emit Transfer(msg.sender, _to, _value);
226     return true;
227   }
228 
229   /**
230   * @dev Gets the balance of the specified address.
231   * @param _owner The address to query the the balance of.
232   * @return An uint256 representing the amount owned by the passed address.
233   */
234   function balanceOf(address _owner) public constant returns (uint256 balance) {
235     return balances[_owner];
236   }
237 
238 
239   /**
240    * @dev Transfer tokens from one address to another
241    * @param _from address The address which you want to send tokens from
242    * @param _to address The address which you want to transfer to
243    * @param _value uint256 the amount of tokens to be transferred
244    */
245   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
246     require(_to != address(0));
247     require(_value <= allowed[_from][msg.sender]);
248 
249     balances[_from] = balances[_from].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
252     emit Transfer(_from, _to, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258    *
259    * Beware that changing an allowance with this method brings the risk that someone may use both the old
260    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
261    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
262    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263    * @param _spender The address which will spend the funds.
264    * @param _value The amount of tokens to be spent.
265    */
266   function approve(address _spender, uint256 _value) public returns (bool) {
267     allowed[msg.sender][_spender] = _value;
268     emit Approval(msg.sender, _spender, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Function to check the amount of tokens that an owner allowed to a spender.
274    * @param _owner address The address which owns the funds.
275    * @param _spender address The address which will spend the funds.
276    * @return A uint256 specifying the amount of tokens still available for the spender.
277    */
278   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    */
288   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
295     uint oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305   }
306  
307 /**
308  * @title Burnable Token
309  * @dev Token that can be irreversibly burned (destroyed).
310  */
311 contract BurnableToken is StandardToken {
312 
313     /**
314      * @dev Burns a specific amount of tokens.
315      * @param _value The amount of token to be burned.
316      */
317     function burn(uint256  _value)
318         public onlyOwner
319     {
320         require(_value > 0);
321 		require(balances[msg.sender] >= _value);
322         address burner = msg.sender;
323         balances[burner] = balances[burner].sub(_value);
324         totalSupply_ = totalSupply_.sub(_value);
325         emit Burn(burner, _value);
326     }
327     event Burn(address indexed burner, uint256  indexed value);
328 } 
329    
330 contract ODEEPToken is StandardToken , BurnableToken  {
331     using SafeMath for uint256;
332     string public constant name = "ODEEP";
333     string public constant symbol = "ODEEP";
334     uint8 public constant decimals = 18;	
335 	
336 	// wallets address for allocation	
337 	address public Bounties_Wallet = 0x70F48becd584115E8FF298eA72D5EFE199526655; // 5% : Bounty
338 	address public Team_Wallet = 0xd3186A1e1ECe80F2E1811904bfBF876e6ea27A41; // 8% : Equity & Team
339 	address public OEM_Wallet = 0x4fD0e4E8EFDf55D2C1B41d504A2977a9f8453714; // 10% : Community Builting, Biz Dev
340 	address public LA_wallet = 0xA0AaFDbDD5bE0d5f1A5f980331DEf9b5e106e587; //8% : Legal & advisors
341     
342 	address public tokenWallet = 0x81cb9078e3c19842B201e2cCFC4B0f111d693D47;    
343 	uint256 public constant INITIAL_SUPPLY = 100000000 ether;	
344 		
345 	/// Base exchange rate is set to 1 ETH = 560 ODEEP.
346 	uint256 tokenRate = 560; 
347 		
348     function ODEEPToken() public {
349         totalSupply_ = INITIAL_SUPPLY;
350 		
351 		// InitialDistribution
352 		// 31% ---> 31000000
353 		balances[Bounties_Wallet] = INITIAL_SUPPLY.mul(5).div(100) ;
354 		balances[Team_Wallet] = INITIAL_SUPPLY.mul(8).div(100);
355 		balances[OEM_Wallet] = INITIAL_SUPPLY.mul(10).div(100) ;
356 		balances[LA_wallet] = INITIAL_SUPPLY.mul(8).div(100) ;
357 		
358 		// 69% ---> 69000000
359         balances[tokenWallet] = INITIAL_SUPPLY.mul(69).div(100);
360 		
361         endDate = _endDate;
362 				
363         emit Transfer(0x0, Bounties_Wallet, balances[Bounties_Wallet]);
364         emit Transfer(0x0, Team_Wallet, balances[Team_Wallet]);
365 		emit Transfer(0x0, OEM_Wallet, balances[OEM_Wallet]);
366         emit Transfer(0x0, LA_wallet, balances[LA_wallet]);
367 				
368 		emit Transfer(0x0, tokenWallet, balances[tokenWallet]);
369     }
370 
371 	/**
372 	******** DATE PReICO - ICO */
373     uint public constant startDate = 1526292000; /// Start Pre-sale - Monday 14 May 2018 12:00:00
374     uint public constant endPreICO = 1528883999;/// Close Pre-Sale - Wednesday 13 June 2018 11:59:59
375 	
376 	/// HOT sale start time
377     uint constant preSale30 = startDate ; /// Start Pre-sale 30% - Monday 14 May 2018 12:00:00
378     uint constant preSale20 = 1527156000; /// Start Pre-sale 20% - Thursday 24 May 2018 12:00:00
379     uint constant preSale15 = 1528020000; /// Start Pre-sale 15% - Sunday 3 June 2018 12:00:00
380 			
381     uint public constant startICO = 1528884000; /// Start Main Sale - Wednesday 13 June 2018 12:00:00
382     uint public constant _endDate = 1532340000; /// Close Main Sale - Monday 23 July 2018 12:00:00 
383 
384     struct Stat {
385         uint currentFundraiser;
386         uint btcAmount;
387         uint ethAmount;
388         uint txCounter;
389     }    
390     Stat public stat;    
391 	
392 	/// Maximum tokens to be allocated on the sale (69% of the hard cap)
393     uint public constant preIcoCap = 5000000 ether;
394     uint public constant IcoCap = 64000000 ether;
395 
396 	/// token caps for each round
397 	uint256[3] private StepCaps = [
398         1250000 ether, 	/// 25% 
399         1750000 ether, 	/// 35%
400         2000000 ether 	/// 40%
401     ];	
402 	uint8[3] private StepDiscount = [30, 20, 15];
403 		
404     /**
405      * @dev modifier to allow actions only when Pre-ICO end date is now
406      */
407     modifier isFinished() {
408         require(now >= endDate);
409         _;
410     }
411 	
412 	/// @return the index of the current discount by date.
413     function currentStepIndexByDate() internal view returns (uint8 roundNum) {
414         require(now <= endPreICO); 
415         if(now > preSale15) return 2;
416         if(now > preSale20) return 1;
417         if(now > preSale30) return 0;
418         else return 0;
419     }
420 	
421 	/// @return integer representing the index of the current sale round
422     function currentStepIndexAll() internal view returns (uint8 roundNum) {
423         roundNum = currentStepIndexByDate();
424         /// round determined by conjunction of both time and total sold tokens
425         while(roundNum < 2 && StepCaps[roundNum]<= 0) {
426             roundNum++;
427         }
428     }
429 	
430 	/// @dev Returns is Pre-Sale.
431     function isPreSale() internal view returns (bool) {
432         if (now >= startDate && now < endPreICO && preIcoCap.sub(stat.currentFundraiser) > 0) {
433             return true;
434         } else {
435             return false;
436         }
437     }
438 
439 	/// @dev Returns is Main Sale.
440     function isMainSale() internal view returns (bool) {
441         if (now >= startICO && now < endDate) {
442             return true;
443         } else {
444             return false;
445         }
446     }
447 	
448     /// @notice Buy tokens from contract by sending ether
449     function () payable public {
450         if (msg.value < 0.001 ether || (!isPreSale() && !isMainSale())) revert();
451         buyTokens();
452     }	
453 	
454 	/// @dev Compute the amount of ODEEP token that can be purchased.
455     /// @param ethAmount Amount of Ether to purchase ODEEP.
456 	function computeTokenAmountAll(uint256 ethAmount) internal returns (uint256) {
457         uint256 tokenBase = ethAmount.mul(tokenRate);
458 		uint8 roundNum = currentStepIndexAll();
459 		uint256 tokens = tokenBase.mul(100)/(100 - (StepDiscount[roundNum]));				
460 		if (roundNum == 2 && (StepCaps[0] > 0 || StepCaps[1] > 0))
461 		{
462 			/// All unsold pre-sale tokens are made available at the last pre-sale period (3% discount rate)
463 			StepCaps[2] = StepCaps[2] + StepCaps[0] + StepCaps[1];
464 			StepCaps[0] = 0;
465 			StepCaps[1] = 0;
466 		}				
467 		uint256 balancePreIco = StepCaps[roundNum];		
468 		
469 		if (balancePreIco == 0 && roundNum == 2) {
470 		} else {
471 			/// If tokens available on the pre-sale run out with the order, next pre-sale discount is applied to the remaining ETH
472 			if (balancePreIco < tokens) {			
473 				uint256 toEthCaps = (balancePreIco.mul((100 - (StepDiscount[roundNum]))).div(100)).div(tokenRate);			
474 				uint256 toReturnEth = ethAmount - toEthCaps ;
475 				tokens= balancePreIco;
476 				StepCaps[roundNum]=StepCaps[roundNum]-balancePreIco;		
477 				tokens = tokens + computeTokenAmountAll(toReturnEth);			
478 			} else {
479 				StepCaps[roundNum] = StepCaps[roundNum] - tokens;
480 			}	
481 		}		
482 		return tokens ;
483     }
484 	
485     /// @notice Buy tokens from contract by sending ether
486     function buyTokens() internal {		
487 		/// only accept a minimum amount of ETH?
488         require(msg.value >= 0.001 ether);
489         uint256 tokens ;
490 		uint256 xAmount = msg.value;
491 		uint256 toReturnEth;
492 		uint256 toTokensReturn;
493 		uint256 balanceIco ;
494 		
495 		if(isPreSale()){	
496 			balanceIco = preIcoCap.sub(stat.currentFundraiser);
497 			tokens =computeTokenAmountAll(xAmount);
498 			if (balanceIco < tokens) {	
499 				uint8 roundNum = currentStepIndexAll();
500 				toTokensReturn = tokens.sub(balanceIco);	 
501 				toReturnEth = (toTokensReturn.mul((100 - (StepDiscount[roundNum]))).div(100)).div(tokenRate);			
502 			}			
503 		} else if (isMainSale()) {
504 			balanceIco = IcoCap.add(preIcoCap);
505  			balanceIco = balanceIco.sub(stat.currentFundraiser);	
506 			tokens = xAmount.mul(tokenRate);
507 			if (balanceIco < tokens) {
508 				toTokensReturn = tokens.sub(balanceIco);
509 				toReturnEth = toTokensReturn.mul(tokenRate);
510 			}			
511 		} else {
512             revert();
513         }
514 		if (tokens > 0 )
515 		{
516 			if (balanceIco < tokens) {	
517 				/// return  ETH
518 				msg.sender.transfer(toReturnEth);
519 				_EnvoisTokens(balanceIco, xAmount - toReturnEth);
520 			} else {
521 				_EnvoisTokens(tokens, xAmount);
522 			}
523 		} else {
524             revert();
525 		}
526     }
527 
528 	/// @dev issue tokens for a single buyer
529 	/// @dev Issue token based on Ether received.
530     /// @param _amount the amount of tokens to send
531 	/// @param _ethers the amount of ether it will receive
532     function _EnvoisTokens(uint _amount, uint _ethers) internal {
533 		/// sends tokens ODEEP to the buyer
534         sendTokens(msg.sender, _amount);
535         stat.currentFundraiser += _amount;
536 		/// sends ether to the seller
537         tokenWallet.transfer(_ethers);
538         stat.ethAmount += _ethers;
539         stat.txCounter += 1;
540     }
541     
542 	/// @dev issue tokens for a single buyer
543 	/// @dev Issue token based on Ether received.
544     /// @param _to address to send to
545 	/// @param _amount the amount of tokens to send
546     function sendTokens(address _to, uint _amount) internal {
547         require(_amount <= balances[tokenWallet]);
548         balances[tokenWallet] -= _amount;
549         balances[_to] += _amount;
550         emit Transfer(tokenWallet, _to, _amount);
551     }
552 
553 	/// @dev issue tokens for a single buyer
554     /// @param _to address to send to
555 	/// @param _amount the amount of tokens to send
556 	/// @param _btcAmount the amount of BitCoin
557     function _sendTokensManually(address _to, uint _amount, uint _btcAmount) public onlyOwner {
558         require(_to != address(0));
559         sendTokens(_to, _amount);
560         stat.currentFundraiser += _amount;
561         stat.btcAmount += _btcAmount;
562         stat.txCounter += 1;
563     }
564 	
565 	/// @dev modify Base exchange rate.
566 	/// @param newTokenRate the new rate. 
567     function setTokenRate(uint newTokenRate) public onlyOwner {
568         tokenRate = newTokenRate;
569     }
570 	
571 	/// @dev Returns the current rate.
572 	function getTokenRate() public constant returns (uint) {
573         return (tokenRate);
574     }      
575 	
576 	/// @dev Returns the current Cap preIco.
577 	/// @param _roundNum the caps 
578 	function getCapTab(uint _roundNum) public view returns (uint) {			
579 		return (StepCaps[_roundNum]);
580     }
581 	
582 	/// @dev modify Base exchange rate.
583 	/// @param _roundNum pre-sale round
584 	/// @param _value initialize the number of tokens for the indicated pre-sale round
585     function setCapTab(uint _roundNum,uint _value) public onlyOwner {
586         require(_value > 0);
587 		StepCaps[_roundNum] = _value;
588     }	
589 }