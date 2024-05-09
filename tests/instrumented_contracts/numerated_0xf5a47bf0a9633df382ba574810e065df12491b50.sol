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
98 // File: contracts/Utils/Ownable.sol
99 
100 pragma solidity ^0.4.24;
101 
102 /**
103  * @title Ownable
104  * @dev The Ownable contract has an owner address, and provides basic authorization control
105  * functions, this simplifies the implementation of "user permissions".
106  */
107 contract Ownable {
108   address public owner;
109 
110 
111   event OwnershipRenounced(address indexed previousOwner);
112   event OwnershipTransferred(
113     address indexed previousOwner,
114     address indexed newOwner
115   );
116 
117 
118   /**
119    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
120    * account.
121    */
122   constructor() public {
123     owner = msg.sender;
124   }
125 
126   /**
127    * @dev Throws if called by any account other than the owner.
128    */
129   modifier onlyOwner() {
130     require(msg.sender == owner, "msg.sender not owner");
131     _;
132   }
133 
134   /**
135    * @dev Allows the current owner to relinquish control of the contract.
136    * @notice Renouncing to ownership will leave the contract without an owner.
137    * It will not be possible to call the functions with the `onlyOwner`
138    * modifier anymore.
139    */
140   function renounceOwnership() public onlyOwner {
141     emit OwnershipRenounced(owner);
142     owner = address(0);
143   }
144 
145   /**
146    * @dev Allows the current owner to transfer control of the contract to a newOwner.
147    * @param _newOwner The address to transfer ownership to.
148    */
149   function transferOwnership(address _newOwner) public onlyOwner {
150     _transferOwnership(_newOwner);
151   }
152 
153   /**
154    * @dev Transfers control of the contract to a newOwner.
155    * @param _newOwner The address to transfer ownership to.
156    */
157   function _transferOwnership(address _newOwner) internal {
158     require(_newOwner != address(0), "_newOwner == 0");
159     emit OwnershipTransferred(owner, _newOwner);
160     owner = _newOwner;
161   }
162 }
163 
164 // File: contracts/Utils/Destructible.sol
165 
166 pragma solidity ^0.4.24;
167 
168 
169 /**
170  * @title Destructible
171  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
172  */
173 contract Destructible is Ownable {
174   /**
175    * @dev Transfers the current balance to the owner and terminates the contract.
176    */
177   function destroy() public onlyOwner {
178     selfdestruct(owner);
179   }
180 
181   function destroyAndSend(address _recipient) public onlyOwner {
182     selfdestruct(_recipient);
183   }
184 }
185 
186 // File: contracts/Interfaces/IWallet.sol
187 
188 pragma solidity ^0.4.24;
189 
190 /**
191  * @title Wallet interface.
192  * @dev The interface of the SC that own the assets.
193  */
194 interface IWallet {
195 
196   function transferAssetTo(
197     address _assetAddress,
198     address _to,
199     uint _amount
200   ) external payable returns (bool);
201 
202   function withdrawAsset(
203     address _assetAddress,
204     uint _amount
205   ) external returns (bool);
206 
207   function setTokenSwapAllowance (
208     address _tokenSwapAddress,
209     bool _allowance
210   ) external returns(bool);
211 }
212 
213 // File: contracts/Utils/Pausable.sol
214 
215 pragma solidity ^0.4.24;
216 
217 
218 
219 /**
220  * @title Pausable
221  * @dev Base contract which allows children to implement an emergency stop mechanism.
222  */
223 contract Pausable is Ownable {
224   event Pause();
225   event Unpause();
226 
227   bool public paused = false;
228 
229 
230   /**
231    * @dev Modifier to make a function callable only when the contract is not paused.
232    */
233   modifier whenNotPaused() {
234     require(!paused, "The contract is paused");
235     _;
236   }
237 
238   /**
239    * @dev Modifier to make a function callable only when the contract is paused.
240    */
241   modifier whenPaused() {
242     require(paused, "The contract is not paused");
243     _;
244   }
245 
246   /**
247    * @dev called by the owner to pause, triggers stopped state
248    */
249   function pause() public onlyOwner whenNotPaused {
250     paused = true;
251     emit Pause();
252   }
253 
254   /**
255    * @dev called by the owner to unpause, returns to normal state
256    */
257   function unpause() public onlyOwner whenPaused {
258     paused = false;
259     emit Unpause();
260   }
261 }
262 
263 // File: contracts/Interfaces/IBadERC20.sol
264 
265 pragma solidity ^0.4.24;
266 
267 /**
268  * @title Bad formed ERC20 token interface.
269  * @dev The interface of the a bad formed ERC20 token.
270  */
271 interface IBadERC20 {
272     function transfer(address to, uint256 value) external;
273     function approve(address spender, uint256 value) external;
274     function transferFrom(
275       address from,
276       address to,
277       uint256 value
278     ) external;
279 
280     function totalSupply() external view returns (uint256);
281 
282     function balanceOf(
283       address who
284     ) external view returns (uint256);
285 
286     function allowance(
287       address owner,
288       address spender
289     ) external view returns (uint256);
290 
291     event Transfer(
292       address indexed from,
293       address indexed to,
294       uint256 value
295     );
296     event Approval(
297       address indexed owner,
298       address indexed spender,
299       uint256 value
300     );
301 }
302 
303 // File: contracts/Utils/SafeTransfer.sol
304 
305 pragma solidity ^0.4.24;
306 
307 
308 /**
309  * @title SafeTransfer
310  * @dev Transfer Bad ERC20 tokens
311  */
312 library SafeTransfer {
313 /**
314    * @dev Wrapping the ERC20 transferFrom function to avoid missing returns.
315    * @param _tokenAddress The address of bad formed ERC20 token.
316    * @param _from Transfer sender.
317    * @param _to Transfer receiver.
318    * @param _value Amount to be transfered.
319    * @return Success of the safeTransferFrom.
320    */
321 
322   function _safeTransferFrom(
323     address _tokenAddress,
324     address _from,
325     address _to,
326     uint256 _value
327   )
328     internal
329     returns (bool result)
330   {
331     IBadERC20(_tokenAddress).transferFrom(_from, _to, _value);
332 
333     assembly {
334       switch returndatasize()
335       case 0 {                      // This is our BadToken
336         result := not(0)            // result is true
337       }
338       case 32 {                     // This is our GoodToken
339         returndatacopy(0, 0, 32)
340         result := mload(0)          // result == returndata of external call
341       }
342       default {                     // This is not an ERC20 token
343         revert(0, 0)
344       }
345     }
346   }
347 
348   /**
349    * @dev Wrapping the ERC20 transfer function to avoid missing returns.
350    * @param _tokenAddress The address of bad formed ERC20 token.
351    * @param _to Transfer receiver.
352    * @param _amount Amount to be transfered.
353    * @return Success of the safeTransfer.
354    */
355   function _safeTransfer(
356     address _tokenAddress,
357     address _to,
358     uint _amount
359   )
360     internal
361     returns (bool result)
362   {
363     IBadERC20(_tokenAddress).transfer(_to, _amount);
364 
365     assembly {
366       switch returndatasize()
367       case 0 {                      // This is our BadToken
368         result := not(0)            // result is true
369       }
370       case 32 {                     // This is our GoodToken
371         returndatacopy(0, 0, 32)
372         result := mload(0)          // result == returndata of external call
373       }
374       default {                     // This is not an ERC20 token
375         revert(0, 0)
376       }
377     }
378   }
379 
380   function _safeApprove(
381     address _token,
382     address _spender,
383     uint256 _value
384   )
385   internal
386   returns (bool result)
387   {
388     IBadERC20(_token).approve(_spender, _value);
389 
390     assembly {
391       switch returndatasize()
392       case 0 {                      // This is our BadToken
393         result := not(0)            // result is true
394       }
395       case 32 {                     // This is our GoodToken
396         returndatacopy(0, 0, 32)
397         result := mload(0)          // result == returndata of external call
398       }
399       default {                     // This is not an ERC20 token
400         revert(0, 0)
401       }
402     }
403   }
404 }
405 
406 // File: contracts/TokenSwap.sol
407 
408 pragma solidity ^0.4.24;
409 
410 
411 
412 
413 
414 
415 
416 /**
417  * @title TokenSwap.
418  * @author Eidoo SAGL.
419  * @dev A swap asset contract. The offerAmount and wantAmount are collected and sent into the contract itself.
420  */
421 contract TokenSwap is
422   Pausable,
423   Destructible
424 {
425   using SafeMath for uint;
426 
427   address public baseTokenAddress;
428   address public quoteTokenAddress;
429 
430   address public wallet;
431 
432   uint public buyRate;
433   uint public buyRateDecimals;
434   uint public sellRate;
435   uint public sellRateDecimals;
436 
437   event LogWithdrawToken(
438     address indexed _from,
439     address indexed _token,
440     uint amount
441   );
442   event LogSetWallet(address indexed _wallet);
443   event LogSetBaseTokenAddress(address indexed _token);
444   event LogSetQuoteTokenAddress(address indexed _token);
445   event LogSetRateAndRateDecimals(
446     uint _buyRate,
447     uint _buyRateDecimals,
448     uint _sellRate,
449     uint _sellRateDecimals
450   );
451   event LogSetNumberOfZeroesFromLastDigit(
452     uint _numberOfZeroesFromLastDigit
453   );
454   event LogTokenSwap(
455     address indexed _userAddress,
456     address indexed _userSentTokenAddress,
457     uint _userSentTokenAmount,
458     address indexed _userReceivedTokenAddress,
459     uint _userReceivedTokenAmount
460   );
461 
462   /**
463    * @dev Contract constructor.
464    * @param _baseTokenAddress  The base of the swap pair.
465    * @param _quoteTokenAddress The quote of the swap pair.
466    * @param _buyRate Purchase rate, how many baseToken for the given quoteToken.
467    * @param _buyRateDecimals Define the decimals precision for the given asset.
468    * @param _sellRate Purchase rate, how many quoteToken for the given baseToken.
469    * @param _sellRateDecimals Define the decimals precision for the given asset.
470    */
471   constructor(
472     address _baseTokenAddress,
473     address _quoteTokenAddress,
474     address _wallet,
475     uint _buyRate,
476     uint _buyRateDecimals,
477     uint _sellRate,
478     uint _sellRateDecimals
479   )
480     public
481   {
482     require(_wallet != address(0), "_wallet == address(0)");
483     baseTokenAddress = _baseTokenAddress;
484     quoteTokenAddress = _quoteTokenAddress;
485     wallet = _wallet;
486     buyRate = _buyRate;
487     buyRateDecimals = _buyRateDecimals;
488     sellRate = _sellRate;
489     sellRateDecimals = _sellRateDecimals;
490   }
491 
492   function()
493     external
494     whenNotPaused
495     payable
496   {
497     require(isETH(quoteTokenAddress), 'Cannot use fallback, the quote set is not ETH');
498 
499     require(swapToken(quoteTokenAddress, msg.value), 'Swap failed');
500   }
501 
502   /**
503    * @dev Set base token address.
504    * @param _baseTokenAddress The pair base token address.
505    * @return bool.
506    */
507   function setBaseTokenAddress(address _baseTokenAddress)
508     public
509     onlyOwner
510     returns (bool)
511   {
512     baseTokenAddress = _baseTokenAddress;
513     emit LogSetBaseTokenAddress(_baseTokenAddress);
514     return true;
515   }
516 
517   /**
518    * @dev Set quote token address.
519    * @param _quoteTokenAddress The quote token address.
520    * @return bool.
521    */
522   function setQuoteTokenAddress(address _quoteTokenAddress)
523     public
524     onlyOwner
525     returns (bool)
526   {
527     quoteTokenAddress = _quoteTokenAddress;
528     emit LogSetQuoteTokenAddress(_quoteTokenAddress);
529     return true;
530   }
531 
532   /**
533    * @dev Set wallet sc address.
534    * @param _wallet The wallet sc address.
535    * @return bool.
536    */
537   function setWallet(address _wallet)
538     public
539     onlyOwner
540     returns (bool)
541   {
542     require(_wallet != address(0), "_wallet == address(0)");
543     wallet = _wallet;
544     emit LogSetWallet(_wallet);
545     return true;
546   }
547 
548   /**
549    * @dev Set rate.
550    * @param _buyRate Multiplier, how many base token for the quote token.
551    * @param _buyRateDecimals Number of significan digits of the rate.
552    * @param _sellRate Multiplier, how many quote token for the base token.
553    * @param _sellRateDecimals Number of significan digits of the rate.
554    * @return bool.
555    */
556   function setRateAndRateDecimals(
557     uint _buyRate,
558     uint _buyRateDecimals,
559     uint _sellRate,
560     uint _sellRateDecimals
561   )
562     public
563     onlyOwner
564     returns (bool)
565   {
566     require(_buyRate != buyRate, "_buyRate == buyRate");
567     require(_buyRate != 0, "_buyRate == 0");
568     require(_sellRate != sellRate, "_sellRate == sellRate");
569     require(_sellRate != 0, "_sellRate == 0");
570     buyRate = _buyRate;
571     sellRate = _sellRate;
572     buyRateDecimals = _buyRateDecimals;
573     sellRateDecimals = _sellRateDecimals;
574     emit LogSetRateAndRateDecimals(
575       _buyRate,
576       _buyRateDecimals,
577       _sellRate,
578       _sellRateDecimals
579     );
580     return true;
581   }
582 
583   /**
584    * @dev Withdraw asset.
585    * @param _tokenAddress Asset to be withdrawed.
586    * @return bool.
587    */
588   function withdrawToken(address _tokenAddress)
589     public
590     onlyOwner
591     returns(bool)
592   {
593     uint tokenBalance;
594     if (isETH(_tokenAddress)) {
595       tokenBalance = address(this).balance;
596       msg.sender.transfer(tokenBalance);
597     } else {
598       tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));
599       require(
600         SafeTransfer._safeTransfer(_tokenAddress, msg.sender, tokenBalance),
601         "withdraw transfer failed"
602       );
603     }
604     emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);
605     return true;
606   }
607 
608   /**
609    * @dev Understand if the user swap request is a BUY or a SELL.
610    * @param _offerTokenAddress The token address the purchaser is offering (It may be the quote or the base).
611    * @return bool.
612    */
613 
614   function isBuy(address _offerTokenAddress)
615     public
616     view
617     returns (bool)
618   {
619     return _offerTokenAddress == quoteTokenAddress;
620   }
621 
622   /**
623    * @dev Understand if the token is ETH or not.
624    * @param _tokenAddress The token address the purchaser is offering (It may be the quote or the base).
625    * @return bool.
626    */
627 
628   function isETH(address _tokenAddress)
629     public
630     pure
631     returns (bool)
632   {
633     return _tokenAddress == address(0);
634   }
635 
636   /**
637    * @dev Understand if the user swap request is for the available pair.
638    * @param _offerTokenAddress The token address the purchaser is offering (It may be the quote or the base).
639    * @return bool.
640    */
641 
642   function isOfferInPair(address _offerTokenAddress)
643     public
644     view
645     returns (bool)
646   {
647     return _offerTokenAddress == quoteTokenAddress ||
648       _offerTokenAddress == baseTokenAddress;
649   }
650 
651   /**
652    * @dev Function to calculate the number of tokens the user is going to receive.
653    * @param _offerTokenAmount The amount of tokne number of WEI to convert in ERC20.
654    * @return uint.
655    */
656   function getAmount(
657     uint _offerTokenAmount,
658     bool _isBuy
659   )
660     public
661     view
662     returns(uint)
663   {
664     uint amount;
665     if (_isBuy) {
666       amount = _offerTokenAmount.mul(buyRate).div(10 ** buyRateDecimals);
667     } else {
668       amount = _offerTokenAmount.mul(sellRate).div(10 ** sellRateDecimals);
669     }
670     return amount;
671   }
672 
673   /**
674    * @dev Release purchased asset to the buyer based on pair rate.
675    * @param _userOfferTokenAddress The token address the purchaser is offering (It may be the quote or the base).
676    * @param _userOfferTokenAmount The amount of token the user want to swap.
677    * @return bool.
678    */
679   function swapToken (
680     address _userOfferTokenAddress,
681     uint _userOfferTokenAmount
682   )
683     public
684     whenNotPaused
685     payable
686     returns (bool)
687   {
688     require(_userOfferTokenAmount != 0, "_userOfferTokenAmount == 0");
689     // check if offered token address is the base or the quote token address
690     require(
691       isOfferInPair(_userOfferTokenAddress),
692       "_userOfferTokenAddress not in pair"
693     );
694     // check if the msg.value is consistent when offered token address is eth
695     if (isETH(_userOfferTokenAddress)) {
696       require(_userOfferTokenAmount == msg.value, "msg.value != _userOfferTokenAmount");
697     } else {
698       require(msg.value == 0, "msg.value != 0");
699     }
700     bool isUserBuy = isBuy(_userOfferTokenAddress);
701     uint toWalletAmount = _userOfferTokenAmount;
702     uint toUserAmount = getAmount(
703       _userOfferTokenAmount,
704       isUserBuy
705     );
706     require(toUserAmount > 0, "toUserAmount must be greater than 0");
707     if (isUserBuy) {
708       // send the quote to wallet
709       require(
710         _transferAmounts(
711           msg.sender,
712           wallet,
713           quoteTokenAddress,
714           toWalletAmount
715         ),
716         "the transfer from of the quote the user to the TokenSwap SC failed"
717       );
718       // send the base to user
719       require(
720         _transferAmounts(
721           wallet,
722           msg.sender,
723           baseTokenAddress,
724           toUserAmount
725         ),
726         "the transfer of the base from the TokenSwap SC to the user failed"
727       );
728       emit LogTokenSwap(
729         msg.sender,
730         quoteTokenAddress,
731         toWalletAmount,
732         baseTokenAddress,
733         toUserAmount
734       );
735     } else {
736       // send the base to wallet
737       require(
738         _transferAmounts(
739           msg.sender,
740           wallet,
741           baseTokenAddress,
742           toWalletAmount
743         ),
744         "the transfer of the base from the user to the TokenSwap SC failed"
745       );
746       // send the quote to user
747       require(
748         _transferAmounts(
749           wallet,
750           msg.sender,
751           quoteTokenAddress,
752           toUserAmount
753         ),
754         "the transfer of the quote from the TokenSwap SC to the user failed"
755       );
756       emit LogTokenSwap(
757         msg.sender,
758         baseTokenAddress,
759         toWalletAmount,
760         quoteTokenAddress,
761         toUserAmount
762       );
763     }
764     return true;
765   }
766 
767   /**
768    * @dev Transfer amounts from user to this contract and vice versa.
769    * @param _from The 'from' address.
770    * @param _to The 'to' address.
771    * @param _tokenAddress The asset to be transfer.
772    * @param _amount The amount to be transfer.
773    * @return bool.
774    */
775   function _transferAmounts(
776     address _from,
777     address _to,
778     address _tokenAddress,
779     uint _amount
780   )
781     private
782     returns (bool)
783   {
784     if (isETH(_tokenAddress)) {
785       if (_from == wallet) {
786         require(
787           IWallet(_from).transferAssetTo(
788             _tokenAddress,
789             _to,
790             _amount
791           ),
792           "trasnsferAssetTo failed"
793         );
794       } else {
795         _to.transfer(_amount);
796       }
797     } else {
798       if (_from == wallet) {
799         require(
800           IWallet(_from).transferAssetTo(
801             _tokenAddress,
802             _to,
803             _amount
804           ),
805           "trasnsferAssetTo failed"
806         );
807       } else {
808         require(
809           SafeTransfer._safeTransferFrom(
810             _tokenAddress,
811             _from,
812             _to,
813             _amount
814         ),
815           "transferFrom reserve to _receiver failed"
816         );
817       }
818     }
819     return true;
820   }
821 }
822 
823 // File: contracts/TokenSwapOneDir.sol
824 
825 pragma solidity ^0.4.24;
826 
827 
828 contract TokenSwapOneDir is TokenSwap
829 {
830   constructor(
831     address _baseTokenAddress,
832     address _quoteTokenAddress,
833     address _wallet,
834     uint _buyRate,
835     uint _buyRateDecimals
836   )
837     public
838     TokenSwap(
839       _baseTokenAddress,
840       _quoteTokenAddress,
841       _wallet,
842       _buyRate,
843       _buyRateDecimals,
844       1,
845       0
846     )
847   {}
848 
849   function swapToken (
850     address _userOfferTokenAddress,
851     uint _userOfferTokenAmount
852   )
853     public
854     payable
855     returns (bool)
856   {
857     require(_userOfferTokenAddress == quoteTokenAddress);
858     return super.swapToken (_userOfferTokenAddress, _userOfferTokenAmount);
859   }
860 }