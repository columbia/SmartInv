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
177 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
178 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
179 contract TokenTransferProxy is Ownable {
180 
181     /// @dev Only authorized addresses can invoke functions with this modifier.
182     modifier onlyAuthorized {
183         require(authorized[msg.sender]);
184         _;
185     }
186 
187     modifier targetAuthorized(address target) {
188         require(authorized[target]);
189         _;
190     }
191 
192     modifier targetNotAuthorized(address target) {
193         require(!authorized[target]);
194         _;
195     }
196 
197     mapping (address => bool) public authorized;
198     address[] public authorities;
199 
200     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
201     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
202 
203     /*
204      * Public functions
205      */
206 
207     /// @dev Authorizes an address.
208     /// @param target Address to authorize.
209     function addAuthorizedAddress(address target)
210         public
211         onlyOwner
212         targetNotAuthorized(target)
213     {
214         authorized[target] = true;
215         authorities.push(target);
216         emit LogAuthorizedAddressAdded(target, msg.sender);
217     }
218 
219     /// @dev Removes authorizion of an address.
220     /// @param target Address to remove authorization from.
221     function removeAuthorizedAddress(address target)
222         public
223         onlyOwner
224         targetAuthorized(target)
225     {
226         delete authorized[target];
227         for (uint i = 0; i < authorities.length; i++) {
228             if (authorities[i] == target) {
229                 authorities[i] = authorities[authorities.length - 1];
230                 authorities.length -= 1;
231                 break;
232             }
233         }
234         emit LogAuthorizedAddressRemoved(target, msg.sender);
235     }
236 
237     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
238     /// @param token Address of token to transfer.
239     /// @param from Address to transfer token from.
240     /// @param to Address to transfer token to.
241     /// @param value Amount of token to transfer.
242     /// @return Success of transfer.
243     function transferFrom(
244         address token,
245         address from,
246         address to,
247         uint value)
248         public
249         onlyAuthorized
250         returns (bool)
251     {
252         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
253         return true;
254     }
255 
256     /*
257      * Public constant functions
258      */
259 
260     /// @dev Gets all authorized addresses.
261     /// @return Array of authorized addresses.
262     function getAuthorizedAddresses()
263         public
264         view
265         returns (address[])
266     {
267         return authorities;
268     }
269 }
270 
271 /**
272  * @title Pausable
273  * @dev Base contract which allows children to implement an emergency stop mechanism.
274  */
275 contract Pausable is Ownable {
276   event Paused();
277   event Unpaused();
278 
279   bool private _paused = false;
280 
281   /**
282    * @return true if the contract is paused, false otherwise.
283    */
284   function paused() public view returns (bool) {
285     return _paused;
286   }
287 
288   /**
289    * @dev Modifier to make a function callable only when the contract is not paused.
290    */
291   modifier whenNotPaused() {
292     require(!_paused, "Contract is paused.");
293     _;
294   }
295 
296   /**
297    * @dev Modifier to make a function callable only when the contract is paused.
298    */
299   modifier whenPaused() {
300     require(_paused, "Contract not paused.");
301     _;
302   }
303 
304   /**
305    * @dev called by the owner to pause, triggers stopped state
306    */
307   function pause() public onlyOwner whenNotPaused {
308     _paused = true;
309     emit Paused();
310   }
311 
312   /**
313    * @dev called by the owner to unpause, returns to normal state
314    */
315   function unpause() public onlyOwner whenPaused {
316     _paused = false;
317     emit Unpaused();
318   }
319 }
320 
321 /**
322  * @title SafeMath
323  * @dev Math operations with safety checks that revert on error
324  */
325 library SafeMath {
326 
327   /**
328   * @dev Multiplies two numbers, reverts on overflow.
329   */
330   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
331     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
332     // benefit is lost if 'b' is also tested.
333     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
334     if (_a == 0) {
335       return 0;
336     }
337 
338     uint256 c = _a * _b;
339     require(c / _a == _b);
340 
341     return c;
342   }
343 
344   /**
345   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
346   */
347   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
348     require(_b > 0); // Solidity only automatically asserts when dividing by 0
349     uint256 c = _a / _b;
350     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
351 
352     return c;
353   }
354 
355   /**
356   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
357   */
358   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
359     require(_b <= _a);
360     uint256 c = _a - _b;
361 
362     return c;
363   }
364 
365   /**
366   * @dev Adds two numbers, reverts on overflow.
367   */
368   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
369     uint256 c = _a + _b;
370     require(c >= _a);
371 
372     return c;
373   }
374 
375   /**
376   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
377   * reverts when dividing by zero.
378   */
379   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
380     require(b != 0);
381     return a % b;
382   }
383 }
384 
385 /*
386     Modified Util contract as used by Kyber Network
387 */
388 
389 library Utils {
390 
391     uint256 constant internal PRECISION = (10**18);
392     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
393     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
394     uint256 constant internal MAX_DECIMALS = 18;
395     uint256 constant internal ETH_DECIMALS = 18;
396     uint256 constant internal MAX_UINT = 2**256-1;
397 
398     // Currently constants can't be accessed from other contracts, so providing functions to do that here
399     function precision() internal pure returns (uint256) { return PRECISION; }
400     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
401     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
402     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
403     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
404     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
405 
406     /// @notice Retrieve the number of decimals used for a given ERC20 token
407     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
408     /// ensure that an exception doesn't cause transaction failure
409     /// @param token the token for which we should retrieve the decimals
410     /// @return decimals the number of decimals in the given token
411     function getDecimals(address token)
412         internal
413         view
414         returns (uint256 decimals)
415     {
416         bytes4 functionSig = bytes4(keccak256("decimals()"));
417 
418         /// @dev Using assembly due to issues with current solidity `address.call()`
419         /// implementation: https://github.com/ethereum/solidity/issues/2884
420         assembly {
421             // Pointer to next free memory slot
422             let ptr := mload(0x40)
423             // Store functionSig variable at ptr
424             mstore(ptr,functionSig)
425             let functionSigLength := 0x04
426             let wordLength := 0x20
427 
428             let success := call(
429                                 5000, // Amount of gas
430                                 token, // Address to call
431                                 0, // ether to send
432                                 ptr, // ptr to input data
433                                 functionSigLength, // size of data
434                                 ptr, // where to store output data (overwrite input)
435                                 wordLength // size of output data (32 bytes)
436                                )
437 
438             switch success
439             case 0 {
440                 decimals := 18 // If the token doesn't implement `decimals()`, return 18 as default
441             }
442             case 1 {
443                 decimals := mload(ptr) // Set decimals to return data from call
444             }
445             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
446         }
447     }
448 
449     /// @dev Checks that a given address has its token allowance and balance set above the given amount
450     /// @param tokenOwner the address which should have custody of the token
451     /// @param tokenAddress the address of the token to check
452     /// @param tokenAmount the amount of the token which should be set
453     /// @param addressToAllow the address which should be allowed to transfer the token
454     /// @return bool true if the allowance and balance is set, false if not
455     function tokenAllowanceAndBalanceSet(
456         address tokenOwner,
457         address tokenAddress,
458         uint256 tokenAmount,
459         address addressToAllow
460     )
461         internal
462         view
463         returns (bool)
464     {
465         return (
466             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
467             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
468         );
469     }
470 
471     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
472         if (dstDecimals >= srcDecimals) {
473             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
474             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
475         } else {
476             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
477             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
478         }
479     }
480 
481     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
482 
483         //source quantity is rounded up. to avoid dest quantity being too low.
484         uint numerator;
485         uint denominator;
486         if (srcDecimals >= dstDecimals) {
487             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
488             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
489             denominator = rate;
490         } else {
491             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
492             numerator = (PRECISION * dstQty);
493             denominator = (rate * (10**(dstDecimals - srcDecimals)));
494         }
495         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
496     }
497 
498     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
499         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
500     }
501 
502     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
503         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
504     }
505 
506     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
507         internal pure returns (uint)
508     {
509         require(srcAmount <= MAX_QTY);
510         require(destAmount <= MAX_QTY);
511 
512         if (dstDecimals >= srcDecimals) {
513             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
514             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
515         } else {
516             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
517             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
518         }
519     }
520 
521     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
522     function min(uint256 a, uint256 b) internal pure returns (uint256) {
523         return a < b ? a : b;
524     }
525 }
526 
527 contract ErrorReporter {
528     function revertTx(string reason) public pure {
529         revert(reason);
530     }
531 }
532 
533 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
534 /// some functions
535 /// @dev Defines a modifier which should be used when only the totle contract should
536 /// able able to call a function
537 contract TotleControl is Ownable {
538     address public totlePrimary;
539 
540     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
541     modifier onlyTotle() {
542         require(msg.sender == totlePrimary);
543         _;
544     }
545 
546     /// @notice Contract constructor
547     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
548     /// @param _totlePrimary the address of the contract to be set as totlePrimary
549     constructor(address _totlePrimary) public {
550         require(_totlePrimary != address(0x0));
551         totlePrimary = _totlePrimary;
552     }
553 
554     /// @notice A function which allows only the owner to change the address of totlePrimary
555     /// @dev onlyOwner modifier only allows the contract owner to run the code
556     /// @param _totlePrimary the address of the contract to be set as totlePrimary
557     function setTotle(
558         address _totlePrimary
559     ) external onlyOwner {
560         require(_totlePrimary != address(0x0));
561         totlePrimary = _totlePrimary;
562     }
563 }
564 
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
858     event LogRebalance(
859         bytes32 id
860     );
861 
862     /*
863     *   Modifiers
864     */
865 
866     modifier handlerWhitelisted(address handler) {
867         if (!handlerWhitelistMap[handler]) {
868             errorReporter.revertTx("Handler not in whitelist");
869         }
870         _;
871     }
872 
873     modifier handlerNotWhitelisted(address handler) {
874         if (handlerWhitelistMap[handler]) {
875             errorReporter.revertTx("Handler already whitelisted");
876         }
877         _;
878     }
879 
880     /// @notice Constructor
881     /// @param _tokenTransferProxy address of the TokenTransferProxy
882     /// @param _errorReporter the address of the error reporter contract
883     constructor (address _tokenTransferProxy, address _errorReporter/*, address _logger*/) public {
884         require(_tokenTransferProxy != address(0x0));
885         require(_errorReporter != address(0x0));
886         /* require(_logger != address(0x0)); */
887         tokenTransferProxy = _tokenTransferProxy;
888         errorReporter = ErrorReporter(_errorReporter);
889         /* logger = Logger(_logger); */
890     }
891 
892     /*
893     *   Public functions
894     */
895 
896     /// @notice Add an exchangeHandler address to the whitelist
897     /// @dev onlyOwner modifier only allows the contract owner to run the code
898     /// @param handler Address of the exchange handler which permission needs adding
899     function addHandlerToWhitelist(address handler)
900         public
901         onlyOwner
902         handlerNotWhitelisted(handler)
903     {
904         handlerWhitelistMap[handler] = true;
905         handlerWhitelistArray.push(handler);
906     }
907 
908     /// @notice Remove an exchangeHandler address from the whitelist
909     /// @dev onlyOwner modifier only allows the contract owner to run the code
910     /// @param handler Address of the exchange handler which permission needs removing
911     function removeHandlerFromWhitelist(address handler)
912         public
913         onlyOwner
914         handlerWhitelisted(handler)
915     {
916         delete handlerWhitelistMap[handler];
917         for (uint i = 0; i < handlerWhitelistArray.length; i++) {
918             if (handlerWhitelistArray[i] == handler) {
919                 handlerWhitelistArray[i] = handlerWhitelistArray[handlerWhitelistArray.length - 1];
920                 handlerWhitelistArray.length -= 1;
921                 break;
922             }
923         }
924     }
925 
926     /// @notice Performs the requested portfolio rebalance
927     /// @param trades A dynamic array of trade structs
928     function performRebalance(
929         Trade[] trades,
930         bytes32 id
931     )
932         public
933         payable
934         whenNotPaused
935     {
936         emit LogRebalance(id);
937         /* logger.log("Starting Rebalance..."); */
938 
939         TradeFlag[] memory tradeFlags = initialiseTradeFlags(trades);
940 
941         staticChecks(trades, tradeFlags);
942 
943         /* logger.log("Static checks passed."); */
944 
945         transferTokens(trades, tradeFlags);
946 
947         /* logger.log("Tokens transferred."); */
948 
949         uint256 etherBalance = msg.value;
950 
951         /* logger.log("Ether balance arg2: etherBalance.", etherBalance); */
952 
953         for (uint256 i; i < trades.length; i++) {
954             Trade memory thisTrade = trades[i];
955             TradeFlag memory thisTradeFlag = tradeFlags[i];
956 
957             CurrentAmounts memory amounts = CurrentAmounts({
958                 amountSpentOnTrade: 0,
959                 amountReceivedFromTrade: 0,
960                 amountLeftToSpendOnTrade: thisTrade.isSell ? thisTrade.tokenAmount : calculateMaxEtherSpend(thisTrade, etherBalance)
961             });
962             /* logger.log("Going to perform trade. arg2: amountLeftToSpendOnTrade", amounts.amountLeftToSpendOnTrade); */
963 
964             performTrade(
965                 thisTrade,
966                 thisTradeFlag,
967                 amounts
968             );
969 
970             /* logger.log("Finished performing trade arg2: amountReceivedFromTrade, arg3: amountSpentOnTrade.", amounts.amountReceivedFromTrade, amounts.amountSpentOnTrade); */
971 
972             if (amounts.amountReceivedFromTrade == 0 && thisTrade.optionalTrade) {
973                 /* logger.log("Received 0 from trade and this is an optional trade. Skipping."); */
974                 continue;
975             }
976 
977             /* logger.log(
978                 "Going to check trade acceptable amounts arg2: amountSpentOnTrade, arg2: amountReceivedFromTrade.",
979                 amounts.amountSpentOnTrade,
980                 amounts.amountReceivedFromTrade
981             ); */
982 
983             if (!checkIfTradeAmountsAcceptable(thisTrade, amounts.amountSpentOnTrade, amounts.amountReceivedFromTrade)) {
984                 errorReporter.revertTx("Amounts spent/received in trade not acceptable");
985             }
986 
987             /* logger.log("Trade passed the acceptable amounts check."); */
988 
989             if (thisTrade.isSell) {
990                 /* logger.log(
991                     "This is a sell trade, adding ether to our balance arg2: etherBalance, arg3: amountReceivedFromTrade",
992                     etherBalance,
993                     amounts.amountReceivedFromTrade
994                 ); */
995                 etherBalance = SafeMath.add(etherBalance, amounts.amountReceivedFromTrade);
996             } else {
997                 /* logger.log(
998                     "This is a buy trade, deducting ether from our balance arg2: etherBalance, arg3: amountSpentOnTrade",
999                     etherBalance,
1000                     amounts.amountSpentOnTrade
1001                 ); */
1002                 etherBalance = SafeMath.sub(etherBalance, amounts.amountSpentOnTrade);
1003             }
1004 
1005             /* logger.log("Transferring tokens to the user arg:6 tokenAddress.", 0,0,0,0, thisTrade.tokenAddress); */
1006 
1007             transferTokensToUser(
1008                 thisTrade.tokenAddress,
1009                 thisTrade.isSell ? amounts.amountLeftToSpendOnTrade : amounts.amountReceivedFromTrade
1010             );
1011 
1012         }
1013 
1014         if(etherBalance > 0) {
1015             /* logger.log("Got a positive ether balance, sending to the user arg2: etherBalance.", etherBalance); */
1016             msg.sender.transfer(etherBalance);
1017         }
1018     }
1019 
1020     /// @notice Performs static checks on the rebalance payload before execution
1021     /// @dev This function is public so a rebalance can be checked before performing a rebalance
1022     /// @param trades A dynamic array of trade structs
1023     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1024     function staticChecks(
1025         Trade[] trades,
1026         TradeFlag[] tradeFlags
1027     )
1028         public
1029         view
1030         whenNotPaused
1031     {
1032         bool previousBuyOccured = false;
1033 
1034         for (uint256 i; i < trades.length; i++) {
1035             Trade memory thisTrade = trades[i];
1036             if (thisTrade.isSell) {
1037                 if (previousBuyOccured) {
1038                     errorReporter.revertTx("A buy has occured before this sell");
1039                 }
1040 
1041                 if (!Utils.tokenAllowanceAndBalanceSet(msg.sender, thisTrade.tokenAddress, thisTrade.tokenAmount, tokenTransferProxy)) {
1042                     if (!thisTrade.optionalTrade) {
1043                         errorReporter.revertTx("Taker has not sent allowance/balance on a non-optional trade");
1044                     }
1045                     /* logger.log(
1046                         "Attempt to sell a token without allowance or sufficient balance arg2: tokenAmount, arg6: tokenAddress . Otional trade, ignoring.",
1047                         thisTrade.tokenAmount,
1048                         0,
1049                         0,
1050                         0,
1051                         thisTrade.tokenAddress
1052                     ); */
1053                     tradeFlags[i].ignoreTrade = true;
1054                     continue;
1055                 }
1056             } else {
1057                 previousBuyOccured = true;
1058             }
1059 
1060             /* logger.log("Checking that all the handlers are whitelisted."); */
1061             for (uint256 j; j < thisTrade.orders.length; j++) {
1062                 Order memory thisOrder = thisTrade.orders[j];
1063                 if ( !handlerWhitelistMap[thisOrder.exchangeHandler] ) {
1064                     /* logger.log(
1065                         "Trying to use a handler that is not whitelisted arg6: exchangeHandler.",
1066                         0,
1067                         0,
1068                         0,
1069                         0,
1070                         thisOrder.exchangeHandler
1071                     ); */
1072                     tradeFlags[i].ignoreOrder[j] = true;
1073                     continue;
1074                 }
1075             }
1076         }
1077     }
1078 
1079     /*
1080     *   Internal functions
1081     */
1082 
1083     /// @notice Initialises the trade flag struct
1084     /// @param trades the trades used to initialise the flags
1085     /// @return tradeFlags the initialised flags
1086     function initialiseTradeFlags(Trade[] trades)
1087         internal
1088         returns (TradeFlag[])
1089     {
1090         /* logger.log("Initializing trade flags."); */
1091         TradeFlag[] memory tradeFlags = new TradeFlag[](trades.length);
1092         for (uint256 i = 0; i < trades.length; i++) {
1093             tradeFlags[i].ignoreOrder = new bool[](trades[i].orders.length);
1094         }
1095         return tradeFlags;
1096     }
1097 
1098     /// @notice Transfers the given amount of tokens back to the msg.sender
1099     /// @param tokenAddress the address of the token to transfer
1100     /// @param tokenAmount the amount of tokens to transfer
1101     function transferTokensToUser(
1102         address tokenAddress,
1103         uint256 tokenAmount
1104     )
1105         internal
1106     {
1107         /* logger.log("Transfering tokens to the user arg2: tokenAmount, arg6: .tokenAddress", tokenAmount, 0, 0, 0, tokenAddress); */
1108         if (tokenAmount > 0) {
1109             if (!ERC20SafeTransfer.safeTransfer(tokenAddress, msg.sender, tokenAmount)) {
1110                 errorReporter.revertTx("Unable to transfer tokens to user");
1111             }
1112         }
1113     }
1114 
1115     /// @notice Executes the given trade
1116     /// @param trade a struct containing information about the trade
1117     /// @param tradeFlag a struct containing trade status information
1118     /// @param amounts a struct containing information about amounts spent
1119     /// and received in the rebalance
1120     function performTrade(
1121         Trade trade,
1122         TradeFlag tradeFlag,
1123         CurrentAmounts amounts
1124     )
1125         internal
1126     {
1127         /* logger.log("Performing trade"); */
1128 
1129         for (uint256 j; j < trade.orders.length; j++) {
1130 
1131             /* logger.log("Processing order arg2: orderIndex", j); */
1132 
1133             //TODO: Change to the amount of tokens that we are trying to get
1134             if( amounts.amountReceivedFromTrade >= trade.minimumAcceptableTokenAmount ) {
1135                 /* logger.log(
1136                     "Got the desired amount from the trade arg2: amountReceivedFromTrade, arg3: minimumAcceptableTokenAmount",
1137                     amounts.amountReceivedFromTrade,
1138                     trade.minimumAcceptableTokenAmount
1139                 ); */
1140                 return;
1141             }
1142 
1143             if (tradeFlag.ignoreOrder[j] || amounts.amountLeftToSpendOnTrade == 0) {
1144                 /* logger.log(
1145                     "Order ignore flag is set to true or have nothing left to spend arg2: amountLeftToSpendOnTrade",
1146                     amounts.amountLeftToSpendOnTrade
1147                 ); */
1148                 continue;
1149             }
1150 
1151             uint256 amountSpentOnOrder = 0;
1152             uint256 amountReceivedFromOrder = 0;
1153 
1154             Order memory thisOrder = trade.orders[j];
1155 
1156             /* logger.log("Setting order exchange handler arg6: exchangeHandler.", 0, 0, 0, 0, thisOrder.exchangeHandler); */
1157             ExchangeHandler thisHandler = ExchangeHandler(thisOrder.exchangeHandler);
1158 
1159             uint256 amountToGiveForOrder = Utils.min(
1160                 thisHandler.getAmountToGive(thisOrder.genericPayload),
1161                 amounts.amountLeftToSpendOnTrade
1162             );
1163 
1164             if (amountToGiveForOrder == 0) {
1165                 /* logger.log(
1166                     "MASSIVE ERROR: amountToGiveForOrder was found to be 0, this hasn't been caught in preTradeChecks, which means dynamicExchangeChecks isnt written correctly!"
1167                 ); */
1168                 continue;
1169             }
1170 
1171             /* logger.log(
1172                 "Calculating amountToGiveForOrder arg2: amountToGiveForOrder, arg3: amountLeftToSpendOnTrade.",
1173                 amountToGiveForOrder,
1174                 amounts.amountLeftToSpendOnTrade
1175             ); */
1176 
1177             if( !thisHandler.staticExchangeChecks(thisOrder.genericPayload) ) {
1178                 /* logger.log("Order did not pass checks, skipping."); */
1179                 continue;
1180             }
1181 
1182             if (trade.isSell) {
1183                 /* logger.log("This is a sell.."); */
1184                 if (!ERC20SafeTransfer.safeTransfer(trade.tokenAddress,address(thisHandler), amountToGiveForOrder)) {
1185                     if( !trade.optionalTrade ) errorReporter.revertTx("Unable to transfer tokens to handler");
1186                     else {
1187                         /* logger.log("Unable to transfer tokens to handler but the trade is optional"); */
1188                         return;
1189                     }
1190                 }
1191 
1192                 /* logger.log("Going to perform a sell order."); */
1193                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performSellOrder(thisOrder.genericPayload, amountToGiveForOrder);
1194                 /* logger.log("Sell order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1195             } else {
1196                 /* logger.log("Going to perform a buy order."); */
1197                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performBuyOrder.value(amountToGiveForOrder)(thisOrder.genericPayload, amountToGiveForOrder);
1198                 /* logger.log("Buy order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1199             }
1200 
1201             if (amountReceivedFromOrder > 0) {
1202                 amounts.amountLeftToSpendOnTrade = SafeMath.sub(amounts.amountLeftToSpendOnTrade, amountSpentOnOrder);
1203                 amounts.amountSpentOnTrade = SafeMath.add(amounts.amountSpentOnTrade, amountSpentOnOrder);
1204                 amounts.amountReceivedFromTrade = SafeMath.add(amounts.amountReceivedFromTrade, amountReceivedFromOrder);
1205 
1206                 /* logger.log(
1207                     "Updated amounts arg2: amountLeftToSpendOnTrade, arg3: amountSpentOnTrade, arg4: amountReceivedFromTrade.",
1208                     amounts.amountLeftToSpendOnTrade,
1209                     amounts.amountSpentOnTrade,
1210                     amounts.amountReceivedFromTrade
1211                 ); */
1212             }
1213         }
1214 
1215     }
1216 
1217     /// @notice Check if the amounts spent and gained on a trade are within the
1218     /// user"s set limits
1219     /// @param trade contains information on the given trade
1220     /// @param amountSpentOnTrade the amount that was spent on the trade
1221     /// @param amountReceivedFromTrade the amount that was received from the trade
1222     /// @return bool whether the trade passes the checks
1223     function checkIfTradeAmountsAcceptable(
1224         Trade trade,
1225         uint256 amountSpentOnTrade,
1226         uint256 amountReceivedFromTrade
1227     )
1228         internal
1229         view
1230         returns (bool passed)
1231     {
1232         /* logger.log("Checking if trade amounts are acceptable."); */
1233         uint256 tokenAmount = trade.isSell ? amountSpentOnTrade : amountReceivedFromTrade;
1234         passed = tokenAmount >= trade.minimumAcceptableTokenAmount;
1235 
1236         if( !passed ) {
1237             /* logger.log(
1238                 "Received less than minimum acceptable tokens arg2: tokenAmount , arg3: minimumAcceptableTokenAmount.",
1239                 tokenAmount,
1240                 trade.minimumAcceptableTokenAmount
1241             ); */
1242         }
1243 
1244         if (passed) {
1245             uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1246             uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1247             uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1248             uint256 actualRate = Utils.calcRateFromQty(amountSpentOnTrade, amountReceivedFromTrade, srcDecimals, destDecimals);
1249             passed = actualRate >= trade.minimumExchangeRate;
1250         }
1251 
1252         if( !passed ) {
1253             /* logger.log(
1254                 "Order rate was lower than minimum acceptable,  rate arg2: actualRate, arg3: minimumExchangeRate.",
1255                 actualRate,
1256                 trade.minimumExchangeRate
1257             ); */
1258         }
1259     }
1260 
1261     /// @notice Iterates through a list of token orders, transfer the SELL orders to this contract & calculates if we have the ether needed
1262     /// @param trades A dynamic array of trade structs
1263     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1264     function transferTokens(Trade[] trades, TradeFlag[] tradeFlags) internal {
1265         for (uint256 i = 0; i < trades.length; i++) {
1266             if (trades[i].isSell && !tradeFlags[i].ignoreTrade) {
1267 
1268                 /* logger.log(
1269                     "Transfering tokens arg2: tokenAmount, arg5: tokenAddress.",
1270                     trades[i].tokenAmount,
1271                     0,
1272                     0,
1273                     0,
1274                     trades[i].tokenAddress
1275                 ); */
1276                 if (
1277                     !TokenTransferProxy(tokenTransferProxy).transferFrom(
1278                         trades[i].tokenAddress,
1279                         msg.sender,
1280                         address(this),
1281                         trades[i].tokenAmount
1282                     )
1283                 ) {
1284                     errorReporter.revertTx("TTP unable to transfer tokens to primary");
1285                 }
1286            }
1287         }
1288     }
1289 
1290     /// @notice Calculates the maximum amount that should be spent on a given buy trade
1291     /// @param trade the buy trade to return the spend amount for
1292     /// @param etherBalance the amount of ether that we currently have to spend
1293     /// @return uint256 the maximum amount of ether we should spend on this trade
1294     function calculateMaxEtherSpend(Trade trade, uint256 etherBalance) internal view returns (uint256) {
1295         /// @dev This function should never be called for a sell
1296         assert(!trade.isSell);
1297 
1298         uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1299         uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1300         uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1301         uint256 maxSpendAtMinRate = Utils.calcSrcQty(trade.tokenAmount, srcDecimals, destDecimals, trade.minimumExchangeRate);
1302 
1303         return Utils.min(etherBalance, maxSpendAtMinRate);
1304     }
1305 
1306     /*
1307     *   Payable fallback function
1308     */
1309 
1310     /// @notice payable fallback to allow handler or exchange contracts to return ether
1311     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
1312     function() public payable whenNotPaused {
1313         // Check in here that the sender is a contract! (to stop accidents)
1314         uint256 size;
1315         address sender = msg.sender;
1316         assembly {
1317             size := extcodesize(sender)
1318         }
1319         if (size == 0) {
1320             errorReporter.revertTx("EOA cannot send ether to primary fallback");
1321         }
1322     }
1323 }