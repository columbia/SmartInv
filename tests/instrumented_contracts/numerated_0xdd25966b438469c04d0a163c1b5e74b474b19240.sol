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
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 library ERC20SafeTransfer {
67     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
68 
69         require(_tokenAddress.call(bytes4(keccak256("transfer(address,uint256)")), _to, _value));
70 
71         return fetchReturnData();
72     }
73 
74     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
75 
76         require(_tokenAddress.call(bytes4(keccak256("transferFrom(address,address,uint256)")), _from, _to, _value));
77 
78         return fetchReturnData();
79     }
80 
81     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
82 
83         require(_tokenAddress.call(bytes4(keccak256("approve(address,uint256)")), _spender, _value));
84 
85         return fetchReturnData();
86     }
87 
88     function fetchReturnData() internal returns (bool success){
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
161 /*
162   Copyright 2018 ZeroEx Intl.
163 
164   Licensed under the Apache License, Version 2.0 (the "License");
165   you may not use this file except in compliance with the License.
166   You may obtain a copy of the License at
167 
168     http://www.apache.org/licenses/LICENSE-2.0
169 
170   Unless required by applicable law or agreed to in writing, software
171   distributed under the License is distributed on an "AS IS" BASIS,
172   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
173   See the License for the specific language governing permissions and
174   limitations under the License.
175 
176 */
177 
178 
179 
180 
181 
182 /// @title TokenTransferProxy - Transfers tokens on behalf of contracts that have been approved via decentralized governance.
183 /// @author Amir Bandeali - <amir@0xProject.com>, Will Warren - <will@0xProject.com>
184 contract TokenTransferProxy is Ownable {
185 
186     /// @dev Only authorized addresses can invoke functions with this modifier.
187     modifier onlyAuthorized {
188         require(authorized[msg.sender]);
189         _;
190     }
191 
192     modifier targetAuthorized(address target) {
193         require(authorized[target]);
194         _;
195     }
196 
197     modifier targetNotAuthorized(address target) {
198         require(!authorized[target]);
199         _;
200     }
201 
202     mapping (address => bool) public authorized;
203     address[] public authorities;
204 
205     event LogAuthorizedAddressAdded(address indexed target, address indexed caller);
206     event LogAuthorizedAddressRemoved(address indexed target, address indexed caller);
207 
208     /*
209      * Public functions
210      */
211 
212     /// @dev Authorizes an address.
213     /// @param target Address to authorize.
214     function addAuthorizedAddress(address target)
215         public
216         onlyOwner
217         targetNotAuthorized(target)
218     {
219         authorized[target] = true;
220         authorities.push(target);
221         emit LogAuthorizedAddressAdded(target, msg.sender);
222     }
223 
224     /// @dev Removes authorizion of an address.
225     /// @param target Address to remove authorization from.
226     function removeAuthorizedAddress(address target)
227         public
228         onlyOwner
229         targetAuthorized(target)
230     {
231         delete authorized[target];
232         for (uint i = 0; i < authorities.length; i++) {
233             if (authorities[i] == target) {
234                 authorities[i] = authorities[authorities.length - 1];
235                 authorities.length -= 1;
236                 break;
237             }
238         }
239         emit LogAuthorizedAddressRemoved(target, msg.sender);
240     }
241 
242     /// @dev Calls into ERC20 Token contract, invoking transferFrom.
243     /// @param token Address of token to transfer.
244     /// @param from Address to transfer token from.
245     /// @param to Address to transfer token to.
246     /// @param value Amount of token to transfer.
247     /// @return Success of transfer.
248     function transferFrom(
249         address token,
250         address from,
251         address to,
252         uint value)
253         public
254         onlyAuthorized
255         returns (bool)
256     {
257         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
258         return true;
259     }
260 
261     /*
262      * Public constant functions
263      */
264 
265     /// @dev Gets all authorized addresses.
266     /// @return Array of authorized addresses.
267     function getAuthorizedAddresses()
268         public
269         view
270         returns (address[])
271     {
272         return authorities;
273     }
274 }
275 
276 
277 
278 /**
279  * @title Pausable
280  * @dev Base contract which allows children to implement an emergency stop mechanism.
281  */
282 contract Pausable is Ownable {
283   event Paused();
284   event Unpaused();
285 
286   bool private _paused = false;
287 
288   /**
289    * @return true if the contract is paused, false otherwise.
290    */
291   function paused() public view returns (bool) {
292     return _paused;
293   }
294 
295   /**
296    * @dev Modifier to make a function callable only when the contract is not paused.
297    */
298   modifier whenNotPaused() {
299     require(!_paused, "Contract is paused.");
300     _;
301   }
302 
303   /**
304    * @dev Modifier to make a function callable only when the contract is paused.
305    */
306   modifier whenPaused() {
307     require(_paused, "Contract not paused.");
308     _;
309   }
310 
311   /**
312    * @dev called by the owner to pause, triggers stopped state
313    */
314   function pause() public onlyOwner whenNotPaused {
315     _paused = true;
316     emit Paused();
317   }
318 
319   /**
320    * @dev called by the owner to unpause, returns to normal state
321    */
322   function unpause() public onlyOwner whenPaused {
323     _paused = false;
324     emit Unpaused();
325   }
326 }
327 
328 
329 
330 /**
331  * @title SafeMath
332  * @dev Math operations with safety checks that revert on error
333  */
334 library SafeMath {
335 
336   /**
337   * @dev Multiplies two numbers, reverts on overflow.
338   */
339   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
340     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
341     // benefit is lost if 'b' is also tested.
342     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
343     if (_a == 0) {
344       return 0;
345     }
346 
347     uint256 c = _a * _b;
348     require(c / _a == _b);
349 
350     return c;
351   }
352 
353   /**
354   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
355   */
356   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
357     require(_b > 0); // Solidity only automatically asserts when dividing by 0
358     uint256 c = _a / _b;
359     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
360 
361     return c;
362   }
363 
364   /**
365   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
366   */
367   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
368     require(_b <= _a);
369     uint256 c = _a - _b;
370 
371     return c;
372   }
373 
374   /**
375   * @dev Adds two numbers, reverts on overflow.
376   */
377   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
378     uint256 c = _a + _b;
379     require(c >= _a);
380 
381     return c;
382   }
383 
384   /**
385   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
386   * reverts when dividing by zero.
387   */
388   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
389     require(b != 0);
390     return a % b;
391   }
392 }
393 
394 
395 
396 /*
397     Modified Util contract as used by Kyber Network
398 */
399 
400 library Utils {
401 
402     uint256 constant internal PRECISION = (10**18);
403     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
404     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
405     uint256 constant internal MAX_DECIMALS = 18;
406     uint256 constant internal ETH_DECIMALS = 18;
407     uint256 constant internal MAX_UINT = 2**256-1;
408 
409     // Currently constants can't be accessed from other contracts, so providing functions to do that here
410     function precision() internal pure returns (uint256) { return PRECISION; }
411     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
412     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
413     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
414     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
415     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
416 
417     /// @notice Retrieve the number of decimals used for a given ERC20 token
418     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
419     /// ensure that an exception doesn't cause transaction failure
420     /// @param token the token for which we should retrieve the decimals
421     /// @return decimals the number of decimals in the given token
422     function getDecimals(address token)
423         internal
424         view
425         returns (uint256 decimals)
426     {
427         bytes4 functionSig = bytes4(keccak256("decimals()"));
428 
429         /// @dev Using assembly due to issues with current solidity `address.call()`
430         /// implementation: https://github.com/ethereum/solidity/issues/2884
431         assembly {
432             // Pointer to next free memory slot
433             let ptr := mload(0x40)
434             // Store functionSig variable at ptr
435             mstore(ptr,functionSig)
436             let functionSigLength := 0x04
437             let wordLength := 0x20
438 
439             let success := call(
440                                 5000, // Amount of gas
441                                 token, // Address to call
442                                 0, // ether to send
443                                 ptr, // ptr to input data
444                                 functionSigLength, // size of data
445                                 ptr, // where to store output data (overwrite input)
446                                 wordLength // size of output data (32 bytes)
447                                )
448 
449             switch success
450             case 0 {
451                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
452             }
453             case 1 {
454                 decimals := mload(ptr) // Set decimals to return data from call
455             }
456             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
457         }
458     }
459 
460     /// @dev Checks that a given address has its token allowance and balance set above the given amount
461     /// @param tokenOwner the address which should have custody of the token
462     /// @param tokenAddress the address of the token to check
463     /// @param tokenAmount the amount of the token which should be set
464     /// @param addressToAllow the address which should be allowed to transfer the token
465     /// @return bool true if the allowance and balance is set, false if not
466     function tokenAllowanceAndBalanceSet(
467         address tokenOwner,
468         address tokenAddress,
469         uint256 tokenAmount,
470         address addressToAllow
471     )
472         internal
473         view
474         returns (bool)
475     {
476         return (
477             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
478             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
479         );
480     }
481 
482     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
483         if (dstDecimals >= srcDecimals) {
484             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
485             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
486         } else {
487             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
488             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
489         }
490     }
491 
492     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
493 
494         //source quantity is rounded up. to avoid dest quantity being too low.
495         uint numerator;
496         uint denominator;
497         if (srcDecimals >= dstDecimals) {
498             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
499             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
500             denominator = rate;
501         } else {
502             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
503             numerator = (PRECISION * dstQty);
504             denominator = (rate * (10**(dstDecimals - srcDecimals)));
505         }
506         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
507     }
508 
509     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
510         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
511     }
512 
513     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
514         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
515     }
516 
517     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
518         internal pure returns (uint)
519     {
520         require(srcAmount <= MAX_QTY);
521         require(destAmount <= MAX_QTY);
522 
523         if (dstDecimals >= srcDecimals) {
524             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
525             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
526         } else {
527             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
528             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
529         }
530     }
531 
532     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
533     function min(uint256 a, uint256 b) internal pure returns (uint256) {
534         return a < b ? a : b;
535     }
536 }
537 
538 
539 contract ErrorReporter {
540     function revertTx(string reason) public pure {
541         revert(reason);
542     }
543 }
544 
545 
546 
547 contract Affiliate{
548 
549   address public affiliateBeneficiary;
550   uint256 public affiliatePercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
551 
552   uint256 public companyPercentage;
553   address public companyBeneficiary;
554 
555   function init(address _companyBeneficiary, uint256 _companyPercentage, address _affiliateBeneficiary, uint256 _affiliatePercentage) public {
556       require(companyBeneficiary == 0x0 && affiliateBeneficiary == 0x0);
557       companyBeneficiary = _companyBeneficiary;
558       companyPercentage = _companyPercentage;
559       affiliateBeneficiary = _affiliateBeneficiary;
560       affiliatePercentage = _affiliatePercentage;
561   }
562 
563   function payout() public {
564       // Payout both the affiliate and the company at the same time
565       affiliateBeneficiary.transfer(SafeMath.div(SafeMath.mul(address(this).balance, affiliatePercentage), getTotalFeePercentage()));
566       companyBeneficiary.transfer(address(this).balance);
567   }
568 
569   function() public payable {
570 
571   }
572 
573   function getTotalFeePercentage() public view returns (uint256){
574       return affiliatePercentage + companyPercentage;
575   }
576 }
577 
578 
579 
580 
581 contract AffiliateRegistry is Ownable {
582 
583   address target;
584   mapping(address => bool) affiliateContracts;
585   address public companyBeneficiary;
586   uint256 public companyPercentage;
587 
588   event AffiliateRegistered(address affiliateContract);
589 
590 
591   constructor(address _target, address _companyBeneficiary, uint256 _companyPercentage) public {
592      target = _target;
593      companyBeneficiary = _companyBeneficiary;
594      companyPercentage = _companyPercentage;
595   }
596 
597   function registerAffiliate(address affiliateBeneficiary, uint256 affiliatePercentage) external {
598       Affiliate newAffiliate = Affiliate(createClone());
599       newAffiliate.init(companyBeneficiary, companyPercentage, affiliateBeneficiary, affiliatePercentage);
600       affiliateContracts[address(newAffiliate)] = true;
601       emit AffiliateRegistered(address(newAffiliate));
602   }
603 
604   function overrideRegisterAffiliate(address _companyBeneficiary, uint256 _companyPercentage, address affiliateBeneficiary, uint256 affiliatePercentage) external onlyOwner {
605       Affiliate newAffiliate = Affiliate(createClone());
606       newAffiliate.init(_companyBeneficiary, _companyPercentage, affiliateBeneficiary, affiliatePercentage);
607       affiliateContracts[address(newAffiliate)] = true;
608       emit AffiliateRegistered(address(newAffiliate));
609   }
610 
611   function deleteAffiliate(address _affiliateAddress) public onlyOwner {
612       affiliateContracts[_affiliateAddress] = false;
613   }
614 
615   function createClone() internal returns (address result) {
616       bytes20 targetBytes = bytes20(target);
617       assembly {
618           let clone := mload(0x40)
619           mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
620           mstore(add(clone, 0x14), targetBytes)
621           mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
622           result := create(0, clone, 0x37)
623       }
624   }
625 
626   function isValidAffiliate(address affiliateContract) public view returns(bool) {
627       return affiliateContracts[affiliateContract];
628   }
629 
630   function updateCompanyInfo(address newCompanyBeneficiary, uint256 newCompanyPercentage) public onlyOwner {
631       companyBeneficiary = newCompanyBeneficiary;
632       companyPercentage = newCompanyPercentage;
633   }
634 }
635 
636 
637 
638 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
639 /// some functions
640 /// @dev Defines a modifier which should be used when only the totle contract should
641 /// able able to call a function
642 contract TotleControl is Ownable {
643     mapping(address => bool) public authorizedPrimaries;
644 
645     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
646     modifier onlyTotle() {
647         require(authorizedPrimaries[msg.sender]);
648         _;
649     }
650 
651     /// @notice Contract constructor
652     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
653     /// @param _totlePrimary the address of the contract to be set as totlePrimary
654     constructor(address _totlePrimary) public {
655         authorizedPrimaries[_totlePrimary] = true;
656     }
657 
658     /// @notice A function which allows only the owner to change the address of totlePrimary
659     /// @dev onlyOwner modifier only allows the contract owner to run the code
660     /// @param _totlePrimary the address of the contract to be set as totlePrimary
661     function addTotle(
662         address _totlePrimary
663     ) external onlyOwner {
664         authorizedPrimaries[_totlePrimary] = true;
665     }
666 
667     function removeTotle(
668         address _totlePrimary
669     ) external onlyOwner {
670         authorizedPrimaries[_totlePrimary] = false;
671     }
672 }
673 
674 contract SelectorProvider {
675     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
676     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
677     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
678     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
679 
680     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
681 }
682 
683 /// @title Interface for all exchange handler contracts
684 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
685 
686     /*
687     *   State Variables
688     */
689 
690     ErrorReporter public errorReporter;
691     /* Logger public logger; */
692     /*
693     *   Modifiers
694     */
695 
696     /// @notice Constructor
697     /// @dev Calls the constructor of the inherited TotleControl
698     /// @param totlePrimary the address of the totlePrimary contract
699     constructor(
700         address totlePrimary,
701         address _errorReporter
702         /* ,address _logger */
703     )
704         TotleControl(totlePrimary)
705         public
706     {
707         require(_errorReporter != address(0x0));
708         /* require(_logger != address(0x0)); */
709         errorReporter = ErrorReporter(_errorReporter);
710         /* logger = Logger(_logger); */
711     }
712 
713     /// @notice Gets the amount that Totle needs to give for this order
714     /// @param genericPayload the data for this order in a generic format
715     /// @return amountToGive amount taker needs to give in order to fill the order
716     function getAmountToGive(
717         bytes genericPayload
718     )
719         public
720         view
721         returns (uint256 amountToGive)
722     {
723         bool success;
724         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
725 
726         assembly {
727             let functionSelectorLength := 0x04
728             let functionSelectorOffset := 0x1C
729             let scratchSpace := 0x0
730             let wordLength := 0x20
731             let bytesLength := mload(genericPayload)
732             let totalLength := add(functionSelectorLength, bytesLength)
733             let startOfNewData := add(genericPayload, functionSelectorOffset)
734 
735             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
736             let functionSelectorCorrect := mload(scratchSpace)
737             mstore(genericPayload, functionSelectorCorrect)
738 
739             success := delegatecall(
740                             gas,
741                             address, // This address of the current contract
742                             startOfNewData, // Start data at the beginning of the functionSelector
743                             totalLength, // Total length of all data, including functionSelector
744                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
745                             wordLength // Length of return variable is one word
746                            )
747             amountToGive := mload(scratchSpace)
748             if eq(success, 0) { revert(0, 0) }
749         }
750     }
751 
752     /// @notice Perform exchange-specific checks on the given order
753     /// @dev this should be called to check for payload errors
754     /// @param genericPayload the data for this order in a generic format
755     /// @return checksPassed value representing pass or fail
756     function staticExchangeChecks(
757         bytes genericPayload
758     )
759         public
760         view
761         returns (bool checksPassed)
762     {
763         bool success;
764         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
765         assembly {
766             let functionSelectorLength := 0x04
767             let functionSelectorOffset := 0x1C
768             let scratchSpace := 0x0
769             let wordLength := 0x20
770             let bytesLength := mload(genericPayload)
771             let totalLength := add(functionSelectorLength, bytesLength)
772             let startOfNewData := add(genericPayload, functionSelectorOffset)
773 
774             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
775             let functionSelectorCorrect := mload(scratchSpace)
776             mstore(genericPayload, functionSelectorCorrect)
777 
778             success := delegatecall(
779                             gas,
780                             address, // This address of the current contract
781                             startOfNewData, // Start data at the beginning of the functionSelector
782                             totalLength, // Total length of all data, including functionSelector
783                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
784                             wordLength // Length of return variable is one word
785                            )
786             checksPassed := mload(scratchSpace)
787             if eq(success, 0) { revert(0, 0) }
788         }
789     }
790 
791     /// @notice Perform a buy order at the exchange
792     /// @param genericPayload the data for this order in a generic format
793     /// @param  amountToGiveForOrder amount that should be spent on this order
794     /// @return amountSpentOnOrder the amount that would be spent on the order
795     /// @return amountReceivedFromOrder the amount that was received from this order
796     function performBuyOrder(
797         bytes genericPayload,
798         uint256 amountToGiveForOrder
799     )
800         public
801         payable
802         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
803     {
804         bool success;
805         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
806         assembly {
807             let callDataOffset := 0x44
808             let functionSelectorOffset := 0x1C
809             let functionSelectorLength := 0x04
810             let scratchSpace := 0x0
811             let wordLength := 0x20
812             let startOfFreeMemory := mload(0x40)
813 
814             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
815 
816             let bytesLength := mload(startOfFreeMemory)
817             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
818 
819             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
820 
821             let functionSelectorCorrect := mload(scratchSpace)
822 
823             mstore(startOfFreeMemory, functionSelectorCorrect)
824 
825             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
826 
827             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
828 
829             success := delegatecall(
830                             gas,
831                             address, // This address of the current contract
832                             startOfNewData, // Start data at the beginning of the functionSelector
833                             totalLength, // Total length of all data, including functionSelector
834                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
835                             mul(wordLength, 0x02) // Length of return variables is two words
836                           )
837             amountSpentOnOrder := mload(scratchSpace)
838             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
839             if eq(success, 0) { revert(0, 0) }
840         }
841     }
842 
843     /// @notice Perform a sell order at the exchange
844     /// @param genericPayload the data for this order in a generic format
845     /// @param  amountToGiveForOrder amount that should be spent on this order
846     /// @return amountSpentOnOrder the amount that would be spent on the order
847     /// @return amountReceivedFromOrder the amount that was received from this order
848     function performSellOrder(
849         bytes genericPayload,
850         uint256 amountToGiveForOrder
851     )
852         public
853         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
854     {
855         bool success;
856         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
857         assembly {
858             let callDataOffset := 0x44
859             let functionSelectorOffset := 0x1C
860             let functionSelectorLength := 0x04
861             let scratchSpace := 0x0
862             let wordLength := 0x20
863             let startOfFreeMemory := mload(0x40)
864 
865             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
866 
867             let bytesLength := mload(startOfFreeMemory)
868             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
869 
870             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
871 
872             let functionSelectorCorrect := mload(scratchSpace)
873 
874             mstore(startOfFreeMemory, functionSelectorCorrect)
875 
876             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
877 
878             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
879 
880             success := delegatecall(
881                             gas,
882                             address, // This address of the current contract
883                             startOfNewData, // Start data at the beginning of the functionSelector
884                             totalLength, // Total length of all data, including functionSelector
885                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
886                             mul(wordLength, 0x02) // Length of return variables is two words
887                           )
888             amountSpentOnOrder := mload(scratchSpace)
889             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
890             if eq(success, 0) { revert(0, 0) }
891         }
892     }
893 }
894 
895 /// @title The primary contract for Totle
896 contract TotlePrimary is Withdrawable, Pausable {
897 
898     /*
899     *   State Variables
900     */
901 
902     mapping(address => bool) public handlerWhitelistMap;
903     address[] public handlerWhitelistArray;
904     AffiliateRegistry affiliateRegistry;
905     address public defaultFeeAccount;
906 
907     TokenTransferProxy public tokenTransferProxy;
908     ErrorReporter public errorReporter;
909     /* Logger public logger; */
910 
911     /*
912     *   Types
913     */
914 
915     // Structs
916     struct Trade {
917         bool isSell;
918         address tokenAddress;
919         uint256 tokenAmount;
920         bool optionalTrade;
921         uint256 minimumExchangeRate;
922         uint256 minimumAcceptableTokenAmount;
923         Order[] orders;
924     }
925 
926     struct Order {
927         address exchangeHandler;
928         bytes genericPayload;
929     }
930 
931     struct TradeFlag {
932         bool ignoreTrade;
933         bool[] ignoreOrder;
934     }
935 
936     struct CurrentAmounts {
937         uint256 amountSpentOnTrade;
938         uint256 amountReceivedFromTrade;
939         uint256 amountLeftToSpendOnTrade;
940     }
941 
942     /*
943     *   Events
944     */
945 
946     event LogRebalance(
947         bytes32 id
948     );
949 
950     /*
951     *   Modifiers
952     */
953 
954     modifier handlerWhitelisted(address handler) {
955         if (!handlerWhitelistMap[handler]) {
956             errorReporter.revertTx("Handler not in whitelist");
957         }
958         _;
959     }
960 
961     modifier handlerNotWhitelisted(address handler) {
962         if (handlerWhitelistMap[handler]) {
963             errorReporter.revertTx("Handler already whitelisted");
964         }
965         _;
966     }
967 
968     /// @notice Constructor
969     /// @param _tokenTransferProxy address of the TokenTransferProxy
970     /// @param _errorReporter the address of the error reporter contract
971     constructor (address _tokenTransferProxy, address _affiliateRegistry, address _errorReporter, address _defaultFeeAccount/*, address _logger*/) public {
972         /* require(_logger != address(0x0)); */
973         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
974         affiliateRegistry = AffiliateRegistry(_affiliateRegistry);
975         errorReporter = ErrorReporter(_errorReporter);
976         defaultFeeAccount = _defaultFeeAccount;
977         /* logger = Logger(_logger); */
978     }
979 
980     /*
981     *   Public functions
982     */
983 
984     /// @notice Update the default fee account
985     /// @dev onlyOwner modifier only allows the contract owner to run the code
986     /// @param newDefaultFeeAccount new default fee account
987     function updateDefaultFeeAccount(address newDefaultFeeAccount) public onlyOwner {
988         defaultFeeAccount = newDefaultFeeAccount;
989     }
990 
991     /// @notice Add an exchangeHandler address to the whitelist
992     /// @dev onlyOwner modifier only allows the contract owner to run the code
993     /// @param handler Address of the exchange handler which permission needs adding
994     function addHandlerToWhitelist(address handler)
995         public
996         onlyOwner
997         handlerNotWhitelisted(handler)
998     {
999         handlerWhitelistMap[handler] = true;
1000         handlerWhitelistArray.push(handler);
1001     }
1002 
1003     /// @notice Remove an exchangeHandler address from the whitelist
1004     /// @dev onlyOwner modifier only allows the contract owner to run the code
1005     /// @param handler Address of the exchange handler which permission needs removing
1006     function removeHandlerFromWhitelist(address handler)
1007         public
1008         onlyOwner
1009         handlerWhitelisted(handler)
1010     {
1011         delete handlerWhitelistMap[handler];
1012         for (uint i = 0; i < handlerWhitelistArray.length; i++) {
1013             if (handlerWhitelistArray[i] == handler) {
1014                 handlerWhitelistArray[i] = handlerWhitelistArray[handlerWhitelistArray.length - 1];
1015                 handlerWhitelistArray.length -= 1;
1016                 break;
1017             }
1018         }
1019     }
1020 
1021     /// @notice Performs the requested portfolio rebalance
1022     /// @param trades A dynamic array of trade structs
1023     function performRebalance(
1024         Trade[] memory trades,
1025         address feeAccount,
1026         bytes32 id
1027     )
1028         public
1029         payable
1030         whenNotPaused
1031     {
1032         if(!affiliateRegistry.isValidAffiliate(feeAccount)){
1033             feeAccount = defaultFeeAccount;
1034         }
1035         Affiliate affiliate = Affiliate(feeAccount);
1036         uint256 feePercentage = affiliate.getTotalFeePercentage();
1037 
1038         emit LogRebalance(id);
1039         /* logger.log("Starting Rebalance..."); */
1040 
1041         TradeFlag[] memory tradeFlags = initialiseTradeFlags(trades);
1042 
1043         staticChecks(trades, tradeFlags);
1044 
1045         /* logger.log("Static checks passed."); */
1046 
1047         transferTokens(trades, tradeFlags);
1048 
1049         /* logger.log("Tokens transferred."); */
1050 
1051         uint256 etherBalance = msg.value;
1052         uint256 totalFee = 0;
1053         /* logger.log("Ether balance arg2: etherBalance.", etherBalance); */
1054 
1055         for (uint256 i; i < trades.length; i++) {
1056             Trade memory thisTrade = trades[i];
1057             TradeFlag memory thisTradeFlag = tradeFlags[i];
1058 
1059             CurrentAmounts memory amounts = CurrentAmounts({
1060                 amountSpentOnTrade: 0,
1061                 amountReceivedFromTrade: 0,
1062                 amountLeftToSpendOnTrade: thisTrade.isSell ? thisTrade.tokenAmount : calculateMaxEtherSpend(thisTrade, etherBalance, feePercentage)
1063             });
1064             /* logger.log("Going to perform trade. arg2: amountLeftToSpendOnTrade", amounts.amountLeftToSpendOnTrade); */
1065 
1066             performTrade(
1067                 thisTrade,
1068                 thisTradeFlag,
1069                 amounts
1070             );
1071             uint256 ethTraded;
1072             uint256 ethFee;
1073             if(thisTrade.isSell){
1074                 ethTraded = amounts.amountReceivedFromTrade;
1075             } else {
1076                 ethTraded = amounts.amountSpentOnTrade;
1077             }
1078             ethFee = calculateFee(ethTraded, feePercentage);
1079             totalFee = SafeMath.add(totalFee, ethFee);
1080             /* logger.log("Finished performing trade arg2: amountReceivedFromTrade, arg3: amountSpentOnTrade.", amounts.amountReceivedFromTrade, amounts.amountSpentOnTrade); */
1081 
1082             if (amounts.amountReceivedFromTrade == 0 && thisTrade.optionalTrade) {
1083                 /* logger.log("Received 0 from trade and this is an optional trade. Skipping."); */
1084                 continue;
1085             }
1086 
1087             /* logger.log(
1088                 "Going to check trade acceptable amounts arg2: amountSpentOnTrade, arg2: amountReceivedFromTrade.",
1089                 amounts.amountSpentOnTrade,
1090                 amounts.amountReceivedFromTrade
1091             ); */
1092 
1093             if (!checkIfTradeAmountsAcceptable(thisTrade, amounts.amountSpentOnTrade, amounts.amountReceivedFromTrade)) {
1094                 errorReporter.revertTx("Amounts spent/received in trade not acceptable");
1095             }
1096 
1097             /* logger.log("Trade passed the acceptable amounts check."); */
1098 
1099             if (thisTrade.isSell) {
1100                 /* logger.log(
1101                     "This is a sell trade, adding ether to our balance arg2: etherBalance, arg3: amountReceivedFromTrade",
1102                     etherBalance,
1103                     amounts.amountReceivedFromTrade
1104                 ); */
1105                 etherBalance = SafeMath.sub(SafeMath.add(etherBalance, ethTraded), ethFee);
1106             } else {
1107                 /* logger.log(
1108                     "This is a buy trade, deducting ether from our balance arg2: etherBalance, arg3: amountSpentOnTrade",
1109                     etherBalance,
1110                     amounts.amountSpentOnTrade
1111                 ); */
1112                 etherBalance = SafeMath.sub(SafeMath.sub(etherBalance, ethTraded), ethFee);
1113             }
1114 
1115             /* logger.log("Transferring tokens to the user arg:6 tokenAddress.", 0,0,0,0, thisTrade.tokenAddress); */
1116 
1117             transferTokensToUser(
1118                 thisTrade.tokenAddress,
1119                 thisTrade.isSell ? amounts.amountLeftToSpendOnTrade : amounts.amountReceivedFromTrade
1120             );
1121 
1122         }
1123         if(totalFee > 0){
1124             feeAccount.transfer(totalFee);
1125         }
1126         if(etherBalance > 0) {
1127             /* logger.log("Got a positive ether balance, sending to the user arg2: etherBalance.", etherBalance); */
1128             msg.sender.transfer(etherBalance);
1129         }
1130     }
1131 
1132     /// @notice Performs static checks on the rebalance payload before execution
1133     /// @dev This function is public so a rebalance can be checked before performing a rebalance
1134     /// @param trades A dynamic array of trade structs
1135     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1136     function staticChecks(
1137         Trade[] trades,
1138         TradeFlag[] tradeFlags
1139     )
1140         public
1141         view
1142         whenNotPaused
1143     {
1144         bool previousBuyOccured = false;
1145 
1146         for (uint256 i; i < trades.length; i++) {
1147             Trade memory thisTrade = trades[i];
1148             if (thisTrade.isSell) {
1149                 if (previousBuyOccured) {
1150                     errorReporter.revertTx("A buy has occured before this sell");
1151                 }
1152 
1153                 if (!Utils.tokenAllowanceAndBalanceSet(msg.sender, thisTrade.tokenAddress, thisTrade.tokenAmount, address(tokenTransferProxy))) {
1154                     if (!thisTrade.optionalTrade) {
1155                         errorReporter.revertTx("Taker has not sent allowance/balance on a non-optional trade");
1156                     }
1157                     /* logger.log(
1158                         "Attempt to sell a token without allowance or sufficient balance arg2: tokenAmount, arg6: tokenAddress . Otional trade, ignoring.",
1159                         thisTrade.tokenAmount,
1160                         0,
1161                         0,
1162                         0,
1163                         thisTrade.tokenAddress
1164                     ); */
1165                     tradeFlags[i].ignoreTrade = true;
1166                     continue;
1167                 }
1168             } else {
1169                 previousBuyOccured = true;
1170             }
1171 
1172             /* logger.log("Checking that all the handlers are whitelisted."); */
1173             for (uint256 j; j < thisTrade.orders.length; j++) {
1174                 Order memory thisOrder = thisTrade.orders[j];
1175                 if ( !handlerWhitelistMap[thisOrder.exchangeHandler] ) {
1176                     /* logger.log(
1177                         "Trying to use a handler that is not whitelisted arg6: exchangeHandler.",
1178                         0,
1179                         0,
1180                         0,
1181                         0,
1182                         thisOrder.exchangeHandler
1183                     ); */
1184                     tradeFlags[i].ignoreOrder[j] = true;
1185                     continue;
1186                 }
1187             }
1188         }
1189     }
1190 
1191     /*
1192     *   Internal functions
1193     */
1194 
1195     /// @notice Initialises the trade flag struct
1196     /// @param trades the trades used to initialise the flags
1197     /// @return tradeFlags the initialised flags
1198     function initialiseTradeFlags(Trade[] trades)
1199         internal
1200         returns (TradeFlag[])
1201     {
1202         /* logger.log("Initializing trade flags."); */
1203         TradeFlag[] memory tradeFlags = new TradeFlag[](trades.length);
1204         for (uint256 i = 0; i < trades.length; i++) {
1205             tradeFlags[i].ignoreOrder = new bool[](trades[i].orders.length);
1206         }
1207         return tradeFlags;
1208     }
1209 
1210     /// @notice Transfers the given amount of tokens back to the msg.sender
1211     /// @param tokenAddress the address of the token to transfer
1212     /// @param tokenAmount the amount of tokens to transfer
1213     function transferTokensToUser(
1214         address tokenAddress,
1215         uint256 tokenAmount
1216     )
1217         internal
1218     {
1219         /* logger.log("Transfering tokens to the user arg2: tokenAmount, arg6: .tokenAddress", tokenAmount, 0, 0, 0, tokenAddress); */
1220         if (tokenAmount > 0) {
1221             if (!ERC20SafeTransfer.safeTransfer(tokenAddress, msg.sender, tokenAmount)) {
1222                 errorReporter.revertTx("Unable to transfer tokens to user");
1223             }
1224         }
1225     }
1226 
1227     /// @notice Executes the given trade
1228     /// @param trade a struct containing information about the trade
1229     /// @param tradeFlag a struct containing trade status information
1230     /// @param amounts a struct containing information about amounts spent
1231     /// and received in the rebalance
1232     function performTrade(
1233         Trade memory trade,
1234         TradeFlag memory tradeFlag,
1235         CurrentAmounts amounts
1236     )
1237         internal
1238     {
1239         /* logger.log("Performing trade"); */
1240 
1241         for (uint256 j; j < trade.orders.length; j++) {
1242 
1243             if(amounts.amountLeftToSpendOnTrade * 10000 < (amounts.amountSpentOnTrade + amounts.amountLeftToSpendOnTrade)){
1244                 return;
1245             }
1246 
1247             if((trade.isSell ? amounts.amountSpentOnTrade : amounts.amountReceivedFromTrade) >= trade.tokenAmount ) {
1248                 return;
1249             }
1250 
1251             if (tradeFlag.ignoreOrder[j] || amounts.amountLeftToSpendOnTrade == 0) {
1252                 /* logger.log(
1253                     "Order ignore flag is set to true or have nothing left to spend arg2: amountLeftToSpendOnTrade",
1254                     amounts.amountLeftToSpendOnTrade
1255                 ); */
1256                 continue;
1257             }
1258 
1259             uint256 amountSpentOnOrder = 0;
1260             uint256 amountReceivedFromOrder = 0;
1261 
1262             Order memory thisOrder = trade.orders[j];
1263 
1264             /* logger.log("Setting order exchange handler arg6: exchangeHandler.", 0, 0, 0, 0, thisOrder.exchangeHandler); */
1265             ExchangeHandler thisHandler = ExchangeHandler(thisOrder.exchangeHandler);
1266 
1267             uint256 amountToGiveForOrder = Utils.min(
1268                 thisHandler.getAmountToGive(thisOrder.genericPayload),
1269                 amounts.amountLeftToSpendOnTrade
1270             );
1271 
1272             if (amountToGiveForOrder == 0) {
1273                 /* logger.log(
1274                     "MASSIVE ERROR: amountToGiveForOrder was found to be 0, this hasn't been caught in preTradeChecks, which means dynamicExchangeChecks isnt written correctly!"
1275                 ); */
1276                 continue;
1277             }
1278 
1279             /* logger.log(
1280                 "Calculating amountToGiveForOrder arg2: amountToGiveForOrder, arg3: amountLeftToSpendOnTrade.",
1281                 amountToGiveForOrder,
1282                 amounts.amountLeftToSpendOnTrade
1283             ); */
1284 
1285             if( !thisHandler.staticExchangeChecks(thisOrder.genericPayload) ) {
1286                 /* logger.log("Order did not pass checks, skipping."); */
1287                 continue;
1288             }
1289 
1290             if (trade.isSell) {
1291                 /* logger.log("This is a sell.."); */
1292                 if (!ERC20SafeTransfer.safeTransfer(trade.tokenAddress,address(thisHandler), amountToGiveForOrder)) {
1293                     if( !trade.optionalTrade ) errorReporter.revertTx("Unable to transfer tokens to handler");
1294                     else {
1295                         /* logger.log("Unable to transfer tokens to handler but the trade is optional"); */
1296                         return;
1297                     }
1298                 }
1299 
1300                 /* logger.log("Going to perform a sell order."); */
1301                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performSellOrder(thisOrder.genericPayload, amountToGiveForOrder);
1302                 /* logger.log("Sell order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1303             } else {
1304                 /* logger.log("Going to perform a buy order."); */
1305                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performBuyOrder.value(amountToGiveForOrder)(thisOrder.genericPayload, amountToGiveForOrder);
1306                 /* logger.log("Buy order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1307             }
1308 
1309 
1310             if (amountReceivedFromOrder > 0) {
1311                 amounts.amountLeftToSpendOnTrade = SafeMath.sub(amounts.amountLeftToSpendOnTrade, amountSpentOnOrder);
1312                 amounts.amountSpentOnTrade = SafeMath.add(amounts.amountSpentOnTrade, amountSpentOnOrder);
1313                 amounts.amountReceivedFromTrade = SafeMath.add(amounts.amountReceivedFromTrade, amountReceivedFromOrder);
1314 
1315                 /* logger.log(
1316                     "Updated amounts arg2: amountLeftToSpendOnTrade, arg3: amountSpentOnTrade, arg4: amountReceivedFromTrade.",
1317                     amounts.amountLeftToSpendOnTrade,
1318                     amounts.amountSpentOnTrade,
1319                     amounts.amountReceivedFromTrade
1320                 ); */
1321             }
1322         }
1323 
1324     }
1325 
1326     /// @notice Check if the amounts spent and gained on a trade are within the
1327     /// user"s set limits
1328     /// @param trade contains information on the given trade
1329     /// @param amountSpentOnTrade the amount that was spent on the trade
1330     /// @param amountReceivedFromTrade the amount that was received from the trade
1331     /// @return bool whether the trade passes the checks
1332     function checkIfTradeAmountsAcceptable(
1333         Trade trade,
1334         uint256 amountSpentOnTrade,
1335         uint256 amountReceivedFromTrade
1336     )
1337         internal
1338         view
1339         returns (bool passed)
1340     {
1341         /* logger.log("Checking if trade amounts are acceptable."); */
1342         uint256 tokenAmount = trade.isSell ? amountSpentOnTrade : amountReceivedFromTrade;
1343         passed = tokenAmount >= trade.minimumAcceptableTokenAmount;
1344 
1345         /*if( !passed ) {
1346              logger.log(
1347                 "Received less than minimum acceptable tokens arg2: tokenAmount , arg3: minimumAcceptableTokenAmount.",
1348                 tokenAmount,
1349                 trade.minimumAcceptableTokenAmount
1350             );
1351         }*/
1352 
1353         if (passed) {
1354             uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1355             uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1356             uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1357             uint256 actualRate = Utils.calcRateFromQty(amountSpentOnTrade, amountReceivedFromTrade, srcDecimals, destDecimals);
1358             passed = actualRate >= trade.minimumExchangeRate;
1359         }
1360 
1361         /*if( !passed ) {
1362              logger.log(
1363                 "Order rate was lower than minimum acceptable,  rate arg2: actualRate, arg3: minimumExchangeRate.",
1364                 actualRate,
1365                 trade.minimumExchangeRate
1366             );
1367         }*/
1368     }
1369 
1370     /// @notice Iterates through a list of token orders, transfer the SELL orders to this contract & calculates if we have the ether needed
1371     /// @param trades A dynamic array of trade structs
1372     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1373     function transferTokens(Trade[] trades, TradeFlag[] tradeFlags) internal {
1374         for (uint256 i = 0; i < trades.length; i++) {
1375             if (trades[i].isSell && !tradeFlags[i].ignoreTrade) {
1376 
1377                 /* logger.log(
1378                     "Transfering tokens arg2: tokenAmount, arg5: tokenAddress.",
1379                     trades[i].tokenAmount,
1380                     0,
1381                     0,
1382                     0,
1383                     trades[i].tokenAddress
1384                 ); */
1385                 if (
1386                     !tokenTransferProxy.transferFrom(
1387                         trades[i].tokenAddress,
1388                         msg.sender,
1389                         address(this),
1390                         trades[i].tokenAmount
1391                     )
1392                 ) {
1393                     errorReporter.revertTx("TTP unable to transfer tokens to primary");
1394                 }
1395            }
1396         }
1397     }
1398 
1399     /// @notice Calculates the maximum amount that should be spent on a given buy trade
1400     /// @param trade the buy trade to return the spend amount for
1401     /// @param etherBalance the amount of ether that we currently have to spend
1402     /// @return uint256 the maximum amount of ether we should spend on this trade
1403     function calculateMaxEtherSpend(Trade trade, uint256 etherBalance, uint256 feePercentage) internal view returns (uint256) {
1404         /// @dev This function should never be called for a sell
1405         assert(!trade.isSell);
1406 
1407         uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1408         uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1409         uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1410         uint256 maxSpendAtMinRate = Utils.calcSrcQty(trade.tokenAmount, srcDecimals, destDecimals, trade.minimumExchangeRate);
1411 
1412         return Utils.min(removeFee(etherBalance, feePercentage), maxSpendAtMinRate);
1413     }
1414 
1415     // @notice Calculates the fee amount given a fee percentage and amount
1416     // @param amount the amount to calculate the fee based on
1417     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1418     function calculateFee(uint256 amount, uint256 fee) internal view returns (uint256){
1419         return SafeMath.div(SafeMath.mul(amount, fee), 1 ether);
1420     }
1421 
1422     // @notice Calculates the cost if amount=cost+fee
1423     // @param amount the amount to calculate the base on
1424     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1425     function removeFee(uint256 amount, uint256 fee) internal view returns (uint256){
1426         return SafeMath.div(SafeMath.mul(amount, 1 ether), SafeMath.add(fee, 1 ether));
1427     }
1428     /*
1429     *   Payable fallback function
1430     */
1431 
1432     /// @notice payable fallback to allow handler or exchange contracts to return ether
1433     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
1434     function() public payable whenNotPaused {
1435         // Check in here that the sender is a contract! (to stop accidents)
1436         uint256 size;
1437         address sender = msg.sender;
1438         assembly {
1439             size := extcodesize(sender)
1440         }
1441         if (size == 0) {
1442             errorReporter.revertTx("EOA cannot send ether to primary fallback");
1443         }
1444     }
1445 }
1446 
1447 
1448 
1449 /// @title A contract which is used to check and set allowances of tokens
1450 /// @dev In order to use this contract is must be inherited in the contract which is using
1451 /// its functionality
1452 contract AllowanceSetter {
1453     uint256 constant MAX_UINT = 2**256 - 1;
1454 
1455     /// @notice A function which allows the caller to approve the max amount of any given token
1456     /// @dev In order to function correctly, token allowances should not be set anywhere else in
1457     /// the inheriting contract
1458     /// @param addressToApprove the address which we want to approve to transfer the token
1459     /// @param token the token address which we want to call approve on
1460     function approveAddress(address addressToApprove, address token) internal {
1461         if(ERC20(token).allowance(address(this), addressToApprove) == 0) {
1462             require(ERC20SafeTransfer.safeApprove(token, addressToApprove, MAX_UINT));
1463         }
1464     }
1465 
1466 }
1467 
1468 contract TotleProxyPrimary is Ownable, AllowanceSetter {
1469 
1470     TokenTransferProxy public tokenTransferProxy;
1471     TotlePrimary public totlePrimary;
1472 
1473     constructor(address _tokenTransferProxy, address _totlePrimary) public {
1474         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
1475         totlePrimary = TotlePrimary(_totlePrimary);
1476     }
1477 
1478     function performRebalance(
1479         TotlePrimary.Trade[] memory trades,
1480         address feeAccount,
1481         bytes32 id,
1482         address paymentReceiver,
1483         bool redirectEth,
1484         address[] redirectTokens
1485     )
1486         public
1487         payable
1488     {
1489           transferTokensIn(trades);
1490           totlePrimary.performRebalance.value(msg.value)(trades, feeAccount, id);
1491           transferTokensOut(trades, paymentReceiver, redirectTokens);
1492           if(redirectEth) {
1493               paymentReceiver.transfer(address(this).balance);
1494           } else {
1495               msg.sender.transfer(address(this).balance);
1496           }
1497     }
1498 
1499     function transferTokensIn(TotlePrimary.Trade[] trades) internal {
1500         for (uint256 i = 0; i < trades.length; i++) {
1501             if (trades[i].isSell) {
1502                 if (!tokenTransferProxy.transferFrom(
1503                         trades[i].tokenAddress,
1504                         msg.sender,
1505                         address(this),
1506                         trades[i].tokenAmount
1507                 )) {
1508                     revert("TTP unable to transfer tokens to proxy");
1509                 }
1510                 approveAddress(address(tokenTransferProxy), trades[i].tokenAddress);
1511            }
1512         }
1513     }
1514 
1515     function transferTokensOut(TotlePrimary.Trade[] trades, address receiver, address[] redirectTokens) internal {
1516         for (uint256 i = 0; i < trades.length; i++) {
1517             bool redirect = false;
1518             for(uint256 tokenIndex = 0; tokenIndex < redirectTokens.length; tokenIndex++){
1519                 if(redirectTokens[tokenIndex] == trades[i].tokenAddress){
1520                     redirect = true;
1521                     break;
1522                 }
1523             }
1524             uint256 balance = ERC20(trades[i].tokenAddress).balanceOf(address(this));
1525             if(balance > 0){
1526                 ERC20SafeTransfer.safeTransfer(trades[i].tokenAddress, redirect ? receiver : msg.sender, balance);
1527             }
1528         }
1529     }
1530 
1531     function setTokenTransferProxy(address _newTokenTransferProxy) public onlyOwner {
1532         tokenTransferProxy = TokenTransferProxy(_newTokenTransferProxy);
1533     }
1534 
1535     function setTotlePrimary(address _newTotlePrimary) public onlyOwner {
1536         totlePrimary = TotlePrimary(_newTotlePrimary);
1537     }
1538 
1539 }