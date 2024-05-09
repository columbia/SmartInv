1 pragma solidity ^0.4.17;
2 
3 // File: contracts/helpers/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16   * @dev The Constructor sets the original owner of the contract to the
17   * sender account.
18   */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24   * @dev Throws if called by any other account other than owner.
25   */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 // File: contracts/helpers/SafeMath.sol
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 
90 }
91 
92 // File: contracts/token/ERC20Interface.sol
93 
94 contract ERC20Interface {
95 
96   event Transfer(address indexed from, address indexed to, uint256 value);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102 
103   function approve(address spender, uint256 value) public returns (bool);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function allowance(address owner, address spender) public view returns (uint256);
106 
107 }
108 
109 // File: contracts/token/BaseToken.sol
110 
111 contract BaseToken is ERC20Interface {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115   mapping (address => mapping (address => uint256)) internal allowed;
116 
117   uint256 totalSupply_;
118 
119   /**
120   * @dev Obtain total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135   /**
136   * @dev Transfer token for a specified address
137   * @param _to The address to transfer to.
138   * @param _value The amount to be transferred.
139   */
140   function transfer(address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[msg.sender]);
143 
144     // SafeMath.sub will throw if there is not enough balance
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     Transfer(msg.sender, _to, _value);
148 
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     require(_spender != address(0));
164 
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167 
168     return true;
169   }
170 
171   /**
172    * @dev Transfer tokens from one address to another
173    * @param _from address The address which you want to send tokens from
174    * @param _to address The address which you want to transfer to
175    * @param _value uint256 the amount of tokens to be transferred
176    */
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
178     require(_to != address(0));
179     require(_value <= balances[_from]);
180     require(_value <= allowed[_from][msg.sender]);
181 
182     balances[_from] = balances[_from].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185 
186     Transfer(_from, _to, _value);
187 
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public view returns (uint256) {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    *
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    * @param _spender The address which will spend the funds.
209    * @param _addedValue The amount of tokens to increase the allowance by.
210    */
211   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
212     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
213     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214 
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
229     uint oldValue = allowed[msg.sender][_spender];
230     if (_subtractedValue > oldValue) {
231       allowed[msg.sender][_spender] = 0;
232     } else {
233       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
234     }
235     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239 }
240 
241 // File: contracts/token/MintableToken.sol
242 
243 /**
244  * @title Mintable token
245  * @dev Simple ERC20 Token example, with mintable token creation
246  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
247  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
248  */
249 contract MintableToken is BaseToken, Ownable {
250 
251   event Mint(address indexed to, uint256 amount);
252   event MintFinished();
253 
254   bool public mintingFinished = false;
255 
256   modifier canMint() {
257     require(!mintingFinished);
258     _;
259   }
260 
261   /**
262    * @dev Function to mint tokens
263    * @param _to The address that will receive the minted tokens.
264    * @param _amount The amount of tokens to mint.
265    * @return A boolean that indicates if the operation was successful.
266    */
267   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
268     require(_to != address(0));
269 
270     totalSupply_ = totalSupply_.add(_amount);
271     balances[_to] = balances[_to].add(_amount);
272     Mint(_to, _amount);
273     Transfer(address(0), _to, _amount);
274     return true;
275   }
276 
277   /**
278    * @dev Function to stop minting new tokens.
279    * @return True if the operation was successful.
280    */
281   function finishMinting() onlyOwner canMint public returns (bool) {
282     mintingFinished = true;
283     MintFinished();
284     return true;
285   }
286 
287 }
288 
289 // File: contracts/token/CappedToken.sol
290 
291 contract CappedToken is MintableToken {
292 
293   uint256 public cap;
294 
295   function CappedToken(uint256 _cap) public {
296     require(_cap > 0);
297     cap = _cap;
298   }
299 
300   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
301     require(totalSupply_.add(_amount) <= cap);
302 
303     return super.mint(_to, _amount);
304   }
305 
306 }
307 
308 // File: contracts/helpers/Pausable.sol
309 
310 /**
311  * @title Pausable
312  * @dev Base contract which allows children to implement an emergency stop mechanism.
313  */
314 contract Pausable is Ownable {
315   event Pause();
316   event Unpause();
317 
318   bool public paused = false;
319 
320   /**
321    * @dev Modifier to make a function callable only when the contract is not paused.
322    */
323   modifier whenNotPaused() {
324     require(!paused);
325     _;
326   }
327 
328   /**
329    * @dev Modifier to make a function callable only when the contract is paused.
330    */
331   modifier whenPaused() {
332     require(paused);
333     _;
334   }
335 
336   /**
337    * @dev called by the owner to pause, triggers stopped state
338    */
339   function pause() onlyOwner whenNotPaused public {
340     paused = true;
341     Pause();
342   }
343 
344   /**
345    * @dev called by the owner to unpause, returns to normal state
346    */
347   function unpause() onlyOwner whenPaused public {
348     paused = false;
349     Unpause();
350   }
351 
352 }
353 
354 // File: contracts/token/PausableToken.sol
355 
356 /**
357  * @title Pausable token
358  * @dev BaseToken modified with pausable transfers.
359  **/
360 contract PausableToken is BaseToken, Pausable {
361 
362   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
363     return super.transfer(_to, _value);
364   }
365 
366   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
367     return super.transferFrom(_from, _to, _value);
368   }
369 
370   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
371     return super.approve(_spender, _value);
372   }
373 
374   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
375     return super.increaseApproval(_spender, _addedValue);
376   }
377 
378   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
379     return super.decreaseApproval(_spender, _subtractedValue);
380   }
381 }
382 
383 // File: contracts/token/SignedTransferToken.sol
384 
385 /**
386 * @title SignedTransferToken
387 * @dev The SignedTransferToken enables collection of fees for token transfers
388 * in native token currency. User will provide a signature that allows the third
389 * party to settle the transaction in his name and collect fee for provided
390 * serivce.
391 */
392 contract SignedTransferToken is BaseToken {
393 
394   event TransferPreSigned(
395     address indexed from,
396     address indexed to,
397     address indexed settler,
398     uint256 value,
399     uint256 fee
400   );
401 
402   event TransferPreSignedMany(
403     address indexed from,
404     address indexed settler,
405     uint256 value,
406     uint256 fee
407   );
408 
409 
410   // Mapping of already executed settlements for a given address
411   mapping(address => mapping(bytes32 => bool)) executedSettlements;
412 
413   /**
414   * @dev Will settle a pre-signed transfer
415   */
416   function transferPreSigned(address _from,
417                              address _to,
418                              uint256 _value,
419                              uint256 _fee,
420                              uint256 _nonce,
421                              uint8 _v,
422                              bytes32 _r,
423                              bytes32 _s) public returns (bool) {
424     uint256 total = _value.add(_fee);
425     bytes32 calcHash = calculateHash(_from, _to, _value, _fee, _nonce);
426 
427     require(_to != address(0));
428     require(isValidSignature(_from, calcHash, _v, _r, _s));
429     require(balances[_from] >= total);
430     require(!executedSettlements[_from][calcHash]);
431 
432     executedSettlements[_from][calcHash] = true;
433 
434     // Move tokens
435     balances[_from] = balances[_from].sub(_value);
436     balances[_to] = balances[_to].add(_value);
437     Transfer(_from, _to, _value);
438 
439     // Move fee
440     balances[_from] = balances[_from].sub(_fee);
441     balances[msg.sender] = balances[msg.sender].add(_fee);
442     Transfer(_from, msg.sender, _fee);
443 
444     TransferPreSigned(_from, _to, msg.sender, _value, _fee);
445 
446     return true;
447   }
448 
449   /**
450   * @dev Settle multiple transactions in a single call. Please note that
451   * should a single one fail the full state will be reverted. Your client
452   * implementation should always first check for balances, correct signatures
453   * and any other conditions that might result in failed transaction.
454   */
455   function transferPreSignedBulk(address[] _from,
456                                  address[] _to,
457                                  uint256[] _values,
458                                  uint256[] _fees,
459                                  uint256[] _nonces,
460                                  uint8[] _v,
461                                  bytes32[] _r,
462                                  bytes32[] _s) public returns (bool) {
463     // Make sure all the arrays are of the same length
464     require(_from.length == _to.length &&
465             _to.length ==_values.length &&
466             _values.length == _fees.length &&
467             _fees.length == _nonces.length &&
468             _nonces.length == _v.length &&
469             _v.length == _r.length &&
470             _r.length == _s.length);
471 
472     for(uint i; i < _from.length; i++) {
473       transferPreSigned(_from[i],
474                         _to[i],
475                         _values[i],
476                         _fees[i],
477                         _nonces[i],
478                         _v[i],
479                         _r[i],
480                         _s[i]);
481     }
482 
483     return true;
484   }
485 
486 
487   function transferPreSignedMany(address _from,
488                                  address[] _tos,
489                                  uint256[] _values,
490                                  uint256 _fee,
491                                  uint256 _nonce,
492                                  uint8 _v,
493                                  bytes32 _r,
494                                  bytes32 _s) public returns (bool) {
495    require(_tos.length == _values.length);
496    uint256 total = getTotal(_tos, _values, _fee);
497 
498    bytes32 calcHash = calculateManyHash(_from, _tos, _values, _fee, _nonce);
499 
500    require(isValidSignature(_from, calcHash, _v, _r, _s));
501    require(balances[_from] >= total);
502    require(!executedSettlements[_from][calcHash]);
503 
504    executedSettlements[_from][calcHash] = true;
505 
506    // transfer to each recipient and take fee at the end
507    for(uint i; i < _tos.length; i++) {
508      // Move tokens
509      balances[_from] = balances[_from].sub(_values[i]);
510      balances[_tos[i]] = balances[_tos[i]].add(_values[i]);
511      Transfer(_from, _tos[i], _values[i]);
512    }
513 
514    // Move fee
515    balances[_from] = balances[_from].sub(_fee);
516    balances[msg.sender] = balances[msg.sender].add(_fee);
517    Transfer(_from, msg.sender, _fee);
518 
519    TransferPreSignedMany(_from, msg.sender, total, _fee);
520 
521    return true;
522   }
523 
524   function getTotal(address[] _tos, uint256[] _values, uint256 _fee) private view returns (uint256)  {
525     uint256 total = _fee;
526 
527     for(uint i; i < _tos.length; i++) {
528       total = total.add(_values[i]); // sum of all the values + fee
529       require(_tos[i] != address(0)); // check that the recipient is a valid address
530     }
531 
532     return total;
533   }
534 
535   /**
536   * @dev Calculates transfer hash for transferPreSignedMany
537   */
538   function calculateManyHash(address _from, address[] _tos, uint256[] _values, uint256 _fee, uint256 _nonce) public view returns (bytes32) {
539     return keccak256(uint256(1), address(this), _from, _tos, _values, _fee, _nonce);
540   }
541 
542   /**
543   * @dev Calculates transfer hash.
544   */
545   function calculateHash(address _from, address _to, uint256 _value, uint256 _fee, uint256 _nonce) public view returns (bytes32) {
546     return keccak256(uint256(0), address(this), _from, _to, _value, _fee, _nonce);
547   }
548 
549   /**
550   * @dev Validates the signature
551   */
552   function isValidSignature(address _signer, bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (bool) {
553     return _signer == ecrecover(
554             keccak256("\x19Ethereum Signed Message:\n32", _hash),
555             _v,
556             _r,
557             _s
558         );
559   }
560 
561   /**
562   * @dev Allows you to check whether a certain transaction has been already
563   * settled or not.
564   */
565   function isTransactionAlreadySettled(address _from, bytes32 _calcHash) public view returns (bool) {
566     return executedSettlements[_from][_calcHash];
567   }
568 
569 }
570 
571 // File: contracts/token/PausableSignedTransferToken.sol
572 
573 contract PausableSignedTransferToken is SignedTransferToken, PausableToken {
574 
575   function transferPreSigned(address _from,
576                              address _to,
577                              uint256 _value,
578                              uint256 _fee,
579                              uint256 _nonce,
580                              uint8 _v,
581                              bytes32 _r,
582                              bytes32 _s) public whenNotPaused returns (bool) {
583     return super.transferPreSigned(_from, _to, _value, _fee, _nonce, _v, _r, _s);
584   }
585 
586   function transferPreSignedBulk(address[] _from,
587                                  address[] _to,
588                                  uint256[] _values,
589                                  uint256[] _fees,
590                                  uint256[] _nonces,
591                                  uint8[] _v,
592                                  bytes32[] _r,
593                                  bytes32[] _s) public whenNotPaused returns (bool) {
594     return super.transferPreSignedBulk(_from, _to, _values, _fees, _nonces, _v, _r, _s);
595   }
596 
597   function transferPreSignedMany(address _from,
598                                  address[] _tos,
599                                  uint256[] _values,
600                                  uint256 _fee,
601                                  uint256 _nonce,
602                                  uint8 _v,
603                                  bytes32 _r,
604                                  bytes32 _s) public whenNotPaused returns (bool) {
605     return super.transferPreSignedMany(_from, _tos, _values, _fee, _nonce, _v, _r, _s);
606   }
607 }
608 
609 // File: contracts/FourToken.sol
610 
611 contract FourToken is CappedToken, PausableSignedTransferToken  {
612   string public name = 'The 4th Pillar Token';
613   string public symbol = 'FOUR';
614   uint256 public decimals = 18;
615 
616   // Max supply of 400 million
617   uint256 public maxSupply = 400000000 * 10**decimals;
618 
619   function FourToken()
620     CappedToken(maxSupply) public {
621       paused = true;
622   }
623 
624   // @dev Recover any mistakenly sent ERC20 tokens to the Token address
625   function recoverERC20Tokens(address _erc20, uint256 _amount) public onlyOwner {
626     ERC20Interface(_erc20).transfer(msg.sender, _amount);
627   }
628 
629 }
630 
631 // File: contracts/crowdsale/Crowdsale.sol
632 
633 /**
634  * @title Crowdsale
635  * @dev Crowdsale is a base contract for managing a token crowdsale.
636  * Crowdsales have a start and end timestamps, where investors can make
637  * token purchases and the crowdsale will assign them tokens based
638  * on a token per ETH rate. Funds collected are forwarded to a wallet
639  * as they arrive. The contract requires a MintableToken that will be
640  * minted as contributions arrive, note that the crowdsale contract
641  * must be owner of the token in order to be able to mint it.
642  */
643 contract Crowdsale {
644   using SafeMath for uint256;
645 
646   /**
647    * event for token purchase logging
648    * @param purchaser who paid for the tokens
649    * @param beneficiary who got the tokens
650    * @param value weis paid for purchase
651    * @param tokens amount of tokens purchased
652    */
653   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 tokens);
654 
655   // The token being sold
656   MintableToken public token;
657 
658   // start and end timestamps in UNIX.
659   uint256 public startTime;
660   uint256 public endTime;
661 
662   // how many tokens does a buyer get per wei
663   uint256 public rate;
664 
665   // wallet where funds are forwarded
666   address public wallet;
667 
668   // amount of raised money in wei
669   uint256 public weiRaised;
670   // amount of sold tokens
671   uint256 public tokensSold;
672 
673 
674   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token) public {
675     require(_startTime >= now);
676     require(_endTime >= _startTime);
677     require(_rate > 0);
678     require(_wallet != address(0));
679     require(_token != address(0));
680 
681     startTime = _startTime;
682     endTime = _endTime;
683     rate = _rate;
684     wallet = _wallet;
685     token = MintableToken(_token);
686   }
687 
688   // fallback function can be used to buy tokens
689   function () external payable {
690     buyTokens(msg.sender);
691   }
692 
693   // low level token purchase function
694   function buyTokens(address beneficiary) public payable {
695     require(beneficiary != address(0));
696     require(validPurchase());
697 
698     uint256 weiAmount = msg.value;
699 
700     // calculate token amount to be created
701     uint256 tokens = getTokenAmount(weiAmount);
702 
703     // update state
704     weiRaised = weiRaised.add(weiAmount);
705     tokensSold = tokensSold.add(tokens);
706 
707     token.mint(beneficiary, tokens);
708     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
709 
710     forwardFunds();
711   }
712 
713   // @return true if crowdsale event has ended
714   function hasEnded() public view returns (bool) {
715     return now > endTime;
716   }
717 
718   // Override this method to have a way to add business logic to your crowdsale when buying
719   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
720     return weiAmount.mul(rate);
721   }
722 
723   // send ether to the fund collection wallet
724   // override to create custom fund forwarding mechanisms
725   function forwardFunds() internal {
726     wallet.transfer(msg.value);
727   }
728 
729   // @return true if the transaction can buy tokens
730   function validPurchase() internal view returns (bool) {
731     bool withinPeriod = now >= startTime && now <= endTime;
732     bool nonZeroPurchase = msg.value != 0;
733     return withinPeriod && nonZeroPurchase;
734   }
735 
736 }
737 
738 // File: contracts/crowdsale/FinalizableCrowdsale.sol
739 
740 contract FinalizableCrowdsale is Crowdsale, Ownable {
741   using SafeMath for uint256;
742 
743   event Finalized();
744 
745   bool public isFinalized = false;
746 
747   /**
748    * @dev Must be called after crowdsale ends, to do some extra finalization
749    * work. Calls the contract's finalization function.
750    */
751   function finalize() onlyOwner public {
752     require(!isFinalized);
753     require(hasEnded());
754 
755     finalization();
756     Finalized();
757 
758     isFinalized = true;
759   }
760 
761   /**
762    * @dev Can be overridden to add finalization logic. The overriding function
763    * should call super.finalization() to ensure the chain of finalization is
764    * executed entirely.
765    */
766   function finalization() internal {
767   }
768 
769 }
770 
771 // File: contracts/crowdsale/TokenCappedCrowdsale.sol
772 
773 contract TokenCappedCrowdsale is Crowdsale {
774   using SafeMath for uint256;
775 
776   uint256 public tokenCap;
777 
778   function TokenCappedCrowdsale(uint256 _tokenCap) public {
779     require(_tokenCap > 0);
780     tokenCap = _tokenCap;
781   }
782 
783   function isCapReached() public view returns (bool) {
784     return tokensSold >= tokenCap;
785   }
786 
787   function hasEnded() public view returns (bool) {
788     return isCapReached() || super.hasEnded();
789   }
790 
791   // overriding Crowdsale#validPurchase to add extra cap logic
792   // @return true if investors can buy at the moment
793   function validPurchase() internal view returns (bool) {
794     bool withinCap = tokensSold.add(getTokenAmount(msg.value)) <= tokenCap;
795     return withinCap && super.validPurchase();
796   }
797 }
798 
799 // File: contracts/crowdsale/WhitelistCrowdsale.sol
800 
801 contract WhitelistCrowdsale is Crowdsale, Ownable {
802   using SafeMath for uint256;
803 
804   event WhitelistUpdated(uint256 timestamp, string operation, uint256 totalAddresses);
805 
806   // Mapping of whitelisted addresses
807   mapping(address => bool) whitelisted;
808 
809   // Total count of whitelisted participants
810   uint256 public whitelistedCount;
811 
812   function isWhitelisted(address _addr) public view returns (bool) {
813     return whitelisted[_addr];
814   }
815 
816   function addAddress(address _addr) external onlyOwner {
817     whitelisted[_addr] = true;
818     whitelistedCount++;
819     WhitelistUpdated(block.timestamp, "Added", whitelistedCount);
820   }
821 
822   function addAddresses(address[] _addrs) external onlyOwner {
823     for (uint256 i = 0; i < _addrs.length; i++) {
824       whitelisted[_addrs[i]] = true;
825       whitelistedCount++;
826     }
827 
828     WhitelistUpdated(block.timestamp, "Added", whitelistedCount);
829   }
830 
831   function removeAddress(address _addr) external onlyOwner {
832     whitelisted[_addr] = false;
833     whitelistedCount--;
834     WhitelistUpdated(block.timestamp, "Removed", whitelistedCount);
835   }
836 
837   function removeAddresses(address[] _addrs) external onlyOwner {
838     for (uint256 i = 0; i < _addrs.length; i++) {
839       whitelisted[_addrs[i]] = false;
840       whitelistedCount--;
841     }
842 
843     WhitelistUpdated(block.timestamp, "Removed", whitelistedCount);
844   }
845 
846   function validPurchase() internal view returns (bool) {
847     return isWhitelisted(msg.sender) && super.validPurchase();
848   }
849 
850 }
851 
852 // File: contracts/FourCrowdsale.sol
853 
854 contract FourCrowdsale is TokenCappedCrowdsale, WhitelistCrowdsale, FinalizableCrowdsale {
855   event RateChanged(uint256 newRate, string name);
856 
857   uint256 private constant E18 = 10**18;
858 
859   // Max tokens sold = 152 million
860   uint256 private TOKEN_SALE_CAP = 152000000 * E18;
861 
862   uint256 public constant TEAM_TOKENS = 50000000 * E18;
863   address public constant TEAM_ADDRESS = 0x3EC2fC20c04656F4B0AA7372258A36FAfB1EF427;
864 
865   // Vault tokens have been pre-minted
866 //  uint256 public constant VAULT_TOKENS = 152000000 * E18;
867 //  address public constant VAULT_ADDRESS = 0x545baa8e4Fff675711CB92Af33e5850aDD913b76;
868 
869   uint256 public constant ADVISORS_AND_CONTRIBUTORS_TOKENS = 39000000 * E18;
870   address public constant ADVISORS_AND_CONTRIBUTORS_ADDRESS = 0x90adab6891514DC24411B9Adf2e11C0eD7739999;
871 
872   // Bounty tokens have been pre-minted
873 //  uint256 public constant BOUNTY_TOKENS = 7000000 * E18;
874 //  address public constant BOUNTY_ADDRESS = 0x18f260a71c282bc4d5fe4ee1187658a06e9d1a59;
875 
876   // Unsold tokens will be transfered to the VAULT
877   address public constant UNSOLD_ADDRESS = 0x4eC155995211C8639375Ae3106187bff3FF5DB46;
878 
879   // Bonus amount. The first 24h there will be a bonus of 10%
880   uint256 public bonus;
881 
882   function FourCrowdsale(uint256 _startTime,
883                          uint256 _endTime,
884                          uint256 _rate,
885                          uint256 _bonus,
886                          address _wallet,
887                          address _token)
888         TokenCappedCrowdsale(TOKEN_SALE_CAP)
889         Crowdsale(_startTime, _endTime, _rate, _wallet, _token) public {
890     bonus = _bonus;
891   }
892 
893   function setCrowdsaleWallet(address _wallet) public onlyOwner {
894     require(_wallet != address(0));
895     wallet = _wallet;
896   }
897 
898   function changeStartAndEndTime(uint256 _newStartTime, uint256 _newEndTime) public onlyOwner {
899     require(_newStartTime >= now);
900     require(_newEndTime >= _newStartTime);
901 
902     startTime = _newStartTime;
903     endTime = _newEndTime;
904   }
905 
906   function changeEndTime(uint256 _newEndTime) public onlyOwner {
907     require(_newEndTime > startTime);
908     endTime = _newEndTime;
909   }
910 
911   function setRate(uint256 _rate) public onlyOwner  {
912     require(now < startTime); // cant change once the sale has started
913     rate = _rate;
914     RateChanged(_rate, 'rate');
915   }
916 
917   function setBonus(uint256 _bonus) public onlyOwner  {
918     require(now < startTime); // cant change once the sale has started
919     bonus = _bonus;
920     RateChanged(_bonus, 'bonus');
921   }
922 
923   function processPresaleOrEarlyContributors(address[] _beneficiaries, uint256[] _tokenAmounts) public onlyOwner {
924     // Cant process anymore after the crowdsale has finished
925     require(now <= endTime);
926 
927     for (uint i = 0; i < _beneficiaries.length; i++) {
928       // update state
929       tokensSold = tokensSold.add(_tokenAmounts[i]);
930       token.mint(_beneficiaries[i], _tokenAmounts[i]);
931 
932       TokenPurchase(msg.sender, _beneficiaries[i], 0, _tokenAmounts[i]);
933     }
934   }
935 
936 
937   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
938     uint256 actualRate = rate;
939 
940     // For the first 24 hours of the crowdsale there is a bonus
941     if (now <= startTime + 1 days) {
942       actualRate = actualRate.add(bonus);
943     }
944 
945     return weiAmount.mul(actualRate);
946   }
947 
948   function finalization() internal {
949     // transfer tokens to team
950     token.mint(TEAM_ADDRESS, TEAM_TOKENS);
951 
952     // transfer tokens to the 4th pillar vault
953     // already minted before crowdsale
954     // token.mint(VAULT_ADDRESS, VAULT_TOKENS);
955 
956     // transfer advisors and contributors tokens
957     token.mint(ADVISORS_AND_CONTRIBUTORS_ADDRESS, ADVISORS_AND_CONTRIBUTORS_TOKENS);
958 
959     // transfer bounty tokens
960     // already minted before crowdsale
961     //token.mint(BOUNTY_ADDRESS, BOUNTY_TOKENS);
962 
963     // transfer all unsold tokens to the unsold address for the airdrop
964     uint256 unsold_tokens = TOKEN_SALE_CAP - tokensSold;
965     token.mint(UNSOLD_ADDRESS, unsold_tokens);
966 
967     // finish minting
968     token.finishMinting();
969     // release ownership back to owner
970     token.transferOwnership(owner);
971     // finalize
972     super.finalization();
973   }
974 
975   // @dev Recover any mistakenly sent ERC20 tokens to the Crowdsale address
976   function recoverERC20Tokens(address _erc20, uint256 _amount) public onlyOwner {
977     ERC20Interface(_erc20).transfer(msg.sender, _amount);
978   }
979 
980   function releaseTokenOwnership() public onlyOwner {
981     token.transferOwnership(owner);
982   }
983 }