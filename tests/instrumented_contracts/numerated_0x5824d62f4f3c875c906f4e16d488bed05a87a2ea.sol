1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10      * @dev Multiplies two numbers, throws on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two numbers, truncating the quotient.
27      */
28     function div(uint256 a, uint256 b) internal pure returns(uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37      */
38     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44      * @dev Adds two numbers, throws on overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59     address public owner;
60 
61     event OwnershipRenounced(address indexed previousOwner);
62     event OwnershipTransferred(
63         address indexed previousOwner,
64         address indexed newOwner
65     );
66 
67     /**
68      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69      * account.
70      */
71     constructor() public {
72         owner = msg.sender;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     /**
84      * @dev Allows the current owner to relinquish control of the contract.
85      * @notice Renouncing to ownership will leave the contract without an owner.
86      * It will not be possible to call the functions with the `onlyOwner`
87      * modifier anymore.
88      */
89     function renounceOwnership() public onlyOwner {
90         emit OwnershipRenounced(owner);
91         owner = address(0);
92     }
93 
94     /**
95      * @dev Allows the current owner to transfer control of the contract to a newOwner.
96      * @param _newOwner The address to transfer ownership to.
97      */
98     function transferOwnership(address _newOwner) public onlyOwner {
99         _transferOwnership(_newOwner);
100     }
101 
102     /**
103      * @dev Transfers control of the contract to a newOwner.
104      * @param _newOwner The address to transfer ownership to.
105      */
106     function _transferOwnership(address _newOwner) internal {
107         require(_newOwner != address(0));
108         emit OwnershipTransferred(owner, _newOwner);
109         owner = _newOwner;
110     }
111 }
112 
113 /**
114  * @title SafeERC20
115  * @dev Wrappers around ERC20 operations that throw on failure.
116  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
117  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
118  */
119 library SafeERC20 {
120     function safeTransfer(ERC20 token, address to, uint256 value) internal {
121         require(token.transfer(to, value));
122     }
123 }
124 
125 /**
126  * @title Oraclize contract interface (returns uint256 USD)
127  */
128 contract OraclizeInterface {
129   function getEthPrice() public view returns (uint256);
130 }
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 {
137   function totalSupply() public view returns (uint256);
138 
139   function balanceOf(address _who) public view returns (uint256);
140 
141   function allowance(address _owner, address _spender)
142     public view returns (uint256);
143 
144   function transfer(address _to, uint256 _value) public returns (bool);
145 
146   function approve(address _spender, uint256 _value)
147     public returns (bool);
148 
149   function transferFrom(address _from, address _to, uint256 _value)
150     public returns (bool);
151 
152   event Transfer(
153     address indexed from,
154     address indexed to,
155     uint256 value
156   );
157 
158   event Approval(
159     address indexed owner,
160     address indexed spender,
161     uint256 value
162   );
163 }
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
170  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
171  */
172 contract StandardToken is ERC20 {
173   using SafeMath for uint256;
174 
175   mapping (address => uint256) private balances;
176 
177   mapping (address => mapping (address => uint256)) private allowed;
178 
179   uint256 private totalSupply_;
180 
181   /**
182   * @dev Total number of tokens in existence
183   */
184   function totalSupply() public view returns (uint256) {
185     return totalSupply_;
186   }
187 
188   /**
189   * @dev Gets the balance of the specified address.
190   * @param _owner The address to query the the balance of.
191   * @return An uint256 representing the amount owned by the passed address.
192   */
193   function balanceOf(address _owner) public view returns (uint256) {
194     return balances[_owner];
195   }
196 
197   /**
198    * @dev Function to check the amount of tokens that an owner allowed to a spender.
199    * @param _owner address The address which owns the funds.
200    * @param _spender address The address which will spend the funds.
201    * @return A uint256 specifying the amount of tokens still available for the spender.
202    */
203   function allowance( address _owner, address _spender ) public view returns (uint256) {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208   * @dev Transfer token for a specified address
209   * @param _to The address to transfer to.
210   * @param _value The amount to be transferred.
211   */
212   function transfer(address _to, uint256 _value) public returns (bool) {
213     require(_value <= balances[msg.sender]);
214     require(_to != address(0));
215 
216     balances[msg.sender] = balances[msg.sender].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     emit Transfer(msg.sender, _to, _value);
219     return true;
220   }
221 
222   /**
223    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224    * Beware that changing an allowance with this method brings the risk that someone may use both the old
225    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228    * @param _spender The address which will spend the funds.
229    * @param _value The amount of tokens to be spent.
230    */
231   function approve(address _spender, uint256 _value) public returns (bool) {
232     allowed[msg.sender][_spender] = _value;
233     emit Approval(msg.sender, _spender, _value);
234     return true;
235   }
236 
237   /**
238    * @dev Transfer tokens from one address to another
239    * @param _from address The address which you want to send tokens from
240    * @param _to address The address which you want to transfer to
241    * @param _value uint256 the amount of tokens to be transferred
242    */
243   function transferFrom( address _from, address _to, uint256 _value ) public returns (bool) {
244     require(_value <= balances[_from]);
245     require(_value <= allowed[_from][msg.sender]);
246     require(_to != address(0));
247 
248     balances[_from] = balances[_from].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
251     emit Transfer(_from, _to, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Increase the amount of tokens that an owner allowed to a spender.
257    * approve should be called when allowed[_spender] == 0. To increment
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _addedValue The amount of tokens to increase the allowance by.
263    */
264   function increaseApproval( address _spender, uint256 _addedValue ) public returns (bool) {
265     allowed[msg.sender][_spender] = (
266       allowed[msg.sender][_spender].add(_addedValue));
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271   /**
272    * @dev Decrease the amount of tokens that an owner allowed to a spender.
273    * approve should be called when allowed[_spender] == 0. To decrement
274    * allowed value is better to use this function to avoid 2 calls (and wait until
275    * the first transaction is mined)
276    * From MonolithDAO Token.sol
277    * @param _spender The address which will spend the funds.
278    * @param _subtractedValue The amount of tokens to decrease the allowance by.
279    */
280   function decreaseApproval( address _spender, uint256 _subtractedValue ) public returns (bool) {
281     uint256 oldValue = allowed[msg.sender][_spender];
282     if (_subtractedValue >= oldValue) {
283       allowed[msg.sender][_spender] = 0;
284     } else {
285       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
286     }
287     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
288     return true;
289   }
290 
291   /**
292    * @dev Internal function that mints an amount of the token and assigns it to
293    * an account. This encapsulates the modification of balances such that the
294    * proper events are emitted.
295    * @param _account The account that will receive the created tokens.
296    * @param _amount The amount that will be created.
297    */
298   function _mint(address _account, uint256 _amount) internal {
299     require(_account != 0);
300     totalSupply_ = totalSupply_.add(_amount);
301     balances[_account] = balances[_account].add(_amount);
302     emit Transfer(address(0), _account, _amount);
303   }
304 
305   /**
306    * @dev Internal function that burns an amount of the token of a given
307    * account.
308    * @param _account The account whose tokens will be burnt.
309    * @param _amount The amount that will be burnt.
310    */
311   function _burn(address _account, uint256 _amount) internal {
312     require(_account != 0);
313     require(_amount <= balances[_account]);
314 
315     totalSupply_ = totalSupply_.sub(_amount);
316     balances[_account] = balances[_account].sub(_amount);
317     emit Transfer(_account, address(0), _amount);
318   }
319 
320   /**
321    * @dev Internal function that burns an amount of the token of a given
322    * account, deducting from the sender's allowance for said account. Uses the
323    * internal _burn function.
324    * @param _account The account whose tokens will be burnt.
325    * @param _amount The amount that will be burnt.
326    */
327   function _burnFrom(address _account, uint256 _amount) internal {
328     require(_amount <= allowed[_account][msg.sender]);
329 
330     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
331     // this function needs to emit an event with the updated approval.
332     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
333     _burn(_account, _amount);
334   }
335 }
336 
337 /**
338  * @title Burnable Token
339  * @dev Token that can be irreversibly burned (destroyed).
340  */
341 contract BurnableToken is StandardToken {
342 
343   event Burn(address indexed burner, uint256 value);
344 
345   /**
346    * @dev Burns a specific amount of tokens.
347    * @param _value The amount of token to be burned.
348    */
349   function burn(uint256 _value) public {
350     _burn(msg.sender, _value);
351   }
352 
353   /**
354    * @dev Burns a specific amount of tokens from the target address and decrements allowance
355    * @param _from address The address which you want to send tokens from
356    * @param _value uint256 The amount of token to be burned
357    */
358   function burnFrom(address _from, uint256 _value) public {
359     _burnFrom(_from, _value);
360   }
361 
362   /**
363    * @dev Overrides StandardToken._burn in order for burn and burnFrom to emit
364    * an additional Burn event.
365    */
366   function _burn(address _who, uint256 _value) internal {
367     super._burn(_who, _value);
368     emit Burn(_who, _value);
369   }
370 }
371 
372 /**
373  * @title EVOAIToken
374  */
375 contract EVOAIToken is BurnableToken {
376     string public constant name = "EVOAI";
377     string public constant symbol = "EVOT";
378     uint8 public constant decimals = 18;
379 
380     uint256 public constant INITIAL_SUPPLY = 10000000 * 1 ether; // Need to change
381 
382     /**
383      * @dev Constructor
384      */
385     constructor() public {
386         _mint(msg.sender, INITIAL_SUPPLY);
387     }
388 }
389 
390 /**
391  * @title Crowdsale
392  */
393 contract Crowdsale is Ownable {
394     using SafeMath for uint256;
395     using SafeERC20 for EVOAIToken;
396 
397     struct State {
398         string roundName;
399         uint256 round;    // Round index
400         uint256 tokens;   // Tokens amaunt for current round
401         uint256 rate;     // USD rate of tokens
402     }
403 
404     State public state;
405     EVOAIToken public token;
406     OraclizeInterface public oraclize;
407 
408     bool public open;
409     address public fundsWallet;
410     uint256 public weiRaised;
411     uint256 public usdRaised;
412     uint256 public privateSaleMinContrAmount = 1000;   // Min 1k
413     uint256 public privateSaleMaxContrAmount = 10000;  // Max 10k
414 
415     /**
416     * Event for token purchase logging
417     * @param purchaser who paid for the tokens
418     * @param beneficiary who got the tokens
419     * @param value weis paid for purchase
420     * @param amount amount of tokens purchased
421     */
422     event TokensPurchased(
423         address indexed purchaser,
424         address indexed beneficiary,
425         uint256 value,
426         uint256 amount
427     );
428 
429     event RoundStarts(uint256 timestamp, string round);
430 
431     /**
432     * Constructor
433     */
434     constructor(address _tokenColdWallet, address _fundsWallet, address _oraclize) public {
435         token = new EVOAIToken();
436         oraclize = OraclizeInterface(_oraclize);
437         open = false;
438         fundsWallet = _fundsWallet;
439         state.roundName = "Crowdsale doesnt started yet";
440         token.safeTransfer(_tokenColdWallet, 3200000 * 1 ether);
441     }
442 
443     // -----------------------------------------
444     // Crowdsale external interface
445     // -----------------------------------------
446 
447     /**
448     * @dev fallback function ***DO NOT OVERRIDE***
449     */
450     function () external payable {
451         buyTokens(msg.sender);
452     }
453 
454     /**
455     * @dev low level token purchase ***DO NOT OVERRIDE***
456     * @param _beneficiary Address performing the token purchase
457     */
458     function buyTokens(address _beneficiary) public payable {
459         uint256 weiAmount = msg.value;
460         _preValidatePurchase(_beneficiary, weiAmount);
461 
462         // calculate wei to usd amount
463         uint256 usdAmount = _getEthToUsdPrice(weiAmount);
464 
465         if(state.round == 1) {
466             _validateUSDAmount(usdAmount);
467         }
468 
469         // calculate token amount to be created
470         uint256 tokens = _getTokenAmount(usdAmount);
471 
472         assert(tokens <= state.tokens);
473 
474         usdAmount = usdAmount.div(100); // Removing cents after whole calculation
475 
476         // update state
477         state.tokens = state.tokens.sub(tokens);
478         weiRaised = weiRaised.add(weiAmount);
479         usdRaised = usdRaised.add(usdAmount);
480 
481         _processPurchase(_beneficiary, tokens);
482 
483         emit TokensPurchased(
484         msg.sender,
485         _beneficiary,
486         weiAmount,
487         tokens
488         );
489 
490         _forwardFunds();
491     }
492 
493     function changeFundsWallet(address _newFundsWallet) public onlyOwner {
494         require(_newFundsWallet != address(0));
495         fundsWallet = _newFundsWallet;
496     }
497 
498     function burnUnsoldTokens() public onlyOwner {
499         require(state.round > 8, "Crowdsale does not finished yet");
500 
501         uint256 unsoldTokens = token.balanceOf(this);
502         token.burn(unsoldTokens);
503     }
504 
505     function changeRound() public onlyOwner {
506         if(state.round == 0) {
507             state = State("Private sale", 1, 300000 * 1 ether, 35);
508             emit RoundStarts(now, "Private sale starts.");
509         } else if(state.round == 1) {
510             state = State("Pre sale", 2, 500000 * 1 ether, 45);
511             emit RoundStarts(now, "Pre sale starts.");
512         } else if(state.round == 2) {
513             state = State("1st round", 3, 1000000 * 1 ether, 55);
514             emit RoundStarts(now, "1st round starts.");
515         } else if(state.round == 3) {
516             state = State("2nd round",4, 1000000 * 1 ether, 65);
517             emit RoundStarts(now, "2nd round starts.");
518         } else if(state.round == 4) {
519             state = State("3th round",5, 1000000 * 1 ether, 75);
520             emit RoundStarts(now, "3th round starts.");
521         } else if(state.round == 5) {
522             state = State("4th round",6, 1000000 * 1 ether, 85);
523             emit RoundStarts(now, "4th round starts.");
524         } else if(state.round == 6) {
525             state = State("5th round",7, 1000000 * 1 ether, 95);
526             emit RoundStarts(now, "5th round starts.");
527         } else if(state.round == 7) {
528             state = State("6th round",8, 1000000 * 1 ether, 105);
529             emit RoundStarts(now, "6th round starts.");
530         } else if(state.round >= 8) {
531             state = State("Crowdsale finished!",9, 0, 0);
532             emit RoundStarts(now, "Crowdsale finished!");
533         }
534     }
535 
536     function endCrowdsale() external onlyOwner {
537         open = false;
538     }
539 
540     function startCrowdsale() external onlyOwner {
541         open = true;
542     }
543 
544     // -----------------------------------------
545     // Internal interface
546     // -----------------------------------------
547 
548     /**
549     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
550     * Example from CappedCrowdsale.sol's _preValidatePurchase method:
551     *   super._preValidatePurchase(_beneficiary, _weiAmount);
552     *   require(weiRaised.add(_weiAmount) <= cap);
553     * @param _beneficiary Address performing the token purchase
554     * @param _weiAmount Value in wei involved in the purchase
555     */
556     function _preValidatePurchase( address _beneficiary, uint256 _weiAmount ) internal view {
557         require(open);
558         require(_beneficiary != address(0));
559         require(_weiAmount != 0);
560     }
561 
562     /**
563     * @dev Validate usd amount for private sale
564     */
565     function _validateUSDAmount( uint256 _usdAmount) internal view {
566         require(_usdAmount.div(100) > privateSaleMinContrAmount);
567         require(_usdAmount.div(100) < privateSaleMaxContrAmount);
568     }
569 
570     /**
571     * @dev Convert ETH to USD and return amount
572     * @param _weiAmount ETH amount which will convert to USD
573     */
574     function _getEthToUsdPrice(uint256 _weiAmount) internal view returns(uint256) {
575         return _weiAmount.mul(_getEthUsdPrice()).div(1 ether);
576     }
577 
578     /**
579     * @dev Getting price from oraclize contract
580     */
581     function _getEthUsdPrice() internal view returns (uint256) {
582         return oraclize.getEthPrice();
583     }
584 
585     /**
586     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
587     * @param _beneficiary Address performing the token purchase
588     * @param _tokenAmount Number of tokens to be emitted
589     */
590     function _deliverTokens( address _beneficiary, uint256 _tokenAmount ) internal {
591         token.safeTransfer(_beneficiary, _tokenAmount);
592     }
593 
594     /**
595     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
596     * @param _beneficiary Address receiving the tokens
597     * @param _tokenAmount Number of tokens to be purchased
598     */
599     function _processPurchase( address _beneficiary, uint256 _tokenAmount ) internal {
600         _deliverTokens(_beneficiary, _tokenAmount);
601     }
602 
603     /**
604     * @dev Override to extend the way in which usd is converted to tokens.
605     * @param _usdAmount Value in usd to be converted into tokens
606     * @return Number of tokens that can be purchased with the specified _usdAmount
607     */
608     function _getTokenAmount(uint256 _usdAmount) internal view returns (uint256) {
609         return _usdAmount.div(state.rate).mul(1 ether);
610     }
611 
612     /**
613     * @dev Determines how ETH is stored/forwarded on purchases.
614     */
615     function _forwardFunds() internal {
616         fundsWallet.transfer(msg.value);
617     }
618 }