1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address _who) public view returns (uint256);
6   function transfer(address _to, uint256 _value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
16     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
17     // benefit is lost if 'b' is also tested.
18     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19     if (_a == 0) {
20       return 0;
21     }
22 
23     c = _a * _b;
24     assert(c / _a == _b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
32     // assert(_b > 0); // Solidity automatically throws when dividing by 0
33     // uint256 c = _a / _b;
34     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
35     return _a / _b;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     assert(_b <= _a);
43     return _a - _b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
50     c = _a + _b;
51     assert(c >= _a);
52     return c;
53   }
54 }
55 
56 contract ERC20 is ERC20Basic {
57   function allowance(address _owner, address _spender)
58     public view returns (uint256);
59 
60   function transferFrom(address _from, address _to, uint256 _value)
61     public returns (bool);
62 
63   function approve(address _spender, uint256 _value) public returns (bool);
64   event Approval(
65     address indexed owner,
66     address indexed spender,
67     uint256 value
68   );
69 }
70 
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) internal balances;
75 
76   uint256 internal totalSupply_;
77 
78   /**
79   * @dev Total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev Transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_value <= balances[msg.sender]);
92     require(_to != address(0));
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 library SafeERC20 {
112   function safeTransfer(
113     ERC20Basic _token,
114     address _to,
115     uint256 _value
116   )
117     internal
118   {
119     require(_token.transfer(_to, _value));
120   }
121 
122   function safeTransferFrom(
123     ERC20 _token,
124     address _from,
125     address _to,
126     uint256 _value
127   )
128     internal
129   {
130     require(_token.transferFrom(_from, _to, _value));
131   }
132 
133   function safeApprove(
134     ERC20 _token,
135     address _spender,
136     uint256 _value
137   )
138     internal
139   {
140     require(_token.approve(_spender, _value));
141   }
142 }
143 
144 contract DetailedERC20 is ERC20 {
145   string public name;
146   string public symbol;
147   uint8 public decimals;
148 
149   constructor(string _name, string _symbol, uint8 _decimals) public {
150     name = _name;
151     symbol = _symbol;
152     decimals = _decimals;
153   }
154 }
155 
156 contract Crowdsale {
157   using SafeMath for uint256;
158   using SafeERC20 for ERC20;
159 
160   // The token being sold
161   ERC20 public token;
162 
163   // Address where funds are collected
164   address public wallet;
165 
166   // How many token units a buyer gets per wei.
167   // The rate is the conversion between wei and the smallest and indivisible token unit.
168   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
169   // 1 wei will give you 1 unit, or 0.001 TOK.
170   uint256 internal rate;
171 
172   // Amount of wei raised
173   uint256 public weiRaised;
174 
175   /**
176    * Event for token purchase logging
177    * @param purchaser who paid for the tokens
178    * @param beneficiary who got the tokens
179    * @param value weis paid for purchase
180    * @param amount amount of tokens purchased
181    */
182   event TokenPurchase(
183     address indexed purchaser,
184     address indexed beneficiary,
185     uint256 value,
186     uint256 amount
187   );
188 
189   /**
190    * @param _wallet Address where collected funds will be forwarded to
191    * @param _token Address of the token being sold
192    */
193   constructor(address _wallet, ERC20 _token) public {
194     require(_wallet != address(0));
195     require(_token != address(0));
196     wallet = _wallet;
197     token = _token;
198   }
199 
200   // -----------------------------------------
201   // Crowdsale external interface
202   // -----------------------------------------
203 
204   /**
205    * @dev fallback function ***DO NOT OVERRIDE***
206    */
207   function () external payable {
208     buyTokens(msg.sender);
209   }
210 
211   /**
212    * @dev low level token purchase ***DO NOT OVERRIDE***
213    * @param _beneficiary Address performing the token purchase
214    */
215   function buyTokens(address _beneficiary) public payable {
216 
217     uint256 weiAmount = msg.value;
218     _preValidatePurchase(_beneficiary, weiAmount);
219 
220     // calculate token amount to be created
221     uint256 tokens = _getTokenAmount(weiAmount);
222 
223     // update state
224     weiRaised = weiRaised.add(weiAmount);
225 
226     _processPurchase(_beneficiary, tokens);
227     emit TokenPurchase(
228       msg.sender,
229       _beneficiary,
230       weiAmount,
231       tokens
232     );
233 
234     _updatePurchasingState(_beneficiary, weiAmount);
235 
236     _forwardFunds();
237     _postValidatePurchase(_beneficiary, weiAmount);
238   }
239 
240   // -----------------------------------------
241   // Internal interface (extensible)
242   // -----------------------------------------
243 
244   /**
245    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
246    * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
247    *   super._preValidatePurchase(_beneficiary, _weiAmount);
248    *   require(weiRaised.add(_weiAmount) <= cap);
249    * @param _beneficiary Address performing the token purchase
250    * @param _weiAmount Value in wei involved in the purchase
251    */
252   function _preValidatePurchase(
253     address _beneficiary,
254     uint256 _weiAmount
255   )
256     internal
257   {
258     require(_beneficiary != address(0));
259     require(_weiAmount != 0);
260   }
261 
262   /**
263    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
264    * @param _beneficiary Address performing the token purchase
265    * @param _weiAmount Value in wei involved in the purchase
266    */
267   function _postValidatePurchase(
268     address _beneficiary,
269     uint256 _weiAmount
270   )
271     internal
272   {
273     // optional override
274   }
275 
276   /**
277    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
278    * @param _beneficiary Address performing the token purchase
279    * @param _tokenAmount Number of tokens to be emitted
280    */
281   function _deliverTokens(
282     address _beneficiary,
283     uint256 _tokenAmount
284   )
285     internal
286   {
287     token.safeTransfer(_beneficiary, _tokenAmount);
288   }
289 
290   /**
291    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
292    * @param _beneficiary Address receiving the tokens
293    * @param _tokenAmount Number of tokens to be purchased
294    */
295   function _processPurchase(
296     address _beneficiary,
297     uint256 _tokenAmount
298   )
299     internal
300   {
301     _deliverTokens(_beneficiary, _tokenAmount);
302   }
303 
304   /**
305    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
306    * @param _beneficiary Address receiving the tokens
307    * @param _weiAmount Value in wei involved in the purchase
308    */
309   function _updatePurchasingState(
310     address _beneficiary,
311     uint256 _weiAmount
312   )
313     internal
314   {
315     // optional override
316   }
317 
318   /**
319    * @dev Override to extend the way in which ether is converted to tokens.
320    * @param _weiAmount Value in wei to be converted into tokens
321    * @return Number of tokens that can be purchased with the specified _weiAmount
322    */
323   function _getTokenAmount(uint256 _weiAmount)
324     internal view returns (uint256)
325   {
326     return _weiAmount.mul(rate);
327   }
328 
329   /**
330    * @dev Determines how ETH is stored/forwarded on purchases.
331    */
332   function _forwardFunds() internal {
333     wallet.transfer(msg.value);
334   }
335 }
336 
337 contract StandardToken is ERC20, BasicToken {
338 
339   mapping (address => mapping (address => uint256)) internal allowed;
340 
341 
342   /**
343    * @dev Transfer tokens from one address to another
344    * @param _from address The address which you want to send tokens from
345    * @param _to address The address which you want to transfer to
346    * @param _value uint256 the amount of tokens to be transferred
347    */
348   function transferFrom(
349     address _from,
350     address _to,
351     uint256 _value
352   )
353     public
354     returns (bool)
355   {
356     require(_value <= balances[_from]);
357     require(_value <= allowed[_from][msg.sender]);
358     require(_to != address(0));
359 
360     balances[_from] = balances[_from].sub(_value);
361     balances[_to] = balances[_to].add(_value);
362     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
363     emit Transfer(_from, _to, _value);
364     return true;
365   }
366 
367   /**
368    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
369    * Beware that changing an allowance with this method brings the risk that someone may use both the old
370    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
371    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
372    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
373    * @param _spender The address which will spend the funds.
374    * @param _value The amount of tokens to be spent.
375    */
376   function approve(address _spender, uint256 _value) public returns (bool) {
377     allowed[msg.sender][_spender] = _value;
378     emit Approval(msg.sender, _spender, _value);
379     return true;
380   }
381 
382   /**
383    * @dev Function to check the amount of tokens that an owner allowed to a spender.
384    * @param _owner address The address which owns the funds.
385    * @param _spender address The address which will spend the funds.
386    * @return A uint256 specifying the amount of tokens still available for the spender.
387    */
388   function allowance(
389     address _owner,
390     address _spender
391    )
392     public
393     view
394     returns (uint256)
395   {
396     return allowed[_owner][_spender];
397   }
398 
399   /**
400    * @dev Increase the amount of tokens that an owner allowed to a spender.
401    * approve should be called when allowed[_spender] == 0. To increment
402    * allowed value is better to use this function to avoid 2 calls (and wait until
403    * the first transaction is mined)
404    * From MonolithDAO Token.sol
405    * @param _spender The address which will spend the funds.
406    * @param _addedValue The amount of tokens to increase the allowance by.
407    */
408   function increaseApproval(
409     address _spender,
410     uint256 _addedValue
411   )
412     public
413     returns (bool)
414   {
415     allowed[msg.sender][_spender] = (
416       allowed[msg.sender][_spender].add(_addedValue));
417     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
418     return true;
419   }
420 
421   /**
422    * @dev Decrease the amount of tokens that an owner allowed to a spender.
423    * approve should be called when allowed[_spender] == 0. To decrement
424    * allowed value is better to use this function to avoid 2 calls (and wait until
425    * the first transaction is mined)
426    * From MonolithDAO Token.sol
427    * @param _spender The address which will spend the funds.
428    * @param _subtractedValue The amount of tokens to decrease the allowance by.
429    */
430   function decreaseApproval(
431     address _spender,
432     uint256 _subtractedValue
433   )
434     public
435     returns (bool)
436   {
437     uint256 oldValue = allowed[msg.sender][_spender];
438     if (_subtractedValue >= oldValue) {
439       allowed[msg.sender][_spender] = 0;
440     } else {
441       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
442     }
443     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
444     return true;
445   }
446 
447 }
448 
449 contract CappedCrowdsale is Crowdsale {
450   using SafeMath for uint256;
451 
452   uint256 public cap;
453 
454   /**
455    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
456    * @param _cap Max amount of wei to be contributed
457    */
458   constructor(uint256 _cap) public {
459     require(_cap > 0);
460     cap = _cap;
461   }
462 
463   /**
464    * @dev Checks whether the cap has been reached.
465    * @return Whether the cap was reached
466    */
467   function capReached() public view returns (bool) {
468     return weiRaised >= cap;
469   }
470 
471   /**
472    * @dev Extend parent behavior requiring purchase to respect the funding cap.
473    * @param _beneficiary Token purchaser
474    * @param _weiAmount Amount of wei contributed
475    */
476   function _preValidatePurchase(
477     address _beneficiary,
478     uint256 _weiAmount
479   )
480     internal
481   {
482     super._preValidatePurchase(_beneficiary, _weiAmount);
483     require(weiRaised.add(_weiAmount) <= cap);
484   }
485 
486 }
487 
488 contract SANDER1 is StandardToken, DetailedERC20 {
489 
490     /**
491     * 12 tokens equal 12 songs equal 1 album
492     * uint256 supply
493     */
494     uint256 internal supply = 12 * 1 ether;
495 
496     constructor () 
497         public 
498         DetailedERC20 (
499             "Super Ander Token 1",
500             "SANDER1", 
501             18
502         ) 
503     {
504         totalSupply_ = supply;
505         balances[msg.sender] = supply;
506         emit Transfer(0x0, msg.sender, totalSupply_);
507     }
508 }
509 contract SuperCrowdsale is CappedCrowdsale {
510     
511     using SafeERC20 for SANDER1;
512 
513     modifier onlyOwner {
514         require(msg.sender == owner);
515         _;
516     }
517 
518     address public owner;
519     SANDER1 public token;
520     uint256 internal weiAmount;
521 
522     event ProcessedRemainder(uint256 remainder);
523 
524     constructor (
525         SANDER1 _token, // sander1.superander.eth
526         address _wallet // wallet.superander.eth
527     ) public 
528         Crowdsale(
529             _wallet,
530             _token
531         ) 
532         CappedCrowdsale(
533             4145880000000000000000 // 4145.88 ETH
534         ) 
535     {
536         owner = msg.sender;
537         token = _token;
538     }
539 
540     /**
541    * @dev low level token purchase ***DO NOT OVERRIDE***
542    * @param _beneficiary Address performing the token purchase
543    */
544     function buyTokens(address _beneficiary) public payable {
545         weiAmount = msg.value;
546         // if wei raised equals total cap, stop the crowdsale.
547         _preValidatePurchase(_beneficiary, weiAmount);
548         uint256 tokens = getTokenAmount(weiAmount);
549         _processPurchase(_beneficiary, tokens);
550         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
551         _updatePurchasingState(_beneficiary, weiAmount);
552         _forwardFunds();
553         weiRaised = weiRaised.add(weiAmount);
554         _postValidatePurchase(_beneficiary, weiAmount);
555         weiAmount = 0;
556     }
557 
558     /**
559     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
560     * @param _beneficiary Address performing the token purchase
561     * @param _tokenAmount Number of tokens to be emitted
562     */
563     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
564         token.safeTransferFrom(owner, _beneficiary, _tokenAmount);
565     }
566 
567     /**
568        * @dev Override to extend the way in which ether is converted to tokens.
569        * @param _weiAmount Value in wei to be converted into tokens
570        * @return Number of tokens that can be purchased with the specified _weiAmount
571    */
572     function getTokenAmount(uint256 _weiAmount) public view returns (uint256) {
573         return _weiAmount.mul(token.allowance(owner, address(this))).div(cap);
574     }
575 }