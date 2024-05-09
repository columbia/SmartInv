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
379 }
380 
381 // File: contracts/TokenSwap.sol
382 
383 pragma solidity ^0.4.24;
384 
385 
386 
387 
388 
389 
390 
391 /**
392  * @title TokenSwap.
393  * @author Eidoo SAGL.
394  * @dev A swap asset contract. The offerAmount and wantAmount are collected and sent into the contract itself.
395  */
396 contract TokenSwap is
397   Pausable,
398   Destructible
399 {
400   using SafeMath for uint;
401 
402   address public baseTokenAddress;
403   address public quoteTokenAddress;
404 
405   address public wallet;
406 
407   uint public buyRate;
408   uint public buyRateDecimals;
409   uint public sellRate;
410   uint public sellRateDecimals;
411 
412   event LogWithdrawToken(
413     address indexed _from,
414     address indexed _token,
415     uint amount
416   );
417   event LogSetWallet(address indexed _wallet);
418   event LogSetBaseTokenAddress(address indexed _token);
419   event LogSetQuoteTokenAddress(address indexed _token);
420   event LogSetRateAndRateDecimals(
421     uint _buyRate,
422     uint _buyRateDecimals,
423     uint _sellRate,
424     uint _sellRateDecimals
425   );
426   event LogSetNumberOfZeroesFromLastDigit(
427     uint _numberOfZeroesFromLastDigit
428   );
429   event LogTokenSwap(
430     address indexed _userAddress,
431     address indexed _userSentTokenAddress,
432     uint _userSentTokenAmount,
433     address indexed _userReceivedTokenAddress,
434     uint _userReceivedTokenAmount
435   );
436 
437   /**
438    * @dev Contract constructor.
439    * @param _baseTokenAddress  The base of the swap pair.
440    * @param _quoteTokenAddress The quote of the swap pair.
441    * @param _buyRate Purchase rate, how many baseToken for the given quoteToken.
442    * @param _buyRateDecimals Define the decimals precision for the given asset.
443    * @param _sellRate Purchase rate, how many quoteToken for the given baseToken.
444    * @param _sellRateDecimals Define the decimals precision for the given asset.
445    */
446   constructor(
447     address _baseTokenAddress,
448     address _quoteTokenAddress,
449     address _wallet,
450     uint _buyRate,
451     uint _buyRateDecimals,
452     uint _sellRate,
453     uint _sellRateDecimals
454   )
455     public
456   {
457     require(_wallet != address(0), "_wallet == address(0)");
458     baseTokenAddress = _baseTokenAddress;
459     quoteTokenAddress = _quoteTokenAddress;
460     wallet = _wallet;
461     buyRate = _buyRate;
462     buyRateDecimals = _buyRateDecimals;
463     sellRate = _sellRate;
464     sellRateDecimals = _sellRateDecimals;
465   }
466 
467   function() external {
468     revert("fallback function not allowed");
469   }
470 
471   /**
472    * @dev Set base token address.
473    * @param _baseTokenAddress The pair base token address.
474    * @return bool.
475    */
476   function setBaseTokenAddress(address _baseTokenAddress)
477     public
478     onlyOwner
479     returns (bool)
480   {
481     baseTokenAddress = _baseTokenAddress;
482     emit LogSetBaseTokenAddress(_baseTokenAddress);
483     return true;
484   }
485 
486   /**
487    * @dev Set quote token address.
488    * @param _quoteTokenAddress The quote token address.
489    * @return bool.
490    */
491   function setQuoteTokenAddress(address _quoteTokenAddress)
492     public
493     onlyOwner
494     returns (bool)
495   {
496     quoteTokenAddress = _quoteTokenAddress;
497     emit LogSetQuoteTokenAddress(_quoteTokenAddress);
498     return true;
499   }
500 
501   /**
502    * @dev Set wallet sc address.
503    * @param _wallet The wallet sc address.
504    * @return bool.
505    */
506   function setWallet(address _wallet)
507     public
508     onlyOwner
509     returns (bool)
510   {
511     require(_wallet != address(0), "_wallet == address(0)");
512     wallet = _wallet;
513     emit LogSetWallet(_wallet);
514     return true;
515   }
516 
517   /**
518    * @dev Set rate.
519    * @param _buyRate Multiplier, how many base token for the quote token.
520    * @param _buyRateDecimals Number of significan digits of the rate.
521    * @param _sellRate Multiplier, how many quote token for the base token.
522    * @param _sellRateDecimals Number of significan digits of the rate.
523    * @return bool.
524    */
525   function setRateAndRateDecimals(
526     uint _buyRate,
527     uint _buyRateDecimals,
528     uint _sellRate,
529     uint _sellRateDecimals
530   )
531     public
532     onlyOwner
533     returns (bool)
534   {
535     require(_buyRate != buyRate, "_buyRate == buyRate");
536     require(_buyRate != 0, "_buyRate == 0");
537     require(_sellRate != sellRate, "_sellRate == sellRate");
538     require(_sellRate != 0, "_sellRate == 0");
539     buyRate = _buyRate;
540     sellRate = _sellRate;
541     buyRateDecimals = _buyRateDecimals;
542     sellRateDecimals = _sellRateDecimals;
543     emit LogSetRateAndRateDecimals(
544       _buyRate,
545       _buyRateDecimals,
546       _sellRate,
547       _sellRateDecimals
548     );
549     return true;
550   }
551 
552   /**
553    * @dev Withdraw asset.
554    * @param _tokenAddress Asset to be withdrawed.
555    * @return bool.
556    */
557   function withdrawToken(address _tokenAddress)
558     public
559     onlyOwner
560     returns(bool)
561   {
562     uint tokenBalance;
563     if (isETH(_tokenAddress)) {
564       tokenBalance = address(this).balance;
565       msg.sender.transfer(tokenBalance);
566     } else {
567       tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));
568       require(
569         SafeTransfer._safeTransfer(_tokenAddress, msg.sender, tokenBalance),
570         "withdraw transfer failed"
571       );
572     }
573     emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);
574     return true;
575   }
576 
577   /**
578    * @dev Understand if the user swap request is a BUY or a SELL.
579    * @param _offerTokenAddress The token address the purchaser is offering (It may be the quote or the base).
580    * @return bool.
581    */
582 
583   function isBuy(address _offerTokenAddress)
584     public
585     view
586     returns (bool)
587   {
588     return _offerTokenAddress == quoteTokenAddress;
589   }
590 
591   /**
592    * @dev Understand if the token is ETH or not.
593    * @param _tokenAddress The token address the purchaser is offering (It may be the quote or the base).
594    * @return bool.
595    */
596 
597   function isETH(address _tokenAddress)
598     public
599     pure
600     returns (bool)
601   {
602     return _tokenAddress == address(0);
603   }
604 
605   /**
606    * @dev Understand if the user swap request is for the available pair.
607    * @param _offerTokenAddress The token address the purchaser is offering (It may be the quote or the base).
608    * @return bool.
609    */
610 
611   function isOfferInPair(address _offerTokenAddress)
612     public
613     view
614     returns (bool)
615   {
616     return _offerTokenAddress == quoteTokenAddress ||
617       _offerTokenAddress == baseTokenAddress;
618   }
619 
620   /**
621    * @dev Function to calculate the number of tokens the user is going to receive.
622    * @param _offerTokenAmount The amount of tokne number of WEI to convert in ERC20.
623    * @return uint.
624    */
625   function getAmount(
626     uint _offerTokenAmount,
627     bool _isBuy
628   )
629     public
630     view
631     returns(uint)
632   {
633     uint amount;
634     if (_isBuy) {
635       amount = _offerTokenAmount.mul(buyRate).div(10 ** buyRateDecimals);
636     } else {
637       amount = _offerTokenAmount.mul(sellRate).div(10 ** sellRateDecimals);
638     }
639     return amount;
640   }
641 
642   /**
643    * @dev Release purchased asset to the buyer based on pair rate.
644    * @param _userOfferTokenAddress The token address the purchaser is offering (It may be the quote or the base).
645    * @param _userOfferTokenAmount The amount of token the user want to swap.
646    * @return bool.
647    */
648   function swapToken (
649     address _userOfferTokenAddress,
650     uint _userOfferTokenAmount
651   )
652     public
653     whenNotPaused
654     payable
655     returns (bool)
656   {
657     require(_userOfferTokenAmount != 0, "_userOfferTokenAmount == 0");
658     // check if offered token address is the base or the quote token address
659     require(
660       isOfferInPair(_userOfferTokenAddress),
661       "_userOfferTokenAddress not in pair"
662     );
663     // check if the msg.value is consistent when offered token address is eth
664     if (isETH(_userOfferTokenAddress)) {
665       require(_userOfferTokenAmount == msg.value, "msg.value != _userOfferTokenAmount");
666     } else {
667       require(msg.value == 0, "msg.value != 0");
668     }
669     bool isUserBuy = isBuy(_userOfferTokenAddress);
670     uint toWalletAmount = _userOfferTokenAmount;
671     uint toUserAmount = getAmount(
672       _userOfferTokenAmount,
673       isUserBuy
674     );
675     require(toUserAmount > 0, "toUserAmount must be greater than 0");
676     if (isUserBuy) {
677       // send the quote to wallet
678       require(
679         _transferAmounts(
680           msg.sender,
681           wallet,
682           quoteTokenAddress,
683           toWalletAmount
684         ),
685         "the transfer from of the quote the user to the TokenSwap SC failed"
686       );
687       // send the base to user
688       require(
689         _transferAmounts(
690           wallet,
691           msg.sender,
692           baseTokenAddress,
693           toUserAmount
694         ),
695         "the transfer of the base from the TokenSwap SC to the user failed"
696       );
697       emit LogTokenSwap(
698         msg.sender,
699         quoteTokenAddress,
700         toWalletAmount,
701         baseTokenAddress,
702         toUserAmount
703       );
704     } else {
705       // send the base to wallet
706       require(
707         _transferAmounts(
708           msg.sender,
709           wallet,
710           baseTokenAddress,
711           toWalletAmount
712         ),
713         "the transfer of the base from the user to the TokenSwap SC failed"
714       );
715       // send the quote to user
716       require(
717         _transferAmounts(
718           wallet,
719           msg.sender,
720           quoteTokenAddress,
721           toUserAmount
722         ),
723         "the transfer of the quote from the TokenSwap SC to the user failed"
724       );
725       emit LogTokenSwap(
726         msg.sender,
727         baseTokenAddress,
728         toWalletAmount,
729         quoteTokenAddress,
730         toUserAmount
731       );
732     }
733     return true;
734   }
735 
736   /**
737    * @dev Transfer amounts from user to this contract and vice versa.
738    * @param _from The 'from' address.
739    * @param _to The 'to' address.
740    * @param _tokenAddress The asset to be transfer.
741    * @param _amount The amount to be transfer.
742    * @return bool.
743    */
744   function _transferAmounts(
745     address _from,
746     address _to,
747     address _tokenAddress,
748     uint _amount
749   )
750     private
751     returns (bool)
752   {
753     if (isETH(_tokenAddress)) {
754       if (_from == wallet) {
755         require(
756           IWallet(_from).transferAssetTo(
757             _tokenAddress,
758             _to,
759             _amount
760           ),
761           "trasnsferAssetTo failed"
762         );
763       } else {
764         _to.transfer(_amount);
765       }
766     } else {
767       if (_from == wallet) {
768         require(
769           IWallet(_from).transferAssetTo(
770             _tokenAddress,
771             _to,
772             _amount
773           ),
774           "trasnsferAssetTo failed"
775         );
776       } else {
777         require(
778           SafeTransfer._safeTransferFrom(
779             _tokenAddress,
780             _from,
781             _to,
782             _amount
783         ),
784           "transferFrom reserve to _receiver failed"
785         );
786       }
787     }
788     return true;
789   }
790 }