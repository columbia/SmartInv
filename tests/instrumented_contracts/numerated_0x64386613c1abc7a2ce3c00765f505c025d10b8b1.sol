1 pragma solidity ^0.4.17;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 
35 /**
36  * @title Ownable
37  * @dev The Ownable contract has an owner address, and provides basic authorization control
38  * functions, this simplifies the implementation of "user permissions".
39  */
40 contract Ownable {
41   address public owner;
42 
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   function Ownable() {
52     owner = msg.sender;
53   }
54 
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) onlyOwner public {
70     require(newOwner != address(0));
71     OwnershipTransferred(owner, newOwner);
72     owner = newOwner;
73   }
74 
75 }
76 
77 /**
78  * @title ERC20
79  * @dev ERC20 interface
80  */
81 contract ERC20 {
82     function balanceOf(address who) public constant returns (uint256);
83     function transfer(address to, uint256 value) public returns (bool);
84     function allowance(address owner, address spender) public constant returns (uint256);
85     function transferFrom(address from, address to, uint256 value) public returns (bool);
86     function approve(address spender, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 
93 
94 
95 
96 
97 contract Controlled {
98     /// @notice The address of the controller is the only address that can call
99     ///  a function with this modifier
100     modifier onlyController { require(msg.sender == controller); _; }
101 
102     address public controller;
103 
104     function Controlled() public { controller = msg.sender;}
105 
106     /// @notice Changes the controller of the contract
107     /// @param _newController The new controller of the contract
108     function changeController(address _newController) public onlyController {
109         controller = _newController;
110     }
111 }
112 
113 /**
114  * @title MiniMe interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20MiniMe is ERC20, Controlled {
118     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool);
119     function totalSupply() public constant returns (uint);
120     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint);
121     function totalSupplyAt(uint _blockNumber) public constant returns(uint);
122     function createCloneToken(string _cloneTokenName, uint8 _cloneDecimalUnits, string _cloneTokenSymbol, uint _snapshotBlock, bool _transfersEnabled) public returns(address);
123     function generateTokens(address _owner, uint _amount) public returns (bool);
124     function destroyTokens(address _owner, uint _amount)  public returns (bool);
125     function enableTransfers(bool _transfersEnabled) public;
126     function isContract(address _addr) constant internal returns(bool);
127     function claimTokens(address _token) public;
128     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
129     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
130 }
131 
132 
133 
134 
135 
136 
137 
138 
139 /**
140  * @title Crowdsale
141  * @dev Crowdsale is a base contract for managing a token crowdsale.
142  * Crowdsales have a start and end timestamps, where investors can make
143  * token purchases and the crowdsale will assign them tokens based
144  * on a token per ETH rate. Funds collected are forwarded to a wallet
145  * as they arrive.
146  */
147 contract Crowdsale {
148   using SafeMath for uint256;
149 
150   // The token being sold
151   ERC20MiniMe public token;
152 
153   // start and end timestamps where investments are allowed (both inclusive)
154   uint256 public startTime;
155   uint256 public endTime;
156 
157   // address where funds are collected
158   address public wallet;
159 
160   // how many token units a buyer gets per wei
161   uint256 public rate;
162 
163   // amount of raised money in wei
164   uint256 public weiRaised;
165 
166   /**
167    * event for token purchase logging
168    * @param purchaser who paid for the tokens
169    * @param beneficiary who got the tokens
170    * @param value weis paid for purchase
171    * @param amount amount of tokens purchased
172    */
173   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
174 
175 
176   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
177     require(_startTime >= now);
178     require(_endTime >= _startTime);
179     require(_rate > 0);
180     require(_wallet != 0x0);
181 
182     startTime = _startTime;
183     endTime = _endTime;
184     rate = _rate;
185     wallet = _wallet;
186   }
187 
188 
189   // fallback function can be used to buy tokens
190   function () payable {
191     buyTokens(msg.sender);
192   }
193 
194   // low level token purchase function
195   function buyTokens(address beneficiary) public payable {
196     buyTokens(beneficiary, msg.value);
197   }
198 
199   // implementation of low level token purchase function
200   function buyTokens(address beneficiary, uint256 weiAmount) internal {
201     require(beneficiary != 0x0);
202     require(validPurchase(weiAmount));
203 
204     transferToken(beneficiary, weiAmount);
205 
206     // update state
207     weiRaised = weiRaised.add(weiAmount);
208 
209     forwardFunds(weiAmount);
210   }
211 
212   // low level transfer token
213   // override to create custom token transfer mechanism, eg. pull pattern
214   function transferToken(address beneficiary, uint256 weiAmount) internal {
215     // calculate token amount to be created
216     uint256 tokens = weiAmount.mul(rate);
217 
218     token.generateTokens(beneficiary, tokens);
219 
220     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
221   }
222 
223   // send ether to the fund collection wallet
224   // override to create custom fund forwarding mechanisms
225   function forwardFunds(uint256 weiAmount) internal {
226     wallet.transfer(weiAmount);
227   }
228 
229   // @return true if the transaction can buy tokens
230   function validPurchase(uint256 weiAmount) internal constant returns (bool) {
231     bool withinPeriod = now >= startTime && now <= endTime;
232     bool nonZeroPurchase = weiAmount != 0;
233     return withinPeriod && nonZeroPurchase;
234   }
235 
236   // @return true if crowdsale event has ended
237   function hasEnded() public constant returns (bool) {
238     return now > endTime;
239   }
240 
241   // @return true if crowdsale has started
242   function hasStarted() public constant returns (bool) {
243     return now >= startTime;
244   }
245 }
246 
247 /**
248  * @title CappedCrowdsale
249  * @dev Extension of Crowdsale with a max amount of funds raised
250  */
251 contract CappedCrowdsale is Crowdsale {
252   using SafeMath for uint256;
253 
254   uint256 public cap;
255 
256   function CappedCrowdsale(uint256 _cap) {
257     require(_cap > 0);
258     cap = _cap;
259   }
260 
261   // overriding Crowdsale#validPurchase to add extra cap logic
262   // @return true if investors can buy at the moment
263   function validPurchase(uint256 weiAmount) internal constant returns (bool) {
264     return super.validPurchase(weiAmount) && !capReached();
265   }
266 
267   // overriding Crowdsale#hasEnded to add cap logic
268   // @return true if crowdsale event has ended
269   function hasEnded() public constant returns (bool) {
270     return super.hasEnded() || capReached();
271   }
272 
273   // @return true if cap has been reached
274   function capReached() internal constant returns (bool) {
275    return weiRaised >= cap;
276   }
277 
278   // overriding Crowdsale#buyTokens to add partial refund logic
279   function buyTokens(address beneficiary) public payable {
280      uint256 weiToCap = cap.sub(weiRaised);
281      uint256 weiAmount = weiToCap < msg.value ? weiToCap : msg.value;
282 
283      buyTokens(beneficiary, weiAmount);
284 
285      uint256 refund = msg.value.sub(weiAmount);
286      if (refund > 0) {
287        msg.sender.transfer(refund);
288      }
289    }
290 }
291 
292 
293 
294 
295 /// @dev The token controller contract must implement these functions
296 contract TokenController {
297     ERC20MiniMe public ethealToken;
298     address public SALE; // address where sale tokens are located
299 
300     /// @notice needed for hodler handling
301     function addHodlerStake(address _beneficiary, uint256 _stake) public;
302     function setHodlerStake(address _beneficiary, uint256 _stake) public;
303     function setHodlerTime(uint256 _time) public;
304 
305 
306     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
307     /// @param _owner The address that sent the ether to create tokens
308     /// @return True if the ether is accepted, false if it throws
309     function proxyPayment(address _owner) public payable returns(bool);
310 
311     /// @notice Notifies the controller about a token transfer allowing the
312     ///  controller to react if desired
313     /// @param _from The origin of the transfer
314     /// @param _to The destination of the transfer
315     /// @param _amount The amount of the transfer
316     /// @return False if the controller does not authorize the transfer
317     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
318 
319     /// @notice Notifies the controller about an approval allowing the
320     ///  controller to react if desired
321     /// @param _owner The address that calls `approve()`
322     /// @param _spender The spender in the `approve()` call
323     /// @param _amount The amount in the `approve()` call
324     /// @return False if the controller does not authorize the approval
325     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
326 }
327 
328 
329 
330 
331 
332 
333 /**
334  * @title FinalizableCrowdsale
335  * @dev Extension of Crowdsale where an owner can do extra work
336  * after finishing.
337  */
338 contract FinalizableCrowdsale is Crowdsale, Ownable {
339   using SafeMath for uint256;
340 
341   bool public isFinalized = false;
342 
343   event Finalized();
344 
345   /**
346    * @dev Must be called after crowdsale ends, to do some extra finalization
347    * work. Calls the contract's finalization function.
348    */
349   function finalize() onlyOwner public {
350     require(!isFinalized);
351     require(hasEnded());
352 
353     finalization();
354     Finalized();
355 
356     isFinalized = true;
357   }
358 
359   /**
360    * @dev Can be overridden to add finalization logic. The overriding function
361    * should call super.finalization() to ensure the chain of finalization is
362    * executed entirely.
363    */
364   function finalization() internal {
365   }
366 }
367 
368 
369 
370 
371 
372 
373 /**
374  * @title Pausable
375  * @dev Base contract which allows children to implement an emergency stop mechanism.
376  */
377 contract Pausable is Ownable {
378   event Pause();
379   event Unpause();
380 
381   bool public paused = false;
382 
383 
384   /**
385    * @dev Modifier to make a function callable only when the contract is not paused.
386    */
387   modifier whenNotPaused() {
388     require(!paused);
389     _;
390   }
391 
392   /**
393    * @dev Modifier to make a function callable only when the contract is paused.
394    */
395   modifier whenPaused() {
396     require(paused);
397     _;
398   }
399 
400   /**
401    * @dev called by the owner to pause, triggers stopped state
402    */
403   function pause() onlyOwner whenNotPaused public {
404     paused = true;
405     Pause();
406   }
407 
408   /**
409    * @dev called by the owner to unpause, returns to normal state
410    */
411   function unpause() onlyOwner whenPaused public {
412     paused = false;
413     Unpause();
414   }
415 }
416 
417 
418 
419 
420 
421 
422 /**
423  * @title Eliptic curve signature operations
424  *
425  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
426  */
427 
428 library ECRecovery {
429 
430   /**
431    * @dev Recover signer address from a message by using his signature
432    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
433    * @param sig bytes signature, the signature is generated using web3.eth.sign()
434    */
435   function recover(bytes32 hash, bytes sig) public pure returns (address) {
436     bytes32 r;
437     bytes32 s;
438     uint8 v;
439 
440     //Check the signature length
441     if (sig.length != 65) {
442       return (address(0));
443     }
444 
445     // Divide the signature in r, s and v variables
446     assembly {
447       r := mload(add(sig, 32))
448       s := mload(add(sig, 64))
449       v := byte(0, mload(add(sig, 96)))
450     }
451 
452     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
453     if (v < 27) {
454       v += 27;
455     }
456 
457     // If the version is correct return the signer address
458     if (v != 27 && v != 28) {
459       return (address(0));
460     } else {
461       return ecrecover(hash, v, r, s);
462     }
463   }
464 
465 }
466 
467 /**
468  * @title EthealWhitelist
469  * @author thesved
470  * @notice EthealWhitelist contract which handles KYC
471  */
472 contract EthealWhitelist is Ownable {
473     using ECRecovery for bytes32;
474 
475     // signer address for offchain whitelist signing
476     address public signer;
477 
478     // storing whitelisted addresses
479     mapping(address => bool) public isWhitelisted;
480 
481     event WhitelistSet(address indexed _address, bool _state);
482 
483     ////////////////
484     // Constructor
485     ////////////////
486     function EthealWhitelist(address _signer) {
487         require(_signer != address(0));
488 
489         signer = _signer;
490     }
491 
492     /// @notice set signing address after deployment
493     function setSigner(address _signer) public onlyOwner {
494         require(_signer != address(0));
495 
496         signer = _signer;
497     }
498 
499     ////////////////
500     // Whitelisting: only owner
501     ////////////////
502 
503     /// @notice Set whitelist state for an address.
504     function setWhitelist(address _addr, bool _state) public onlyOwner {
505         require(_addr != address(0));
506         isWhitelisted[_addr] = _state;
507         WhitelistSet(_addr, _state);
508     }
509 
510     /// @notice Set whitelist state for multiple addresses
511     function setManyWhitelist(address[] _addr, bool _state) public onlyOwner {
512         for (uint256 i = 0; i < _addr.length; i++) {
513             setWhitelist(_addr[i], _state);
514         }
515     }
516 
517     /// @notice offchain whitelist check
518     function isOffchainWhitelisted(address _addr, bytes _sig) public view returns (bool) {
519         bytes32 hash = keccak256("\x19Ethereum Signed Message:\n20",_addr);
520         return hash.recover(_sig) == signer;
521     }
522 }
523 
524 /**
525  * @title EthealNormalSale
526  * @author thesved
527  * @notice Etheal Token Sale contract, with softcap and hardcap (cap)
528  * @dev This contract has to be finalized before token claims are enabled
529  */
530 contract EthealNormalSale is Pausable, FinalizableCrowdsale, CappedCrowdsale {
531     // the token is here
532     TokenController public ethealController;
533 
534     // after reaching {weiRaised} >= {softCap}, there is {softCapTime} seconds until the sale closes
535     // {softCapClose} contains the closing time
536     uint256 public rate = 700;
537     uint256 public softCap = 6800 ether;
538     uint256 public softCapTime = 120 hours;
539     uint256 public softCapClose;
540     uint256 public cap = 14300 ether;
541 
542     // how many token is sold and not claimed, used for refunding to token controller
543     uint256 public tokenBalance;
544 
545     // total token sold
546     uint256 public tokenSold;
547 
548     // minimum contribution, 0.1ETH
549     uint256 public minContribution = 0.1 ether;
550 
551     // whitelist: above threshold the contract has to approve each transaction
552     EthealWhitelist public whitelist;
553     uint256 public whitelistThreshold = 1 ether;
554 
555     // deposit address from which it can get funds before sale
556     address public deposit;
557     
558     // stakes contains token bought and contirbutions contains the value in wei
559     mapping (address => uint256) public stakes;
560     mapping (address => uint256) public contributions;
561 
562     // promo token bonus
563     address public promoTokenController;
564     mapping (address => uint256) public bonusExtra;
565 
566     // addresses of contributors to handle finalization after token sale end (refunds or token claims)
567     address[] public contributorsKeys; 
568 
569     // events for token purchase during sale and claiming tokens after sale
570     event LogTokenClaimed(address indexed _claimer, address indexed _beneficiary, uint256 _amount);
571     event LogTokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount, uint256 _participants, uint256 _weiRaised);
572     event LogTokenSoftCapReached(uint256 _closeTime);
573     event LogTokenHardCapReached();
574 
575     ////////////////
576     // Constructor and inherited function overrides
577     ////////////////
578 
579     /// @notice Constructor to create PreSale contract
580     /// @param _ethealController Address of ethealController
581     /// @param _startTime The start time of token sale in seconds.
582     /// @param _endTime The end time of token sale in seconds.
583     /// @param _minContribution The minimum contribution per transaction in wei (0.1 ETH)
584     /// @param _rate Number of HEAL tokens per 1 ETH
585     /// @param _softCap Softcap in wei, reaching it ends the sale in _softCapTime seconds
586     /// @param _softCapTime Seconds until the sale remains open after reaching _softCap
587     /// @param _cap Maximum cap in wei, we can't raise more funds
588     /// @param _wallet Address of multisig wallet, which will get all the funds after successful sale
589     function EthealNormalSale(
590         address _ethealController,
591         uint256 _startTime, 
592         uint256 _endTime, 
593         uint256 _minContribution, 
594         uint256 _rate, 
595         uint256 _softCap, 
596         uint256 _softCapTime, 
597         uint256 _cap, 
598         address _wallet
599     )
600         CappedCrowdsale(_cap)
601         FinalizableCrowdsale()
602         Crowdsale(_startTime, _endTime, _rate, _wallet)
603     {
604         // ethealController must be valid
605         require(_ethealController != address(0));
606         ethealController = TokenController(_ethealController);
607 
608         // caps have to be consistent with each other
609         require(_softCap <= _cap);
610         softCap = _softCap;
611         softCapTime = _softCapTime;
612 
613         // this is needed since super constructor wont overwite overriden variables
614         cap = _cap;
615         rate = _rate;
616 
617         minContribution = _minContribution;
618     }
619 
620     ////////////////
621     // Administer contract details
622     ////////////////
623 
624     /// @notice Sets min contribution
625     function setMinContribution(uint256 _minContribution) public onlyOwner {
626         minContribution = _minContribution;
627     }
628 
629     /// @notice Sets soft cap and max cap
630     function setCaps(uint256 _softCap, uint256 _softCapTime, uint256 _cap) public onlyOwner {
631         require(_softCap <= _cap);
632         softCap = _softCap;
633         softCapTime = _softCapTime;
634         cap = _cap;
635     }
636 
637     /// @notice Sets crowdsale start and end time
638     function setTimes(uint256 _startTime, uint256 _endTime) public onlyOwner {
639         require(_startTime <= _endTime);
640         require(!hasEnded());
641         startTime = _startTime;
642         endTime = _endTime;
643     }
644 
645     /// @notice Set rate
646     function setRate(uint256 _rate) public onlyOwner {
647         require(_rate > 0);
648         rate = _rate;
649     }
650 
651     /// @notice Set address of promo token
652     function setPromoTokenController(address _addr) public onlyOwner {
653         require(_addr != address(0));
654         promoTokenController = _addr;
655     }
656 
657     /// @notice Set whitelist contract address and minimum threshold
658     function setWhitelist(address _whitelist, uint256 _threshold) public onlyOwner {
659         // if whitelist contract address is provided we set it
660         if (_whitelist != address(0)) {
661             whitelist = EthealWhitelist(_whitelist);
662         }
663         whitelistThreshold = _threshold;
664     }
665 
666     /// @notice Set deposit contract address from which it can receive money before sale
667     function setDeposit(address _deposit) public onlyOwner {
668         deposit = _deposit;
669     }
670 
671     /// @notice move excess tokens, eg to hodler/sale contract
672     function moveTokens(address _to, uint256 _amount) public onlyOwner {
673         require(_to != address(0));
674         require(_amount <= getHealBalance().sub(tokenBalance));
675         require(ethealController.ethealToken().transfer(_to, _amount));
676     }
677 
678     ////////////////
679     // Purchase functions
680     ////////////////
681 
682     /// @dev Overriding Crowdsale#buyTokens to add partial refund
683     /// @param _beneficiary Beneficiary of the token purchase
684     function buyTokens(address _beneficiary) public payable whenNotPaused {
685         handlePayment(_beneficiary, msg.value, now, "");
686     }
687 
688     /// @dev buying tokens for someone with offchain whitelist signature
689     function buyTokensSigned(address _beneficiary, bytes _whitelistSign) public payable whenNotPaused {
690         handlePayment(_beneficiary, msg.value, now, _whitelistSign);
691     }
692 
693     /// @dev Internal function for handling transactions with ether.
694     function handlePayment(address _beneficiary, uint256 _amount, uint256 _time, bytes memory _whitelistSign) internal {
695         require(_beneficiary != address(0));
696 
697         uint256 weiAmount = handleContribution(_beneficiary, _amount, _time, _whitelistSign);      
698         forwardFunds(weiAmount);  
699 
700         // handle refund excess tokens
701         uint256 refund = _amount.sub(weiAmount);
702         if (refund > 0) {
703             _beneficiary.transfer(refund);
704         }
705     }
706 
707     /// @dev Handling the amount of contribution and cap logic. Internal function.
708     /// @return Wei successfully contributed.
709     function handleContribution(address _beneficiary, uint256 _amount, uint256 _time, bytes memory _whitelistSign) internal returns (uint256) {
710         require(_beneficiary != address(0));
711 
712         uint256 weiToCap = howMuchCanXContributeNow(_beneficiary);
713         uint256 weiAmount = uint256Min(weiToCap, _amount);
714 
715         // account the new contribution
716         transferToken(_beneficiary, weiAmount, _time, _whitelistSign);
717 
718         // close sale in softCapTime seconds after reaching softCap
719         if (weiRaised >= softCap && softCapClose == 0) {
720             softCapClose = now.add(softCapTime);
721             LogTokenSoftCapReached(uint256Min(softCapClose, endTime));
722         }
723 
724         // event for hard cap reached
725         if (weiRaised >= cap) {
726             LogTokenHardCapReached();
727         }
728 
729         return weiAmount;
730     }
731 
732     /// @dev Handling token distribution and accounting. Overriding Crowdsale#transferToken.
733     /// @param _beneficiary Address of the recepient of the tokens
734     /// @param _weiAmount Contribution in wei
735     /// @param _time When the contribution was made
736     function transferToken(address _beneficiary, uint256 _weiAmount, uint256 _time, bytes memory _whitelistSign) internal {
737         require(_beneficiary != address(0));
738         require(validPurchase(_weiAmount));
739 
740         // increase wei Raised
741         weiRaised = weiRaised.add(_weiAmount);
742 
743         // require whitelist above threshold
744         contributions[_beneficiary] = contributions[_beneficiary].add(_weiAmount);
745         require(contributions[_beneficiary] <= whitelistThreshold 
746                 || whitelist.isWhitelisted(_beneficiary)
747                 || whitelist.isOffchainWhitelisted(_beneficiary, _whitelistSign)
748         );
749 
750         // calculate tokens, so we can refund excess tokens to EthealController after token sale
751         uint256 _bonus = getBonus(_beneficiary, _weiAmount, _time);
752         uint256 tokens = _weiAmount.mul(rate).mul(_bonus).div(100);
753         tokenBalance = tokenBalance.add(tokens);
754 
755         if (stakes[_beneficiary] == 0) {
756             contributorsKeys.push(_beneficiary);
757         }
758         stakes[_beneficiary] = stakes[_beneficiary].add(tokens);
759 
760         LogTokenPurchase(msg.sender, _beneficiary, _weiAmount, tokens, contributorsKeys.length, weiRaised);
761     }
762 
763     /// @dev Get eth deposit from Deposit contract
764     function depositEth(address _beneficiary, uint256 _time, bytes _whitelistSign) public payable whenNotPaused {
765         require(msg.sender == deposit);
766 
767         handlePayment(_beneficiary, msg.value, _time, _whitelistSign);
768     }
769 
770     /// @dev Deposit from other currencies
771     function depositOffchain(address _beneficiary, uint256 _amount, uint256 _time, bytes _whitelistSign) public onlyOwner whenNotPaused {
772         handleContribution(_beneficiary, _amount, _time, _whitelistSign);
773     }
774 
775     /// @dev Overriding Crowdsale#validPurchase to add min contribution logic
776     /// @param _weiAmount Contribution amount in wei
777     /// @return true if contribution is okay
778     function validPurchase(uint256 _weiAmount) internal constant returns (bool) {
779         bool nonEnded = !hasEnded();
780         bool nonZero = _weiAmount != 0;
781         bool enoughContribution = _weiAmount >= minContribution;
782         return nonEnded && nonZero && enoughContribution;
783     }
784 
785     /// @dev Overriding Crowdsale#hasEnded to add soft cap logic
786     /// @return true if crowdsale event has ended or a softCapClose time is set and passed
787     function hasEnded() public constant returns (bool) {
788         return super.hasEnded() || softCapClose > 0 && now > softCapClose;
789     }
790 
791     /// @dev Extending RefundableCrowdsale#finalization sending back excess tokens to ethealController
792     function finalization() internal {
793         uint256 _balance = getHealBalance();
794 
795         // saving token balance for future reference
796         tokenSold = tokenBalance; 
797 
798         // send back the excess token to ethealController
799         if (_balance > tokenBalance) {
800             ethealController.ethealToken().transfer(ethealController.SALE(), _balance.sub(tokenBalance));
801         }
802 
803         // hodler stake counting starts 14 days after closing normal sale
804         ethealController.setHodlerTime(now + 14 days);
805 
806         super.finalization();
807     }
808 
809 
810     ////////////////
811     // AFTER token sale
812     ////////////////
813 
814     /// @notice Modifier for after sale finalization
815     modifier afterSale() {
816         require(isFinalized);
817         _;
818     }
819 
820     /// @notice Claim token for msg.sender after token sale based on stake.
821     function claimToken() public afterSale {
822         claimTokenFor(msg.sender);
823     }
824 
825     /// @notice Claim token after token sale based on stake.
826     /// @dev Anyone can call this function and distribute tokens after successful token sale
827     /// @param _beneficiary Address of the beneficiary who gets the token
828     function claimTokenFor(address _beneficiary) public afterSale whenNotPaused {
829         uint256 tokens = stakes[_beneficiary];
830         require(tokens > 0);
831 
832         // set the stake 0 for beneficiary
833         stakes[_beneficiary] = 0;
834 
835         // decrease tokenBalance, to make it possible to withdraw excess HEAL funds
836         tokenBalance = tokenBalance.sub(tokens);
837 
838         // distribute hodlr stake
839         ethealController.addHodlerStake(_beneficiary, tokens);
840 
841         // distribute token
842         require(ethealController.ethealToken().transfer(_beneficiary, tokens));
843         LogTokenClaimed(msg.sender, _beneficiary, tokens);
844     }
845 
846     /// @notice claimToken() for multiple addresses
847     /// @dev Anyone can call this function and distribute tokens after successful token sale
848     /// @param _beneficiaries Array of addresses for which we want to claim tokens
849     function claimManyTokenFor(address[] _beneficiaries) external afterSale {
850         for (uint256 i = 0; i < _beneficiaries.length; i++) {
851             claimTokenFor(_beneficiaries[i]);
852         }
853     }
854 
855 
856     ////////////////
857     // Bonus functions
858     ////////////////
859 
860     /// @notice Sets extra 5% bonus for those addresses who send back a promo token
861     /// @notice It contains an easter egg.
862     /// @param _addr this address gets the bonus
863     /// @param _value how many tokens are transferred
864     function setPromoBonus(address _addr, uint256 _value) public {
865         require(msg.sender == promoTokenController || msg.sender == owner);
866         require(_value>0);
867 
868         uint256 _bonus = keccak256(_value) == 0xbeced09521047d05b8960b7e7bcc1d1292cf3e4b2a6b63f48335cbde5f7545d2 ? 6 : 5;
869 
870         if (bonusExtra[ _addr ] < _bonus) {
871             bonusExtra[ _addr ] = _bonus;
872         }
873     }
874 
875     /// @notice Manual set extra bonus for addresses
876     function setBonusExtra(address _addr, uint256 _bonus) public onlyOwner {
877         require(_addr != address(0));
878         bonusExtra[_addr] = _bonus;
879     }
880 
881     /// @notice Mass set extra bonus for addresses
882     function setManyBonusExtra(address[] _addr, uint256 _bonus) external onlyOwner {
883         for (uint256 i = 0; i < _addr.length; i++) {
884             setBonusExtra(_addr[i],_bonus);
885         }
886     }
887 
888     /// @notice Returns bonus for now
889     function getBonusNow(address _addr, uint256 _size) public view returns (uint256) {
890         return getBonus(_addr, _size, now);
891     }
892 
893     /// @notice Returns the bonus in percentage, eg 130 means 30% bonus
894     function getBonus(address _addr, uint256 _size, uint256 _time) public view returns (uint256 _bonus) {
895         // detailed bonus structure: https://etheal.com/#heal-token
896         _bonus = 100;
897         
898         // time based bonuses
899         uint256 _day = getSaleDay(_time);
900         uint256 _hour = getSaleHour(_time);
901         if (_day <= 1) {
902             if (_hour <= 1) _bonus = 130;
903             else if (_hour <= 5) _bonus = 125;
904             else if (_hour <= 8) _bonus = 120;
905             else _bonus = 118;
906         } 
907         else if (_day <= 2) { _bonus = 116; }
908         else if (_day <= 3) { _bonus = 115; }
909         else if (_day <= 5) { _bonus = 114; }
910         else if (_day <= 7) { _bonus = 113; }
911         else if (_day <= 9) { _bonus = 112; }
912         else if (_day <= 11) { _bonus = 111; }
913         else if (_day <= 13) { _bonus = 110; }
914         else if (_day <= 15) { _bonus = 108; }
915         else if (_day <= 17) { _bonus = 107; }
916         else if (_day <= 19) { _bonus = 106; }
917         else if (_day <= 21) { _bonus = 105; }
918         else if (_day <= 23) { _bonus = 104; }
919         else if (_day <= 25) { _bonus = 103; }
920         else if (_day <= 27) { _bonus = 102; }
921 
922         // size based bonuses
923         if (_size >= 100 ether) { _bonus = _bonus + 4; }
924         else if (_size >= 10 ether) { _bonus = _bonus + 2; }
925 
926         // manual bonus
927         _bonus += bonusExtra[ _addr ];
928 
929         return _bonus;
930     }
931 
932 
933     ////////////////
934     // Constant, helper functions
935     ////////////////
936 
937     /// @notice How many wei can the msg.sender contribute now.
938     function howMuchCanIContributeNow() view public returns (uint256) {
939         return howMuchCanXContributeNow(msg.sender);
940     }
941 
942     /// @notice How many wei can an ethereum address contribute now.
943     /// @param _beneficiary Ethereum address
944     /// @return Number of wei the _beneficiary can contribute now.
945     function howMuchCanXContributeNow(address _beneficiary) view public returns (uint256) {
946         require(_beneficiary != address(0));
947 
948         if (hasEnded() || paused) 
949             return 0;
950 
951         // wei to hard cap
952         uint256 weiToCap = cap.sub(weiRaised);
953 
954         return weiToCap;
955     }
956 
957     /// @notice For a give date how many 24 hour blocks have ellapsed since token sale start
958     ///  Before sale return 0, first day 1, second day 2, ...
959     /// @param _time Date in seconds for which we want to know which sale day it is
960     /// @return Number of 24 hour blocks ellapsing since token sale start starting from 1
961     function getSaleDay(uint256 _time) view public returns (uint256) {
962         uint256 _day = 0;
963         if (_time > startTime) {
964             _day = _time.sub(startTime).div(60*60*24).add(1);
965         }
966         return _day;
967     }
968 
969     /// @notice How many 24 hour blocks have ellapsed since token sale start
970     /// @return Number of 24 hour blocks ellapsing since token sale start starting from 1
971     function getSaleDayNow() view public returns (uint256) {
972         return getSaleDay(now);
973     }
974 
975     /// @notice Returns sale hour: 0 before sale, 1 for the first hour, ...
976     /// @param _time Date in seconds for which we want to know which sale hour it is
977     /// @return Number of 1 hour blocks ellapsing since token sale start starting from 1
978     function getSaleHour(uint256 _time) view public returns (uint256) {
979         uint256 _hour = 0;
980         if (_time > startTime) {
981             _hour = _time.sub(startTime).div(60*60).add(1);
982         }
983         return _hour;
984     }
985 
986     /// @notice How many 1 hour blocks have ellapsed since token sale start
987     /// @return Number of 1 hour blocks ellapsing since token sale start starting from 1
988     function getSaleHourNow() view public returns (uint256) {
989         return getSaleHour(now);
990     }
991 
992     /// @notice Minimum between two uint256 numbers
993     function uint256Min(uint256 a, uint256 b) pure internal returns (uint256) {
994         return a > b ? b : a;
995     }
996 
997 
998     ////////////////
999     // Test and contribution web app, NO audit is needed
1000     ////////////////
1001 
1002     /// @notice How many contributors we have.
1003     /// @return Number of different contributor ethereum addresses
1004     function getContributorsCount() view public returns (uint256) {
1005         return contributorsKeys.length;
1006     }
1007 
1008     /// @notice Get contributor addresses to manage refunds or token claims.
1009     /// @dev If the sale is not yet successful, then it searches in the RefundVault.
1010     ///  If the sale is successful, it searches in contributors.
1011     /// @param _pending If true, then returns addresses which didn't get their tokens distributed to them
1012     /// @param _claimed If true, then returns already distributed addresses
1013     /// @return Array of addresses of contributors
1014     function getContributors(bool _pending, bool _claimed) view public returns (address[] contributors) {
1015         uint256 i = 0;
1016         uint256 results = 0;
1017         address[] memory _contributors = new address[](contributorsKeys.length);
1018 
1019         // search in contributors
1020         for (i = 0; i < contributorsKeys.length; i++) {
1021             if (_pending && stakes[contributorsKeys[i]] > 0 || _claimed && stakes[contributorsKeys[i]] == 0) {
1022                 _contributors[results] = contributorsKeys[i];
1023                 results++;
1024             }
1025         }
1026 
1027         contributors = new address[](results);
1028         for (i = 0; i < results; i++) {
1029             contributors[i] = _contributors[i];
1030         }
1031 
1032         return contributors;
1033     }
1034 
1035     /// @notice How many HEAL tokens do this contract have
1036     function getHealBalance() view public returns (uint256) {
1037         return ethealController.ethealToken().balanceOf(address(this));
1038     }
1039 
1040     /// @notice Get current date for web3
1041     function getNow() view public returns (uint256) {
1042         return now;
1043     }
1044 }