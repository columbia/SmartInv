1 pragma solidity 0.5.7;
2 pragma experimental ABIEncoderV2;
3 
4 /*
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
127  * @title Pausable
128  * @dev Base contract which allows children to implement an emergency stop mechanism.
129  */
130 contract Pausable is Ownable {
131   event Paused();
132   event Unpaused();
133 
134   bool private _paused = false;
135 
136   /**
137    * @return true if the contract is paused, false otherwise.
138    */
139   function paused() public view returns (bool) {
140     return _paused;
141   }
142 
143   /**
144    * @dev Modifier to make a function callable only when the contract is not paused.
145    */
146   modifier whenNotPaused() {
147     require(!_paused, "Contract is paused.");
148     _;
149   }
150 
151   /**
152    * @dev Modifier to make a function callable only when the contract is paused.
153    */
154   modifier whenPaused() {
155     require(_paused, "Contract not paused.");
156     _;
157   }
158 
159   /**
160    * @dev called by the owner to pause, triggers stopped state
161    */
162   function pause() public onlyOwner whenNotPaused {
163     _paused = true;
164     emit Paused();
165   }
166 
167   /**
168    * @dev called by the owner to unpause, returns to normal state
169    */
170   function unpause() public onlyOwner whenPaused {
171     _paused = false;
172     emit Unpaused();
173   }
174 }
175 
176 /**
177  * @title ERC20 interface
178  * @dev see https://github.com/ethereum/EIPs/issues/20
179  */
180 contract ERC20 {
181   function totalSupply() public view returns (uint256);
182 
183   function balanceOf(address _who) public view returns (uint256);
184 
185   function allowance(address _owner, address _spender)
186     public view returns (uint256);
187 
188   function transfer(address _to, uint256 _value) public returns (bool);
189 
190   function approve(address _spender, uint256 _value)
191     public returns (bool);
192 
193   function transferFrom(address _from, address _to, uint256 _value)
194     public returns (bool);
195 
196   function decimals() public view returns (uint256);
197 
198   event Transfer(
199     address indexed from,
200     address indexed to,
201     uint256 value
202   );
203 
204   event Approval(
205     address indexed owner,
206     address indexed spender,
207     uint256 value
208   );
209 }
210 /*
211 
212   Copyright 2018 ZeroEx Intl.
213 
214   Licensed under the Apache License, Version 2.0 (the "License");
215   you may not use this file except in compliance with the License.
216   You may obtain a copy of the License at
217 
218     http://www.apache.org/licenses/LICENSE-2.0
219 
220   Unless required by applicable law or agreed to in writing, software
221   distributed under the License is distributed on an "AS IS" BASIS,
222   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
223   See the License for the specific language governing permissions and
224   limitations under the License.
225 
226 */
227 // @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
228 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
229 contract TokenTransferProxy is Ownable {
230 
231     /// @dev Only authorized addresses can invoke functions with this modifier.
232     modifier onlyAuthorized {
233         require(authorized[msg.sender]);
234         _;
235     }
236 
237     modifier targetAuthorized(address target) {
238         require(authorized[target]);
239         _;
240     }
241 
242     modifier targetNotAuthorized(address target) {
243         require(!authorized[target]);
244         _;
245     }
246 
247     mapping (address => bool) public authorized;
248     address[] public authorities;
249 
250     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
251     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
252 
253     /*
254      * Public functions
255      */
256 
257     /// @dev Authorizes an address.
258     /// @param target Address to authorize.
259     function addAuthorizedAddress(address target)
260         public
261         onlyOwner
262         targetNotAuthorized(target)
263     {
264         authorized[target] = true;
265         authorities.push(target);
266         emit LogAuthorizedAddressAdded(target, msg.sender);
267     }
268 
269     /// @dev Removes authorizion of an address.
270     /// @param target Address to remove authorization from.
271     function removeAuthorizedAddress(address target)
272         public
273         onlyOwner
274         targetAuthorized(target)
275     {
276         delete authorized[target];
277         for (uint i = 0; i < authorities.length; i++) {
278             if (authorities[i] == target) {
279                 authorities[i] = authorities[authorities.length - 1];
280                 authorities.length -= 1;
281                 break;
282             }
283         }
284         emit LogAuthorizedAddressRemoved(target, msg.sender);
285     }
286 
287     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
288     /// @param token Address of token to transfer.
289     /// @param from Address to transfer token from.
290     /// @param to Address to transfer token to.
291     /// @param value Amount of token to transfer.
292     /// @return Success of transfer.
293     function transferFrom(
294         address token,
295         address from,
296         address to,
297         uint value)
298         public
299         onlyAuthorized
300         returns (bool)
301     {
302         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
303         return true;
304     }
305 
306     /*
307      * Public view functions
308      */
309 
310     /// @dev Gets all authorized addresses.
311     /// @return Array of authorized addresses.
312     function getAuthorizedAddresses()
313         public
314         view
315         returns (address[] memory)
316     {
317         return authorities;
318     }
319 }
320 
321 
322 /*
323     Modified Util contract as used by Kyber Network
324 */
325 
326 library Utils {
327 
328     uint256 constant internal PRECISION = (10**18);
329     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
330     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
331     uint256 constant internal MAX_DECIMALS = 18;
332     uint256 constant internal ETH_DECIMALS = 18;
333     uint256 constant internal MAX_UINT = 2**256-1;
334     address constant internal ETH_ADDRESS = address(0x0);
335 
336     // Currently constants can't be accessed from other contracts, so providing functions to do that here
337     function precision() internal pure returns (uint256) { return PRECISION; }
338     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
339     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
340     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
341     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
342     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
343     function eth_address() internal pure returns (address) { return ETH_ADDRESS; }
344 
345     /// @notice Retrieve the number of decimals used for a given ERC20 token
346     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
347     /// ensure that an exception doesn't cause transaction failure
348     /// @param token the token for which we should retrieve the decimals
349     /// @return decimals the number of decimals in the given token
350     function getDecimals(address token)
351         internal
352         returns (uint256 decimals)
353     {
354         bytes4 functionSig = bytes4(keccak256("decimals()"));
355 
356         /// @dev Using assembly due to issues with current solidity `address.call()`
357         /// implementation: https://github.com/ethereum/solidity/issues/2884
358         assembly {
359             // Pointer to next free memory slot
360             let ptr := mload(0x40)
361             // Store functionSig variable at ptr
362             mstore(ptr,functionSig)
363             let functionSigLength := 0x04
364             let wordLength := 0x20
365 
366             let success := call(
367                                 gas, // Amount of gas
368                                 token, // Address to call
369                                 0, // ether to send
370                                 ptr, // ptr to input data
371                                 functionSigLength, // size of data
372                                 ptr, // where to store output data (overwrite input)
373                                 wordLength // size of output data (32 bytes)
374                                )
375 
376             switch success
377             case 0 {
378                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
379             }
380             case 1 {
381                 decimals := mload(ptr) // Set decimals to return data from call
382             }
383             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
384         }
385     }
386 
387     /// @dev Checks that a given address has its token allowance and balance set above the given amount
388     /// @param tokenOwner the address which should have custody of the token
389     /// @param tokenAddress the address of the token to check
390     /// @param tokenAmount the amount of the token which should be set
391     /// @param addressToAllow the address which should be allowed to transfer the token
392     /// @return bool true if the allowance and balance is set, false if not
393     function tokenAllowanceAndBalanceSet(
394         address tokenOwner,
395         address tokenAddress,
396         uint256 tokenAmount,
397         address addressToAllow
398     )
399         internal
400         view
401         returns (bool)
402     {
403         return (
404             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
405             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
406         );
407     }
408 
409     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
410         if (dstDecimals >= srcDecimals) {
411             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
412             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
413         } else {
414             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
415             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
416         }
417     }
418 
419     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
420 
421         //source quantity is rounded up. to avoid dest quantity being too low.
422         uint numerator;
423         uint denominator;
424         if (srcDecimals >= dstDecimals) {
425             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
426             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
427             denominator = rate;
428         } else {
429             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
430             numerator = (PRECISION * dstQty);
431             denominator = (rate * (10**(dstDecimals - srcDecimals)));
432         }
433         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
434     }
435 
436     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal returns (uint) {
437         return calcDstQty(srcAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
438     }
439 
440     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal returns (uint) {
441         return calcSrcQty(destAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
442     }
443 
444     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
445         internal pure returns (uint)
446     {
447         require(srcAmount <= MAX_QTY);
448         require(destAmount <= MAX_QTY);
449 
450         if (dstDecimals >= srcDecimals) {
451             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
452             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
453         } else {
454             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
455             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
456         }
457     }
458 
459     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
460     function min(uint256 a, uint256 b) internal pure returns (uint256) {
461         return a < b ? a : b;
462     }
463 }
464 
465 /**
466  * @title SafeMath
467  * @dev Math operations with safety checks that revert on error
468  */
469 library SafeMath {
470 
471   /**
472   * @dev Multiplies two numbers, reverts on overflow.
473   */
474   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
475     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
476     // benefit is lost if 'b' is also tested.
477     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
478     if (_a == 0) {
479       return 0;
480     }
481 
482     uint256 c = _a * _b;
483     require(c / _a == _b);
484 
485     return c;
486   }
487 
488   /**
489   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
490   */
491   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
492     require(_b > 0); // Solidity only automatically asserts when dividing by 0
493     uint256 c = _a / _b;
494     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
495 
496     return c;
497   }
498 
499   /**
500   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
501   */
502   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
503     require(_b <= _a);
504     uint256 c = _a - _b;
505 
506     return c;
507   }
508 
509   /**
510   * @dev Adds two numbers, reverts on overflow.
511   */
512   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
513     uint256 c = _a + _b;
514     require(c >= _a);
515 
516     return c;
517   }
518 
519   /**
520   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
521   * reverts when dividing by zero.
522   */
523   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
524     require(b != 0);
525     return a % b;
526   }
527 }
528 
529 contract Partner {
530 
531     address payable public partnerBeneficiary;
532     uint256 public partnerPercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
533 
534     uint256 public companyPercentage;
535     address payable public companyBeneficiary;
536 
537     event LogPayout(
538         address token,
539         uint256 partnerAmount,
540         uint256 companyAmount
541     );
542 
543     function init(
544         address payable _companyBeneficiary,
545         uint256 _companyPercentage,
546         address payable _partnerBeneficiary,
547         uint256 _partnerPercentage
548     ) public {
549         require(companyBeneficiary == address(0x0) && partnerBeneficiary == address(0x0));
550         companyBeneficiary = _companyBeneficiary;
551         companyPercentage = _companyPercentage;
552         partnerBeneficiary = _partnerBeneficiary;
553         partnerPercentage = _partnerPercentage;
554     }
555 
556     function payout(
557         address[] memory tokens
558     ) public {
559         // Payout both the partner and the company at the same time
560         for(uint256 index = 0; index<tokens.length; index++){
561             uint256 balance = tokens[index] == Utils.eth_address()? address(this).balance : ERC20(tokens[index]).balanceOf(address(this));
562             uint256 partnerAmount = SafeMath.div(SafeMath.mul(balance, partnerPercentage), getTotalFeePercentage());
563             uint256 companyAmount = balance - partnerAmount;
564             if(tokens[index] == Utils.eth_address()){
565                 partnerBeneficiary.transfer(partnerAmount);
566                 companyBeneficiary.transfer(companyAmount);
567             } else {
568                 ERC20SafeTransfer.safeTransfer(tokens[index], partnerBeneficiary, partnerAmount);
569                 ERC20SafeTransfer.safeTransfer(tokens[index], companyBeneficiary, companyAmount);
570             }
571         }
572     }
573 
574     function getTotalFeePercentage() public view returns (uint256){
575         return partnerPercentage + companyPercentage;
576     }
577 
578     function() external payable {
579 
580     }
581 }
582 
583 /**
584  * @title Math
585  * @dev Assorted math operations
586  */
587 
588 library Math {
589   function max(uint256 a, uint256 b) internal pure returns (uint256) {
590     return a >= b ? a : b;
591   }
592 
593   function min(uint256 a, uint256 b) internal pure returns (uint256) {
594     return a < b ? a : b;
595   }
596 
597   function average(uint256 a, uint256 b) internal pure returns (uint256) {
598     // (a + b) / 2 can overflow, so we distribute
599     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
600   }
601 }
602 
603 /// @title Interface for all exchange handler contracts
604 contract ExchangeHandler is Withdrawable, Pausable {
605 
606     /*
607     *   State Variables
608     */
609 
610     /* Logger public logger; */
611     /*
612     *   Modifiers
613     */
614 
615     function performOrder(
616         bytes memory genericPayload,
617         uint256 availableToSpend,
618         uint256 targetAmount,
619         bool targetAmountIsSource
620     )
621         public
622         payable
623         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder);
624 
625 }
626 
627 /// @title The primary contract for Totle
628 contract TotlePrimary is Withdrawable, Pausable {
629 
630     /*
631     *   State Variables
632     */
633 
634     TokenTransferProxy public tokenTransferProxy;
635     mapping(address => bool) public signers;
636     /* Logger public logger; */
637 
638     /*
639     *   Types
640     */
641 
642     // Structs
643     struct Order {
644         address payable exchangeHandler;
645         bytes encodedPayload;
646     }
647 
648     struct Trade {
649         address sourceToken;
650         address destinationToken;
651         uint256 amount;
652         bool isSourceAmount; //true if amount is sourceToken, false if it's destinationToken
653         Order[] orders;
654     }
655 
656     struct Swap {
657         Trade[] trades;
658         uint256 minimumExchangeRate;
659         uint256 minimumDestinationAmount;
660         uint256 sourceAmount;
661         uint256 tradeToTakeFeeFrom;
662         bool takeFeeFromSource; //Takes the fee before the trade if true, takes it after if false
663         address payable redirectAddress;
664         bool required;
665     }
666 
667     struct SwapCollection {
668         Swap[] swaps;
669         address payable partnerContract;
670         uint256 expirationBlock;
671         bytes32 id;
672         uint8 v;
673         bytes32 r;
674         bytes32 s;
675     }
676 
677     struct TokenBalance {
678         address tokenAddress;
679         uint256 balance;
680     }
681 
682     struct FeeVariables {
683         uint256 feePercentage;
684         Partner partner;
685         uint256 totalFee;
686     }
687 
688     struct AmountsSpentReceived{
689         uint256 spent;
690         uint256 received;
691     }
692     /*
693     *   Events
694     */
695 
696     event LogSwapCollection(
697         bytes32 indexed id,
698         address indexed partnerContract,
699         address indexed user
700     );
701 
702     event LogSwap(
703         bytes32 indexed id,
704         address sourceAsset,
705         address destinationAsset,
706         uint256 sourceAmount,
707         uint256 destinationAmount,
708         address feeAsset,
709         uint256 feeAmount
710     );
711 
712     /// @notice Constructor
713     /// @param _tokenTransferProxy address of the TokenTransferProxy
714     /// @param _signer the suggester's address that signs the payloads. More can be added with add/removeSigner functions
715     constructor (address _tokenTransferProxy, address _signer/*, address _logger*/) public {
716         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
717         signers[_signer] = true;
718         /* logger = Logger(_logger); */
719     }
720 
721     /*
722     *   Public functions
723     */
724 
725     modifier notExpired(SwapCollection memory swaps) {
726         require(swaps.expirationBlock > block.number, "Expired");
727         _;
728     }
729 
730     modifier validSignature(SwapCollection memory swaps){
731         bytes32 hash = keccak256(abi.encode(swaps.swaps, swaps.partnerContract, swaps.expirationBlock, swaps.id, msg.sender));
732         require(signers[ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)), swaps.v, swaps.r, swaps.s)], "Invalid signature");
733         _;
734     }
735 
736     /// @notice Performs the requested set of swaps
737     /// @param swaps The struct that defines the collection of swaps to perform
738     function performSwapCollection(
739         SwapCollection memory swaps
740     )
741         public
742         payable
743         whenNotPaused
744         notExpired(swaps)
745         validSignature(swaps)
746     {
747         TokenBalance[20] memory balances;
748         balances[0] = TokenBalance(address(Utils.eth_address()), msg.value);
749         //this.log("Created eth balance", balances[0].balance, 0x0);
750         for(uint256 swapIndex = 0; swapIndex < swaps.swaps.length; swapIndex++){
751             //this.log("About to perform swap", swapIndex, swaps.id);
752             performSwap(swaps.id, swaps.swaps[swapIndex], balances, swaps.partnerContract);
753         }
754         emit LogSwapCollection(swaps.id, swaps.partnerContract, msg.sender);
755         transferAllTokensToUser(balances);
756     }
757 
758     function addSigner(address newSigner) public onlyOwner {
759          signers[newSigner] = true;
760     }
761 
762     function removeSigner(address signer) public onlyOwner {
763          signers[signer] = false;
764     }
765 
766     /*
767     *   Internal functions
768     */
769 
770 
771     function performSwap(
772         bytes32 swapCollectionId,
773         Swap memory swap,
774         TokenBalance[20] memory balances,
775         address payable partnerContract
776     )
777         internal
778     {
779         if(!transferFromSenderDifference(balances, swap.trades[0].sourceToken, swap.sourceAmount)){
780             if(swap.required){
781                 revert("Failed to get tokens for swap");
782             } else {
783                 return;
784             }
785         }
786         uint256 amountSpentFirstTrade = 0;
787         uint256 amountReceived = 0;
788         uint256 feeAmount = 0;
789         for(uint256 tradeIndex = 0; tradeIndex < swap.trades.length; tradeIndex++){
790             if(tradeIndex == swap.tradeToTakeFeeFrom && swap.takeFeeFromSource){
791                 feeAmount = takeFee(balances, swap.trades[tradeIndex].sourceToken, partnerContract,tradeIndex==0 ? swap.sourceAmount : amountReceived);
792             }
793             uint256 tempSpent;
794             //this.log("About to performTrade",0,0x0);
795             (tempSpent, amountReceived) = performTrade(
796                 swap.trades[tradeIndex],
797                 balances,
798                 Utils.min(
799                     tradeIndex == 0 ? swap.sourceAmount : amountReceived,
800                     balances[findToken(balances, swap.trades[tradeIndex].sourceToken)].balance
801                 )
802             );
803             if(!swap.trades[tradeIndex].isSourceAmount && amountReceived < swap.trades[tradeIndex].amount){
804                 if(swap.required){
805                     revert("Not enough destination amount");
806                 }
807                 return;
808             }
809             if(tradeIndex == 0){
810                 amountSpentFirstTrade = tempSpent;
811                 if(feeAmount != 0){
812                     amountSpentFirstTrade += feeAmount;
813                 }
814             }
815             if(tradeIndex == swap.tradeToTakeFeeFrom && !swap.takeFeeFromSource){
816                 feeAmount = takeFee(balances, swap.trades[tradeIndex].destinationToken, partnerContract, amountReceived);
817                 amountReceived -= feeAmount;
818             }
819         }
820         //this.log("About to emit LogSwap", 0, 0x0);
821         emit LogSwap(
822             swapCollectionId,
823             swap.trades[0].sourceToken,
824             swap.trades[swap.trades.length-1].destinationToken,
825             amountSpentFirstTrade,
826             amountReceived,
827             swap.takeFeeFromSource?swap.trades[swap.tradeToTakeFeeFrom].sourceToken:swap.trades[swap.tradeToTakeFeeFrom].destinationToken,
828             feeAmount
829         );
830 
831         if(amountReceived < swap.minimumDestinationAmount){
832             //this.log("Minimum destination amount failed", 0, 0x0);
833             revert("Got less than minimumDestinationAmount");
834         } else if (minimumRateFailed(swap.trades[0].sourceToken, swap.trades[swap.trades.length-1].destinationToken,swap.sourceAmount, amountReceived, swap.minimumExchangeRate)){
835             //this.log("Minimum rate failed", 0, 0x0);
836             revert("Minimum exchange rate not met");
837         }
838         if(swap.redirectAddress != msg.sender && swap.redirectAddress != address(0x0)){
839             //this.log("About to redirect tokens", amountReceived, 0x0);
840             uint256 destinationTokenIndex = findToken(balances,swap.trades[swap.trades.length-1].destinationToken);
841             uint256 amountToSend = Math.min(amountReceived, balances[destinationTokenIndex].balance);
842             transferTokens(balances, destinationTokenIndex, swap.redirectAddress, amountToSend);
843             removeBalance(balances, swap.trades[swap.trades.length-1].destinationToken, amountToSend);
844         }
845     }
846 
847     function performTrade(
848         Trade memory trade, 
849         TokenBalance[20] memory balances,
850         uint256 availableToSpend
851     ) 
852         internal returns (uint256 totalSpent, uint256 totalReceived)
853     {
854         uint256 tempSpent = 0;
855         uint256 tempReceived = 0;
856         for(uint256 orderIndex = 0; orderIndex < trade.orders.length; orderIndex++){
857             if((availableToSpend - totalSpent) * 10000 < availableToSpend){
858                 break;
859             } else if(!trade.isSourceAmount && tempReceived == trade.amount){
860                 break;
861             } else if (trade.isSourceAmount && tempSpent == trade.amount){
862                 break;
863             }
864             //this.log("About to perform order", orderIndex,0x0);
865             (tempSpent, tempReceived) = performOrder(
866                 trade.orders[orderIndex], 
867                 availableToSpend - totalSpent,
868                 trade.isSourceAmount ? availableToSpend - totalSpent : trade.amount - totalReceived, 
869                 trade.isSourceAmount,
870                 trade.sourceToken, 
871                 balances);
872             //this.log("Order performed",0,0x0);
873             totalSpent += tempSpent;
874             totalReceived += tempReceived;
875         }
876         addBalance(balances, trade.destinationToken, totalReceived);
877         removeBalance(balances, trade.sourceToken, totalSpent);
878         //this.log("Trade performed",tempSpent, 0);
879     }
880 
881     function performOrder(
882         Order memory order, 
883         uint256 availableToSpend,
884         uint256 targetAmount,
885         bool isSourceAmount,
886         address tokenToSpend,
887         TokenBalance[20] memory balances
888     )
889         internal returns (uint256 spent, uint256 received)
890     {
891         //this.log("Performing order", availableToSpend, 0x0);
892 
893         if(tokenToSpend == Utils.eth_address()){
894             (spent, received) = ExchangeHandler(order.exchangeHandler).performOrder.value(availableToSpend)(order.encodedPayload, availableToSpend, targetAmount, isSourceAmount);
895 
896         } else {
897             transferTokens(balances, findToken(balances, tokenToSpend), order.exchangeHandler, availableToSpend);
898             (spent, received) = ExchangeHandler(order.exchangeHandler).performOrder(order.encodedPayload, availableToSpend, targetAmount, isSourceAmount);
899         }
900         //this.log("Performing order", spent,0x0);
901         //this.log("Performing order", received,0x0);
902     }
903 
904     function minimumRateFailed(
905         address sourceToken,
906         address destinationToken,
907         uint256 sourceAmount,
908         uint256 destinationAmount,
909         uint256 minimumExchangeRate
910     )
911         internal returns(bool failed)
912     {
913         //this.log("About to get source decimals",sourceAmount,0x0);
914         uint256 sourceDecimals = sourceToken == Utils.eth_address() ? 18 : Utils.getDecimals(sourceToken);
915         //this.log("About to get destination decimals",destinationAmount,0x0);
916         uint256 destinationDecimals = destinationToken == Utils.eth_address() ? 18 : Utils.getDecimals(destinationToken);
917         //this.log("About to calculate amount got",0,0x0);
918         uint256 rateGot = Utils.calcRateFromQty(sourceAmount, destinationAmount, sourceDecimals, destinationDecimals);
919         //this.log("Minimum rate failed", rateGot, 0x0);
920         return rateGot < minimumExchangeRate;
921     }
922 
923     function takeFee(
924         TokenBalance[20] memory balances,
925         address token,
926         address payable partnerContract,
927         uint256 amountTraded
928     )
929         internal
930         returns (uint256 feeAmount)
931     {
932         Partner partner = Partner(partnerContract);
933         uint256 feePercentage = partner.getTotalFeePercentage();
934         //this.log("Got fee percentage", feePercentage, 0x0);
935         feeAmount = calculateFee(amountTraded, feePercentage);
936         //this.log("Taking fee", feeAmount, 0);
937         transferTokens(balances, findToken(balances, token), partnerContract, feeAmount);
938         removeBalance(balances, findToken(balances, token), feeAmount);
939         //this.log("Took fee", 0, 0x0);
940         return feeAmount;
941     }
942 
943     function transferFromSenderDifference(
944         TokenBalance[20] memory balances,
945         address token,
946         uint256 sourceAmount
947     )
948         internal returns (bool)
949     {
950         if(token == Utils.eth_address()){
951             if(sourceAmount>balances[0].balance){
952                 //this.log("Not enough eth", 0,0x0);
953                 return false;
954             }
955             //this.log("Enough eth", 0,0x0);
956             return true;
957         }
958 
959         uint256 tokenIndex = findToken(balances, token);
960         if(sourceAmount>balances[tokenIndex].balance){
961             //this.log("Transferring in token", 0,0x0);
962             bool success;
963             (success,) = address(tokenTransferProxy).call(abi.encodeWithSignature("transferFrom(address,address,address,uint256)", token, msg.sender, address(this), sourceAmount - balances[tokenIndex].balance));
964             if(success){
965                 //this.log("Got enough token", 0,0x0);
966                 balances[tokenIndex].balance = sourceAmount;
967                 return true;
968             }
969             //this.log("Didn't get enough token", 0,0x0);
970             return false;
971         }
972         return true;
973     }
974 
975     function transferAllTokensToUser(
976         TokenBalance[20] memory balances
977     )
978         internal
979     {
980         //this.log("About to transfer all tokens", 0, 0x0);
981         for(uint256 balanceIndex = 0; balanceIndex < balances.length; balanceIndex++){
982             if(balanceIndex != 0 && balances[balanceIndex].tokenAddress == address(0x0)){
983                 return;
984             }
985             //this.log("Transferring tokens", uint256(balances[balanceIndex].balance),0x0);
986             transferTokens(balances, balanceIndex, msg.sender, balances[balanceIndex].balance);
987         }
988     }
989 
990 
991 
992     function transferTokens(
993         TokenBalance[20] memory balances,
994         uint256 tokenIndex,
995         address payable destination,
996         uint256 tokenAmount
997     )
998         internal
999     {
1000         if(tokenAmount > 0){
1001             if(balances[tokenIndex].tokenAddress == Utils.eth_address()){
1002                 destination.transfer(tokenAmount);
1003             } else {
1004                 ERC20SafeTransfer.safeTransfer(balances[tokenIndex].tokenAddress, destination, tokenAmount);
1005             }
1006         }
1007     }
1008 
1009     function findToken(
1010         TokenBalance[20] memory balances,
1011         address token
1012     )
1013         internal pure returns (uint256)
1014     {
1015         for(uint256 index = 0; index < balances.length; index++){
1016             if(balances[index].tokenAddress == token){
1017                 return index;
1018             } else if (index != 0 && balances[index].tokenAddress == address(0x0)){
1019                 balances[index] = TokenBalance(token, 0);
1020                 return index;
1021             }
1022         }
1023     }
1024 
1025     function addBalance(
1026         TokenBalance[20] memory balances,
1027         address tokenAddress,
1028         uint256 amountToAdd
1029     )
1030         internal
1031         pure
1032     {
1033         uint256 tokenIndex = findToken(balances, tokenAddress);
1034         addBalance(balances, tokenIndex, amountToAdd);
1035     }
1036 
1037     function addBalance(
1038         TokenBalance[20] memory balances,
1039         uint256 balanceIndex,
1040         uint256 amountToAdd
1041     )
1042         internal
1043         pure
1044     {
1045        balances[balanceIndex].balance += amountToAdd;
1046     }
1047 
1048     function removeBalance(
1049         TokenBalance[20] memory balances,
1050         address tokenAddress,
1051         uint256 amountToRemove
1052     )
1053         internal
1054         pure
1055     {
1056         uint256 tokenIndex = findToken(balances, tokenAddress);
1057         removeBalance(balances, tokenIndex, amountToRemove);
1058     }
1059 
1060     function removeBalance(
1061         TokenBalance[20] memory balances,
1062         uint256 balanceIndex,
1063         uint256 amountToRemove
1064     )
1065         internal
1066         pure
1067     {
1068         balances[balanceIndex].balance -= amountToRemove;
1069     }
1070 
1071     // @notice Calculates the fee amount given a fee percentage and amount
1072     // @param amount the amount to calculate the fee based on
1073     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1074     function calculateFee(uint256 amount, uint256 fee) internal pure returns (uint256){
1075         return SafeMath.div(SafeMath.mul(amount, fee), 1 ether);
1076     }
1077 
1078     /*
1079     *   Payable fallback function
1080     */
1081 
1082     /// @notice payable fallback to allow handler or exchange contracts to return ether
1083     /// @dev only accounts containing code (ie. contracts) can send ether to contract
1084     function() external payable whenNotPaused {
1085         // Check in here that the sender is a contract! (to stop accidents)
1086         uint256 size;
1087         address sender = msg.sender;
1088         assembly {
1089             size := extcodesize(sender)
1090         }
1091         if (size == 0) {
1092             revert("EOA cannot send ether to primary fallback");
1093         }
1094     }
1095     event Log(string a, uint256 b, bytes32 c);
1096 
1097     function log(string memory a, uint256 b, bytes32 c) public {
1098         emit Log(a,b,c);
1099     }
1100 }