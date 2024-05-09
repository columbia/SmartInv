1 pragma solidity 0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to relinquish control of the contract.
36    * @notice Renouncing to ownership will leave the contract without an owner.
37    * It will not be possible to call the functions with the `onlyOwner`
38    * modifier anymore.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 library ERC20SafeTransfer {
65     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
66 
67         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
68 
69         return fetchReturnData();
70     }
71 
72     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
73 
74         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
75 
76         return fetchReturnData();
77     }
78 
79     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
80 
81         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
82 
83         return fetchReturnData();
84     }
85 
86     function fetchReturnData() internal returns (bool success){
87         assembly {
88             switch returndatasize()
89             case 0 {
90                 success := 1
91             }
92             case 32 {
93                 returndatacopy(0, 0, 32)
94                 success := mload(0)
95             }
96             default {
97                 revert(0, 0)
98             }
99         }
100     }
101 
102 }
103 
104 /// @title A contract which allows its owner to withdraw any ether which is contained inside
105 contract Withdrawable is Ownable {
106 
107     /// @notice Withdraw ether contained in this contract and send it back to owner
108     /// @dev onlyOwner modifier only allows the contract owner to run the code
109     /// @param _token The address of the token that the user wants to withdraw
110     /// @param _amount The amount of tokens that the caller wants to withdraw
111     /// @return bool value indicating whether the transfer was successful
112     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
113         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
114     }
115 
116     /// @notice Withdraw ether contained in this contract and send it back to owner
117     /// @dev onlyOwner modifier only allows the contract owner to run the code
118     /// @param _amount The amount of ether that the caller wants to withdraw
119     function withdrawETH(uint256 _amount) external onlyOwner {
120         owner.transfer(_amount);
121     }
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 {
129   function totalSupply() public view returns (uint256);
130 
131   function balanceOf(address _who) public view returns (uint256);
132 
133   function allowance(address _owner, address _spender)
134     public view returns (uint256);
135 
136   function transfer(address _to, uint256 _value) public returns (bool);
137 
138   function approve(address _spender, uint256 _value)
139     public returns (bool);
140 
141   function transferFrom(address _from, address _to, uint256 _value)
142     public returns (bool);
143 
144   function decimals() public view returns (uint256);
145 
146   event Transfer(
147     address indexed from,
148     address indexed to,
149     uint256 value
150   );
151 
152   event Approval(
153     address indexed owner,
154     address indexed spender,
155     uint256 value
156   );
157 }
158 
159 /*
160 
161   Copyright 2018 ZeroEx Intl.
162 
163   Licensed under the Apache License, Version 2.0 (the "License");
164   you may not use this file except in compliance with the License.
165   You may obtain a copy of the License at
166 
167     http://www.apache.org/licenses/LICENSE-2.0
168 
169   Unless required by applicable law or agreed to in writing, software
170   distributed under the License is distributed on an "AS IS" BASIS,
171   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
172   See the License for the specific language governing permissions and
173   limitations under the License.
174 
175 */
176 
177 pragma solidity 0.4.25;
178 
179 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
180 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
181 contract TokenTransferProxy is Ownable {
182 
183     /// @dev Only authorized addresses can invoke functions with this modifier.
184     modifier onlyAuthorized {
185         require(authorized[msg.sender]);
186         _;
187     }
188 
189     modifier targetAuthorized(address target) {
190         require(authorized[target]);
191         _;
192     }
193 
194     modifier targetNotAuthorized(address target) {
195         require(!authorized[target]);
196         _;
197     }
198 
199     mapping (address => bool) public authorized;
200     address[] public authorities;
201 
202     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
203     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
204 
205     /*
206      * Public functions
207      */
208 
209     /// @dev Authorizes an address.
210     /// @param target Address to authorize.
211     function addAuthorizedAddress(address target)
212         public
213         onlyOwner
214         targetNotAuthorized(target)
215     {
216         authorized[target] = true;
217         authorities.push(target);
218         emit LogAuthorizedAddressAdded(target, msg.sender);
219     }
220 
221     /// @dev Removes authorizion of an address.
222     /// @param target Address to remove authorization from.
223     function removeAuthorizedAddress(address target)
224         public
225         onlyOwner
226         targetAuthorized(target)
227     {
228         delete authorized[target];
229         for (uint i = 0; i < authorities.length; i++) {
230             if (authorities[i] == target) {
231                 authorities[i] = authorities[authorities.length - 1];
232                 authorities.length -= 1;
233                 break;
234             }
235         }
236         emit LogAuthorizedAddressRemoved(target, msg.sender);
237     }
238 
239     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
240     /// @param token Address of token to transfer.
241     /// @param from Address to transfer token from.
242     /// @param to Address to transfer token to.
243     /// @param value Amount of token to transfer.
244     /// @return Success of transfer.
245     function transferFrom(
246         address token,
247         address from,
248         address to,
249         uint value)
250         public
251         onlyAuthorized
252         returns (bool)
253     {
254         return ERC20(token).transferFrom(from, to, value);
255     }
256 
257     /*
258      * Public constant functions
259      */
260 
261     /// @dev Gets all authorized addresses.
262     /// @return Array of authorized addresses.
263     function getAuthorizedAddresses()
264         public
265         view
266         returns (address[])
267     {
268         return authorities;
269     }
270 }
271 
272 /**
273  * @title Pausable
274  * @dev Base contract which allows children to implement an emergency stop mechanism.
275  */
276 contract Pausable is Ownable {
277   event Paused();
278   event Unpaused();
279 
280   bool private _paused = false;
281 
282   /**
283    * @return true if the contract is paused, false otherwise.
284    */
285   function paused() public view returns (bool) {
286     return _paused;
287   }
288 
289   /**
290    * @dev Modifier to make a function callable only when the contract is not paused.
291    */
292   modifier whenNotPaused() {
293     require(!_paused, "Contract is paused.");
294     _;
295   }
296 
297   /**
298    * @dev Modifier to make a function callable only when the contract is paused.
299    */
300   modifier whenPaused() {
301     require(_paused, "Contract not paused.");
302     _;
303   }
304 
305   /**
306    * @dev called by the owner to pause, triggers stopped state
307    */
308   function pause() public onlyOwner whenNotPaused {
309     _paused = true;
310     emit Paused();
311   }
312 
313   /**
314    * @dev called by the owner to unpause, returns to normal state
315    */
316   function unpause() public onlyOwner whenPaused {
317     _paused = false;
318     emit Unpaused();
319   }
320 }
321 
322 /**
323  * @title SafeMath
324  * @dev Math operations with safety checks that revert on error
325  */
326 library SafeMath {
327 
328   /**
329   * @dev Multiplies two numbers, reverts on overflow.
330   */
331   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
332     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
333     // benefit is lost if 'b' is also tested.
334     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
335     if (_a == 0) {
336       return 0;
337     }
338 
339     uint256 c = _a * _b;
340     require(c / _a == _b);
341 
342     return c;
343   }
344 
345   /**
346   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
347   */
348   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
349     require(_b > 0); // Solidity only automatically asserts when dividing by 0
350     uint256 c = _a / _b;
351     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
352 
353     return c;
354   }
355 
356   /**
357   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
358   */
359   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
360     require(_b <= _a);
361     uint256 c = _a - _b;
362 
363     return c;
364   }
365 
366   /**
367   * @dev Adds two numbers, reverts on overflow.
368   */
369   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
370     uint256 c = _a + _b;
371     require(c >= _a);
372 
373     return c;
374   }
375 
376   /**
377   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
378   * reverts when dividing by zero.
379   */
380   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
381     require(b != 0);
382     return a % b;
383   }
384 }
385 
386 /*
387     Modified Util contract as used by Kyber Network
388 */
389 
390 library Utils {
391 
392     uint256 constant internal PRECISION = (10**18);
393     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
394     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
395     uint256 constant internal MAX_DECIMALS = 18;
396     uint256 constant internal ETH_DECIMALS = 18;
397     uint256 constant internal MAX_UINT = 2**256-1;
398 
399     // Currently constants can't be accessed from other contracts, so providing functions to do that here
400     function precision() internal pure returns (uint256) { return PRECISION; }
401     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
402     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
403     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
404     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
405     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
406 
407     /// @notice Retrieve the number of decimals used for a given ERC20 token
408     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
409     /// ensure that an exception doesn't cause transaction failure
410     /// @param token the token for which we should retrieve the decimals
411     /// @return decimals the number of decimals in the given token
412     function getDecimals(address token)
413         internal
414         view
415         returns (uint256 decimals)
416     {
417         bytes4 functionSig = bytes4(keccak256("decimals()"));
418 
419         /// @dev Using assembly due to issues with current solidity `address.call()`
420         /// implementation: https://github.com/ethereum/solidity/issues/2884
421         assembly {
422             // Pointer to next free memory slot
423             let ptr := mload(0x40)
424             // Store functionSig variable at ptr
425             mstore(ptr,functionSig)
426             let functionSigLength := 0x04
427             let wordLength := 0x20
428 
429             let success := call(
430                                 5000, // Amount of gas
431                                 token, // Address to call
432                                 0, // ether to send
433                                 ptr, // ptr to input data
434                                 functionSigLength, // size of data
435                                 ptr, // where to store output data (overwrite input)
436                                 wordLength // size of output data (32 bytes)
437                                )
438 
439             switch success
440             case 0 {
441                 decimals := 18 // If the token doesn't implement `decimals()`, return 18 as default
442             }
443             case 1 {
444                 decimals := mload(ptr) // Set decimals to return data from call
445             }
446             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
447         }
448     }
449 
450     /// @dev Checks that a given address has its token allowance and balance set above the given amount
451     /// @param tokenOwner the address which should have custody of the token
452     /// @param tokenAddress the address of the token to check
453     /// @param tokenAmount the amount of the token which should be set
454     /// @param addressToAllow the address which should be allowed to transfer the token
455     /// @return bool true if the allowance and balance is set, false if not
456     function tokenAllowanceAndBalanceSet(
457         address tokenOwner,
458         address tokenAddress,
459         uint256 tokenAmount,
460         address addressToAllow
461     )
462         internal
463         view
464         returns (bool)
465     {
466         return (
467             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
468             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
469         );
470     }
471 
472     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
473         if (dstDecimals >= srcDecimals) {
474             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
475             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
476         } else {
477             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
478             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
479         }
480     }
481 
482     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
483 
484         //source quantity is rounded up. to avoid dest quantity being too low.
485         uint numerator;
486         uint denominator;
487         if (srcDecimals >= dstDecimals) {
488             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
489             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
490             denominator = rate;
491         } else {
492             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
493             numerator = (PRECISION * dstQty);
494             denominator = (rate * (10**(dstDecimals - srcDecimals)));
495         }
496         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
497     }
498 
499     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
500         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
501     }
502 
503     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
504         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
505     }
506 
507     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
508         internal pure returns (uint)
509     {
510         require(srcAmount <= MAX_QTY);
511         require(destAmount <= MAX_QTY);
512 
513         if (dstDecimals >= srcDecimals) {
514             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
515             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
516         } else {
517             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
518             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
519         }
520     }
521 
522     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
523     function min(uint256 a, uint256 b) internal pure returns (uint256) {
524         return a < b ? a : b;
525     }
526 }
527 
528 contract ErrorReporter {
529     function revertTx(string reason) public pure {
530         revert(reason);
531     }
532 }
533 
534 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
535 /// some functions
536 /// @dev Defines a modifier which should be used when only the totle contract should
537 /// able able to call a function
538 contract TotleControl is Ownable {
539     address public totlePrimary;
540 
541     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
542     modifier onlyTotle() {
543         require(msg.sender == totlePrimary);
544         _;
545     }
546 
547     /// @notice Contract constructor
548     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
549     /// @param _totlePrimary the address of the contract to be set as totlePrimary
550     constructor(address _totlePrimary) public {
551         require(_totlePrimary != address(0x0));
552         totlePrimary = _totlePrimary;
553     }
554 
555     /// @notice A function which allows only the owner to change the address of totlePrimary
556     /// @dev onlyOwner modifier only allows the contract owner to run the code
557     /// @param _totlePrimary the address of the contract to be set as totlePrimary
558     function setTotle(
559         address _totlePrimary
560     ) external onlyOwner {
561         require(_totlePrimary != address(0x0));
562         totlePrimary = _totlePrimary;
563     }
564 }
565 
566 contract SelectorProvider {
567     bytes4 constant getAmountToGive = bytes4(keccak256("getAmountToGive(bytes)"));
568     bytes4 constant staticExchangeChecks = bytes4(keccak256("staticExchangeChecks(bytes)"));
569     bytes4 constant performBuyOrder = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
570     bytes4 constant performSellOrder = bytes4(keccak256("performSellOrder(bytes,uint256)"));
571 
572     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
573 }
574 
575 /// @title Interface for all exchange handler contracts
576 contract ExchangeHandler is TotleControl, Withdrawable, Pausable {
577 
578     /*
579     *   State Variables
580     */
581 
582     SelectorProvider public selectorProvider;
583     ErrorReporter public errorReporter;
584     /* Logger public logger; */
585     /*
586     *   Modifiers
587     */
588 
589     modifier onlySelf() {
590         require(msg.sender == address(this));
591         _;
592     }
593 
594     /// @notice Constructor
595     /// @dev Calls the constructor of the inherited TotleControl
596     /// @param _selectorProvider the provider for this exchanges function selectors
597     /// @param totlePrimary the address of the totlePrimary contract
598     constructor(
599         address _selectorProvider,
600         address totlePrimary,
601         address _errorReporter
602         /* ,address _logger */
603     )
604         TotleControl(totlePrimary)
605         public
606     {
607         require(_selectorProvider != address(0x0));
608         require(_errorReporter != address(0x0));
609         /* require(_logger != address(0x0)); */
610         selectorProvider = SelectorProvider(_selectorProvider);
611         errorReporter = ErrorReporter(_errorReporter);
612         /* logger = Logger(_logger); */
613     }
614 
615     /// @notice Gets the amount that Totle needs to give for this order
616     /// @param genericPayload the data for this order in a generic format
617     /// @return amountToGive amount taker needs to give in order to fill the order
618     function getAmountToGive(
619         bytes genericPayload
620     )
621         public
622         view
623         onlyTotle
624         whenNotPaused
625         returns (uint256 amountToGive)
626     {
627         bool success;
628         bytes4 functionSelector = selectorProvider.getSelector(this.getAmountToGive.selector);
629 
630         assembly {
631             let functionSelectorLength := 0x04
632             let functionSelectorOffset := 0x1C
633             let scratchSpace := 0x0
634             let wordLength := 0x20
635             let bytesLength := mload(genericPayload)
636             let totalLength := add(functionSelectorLength, bytesLength)
637             let startOfNewData := add(genericPayload, functionSelectorOffset)
638 
639             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
640             let functionSelectorCorrect := mload(scratchSpace)
641             mstore(genericPayload, functionSelectorCorrect)
642 
643             success := call(
644                             gas,
645                             address, // This address of the current contract
646                             callvalue,
647                             startOfNewData, // Start data at the beginning of the functionSelector
648                             totalLength, // Total length of all data, including functionSelector
649                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
650                             wordLength // Length of return variable is one word
651                            )
652             amountToGive := mload(scratchSpace)
653             if eq(success, 0) { revert(0, 0) }
654         }
655     }
656 
657     /// @notice Perform exchange-specific checks on the given order
658     /// @dev this should be called to check for payload errors
659     /// @param genericPayload the data for this order in a generic format
660     /// @return checksPassed value representing pass or fail
661     function staticExchangeChecks(
662         bytes genericPayload
663     )
664         public
665         view
666         onlyTotle
667         whenNotPaused
668         returns (bool checksPassed)
669     {
670         bool success;
671         bytes4 functionSelector = selectorProvider.getSelector(this.staticExchangeChecks.selector);
672         assembly {
673             let functionSelectorLength := 0x04
674             let functionSelectorOffset := 0x1C
675             let scratchSpace := 0x0
676             let wordLength := 0x20
677             let bytesLength := mload(genericPayload)
678             let totalLength := add(functionSelectorLength, bytesLength)
679             let startOfNewData := add(genericPayload, functionSelectorOffset)
680 
681             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
682             let functionSelectorCorrect := mload(scratchSpace)
683             mstore(genericPayload, functionSelectorCorrect)
684 
685             success := call(
686                             gas,
687                             address, // This address of the current contract
688                             callvalue,
689                             startOfNewData, // Start data at the beginning of the functionSelector
690                             totalLength, // Total length of all data, including functionSelector
691                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
692                             wordLength // Length of return variable is one word
693                            )
694             checksPassed := mload(scratchSpace)
695             if eq(success, 0) { revert(0, 0) }
696         }
697     }
698 
699     /// @notice Perform a buy order at the exchange
700     /// @param genericPayload the data for this order in a generic format
701     /// @param  amountToGiveForOrder amount that should be spent on this order
702     /// @return amountSpentOnOrder the amount that would be spent on the order
703     /// @return amountReceivedFromOrder the amount that was received from this order
704     function performBuyOrder(
705         bytes genericPayload,
706         uint256 amountToGiveForOrder
707     )
708         public
709         payable
710         onlyTotle
711         whenNotPaused
712         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
713     {
714         bool success;
715         bytes4 functionSelector = selectorProvider.getSelector(this.performBuyOrder.selector);
716         assembly {
717             let callDataOffset := 0x44
718             let functionSelectorOffset := 0x1C
719             let functionSelectorLength := 0x04
720             let scratchSpace := 0x0
721             let wordLength := 0x20
722             let startOfFreeMemory := mload(0x40)
723 
724             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
725 
726             let bytesLength := mload(startOfFreeMemory)
727             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
728 
729             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
730 
731             let functionSelectorCorrect := mload(scratchSpace)
732 
733             mstore(startOfFreeMemory, functionSelectorCorrect)
734 
735             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
736 
737             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
738 
739             success := call(
740                             gas,
741                             address, // This address of the current contract
742                             callvalue,
743                             startOfNewData, // Start data at the beginning of the functionSelector
744                             totalLength, // Total length of all data, including functionSelector
745                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
746                             mul(wordLength, 0x02) // Length of return variables is two words
747                           )
748             amountSpentOnOrder := mload(scratchSpace)
749             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
750             if eq(success, 0) { revert(0, 0) }
751         }
752     }
753 
754     /// @notice Perform a sell order at the exchange
755     /// @param genericPayload the data for this order in a generic format
756     /// @param  amountToGiveForOrder amount that should be spent on this order
757     /// @return amountSpentOnOrder the amount that would be spent on the order
758     /// @return amountReceivedFromOrder the amount that was received from this order
759     function performSellOrder(
760         bytes genericPayload,
761         uint256 amountToGiveForOrder
762     )
763         public
764         onlyTotle
765         whenNotPaused
766         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
767     {
768         bool success;
769         bytes4 functionSelector = selectorProvider.getSelector(this.performSellOrder.selector);
770         assembly {
771             let callDataOffset := 0x44
772             let functionSelectorOffset := 0x1C
773             let functionSelectorLength := 0x04
774             let scratchSpace := 0x0
775             let wordLength := 0x20
776             let startOfFreeMemory := mload(0x40)
777 
778             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
779 
780             let bytesLength := mload(startOfFreeMemory)
781             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
782 
783             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
784 
785             let functionSelectorCorrect := mload(scratchSpace)
786 
787             mstore(startOfFreeMemory, functionSelectorCorrect)
788 
789             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
790 
791             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
792 
793             success := call(
794                             gas,
795                             address, // This address of the current contract
796                             callvalue,
797                             startOfNewData, // Start data at the beginning of the functionSelector
798                             totalLength, // Total length of all data, including functionSelector
799                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
800                             mul(wordLength, 0x02) // Length of return variables is two words
801                           )
802             amountSpentOnOrder := mload(scratchSpace)
803             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
804             if eq(success, 0) { revert(0, 0) }
805         }
806     }
807 }
808 
809 /// @title The primary contract for Totle
810 contract TotlePrimary is Withdrawable, Pausable {
811 
812     /*
813     *   State Variables
814     */
815 
816     mapping(address => bool) public handlerWhitelistMap;
817     address[] public handlerWhitelistArray;
818 
819     address public tokenTransferProxy;
820     ErrorReporter public errorReporter;
821     /* Logger public logger; */
822 
823     /*
824     *   Types
825     */
826 
827     // Structs
828     struct Trade {
829         bool isSell;
830         address tokenAddress;
831         uint256 tokenAmount;
832         bool optionalTrade;
833         uint256 minimumExchangeRate;
834         uint256 minimumAcceptableTokenAmount;
835         Order[] orders;
836     }
837 
838     struct Order {
839         address exchangeHandler;
840         bytes genericPayload;
841     }
842 
843     struct TradeFlag {
844         bool ignoreTrade;
845         bool[] ignoreOrder;
846     }
847 
848     struct CurrentAmounts {
849         uint256 amountSpentOnTrade;
850         uint256 amountReceivedFromTrade;
851         uint256 amountLeftToSpendOnTrade;
852     }
853 
854     /*
855     *   Events
856     */
857 
858     event GenericEvent(
859         uint256 id
860         // bytes placeholderForEventData
861     );
862 
863     /*
864     *   Modifiers
865     */
866 
867     modifier handlerWhitelisted(address handler) {
868         if (!handlerWhitelistMap[handler]) {
869             errorReporter.revertTx("Handler not in whitelist");
870         }
871         _;
872     }
873 
874     modifier handlerNotWhitelisted(address handler) {
875         if (handlerWhitelistMap[handler]) {
876             errorReporter.revertTx("Handler already whitelisted");
877         }
878         _;
879     }
880 
881     /// @notice Constructor
882     /// @param _tokenTransferProxy address of the TokenTransferProxy
883     /// @param _errorReporter the address of the error reporter contract
884     constructor (address _tokenTransferProxy, address _errorReporter/*, address _logger*/) public {
885         require(_tokenTransferProxy != address(0x0));
886         require(_errorReporter != address(0x0));
887         /* require(_logger != address(0x0)); */
888         tokenTransferProxy = _tokenTransferProxy;
889         errorReporter = ErrorReporter(_errorReporter);
890         /* logger = Logger(_logger); */
891     }
892 
893     /*
894     *   Public functions
895     */
896 
897     /// @notice Add an exchangeHandler address to the whitelist
898     /// @dev onlyOwner modifier only allows the contract owner to run the code
899     /// @param handler Address of the exchange handler which permission needs adding
900     function addHandlerToWhitelist(address handler)
901         public
902         onlyOwner
903         handlerNotWhitelisted(handler)
904     {
905         handlerWhitelistMap[handler] = true;
906         handlerWhitelistArray.push(handler);
907         emit GenericEvent(1);
908     }
909 
910     /// @notice Remove an exchangeHandler address from the whitelist
911     /// @dev onlyOwner modifier only allows the contract owner to run the code
912     /// @param handler Address of the exchange handler which permission needs removing
913     function removeHandlerFromWhitelist(address handler)
914         public
915         onlyOwner
916         handlerWhitelisted(handler)
917     {
918         delete handlerWhitelistMap[handler];
919         for (uint i = 0; i < handlerWhitelistArray.length; i++) {
920             if (handlerWhitelistArray[i] == handler) {
921                 handlerWhitelistArray[i] = handlerWhitelistArray[handlerWhitelistArray.length - 1];
922                 handlerWhitelistArray.length -= 1;
923                 break;
924             }
925         }
926         emit GenericEvent(2);
927     }
928 
929     /// @notice Performs the requested portfolio rebalance
930     /// @param trades A dynamic array of trade structs
931     function performRebalance(
932         Trade[] trades
933     )
934         public
935         payable
936         whenNotPaused
937     {
938         /* logger.log("Starting Rebalance..."); */
939 
940         TradeFlag[] memory tradeFlags = initialiseTradeFlags(trades);
941 
942         staticChecks(trades, tradeFlags);
943 
944         /* logger.log("Static checks passed."); */
945 
946         transferTokens(trades, tradeFlags);
947 
948         /* logger.log("Tokens transferred."); */
949 
950         uint256 etherBalance = msg.value;
951 
952         /* logger.log("Ether balance arg2: etherBalance.", etherBalance); */
953 
954         for (uint256 i; i < trades.length; i++) {
955             Trade memory thisTrade = trades[i];
956             TradeFlag memory thisTradeFlag = tradeFlags[i];
957 
958             CurrentAmounts memory amounts = CurrentAmounts({
959                 amountSpentOnTrade: 0,
960                 amountReceivedFromTrade: 0,
961                 amountLeftToSpendOnTrade: thisTrade.isSell ? thisTrade.tokenAmount : calculateMaxEtherSpend(thisTrade, etherBalance)
962             });
963             /* logger.log("Going to perform trade. arg2: amountLeftToSpendOnTrade", amounts.amountLeftToSpendOnTrade); */
964 
965             performTrade(
966                 thisTrade,
967                 thisTradeFlag,
968                 amounts
969             );
970 
971             /* logger.log("Finished performing trade arg2: amountReceivedFromTrade, arg3: amountSpentOnTrade.", amounts.amountReceivedFromTrade, amounts.amountSpentOnTrade); */
972 
973             if (amounts.amountReceivedFromTrade == 0 && thisTrade.optionalTrade) {
974                 /* logger.log("Received 0 from trade and this is an optional trade. Skipping."); */
975                 continue;
976             }
977 
978             /* logger.log(
979                 "Going to check trade acceptable amounts arg2: amountSpentOnTrade, arg2: amountReceivedFromTrade.",
980                 amounts.amountSpentOnTrade,
981                 amounts.amountReceivedFromTrade
982             ); */
983 
984             if (!checkIfTradeAmountsAcceptable(thisTrade, amounts.amountSpentOnTrade, amounts.amountReceivedFromTrade)) {
985                 errorReporter.revertTx("Amounts spent/received in trade not acceptable");
986             }
987 
988             /* logger.log("Trade passed the acceptable amounts check."); */
989 
990             if (thisTrade.isSell) {
991                 /* logger.log(
992                     "This is a sell trade, adding ether to our balance arg2: etherBalance, arg3: amountReceivedFromTrade",
993                     etherBalance,
994                     amounts.amountReceivedFromTrade
995                 ); */
996                 etherBalance = SafeMath.add(etherBalance, amounts.amountReceivedFromTrade);
997             } else {
998                 /* logger.log(
999                     "This is a buy trade, deducting ether from our balance arg2: etherBalance, arg3: amountSpentOnTrade",
1000                     etherBalance,
1001                     amounts.amountSpentOnTrade
1002                 ); */
1003                 etherBalance = SafeMath.sub(etherBalance, amounts.amountSpentOnTrade);
1004             }
1005 
1006             /* logger.log("Transferring tokens to the user arg:6 tokenAddress.", 0,0,0,0, thisTrade.tokenAddress); */
1007 
1008             transferTokensToUser(
1009                 thisTrade.tokenAddress,
1010                 thisTrade.isSell ? amounts.amountLeftToSpendOnTrade : amounts.amountReceivedFromTrade
1011             );
1012 
1013         }
1014 
1015         if(etherBalance > 0) {
1016             /* logger.log("Got a positive ether balance, sending to the user arg2: etherBalance.", etherBalance); */
1017             msg.sender.transfer(etherBalance);
1018         }
1019     }
1020 
1021     /// @notice Performs static checks on the rebalance payload before execution
1022     /// @dev This function is public so a rebalance can be checked before performing a rebalance
1023     /// @param trades A dynamic array of trade structs
1024     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1025     function staticChecks(
1026         Trade[] trades,
1027         TradeFlag[] tradeFlags
1028     )
1029         public
1030         view
1031         whenNotPaused
1032     {
1033         bool previousBuyOccured = false;
1034 
1035         for (uint256 i; i < trades.length; i++) {
1036             Trade memory thisTrade = trades[i];
1037             if (thisTrade.isSell) {
1038                 if (previousBuyOccured) {
1039                     errorReporter.revertTx("A buy has occured before this sell");
1040                 }
1041 
1042                 if (!Utils.tokenAllowanceAndBalanceSet(msg.sender, thisTrade.tokenAddress, thisTrade.tokenAmount, tokenTransferProxy)) {
1043                     if (!thisTrade.optionalTrade) {
1044                         errorReporter.revertTx("Taker has not sent allowance/balance on a non-optional trade");
1045                     }
1046                     /* logger.log(
1047                         "Attempt to sell a token without allowance or sufficient balance arg2: tokenAmount, arg6: tokenAddress . Otional trade, ignoring.",
1048                         thisTrade.tokenAmount,
1049                         0,
1050                         0,
1051                         0,
1052                         thisTrade.tokenAddress
1053                     ); */
1054                     tradeFlags[i].ignoreTrade = true;
1055                     continue;
1056                 }
1057             } else {
1058                 previousBuyOccured = true;
1059             }
1060 
1061             /* logger.log("Checking that all the handlers are whitelisted."); */
1062             for (uint256 j; j < thisTrade.orders.length; j++) {
1063                 Order memory thisOrder = thisTrade.orders[j];
1064                 if ( !handlerWhitelistMap[thisOrder.exchangeHandler] ) {
1065                     /* logger.log(
1066                         "Trying to use a handler that is not whitelisted arg6: exchangeHandler.",
1067                         0,
1068                         0,
1069                         0,
1070                         0,
1071                         thisOrder.exchangeHandler
1072                     ); */
1073                     tradeFlags[i].ignoreOrder[j] = true;
1074                     continue;
1075                 }
1076             }
1077         }
1078     }
1079 
1080     /*
1081     *   Internal functions
1082     */
1083 
1084     /// @notice Initialises the trade flag struct
1085     /// @param trades the trades used to initialise the flags
1086     /// @return tradeFlags the initialised flags
1087     function initialiseTradeFlags(Trade[] trades)
1088         internal
1089         returns (TradeFlag[])
1090     {
1091         /* logger.log("Initializing trade flags."); */
1092         TradeFlag[] memory tradeFlags = new TradeFlag[](trades.length);
1093         for (uint256 i = 0; i < trades.length; i++) {
1094             tradeFlags[i].ignoreOrder = new bool[](trades[i].orders.length);
1095         }
1096         return tradeFlags;
1097     }
1098 
1099     /// @notice Transfers the given amount of tokens back to the msg.sender
1100     /// @param tokenAddress the address of the token to transfer
1101     /// @param tokenAmount the amount of tokens to transfer
1102     function transferTokensToUser(
1103         address tokenAddress,
1104         uint256 tokenAmount
1105     )
1106         internal
1107     {
1108         /* logger.log("Transfering tokens to the user arg2: tokenAmount, arg6: .tokenAddress", tokenAmount, 0, 0, 0, tokenAddress); */
1109         if (tokenAmount > 0) {
1110             if (!ERC20SafeTransfer.safeTransfer(tokenAddress, msg.sender, tokenAmount)) {
1111                 errorReporter.revertTx("Unable to transfer tokens to user");
1112             }
1113         }
1114     }
1115 
1116     /// @notice Executes the given trade
1117     /// @param trade a struct containing information about the trade
1118     /// @param tradeFlag a struct containing trade status information
1119     /// @param amounts a struct containing information about amounts spent
1120     /// and received in the rebalance
1121     function performTrade(
1122         Trade trade,
1123         TradeFlag tradeFlag,
1124         CurrentAmounts amounts
1125     )
1126         internal
1127     {
1128         /* logger.log("Performing trade"); */
1129 
1130         for (uint256 j; j < trade.orders.length; j++) {
1131 
1132             /* logger.log("Processing order arg2: orderIndex", j); */
1133 
1134             //TODO: Change to the amount of tokens that we are trying to get
1135             if( amounts.amountReceivedFromTrade >= trade.minimumAcceptableTokenAmount ) {
1136                 /* logger.log(
1137                     "Got the desired amount from the trade arg2: amountReceivedFromTrade, arg3: minimumAcceptableTokenAmount",
1138                     amounts.amountReceivedFromTrade,
1139                     trade.minimumAcceptableTokenAmount
1140                 ); */
1141                 return;
1142             }
1143 
1144             if (tradeFlag.ignoreOrder[j] || amounts.amountLeftToSpendOnTrade == 0) {
1145                 /* logger.log(
1146                     "Order ignore flag is set to true or have nothing left to spend arg2: amountLeftToSpendOnTrade",
1147                     amounts.amountLeftToSpendOnTrade
1148                 ); */
1149                 continue;
1150             }
1151 
1152             uint256 amountSpentOnOrder = 0;
1153             uint256 amountReceivedFromOrder = 0;
1154 
1155             Order memory thisOrder = trade.orders[j];
1156 
1157             /* logger.log("Setting order exchange handler arg6: exchangeHandler.", 0, 0, 0, 0, thisOrder.exchangeHandler); */
1158             ExchangeHandler thisHandler = ExchangeHandler(thisOrder.exchangeHandler);
1159 
1160             uint256 amountToGiveForOrder = Utils.min(
1161                 thisHandler.getAmountToGive(thisOrder.genericPayload),
1162                 amounts.amountLeftToSpendOnTrade
1163             );
1164 
1165             if (amountToGiveForOrder == 0) {
1166                 /* logger.log(
1167                     "MASSIVE ERROR: amountToGiveForOrder was found to be 0, this hasn't been caught in preTradeChecks, which means dynamicExchangeChecks isnt written correctly!"
1168                 ); */
1169                 continue;
1170             }
1171 
1172             /* logger.log(
1173                 "Calculating amountToGiveForOrder arg2: amountToGiveForOrder, arg3: amountLeftToSpendOnTrade.",
1174                 amountToGiveForOrder,
1175                 amounts.amountLeftToSpendOnTrade
1176             ); */
1177 
1178             if( !thisHandler.staticExchangeChecks(thisOrder.genericPayload) ) {
1179                 /* logger.log("Order did not pass checks, skipping."); */
1180                 continue;
1181             }
1182 
1183             if (trade.isSell) {
1184                 /* logger.log("This is a sell.."); */
1185                 if (!ERC20SafeTransfer.safeTransfer(trade.tokenAddress,address(thisHandler), amountToGiveForOrder)) {
1186                     if( !trade.optionalTrade ) errorReporter.revertTx("Unable to transfer tokens to handler");
1187                     else {
1188                         /* logger.log("Unable to transfer tokens to handler but the trade is optional"); */
1189                         return;
1190                     }
1191                 }
1192 
1193                 /* logger.log("Going to perform a sell order."); */
1194                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performSellOrder(thisOrder.genericPayload, amountToGiveForOrder);
1195                 /* logger.log("Sell order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1196             } else {
1197                 /* logger.log("Going to perform a buy order."); */
1198                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performBuyOrder.value(amountToGiveForOrder)(thisOrder.genericPayload, amountToGiveForOrder);
1199                 /* logger.log("Buy order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1200             }
1201 
1202             if (amountReceivedFromOrder > 0) {
1203                 amounts.amountLeftToSpendOnTrade = SafeMath.sub(amounts.amountLeftToSpendOnTrade, amountSpentOnOrder);
1204                 amounts.amountSpentOnTrade = SafeMath.add(amounts.amountSpentOnTrade, amountSpentOnOrder);
1205                 amounts.amountReceivedFromTrade = SafeMath.add(amounts.amountReceivedFromTrade, amountReceivedFromOrder);
1206 
1207                 /* logger.log(
1208                     "Updated amounts arg2: amountLeftToSpendOnTrade, arg3: amountSpentOnTrade, arg4: amountReceivedFromTrade.",
1209                     amounts.amountLeftToSpendOnTrade,
1210                     amounts.amountSpentOnTrade,
1211                     amounts.amountReceivedFromTrade
1212                 ); */
1213             }
1214         }
1215 
1216     }
1217 
1218     /// @notice Check if the amounts spent and gained on a trade are within the
1219     /// user"s set limits
1220     /// @param trade contains information on the given trade
1221     /// @param amountSpentOnTrade the amount that was spent on the trade
1222     /// @param amountReceivedFromTrade the amount that was received from the trade
1223     /// @return bool whether the trade passes the checks
1224     function checkIfTradeAmountsAcceptable(
1225         Trade trade,
1226         uint256 amountSpentOnTrade,
1227         uint256 amountReceivedFromTrade
1228     )
1229         internal
1230         view
1231         returns (bool passed)
1232     {
1233         /* logger.log("Checking if trade amounts are acceptable."); */
1234         uint256 tokenAmount = trade.isSell ? amountSpentOnTrade : amountReceivedFromTrade;
1235         passed = tokenAmount >= trade.minimumAcceptableTokenAmount;
1236 
1237         if( !passed ) {
1238             /* logger.log(
1239                 "Received less than minimum acceptable tokens arg2: tokenAmount , arg3: minimumAcceptableTokenAmount.",
1240                 tokenAmount,
1241                 trade.minimumAcceptableTokenAmount
1242             ); */
1243         }
1244 
1245         if (passed) {
1246             uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1247             uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1248             uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1249             uint256 actualRate = Utils.calcRateFromQty(amountSpentOnTrade, amountReceivedFromTrade, srcDecimals, destDecimals);
1250             passed = actualRate >= trade.minimumExchangeRate;
1251         }
1252 
1253         if( !passed ) {
1254             /* logger.log(
1255                 "Order rate was lower than minimum acceptable,  rate arg2: actualRate, arg3: minimumExchangeRate.",
1256                 actualRate,
1257                 trade.minimumExchangeRate
1258             ); */
1259         }
1260     }
1261 
1262     /// @notice Iterates through a list of token orders, transfer the SELL orders to this contract & calculates if we have the ether needed
1263     /// @param trades A dynamic array of trade structs
1264     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1265     function transferTokens(Trade[] trades, TradeFlag[] tradeFlags) internal {
1266         for (uint256 i = 0; i < trades.length; i++) {
1267             if (trades[i].isSell && !tradeFlags[i].ignoreTrade) {
1268 
1269                 /* logger.log(
1270                     "Transfering tokens arg2: tokenAmount, arg5: tokenAddress.",
1271                     trades[i].tokenAmount,
1272                     0,
1273                     0,
1274                     0,
1275                     trades[i].tokenAddress
1276                 ); */
1277                 if (
1278                     !TokenTransferProxy(tokenTransferProxy).transferFrom(
1279                         trades[i].tokenAddress,
1280                         msg.sender,
1281                         address(this),
1282                         trades[i].tokenAmount
1283                     )
1284                 ) {
1285                     errorReporter.revertTx("TTP unable to transfer tokens to primary");
1286                 }
1287                 emit GenericEvent(3);
1288            }
1289         }
1290     }
1291 
1292     /// @notice Calculates the maximum amount that should be spent on a given buy trade
1293     /// @param trade the buy trade to return the spend amount for
1294     /// @param etherBalance the amount of ether that we currently have to spend
1295     /// @return uint256 the maximum amount of ether we should spend on this trade
1296     function calculateMaxEtherSpend(Trade trade, uint256 etherBalance) internal view returns (uint256) {
1297         /// @dev This function should never be called for a sell
1298         assert(!trade.isSell);
1299 
1300         uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1301         uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1302         uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1303         uint256 maxSpendAtMinRate = Utils.calcSrcQty(trade.tokenAmount, srcDecimals, destDecimals, trade.minimumExchangeRate);
1304 
1305         return Utils.min(etherBalance, maxSpendAtMinRate);
1306     }
1307 
1308     /*
1309     *   Payable fallback function
1310     */
1311 
1312     /// @notice payable fallback to allow handler or exchange contracts to return ether
1313     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
1314     function() public payable whenNotPaused {
1315         // Check in here that the sender is a contract! (to stop accidents)
1316         uint256 size;
1317         address sender = msg.sender;
1318         assembly {
1319             size := extcodesize(sender)
1320         }
1321         if (size == 0) {
1322             errorReporter.revertTx("EOA cannot send ether to primary fallback");
1323         }
1324     }
1325 }