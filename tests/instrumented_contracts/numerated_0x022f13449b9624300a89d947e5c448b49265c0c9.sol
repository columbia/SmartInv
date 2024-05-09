1 /**
2  * @title Standard ERC20 token
3  *
4  * @dev Implementation of the basic standard token.
5  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity
6  *
7  * The BG token contract bases on the ERC20 standard token contracts 
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
191  * @title Pausable
192  *
193  * @dev Implementation of the basic standard token.
194  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity
195  * @dev Base contract which allows children to implement an emergency stop mechanism.
196  */
197 contract Pausable is Ownable {
198   event PausePublic(bool newState);
199   event PauseOwnerAdmin(bool newState);
200 
201   bool public pausedPublic = true;
202   bool public pausedOwnerAdmin = false;
203   uint public endDate;
204 
205   /**
206    * @dev Modifier to make a function callable based on pause states.
207    */
208   modifier whenNotPaused() {
209     if(pausedPublic) {
210       if(!pausedOwnerAdmin) {
211         require(msg.sender == owner);
212       } else {
213         revert();
214       }
215     }
216     _;
217   }
218 
219   /**
220    * @dev called by the owner to set new pause flags
221    * pausedPublic can't be false while pausedOwnerAdmin is true
222    */
223   function pause(bool newPausedPublic, bool newPausedOwnerAdmin) onlyOwner public {
224     require(!(newPausedPublic == false && newPausedOwnerAdmin == true));
225 
226     pausedPublic = newPausedPublic;
227     pausedOwnerAdmin = newPausedOwnerAdmin;
228 
229     emit PausePublic(newPausedPublic);
230     emit PauseOwnerAdmin(newPausedOwnerAdmin);
231   }
232 }
233 
234 contract StandardToken is ERC20, BasicToken, Pausable {
235     using SafeMath for uint256;
236     mapping (address => mapping (address => uint256)) internal allowed;
237 
238   mapping(address => uint256) balances;
239 
240   /**
241   * @dev transfer token for a specified address
242   * @param _to The address to transfer to.
243   * @param _value The amount to be transferred.
244   */
245   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
246     require(_to != address(0));
247     balances[msg.sender] = balances[msg.sender].sub(_value);
248     balances[_to] = balances[_to].add(_value);
249     emit Transfer(msg.sender, _to, _value);
250     return true;
251   }
252 
253   /**
254   * @dev Gets the balance of the specified address.
255   * @param _owner The address to query the the balance of.
256   * @return An uint256 representing the amount owned by the passed address.
257   */
258   function balanceOf(address _owner) public constant returns (uint256 balance) {
259     return balances[_owner];
260   }
261 
262 
263   /**
264    * @dev Transfer tokens from one address to another
265    * @param _from address The address which you want to send tokens from
266    * @param _to address The address which you want to transfer to
267    * @param _value uint256 the amount of tokens to be transferred
268    */
269   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
270     require(_to != address(0));
271     require(_value <= allowed[_from][msg.sender]);
272 
273     balances[_from] = balances[_from].sub(_value);
274     balances[_to] = balances[_to].add(_value);
275     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
276     emit Transfer(_from, _to, _value);
277     return true;
278   }
279 
280   /**
281    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
282    *
283    * Beware that changing an allowance with this method brings the risk that someone may use both the old
284    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
285    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
286    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287    * @param _spender The address which will spend the funds.
288    * @param _value The amount of tokens to be spent.
289    */
290   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
291     allowed[msg.sender][_spender] = _value;
292     emit Approval(msg.sender, _spender, _value);
293     return true;
294   }
295 
296   /**
297    * @dev Function to check the amount of tokens that an owner allowed to a spender.
298    * @param _owner address The address which owns the funds.
299    * @param _spender address The address which will spend the funds.
300    * @return A uint256 specifying the amount of tokens still available for the spender.
301    */
302   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
303     return allowed[_owner][_spender];
304   }
305 
306   /**
307    * approve should be called when allowed[_spender] == 0. To increment
308    * allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)
310    * From MonolithDAO Token.sol
311    */
312   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
313     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
314     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
315     return true;
316   }
317 
318   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
319     uint oldValue = allowed[msg.sender][_spender];
320     if (_subtractedValue > oldValue) {
321       allowed[msg.sender][_spender] = 0;
322     } else {
323       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324     }
325     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329   }
330  
331 /**
332  * @title Burnable Token
333  * @dev Token that can be irreversibly burned (destroyed).
334  */
335 contract BurnableToken is StandardToken {
336 
337     /**
338      * @dev Burns a specific amount of tokens.
339      * @param _value The amount of token to be burned.
340      */
341     function burn(uint256  _value)
342         public onlyOwner
343     {
344         require(_value > 0);
345 		require(balances[msg.sender] >= _value);
346         address burner = msg.sender;
347         balances[burner] = balances[burner].sub(_value);
348         totalSupply_ = totalSupply_.sub(_value);
349         emit Burn(burner, _value);
350     }
351     event Burn(address indexed burner, uint256  indexed value);
352 } 
353 
354 contract BGToken is StandardToken , BurnableToken  {
355     using SafeMath for uint256;
356     string public constant name = "BlueGold";
357     string public constant symbol = "BG";
358     uint8 public constant decimals = 18;	
359 	
360 	// wallets address for allocation	
361 	address public Bounties_Wallet = 0x2805C02FE839210E194Fc4a12DaB683a34Ad95EF; // 5% : Bounty
362 	address public Team_Wallet = 0x6C42c4EC37d0F45E2d9C2287f399E14Ea2b3B77d; // 8% : Equity & Team
363 	address public OEM_Wallet = 0x278cB54ae3B7851D3262A307cb6780b642A29485; // 10% : Community Builting, Biz Dev
364 	address public LA_wallet = 0x1669e7910e27b1400B5567eE360de2c5Ee964859; //8% : Legal & advisors
365 		
366 	address public tokenWallet = 0xDb3D4293981adeEC2A258c0b8046eAdb20D3ff13;     
367 	uint256 public constant INITIAL_SUPPLY = 100000000 ether;	
368 	
369 	/// Base exchange rate is set to 1 ETH = 460 BG.
370 	uint256 tokenRate = 460; 	
371 	
372     function BGToken() public {
373         totalSupply_ = INITIAL_SUPPLY;
374 
375 		// InitialDistribution
376 		// 31% ---> 31000000
377 		balances[Bounties_Wallet] = INITIAL_SUPPLY.mul(5).div(100) ;
378 		balances[Team_Wallet] = INITIAL_SUPPLY.mul(8).div(100);
379 		balances[OEM_Wallet] = INITIAL_SUPPLY.mul(10).div(100) ;
380 		balances[LA_wallet] = INITIAL_SUPPLY.mul(8).div(100) ;
381 		
382 		// 69% ---> 69000000
383         balances[tokenWallet] = INITIAL_SUPPLY.mul(69).div(100);
384 				
385         emit Transfer(0x0, Bounties_Wallet, balances[Bounties_Wallet]);
386         emit Transfer(0x0, Team_Wallet, balances[Team_Wallet]);
387 		emit Transfer(0x0, OEM_Wallet, balances[OEM_Wallet]);
388         emit Transfer(0x0, LA_wallet, balances[LA_wallet]);
389 				
390 		emit Transfer(0x0, tokenWallet, balances[tokenWallet]);
391         endDate = _endDate;			
392     }
393 	
394     uint constant _endDate = 1546297199; /// Close Main Sale -  Monday 31 December 2018 23:59:59 
395 	uint256 Bonus = 30; 	
396 	uint256 extraBonus = 20; 		
397 
398     struct Stat {
399         uint currentFundraiser;
400         uint otherAmount;
401         uint ethAmount;
402         uint txCounter;
403     }    
404     Stat public stat;    	
405 
406 	/// Maximum tokens to be allocated on the sale (69% of the hard cap)
407     uint256 IcoCap = INITIAL_SUPPLY;
408 	
409 	 /**
410      * @dev modifier to allow actions only when ICO end date is not now
411      */
412 	modifier isRunning {
413         require (endDate >= now);
414         _;
415     }
416 	
417     /// @notice Buy tokens from contract by sending ether
418     function () payable isRunning public {
419         if (msg.value < 0.001 ether) revert();
420         buyTokens();
421     }	
422 
423     /// @notice Buy tokens from contract by sending ether
424     function buyTokens() internal {		
425 		/// only accept a minimum amount of ETH?
426         require(msg.value >= 0.001 ether);
427         uint256 tokens ;
428 		uint256 xAmount = msg.value;
429 		uint256 toReturnEth;
430 		uint256 toTokensReturn;
431 		uint256 balanceIco ;	
432 		uint256 AllBonus = 0; 
433 		
434 		balanceIco = IcoCap;
435 		balanceIco = balanceIco.sub(stat.currentFundraiser);	
436 		
437 		AllBonus= Bonus.add(extraBonus);
438 		tokens = xAmount.mul(tokenRate);
439 		tokens = (tokens.mul(100)).div(100 - (AllBonus));
440 		
441 		if (balanceIco < tokens) {
442 			toTokensReturn = tokens.sub(balanceIco);
443 			toReturnEth = toTokensReturn.mul(tokenRate);
444 		}			
445 
446 		if (tokens > 0 )
447 		{
448 			if (balanceIco < tokens) {	
449 				/// return  ETH
450 				if (toReturnEth <= xAmount) 
451 				{
452 					msg.sender.transfer(toReturnEth);									
453 					_EnvoisTokens(balanceIco, xAmount - toReturnEth);
454 				}
455 				
456 			} else {
457 				_EnvoisTokens(tokens, xAmount);
458 			}
459 		} else {
460             revert();
461 		}
462     }
463 
464 	/// @dev issue tokens for a single buyer
465 	/// @dev Issue token based on Ether received.
466     /// @param _amount the amount of tokens to send
467 	/// @param _ethers the amount of ether it will receive
468     function _EnvoisTokens(uint _amount, uint _ethers) internal {
469 		/// sends tokens ODEEP to the buyer
470         sendTokens(msg.sender, _amount);
471         stat.currentFundraiser += _amount;
472 		/// sends ether to the seller
473         tokenWallet.transfer(_ethers);
474         stat.ethAmount += _ethers;
475         stat.txCounter += 1;
476     }
477 
478 	/// @dev issue tokens for a single buyer
479 	/// @dev Issue token based on Ether received.
480     /// @param _to address to send to
481 	/// @param _amount the amount of tokens to send
482     function sendTokens(address _to, uint _amount) internal {
483         require(_amount <= balances[tokenWallet]);
484         balances[tokenWallet] -= _amount;
485         balances[_to] += _amount;
486         emit Transfer(tokenWallet, _to, _amount);
487     }
488 	
489 	/// @dev issue tokens for a single buyer
490     /// @param _to address to send to
491 	/// @param _amount the amount of tokens to send
492 	/// @param _otherAmount the amount of pay
493     function _sendTokensManually(address _to, uint _amount, uint _otherAmount) public onlyOwner {
494         require(_to != address(0));
495 		sendTokens(_to, _amount);		
496 		stat.currentFundraiser += _amount;
497         stat.otherAmount += _otherAmount;
498         stat.txCounter += 1;
499     }	
500 
501 	/// @dev modify ICO cap.
502 	/// @param newIcoCap the new Cap. 
503     function setIcoCap(uint256 newIcoCap) public onlyOwner {
504         IcoCap = newIcoCap;
505     }
506 	
507 	/// @dev Returns the current Cap.
508 	function getIcoCap() public constant returns (uint256) {
509         return (IcoCap);
510     }    	
511 		
512 	/// @dev modify Base exchange rate.
513 	/// @param newTokenRate the new rate. 
514     function setTokenRate(uint newTokenRate) public onlyOwner {
515         tokenRate = newTokenRate;
516     }
517 	
518 	/// @dev Returns the current rate.
519 	function getTokenRate() public constant returns (uint) {
520         return (tokenRate);
521     }    	
522 	
523 	/// @dev modify Bonus.
524 	/// @param newBonus the new Bonus. 
525     function setBonus(uint newBonus) public onlyOwner {
526         Bonus = newBonus;		
527     }
528 	
529 	/// @dev Returns the current Bonus.
530 	function getBonus() public constant returns (uint) {
531         return (Bonus);
532     } 	
533 	
534 	/// @dev modify ExtraBonus.
535 	/// @param newExtraBonus the new Bonus. 
536     function setExtraBonus(uint newExtraBonus) public onlyOwner {
537         extraBonus = newExtraBonus;
538     }
539 	
540 	/// @dev Returns the current ExtraBonus.
541 	function getExtraBonus() public constant returns (uint) {
542         return (extraBonus);
543     } 	
544 	
545 	/// @dev modify endDate.
546 	/// @param newEndDate the new endDate. 
547     function setEndDate(uint newEndDate) public onlyOwner {
548         endDate = newEndDate;
549     }		
550 	
551 }