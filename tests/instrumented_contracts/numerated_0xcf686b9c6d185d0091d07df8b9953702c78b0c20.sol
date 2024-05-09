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
261      * Public constant functions
262      */
263 
264     /// @dev Gets all authorized addresses.
265     /// @return Array of authorized addresses.
266     function getAuthorizedAddresses()
267         public
268         view
269         returns (address[])
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
401 
402     // Currently constants can't be accessed from other contracts, so providing functions to do that here
403     function precision() internal pure returns (uint256) { return PRECISION; }
404     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
405     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
406     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
407     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
408     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
409 
410     /// @notice Retrieve the number of decimals used for a given ERC20 token
411     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
412     /// ensure that an exception doesn't cause transaction failure
413     /// @param token the token for which we should retrieve the decimals
414     /// @return decimals the number of decimals in the given token
415     function getDecimals(address token)
416         internal
417         view
418         returns (uint256 decimals)
419     {
420         bytes4 functionSig = bytes4(keccak256("decimals()"));
421 
422         /// @dev Using assembly due to issues with current solidity `address.call()`
423         /// implementation: https://github.com/ethereum/solidity/issues/2884
424         assembly {
425             // Pointer to next free memory slot
426             let ptr := mload(0x40)
427             // Store functionSig variable at ptr
428             mstore(ptr,functionSig)
429             let functionSigLength := 0x04
430             let wordLength := 0x20
431 
432             let success := call(
433                                 5000, // Amount of gas
434                                 token, // Address to call
435                                 0, // ether to send
436                                 ptr, // ptr to input data
437                                 functionSigLength, // size of data
438                                 ptr, // where to store output data (overwrite input)
439                                 wordLength // size of output data (32 bytes)
440                                )
441 
442             switch success
443             case 0 {
444                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
445             }
446             case 1 {
447                 decimals := mload(ptr) // Set decimals to return data from call
448             }
449             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
450         }
451     }
452 
453     /// @dev Checks that a given address has its token allowance and balance set above the given amount
454     /// @param tokenOwner the address which should have custody of the token
455     /// @param tokenAddress the address of the token to check
456     /// @param tokenAmount the amount of the token which should be set
457     /// @param addressToAllow the address which should be allowed to transfer the token
458     /// @return bool true if the allowance and balance is set, false if not
459     function tokenAllowanceAndBalanceSet(
460         address tokenOwner,
461         address tokenAddress,
462         uint256 tokenAmount,
463         address addressToAllow
464     )
465         internal
466         view
467         returns (bool)
468     {
469         return (
470             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
471             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
472         );
473     }
474 
475     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
476         if (dstDecimals >= srcDecimals) {
477             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
478             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
479         } else {
480             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
481             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
482         }
483     }
484 
485     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
486 
487         //source quantity is rounded up. to avoid dest quantity being too low.
488         uint numerator;
489         uint denominator;
490         if (srcDecimals >= dstDecimals) {
491             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
492             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
493             denominator = rate;
494         } else {
495             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
496             numerator = (PRECISION * dstQty);
497             denominator = (rate * (10**(dstDecimals - srcDecimals)));
498         }
499         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
500     }
501 
502     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal view returns (uint) {
503         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
504     }
505 
506     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal view returns (uint) {
507         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
508     }
509 
510     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
511         internal pure returns (uint)
512     {
513         require(srcAmount <= MAX_QTY);
514         require(destAmount <= MAX_QTY);
515 
516         if (dstDecimals >= srcDecimals) {
517             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
518             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
519         } else {
520             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
521             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
522         }
523     }
524 
525     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
526     function min(uint256 a, uint256 b) internal pure returns (uint256) {
527         return a < b ? a : b;
528     }
529 }
530 
531 contract ErrorReporter {
532     function revertTx(string reason) public pure {
533         revert(reason);
534     }
535 }
536 
537 contract Affiliate{
538 
539   event FeeLog(uint256 ethCollected);
540 
541   address public affiliateBeneficiary;
542   uint256 public affiliatePercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
543 
544   uint256 public companyPercentage;
545   address public companyBeneficiary;
546 
547   function init(address _companyBeneficiary, uint256 _companyPercentage, address _affiliateBeneficiary, uint256 _affiliatePercentage) public {
548       require(companyBeneficiary == 0x0 && affiliateBeneficiary == 0x0);
549       companyBeneficiary = _companyBeneficiary;
550       companyPercentage = _companyPercentage;
551       affiliateBeneficiary = _affiliateBeneficiary;
552       affiliatePercentage = _affiliatePercentage;
553   }
554 
555   function payout() public {
556       // Payout both the affiliate and the company at the same time
557       affiliateBeneficiary.transfer(SafeMath.div(SafeMath.mul(address(this).balance, affiliatePercentage), getTotalFeePercentage()));
558       companyBeneficiary.transfer(address(this).balance);
559   }
560 
561   function() public payable {
562       emit FeeLog(msg.value);
563   }
564 
565   function getTotalFeePercentage() public view returns (uint256){
566       return affiliatePercentage + companyPercentage;
567   }
568 }
569 
570 contract AffiliateRegistry is Ownable {
571 
572   address target;
573   mapping(address => bool) affiliateContracts;
574   address public companyBeneficiary;
575   uint256 public companyPercentage;
576 
577   event AffiliateRegistered(address affiliateContract);
578 
579 
580   constructor(address _target, address _companyBeneficiary, uint256 _companyPercentage) public {
581      target = _target;
582      companyBeneficiary = _companyBeneficiary;
583      companyPercentage = _companyPercentage;
584   }
585 
586   function registerAffiliate(address affiliateBeneficiary, uint256 affiliatePercentage) external {
587       Affiliate newAffiliate = Affiliate(createClone());
588       newAffiliate.init(companyBeneficiary, companyPercentage, affiliateBeneficiary, affiliatePercentage);
589       affiliateContracts[address(newAffiliate)] = true;
590       emit AffiliateRegistered(address(newAffiliate));
591   }
592 
593   function overrideRegisterAffiliate(address _companyBeneficiary, uint256 _companyPercentage, address affiliateBeneficiary, uint256 affiliatePercentage) external onlyOwner {
594       Affiliate newAffiliate = Affiliate(createClone());
595       newAffiliate.init(_companyBeneficiary, _companyPercentage, affiliateBeneficiary, affiliatePercentage);
596       affiliateContracts[address(newAffiliate)] = true;
597       emit AffiliateRegistered(address(newAffiliate));
598   }
599 
600   function deleteAffiliate(address _affiliateAddress) public onlyOwner {
601       affiliateContracts[_affiliateAddress] = false;
602   }
603 
604   function createClone() internal returns (address result) {
605       bytes20 targetBytes = bytes20(target);
606       assembly {
607           let clone := mload(0x40)
608           mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
609           mstore(add(clone, 0x14), targetBytes)
610           mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
611           result := create(0, clone, 0x37)
612       }
613   }
614 
615   function isValidAffiliate(address affiliateContract) public view returns(bool) {
616       return affiliateContracts[affiliateContract];
617   }
618 
619   function updateCompanyInfo(address newCompanyBeneficiary, uint256 newCompanyPercentage) public onlyOwner {
620       companyBeneficiary = newCompanyBeneficiary;
621       companyPercentage = newCompanyPercentage;
622   }
623 }
624 
625 /// @title A contract which can be used to ensure only the TotlePrimary contract can call
626 /// some functions
627 /// @dev Defines a modifier which should be used when only the totle contract should
628 /// able able to call a function
629 contract TotleControl is Ownable {
630     mapping(address => bool) public authorizedPrimaries;
631 
632     /// @dev A modifier which only allows code execution if msg.sender equals totlePrimary address
633     modifier onlyTotle() {
634         require(authorizedPrimaries[msg.sender]);
635         _;
636     }
637 
638     /// @notice Contract constructor
639     /// @dev As this contract inherits ownable, msg.sender will become the contract owner
640     /// @param _totlePrimary the address of the contract to be set as totlePrimary
641     constructor(address _totlePrimary) public {
642         authorizedPrimaries[_totlePrimary] = true;
643     }
644 
645     /// @notice A function which allows only the owner to change the address of totlePrimary
646     /// @dev onlyOwner modifier only allows the contract owner to run the code
647     /// @param _totlePrimary the address of the contract to be set as totlePrimary
648     function addTotle(
649         address _totlePrimary
650     ) external onlyOwner {
651         authorizedPrimaries[_totlePrimary] = true;
652     }
653 
654     function removeTotle(
655         address _totlePrimary
656     ) external onlyOwner {
657         authorizedPrimaries[_totlePrimary] = false;
658     }
659 }
660 
661 contract SelectorProvider {
662     bytes4 constant getAmountToGiveSelector = bytes4(keccak256("getAmountToGive(bytes)"));
663     bytes4 constant staticExchangeChecksSelector = bytes4(keccak256("staticExchangeChecks(bytes)"));
664     bytes4 constant performBuyOrderSelector = bytes4(keccak256("performBuyOrder(bytes,uint256)"));
665     bytes4 constant performSellOrderSelector = bytes4(keccak256("performSellOrder(bytes,uint256)"));
666 
667     function getSelector(bytes4 genericSelector) public pure returns (bytes4);
668 }
669 
670 /// @title Interface for all exchange handler contracts
671 contract ExchangeHandler is SelectorProvider, TotleControl, Withdrawable, Pausable {
672 
673     /*
674     *   State Variables
675     */
676 
677     ErrorReporter public errorReporter;
678     /* Logger public logger; */
679     /*
680     *   Modifiers
681     */
682 
683     /// @notice Constructor
684     /// @dev Calls the constructor of the inherited TotleControl
685     /// @param totlePrimary the address of the totlePrimary contract
686     constructor(
687         address totlePrimary,
688         address _errorReporter
689         /* ,address _logger */
690     )
691         TotleControl(totlePrimary)
692         public
693     {
694         require(_errorReporter != address(0x0));
695         /* require(_logger != address(0x0)); */
696         errorReporter = ErrorReporter(_errorReporter);
697         /* logger = Logger(_logger); */
698     }
699 
700     /// @notice Gets the amount that Totle needs to give for this order
701     /// @param genericPayload the data for this order in a generic format
702     /// @return amountToGive amount taker needs to give in order to fill the order
703     function getAmountToGive(
704         bytes genericPayload
705     )
706         public
707         view
708         returns (uint256 amountToGive)
709     {
710         bool success;
711         bytes4 functionSelector = getSelector(this.getAmountToGive.selector);
712 
713         assembly {
714             let functionSelectorLength := 0x04
715             let functionSelectorOffset := 0x1C
716             let scratchSpace := 0x0
717             let wordLength := 0x20
718             let bytesLength := mload(genericPayload)
719             let totalLength := add(functionSelectorLength, bytesLength)
720             let startOfNewData := add(genericPayload, functionSelectorOffset)
721 
722             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
723             let functionSelectorCorrect := mload(scratchSpace)
724             mstore(genericPayload, functionSelectorCorrect)
725 
726             success := delegatecall(
727                             gas,
728                             address, // This address of the current contract
729                             startOfNewData, // Start data at the beginning of the functionSelector
730                             totalLength, // Total length of all data, including functionSelector
731                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
732                             wordLength // Length of return variable is one word
733                            )
734             amountToGive := mload(scratchSpace)
735             if eq(success, 0) { revert(0, 0) }
736         }
737     }
738 
739     /// @notice Perform exchange-specific checks on the given order
740     /// @dev this should be called to check for payload errors
741     /// @param genericPayload the data for this order in a generic format
742     /// @return checksPassed value representing pass or fail
743     function staticExchangeChecks(
744         bytes genericPayload
745     )
746         public
747         view
748         returns (bool checksPassed)
749     {
750         bool success;
751         bytes4 functionSelector = getSelector(this.staticExchangeChecks.selector);
752         assembly {
753             let functionSelectorLength := 0x04
754             let functionSelectorOffset := 0x1C
755             let scratchSpace := 0x0
756             let wordLength := 0x20
757             let bytesLength := mload(genericPayload)
758             let totalLength := add(functionSelectorLength, bytesLength)
759             let startOfNewData := add(genericPayload, functionSelectorOffset)
760 
761             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
762             let functionSelectorCorrect := mload(scratchSpace)
763             mstore(genericPayload, functionSelectorCorrect)
764 
765             success := delegatecall(
766                             gas,
767                             address, // This address of the current contract
768                             startOfNewData, // Start data at the beginning of the functionSelector
769                             totalLength, // Total length of all data, including functionSelector
770                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
771                             wordLength // Length of return variable is one word
772                            )
773             checksPassed := mload(scratchSpace)
774             if eq(success, 0) { revert(0, 0) }
775         }
776     }
777 
778     /// @notice Perform a buy order at the exchange
779     /// @param genericPayload the data for this order in a generic format
780     /// @param  amountToGiveForOrder amount that should be spent on this order
781     /// @return amountSpentOnOrder the amount that would be spent on the order
782     /// @return amountReceivedFromOrder the amount that was received from this order
783     function performBuyOrder(
784         bytes genericPayload,
785         uint256 amountToGiveForOrder
786     )
787         public
788         payable
789         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
790     {
791         bool success;
792         bytes4 functionSelector = getSelector(this.performBuyOrder.selector);
793         assembly {
794             let callDataOffset := 0x44
795             let functionSelectorOffset := 0x1C
796             let functionSelectorLength := 0x04
797             let scratchSpace := 0x0
798             let wordLength := 0x20
799             let startOfFreeMemory := mload(0x40)
800 
801             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
802 
803             let bytesLength := mload(startOfFreeMemory)
804             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
805 
806             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
807 
808             let functionSelectorCorrect := mload(scratchSpace)
809 
810             mstore(startOfFreeMemory, functionSelectorCorrect)
811 
812             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
813 
814             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
815 
816             success := delegatecall(
817                             gas,
818                             address, // This address of the current contract
819                             startOfNewData, // Start data at the beginning of the functionSelector
820                             totalLength, // Total length of all data, including functionSelector
821                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
822                             mul(wordLength, 0x02) // Length of return variables is two words
823                           )
824             amountSpentOnOrder := mload(scratchSpace)
825             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
826             if eq(success, 0) { revert(0, 0) }
827         }
828     }
829 
830     /// @notice Perform a sell order at the exchange
831     /// @param genericPayload the data for this order in a generic format
832     /// @param  amountToGiveForOrder amount that should be spent on this order
833     /// @return amountSpentOnOrder the amount that would be spent on the order
834     /// @return amountReceivedFromOrder the amount that was received from this order
835     function performSellOrder(
836         bytes genericPayload,
837         uint256 amountToGiveForOrder
838     )
839         public
840         returns (uint256 amountSpentOnOrder, uint256 amountReceivedFromOrder)
841     {
842         bool success;
843         bytes4 functionSelector = getSelector(this.performSellOrder.selector);
844         assembly {
845             let callDataOffset := 0x44
846             let functionSelectorOffset := 0x1C
847             let functionSelectorLength := 0x04
848             let scratchSpace := 0x0
849             let wordLength := 0x20
850             let startOfFreeMemory := mload(0x40)
851 
852             calldatacopy(startOfFreeMemory, callDataOffset, calldatasize)
853 
854             let bytesLength := mload(startOfFreeMemory)
855             let totalLength := add(add(functionSelectorLength, bytesLength), wordLength)
856 
857             mstore(add(scratchSpace, functionSelectorOffset), functionSelector)
858 
859             let functionSelectorCorrect := mload(scratchSpace)
860 
861             mstore(startOfFreeMemory, functionSelectorCorrect)
862 
863             mstore(add(startOfFreeMemory, add(wordLength, bytesLength)), amountToGiveForOrder)
864 
865             let startOfNewData := add(startOfFreeMemory,functionSelectorOffset)
866 
867             success := delegatecall(
868                             gas,
869                             address, // This address of the current contract
870                             startOfNewData, // Start data at the beginning of the functionSelector
871                             totalLength, // Total length of all data, including functionSelector
872                             scratchSpace, // Use the first word of memory (scratch space) to store our return variable.
873                             mul(wordLength, 0x02) // Length of return variables is two words
874                           )
875             amountSpentOnOrder := mload(scratchSpace)
876             amountReceivedFromOrder := mload(add(scratchSpace, wordLength))
877             if eq(success, 0) { revert(0, 0) }
878         }
879     }
880 }
881 
882 /// @title The primary contract for Totle
883 contract TotlePrimary is Withdrawable, Pausable {
884 
885     /*
886     *   State Variables
887     */
888 
889     mapping(address => bool) public handlerWhitelistMap;
890     address[] public handlerWhitelistArray;
891     AffiliateRegistry affiliateRegistry;
892     address public defaultFeeAccount;
893 
894     TokenTransferProxy public tokenTransferProxy;
895     ErrorReporter public errorReporter;
896     /* Logger public logger; */
897 
898     /*
899     *   Types
900     */
901 
902     // Structs
903     struct Trade {
904         bool isSell;
905         address tokenAddress;
906         uint256 tokenAmount;
907         bool optionalTrade;
908         uint256 minimumExchangeRate;
909         uint256 minimumAcceptableTokenAmount;
910         Order[] orders;
911     }
912 
913     struct Order {
914         address exchangeHandler;
915         bytes genericPayload;
916     }
917 
918     struct TradeFlag {
919         bool ignoreTrade;
920         bool[] ignoreOrder;
921     }
922 
923     struct CurrentAmounts {
924         uint256 amountSpentOnTrade;
925         uint256 amountReceivedFromTrade;
926         uint256 amountLeftToSpendOnTrade;
927     }
928 
929     /*
930     *   Events
931     */
932 
933     event LogRebalance(
934         bytes32 id,
935         uint256 totalEthTraded,
936         uint256 totalFee,
937         address feeAccount
938     );
939 
940     event LogTrade(
941         bool isSell,
942         address token,
943         uint256 ethAmount,
944         uint256 tokenAmount
945     );
946 
947     /*
948     *   Modifiers
949     */
950 
951     modifier handlerWhitelisted(address handler) {
952         if (!handlerWhitelistMap[handler]) {
953             errorReporter.revertTx("Handler not in whitelist");
954         }
955         _;
956     }
957 
958     modifier handlerNotWhitelisted(address handler) {
959         if (handlerWhitelistMap[handler]) {
960             errorReporter.revertTx("Handler already whitelisted");
961         }
962         _;
963     }
964 
965     /// @notice Constructor
966     /// @param _tokenTransferProxy address of the TokenTransferProxy
967     /// @param _errorReporter the address of the error reporter contract
968     constructor (address _tokenTransferProxy, address _affiliateRegistry, address _errorReporter, address _defaultFeeAccount/*, address _logger*/) public {
969         /* require(_logger != address(0x0)); */
970         tokenTransferProxy = TokenTransferProxy(_tokenTransferProxy);
971         affiliateRegistry = AffiliateRegistry(_affiliateRegistry);
972         errorReporter = ErrorReporter(_errorReporter);
973         defaultFeeAccount = _defaultFeeAccount;
974         /* logger = Logger(_logger); */
975     }
976 
977     /*
978     *   Public functions
979     */
980 
981     /// @notice Update the default fee account
982     /// @dev onlyOwner modifier only allows the contract owner to run the code
983     /// @param newDefaultFeeAccount new default fee account
984     function updateDefaultFeeAccount(address newDefaultFeeAccount) public onlyOwner {
985         defaultFeeAccount = newDefaultFeeAccount;
986     }
987 
988     /// @notice Add an exchangeHandler address to the whitelist
989     /// @dev onlyOwner modifier only allows the contract owner to run the code
990     /// @param handler Address of the exchange handler which permission needs adding
991     function addHandlerToWhitelist(address handler)
992         public
993         onlyOwner
994         handlerNotWhitelisted(handler)
995     {
996         handlerWhitelistMap[handler] = true;
997         handlerWhitelistArray.push(handler);
998     }
999 
1000     /// @notice Remove an exchangeHandler address from the whitelist
1001     /// @dev onlyOwner modifier only allows the contract owner to run the code
1002     /// @param handler Address of the exchange handler which permission needs removing
1003     function removeHandlerFromWhitelist(address handler)
1004         public
1005         onlyOwner
1006         handlerWhitelisted(handler)
1007     {
1008         delete handlerWhitelistMap[handler];
1009         for (uint i = 0; i < handlerWhitelistArray.length; i++) {
1010             if (handlerWhitelistArray[i] == handler) {
1011                 handlerWhitelistArray[i] = handlerWhitelistArray[handlerWhitelistArray.length - 1];
1012                 handlerWhitelistArray.length -= 1;
1013                 break;
1014             }
1015         }
1016     }
1017 
1018     struct FeeVariables{
1019         uint256 feePercentage;
1020         Affiliate affiliate;
1021         uint256 totalFee;
1022     }
1023     /// @notice Performs the requested portfolio rebalance
1024     /// @param trades A dynamic array of trade structs
1025     function performRebalance(
1026         Trade[] memory trades,
1027         address feeAccount,
1028         bytes32 id
1029     )
1030         public
1031         payable
1032         whenNotPaused
1033     {
1034         if(!affiliateRegistry.isValidAffiliate(feeAccount)){
1035             feeAccount = defaultFeeAccount;
1036         }
1037         FeeVariables memory feeVariables = FeeVariables(0, Affiliate(feeAccount), 0);
1038         feeVariables.feePercentage  = feeVariables.affiliate.getTotalFeePercentage();
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
1052         /* logger.log("Ether balance arg2: etherBalance.", etherBalance); */
1053         uint256 totalTraded = 0;
1054         for (uint256 i; i < trades.length; i++) {
1055             Trade memory thisTrade = trades[i];
1056             TradeFlag memory thisTradeFlag = tradeFlags[i];
1057 
1058             CurrentAmounts memory amounts = CurrentAmounts({
1059                 amountSpentOnTrade: 0,
1060                 amountReceivedFromTrade: 0,
1061                 amountLeftToSpendOnTrade: thisTrade.isSell ? thisTrade.tokenAmount : calculateMaxEtherSpend(thisTrade, etherBalance, feeVariables.feePercentage)
1062             });
1063             /* logger.log("Going to perform trade. arg2: amountLeftToSpendOnTrade", amounts.amountLeftToSpendOnTrade); */
1064 
1065             performTrade(
1066                 thisTrade,
1067                 thisTradeFlag,
1068                 amounts
1069             );
1070             emit LogTrade(thisTrade.isSell, thisTrade.tokenAddress, thisTrade.isSell ? amounts.amountReceivedFromTrade:amounts.amountSpentOnTrade, thisTrade.isSell?amounts.amountSpentOnTrade:amounts.amountReceivedFromTrade);
1071 
1072             uint256 ethTraded;
1073             uint256 ethFee;
1074             if(thisTrade.isSell){
1075                 ethTraded = amounts.amountReceivedFromTrade;
1076             } else {
1077                 ethTraded = amounts.amountSpentOnTrade;
1078             }
1079             totalTraded += ethTraded;
1080             ethFee = calculateFee(ethTraded, feeVariables.feePercentage);
1081             feeVariables.totalFee = SafeMath.add(feeVariables.totalFee, ethFee);
1082             /* logger.log("Finished performing trade arg2: amountReceivedFromTrade, arg3: amountSpentOnTrade.", amounts.amountReceivedFromTrade, amounts.amountSpentOnTrade); */
1083 
1084             if (amounts.amountReceivedFromTrade == 0 && thisTrade.optionalTrade) {
1085                 /* logger.log("Received 0 from trade and this is an optional trade. Skipping."); */
1086                 continue;
1087             }
1088 
1089             /* logger.log(
1090                 "Going to check trade acceptable amounts arg2: amountSpentOnTrade, arg2: amountReceivedFromTrade.",
1091                 amounts.amountSpentOnTrade,
1092                 amounts.amountReceivedFromTrade
1093             ); */
1094 
1095             if (!checkIfTradeAmountsAcceptable(thisTrade, amounts.amountSpentOnTrade, amounts.amountReceivedFromTrade)) {
1096                 errorReporter.revertTx("Amounts spent/received in trade not acceptable");
1097             }
1098 
1099             /* logger.log("Trade passed the acceptable amounts check."); */
1100 
1101             if (thisTrade.isSell) {
1102                 /* logger.log(
1103                     "This is a sell trade, adding ether to our balance arg2: etherBalance, arg3: amountReceivedFromTrade",
1104                     etherBalance,
1105                     amounts.amountReceivedFromTrade
1106                 ); */
1107                 etherBalance = SafeMath.sub(SafeMath.add(etherBalance, ethTraded), ethFee);
1108             } else {
1109                 /* logger.log(
1110                     "This is a buy trade, deducting ether from our balance arg2: etherBalance, arg3: amountSpentOnTrade",
1111                     etherBalance,
1112                     amounts.amountSpentOnTrade
1113                 ); */
1114                 etherBalance = SafeMath.sub(SafeMath.sub(etherBalance, ethTraded), ethFee);
1115             }
1116 
1117             /* logger.log("Transferring tokens to the user arg:6 tokenAddress.", 0,0,0,0, thisTrade.tokenAddress); */
1118 
1119             transferTokensToUser(
1120                 thisTrade.tokenAddress,
1121                 thisTrade.isSell ? amounts.amountLeftToSpendOnTrade : amounts.amountReceivedFromTrade
1122             );
1123 
1124         }
1125         emit LogRebalance(id, totalTraded, feeVariables.totalFee, feeAccount);
1126         if(feeVariables.totalFee > 0){
1127             feeAccount.transfer(feeVariables.totalFee);
1128         }
1129         if(etherBalance > 0) {
1130             /* logger.log("Got a positive ether balance, sending to the user arg2: etherBalance.", etherBalance); */
1131             msg.sender.transfer(etherBalance);
1132         }
1133     }
1134 
1135     /// @notice Performs static checks on the rebalance payload before execution
1136     /// @dev This function is public so a rebalance can be checked before performing a rebalance
1137     /// @param trades A dynamic array of trade structs
1138     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1139     function staticChecks(
1140         Trade[] trades,
1141         TradeFlag[] tradeFlags
1142     )
1143         public
1144         view
1145         whenNotPaused
1146     {
1147         bool previousBuyOccured = false;
1148 
1149         for (uint256 i; i < trades.length; i++) {
1150             Trade memory thisTrade = trades[i];
1151             if (thisTrade.isSell) {
1152                 if (previousBuyOccured) {
1153                     errorReporter.revertTx("A buy has occured before this sell");
1154                 }
1155 
1156                 if (!Utils.tokenAllowanceAndBalanceSet(msg.sender, thisTrade.tokenAddress, thisTrade.tokenAmount, address(tokenTransferProxy))) {
1157                     if (!thisTrade.optionalTrade) {
1158                         errorReporter.revertTx("Taker has not sent allowance/balance on a non-optional trade");
1159                     }
1160                     /* logger.log(
1161                         "Attempt to sell a token without allowance or sufficient balance arg2: tokenAmount, arg6: tokenAddress . Otional trade, ignoring.",
1162                         thisTrade.tokenAmount,
1163                         0,
1164                         0,
1165                         0,
1166                         thisTrade.tokenAddress
1167                     ); */
1168                     tradeFlags[i].ignoreTrade = true;
1169                     continue;
1170                 }
1171             } else {
1172                 previousBuyOccured = true;
1173             }
1174 
1175             /* logger.log("Checking that all the handlers are whitelisted."); */
1176             for (uint256 j; j < thisTrade.orders.length; j++) {
1177                 Order memory thisOrder = thisTrade.orders[j];
1178                 if ( !handlerWhitelistMap[thisOrder.exchangeHandler] ) {
1179                     /* logger.log(
1180                         "Trying to use a handler that is not whitelisted arg6: exchangeHandler.",
1181                         0,
1182                         0,
1183                         0,
1184                         0,
1185                         thisOrder.exchangeHandler
1186                     ); */
1187                     tradeFlags[i].ignoreOrder[j] = true;
1188                     continue;
1189                 }
1190             }
1191         }
1192     }
1193 
1194     /*
1195     *   Internal functions
1196     */
1197 
1198     /// @notice Initialises the trade flag struct
1199     /// @param trades the trades used to initialise the flags
1200     /// @return tradeFlags the initialised flags
1201     function initialiseTradeFlags(Trade[] trades)
1202         internal
1203         returns (TradeFlag[])
1204     {
1205         /* logger.log("Initializing trade flags."); */
1206         TradeFlag[] memory tradeFlags = new TradeFlag[](trades.length);
1207         for (uint256 i = 0; i < trades.length; i++) {
1208             tradeFlags[i].ignoreOrder = new bool[](trades[i].orders.length);
1209         }
1210         return tradeFlags;
1211     }
1212 
1213     /// @notice Transfers the given amount of tokens back to the msg.sender
1214     /// @param tokenAddress the address of the token to transfer
1215     /// @param tokenAmount the amount of tokens to transfer
1216     function transferTokensToUser(
1217         address tokenAddress,
1218         uint256 tokenAmount
1219     )
1220         internal
1221     {
1222         /* logger.log("Transfering tokens to the user arg2: tokenAmount, arg6: .tokenAddress", tokenAmount, 0, 0, 0, tokenAddress); */
1223         if (tokenAmount > 0) {
1224             if (!ERC20SafeTransfer.safeTransfer(tokenAddress, msg.sender, tokenAmount)) {
1225                 errorReporter.revertTx("Unable to transfer tokens to user");
1226             }
1227         }
1228     }
1229 
1230     /// @notice Executes the given trade
1231     /// @param trade a struct containing information about the trade
1232     /// @param tradeFlag a struct containing trade status information
1233     /// @param amounts a struct containing information about amounts spent
1234     /// and received in the rebalance
1235     function performTrade(
1236         Trade memory trade,
1237         TradeFlag memory tradeFlag,
1238         CurrentAmounts amounts
1239     )
1240         internal
1241     {
1242         /* logger.log("Performing trade"); */
1243 
1244         for (uint256 j; j < trade.orders.length; j++) {
1245 
1246             if(amounts.amountLeftToSpendOnTrade * 10000 < (amounts.amountSpentOnTrade + amounts.amountLeftToSpendOnTrade)){
1247                 return;
1248             }
1249 
1250             if((trade.isSell ? amounts.amountSpentOnTrade : amounts.amountReceivedFromTrade) >= trade.tokenAmount ) {
1251                 return;
1252             }
1253 
1254             if (tradeFlag.ignoreOrder[j] || amounts.amountLeftToSpendOnTrade == 0) {
1255                 /* logger.log(
1256                     "Order ignore flag is set to true or have nothing left to spend arg2: amountLeftToSpendOnTrade",
1257                     amounts.amountLeftToSpendOnTrade
1258                 ); */
1259                 continue;
1260             }
1261 
1262             uint256 amountSpentOnOrder = 0;
1263             uint256 amountReceivedFromOrder = 0;
1264 
1265             Order memory thisOrder = trade.orders[j];
1266 
1267             /* logger.log("Setting order exchange handler arg6: exchangeHandler.", 0, 0, 0, 0, thisOrder.exchangeHandler); */
1268             ExchangeHandler thisHandler = ExchangeHandler(thisOrder.exchangeHandler);
1269 
1270             uint256 amountToGiveForOrder = Utils.min(
1271                 thisHandler.getAmountToGive(thisOrder.genericPayload),
1272                 amounts.amountLeftToSpendOnTrade
1273             );
1274 
1275             if (amountToGiveForOrder == 0) {
1276                 /* logger.log(
1277                     "MASSIVE ERROR: amountToGiveForOrder was found to be 0, this hasn't been caught in preTradeChecks, which means dynamicExchangeChecks isnt written correctly!"
1278                 ); */
1279                 continue;
1280             }
1281 
1282             /* logger.log(
1283                 "Calculating amountToGiveForOrder arg2: amountToGiveForOrder, arg3: amountLeftToSpendOnTrade.",
1284                 amountToGiveForOrder,
1285                 amounts.amountLeftToSpendOnTrade
1286             ); */
1287 
1288             if( !thisHandler.staticExchangeChecks(thisOrder.genericPayload) ) {
1289                 /* logger.log("Order did not pass checks, skipping."); */
1290                 continue;
1291             }
1292 
1293             if (trade.isSell) {
1294                 /* logger.log("This is a sell.."); */
1295                 if (!ERC20SafeTransfer.safeTransfer(trade.tokenAddress,address(thisHandler), amountToGiveForOrder)) {
1296                     if( !trade.optionalTrade ) errorReporter.revertTx("Unable to transfer tokens to handler");
1297                     else {
1298                         /* logger.log("Unable to transfer tokens to handler but the trade is optional"); */
1299                         return;
1300                     }
1301                 }
1302 
1303                 /* logger.log("Going to perform a sell order."); */
1304                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performSellOrder(thisOrder.genericPayload, amountToGiveForOrder);
1305                 /* logger.log("Sell order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1306             } else {
1307                 /* logger.log("Going to perform a buy order."); */
1308                 (amountSpentOnOrder, amountReceivedFromOrder) = thisHandler.performBuyOrder.value(amountToGiveForOrder)(thisOrder.genericPayload, amountToGiveForOrder);
1309                 /* logger.log("Buy order performed arg2: amountSpentOnOrder, arg3: amountReceivedFromOrder", amountSpentOnOrder, amountReceivedFromOrder); */
1310             }
1311 
1312 
1313             if (amountReceivedFromOrder > 0) {
1314                 amounts.amountLeftToSpendOnTrade = SafeMath.sub(amounts.amountLeftToSpendOnTrade, amountSpentOnOrder);
1315                 amounts.amountSpentOnTrade = SafeMath.add(amounts.amountSpentOnTrade, amountSpentOnOrder);
1316                 amounts.amountReceivedFromTrade = SafeMath.add(amounts.amountReceivedFromTrade, amountReceivedFromOrder);
1317 
1318                 /* logger.log(
1319                     "Updated amounts arg2: amountLeftToSpendOnTrade, arg3: amountSpentOnTrade, arg4: amountReceivedFromTrade.",
1320                     amounts.amountLeftToSpendOnTrade,
1321                     amounts.amountSpentOnTrade,
1322                     amounts.amountReceivedFromTrade
1323                 ); */
1324             }
1325         }
1326 
1327     }
1328 
1329     /// @notice Check if the amounts spent and gained on a trade are within the
1330     /// user"s set limits
1331     /// @param trade contains information on the given trade
1332     /// @param amountSpentOnTrade the amount that was spent on the trade
1333     /// @param amountReceivedFromTrade the amount that was received from the trade
1334     /// @return bool whether the trade passes the checks
1335     function checkIfTradeAmountsAcceptable(
1336         Trade trade,
1337         uint256 amountSpentOnTrade,
1338         uint256 amountReceivedFromTrade
1339     )
1340         internal
1341         view
1342         returns (bool passed)
1343     {
1344         /* logger.log("Checking if trade amounts are acceptable."); */
1345         uint256 tokenAmount = trade.isSell ? amountSpentOnTrade : amountReceivedFromTrade;
1346         passed = tokenAmount >= trade.minimumAcceptableTokenAmount;
1347 
1348         /*if( !passed ) {
1349              logger.log(
1350                 "Received less than minimum acceptable tokens arg2: tokenAmount , arg3: minimumAcceptableTokenAmount.",
1351                 tokenAmount,
1352                 trade.minimumAcceptableTokenAmount
1353             );
1354         }*/
1355 
1356         if (passed) {
1357             uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1358             uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1359             uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1360             uint256 actualRate = Utils.calcRateFromQty(amountSpentOnTrade, amountReceivedFromTrade, srcDecimals, destDecimals);
1361             passed = actualRate >= trade.minimumExchangeRate;
1362         }
1363 
1364         /*if( !passed ) {
1365              logger.log(
1366                 "Order rate was lower than minimum acceptable,  rate arg2: actualRate, arg3: minimumExchangeRate.",
1367                 actualRate,
1368                 trade.minimumExchangeRate
1369             );
1370         }*/
1371     }
1372 
1373     /// @notice Iterates through a list of token orders, transfer the SELL orders to this contract & calculates if we have the ether needed
1374     /// @param trades A dynamic array of trade structs
1375     /// @param tradeFlags A dynamic array of flags indicating trade and order status
1376     function transferTokens(Trade[] trades, TradeFlag[] tradeFlags) internal {
1377         for (uint256 i = 0; i < trades.length; i++) {
1378             if (trades[i].isSell && !tradeFlags[i].ignoreTrade) {
1379 
1380                 /* logger.log(
1381                     "Transfering tokens arg2: tokenAmount, arg5: tokenAddress.",
1382                     trades[i].tokenAmount,
1383                     0,
1384                     0,
1385                     0,
1386                     trades[i].tokenAddress
1387                 ); */
1388                 if (
1389                     !tokenTransferProxy.transferFrom(
1390                         trades[i].tokenAddress,
1391                         msg.sender,
1392                         address(this),
1393                         trades[i].tokenAmount
1394                     )
1395                 ) {
1396                     errorReporter.revertTx("TTP unable to transfer tokens to primary");
1397                 }
1398            }
1399         }
1400     }
1401 
1402     /// @notice Calculates the maximum amount that should be spent on a given buy trade
1403     /// @param trade the buy trade to return the spend amount for
1404     /// @param etherBalance the amount of ether that we currently have to spend
1405     /// @return uint256 the maximum amount of ether we should spend on this trade
1406     function calculateMaxEtherSpend(Trade trade, uint256 etherBalance, uint256 feePercentage) internal view returns (uint256) {
1407         /// @dev This function should never be called for a sell
1408         assert(!trade.isSell);
1409 
1410         uint256 tokenDecimals = Utils.getDecimals(ERC20(trade.tokenAddress));
1411         uint256 srcDecimals = trade.isSell ? tokenDecimals : Utils.eth_decimals();
1412         uint256 destDecimals = trade.isSell ? Utils.eth_decimals() : tokenDecimals;
1413         uint256 maxSpendAtMinRate = Utils.calcSrcQty(trade.tokenAmount, srcDecimals, destDecimals, trade.minimumExchangeRate);
1414 
1415         return Utils.min(removeFee(etherBalance, feePercentage), maxSpendAtMinRate);
1416     }
1417 
1418     // @notice Calculates the fee amount given a fee percentage and amount
1419     // @param amount the amount to calculate the fee based on
1420     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1421     function calculateFee(uint256 amount, uint256 fee) internal view returns (uint256){
1422         return SafeMath.div(SafeMath.mul(amount, fee), 1 ether);
1423     }
1424 
1425     // @notice Calculates the cost if amount=cost+fee
1426     // @param amount the amount to calculate the base on
1427     // @param fee the percentage, out of 1 eth (e.g. 0.01 ETH would be 1%)
1428     function removeFee(uint256 amount, uint256 fee) internal view returns (uint256){
1429         return SafeMath.div(SafeMath.mul(amount, 1 ether), SafeMath.add(fee, 1 ether));
1430     }
1431     /*
1432     *   Payable fallback function
1433     */
1434 
1435     /// @notice payable fallback to allow handler or exchange contracts to return ether
1436     /// @dev only accounts containing code (ie. contracts) can send ether to this contract
1437     function() public payable whenNotPaused {
1438         // Check in here that the sender is a contract! (to stop accidents)
1439         uint256 size;
1440         address sender = msg.sender;
1441         assembly {
1442             size := extcodesize(sender)
1443         }
1444         if (size == 0) {
1445             errorReporter.revertTx("EOA cannot send ether to primary fallback");
1446         }
1447     }
1448 }