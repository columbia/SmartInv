1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67     require(_value <= balances[msg.sender]);
68 
69     // SafeMath.sub will throw if there is not enough balance.
70     balances[msg.sender] = balances[msg.sender].sub(_value);
71     balances[_to] = balances[_to].add(_value);
72     Transfer(msg.sender, _to, _value);
73     return true;
74   }
75 
76   /**
77   * @dev Gets the balance of the specified address.
78   * @param _owner The address to query the the balance of.
79   * @return An uint256 representing the amount owned by the passed address.
80   */
81   function balanceOf(address _owner) public view returns (uint256 balance) {
82     return balances[_owner];
83   }
84 
85 }
86 
87 
88 
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 
103 /**
104  * @title Standard ERC20 token
105  *
106  * @dev Implementation of the basic standard token.
107  * @dev https://github.com/ethereum/EIPs/issues/20
108  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, BasicToken {
111 
112   mapping (address => mapping (address => uint256)) internal allowed;
113 
114 
115   /**
116    * @dev Transfer tokens from one address to another
117    * @param _from address The address which you want to send tokens from
118    * @param _to address The address which you want to transfer to
119    * @param _value uint256 the amount of tokens to be transferred
120    */
121   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[_from]);
124     require(_value <= allowed[_from][msg.sender]);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
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
148 
149   /**
150    * @dev Function to check the amount of tokens that an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint256 specifying the amount of tokens still available for the spender.
154    */
155   function allowance(address _owner, address _spender) public view returns (uint256) {
156     return allowed[_owner][_spender];
157   }
158 
159   /**
160    * @dev Increase the amount of tokens that an owner allowed to a spender.
161    *
162    * approve should be called when allowed[_spender] == 0. To increment
163    * allowed value is better to use this function to avoid 2 calls (and wait until
164    * the first transaction is mined)
165    * From MonolithDAO Token.sol
166    * @param _spender The address which will spend the funds.
167    * @param _addedValue The amount of tokens to increase the allowance by.
168    */
169   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
170     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175   /**
176    * @dev Decrease the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To decrement
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _subtractedValue The amount of tokens to decrease the allowance by.
184    */
185   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196 }
197 
198 
199 
200 /**
201  * @title Ownable
202  * @dev The Ownable contract has an owner address, and provides basic authorization control
203  * functions, this simplifies the implementation of "user permissions".
204  */
205 contract Ownable {
206   address public owner;
207 
208 
209   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
210 
211 
212   /**
213    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
214    * account.
215    */
216   function Ownable() public {
217     owner = msg.sender;
218   }
219 
220 
221   /**
222    * @dev Throws if called by any account other than the owner.
223    */
224   modifier onlyOwner() {
225     require(msg.sender == owner);
226     _;
227   }
228 
229 
230   /**
231    * @dev Allows the current owner to transfer control of the contract to a newOwner.
232    * @param newOwner The address to transfer ownership to.
233    */
234   function transferOwnership(address newOwner) public onlyOwner {
235     require(newOwner != address(0));
236     OwnershipTransferred(owner, newOwner);
237     owner = newOwner;
238   }
239 
240 }
241 
242 
243 
244 contract MintableToken is StandardToken, Ownable {
245   event Mint(address indexed to, uint256 amount);
246   event MintFinished();
247 
248   bool public mintingFinished = false;
249 
250 
251   modifier canMint() {
252     require(!mintingFinished);
253     _;
254   }
255 
256   /**
257    * @dev Function to mint tokens
258    * @param _to The address that will receive the minted tokens.
259    * @param _amount The amount of tokens to mint.
260    * @return A boolean that indicates if the operation was successful.
261    */
262   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
263     totalSupply = totalSupply.add(_amount);
264     balances[_to] = balances[_to].add(_amount);
265     Mint(_to, _amount);
266     Transfer(address(0), _to, _amount);
267     return true;
268   }
269 
270   /**
271    * @dev Function to stop minting new tokens.
272    * @return True if the operation was successful.
273    */
274   function finishMinting() onlyOwner canMint public returns (bool) {
275     mintingFinished = true;
276     MintFinished();
277     return true;
278   }
279 }
280 
281 
282 
283 contract CakToken is MintableToken {
284     string public constant name = "Cash Account Key";
285     string public constant symbol = "CAK";
286     uint8 public constant decimals = 0;
287 }
288 
289 /**
290  * @title Crowdsale
291  * @dev Crowdsale is a base contract for managing a token crowdsale.
292  * Crowdsales have a start and end timestamps, where investors can make
293  * token purchases and the crowdsale will assign them tokens based
294  * on a token per ETH rate. Funds collected are forwarded to a wallet
295  * as they arrive.
296  */
297 contract Crowdsale {
298   using SafeMath for uint256;
299 
300   // The token being sold
301   MintableToken public token;
302 
303   // start and end timestamps where investments are allowed (both inclusive)
304   uint256 public startTime;
305   uint256 public endTime;
306 
307   // address where funds are collected
308   address public wallet;
309 
310   // how many token units a buyer gets per wei
311   uint256 public rate;
312 
313   // amount of raised money in wei
314   uint256 public weiRaised;
315 
316   /**
317    * event for token purchase logging
318    * @param purchaser who paid for the tokens
319    * @param beneficiary who got the tokens
320    * @param value weis paid for purchase
321    * @param amount amount of tokens purchased
322    */
323   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
324 
325 
326   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
327     require(_startTime >= now);
328     require(_endTime >= _startTime);
329     require(_rate > 0);
330     require(_wallet != address(0));
331 
332     token = createTokenContract();
333     startTime = _startTime;
334     endTime = _endTime;
335     rate = _rate;
336     wallet = _wallet;
337   }
338 
339   // creates the token to be sold.
340   // override this method to have crowdsale of a specific mintable token.
341   function createTokenContract() internal returns (MintableToken) {
342     return new MintableToken();
343   }
344 
345 
346   // fallback function can be used to buy tokens
347   function () external payable {
348     buyTokens(msg.sender);
349   }
350 
351   // low level token purchase function
352   function buyTokens(address beneficiary) public payable {
353     require(beneficiary != address(0));
354     require(validPurchase());
355 
356     uint256 weiAmount = msg.value;
357 
358     // calculate token amount to be created
359     uint256 tokens = weiAmount.mul(rate);
360 
361     // update state
362     weiRaised = weiRaised.add(weiAmount);
363 
364     token.mint(beneficiary, tokens);
365     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
366 
367     forwardFunds();
368   }
369 
370   // send ether to the fund collection wallet
371   // override to create custom fund forwarding mechanisms
372   function forwardFunds() internal {
373     wallet.transfer(msg.value);
374   }
375 
376   // @return true if the transaction can buy tokens
377   function validPurchase() internal view returns (bool) {
378     bool withinPeriod = now >= startTime && now <= endTime;
379     bool nonZeroPurchase = msg.value != 0;
380     return withinPeriod && nonZeroPurchase;
381   }
382 
383   // @return true if crowdsale event has ended
384   function hasEnded() public view returns (bool) {
385     return now > endTime;
386   }
387 
388 
389 }
390 
391 
392 contract CakCrowdsale is Ownable, Crowdsale {
393     using SafeMath for uint256;
394 
395     enum SaleStages { Crowdsale, Finalized }
396     SaleStages public currentStage;
397 
398     uint256 public constant TOKEN_CAP = 3e7;
399     uint256 public totalTokensMinted;
400 
401     // allow managers to whitelist and confirm contributions by manager accounts
402     // (managers can be set and altered by owner, multiple manager accounts are possible
403     mapping(address => bool) public isManagers;
404 
405     // true if address is allowed to invest
406     mapping(address => bool) public isWhitelisted;
407 
408     // list of events
409     event ChangedInvestorWhitelisting(address indexed investor, bool whitelisted);
410     event ChangedManager(address indexed manager, bool active);
411     event PresaleMinted(address indexed beneficiary, uint256 tokenAmount);
412     event CakCalcAmount(uint256 tokenAmount, uint256 weiReceived, uint256 rate);
413     event RefundAmount(address indexed beneficiary, uint256 refundAmount);
414 
415     // list of modifers
416     modifier onlyManager(){
417         require(isManagers[msg.sender]);
418         _;
419     }
420 
421     modifier onlyCrowdsaleStage() {
422         require(currentStage == SaleStages.Crowdsale);
423         _;
424     }
425 
426     /**
427      * @dev Constructor
428      * @param _startTime uint256
429      * @param _endTime unit256
430      * @param _rate uint256
431      * @param _wallet address
432      */
433     function CakCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet)
434         Crowdsale(_startTime, _endTime, _rate, _wallet)
435         public
436     {
437         setManager(msg.sender, true);
438         currentStage = SaleStages.Crowdsale;
439     }
440 
441     /**
442     * @dev allows contract owner to mint tokens for presale or non-ETH contributions in batches
443      * @param _toList address[] array of the beneficiaries to receive tokens
444      * @param _tokenList uint256[] array of the token amounts to mint for the corresponding users
445     */
446     function batchMintPresaleTokens(address[] _toList, uint256[] _tokenList) external onlyOwner onlyCrowdsaleStage {
447         require(_toList.length == _tokenList.length);
448 
449         for (uint256 i; i < _toList.length; i = i.add(1)) {
450             mintPresaleTokens(_toList[i], _tokenList[i]);
451         }
452     }
453 
454     /**
455      * @dev mint tokens for presale beneficaries
456      * @param _beneficiary address address of the presale buyer
457      * @param _amount unit256 amount of CAK tokens they will receieve
458      */
459     function mintPresaleTokens(address _beneficiary, uint256 _amount) public onlyOwner onlyCrowdsaleStage {
460         require(_beneficiary != address(0));
461         require(_amount > 0);
462         require(totalTokensMinted.add(_amount) <= TOKEN_CAP);
463         require(now < startTime);
464 
465         token.mint(_beneficiary, _amount);
466         totalTokensMinted = totalTokensMinted.add(_amount);
467         PresaleMinted(_beneficiary, _amount);
468     }
469 
470      /**
471      * @dev entry point for the buying of CAK tokens. overriding open zeppelins buyTokens()
472      * @param _beneficiary address address of the investor, must be whitelested first
473      */
474     function buyTokens(address _beneficiary) public payable onlyCrowdsaleStage {
475         require(_beneficiary != address(0));
476         require(isWhitelisted[msg.sender]);
477         require(validPurchase());
478         require(msg.value >= rate);  //rate == minimum amount in WEI to purchase 1 CAK token
479 
480         uint256 weiAmount = msg.value;
481         weiRaised = weiRaised.add(weiAmount);
482 
483         // Calculate the amount of tokens
484         uint256 tokens = calcCakAmount(weiAmount);
485         CakCalcAmount(tokens, weiAmount, rate);
486         require(totalTokensMinted.add(tokens) <= TOKEN_CAP);
487 
488         token.mint(_beneficiary, tokens);
489         totalTokensMinted = totalTokensMinted.add(tokens);
490         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
491 
492         uint256 refundAmount = refundLeftOverWei(weiAmount, tokens);
493         if (refundAmount > 0) {
494             weiRaised = weiRaised.sub(refundAmount);
495             msg.sender.transfer(refundAmount);
496             RefundAmount(msg.sender, refundAmount);
497         }
498 
499         forwardEther(refundAmount);
500     }
501 
502      /**
503      * @dev set manager to true/false to enable/disable manager rights
504      * @param _manager address address of the manager to create/alter
505      * @param _active bool flag that shows if the manager account is active
506      */
507     function setManager(address _manager, bool _active) public onlyOwner {
508         require(_manager != address(0));
509         isManagers[_manager] = _active;
510         ChangedManager(_manager, _active);
511     }
512 
513     /**
514      * @dev whitelister "account". This can be done from managers only
515      * @param _investor address address of the investor's wallet
516      */
517     function whiteListInvestor(address _investor) external onlyManager {
518         require(_investor != address(0));
519         isWhitelisted[_investor] = true;
520         ChangedInvestorWhitelisting(_investor, true);
521     }
522 
523     /**
524      * @dev whitelister "accounts". This can be done from managers only
525      * @param _investors address[] addresses of the investors' wallet
526      */
527     function batchWhiteListInvestors(address[] _investors) external onlyManager {
528         address investor;
529 
530         for (uint256 c; c < _investors.length; c = c.add(1)) {
531             investor = _investors[c]; // gas optimization
532             isWhitelisted[investor] = true;
533             ChangedInvestorWhitelisting(investor, true);
534         }
535     }
536 
537     /**
538      * @dev un-whitelister "account". This can be done from managers only
539      * @param _investor address address of the investor's wallet
540      */
541     function unWhiteListInvestor(address _investor) external onlyManager {
542         require(_investor != address(0));
543         isWhitelisted[_investor] = false;
544         ChangedInvestorWhitelisting(_investor, false);
545     }
546 
547     /**
548      * @dev ends the crowdsale, callable only by contract owner
549      */
550     function finalizeSale() public onlyOwner {
551          currentStage = SaleStages.Finalized;
552          token.finishMinting();
553     }
554 
555     /**
556      * @dev calculate WEI to CAK tokens to mint
557      * @param weiReceived uint256 wei received from the investor
558      */
559     function calcCakAmount(uint256 weiReceived) public view returns (uint256) {
560         uint256 tokenAmount = weiReceived.div(rate);
561         return tokenAmount;
562     }
563 
564     /**
565      * @dev calculate WEI refund to investor, if any. This handles rounding errors
566      * which are important here due to the 0 decimals
567      * @param weiReceived uint256 wei received from the investor
568      * @param tokenAmount uint256 CAK tokens minted for investor
569      */
570     function refundLeftOverWei(uint256 weiReceived, uint256 tokenAmount) internal view returns (uint256) {
571         uint256 refundAmount = 0;
572         uint256 weiInvested = tokenAmount.mul(rate);
573         if (weiInvested < weiReceived)
574             refundAmount = weiReceived.sub(weiInvested);
575         return refundAmount;
576     }
577 
578     /**
579      * Overrides the Crowdsale.createTokenContract to create a CAK token
580      * instead of a default MintableToken.
581      */
582     function createTokenContract() internal returns (MintableToken) {
583         return new CakToken();
584     }
585 
586     /**
587      * @dev forward Ether to wallet with proper amount subtracting refund, if refund exists
588      * @param refund unint256 the amount refunded to the investor, if > 0 
589      */
590     function forwardEther(uint256 refund) internal {
591         wallet.transfer(msg.value.sub(refund));
592     }
593 }