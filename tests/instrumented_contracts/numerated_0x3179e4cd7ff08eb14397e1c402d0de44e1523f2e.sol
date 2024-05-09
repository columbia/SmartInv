1 pragma solidity 0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address payable public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address payable _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address payable _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 library ERC20SafeTransfer {
67     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
68         (success,) = _tokenAddress.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _value));
69         require(success, "Transfer failed");
70 
71         return fetchReturnData();
72     }
73 
74     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
75         (success,) = _tokenAddress.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value));
76         require(success, "Transfer From failed");
77 
78         return fetchReturnData();
79     }
80 
81     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
82         (success,) = _tokenAddress.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));
83         require(success,  "Approve failed");
84 
85         return fetchReturnData();
86     }
87 
88     function fetchReturnData() internal pure returns (bool success){
89         assembly {
90             switch returndatasize()
91             case 0 {
92                 success := 1
93             }
94             case 32 {
95                 returndatacopy(0, 0, 32)
96                 success := mload(0)
97             }
98             default {
99                 revert(0, 0)
100             }
101         }
102     }
103 
104 }
105 
106 /// @title A contract which allows its owner to withdraw any ether which is contained inside
107 contract Withdrawable is Ownable {
108 
109     /// @notice Withdraw ether contained in this contract and send it back to owner
110     /// @dev onlyOwner modifier only allows the contract owner to run the code
111     /// @param _token The address of the token that the user wants to withdraw
112     /// @param _amount The amount of tokens that the caller wants to withdraw
113     /// @return bool value indicating whether the transfer was successful
114     function withdrawToken(address _token, uint256 _amount) external onlyOwner returns (bool) {
115         return ERC20SafeTransfer.safeTransfer(_token, owner, _amount);
116     }
117 
118     /// @notice Withdraw ether contained in this contract and send it back to owner
119     /// @dev onlyOwner modifier only allows the contract owner to run the code
120     /// @param _amount The amount of ether that the caller wants to withdraw
121     function withdrawETH(uint256 _amount) external onlyOwner {
122         owner.transfer(_amount);
123     }
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 {
131   function totalSupply() public view returns (uint256);
132 
133   function balanceOf(address _who) public view returns (uint256);
134 
135   function allowance(address _owner, address _spender)
136     public view returns (uint256);
137 
138   function transfer(address _to, uint256 _value) public returns (bool);
139 
140   function approve(address _spender, uint256 _value)
141     public returns (bool);
142 
143   function transferFrom(address _from, address _to, uint256 _value)
144     public returns (bool);
145 
146   function decimals() public view returns (uint256);
147 
148   event Transfer(
149     address indexed from,
150     address indexed to,
151     uint256 value
152   );
153 
154   event Approval(
155     address indexed owner,
156     address indexed spender,
157     uint256 value
158   );
159 }
160 
161 // File: contracts/lib/TokenTransferProxy.sol
162 
163 /*
164 
165   Copyright 2018 ZeroEx Intl.
166 
167   Licensed under the Apache License, Version 2.0 (the "License");
168   you may not use this file except in compliance with the License.
169   You may obtain a copy of the License at
170 
171     http://www.apache.org/licenses/LICENSE-2.0
172 
173   Unless required by applicable law or agreed to in writing, software
174   distributed under the License is distributed on an "AS IS" BASIS,
175   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
176   See the License for the specific language governing permissions and
177   limitations under the License.
178 
179 */
180 
181 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
182 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
183 contract TokenTransferProxy is Ownable {
184 
185     /// @dev Only authorized addresses can invoke functions with this modifier.
186     modifier onlyAuthorized {
187         require(authorized[msg.sender]);
188         _;
189     }
190 
191     modifier targetAuthorized(address target) {
192         require(authorized[target]);
193         _;
194     }
195 
196     modifier targetNotAuthorized(address target) {
197         require(!authorized[target]);
198         _;
199     }
200 
201     mapping (address => bool) public authorized;
202     address[] public authorities;
203 
204     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
205     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
206 
207     /*
208      * Public functions
209      */
210 
211     /// @dev Authorizes an address.
212     /// @param target Address to authorize.
213     function addAuthorizedAddress(address target)
214         public
215         onlyOwner
216         targetNotAuthorized(target)
217     {
218         authorized[target] = true;
219         authorities.push(target);
220         emit LogAuthorizedAddressAdded(target, msg.sender);
221     }
222 
223     /// @dev Removes authorizion of an address.
224     /// @param target Address to remove authorization from.
225     function removeAuthorizedAddress(address target)
226         public
227         onlyOwner
228         targetAuthorized(target)
229     {
230         delete authorized[target];
231         for (uint i = 0; i < authorities.length; i++) {
232             if (authorities[i] == target) {
233                 authorities[i] = authorities[authorities.length - 1];
234                 authorities.length -= 1;
235                 break;
236             }
237         }
238         emit LogAuthorizedAddressRemoved(target, msg.sender);
239     }
240 
241     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
242     /// @param token Address of token to transfer.
243     /// @param from Address to transfer token from.
244     /// @param to Address to transfer token to.
245     /// @param value Amount of token to transfer.
246     /// @return Success of transfer.
247     function transferFrom(
248         address token,
249         address from,
250         address to,
251         uint value)
252         public
253         onlyAuthorized
254         returns (bool)
255     {
256         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
257         return true;
258     }
259 
260     /*
261      * Public view functions
262      */
263 
264     /// @dev Gets all authorized addresses.
265     /// @return Array of authorized addresses.
266     function getAuthorizedAddresses()
267         public
268         view
269         returns (address[] memory)
270     {
271         return authorities;
272     }
273 }
274 
275 /**
276  * @title Pausable
277  * @dev Base contract which allows children to implement an emergency stop mechanism.
278  */
279 contract Pausable is Ownable {
280   event Paused();
281   event Unpaused();
282 
283   bool private _paused = false;
284 
285   /**
286    * @return true if the contract is paused, false otherwise.
287    */
288   function paused() public view returns (bool) {
289     return _paused;
290   }
291 
292   /**
293    * @dev Modifier to make a function callable only when the contract is not paused.
294    */
295   modifier whenNotPaused() {
296     require(!_paused, "Contract is paused.");
297     _;
298   }
299 
300   /**
301    * @dev Modifier to make a function callable only when the contract is paused.
302    */
303   modifier whenPaused() {
304     require(_paused, "Contract not paused.");
305     _;
306   }
307 
308   /**
309    * @dev called by the owner to pause, triggers stopped state
310    */
311   function pause() public onlyOwner whenNotPaused {
312     _paused = true;
313     emit Paused();
314   }
315 
316   /**
317    * @dev called by the owner to unpause, returns to normal state
318    */
319   function unpause() public onlyOwner whenPaused {
320     _paused = false;
321     emit Unpaused();
322   }
323 }
324 
325 /**
326  * @title SafeMath
327  * @dev Math operations with safety checks that revert on error
328  */
329 library SafeMath {
330 
331   /**
332   * @dev Multiplies two numbers, reverts on overflow.
333   */
334   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
335     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
336     // benefit is lost if 'b' is also tested.
337     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
338     if (_a == 0) {
339       return 0;
340     }
341 
342     uint256 c = _a * _b;
343     require(c / _a == _b);
344 
345     return c;
346   }
347 
348   /**
349   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
350   */
351   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
352     require(_b > 0); // Solidity only automatically asserts when dividing by 0
353     uint256 c = _a / _b;
354     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
355 
356     return c;
357   }
358 
359   /**
360   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
361   */
362   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
363     require(_b <= _a);
364     uint256 c = _a - _b;
365 
366     return c;
367   }
368 
369   /**
370   * @dev Adds two numbers, reverts on overflow.
371   */
372   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
373     uint256 c = _a + _b;
374     require(c >= _a);
375 
376     return c;
377   }
378 
379   /**
380   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
381   * reverts when dividing by zero.
382   */
383   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
384     require(b != 0);
385     return a % b;
386   }
387 }
388 
389 /**
390  * @title Math
391  * @dev Assorted math operations
392  */
393 
394 library Math {
395   function max(uint256 a, uint256 b) internal pure returns (uint256) {
396     return a >= b ? a : b;
397   }
398 
399   function min(uint256 a, uint256 b) internal pure returns (uint256) {
400     return a < b ? a : b;
401   }
402 
403   function average(uint256 a, uint256 b) internal pure returns (uint256) {
404     // (a + b) / 2 can overflow, so we distribute
405     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
406   }
407 }
408 
409 /*
410     Modified Util contract as used by Kyber Network
411 */
412 
413 library Utils {
414 
415     uint256 constant internal PRECISION = (10**18);
416     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
417     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
418     uint256 constant internal MAX_DECIMALS = 18;
419     uint256 constant internal ETH_DECIMALS = 18;
420     uint256 constant internal MAX_UINT = 2**256-1;
421     address constant internal ETH_ADDRESS = address(0x0);
422 
423     // Currently constants can't be accessed from other contracts, so providing functions to do that here
424     function precision() internal pure returns (uint256) { return PRECISION; }
425     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
426     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
427     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
428     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
429     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
430     function eth_address() internal pure returns (address) { return ETH_ADDRESS; }
431 
432     /// @notice Retrieve the number of decimals used for a given ERC20 token
433     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
434     /// ensure that an exception doesn't cause transaction failure
435     /// @param token the token for which we should retrieve the decimals
436     /// @return decimals the number of decimals in the given token
437     function getDecimals(address token)
438         internal
439         returns (uint256 decimals)
440     {
441         bytes4 functionSig = bytes4(keccak256("decimals()"));
442 
443         /// @dev Using assembly due to issues with current solidity `address.call()`
444         /// implementation: https://github.com/ethereum/solidity/issues/2884
445         assembly {
446             // Pointer to next free memory slot
447             let ptr := mload(0x40)
448             // Store functionSig variable at ptr
449             mstore(ptr,functionSig)
450             let functionSigLength := 0x04
451             let wordLength := 0x20
452 
453             let success := call(
454                                 5000, // Amount of gas
455                                 token, // Address to call
456                                 0, // ether to send
457                                 ptr, // ptr to input data
458                                 functionSigLength, // size of data
459                                 ptr, // where to store output data (overwrite input)
460                                 wordLength // size of output data (32 bytes)
461                                )
462 
463             switch success
464             case 0 {
465                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
466             }
467             case 1 {
468                 decimals := mload(ptr) // Set decimals to return data from call
469             }
470             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
471         }
472     }
473 
474     /// @dev Checks that a given address has its token allowance and balance set above the given amount
475     /// @param tokenOwner the address which should have custody of the token
476     /// @param tokenAddress the address of the token to check
477     /// @param tokenAmount the amount of the token which should be set
478     /// @param addressToAllow the address which should be allowed to transfer the token
479     /// @return bool true if the allowance and balance is set, false if not
480     function tokenAllowanceAndBalanceSet(
481         address tokenOwner,
482         address tokenAddress,
483         uint256 tokenAmount,
484         address addressToAllow
485     )
486         internal
487         view
488         returns (bool)
489     {
490         return (
491             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
492             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
493         );
494     }
495 
496     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
497         if (dstDecimals >= srcDecimals) {
498             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
499             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
500         } else {
501             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
502             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
503         }
504     }
505 
506     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
507 
508         //source quantity is rounded up. to avoid dest quantity being too low.
509         uint numerator;
510         uint denominator;
511         if (srcDecimals >= dstDecimals) {
512             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
513             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
514             denominator = rate;
515         } else {
516             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
517             numerator = (PRECISION * dstQty);
518             denominator = (rate * (10**(dstDecimals - srcDecimals)));
519         }
520         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
521     }
522 
523     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal returns (uint) {
524         return calcDstQty(srcAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
525     }
526 
527     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal returns (uint) {
528         return calcSrcQty(destAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
529     }
530 
531     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
532         internal pure returns (uint)
533     {
534         require(srcAmount <= MAX_QTY);
535         require(destAmount <= MAX_QTY);
536 
537         if (dstDecimals >= srcDecimals) {
538             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
539             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
540         } else {
541             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
542             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
543         }
544     }
545 
546     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
547     function min(uint256 a, uint256 b) internal pure returns (uint256) {
548         return a < b ? a : b;
549     }
550 }
551 
552 contract Partner {
553 
554     address payable public partnerBeneficiary;
555     uint256 public partnerPercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
556 
557     uint256 public companyPercentage;
558     address payable public companyBeneficiary;
559 
560     event LogPayout(
561         address[] tokens,
562         uint256[] amount
563     );
564 
565     function init(
566         address payable _companyBeneficiary,
567         uint256 _companyPercentage,
568         address payable _partnerBeneficiary,
569         uint256 _partnerPercentage
570     ) public {
571         require(companyBeneficiary == address(0x0) && partnerBeneficiary == address(0x0));
572         companyBeneficiary = _companyBeneficiary;
573         companyPercentage = _companyPercentage;
574         partnerBeneficiary = _partnerBeneficiary;
575         partnerPercentage = _partnerPercentage;
576     }
577 
578     function payout(
579         address[] memory tokens,
580         uint256[] memory amounts
581     ) public {
582         // Payout both the partner and the company at the same time
583         for(uint256 index = 0; index<tokens.length; index++){
584             uint256 partnerAmount = SafeMath.div(SafeMath.mul(amounts[index], partnerPercentage), getTotalFeePercentage());
585             uint256 companyAmount = amounts[index] - partnerAmount;
586             if(tokens[index] == Utils.eth_address()){
587                 partnerBeneficiary.transfer(partnerAmount);
588                 companyBeneficiary.transfer(companyAmount);
589             } else {
590                 ERC20SafeTransfer.safeTransfer(tokens[index], partnerBeneficiary, partnerAmount);
591                 ERC20SafeTransfer.safeTransfer(tokens[index], companyBeneficiary, companyAmount);
592             }
593         }
594 	emit LogPayout(tokens,amounts);
595     }
596 
597     function getTotalFeePercentage() public view returns (uint256){
598         return partnerPercentage + companyPercentage;
599     }
600 
601     function() external payable {
602 
603     }
604 }
605 
606 /// @title Interface for all exchange handler contracts
607 contract ExchangeHandler is Withdrawable, Pausable {
608 
609     /*
610     *   State Variables
611     */
612 
613     /* Logger public logger; */
614     /*
615     *   Modifiers
616     */
617 
618     function performOrder(
619         bytes memory genericPayload,
620         uint256 availableToSpend,
621         uint256 targetAmount,
622         bool targetAmountIsSource
623     )
624         public
625         payable
626         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder);
627 
628 }
629 
630 /// @title The primary contract for Totle
631 contract TotlePrimary is Withdrawable, Pausable {
632 
633     /*
634     *   State Variables
635     */
636 
637     TokenTransferProxy public tokenTransferProxy;
638     mapping(address => bool) public signers;
639     /* Logger public logger; */
640 
641     /*
642     *   Types
643     */
644 
645     // Structs
646     struct Order {
647         address payable exchangeHandler;
648         bytes encodedPayload;
649     }
650 
651     struct Trade {
652         address sourceToken;
653         address destinationToken;
654         uint256 amount;
655         bool isSourceAmount; //true if amount is sourceToken, false if it's destinationToken
656         Order[] orders;
657     }
658 
659     struct Swap {
660         Trade[] trades;
661         uint256 minimumExchangeRate;
662         uint256 minimumDestinationAmount;
663         uint256 sourceAmount;
664         uint256 tradeToTakeFeeFrom;
665         bool takeFeeFromSource; //Takes the fee before the trade if true, takes it after if false
666         address payable redirectAddress;
667         bool required;
668     }
669 
670     struct SwapCollection {
671         Swap[] swaps;
672         address payable partnerContract;
673         uint256 expirationBlock;
674         bytes32 id;
675         uint8 v;
676         bytes32 r;
677         bytes32 s;
678     }
679 
680     struct TokenBalance {
681         address tokenAddress;
682         uint256 balance;
683     }
684 
685     struct FeeVariables {
686         uint256 feePercentage;
687         Partner partner;
688         uint256 totalFee;
689     }
690 
691     struct AmountsSpentReceived{
692         uint256 spent;
693         uint256 received;
694     }
695     /*
696     *   Events
697     */
698 
699     event LogSwapCollection(
700         bytes32 indexed id,
701         address indexed partnerContract,
702         address indexed user
703     );
704 
705     event LogSwap(
706         bytes32 indexed id,
707         address sourceAsset,
708         address destinationAsset,
709         uint256 sourceAmount,
710         uint256 destinationAmount,
711         address feeAsset,
712         uint256 feeAmount
713     );
714 
715     /// @notice Constructor
716     /// @param _tokenTransferProxy address of the TokenTransferProxy
717     /// @param _signer the suggester's address that signs the payloads. More can be added with add/removeSigner functions
718     constructor (address _tokenTransferProxy, address _signer/*, address _logger*/) public {
719         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
720         signers[_signer] = true;
721         /* logger = Logger(_logger); */
722     }
723 
724     /*
725     *   Public functions
726     */
727 
728     modifier notExpired(SwapCollection memory swaps) {
729         require(swaps.expirationBlock > block.number, "Expired");
730         _;
731     }
732 
733     modifier validSignature(SwapCollection memory swaps){
734         bytes32 hash = keccak256(abi.encode(swaps.swaps, swaps.partnerContract, swaps.expirationBlock, swaps.id, msg.sender));
735         require(signers[ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), swaps.v, swaps.r, swaps.s)], "Invalid signature");
736         _;
737     }
738 
739     /// @notice Performs the requested set of swaps
740     /// @param swaps The struct that defines the collection of swaps to perform
741     function performSwapCollection(
742         SwapCollection memory swaps
743     )
744         public
745         payable
746         whenNotPaused
747         notExpired(swaps)
748         validSignature(swaps)
749     {
750         TokenBalance[20] memory balances;
751         balances[0] = TokenBalance(address(Utils.eth_address()), msg.value);
752         //this.log("Created eth balance", balances[0].balance, 0x0);
753         for(uint256 swapIndex = 0; swapIndex < swaps.swaps.length; swapIndex++){
754             //this.log("About to perform swap", swapIndex, swaps.id);
755             performSwap(swaps.id, swaps.swaps[swapIndex], balances, swaps.partnerContract);
756         }
757         emit LogSwapCollection(swaps.id, swaps.partnerContract, msg.sender);
758         transferAllTokensToUser(balances);
759     }
760 
761     function addSigner(address newSigner) public onlyOwner {
762          signers[newSigner] = true;
763     }
764 
765     function removeSigner(address signer) public onlyOwner {
766          signers[signer] = false;
767     }
768 
769     /*
770     *   Internal functions
771     */
772 
773 
774     function performSwap(
775         bytes32 swapCollectionId,
776         Swap memory swap,
777         TokenBalance[20] memory balances,
778         address payable partnerContract
779     )
780         internal
781     {
782         if(!transferFromSenderDifference(balances, swap.trades[0].sourceToken, swap.sourceAmount)){
783             if(swap.required){
784                 revert("Failed to get tokens for swap");
785             } else {
786                 return;
787             }
788         }
789         uint256 amountSpentFirstTrade = 0;
790         uint256 amountReceived = 0;
791         uint256 feeAmount = 0;
792         for(uint256 tradeIndex = 0; tradeIndex < swap.trades.length; tradeIndex++){
793             if(tradeIndex == swap.tradeToTakeFeeFrom && swap.takeFeeFromSource){
794                 feeAmount = takeFee(balances, swap.trades[tradeIndex].sourceToken, partnerContract,tradeIndex==0 ? swap.sourceAmount : amountReceived);
795             }
796             uint256 tempSpent;
797             //this.log("About to performTrade",0,0x0);
798             (tempSpent, amountReceived) = performTrade(
799                 swap.trades[tradeIndex],
800                 balances,
801                 Utils.min(
802                     tradeIndex == 0 ? swap.sourceAmount : amountReceived,
803                     balances[findToken(balances, swap.trades[tradeIndex].sourceToken)].balance
804                 )
805             );
806             if(!swap.trades[tradeIndex].isSourceAmount && amountReceived < swap.trades[tradeIndex].amount){
807                 if(swap.required){
808                     revert("Not enough destination amount");
809                 }
810                 return;
811             }
812             if(tradeIndex == 0){
813                 amountSpentFirstTrade = tempSpent;
814                 if(feeAmount != 0){
815                     amountSpentFirstTrade += feeAmount;
816                 }
817             }
818             if(tradeIndex == swap.tradeToTakeFeeFrom && !swap.takeFeeFromSource){
819                 feeAmount = takeFee(balances, swap.trades[tradeIndex].destinationToken, partnerContract, amountReceived);
820                 amountReceived -= feeAmount;
821             }
822         }
823         //this.log("About to emit LogSwap", 0, 0x0);
824         emit LogSwap(
825             swapCollectionId,
826             swap.trades[0].sourceToken,
827             swap.trades[swap.trades.length-1].destinationToken,
828             amountSpentFirstTrade,
829             amountReceived,
830             swap.takeFeeFromSource?swap.trades[swap.tradeToTakeFeeFrom].sourceToken:swap.trades[swap.tradeToTakeFeeFrom].destinationToken,
831             feeAmount
832         );
833 
834         if(amountReceived < swap.minimumDestinationAmount){
835             //this.log("Minimum destination amount failed", 0, 0x0);
836             revert("Got less than minimumDestinationAmount");
837         } else if (minimumRateFailed(swap.trades[0].sourceToken, swap.trades[swap.trades.length-1].destinationToken,swap.sourceAmount, amountReceived, swap.minimumExchangeRate)){
838             //this.log("Minimum rate failed", 0, 0x0);
839             revert("Minimum exchange rate not met");
840         }
841         if(swap.redirectAddress != msg.sender && swap.redirectAddress != address(0x0)){
842             //this.log("About to redirect tokens", amountReceived, 0x0);
843             uint256 destinationTokenIndex = findToken(balances,swap.trades[swap.trades.length-1].destinationToken);
844             uint256 amountToSend = Math.min(amountReceived, balances[destinationTokenIndex].balance);
845             transferTokens(balances, destinationTokenIndex, swap.redirectAddress, amountToSend);
846             removeBalance(balances, swap.trades[swap.trades.length-1].destinationToken, amountToSend);
847         }
848     }
849 
850     function performTrade(
851         Trade memory trade, 
852         TokenBalance[20] memory balances,
853         uint256 availableToSpend
854     ) 
855         internal returns (uint256 totalSpent, uint256 totalReceived)
856     {
857         uint256 tempSpent = 0;
858         uint256 tempReceived = 0;
859         for(uint256 orderIndex = 0; orderIndex < trade.orders.length; orderIndex++){
860             if((availableToSpend - totalSpent) * 10000 < availableToSpend){
861                 break;
862             } else if(!trade.isSourceAmount && tempReceived == trade.amount){
863                 break;
864             } else if (trade.isSourceAmount && tempSpent == trade.amount){
865                 break;
866             }
867             //this.log("About to perform order", orderIndex,0x0);
868             (tempSpent, tempReceived) = performOrder(
869                 trade.orders[orderIndex], 
870                 availableToSpend - totalSpent,
871                 trade.isSourceAmount ? availableToSpend - totalSpent : trade.amount - totalReceived, 
872                 trade.isSourceAmount,
873                 trade.sourceToken, 
874                 balances);
875             //this.log("Order performed",0,0x0);
876             totalSpent += tempSpent;
877             totalReceived += tempReceived;
878         }
879         addBalance(balances, trade.destinationToken, tempReceived);
880         removeBalance(balances, trade.sourceToken, tempSpent);
881         //this.log("Trade performed",tempSpent, 0);
882     }
883 
884     function performOrder(
885         Order memory order, 
886         uint256 availableToSpend,
887         uint256 targetAmount,
888         bool isSourceAmount,
889         address tokenToSpend,
890         TokenBalance[20] memory balances
891     )
892         internal returns (uint256 spent, uint256 received)
893     {
894         //this.log("Performing order", availableToSpend, 0x0);
895 
896         if(tokenToSpend == Utils.eth_address()){
897             (spent, received) = ExchangeHandler(order.exchangeHandler).performOrder.value(availableToSpend)(order.encodedPayload, availableToSpend, targetAmount, isSourceAmount);
898 
899         } else {
900             transferTokens(balances, findToken(balances, tokenToSpend), order.exchangeHandler, availableToSpend);
901             (spent, received) = ExchangeHandler(order.exchangeHandler).performOrder(order.encodedPayload, availableToSpend, targetAmount, isSourceAmount);
902         }
903         //this.log("Performing order", spent,0x0);
904         //this.log("Performing order", received,0x0);
905     }
906 
907     function minimumRateFailed(
908         address sourceToken,
909         address destinationToken,
910         uint256 sourceAmount,
911         uint256 destinationAmount,
912         uint256 minimumExchangeRate
913     )
914         internal returns(bool failed)
915     {
916         //this.log("About to get source decimals",sourceAmount,0x0);
917         uint256 sourceDecimals = sourceToken == Utils.eth_address() ? 18 : Utils.getDecimals(sourceToken);
918         //this.log("About to get destination decimals",destinationAmount,0x0);
919         uint256 destinationDecimals = destinationToken == Utils.eth_address() ? 18 : Utils.getDecimals(destinationToken);
920         //this.log("About to calculate amount got",0,0x0);
921         uint256 rateGot = Utils.calcRateFromQty(sourceAmount, destinationAmount, sourceDecimals, destinationDecimals);
922         //this.log("Minimum rate failed", rateGot, 0x0);
923         return rateGot < minimumExchangeRate;
924     }
925 
926     function takeFee(
927         TokenBalance[20] memory balances,
928         address token,
929         address payable partnerContract,
930         uint256 amountTraded
931     )
932         internal
933         returns (uint256 feeAmount)
934     {
935         Partner partner = Partner(partnerContract);
936         uint256 feePercentage = partner.getTotalFeePercentage();
937         //this.log("Got fee percentage", feePercentage, 0x0);
938         feeAmount = calculateFee(amountTraded, feePercentage);
939         //this.log("Taking fee", feeAmount, 0);
940         transferTokens(balances, findToken(balances, token), partnerContract, feeAmount);
941         removeBalance(balances, findToken(balances, token), feeAmount);
942         //this.log("Took fee", 0, 0x0);
943         return feeAmount;
944     }
945 
946     function transferFromSenderDifference(
947         TokenBalance[20] memory balances,
948         address token,
949         uint256 sourceAmount
950     )
951         internal returns (bool)
952     {
953         if(token == Utils.eth_address()){
954             if(sourceAmount>balances[0].balance){
955                 //this.log("Not enough eth", 0,0x0);
956                 return false;
957             }
958             //this.log("Enough eth", 0,0x0);
959             return true;
960         }
961 
962         uint256 tokenIndex = findToken(balances, token);
963         if(sourceAmount>balances[tokenIndex].balance){
964             //this.log("Transferring in token", 0,0x0);
965             bool success;
966             (success,) = address(tokenTransferProxy).call(abi.encodeWithSignature("transferFrom(address,address,address,uint256)", token, msg.sender, address(this), sourceAmount - balances[tokenIndex].balance));
967             if(success){
968                 //this.log("Got enough token", 0,0x0);
969                 balances[tokenIndex].balance = sourceAmount;
970                 return true;
971             }
972             //this.log("Didn't get enough token", 0,0x0);
973             return false;
974         }
975         return true;
976     }
977 
978     function transferAllTokensToUser(
979         TokenBalance[20] memory balances
980     )
981         internal
982     {
983         //this.log("About to transfer all tokens", 0, 0x0);
984         for(uint256 balanceIndex = 0; balanceIndex < balances.length; balanceIndex++){
985             if(balanceIndex != 0 && balances[balanceIndex].tokenAddress == address(0x0)){
986                 return;
987             }
988             //this.log("Transferring tokens", uint256(balances[balanceIndex].balance),0x0);
989             transferTokens(balances, balanceIndex, msg.sender, balances[balanceIndex].balance);
990         }
991     }
992 
993 
994 
995     function transferTokens(
996         TokenBalance[20] memory balances,
997         uint256 tokenIndex,
998         address payable destination,
999         uint256 tokenAmount
1000     )
1001         internal
1002     {
1003         if(tokenAmount > 0){
1004             if(balances[tokenIndex].tokenAddress == Utils.eth_address()){
1005                 destination.transfer(tokenAmount);
1006             } else {
1007                 ERC20SafeTransfer.safeTransfer(balances[tokenIndex].tokenAddress, destination, tokenAmount);
1008             }
1009         }
1010     }
1011 
1012     function findToken(
1013         TokenBalance[20] memory balances,
1014         address token
1015     )
1016         internal pure returns (uint256)
1017     {
1018         for(uint256 index = 0; index < balances.length; index++){
1019             if(balances[index].tokenAddress == token){
1020                 return index;
1021             } else if (index != 0 && balances[index].tokenAddress == address(0x0)){
1022                 balances[index] = TokenBalance(token, 0);
1023                 return index;
1024             }
1025         }
1026     }
1027 
1028     function addBalance(
1029         TokenBalance[20] memory balances,
1030         address tokenAddress,
1031         uint256 amountToAdd
1032     )
1033         internal
1034         pure
1035     {
1036         uint256 tokenIndex = findToken(balances, tokenAddress);
1037         addBalance(balances, tokenIndex, amountToAdd);
1038     }
1039 
1040     function addBalance(
1041         TokenBalance[20] memory balances,
1042         uint256 balanceIndex,
1043         uint256 amountToAdd
1044     )
1045         internal
1046         pure
1047     {
1048        balances[balanceIndex].balance += amountToAdd;
1049     }
1050 
1051     function removeBalance(
1052         TokenBalance[20] memory balances,
1053         address tokenAddress,
1054         uint256 amountToRemove
1055     )
1056         internal
1057         pure
1058     {
1059         uint256 tokenIndex = findToken(balances, tokenAddress);
1060         removeBalance(balances, tokenIndex, amountToRemove);
1061     }
1062 
1063     function removeBalance(
1064         TokenBalance[20] memory balances,
1065         uint256 balanceIndex,
1066         uint256 amountToRemove
1067     )
1068         internal
1069         pure
1070     {
1071         balances[balanceIndex].balance -= amountToRemove;
1072     }
1073 
1074     // @notice Calculates the fee amount given a fee percentage and amount
1075     // @param amount the amount to calculate the fee based on
1076     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1077     function calculateFee(uint256 amount, uint256 fee) internal pure returns (uint256){
1078         return SafeMath.div(SafeMath.mul(amount, fee), 1 ether);
1079     }
1080 
1081     /*
1082     *   Payable fallback function
1083     */
1084 
1085     /// @notice payable fallback to allow handler or exchange contracts to return ether
1086     /// @dev only accounts containing code (ie. contracts) can send ether to contract
1087     function() external payable whenNotPaused {
1088         // Check in here that the sender is a contract! (to stop accidents)
1089         uint256 size;
1090         address sender = msg.sender;
1091         assembly {
1092             size := extcodesize(sender)
1093         }
1094         if (size == 0) {
1095             revert("EOA cannot send ether to primary fallback");
1096         }
1097     }
1098     event Log(string a, uint256 b, bytes32 c);
1099 
1100     function log(string memory a, uint256 b, bytes32 c) public {
1101         emit Log(a,b,c);
1102     }
1103 }