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
211 // File: contracts/lib/TokenTransferProxy.sol
212 
213 /*
214 
215   Copyright 2018 ZeroEx Intl.
216 
217   Licensed under the Apache License, Version 2.0 (the "License");
218   you may not use this file except in compliance with the License.
219   You may obtain a copy of the License at
220 
221     http://www.apache.org/licenses/LICENSE-2.0
222 
223   Unless required by applicable law or agreed to in writing, software
224   distributed under the License is distributed on an "AS IS" BASIS,
225   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
226   See the License for the specific language governing permissions and
227   limitations under the License.
228 
229 */
230 
231 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
232 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
233 contract TokenTransferProxy is Ownable {
234 
235     /// @dev Only authorized addresses can invoke functions with this modifier.
236     modifier onlyAuthorized {
237         require(authorized[msg.sender]);
238         _;
239     }
240 
241     modifier targetAuthorized(address target) {
242         require(authorized[target]);
243         _;
244     }
245 
246     modifier targetNotAuthorized(address target) {
247         require(!authorized[target]);
248         _;
249     }
250 
251     mapping (address => bool) public authorized;
252     address[] public authorities;
253 
254     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
255     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
256 
257     /*
258      * Public functions
259      */
260 
261     /// @dev Authorizes an address.
262     /// @param target Address to authorize.
263     function addAuthorizedAddress(address target)
264         public
265         onlyOwner
266         targetNotAuthorized(target)
267     {
268         authorized[target] = true;
269         authorities.push(target);
270         emit LogAuthorizedAddressAdded(target, msg.sender);
271     }
272 
273     /// @dev Removes authorizion of an address.
274     /// @param target Address to remove authorization from.
275     function removeAuthorizedAddress(address target)
276         public
277         onlyOwner
278         targetAuthorized(target)
279     {
280         delete authorized[target];
281         for (uint i = 0; i < authorities.length; i++) {
282             if (authorities[i] == target) {
283                 authorities[i] = authorities[authorities.length - 1];
284                 authorities.length -= 1;
285                 break;
286             }
287         }
288         emit LogAuthorizedAddressRemoved(target, msg.sender);
289     }
290 
291     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
292     /// @param token Address of token to transfer.
293     /// @param from Address to transfer token from.
294     /// @param to Address to transfer token to.
295     /// @param value Amount of token to transfer.
296     /// @return Success of transfer.
297     function transferFrom(
298         address token,
299         address from,
300         address to,
301         uint value)
302         public
303         onlyAuthorized
304         returns (bool)
305     {
306         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
307         return true;
308     }
309 
310     /*
311      * Public view functions
312      */
313 
314     /// @dev Gets all authorized addresses.
315     /// @return Array of authorized addresses.
316     function getAuthorizedAddresses()
317         public
318         view
319         returns (address[] memory)
320     {
321         return authorities;
322     }
323 }
324 
325 /*
326     Modified Util contract as used by Kyber Network
327 */
328 
329 library Utils {
330 
331     uint256 constant internal PRECISION = (10**18);
332     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
333     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
334     uint256 constant internal MAX_DECIMALS = 18;
335     uint256 constant internal ETH_DECIMALS = 18;
336     uint256 constant internal MAX_UINT = 2**256-1;
337     address constant internal ETH_ADDRESS = address(0x0);
338 
339     // Currently constants can't be accessed from other contracts, so providing functions to do that here
340     function precision() internal pure returns (uint256) { return PRECISION; }
341     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
342     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
343     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
344     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
345     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
346     function eth_address() internal pure returns (address) { return ETH_ADDRESS; }
347 
348     /// @notice Retrieve the number of decimals used for a given ERC20 token
349     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
350     /// ensure that an exception doesn't cause transaction failure
351     /// @param token the token for which we should retrieve the decimals
352     /// @return decimals the number of decimals in the given token
353     function getDecimals(address token)
354         internal
355         returns (uint256 decimals)
356     {
357         bytes4 functionSig = bytes4(keccak256("decimals()"));
358 
359         /// @dev Using assembly due to issues with current solidity `address.call()`
360         /// implementation: https://github.com/ethereum/solidity/issues/2884
361         assembly {
362             // Pointer to next free memory slot
363             let ptr := mload(0x40)
364             // Store functionSig variable at ptr
365             mstore(ptr,functionSig)
366             let functionSigLength := 0x04
367             let wordLength := 0x20
368 
369             let success := call(
370                                 gas, // Amount of gas
371                                 token, // Address to call
372                                 0, // ether to send
373                                 ptr, // ptr to input data
374                                 functionSigLength, // size of data
375                                 ptr, // where to store output data (overwrite input)
376                                 wordLength // size of output data (32 bytes)
377                                )
378 
379             switch success
380             case 0 {
381                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
382             }
383             case 1 {
384                 decimals := mload(ptr) // Set decimals to return data from call
385             }
386             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
387         }
388     }
389 
390     /// @dev Checks that a given address has its token allowance and balance set above the given amount
391     /// @param tokenOwner the address which should have custody of the token
392     /// @param tokenAddress the address of the token to check
393     /// @param tokenAmount the amount of the token which should be set
394     /// @param addressToAllow the address which should be allowed to transfer the token
395     /// @return bool true if the allowance and balance is set, false if not
396     function tokenAllowanceAndBalanceSet(
397         address tokenOwner,
398         address tokenAddress,
399         uint256 tokenAmount,
400         address addressToAllow
401     )
402         internal
403         view
404         returns (bool)
405     {
406         return (
407             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
408             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
409         );
410     }
411 
412     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
413         if (dstDecimals >= srcDecimals) {
414             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
415             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
416         } else {
417             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
418             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
419         }
420     }
421 
422     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
423 
424         //source quantity is rounded up. to avoid dest quantity being too low.
425         uint numerator;
426         uint denominator;
427         if (srcDecimals >= dstDecimals) {
428             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
429             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
430             denominator = rate;
431         } else {
432             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
433             numerator = (PRECISION * dstQty);
434             denominator = (rate * (10**(dstDecimals - srcDecimals)));
435         }
436         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
437     }
438 
439     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal returns (uint) {
440         return calcDstQty(srcAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
441     }
442 
443     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal returns (uint) {
444         return calcSrcQty(destAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
445     }
446 
447     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
448         internal pure returns (uint)
449     {
450         require(srcAmount <= MAX_QTY);
451         require(destAmount <= MAX_QTY);
452 
453         if (dstDecimals >= srcDecimals) {
454             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
455             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
456         } else {
457             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
458             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
459         }
460     }
461 
462     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
463     function min(uint256 a, uint256 b) internal pure returns (uint256) {
464         return a < b ? a : b;
465     }
466 }
467 
468 /**
469  * @title SafeMath
470  * @dev Math operations with safety checks that revert on error
471  */
472 library SafeMath {
473 
474   /**
475   * @dev Multiplies two numbers, reverts on overflow.
476   */
477   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
478     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
479     // benefit is lost if 'b' is also tested.
480     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
481     if (_a == 0) {
482       return 0;
483     }
484 
485     uint256 c = _a * _b;
486     require(c / _a == _b);
487 
488     return c;
489   }
490 
491   /**
492   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
493   */
494   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
495     require(_b > 0); // Solidity only automatically asserts when dividing by 0
496     uint256 c = _a / _b;
497     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
498 
499     return c;
500   }
501 
502   /**
503   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
504   */
505   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
506     require(_b <= _a);
507     uint256 c = _a - _b;
508 
509     return c;
510   }
511 
512   /**
513   * @dev Adds two numbers, reverts on overflow.
514   */
515   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
516     uint256 c = _a + _b;
517     require(c >= _a);
518 
519     return c;
520   }
521 
522   /**
523   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
524   * reverts when dividing by zero.
525   */
526   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
527     require(b != 0);
528     return a % b;
529   }
530 }
531 
532 /**
533  * @title Math
534  * @dev Assorted math operations
535  */
536 
537 library Math {
538   function max(uint256 a, uint256 b) internal pure returns (uint256) {
539     return a >= b ? a : b;
540   }
541 
542   function min(uint256 a, uint256 b) internal pure returns (uint256) {
543     return a < b ? a : b;
544   }
545 
546   function average(uint256 a, uint256 b) internal pure returns (uint256) {
547     // (a + b) / 2 can overflow, so we distribute
548     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
549   }
550 }
551 
552 contract PartnerRegistry is Ownable, Pausable {
553 
554     address target;
555     mapping(address => bool) partnerContracts;
556     address payable public companyBeneficiary;
557     uint256 public basePercentage;
558     PartnerRegistry public previousRegistry;
559 
560     event PartnerRegistered(address indexed creator, address indexed beneficiary, address partnerContract);
561 
562     constructor(PartnerRegistry _previousRegistry, address _target, address payable _companyBeneficiary, uint256 _basePercentage) public {
563         previousRegistry = _previousRegistry;
564         target = _target;
565         companyBeneficiary = _companyBeneficiary;
566         basePercentage = _basePercentage;
567     }
568 
569     function registerPartner(address payable partnerBeneficiary, uint256 partnerPercentage) whenNotPaused external {
570         Partner newPartner = Partner(createClone());
571         newPartner.init(this,address(0x0000000000000000000000000000000000000000), 0, partnerBeneficiary, partnerPercentage);
572         partnerContracts[address(newPartner)] = true;
573         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
574     }
575 
576     function overrideRegisterPartner(
577         address payable _companyBeneficiary,
578         uint256 _companyPercentage,
579         address payable partnerBeneficiary,
580         uint256 partnerPercentage
581     ) external onlyOwner {
582         Partner newPartner = Partner(createClone());
583         newPartner.init(PartnerRegistry(0x0000000000000000000000000000000000000000), _companyBeneficiary, _companyPercentage, partnerBeneficiary, partnerPercentage);
584         partnerContracts[address(newPartner)] = true;
585         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
586     }
587 
588     function deletePartner(address _partnerAddress) external onlyOwner {
589         partnerContracts[_partnerAddress] = false;
590     }
591 
592     function createClone() internal returns (address payable result) {
593         bytes20 targetBytes = bytes20(target);
594         assembly {
595             let clone := mload(0x40)
596             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
597             mstore(add(clone, 0x14), targetBytes)
598             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
599             result := create(0, clone, 0x37)
600         }
601     }
602 
603     function isValidPartner(address partnerContract) external view returns(bool) {
604         return partnerContracts[partnerContract] || previousRegistry.isValidPartner(partnerContract);
605     }
606 
607     function updateCompanyInfo(address payable newCompanyBeneficiary, uint256 newBasePercentage) external onlyOwner {
608         companyBeneficiary = newCompanyBeneficiary;
609         basePercentage = newBasePercentage;
610     }
611 }
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
750 /* import "../lib/Logger.sol"; */
751 
752 /// @title Interface for all exchange handler contracts
753 contract ExchangeHandler is Withdrawable, Pausable {
754 
755     /*
756     *   State Variables
757     */
758 
759     /* Logger public logger; */
760     /*
761     *   Modifiers
762     */
763 
764     function performOrder(
765         bytes memory genericPayload,
766         uint256 availableToSpend,
767         uint256 targetAmount,
768         bool targetAmountIsSource
769     )
770         public
771         payable
772         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder);
773 
774 }
775 
776 interface IGST2 {
777     function freeUpTo(uint256) external returns (uint256);
778 }
779 
780 
781 /// @title The primary contract for Totle
782 contract TotlePrimary is Withdrawable, Pausable {
783     /*
784      *   State Variables
785      */
786 
787     IGST2 public constant GAS_TOKEN = IGST2(
788         0x0000000000b3F879cb30FE243b4Dfee438691c04
789     );
790     TokenTransferProxy public tokenTransferProxy;
791     mapping(address => bool) public signers;
792     uint256 public MIN_REFUND_GAS_PRICE = 20000000000;
793     /*
794      *   Types
795      */
796 
797     // Structs
798     struct Order {
799         address payable exchangeHandler;
800         bytes encodedPayload;
801         uint256 minSourceAmount;
802         uint256 maxSourceAmount;
803     }
804 
805     struct Trade {
806         address sourceToken;
807         address destinationToken;
808         uint256 amount;
809         bool isSourceAmount; //true if amount is sourceToken, false if it's destinationToken
810         Order[] orders;
811     }
812 
813     struct Swap {
814         Trade[] trades;
815         uint256 minimumExchangeRate;
816         uint256 minimumDestinationAmount;
817         uint256 sourceAmount;
818         uint256 tradeToTakeFeeFrom;
819         bool takeFeeFromSource; //Takes the fee before the trade if true, takes it after if false
820         address payable redirectAddress;
821         bool required;
822     }
823 
824     struct SwapCollection {
825         Swap[] swaps;
826         address payable partnerContract;
827         uint256 expirationBlock;
828         bytes32 id;
829         uint256 maxGasPrice;
830         uint8 v;
831         bytes32 r;
832         bytes32 s;
833     }
834 
835     /*
836      *   Events
837      */
838 
839     event LogSwapCollection(
840         bytes32 indexed id,
841         address indexed partnerContract,
842         address indexed user
843     );
844 
845     event LogSwap(
846         bytes32 indexed id,
847         address sourceAsset,
848         address destinationAsset,
849         uint256 sourceAmount,
850         uint256 destinationAmount,
851         address feeAsset,
852         uint256 feeAmount
853     );
854 
855     /// @notice Constructor
856     /// @param _tokenTransferProxy address of the TokenTransferProxy
857     /// @param _signer the suggester's address that signs the payloads. More can be added with add/removeSigner functions
858     constructor(address _tokenTransferProxy, address _signer) public {
859         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
860         signers[_signer] = true;
861     }
862 
863     /*
864      *   Public functions
865      */
866 
867     modifier notExpired(SwapCollection memory swaps) {
868         require(swaps.expirationBlock > block.number, "Expired");
869         _;
870     }
871 
872     modifier validSignature(SwapCollection memory swaps) {
873         bytes32 hash = keccak256(
874             abi.encode(
875                 swaps.swaps,
876                 swaps.partnerContract,
877                 swaps.expirationBlock,
878                 swaps.id,
879                 swaps.maxGasPrice,
880                 msg.sender
881             )
882         );
883         require(
884             signers[ecrecover(
885                 keccak256(
886                     abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
887                 ),
888                 swaps.v,
889                 swaps.r,
890                 swaps.s
891             )],
892             "Invalid signature"
893         );
894         _;
895     }
896 
897     modifier notAboveMaxGas(SwapCollection memory swaps) {
898         require(tx.gasprice <= swaps.maxGasPrice, "Gas price too high");
899         _;
900     }
901 
902     /// @notice Performs the requested set of swaps
903     /// @param swaps The struct that defines the collection of swaps to perform
904     function performSwapCollection(SwapCollection memory swaps)
905         public
906         payable
907         whenNotPaused
908         notExpired(swaps)
909         validSignature(swaps)
910         notAboveMaxGas(swaps)
911     {
912         uint256 startingGas = 0;
913         if (tx.gasprice >= MIN_REFUND_GAS_PRICE) {
914             startingGas = gasleft();
915         }
916 
917 
918         TokenBalanceLibrary.TokenBalance[20] memory balances;
919         balances[0] = TokenBalanceLibrary.TokenBalance(
920             address(Utils.eth_address()),
921             msg.value
922         );
923         for (
924             uint256 swapIndex = 0;
925             swapIndex < swaps.swaps.length;
926             swapIndex++
927         ) {
928             performSwap(
929                 swaps.id,
930                 swaps.swaps[swapIndex],
931                 balances,
932                 swaps.partnerContract
933             );
934         }
935         emit LogSwapCollection(swaps.id, swaps.partnerContract, msg.sender);
936         transferAllTokensToUser(balances);
937         if (startingGas > 0) {
938             refundGas(startingGas);
939         }
940     }
941 
942     function refundGas(uint256 startingGas) internal {
943         uint256 gasRemaining = gasleft();
944         uint256 gasSpent = startingGas - gasRemaining;
945         uint256 tokensToFree = Math.min(
946             (gasSpent + 14154) / 41130,
947             (gasRemaining - 27710) / (1148 + 5722 + 150)
948         );
949         GAS_TOKEN.freeUpTo(tokensToFree);
950     }
951 
952     function addSigner(address newSigner) public onlyOwner {
953         signers[newSigner] = true;
954     }
955 
956     function removeSigner(address signer) public onlyOwner {
957         signers[signer] = false;
958     }
959 
960     function updateMinRefundGasPrice(uint256 newMinRefundGasPrice)
961         external
962         onlyOwner
963     {
964         MIN_REFUND_GAS_PRICE = newMinRefundGasPrice;
965     }
966 
967     /*
968      *   Internal functions
969      */
970 
971     function performSwap(
972         bytes32 swapCollectionId,
973         Swap memory swap,
974         TokenBalanceLibrary.TokenBalance[20] memory balances,
975         address payable partnerContract
976     ) internal {
977         if (
978             !transferFromSenderDifference(
979                 balances,
980                 swap.trades[0].sourceToken,
981                 swap.sourceAmount
982             )
983         ) {
984             if (swap.required) {
985                 revert("Failed to get tokens for swap");
986             } else {
987                 return;
988             }
989         }
990         uint256 amountSpentFirstTrade = 0;
991         uint256 amountReceived = 0;
992         uint256 feeAmount = 0;
993         for (
994             uint256 tradeIndex = 0;
995             tradeIndex < swap.trades.length;
996             tradeIndex++
997         ) {
998             if (
999                 tradeIndex == swap.tradeToTakeFeeFrom && swap.takeFeeFromSource
1000             ) {
1001                 feeAmount = takeFee(
1002                     balances,
1003                     swap.trades[tradeIndex].sourceToken,
1004                     partnerContract,
1005                     tradeIndex == 0 ? swap.sourceAmount : amountReceived
1006                 );
1007             }
1008             uint256 tempSpent;
1009             (tempSpent, amountReceived) = performTrade(
1010                 swap.trades[tradeIndex],
1011                 balances,
1012                 Utils.min(
1013                     tradeIndex == 0 ? swap.sourceAmount : amountReceived,
1014                     balances[TokenBalanceLibrary.findToken(
1015                         balances,
1016                         swap.trades[tradeIndex].sourceToken
1017                     )]
1018                         .balance
1019                 )
1020             );
1021             if (
1022                 !swap.trades[tradeIndex].isSourceAmount &&
1023                 amountReceived < swap.trades[tradeIndex].amount
1024             ) {
1025                 if (swap.required) {
1026                     revert("Not enough destination amount");
1027                 }
1028                 return;
1029             }
1030             if (tradeIndex == 0) {
1031                 amountSpentFirstTrade = tempSpent;
1032                 if (feeAmount != 0) {
1033                     amountSpentFirstTrade += feeAmount;
1034                 }
1035             }
1036             if (
1037                 tradeIndex == swap.tradeToTakeFeeFrom && !swap.takeFeeFromSource
1038             ) {
1039                 feeAmount = takeFee(
1040                     balances,
1041                     swap.trades[tradeIndex].destinationToken,
1042                     partnerContract,
1043                     amountReceived
1044                 );
1045                 amountReceived -= feeAmount;
1046             }
1047         }
1048         emit LogSwap(
1049             swapCollectionId,
1050             swap.trades[0].sourceToken,
1051             swap.trades[swap.trades.length - 1].destinationToken,
1052             amountSpentFirstTrade,
1053             amountReceived,
1054             swap.takeFeeFromSource
1055                 ? swap.trades[swap.tradeToTakeFeeFrom].sourceToken
1056                 : swap.trades[swap.tradeToTakeFeeFrom].destinationToken,
1057             feeAmount
1058         );
1059 
1060         if (amountReceived < swap.minimumDestinationAmount) {
1061             revert("Got less than minimumDestinationAmount");
1062         } else if (
1063             minimumRateFailed(
1064                 swap.trades[0].sourceToken,
1065                 swap.trades[swap.trades.length - 1].destinationToken,
1066                 swap.sourceAmount,
1067                 amountReceived,
1068                 swap.minimumExchangeRate
1069             )
1070         ) {
1071             revert("Minimum exchange rate not met");
1072         }
1073         if (
1074             swap.redirectAddress != msg.sender &&
1075             swap.redirectAddress != address(0x0)
1076         ) {
1077             uint256 destinationTokenIndex = TokenBalanceLibrary.findToken(
1078                 balances,
1079                 swap.trades[swap.trades.length - 1].destinationToken
1080             );
1081             uint256 amountToSend = Math.min(
1082                 amountReceived,
1083                 balances[destinationTokenIndex].balance
1084             );
1085             transferTokens(
1086                 balances,
1087                 destinationTokenIndex,
1088                 swap.redirectAddress,
1089                 amountToSend
1090             );
1091             TokenBalanceLibrary.removeBalance(
1092                 balances,
1093                 swap.trades[swap.trades.length - 1].destinationToken,
1094                 amountToSend
1095             );
1096         }
1097     }
1098 
1099     function performTrade(
1100         Trade memory trade,
1101         TokenBalanceLibrary.TokenBalance[20] memory balances,
1102         uint256 availableToSpend
1103     ) internal returns (uint256 totalSpent, uint256 totalReceived) {
1104         uint256 tempSpent = 0;
1105         uint256 tempReceived = 0;
1106         uint256 missingSpend = 0; // This is the amount that we expected to have spent, but didn't. Not to be confused with the total amount left to spend
1107         uint256 totalRemainingExcess = getTotalExcess(trade);
1108         for (
1109             uint256 orderIndex = 0;
1110             orderIndex < trade.orders.length;
1111             orderIndex++
1112         ) {
1113             if ((availableToSpend - totalSpent) * 10000 < availableToSpend) {
1114                 break;
1115             } else if (trade.isSourceAmount && tempSpent == trade.amount) {
1116                 break;
1117             }
1118             uint256 targetSpend = getTargetSpend(
1119                 trade.orders[orderIndex].minSourceAmount,
1120                 trade.orders[orderIndex].maxSourceAmount,
1121                 totalRemainingExcess,
1122                 missingSpend);
1123             (tempSpent, tempReceived) = performOrder(
1124                 trade.orders[orderIndex],
1125                 availableToSpend - totalSpent,
1126                 trade.isSourceAmount,
1127                 trade.sourceToken,
1128                 balances
1129             );
1130             totalRemainingExcess -= (trade.orders[orderIndex].maxSourceAmount -
1131                 trade.orders[orderIndex].minSourceAmount);
1132             if (tempSpent < trade.orders[orderIndex].minSourceAmount) {
1133                 missingSpend += (targetSpend - tempSpent);
1134             }
1135             totalSpent += tempSpent;
1136             totalReceived += tempReceived;
1137         }
1138         TokenBalanceLibrary.addBalance(
1139             balances,
1140             trade.destinationToken,
1141             totalReceived
1142         );
1143         TokenBalanceLibrary.removeBalance(
1144             balances,
1145             trade.sourceToken,
1146             totalSpent
1147         );
1148     }
1149 
1150     function performOrder(
1151         Order memory order,
1152         uint256 targetAmount,
1153         bool isSourceAmount,
1154         address tokenToSpend,
1155         TokenBalanceLibrary.TokenBalance[20] memory balances
1156     ) internal returns (uint256 spent, uint256 received) {
1157         if (tokenToSpend == Utils.eth_address()) {
1158             (spent, received) = ExchangeHandler(order.exchangeHandler)
1159                 .performOrder
1160                 .value(targetAmount)(
1161                 order.encodedPayload,
1162                 targetAmount,
1163                 targetAmount,
1164                 isSourceAmount
1165             );
1166         } else {
1167             transferTokens(
1168                 balances,
1169                 TokenBalanceLibrary.findToken(balances, tokenToSpend),
1170                 order.exchangeHandler,
1171                 targetAmount
1172             );
1173             (spent, received) = ExchangeHandler(order.exchangeHandler)
1174                 .performOrder(
1175                 order.encodedPayload,
1176                 targetAmount,
1177                 targetAmount,
1178                 isSourceAmount
1179             );
1180         }
1181     }
1182 
1183     function getTargetSpend(
1184         uint256 minOrderAmount,
1185         uint256 maxOrderAmount,
1186         uint256 totalRemainingExcess,
1187         uint256 missingSpend
1188     ) internal returns (uint256 targetSpend) {
1189         if (missingSpend == 0 || minOrderAmount == maxOrderAmount) {
1190             return minOrderAmount;
1191         } else {
1192             return
1193                 ((maxOrderAmount - minOrderAmount) * missingSpend) /
1194                 totalRemainingExcess;
1195         }
1196     }
1197 
1198     function getTotalExcess(Trade memory trade)
1199         internal
1200         returns (uint256 totalExcess)
1201     {
1202         for (uint8 index = 0; index < trade.orders.length; index++) {
1203             totalExcess +=
1204                 trade.orders[index].maxSourceAmount -
1205                 trade.orders[index].minSourceAmount;
1206         }
1207         return totalExcess;
1208     }
1209 
1210     function minimumRateFailed(
1211         address sourceToken,
1212         address destinationToken,
1213         uint256 sourceAmount,
1214         uint256 destinationAmount,
1215         uint256 minimumExchangeRate
1216     ) internal returns (bool failed) {
1217         uint256 sourceDecimals = sourceToken == Utils.eth_address()
1218             ? 18
1219             : Utils.getDecimals(sourceToken);
1220         uint256 destinationDecimals = destinationToken == Utils.eth_address()
1221             ? 18
1222             : Utils.getDecimals(destinationToken);
1223         uint256 rateGot = Utils.calcRateFromQty(
1224             sourceAmount,
1225             destinationAmount,
1226             sourceDecimals,
1227             destinationDecimals
1228         );
1229         return rateGot < minimumExchangeRate;
1230     }
1231 
1232     function takeFee(
1233         TokenBalanceLibrary.TokenBalance[20] memory balances,
1234         address token,
1235         address payable partnerContract,
1236         uint256 amountTraded
1237     ) internal returns (uint256 feeAmount) {
1238         Partner partner = Partner(partnerContract);
1239         uint256 feePercentage = partner.getTotalFeePercentage();
1240         feeAmount = calculateFee(amountTraded, feePercentage);
1241         transferTokens(
1242             balances,
1243             TokenBalanceLibrary.findToken(balances, token),
1244             partnerContract,
1245             feeAmount
1246         );
1247         TokenBalanceLibrary.removeBalance(
1248             balances,
1249             TokenBalanceLibrary.findToken(balances, token),
1250             feeAmount
1251         );
1252         return feeAmount;
1253     }
1254 
1255     function transferFromSenderDifference(
1256         TokenBalanceLibrary.TokenBalance[20] memory balances,
1257         address token,
1258         uint256 sourceAmount
1259     ) internal returns (bool) {
1260         if (token == Utils.eth_address()) {
1261             if (sourceAmount > balances[0].balance) {
1262                 return false;
1263             }
1264             return true;
1265         }
1266 
1267         uint256 tokenIndex = TokenBalanceLibrary.findToken(balances, token);
1268         if (sourceAmount > balances[tokenIndex].balance) {
1269             bool success;
1270             (success, ) = address(tokenTransferProxy).call(
1271                 abi.encodeWithSignature(
1272                     "transferFrom(address,address,address,uint256)",
1273                     token,
1274                     msg.sender,
1275                     address(this),
1276                     sourceAmount - balances[tokenIndex].balance
1277                 )
1278             );
1279             if (success) {
1280                 balances[tokenIndex].balance = sourceAmount;
1281                 return true;
1282             }
1283             return false;
1284         }
1285         return true;
1286     }
1287 
1288     function transferAllTokensToUser(
1289         TokenBalanceLibrary.TokenBalance[20] memory balances
1290     ) internal {
1291         for (
1292             uint256 balanceIndex = 0;
1293             balanceIndex < balances.length;
1294             balanceIndex++
1295         ) {
1296             if (
1297                 balanceIndex != 0 &&
1298                 balances[balanceIndex].tokenAddress == address(0x0)
1299             ) {
1300                 return;
1301             }
1302             transferTokens(
1303                 balances,
1304                 balanceIndex,
1305                 msg.sender,
1306                 balances[balanceIndex].balance
1307             );
1308         }
1309     }
1310 
1311     function transferTokens(
1312         TokenBalanceLibrary.TokenBalance[20] memory balances,
1313         uint256 tokenIndex,
1314         address payable destination,
1315         uint256 tokenAmount
1316     ) internal {
1317         if (tokenAmount > 0) {
1318             if (balances[tokenIndex].tokenAddress == Utils.eth_address()) {
1319                 destination.transfer(tokenAmount);
1320             } else {
1321                 require(
1322                     ERC20SafeTransfer.safeTransfer(
1323                         balances[tokenIndex].tokenAddress,
1324                         destination,
1325                         tokenAmount
1326                     ),
1327                     "Transfer failed"
1328                 );
1329             }
1330         }
1331     }
1332 
1333     // @notice Calculates the fee amount given a fee percentage and amount
1334     // @param amount the amount to calculate the fee based on
1335     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1336     function calculateFee(uint256 amount, uint256 fee)
1337         internal
1338         pure
1339         returns (uint256)
1340     {
1341         return SafeMath.div(SafeMath.mul(amount, fee), 1 ether);
1342     }
1343 
1344     /*
1345      *   Payable fallback function
1346      */
1347 
1348     /// @notice payable fallback to allow handler or exchange contracts to return ether
1349     /// @dev only accounts containing code (ie. contracts) can send ether to contract
1350     function() external payable whenNotPaused {
1351         // Check in here that the sender is a contract! (to stop accidents)
1352         uint256 size;
1353         address sender = msg.sender;
1354         assembly {
1355             size := extcodesize(sender)
1356         }
1357         if (size == 0) {
1358             revert("EOA cannot send ether to primary fallback");
1359         }
1360     }
1361 }