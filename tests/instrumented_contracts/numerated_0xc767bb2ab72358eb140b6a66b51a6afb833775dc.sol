1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/math/SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // assert(b > 0); // Solidity automatically throws when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67     return c;
68   }
69 
70   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function add(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     assert(c >= a);
78     return c;
79   }
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/BasicToken.sol
97 
98 /**
99  * @title Basic token
100  * @dev Basic version of StandardToken, with no allowances.
101  */
102 contract BasicToken is ERC20Basic {
103   using SafeMath for uint256;
104 
105   mapping(address => uint256) balances;
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 }
133 
134 // File: zeppelin-solidity/contracts/token/ERC20.sol
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public view returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // File: zeppelin-solidity/contracts/token/StandardToken.sol
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 // File: zeppelin-solidity/contracts/token/MintableToken.sol
245 
246 /**
247  * @title Mintable token
248  * @dev Simple ERC20 Token example, with mintable token creation
249  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
250  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
251  */
252 
253 contract MintableToken is StandardToken, Ownable {
254   event Mint(address indexed to, uint256 amount);
255   event MintFinished();
256 
257   bool public mintingFinished = false;
258 
259 
260   modifier canMint() {
261     require(!mintingFinished);
262     _;
263   }
264 
265   /**
266    * @dev Function to mint tokens
267    * @param _to The address that will receive the minted tokens.
268    * @param _amount The amount of tokens to mint.
269    * @return A boolean that indicates if the operation was successful.
270    */
271   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
272     totalSupply = totalSupply.add(_amount);
273     balances[_to] = balances[_to].add(_amount);
274     Mint(_to, _amount);
275     Transfer(address(0), _to, _amount);
276     return true;
277   }
278 
279   /**
280    * @dev Function to stop minting new tokens.
281    * @return True if the operation was successful.
282    */
283   function finishMinting() onlyOwner canMint public returns (bool) {
284     mintingFinished = true;
285     MintFinished();
286     return true;
287   }
288 }
289 
290 // File: zeppelin-solidity/contracts/token/CappedToken.sol
291 
292 /**
293  * @title Capped token
294  * @dev Mintable token with a token cap.
295  */
296 
297 contract CappedToken is MintableToken {
298 
299   uint256 public cap;
300 
301   function CappedToken(uint256 _cap) public {
302     require(_cap > 0);
303     cap = _cap;
304   }
305 
306   /**
307    * @dev Function to mint tokens
308    * @param _to The address that will receive the minted tokens.
309    * @param _amount The amount of tokens to mint.
310    * @return A boolean that indicates if the operation was successful.
311    */
312   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
313     require(totalSupply.add(_amount) <= cap);
314 
315     return super.mint(_to, _amount);
316   }
317 
318 }
319 
320 // File: contracts/JcnToken.sol
321 
322 contract JcnToken is CappedToken {
323 
324 	string public name = "JizzCoins";
325 	string public symbol = "JCN";
326 	uint8 public decimals = 18;
327 
328 	uint256 public constant HARD_CAP = 100000000 * (10 ** uint256(18));			//100 Million
329 
330 	/**
331 	 * @dev Constructor that gives msg.sender all of existing tokens.
332 	 */
333 	function JcnToken() public
334 	CappedToken(HARD_CAP) 
335 	{	
336 	}
337 }
338 
339 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
340 
341 /**
342  * @title Crowdsale
343  * @dev Crowdsale is a base contract for managing a token crowdsale.
344  * Crowdsales have a start and end timestamps, where investors can make
345  * token purchases and the crowdsale will assign them tokens based
346  * on a token per ETH rate. Funds collected are forwarded to a wallet
347  * as they arrive.
348  */
349 contract Crowdsale {
350   using SafeMath for uint256;
351 
352   // The token being sold
353   MintableToken public token;
354 
355   // start and end timestamps where investments are allowed (both inclusive)
356   uint256 public startTime;
357   uint256 public endTime;
358 
359   // address where funds are collected
360   address public wallet;
361 
362   // how many token units a buyer gets per wei
363   uint256 public rate;
364 
365   // amount of raised money in wei
366   uint256 public weiRaised;
367 
368   /**
369    * event for token purchase logging
370    * @param purchaser who paid for the tokens
371    * @param beneficiary who got the tokens
372    * @param value weis paid for purchase
373    * @param amount amount of tokens purchased
374    */
375   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
376 
377 
378   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
379     require(_startTime >= now);
380     require(_endTime >= _startTime);
381     require(_rate > 0);
382     require(_wallet != address(0));
383 
384     token = createTokenContract();
385     startTime = _startTime;
386     endTime = _endTime;
387     rate = _rate;
388     wallet = _wallet;
389   }
390 
391   // creates the token to be sold.
392   // override this method to have crowdsale of a specific mintable token.
393   function createTokenContract() internal returns (MintableToken) {
394     return new MintableToken();
395   }
396 
397 
398   // fallback function can be used to buy tokens
399   function () external payable {
400     buyTokens(msg.sender);
401   }
402 
403   // low level token purchase function
404   function buyTokens(address beneficiary) public payable {
405     require(beneficiary != address(0));
406     require(validPurchase());
407 
408     uint256 weiAmount = msg.value;
409 
410     // calculate token amount to be created
411     uint256 tokens = weiAmount.mul(rate);
412 
413     // update state
414     weiRaised = weiRaised.add(weiAmount);
415 
416     token.mint(beneficiary, tokens);
417     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
418 
419     forwardFunds();
420   }
421 
422   // send ether to the fund collection wallet
423   // override to create custom fund forwarding mechanisms
424   function forwardFunds() internal {
425     wallet.transfer(msg.value);
426   }
427 
428   // @return true if the transaction can buy tokens
429   function validPurchase() internal view returns (bool) {
430     bool withinPeriod = now >= startTime && now <= endTime;
431     bool nonZeroPurchase = msg.value != 0;
432     return withinPeriod && nonZeroPurchase;
433   }
434 
435   // @return true if crowdsale event has ended
436   function hasEnded() public view returns (bool) {
437     return now > endTime;
438   }
439 
440 
441 }
442 
443 // File: contracts/JcnCrowdsale.sol
444 
445 contract JcnCrowdsale is Crowdsale {
446 
447 	uint256 public constant FOUNDERS_SHARE = 30000000 * (10 ** uint256(18));	//30 Million
448 	uint256 public constant RESERVE_FUND = 15000000 * (10 ** uint256(18));		//15 Million
449 	uint256 public constant CONTENT_FUND = 5000000 * (10 ** uint256(18));		//5 Million
450 	uint256 public constant BOUNTY_FUND = 5000000 * (10 ** uint256(18));		//5 Million
451 
452 	// ICO phases structure
453 	enum IcoPhases { EarlyBirdPresale, Presale, EarlyBirdCrowdsale, FullCrowdsale }
454 	struct Phase {
455 		uint256 startTime;
456 		uint256 endTime;
457 		uint256 minimum;	//in wei
458 		uint8 bonus;
459 	}
460 	mapping (uint => Phase) ico;
461 
462 	//constructor
463 	function JcnCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public
464 	Crowdsale(_startTime, _endTime, _rate, _wallet) 
465 	{       
466 		//define the ICO phases (date/time in GMT+1)
467 
468 		//2018-01-10 11:00, 2018-01-20 10:59, 0.75 ether 25%
469 		ico[uint(IcoPhases.EarlyBirdPresale)] = Phase(1515578400, 1516442399, 750000000000000000, 25);	
470 		
471 		//2018-01-20 11:00, 2018-02-01 10:59, 0.5 ether 15%
472 		ico[uint(IcoPhases.Presale)] = Phase(1516442400, 1517479199, 500000000000000000, 15);
473 		
474 		//2018-02-01 11:00, 2018-02-10 10:59, 0.25 ether 5%
475 		ico[uint(IcoPhases.EarlyBirdCrowdsale)] = Phase(1517479200, 1518256799, 250000000000000000, 5);
476 		
477 		//2018-02-10 11:00, 2018-04-10 10:59, 0.001 ether 0%
478 		ico[uint(IcoPhases.FullCrowdsale)] = Phase(1518256800, 1523350799, 1000000000000000, 0);
479 
480 		//mint the reserved tokens
481 		uint256 reserved_tokens = FOUNDERS_SHARE.add(RESERVE_FUND).add(CONTENT_FUND).add(BOUNTY_FUND);
482 		token.mint(wallet, reserved_tokens);
483 	}
484 
485 	//creates the token to be sold.
486 	function createTokenContract() internal returns (MintableToken) {
487 		return new JcnToken();
488 	}
489 
490 	//low level token purchase function
491 	//overridden to allow for calculations based on the ICO phases 
492 	function buyTokens(address beneficiary) public payable {
493 		require(beneficiary != address(0));
494 		require(validPurchase());
495 
496 		uint256 weiAmount = msg.value;
497 
498 		// calculate token amount to be created
499 		uint256 tokens = weiAmount.mul(rate);
500 
501 		//-----------------------------------------------------
502 		//START changes of the original function
503 
504 		//get the minimum
505 		uint256 minimum = currentIcoPhaseMinimum();
506 
507 		//make sure the minimum is met
508 		require(weiAmount >= minimum);
509 
510 		//determine the bonus
511 		uint bonus = currentIcoPhaseBonus();
512 
513 		//tokens = tokens + ((tokens * bonus)/100);
514 		tokens = tokens.add((tokens.mul(bonus)).div(100));
515 
516 		//END changes
517 		//-----------------------------------------------------
518 
519 		// update state
520 		weiRaised = weiRaised.add(weiAmount);
521 
522 		token.mint(beneficiary, tokens);
523 		TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
524 
525 		forwardFunds();
526 	}
527 
528 	//function to find out what is the current ICO phase bonus 
529 	function currentIcoPhaseBonus() public view returns (uint8) {
530 
531 		for (uint i = 0; i < 4; i++) {
532 			if(ico[i].startTime <= now && ico[i].endTime >= now){
533 				return ico[i].bonus;
534 			}
535 		}
536 		return 0;	//not currently in any phase, ICO most likely finished or not started, 0% bonus
537 	}
538 
539 	//function to find out what is the current ICO phase minimum 
540 	function currentIcoPhaseMinimum() public view returns (uint256) {
541 
542 		for (uint i = 0; i < 4; i++) {
543 			if(ico[i].startTime <= now && ico[i].endTime >= now){
544 				return ico[i].minimum;
545 			}
546 		}
547 		return 0;	//not currently in any phase, ICO most likely finished or not started, 0 minimum
548 	}
549 }