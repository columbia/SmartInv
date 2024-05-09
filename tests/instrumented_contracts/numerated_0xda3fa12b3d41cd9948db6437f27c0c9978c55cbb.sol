1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20Basic {
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 library SafeMath {
13 
14 
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26 
27     uint256 c = a / b;
28 
29     return c;
30   }
31 
32 
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   uint256 totalSupply_;
53 
54   function totalSupply() public view returns (uint256) {
55     return totalSupply_;
56   }
57 
58 
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value <= balances[msg.sender]);
62 
63 
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   function balanceOf(address _owner) public view returns (uint256 balance) {
71     return balances[_owner];
72   }
73 
74 }
75 
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender) public view returns (uint256);
78   function transferFrom(address from, address to, uint256 value) public returns (bool);
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 
85 contract StandardToken is ERC20, BasicToken {
86 
87   mapping (address => mapping (address => uint256)) internal allowed;
88 
89 
90   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[_from]);
93     require(_value <= allowed[_from][msg.sender]);
94 
95     balances[_from] = balances[_from].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98     Transfer(_from, _to, _value);
99     return true;
100   }
101 
102   function approve(address _spender, uint256 _value) public returns (bool) {
103     allowed[msg.sender][_spender] = _value;
104     Approval(msg.sender, _spender, _value);
105     return true;
106   }
107 
108   function allowance(address _owner, address _spender) public view returns (uint256) {
109     return allowed[_owner][_spender];
110   }
111 
112   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
113     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
114     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115     return true;
116   }
117 
118   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
119     uint oldValue = allowed[msg.sender][_spender];
120     if (_subtractedValue > oldValue) {
121       allowed[msg.sender][_spender] = 0;
122     } else {
123       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
124     }
125     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 
129 }
130 
131 
132 contract EnkronosToken is StandardToken {
133 
134 	string public name = 'EnkronosToken';
135 	string public symbol = 'ENK';
136 	uint8 public decimals = 18;
137 	uint public INITIAL_SUPPLY = 500000000000000000000000000;
138 
139 
140 	function EnkronosToken() public {
141 	  totalSupply_ = INITIAL_SUPPLY;
142 	  balances[msg.sender] = INITIAL_SUPPLY;
143 	}
144 
145 }
146 
147 contract Crowdsale {
148   using SafeMath for uint256;
149 
150   // The token being sold
151   ERC20 public token;
152 
153   // Address where funds are collected
154   address public wallet;
155 
156   // How many token units a buyer gets per wei
157   uint256 public rate;
158 
159   // Amount of wei raised
160   uint256 public weiRaised;
161 
162   /**
163    * Event for token purchase logging
164    * @param purchaser who paid for the tokens
165    * @param beneficiary who got the tokens
166    * @param value weis paid for purchase
167    * @param amount amount of tokens purchased
168    */
169   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
170 
171   /**
172    * @param _rate Number of token units a buyer gets per wei
173    * @param _wallet Address where collected funds will be forwarded to
174    * @param _token Address of the token being sold
175    */
176   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
177     require(_rate > 0);
178     require(_wallet != address(0));
179     require(_token != address(0));
180 
181     rate = _rate;
182     wallet = _wallet;
183     token = _token;
184   }
185 
186   // -----------------------------------------
187   // Crowdsale external interface
188   // -----------------------------------------
189 
190   /**
191    * @dev fallback function ***DO NOT OVERRIDE***
192    */
193   function () external payable {
194     buyTokens(msg.sender);
195   }
196 
197   /**
198    * @dev low level token purchase ***DO NOT OVERRIDE***
199    * @param _beneficiary Address performing the token purchase
200    */
201   function buyTokens(address _beneficiary) public payable {
202 
203     uint256 weiAmount = msg.value;
204     _preValidatePurchase(_beneficiary, weiAmount);
205 
206     // calculate token amount to be created
207     uint256 tokens = _getTokenAmount(weiAmount);
208 
209     // update state
210     weiRaised = weiRaised.add(weiAmount);
211 
212     _processPurchase(_beneficiary, tokens);
213     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
214 
215     _updatePurchasingState(_beneficiary, weiAmount);
216 
217     _forwardFunds();
218     _postValidatePurchase(_beneficiary, weiAmount);
219   }
220 
221   // -----------------------------------------
222   // Internal interface (extensible)
223   // -----------------------------------------
224 
225   /**
226    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
227    * @param _beneficiary Address performing the token purchase
228    * @param _weiAmount Value in wei involved in the purchase
229    */
230   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
231     require(_beneficiary != address(0));
232     require(_weiAmount != 0);
233   }
234 
235   /**
236    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
237    * @param _beneficiary Address performing the token purchase
238    * @param _weiAmount Value in wei involved in the purchase
239    */
240   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
241     // optional override
242   }
243 
244   /**
245    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
246    * @param _beneficiary Address performing the token purchase
247    * @param _tokenAmount Number of tokens to be emitted
248    */
249   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
250     token.transfer(_beneficiary, _tokenAmount);
251   }
252 
253   /**
254    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
255    * @param _beneficiary Address receiving the tokens
256    * @param _tokenAmount Number of tokens to be purchased
257    */
258   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
259     _deliverTokens(_beneficiary, _tokenAmount);
260   }
261 
262   /**
263    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
264    * @param _beneficiary Address receiving the tokens
265    * @param _weiAmount Value in wei involved in the purchase
266    */
267   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
268     // optional override
269   }
270 
271   /**
272    * @dev Override to extend the way in which ether is converted to tokens.
273    * @param _weiAmount Value in wei to be converted into tokens
274    * @return Number of tokens that can be purchased with the specified _weiAmount
275    */
276   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
277     return _weiAmount.mul(rate);
278   }
279 
280   /**
281    * @dev Determines how ETH is stored/forwarded on purchases.
282    */
283   function _forwardFunds() internal {
284     wallet.transfer(msg.value);
285   }
286 }
287 
288 
289 
290 contract Ownable {
291   address public owner;
292 
293 
294   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296 
297   /**
298    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
299    * account.
300    */
301   function Ownable() public {
302     owner = msg.sender;
303   }
304 
305   /**
306    * @dev Throws if called by any account other than the owner.
307    */
308   modifier onlyOwner() {
309     require(msg.sender == owner);
310     _;
311   }
312 
313   /**
314    * @dev Allows the current owner to transfer control of the contract to a newOwner.
315    * @param newOwner The address to transfer ownership to.
316    */
317   function transferOwnership(address newOwner) public onlyOwner {
318     require(newOwner != address(0));
319     OwnershipTransferred(owner, newOwner);
320     owner = newOwner;
321   }
322 
323 }
324 
325 
326 /**
327  * @title WhitelistedCrowdsale
328  * @dev Crowdsale in which only whitelisted users can contribute.
329  */
330 contract WhitelistedCrowdsale is Crowdsale, Ownable {
331 
332   mapping(address => bool) public whitelist;
333 
334   /**
335    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
336    */
337   modifier isWhitelisted(address _beneficiary) {
338     require(whitelist[_beneficiary]);
339     _;
340   }
341 
342   /**
343    * @dev Adds single address to whitelist.
344    * @param _beneficiary Address to be added to the whitelist
345    */
346   function addToWhitelist(address _beneficiary) external onlyOwner {
347     whitelist[_beneficiary] = true;
348   }
349 
350   /**
351    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
352    * @param _beneficiaries Addresses to be added to the whitelist
353    */
354   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
355     for (uint256 i = 0; i < _beneficiaries.length; i++) {
356       whitelist[_beneficiaries[i]] = true;
357     }
358   }
359 
360   /**
361    * @dev Removes single address from whitelist.
362    * @param _beneficiary Address to be removed to the whitelist
363    */
364   function removeFromWhitelist(address _beneficiary) external onlyOwner {
365     whitelist[_beneficiary] = false;
366   }
367 
368   /**
369    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
370    * @param _beneficiary Token beneficiary
371    * @param _weiAmount Amount of wei contributed
372    */
373   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
374     super._preValidatePurchase(_beneficiary, _weiAmount);
375   }
376 
377 }
378 
379 contract RefundVault is Ownable {
380   using SafeMath for uint256;
381 
382   enum State { Active, Refunding, Closed }
383 
384   mapping (address => uint256) public deposited;
385   address public wallet;
386   State public state;
387 
388   event Closed();
389   event RefundsEnabled();
390   event Refunded(address indexed beneficiary, uint256 weiAmount);
391 
392   /**
393    * @param _wallet Vault address
394    */
395   function RefundVault(address _wallet) public {
396     require(_wallet != address(0));
397     wallet = _wallet;
398     state = State.Active;
399   }
400 
401   /**
402    * @param investor Investor address
403    */
404   function deposit(address investor) onlyOwner public payable {
405     require(state == State.Active);
406     deposited[investor] = deposited[investor].add(msg.value);
407   }
408 
409   function close() onlyOwner public {
410     require(state == State.Active);
411     state = State.Closed;
412     Closed();
413     wallet.transfer(this.balance);
414   }
415 
416   function enableRefunds() onlyOwner public {
417     require(state == State.Active);
418     state = State.Refunding;
419     RefundsEnabled();
420   }
421 
422   /**
423    * @param investor Investor address
424    */
425   function refund(address investor) public {
426     require(state == State.Refunding);
427     uint256 depositedValue = deposited[investor];
428     deposited[investor] = 0;
429     investor.transfer(depositedValue);
430     Refunded(investor, depositedValue);
431   }
432 }
433 
434 contract EnkronosCrowdsale is WhitelistedCrowdsale {
435     //
436     uint256 public goal;
437     //
438     uint256 public minBuy;
439     //
440     RefundVault public vault;
441     //
442     function EnkronosCrowdsale (
443 			       uint256 _rate,
444              address _wallet,
445              StandardToken _token,
446              uint256 _goal
447     )
448     public
449     Crowdsale(_rate, _wallet, _token)
450     WhitelistedCrowdsale() {
451 
452       require(_goal > 0);
453       vault = new RefundVault(wallet);
454       goal = _goal;
455 
456       setMinBuyPrivate();
457       setWhitelistOn();
458     }
459 
460     /**
461      * @dev Investors can claim refunds here if crowdsale is unsuccessful
462      */
463     function claimRefund() public {
464         require(isFinalized);
465         require(!goalReached());
466         vault.refund(msg.sender);
467     }
468 
469     /**
470      * @dev Checks whether funding goal was reached.
471      * @return Whether funding goal was reached
472      */
473     function goalReached() public view returns (bool) {
474         return weiRaised >= goal;
475     }
476 
477 
478     bool public isFinalized = false;
479     event Finalized();
480     /**
481      * @dev Must be called after crowdsale ends, to do some extra finalization
482      * work. Calls the contract's finalization function.
483      */
484     function finalize() onlyOwner public {
485         require(!isFinalized);
486         //require(hasClosed()); From TimedCrowdsale
487 
488         finalization();
489         Finalized();
490 
491         isFinalized = true;
492     }
493 
494     /**
495      * @dev Can be overridden to add finalization logic. The overriding function
496      * should call super.finalization() to ensure the chain of finalization is
497      * executed entirely.
498      */
499     function finalization() internal {
500       //
501       if (goalReached()) {
502         vault.close();
503       } else {
504         vault.enableRefunds();
505       }
506       //
507         uint remaining = token.balanceOf(this);
508         token.transfer(owner, remaining);
509     }
510     /**
511      * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
512      */
513     function _forwardFunds() internal {
514         vault.deposit.value(msg.value)(msg.sender);
515     }
516     //
517     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
518         require(_weiAmount >= minBuy);
519         super._preValidatePurchase(_beneficiary, _weiAmount);
520     }
521     //
522     function setRate1666() onlyOwner public {
523         rate = 1666;
524     }
525     function setRate555() onlyOwner public {
526         rate = 555;
527     }
528     function setRate362() onlyOwner public {
529         rate = 362;
530     }
531     function setRate347() onlyOwner public {
532         rate = 347;
533     }
534     function setRate340() onlyOwner public {
535         rate = 340;
536     }
537     function setRate333() onlyOwner public {
538         rate = 333;
539     }
540     //
541     function setMinBuyPrivate() onlyOwner public {
542         minBuy = 10000000000000000000; // 10 ether
543     }
544     function setMinBuyPublic() onlyOwner public {
545         minBuy = 100000000000000000; // 0.1 ether
546     }
547     //
548     bool public isWhitelistOn;
549     function setWhitelistOn() onlyOwner public {
550         isWhitelistOn = true;
551     }
552     function setWhitelistOff() onlyOwner public {
553         isWhitelistOn = false;
554     }
555 
556     modifier isWhitelisted(address _beneficiary) {
557       if(isWhitelistOn)
558         require(whitelist[_beneficiary]);
559       _;
560     }
561 }