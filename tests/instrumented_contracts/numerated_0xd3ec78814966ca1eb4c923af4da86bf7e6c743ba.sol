1 // File: contracts/token/interfaces/IERC20Token.sol
2 
3 pragma solidity 0.4.26;
4 
5 /*
6     ERC20 Standard Token interface
7 */
8 contract IERC20Token {
9     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
10     function name() public view returns (string) {this;}
11     function symbol() public view returns (string) {this;}
12     function decimals() public view returns (uint8) {this;}
13     function totalSupply() public view returns (uint256) {this;}
14     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
15     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
16 
17     function transfer(address _to, uint256 _value) public returns (bool success);
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19     function approve(address _spender, uint256 _value) public returns (bool success);
20 }
21 
22 // File: contracts/utility/interfaces/IWhitelist.sol
23 
24 pragma solidity 0.4.26;
25 
26 /*
27     Whitelist interface
28 */
29 contract IWhitelist {
30     function isWhitelisted(address _address) public view returns (bool);
31 }
32 
33 // File: contracts/converter/interfaces/IBancorConverter.sol
34 
35 pragma solidity 0.4.26;
36 
37 
38 
39 /*
40     Bancor Converter interface
41 */
42 contract IBancorConverter {
43     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
44     function convert2(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public returns (uint256);
45     function quickConvert2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public payable returns (uint256);
46     function conversionsEnabled() public view returns (bool) {this;}
47     function conversionWhitelist() public view returns (IWhitelist) {this;}
48     function conversionFee() public view returns (uint32) {this;}
49     function reserves(address _address) public view returns (uint256, uint32, bool, bool, bool) {_address; this;}
50     function getReserveBalance(IERC20Token _reserveToken) public view returns (uint256);
51     function reserveTokens(uint256 _index) public view returns (IERC20Token) {_index; this;}
52     // deprecated, backward compatibility
53     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
54     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
55     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
56     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool);
57     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
58     function connectorTokens(uint256 _index) public view returns (IERC20Token);
59     function connectorTokenCount() public view returns (uint16);
60 }
61 
62 // File: contracts/converter/interfaces/IBancorConverterUpgrader.sol
63 
64 pragma solidity 0.4.26;
65 
66 
67 /*
68     Bancor Converter Upgrader interface
69 */
70 contract IBancorConverterUpgrader {
71     function upgrade(bytes32 _version) public;
72     function upgrade(uint16 _version) public;
73 }
74 
75 // File: contracts/converter/interfaces/IBancorFormula.sol
76 
77 pragma solidity 0.4.26;
78 
79 /*
80     Bancor Formula interface
81 */
82 contract IBancorFormula {
83     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public view returns (uint256);
84     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public view returns (uint256);
85     function calculateCrossReserveReturn(uint256 _fromReserveBalance, uint32 _fromReserveRatio, uint256 _toReserveBalance, uint32 _toReserveRatio, uint256 _amount) public view returns (uint256);
86     function calculateFundCost(uint256 _supply, uint256 _reserveBalance, uint32 _totalRatio, uint256 _amount) public view returns (uint256);
87     function calculateLiquidateReturn(uint256 _supply, uint256 _reserveBalance, uint32 _totalRatio, uint256 _amount) public view returns (uint256);
88     // deprecated, backward compatibility
89     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
90 }
91 
92 // File: contracts/IBancorNetwork.sol
93 
94 pragma solidity 0.4.26;
95 
96 
97 /*
98     Bancor Network interface
99 */
100 contract IBancorNetwork {
101     function convert2(
102         IERC20Token[] _path,
103         uint256 _amount,
104         uint256 _minReturn,
105         address _affiliateAccount,
106         uint256 _affiliateFee
107     ) public payable returns (uint256);
108 
109     function claimAndConvert2(
110         IERC20Token[] _path,
111         uint256 _amount,
112         uint256 _minReturn,
113         address _affiliateAccount,
114         uint256 _affiliateFee
115     ) public returns (uint256);
116 
117     function convertFor2(
118         IERC20Token[] _path,
119         uint256 _amount,
120         uint256 _minReturn,
121         address _for,
122         address _affiliateAccount,
123         uint256 _affiliateFee
124     ) public payable returns (uint256);
125 
126     function claimAndConvertFor2(
127         IERC20Token[] _path,
128         uint256 _amount,
129         uint256 _minReturn,
130         address _for,
131         address _affiliateAccount,
132         uint256 _affiliateFee
133     ) public returns (uint256);
134 
135     function convertForPrioritized4(
136         IERC20Token[] _path,
137         uint256 _amount,
138         uint256 _minReturn,
139         address _for,
140         uint256[] memory _signature,
141         address _affiliateAccount,
142         uint256 _affiliateFee
143     ) public payable returns (uint256);
144 
145     // deprecated, backward compatibility
146     function convert(
147         IERC20Token[] _path,
148         uint256 _amount,
149         uint256 _minReturn
150     ) public payable returns (uint256);
151 
152     // deprecated, backward compatibility
153     function claimAndConvert(
154         IERC20Token[] _path,
155         uint256 _amount,
156         uint256 _minReturn
157     ) public returns (uint256);
158 
159     // deprecated, backward compatibility
160     function convertFor(
161         IERC20Token[] _path,
162         uint256 _amount,
163         uint256 _minReturn,
164         address _for
165     ) public payable returns (uint256);
166 
167     // deprecated, backward compatibility
168     function claimAndConvertFor(
169         IERC20Token[] _path,
170         uint256 _amount,
171         uint256 _minReturn,
172         address _for
173     ) public returns (uint256);
174 
175     // deprecated, backward compatibility
176     function convertForPrioritized3(
177         IERC20Token[] _path,
178         uint256 _amount,
179         uint256 _minReturn,
180         address _for,
181         uint256 _customVal,
182         uint256 _block,
183         uint8 _v,
184         bytes32 _r,
185         bytes32 _s
186     ) public payable returns (uint256);
187 
188     // deprecated, backward compatibility
189     function convertForPrioritized2(
190         IERC20Token[] _path,
191         uint256 _amount,
192         uint256 _minReturn,
193         address _for,
194         uint256 _block,
195         uint8 _v,
196         bytes32 _r,
197         bytes32 _s
198     ) public payable returns (uint256);
199 
200     // deprecated, backward compatibility
201     function convertForPrioritized(
202         IERC20Token[] _path,
203         uint256 _amount,
204         uint256 _minReturn,
205         address _for,
206         uint256 _block,
207         uint256 _nonce,
208         uint8 _v,
209         bytes32 _r,
210         bytes32 _s
211     ) public payable returns (uint256);
212 }
213 
214 // File: contracts/FeatureIds.sol
215 
216 pragma solidity 0.4.26;
217 
218 /**
219   * @dev Id definitions for bancor contract features
220   * 
221   * Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
222 */
223 contract FeatureIds {
224     // converter features
225     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
226 }
227 
228 // File: contracts/utility/interfaces/IOwned.sol
229 
230 pragma solidity 0.4.26;
231 
232 /*
233     Owned contract interface
234 */
235 contract IOwned {
236     // this function isn't abstract since the compiler emits automatically generated getter functions as external
237     function owner() public view returns (address) {this;}
238 
239     function transferOwnership(address _newOwner) public;
240     function acceptOwnership() public;
241 }
242 
243 // File: contracts/utility/Owned.sol
244 
245 pragma solidity 0.4.26;
246 
247 
248 /**
249   * @dev Provides support and utilities for contract ownership
250 */
251 contract Owned is IOwned {
252     address public owner;
253     address public newOwner;
254 
255     /**
256       * @dev triggered when the owner is updated
257       * 
258       * @param _prevOwner previous owner
259       * @param _newOwner  new owner
260     */
261     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
262 
263     /**
264       * @dev initializes a new Owned instance
265     */
266     constructor() public {
267         owner = msg.sender;
268     }
269 
270     // allows execution by the owner only
271     modifier ownerOnly {
272         require(msg.sender == owner);
273         _;
274     }
275 
276     /**
277       * @dev allows transferring the contract ownership
278       * the new owner still needs to accept the transfer
279       * can only be called by the contract owner
280       * 
281       * @param _newOwner    new contract owner
282     */
283     function transferOwnership(address _newOwner) public ownerOnly {
284         require(_newOwner != owner);
285         newOwner = _newOwner;
286     }
287 
288     /**
289       * @dev used by a new owner to accept an ownership transfer
290     */
291     function acceptOwnership() public {
292         require(msg.sender == newOwner);
293         emit OwnerUpdate(owner, newOwner);
294         owner = newOwner;
295         newOwner = address(0);
296     }
297 }
298 
299 // File: contracts/utility/Managed.sol
300 
301 pragma solidity 0.4.26;
302 
303 
304 /**
305   * @dev Provides support and utilities for contract management
306   * Note that a managed contract must also have an owner
307 */
308 contract Managed is Owned {
309     address public manager;
310     address public newManager;
311 
312     /**
313       * @dev triggered when the manager is updated
314       * 
315       * @param _prevManager previous manager
316       * @param _newManager  new manager
317     */
318     event ManagerUpdate(address indexed _prevManager, address indexed _newManager);
319 
320     /**
321       * @dev initializes a new Managed instance
322     */
323     constructor() public {
324         manager = msg.sender;
325     }
326 
327     // allows execution by the manager only
328     modifier managerOnly {
329         assert(msg.sender == manager);
330         _;
331     }
332 
333     // allows execution by either the owner or the manager only
334     modifier ownerOrManagerOnly {
335         require(msg.sender == owner || msg.sender == manager);
336         _;
337     }
338 
339     /**
340       * @dev allows transferring the contract management
341       * the new manager still needs to accept the transfer
342       * can only be called by the contract manager
343       * 
344       * @param _newManager    new contract manager
345     */
346     function transferManagement(address _newManager) public ownerOrManagerOnly {
347         require(_newManager != manager);
348         newManager = _newManager;
349     }
350 
351     /**
352       * @dev used by a new manager to accept a management transfer
353     */
354     function acceptManagement() public {
355         require(msg.sender == newManager);
356         emit ManagerUpdate(manager, newManager);
357         manager = newManager;
358         newManager = address(0);
359     }
360 }
361 
362 // File: contracts/utility/SafeMath.sol
363 
364 pragma solidity 0.4.26;
365 
366 /**
367   * @dev Library for basic math operations with overflow/underflow protection
368 */
369 library SafeMath {
370     /**
371       * @dev returns the sum of _x and _y, reverts if the calculation overflows
372       * 
373       * @param _x   value 1
374       * @param _y   value 2
375       * 
376       * @return sum
377     */
378     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
379         uint256 z = _x + _y;
380         require(z >= _x);
381         return z;
382     }
383 
384     /**
385       * @dev returns the difference of _x minus _y, reverts if the calculation underflows
386       * 
387       * @param _x   minuend
388       * @param _y   subtrahend
389       * 
390       * @return difference
391     */
392     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
393         require(_x >= _y);
394         return _x - _y;
395     }
396 
397     /**
398       * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
399       * 
400       * @param _x   factor 1
401       * @param _y   factor 2
402       * 
403       * @return product
404     */
405     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
406         // gas optimization
407         if (_x == 0)
408             return 0;
409 
410         uint256 z = _x * _y;
411         require(z / _x == _y);
412         return z;
413     }
414 
415       /**
416         * ev Integer division of two numbers truncating the quotient, reverts on division by zero.
417         * 
418         * aram _x   dividend
419         * aram _y   divisor
420         * 
421         * eturn quotient
422     */
423     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
424         require(_y > 0);
425         uint256 c = _x / _y;
426 
427         return c;
428     }
429 }
430 
431 // File: contracts/utility/Utils.sol
432 
433 pragma solidity 0.4.26;
434 
435 /**
436   * @dev Utilities & Common Modifiers
437 */
438 contract Utils {
439     /**
440       * constructor
441     */
442     constructor() public {
443     }
444 
445     // verifies that an amount is greater than zero
446     modifier greaterThanZero(uint256 _amount) {
447         require(_amount > 0);
448         _;
449     }
450 
451     // validates an address - currently only checks that it isn't null
452     modifier validAddress(address _address) {
453         require(_address != address(0));
454         _;
455     }
456 
457     // verifies that the address is different than this contract address
458     modifier notThis(address _address) {
459         require(_address != address(this));
460         _;
461     }
462 
463 }
464 
465 // File: contracts/utility/interfaces/IContractRegistry.sol
466 
467 pragma solidity 0.4.26;
468 
469 /*
470     Contract Registry interface
471 */
472 contract IContractRegistry {
473     function addressOf(bytes32 _contractName) public view returns (address);
474 
475     // deprecated, backward compatibility
476     function getAddress(bytes32 _contractName) public view returns (address);
477 }
478 
479 // File: contracts/utility/ContractRegistryClient.sol
480 
481 pragma solidity 0.4.26;
482 
483 
484 
485 
486 /**
487   * @dev Base contract for ContractRegistry clients
488 */
489 contract ContractRegistryClient is Owned, Utils {
490     bytes32 internal constant CONTRACT_FEATURES = "ContractFeatures";
491     bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
492     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
493     bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
494     bytes32 internal constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
495     bytes32 internal constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
496     bytes32 internal constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
497     bytes32 internal constant BANCOR_CONVERTER_REGISTRY = "BancorConverterRegistry";
498     bytes32 internal constant BANCOR_CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
499     bytes32 internal constant BNT_TOKEN = "BNTToken";
500     bytes32 internal constant BANCOR_X = "BancorX";
501     bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
502 
503     IContractRegistry public registry;      // address of the current contract-registry
504     IContractRegistry public prevRegistry;  // address of the previous contract-registry
505     bool public adminOnly;                  // only an administrator can update the contract-registry
506 
507     /**
508       * @dev verifies that the caller is mapped to the given contract name
509       * 
510       * @param _contractName    contract name
511     */
512     modifier only(bytes32 _contractName) {
513         require(msg.sender == addressOf(_contractName));
514         _;
515     }
516 
517     /**
518       * @dev initializes a new ContractRegistryClient instance
519       * 
520       * @param  _registry   address of a contract-registry contract
521     */
522     constructor(IContractRegistry _registry) internal validAddress(_registry) {
523         registry = IContractRegistry(_registry);
524         prevRegistry = IContractRegistry(_registry);
525     }
526 
527     /**
528       * @dev updates to the new contract-registry
529      */
530     function updateRegistry() public {
531         // verify that this function is permitted
532         require(!adminOnly || isAdmin());
533 
534         // get the new contract-registry
535         address newRegistry = addressOf(CONTRACT_REGISTRY);
536 
537         // verify that the new contract-registry is different and not zero
538         require(newRegistry != address(registry) && newRegistry != address(0));
539 
540         // verify that the new contract-registry is pointing to a non-zero contract-registry
541         require(IContractRegistry(newRegistry).addressOf(CONTRACT_REGISTRY) != address(0));
542 
543         // save a backup of the current contract-registry before replacing it
544         prevRegistry = registry;
545 
546         // replace the current contract-registry with the new contract-registry
547         registry = IContractRegistry(newRegistry);
548     }
549 
550     /**
551       * @dev restores the previous contract-registry
552     */
553     function restoreRegistry() public {
554         // verify that this function is permitted
555         require(isAdmin());
556 
557         // restore the previous contract-registry
558         registry = prevRegistry;
559     }
560 
561     /**
562       * @dev restricts the permission to update the contract-registry
563       * 
564       * @param _adminOnly    indicates whether or not permission is restricted to administrator only
565     */
566     function restrictRegistryUpdate(bool _adminOnly) public {
567         // verify that this function is permitted
568         require(adminOnly != _adminOnly && isAdmin());
569 
570         // change the permission to update the contract-registry
571         adminOnly = _adminOnly;
572     }
573 
574     /**
575       * @dev returns whether or not the caller is an administrator
576      */
577     function isAdmin() internal view returns (bool) {
578         return msg.sender == owner;
579     }
580 
581     /**
582       * @dev returns the address associated with the given contract name
583       * 
584       * @param _contractName    contract name
585       * 
586       * @return contract address
587     */
588     function addressOf(bytes32 _contractName) internal view returns (address) {
589         return registry.addressOf(_contractName);
590     }
591 }
592 
593 // File: contracts/utility/interfaces/IContractFeatures.sol
594 
595 pragma solidity 0.4.26;
596 
597 /*
598     Contract Features interface
599 */
600 contract IContractFeatures {
601     function isSupported(address _contract, uint256 _features) public view returns (bool);
602     function enableFeatures(uint256 _features, bool _enable) public;
603 }
604 
605 // File: contracts/utility/interfaces/IAddressList.sol
606 
607 pragma solidity 0.4.26;
608 
609 /*
610     Address list interface
611 */
612 contract IAddressList {
613     mapping (address => bool) public listedAddresses;
614 }
615 
616 // File: contracts/token/interfaces/ISmartToken.sol
617 
618 pragma solidity 0.4.26;
619 
620 
621 
622 /*
623     Smart Token interface
624 */
625 contract ISmartToken is IOwned, IERC20Token {
626     function disableTransfers(bool _disable) public;
627     function issue(address _to, uint256 _amount) public;
628     function destroy(address _from, uint256 _amount) public;
629 }
630 
631 // File: contracts/token/interfaces/ISmartTokenController.sol
632 
633 pragma solidity 0.4.26;
634 
635 
636 /*
637     Smart Token Controller interface
638 */
639 contract ISmartTokenController {
640     function claimTokens(address _from, uint256 _amount) public;
641     function token() public view returns (ISmartToken) {this;}
642 }
643 
644 // File: contracts/utility/interfaces/ITokenHolder.sol
645 
646 pragma solidity 0.4.26;
647 
648 
649 
650 /*
651     Token Holder interface
652 */
653 contract ITokenHolder is IOwned {
654     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
655 }
656 
657 // File: contracts/token/interfaces/INonStandardERC20.sol
658 
659 pragma solidity 0.4.26;
660 
661 /*
662     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
663 */
664 contract INonStandardERC20 {
665     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
666     function name() public view returns (string) {this;}
667     function symbol() public view returns (string) {this;}
668     function decimals() public view returns (uint8) {this;}
669     function totalSupply() public view returns (uint256) {this;}
670     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
671     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
672 
673     function transfer(address _to, uint256 _value) public;
674     function transferFrom(address _from, address _to, uint256 _value) public;
675     function approve(address _spender, uint256 _value) public;
676 }
677 
678 // File: contracts/utility/TokenHolder.sol
679 
680 pragma solidity 0.4.26;
681 
682 
683 
684 
685 
686 
687 /**
688   * @dev We consider every contract to be a 'token holder' since it's currently not possible
689   * for a contract to deny receiving tokens.
690   * 
691   * The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
692   * the owner to send tokens that were sent to the contract by mistake back to their sender.
693   * 
694   * Note that we use the non standard ERC-20 interface which has no return value for transfer
695   * in order to support both non standard as well as standard token contracts.
696   * see https://github.com/ethereum/solidity/issues/4116
697 */
698 contract TokenHolder is ITokenHolder, Owned, Utils {
699     /**
700       * @dev initializes a new TokenHolder instance
701     */
702     constructor() public {
703     }
704 
705     /**
706       * @dev withdraws tokens held by the contract and sends them to an account
707       * can only be called by the owner
708       * 
709       * @param _token   ERC20 token contract address
710       * @param _to      account to receive the new amount
711       * @param _amount  amount to withdraw
712     */
713     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
714         public
715         ownerOnly
716         validAddress(_token)
717         validAddress(_to)
718         notThis(_to)
719     {
720         INonStandardERC20(_token).transfer(_to, _amount);
721     }
722 }
723 
724 // File: contracts/token/SmartTokenController.sol
725 
726 pragma solidity 0.4.26;
727 
728 
729 
730 
731 /**
732   * @dev The smart token controller is an upgradable part of the smart token that allows
733   * more functionality as well as fixes for bugs/exploits.
734   * Once it accepts ownership of the token, it becomes the token's sole controller
735   * that can execute any of its functions.
736   * 
737   * To upgrade the controller, ownership must be transferred to a new controller, along with
738   * any relevant data.
739   * 
740   * The smart token must be set on construction and cannot be changed afterwards.
741   * Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
742   * 
743   * Note that the controller can transfer token ownership to a new controller that
744   * doesn't allow executing any function on the token, for a trustless solution.
745   * Doing that will also remove the owner's ability to upgrade the controller.
746 */
747 contract SmartTokenController is ISmartTokenController, TokenHolder {
748     ISmartToken public token;   // Smart Token contract
749     address public bancorX;     // BancorX contract
750 
751     /**
752       * @dev initializes a new SmartTokenController instance
753       * 
754       * @param  _token      smart token governed by the controller
755     */
756     constructor(ISmartToken _token)
757         public
758         validAddress(_token)
759     {
760         token = _token;
761     }
762 
763     // ensures that the controller is the token's owner
764     modifier active() {
765         require(token.owner() == address(this));
766         _;
767     }
768 
769     // ensures that the controller is not the token's owner
770     modifier inactive() {
771         require(token.owner() != address(this));
772         _;
773     }
774 
775     /**
776       * @dev allows transferring the token ownership
777       * the new owner needs to accept the transfer
778       * can only be called by the contract owner
779       * 
780       * @param _newOwner    new token owner
781     */
782     function transferTokenOwnership(address _newOwner) public ownerOnly {
783         token.transferOwnership(_newOwner);
784     }
785 
786     /**
787       * @dev used by a new owner to accept a token ownership transfer
788       * can only be called by the contract owner
789     */
790     function acceptTokenOwnership() public ownerOnly {
791         token.acceptOwnership();
792     }
793 
794     /**
795       * @dev withdraws tokens held by the controller and sends them to an account
796       * can only be called by the owner
797       * 
798       * @param _token   ERC20 token contract address
799       * @param _to      account to receive the new amount
800       * @param _amount  amount to withdraw
801     */
802     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
803         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
804     }
805 
806     /**
807       * @dev allows the associated BancorX contract to claim tokens from any address (so that users
808       * dont have to first give allowance when calling BancorX)
809       * 
810       * @param _from      address to claim the tokens from
811       * @param _amount    the amount of tokens to claim
812      */
813     function claimTokens(address _from, uint256 _amount) public {
814         // only the associated BancorX contract may call this method
815         require(msg.sender == bancorX);
816 
817         // destroy the tokens belonging to _from, and issue the same amount to bancorX
818         token.destroy(_from, _amount);
819         token.issue(msg.sender, _amount);
820     }
821 
822     /**
823       * @dev allows the owner to set the associated BancorX contract
824       * @param _bancorX    BancorX contract
825      */
826     function setBancorX(address _bancorX) public ownerOnly {
827         bancorX = _bancorX;
828     }
829 }
830 
831 // File: contracts/token/interfaces/IEtherToken.sol
832 
833 pragma solidity 0.4.26;
834 
835 
836 
837 /*
838     Ether Token interface
839 */
840 contract IEtherToken is ITokenHolder, IERC20Token {
841     function deposit() public payable;
842     function withdraw(uint256 _amount) public;
843     function withdrawTo(address _to, uint256 _amount) public;
844 }
845 
846 // File: contracts/bancorx/interfaces/IBancorX.sol
847 
848 pragma solidity 0.4.26;
849 
850 contract IBancorX {
851     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
852     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
853 }
854 
855 // File: contracts/converter/BancorConverter.sol
856 
857 pragma solidity 0.4.26;
858 
859 
860 
861 
862 
863 
864 
865 
866 
867 
868 
869 
870 
871 
872 
873 
874 /**
875   * @dev Bancor Converter
876   * 
877   * The Bancor converter allows for conversions between a Smart Token and other ERC20 tokens and between different ERC20 tokens and themselves. 
878   * 
879   * The ERC20 reserve balance can be virtual, meaning that conversions between reserve tokens are based on the virtual balance instead of relying on the actual reserve balance.
880   * 
881   * This mechanism opens the possibility to create different financial tools (for example, lower slippage in conversions).
882   * 
883   * The converter is upgradable (just like any SmartTokenController) and all upgrades are opt-in. 
884   * 
885   * WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits or with very small numbers because of precision loss 
886   * 
887   * Open issues:
888   * - Front-running attacks are currently mitigated by the following mechanisms:
889   *     - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
890   *     - gas price limit prevents users from having control over the order of execution
891   *     - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
892   * 
893   * Other potential solutions might include a commit/reveal based schemes
894   * - Possibly add getters for the reserve fields so that the client won't need to rely on the order in the struct
895 */
896 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractRegistryClient, FeatureIds {
897     using SafeMath for uint256;
898 
899     uint32 private constant RATIO_RESOLUTION = 1000000;
900     uint64 private constant CONVERSION_FEE_RESOLUTION = 1000000;
901 
902     struct Reserve {
903         uint256 virtualBalance;         // reserve virtual balance
904         uint32 ratio;                   // reserve ratio, represented in ppm, 1-1000000
905         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
906         bool isSaleEnabled;             // is sale of the reserve token enabled, can be set by the owner
907         bool isSet;                     // used to tell if the mapping element is defined
908     }
909 
910     /**
911       * @dev version number
912     */
913     uint16 public version = 23;
914     string public converterType = 'bancor';
915 
916     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
917     IERC20Token[] public reserveTokens;                 // ERC20 standard token addresses (prior version 17, use 'connectorTokens' instead)
918     mapping (address => Reserve) public reserves;       // reserve token addresses -> reserve data (prior version 17, use 'connectors' instead)
919     uint32 private totalReserveRatio = 0;               // used to efficiently prevent increasing the total reserve ratio above 100%
920     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
921                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
922     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
923     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
924 
925     /**
926       * @dev triggered when a conversion between two tokens occurs
927       * 
928       * @param _fromToken       ERC20 token converted from
929       * @param _toToken         ERC20 token converted to
930       * @param _trader          wallet that initiated the trade
931       * @param _amount          amount converted, in fromToken
932       * @param _return          amount returned, minus conversion fee
933       * @param _conversionFee   conversion fee
934     */
935     event Conversion(
936         address indexed _fromToken,
937         address indexed _toToken,
938         address indexed _trader,
939         uint256 _amount,
940         uint256 _return,
941         int256 _conversionFee
942     );
943 
944     /**
945       * @dev triggered after a conversion with new price data
946       * 
947       * @param  _connectorToken     reserve token
948       * @param  _tokenSupply        smart token supply
949       * @param  _connectorBalance   reserve balance
950       * @param  _connectorWeight    reserve ratio
951     */
952     event PriceDataUpdate(
953         address indexed _connectorToken,
954         uint256 _tokenSupply,
955         uint256 _connectorBalance,
956         uint32 _connectorWeight
957     );
958 
959     /**
960       * @dev triggered when the conversion fee is updated
961       * 
962       * @param  _prevFee    previous fee percentage, represented in ppm
963       * @param  _newFee     new fee percentage, represented in ppm
964     */
965     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
966 
967     /**
968       * @dev triggered when conversions are enabled/disabled
969       * 
970       * @param  _conversionsEnabled true if conversions are enabled, false if not
971     */
972     event ConversionsEnable(bool _conversionsEnabled);
973 
974     /**
975       * @dev triggered when virtual balances are enabled/disabled
976       * 
977       * @param  _enabled true if virtual balances are enabled, false if not
978     */
979     event VirtualBalancesEnable(bool _enabled);
980 
981     /**
982       * @dev initializes a new BancorConverter instance
983       * 
984       * @param  _token              smart token governed by the converter
985       * @param  _registry           address of a contract registry contract
986       * @param  _maxConversionFee   maximum conversion fee, represented in ppm
987       * @param  _reserveToken       optional, initial reserve, allows defining the first reserve at deployment time
988       * @param  _reserveRatio       optional, ratio for the initial reserve
989     */
990     constructor(
991         ISmartToken _token,
992         IContractRegistry _registry,
993         uint32 _maxConversionFee,
994         IERC20Token _reserveToken,
995         uint32 _reserveRatio
996     )   ContractRegistryClient(_registry)
997         public
998         SmartTokenController(_token)
999         validConversionFee(_maxConversionFee)
1000     {
1001         IContractFeatures features = IContractFeatures(addressOf(CONTRACT_FEATURES));
1002 
1003         // initialize supported features
1004         if (features != address(0))
1005             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
1006 
1007         maxConversionFee = _maxConversionFee;
1008 
1009         if (_reserveToken != address(0))
1010             addReserve(_reserveToken, _reserveRatio);
1011     }
1012 
1013     // validates a reserve token address - verifies that the address belongs to one of the reserve tokens
1014     modifier validReserve(IERC20Token _address) {
1015         require(reserves[_address].isSet);
1016         _;
1017     }
1018 
1019     // validates conversion fee
1020     modifier validConversionFee(uint32 _conversionFee) {
1021         require(_conversionFee >= 0 && _conversionFee <= CONVERSION_FEE_RESOLUTION);
1022         _;
1023     }
1024 
1025     // validates reserve ratio
1026     modifier validReserveRatio(uint32 _ratio) {
1027         require(_ratio > 0 && _ratio <= RATIO_RESOLUTION);
1028         _;
1029     }
1030 
1031     // allows execution only when conversions aren't disabled
1032     modifier conversionsAllowed {
1033         require(conversionsEnabled);
1034         _;
1035     }
1036 
1037     // allows execution only if the total-supply of the token is greater than zero
1038     modifier totalSupplyGreaterThanZeroOnly {
1039         require(token.totalSupply() > 0);
1040         _;
1041     }
1042 
1043     // allows execution only on a multiple-reserve converter
1044     modifier multipleReservesOnly {
1045         require(reserveTokens.length > 1);
1046         _;
1047     }
1048 
1049     /**
1050       * @dev returns the number of reserve tokens defined
1051       * note that prior to version 17, you should use 'connectorTokenCount' instead
1052       * 
1053       * @return number of reserve tokens
1054     */
1055     function reserveTokenCount() public view returns (uint16) {
1056         return uint16(reserveTokens.length);
1057     }
1058 
1059     /**
1060       * @dev allows the owner to update & enable the conversion whitelist contract address
1061       * when set, only addresses that are whitelisted are actually allowed to use the converter
1062       * note that the whitelist check is actually done by the BancorNetwork contract
1063       * 
1064       * @param _whitelist    address of a whitelist contract
1065     */
1066     function setConversionWhitelist(IWhitelist _whitelist)
1067         public
1068         ownerOnly
1069         notThis(_whitelist)
1070     {
1071         conversionWhitelist = _whitelist;
1072     }
1073 
1074     /**
1075       * @dev disables the entire conversion functionality
1076       * this is a safety mechanism in case of a emergency
1077       * can only be called by the manager
1078       * 
1079       * @param _disable true to disable conversions, false to re-enable them
1080     */
1081     function disableConversions(bool _disable) public ownerOrManagerOnly {
1082         if (conversionsEnabled == _disable) {
1083             conversionsEnabled = !_disable;
1084             emit ConversionsEnable(conversionsEnabled);
1085         }
1086     }
1087 
1088     /**
1089       * @dev allows transferring the token ownership
1090       * the new owner needs to accept the transfer
1091       * can only be called by the contract owner
1092       * note that token ownership can only be transferred while the owner is the converter upgrader contract
1093       * 
1094       * @param _newOwner    new token owner
1095     */
1096     function transferTokenOwnership(address _newOwner)
1097         public
1098         ownerOnly
1099         only(BANCOR_CONVERTER_UPGRADER)
1100     {
1101         super.transferTokenOwnership(_newOwner);
1102     }
1103 
1104     /**
1105       * @dev used by a new owner to accept a token ownership transfer
1106       * can only be called by the contract owner
1107       * note that token ownership can only be accepted if its total-supply is greater than zero
1108     */
1109     function acceptTokenOwnership()
1110         public
1111         ownerOnly
1112         totalSupplyGreaterThanZeroOnly
1113     {
1114         super.acceptTokenOwnership();
1115     }
1116 
1117     /**
1118       * @dev updates the current conversion fee
1119       * can only be called by the manager
1120       * 
1121       * @param _conversionFee new conversion fee, represented in ppm
1122     */
1123     function setConversionFee(uint32 _conversionFee)
1124         public
1125         ownerOrManagerOnly
1126     {
1127         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
1128         emit ConversionFeeUpdate(conversionFee, _conversionFee);
1129         conversionFee = _conversionFee;
1130     }
1131 
1132     /**
1133       * @dev given a return amount, returns the amount minus the conversion fee
1134       * 
1135       * @param _amount      return amount
1136       * @param _magnitude   1 for standard conversion, 2 for cross reserve conversion
1137       * 
1138       * @return return amount minus conversion fee
1139     */
1140     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
1141         return _amount.mul((CONVERSION_FEE_RESOLUTION - conversionFee) ** _magnitude).div(CONVERSION_FEE_RESOLUTION ** _magnitude);
1142     }
1143 
1144     /**
1145       * @dev withdraws tokens held by the converter and sends them to an account
1146       * can only be called by the owner
1147       * note that reserve tokens can only be withdrawn by the owner while the converter is inactive
1148       * unless the owner is the converter upgrader contract
1149       * 
1150       * @param _token   ERC20 token contract address
1151       * @param _to      account to receive the new amount
1152       * @param _amount  amount to withdraw
1153     */
1154     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public {
1155         address converterUpgrader = addressOf(BANCOR_CONVERTER_UPGRADER);
1156 
1157         // if the token is not a reserve token, allow withdrawal
1158         // otherwise verify that the converter is inactive or that the owner is the upgrader contract
1159         require(!reserves[_token].isSet || token.owner() != address(this) || owner == converterUpgrader);
1160         super.withdrawTokens(_token, _to, _amount);
1161     }
1162 
1163     /**
1164       * @dev upgrades the converter to the latest version
1165       * can only be called by the owner
1166       * note that the owner needs to call acceptOwnership/acceptManagement on the new converter after the upgrade
1167     */
1168     function upgrade() public ownerOnly {
1169         IBancorConverterUpgrader converterUpgrader = IBancorConverterUpgrader(addressOf(BANCOR_CONVERTER_UPGRADER));
1170 
1171         transferOwnership(converterUpgrader);
1172         converterUpgrader.upgrade(version);
1173         acceptOwnership();
1174     }
1175 
1176     /**
1177       * @dev defines a new reserve for the token
1178       * can only be called by the owner while the converter is inactive
1179       * note that prior to version 17, you should use 'addConnector' instead
1180       * 
1181       * @param _token                  address of the reserve token
1182       * @param _ratio                  constant reserve ratio, represented in ppm, 1-1000000
1183     */
1184     function addReserve(IERC20Token _token, uint32 _ratio)
1185         public
1186         ownerOnly
1187         inactive
1188         validAddress(_token)
1189         notThis(_token)
1190         validReserveRatio(_ratio)
1191     {
1192         require(_token != token && !reserves[_token].isSet && totalReserveRatio + _ratio <= RATIO_RESOLUTION); // validate input
1193 
1194         reserves[_token].ratio = _ratio;
1195         reserves[_token].isVirtualBalanceEnabled = false;
1196         reserves[_token].virtualBalance = 0;
1197         reserves[_token].isSaleEnabled = true;
1198         reserves[_token].isSet = true;
1199         reserveTokens.push(_token);
1200         totalReserveRatio += _ratio;
1201     }
1202 
1203     /**
1204       * @dev updates a reserve's virtual balance
1205       * only used during an upgrade process
1206       * can only be called by the contract owner while the owner is the converter upgrader contract
1207       * note that prior to version 17, you should use 'updateConnector' instead
1208       * 
1209       * @param _reserveToken    address of the reserve token
1210       * @param _virtualBalance  new reserve virtual balance, or 0 to disable virtual balance
1211     */
1212     function updateReserveVirtualBalance(IERC20Token _reserveToken, uint256 _virtualBalance)
1213         public
1214         ownerOnly
1215         only(BANCOR_CONVERTER_UPGRADER)
1216         validReserve(_reserveToken)
1217     {
1218         Reserve storage reserve = reserves[_reserveToken];
1219         reserve.isVirtualBalanceEnabled = _virtualBalance != 0;
1220         reserve.virtualBalance = _virtualBalance;
1221     }
1222 
1223     /**
1224       * @dev enables virtual balance for the reserves
1225       * virtual balance only affects conversions between reserve tokens
1226       * virtual balance of all reserves can only scale by the same factor, to keep the ratio between them the same
1227       * note that the balance is determined during the execution of this function and set statically -
1228       * meaning that it's not calculated dynamically based on the factor after each conversion
1229       * can only be called by the contract owner while the converter is active
1230       * 
1231       * @param _scaleFactor  percentage, 100-1000 (100 = no virtual balance, 1000 = virtual balance = actual balance * 10)
1232     */
1233     function enableVirtualBalances(uint16 _scaleFactor)
1234         public
1235         ownerOnly
1236         active
1237     {
1238         // validate input
1239         require(_scaleFactor >= 100 && _scaleFactor <= 1000);
1240         bool enable = _scaleFactor != 100;
1241 
1242         // iterate through the reserves and scale their balance by the ratio provided,
1243         // or disable virtual balance altogether if a factor of 100% is passed in
1244         IERC20Token reserveToken;
1245         for (uint16 i = 0; i < reserveTokens.length; i++) {
1246             reserveToken = reserveTokens[i];
1247             Reserve storage reserve = reserves[reserveToken];
1248             reserve.isVirtualBalanceEnabled = enable;
1249             reserve.virtualBalance = enable ? reserveToken.balanceOf(this).mul(_scaleFactor).div(100) : 0;
1250         }
1251 
1252         emit VirtualBalancesEnable(enable);
1253     }
1254 
1255     /**
1256       * @dev disables converting from the given reserve token in case the reserve token got compromised
1257       * can only be called by the owner
1258       * note that converting to the token is still enabled regardless of this flag and it cannot be disabled by the owner
1259       * note that prior to version 17, you should use 'disableConnectorSale' instead
1260       * 
1261       * @param _reserveToken    reserve token contract address
1262       * @param _disable         true to disable the token, false to re-enable it
1263     */
1264     function disableReserveSale(IERC20Token _reserveToken, bool _disable)
1265         public
1266         ownerOnly
1267         validReserve(_reserveToken)
1268     {
1269         reserves[_reserveToken].isSaleEnabled = !_disable;
1270     }
1271 
1272     /**
1273       * @dev returns the reserve's ratio
1274       * added in version 22
1275       * 
1276       * @param _reserveToken    reserve token contract address
1277       * 
1278       * @return reserve ratio
1279     */
1280     function getReserveRatio(IERC20Token _reserveToken)
1281         public
1282         view
1283         validReserve(_reserveToken)
1284         returns (uint256)
1285     {
1286         return reserves[_reserveToken].ratio;
1287     }
1288 
1289     /**
1290       * @dev returns the reserve's virtual balance if one is defined, otherwise returns the actual balance
1291       * note that prior to version 17, you should use 'getConnectorBalance' instead
1292       * 
1293       * @param _reserveToken    reserve token contract address
1294       * 
1295       * @return reserve balance
1296     */
1297     function getReserveBalance(IERC20Token _reserveToken)
1298         public
1299         view
1300         validReserve(_reserveToken)
1301         returns (uint256)
1302     {
1303         Reserve storage reserve = reserves[_reserveToken];
1304         return reserve.isVirtualBalanceEnabled ? reserve.virtualBalance : _reserveToken.balanceOf(this);
1305     }
1306 
1307     /**
1308       * @dev calculates the expected return of converting a given amount of tokens
1309       * 
1310       * @param _fromToken  contract address of the token to convert from
1311       * @param _toToken    contract address of the token to convert to
1312       * @param _amount     amount of tokens received from the user
1313       * 
1314       * @return amount of tokens that the user will receive
1315       * @return amount of tokens that the user will pay as fee
1316     */
1317     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256) {
1318         require(_fromToken != _toToken); // validate input
1319 
1320         // conversion between the token and one of its reserves
1321         if (_toToken == token)
1322             return getPurchaseReturn(_fromToken, _amount);
1323         else if (_fromToken == token)
1324             return getSaleReturn(_toToken, _amount);
1325 
1326         // conversion between 2 reserves
1327         return getCrossReserveReturn(_fromToken, _toToken, _amount);
1328     }
1329 
1330     /**
1331       * @dev calculates the expected return of buying with a given amount of tokens
1332       * 
1333       * @param _reserveToken    contract address of the reserve token
1334       * @param _depositAmount   amount of reserve-tokens received from the user
1335       * 
1336       * @return amount of supply-tokens that the user will receive
1337       * @return amount of supply-tokens that the user will pay as fee
1338     */
1339     function getPurchaseReturn(IERC20Token _reserveToken, uint256 _depositAmount)
1340         public
1341         view
1342         active
1343         validReserve(_reserveToken)
1344         returns (uint256, uint256)
1345     {
1346         Reserve storage reserve = reserves[_reserveToken];
1347         require(reserve.isSaleEnabled); // validate input
1348 
1349         uint256 tokenSupply = token.totalSupply();
1350         uint256 reserveBalance = _reserveToken.balanceOf(this);
1351         IBancorFormula formula = IBancorFormula(addressOf(BANCOR_FORMULA));
1352         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, reserveBalance, reserve.ratio, _depositAmount);
1353         uint256 finalAmount = getFinalAmount(amount, 1);
1354 
1355         // return the amount minus the conversion fee and the conversion fee
1356         return (finalAmount, amount - finalAmount);
1357     }
1358 
1359     /**
1360       * @dev calculates the expected return of selling a given amount of tokens
1361       * 
1362       * @param _reserveToken    contract address of the reserve token
1363       * @param _sellAmount      amount of supply-tokens received from the user
1364       * 
1365       * @return amount of reserve-tokens that the user will receive
1366       * @return amount of reserve-tokens that the user will pay as fee
1367     */
1368     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount)
1369         public
1370         view
1371         active
1372         validReserve(_reserveToken)
1373         returns (uint256, uint256)
1374     {
1375         Reserve storage reserve = reserves[_reserveToken];
1376         uint256 tokenSupply = token.totalSupply();
1377         uint256 reserveBalance = _reserveToken.balanceOf(this);
1378         IBancorFormula formula = IBancorFormula(addressOf(BANCOR_FORMULA));
1379         uint256 amount = formula.calculateSaleReturn(tokenSupply, reserveBalance, reserve.ratio, _sellAmount);
1380         uint256 finalAmount = getFinalAmount(amount, 1);
1381 
1382         // return the amount minus the conversion fee and the conversion fee
1383         return (finalAmount, amount - finalAmount);
1384     }
1385 
1386     /**
1387       * @dev calculates the expected return of converting a given amount from one reserve to another
1388       * note that prior to version 17, you should use 'getCrossConnectorReturn' instead
1389       * 
1390       * @param _fromReserveToken    contract address of the reserve token to convert from
1391       * @param _toReserveToken      contract address of the reserve token to convert to
1392       * @param _amount              amount of tokens received from the user
1393       * 
1394       * @return amount of tokens that the user will receive
1395       * @return amount of tokens that the user will pay as fee
1396     */
1397     function getCrossReserveReturn(IERC20Token _fromReserveToken, IERC20Token _toReserveToken, uint256 _amount)
1398         public
1399         view
1400         active
1401         validReserve(_fromReserveToken)
1402         validReserve(_toReserveToken)
1403         returns (uint256, uint256)
1404     {
1405         Reserve storage fromReserve = reserves[_fromReserveToken];
1406         Reserve storage toReserve = reserves[_toReserveToken];
1407         require(fromReserve.isSaleEnabled); // validate input
1408 
1409         IBancorFormula formula = IBancorFormula(addressOf(BANCOR_FORMULA));
1410         uint256 amount = formula.calculateCrossReserveReturn(
1411             getReserveBalance(_fromReserveToken), 
1412             fromReserve.ratio, 
1413             getReserveBalance(_toReserveToken), 
1414             toReserve.ratio, 
1415             _amount);
1416         uint256 finalAmount = getFinalAmount(amount, 2);
1417 
1418         // return the amount minus the conversion fee and the conversion fee
1419         // the fee is higher (magnitude = 2) since cross reserve conversion equals 2 conversions (from / to the smart token)
1420         return (finalAmount, amount - finalAmount);
1421     }
1422 
1423     /**
1424       * @dev converts a specific amount of _fromToken to _toToken
1425       * can only be called by the bancor network contract
1426       * 
1427       * @param _fromToken  ERC20 token to convert from
1428       * @param _toToken    ERC20 token to convert to
1429       * @param _amount     amount to convert, in fromToken
1430       * @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1431       * 
1432       * @return conversion return amount
1433     */
1434     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
1435         public
1436         only(BANCOR_NETWORK)
1437         conversionsAllowed
1438         greaterThanZero(_minReturn)
1439         returns (uint256)
1440     {
1441         require(_fromToken != _toToken); // validate input
1442 
1443         // conversion between the token and one of its reserves
1444         if (_toToken == token)
1445             return buy(_fromToken, _amount, _minReturn);
1446         else if (_fromToken == token)
1447             return sell(_toToken, _amount, _minReturn);
1448 
1449         uint256 amount;
1450         uint256 feeAmount;
1451 
1452         // conversion between 2 reserves
1453         (amount, feeAmount) = getCrossReserveReturn(_fromToken, _toToken, _amount);
1454         // ensure the trade gives something in return and meets the minimum requested amount
1455         require(amount != 0 && amount >= _minReturn);
1456 
1457         // update the source token virtual balance if relevant
1458         Reserve storage fromReserve = reserves[_fromToken];
1459         if (fromReserve.isVirtualBalanceEnabled)
1460             fromReserve.virtualBalance = fromReserve.virtualBalance.add(_amount);
1461 
1462         // update the target token virtual balance if relevant
1463         Reserve storage toReserve = reserves[_toToken];
1464         if (toReserve.isVirtualBalanceEnabled)
1465             toReserve.virtualBalance = toReserve.virtualBalance.sub(amount);
1466 
1467         // ensure that the trade won't deplete the reserve balance
1468         uint256 toReserveBalance = getReserveBalance(_toToken);
1469         assert(amount < toReserveBalance);
1470 
1471         // transfer funds from the caller in the from reserve token
1472         ensureTransferFrom(_fromToken, msg.sender, this, _amount);
1473         // transfer funds to the caller in the to reserve token
1474         // the transfer might fail if virtual balance is enabled
1475         ensureTransferFrom(_toToken, this, msg.sender, amount);
1476 
1477         // dispatch the conversion event
1478         // the fee is higher (magnitude = 2) since cross reserve conversion equals 2 conversions (from / to the smart token)
1479         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
1480 
1481         // dispatch price data updates for the smart token / both reserves
1482         emit PriceDataUpdate(_fromToken, token.totalSupply(), _fromToken.balanceOf(this), fromReserve.ratio);
1483         emit PriceDataUpdate(_toToken, token.totalSupply(), _toToken.balanceOf(this), toReserve.ratio);
1484         return amount;
1485     }
1486 
1487     /**
1488       * @dev buys the token by depositing one of its reserve tokens
1489       * 
1490       * @param _reserveToken    reserve token contract address
1491       * @param _depositAmount   amount to deposit (in the reserve token)
1492       * @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1493       * 
1494       * @return buy return amount
1495     */
1496     function buy(IERC20Token _reserveToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
1497         uint256 amount;
1498         uint256 feeAmount;
1499         (amount, feeAmount) = getPurchaseReturn(_reserveToken, _depositAmount);
1500         // ensure the trade gives something in return and meets the minimum requested amount
1501         require(amount != 0 && amount >= _minReturn);
1502 
1503         // update virtual balance if relevant
1504         Reserve storage reserve = reserves[_reserveToken];
1505         if (reserve.isVirtualBalanceEnabled)
1506             reserve.virtualBalance = reserve.virtualBalance.add(_depositAmount);
1507 
1508         // transfer funds from the caller in the reserve token
1509         ensureTransferFrom(_reserveToken, msg.sender, this, _depositAmount);
1510         // issue new funds to the caller in the smart token
1511         token.issue(msg.sender, amount);
1512 
1513         // dispatch the conversion event
1514         dispatchConversionEvent(_reserveToken, token, _depositAmount, amount, feeAmount);
1515 
1516         // dispatch price data update for the smart token/reserve
1517         emit PriceDataUpdate(_reserveToken, token.totalSupply(), _reserveToken.balanceOf(this), reserve.ratio);
1518         return amount;
1519     }
1520 
1521     /**
1522       * @dev sells the token by withdrawing from one of its reserve tokens
1523       * 
1524       * @param _reserveToken    reserve token contract address
1525       * @param _sellAmount      amount to sell (in the smart token)
1526       * @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1527       * 
1528       * @return sell return amount
1529     */
1530     function sell(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
1531         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1532         uint256 amount;
1533         uint256 feeAmount;
1534         (amount, feeAmount) = getSaleReturn(_reserveToken, _sellAmount);
1535         // ensure the trade gives something in return and meets the minimum requested amount
1536         require(amount != 0 && amount >= _minReturn);
1537 
1538         // ensure that the trade will only deplete the reserve balance if the total supply is depleted as well
1539         uint256 tokenSupply = token.totalSupply();
1540         uint256 reserveBalance = _reserveToken.balanceOf(this);
1541         assert(amount < reserveBalance || (amount == reserveBalance && _sellAmount == tokenSupply));
1542 
1543         // update virtual balance if relevant
1544         Reserve storage reserve = reserves[_reserveToken];
1545         if (reserve.isVirtualBalanceEnabled)
1546             reserve.virtualBalance = reserve.virtualBalance.sub(amount);
1547 
1548         // destroy _sellAmount from the caller's balance in the smart token
1549         token.destroy(msg.sender, _sellAmount);
1550         // transfer funds to the caller in the reserve token
1551         ensureTransferFrom(_reserveToken, this, msg.sender, amount);
1552 
1553         // dispatch the conversion event
1554         dispatchConversionEvent(token, _reserveToken, _sellAmount, amount, feeAmount);
1555 
1556         // dispatch price data update for the smart token/reserve
1557         emit PriceDataUpdate(_reserveToken, token.totalSupply(), _reserveToken.balanceOf(this), reserve.ratio);
1558         return amount;
1559     }
1560 
1561     /**
1562       * @dev converts a specific amount of _fromToken to _toToken
1563       * note that prior to version 16, you should use 'convert' instead
1564       * 
1565       * @param _fromToken           ERC20 token to convert from
1566       * @param _toToken             ERC20 token to convert to
1567       * @param _amount              amount to convert, in fromToken
1568       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1569       * @param _affiliateAccount    affiliate account
1570       * @param _affiliateFee        affiliate fee in PPM
1571       * 
1572       * @return conversion return amount
1573     */
1574     function convert2(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public returns (uint256) {
1575         IERC20Token[] memory path = new IERC20Token[](3);
1576         (path[0], path[1], path[2]) = (_fromToken, token, _toToken);
1577         return quickConvert2(path, _amount, _minReturn, _affiliateAccount, _affiliateFee);
1578     }
1579 
1580     /**
1581       * @dev converts the token to any other token in the bancor network by following a predefined conversion path
1582       * note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1583       * note that prior to version 16, you should use 'quickConvert' instead
1584       * 
1585       * @param _path                conversion path, see conversion path format in the BancorNetwork contract
1586       * @param _amount              amount to convert from (in the initial source token)
1587       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1588       * @param _affiliateAccount    affiliate account
1589       * @param _affiliateFee        affiliate fee in PPM
1590       * 
1591       * @return tokens issued in return
1592     */
1593     function quickConvert2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee)
1594         public
1595         payable
1596         returns (uint256)
1597     {
1598         return quickConvertPrioritized2(_path, _amount, _minReturn, getSignature(0x0, 0x0, 0x0, 0x0, 0x0), _affiliateAccount, _affiliateFee);
1599     }
1600 
1601     /**
1602       * @dev converts the token to any other token in the bancor network by following a predefined conversion path
1603       * note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1604       * note that prior to version 16, you should use 'quickConvertPrioritized' instead
1605       * 
1606       * @param _path                conversion path, see conversion path format in the BancorNetwork contract
1607       * @param _amount              amount to convert from (in the initial source token)
1608       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1609       * @param _signature           an array of the following elements:
1610       *     [0] uint256             custom value that was signed for prioritized conversion; must be equal to _amount
1611       *     [1] uint256             if the current block exceeded the given parameter - it is cancelled
1612       *     [2] uint8               (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
1613       *     [3] bytes32             (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
1614       *     [4] bytes32             (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
1615       * if the array is empty (length == 0), then the gas-price limit is verified instead of the signature
1616       * @param _affiliateAccount    affiliate account
1617       * @param _affiliateFee        affiliate fee in PPM
1618       * 
1619       * @return tokens issued in return
1620     */
1621     function quickConvertPrioritized2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256[] memory _signature, address _affiliateAccount, uint256 _affiliateFee)
1622         public
1623         payable
1624         returns (uint256)
1625     {
1626         require(_signature.length == 0 || _signature[0] == _amount);
1627 
1628         IBancorNetwork bancorNetwork = IBancorNetwork(addressOf(BANCOR_NETWORK));
1629 
1630         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1631         // so it can execute the conversion on behalf of the caller
1632         if (msg.value == 0) {
1633             // not ETH, send the source tokens to the BancorNetwork contract
1634             // if the token is the smart token, no allowance is required - destroy the tokens
1635             // from the caller and issue them to the BancorNetwork contract
1636             if (_path[0] == token) {
1637                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1638                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1639             } else {
1640                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1641                 ensureTransferFrom(_path[0], msg.sender, bancorNetwork, _amount);
1642             }
1643         }
1644 
1645         // execute the conversion and pass on the ETH with the call
1646         return bancorNetwork.convertForPrioritized4.value(msg.value)(_path, _amount, _minReturn, msg.sender, _signature, _affiliateAccount, _affiliateFee);
1647     }
1648 
1649     /**
1650       * @dev allows a user to convert BNT that was sent from another blockchain into any other
1651       * token on the BancorNetwork without specifying the amount of BNT to be converted, but
1652       * rather by providing the xTransferId which allows us to get the amount from BancorX.
1653       * note that prior to version 16, you should use 'completeXConversion' instead
1654       * 
1655       * @param _path            conversion path, see conversion path format in the BancorNetwork contract
1656       * @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1657       * @param _conversionId    pre-determined unique (if non zero) id which refers to this transaction 
1658       * @param _signature       an array of the following elements:
1659       *     [0] uint256         custom value that was signed for prioritized conversion; must be equal to _conversionId
1660       *     [1] uint256         if the current block exceeded the given parameter - it is cancelled
1661       *     [2] uint8           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
1662       *     [3] bytes32         (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
1663       *     [4] bytes32         (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
1664       * if the array is empty (length == 0), then the gas-price limit is verified instead of the signature
1665       * 
1666       * @return tokens issued in return
1667     */
1668     function completeXConversion2(
1669         IERC20Token[] _path,
1670         uint256 _minReturn,
1671         uint256 _conversionId,
1672         uint256[] memory _signature
1673     )
1674         public
1675         returns (uint256)
1676     {
1677         // verify that the custom value (if valid) is equal to _conversionId
1678         require(_signature.length == 0 || _signature[0] == _conversionId);
1679 
1680         IBancorX bancorX = IBancorX(addressOf(BANCOR_X));
1681         IBancorNetwork bancorNetwork = IBancorNetwork(addressOf(BANCOR_NETWORK));
1682 
1683         // verify that the first token in the path is BNT
1684         require(_path[0] == addressOf(BNT_TOKEN));
1685 
1686         // get conversion amount from BancorX contract
1687         uint256 amount = bancorX.getXTransferAmount(_conversionId, msg.sender);
1688 
1689         // send BNT from msg.sender to the BancorNetwork contract
1690         token.destroy(msg.sender, amount);
1691         token.issue(bancorNetwork, amount);
1692 
1693         return bancorNetwork.convertForPrioritized4(_path, amount, _minReturn, msg.sender, _signature, address(0), 0);
1694     }
1695 
1696     /**
1697       * @dev returns whether or not the caller is an administrator
1698      */
1699     function isAdmin() internal view returns (bool) {
1700         return msg.sender == owner || msg.sender == manager;
1701     }
1702 
1703     /**
1704       * @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1705       * true on success but revert on failure instead
1706       * 
1707       * @param _token     the token to transfer
1708       * @param _from      the address to transfer the tokens from
1709       * @param _to        the address to transfer the tokens to
1710       * @param _amount    the amount to transfer
1711     */
1712     function ensureTransferFrom(IERC20Token _token, address _from, address _to, uint256 _amount) private {
1713         // We must assume that functions `transfer` and `transferFrom` do not return anything,
1714         // because not all tokens abide the requirement of the ERC20 standard to return success or failure.
1715         // This is because in the current compiler version, the calling contract can handle more returned data than expected but not less.
1716         // This may change in the future, so that the calling contract will revert if the size of the data is not exactly what it expects.
1717         uint256 prevBalance = _token.balanceOf(_to);
1718         if (_from == address(this))
1719             INonStandardERC20(_token).transfer(_to, _amount);
1720         else
1721             INonStandardERC20(_token).transferFrom(_from, _to, _amount);
1722         uint256 postBalance = _token.balanceOf(_to);
1723         require(postBalance > prevBalance);
1724     }
1725 
1726     /**
1727       * @dev buys the token with all reserve tokens using the same percentage
1728       * for example, if the caller increases the supply by 10%,
1729       * then it will cost an amount equal to 10% of each reserve token balance
1730       * note that the function can be called only when conversions are enabled
1731       * 
1732       * @param _amount  amount to increase the supply by (in the smart token)
1733     */
1734     function fund(uint256 _amount)
1735         public
1736         conversionsAllowed
1737         multipleReservesOnly
1738     {
1739         uint256 supply = token.totalSupply();
1740         IBancorFormula formula = IBancorFormula(addressOf(BANCOR_FORMULA));
1741 
1742         // iterate through the reserve tokens and transfer a percentage equal to the ratio between _amount
1743         // and the total supply in each reserve from the caller to the converter
1744         IERC20Token reserveToken;
1745         uint256 reserveBalance;
1746         uint256 reserveAmount;
1747         for (uint16 i = 0; i < reserveTokens.length; i++) {
1748             reserveToken = reserveTokens[i];
1749             reserveBalance = reserveToken.balanceOf(this);
1750             reserveAmount = formula.calculateFundCost(supply, reserveBalance, totalReserveRatio, _amount);
1751 
1752             // update virtual balance if relevant
1753             Reserve storage reserve = reserves[reserveToken];
1754             if (reserve.isVirtualBalanceEnabled)
1755                 reserve.virtualBalance = reserve.virtualBalance.add(reserveAmount);
1756 
1757             // transfer funds from the caller in the reserve token
1758             ensureTransferFrom(reserveToken, msg.sender, this, reserveAmount);
1759 
1760             // dispatch price data update for the smart token/reserve
1761             emit PriceDataUpdate(reserveToken, supply + _amount, reserveBalance + reserveAmount, reserve.ratio);
1762         }
1763 
1764         // issue new funds to the caller in the smart token
1765         token.issue(msg.sender, _amount);
1766     }
1767 
1768     /**
1769       * @dev sells the token for all reserve tokens using the same percentage
1770       * for example, if the holder sells 10% of the supply,
1771       * then they will receive 10% of each reserve token balance in return
1772       * note that the function can be called also when conversions are disabled
1773       * 
1774       * @param _amount  amount to liquidate (in the smart token)
1775     */
1776     function liquidate(uint256 _amount)
1777         public
1778         multipleReservesOnly
1779     {
1780         uint256 supply = token.totalSupply();
1781         IBancorFormula formula = IBancorFormula(addressOf(BANCOR_FORMULA));
1782 
1783         // destroy _amount from the caller's balance in the smart token
1784         token.destroy(msg.sender, _amount);
1785 
1786         // iterate through the reserve tokens and send a percentage equal to the ratio between _amount
1787         // and the total supply from each reserve balance to the caller
1788         IERC20Token reserveToken;
1789         uint256 reserveBalance;
1790         uint256 reserveAmount;
1791         for (uint16 i = 0; i < reserveTokens.length; i++) {
1792             reserveToken = reserveTokens[i];
1793             reserveBalance = reserveToken.balanceOf(this);
1794             reserveAmount = formula.calculateLiquidateReturn(supply, reserveBalance, totalReserveRatio, _amount);
1795 
1796             // update virtual balance if relevant
1797             Reserve storage reserve = reserves[reserveToken];
1798             if (reserve.isVirtualBalanceEnabled)
1799                 reserve.virtualBalance = reserve.virtualBalance.sub(reserveAmount);
1800 
1801             // transfer funds to the caller in the reserve token
1802             ensureTransferFrom(reserveToken, this, msg.sender, reserveAmount);
1803 
1804             // dispatch price data update for the smart token/reserve
1805             emit PriceDataUpdate(reserveToken, supply - _amount, reserveBalance - reserveAmount, reserve.ratio);
1806         }
1807     }
1808 
1809     /**
1810       * @dev helper, dispatches the Conversion event
1811       * 
1812       * @param _fromToken       ERC20 token to convert from
1813       * @param _toToken         ERC20 token to convert to
1814       * @param _amount          amount purchased/sold (in the source token)
1815       * @param _returnAmount    amount returned (in the target token)
1816     */
1817     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1818         // fee amount is converted to 255 bits -
1819         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1820         // currently the fee is always taken from the target token
1821         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1822         assert(_feeAmount < 2 ** 255);
1823         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1824     }
1825 
1826     function getSignature(
1827         uint256 _customVal,
1828         uint256 _block,
1829         uint8 _v,
1830         bytes32 _r,
1831         bytes32 _s
1832     ) private pure returns (uint256[] memory) {
1833         if (_v == 0x0 && _r == 0x0 && _s == 0x0)
1834             return new uint256[](0);
1835         uint256[] memory signature = new uint256[](5);
1836         signature[0] = _customVal;
1837         signature[1] = _block;
1838         signature[2] = uint256(_v);
1839         signature[3] = uint256(_r);
1840         signature[4] = uint256(_s);
1841         return signature;
1842     }
1843 
1844     /**
1845       * @dev deprecated, backward compatibility
1846     */
1847     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1848         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1849     }
1850 
1851     /**
1852       * @dev deprecated, backward compatibility
1853     */
1854     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1855         return convert2(_fromToken, _toToken, _amount, _minReturn, address(0), 0);
1856     }
1857 
1858     /**
1859       * @dev deprecated, backward compatibility
1860     */
1861     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
1862         return quickConvert2(_path, _amount, _minReturn, address(0), 0);
1863     }
1864 
1865     /**
1866       * @dev deprecated, backward compatibility
1867     */
1868     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256) {
1869         return quickConvertPrioritized2(_path, _amount, _minReturn, getSignature(_amount, _block, _v, _r, _s), address(0), 0);
1870     }
1871 
1872     /**
1873       * @dev deprecated, backward compatibility
1874     */
1875     function completeXConversion(IERC20Token[] _path, uint256 _minReturn, uint256 _conversionId, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s) public returns (uint256) {
1876         return completeXConversion2(_path, _minReturn, _conversionId, getSignature(_conversionId, _block, _v, _r, _s));
1877     }
1878 
1879     /**
1880       * @dev deprecated, backward compatibility
1881     */
1882     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) {
1883         Reserve storage reserve = reserves[_address];
1884         return(reserve.virtualBalance, reserve.ratio, reserve.isVirtualBalanceEnabled, reserve.isSaleEnabled, reserve.isSet);
1885     }
1886 
1887     /**
1888       * @dev deprecated, backward compatibility
1889     */
1890     function connectorTokens(uint256 _index) public view returns (IERC20Token) {
1891         return BancorConverter.reserveTokens[_index];
1892     }
1893 
1894     /**
1895       * @dev deprecated, backward compatibility
1896     */
1897     function connectorTokenCount() public view returns (uint16) {
1898         return reserveTokenCount();
1899     }
1900 
1901     /**
1902       * @dev deprecated, backward compatibility
1903     */
1904     function addConnector(IERC20Token _token, uint32 _weight, bool /*_enableVirtualBalance*/) public {
1905         addReserve(_token, _weight);
1906     }
1907 
1908     /**
1909       * @dev deprecated, backward compatibility
1910     */
1911     function updateConnector(IERC20Token _connectorToken, uint32 /*_weight*/, bool /*_enableVirtualBalance*/, uint256 _virtualBalance) public {
1912         updateReserveVirtualBalance(_connectorToken, _virtualBalance);
1913     }
1914 
1915     /**
1916       * @dev deprecated, backward compatibility
1917     */
1918     function disableConnectorSale(IERC20Token _connectorToken, bool _disable) public {
1919         disableReserveSale(_connectorToken, _disable);
1920     }
1921 
1922     /**
1923       * @dev deprecated, backward compatibility
1924     */
1925     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256) {
1926         return getReserveBalance(_connectorToken);
1927     }
1928 
1929     /**
1930       * @dev deprecated, backward compatibility
1931     */
1932     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _amount) public view returns (uint256, uint256) {
1933         return getCrossReserveReturn(_fromConnectorToken, _toConnectorToken, _amount);
1934     }
1935 }