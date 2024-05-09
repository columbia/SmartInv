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
162 
163   Copyright 2018 ZeroEx Intl.
164 
165   Licensed under the Apache License, Version 2.0 (the "License");
166   you may not use this file except in compliance with the License.
167   You may obtain a copy of the License at
168 
169     http://www.apache.org/licenses/LICENSE-2.0
170 
171   Unless required by applicable law or agreed to in writing, software
172   distributed under the License is distributed on an "AS IS" BASIS,
173   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
174   See the License for the specific language governing permissions and
175   limitations under the License.
176 
177 */
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
254         require(ERC20SafeTransfer.safeTransferFrom(token, from, to, value));
255         return true;
256     }
257 
258     /*
259      * Public constant functions
260      */
261 
262     /// @dev Gets all authorized addresses.
263     /// @return Array of authorized addresses.
264     function getAuthorizedAddresses()
265         public
266         view
267         returns (address[])
268     {
269         return authorities;
270     }
271 }
272 
273 /**
274  * @title Pausable
275  * @dev Base contract which allows children to implement an emergency stop mechanism.
276  */
277 contract Pausable is Ownable {
278   event Paused();
279   event Unpaused();
280 
281   bool private _paused = false;
282 
283   /**
284    * @return true if the contract is paused, false otherwise.
285    */
286   function paused() public view returns (bool) {
287     return _paused;
288   }
289 
290   /**
291    * @dev Modifier to make a function callable only when the contract is not paused.
292    */
293   modifier whenNotPaused() {
294     require(!_paused, "Contract is paused.");
295     _;
296   }
297 
298   /**
299    * @dev Modifier to make a function callable only when the contract is paused.
300    */
301   modifier whenPaused() {
302     require(_paused, "Contract not paused.");
303     _;
304   }
305 
306   /**
307    * @dev called by the owner to pause, triggers stopped state
308    */
309   function pause() public onlyOwner whenNotPaused {
310     _paused = true;
311     emit Paused();
312   }
313 
314   /**
315    * @dev called by the owner to unpause, returns to normal state
316    */
317   function unpause() public onlyOwner whenPaused {
318     _paused = false;
319     emit Unpaused();
320   }
321 }
322 
323 /**
324  * @title SafeMath
325  * @dev Math operations with safety checks that revert on error
326  */
327 library SafeMath {
328 
329   /**
330   * @dev Multiplies two numbers, reverts on overflow.
331   */
332   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
333     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
334     // benefit is lost if 'b' is also tested.
335     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
336     if (_a == 0) {
337       return 0;
338     }
339 
340     uint256 c = _a * _b;
341     require(c / _a == _b);
342 
343     return c;
344   }
345 
346   /**
347   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
348   */
349   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
350     require(_b > 0); // Solidity only automatically asserts when dividing by 0
351     uint256 c = _a / _b;
352     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
353 
354     return c;
355   }
356 
357   /**
358   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
359   */
360   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
361     require(_b <= _a);
362     uint256 c = _a - _b;
363 
364     return c;
365   }
366 
367   /**
368   * @dev Adds two numbers, reverts on overflow.
369   */
370   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
371     uint256 c = _a + _b;
372     require(c >= _a);
373 
374     return c;
375   }
376 
377   /**
378   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
379   * reverts when dividing by zero.
380   */
381   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
382     require(b != 0);
383     return a % b;
384   }
385 }
386 
387 /*
388     Modified Util contract as used by Kyber Network
389 */
390 
391 library Utils {
392 
393     uint256 constant internal PRECISION = (10**18);
394     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
395     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
396     uint256 constant internal MAX_DECIMALS = 18;
397     uint256 constant internal ETH_DECIMALS = 18;
398     uint256 constant internal MAX_UINT = 2**256-1;
399 
400     // Currently constants can't be accessed from other contracts, so providing functions to do that here
401     function precision() internal pure returns (uint256) { return PRECISION; }
402     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
403     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
404     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
405     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
406     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
407 
408     /// @notice Retrieve the number of decimals used for a given ERC20 token
409     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
410     /// ensure that an exception doesn't cause transaction failure
411     /// @param token the token for which we should retrieve the decimals
412     /// @return decimals the number of decimals in the given token
413     function getDecimals(address token)
414         internal
415         view
416         returns (uint256 decimals)
417     {
418         bytes4 functionSig = bytes4(keccak256("decimals()"));
419 
420         /// @dev Using assembly due to issues with current solidity `address.call()`
421         /// implementation: https://github.com/ethereum/solidity/issues/2884
422         assembly {
423             // Pointer to next free memory slot
424             let ptr := mload(0x40)
425             // Store functionSig variable at ptr
426             mstore(ptr,functionSig)
427             let functionSigLength := 0x04
428             let wordLength := 0x20
429 
430             let success := call(
431                                 5000, // Amount of gas
432                                 token, // Address to call
433                                 0, // ether to send
434                                 ptr, // ptr to input data
435                                 functionSigLength, // size of data
436                                 ptr, // where to store output data (overwrite input)
437                                 wordLength // size of output data (32 bytes)
438                                )
439 
440             switch success
441             case 0 {
442                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
443             }
444             case 1 {
445                 decimals := mload(ptr) // Set decimals to return data from call
446             }
447             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
448         }
449     }
450 
451     /// @dev Checks that a given address has its token allowance and balance set above the given amount
452     /// @param tokenOwner the address which should have custody of the token
453     /// @param tokenAddress the address of the token to check
454     /// @param tokenAmount the amount of the token which should be set
455     /// @param addressToAllow the address which should be allowed to transfer the token
456     /// @return bool true if the allowance and balance is set, false if not
457     function tokenAllowanceAndBalanceSet(
458         address tokenOwner,
459         address tokenAddress,
460         uint256 tokenAmount,
461         address addressToAllow
462     )
463         internal
464         view
465         returns (bool)
466     {
467         return (
468             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
469             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
470         );
471     }
472 
473     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
474         if (dstDecimals >= srcDecimals) {
475             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
476             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
477         } else {
478             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
479             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
480         }
481     }
482 
483     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
484 
485         //source quantity is rounded up. to avoid dest quantity being too low.
486         uint numerator;
487         uint denominator;
488         if (srcDecimals >= dstDecimals) {
489             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
490             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
491             denominator = rate;
492         } else {
493             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
494             numerator = (PRECISION * dstQty);
495             denominator = (rate * (10**(dstDecimals - srcDecimals)));
496         }
497         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
498     }
499 
500     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
501         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
502     }
503 
504     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
505         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
506     }
507 
508     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
509         internal pure returns (uint)
510     {
511         require(srcAmount <= MAX_QTY);
512         require(destAmount <= MAX_QTY);
513 
514         if (dstDecimals >= srcDecimals) {
515             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
516             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
517         } else {
518             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
519             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
520         }
521     }
522 
523     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
524     function min(uint256 a, uint256 b) internal pure returns (uint256) {
525         return a < b ? a : b;
526     }
527 }
528 
529 contract ErrorReporter {
530     function revertTx(string reason) public pure {
531         revert(reason);
532     }
533 }
534 
535 contract Affiliate{
536 
537   address public affiliateBeneficiary;
538   uint256 public affiliatePercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
539 
540   uint256 public companyPercentage;
541   address public companyBeneficiary;
542 
543   function init(address _companyBeneficiary, uint256 _companyPercentage, address _affiliateBeneficiary, uint256 _affiliatePercentage) public {
544       require(companyBeneficiary == 0x0 && affiliateBeneficiary == 0x0);
545       companyBeneficiary = _companyBeneficiary;
546       companyPercentage = _companyPercentage;
547       affiliateBeneficiary = _affiliateBeneficiary;
548       affiliatePercentage = _affiliatePercentage;
549   }
550 
551   function payout() public {
552       // Payout both the affiliate and the company at the same time
553       affiliateBeneficiary.transfer(SafeMath.div(SafeMath.mul(address(this).balance, affiliatePercentage), getTotalFeePercentage()));
554       companyBeneficiary.transfer(address(this).balance);
555   }
556 
557   function() public payable {
558 
559   }
560 
561   function getTotalFeePercentage() public view returns (uint256){
562       return affiliatePercentage + companyPercentage;
563   }
564 }
565 
566 contract AffiliateRegistry is Ownable {
567 
568   address target;
569   mapping(address => bool) affiliateContracts;
570   address public companyBeneficiary;
571   uint256 public companyPercentage;
572 
573   event AffiliateRegistered(address affiliateContract);
574 
575 
576   constructor(address _target, address _companyBeneficiary, uint256 _companyPercentage) public {
577      target = _target;
578      companyBeneficiary = _companyBeneficiary;
579      companyPercentage = _companyPercentage;
580   }
581 
582   function registerAffiliate(address affiliateBeneficiary, uint256 affiliatePercentage) external {
583       Affiliate newAffiliate = Affiliate(createClone());
584       newAffiliate.init(companyBeneficiary, companyPercentage, affiliateBeneficiary, affiliatePercentage);
585       affiliateContracts[address(newAffiliate)] = true;
586       emit AffiliateRegistered(address(newAffiliate));
587   }
588 
589   function overrideRegisterAffiliate(address _companyBeneficiary, uint256 _companyPercentage, address affiliateBeneficiary, uint256 affiliatePercentage) external onlyOwner {
590       Affiliate newAffiliate = Affiliate(createClone());
591       newAffiliate.init(_companyBeneficiary, _companyPercentage, affiliateBeneficiary, affiliatePercentage);
592       affiliateContracts[address(newAffiliate)] = true;
593       emit AffiliateRegistered(address(newAffiliate));
594   }
595 
596   function deleteAffiliate(address _affiliateAddress) public onlyOwner {
597       affiliateContracts[_affiliateAddress] = false;
598   }
599 
600   function createClone() internal returns (address result) {
601       bytes20 targetBytes = bytes20(target);
602       assembly {
603           let clone := mload(0x40)
604           mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
605           mstore(add(clone, 0x14), targetBytes)
606           mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
607           result := create(0, clone, 0x37)
608       }
609   }
610 
611   function isValidAffiliate(address affiliateContract) public view returns(bool) {
612       return affiliateContracts[affiliateContract];
613   }
614 
615   function updateCompanyInfo(address newCompanyBeneficiary, uint256 newCompanyPercentage) public onlyOwner {
616       companyBeneficiary = newCompanyBeneficiary;
617       companyPercentage = newCompanyPercentage;
618   }
619 }
620 
621 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
622 /// some functions
623 /// @dev Defines a modifier which should be used when only the totle contract should
624 /// able able to call a function
625 contract TotleControl is Ownable {
626     mapping(address => bool) public authorizedPrimaries;
627 
628     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
629     modifier onlyTotle() {
630         require(authorizedPrimaries[msg.sender]);
631         _;
632     }
633 
634     /// @notice Contract constructor
635     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
636     /// @param _totlePrimary the address of the contract to be set as totlePrimary
637     constructor(address _totlePrimary) public {
638         authorizedPrimaries[_totlePrimary] = true;
639     }
640 
641     /// @notice A function which allows only the owner to change the address of totlePrimary
642     /// @dev onlyOwner modifier only allows the contract owner to run the code
643     /// @param _totlePrimary the address of the contract to be set as totlePrimary
644     function addTotle(
645         address _totlePrimary
646     ) external onlyOwner {
647         authorizedPrimaries[_totlePrimary] = true;
648     }
649 
650     function removeTotle(
651         address _totlePrimary
652     ) external onlyOwner {
653         authorizedPrimaries[_totlePrimary] = false;
654     }
655 }
656 
657 contract SelectorProvider {
658     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
659     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
660     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
661     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
662 
663     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
664 }
665 
666 /// @title Interface for all exchange handler contracts
667 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
668 
669     /*
670     *   State Variables
671     */
672 
673     ErrorReporter public errorReporter;
674     /* Logger public logger; */
675     /*
676     *   Modifiers
677     */
678 
679     /// @notice Constructor
680     /// @dev Calls the constructor of the inherited TotleControl
681     /// @param totlePrimary the address of the totlePrimary contract
682     constructor(
683         address totlePrimary,
684         address _errorReporter
685         /* ,address _logger */
686     )
687         TotleControl(totlePrimary)
688         public
689     {
690         require(_errorReporter != address(0x0));
691         /* require(_logger != address(0x0)); */
692         errorReporter = ErrorReporter(_errorReporter);
693         /* logger = Logger(_logger); */
694     }
695 
696     /// @notice Gets the amount that Totle needs to give for this order
697     /// @param genericPayload the data for this order in a generic format
698     /// @return amountToGive amount taker needs to give in order to fill the order
699     function getAmountToGive(
700         bytes genericPayload
701     )
702         public
703         view
704         returns (uint256 amountToGive)
705     {
706         bool success;
707         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
708 
709         assembly {
710             let functionSelectorLength := 0x04
711             let functionSelectorOffset := 0x1C
712             let scratchSpace := 0x0
713             let wordLength := 0x20
714             let bytesLength := mload(genericPayload)
715             let totalLength := add(functionSelectorLength, bytesLength)
716             let startOfNewData := add(genericPayload, functionSelectorOffset)
717 
718             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
719             let functionSelectorCorrect := mload(scratchSpace)
720             mstore(genericPayload, functionSelectorCorrect)
721 
722             success := delegatecall(
723                             gas,
724                             address, // This address of the current contract
725                             startOfNewData, // Start data at the beginning of the functionSelector
726                             totalLength, // Total length of all data, including functionSelector
727                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
728                             wordLength // Length of return variable is one word
729                            )
730             amountToGive := mload(scratchSpace)
731             if eq(success, 0) { revert(0, 0) }
732         }
733     }
734 
735     /// @notice Perform exchange-specific checks on the given order
736     /// @dev this should be called to check for payload errors
737     /// @param genericPayload the data for this order in a generic format
738     /// @return checksPassed value representing pass or fail
739     function staticExchangeChecks(
740         bytes genericPayload
741     )
742         public
743         view
744         returns (bool checksPassed)
745     {
746         bool success;
747         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
748         assembly {
749             let functionSelectorLength := 0x04
750             let functionSelectorOffset := 0x1C
751             let scratchSpace := 0x0
752             let wordLength := 0x20
753             let bytesLength := mload(genericPayload)
754             let totalLength := add(functionSelectorLength, bytesLength)
755             let startOfNewData := add(genericPayload, functionSelectorOffset)
756 
757             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
758             let functionSelectorCorrect := mload(scratchSpace)
759             mstore(genericPayload, functionSelectorCorrect)
760 
761             success := delegatecall(
762                             gas,
763                             address, // This address of the current contract
764                             startOfNewData, // Start data at the beginning of the functionSelector
765                             totalLength, // Total length of all data, including functionSelector
766                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
767                             wordLength // Length of return variable is one word
768                            )
769             checksPassed := mload(scratchSpace)
770             if eq(success, 0) { revert(0, 0) }
771         }
772     }
773 
774     /// @notice Perform a buy order at the exchange
775     /// @param genericPayload the data for this order in a generic format
776     /// @param  amountToGiveForOrder amount that should be spent on this order
777     /// @return amountSpentOnOrder the amount that would be spent on the order
778     /// @return amountReceivedFromOrder the amount that was received from this order
779     function performBuyOrder(
780         bytes genericPayload,
781         uint256 amountToGiveForOrder
782     )
783         public
784         payable
785         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
786     {
787         bool success;
788         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
789         assembly {
790             let callDataOffset := 0x44
791             let functionSelectorOffset := 0x1C
792             let functionSelectorLength := 0x04
793             let scratchSpace := 0x0
794             let wordLength := 0x20
795             let startOfFreeMemory := mload(0x40)
796 
797             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
798 
799             let bytesLength := mload(startOfFreeMemory)
800             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
801 
802             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
803 
804             let functionSelectorCorrect := mload(scratchSpace)
805 
806             mstore(startOfFreeMemory, functionSelectorCorrect)
807 
808             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
809 
810             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
811 
812             success := delegatecall(
813                             gas,
814                             address, // This address of the current contract
815                             startOfNewData, // Start data at the beginning of the functionSelector
816                             totalLength, // Total length of all data, including functionSelector
817                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
818                             mul(wordLength, 0x02) // Length of return variables is two words
819                           )
820             amountSpentOnOrder := mload(scratchSpace)
821             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
822             if eq(success, 0) { revert(0, 0) }
823         }
824     }
825 
826     /// @notice Perform a sell order at the exchange
827     /// @param genericPayload the data for this order in a generic format
828     /// @param  amountToGiveForOrder amount that should be spent on this order
829     /// @return amountSpentOnOrder the amount that would be spent on the order
830     /// @return amountReceivedFromOrder the amount that was received from this order
831     function performSellOrder(
832         bytes genericPayload,
833         uint256 amountToGiveForOrder
834     )
835         public
836         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
837     {
838         bool success;
839         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
840         assembly {
841             let callDataOffset := 0x44
842             let functionSelectorOffset := 0x1C
843             let functionSelectorLength := 0x04
844             let scratchSpace := 0x0
845             let wordLength := 0x20
846             let startOfFreeMemory := mload(0x40)
847 
848             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
849 
850             let bytesLength := mload(startOfFreeMemory)
851             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
852 
853             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
854 
855             let functionSelectorCorrect := mload(scratchSpace)
856 
857             mstore(startOfFreeMemory, functionSelectorCorrect)
858 
859             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
860 
861             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
862 
863             success := delegatecall(
864                             gas,
865                             address, // This address of the current contract
866                             startOfNewData, // Start data at the beginning of the functionSelector
867                             totalLength, // Total length of all data, including functionSelector
868                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
869                             mul(wordLength, 0x02) // Length of return variables is two words
870                           )
871             amountSpentOnOrder := mload(scratchSpace)
872             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
873             if eq(success, 0) { revert(0, 0) }
874         }
875     }
876 }
877 
878 /// @title The primary contract for Totle
879 contract TotlePrimary is Withdrawable, Pausable {
880 
881     /*
882     *   State Variables
883     */
884 
885     mapping(address => bool) public handlerWhitelistMap;
886     address[] public handlerWhitelistArray;
887     AffiliateRegistry affiliateRegistry;
888     address public defaultFeeAccount;
889 
890     TokenTransferProxy public tokenTransferProxy;
891     ErrorReporter public errorReporter;
892     /* Logger public logger; */
893 
894     /*
895     *   Types
896     */
897 
898     // Structs
899     struct Trade {
900         bool isSell;
901         address tokenAddress;
902         uint256 tokenAmount;
903         bool optionalTrade;
904         uint256 minimumExchangeRate;
905         uint256 minimumAcceptableTokenAmount;
906         Order[] orders;
907     }
908 
909     struct Order {
910         address exchangeHandler;
911         bytes genericPayload;
912     }
913 
914     struct TradeFlag {
915         bool ignoreTrade;
916         bool[] ignoreOrder;
917     }
918 
919     struct CurrentAmounts {
920         uint256 amountSpentOnTrade;
921         uint256 amountReceivedFromTrade;
922         uint256 amountLeftToSpendOnTrade;
923     }
924 
925     /*
926     *   Events
927     */
928 
929     event LogRebalance(
930         bytes32 id
931     );
932 
933     /*
934     *   Modifiers
935     */
936 
937     modifier handlerWhitelisted(address handler) {
938         if (!handlerWhitelistMap[handler]) {
939             errorReporter.revertTx("Handler not in whitelist");
940         }
941         _;
942     }
943 
944     modifier handlerNotWhitelisted(address handler) {
945         if (handlerWhitelistMap[handler]) {
946             errorReporter.revertTx("Handler already whitelisted");
947         }
948         _;
949     }
950 
951     /// @notice Constructor
952     /// @param _tokenTransferProxy address of the TokenTransferProxy
953     /// @param _errorReporter the address of the error reporter contract
954     constructor (address _tokenTransferProxy, address _affiliateRegistry, address _errorReporter, address _defaultFeeAccount/*, address _logger*/) public {
955         /* require(_logger != address(0x0)); */
956         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
957         affiliateRegistry = AffiliateRegistry(_affiliateRegistry);
958         errorReporter = ErrorReporter(_errorReporter);
959         defaultFeeAccount = _defaultFeeAccount;
960         /* logger = Logger(_logger); */
961     }
962 
963     /*
964     *   Public functions
965     */
966 
967     /// @notice Update the default fee account
968     /// @dev onlyOwner modifier only allows the contract owner to run the code
969     /// @param newDefaultFeeAccount new default fee account
970     function updateDefaultFeeAccount(address newDefaultFeeAccount) public onlyOwner {
971         defaultFeeAccount = newDefaultFeeAccount;
972     }
973 
974     /// @notice Add an exchangeHandler address to the whitelist
975     /// @dev onlyOwner modifier only allows the contract owner to run the code
976     /// @param handler Address of the exchange handler which permission needs adding
977     function addHandlerToWhitelist(address handler)
978         public
979         onlyOwner
980         handlerNotWhitelisted(handler)
981     {
982         handlerWhitelistMap[handler] = true;
983         handlerWhitelistArray.push(handler);
984     }
985 
986     /// @notice Remove an exchangeHandler address from the whitelist
987     /// @dev onlyOwner modifier only allows the contract owner to run the code
988     /// @param handler Address of the exchange handler which permission needs removing
989     function removeHandlerFromWhitelist(address handler)
990         public
991         onlyOwner
992         handlerWhitelisted(handler)
993     {
994         delete handlerWhitelistMap[handler];
995         for (uint i = 0; i < handlerWhitelistArray.length; i++) {
996             if (handlerWhitelistArray[i] == handler) {
997                 handlerWhitelistArray[i] = handlerWhitelistArray[handlerWhitelistArray.length - 1];
998                 handlerWhitelistArray.length -= 1;
999                 break;
1000             }
1001         }
1002     }
1003 
1004     /// @notice Performs the requested portfolio rebalance
1005     /// @param trades A dynamic array of trade structs
1006     function performRebalance(
1007         Trade[] memory trades,
1008         address feeAccount,
1009         bytes32 id
1010     )
1011         public
1012         payable
1013         whenNotPaused
1014     {
1015         if(!affiliateRegistry.isValidAffiliate(feeAccount)){
1016             feeAccount = defaultFeeAccount;
1017         }
1018         Affiliate affiliate = Affiliate(feeAccount);
1019         uint256 feePercentage = affiliate.getTotalFeePercentage();
1020 
1021         emit LogRebalance(id);
1022         /* logger.log("Starting Rebalance..."); */
1023 
1024         TradeFlag[] memory tradeFlags = initialiseTradeFlags(trades);
1025 
1026         staticChecks(trades, tradeFlags);
1027 
1028         /* logger.log("Static checks passed."); */
1029 
1030         transferTokens(trades, tradeFlags);
1031 
1032         /* logger.log("Tokens transferred."); */
1033 
1034         uint256 etherBalance = msg.value;
1035         uint256 totalFee = 0;
1036         /* logger.log("Ether balance arg2: etherBalance.", etherBalance); */
1037 
1038         for (uint256 i; i < trades.length; i++) {
1039             Trade memory thisTrade = trades[i];
1040             TradeFlag memory thisTradeFlag = tradeFlags[i];
1041 
1042             CurrentAmounts memory amounts = CurrentAmounts({
1043                 amountSpentOnTrade: 0,
1044                 amountReceivedFromTrade: 0,
1045                 amountLeftToSpendOnTrade: thisTrade.isSell ? thisTrade.tokenAmount : calculateMaxEtherSpend(thisTrade, etherBalance, feePercentage)
1046             });
1047             /* logger.log("Going to perform trade. arg2: amountLeftToSpendOnTrade", amounts.amountLeftToSpendOnTrade); */
1048 
1049             performTrade(
1050                 thisTrade,
1051                 thisTradeFlag,
1052                 amounts
1053             );
1054             uint256 ethTraded;
1055             uint256 ethFee;
1056             if(thisTrade.isSell){
1057                 ethTraded = amounts.amountReceivedFromTrade;
1058             } else {
1059                 ethTraded = amounts.amountSpentOnTrade;
1060             }
1061             ethFee = calculateFee(ethTraded, feePercentage);
1062             totalFee = SafeMath.add(totalFee, ethFee);
1063             /* logger.log("Finished performing trade arg2: amountReceivedFromTrade, arg3: amountSpentOnTrade.", amounts.amountReceivedFromTrade, amounts.amountSpentOnTrade); */
1064 
1065             if (amounts.amountReceivedFromTrade == 0 && thisTrade.optionalTrade) {
1066                 /* logger.log("Received 0 from trade and this is an optional trade. Skipping."); */
1067                 continue;
1068             }
1069 
1070             /* logger.log(
1071                 "Going to check trade acceptable amounts arg2: amountSpentOnTrade, arg2: amountReceivedFromTrade.",
1072                 amounts.amountSpentOnTrade,
1073                 amounts.amountReceivedFromTrade
1074             ); */
1075 
1076             if (!checkIfTradeAmountsAcceptable(thisTrade, amounts.amountSpentOnTrade, amounts.amountReceivedFromTrade)) {
1077                 errorReporter.revertTx("Amounts spent/received in trade not acceptable");
1078             }
1079 
1080             /* logger.log("Trade passed the acceptable amounts check."); */
1081 
1082             if (thisTrade.isSell) {
1083                 /* logger.log(
1084                     "This is a sell trade, adding ether to our balance arg2: etherBalance, arg3: amountReceivedFromTrade",
1085                     etherBalance,
1086                     amounts.amountReceivedFromTrade
1087                 ); */
1088                 etherBalance = SafeMath.sub(SafeMath.add(etherBalance, ethTraded), ethFee);
1089             } else {
1090                 /* logger.log(
1091                     "This is a buy trade, deducting ether from our balance arg2: etherBalance, arg3: amountSpentOnTrade",
1092                     etherBalance,
1093                     amounts.amountSpentOnTrade
1094                 ); */
1095                 etherBalance = SafeMath.sub(SafeMath.sub(etherBalance, ethTraded), ethFee);
1096             }
1097 
1098             /* logger.log("Transferring tokens to the user arg:6 tokenAddress.", 0,0,0,0, thisTrade.tokenAddress); */
1099 
1100             transferTokensToUser(
1101                 thisTrade.tokenAddress,
1102                 thisTrade.isSell ? amounts.amountLeftToSpendOnTrade : amounts.amountReceivedFromTrade
1103             );
1104 
1105         }
1106         if(totalFee > 0){
1107             feeAccount.transfer(totalFee);
1108         }
1109         if(etherBalance > 0) {
1110             /* logger.log("Got a positive ether balance, sending to the user arg2: etherBalance.", etherBalance); */
1111             msg.sender.transfer(etherBalance);
1112         }
1113     }
1114 
1115     /// @notice Performs static checks on the rebalance payload before execution
1116     /// @dev This function is public so a rebalance can be checked before performing a rebalance
1117     /// @param trades A dynamic array of trade structs
1118     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1119     function staticChecks(
1120         Trade[] trades,
1121         TradeFlag[] tradeFlags
1122     )
1123         public
1124         view
1125         whenNotPaused
1126     {
1127         bool previousBuyOccured = false;
1128 
1129         for (uint256 i; i < trades.length; i++) {
1130             Trade memory thisTrade = trades[i];
1131             if (thisTrade.isSell) {
1132                 if (previousBuyOccured) {
1133                     errorReporter.revertTx("A buy has occured before this sell");
1134                 }
1135 
1136                 if (!Utils.tokenAllowanceAndBalanceSet(msg.sender, thisTrade.tokenAddress, thisTrade.tokenAmount, address(tokenTransferProxy))) {
1137                     if (!thisTrade.optionalTrade) {
1138                         errorReporter.revertTx("Taker has not sent allowance/balance on a non-optional trade");
1139                     }
1140                     /* logger.log(
1141                         "Attempt to sell a token without allowance or sufficient balance arg2: tokenAmount, arg6: tokenAddress . Otional trade, ignoring.",
1142                         thisTrade.tokenAmount,
1143                         0,
1144                         0,
1145                         0,
1146                         thisTrade.tokenAddress
1147                     ); */
1148                     tradeFlags[i].ignoreTrade = true;
1149                     continue;
1150                 }
1151             } else {
1152                 previousBuyOccured = true;
1153             }
1154 
1155             /* logger.log("Checking that all the handlers are whitelisted."); */
1156             for (uint256 j; j < thisTrade.orders.length; j++) {
1157                 Order memory thisOrder = thisTrade.orders[j];
1158                 if ( !handlerWhitelistMap[thisOrder.exchangeHandler] ) {
1159                     /* logger.log(
1160                         "Trying to use a handler that is not whitelisted arg6: exchangeHandler.",
1161                         0,
1162                         0,
1163                         0,
1164                         0,
1165                         thisOrder.exchangeHandler
1166                     ); */
1167                     tradeFlags[i].ignoreOrder[j] = true;
1168                     continue;
1169                 }
1170             }
1171         }
1172     }
1173 
1174     /*
1175     *   Internal functions
1176     */
1177 
1178     /// @notice Initialises the trade flag struct
1179     /// @param trades the trades used to initialise the flags
1180     /// @return tradeFlags the initialised flags
1181     function initialiseTradeFlags(Trade[] trades)
1182         internal
1183         returns (TradeFlag[])
1184     {
1185         /* logger.log("Initializing trade flags."); */
1186         TradeFlag[] memory tradeFlags = new TradeFlag[](trades.length);
1187         for (uint256 i = 0; i < trades.length; i++) {
1188             tradeFlags[i].ignoreOrder = new bool[](trades[i].orders.length);
1189         }
1190         return tradeFlags;
1191     }
1192 
1193     /// @notice Transfers the given amount of tokens back to the msg.sender
1194     /// @param tokenAddress the address of the token to transfer
1195     /// @param tokenAmount the amount of tokens to transfer
1196     function transferTokensToUser(
1197         address tokenAddress,
1198         uint256 tokenAmount
1199     )
1200         internal
1201     {
1202         /* logger.log("Transfering tokens to the user arg2: tokenAmount, arg6: .tokenAddress", tokenAmount, 0, 0, 0, tokenAddress); */
1203         if (tokenAmount > 0) {
1204             if (!ERC20SafeTransfer.safeTransfer(tokenAddress, msg.sender, tokenAmount)) {
1205                 errorReporter.revertTx("Unable to transfer tokens to user");
1206             }
1207         }
1208     }
1209 
1210     /// @notice Executes the given trade
1211     /// @param trade a struct containing information about the trade
1212     /// @param tradeFlag a struct containing trade status information
1213     /// @param amounts a struct containing information about amounts spent
1214     /// and received in the rebalance
1215     function performTrade(
1216         Trade memory trade,
1217         TradeFlag memory tradeFlag,
1218         CurrentAmounts amounts
1219     )
1220         internal
1221     {
1222         /* logger.log("Performing trade"); */
1223 
1224         for (uint256 j; j < trade.orders.length; j++) {
1225 
1226             if(amounts.amountLeftToSpendOnTrade * 10000 < (amounts.amountSpentOnTrade + amounts.amountLeftToSpendOnTrade)){
1227                 return;
1228             }
1229 
1230             if((trade.isSell ? amounts.amountSpentOnTrade : amounts.amountReceivedFromTrade) >= trade.tokenAmount ) {
1231                 return;
1232             }
1233 
1234             if (tradeFlag.ignoreOrder[j] || amounts.amountLeftToSpendOnTrade == 0) {
1235                 /* logger.log(
1236                     "Order ignore flag is set to true or have nothing left to spend arg2: amountLeftToSpendOnTrade",
1237                     amounts.amountLeftToSpendOnTrade
1238                 ); */
1239                 continue;
1240             }
1241 
1242             uint256 amountSpentOnOrder = 0;
1243             uint256 amountReceivedFromOrder = 0;
1244 
1245             Order memory thisOrder = trade.orders[j];
1246 
1247             /* logger.log("Setting order exchange handler arg6: exchangeHandler.", 0, 0, 0, 0, thisOrder.exchangeHandler); */
1248             ExchangeHandler thisHandler = ExchangeHandler(thisOrder.exchangeHandler);
1249 
1250             uint256 amountToGiveForOrder = Utils.min(
1251                 thisHandler.getAmountToGive(thisOrder.genericPayload),
1252                 amounts.amountLeftToSpendOnTrade
1253             );
1254 
1255             if (amountToGiveForOrder == 0) {
1256                 /* logger.log(
1257                     "MASSIVE ERROR: amountToGiveForOrder was found to be 0, this hasn't been caught in preTradeChecks, which means dynamicExchangeChecks isnt written correctly!"
1258                 ); */
1259                 continue;
1260             }
1261 
1262             /* logger.log(
1263                 "Calculating amountToGiveForOrder arg2: amountToGiveForOrder, arg3: amountLeftToSpendOnTrade.",
1264                 amountToGiveForOrder,
1265                 amounts.amountLeftToSpendOnTrade
1266             ); */
1267 
1268             if( !thisHandler.staticExchangeChecks(thisOrder.genericPayload) ) {
1269                 /* logger.log("Order did not pass checks, skipping."); */
1270                 continue;
1271             }
1272 
1273             if (trade.isSell) {
1274                 /* logger.log("This is a sell.."); */
1275                 if (!ERC20SafeTransfer.safeTransfer(trade.tokenAddress,address(thisHandler), amountToGiveForOrder)) {
1276                     if( !trade.optionalTrade ) errorReporter.revertTx("Unable to transfer tokens to handler");
1277                     else {
1278                         /* logger.log("Unable to transfer tokens to handler but the trade is optional"); */
1279                         return;
1280                     }
1281                 }
1282 
1283                 /* logger.log("Going to perform a sell order."); */
1284                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performSellOrder(thisOrder.genericPayload, amountToGiveForOrder);
1285                 /* logger.log("Sell order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1286             } else {
1287                 /* logger.log("Going to perform a buy order."); */
1288                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performBuyOrder.value(amountToGiveForOrder)(thisOrder.genericPayload, amountToGiveForOrder);
1289                 /* logger.log("Buy order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1290             }
1291 
1292 
1293             if (amountReceivedFromOrder > 0) {
1294                 amounts.amountLeftToSpendOnTrade = SafeMath.sub(amounts.amountLeftToSpendOnTrade, amountSpentOnOrder);
1295                 amounts.amountSpentOnTrade = SafeMath.add(amounts.amountSpentOnTrade, amountSpentOnOrder);
1296                 amounts.amountReceivedFromTrade = SafeMath.add(amounts.amountReceivedFromTrade, amountReceivedFromOrder);
1297 
1298                 /* logger.log(
1299                     "Updated amounts arg2: amountLeftToSpendOnTrade, arg3: amountSpentOnTrade, arg4: amountReceivedFromTrade.",
1300                     amounts.amountLeftToSpendOnTrade,
1301                     amounts.amountSpentOnTrade,
1302                     amounts.amountReceivedFromTrade
1303                 ); */
1304             }
1305         }
1306 
1307     }
1308 
1309     /// @notice Check if the amounts spent and gained on a trade are within the
1310     /// user"s set limits
1311     /// @param trade contains information on the given trade
1312     /// @param amountSpentOnTrade the amount that was spent on the trade
1313     /// @param amountReceivedFromTrade the amount that was received from the trade
1314     /// @return bool whether the trade passes the checks
1315     function checkIfTradeAmountsAcceptable(
1316         Trade trade,
1317         uint256 amountSpentOnTrade,
1318         uint256 amountReceivedFromTrade
1319     )
1320         internal
1321         view
1322         returns (bool passed)
1323     {
1324         /* logger.log("Checking if trade amounts are acceptable."); */
1325         uint256 tokenAmount = trade.isSell ? amountSpentOnTrade : amountReceivedFromTrade;
1326         passed = tokenAmount >= trade.minimumAcceptableTokenAmount;
1327 
1328         /*if( !passed ) {
1329              logger.log(
1330                 "Received less than minimum acceptable tokens arg2: tokenAmount , arg3: minimumAcceptableTokenAmount.",
1331                 tokenAmount,
1332                 trade.minimumAcceptableTokenAmount
1333             );
1334         }*/
1335 
1336         if (passed) {
1337             uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1338             uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1339             uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1340             uint256 actualRate = Utils.calcRateFromQty(amountSpentOnTrade, amountReceivedFromTrade, srcDecimals, destDecimals);
1341             passed = actualRate >= trade.minimumExchangeRate;
1342         }
1343 
1344         /*if( !passed ) {
1345              logger.log(
1346                 "Order rate was lower than minimum acceptable,  rate arg2: actualRate, arg3: minimumExchangeRate.",
1347                 actualRate,
1348                 trade.minimumExchangeRate
1349             );
1350         }*/
1351     }
1352 
1353     /// @notice Iterates through a list of token orders, transfer the SELL orders to this contract & calculates if we have the ether needed
1354     /// @param trades A dynamic array of trade structs
1355     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1356     function transferTokens(Trade[] trades, TradeFlag[] tradeFlags) internal {
1357         for (uint256 i = 0; i < trades.length; i++) {
1358             if (trades[i].isSell && !tradeFlags[i].ignoreTrade) {
1359 
1360                 /* logger.log(
1361                     "Transfering tokens arg2: tokenAmount, arg5: tokenAddress.",
1362                     trades[i].tokenAmount,
1363                     0,
1364                     0,
1365                     0,
1366                     trades[i].tokenAddress
1367                 ); */
1368                 if (
1369                     !tokenTransferProxy.transferFrom(
1370                         trades[i].tokenAddress,
1371                         msg.sender,
1372                         address(this),
1373                         trades[i].tokenAmount
1374                     )
1375                 ) {
1376                     errorReporter.revertTx("TTP unable to transfer tokens to primary");
1377                 }
1378            }
1379         }
1380     }
1381 
1382     /// @notice Calculates the maximum amount that should be spent on a given buy trade
1383     /// @param trade the buy trade to return the spend amount for
1384     /// @param etherBalance the amount of ether that we currently have to spend
1385     /// @return uint256 the maximum amount of ether we should spend on this trade
1386     function calculateMaxEtherSpend(Trade trade, uint256 etherBalance, uint256 feePercentage) internal view returns (uint256) {
1387         /// @dev This function should never be called for a sell
1388         assert(!trade.isSell);
1389 
1390         uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1391         uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1392         uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1393         uint256 maxSpendAtMinRate = Utils.calcSrcQty(trade.tokenAmount, srcDecimals, destDecimals, trade.minimumExchangeRate);
1394 
1395         return Utils.min(removeFee(etherBalance, feePercentage), maxSpendAtMinRate);
1396     }
1397 
1398     // @notice Calculates the fee amount given a fee percentage and amount
1399     // @param amount the amount to calculate the fee based on
1400     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1401     function calculateFee(uint256 amount, uint256 fee) internal view returns (uint256){
1402         return SafeMath.div(SafeMath.mul(amount, fee), 1 ether);
1403     }
1404 
1405     // @notice Calculates the cost if amount=cost+fee
1406     // @param amount the amount to calculate the base on
1407     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1408     function removeFee(uint256 amount, uint256 fee) internal view returns (uint256){
1409         return SafeMath.div(SafeMath.mul(amount, 1 ether), SafeMath.add(fee, 1 ether));
1410     }
1411     /*
1412     *   Payable fallback function
1413     */
1414 
1415     /// @notice payable fallback to allow handler or exchange contracts to return ether
1416     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
1417     function() public payable whenNotPaused {
1418         // Check in here that the sender is a contract! (to stop accidents)
1419         uint256 size;
1420         address sender = msg.sender;
1421         assembly {
1422             size := extcodesize(sender)
1423         }
1424         if (size == 0) {
1425             errorReporter.revertTx("EOA cannot send ether to primary fallback");
1426         }
1427     }
1428 }
1429 
1430 /// @title A contract which is used to check and set allowances of tokens
1431 /// @dev In order to use this contract is must be inherited in the contract which is using
1432 /// its functionality
1433 contract AllowanceSetter {
1434     uint256 constant MAX_UINT = 2**256 - 1;
1435 
1436     /// @notice A function which allows the caller to approve the max amount of any given token
1437     /// @dev In order to function correctly, token allowances should not be set anywhere else in
1438     /// the inheriting contract
1439     /// @param addressToApprove the address which we want to approve to transfer the token
1440     /// @param token the token address which we want to call approve on
1441     function approveAddress(address addressToApprove, address token) internal {
1442         if(ERC20(token).allowance(address(this), addressToApprove) == 0) {
1443             require(ERC20SafeTransfer.safeApprove(token, addressToApprove, MAX_UINT));
1444         }
1445     }
1446 
1447 }
1448 
1449 contract TotleProxyPrimary is Ownable, AllowanceSetter {
1450 
1451     TokenTransferProxy public tokenTransferProxy;
1452     TotlePrimary public totlePrimary;
1453 
1454     constructor(address _tokenTransferProxy, address _totlePrimary) public {
1455         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
1456         totlePrimary = TotlePrimary(_totlePrimary);
1457     }
1458 
1459     function performRebalance(
1460         TotlePrimary.Trade[] memory trades,
1461         address feeAccount,
1462         bytes32 id,
1463         address paymentReceiver,
1464         bool redirectEth,
1465         address[] redirectTokens
1466     )
1467         public
1468         payable
1469     {
1470           transferTokensIn(trades);
1471           totlePrimary.performRebalance(trades, feeAccount, id);
1472           transferTokensOut(trades, paymentReceiver, redirectTokens);
1473           if(redirectEth) {
1474               paymentReceiver.transfer(address(this).balance);
1475           } else {
1476               msg.sender.transfer(address(this).balance);
1477           }
1478     }
1479 
1480     function transferTokensIn(TotlePrimary.Trade[] trades) internal {
1481         for (uint256 i = 0; i < trades.length; i++) {
1482             if (trades[i].isSell) {
1483                 if (!tokenTransferProxy.transferFrom(
1484                         trades[i].tokenAddress,
1485                         msg.sender,
1486                         address(this),
1487                         trades[i].tokenAmount
1488                 )) {
1489                     revert("TTP unable to transfer tokens to proxy");
1490                 }
1491                 approveAddress(address(totlePrimary), trades[i].tokenAddress);
1492            }
1493         }
1494     }
1495 
1496     function transferTokensOut(TotlePrimary.Trade[] trades, address receiver, address[] redirectTokens) internal {
1497         for (uint256 i = 0; i < trades.length; i++) {
1498             bool redirect = false;
1499             for(uint256 tokenIndex = 0; tokenIndex < redirectTokens.length; tokenIndex++){
1500                 if(redirectTokens[tokenIndex] == trades[i].tokenAddress){
1501                     redirect = true;
1502                     break;
1503                 }
1504             }
1505             uint256 balance = ERC20(trades[i].tokenAddress).balanceOf(address(this));
1506             if(balance > 0){
1507                 ERC20SafeTransfer.safeTransfer(trades[i].tokenAddress, redirect ? receiver : msg.sender, balance);
1508             }
1509         }
1510     }
1511 
1512     function setTokenTransferProxy(address _newTokenTransferProxy) public onlyOwner {
1513         tokenTransferProxy = TokenTransferProxy(_newTokenTransferProxy);
1514     }
1515 
1516     function setTotlePrimary(address _newTotlePrimary) public onlyOwner {
1517         totlePrimary = TotlePrimary(_newTotlePrimary);
1518     }
1519 
1520 }