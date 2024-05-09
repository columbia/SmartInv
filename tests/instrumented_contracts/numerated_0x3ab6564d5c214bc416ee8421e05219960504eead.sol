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
22 // File: contracts/IBancorNetwork.sol
23 
24 pragma solidity 0.4.26;
25 
26 
27 /*
28     Bancor Network interface
29 */
30 contract IBancorNetwork {
31     function convert2(
32         IERC20Token[] _path,
33         uint256 _amount,
34         uint256 _minReturn,
35         address _affiliateAccount,
36         uint256 _affiliateFee
37     ) public payable returns (uint256);
38 
39     function claimAndConvert2(
40         IERC20Token[] _path,
41         uint256 _amount,
42         uint256 _minReturn,
43         address _affiliateAccount,
44         uint256 _affiliateFee
45     ) public returns (uint256);
46 
47     function convertFor2(
48         IERC20Token[] _path,
49         uint256 _amount,
50         uint256 _minReturn,
51         address _for,
52         address _affiliateAccount,
53         uint256 _affiliateFee
54     ) public payable returns (uint256);
55 
56     function claimAndConvertFor2(
57         IERC20Token[] _path,
58         uint256 _amount,
59         uint256 _minReturn,
60         address _for,
61         address _affiliateAccount,
62         uint256 _affiliateFee
63     ) public returns (uint256);
64 
65     function convertForPrioritized4(
66         IERC20Token[] _path,
67         uint256 _amount,
68         uint256 _minReturn,
69         address _for,
70         uint256[] memory _signature,
71         address _affiliateAccount,
72         uint256 _affiliateFee
73     ) public payable returns (uint256);
74 
75     // deprecated, backward compatibility
76     function convert(
77         IERC20Token[] _path,
78         uint256 _amount,
79         uint256 _minReturn
80     ) public payable returns (uint256);
81 
82     // deprecated, backward compatibility
83     function claimAndConvert(
84         IERC20Token[] _path,
85         uint256 _amount,
86         uint256 _minReturn
87     ) public returns (uint256);
88 
89     // deprecated, backward compatibility
90     function convertFor(
91         IERC20Token[] _path,
92         uint256 _amount,
93         uint256 _minReturn,
94         address _for
95     ) public payable returns (uint256);
96 
97     // deprecated, backward compatibility
98     function claimAndConvertFor(
99         IERC20Token[] _path,
100         uint256 _amount,
101         uint256 _minReturn,
102         address _for
103     ) public returns (uint256);
104 
105     // deprecated, backward compatibility
106     function convertForPrioritized3(
107         IERC20Token[] _path,
108         uint256 _amount,
109         uint256 _minReturn,
110         address _for,
111         uint256 _customVal,
112         uint256 _block,
113         uint8 _v,
114         bytes32 _r,
115         bytes32 _s
116     ) public payable returns (uint256);
117 
118     // deprecated, backward compatibility
119     function convertForPrioritized2(
120         IERC20Token[] _path,
121         uint256 _amount,
122         uint256 _minReturn,
123         address _for,
124         uint256 _block,
125         uint8 _v,
126         bytes32 _r,
127         bytes32 _s
128     ) public payable returns (uint256);
129 
130     // deprecated, backward compatibility
131     function convertForPrioritized(
132         IERC20Token[] _path,
133         uint256 _amount,
134         uint256 _minReturn,
135         address _for,
136         uint256 _block,
137         uint256 _nonce,
138         uint8 _v,
139         bytes32 _r,
140         bytes32 _s
141     ) public payable returns (uint256);
142 }
143 
144 // File: contracts/FeatureIds.sol
145 
146 pragma solidity 0.4.26;
147 
148 /**
149   * @dev Id definitions for bancor contract features
150   * 
151   * Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
152 */
153 contract FeatureIds {
154     // converter features
155     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
156 }
157 
158 // File: contracts/utility/interfaces/IWhitelist.sol
159 
160 pragma solidity 0.4.26;
161 
162 /*
163     Whitelist interface
164 */
165 contract IWhitelist {
166     function isWhitelisted(address _address) public view returns (bool);
167 }
168 
169 // File: contracts/converter/interfaces/IBancorConverter.sol
170 
171 pragma solidity 0.4.26;
172 
173 
174 
175 /*
176     Bancor Converter interface
177 */
178 contract IBancorConverter {
179     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
180     function convert2(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public returns (uint256);
181     function quickConvert2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public payable returns (uint256);
182     function conversionWhitelist() public view returns (IWhitelist) {this;}
183     function conversionFee() public view returns (uint32) {this;}
184     function reserves(address _address) public view returns (uint256, uint32, bool, bool, bool) {_address; this;}
185     function getReserveBalance(IERC20Token _reserveToken) public view returns (uint256);
186     function reserveTokens(uint256 _index) public view returns (IERC20Token) {_index; this;}
187 
188     // deprecated, backward compatibility
189     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
190     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
191     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
192     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool);
193     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
194     function connectorTokens(uint256 _index) public view returns (IERC20Token);
195     function connectorTokenCount() public view returns (uint16);
196 }
197 
198 // File: contracts/converter/interfaces/IBancorFormula.sol
199 
200 pragma solidity 0.4.26;
201 
202 /*
203     Bancor Formula interface
204 */
205 contract IBancorFormula {
206     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public view returns (uint256);
207     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public view returns (uint256);
208     function calculateCrossReserveReturn(uint256 _fromReserveBalance, uint32 _fromReserveRatio, uint256 _toReserveBalance, uint32 _toReserveRatio, uint256 _amount) public view returns (uint256);
209     function calculateFundCost(uint256 _supply, uint256 _reserveBalance, uint32 _totalRatio, uint256 _amount) public view returns (uint256);
210     function calculateLiquidateReturn(uint256 _supply, uint256 _reserveBalance, uint32 _totalRatio, uint256 _amount) public view returns (uint256);
211     // deprecated, backward compatibility
212     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
213 }
214 
215 // File: contracts/converter/interfaces/IBancorGasPriceLimit.sol
216 
217 pragma solidity 0.4.26;
218 
219 /*
220     Bancor Gas Price Limit interface
221 */
222 contract IBancorGasPriceLimit {
223     function gasPrice() public view returns (uint256) {this;}
224     function validateGasPrice(uint256) public view;
225 }
226 
227 // File: contracts/utility/interfaces/IOwned.sol
228 
229 pragma solidity 0.4.26;
230 
231 /*
232     Owned contract interface
233 */
234 contract IOwned {
235     // this function isn't abstract since the compiler emits automatically generated getter functions as external
236     function owner() public view returns (address) {this;}
237 
238     function transferOwnership(address _newOwner) public;
239     function acceptOwnership() public;
240 }
241 
242 // File: contracts/utility/Owned.sol
243 
244 pragma solidity 0.4.26;
245 
246 
247 /**
248   * @dev Provides support and utilities for contract ownership
249 */
250 contract Owned is IOwned {
251     address public owner;
252     address public newOwner;
253 
254     /**
255       * @dev triggered when the owner is updated
256       * 
257       * @param _prevOwner previous owner
258       * @param _newOwner  new owner
259     */
260     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
261 
262     /**
263       * @dev initializes a new Owned instance
264     */
265     constructor() public {
266         owner = msg.sender;
267     }
268 
269     // allows execution by the owner only
270     modifier ownerOnly {
271         require(msg.sender == owner);
272         _;
273     }
274 
275     /**
276       * @dev allows transferring the contract ownership
277       * the new owner still needs to accept the transfer
278       * can only be called by the contract owner
279       * 
280       * @param _newOwner    new contract owner
281     */
282     function transferOwnership(address _newOwner) public ownerOnly {
283         require(_newOwner != owner);
284         newOwner = _newOwner;
285     }
286 
287     /**
288       * @dev used by a new owner to accept an ownership transfer
289     */
290     function acceptOwnership() public {
291         require(msg.sender == newOwner);
292         emit OwnerUpdate(owner, newOwner);
293         owner = newOwner;
294         newOwner = address(0);
295     }
296 }
297 
298 // File: contracts/utility/Utils.sol
299 
300 pragma solidity 0.4.26;
301 
302 /**
303   * @dev Utilities & Common Modifiers
304 */
305 contract Utils {
306     /**
307       * constructor
308     */
309     constructor() public {
310     }
311 
312     // verifies that an amount is greater than zero
313     modifier greaterThanZero(uint256 _amount) {
314         require(_amount > 0);
315         _;
316     }
317 
318     // validates an address - currently only checks that it isn't null
319     modifier validAddress(address _address) {
320         require(_address != address(0));
321         _;
322     }
323 
324     // verifies that the address is different than this contract address
325     modifier notThis(address _address) {
326         require(_address != address(this));
327         _;
328     }
329 
330 }
331 
332 // File: contracts/utility/interfaces/ITokenHolder.sol
333 
334 pragma solidity 0.4.26;
335 
336 
337 
338 /*
339     Token Holder interface
340 */
341 contract ITokenHolder is IOwned {
342     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
343 }
344 
345 // File: contracts/token/interfaces/INonStandardERC20.sol
346 
347 pragma solidity 0.4.26;
348 
349 /*
350     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
351 */
352 contract INonStandardERC20 {
353     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
354     function name() public view returns (string) {this;}
355     function symbol() public view returns (string) {this;}
356     function decimals() public view returns (uint8) {this;}
357     function totalSupply() public view returns (uint256) {this;}
358     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
359     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
360 
361     function transfer(address _to, uint256 _value) public;
362     function transferFrom(address _from, address _to, uint256 _value) public;
363     function approve(address _spender, uint256 _value) public;
364 }
365 
366 // File: contracts/utility/TokenHolder.sol
367 
368 pragma solidity 0.4.26;
369 
370 
371 
372 
373 
374 
375 /**
376   * @dev We consider every contract to be a 'token holder' since it's currently not possible
377   * for a contract to deny receiving tokens.
378   * 
379   * The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
380   * the owner to send tokens that were sent to the contract by mistake back to their sender.
381   * 
382   * Note that we use the non standard ERC-20 interface which has no return value for transfer
383   * in order to support both non standard as well as standard token contracts.
384   * see https://github.com/ethereum/solidity/issues/4116
385 */
386 contract TokenHolder is ITokenHolder, Owned, Utils {
387     /**
388       * @dev initializes a new TokenHolder instance
389     */
390     constructor() public {
391     }
392 
393     /**
394       * @dev withdraws tokens held by the contract and sends them to an account
395       * can only be called by the owner
396       * 
397       * @param _token   ERC20 token contract address
398       * @param _to      account to receive the new amount
399       * @param _amount  amount to withdraw
400     */
401     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
402         public
403         ownerOnly
404         validAddress(_token)
405         validAddress(_to)
406         notThis(_to)
407     {
408         INonStandardERC20(_token).transfer(_to, _amount);
409     }
410 }
411 
412 // File: contracts/utility/SafeMath.sol
413 
414 pragma solidity 0.4.26;
415 
416 /**
417   * @dev Library for basic math operations with overflow/underflow protection
418 */
419 library SafeMath {
420     /**
421       * @dev returns the sum of _x and _y, reverts if the calculation overflows
422       * 
423       * @param _x   value 1
424       * @param _y   value 2
425       * 
426       * @return sum
427     */
428     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
429         uint256 z = _x + _y;
430         require(z >= _x);
431         return z;
432     }
433 
434     /**
435       * @dev returns the difference of _x minus _y, reverts if the calculation underflows
436       * 
437       * @param _x   minuend
438       * @param _y   subtrahend
439       * 
440       * @return difference
441     */
442     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
443         require(_x >= _y);
444         return _x - _y;
445     }
446 
447     /**
448       * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
449       * 
450       * @param _x   factor 1
451       * @param _y   factor 2
452       * 
453       * @return product
454     */
455     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
456         // gas optimization
457         if (_x == 0)
458             return 0;
459 
460         uint256 z = _x * _y;
461         require(z / _x == _y);
462         return z;
463     }
464 
465       /**
466         * ev Integer division of two numbers truncating the quotient, reverts on division by zero.
467         * 
468         * aram _x   dividend
469         * aram _y   divisor
470         * 
471         * eturn quotient
472     */
473     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
474         require(_y > 0);
475         uint256 c = _x / _y;
476 
477         return c;
478     }
479 }
480 
481 // File: contracts/utility/interfaces/IContractRegistry.sol
482 
483 pragma solidity 0.4.26;
484 
485 /*
486     Contract Registry interface
487 */
488 contract IContractRegistry {
489     function addressOf(bytes32 _contractName) public view returns (address);
490 
491     // deprecated, backward compatibility
492     function getAddress(bytes32 _contractName) public view returns (address);
493 }
494 
495 // File: contracts/utility/ContractRegistryClient.sol
496 
497 pragma solidity 0.4.26;
498 
499 
500 
501 
502 /**
503   * @dev Base contract for ContractRegistry clients
504 */
505 contract ContractRegistryClient is Owned, Utils {
506     bytes32 internal constant CONTRACT_FEATURES = "ContractFeatures";
507     bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
508     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
509     bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
510     bytes32 internal constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
511     bytes32 internal constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
512     bytes32 internal constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
513     bytes32 internal constant BANCOR_CONVERTER_REGISTRY = "BancorConverterRegistry";
514     bytes32 internal constant BANCOR_CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
515     bytes32 internal constant BNT_TOKEN = "BNTToken";
516     bytes32 internal constant BANCOR_X = "BancorX";
517     bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
518 
519     IContractRegistry public registry;      // address of the current contract-registry
520     IContractRegistry public prevRegistry;  // address of the previous contract-registry
521     bool public adminOnly;                  // only an administrator can update the contract-registry
522 
523     /**
524       * @dev verifies that the caller is mapped to the given contract name
525       * 
526       * @param _contractName    contract name
527     */
528     modifier only(bytes32 _contractName) {
529         require(msg.sender == addressOf(_contractName));
530         _;
531     }
532 
533     /**
534       * @dev initializes a new ContractRegistryClient instance
535       * 
536       * @param  _registry   address of a contract-registry contract
537     */
538     constructor(IContractRegistry _registry) internal validAddress(_registry) {
539         registry = IContractRegistry(_registry);
540         prevRegistry = IContractRegistry(_registry);
541     }
542 
543     /**
544       * @dev updates to the new contract-registry
545      */
546     function updateRegistry() public {
547         // verify that this function is permitted
548         require(!adminOnly || isAdmin());
549 
550         // get the new contract-registry
551         address newRegistry = addressOf(CONTRACT_REGISTRY);
552 
553         // verify that the new contract-registry is different and not zero
554         require(newRegistry != address(registry) && newRegistry != address(0));
555 
556         // verify that the new contract-registry is pointing to a non-zero contract-registry
557         require(IContractRegistry(newRegistry).addressOf(CONTRACT_REGISTRY) != address(0));
558 
559         // save a backup of the current contract-registry before replacing it
560         prevRegistry = registry;
561 
562         // replace the current contract-registry with the new contract-registry
563         registry = IContractRegistry(newRegistry);
564     }
565 
566     /**
567       * @dev restores the previous contract-registry
568     */
569     function restoreRegistry() public {
570         // verify that this function is permitted
571         require(isAdmin());
572 
573         // restore the previous contract-registry
574         registry = prevRegistry;
575     }
576 
577     /**
578       * @dev restricts the permission to update the contract-registry
579       * 
580       * @param _adminOnly    indicates whether or not permission is restricted to administrator only
581     */
582     function restrictRegistryUpdate(bool _adminOnly) public {
583         // verify that this function is permitted
584         require(adminOnly != _adminOnly && isAdmin());
585 
586         // change the permission to update the contract-registry
587         adminOnly = _adminOnly;
588     }
589 
590     /**
591       * @dev returns whether or not the caller is an administrator
592      */
593     function isAdmin() internal view returns (bool) {
594         return msg.sender == owner;
595     }
596 
597     /**
598       * @dev returns the address associated with the given contract name
599       * 
600       * @param _contractName    contract name
601       * 
602       * @return contract address
603     */
604     function addressOf(bytes32 _contractName) internal view returns (address) {
605         return registry.addressOf(_contractName);
606     }
607 }
608 
609 // File: contracts/utility/interfaces/IContractFeatures.sol
610 
611 pragma solidity 0.4.26;
612 
613 /*
614     Contract Features interface
615 */
616 contract IContractFeatures {
617     function isSupported(address _contract, uint256 _features) public view returns (bool);
618     function enableFeatures(uint256 _features, bool _enable) public;
619 }
620 
621 // File: contracts/utility/interfaces/IAddressList.sol
622 
623 pragma solidity 0.4.26;
624 
625 /*
626     Address list interface
627 */
628 contract IAddressList {
629     mapping (address => bool) public listedAddresses;
630 }
631 
632 // File: contracts/token/interfaces/IEtherToken.sol
633 
634 pragma solidity 0.4.26;
635 
636 
637 
638 /*
639     Ether Token interface
640 */
641 contract IEtherToken is ITokenHolder, IERC20Token {
642     function deposit() public payable;
643     function withdraw(uint256 _amount) public;
644     function withdrawTo(address _to, uint256 _amount) public;
645 }
646 
647 // File: contracts/token/interfaces/ISmartToken.sol
648 
649 pragma solidity 0.4.26;
650 
651 
652 
653 /*
654     Smart Token interface
655 */
656 contract ISmartToken is IOwned, IERC20Token {
657     function disableTransfers(bool _disable) public;
658     function issue(address _to, uint256 _amount) public;
659     function destroy(address _from, uint256 _amount) public;
660 }
661 
662 // File: contracts/bancorx/interfaces/IBancorX.sol
663 
664 pragma solidity 0.4.26;
665 
666 contract IBancorX {
667     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
668     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
669 }
670 
671 // File: contracts/BancorNetwork.sol
672 
673 pragma solidity 0.4.26;
674 
675 
676 
677 
678 
679 
680 
681 
682 
683 
684 
685 
686 
687 
688 
689 
690 /**
691   * @dev The BancorNetwork contract is the main entry point for Bancor token conversions.
692   * It also allows for the conversion of any token in the Bancor Network to any other token in a single transaction by providing a conversion path.
693   * 
694   * A note on Conversion Path: Conversion path is a data structure that is used when converting a token to another token in the Bancor Network,
695   * when the conversion cannot necessarily be done by a single converter and might require multiple 'hops'.
696   * The path defines which converters should be used and what kind of conversion should be done in each step.
697   * 
698   * The path format doesn't include complex structure; instead, it is represented by a single array in which each 'hop' is represented by a 2-tuple - smart token & to token.
699   * In addition, the first element is always the source token.
700   * The smart token is only used as a pointer to a converter (since converter addresses are more likely to change as opposed to smart token addresses).
701   * 
702   * Format:
703   * [source token, smart token, to token, smart token, to token...]
704 */
705 contract BancorNetwork is IBancorNetwork, TokenHolder, ContractRegistryClient, FeatureIds {
706     using SafeMath for uint256;
707 
708     uint256 private constant CONVERSION_FEE_RESOLUTION = 1000000;
709     uint256 private constant AFFILIATE_FEE_RESOLUTION = 1000000;
710 
711     uint256 public maxAffiliateFee = 30000;     // maximum affiliate-fee
712     address public signerAddress = 0x0;         // verified address that allows conversions with higher gas price
713 
714     mapping (address => bool) public etherTokens;       // list of all supported ether tokens
715     mapping (bytes32 => bool) public conversionHashes;  // list of conversion hashes, to prevent re-use of the same hash
716 
717     /**
718       * @dev triggered when a conversion between two tokens occurs
719       * 
720       * @param _smartToken      smart token governed by the converter
721       * @param _fromToken       ERC20 token converted from
722       * @param _toToken         ERC20 token converted to
723       * @param _fromAmount      amount converted, in fromToken
724       * @param _toAmount        amount returned, minus conversion fee
725       * @param _trader          wallet that initiated the trade
726     */
727     event Conversion(
728         address indexed _smartToken,
729         address indexed _fromToken,
730         address indexed _toToken,
731         uint256 _fromAmount,
732         uint256 _toAmount,
733         address _trader
734     );
735 
736     /**
737       * @dev initializes a new BancorNetwork instance
738       * 
739       * @param _registry    address of a contract registry contract
740     */
741     constructor(IContractRegistry _registry) ContractRegistryClient(_registry) public {
742     }
743 
744     /**
745       * @dev allows the owner to update the maximum affiliate-fee
746       * 
747       * @param _maxAffiliateFee   maximum affiliate-fee
748     */
749     function setMaxAffiliateFee(uint256 _maxAffiliateFee)
750         public
751         ownerOnly
752     {
753         require(_maxAffiliateFee <= AFFILIATE_FEE_RESOLUTION);
754         maxAffiliateFee = _maxAffiliateFee;
755     }
756 
757     /**
758       * @dev allows the owner to update the signer address
759       * 
760       * @param _signerAddress    new signer address
761     */
762     function setSignerAddress(address _signerAddress)
763         public
764         ownerOnly
765         validAddress(_signerAddress)
766         notThis(_signerAddress)
767     {
768         signerAddress = _signerAddress;
769     }
770 
771     /**
772       * @dev allows the owner to register/unregister ether tokens
773       * 
774       * @param _token       ether token contract address
775       * @param _register    true to register, false to unregister
776     */
777     function registerEtherToken(IEtherToken _token, bool _register)
778         public
779         ownerOnly
780         validAddress(_token)
781         notThis(_token)
782     {
783         etherTokens[_token] = _register;
784     }
785 
786     /**
787       * @dev verifies that the signer address is the one associated with the public key from a given elliptic curve signature
788       * note that the signature is valid only for one conversion, and that it expires after the give block
789     */
790     function verifyTrustedSender(IERC20Token[] _path, address _addr, uint256[] memory _signature) private {
791         uint256 blockNumber = _signature[1];
792 
793         // check that the current block number doesn't exceeded the maximum allowed with the current signature
794         require(block.number <= blockNumber);
795 
796         // create the hash of the given signature
797         bytes32 hash = keccak256(abi.encodePacked(blockNumber, tx.gasprice, _addr, msg.sender, _signature[0], _path));
798 
799         // check that it is the first conversion with the given signature
800         require(!conversionHashes[hash]);
801 
802         // verify that the signing address is identical to the trusted signer address in the contract
803         bytes32 prefixedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
804         require(ecrecover(prefixedHash, uint8(_signature[2]), bytes32(_signature[3]), bytes32(_signature[4])) == signerAddress);
805 
806         // mark the hash so that it can't be used multiple times
807         conversionHashes[hash] = true;
808     }
809 
810     /**
811       * @dev converts the token to any other token in the bancor network by following
812       * a predefined conversion path and transfers the result tokens to a target account
813       * note that the network should already own the source tokens
814       * 
815       * @param _path                conversion path, see conversion path format above
816       * @param _amount              amount to convert from (in the initial source token)
817       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
818       * @param _for                 account that will receive the conversion result
819       * @param _affiliateAccount    affiliate account
820       * @param _affiliateFee        affiliate fee in PPM
821       * 
822       * @return tokens issued in return
823     */
824     function convertFor2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, address _affiliateAccount, uint256 _affiliateFee) public payable returns (uint256) {
825         return convertForPrioritized4(_path, _amount, _minReturn, _for, getSignature(0x0, 0x0, 0x0, 0x0, 0x0), _affiliateAccount, _affiliateFee);
826     }
827 
828     /**
829       * @dev converts the token to any other token in the bancor network
830       * by following a predefined conversion path and transfers the result
831       * tokens to a target account.
832       * this version of the function also allows the verified signer
833       * to bypass the universal gas price limit.
834       * note that the network should already own the source tokens
835       * 
836       * @param _path                conversion path, see conversion path format above
837       * @param _amount              amount to convert from (in the initial source token)
838       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
839       * @param _for                 account that will receive the conversion result
840       * @param _signature           an array of the following elements:
841       *     [0] uint256             custom value that was signed for prioritized conversion
842       *     [1] uint256             if the current block exceeded the given parameter - it is cancelled
843       *     [2] uint8               (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
844       *     [3] bytes32             (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
845       *     [4] bytes32             (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
846       * if the array is empty (length == 0), then the gas-price limit is verified instead of the signature
847       * @param _affiliateAccount    affiliate account
848       * @param _affiliateFee        affiliate fee in PPM
849       * 
850       * @return tokens issued in return
851     */
852     function convertForPrioritized4(
853         IERC20Token[] _path,
854         uint256 _amount,
855         uint256 _minReturn,
856         address _for,
857         uint256[] memory _signature,
858         address _affiliateAccount,
859         uint256 _affiliateFee
860     )
861         public
862         payable
863         returns (uint256)
864     {
865         // verify that the conversion parameters are legal
866         verifyConversionParams(_path, _for, _for, _signature);
867 
868         // handle msg.value
869         handleValue(_path[0], _amount, false);
870 
871         // convert and get the resulting amount
872         uint256 amount = convertByPath(_path, _amount, _minReturn, _affiliateAccount, _affiliateFee);
873 
874         // finished the conversion, transfer the funds to the target account
875         // if the target token is an ether token, withdraw the tokens and send them as ETH
876         // otherwise, transfer the tokens as is
877         IERC20Token toToken = _path[_path.length - 1];
878         if (etherTokens[toToken])
879             IEtherToken(toToken).withdrawTo(_for, amount);
880         else
881             ensureTransferFrom(toToken, this, _for, amount);
882 
883         return amount;
884     }
885 
886     /**
887       * @dev converts any other token to BNT in the bancor network
888       * by following a predefined conversion path and transfers the resulting
889       * tokens to BancorX.
890       * note that the network should already have been given allowance of the source token (if not ETH)
891       * 
892       * @param _path                conversion path, see conversion path format above
893       * @param _amount              amount to convert from (in the initial source token)
894       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
895       * @param _toBlockchain        blockchain BNT will be issued on
896       * @param _to                  address/account on _toBlockchain to send the BNT to
897       * @param _conversionId        pre-determined unique (if non zero) id which refers to this transaction 
898       * @param _affiliateAccount    affiliate account
899       * @param _affiliateFee        affiliate fee in PPM
900       * 
901       * @return the amount of BNT received from this conversion
902     */
903     function xConvert2(
904         IERC20Token[] _path,
905         uint256 _amount,
906         uint256 _minReturn,
907         bytes32 _toBlockchain,
908         bytes32 _to,
909         uint256 _conversionId,
910         address _affiliateAccount,
911         uint256 _affiliateFee
912     )
913         public
914         payable
915         returns (uint256)
916     {
917         return xConvertPrioritized3(_path, _amount, _minReturn, _toBlockchain, _to, _conversionId, getSignature(0x0, 0x0, 0x0, 0x0, 0x0), _affiliateAccount, _affiliateFee);
918     }
919 
920     /**
921       * @dev converts any other token to BNT in the bancor network
922       * by following a predefined conversion path and transfers the resulting
923       * tokens to BancorX.
924       * this version of the function also allows the verified signer
925       * to bypass the universal gas price limit.
926       * note that the network should already have been given allowance of the source token (if not ETH)
927       * 
928       * @param _path                conversion path, see conversion path format above
929       * @param _amount              amount to convert from (in the initial source token)
930       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
931       * @param _toBlockchain        blockchain BNT will be issued on
932       * @param _to                  address/account on _toBlockchain to send the BNT to
933       * @param _conversionId        pre-determined unique (if non zero) id which refers to this transaction 
934       * @param _signature           an array of the following elements:
935       *     [0] uint256             custom value that was signed for prioritized conversion; must be equal to _amount
936       *     [1] uint256             if the current block exceeded the given parameter - it is cancelled
937       *     [2] uint8               (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
938       *     [3] bytes32             (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
939       *     [4] bytes32             (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
940       * if the array is empty (length == 0), then the gas-price limit is verified instead of the signature
941       * @param _affiliateAccount    affiliate account
942       * @param _affiliateFee        affiliate fee in PPM
943       * 
944       * @return the amount of BNT received from this conversion
945     */
946     function xConvertPrioritized3(
947         IERC20Token[] _path,
948         uint256 _amount,
949         uint256 _minReturn,
950         bytes32 _toBlockchain,
951         bytes32 _to,
952         uint256 _conversionId,
953         uint256[] memory _signature,
954         address _affiliateAccount,
955         uint256 _affiliateFee
956     )
957         public
958         payable
959         returns (uint256)
960     {
961         // verify that the custom value (if valid) is equal to _amount
962         require(_signature.length == 0 || _signature[0] == _amount);
963 
964         // verify that the conversion parameters are legal
965         verifyConversionParams(_path, msg.sender, this, _signature);
966 
967         // verify that the destination token is BNT
968         require(_path[_path.length - 1] == addressOf(BNT_TOKEN));
969 
970         // handle msg.value
971         handleValue(_path[0], _amount, true);
972 
973         // convert and get the resulting amount
974         uint256 amount = convertByPath(_path, _amount, _minReturn, _affiliateAccount, _affiliateFee);
975 
976         // transfer the resulting amount to BancorX
977         IBancorX(addressOf(BANCOR_X)).xTransfer(_toBlockchain, _to, amount, _conversionId);
978 
979         return amount;
980     }
981 
982     /**
983       * @dev executes the actual conversion by following the conversion path
984       * 
985       * @param _path                conversion path, see conversion path format above
986       * @param _amount              amount to convert from (in the initial source token)
987       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
988       * @param _affiliateAccount    affiliate account
989       * @param _affiliateFee        affiliate fee in PPM
990       * 
991       * @return amount of tokens issued
992     */
993     function convertByPath(
994         IERC20Token[] _path,
995         uint256 _amount,
996         uint256 _minReturn,
997         address _affiliateAccount,
998         uint256 _affiliateFee
999     ) private returns (uint256) {
1000         uint256 toAmount;
1001         uint256 fromAmount = _amount;
1002         uint256 lastIndex = _path.length - 1;
1003 
1004         address bntToken;
1005         if (address(_affiliateAccount) == 0) {
1006             require(_affiliateFee == 0);
1007             bntToken = address(0);
1008         }
1009         else {
1010             require(0 < _affiliateFee && _affiliateFee <= maxAffiliateFee);
1011             bntToken = addressOf(BNT_TOKEN);
1012         }
1013 
1014         // iterate over the conversion path
1015         for (uint256 i = 2; i <= lastIndex; i += 2) {
1016             IBancorConverter converter = IBancorConverter(ISmartToken(_path[i - 1]).owner());
1017 
1018             // if the smart token isn't the source (from token), the converter doesn't have control over it and thus we need to approve the request
1019             if (_path[i - 1] != _path[i - 2])
1020                 ensureAllowance(_path[i - 2], converter, fromAmount);
1021 
1022             // make the conversion - if it's the last one, also provide the minimum return value
1023             toAmount = converter.change(_path[i - 2], _path[i], fromAmount, i == lastIndex ? _minReturn : 1);
1024 
1025             // pay affiliate-fee if needed
1026             if (address(_path[i]) == bntToken) {
1027                 uint256 affiliateAmount = toAmount.mul(_affiliateFee).div(AFFILIATE_FEE_RESOLUTION);
1028                 require(_path[i].transfer(_affiliateAccount, affiliateAmount));
1029                 toAmount -= affiliateAmount;
1030                 bntToken = address(0);
1031             }
1032 
1033             emit Conversion(_path[i - 1], _path[i - 2], _path[i], fromAmount, toAmount, msg.sender);
1034             fromAmount = toAmount;
1035         }
1036 
1037         return toAmount;
1038     }
1039 
1040     bytes4 private constant GET_RETURN_FUNC_SELECTOR = bytes4(uint256(keccak256("getReturn(address,address,uint256)") >> (256 - 4 * 8)));
1041 
1042     function getReturn(address _dest, address _fromToken, address _toToken, uint256 _amount) internal view returns (uint256, uint256) {
1043         uint256[2] memory ret;
1044         bytes memory data = abi.encodeWithSelector(GET_RETURN_FUNC_SELECTOR, _fromToken, _toToken, _amount);
1045 
1046         assembly {
1047             let success := staticcall(
1048                 gas,           // gas remaining
1049                 _dest,         // destination address
1050                 add(data, 32), // input buffer (starts after the first 32 bytes in the `data` array)
1051                 mload(data),   // input length (loaded from the first 32 bytes in the `data` array)
1052                 ret,           // output buffer
1053                 64             // output length
1054             )
1055             if iszero(success) {
1056                 revert(0, 0)
1057             }
1058         }
1059 
1060         return (ret[0], ret[1]);
1061     }
1062 
1063     /**
1064       * @dev calculates the expected return of converting a given amount on a given path
1065       * note that there is no support for circular paths
1066       * 
1067       * @param _path        conversion path (see conversion path format above)
1068       * @param _amount      amount of _path[0] tokens received from the user
1069       * 
1070       * @return amount of _path[_path.length - 1] tokens that the user will receive
1071       * @return amount of _path[_path.length - 1] tokens that the user will pay as fee
1072     */
1073     function getReturnByPath(IERC20Token[] _path, uint256 _amount) public view returns (uint256, uint256) {
1074         uint256 amount;
1075         uint256 fee;
1076         uint256 supply;
1077         uint256 balance;
1078         uint32 ratio;
1079         IBancorConverter converter;
1080         IBancorFormula formula = IBancorFormula(addressOf(BANCOR_FORMULA));
1081 
1082         amount = _amount;
1083 
1084         // verify that the number of elements is larger than 2 and odd
1085         require(_path.length > 2 && _path.length % 2 == 1);
1086 
1087         // iterate over the conversion path
1088         for (uint256 i = 2; i < _path.length; i += 2) {
1089             IERC20Token fromToken = _path[i - 2];
1090             IERC20Token smartToken = _path[i - 1];
1091             IERC20Token toToken = _path[i];
1092 
1093             if (toToken == smartToken) { // buy the smart token
1094                 // check if the current smart token has changed
1095                 if (i < 3 || smartToken != _path[i - 3]) {
1096                     supply = smartToken.totalSupply();
1097                     converter = IBancorConverter(ISmartToken(smartToken).owner());
1098                 }
1099 
1100                 // calculate the amount & the conversion fee
1101                 balance = converter.getConnectorBalance(fromToken);
1102                 (, ratio, , , ) = converter.connectors(fromToken);
1103                 amount = formula.calculatePurchaseReturn(supply, balance, ratio, amount);
1104                 fee = amount.mul(converter.conversionFee()).div(CONVERSION_FEE_RESOLUTION);
1105                 amount -= fee;
1106 
1107                 // update the smart token supply for the next iteration
1108                 supply += amount;
1109             }
1110             else if (fromToken == smartToken) { // sell the smart token
1111                 // check if the current smart token has changed
1112                 if (i < 3 || smartToken != _path[i - 3]) {
1113                     supply = smartToken.totalSupply();
1114                     converter = IBancorConverter(ISmartToken(smartToken).owner());
1115                 }
1116 
1117                 // calculate the amount & the conversion fee
1118                 balance = converter.getConnectorBalance(toToken);
1119                 (, ratio, , , ) = converter.connectors(toToken);
1120                 amount = formula.calculateSaleReturn(supply, balance, ratio, amount);
1121                 fee = amount.mul(converter.conversionFee()).div(CONVERSION_FEE_RESOLUTION);
1122                 amount -= fee;
1123 
1124                 // update the smart token supply for the next iteration
1125                 supply -= amount;
1126             }
1127             else { // cross reserve conversion
1128                 // check if the current smart token has changed
1129                 if (i < 3 || smartToken != _path[i - 3]) {
1130                     converter = IBancorConverter(ISmartToken(smartToken).owner());
1131                 }
1132 
1133                 (amount, fee) = getReturn(converter, fromToken, toToken, amount);
1134             }
1135         }
1136 
1137         return (amount, fee);
1138     }
1139 
1140     /**
1141       * @dev claims the caller's tokens, converts them to any other token in the bancor network
1142       * by following a predefined conversion path and transfers the result tokens to a target account
1143       * note that allowance must be set beforehand
1144       * 
1145       * @param _path                conversion path, see conversion path format above
1146       * @param _amount              amount to convert from (in the initial source token)
1147       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1148       * @param _for                 account that will receive the conversion result
1149       * @param _affiliateAccount    affiliate account
1150       * @param _affiliateFee        affiliate fee in PPM
1151       * 
1152       * @return tokens issued in return
1153     */
1154     function claimAndConvertFor2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, address _affiliateAccount, uint256 _affiliateFee) public returns (uint256) {
1155         // we need to transfer the tokens from the caller to the network before we follow
1156         // the conversion path, to allow it to execute the conversion on behalf of the caller
1157         // note: we assume we already have allowance
1158         IERC20Token fromToken = _path[0];
1159         ensureTransferFrom(fromToken, msg.sender, this, _amount);
1160         return convertFor2(_path, _amount, _minReturn, _for, _affiliateAccount, _affiliateFee);
1161     }
1162 
1163     /**
1164       * @dev converts the token to any other token in the bancor network by following
1165       * a predefined conversion path and transfers the result tokens back to the sender
1166       * note that the network should already own the source tokens
1167       * 
1168       * @param _path                conversion path, see conversion path format above
1169       * @param _amount              amount to convert from (in the initial source token)
1170       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1171       * @param _affiliateAccount    affiliate account
1172       * @param _affiliateFee        affiliate fee in PPM
1173       * 
1174       * @return tokens issued in return
1175     */
1176     function convert2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public payable returns (uint256) {
1177         return convertFor2(_path, _amount, _minReturn, msg.sender, _affiliateAccount, _affiliateFee);
1178     }
1179 
1180     /**
1181       * @dev claims the caller's tokens, converts them to any other token in the bancor network
1182       * by following a predefined conversion path and transfers the result tokens back to the sender
1183       * note that allowance must be set beforehand
1184       * 
1185       * @param _path                conversion path, see conversion path format above
1186       * @param _amount              amount to convert from (in the initial source token)
1187       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1188       * @param _affiliateAccount    affiliate account
1189       * @param _affiliateFee        affiliate fee in PPM
1190       * 
1191       * @return tokens issued in return
1192     */
1193     function claimAndConvert2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public returns (uint256) {
1194         return claimAndConvertFor2(_path, _amount, _minReturn, msg.sender, _affiliateAccount, _affiliateFee);
1195     }
1196 
1197     /**
1198       * @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1199       * true on success but revert on failure instead
1200       * 
1201       * @param _token     the token to transfer
1202       * @param _from      the address to transfer the tokens from
1203       * @param _to        the address to transfer the tokens to
1204       * @param _amount    the amount to transfer
1205     */
1206     function ensureTransferFrom(IERC20Token _token, address _from, address _to, uint256 _amount) private {
1207         // We must assume that functions `transfer` and `transferFrom` do not return anything,
1208         // because not all tokens abide the requirement of the ERC20 standard to return success or failure.
1209         // This is because in the current compiler version, the calling contract can handle more returned data than expected but not less.
1210         // This may change in the future, so that the calling contract will revert if the size of the data is not exactly what it expects.
1211         uint256 prevBalance = _token.balanceOf(_to);
1212         if (_from == address(this))
1213             INonStandardERC20(_token).transfer(_to, _amount);
1214         else
1215             INonStandardERC20(_token).transferFrom(_from, _to, _amount);
1216         uint256 postBalance = _token.balanceOf(_to);
1217         require(postBalance > prevBalance);
1218     }
1219 
1220     /**
1221       * @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
1222       * Note that we use the non standard erc-20 interface in which `approve` has no return value so that
1223       * this function will work for both standard and non standard tokens
1224       * 
1225       * @param _token   token to check the allowance in
1226       * @param _spender approved address
1227       * @param _value   allowance amount
1228     */
1229     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
1230         uint256 allowance = _token.allowance(this, _spender);
1231         if (allowance < _value) {
1232             if (allowance > 0)
1233                 INonStandardERC20(_token).approve(_spender, 0);
1234             INonStandardERC20(_token).approve(_spender, _value);
1235         }
1236     }
1237 
1238     function getSignature(
1239         uint256 _customVal,
1240         uint256 _block,
1241         uint8 _v,
1242         bytes32 _r,
1243         bytes32 _s
1244     ) private pure returns (uint256[] memory) {
1245         if (_v == 0x0 && _r == 0x0 && _s == 0x0)
1246             return new uint256[](0);
1247         uint256[] memory signature = new uint256[](5);
1248         signature[0] = _customVal;
1249         signature[1] = _block;
1250         signature[2] = uint256(_v);
1251         signature[3] = uint256(_r);
1252         signature[4] = uint256(_s);
1253         return signature;
1254     }
1255 
1256     function verifyConversionParams(
1257         IERC20Token[] _path,
1258         address _sender,
1259         address _receiver,
1260         uint256[] memory _signature
1261     )
1262         private
1263     {
1264         // verify that the number of elements is odd and that maximum number of 'hops' is 10
1265         require(_path.length > 2 && _path.length <= (1 + 2 * 10) && _path.length % 2 == 1);
1266 
1267         // verify that the account which should receive the conversion result is whitelisted
1268         IContractFeatures features = IContractFeatures(addressOf(CONTRACT_FEATURES));
1269         for (uint256 i = 1; i < _path.length; i += 2) {
1270             IBancorConverter converter = IBancorConverter(ISmartToken(_path[i]).owner());
1271             if (features.isSupported(converter, FeatureIds.CONVERTER_CONVERSION_WHITELIST)) {
1272                 IWhitelist whitelist = converter.conversionWhitelist();
1273                 require(whitelist == address(0) || whitelist.isWhitelisted(_receiver));
1274             }
1275         }
1276 
1277         if (_signature.length >= 5) {
1278             // verify signature
1279             verifyTrustedSender(_path, _sender, _signature);
1280         }
1281         else {
1282             // verify gas price limit
1283             IBancorGasPriceLimit gasPriceLimit = IBancorGasPriceLimit(addressOf(BANCOR_GAS_PRICE_LIMIT));
1284             gasPriceLimit.validateGasPrice(tx.gasprice);
1285         }
1286     }
1287 
1288     function handleValue(IERC20Token _token, uint256 _amount, bool _claim) private {
1289         // if ETH is provided, ensure that the amount is identical to _amount, verify that the source token is an ether token and deposit the ETH in it
1290         if (msg.value > 0) {
1291             require(_amount == msg.value && etherTokens[_token]);
1292             IEtherToken(_token).deposit.value(msg.value)();
1293         }
1294         // Otherwise, claim the tokens from the sender if needed
1295         else if (_claim) {
1296             ensureTransferFrom(_token, msg.sender, this, _amount);
1297         }
1298     }
1299 
1300     /**
1301       * @dev deprecated, backward compatibility
1302     */
1303     function convert(
1304         IERC20Token[] _path,
1305         uint256 _amount,
1306         uint256 _minReturn
1307     ) public payable returns (uint256)
1308     {
1309         return convert2(_path, _amount, _minReturn, address(0), 0);
1310     }
1311 
1312     /**
1313       * @dev deprecated, backward compatibility
1314     */
1315     function claimAndConvert(
1316         IERC20Token[] _path,
1317         uint256 _amount,
1318         uint256 _minReturn
1319     ) public returns (uint256)
1320     {
1321         return claimAndConvert2(_path, _amount, _minReturn, address(0), 0);
1322     }
1323 
1324     /**
1325       * @dev deprecated, backward compatibility
1326     */
1327     function convertFor(
1328         IERC20Token[] _path,
1329         uint256 _amount,
1330         uint256 _minReturn,
1331         address _for
1332     ) public payable returns (uint256)
1333     {
1334         return convertFor2(_path, _amount, _minReturn, _for, address(0), 0);
1335     }
1336 
1337     /**
1338       * @dev deprecated, backward compatibility
1339     */
1340     function claimAndConvertFor(
1341         IERC20Token[] _path,
1342         uint256 _amount,
1343         uint256 _minReturn,
1344         address _for
1345     ) public returns (uint256)
1346     {
1347         return claimAndConvertFor2(_path, _amount, _minReturn, _for, address(0), 0);
1348     }
1349 
1350     /**
1351       * @dev deprecated, backward compatibility
1352     */
1353     function xConvert(
1354         IERC20Token[] _path,
1355         uint256 _amount,
1356         uint256 _minReturn,
1357         bytes32 _toBlockchain,
1358         bytes32 _to,
1359         uint256 _conversionId
1360     )
1361         public
1362         payable
1363         returns (uint256)
1364     {
1365         return xConvert2(_path, _amount, _minReturn, _toBlockchain, _to, _conversionId, address(0), 0);
1366     }
1367 
1368     /**
1369       * @dev deprecated, backward compatibility
1370     */
1371     function xConvertPrioritized2(
1372         IERC20Token[] _path,
1373         uint256 _amount,
1374         uint256 _minReturn,
1375         bytes32 _toBlockchain,
1376         bytes32 _to,
1377         uint256 _conversionId,
1378         uint256[] memory _signature
1379     )
1380         public
1381         payable
1382         returns (uint256)
1383     {
1384         return xConvertPrioritized3(_path, _amount, _minReturn, _toBlockchain, _to, _conversionId, _signature, address(0), 0);
1385     }
1386 
1387     /**
1388       * @dev deprecated, backward compatibility
1389     */
1390     function xConvertPrioritized(
1391         IERC20Token[] _path,
1392         uint256 _amount,
1393         uint256 _minReturn,
1394         bytes32 _toBlockchain,
1395         bytes32 _to,
1396         uint256 _conversionId,
1397         uint256 _block,
1398         uint8 _v,
1399         bytes32 _r,
1400         bytes32 _s
1401     )
1402         public
1403         payable
1404         returns (uint256)
1405     {
1406         // workaround the 'stack too deep' compilation error
1407         uint256[] memory signature = getSignature(_amount, _block, _v, _r, _s);
1408         return xConvertPrioritized3(_path, _amount, _minReturn, _toBlockchain, _to, _conversionId, signature, address(0), 0);
1409         // return xConvertPrioritized3(_path, _amount, _minReturn, _toBlockchain, _to, _conversionId, getSignature(_amount, _block, _v, _r, _s), address(0), 0);
1410     }
1411 
1412     /**
1413       * @dev deprecated, backward compatibility
1414     */
1415     function convertForPrioritized3(
1416         IERC20Token[] _path,
1417         uint256 _amount,
1418         uint256 _minReturn,
1419         address _for,
1420         uint256 _customVal,
1421         uint256 _block,
1422         uint8 _v,
1423         bytes32 _r,
1424         bytes32 _s
1425     )
1426         public
1427         payable
1428         returns (uint256)
1429     {
1430         return convertForPrioritized4(_path, _amount, _minReturn, _for, getSignature(_customVal, _block, _v, _r, _s), address(0), 0);
1431     }
1432 
1433     /**
1434       * @dev deprecated, backward compatibility
1435     */
1436     function convertForPrioritized2(
1437         IERC20Token[] _path,
1438         uint256 _amount,
1439         uint256 _minReturn,
1440         address _for,
1441         uint256 _block,
1442         uint8 _v,
1443         bytes32 _r,
1444         bytes32 _s
1445     )
1446         public
1447         payable
1448         returns (uint256)
1449     {
1450         return convertForPrioritized4(_path, _amount, _minReturn, _for, getSignature(_amount, _block, _v, _r, _s), address(0), 0);
1451     }
1452 
1453     /**
1454       * @dev deprecated, backward compatibility
1455     */
1456     function convertForPrioritized(
1457         IERC20Token[] _path,
1458         uint256 _amount,
1459         uint256 _minReturn,
1460         address _for,
1461         uint256 _block,
1462         uint256 _nonce,
1463         uint8 _v,
1464         bytes32 _r,
1465         bytes32 _s)
1466         public payable returns (uint256)
1467     {
1468         _nonce;
1469         return convertForPrioritized4(_path, _amount, _minReturn, _for, getSignature(_amount, _block, _v, _r, _s), address(0), 0);
1470     }
1471 }