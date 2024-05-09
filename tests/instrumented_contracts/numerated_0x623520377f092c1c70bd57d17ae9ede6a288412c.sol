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
389 /*
390     Modified Util contract as used by Kyber Network
391 */
392 
393 library Utils {
394 
395     uint256 constant internal PRECISION = (10**18);
396     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
397     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
398     uint256 constant internal MAX_DECIMALS = 18;
399     uint256 constant internal ETH_DECIMALS = 18;
400     uint256 constant internal MAX_UINT = 2**256-1;
401     address constant internal ETH_ADDRESS = address(0x0);
402 
403     // Currently constants can't be accessed from other contracts, so providing functions to do that here
404     function precision() internal pure returns (uint256) { return PRECISION; }
405     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
406     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
407     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
408     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
409     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
410     function eth_address() internal pure returns (address) { return ETH_ADDRESS; }
411 
412     /// @notice Retrieve the number of decimals used for a given ERC20 token
413     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
414     /// ensure that an exception doesn't cause transaction failure
415     /// @param token the token for which we should retrieve the decimals
416     /// @return decimals the number of decimals in the given token
417     function getDecimals(address token)
418         internal
419         returns (uint256 decimals)
420     {
421         bytes4 functionSig = bytes4(keccak256("decimals()"));
422 
423         /// @dev Using assembly due to issues with current solidity `address.call()`
424         /// implementation: https://github.com/ethereum/solidity/issues/2884
425         assembly {
426             // Pointer to next free memory slot
427             let ptr := mload(0x40)
428             // Store functionSig variable at ptr
429             mstore(ptr,functionSig)
430             let functionSigLength := 0x04
431             let wordLength := 0x20
432 
433             let success := call(
434                                 5000, // Amount of gas
435                                 token, // Address to call
436                                 0, // ether to send
437                                 ptr, // ptr to input data
438                                 functionSigLength, // size of data
439                                 ptr, // where to store output data (overwrite input)
440                                 wordLength // size of output data (32 bytes)
441                                )
442 
443             switch success
444             case 0 {
445                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
446             }
447             case 1 {
448                 decimals := mload(ptr) // Set decimals to return data from call
449             }
450             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
451         }
452     }
453 
454     /// @dev Checks that a given address has its token allowance and balance set above the given amount
455     /// @param tokenOwner the address which should have custody of the token
456     /// @param tokenAddress the address of the token to check
457     /// @param tokenAmount the amount of the token which should be set
458     /// @param addressToAllow the address which should be allowed to transfer the token
459     /// @return bool true if the allowance and balance is set, false if not
460     function tokenAllowanceAndBalanceSet(
461         address tokenOwner,
462         address tokenAddress,
463         uint256 tokenAmount,
464         address addressToAllow
465     )
466         internal
467         view
468         returns (bool)
469     {
470         return (
471             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
472             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
473         );
474     }
475 
476     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
477         if (dstDecimals >= srcDecimals) {
478             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
479             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
480         } else {
481             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
482             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
483         }
484     }
485 
486     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
487 
488         //source quantity is rounded up. to avoid dest quantity being too low.
489         uint numerator;
490         uint denominator;
491         if (srcDecimals >= dstDecimals) {
492             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
493             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
494             denominator = rate;
495         } else {
496             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
497             numerator = (PRECISION * dstQty);
498             denominator = (rate * (10**(dstDecimals - srcDecimals)));
499         }
500         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
501     }
502 
503     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal returns (uint) {
504         return calcDstQty(srcAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
505     }
506 
507     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal returns (uint) {
508         return calcSrcQty(destAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
509     }
510 
511     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
512         internal pure returns (uint)
513     {
514         require(srcAmount <= MAX_QTY);
515         require(destAmount <= MAX_QTY);
516 
517         if (dstDecimals >= srcDecimals) {
518             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
519             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
520         } else {
521             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
522             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
523         }
524     }
525 
526     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
527     function min(uint256 a, uint256 b) internal pure returns (uint256) {
528         return a < b ? a : b;
529     }
530 }
531 
532 contract Partner {
533 
534     address payable public partnerBeneficiary;
535     uint256 public partnerPercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
536 
537     uint256 public companyPercentage;
538     address payable public companyBeneficiary;
539 
540     event LogPayout(
541         address token,
542         uint256 partnerAmount,
543         uint256 companyAmount
544     );
545 
546     function init(
547         address payable _companyBeneficiary,
548         uint256 _companyPercentage,
549         address payable _partnerBeneficiary,
550         uint256 _partnerPercentage
551     ) public {
552         require(companyBeneficiary == address(0x0) && partnerBeneficiary == address(0x0));
553         companyBeneficiary = _companyBeneficiary;
554         companyPercentage = _companyPercentage;
555         partnerBeneficiary = _partnerBeneficiary;
556         partnerPercentage = _partnerPercentage;
557     }
558 
559     function payout(
560         address[] memory tokens
561     ) public {
562         // Payout both the partner and the company at the same time
563         for(uint256 index = 0; index<tokens.length; index++){
564             uint256 balance = tokens[index] == Utils.eth_address()? address(this).balance : ERC20(tokens[index]).balanceOf(address(this));
565             uint256 partnerAmount = SafeMath.div(SafeMath.mul(balance, partnerPercentage), getTotalFeePercentage());
566             uint256 companyAmount = balance - partnerAmount;
567             if(tokens[index] == Utils.eth_address()){
568                 partnerBeneficiary.transfer(partnerAmount);
569                 companyBeneficiary.transfer(companyAmount);
570             } else {
571                 ERC20SafeTransfer.safeTransfer(tokens[index], partnerBeneficiary, partnerAmount);
572                 ERC20SafeTransfer.safeTransfer(tokens[index], companyBeneficiary, companyAmount);
573             }
574         }
575     }
576 
577     function getTotalFeePercentage() public view returns (uint256){
578         return partnerPercentage + companyPercentage;
579     }
580 
581     function() external payable {
582 
583     }
584 }
585 
586 /* import "../lib/Logger.sol"; */
587 
588 /// @title Interface for all exchange handler contracts
589 contract ExchangeHandler is Withdrawable, Pausable {
590 
591     /*
592     *   State Variables
593     */
594 
595     /* Logger public logger; */
596     /*
597     *   Modifiers
598     */
599 
600     function performOrder(
601         bytes memory genericPayload,
602         uint256 availableToSpend,
603         uint256 targetAmount,
604         bool targetAmountIsSource
605     )
606         public
607         payable
608         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder);
609 
610 }
611 
612 /// @title The primary contract for Totle
613 contract TotlePrimary is Withdrawable, Pausable {
614 
615     /*
616     *   State Variables
617     */
618 
619     TokenTransferProxy public tokenTransferProxy;
620     mapping(address => bool) public signers;
621     /* Logger public logger; */
622 
623     /*
624     *   Types
625     */
626 
627     // Structs
628     struct Order {
629         address payable exchangeHandler;
630         bytes encodedPayload;
631     }
632 
633     struct Trade {
634         address sourceToken;
635         address destinationToken;
636         uint256 amount;
637         bool isSourceAmount; //true if amount is sourceToken, false if it's destinationToken
638         Order[] orders;
639     }
640 
641     struct Swap {
642         Trade[] trades;
643         uint256 minimumExchangeRate;
644         uint256 minimumDestinationAmount;
645         uint256 sourceAmount;
646         uint256 tradeToTakeFeeFrom;
647         bool takeFeeFromSource; //Takes the fee before the trade if true, takes it after if false
648         address payable redirectAddress;
649         bool required;
650     }
651 
652     struct SwapCollection {
653         Swap[] swaps;
654         address payable partnerContract;
655         uint256 expirationBlock;
656         bytes32 id;
657         uint8 v;
658         bytes32 r;
659         bytes32 s;
660     }
661 
662     struct TokenBalance {
663         address tokenAddress;
664         uint256 balance;
665     }
666 
667     struct FeeVariables {
668         uint256 feePercentage;
669         Partner partner;
670         uint256 totalFee;
671     }
672 
673     struct AmountsSpentReceived{
674         uint256 spent;
675         uint256 received;
676     }
677     /*
678     *   Events
679     */
680 
681     event LogSwapCollection(
682         bytes32 indexed id,
683         address indexed partnerContract,
684         address indexed user
685     );
686 
687     event LogSwap(
688         bytes32 indexed id,
689         address sourceAsset,
690         address destinationAsset,
691         uint256 sourceAmount,
692         uint256 destinationAmount,
693         address feeAsset,
694         uint256 feeAmount
695     );
696 
697     /// @notice Constructor
698     /// @param _tokenTransferProxy address of the TokenTransferProxy
699     /// @param _signer the suggester's address that signs the payloads. More can be added with add/removeSigner functions
700     constructor (address _tokenTransferProxy, address _signer/*, address _logger*/) public {
701         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
702         signers[_signer] = true;
703         /* logger = Logger(_logger); */
704     }
705 
706     /*
707     *   Public functions
708     */
709 
710     modifier notExpired(SwapCollection memory swaps) {
711         require(swaps.expirationBlock > block.number, "Expired");
712         _;
713     }
714 
715     modifier validSignature(SwapCollection memory swaps){
716         bytes32 hash = keccak256(abi.encode(swaps.swaps, swaps.partnerContract, swaps.expirationBlock, swaps.id, msg.sender));
717         require(signers[ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), swaps.v, swaps.r, swaps.s)], "Invalid signature");
718         _;
719     }
720 
721     /// @notice Performs the requested set of swaps
722     /// @param swaps The struct that defines the collection of swaps to perform
723     function performSwapCollection(
724         SwapCollection memory swaps
725     )
726         public
727         payable
728         whenNotPaused
729         notExpired(swaps)
730         validSignature(swaps)
731     {
732         TokenBalance[20] memory balances;
733         balances[0] = TokenBalance(address(Utils.eth_address()), msg.value);
734         this.log("Created eth balance", balances[0].balance, 0x0);
735         for(uint256 swapIndex = 0; swapIndex < swaps.swaps.length; swapIndex++){
736             this.log("About to perform swap", swapIndex, swaps.id);
737             performSwap(swaps.id, swaps.swaps[swapIndex], balances, swaps.partnerContract);
738         }
739         emit LogSwapCollection(swaps.id, swaps.partnerContract, msg.sender);
740         transferAllTokensToUser(balances);
741     }
742 
743     function addSigner(address newSigner) public onlyOwner {
744          signers[newSigner] = true;
745     }
746 
747     function removeSigner(address signer) public onlyOwner {
748          signers[signer] = false;
749     }
750 
751     /*
752     *   Internal functions
753     */
754 
755 
756     function performSwap(
757         bytes32 swapCollectionId,
758         Swap memory swap,
759         TokenBalance[20] memory balances,
760         address payable partnerContract
761     )
762         internal
763     {
764         if(!transferFromSenderDifference(balances, swap.trades[0].sourceToken, swap.sourceAmount)){
765             if(swap.required){
766                 revert("Failed to get tokens for required swap");
767             } else {
768                 return;
769             }
770         }
771         uint256 amountSpentFirstTrade = 0;
772         uint256 amountReceived = 0;
773         uint256 feeAmount = 0;
774         for(uint256 tradeIndex = 0; tradeIndex < swap.trades.length; tradeIndex++){
775             if(tradeIndex == swap.tradeToTakeFeeFrom && swap.takeFeeFromSource){
776                 feeAmount = takeFee(balances, swap.trades[tradeIndex].sourceToken, partnerContract,tradeIndex==0 ? swap.sourceAmount : amountReceived);
777             }
778             uint256 tempSpent;
779             this.log("About to performTrade",0,0x0);
780             (tempSpent, amountReceived) = performTrade(
781                 swap.trades[tradeIndex],
782                 balances,
783                 Utils.min(
784                     tradeIndex == 0 ? swap.sourceAmount : amountReceived,
785                     balances[findToken(balances, swap.trades[tradeIndex].sourceToken)].balance
786                 )
787             );
788             if(!swap.trades[tradeIndex].isSourceAmount && amountReceived < swap.trades[tradeIndex].amount){
789                 if(swap.required){
790                     revert("Not enough destination amount");
791                 }
792                 return;
793             }
794             if(tradeIndex == 0){
795                 amountSpentFirstTrade = tempSpent;
796             }
797             if(tradeIndex == swap.tradeToTakeFeeFrom && !swap.takeFeeFromSource){
798                 feeAmount = takeFee(balances, swap.trades[tradeIndex].destinationToken, partnerContract, amountReceived);
799             }
800         }
801         this.log("About to emit LogSwap", 0, 0x0);
802         emit LogSwap(
803             swapCollectionId,
804             swap.trades[0].sourceToken,
805             swap.trades[swap.trades.length-1].destinationToken,
806             amountSpentFirstTrade,
807             amountReceived,
808             swap.takeFeeFromSource?swap.trades[swap.tradeToTakeFeeFrom].sourceToken:swap.trades[swap.tradeToTakeFeeFrom].destinationToken,
809             feeAmount
810         );
811 
812         if(amountReceived < swap.minimumDestinationAmount){
813             this.log("Minimum destination amount failed", 0, 0x0);
814             revert("Tokens got less than minimumDestinationAmount");
815         } else if (minimumRateFailed(swap.trades[0].sourceToken, swap.trades[swap.trades.length-1].destinationToken,swap.sourceAmount, amountReceived, swap.minimumExchangeRate)){
816             this.log("Minimum rate failed", 0, 0x0);
817             revert("Minimum exchange rate not met");
818         }
819         if(swap.redirectAddress != msg.sender && swap.redirectAddress != address(0x0)){
820             this.log("About to redirect tokens", amountReceived, 0x0);
821             transferTokens(balances, findToken(balances,swap.trades[swap.trades.length-1].destinationToken), swap.redirectAddress, amountReceived);
822             removeBalance(balances, swap.trades[swap.trades.length-1].destinationToken, amountReceived);
823         }
824     }
825 
826     function performTrade(
827         Trade memory trade, 
828         TokenBalance[20] memory balances,
829         uint256 availableToSpend
830     ) 
831         internal returns (uint256 totalSpent, uint256 totalReceived)
832     {
833         uint256 tempSpent = 0;
834         uint256 tempReceived = 0;
835         for(uint256 orderIndex = 0; orderIndex < trade.orders.length; orderIndex++){
836             if((availableToSpend - totalSpent) * 10000 < availableToSpend){
837                 break;
838             }
839             this.log("About to perform order", orderIndex,0x0);
840             (tempSpent, tempReceived) = performOrder(
841                 trade.orders[orderIndex], 
842                 availableToSpend - totalSpent,
843                 trade.isSourceAmount ? availableToSpend - totalSpent : trade.amount - totalReceived, 
844                 trade.isSourceAmount,
845                 trade.sourceToken, 
846                 balances);
847             this.log("Order performed",0,0x0);
848             totalSpent += tempSpent;
849             totalReceived += tempReceived;
850         }
851         addBalance(balances, trade.destinationToken, tempReceived);
852         removeBalance(balances, trade.sourceToken, tempSpent);
853         this.log("Trade performed",tempSpent, 0);
854     }
855 
856     function performOrder(
857         Order memory order, 
858         uint256 availableToSpend,
859         uint256 targetAmount,
860         bool isSourceAmount,
861         address tokenToSpend,
862         TokenBalance[20] memory balances
863     )
864         internal returns (uint256 spent, uint256 received)
865     {
866         this.log("Performing order", availableToSpend, 0x0);
867 
868         if(tokenToSpend == Utils.eth_address()){
869             (spent, received) = ExchangeHandler(order.exchangeHandler).performOrder.value(availableToSpend)(order.encodedPayload, availableToSpend, targetAmount, isSourceAmount);
870 
871         } else {
872             transferTokens(balances, findToken(balances, tokenToSpend), order.exchangeHandler, availableToSpend);
873             (spent, received) = ExchangeHandler(order.exchangeHandler).performOrder(order.encodedPayload, availableToSpend, targetAmount, isSourceAmount);
874         }
875         this.log("Performing order", spent,0x0);
876         this.log("Performing order", received,0x0);
877     }
878 
879     function minimumRateFailed(
880         address sourceToken,
881         address destinationToken,
882         uint256 sourceAmount,
883         uint256 destinationAmount,
884         uint256 minimumExchangeRate
885     )
886         internal returns(bool failed)
887     {
888         this.log("About to get source decimals",sourceAmount,0x0);
889         uint256 sourceDecimals = sourceToken == Utils.eth_address() ? 18 : Utils.getDecimals(sourceToken);
890         this.log("About to get destination decimals",destinationAmount,0x0);
891         uint256 destinationDecimals = destinationToken == Utils.eth_address() ? 18 : Utils.getDecimals(destinationToken);
892         this.log("About to calculate amount got",0,0x0);
893         uint256 rateGot = Utils.calcRateFromQty(sourceAmount, destinationAmount, sourceDecimals, destinationDecimals);
894         this.log("Minimum rate failed", rateGot, 0x0);
895         return rateGot < minimumExchangeRate;
896     }
897 
898     function takeFee(
899         TokenBalance[20] memory balances,
900         address token,
901         address payable partnerContract,
902         uint256 amountTraded
903     )
904         internal
905         returns (uint256 feeAmount)
906     {
907         Partner partner = Partner(partnerContract);
908         uint256 feePercentage = partner.getTotalFeePercentage();
909         this.log("Got fee percentage", feePercentage, 0x0);
910         feeAmount = calculateFee(amountTraded, feePercentage);
911         this.log("Taking fee", feeAmount, 0);
912         transferTokens(balances, findToken(balances, token), partnerContract, feeAmount);
913         removeBalance(balances, findToken(balances, token), feeAmount);
914         this.log("Took fee", 0, 0x0);
915         return feeAmount;
916     }
917 
918     function transferFromSenderDifference(
919         TokenBalance[20] memory balances,
920         address token,
921         uint256 sourceAmount
922     )
923         internal returns (bool)
924     {
925         if(token == Utils.eth_address()){
926             if(sourceAmount>balances[0].balance){
927                 this.log("Not enough eth", 0,0x0);
928                 return false;
929             }
930             this.log("Enough eth", 0,0x0);
931             return true;
932         }
933 
934         uint256 tokenIndex = findToken(balances, token);
935         if(sourceAmount>balances[tokenIndex].balance){
936             this.log("Transferring in token", 0,0x0);
937             bool success;
938             (success,) = address(tokenTransferProxy).call(abi.encodeWithSignature("transferFrom(address,address,address,uint256)", token, msg.sender, address(this), sourceAmount - balances[tokenIndex].balance));
939             if(success){
940                 this.log("Got enough token", 0,0x0);
941                 balances[tokenIndex].balance = sourceAmount;
942                 return true;
943             }
944             this.log("Didn't get enough token", 0,0x0);
945             return false;
946         }
947         return true;
948     }
949 
950     function transferAllTokensToUser(
951         TokenBalance[20] memory balances
952     )
953         internal
954     {
955         this.log("About to transfer all tokens", 0, 0x0);
956         for(uint256 balanceIndex = 0; balanceIndex < balances.length; balanceIndex++){
957             if(balanceIndex != 0 && balances[balanceIndex].tokenAddress == address(0x0)){
958                 return;
959             }
960             this.log("Transferring tokens", uint256(balances[balanceIndex].balance),0x0);
961             transferTokens(balances, balanceIndex, msg.sender, balances[balanceIndex].balance);
962         }
963     }
964 
965 
966 
967     function transferTokens(
968         TokenBalance[20] memory balances,
969         uint256 tokenIndex,
970         address payable destination,
971         uint256 tokenAmount
972     )
973         internal
974     {
975         if(tokenAmount > 0){
976             if(balances[tokenIndex].tokenAddress == Utils.eth_address()){
977                 destination.transfer(tokenAmount);
978             } else {
979                 ERC20SafeTransfer.safeTransfer(balances[tokenIndex].tokenAddress, destination, tokenAmount);
980             }
981         }
982     }
983 
984     function findToken(
985         TokenBalance[20] memory balances,
986         address token
987     )
988         internal pure returns (uint256)
989     {
990         for(uint256 index = 0; index < balances.length; index++){
991             if(balances[index].tokenAddress == token){
992                 return index;
993             } else if (index != 0 && balances[index].tokenAddress == address(0x0)){
994                 balances[index] = TokenBalance(token, 0);
995                 return index;
996             }
997         }
998     }
999 
1000     function addBalance(
1001         TokenBalance[20] memory balances,
1002         address tokenAddress,
1003         uint256 amountToAdd
1004     )
1005         internal
1006         pure
1007     {
1008         uint256 tokenIndex = findToken(balances, tokenAddress);
1009         addBalance(balances, tokenIndex, amountToAdd);
1010     }
1011 
1012     function addBalance(
1013         TokenBalance[20] memory balances,
1014         uint256 balanceIndex,
1015         uint256 amountToAdd
1016     )
1017         internal
1018         pure
1019     {
1020        balances[balanceIndex].balance += amountToAdd;
1021     }
1022 
1023     function removeBalance(
1024         TokenBalance[20] memory balances,
1025         address tokenAddress,
1026         uint256 amountToRemove
1027     )
1028         internal
1029         pure
1030     {
1031         uint256 tokenIndex = findToken(balances, tokenAddress);
1032         removeBalance(balances, tokenIndex, amountToRemove);
1033     }
1034 
1035     function removeBalance(
1036         TokenBalance[20] memory balances,
1037         uint256 balanceIndex,
1038         uint256 amountToRemove
1039     )
1040         internal
1041         pure
1042     {
1043         balances[balanceIndex].balance -= amountToRemove;
1044     }
1045 
1046     // @notice Calculates the fee amount given a fee percentage and amount
1047     // @param amount the amount to calculate the fee based on
1048     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1049     function calculateFee(uint256 amount, uint256 fee) internal pure returns (uint256){
1050         return SafeMath.div(SafeMath.mul(amount, fee), 1 ether);
1051     }
1052 
1053     /*
1054     *   Payable fallback function
1055     */
1056 
1057     /// @notice payable fallback to allow handler or exchange contracts to return ether
1058     /// @dev only accounts containing code (ie. contracts) can send ether to contract
1059     function() external payable whenNotPaused {
1060         // Check in here that the sender is a contract! (to stop accidents)
1061         uint256 size;
1062         address sender = msg.sender;
1063         assembly {
1064             size := extcodesize(sender)
1065         }
1066         if (size == 0) {
1067             revert("EOA cannot send ether to primary fallback");
1068         }
1069     }
1070     event Log(string a, uint256 b, bytes32 c);
1071 
1072     function log(string memory a, uint256 b, bytes32 c) public {
1073         emit Log(a,b,c);
1074     }
1075 }