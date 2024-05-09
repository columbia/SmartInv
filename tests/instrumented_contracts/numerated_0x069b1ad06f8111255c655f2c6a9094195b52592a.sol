1 pragma solidity ^0.4.23;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
18 
19 /**
20  * @title ERC20 interface
21  * @dev see https://github.com/ethereum/EIPs/issues/20
22  */
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender)
25     public view returns (uint256);
26 
27   function transferFrom(address from, address to, uint256 value)
28     public returns (bool);
29 
30   function approve(address spender, uint256 value) public returns (bool);
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, throws on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
50     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     c = a * b;
58     assert(c / a == b);
59     return c;
60   }
61 
62   /**
63   * @dev Integer division of two numbers, truncating the quotient.
64   */
65   function div(uint256 a, uint256 b) internal pure returns (uint256) {
66     // assert(b > 0); // Solidity automatically throws when dividing by 0
67     // uint256 c = a / b;
68     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
69     return a / b;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     assert(b <= a);
77     return a - b;
78   }
79 
80   /**
81   * @dev Adds two numbers, throws on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 
90 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
91 
92 /**
93  * @title Crowdsale
94  * @dev Crowdsale is a base contract for managing a token crowdsale,
95  * allowing investors to purchase tokens with ether. This contract implements
96  * such functionality in its most fundamental form and can be extended to provide additional
97  * functionality and/or custom behavior.
98  * The external interface represents the basic interface for purchasing tokens, and conform
99  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
100  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
101  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
102  * behavior.
103  */
104 contract Crowdsale {
105   using SafeMath for uint256;
106 
107   // The token being sold
108   ERC20 public token;
109 
110   // Address where funds are collected
111   address public wallet;
112 
113   // How many token units a buyer gets per wei.
114   // The rate is the conversion between wei and the smallest and indivisible token unit.
115   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
116   // 1 wei will give you 1 unit, or 0.001 TOK.
117   uint256 public rate;
118 
119   // Amount of wei raised
120   uint256 public weiRaised;
121 
122   /**
123    * Event for token purchase logging
124    * @param purchaser who paid for the tokens
125    * @param beneficiary who got the tokens
126    * @param value weis paid for purchase
127    * @param amount amount of tokens purchased
128    */
129   event TokenPurchase(
130     address indexed purchaser,
131     address indexed beneficiary,
132     uint256 value,
133     uint256 amount
134   );
135 
136   /**
137    * @param _rate Number of token units a buyer gets per wei
138    * @param _wallet Address where collected funds will be forwarded to
139    * @param _token Address of the token being sold
140    */
141   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
142     require(_rate > 0);
143     require(_wallet != address(0));
144     require(_token != address(0));
145 
146     rate = _rate;
147     wallet = _wallet;
148     token = _token;
149   }
150 
151   // -----------------------------------------
152   // Crowdsale external interface
153   // -----------------------------------------
154 
155   /**
156    * @dev fallback function ***DO NOT OVERRIDE***
157    */
158   function () external payable {
159     buyTokens(msg.sender);
160   }
161 
162   /**
163    * @dev low level token purchase ***DO NOT OVERRIDE***
164    * @param _beneficiary Address performing the token purchase
165    */
166   function buyTokens(address _beneficiary) public payable {
167 
168     uint256 weiAmount = msg.value;
169     _preValidatePurchase(_beneficiary, weiAmount);
170 
171     // calculate token amount to be created
172     uint256 tokens = _getTokenAmount(weiAmount);
173 
174     // update state
175     weiRaised = weiRaised.add(weiAmount);
176 
177     _processPurchase(_beneficiary, tokens);
178     emit TokenPurchase(
179       msg.sender,
180       _beneficiary,
181       weiAmount,
182       tokens
183     );
184 
185     _updatePurchasingState(_beneficiary, weiAmount);
186 
187     _forwardFunds();
188     _postValidatePurchase(_beneficiary, weiAmount);
189   }
190 
191   // -----------------------------------------
192   // Internal interface (extensible)
193   // -----------------------------------------
194 
195   /**
196    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
197    * @param _beneficiary Address performing the token purchase
198    * @param _weiAmount Value in wei involved in the purchase
199    */
200   function _preValidatePurchase(
201     address _beneficiary,
202     uint256 _weiAmount
203   )
204     internal
205   {
206     require(_beneficiary != address(0));
207     require(_weiAmount != 0);
208   }
209 
210   /**
211    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
212    * @param _beneficiary Address performing the token purchase
213    * @param _weiAmount Value in wei involved in the purchase
214    */
215   function _postValidatePurchase(
216     address _beneficiary,
217     uint256 _weiAmount
218   )
219     internal
220   {
221     // optional override
222   }
223 
224   /**
225    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
226    * @param _beneficiary Address performing the token purchase
227    * @param _tokenAmount Number of tokens to be emitted
228    */
229   function _deliverTokens(
230     address _beneficiary,
231     uint256 _tokenAmount
232   )
233     internal
234   {
235     token.transfer(_beneficiary, _tokenAmount);
236   }
237 
238   /**
239    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
240    * @param _beneficiary Address receiving the tokens
241    * @param _tokenAmount Number of tokens to be purchased
242    */
243   function _processPurchase(
244     address _beneficiary,
245     uint256 _tokenAmount
246   )
247     internal
248   {
249     _deliverTokens(_beneficiary, _tokenAmount);
250   }
251 
252   /**
253    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
254    * @param _beneficiary Address receiving the tokens
255    * @param _weiAmount Value in wei involved in the purchase
256    */
257   function _updatePurchasingState(
258     address _beneficiary,
259     uint256 _weiAmount
260   )
261     internal
262   {
263     // optional override
264   }
265 
266   /**
267    * @dev Override to extend the way in which ether is converted to tokens.
268    * @param _weiAmount Value in wei to be converted into tokens
269    * @return Number of tokens that can be purchased with the specified _weiAmount
270    */
271   function _getTokenAmount(uint256 _weiAmount)
272     internal view returns (uint256)
273   {
274     return _weiAmount.mul(rate);
275   }
276 
277   /**
278    * @dev Determines how ETH is stored/forwarded on purchases.
279    */
280   function _forwardFunds() internal {
281     wallet.transfer(msg.value);
282   }
283 }
284 
285 // File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol
286 
287 /**
288  * @title Ownable
289  * @dev The Ownable contract has an owner address, and provides basic authorization control
290  * functions, this simplifies the implementation of "user permissions".
291  */
292 contract Ownable {
293   address public owner;
294 
295 
296   event OwnershipRenounced(address indexed previousOwner);
297   event OwnershipTransferred(
298     address indexed previousOwner,
299     address indexed newOwner
300   );
301 
302 
303   /**
304    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
305    * account.
306    */
307   constructor() public {
308     owner = msg.sender;
309   }
310 
311   /**
312    * @dev Throws if called by any account other than the owner.
313    */
314   modifier onlyOwner() {
315     require(msg.sender == owner);
316     _;
317   }
318 
319   /**
320    * @dev Allows the current owner to relinquish control of the contract.
321    */
322   function renounceOwnership() public onlyOwner {
323     emit OwnershipRenounced(owner);
324     owner = address(0);
325   }
326 
327   /**
328    * @dev Allows the current owner to transfer control of the contract to a newOwner.
329    * @param _newOwner The address to transfer ownership to.
330    */
331   function transferOwnership(address _newOwner) public onlyOwner {
332     _transferOwnership(_newOwner);
333   }
334 
335   /**
336    * @dev Transfers control of the contract to a newOwner.
337    * @param _newOwner The address to transfer ownership to.
338    */
339   function _transferOwnership(address _newOwner) internal {
340     require(_newOwner != address(0));
341     emit OwnershipTransferred(owner, _newOwner);
342     owner = _newOwner;
343   }
344 }
345 
346 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/validation/WhitelistedCrowdsale.sol
347 
348 /**
349  * @title WhitelistedCrowdsale
350  * @dev Crowdsale in which only whitelisted users can contribute.
351  */
352 contract WhitelistedCrowdsale is Crowdsale, Ownable {
353 
354   mapping(address => bool) public whitelist;
355 
356   /**
357    * @dev Reverts if beneficiary is not whitelisted. Can be used when extending this contract.
358    */
359   modifier isWhitelisted(address _beneficiary) {
360     require(whitelist[_beneficiary]);
361     _;
362   }
363 
364   /**
365    * @dev Adds single address to whitelist.
366    * @param _beneficiary Address to be added to the whitelist
367    */
368   function addToWhitelist(address _beneficiary) external onlyOwner {
369     whitelist[_beneficiary] = true;
370   }
371 
372   /**
373    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
374    * @param _beneficiaries Addresses to be added to the whitelist
375    */
376   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
377     for (uint256 i = 0; i < _beneficiaries.length; i++) {
378       whitelist[_beneficiaries[i]] = true;
379     }
380   }
381 
382   /**
383    * @dev Removes single address from whitelist.
384    * @param _beneficiary Address to be removed to the whitelist
385    */
386   function removeFromWhitelist(address _beneficiary) external onlyOwner {
387     whitelist[_beneficiary] = false;
388   }
389 
390   /**
391    * @dev Extend parent behavior requiring beneficiary to be in whitelist.
392    * @param _beneficiary Token beneficiary
393    * @param _weiAmount Amount of wei contributed
394    */
395   function _preValidatePurchase(
396     address _beneficiary,
397     uint256 _weiAmount
398   )
399     internal
400     isWhitelisted(_beneficiary)
401   {
402     super._preValidatePurchase(_beneficiary, _weiAmount);
403   }
404 
405 }
406 
407 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
408 
409 /**
410  * @title TimedCrowdsale
411  * @dev Crowdsale accepting contributions only within a time frame.
412  */
413 contract TimedCrowdsale is Crowdsale {
414   using SafeMath for uint256;
415 
416   uint256 public openingTime;
417   uint256 public closingTime;
418 
419   /**
420    * @dev Reverts if not in crowdsale time range.
421    */
422   modifier onlyWhileOpen {
423     // solium-disable-next-line security/no-block-members
424     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
425     _;
426   }
427 
428   /**
429    * @dev Constructor, takes crowdsale opening and closing times.
430    * @param _openingTime Crowdsale opening time
431    * @param _closingTime Crowdsale closing time
432    */
433   constructor(uint256 _openingTime, uint256 _closingTime) public {
434     // solium-disable-next-line security/no-block-members
435     require(_openingTime >= block.timestamp);
436     require(_closingTime >= _openingTime);
437 
438     openingTime = _openingTime;
439     closingTime = _closingTime;
440   }
441 
442   /**
443    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
444    * @return Whether crowdsale period has elapsed
445    */
446   function hasClosed() public view returns (bool) {
447     // solium-disable-next-line security/no-block-members
448     return block.timestamp > closingTime;
449   }
450 
451   /**
452    * @dev Extend parent behavior requiring to be within contributing period
453    * @param _beneficiary Token purchaser
454    * @param _weiAmount Amount of wei contributed
455    */
456   function _preValidatePurchase(
457     address _beneficiary,
458     uint256 _weiAmount
459   )
460     internal
461     onlyWhileOpen
462   {
463     super._preValidatePurchase(_beneficiary, _weiAmount);
464   }
465 
466 }
467 
468 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
469 
470 /**
471  * @title FinalizableCrowdsale
472  * @dev Extension of Crowdsale where an owner can do extra work
473  * after finishing.
474  */
475 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
476   using SafeMath for uint256;
477 
478   bool public isFinalized = false;
479 
480   event Finalized();
481 
482   /**
483    * @dev Must be called after crowdsale ends, to do some extra finalization
484    * work. Calls the contract's finalization function.
485    */
486   function finalize() onlyOwner public {
487     require(!isFinalized);
488     require(hasClosed());
489 
490     finalization();
491     emit Finalized();
492 
493     isFinalized = true;
494   }
495 
496   /**
497    * @dev Can be overridden to add finalization logic. The overriding function
498    * should call super.finalization() to ensure the chain of finalization is
499    * executed entirely.
500    */
501   function finalization() internal {
502   }
503 
504 }
505 
506 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/distribution/utils/RefundVault.sol
507 
508 /**
509  * @title RefundVault
510  * @dev This contract is used for storing funds while a crowdsale
511  * is in progress. Supports refunding the money if crowdsale fails,
512  * and forwarding it if crowdsale is successful.
513  */
514 contract RefundVault is Ownable {
515   using SafeMath for uint256;
516 
517   enum State { Active, Refunding, Closed }
518 
519   mapping (address => uint256) public deposited;
520   address public wallet;
521   State public state;
522 
523   event Closed();
524   event RefundsEnabled();
525   event Refunded(address indexed beneficiary, uint256 weiAmount);
526 
527   /**
528    * @param _wallet Vault address
529    */
530   constructor(address _wallet) public {
531     require(_wallet != address(0));
532     wallet = _wallet;
533     state = State.Active;
534   }
535 
536   /**
537    * @param investor Investor address
538    */
539   function deposit(address investor) onlyOwner public payable {
540     require(state == State.Active);
541     deposited[investor] = deposited[investor].add(msg.value);
542   }
543 
544   function close() onlyOwner public {
545     require(state == State.Active);
546     state = State.Closed;
547     emit Closed();
548     wallet.transfer(address(this).balance);
549   }
550 
551   function enableRefunds() onlyOwner public {
552     require(state == State.Active);
553     state = State.Refunding;
554     emit RefundsEnabled();
555   }
556 
557   /**
558    * @param investor Investor address
559    */
560   function refund(address investor) public {
561     require(state == State.Refunding);
562     uint256 depositedValue = deposited[investor];
563     deposited[investor] = 0;
564     investor.transfer(depositedValue);
565     emit Refunded(investor, depositedValue);
566   }
567 }
568 
569 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/distribution/RefundableCrowdsale.sol
570 
571 /**
572  * @title RefundableCrowdsale
573  * @dev Extension of Crowdsale contract that adds a funding goal, and
574  * the possibility of users getting a refund if goal is not met.
575  * Uses a RefundVault as the crowdsale's vault.
576  */
577 contract RefundableCrowdsale is FinalizableCrowdsale {
578   using SafeMath for uint256;
579 
580   // minimum amount of funds to be raised in weis
581   uint256 public goal;
582 
583   // refund vault used to hold funds while crowdsale is running
584   RefundVault public vault;
585 
586   /**
587    * @dev Constructor, creates RefundVault.
588    * @param _goal Funding goal
589    */
590   constructor(uint256 _goal) public {
591     require(_goal > 0);
592     vault = new RefundVault(wallet);
593     goal = _goal;
594   }
595 
596   /**
597    * @dev Investors can claim refunds here if crowdsale is unsuccessful
598    */
599   function claimRefund() public {
600     require(isFinalized);
601     require(!goalReached());
602 
603     vault.refund(msg.sender);
604   }
605 
606   /**
607    * @dev Checks whether funding goal was reached.
608    * @return Whether funding goal was reached
609    */
610   function goalReached() public view returns (bool) {
611     return weiRaised >= goal;
612   }
613 
614   /**
615    * @dev vault finalization task, called when owner calls finalize()
616    */
617   function finalization() internal {
618     if (goalReached()) {
619       vault.close();
620     } else {
621       vault.enableRefunds();
622     }
623 
624     super.finalization();
625   }
626 
627   /**
628    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
629    */
630   function _forwardFunds() internal {
631     vault.deposit.value(msg.value)(msg.sender);
632   }
633 
634 }
635 
636 // File: node_modules/openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
637 
638 /**
639  * @title PostDeliveryCrowdsale
640  * @dev Crowdsale that locks tokens from withdrawal until it ends.
641  */
642 contract PostDeliveryCrowdsale is TimedCrowdsale {
643   using SafeMath for uint256;
644 
645   mapping(address => uint256) public balances;
646 
647   /**
648    * @dev Withdraw tokens only after crowdsale ends.
649    */
650   function withdrawTokens() public {
651     require(hasClosed());
652     uint256 amount = balances[msg.sender];
653     require(amount > 0);
654     balances[msg.sender] = 0;
655     _deliverTokens(msg.sender, amount);
656   }
657 
658   /**
659    * @dev Overrides parent by storing balances instead of issuing tokens right away.
660    * @param _beneficiary Token purchaser
661    * @param _tokenAmount Amount of tokens purchased
662    */
663   function _processPurchase(
664     address _beneficiary,
665     uint256 _tokenAmount
666   )
667     internal
668   {
669     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
670   }
671 
672 }
673 
674 // File: node_modules/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
675 
676 /**
677  * @title Pausable
678  * @dev Base contract which allows children to implement an emergency stop mechanism.
679  */
680 contract Pausable is Ownable {
681   event Pause();
682   event Unpause();
683 
684   bool public paused = false;
685 
686 
687   /**
688    * @dev Modifier to make a function callable only when the contract is not paused.
689    */
690   modifier whenNotPaused() {
691     require(!paused);
692     _;
693   }
694 
695   /**
696    * @dev Modifier to make a function callable only when the contract is paused.
697    */
698   modifier whenPaused() {
699     require(paused);
700     _;
701   }
702 
703   /**
704    * @dev called by the owner to pause, triggers stopped state
705    */
706   function pause() onlyOwner whenNotPaused public {
707     paused = true;
708     emit Pause();
709   }
710 
711   /**
712    * @dev called by the owner to unpause, returns to normal state
713    */
714   function unpause() onlyOwner whenPaused public {
715     paused = false;
716     emit Unpause();
717   }
718 }
719 
720 // File: contracts/crowdsale/OraclizeContractInterface.sol
721 
722 /**
723  * @title OraclizeContractInterface
724  * @dev OraclizeContractInterface
725  **/
726 contract OraclizeContractInterface {
727   function finalize() public;
728   function buyTokensWithLTC(address _ethWallet, string _ltcWallet, uint256 _ltcAmount) public;
729   function buyTokensWithBTC(address _ethWallet, string _btcWallet, uint256 _btcAmount) public;
730   function buyTokensWithBNB(address _ethWallet, string _bnbWallet, uint256 _bnbAmount) public payable;
731   function buyTokensWithBCH(address _ethWallet, string _bchWallet, uint256 _bchAmount) public payable;
732   function getMultiCurrencyInvestorContribution(string _currencyWallet) public view returns(uint256);
733 }
734 
735 // File: contracts/crowdsale/BurnableTokenInterface.sol
736 
737 /**
738  * @title BurnableTokenInterface, defining one single function to burn tokens.
739  * @dev BurnableTokenInterface
740  **/
741 contract BurnableTokenInterface {
742 
743   /**
744   * @dev Burns a specific amount of tokens.
745   * @param _value The amount of token to be burned.
746   */
747   function burn(uint256 _value) public;
748 }
749 
750 // File: installed_contracts/oraclize-api/contracts/usingOraclize.sol
751 
752 // <ORACLIZE_API>
753 /*
754 Copyright (c) 2015-2016 Oraclize SRL
755 Copyright (c) 2016 Oraclize LTD
756 
757 
758 
759 Permission is hereby granted, free of charge, to any person obtaining a copy
760 of this software and associated documentation files (the "Software"), to deal
761 in the Software without restriction, including without limitation the rights
762 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
763 copies of the Software, and to permit persons to whom the Software is
764 furnished to do so, subject to the following conditions:
765 
766 
767 
768 The above copyright notice and this permission notice shall be included in
769 all copies or substantial portions of the Software.
770 
771 
772 
773 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
774 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
775 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
776 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
777 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
778 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
779 THE SOFTWARE.
780 */
781 
782 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
783 pragma solidity ^0.4.18;
784 
785 contract OraclizeI {
786     address public cbAddress;
787     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
788     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
789     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
790     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
791     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
792     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
793     function getPrice(string _datasource) public returns (uint _dsprice);
794     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
795     function setProofType(byte _proofType) external;
796     function setCustomGasPrice(uint _gasPrice) external;
797     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
798 }
799 contract OraclizeAddrResolverI {
800     function getAddress() public returns (address _addr);
801 }
802 contract usingOraclize {
803     uint constant day = 60*60*24;
804     uint constant week = 60*60*24*7;
805     uint constant month = 60*60*24*30;
806     byte constant proofType_NONE = 0x00;
807     byte constant proofType_TLSNotary = 0x10;
808     byte constant proofType_Android = 0x20;
809     byte constant proofType_Ledger = 0x30;
810     byte constant proofType_Native = 0xF0;
811     byte constant proofStorage_IPFS = 0x01;
812     uint8 constant networkID_auto = 0;
813     uint8 constant networkID_mainnet = 1;
814     uint8 constant networkID_testnet = 2;
815     uint8 constant networkID_morden = 2;
816     uint8 constant networkID_consensys = 161;
817 
818     OraclizeAddrResolverI OAR;
819 
820     OraclizeI oraclize;
821     modifier oraclizeAPI {
822         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
823             oraclize_setNetwork(networkID_auto);
824 
825         if(address(oraclize) != OAR.getAddress())
826             oraclize = OraclizeI(OAR.getAddress());
827 
828         _;
829     }
830     modifier coupon(string code){
831         oraclize = OraclizeI(OAR.getAddress());
832         _;
833     }
834 
835     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
836       return oraclize_setNetwork();
837       networkID; // silence the warning and remain backwards compatible
838     }
839     function oraclize_setNetwork() internal returns(bool){
840         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
841             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
842             oraclize_setNetworkName("eth_mainnet");
843             return true;
844         }
845         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
846             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
847             oraclize_setNetworkName("eth_ropsten3");
848             return true;
849         }
850         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
851             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
852             oraclize_setNetworkName("eth_kovan");
853             return true;
854         }
855         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
856             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
857             oraclize_setNetworkName("eth_rinkeby");
858             return true;
859         }
860         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
861             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
862             return true;
863         }
864         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
865             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
866             return true;
867         }
868         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
869             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
870             return true;
871         }
872         return false;
873     }
874 
875     function __callback(bytes32 myid, string result) public {
876         __callback(myid, result, new bytes(0));
877     }
878     function __callback(bytes32 myid, string result, bytes proof) public {
879       return;
880       myid; result; proof; // Silence compiler warnings
881     }
882 
883     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
884         return oraclize.getPrice(datasource);
885     }
886 
887     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
888         return oraclize.getPrice(datasource, gaslimit);
889     }
890 
891     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
892         uint price = oraclize.getPrice(datasource);
893         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
894         return oraclize.query.value(price)(0, datasource, arg);
895     }
896     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
897         uint price = oraclize.getPrice(datasource);
898         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
899         return oraclize.query.value(price)(timestamp, datasource, arg);
900     }
901     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
902         uint price = oraclize.getPrice(datasource, gaslimit);
903         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
904         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
905     }
906     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
907         uint price = oraclize.getPrice(datasource, gaslimit);
908         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
909         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
910     }
911     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
912         uint price = oraclize.getPrice(datasource);
913         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
914         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
915     }
916     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
917         uint price = oraclize.getPrice(datasource);
918         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
919         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
920     }
921     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
922         uint price = oraclize.getPrice(datasource, gaslimit);
923         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
924         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
925     }
926     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
927         uint price = oraclize.getPrice(datasource, gaslimit);
928         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
929         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
930     }
931     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
932         uint price = oraclize.getPrice(datasource);
933         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
934         bytes memory args = stra2cbor(argN);
935         return oraclize.queryN.value(price)(0, datasource, args);
936     }
937     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
938         uint price = oraclize.getPrice(datasource);
939         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
940         bytes memory args = stra2cbor(argN);
941         return oraclize.queryN.value(price)(timestamp, datasource, args);
942     }
943     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
944         uint price = oraclize.getPrice(datasource, gaslimit);
945         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
946         bytes memory args = stra2cbor(argN);
947         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
948     }
949     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
950         uint price = oraclize.getPrice(datasource, gaslimit);
951         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
952         bytes memory args = stra2cbor(argN);
953         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
954     }
955     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
956         string[] memory dynargs = new string[](1);
957         dynargs[0] = args[0];
958         return oraclize_query(datasource, dynargs);
959     }
960     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
961         string[] memory dynargs = new string[](1);
962         dynargs[0] = args[0];
963         return oraclize_query(timestamp, datasource, dynargs);
964     }
965     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
966         string[] memory dynargs = new string[](1);
967         dynargs[0] = args[0];
968         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
969     }
970     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
971         string[] memory dynargs = new string[](1);
972         dynargs[0] = args[0];
973         return oraclize_query(datasource, dynargs, gaslimit);
974     }
975 
976     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
977         string[] memory dynargs = new string[](2);
978         dynargs[0] = args[0];
979         dynargs[1] = args[1];
980         return oraclize_query(datasource, dynargs);
981     }
982     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
983         string[] memory dynargs = new string[](2);
984         dynargs[0] = args[0];
985         dynargs[1] = args[1];
986         return oraclize_query(timestamp, datasource, dynargs);
987     }
988     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
989         string[] memory dynargs = new string[](2);
990         dynargs[0] = args[0];
991         dynargs[1] = args[1];
992         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
993     }
994     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
995         string[] memory dynargs = new string[](2);
996         dynargs[0] = args[0];
997         dynargs[1] = args[1];
998         return oraclize_query(datasource, dynargs, gaslimit);
999     }
1000     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1001         string[] memory dynargs = new string[](3);
1002         dynargs[0] = args[0];
1003         dynargs[1] = args[1];
1004         dynargs[2] = args[2];
1005         return oraclize_query(datasource, dynargs);
1006     }
1007     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1008         string[] memory dynargs = new string[](3);
1009         dynargs[0] = args[0];
1010         dynargs[1] = args[1];
1011         dynargs[2] = args[2];
1012         return oraclize_query(timestamp, datasource, dynargs);
1013     }
1014     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1015         string[] memory dynargs = new string[](3);
1016         dynargs[0] = args[0];
1017         dynargs[1] = args[1];
1018         dynargs[2] = args[2];
1019         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1020     }
1021     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1022         string[] memory dynargs = new string[](3);
1023         dynargs[0] = args[0];
1024         dynargs[1] = args[1];
1025         dynargs[2] = args[2];
1026         return oraclize_query(datasource, dynargs, gaslimit);
1027     }
1028 
1029     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1030         string[] memory dynargs = new string[](4);
1031         dynargs[0] = args[0];
1032         dynargs[1] = args[1];
1033         dynargs[2] = args[2];
1034         dynargs[3] = args[3];
1035         return oraclize_query(datasource, dynargs);
1036     }
1037     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1038         string[] memory dynargs = new string[](4);
1039         dynargs[0] = args[0];
1040         dynargs[1] = args[1];
1041         dynargs[2] = args[2];
1042         dynargs[3] = args[3];
1043         return oraclize_query(timestamp, datasource, dynargs);
1044     }
1045     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1046         string[] memory dynargs = new string[](4);
1047         dynargs[0] = args[0];
1048         dynargs[1] = args[1];
1049         dynargs[2] = args[2];
1050         dynargs[3] = args[3];
1051         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1052     }
1053     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1054         string[] memory dynargs = new string[](4);
1055         dynargs[0] = args[0];
1056         dynargs[1] = args[1];
1057         dynargs[2] = args[2];
1058         dynargs[3] = args[3];
1059         return oraclize_query(datasource, dynargs, gaslimit);
1060     }
1061     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1062         string[] memory dynargs = new string[](5);
1063         dynargs[0] = args[0];
1064         dynargs[1] = args[1];
1065         dynargs[2] = args[2];
1066         dynargs[3] = args[3];
1067         dynargs[4] = args[4];
1068         return oraclize_query(datasource, dynargs);
1069     }
1070     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1071         string[] memory dynargs = new string[](5);
1072         dynargs[0] = args[0];
1073         dynargs[1] = args[1];
1074         dynargs[2] = args[2];
1075         dynargs[3] = args[3];
1076         dynargs[4] = args[4];
1077         return oraclize_query(timestamp, datasource, dynargs);
1078     }
1079     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1080         string[] memory dynargs = new string[](5);
1081         dynargs[0] = args[0];
1082         dynargs[1] = args[1];
1083         dynargs[2] = args[2];
1084         dynargs[3] = args[3];
1085         dynargs[4] = args[4];
1086         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1087     }
1088     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1089         string[] memory dynargs = new string[](5);
1090         dynargs[0] = args[0];
1091         dynargs[1] = args[1];
1092         dynargs[2] = args[2];
1093         dynargs[3] = args[3];
1094         dynargs[4] = args[4];
1095         return oraclize_query(datasource, dynargs, gaslimit);
1096     }
1097     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1098         uint price = oraclize.getPrice(datasource);
1099         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1100         bytes memory args = ba2cbor(argN);
1101         return oraclize.queryN.value(price)(0, datasource, args);
1102     }
1103     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1104         uint price = oraclize.getPrice(datasource);
1105         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1106         bytes memory args = ba2cbor(argN);
1107         return oraclize.queryN.value(price)(timestamp, datasource, args);
1108     }
1109     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1110         uint price = oraclize.getPrice(datasource, gaslimit);
1111         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1112         bytes memory args = ba2cbor(argN);
1113         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1114     }
1115     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1116         uint price = oraclize.getPrice(datasource, gaslimit);
1117         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1118         bytes memory args = ba2cbor(argN);
1119         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1120     }
1121     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1122         bytes[] memory dynargs = new bytes[](1);
1123         dynargs[0] = args[0];
1124         return oraclize_query(datasource, dynargs);
1125     }
1126     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1127         bytes[] memory dynargs = new bytes[](1);
1128         dynargs[0] = args[0];
1129         return oraclize_query(timestamp, datasource, dynargs);
1130     }
1131     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1132         bytes[] memory dynargs = new bytes[](1);
1133         dynargs[0] = args[0];
1134         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1135     }
1136     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1137         bytes[] memory dynargs = new bytes[](1);
1138         dynargs[0] = args[0];
1139         return oraclize_query(datasource, dynargs, gaslimit);
1140     }
1141 
1142     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1143         bytes[] memory dynargs = new bytes[](2);
1144         dynargs[0] = args[0];
1145         dynargs[1] = args[1];
1146         return oraclize_query(datasource, dynargs);
1147     }
1148     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1149         bytes[] memory dynargs = new bytes[](2);
1150         dynargs[0] = args[0];
1151         dynargs[1] = args[1];
1152         return oraclize_query(timestamp, datasource, dynargs);
1153     }
1154     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1155         bytes[] memory dynargs = new bytes[](2);
1156         dynargs[0] = args[0];
1157         dynargs[1] = args[1];
1158         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1159     }
1160     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1161         bytes[] memory dynargs = new bytes[](2);
1162         dynargs[0] = args[0];
1163         dynargs[1] = args[1];
1164         return oraclize_query(datasource, dynargs, gaslimit);
1165     }
1166     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1167         bytes[] memory dynargs = new bytes[](3);
1168         dynargs[0] = args[0];
1169         dynargs[1] = args[1];
1170         dynargs[2] = args[2];
1171         return oraclize_query(datasource, dynargs);
1172     }
1173     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1174         bytes[] memory dynargs = new bytes[](3);
1175         dynargs[0] = args[0];
1176         dynargs[1] = args[1];
1177         dynargs[2] = args[2];
1178         return oraclize_query(timestamp, datasource, dynargs);
1179     }
1180     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1181         bytes[] memory dynargs = new bytes[](3);
1182         dynargs[0] = args[0];
1183         dynargs[1] = args[1];
1184         dynargs[2] = args[2];
1185         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1186     }
1187     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1188         bytes[] memory dynargs = new bytes[](3);
1189         dynargs[0] = args[0];
1190         dynargs[1] = args[1];
1191         dynargs[2] = args[2];
1192         return oraclize_query(datasource, dynargs, gaslimit);
1193     }
1194 
1195     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1196         bytes[] memory dynargs = new bytes[](4);
1197         dynargs[0] = args[0];
1198         dynargs[1] = args[1];
1199         dynargs[2] = args[2];
1200         dynargs[3] = args[3];
1201         return oraclize_query(datasource, dynargs);
1202     }
1203     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1204         bytes[] memory dynargs = new bytes[](4);
1205         dynargs[0] = args[0];
1206         dynargs[1] = args[1];
1207         dynargs[2] = args[2];
1208         dynargs[3] = args[3];
1209         return oraclize_query(timestamp, datasource, dynargs);
1210     }
1211     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1212         bytes[] memory dynargs = new bytes[](4);
1213         dynargs[0] = args[0];
1214         dynargs[1] = args[1];
1215         dynargs[2] = args[2];
1216         dynargs[3] = args[3];
1217         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1218     }
1219     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1220         bytes[] memory dynargs = new bytes[](4);
1221         dynargs[0] = args[0];
1222         dynargs[1] = args[1];
1223         dynargs[2] = args[2];
1224         dynargs[3] = args[3];
1225         return oraclize_query(datasource, dynargs, gaslimit);
1226     }
1227     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1228         bytes[] memory dynargs = new bytes[](5);
1229         dynargs[0] = args[0];
1230         dynargs[1] = args[1];
1231         dynargs[2] = args[2];
1232         dynargs[3] = args[3];
1233         dynargs[4] = args[4];
1234         return oraclize_query(datasource, dynargs);
1235     }
1236     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1237         bytes[] memory dynargs = new bytes[](5);
1238         dynargs[0] = args[0];
1239         dynargs[1] = args[1];
1240         dynargs[2] = args[2];
1241         dynargs[3] = args[3];
1242         dynargs[4] = args[4];
1243         return oraclize_query(timestamp, datasource, dynargs);
1244     }
1245     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1246         bytes[] memory dynargs = new bytes[](5);
1247         dynargs[0] = args[0];
1248         dynargs[1] = args[1];
1249         dynargs[2] = args[2];
1250         dynargs[3] = args[3];
1251         dynargs[4] = args[4];
1252         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1253     }
1254     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1255         bytes[] memory dynargs = new bytes[](5);
1256         dynargs[0] = args[0];
1257         dynargs[1] = args[1];
1258         dynargs[2] = args[2];
1259         dynargs[3] = args[3];
1260         dynargs[4] = args[4];
1261         return oraclize_query(datasource, dynargs, gaslimit);
1262     }
1263 
1264     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1265         return oraclize.cbAddress();
1266     }
1267     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1268         return oraclize.setProofType(proofP);
1269     }
1270     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1271         return oraclize.setCustomGasPrice(gasPrice);
1272     }
1273 
1274     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1275         return oraclize.randomDS_getSessionPubKeyHash();
1276     }
1277 
1278     function getCodeSize(address _addr) constant internal returns(uint _size) {
1279         assembly {
1280             _size := extcodesize(_addr)
1281         }
1282     }
1283 
1284     function parseAddr(string _a) internal pure returns (address){
1285         bytes memory tmp = bytes(_a);
1286         uint160 iaddr = 0;
1287         uint160 b1;
1288         uint160 b2;
1289         for (uint i=2; i<2+2*20; i+=2){
1290             iaddr *= 256;
1291             b1 = uint160(tmp[i]);
1292             b2 = uint160(tmp[i+1]);
1293             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1294             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1295             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1296             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1297             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1298             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1299             iaddr += (b1*16+b2);
1300         }
1301         return address(iaddr);
1302     }
1303 
1304     function strCompare(string _a, string _b) internal pure returns (int) {
1305         bytes memory a = bytes(_a);
1306         bytes memory b = bytes(_b);
1307         uint minLength = a.length;
1308         if (b.length < minLength) minLength = b.length;
1309         for (uint i = 0; i < minLength; i ++)
1310             if (a[i] < b[i])
1311                 return -1;
1312             else if (a[i] > b[i])
1313                 return 1;
1314         if (a.length < b.length)
1315             return -1;
1316         else if (a.length > b.length)
1317             return 1;
1318         else
1319             return 0;
1320     }
1321 
1322     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1323         bytes memory h = bytes(_haystack);
1324         bytes memory n = bytes(_needle);
1325         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1326             return -1;
1327         else if(h.length > (2**128 -1))
1328             return -1;
1329         else
1330         {
1331             uint subindex = 0;
1332             for (uint i = 0; i < h.length; i ++)
1333             {
1334                 if (h[i] == n[0])
1335                 {
1336                     subindex = 1;
1337                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1338                     {
1339                         subindex++;
1340                     }
1341                     if(subindex == n.length)
1342                         return int(i);
1343                 }
1344             }
1345             return -1;
1346         }
1347     }
1348 
1349     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1350         bytes memory _ba = bytes(_a);
1351         bytes memory _bb = bytes(_b);
1352         bytes memory _bc = bytes(_c);
1353         bytes memory _bd = bytes(_d);
1354         bytes memory _be = bytes(_e);
1355         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1356         bytes memory babcde = bytes(abcde);
1357         uint k = 0;
1358         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1359         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1360         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1361         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1362         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1363         return string(babcde);
1364     }
1365 
1366     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1367         return strConcat(_a, _b, _c, _d, "");
1368     }
1369 
1370     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1371         return strConcat(_a, _b, _c, "", "");
1372     }
1373 
1374     function strConcat(string _a, string _b) internal pure returns (string) {
1375         return strConcat(_a, _b, "", "", "");
1376     }
1377 
1378     // parseInt
1379     function parseInt(string _a) internal pure returns (uint) {
1380         return parseInt(_a, 0);
1381     }
1382 
1383     // parseInt(parseFloat*10^_b)
1384     function parseInt(string _a, uint _b) internal pure returns (uint) {
1385         bytes memory bresult = bytes(_a);
1386         uint mint = 0;
1387         bool decimals = false;
1388         for (uint i=0; i<bresult.length; i++){
1389             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1390                 if (decimals){
1391                    if (_b == 0) break;
1392                     else _b--;
1393                 }
1394                 mint *= 10;
1395                 mint += uint(bresult[i]) - 48;
1396             } else if (bresult[i] == 46) decimals = true;
1397         }
1398         if (_b > 0) mint *= 10**_b;
1399         return mint;
1400     }
1401 
1402     function uint2str(uint i) internal pure returns (string){
1403         if (i == 0) return "0";
1404         uint j = i;
1405         uint len;
1406         while (j != 0){
1407             len++;
1408             j /= 10;
1409         }
1410         bytes memory bstr = new bytes(len);
1411         uint k = len - 1;
1412         while (i != 0){
1413             bstr[k--] = byte(48 + i % 10);
1414             i /= 10;
1415         }
1416         return string(bstr);
1417     }
1418 
1419     function stra2cbor(string[] arr) internal pure returns (bytes) {
1420             uint arrlen = arr.length;
1421 
1422             // get correct cbor output length
1423             uint outputlen = 0;
1424             bytes[] memory elemArray = new bytes[](arrlen);
1425             for (uint i = 0; i < arrlen; i++) {
1426                 elemArray[i] = (bytes(arr[i]));
1427                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1428             }
1429             uint ctr = 0;
1430             uint cborlen = arrlen + 0x80;
1431             outputlen += byte(cborlen).length;
1432             bytes memory res = new bytes(outputlen);
1433 
1434             while (byte(cborlen).length > ctr) {
1435                 res[ctr] = byte(cborlen)[ctr];
1436                 ctr++;
1437             }
1438             for (i = 0; i < arrlen; i++) {
1439                 res[ctr] = 0x5F;
1440                 ctr++;
1441                 for (uint x = 0; x < elemArray[i].length; x++) {
1442                     // if there's a bug with larger strings, this may be the culprit
1443                     if (x % 23 == 0) {
1444                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1445                         elemcborlen += 0x40;
1446                         uint lctr = ctr;
1447                         while (byte(elemcborlen).length > ctr - lctr) {
1448                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1449                             ctr++;
1450                         }
1451                     }
1452                     res[ctr] = elemArray[i][x];
1453                     ctr++;
1454                 }
1455                 res[ctr] = 0xFF;
1456                 ctr++;
1457             }
1458             return res;
1459         }
1460 
1461     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1462             uint arrlen = arr.length;
1463 
1464             // get correct cbor output length
1465             uint outputlen = 0;
1466             bytes[] memory elemArray = new bytes[](arrlen);
1467             for (uint i = 0; i < arrlen; i++) {
1468                 elemArray[i] = (bytes(arr[i]));
1469                 outputlen += elemArray[i].length + (elemArray[i].length - 1)/23 + 3; //+3 accounts for paired identifier types
1470             }
1471             uint ctr = 0;
1472             uint cborlen = arrlen + 0x80;
1473             outputlen += byte(cborlen).length;
1474             bytes memory res = new bytes(outputlen);
1475 
1476             while (byte(cborlen).length > ctr) {
1477                 res[ctr] = byte(cborlen)[ctr];
1478                 ctr++;
1479             }
1480             for (i = 0; i < arrlen; i++) {
1481                 res[ctr] = 0x5F;
1482                 ctr++;
1483                 for (uint x = 0; x < elemArray[i].length; x++) {
1484                     // if there's a bug with larger strings, this may be the culprit
1485                     if (x % 23 == 0) {
1486                         uint elemcborlen = elemArray[i].length - x >= 24 ? 23 : elemArray[i].length - x;
1487                         elemcborlen += 0x40;
1488                         uint lctr = ctr;
1489                         while (byte(elemcborlen).length > ctr - lctr) {
1490                             res[ctr] = byte(elemcborlen)[ctr - lctr];
1491                             ctr++;
1492                         }
1493                     }
1494                     res[ctr] = elemArray[i][x];
1495                     ctr++;
1496                 }
1497                 res[ctr] = 0xFF;
1498                 ctr++;
1499             }
1500             return res;
1501         }
1502 
1503 
1504     string oraclize_network_name;
1505     function oraclize_setNetworkName(string _network_name) internal {
1506         oraclize_network_name = _network_name;
1507     }
1508 
1509     function oraclize_getNetworkName() internal view returns (string) {
1510         return oraclize_network_name;
1511     }
1512 
1513     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1514         require((_nbytes > 0) && (_nbytes <= 32));
1515         // Convert from seconds to ledger timer ticks
1516         _delay *= 10; 
1517         bytes memory nbytes = new bytes(1);
1518         nbytes[0] = byte(_nbytes);
1519         bytes memory unonce = new bytes(32);
1520         bytes memory sessionKeyHash = new bytes(32);
1521         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1522         assembly {
1523             mstore(unonce, 0x20)
1524             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1525             mstore(sessionKeyHash, 0x20)
1526             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1527         }
1528         bytes memory delay = new bytes(32);
1529         assembly { 
1530             mstore(add(delay, 0x20), _delay) 
1531         }
1532         
1533         bytes memory delay_bytes8 = new bytes(8);
1534         copyBytes(delay, 24, 8, delay_bytes8, 0);
1535 
1536         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1537         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1538         
1539         bytes memory delay_bytes8_left = new bytes(8);
1540         
1541         assembly {
1542             let x := mload(add(delay_bytes8, 0x20))
1543             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1544             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1545             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1546             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1547             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1548             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1549             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1550             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1551 
1552         }
1553         
1554         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1555         return queryId;
1556     }
1557     
1558     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1559         oraclize_randomDS_args[queryId] = commitment;
1560     }
1561 
1562     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1563     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1564 
1565     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1566         bool sigok;
1567         address signer;
1568 
1569         bytes32 sigr;
1570         bytes32 sigs;
1571 
1572         bytes memory sigr_ = new bytes(32);
1573         uint offset = 4+(uint(dersig[3]) - 0x20);
1574         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1575         bytes memory sigs_ = new bytes(32);
1576         offset += 32 + 2;
1577         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1578 
1579         assembly {
1580             sigr := mload(add(sigr_, 32))
1581             sigs := mload(add(sigs_, 32))
1582         }
1583 
1584 
1585         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1586         if (address(keccak256(pubkey)) == signer) return true;
1587         else {
1588             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1589             return (address(keccak256(pubkey)) == signer);
1590         }
1591     }
1592 
1593     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1594         bool sigok;
1595 
1596         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1597         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1598         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1599 
1600         bytes memory appkey1_pubkey = new bytes(64);
1601         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1602 
1603         bytes memory tosign2 = new bytes(1+65+32);
1604         tosign2[0] = byte(1); //role
1605         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1606         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1607         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1608         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1609 
1610         if (sigok == false) return false;
1611 
1612 
1613         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1614         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1615 
1616         bytes memory tosign3 = new bytes(1+65);
1617         tosign3[0] = 0xFE;
1618         copyBytes(proof, 3, 65, tosign3, 1);
1619 
1620         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1621         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1622 
1623         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1624 
1625         return sigok;
1626     }
1627 
1628     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1629         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1630         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1631 
1632         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1633         require(proofVerified);
1634 
1635         _;
1636     }
1637 
1638     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1639         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1640         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1641 
1642         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1643         if (proofVerified == false) return 2;
1644 
1645         return 0;
1646     }
1647 
1648     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1649         bool match_ = true;
1650         
1651         require(prefix.length == n_random_bytes);
1652 
1653         for (uint256 i=0; i< n_random_bytes; i++) {
1654             if (content[i] != prefix[i]) match_ = false;
1655         }
1656 
1657         return match_;
1658     }
1659 
1660     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1661 
1662         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1663         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1664         bytes memory keyhash = new bytes(32);
1665         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1666         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1667 
1668         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1669         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1670 
1671         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1672         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1673 
1674         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1675         // This is to verify that the computed args match with the ones specified in the query.
1676         bytes memory commitmentSlice1 = new bytes(8+1+32);
1677         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1678 
1679         bytes memory sessionPubkey = new bytes(64);
1680         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1681         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1682 
1683         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1684         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1685             delete oraclize_randomDS_args[queryId];
1686         } else return false;
1687 
1688 
1689         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1690         bytes memory tosign1 = new bytes(32+8+1+32);
1691         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1692         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1693 
1694         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1695         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1696             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1697         }
1698 
1699         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1700     }
1701 
1702     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1703     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1704         uint minLength = length + toOffset;
1705 
1706         // Buffer too small
1707         require(to.length >= minLength); // Should be a better way?
1708 
1709         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1710         uint i = 32 + fromOffset;
1711         uint j = 32 + toOffset;
1712 
1713         while (i < (32 + fromOffset + length)) {
1714             assembly {
1715                 let tmp := mload(add(from, i))
1716                 mstore(add(to, j), tmp)
1717             }
1718             i += 32;
1719             j += 32;
1720         }
1721 
1722         return to;
1723     }
1724 
1725     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1726     // Duplicate Solidity's ecrecover, but catching the CALL return value
1727     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1728         // We do our own memory management here. Solidity uses memory offset
1729         // 0x40 to store the current end of memory. We write past it (as
1730         // writes are memory extensions), but don't update the offset so
1731         // Solidity will reuse it. The memory used here is only needed for
1732         // this context.
1733 
1734         // FIXME: inline assembly can't access return values
1735         bool ret;
1736         address addr;
1737 
1738         assembly {
1739             let size := mload(0x40)
1740             mstore(size, hash)
1741             mstore(add(size, 32), v)
1742             mstore(add(size, 64), r)
1743             mstore(add(size, 96), s)
1744 
1745             // NOTE: we can reuse the request memory because we deal with
1746             //       the return code
1747             ret := call(3000, 1, 0, size, 128, size, 32)
1748             addr := mload(size)
1749         }
1750 
1751         return (ret, addr);
1752     }
1753 
1754     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1755     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1756         bytes32 r;
1757         bytes32 s;
1758         uint8 v;
1759 
1760         if (sig.length != 65)
1761           return (false, 0);
1762 
1763         // The signature format is a compact form of:
1764         //   {bytes32 r}{bytes32 s}{uint8 v}
1765         // Compact means, uint8 is not padded to 32 bytes.
1766         assembly {
1767             r := mload(add(sig, 32))
1768             s := mload(add(sig, 64))
1769 
1770             // Here we are loading the last 32 bytes. We exploit the fact that
1771             // 'mload' will pad with zeroes if we overread.
1772             // There is no 'mload8' to do this, but that would be nicer.
1773             v := byte(0, mload(add(sig, 96)))
1774 
1775             // Alternative solution:
1776             // 'byte' is not working due to the Solidity parser, so lets
1777             // use the second best option, 'and'
1778             // v := and(mload(add(sig, 65)), 255)
1779         }
1780 
1781         // albeit non-transactional signatures are not specified by the YP, one would expect it
1782         // to match the YP range of [27, 28]
1783         //
1784         // geth uses [0, 1] and some clients have followed. This might change, see:
1785         //  https://github.com/ethereum/go-ethereum/issues/2053
1786         if (v < 27)
1787           v += 27;
1788 
1789         if (v != 27 && v != 28)
1790             return (false, 0);
1791 
1792         return safer_ecrecover(hash, v, r, s);
1793     }
1794 
1795 }
1796 // </ORACLIZE_API>
1797 
1798 // File: contracts/crowdsale/FiatContractInterface.sol
1799 
1800 /**
1801  * @title FiatContractInterface, defining one single function to get 0,01 $ price.
1802  * @dev FiatContractInterface
1803  **/
1804 contract FiatContractInterface {
1805   function USD(uint _id) view public returns (uint256);
1806 }
1807 
1808 // File: contracts/utils/strings.sol
1809 
1810 /*
1811  * @title String & slice utility library for Solidity contracts.
1812  * @author Nick Johnson <arachnid@notdot.net>
1813  *
1814  * @dev Functionality in this library is largely implemented using an
1815  *      abstraction called a 'slice'. A slice represents a part of a string -
1816  *      anything from the entire string to a single character, or even no
1817  *      characters at all (a 0-length slice). Since a slice only has to specify
1818  *      an offset and a length, copying and manipulating slices is a lot less
1819  *      expensive than copying and manipulating the strings they reference.
1820  *
1821  *      To further reduce gas costs, most functions on slice that need to return
1822  *      a slice modify the original one instead of allocating a new one; for
1823  *      instance, `s.split(".")` will return the text up to the first '.',
1824  *      modifying s to only contain the remainder of the string after the '.'.
1825  *      In situations where you do not want to modify the original slice, you
1826  *      can make a copy first with `.copy()`, for example:
1827  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1828  *      Solidity has no memory management, it will result in allocating many
1829  *      short-lived slices that are later discarded.
1830  *
1831  *      Functions that return two slices come in two versions: a non-allocating
1832  *      version that takes the second slice as an argument, modifying it in
1833  *      place, and an allocating version that allocates and returns the second
1834  *      slice; see `nextRune` for example.
1835  *
1836  *      Functions that have to copy string data will return strings rather than
1837  *      slices; these can be cast back to slices for further processing if
1838  *      required.
1839  *
1840  *      For convenience, some functions are provided with non-modifying
1841  *      variants that create a new slice and return both; for instance,
1842  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1843  *      corresponding to the left and right parts of the string.
1844  */
1845 
1846 pragma solidity ^0.4.14;
1847 
1848 library strings {
1849     struct slice {
1850         uint _len;
1851         uint _ptr;
1852     }
1853 
1854     function memcpy(uint dest, uint src, uint len) private pure {
1855         // Copy word-length chunks while possible
1856         for(; len >= 32; len -= 32) {
1857             assembly {
1858                 mstore(dest, mload(src))
1859             }
1860             dest += 32;
1861             src += 32;
1862         }
1863 
1864         // Copy remaining bytes
1865         uint mask = 256 ** (32 - len) - 1;
1866         assembly {
1867             let srcpart := and(mload(src), not(mask))
1868             let destpart := and(mload(dest), mask)
1869             mstore(dest, or(destpart, srcpart))
1870         }
1871     }
1872 
1873     /*
1874      * @dev Returns a slice containing the entire string.
1875      * @param self The string to make a slice from.
1876      * @return A newly allocated slice containing the entire string.
1877      */
1878     function toSlice(string memory self) internal pure returns (slice memory) {
1879         uint ptr;
1880         assembly {
1881             ptr := add(self, 0x20)
1882         }
1883         return slice(bytes(self).length, ptr);
1884     }
1885 
1886     /*
1887      * @dev Returns the length of a null-terminated bytes32 string.
1888      * @param self The value to find the length of.
1889      * @return The length of the string, from 0 to 32.
1890      */
1891     function len(bytes32 self) internal pure returns (uint) {
1892         uint ret;
1893         if (self == 0)
1894             return 0;
1895         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1896             ret += 16;
1897             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1898         }
1899         if (self & 0xffffffffffffffff == 0) {
1900             ret += 8;
1901             self = bytes32(uint(self) / 0x10000000000000000);
1902         }
1903         if (self & 0xffffffff == 0) {
1904             ret += 4;
1905             self = bytes32(uint(self) / 0x100000000);
1906         }
1907         if (self & 0xffff == 0) {
1908             ret += 2;
1909             self = bytes32(uint(self) / 0x10000);
1910         }
1911         if (self & 0xff == 0) {
1912             ret += 1;
1913         }
1914         return 32 - ret;
1915     }
1916 
1917     /*
1918      * @dev Returns a slice containing the entire bytes32, interpreted as a
1919      *      null-terminated utf-8 string.
1920      * @param self The bytes32 value to convert to a slice.
1921      * @return A new slice containing the value of the input argument up to the
1922      *         first null.
1923      */
1924     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1925         // Allocate space for `self` in memory, copy it there, and point ret at it
1926         assembly {
1927             let ptr := mload(0x40)
1928             mstore(0x40, add(ptr, 0x20))
1929             mstore(ptr, self)
1930             mstore(add(ret, 0x20), ptr)
1931         }
1932         ret._len = len(self);
1933     }
1934 
1935     /*
1936      * @dev Returns a new slice containing the same data as the current slice.
1937      * @param self The slice to copy.
1938      * @return A new slice containing the same data as `self`.
1939      */
1940     function copy(slice memory self) internal pure returns (slice memory) {
1941         return slice(self._len, self._ptr);
1942     }
1943 
1944     /*
1945      * @dev Copies a slice to a new string.
1946      * @param self The slice to copy.
1947      * @return A newly allocated string containing the slice's text.
1948      */
1949     function toString(slice memory self) internal pure returns (string memory) {
1950         string memory ret = new string(self._len);
1951         uint retptr;
1952         assembly { retptr := add(ret, 32) }
1953 
1954         memcpy(retptr, self._ptr, self._len);
1955         return ret;
1956     }
1957 
1958     /*
1959      * @dev Returns the length in runes of the slice. Note that this operation
1960      *      takes time proportional to the length of the slice; avoid using it
1961      *      in loops, and call `slice.empty()` if you only need to know whether
1962      *      the slice is empty or not.
1963      * @param self The slice to operate on.
1964      * @return The length of the slice in runes.
1965      */
1966     function len(slice memory self) internal pure returns (uint l) {
1967         // Starting at ptr-31 means the LSB will be the byte we care about
1968         uint ptr = self._ptr - 31;
1969         uint end = ptr + self._len;
1970         for (l = 0; ptr < end; l++) {
1971             uint8 b;
1972             assembly { b := and(mload(ptr), 0xFF) }
1973             if (b < 0x80) {
1974                 ptr += 1;
1975             } else if(b < 0xE0) {
1976                 ptr += 2;
1977             } else if(b < 0xF0) {
1978                 ptr += 3;
1979             } else if(b < 0xF8) {
1980                 ptr += 4;
1981             } else if(b < 0xFC) {
1982                 ptr += 5;
1983             } else {
1984                 ptr += 6;
1985             }
1986         }
1987     }
1988 
1989     /*
1990      * @dev Returns true if the slice is empty (has a length of 0).
1991      * @param self The slice to operate on.
1992      * @return True if the slice is empty, False otherwise.
1993      */
1994     function empty(slice memory self) internal pure returns (bool) {
1995         return self._len == 0;
1996     }
1997 
1998     /*
1999      * @dev Returns a positive number if `other` comes lexicographically after
2000      *      `self`, a negative number if it comes before, or zero if the
2001      *      contents of the two slices are equal. Comparison is done per-rune,
2002      *      on unicode codepoints.
2003      * @param self The first slice to compare.
2004      * @param other The second slice to compare.
2005      * @return The result of the comparison.
2006      */
2007     function compare(slice memory self, slice memory other) internal pure returns (int) {
2008         uint shortest = self._len;
2009         if (other._len < self._len)
2010             shortest = other._len;
2011 
2012         uint selfptr = self._ptr;
2013         uint otherptr = other._ptr;
2014         for (uint idx = 0; idx < shortest; idx += 32) {
2015             uint a;
2016             uint b;
2017             assembly {
2018                 a := mload(selfptr)
2019                 b := mload(otherptr)
2020             }
2021             if (a != b) {
2022                 // Mask out irrelevant bytes and check again
2023                 uint256 mask = uint256(-1); // 0xffff...
2024                 if(shortest < 32) {
2025                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
2026                 }
2027                 uint256 diff = (a & mask) - (b & mask);
2028                 if (diff != 0)
2029                     return int(diff);
2030             }
2031             selfptr += 32;
2032             otherptr += 32;
2033         }
2034         return int(self._len) - int(other._len);
2035     }
2036 
2037     /*
2038      * @dev Returns true if the two slices contain the same text.
2039      * @param self The first slice to compare.
2040      * @param self The second slice to compare.
2041      * @return True if the slices are equal, false otherwise.
2042      */
2043     function equals(slice memory self, slice memory other) internal pure returns (bool) {
2044         return compare(self, other) == 0;
2045     }
2046 
2047     /*
2048      * @dev Extracts the first rune in the slice into `rune`, advancing the
2049      *      slice to point to the next rune and returning `self`.
2050      * @param self The slice to operate on.
2051      * @param rune The slice that will contain the first rune.
2052      * @return `rune`.
2053      */
2054     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
2055         rune._ptr = self._ptr;
2056 
2057         if (self._len == 0) {
2058             rune._len = 0;
2059             return rune;
2060         }
2061 
2062         uint l;
2063         uint b;
2064         // Load the first byte of the rune into the LSBs of b
2065         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
2066         if (b < 0x80) {
2067             l = 1;
2068         } else if(b < 0xE0) {
2069             l = 2;
2070         } else if(b < 0xF0) {
2071             l = 3;
2072         } else {
2073             l = 4;
2074         }
2075 
2076         // Check for truncated codepoints
2077         if (l > self._len) {
2078             rune._len = self._len;
2079             self._ptr += self._len;
2080             self._len = 0;
2081             return rune;
2082         }
2083 
2084         self._ptr += l;
2085         self._len -= l;
2086         rune._len = l;
2087         return rune;
2088     }
2089 
2090     /*
2091      * @dev Returns the first rune in the slice, advancing the slice to point
2092      *      to the next rune.
2093      * @param self The slice to operate on.
2094      * @return A slice containing only the first rune from `self`.
2095      */
2096     function nextRune(slice memory self) internal pure returns (slice memory ret) {
2097         nextRune(self, ret);
2098     }
2099 
2100     /*
2101      * @dev Returns the number of the first codepoint in the slice.
2102      * @param self The slice to operate on.
2103      * @return The number of the first codepoint in the slice.
2104      */
2105     function ord(slice memory self) internal pure returns (uint ret) {
2106         if (self._len == 0) {
2107             return 0;
2108         }
2109 
2110         uint word;
2111         uint length;
2112         uint divisor = 2 ** 248;
2113 
2114         // Load the rune into the MSBs of b
2115         assembly { word:= mload(mload(add(self, 32))) }
2116         uint b = word / divisor;
2117         if (b < 0x80) {
2118             ret = b;
2119             length = 1;
2120         } else if(b < 0xE0) {
2121             ret = b & 0x1F;
2122             length = 2;
2123         } else if(b < 0xF0) {
2124             ret = b & 0x0F;
2125             length = 3;
2126         } else {
2127             ret = b & 0x07;
2128             length = 4;
2129         }
2130 
2131         // Check for truncated codepoints
2132         if (length > self._len) {
2133             return 0;
2134         }
2135 
2136         for (uint i = 1; i < length; i++) {
2137             divisor = divisor / 256;
2138             b = (word / divisor) & 0xFF;
2139             if (b & 0xC0 != 0x80) {
2140                 // Invalid UTF-8 sequence
2141                 return 0;
2142             }
2143             ret = (ret * 64) | (b & 0x3F);
2144         }
2145 
2146         return ret;
2147     }
2148 
2149     /*
2150      * @dev Returns the keccak-256 hash of the slice.
2151      * @param self The slice to hash.
2152      * @return The hash of the slice.
2153      */
2154     function keccak(slice memory self) internal pure returns (bytes32 ret) {
2155         assembly {
2156             ret := keccak256(mload(add(self, 32)), mload(self))
2157         }
2158     }
2159 
2160     /*
2161      * @dev Returns true if `self` starts with `needle`.
2162      * @param self The slice to operate on.
2163      * @param needle The slice to search for.
2164      * @return True if the slice starts with the provided text, false otherwise.
2165      */
2166     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
2167         if (self._len < needle._len) {
2168             return false;
2169         }
2170 
2171         if (self._ptr == needle._ptr) {
2172             return true;
2173         }
2174 
2175         bool equal;
2176         assembly {
2177             let length := mload(needle)
2178             let selfptr := mload(add(self, 0x20))
2179             let needleptr := mload(add(needle, 0x20))
2180             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2181         }
2182         return equal;
2183     }
2184 
2185     /*
2186      * @dev If `self` starts with `needle`, `needle` is removed from the
2187      *      beginning of `self`. Otherwise, `self` is unmodified.
2188      * @param self The slice to operate on.
2189      * @param needle The slice to search for.
2190      * @return `self`
2191      */
2192     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
2193         if (self._len < needle._len) {
2194             return self;
2195         }
2196 
2197         bool equal = true;
2198         if (self._ptr != needle._ptr) {
2199             assembly {
2200                 let length := mload(needle)
2201                 let selfptr := mload(add(self, 0x20))
2202                 let needleptr := mload(add(needle, 0x20))
2203                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2204             }
2205         }
2206 
2207         if (equal) {
2208             self._len -= needle._len;
2209             self._ptr += needle._len;
2210         }
2211 
2212         return self;
2213     }
2214 
2215     /*
2216      * @dev Returns true if the slice ends with `needle`.
2217      * @param self The slice to operate on.
2218      * @param needle The slice to search for.
2219      * @return True if the slice starts with the provided text, false otherwise.
2220      */
2221     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
2222         if (self._len < needle._len) {
2223             return false;
2224         }
2225 
2226         uint selfptr = self._ptr + self._len - needle._len;
2227 
2228         if (selfptr == needle._ptr) {
2229             return true;
2230         }
2231 
2232         bool equal;
2233         assembly {
2234             let length := mload(needle)
2235             let needleptr := mload(add(needle, 0x20))
2236             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2237         }
2238 
2239         return equal;
2240     }
2241 
2242     /*
2243      * @dev If `self` ends with `needle`, `needle` is removed from the
2244      *      end of `self`. Otherwise, `self` is unmodified.
2245      * @param self The slice to operate on.
2246      * @param needle The slice to search for.
2247      * @return `self`
2248      */
2249     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
2250         if (self._len < needle._len) {
2251             return self;
2252         }
2253 
2254         uint selfptr = self._ptr + self._len - needle._len;
2255         bool equal = true;
2256         if (selfptr != needle._ptr) {
2257             assembly {
2258                 let length := mload(needle)
2259                 let needleptr := mload(add(needle, 0x20))
2260                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
2261             }
2262         }
2263 
2264         if (equal) {
2265             self._len -= needle._len;
2266         }
2267 
2268         return self;
2269     }
2270 
2271     // Returns the memory address of the first byte of the first occurrence of
2272     // `needle` in `self`, or the first byte after `self` if not found.
2273     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
2274         uint ptr = selfptr;
2275         uint idx;
2276 
2277         if (needlelen <= selflen) {
2278             if (needlelen <= 32) {
2279                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
2280 
2281                 bytes32 needledata;
2282                 assembly { needledata := and(mload(needleptr), mask) }
2283 
2284                 uint end = selfptr + selflen - needlelen;
2285                 bytes32 ptrdata;
2286                 assembly { ptrdata := and(mload(ptr), mask) }
2287 
2288                 while (ptrdata != needledata) {
2289                     if (ptr >= end)
2290                         return selfptr + selflen;
2291                     ptr++;
2292                     assembly { ptrdata := and(mload(ptr), mask) }
2293                 }
2294                 return ptr;
2295             } else {
2296                 // For long needles, use hashing
2297                 bytes32 hash;
2298                 assembly { hash := keccak256(needleptr, needlelen) }
2299 
2300                 for (idx = 0; idx <= selflen - needlelen; idx++) {
2301                     bytes32 testHash;
2302                     assembly { testHash := keccak256(ptr, needlelen) }
2303                     if (hash == testHash)
2304                         return ptr;
2305                     ptr += 1;
2306                 }
2307             }
2308         }
2309         return selfptr + selflen;
2310     }
2311 
2312     // Returns the memory address of the first byte after the last occurrence of
2313     // `needle` in `self`, or the address of `self` if not found.
2314     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
2315         uint ptr;
2316 
2317         if (needlelen <= selflen) {
2318             if (needlelen <= 32) {
2319                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
2320 
2321                 bytes32 needledata;
2322                 assembly { needledata := and(mload(needleptr), mask) }
2323 
2324                 ptr = selfptr + selflen - needlelen;
2325                 bytes32 ptrdata;
2326                 assembly { ptrdata := and(mload(ptr), mask) }
2327 
2328                 while (ptrdata != needledata) {
2329                     if (ptr <= selfptr)
2330                         return selfptr;
2331                     ptr--;
2332                     assembly { ptrdata := and(mload(ptr), mask) }
2333                 }
2334                 return ptr + needlelen;
2335             } else {
2336                 // For long needles, use hashing
2337                 bytes32 hash;
2338                 assembly { hash := keccak256(needleptr, needlelen) }
2339                 ptr = selfptr + (selflen - needlelen);
2340                 while (ptr >= selfptr) {
2341                     bytes32 testHash;
2342                     assembly { testHash := keccak256(ptr, needlelen) }
2343                     if (hash == testHash)
2344                         return ptr + needlelen;
2345                     ptr -= 1;
2346                 }
2347             }
2348         }
2349         return selfptr;
2350     }
2351 
2352     /*
2353      * @dev Modifies `self` to contain everything from the first occurrence of
2354      *      `needle` to the end of the slice. `self` is set to the empty slice
2355      *      if `needle` is not found.
2356      * @param self The slice to search and modify.
2357      * @param needle The text to search for.
2358      * @return `self`.
2359      */
2360     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
2361         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2362         self._len -= ptr - self._ptr;
2363         self._ptr = ptr;
2364         return self;
2365     }
2366 
2367     /*
2368      * @dev Modifies `self` to contain the part of the string from the start of
2369      *      `self` to the end of the first occurrence of `needle`. If `needle`
2370      *      is not found, `self` is set to the empty slice.
2371      * @param self The slice to search and modify.
2372      * @param needle The text to search for.
2373      * @return `self`.
2374      */
2375     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
2376         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2377         self._len = ptr - self._ptr;
2378         return self;
2379     }
2380 
2381     /*
2382      * @dev Splits the slice, setting `self` to everything after the first
2383      *      occurrence of `needle`, and `token` to everything before it. If
2384      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2385      *      and `token` is set to the entirety of `self`.
2386      * @param self The slice to split.
2387      * @param needle The text to search for in `self`.
2388      * @param token An output parameter to which the first token is written.
2389      * @return `token`.
2390      */
2391     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2392         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
2393         token._ptr = self._ptr;
2394         token._len = ptr - self._ptr;
2395         if (ptr == self._ptr + self._len) {
2396             // Not found
2397             self._len = 0;
2398         } else {
2399             self._len -= token._len + needle._len;
2400             self._ptr = ptr + needle._len;
2401         }
2402         return token;
2403     }
2404 
2405     /*
2406      * @dev Splits the slice, setting `self` to everything after the first
2407      *      occurrence of `needle`, and returning everything before it. If
2408      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2409      *      and the entirety of `self` is returned.
2410      * @param self The slice to split.
2411      * @param needle The text to search for in `self`.
2412      * @return The part of `self` up to the first occurrence of `delim`.
2413      */
2414     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2415         split(self, needle, token);
2416     }
2417 
2418     /*
2419      * @dev Splits the slice, setting `self` to everything before the last
2420      *      occurrence of `needle`, and `token` to everything after it. If
2421      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2422      *      and `token` is set to the entirety of `self`.
2423      * @param self The slice to split.
2424      * @param needle The text to search for in `self`.
2425      * @param token An output parameter to which the first token is written.
2426      * @return `token`.
2427      */
2428     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
2429         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
2430         token._ptr = ptr;
2431         token._len = self._len - (ptr - self._ptr);
2432         if (ptr == self._ptr) {
2433             // Not found
2434             self._len = 0;
2435         } else {
2436             self._len -= token._len + needle._len;
2437         }
2438         return token;
2439     }
2440 
2441     /*
2442      * @dev Splits the slice, setting `self` to everything before the last
2443      *      occurrence of `needle`, and returning everything after it. If
2444      *      `needle` does not occur in `self`, `self` is set to the empty slice,
2445      *      and the entirety of `self` is returned.
2446      * @param self The slice to split.
2447      * @param needle The text to search for in `self`.
2448      * @return The part of `self` after the last occurrence of `delim`.
2449      */
2450     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
2451         rsplit(self, needle, token);
2452     }
2453 
2454     /*
2455      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
2456      * @param self The slice to search.
2457      * @param needle The text to search for in `self`.
2458      * @return The number of occurrences of `needle` found in `self`.
2459      */
2460     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
2461         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
2462         while (ptr <= self._ptr + self._len) {
2463             cnt++;
2464             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
2465         }
2466     }
2467 
2468     /*
2469      * @dev Returns True if `self` contains `needle`.
2470      * @param self The slice to search.
2471      * @param needle The text to search for in `self`.
2472      * @return True if `needle` is found in `self`, false otherwise.
2473      */
2474     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
2475         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
2476     }
2477 
2478     /*
2479      * @dev Returns a newly allocated string containing the concatenation of
2480      *      `self` and `other`.
2481      * @param self The first slice to concatenate.
2482      * @param other The second slice to concatenate.
2483      * @return The concatenation of the two strings.
2484      */
2485     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
2486         string memory ret = new string(self._len + other._len);
2487         uint retptr;
2488         assembly { retptr := add(ret, 32) }
2489         memcpy(retptr, self._ptr, self._len);
2490         memcpy(retptr + self._len, other._ptr, other._len);
2491         return ret;
2492     }
2493 
2494     /*
2495      * @dev Joins an array of slices, using `self` as a delimiter, returning a
2496      *      newly allocated string.
2497      * @param self The delimiter to use.
2498      * @param parts A list of slices to join.
2499      * @return A newly allocated string containing all the slices in `parts`,
2500      *         joined with `self`.
2501      */
2502     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
2503         if (parts.length == 0)
2504             return "";
2505 
2506         uint length = self._len * (parts.length - 1);
2507         for(uint i = 0; i < parts.length; i++)
2508             length += parts[i]._len;
2509 
2510         string memory ret = new string(length);
2511         uint retptr;
2512         assembly { retptr := add(ret, 32) }
2513 
2514         for(i = 0; i < parts.length; i++) {
2515             memcpy(retptr, parts[i]._ptr, parts[i]._len);
2516             retptr += parts[i]._len;
2517             if (i < parts.length - 1) {
2518                 memcpy(retptr, self._ptr, self._len);
2519                 retptr += self._len;
2520             }
2521         }
2522 
2523         return ret;
2524     }
2525 }
2526 
2527 // File: contracts/crowdsale/MultiCurrencyRates.sol
2528 
2529 /**
2530  * @title MultiCurrencyRates
2531  * @dev MultiCurrencyRates
2532  */
2533 // solium-disable-next-line max-len
2534 contract MultiCurrencyRates is usingOraclize, Ownable {
2535   using SafeMath for uint256;
2536   using strings for *;
2537 
2538   FiatContractInterface public fiatContract;
2539 
2540   /**
2541    * @param _fiatContract Address of fiatContract
2542    */
2543 
2544   constructor(address _fiatContract) public {
2545     require(_fiatContract != address(0));
2546     fiatContract = FiatContractInterface(_fiatContract);
2547   }
2548 
2549   /**
2550   * @dev Set fiat contract
2551   * @param _fiatContract Address of new fiatContract
2552   */
2553   function setFiatContract(address _fiatContract) public onlyOwner {
2554     fiatContract = FiatContractInterface(_fiatContract);
2555   }
2556 
2557   /**
2558   * @dev Returns the current 0.01$ => ETH wei rate
2559   */
2560   function getUSDCentToWeiRate() internal view returns (uint256) {
2561     return fiatContract.USD(0);
2562   }
2563 
2564   /**
2565   * @dev Returns the current 0.01$ => BTC satoshi rate
2566   */
2567   function getUSDCentToBTCSatoshiRate() internal view returns (uint256) {
2568     return fiatContract.USD(1);
2569   }
2570 
2571   /**
2572   * @dev Returns the current 0.01$ => LTC satoshi rate
2573   */
2574   function getUSDCentToLTCSatoshiRate() internal view returns (uint256) {
2575     return fiatContract.USD(2);
2576   }
2577 
2578   /**
2579   * @dev Returns the current BNB => 0.01$ rate
2580   */
2581   function getBNBToUSDCentRate(string oraclizeResult) internal pure returns (uint256) {
2582     return parseInt(parseCurrencyRate(oraclizeResult, "BNB"), 2);
2583   }
2584 
2585   /**
2586   * @dev Returns the current BCH => 0.01$ rate
2587   */
2588   function getBCHToUSDCentRate(string oraclizeResult) internal pure returns (uint256) {
2589     return parseInt(parseCurrencyRate(oraclizeResult, "BCH"), 2);
2590   }
2591 
2592   /**
2593    * @dev Parse currency rate from oraclize response
2594    * @param oraclizeResult Result from Oraclize with currencies prices
2595    * @param _currencyTicker Currency tiker
2596    * @return Currency price string in USD
2597    */
2598   function parseCurrencyRate(string oraclizeResult, string _currencyTicker) internal pure returns(string) {
2599     strings.slice memory response = oraclizeResult.toSlice();
2600     strings.slice memory needle = _currencyTicker.toSlice();
2601     strings.slice memory tickerPrice = response.find(needle).split("}".toSlice()).find(" ".toSlice()).rsplit(" ".toSlice());
2602     return tickerPrice.toString();
2603   }
2604 
2605 }
2606 
2607 // File: contracts/crowdsale/PhaseCrowdsaleInterface.sol
2608 
2609 /**
2610  * @title PhaseCrowdsaleInterface
2611  * @dev PhaseCrowdsaleInterface
2612  */
2613 contract PhaseCrowdsaleInterface {
2614      
2615   /**
2616   * @dev Get phase number depending on the current time
2617   */
2618   function getPhaseNumber() public view returns (uint256);
2619 
2620   /**
2621   * @dev Returns the current token price in $ cents depending on the current time
2622   */
2623   function getCurrentTokenPriceInCents() public view returns (uint256);
2624 
2625   /**
2626   * @dev Returns the token sale bonus percentage depending on the current time
2627   */
2628   function getCurrentBonusPercentage() public view returns (uint256);
2629 }
2630 
2631 // File: contracts/crowdsale/CryptonityCrowdsale.sol
2632 
2633 /**
2634  * @title CryptonityCrowdsale
2635  * @dev CryptonityCrowdsale
2636  */
2637 // solium-disable-next-line max-len
2638 contract CryptonityCrowdsale is TimedCrowdsale, WhitelistedCrowdsale, RefundableCrowdsale, PostDeliveryCrowdsale, MultiCurrencyRates, Pausable {
2639   using SafeMath for uint256;
2640   OraclizeContractInterface public oraclizeContract;
2641   PhaseCrowdsaleInterface public phaseCrowdsale;
2642   // Public supply of token
2643   uint256 public publicSupply = 60000000 * 1 ether;
2644   // Remaining public supply of token for each phase
2645   uint256[3] public remainingPublicSupplyPerPhase = [15000000 * 1 ether, 26000000 * 1 ether, 19000000 * 1 ether];
2646   // When tokens will be available for withdraw
2647   uint256 public deliveryTime;
2648   // A limit for total contributions in USD cents
2649   uint256 public cap;
2650   // Is goal reached
2651   bool public isGoalReached = false;
2652 
2653   event LogInfo(string description);
2654 
2655   /**
2656    * @param _phasesTime Crowdsale phases time [openingTime, closingTime, secondPhaseStartTime, thirdPhaseStartTime]
2657    * @param _rate Number of token units a buyer gets per wei
2658    * @param _wallet Address where collected funds will be forwarded to
2659    * @param _token Address of the token being sold
2660    * @param _softCapUSDInCents Funding goal in USD cents
2661    * @param _hardCapUSDInCents Max amount of USD cents to be contributed
2662    * @param _fiatContract FiatContract
2663    * @param _phaseCrowdsale info about current phase
2664    * @param _oraclizeContract oraclize contract
2665    */
2666   constructor(
2667     uint256[4] _phasesTime,
2668     uint256 _rate,
2669     address _wallet,
2670     ERC20 _token,
2671     uint256 _softCapUSDInCents,
2672     uint256 _hardCapUSDInCents,
2673     address _fiatContract,
2674     address _phaseCrowdsale,
2675     address _oraclizeContract
2676   )
2677     public
2678     Crowdsale(_rate, _wallet, _token)
2679     RefundableCrowdsale(_softCapUSDInCents)
2680     TimedCrowdsale(_phasesTime[0], _phasesTime[1])
2681     MultiCurrencyRates(_fiatContract)
2682   {
2683 
2684     require(_phasesTime[2] >= _phasesTime[0]);
2685     require(_phasesTime[3] >= _phasesTime[2]);
2686     require(_phasesTime[1] >= _phasesTime[3]);
2687     require(_hardCapUSDInCents > 0);
2688     require(_softCapUSDInCents <= _hardCapUSDInCents);
2689     cap = _hardCapUSDInCents;
2690     // token delivery starts 15 days after the crowdsale ends
2691     deliveryTime = _phasesTime[1].add(15 days);
2692     oraclizeContract = OraclizeContractInterface(_oraclizeContract);
2693     phaseCrowdsale = PhaseCrowdsaleInterface(_phaseCrowdsale);
2694 
2695   }
2696 
2697   /**
2698    * @dev Reverts if crowdsale is not finalized
2699    */
2700   modifier whenFinalized {
2701     require(isFinalized);
2702     _;
2703   }
2704 
2705   /**
2706    * @dev Reverts if caller isn't oraclizeContract
2707    */
2708   modifier onlyOraclize {
2709     require(msg.sender == address(oraclizeContract));
2710     _;
2711   }
2712 
2713   /**
2714    * @dev Get multi currency investor contribution.
2715    * @param _currencyWallet Address of currency wallet
2716    * @return Amount of currency contribution
2717    */
2718   function getMultiCurrencyInvestorContribution(string _currencyWallet) public view returns(uint256) {
2719     return  oraclizeContract.getMultiCurrencyInvestorContribution(_currencyWallet);
2720   }
2721 
2722   /**
2723    * @dev Calculates the sum amount of tokens which were unsold or remaining during all crowdsale phases.
2724    * @return The total amount of unsold tokens
2725    */
2726   function calculateTotalRemainingPublicSupply() private view returns (uint256) {
2727     uint256 totalRemainingPublicSupply = 0;
2728     for (uint i = 0; i < remainingPublicSupplyPerPhase.length; i++) {
2729       totalRemainingPublicSupply = totalRemainingPublicSupply.add(remainingPublicSupplyPerPhase[i]);
2730     }
2731     return totalRemainingPublicSupply;
2732   }
2733 
2734   /**
2735    * @dev Validation of an incoming purchase. Allowas purchases only when crowdsale is not paused.
2736    * @param _beneficiary Address performing the token purchase
2737    * @param _weiAmount Value in wei involved in the purchase
2738    */
2739   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal whenNotPaused {
2740     super._preValidatePurchase(_beneficiary, _weiAmount);
2741     rate = uint256(1 ether).mul(1 ether).div(getUSDCentToWeiRate()).div(phaseCrowdsale.getCurrentTokenPriceInCents());
2742   }
2743   /**
2744    * @dev Executed by oraclize when a purchase has been validated and is ready to be executed.
2745    * It computes the bonus.
2746    * @param _beneficiary Address receiving the tokens
2747    * @param _tokenAmount Number of tokens to be purchased
2748    */
2749   function processPurchase(address _beneficiary, uint256 _tokenAmount) public onlyOraclize onlyWhileOpen isWhitelisted(_beneficiary) {
2750     _processPurchase(_beneficiary, _tokenAmount);
2751   }
2752 
2753   /**
2754    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
2755    * It computes the bonus.
2756    * @param _beneficiary Address receiving the tokens
2757    * @param _tokenAmount Number of tokens to be purchased
2758    */
2759   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
2760     uint256 totalAmount = _tokenAmount;
2761     uint256 bonusPercent = phaseCrowdsale.getCurrentBonusPercentage();
2762 
2763     if (bonusPercent > 0) {
2764       uint256 bonusAmount = totalAmount.mul(bonusPercent).div(100); // tokens * bonus (%) / 100%
2765       totalAmount = totalAmount.add(bonusAmount);
2766     }
2767     uint256 phaseNumber = phaseCrowdsale.getPhaseNumber();
2768     require(remainingPublicSupplyPerPhase[phaseNumber] >= totalAmount);
2769     super._processPurchase(_beneficiary, totalAmount);
2770     remainingPublicSupplyPerPhase[phaseNumber] = remainingPublicSupplyPerPhase[phaseNumber].sub(totalAmount);
2771   }
2772 
2773   /**
2774   * @dev Withdraw tokens only after the deliveryTime
2775   */
2776   function withdrawTokens() public whenFinalized {
2777     require(isGoalReached);
2778     // solium-disable-next-line security/no-block-members
2779     require(now > deliveryTime);
2780     super.withdrawTokens();
2781   }
2782 
2783   /**
2784    * @dev Investors can claim refunds here if crowdsale is unsuccessful
2785    */
2786   function claimRefund() public whenFinalized {
2787     require(!isGoalReached);
2788     vault.refund(msg.sender);
2789   }
2790 
2791   /**
2792    * @dev Token purchase with LTC
2793    * @param _ethWallet Address receiving the tokens
2794    * @param _ltcWallet LTC address who paid for the tokens
2795    * @param _ltcAmount Value in LTC involved in the purchase
2796    */
2797   function buyTokensWithLTC(address _ethWallet, string _ltcWallet, uint256 _ltcAmount) public onlyOwner {
2798     oraclizeContract.buyTokensWithLTC(_ethWallet, _ltcWallet, _ltcAmount);
2799   }
2800 
2801   /**
2802    * @dev Token purchase with BTC
2803    * @param _ethWallet Address receiving the tokens
2804    * @param _btcWallet BTC address who paid for the tokens
2805    * @param _btcAmount Value in BTC involved in the purchase
2806    */
2807   function buyTokensWithBTC(address _ethWallet, string _btcWallet, uint256 _btcAmount) public onlyOwner {
2808     oraclizeContract.buyTokensWithBTC(_ethWallet, _btcWallet, _btcAmount);
2809   }
2810 
2811   /**
2812    * @dev Token purchase with BNB
2813    * @param _ethWallet Address receiving the tokens
2814    * @param _bnbWallet BNB address who paid for the tokens
2815    * @param _bnbAmount Value in BNB involved in the purchase
2816    */
2817   function buyTokensWithBNB(address _ethWallet, string _bnbWallet, uint256 _bnbAmount) public payable onlyOwner {
2818     oraclizeContract.buyTokensWithBNB.value(msg.value)(_ethWallet, _bnbWallet, _bnbAmount);
2819   }
2820 
2821   /**
2822    * @dev Token purchase with BCH
2823    * @param _ethWallet Address receiving the tokens
2824    * @param _bchWallet BCH address who paid for the tokens
2825    * @param _bchAmount Value in BCH involved in the purchase
2826    */
2827   function buyTokensWithBCH(address _ethWallet, string _bchWallet, uint256 _bchAmount) public payable onlyOwner {
2828     oraclizeContract.buyTokensWithBCH.value(msg.value)(_ethWallet, _bchWallet, _bchAmount);
2829   }
2830 
2831   /**
2832   * @dev The way in which ether is converted to tokens.
2833   * @param _weiAmount Value in wei to be converted into tokens
2834   * @return Number of tokens that can be purchased with the specified _weiAmount
2835   */
2836   function _getTokenAmount(uint256 _weiAmount)
2837     internal view returns (uint256)
2838   {
2839     return _weiAmount.mul(rate).div(1 ether); // divisor 10^18 to nullify multiplier from _calculateCurrentRate
2840   }
2841 
2842   /**
2843    * @dev Finalization logic.
2844    * Burn the remaining tokens.
2845    * Transfer token ownership to contract owner.
2846    */
2847   function finalization() internal {
2848     oraclizeContract.finalize();
2849   }
2850 
2851   /**
2852    * @dev Executed by oraclize when multicurrency finalization is calculated
2853    * @param _usdRaised usdCent reised with multicurrency
2854    */
2855   function finalizationCallback(uint256 _usdRaised) public onlyOraclize {
2856     uint256 usdRaised = weiRaised.div(getUSDCentToWeiRate()).add(_usdRaised);
2857     if(usdRaised >= goal) {
2858       emit LogInfo("Finalization completed");
2859       isGoalReached = true;
2860       vault.close();
2861     } else {
2862       emit LogInfo("Finalization failed");
2863       vault.enableRefunds();
2864     }
2865     uint256 totalRemainingPublicSupply = calculateTotalRemainingPublicSupply();
2866     if (totalRemainingPublicSupply > 0) {
2867       BurnableTokenInterface(address(token)).burn(totalRemainingPublicSupply);
2868       delete remainingPublicSupplyPerPhase;
2869     }
2870     Ownable(address(token)).transferOwnership(owner);
2871   }
2872 }