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
210 
211 /*
212 
213   Copyright 2018 ZeroEx Intl.
214 
215   Licensed under the Apache License, Version 2.0 (the "License");
216   you may not use this file except in compliance with the License.
217   You may obtain a copy of the License at
218 
219     http://www.apache.org/licenses/LICENSE-2.0
220 
221   Unless required by applicable law or agreed to in writing, software
222   distributed under the License is distributed on an "AS IS" BASIS,
223   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
224   See the License for the specific language governing permissions and
225   limitations under the License.
226 
227 */
228 
229 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
230 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
231 contract TokenTransferProxy is Ownable {
232 
233     /// @dev Only authorized addresses can invoke functions with this modifier.
234     modifier onlyAuthorized {
235         require(authorized[msg.sender]);
236         _;
237     }
238 
239     modifier targetAuthorized(address target) {
240         require(authorized[target]);
241         _;
242     }
243 
244     modifier targetNotAuthorized(address target) {
245         require(!authorized[target]);
246         _;
247     }
248 
249     mapping (address => bool) public authorized;
250     address[] public authorities;
251 
252     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
253     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
254 
255     /*
256      * Public functions
257      */
258 
259     /// @dev Authorizes an address.
260     /// @param target Address to authorize.
261     function addAuthorizedAddress(address target)
262         public
263         onlyOwner
264         targetNotAuthorized(target)
265     {
266         authorized[target] = true;
267         authorities.push(target);
268         emit LogAuthorizedAddressAdded(target, msg.sender);
269     }
270 
271     /// @dev Removes authorizion of an address.
272     /// @param target Address to remove authorization from.
273     function removeAuthorizedAddress(address target)
274         public
275         onlyOwner
276         targetAuthorized(target)
277     {
278         delete authorized[target];
279         for (uint i = 0; i < authorities.length; i++) {
280             if (authorities[i] == target) {
281                 authorities[i] = authorities[authorities.length - 1];
282                 authorities.length -= 1;
283                 break;
284             }
285         }
286         emit LogAuthorizedAddressRemoved(target, msg.sender);
287     }
288 
289     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
290     /// @param token Address of token to transfer.
291     /// @param from Address to transfer token from.
292     /// @param to Address to transfer token to.
293     /// @param value Amount of token to transfer.
294     /// @return Success of transfer.
295     function transferFrom(
296         address token,
297         address from,
298         address to,
299         uint value)
300         public
301         onlyAuthorized
302         returns (bool)
303     {
304         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
305         return true;
306     }
307 
308     /*
309      * Public view functions
310      */
311 
312     /// @dev Gets all authorized addresses.
313     /// @return Array of authorized addresses.
314     function getAuthorizedAddresses()
315         public
316         view
317         returns (address[] memory)
318     {
319         return authorities;
320     }
321 }
322 
323 /*
324     Modified Util contract as used by Kyber Network
325 */
326 
327 library Utils {
328 
329     uint256 constant internal PRECISION = (10**18);
330     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
331     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
332     uint256 constant internal MAX_DECIMALS = 18;
333     uint256 constant internal ETH_DECIMALS = 18;
334     uint256 constant internal MAX_UINT = 2**256-1;
335     address constant internal ETH_ADDRESS = address(0x0);
336 
337     // Currently constants can't be accessed from other contracts, so providing functions to do that here
338     function precision() internal pure returns (uint256) { return PRECISION; }
339     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
340     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
341     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
342     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
343     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
344     function eth_address() internal pure returns (address) { return ETH_ADDRESS; }
345 
346     /// @notice Retrieve the number of decimals used for a given ERC20 token
347     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
348     /// ensure that an exception doesn't cause transaction failure
349     /// @param token the token for which we should retrieve the decimals
350     /// @return decimals the number of decimals in the given token
351     function getDecimals(address token)
352         internal
353         returns (uint256 decimals)
354     {
355         bytes4 functionSig = bytes4(keccak256("decimals()"));
356 
357         /// @dev Using assembly due to issues with current solidity `address.call()`
358         /// implementation: https://github.com/ethereum/solidity/issues/2884
359         assembly {
360             // Pointer to next free memory slot
361             let ptr := mload(0x40)
362             // Store functionSig variable at ptr
363             mstore(ptr,functionSig)
364             let functionSigLength := 0x04
365             let wordLength := 0x20
366 
367             let success := call(
368                                 gas, // Amount of gas
369                                 token, // Address to call
370                                 0, // ether to send
371                                 ptr, // ptr to input data
372                                 functionSigLength, // size of data
373                                 ptr, // where to store output data (overwrite input)
374                                 wordLength // size of output data (32 bytes)
375                                )
376 
377             switch success
378             case 0 {
379                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
380             }
381             case 1 {
382                 decimals := mload(ptr) // Set decimals to return data from call
383             }
384             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
385         }
386     }
387 
388     /// @dev Checks that a given address has its token allowance and balance set above the given amount
389     /// @param tokenOwner the address which should have custody of the token
390     /// @param tokenAddress the address of the token to check
391     /// @param tokenAmount the amount of the token which should be set
392     /// @param addressToAllow the address which should be allowed to transfer the token
393     /// @return bool true if the allowance and balance is set, false if not
394     function tokenAllowanceAndBalanceSet(
395         address tokenOwner,
396         address tokenAddress,
397         uint256 tokenAmount,
398         address addressToAllow
399     )
400         internal
401         view
402         returns (bool)
403     {
404         return (
405             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
406             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
407         );
408     }
409 
410     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
411         if (dstDecimals >= srcDecimals) {
412             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
413             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
414         } else {
415             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
416             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
417         }
418     }
419 
420     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
421 
422         //source quantity is rounded up. to avoid dest quantity being too low.
423         uint numerator;
424         uint denominator;
425         if (srcDecimals >= dstDecimals) {
426             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
427             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
428             denominator = rate;
429         } else {
430             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
431             numerator = (PRECISION * dstQty);
432             denominator = (rate * (10**(dstDecimals - srcDecimals)));
433         }
434         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
435     }
436 
437     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal returns (uint) {
438         return calcDstQty(srcAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
439     }
440 
441     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal returns (uint) {
442         return calcSrcQty(destAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
443     }
444 
445     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
446         internal pure returns (uint)
447     {
448         require(srcAmount <= MAX_QTY);
449         require(destAmount <= MAX_QTY);
450 
451         if (dstDecimals >= srcDecimals) {
452             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
453             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
454         } else {
455             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
456             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
457         }
458     }
459 
460     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
461     function min(uint256 a, uint256 b) internal pure returns (uint256) {
462         return a < b ? a : b;
463     }
464 }
465 
466 /**
467  * @title SafeMath
468  * @dev Math operations with safety checks that revert on error
469  */
470 library SafeMath {
471 
472   /**
473   * @dev Multiplies two numbers, reverts on overflow.
474   */
475   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
476     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
477     // benefit is lost if 'b' is also tested.
478     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
479     if (_a == 0) {
480       return 0;
481     }
482 
483     uint256 c = _a * _b;
484     require(c / _a == _b);
485 
486     return c;
487   }
488 
489   /**
490   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
491   */
492   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
493     require(_b > 0); // Solidity only automatically asserts when dividing by 0
494     uint256 c = _a / _b;
495     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
496 
497     return c;
498   }
499 
500   /**
501   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
502   */
503   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
504     require(_b <= _a);
505     uint256 c = _a - _b;
506 
507     return c;
508   }
509 
510   /**
511   * @dev Adds two numbers, reverts on overflow.
512   */
513   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
514     uint256 c = _a + _b;
515     require(c >= _a);
516 
517     return c;
518   }
519 
520   /**
521   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
522   * reverts when dividing by zero.
523   */
524   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
525     require(b != 0);
526     return a % b;
527   }
528 }
529 
530 /**
531  * @title Math
532  * @dev Assorted math operations
533  */
534 
535 library Math {
536   function max(uint256 a, uint256 b) internal pure returns (uint256) {
537     return a >= b ? a : b;
538   }
539 
540   function min(uint256 a, uint256 b) internal pure returns (uint256) {
541     return a < b ? a : b;
542   }
543 
544   function average(uint256 a, uint256 b) internal pure returns (uint256) {
545     // (a + b) / 2 can overflow, so we distribute
546     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
547   }
548 }
549 
550 
551 contract PartnerRegistry is Ownable, Pausable {
552 
553     address target;
554     mapping(address => bool) partnerContracts;
555     address payable public companyBeneficiary;
556     uint256 public basePercentage;
557     PartnerRegistry public previousRegistry;
558 
559     event PartnerRegistered(address indexed creator, address indexed beneficiary, address partnerContract);
560 
561     constructor(PartnerRegistry _previousRegistry, address _target, address payable _companyBeneficiary, uint256 _basePercentage) public {
562         previousRegistry = _previousRegistry;
563         target = _target;
564         companyBeneficiary = _companyBeneficiary;
565         basePercentage = _basePercentage;
566     }
567 
568     function registerPartner(address payable partnerBeneficiary, uint256 partnerPercentage) whenNotPaused external {
569         Partner newPartner = Partner(createClone());
570         newPartner.init(this,address(0x0000000000000000000000000000000000000000), 0, partnerBeneficiary, partnerPercentage);
571         partnerContracts[address(newPartner)] = true;
572         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
573     }
574 
575     function overrideRegisterPartner(
576         address payable _companyBeneficiary,
577         uint256 _companyPercentage,
578         address payable partnerBeneficiary,
579         uint256 partnerPercentage
580     ) external onlyOwner {
581         Partner newPartner = Partner(createClone());
582         newPartner.init(PartnerRegistry(0x0000000000000000000000000000000000000000), _companyBeneficiary, _companyPercentage, partnerBeneficiary, partnerPercentage);
583         partnerContracts[address(newPartner)] = true;
584         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
585     }
586 
587     function deletePartner(address _partnerAddress) external onlyOwner {
588         partnerContracts[_partnerAddress] = false;
589     }
590 
591     function createClone() internal returns (address payable result) {
592         bytes20 targetBytes = bytes20(target);
593         assembly {
594             let clone := mload(0x40)
595             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
596             mstore(add(clone, 0x14), targetBytes)
597             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
598             result := create(0, clone, 0x37)
599         }
600     }
601 
602     function isValidPartner(address partnerContract) external view returns(bool) {
603         return partnerContracts[partnerContract] || previousRegistry.isValidPartner(partnerContract);
604     }
605 
606     function updateCompanyInfo(address payable newCompanyBeneficiary, uint256 newBasePercentage) external onlyOwner {
607         companyBeneficiary = newCompanyBeneficiary;
608         basePercentage = newBasePercentage;
609     }
610 }
611 
612 
613 contract Partner {
614 
615     address payable public partnerBeneficiary;
616     uint256 public partnerPercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
617 
618     uint256 public overrideCompanyPercentage;
619     address payable public overrideCompanyBeneficiary;
620 
621     PartnerRegistry public registry;
622 
623     event LogPayout(
624         address[] tokens,
625         uint256[] amount
626     );
627 
628     function init(
629         PartnerRegistry _registry,
630         address payable _overrideCompanyBeneficiary,
631         uint256 _overrideCompanyPercentage,
632         address payable _partnerBeneficiary,
633         uint256 _partnerPercentage
634     ) public {
635         require(registry == PartnerRegistry(0x0000000000000000000000000000000000000000) &&
636           overrideCompanyBeneficiary == address(0x0) && partnerBeneficiary == address(0x0)
637         );
638         overrideCompanyBeneficiary = _overrideCompanyBeneficiary;
639         overrideCompanyPercentage = _overrideCompanyPercentage;
640         partnerBeneficiary = _partnerBeneficiary;
641         partnerPercentage = _partnerPercentage;
642         overrideCompanyPercentage = _overrideCompanyPercentage;
643         registry = _registry;
644     }
645 
646     function payout(
647         address[] memory tokens,
648         uint256[] memory amounts
649     ) public {
650         uint totalFeePercentage = getTotalFeePercentage();
651         address payable companyBeneficiary = companyBeneficiary();
652         // Payout both the partner and the company at the same time
653         for(uint256 index = 0; index<tokens.length; index++){
654             uint256 partnerAmount = SafeMath.div(SafeMath.mul(amounts[index], partnerPercentage), getTotalFeePercentage());
655             uint256 companyAmount = amounts[index] - partnerAmount;
656             if(tokens[index] == Utils.eth_address()){
657                 partnerBeneficiary.transfer(partnerAmount);
658                 companyBeneficiary.transfer(companyAmount);
659             } else {
660                 ERC20SafeTransfer.safeTransfer(tokens[index], partnerBeneficiary, partnerAmount);
661                 ERC20SafeTransfer.safeTransfer(tokens[index], companyBeneficiary, companyAmount);
662             }
663         }
664 	emit LogPayout(tokens,amounts);
665     }
666 
667     function getTotalFeePercentage() public view returns (uint256){
668         return partnerPercentage + companyPercentage();
669     }
670 
671     function companyPercentage() public view returns (uint256){
672         if(registry != PartnerRegistry(0x0000000000000000000000000000000000000000)){
673             return Math.max(registry.basePercentage(), partnerPercentage);
674         } else {
675             return overrideCompanyPercentage;
676         }
677     }
678 
679     function companyBeneficiary() public view returns (address payable) {
680         if(registry != PartnerRegistry(0x0000000000000000000000000000000000000000)){
681             return registry.companyBeneficiary();
682         } else {
683             return overrideCompanyBeneficiary;
684         }    
685     }
686 
687     function() external payable {
688 
689     }
690 }
691 
692 library TokenBalanceLibrary {
693     struct TokenBalance {
694         address tokenAddress;
695         uint256 balance;
696     }
697 
698     function findToken(TokenBalance[20] memory balances, address token)
699         internal
700         pure
701         returns (uint256)
702     {
703         for (uint256 index = 0; index < balances.length; index++) {
704             if (balances[index].tokenAddress == token) {
705                 return index;
706             } else if (
707                 index != 0 && balances[index].tokenAddress == address(0x0)
708             ) {
709                 balances[index] = TokenBalance(token, 0);
710                 return index;
711             }
712         }
713     }
714 
715     function addBalance(
716         TokenBalance[20] memory balances,
717         address tokenAddress,
718         uint256 amountToAdd
719     ) internal pure {
720         uint256 tokenIndex = findToken(balances, tokenAddress);
721         addBalance(balances, tokenIndex, amountToAdd);
722     }
723 
724     function addBalance(
725         TokenBalance[20] memory balances,
726         uint256 balanceIndex,
727         uint256 amountToAdd
728     ) internal pure {
729         balances[balanceIndex].balance += amountToAdd;
730     }
731 
732     function removeBalance(
733         TokenBalance[20] memory balances,
734         address tokenAddress,
735         uint256 amountToRemove
736     ) internal pure {
737         uint256 tokenIndex = findToken(balances, tokenAddress);
738         removeBalance(balances, tokenIndex, amountToRemove);
739     }
740 
741     function removeBalance(
742         TokenBalance[20] memory balances,
743         uint256 balanceIndex,
744         uint256 amountToRemove
745     ) internal pure {
746         balances[balanceIndex].balance -= amountToRemove;
747     }
748 }
749 
750 /// @title Interface for all exchange handler contracts
751 contract ExchangeHandler is Withdrawable, Pausable {
752 
753     /*
754     *   State Variables
755     */
756 
757     /* Logger public logger; */
758     /*
759     *   Modifiers
760     */
761 
762     function performOrder(
763         bytes memory genericPayload,
764         uint256 availableToSpend,
765         uint256 targetAmount,
766         bool targetAmountIsSource
767     )
768         public
769         payable
770         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder);
771 
772 }
773 
774 interface IGST2 {
775     function freeUpTo(uint256) external returns (uint256);
776 }
777 
778 /// @title The primary contract for Totle
779 contract TotlePrimary is Withdrawable, Pausable {
780     /*
781     *   State Variables
782     */
783 
784     IGST2 public constant GAS_TOKEN = IGST2(
785         0x0000000000b3F879cb30FE243b4Dfee438691c04
786     );
787     TokenTransferProxy public tokenTransferProxy;
788     mapping(address => bool) public signers;
789     uint256 public MIN_REFUND_GAS_PRICE = 3000000000;
790     /*
791     *   Types
792     */
793 
794     // Structs
795     struct Order {
796         address payable exchangeHandler;
797         bytes encodedPayload;
798     }
799 
800     struct Trade {
801         address sourceToken;
802         address destinationToken;
803         uint256 amount;
804         bool isSourceAmount; //true if amount is sourceToken, false if it's destinationToken
805         Order[] orders;
806     }
807 
808     struct Swap {
809         Trade[] trades;
810         uint256 minimumExchangeRate;
811         uint256 minimumDestinationAmount;
812         uint256 sourceAmount;
813         uint256 tradeToTakeFeeFrom;
814         bool takeFeeFromSource; //Takes the fee before the trade if true, takes it after if false
815         address payable redirectAddress;
816         bool required;
817     }
818 
819     struct SwapCollection {
820         Swap[] swaps;
821         address payable partnerContract;
822         uint256 expirationBlock;
823         bytes32 id;
824         uint256 maxGasPrice;
825         uint8 v;
826         bytes32 r;
827         bytes32 s;
828     }
829 
830     struct FeeVariables {
831         uint256 feePercentage;
832         Partner partner;
833         uint256 totalFee;
834     }
835 
836     struct AmountsSpentReceived {
837         uint256 spent;
838         uint256 received;
839     }
840     /*
841     *   Events
842     */
843 
844     event LogSwapCollection(
845         bytes32 indexed id,
846         address indexed partnerContract,
847         address indexed user
848     );
849 
850     event LogSwap(
851         bytes32 indexed id,
852         address sourceAsset,
853         address destinationAsset,
854         uint256 sourceAmount,
855         uint256 destinationAmount,
856         address feeAsset,
857         uint256 feeAmount
858     );
859 
860     /// @notice Constructor
861     /// @param _tokenTransferProxy address of the TokenTransferProxy
862     /// @param _signer the suggester's address that signs the payloads. More can be added with add/removeSigner functions
863     constructor(address _tokenTransferProxy, address _signer) public {
864         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
865         signers[_signer] = true;
866     }
867 
868     /*
869     *   Public functions
870     */
871 
872     modifier notExpired(SwapCollection memory swaps) {
873         require(swaps.expirationBlock > block.number, "Expired");
874         _;
875     }
876 
877     modifier validSignature(SwapCollection memory swaps) {
878         bytes32 hash = keccak256(
879             abi.encode(
880                 swaps.swaps,
881                 swaps.partnerContract,
882                 swaps.expirationBlock,
883                 swaps.id,
884                 swaps.maxGasPrice,
885                 msg.sender
886             )
887         );
888         require(
889             signers[ecrecover(
890                 keccak256(
891                     abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
892                 ),
893                 swaps.v,
894                 swaps.r,
895                 swaps.s
896             )],
897             "Invalid signature"
898         );
899         _;
900     }
901 
902     modifier notAboveMaxGas(SwapCollection memory swaps) {
903         require(tx.gasprice <= swaps.maxGasPrice, "Gas price too high");
904         _;
905     }
906 
907     /// @notice Performs the requested set of swaps
908     /// @param swaps The struct that defines the collection of swaps to perform
909     function performSwapCollection(SwapCollection memory swaps)
910         public
911         payable
912         whenNotPaused
913         notExpired(swaps)
914         validSignature(swaps)
915         notAboveMaxGas(swaps)
916     {
917         uint256 startingGas = 0;
918         if (tx.gasprice >= MIN_REFUND_GAS_PRICE) {
919             startingGas = gasleft();
920         }
921         TokenBalanceLibrary.TokenBalance[20] memory balances;
922         balances[0] = TokenBalanceLibrary.TokenBalance(
923             address(Utils.eth_address()),
924             msg.value
925         );
926         for (
927             uint256 swapIndex = 0;
928             swapIndex < swaps.swaps.length;
929             swapIndex++
930         ) {
931             performSwap(
932                 swaps.id,
933                 swaps.swaps[swapIndex],
934                 balances,
935                 swaps.partnerContract
936             );
937         }
938         emit LogSwapCollection(swaps.id, swaps.partnerContract, msg.sender);
939         transferAllTokensToUser(balances);
940         if (startingGas > 0) {
941             refundGas(startingGas);
942         }
943     }
944 
945     function refundGas(uint256 startingGas) internal {
946         uint256 gasRemaining = gasleft();
947         uint256 gasSpent = startingGas - gasRemaining;
948         uint256 tokensToFree = Math.min(
949             (gasSpent + 14154) / 41130,
950             (gasRemaining - 27710) / (1148 + 5722 + 150)
951         );
952         GAS_TOKEN.freeUpTo(tokensToFree);
953     }
954 
955     function addSigner(address newSigner) public onlyOwner {
956         signers[newSigner] = true;
957     }
958 
959     function removeSigner(address signer) public onlyOwner {
960         signers[signer] = false;
961     }
962 
963     function updateMinRefundGasPrice(uint256 newMinRefundGasPrice)
964         external
965         onlyOwner
966     {
967         MIN_REFUND_GAS_PRICE = newMinRefundGasPrice;
968     }
969     /*
970     *   Internal functions
971     */
972 
973     function performSwap(
974         bytes32 swapCollectionId,
975         Swap memory swap,
976         TokenBalanceLibrary.TokenBalance[20] memory balances,
977         address payable partnerContract
978     ) internal {
979         if (
980             !transferFromSenderDifference(
981                 balances,
982                 swap.trades[0].sourceToken,
983                 swap.sourceAmount
984             )
985         ) {
986             if (swap.required) {
987                 revert("Failed to get tokens for swap");
988             } else {
989                 return;
990             }
991         }
992         uint256 amountSpentFirstTrade = 0;
993         uint256 amountReceived = 0;
994         uint256 feeAmount = 0;
995         for (
996             uint256 tradeIndex = 0;
997             tradeIndex < swap.trades.length;
998             tradeIndex++
999         ) {
1000             if (
1001                 tradeIndex == swap.tradeToTakeFeeFrom && swap.takeFeeFromSource
1002             ) {
1003                 feeAmount = takeFee(
1004                     balances,
1005                     swap.trades[tradeIndex].sourceToken,
1006                     partnerContract,
1007                     tradeIndex == 0 ? swap.sourceAmount : amountReceived
1008                 );
1009             }
1010             uint256 tempSpent;
1011             (tempSpent, amountReceived) = performTrade(
1012                 swap.trades[tradeIndex],
1013                 balances,
1014                 Utils.min(
1015                     tradeIndex == 0 ? swap.sourceAmount : amountReceived,
1016                     balances[TokenBalanceLibrary.findToken(
1017                         balances,
1018                         swap.trades[tradeIndex].sourceToken
1019                     )]
1020                         .balance
1021                 )
1022             );
1023             if (
1024                 !swap.trades[tradeIndex].isSourceAmount &&
1025                 amountReceived < swap.trades[tradeIndex].amount
1026             ) {
1027                 if (swap.required) {
1028                     revert("Not enough destination amount");
1029                 }
1030                 return;
1031             }
1032             if (tradeIndex == 0) {
1033                 amountSpentFirstTrade = tempSpent;
1034                 if (feeAmount != 0) {
1035                     amountSpentFirstTrade += feeAmount;
1036                 }
1037             }
1038             if (
1039                 tradeIndex == swap.tradeToTakeFeeFrom && !swap.takeFeeFromSource
1040             ) {
1041                 feeAmount = takeFee(
1042                     balances,
1043                     swap.trades[tradeIndex].destinationToken,
1044                     partnerContract,
1045                     amountReceived
1046                 );
1047                 amountReceived -= feeAmount;
1048             }
1049         }
1050         emit LogSwap(
1051             swapCollectionId,
1052             swap.trades[0].sourceToken,
1053             swap.trades[swap.trades.length - 1].destinationToken,
1054             amountSpentFirstTrade,
1055             amountReceived,
1056             swap.takeFeeFromSource
1057                 ? swap.trades[swap.tradeToTakeFeeFrom].sourceToken
1058                 : swap.trades[swap.tradeToTakeFeeFrom].destinationToken,
1059             feeAmount
1060         );
1061 
1062         if (amountReceived < swap.minimumDestinationAmount) {
1063             revert("Got less than minimumDestinationAmount");
1064         } else if (
1065             minimumRateFailed(
1066                 swap.trades[0].sourceToken,
1067                 swap.trades[swap.trades.length - 1].destinationToken,
1068                 swap.sourceAmount,
1069                 amountReceived,
1070                 swap.minimumExchangeRate
1071             )
1072         ) {
1073             revert("Minimum exchange rate not met");
1074         }
1075         if (
1076             swap.redirectAddress != msg.sender &&
1077             swap.redirectAddress != address(0x0)
1078         ) {
1079             uint256 destinationTokenIndex = TokenBalanceLibrary.findToken(
1080                 balances,
1081                 swap.trades[swap.trades.length - 1].destinationToken
1082             );
1083             uint256 amountToSend = Math.min(
1084                 amountReceived,
1085                 balances[destinationTokenIndex].balance
1086             );
1087             transferTokens(
1088                 balances,
1089                 destinationTokenIndex,
1090                 swap.redirectAddress,
1091                 amountToSend
1092             );
1093             TokenBalanceLibrary.removeBalance(
1094                 balances,
1095                 swap.trades[swap.trades.length - 1].destinationToken,
1096                 amountToSend
1097             );
1098         }
1099     }
1100 
1101     function performTrade(
1102         Trade memory trade,
1103         TokenBalanceLibrary.TokenBalance[20] memory balances,
1104         uint256 availableToSpend
1105     ) internal returns (uint256 totalSpent, uint256 totalReceived) {
1106         uint256 tempSpent = 0;
1107         uint256 tempReceived = 0;
1108         for (
1109             uint256 orderIndex = 0;
1110             orderIndex < trade.orders.length;
1111             orderIndex++
1112         ) {
1113             if ((availableToSpend - totalSpent) * 10000 < availableToSpend) {
1114                 break;
1115             } else if (!trade.isSourceAmount && tempReceived == trade.amount) {
1116                 break;
1117             } else if (trade.isSourceAmount && tempSpent == trade.amount) {
1118                 break;
1119             }
1120             (tempSpent, tempReceived) = performOrder(
1121                 trade.orders[orderIndex],
1122                 availableToSpend - totalSpent,
1123                 trade.isSourceAmount
1124                     ? availableToSpend - totalSpent
1125                     : trade.amount - totalReceived,
1126                 trade.isSourceAmount,
1127                 trade.sourceToken,
1128                 balances
1129             );
1130             totalSpent += tempSpent;
1131             totalReceived += tempReceived;
1132         }
1133         TokenBalanceLibrary.addBalance(
1134             balances,
1135             trade.destinationToken,
1136             totalReceived
1137         );
1138         TokenBalanceLibrary.removeBalance(
1139             balances,
1140             trade.sourceToken,
1141             totalSpent
1142         );
1143     }
1144 
1145     function performOrder(
1146         Order memory order,
1147         uint256 availableToSpend,
1148         uint256 targetAmount,
1149         bool isSourceAmount,
1150         address tokenToSpend,
1151         TokenBalanceLibrary.TokenBalance[20] memory balances
1152     ) internal returns (uint256 spent, uint256 received) {
1153         if (tokenToSpend == Utils.eth_address()) {
1154             (spent, received) = ExchangeHandler(order.exchangeHandler)
1155                 .performOrder
1156                 .value(availableToSpend)(
1157                 order.encodedPayload,
1158                 availableToSpend,
1159                 targetAmount,
1160                 isSourceAmount
1161             );
1162 
1163         } else {
1164             transferTokens(
1165                 balances,
1166                 TokenBalanceLibrary.findToken(balances, tokenToSpend),
1167                 order.exchangeHandler,
1168                 availableToSpend
1169             );
1170             (spent, received) = ExchangeHandler(order.exchangeHandler)
1171                 .performOrder(
1172                 order.encodedPayload,
1173                 availableToSpend,
1174                 targetAmount,
1175                 isSourceAmount
1176             );
1177         }
1178     }
1179 
1180     function minimumRateFailed(
1181         address sourceToken,
1182         address destinationToken,
1183         uint256 sourceAmount,
1184         uint256 destinationAmount,
1185         uint256 minimumExchangeRate
1186     ) internal returns (bool failed) {
1187         uint256 sourceDecimals = sourceToken == Utils.eth_address()
1188             ? 18
1189             : Utils.getDecimals(sourceToken);
1190         uint256 destinationDecimals = destinationToken == Utils.eth_address()
1191             ? 18
1192             : Utils.getDecimals(destinationToken);
1193         uint256 rateGot = Utils.calcRateFromQty(
1194             sourceAmount,
1195             destinationAmount,
1196             sourceDecimals,
1197             destinationDecimals
1198         );
1199         return rateGot < minimumExchangeRate;
1200     }
1201 
1202     function takeFee(
1203         TokenBalanceLibrary.TokenBalance[20] memory balances,
1204         address token,
1205         address payable partnerContract,
1206         uint256 amountTraded
1207     ) internal returns (uint256 feeAmount) {
1208         Partner partner = Partner(partnerContract);
1209         uint256 feePercentage = partner.getTotalFeePercentage();
1210         feeAmount = calculateFee(amountTraded, feePercentage);
1211         transferTokens(
1212             balances,
1213             TokenBalanceLibrary.findToken(balances, token),
1214             partnerContract,
1215             feeAmount
1216         );
1217         TokenBalanceLibrary.removeBalance(
1218             balances,
1219             TokenBalanceLibrary.findToken(balances, token),
1220             feeAmount
1221         );
1222         return feeAmount;
1223     }
1224 
1225     function transferFromSenderDifference(
1226         TokenBalanceLibrary.TokenBalance[20] memory balances,
1227         address token,
1228         uint256 sourceAmount
1229     ) internal returns (bool) {
1230         if (token == Utils.eth_address()) {
1231             if (sourceAmount > balances[0].balance) {
1232                 return false;
1233             }
1234             return true;
1235         }
1236 
1237         uint256 tokenIndex = TokenBalanceLibrary.findToken(balances, token);
1238         if (sourceAmount > balances[tokenIndex].balance) {
1239             bool success;
1240             (success, ) = address(tokenTransferProxy).call(
1241                 abi.encodeWithSignature(
1242                     "transferFrom(address,address,address,uint256)",
1243                     token,
1244                     msg.sender,
1245                     address(this),
1246                     sourceAmount - balances[tokenIndex].balance
1247                 )
1248             );
1249             if (success) {
1250                 balances[tokenIndex].balance = sourceAmount;
1251                 return true;
1252             }
1253             return false;
1254         }
1255         return true;
1256     }
1257 
1258     function transferAllTokensToUser(
1259         TokenBalanceLibrary.TokenBalance[20] memory balances
1260     ) internal {
1261         for (
1262             uint256 balanceIndex = 0;
1263             balanceIndex < balances.length;
1264             balanceIndex++
1265         ) {
1266             if (
1267                 balanceIndex != 0 &&
1268                 balances[balanceIndex].tokenAddress == address(0x0)
1269             ) {
1270                 return;
1271             }
1272             transferTokens(
1273                 balances,
1274                 balanceIndex,
1275                 msg.sender,
1276                 balances[balanceIndex].balance
1277             );
1278         }
1279     }
1280 
1281     function transferTokens(
1282         TokenBalanceLibrary.TokenBalance[20] memory balances,
1283         uint256 tokenIndex,
1284         address payable destination,
1285         uint256 tokenAmount
1286     ) internal {
1287         if (tokenAmount > 0) {
1288             if (balances[tokenIndex].tokenAddress == Utils.eth_address()) {
1289                 destination.transfer(tokenAmount);
1290             } else {
1291                 require(
1292                     ERC20SafeTransfer.safeTransfer(
1293                         balances[tokenIndex].tokenAddress,
1294                         destination,
1295                         tokenAmount
1296                     ),
1297                     "Transfer failed"
1298                 );
1299             }
1300         }
1301     }
1302 
1303     // @notice Calculates the fee amount given a fee percentage and amount
1304     // @param amount the amount to calculate the fee based on
1305     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1306     function calculateFee(uint256 amount, uint256 fee)
1307         internal
1308         pure
1309         returns (uint256)
1310     {
1311         return SafeMath.div(SafeMath.mul(amount, fee), 1 ether);
1312     }
1313 
1314     /*
1315     *   Payable fallback function
1316     */
1317 
1318     /// @notice payable fallback to allow handler or exchange contracts to return ether
1319     /// @dev only accounts containing code (ie. contracts) can send ether to contract
1320     function() external payable whenNotPaused {
1321         // Check in here that the sender is a contract! (to stop accidents)
1322         uint256 size;
1323         address sender = msg.sender;
1324         assembly {
1325             size := extcodesize(sender)
1326         }
1327         if (size == 0) {
1328             revert("EOA cannot send ether to primary fallback");
1329         }
1330     }
1331 }