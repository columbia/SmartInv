1 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * See https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address _who) public view returns (uint256);
14   function transfer(address _to, uint256 _value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
19 
20 pragma solidity ^0.4.24;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address _owner, address _spender)
30     public view returns (uint256);
31 
32   function transferFrom(address _from, address _to, uint256 _value)
33     public returns (bool);
34 
35   function approve(address _spender, uint256 _value) public returns (bool);
36   event Approval(
37     address indexed owner,
38     address indexed spender,
39     uint256 value
40   );
41 }
42 
43 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
44 
45 pragma solidity ^0.4.24;
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54   /**
55   * @dev Multiplies two numbers, throws on overflow.
56   */
57   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
58     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
59     // benefit is lost if 'b' is also tested.
60     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
61     if (_a == 0) {
62       return 0;
63     }
64 
65     c = _a * _b;
66     assert(c / _a == _b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
74     // assert(_b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = _a / _b;
76     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
77     return _a / _b;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
84     assert(_b <= _a);
85     return _a - _b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
92     c = _a + _b;
93     assert(c >= _a);
94     return c;
95   }
96 }
97 
98 // File: contracts/Interfaces/IBadERC20.sol
99 
100 pragma solidity ^0.4.24;
101 
102 /**
103  * @title Bad formed ERC20 token interface.
104  * @dev The interface of the a bad formed ERC20 token.
105  */
106 interface IBadERC20 {
107     function transfer(address to, uint256 value) external;
108     function approve(address spender, uint256 value) external;
109     function transferFrom(
110       address from,
111       address to,
112       uint256 value
113     ) external;
114 
115     function totalSupply() external view returns (uint256);
116 
117     function balanceOf(
118       address who
119     ) external view returns (uint256);
120 
121     function allowance(
122       address owner,
123       address spender
124     ) external view returns (uint256);
125 
126     event Transfer(
127       address indexed from,
128       address indexed to,
129       uint256 value
130     );
131     event Approval(
132       address indexed owner,
133       address indexed spender,
134       uint256 value
135     );
136 }
137 
138 // File: contracts/Utils/SafeTransfer.sol
139 
140 pragma solidity ^0.4.24;
141 
142 
143 /**
144  * @title SafeTransfer
145  * @dev Transfer Bad ERC20 tokens
146  */
147 library SafeTransfer {
148 /**
149    * @dev Wrapping the ERC20 transferFrom function to avoid missing returns.
150    * @param _tokenAddress The address of bad formed ERC20 token.
151    * @param _from Transfer sender.
152    * @param _to Transfer receiver.
153    * @param _value Amount to be transfered.
154    * @return Success of the safeTransferFrom.
155    */
156 
157   function _safeTransferFrom(
158     address _tokenAddress,
159     address _from,
160     address _to,
161     uint256 _value
162   )
163     internal
164     returns (bool result)
165   {
166     IBadERC20(_tokenAddress).transferFrom(_from, _to, _value);
167 
168     assembly {
169       switch returndatasize()
170       case 0 {                      // This is our BadToken
171         result := not(0)            // result is true
172       }
173       case 32 {                     // This is our GoodToken
174         returndatacopy(0, 0, 32)
175         result := mload(0)          // result == returndata of external call
176       }
177       default {                     // This is not an ERC20 token
178         revert(0, 0)
179       }
180     }
181   }
182 
183   /**
184    * @dev Wrapping the ERC20 transfer function to avoid missing returns.
185    * @param _tokenAddress The address of bad formed ERC20 token.
186    * @param _to Transfer receiver.
187    * @param _amount Amount to be transfered.
188    * @return Success of the safeTransfer.
189    */
190   function _safeTransfer(
191     address _tokenAddress,
192     address _to,
193     uint _amount
194   )
195     internal
196     returns (bool result)
197   {
198     IBadERC20(_tokenAddress).transfer(_to, _amount);
199 
200     assembly {
201       switch returndatasize()
202       case 0 {                      // This is our BadToken
203         result := not(0)            // result is true
204       }
205       case 32 {                     // This is our GoodToken
206         returndatacopy(0, 0, 32)
207         result := mload(0)          // result == returndata of external call
208       }
209       default {                     // This is not an ERC20 token
210         revert(0, 0)
211       }
212     }
213   }
214 
215   function _safeApprove(
216     address _token,
217     address _spender,
218     uint256 _value
219   )
220   internal
221   returns (bool result)
222   {
223     IBadERC20(_token).approve(_spender, _value);
224 
225     assembly {
226       switch returndatasize()
227       case 0 {                      // This is our BadToken
228         result := not(0)            // result is true
229       }
230       case 32 {                     // This is our GoodToken
231         returndatacopy(0, 0, 32)
232         result := mload(0)          // result == returndata of external call
233       }
234       default {                     // This is not an ERC20 token
235         revert(0, 0)
236       }
237     }
238   }
239 }
240 
241 // File: contracts/Interfaces/IBZxLoanToken.sol
242 
243 pragma solidity ^0.4.0;
244 
245 interface IBZxLoanToken {
246     function transfer(address dst, uint256 amount) external returns (bool);
247     function transferFrom(address src, address dst, uint256 amount) external returns (bool);
248     function approve(address spender, uint256 amount) external returns (bool);
249     function allowance(address owner, address spender) external view returns (uint256);
250     function balanceOf(address owner) external view returns (uint256);
251 
252     function loanTokenAddress() external view returns (address);
253     function tokenPrice() external view returns (uint256 price);
254 //    function mintWithEther(address receiver) external payable returns (uint256 mintAmount);
255     function mint(address receiver, uint256 depositAmount) external returns (uint256 mintAmount);
256 //    function burnToEther(address payable receiver, uint256 burnAmount) external returns (uint256 loanAmountPaid);
257     function burn(address receiver, uint256 burnAmount) external returns (uint256 loanAmountPaid);
258 }
259 
260 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
261 
262 pragma solidity ^0.4.24;
263 
264 
265 
266 
267 /**
268  * @title SafeERC20
269  * @dev Wrappers around ERC20 operations that throw on failure.
270  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
271  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
272  */
273 library SafeERC20 {
274   function safeTransfer(
275     ERC20Basic _token,
276     address _to,
277     uint256 _value
278   )
279     internal
280   {
281     require(_token.transfer(_to, _value));
282   }
283 
284   function safeTransferFrom(
285     ERC20 _token,
286     address _from,
287     address _to,
288     uint256 _value
289   )
290     internal
291   {
292     require(_token.transferFrom(_from, _to, _value));
293   }
294 
295   function safeApprove(
296     ERC20 _token,
297     address _spender,
298     uint256 _value
299   )
300     internal
301   {
302     require(_token.approve(_spender, _value));
303   }
304 }
305 
306 // File: contracts/Interfaces/ICToken.sol
307 
308 pragma solidity ^0.4.0;
309 
310 interface ICToken {
311     function exchangeRateStored() external view returns (uint);
312 
313     function transfer(address dst, uint256 amount) external returns (bool);
314     function transferFrom(address src, address dst, uint256 amount) external returns (bool);
315     function approve(address spender, uint256 amount) external returns (bool);
316     function allowance(address owner, address spender) external view returns (uint256);
317     function balanceOf(address owner) external view returns (uint256);
318 
319 //    function balanceOfUnderlying(address owner) external returns (uint);
320 }
321 
322 // File: contracts/Interfaces/ICErc20.sol
323 
324 pragma solidity ^0.4.0;
325 
326 
327 contract  ICErc20 is ICToken {
328     function underlying() external view returns (address);
329 
330     function mint(uint mintAmount) external returns (uint);
331     function redeem(uint redeemTokens) external returns (uint);
332 //    function redeemUnderlying(uint redeemAmount) external returns (uint);
333 //    function borrow(uint borrowAmount) external returns (uint);
334 //    function repayBorrow(uint repayAmount) external returns (uint);
335 //    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
336 //    function liquidateBorrow(address borrower, uint repayAmount, address cTokenCollateral) external returns (uint);
337 }
338 
339 // File: contracts/Interfaces/IErc20Swap.sol
340 
341 pragma solidity ^0.4.0;
342 
343 interface IErc20Swap {
344     function getRate(address src, address dst, uint256 srcAmount) external view returns(uint expectedRate, uint slippageRate);  // real rate = returned value / 1e18
345     function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) external payable;
346 }
347 
348 // File: contracts/Utils/Ownable.sol
349 
350 pragma solidity ^0.4.24;
351 
352 /**
353  * @title Ownable
354  * @dev The Ownable contract has an owner address, and provides basic authorization control
355  * functions, this simplifies the implementation of "user permissions".
356  */
357 contract Ownable {
358   address public owner;
359 
360 
361   event OwnershipRenounced(address indexed previousOwner);
362   event OwnershipTransferred(
363     address indexed previousOwner,
364     address indexed newOwner
365   );
366 
367 
368   /**
369    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
370    * account.
371    */
372   constructor() public {
373     owner = msg.sender;
374   }
375 
376   /**
377    * @dev Throws if called by any account other than the owner.
378    */
379   modifier onlyOwner() {
380     require(msg.sender == owner, "msg.sender not owner");
381     _;
382   }
383 
384   /**
385    * @dev Allows the current owner to relinquish control of the contract.
386    * @notice Renouncing to ownership will leave the contract without an owner.
387    * It will not be possible to call the functions with the `onlyOwner`
388    * modifier anymore.
389    */
390   function renounceOwnership() public onlyOwner {
391     emit OwnershipRenounced(owner);
392     owner = address(0);
393   }
394 
395   /**
396    * @dev Allows the current owner to transfer control of the contract to a newOwner.
397    * @param _newOwner The address to transfer ownership to.
398    */
399   function transferOwnership(address _newOwner) public onlyOwner {
400     _transferOwnership(_newOwner);
401   }
402 
403   /**
404    * @dev Transfers control of the contract to a newOwner.
405    * @param _newOwner The address to transfer ownership to.
406    */
407   function _transferOwnership(address _newOwner) internal {
408     require(_newOwner != address(0), "_newOwner == 0");
409     emit OwnershipTransferred(owner, _newOwner);
410     owner = _newOwner;
411   }
412 }
413 
414 // File: contracts/Utils/Destructible.sol
415 
416 pragma solidity ^0.4.24;
417 
418 
419 /**
420  * @title Destructible
421  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
422  */
423 contract Destructible is Ownable {
424   /**
425    * @dev Transfers the current balance to the owner and terminates the contract.
426    */
427   function destroy() public onlyOwner {
428     selfdestruct(owner);
429   }
430 
431   function destroyAndSend(address _recipient) public onlyOwner {
432     selfdestruct(_recipient);
433   }
434 }
435 
436 // File: contracts/Utils/Pausable.sol
437 
438 pragma solidity ^0.4.24;
439 
440 
441 
442 /**
443  * @title Pausable
444  * @dev Base contract which allows children to implement an emergency stop mechanism.
445  */
446 contract Pausable is Ownable {
447   event Pause();
448   event Unpause();
449 
450   bool public paused = false;
451 
452 
453   /**
454    * @dev Modifier to make a function callable only when the contract is not paused.
455    */
456   modifier whenNotPaused() {
457     require(!paused, "The contract is paused");
458     _;
459   }
460 
461   /**
462    * @dev Modifier to make a function callable only when the contract is paused.
463    */
464   modifier whenPaused() {
465     require(paused, "The contract is not paused");
466     _;
467   }
468 
469   /**
470    * @dev called by the owner to pause, triggers stopped state
471    */
472   function pause() public onlyOwner whenNotPaused {
473     paused = true;
474     emit Pause();
475   }
476 
477   /**
478    * @dev called by the owner to unpause, returns to normal state
479    */
480   function unpause() public onlyOwner whenPaused {
481     paused = false;
482     emit Unpause();
483   }
484 }
485 
486 // File: contracts/Utils/Withdrawable.sol
487 
488 pragma solidity ^0.4.24;
489 
490 
491 
492 
493 contract Withdrawable is Ownable {
494   using SafeTransfer for ERC20;
495   address constant ETHER = address(0);
496 
497   event LogWithdrawToken(
498     address indexed _from,
499     address indexed _token,
500     uint amount
501   );
502 
503   /**
504    * @dev Withdraw asset.
505    * @param _tokenAddress Asset to be withdrawed.
506    * @return bool.
507    */
508   function withdrawToken(address _tokenAddress) public onlyOwner {
509     uint tokenBalance;
510     if (_tokenAddress == ETHER) {
511       tokenBalance = address(this).balance;
512       msg.sender.transfer(tokenBalance);
513     } else {
514       tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));
515       ERC20(_tokenAddress)._safeTransfer(msg.sender, tokenBalance);
516     }
517     emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);
518   }
519 
520 }
521 
522 // File: contracts/WrappedTokenSwap.sol
523 
524 pragma solidity ^0.4.24;
525 
526 
527 
528 
529 
530 
531 
532 
533 
534 
535 
536 /**
537  * @title TokenSwap.
538  * @author Eidoo SAGL.
539  * @dev A swap asset contract. The offerAmount and wantAmount are collected and sent into the contract itself.
540  */
541 contract WrappedTokenSwap is Ownable, Withdrawable, Pausable, Destructible, IErc20Swap
542 {
543   using SafeMath for uint;
544   using SafeTransfer for ERC20;
545   address constant ETHER = address(0);
546   uint constant rateDecimals = 18;
547   uint constant rateUnit = 10 ** rateDecimals;
548 
549   address public wallet;
550 
551   uint public spread;
552   uint constant spreadDecimals = 6;
553   uint constant spreadUnit = 10 ** spreadDecimals;
554 
555   bool rateFixMultiplyOnWrap;
556   uint rateFixFactor;
557 
558   event LogTokenSwap(
559     address indexed _userAddress,
560     address indexed _userSentTokenAddress,
561     uint _userSentTokenAmount,
562     address indexed _userReceivedTokenAddress,
563     uint _userReceivedTokenAmount
564   );
565 
566   event LogFee(address token, uint amount);
567 
568   // abstract methods
569   function underlyingTokenAddress() public view returns(address);
570   function wrappedTokenAddress() public view returns(address);
571   function wrap(uint unwrappedAmount) private returns(bool);
572   function unwrap(uint wrappedAmount) private returns(bool);
573   function getExchangedAmount(uint _amount, bool _isUnwrap) private view returns(uint);
574 
575   /**
576    * @dev Contract constructor.
577    * @param _wallet The wallet for fees.
578    * @param _spread The initial spread (in millionths).
579    */
580   constructor(
581     address _wallet,
582     uint _spread,
583     bool _rateFixMultiplyOnWrap,
584     uint _rateFixFactor
585   )
586     public
587   {
588     require(_wallet != address(0), "_wallet == address(0)");
589     wallet = _wallet;
590     spread = _spread;
591     require(_rateFixFactor > 0, "_rateFixFactor == 0");
592     rateFixFactor = _rateFixFactor;
593     rateFixMultiplyOnWrap = _rateFixMultiplyOnWrap;
594   }
595 
596   function() external {
597     revert("fallback function not allowed");
598   }
599 
600   function setFixFactor(uint factor, bool multiplyOnWrap) external onlyOwner {
601     require(factor > 0, "factor == 0");
602     rateFixFactor = factor;
603     rateFixMultiplyOnWrap = multiplyOnWrap;
604   }
605 
606   function setWallet(address _wallet) public onlyOwner {
607     require(_wallet != address(0), "_wallet == address(0)");
608     wallet = _wallet;
609   }
610 
611   function setSpread(uint _spread) public onlyOwner {
612     spread = _spread;
613   }
614 
615 
616   // kybernetwork style getRate
617   function getRate(address src, address dst, uint256 /*srcAmount*/) public view
618     returns(uint, uint)
619   {
620     address wrapped = wrappedTokenAddress();
621     address underlying = underlyingTokenAddress();
622     require((src == wrapped && dst == underlying) || (src == underlying && dst == wrapped), "Wrong tokens pair");
623     uint rate = getAmount(rateUnit, src == wrapped);
624     rate = (rateFixMultiplyOnWrap && src == underlying) || (!rateFixMultiplyOnWrap && src == wrapped)
625       ? rate.mul(rateFixFactor)
626       : rate.div(rateFixFactor);
627     return (rate, rate);
628   }
629 
630   function buyRate() public view returns(uint) {
631     return getAmount(rateUnit, false);
632   }
633 
634   function buyRateDecimals() public pure returns(uint) {
635     return rateDecimals;
636   }
637 
638   function sellRate() public view returns(uint) {
639     return getAmount(rateUnit, true);
640   }
641 
642   function sellRateDecimals() public pure returns(uint) {
643     return rateDecimals;
644   }
645 
646   /******************* end rate functions *******************/
647 
648   function _getFee(uint underlyingTokenTotal) internal view returns(uint) {
649     return underlyingTokenTotal.mul(spread).div(spreadUnit);
650   }
651 
652   /**
653  * @dev For interface compatibility. Function to calculate the number of tokens the user is going to receive.
654  * @param _offerTokenAmount The amount of tokens.
655  * @param _isUnwrap If true, the offered token is the wrapped token, otherwise is the underlying token.
656  * @return uint.
657  */
658   function getAmount(uint _offerTokenAmount, bool _isUnwrap)
659     public view returns(uint toUserAmount)
660   {
661     if (_isUnwrap) {
662       uint amount = getExchangedAmount(_offerTokenAmount, _isUnwrap);
663       // fee is always in underlying token, when minting the CToken is the received token
664       toUserAmount = amount.sub(_getFee(amount));
665     } else {
666       // fee is always in underlying token, when redeeming the CToken is the offered token
667       uint fee = _getFee(_offerTokenAmount);
668       toUserAmount = getExchangedAmount(_offerTokenAmount.sub(fee), _isUnwrap);
669     }
670   }
671 
672   /**
673    * @dev For old interface compatibility. Release purchased asset to the buyer based on pair rate.
674    * @param _userOfferTokenAddress The token address the purchaser is offering (It may be the quote or the base).
675    * @param _userOfferTokenAmount The amount of token the user want to swap.
676    * @return bool.
677    */
678   function swapToken (
679     address _userOfferTokenAddress,
680     uint _userOfferTokenAmount
681   )
682     public
683     whenNotPaused
684     returns (bool)
685   {
686     swap(
687       _userOfferTokenAddress,
688       _userOfferTokenAmount,
689       _userOfferTokenAddress == wrappedTokenAddress()
690         ? underlyingTokenAddress()
691         : wrappedTokenAddress(),
692       0,
693       0
694     );
695     return true;
696   }
697 
698   function swap(address src, uint srcAmount, address dest, uint /*maxDestAmount*/, uint /*minConversionRate*/) public payable
699     whenNotPaused
700   {
701     require(msg.value == 0, "ethers not supported");
702     require(srcAmount != 0, "srcAmount == 0");
703     require(
704       ERC20(src).allowance(msg.sender, address(this)) >= srcAmount,
705       "ERC20 allowance < srcAmount"
706     );
707     address underlying = underlyingTokenAddress();
708     address wrapped = wrappedTokenAddress();
709     require((src == wrapped && dest == underlying) || (src == underlying && dest == wrapped), "Wrong tokens pair");
710     bool isUnwrap = src == wrapped;
711     uint toUserAmount;
712     uint fee;
713 
714     // get user's tokens
715     ERC20(src)._safeTransferFrom(msg.sender, address(this), srcAmount);
716 
717     if (isUnwrap) {
718       require(unwrap(srcAmount), "cannot unwrap the token");
719       uint unwrappedAmount = getExchangedAmount(srcAmount, isUnwrap);
720       require(
721         ERC20(underlying).balanceOf(address(this)) >= unwrappedAmount,
722         "No enough underlying tokens after redeem"
723       );
724       fee = _getFee(unwrappedAmount);
725       toUserAmount = unwrappedAmount.sub(fee);
726       require(toUserAmount > 0, "toUserAmount must be greater than 0");
727       require(
728         ERC20(underlying)._safeTransfer(msg.sender, toUserAmount),
729         "cannot transfer underlying token to the user"
730       );
731     } else {
732       fee = _getFee(srcAmount);
733       uint toSwap = srcAmount.sub(fee);
734       require(wrap(toSwap), "cannot wrap the token");
735       toUserAmount = getExchangedAmount(toSwap, isUnwrap);
736       require(ERC20(wrapped).balanceOf(address(this)) >= toUserAmount, "No enough wrapped tokens after wrap");
737       require(toUserAmount > 0, "toUserAmount must be greater than 0");
738       require(
739         ERC20(wrapped)._safeTransfer(msg.sender, toUserAmount),
740         "cannot transfer the wrapped token to the user"
741       );
742     }
743     // get the fee
744     if (fee > 0) {
745       require(
746         ERC20(underlying)._safeTransfer(wallet, fee),
747         "cannot transfer the underlying token to the wallet for the fees"
748       );
749       emit LogFee(address(underlying), fee);
750     }
751 
752     emit LogTokenSwap(
753       msg.sender,
754       src,
755       srcAmount,
756       dest,
757       toUserAmount
758     );
759   }
760 
761 
762 }
763 
764 // File: contracts/BZxLoanTokenSwap.sol
765 
766 pragma solidity ^0.4.24;
767 
768 
769 
770 
771 
772 
773 /**
774  * @title TokenSwap.
775  * @author Eidoo SAGL.
776  * @dev A swap asset contract. The offerAmount and wantAmount are collected and sent into the contract itself.
777  */
778 contract BZxLoanTokenSwap is WrappedTokenSwap
779 {
780   using SafeMath for uint;
781   using SafeTransfer for ERC20;
782   uint constant expScale = 1e18;
783 
784   IBZxLoanToken public loanToken;
785 
786   /**
787    * @dev Contract constructor.
788    * @param _loanTokenAddress  The LoanToken in the pair.
789    * @param _wallet The wallet for fees.
790    * @param _spread The initial spread (in millionths).
791    */
792   constructor(
793     address _loanTokenAddress,
794     address _wallet,
795     uint _spread,
796     bool _rateFixMultiplyOnWrap,
797     uint _rateFixFactor
798   )
799     public WrappedTokenSwap(_wallet, _spread, _rateFixMultiplyOnWrap, _rateFixFactor)
800   {
801     loanToken = IBZxLoanToken(_loanTokenAddress);
802   }
803 
804   function underlyingTokenAddress() public view returns(address) {
805     return loanToken.loanTokenAddress();
806   }
807 
808   function wrappedTokenAddress() public view returns(address) {
809     return address(loanToken);
810   }
811 
812   function wrap(uint unwrappedAmount) private returns(bool) {
813     require(
814       ERC20(loanToken.loanTokenAddress())._safeApprove(address(loanToken), unwrappedAmount),
815       "Cannot approve underlying token for mint"
816     );
817     return loanToken.mint(address(this), unwrappedAmount) > 0;
818   }
819 
820   function unwrap(uint wrappedAmount) private returns(bool) {
821     return loanToken.burn(address(this), wrappedAmount) > 0;
822   }
823 
824   function getExchangedAmount(uint _amount, bool _isUnwrap) private view returns(uint) {
825     uint rate = loanToken.tokenPrice();
826     return _isUnwrap
827       ? _amount.mul(rate).div(expScale)
828       : _amount.mul(expScale).div(rate);
829   }
830 
831 }