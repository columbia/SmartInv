1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22    * @dev Multiplies two numbers, throws on overflow.
23    */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34    * @dev Integer division of two numbers, truncating the quotient.
35    */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45    */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52    * @dev Adds two numbers, throws on overflow.
53    */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 
62 /**
63  * @title Crowdsale
64  * @dev Crowdsale is a base contract for managing a token crowdsale,
65  * allowing investors to purchase tokens with ether.
66  * The external interface represents the basic interface for purchasing tokens, and conform
67  * the base architecture for crowdsales. 
68  *
69  * Presales:
70  * Certain addresses are allowed to buy at a presale rate during the presale period. The
71  * contribution of the investor needs to be of at least 5 ETH. A maximum of 15 million tokens
72  * in total can be bought at the presale rate. Once the presale has been instructed to end, it
73  * is not possible to enable it again.
74  *
75  * Sales:
76  * Any address can purchase at the regular sale price. Sales can be pauses, resumed, and stopped.
77  *
78  * Minting:
79  * The transferTokens function will mint the tokens in the Token contract. After the minting 
80  * is done, the Crowdsale is reset.
81  * 
82  * Refunds:
83  * A investor can be refunded by the owner. Calling the refund function resets the tokens bought
84  * to zero for that investor. The Ether refund needs to be processed manually. It is important
85  * to record how many tokens the investor had bought before calling refund().
86  *
87 */
88 contract Crowdsale {
89   using SafeMath for uint256;
90 
91   // The token being sold
92   StandardToken public token;
93 
94   // How many token units a buyer gets per wei
95   uint256 public rate;
96 
97   // How many token units a buyer gets per wei if entitled to the presale
98   uint public presaleRate;
99 
100   // Amount of wei raised
101   uint256 public weiRaised;
102 
103   // Administrator of the sale
104   address public owner;
105 
106   // How many tokens each address bought at the normal rate
107   mapping (address => uint) public regularTokensSold;
108 
109   // How many tokens each address bought at the presale rate
110   mapping (address => uint) public presaleTokensSold;
111 
112   // List of all the investors
113   address[] public investors;
114 
115   // Whether the sale is active
116   bool public inSale = true;
117 
118   // Whether the presale is active
119   bool public inPresale = true;
120 
121   // How many tokens each address can buy at the presale rate
122   mapping (address => uint) public presaleAllocations;
123 
124   // The total number of tokens bought
125   uint256 public totalPresaleTokensSold = 0;
126 
127   // The total number of tokens bought
128   uint256 public totalRegularTokensSold = 0;
129 
130   // The maximum number of tokens which can be sold during presale
131   uint256 constant public PRESALETOKENMAXSALES = 15000000000000000000000000;
132 
133   // The maximum number of tokens which can be sold during regular sale
134   uint256 public regularTokenMaxSales = 16000000000000000000000000;
135 
136   // The minimum investment (5 ETH) during presale
137   uint256 constant public MINIMUMINVESTMENTPRESALE = 5000000000000000000;
138 
139   // The minimum investment (5 ETH) during sale
140   uint256 constant public MINIMUMINVESTMENTSALE = 1000000000000000000;
141 
142   modifier onlyOwner() {
143     require(msg.sender == owner);
144     _;
145   }
146 
147   modifier onlyDuringPresale() {
148     require(inPresale);
149     _;
150   }
151 
152   modifier onlyWhenSalesEnabled() {
153     require(inSale);
154     _;
155   }
156 
157   /**
158    * Event for token purchase logging
159    * @param purchaser who paid for the tokens
160    * @param beneficiary who got the tokens
161    * @param value weis paid for purchase
162    * @param amount amount of tokens purchased
163    * @param rate the rate at which the tokens were purchased
164    */
165   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount, uint256 rate);
166 
167   /**
168    * Constructor for the crowdsale
169    * @param _owner owner of the contract, which can call privileged functions, and where every ether
170    *        is sent to
171    * @param _rate the rate for regular sales
172    * @param _rate the rate for presales
173    * @param _ownerInitialTokens the number of tokens the owner is allocated initially
174    */
175   function Crowdsale(
176     address _owner, 
177     uint256 _rate, 
178     uint256 _presaleRate, 
179     uint256 _ownerInitialTokens
180   ) public payable {
181     require(_rate > 0);
182     require(_presaleRate > 0);
183     require(_owner != address(0));
184 
185     rate = _rate;
186     presaleRate = _presaleRate;
187     owner = _owner;
188 
189     investors.push(owner);
190     regularTokensSold[owner] = _ownerInitialTokens;
191   }
192 
193   // -----------------------------------------
194   // Crowdsale external interface
195   // -----------------------------------------
196 
197   function () external payable {
198     buyTokens();
199   }
200 
201   /**
202    * Sets the address of the Token contract.
203    */
204   function setToken(StandardToken _token) public onlyOwner {
205     token = _token;
206   }
207 
208   /**
209    * Buy a token at presale price. Converts ETH to as much QNT the sender can purchase. Any change
210    * is refunded to the sender. Minimum contribution is 5 ETH.
211    */
212   function buyPresaleTokens() onlyDuringPresale onlyWhenSalesEnabled public payable {
213     address _beneficiary = msg.sender;
214     uint256 weiAmount = msg.value;
215 
216     _preValidatePurchase(_beneficiary);
217     require(weiAmount >= MINIMUMINVESTMENTPRESALE);
218 
219     uint256 presaleAllocation = presaleAllocations[_beneficiary];
220 
221     uint256 presaleTokens = _min256(weiAmount.mul(presaleRate), presaleAllocation);
222 
223     _recordPresalePurchase(_beneficiary, presaleTokens);
224 
225     // Remove presale tokens allocation
226     presaleAllocations[_beneficiary] = presaleAllocations[_beneficiary].sub(presaleTokens);
227 
228     uint256 weiCharged = presaleTokens.div(presaleRate);
229 
230     // Return any extra Wei to the sender
231     uint256 change = weiAmount.sub(weiCharged);
232     _beneficiary.transfer(change);
233 
234     // Update total number of Wei raised
235     weiRaised = weiRaised.add(weiAmount.sub(change));
236 
237     emit TokenPurchase(msg.sender, _beneficiary, weiCharged, presaleTokens, presaleRate);
238 
239     // Forward the funds to owner
240     _forwardFunds(weiCharged);
241   }
242 
243   /**
244    * Buy a token at sale price. Minimum contribution is 1 ETH.
245    */
246   function buyTokens() onlyWhenSalesEnabled public payable {
247     address _beneficiary = msg.sender;
248     uint256 weiAmount = msg.value;
249     _preValidatePurchase(_beneficiary);
250 
251     require(weiAmount >= MINIMUMINVESTMENTSALE);
252 
253     uint256 tokens = weiAmount.mul(rate);
254 
255     // Check we haven't sold too many tokens
256     totalRegularTokensSold = totalRegularTokensSold.add(tokens);
257     require(totalRegularTokensSold <= regularTokenMaxSales);
258 
259     // Update total number of Wei raised
260     weiRaised = weiRaised.add(weiAmount);
261 
262     investors.push(_beneficiary);
263 
264     // Give tokens
265     regularTokensSold[_beneficiary] = regularTokensSold[_beneficiary].add(tokens);
266 
267     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens, rate);
268 
269     // Forward the funds to owner
270     _forwardFunds(weiAmount);
271   }
272 
273   /**
274    * Records a purchase which has been completed before the instantiation of this contract.
275    * @param _beneficiary the investor
276    * @param _presaleTokens the number of tokens which the investor has bought
277    */
278   function recordPresalePurchase(address _beneficiary, uint256 _presaleTokens) public onlyOwner {
279     weiRaised = weiRaised.add(_presaleTokens.div(presaleRate));
280     return _recordPresalePurchase(_beneficiary, _presaleTokens);
281   }
282 
283   function enableSale() onlyOwner public {
284     inSale = true;
285   }
286 
287   function disableSale() onlyOwner public {
288     inSale = false;
289   }
290 
291   function endPresale() onlyOwner public {
292     inPresale = false;
293 
294     // Convert the unsold presale tokens to regular tokens
295     uint256 remainingPresaleTokens = PRESALETOKENMAXSALES.sub(totalPresaleTokensSold);
296     regularTokenMaxSales = regularTokenMaxSales.add(remainingPresaleTokens);
297   }
298 
299   /**
300    * Mints the tokens in the Token contract.
301    */
302   function transferTokens() public onlyOwner {
303     for (uint256 i = 0; i < investors.length; i = i.add(1)) {
304       address investor = investors[i];
305 
306       uint256 tokens = regularTokensSold[investor];
307       uint256 presaleTokens = presaleTokensSold[investor];
308       
309       regularTokensSold[investor] = 0;
310       presaleTokensSold[investor] = 0;
311 
312       if (tokens > 0) {
313         _deliverTokens(token, investor, tokens);
314       }
315 
316       if (presaleTokens > 0) {
317         _deliverTokens(token, investor, presaleTokens);
318       }
319     }
320   }
321 
322   /**
323    * Mints the tokens in the Token contract. With Offset and Limit
324    */
325   function transferTokensWithOffsetAndLimit(uint256 offset, uint256 limit) public onlyOwner {
326     for (uint256 i = offset; i <  _min256(investors.length,offset+limit); i = i.add(1)) {
327       address investor = investors[i];
328 
329       uint256 tokens = regularTokensSold[investor];
330       uint256 presaleTokens = presaleTokensSold[investor];
331 
332       regularTokensSold[investor] = 0;
333       presaleTokensSold[investor] = 0;
334 
335       if (tokens > 0) {
336         _deliverTokens(token, investor, tokens);
337       }
338 
339       if (presaleTokens > 0) {
340         _deliverTokens(token, investor, presaleTokens);
341       }
342     }
343   }
344 
345 
346   /**
347    * Clears the number of tokens bought by an investor. The ETH refund needs to be processed
348    * manually.
349    */
350   function refund(address investor) onlyOwner public {
351     require(investor != owner);
352 
353     uint256 regularTokens = regularTokensSold[investor];
354     totalRegularTokensSold = totalRegularTokensSold.sub(regularTokens);
355     weiRaised = weiRaised.sub(regularTokens.div(rate));
356 
357     uint256 presaleTokens = presaleTokensSold[investor];
358     totalPresaleTokensSold = totalPresaleTokensSold.sub(presaleTokens);
359     weiRaised = weiRaised.sub(presaleTokens.div(presaleRate));
360 
361     regularTokensSold[investor] = 0;
362     presaleTokensSold[investor] = 0;
363 
364     // Manually send ether to the account
365   }
366 
367   /**
368   * Accessor for Index
369   */
370   function getInvestorAtIndex(uint256 _index) public view returns(address) {
371     return investors[_index];
372   }
373 
374   /**
375   * Return the length of the investors array
376   */
377   function getInvestorsLength() public view returns(uint256) {
378     return investors.length;
379   }
380 
381   /**
382    * Get the number of tokens bought at the regular price for an address.
383    */
384   function getNumRegularTokensBought(address _address) public view returns(uint256) {
385     return regularTokensSold[_address];
386   }
387 
388   /**
389    * Get the number of tokens bought at the presale price for an address.
390    */
391   function getNumPresaleTokensBought(address _address) public view returns(uint256) {
392     return presaleTokensSold[_address];
393   }
394 
395   /**
396    * Get the number of tokens which an investor can purchase at presale rate.
397    */
398   function getPresaleAllocation(address investor) view public returns(uint256) {
399     return presaleAllocations[investor];
400   }
401 
402   /**
403    * Set the number of tokens which an investor can purchase at presale rate.
404    */
405   function setPresaleAllocation(address investor, uint allocation) onlyOwner public {
406     presaleAllocations[investor] = allocation;
407   }
408 
409   // -----------------------------------------
410   // Internal interface (extensible)
411   // -----------------------------------------
412 
413   /**
414    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
415    * @param _beneficiary Address performing the token purchase
416    */
417   function _preValidatePurchase(address _beneficiary) internal pure {
418     require(_beneficiary != address(0));
419   }
420 
421   /**
422    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
423    * @param _beneficiary Address performing the token purchase
424    * @param _tokenAmount Number of tokens to be emitted
425    */
426   function _deliverTokens(StandardToken _token, address _beneficiary, uint256 _tokenAmount) internal {
427     _token.mint(_beneficiary, _tokenAmount);
428   }
429 
430   /**
431    * @dev Determines how ETH is stored/forwarded on purchases.
432    */
433   function _forwardFunds(uint256 amount) internal {
434     owner.transfer(amount);
435   }
436 
437   function _min256(uint256 a, uint256 b) internal pure returns (uint256) {
438     return a < b ? a : b;
439   }
440 
441   /**
442    * Records a presale purchase.
443    * @param _beneficiary the investor
444    * @param _presaleTokens the number of tokens which the investor has bought
445    */
446   function _recordPresalePurchase(address _beneficiary, uint256 _presaleTokens) internal {
447     // Check we haven't sold too many presale tokens
448     totalPresaleTokensSold = totalPresaleTokensSold.add(_presaleTokens);
449     require(totalPresaleTokensSold <= PRESALETOKENMAXSALES);
450 
451     investors.push(_beneficiary);
452 
453     // Give presale tokens
454     presaleTokensSold[_beneficiary] = presaleTokensSold[_beneficiary].add(_presaleTokens);
455   }
456 }
457 
458 /**
459  * @title Basic token
460  * @dev Basic version of StandardToken, with no allowances.
461  */
462 contract BasicToken is ERC20Basic {
463   using SafeMath for uint256;
464 
465   mapping(address => uint256) balances;
466 
467   uint256 totalSupply_ = 45467000000000000000000000;
468 
469   /**
470   * @dev total number of tokens in existence
471   */
472   function totalSupply() public view returns (uint256) {
473     return totalSupply_;
474   }
475 
476   /**
477   * @dev transfer token for a specified address
478   * @param _to The address to transfer to.
479   * @param _value The amount to be transferred.
480   */
481   function transfer(address _to, uint256 _value) public returns (bool) {
482     require(_to != address(0));
483     require(_value <= balances[msg.sender]);
484 
485     // SafeMath.sub will throw if there is not enough balance.
486     balances[msg.sender] = balances[msg.sender].sub(_value);
487     balances[_to] = balances[_to].add(_value);
488     emit Transfer(msg.sender, _to, _value);
489     return true;
490   }
491 
492   /**
493   * @dev Gets the balance of the specified address.
494   * @param _owner The address to query the the balance of.
495   * @return An uint256 representing the amount owned by the passed address.
496   */
497   function balanceOf(address _owner) public view returns (uint256 balance) {
498     return balances[_owner];
499   }
500 
501 }
502 
503 /**
504  * @title ERC20 interface
505  * @dev see https://github.com/ethereum/EIPs/issues/20
506  */
507 contract ERC20 is ERC20Basic {
508   function allowance(address owner, address spender) public view returns (uint256);
509   function transferFrom(address from, address to, uint256 value) public returns (bool);
510   function approve(address spender, uint256 value) public returns (bool);
511   event Approval(address indexed owner, address indexed spender, uint256 value);
512 }
513 
514 /**
515  * @title Standard ERC20 token
516  *
517  * @dev Implementation of the basic standard token.
518  * @dev https://github.com/ethereum/EIPs/issues/20
519  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
520  */
521 contract StandardToken is ERC20, BasicToken {
522 
523   // Name of the token
524   string constant public name = "Quant";
525   // Token abbreviation
526   string constant public symbol = "QNT";
527   // Decimal places
528   uint8 constant public decimals = 18;
529   // Zeros after the point
530   uint256 constant public DECIMAL_ZEROS = 1000000000000000000;
531 
532   mapping (address => mapping (address => uint256)) internal allowed;
533 
534   address public crowdsale;
535 
536   modifier onlyCrowdsale() {
537     require(msg.sender == crowdsale);
538     _;
539   }
540 
541   function StandardToken(address _crowdsale) public {
542     require(_crowdsale != address(0));
543     crowdsale = _crowdsale;
544   }
545 
546   function mint(address _address, uint256 _value) public onlyCrowdsale {
547     balances[_address] = balances[_address].add(_value);
548     emit Transfer(0, _address, _value);
549   }
550 
551   /**
552    * @dev Transfer tokens from one address to another
553    * @param _from address The address which you want to send tokens from
554    * @param _to address The address which you want to transfer to
555    * @param _value uint256 the amount of tokens to be transferred
556    */
557   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
558     require(_to != address(0));
559     require(_value <= balances[_from]);
560     require(_value <= allowed[_from][msg.sender]);
561 
562     balances[_from] = balances[_from].sub(_value);
563     balances[_to] = balances[_to].add(_value);
564     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
565     emit Transfer(_from, _to, _value);
566     return true;
567   }
568 
569   /**
570    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
571    *
572    * Beware that changing an allowance with this method brings the risk that someone may use both the old
573    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
574    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
575    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
576    * @param _spender The address which will spend the funds.
577    * @param _value The amount of tokens to be spent.
578    */
579   function approve(address _spender, uint256 _value) public returns (bool) {
580     allowed[msg.sender][_spender] = _value;
581     emit Approval(msg.sender, _spender, _value);
582     return true;
583   }
584 
585   /**
586    * @dev Function to check the amount of tokens that an owner allowed to a spender.
587    * @param _owner address The address which owns the funds.
588    * @param _spender address The address which will spend the funds.
589    * @return A uint256 specifying the amount of tokens still available for the spender.
590    */
591   function allowance(address _owner, address _spender) public view returns (uint256) {
592     return allowed[_owner][_spender];
593   }
594 
595   /**
596    * @dev Increase the amount of tokens that an owner allowed to a spender.
597    *
598    * approve should be called when allowed[_spender] == 0. To increment
599    * allowed value is better to use this function to avoid 2 calls (and wait until
600    * the first transaction is mined)
601    * From MonolithDAO Token.sol
602    * @param _spender The address which will spend the funds.
603    * @param _addedValue The amount of tokens to increase the allowance by.
604    */
605   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
606     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
607     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
608     return true;
609   }
610 
611   /**
612    * @dev Decrease the amount of tokens that an owner allowed to a spender.
613    *
614    * approve should be called when allowed[_spender] == 0. To decrement
615    * allowed value is better to use this function to avoid 2 calls (and wait until
616    * the first transaction is mined)
617    * From MonolithDAO Token.sol
618    * @param _spender The address which will spend the funds.
619    * @param _subtractedValue The amount of tokens to decrease the allowance by.
620    */
621   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
622     uint oldValue = allowed[msg.sender][_spender];
623     if (_subtractedValue > oldValue) {
624       allowed[msg.sender][_spender] = 0;
625     } else {
626       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
627     }
628     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
629     return true;
630   }
631 
632 }