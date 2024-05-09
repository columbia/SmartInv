1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-07
3 */
4 
5 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
6 
7 pragma solidity ^0.4.24;
8 
9 
10 /**
11  * @title ERC20Basic
12  * @dev Simpler version of ERC20 interface
13  * See https://github.com/ethereum/EIPs/issues/179
14  */
15 contract ERC20Basic {
16   function totalSupply() public view returns (uint256);
17   function balanceOf(address _who) public view returns (uint256);
18   function transfer(address _to, uint256 _value) public returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
23 
24 pragma solidity ^0.4.24;
25 
26 
27 
28 /**
29  * @title ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/20
31  */
32 contract ERC20 is ERC20Basic {
33   function allowance(address _owner, address _spender)
34     public view returns (uint256);
35 
36   function transferFrom(address _from, address _to, uint256 _value)
37     public returns (bool);
38 
39   function approve(address _spender, uint256 _value) public returns (bool);
40   event Approval(
41     address indexed owner,
42     address indexed spender,
43     uint256 value
44   );
45 }
46 
47 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
48 
49 pragma solidity ^0.4.24;
50 
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, throws on overflow.
60   */
61   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
62     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
63     // benefit is lost if 'b' is also tested.
64     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
65     if (_a == 0) {
66       return 0;
67     }
68 
69     c = _a * _b;
70     assert(c / _a == _b);
71     return c;
72   }
73 
74   /**
75   * @dev Integer division of two numbers, truncating the quotient.
76   */
77   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
78     // assert(_b > 0); // Solidity automatically throws when dividing by 0
79     // uint256 c = _a / _b;
80     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
81     return _a / _b;
82   }
83 
84   /**
85   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
86   */
87   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
88     assert(_b <= _a);
89     return _a - _b;
90   }
91 
92   /**
93   * @dev Adds two numbers, throws on overflow.
94   */
95   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
96     c = _a + _b;
97     assert(c >= _a);
98     return c;
99   }
100 }
101 
102 // File: contracts/Utils/Ownable.sol
103 
104 pragma solidity ^0.4.24;
105 
106 /**
107  * @title Ownable
108  * @dev The Ownable contract has an owner address, and provides basic authorization control
109  * functions, this simplifies the implementation of "user permissions".
110  */
111 contract Ownable {
112   address public owner;
113 
114 
115   event OwnershipRenounced(address indexed previousOwner);
116   event OwnershipTransferred(
117     address indexed previousOwner,
118     address indexed newOwner
119   );
120 
121 
122   /**
123    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
124    * account.
125    */
126   constructor() public {
127     owner = msg.sender;
128   }
129 
130   /**
131    * @dev Throws if called by any account other than the owner.
132    */
133   modifier onlyOwner() {
134     require(msg.sender == owner, "msg.sender not owner");
135     _;
136   }
137 
138   /**
139    * @dev Allows the current owner to relinquish control of the contract.
140    * @notice Renouncing to ownership will leave the contract without an owner.
141    * It will not be possible to call the functions with the `onlyOwner`
142    * modifier anymore.
143    */
144   function renounceOwnership() public onlyOwner {
145     emit OwnershipRenounced(owner);
146     owner = address(0);
147   }
148 
149   /**
150    * @dev Allows the current owner to transfer control of the contract to a newOwner.
151    * @param _newOwner The address to transfer ownership to.
152    */
153   function transferOwnership(address _newOwner) public onlyOwner {
154     _transferOwnership(_newOwner);
155   }
156 
157   /**
158    * @dev Transfers control of the contract to a newOwner.
159    * @param _newOwner The address to transfer ownership to.
160    */
161   function _transferOwnership(address _newOwner) internal {
162     require(_newOwner != address(0), "_newOwner == 0");
163     emit OwnershipTransferred(owner, _newOwner);
164     owner = _newOwner;
165   }
166 }
167 
168 // File: contracts/Utils/Destructible.sol
169 
170 pragma solidity ^0.4.24;
171 
172 
173 /**
174  * @title Destructible
175  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
176  */
177 contract Destructible is Ownable {
178   /**
179    * @dev Transfers the current balance to the owner and terminates the contract.
180    */
181   function destroy() public onlyOwner {
182     selfdestruct(owner);
183   }
184 
185   function destroyAndSend(address _recipient) public onlyOwner {
186     selfdestruct(_recipient);
187   }
188 }
189 
190 // File: contracts/Interfaces/IBadERC20.sol
191 
192 pragma solidity ^0.4.24;
193 
194 /**
195  * @title Bad formed ERC20 token interface.
196  * @dev The interface of the a bad formed ERC20 token.
197  */
198 interface IBadERC20 {
199     function transfer(address to, uint256 value) external;
200     function approve(address spender, uint256 value) external;
201     function transferFrom(
202       address from,
203       address to,
204       uint256 value
205     ) external;
206 
207     function totalSupply() external view returns (uint256);
208 
209     function balanceOf(
210       address who
211     ) external view returns (uint256);
212 
213     function allowance(
214       address owner,
215       address spender
216     ) external view returns (uint256);
217 
218     event Transfer(
219       address indexed from,
220       address indexed to,
221       uint256 value
222     );
223     event Approval(
224       address indexed owner,
225       address indexed spender,
226       uint256 value
227     );
228 }
229 
230 // File: contracts/Utils/SafeTransfer.sol
231 
232 pragma solidity ^0.4.24;
233 
234 
235 /**
236  * @title SafeTransfer
237  * @dev Transfer Bad ERC20 tokens
238  */
239 library SafeTransfer {
240 /**
241    * @dev Wrapping the ERC20 transferFrom function to avoid missing returns.
242    * @param _tokenAddress The address of bad formed ERC20 token.
243    * @param _from Transfer sender.
244    * @param _to Transfer receiver.
245    * @param _value Amount to be transfered.
246    * @return Success of the safeTransferFrom.
247    */
248 
249   function _safeTransferFrom(
250     address _tokenAddress,
251     address _from,
252     address _to,
253     uint256 _value
254   )
255     internal
256     returns (bool result)
257   {
258     IBadERC20(_tokenAddress).transferFrom(_from, _to, _value);
259 
260     assembly {
261       switch returndatasize()
262       case 0 {                      // This is our BadToken
263         result := not(0)            // result is true
264       }
265       case 32 {                     // This is our GoodToken
266         returndatacopy(0, 0, 32)
267         result := mload(0)          // result == returndata of external call
268       }
269       default {                     // This is not an ERC20 token
270         revert(0, 0)
271       }
272     }
273   }
274 
275   /**
276    * @dev Wrapping the ERC20 transfer function to avoid missing returns.
277    * @param _tokenAddress The address of bad formed ERC20 token.
278    * @param _to Transfer receiver.
279    * @param _amount Amount to be transfered.
280    * @return Success of the safeTransfer.
281    */
282   function _safeTransfer(
283     address _tokenAddress,
284     address _to,
285     uint _amount
286   )
287     internal
288     returns (bool result)
289   {
290     IBadERC20(_tokenAddress).transfer(_to, _amount);
291 
292     assembly {
293       switch returndatasize()
294       case 0 {                      // This is our BadToken
295         result := not(0)            // result is true
296       }
297       case 32 {                     // This is our GoodToken
298         returndatacopy(0, 0, 32)
299         result := mload(0)          // result == returndata of external call
300       }
301       default {                     // This is not an ERC20 token
302         revert(0, 0)
303       }
304     }
305   }
306 
307   function _safeApprove(
308     address _token,
309     address _spender,
310     uint256 _value
311   )
312   internal
313   returns (bool result)
314   {
315     IBadERC20(_token).approve(_spender, _value);
316 
317     assembly {
318       switch returndatasize()
319       case 0 {                      // This is our BadToken
320         result := not(0)            // result is true
321       }
322       case 32 {                     // This is our GoodToken
323         returndatacopy(0, 0, 32)
324         result := mload(0)          // result == returndata of external call
325       }
326       default {                     // This is not an ERC20 token
327         revert(0, 0)
328       }
329     }
330   }
331 }
332 
333 // File: contracts/Utils/Pausable.sol
334 
335 pragma solidity ^0.4.24;
336 
337 
338 
339 /**
340  * @title Pausable
341  * @dev Base contract which allows children to implement an emergency stop mechanism.
342  */
343 contract Pausable is Ownable {
344   event Pause();
345   event Unpause();
346 
347   bool public paused = false;
348 
349 
350   /**
351    * @dev Modifier to make a function callable only when the contract is not paused.
352    */
353   modifier whenNotPaused() {
354     require(!paused, "The contract is paused");
355     _;
356   }
357 
358   /**
359    * @dev Modifier to make a function callable only when the contract is paused.
360    */
361   modifier whenPaused() {
362     require(paused, "The contract is not paused");
363     _;
364   }
365 
366   /**
367    * @dev called by the owner to pause, triggers stopped state
368    */
369   function pause() public onlyOwner whenNotPaused {
370     paused = true;
371     emit Pause();
372   }
373 
374   /**
375    * @dev called by the owner to unpause, returns to normal state
376    */
377   function unpause() public onlyOwner whenPaused {
378     paused = false;
379     emit Unpause();
380   }
381 }
382 
383 // File: contracts/Interfaces/IErc20Swap.sol
384 
385 pragma solidity ^0.4.0;
386 
387 interface IErc20Swap {
388     function getRate(address src, address dst, uint256 srcAmount) external view returns(uint expectedRate, uint slippageRate);  // real rate = returned value / 1e18
389     function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) external payable;
390 }
391 
392 // File: contracts/Interfaces/IKyberNetwork.sol
393 
394 pragma solidity >=0.4.21 <0.6.0;
395 
396 interface IKyberNetwork {
397 
398     function getExpectedRate(address src, address dest, uint srcQty) external view
399         returns (uint expectedRate, uint slippageRate);
400 
401     function trade(
402         address src,
403         uint srcAmount,
404         address dest,
405         address destAddress,
406         uint maxDestAmount,
407         uint minConversionRate,
408         address walletId
409     ) external payable returns(uint256);
410 }
411 
412 // File: contracts/KyberTokenSwap.sol
413 
414 pragma solidity ^0.4.24;
415 
416 
417 
418 
419 
420 
421 
422 
423 /**
424  * @title TokenSwap.
425  * @author Eidoo SAGL.
426  * @dev A swap asset contract. The offerAmount and wantAmount are collected and sent into the contract itself.
427  */
428 contract KyberTokenSwap is Pausable, Destructible, IErc20Swap
429 {
430   using SafeMath for uint;
431   using SafeTransfer for ERC20;
432   address constant ETHER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
433   uint constant expScale = 1e18;
434   uint constant rateDecimals = 18;
435   uint constant rateUnit = 10 ** rateDecimals;
436 
437   IKyberNetwork public kyberNetwork;
438 
439   address public wallet;
440   address public kyberFeeWallet;
441 
442   uint public spreadDefault;
443   mapping (address => mapping (address => uint)) spreadCustom;
444   uint constant spreadDecimals = 6;
445   uint constant spreadUnit = 10 ** spreadDecimals;
446 
447   event LogWithdrawToken(
448     address indexed _from,
449     address indexed _token,
450     uint amount
451   );
452 
453   event LogTokenSwap(
454     address indexed _userAddress,
455     address indexed _userSentTokenAddress,
456     uint _userSentTokenAmount,
457     address indexed _userReceivedTokenAddress,
458     uint _userReceivedTokenAmount
459   );
460 
461   event LogFee(address token, uint amount);
462 
463   event UnexpectedIntialBalance(address token, uint amount);
464 
465   constructor(
466     address _kyberNetwork,
467     address _wallet,
468     address _kyberFeeWallet,
469     uint _spread
470   )
471     public
472   {
473     require(_wallet != address(0), "_wallet == address(0)");
474     require(_kyberNetwork != address(0), "_kyberNetwork == address(0)");
475     require(_spread < spreadUnit, "spread >= spreadUnit");
476     wallet = _wallet;
477     spreadDefault = _spread;
478     kyberNetwork = IKyberNetwork(_kyberNetwork);
479     kyberFeeWallet = _kyberFeeWallet;
480   }
481 
482   function() external payable {
483     // can receive ethers from KyberNetwork
484   }
485 
486   function setWallet(address _wallet) public onlyOwner {
487     require(_wallet != address(0), "_wallet == address(0)");
488     wallet = _wallet;
489   }
490 
491   function setKyberFeeWallet(address _wallet) public onlyOwner {
492     kyberFeeWallet = _wallet;
493   }
494 
495   function setSpreadDefault(uint _spread) public onlyOwner {
496     require(_spread < spreadUnit, "spread >= spreadUnit");
497     spreadDefault = _spread;
498   }
499 
500   // spread value >= spreadUnit means no fee
501   function setSpread(address tokenA, address tokenB, uint spread) public onlyOwner {
502     uint value = spread > spreadUnit ? spreadUnit : spread;
503     spreadCustom[tokenA][tokenB] = value;
504     spreadCustom[tokenB][tokenA] = value;
505   }
506 
507   function getSpread(address tokenA, address tokenB) public view returns(uint) {
508     uint value = spreadCustom[tokenA][tokenB];
509     if (value == 0) return spreadDefault;
510     if (value >= spreadUnit) return 0;
511     else return value;
512   }
513 
514   /**
515    * @dev Withdraw asset.
516    * @param _tokenAddress Asset to be withdrawed.
517    * @return bool.
518    */
519   function withdrawToken(address _tokenAddress)
520     public
521     onlyOwner
522   {
523     uint tokenBalance;
524     if (_tokenAddress == ETHER || _tokenAddress == address(0)) {
525       tokenBalance = address(this).balance;
526       msg.sender.transfer(tokenBalance);
527     } else {
528       tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));
529       ERC20(_tokenAddress)._safeTransfer(msg.sender, tokenBalance);
530     }
531     emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);
532   }
533 
534   /*******************  *******************/
535   function getRate(address src, address dest, uint256 srcAmount) external view
536     returns(uint expectedRate, uint slippageRate)
537   {
538     (uint256 kExpected, uint256 kSplippage) = kyberNetwork.getExpectedRate(src, dest, srcAmount);
539     uint256 spread = getSpread(src, dest);
540     expectedRate = kExpected.mul(spreadUnit - spread).div(spreadUnit);
541     slippageRate = kSplippage.mul(spreadUnit - spread).div(spreadUnit);
542   }
543 
544   function _freeUnexpectedTokens(address token) private {
545     uint256 unexpectedBalance = token == ETHER
546       ? address(this).balance.sub(msg.value)
547       : ERC20(token).balanceOf(address(this));
548     if (unexpectedBalance > 0) {
549       _transfer(token, wallet, unexpectedBalance);
550       emit UnexpectedIntialBalance(token, unexpectedBalance);
551     }
552   }
553 
554   function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) public payable {
555     require(src != dest, "src == dest");
556     require(srcAmount > 0, "srcAmount == 0");
557 
558     // empty unexpected initial balances
559     _freeUnexpectedTokens(src);
560     _freeUnexpectedTokens(dest);
561 
562     if (src == ETHER) {
563       require(msg.value == srcAmount, "msg.value != srcAmount");
564     } else {
565       require(
566         ERC20(src).allowance(msg.sender, address(this)) >= srcAmount,
567         "ERC20 allowance < srcAmount"
568       );
569       // get user's tokens
570       require(
571         ERC20(src)._safeTransferFrom(msg.sender, address(this), srcAmount),
572         "cannot transfer src token from msg.sender to this"
573       );
574     }
575 
576 //    (uint256 expectedRate, ) = kyberNetwork.getExpectedRate(src, dest, srcAmount);
577 //    require(expectedRate > 0, "expectedRate is 0, pair is not tradable");
578 
579     uint256 spread = getSpread(src, dest);
580 
581     uint256 destTradedAmount = _callKyberNetworkTrade(src, srcAmount, dest, maxDestAmount, minConversionRate, spread);
582 
583     uint256 notTraded = _myBalance(src);
584     uint256 srcTradedAmount = srcAmount.sub(notTraded);
585     require(srcTradedAmount > 0, "no traded tokens");
586     require(
587        _myBalance(dest) >= destTradedAmount,
588        "No enough dest tokens after trade"
589      );
590     // pay fee and user
591     uint256 toUserAmount = _payFee(dest, destTradedAmount, spread);
592     _transfer(dest, msg.sender, toUserAmount);
593     // returns not traded tokens if any
594     if (notTraded > 0) {
595       _transfer(src, msg.sender, notTraded);
596     }
597 
598     emit LogTokenSwap(
599       msg.sender,
600       src,
601       srcTradedAmount,
602       dest,
603       toUserAmount
604     );
605   }
606 
607   function _callKyberNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate, uint spread) private returns(uint256) {
608     // calculate the minConversionRate and maxDestAmount keeping in mind the fee
609     uint256 adaptedMinRate = minConversionRate.mul(spreadUnit).div(spreadUnit - spread);
610     uint256 adaptedMaxDestAmount = maxDestAmount.mul(spreadUnit).div(spreadUnit - spread);
611     if (src == ETHER) {
612       return kyberNetwork.trade
613         .value(srcAmount)(src, srcAmount, dest, address(this), adaptedMaxDestAmount, adaptedMinRate, kyberFeeWallet);
614     } else {
615       if (ERC20(src).allowance(address(this), address(kyberNetwork)) > 0) {
616         ERC20(src)._safeApprove(address(kyberNetwork), 0);
617       }
618       ERC20(src)._safeApprove(address(kyberNetwork), srcAmount);
619       return kyberNetwork.trade(src, srcAmount, dest, address(this), adaptedMaxDestAmount, adaptedMinRate, kyberFeeWallet);
620     }
621   }
622 
623   function _payFee(address token, uint destTradedAmount, uint spread) private returns(uint256 toUserAmount) {
624     uint256 fee = destTradedAmount.mul(spread).div(spreadUnit);
625     toUserAmount = destTradedAmount.sub(fee);
626     // pay fee
627     if (fee > 0) {
628       _transfer(token, wallet, fee);
629       emit LogFee(token, fee);
630     }
631   }
632 
633   function _myBalance(address token) private view returns(uint256) {
634     return token == ETHER
635       ? address(this).balance
636       : ERC20(token).balanceOf(address(this));
637   }
638 
639   function _transfer(address token, address recipient, uint256 amount) private {
640     if (token == ETHER) {
641       recipient.transfer(amount);
642     } else {
643       require(ERC20(token)._safeTransfer(recipient, amount), "cannot transfer tokens");
644     }
645   }
646 
647 }