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
65     // deprecated, backward compatibility
66     function convert(
67         IERC20Token[] _path,
68         uint256 _amount,
69         uint256 _minReturn
70     ) public payable returns (uint256);
71 
72     // deprecated, backward compatibility
73     function claimAndConvert(
74         IERC20Token[] _path,
75         uint256 _amount,
76         uint256 _minReturn
77     ) public returns (uint256);
78 
79     // deprecated, backward compatibility
80     function convertFor(
81         IERC20Token[] _path,
82         uint256 _amount,
83         uint256 _minReturn,
84         address _for
85     ) public payable returns (uint256);
86 
87     // deprecated, backward compatibility
88     function claimAndConvertFor(
89         IERC20Token[] _path,
90         uint256 _amount,
91         uint256 _minReturn,
92         address _for
93     ) public returns (uint256);
94 }
95 
96 // File: contracts/IConversionPathFinder.sol
97 
98 pragma solidity 0.4.26;
99 
100 
101 /*
102     Conversion Path Finder interface
103 */
104 contract IConversionPathFinder {
105     function findPath(address _sourceToken, address _targetToken) public view returns (address[] memory);
106 }
107 
108 // File: contracts/utility/interfaces/IOwned.sol
109 
110 pragma solidity 0.4.26;
111 
112 /*
113     Owned contract interface
114 */
115 contract IOwned {
116     // this function isn't abstract since the compiler emits automatically generated getter functions as external
117     function owner() public view returns (address) {this;}
118 
119     function transferOwnership(address _newOwner) public;
120     function acceptOwnership() public;
121 }
122 
123 // File: contracts/utility/interfaces/ITokenHolder.sol
124 
125 pragma solidity 0.4.26;
126 
127 
128 
129 /*
130     Token Holder interface
131 */
132 contract ITokenHolder is IOwned {
133     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
134 }
135 
136 // File: contracts/converter/interfaces/IConverterAnchor.sol
137 
138 pragma solidity 0.4.26;
139 
140 
141 
142 /*
143     Converter Anchor interface
144 */
145 contract IConverterAnchor is IOwned, ITokenHolder {
146 }
147 
148 // File: contracts/utility/interfaces/IWhitelist.sol
149 
150 pragma solidity 0.4.26;
151 
152 /*
153     Whitelist interface
154 */
155 contract IWhitelist {
156     function isWhitelisted(address _address) public view returns (bool);
157 }
158 
159 // File: contracts/converter/interfaces/IConverter.sol
160 
161 pragma solidity 0.4.26;
162 
163 
164 
165 
166 
167 /*
168     Converter interface
169 */
170 contract IConverter is IOwned {
171     function converterType() public pure returns (uint16);
172     function anchor() public view returns (IConverterAnchor) {this;}
173     function isActive() public view returns (bool);
174 
175     function rateAndFee(IERC20Token _sourceToken, IERC20Token _targetToken, uint256 _amount) public view returns (uint256, uint256);
176     function convert(IERC20Token _sourceToken,
177                      IERC20Token _targetToken,
178                      uint256 _amount,
179                      address _trader,
180                      address _beneficiary) public payable returns (uint256);
181 
182     function conversionWhitelist() public view returns (IWhitelist) {this;}
183     function conversionFee() public view returns (uint32) {this;}
184     function maxConversionFee() public view returns (uint32) {this;}
185     function reserveBalance(IERC20Token _reserveToken) public view returns (uint256);
186     function() external payable;
187 
188     function transferAnchorOwnership(address _newOwner) public;
189     function acceptAnchorOwnership() public;
190     function setConversionFee(uint32 _conversionFee) public;
191     function setConversionWhitelist(IWhitelist _whitelist) public;
192     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
193     function withdrawETH(address _to) public;
194     function addReserve(IERC20Token _token, uint32 _ratio) public;
195 
196     // deprecated, backward compatibility
197     function token() public view returns (IConverterAnchor);
198     function transferTokenOwnership(address _newOwner) public;
199     function acceptTokenOwnership() public;
200     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool);
201     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
202     function connectorTokens(uint256 _index) public view returns (IERC20Token);
203     function connectorTokenCount() public view returns (uint16);
204 }
205 
206 // File: contracts/converter/interfaces/IBancorFormula.sol
207 
208 pragma solidity 0.4.26;
209 
210 /*
211     Bancor Formula interface
212 */
213 contract IBancorFormula {
214     function purchaseRate(uint256 _supply,
215                           uint256 _reserveBalance,
216                           uint32 _reserveWeight,
217                           uint256 _amount)
218                           public view returns (uint256);
219 
220     function saleRate(uint256 _supply,
221                       uint256 _reserveBalance,
222                       uint32 _reserveWeight,
223                       uint256 _amount)
224                       public view returns (uint256);
225 
226     function crossReserveRate(uint256 _sourceReserveBalance,
227                               uint32 _sourceReserveWeight,
228                               uint256 _targetReserveBalance,
229                               uint32 _targetReserveWeight,
230                               uint256 _amount)
231                               public view returns (uint256);
232 
233     function fundCost(uint256 _supply,
234                       uint256 _reserveBalance,
235                       uint32 _reserveRatio,
236                       uint256 _amount)
237                       public view returns (uint256);
238 
239     function liquidateRate(uint256 _supply,
240                            uint256 _reserveBalance,
241                            uint32 _reserveRatio,
242                            uint256 _amount)
243                            public view returns (uint256);
244 }
245 
246 // File: contracts/utility/Owned.sol
247 
248 pragma solidity 0.4.26;
249 
250 
251 /**
252   * @dev Provides support and utilities for contract ownership
253 */
254 contract Owned is IOwned {
255     address public owner;
256     address public newOwner;
257 
258     /**
259       * @dev triggered when the owner is updated
260       *
261       * @param _prevOwner previous owner
262       * @param _newOwner  new owner
263     */
264     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
265 
266     /**
267       * @dev initializes a new Owned instance
268     */
269     constructor() public {
270         owner = msg.sender;
271     }
272 
273     // allows execution by the owner only
274     modifier ownerOnly {
275         _ownerOnly();
276         _;
277     }
278 
279     // error message binary size optimization
280     function _ownerOnly() internal view {
281         require(msg.sender == owner, "ERR_ACCESS_DENIED");
282     }
283 
284     /**
285       * @dev allows transferring the contract ownership
286       * the new owner still needs to accept the transfer
287       * can only be called by the contract owner
288       *
289       * @param _newOwner    new contract owner
290     */
291     function transferOwnership(address _newOwner) public ownerOnly {
292         require(_newOwner != owner, "ERR_SAME_OWNER");
293         newOwner = _newOwner;
294     }
295 
296     /**
297       * @dev used by a new owner to accept an ownership transfer
298     */
299     function acceptOwnership() public {
300         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
301         emit OwnerUpdate(owner, newOwner);
302         owner = newOwner;
303         newOwner = address(0);
304     }
305 }
306 
307 // File: contracts/utility/Utils.sol
308 
309 pragma solidity 0.4.26;
310 
311 /**
312   * @dev Utilities & Common Modifiers
313 */
314 contract Utils {
315     // verifies that a value is greater than zero
316     modifier greaterThanZero(uint256 _value) {
317         _greaterThanZero(_value);
318         _;
319     }
320 
321     // error message binary size optimization
322     function _greaterThanZero(uint256 _value) internal pure {
323         require(_value > 0, "ERR_ZERO_VALUE");
324     }
325 
326     // validates an address - currently only checks that it isn't null
327     modifier validAddress(address _address) {
328         _validAddress(_address);
329         _;
330     }
331 
332     // error message binary size optimization
333     function _validAddress(address _address) internal pure {
334         require(_address != address(0), "ERR_INVALID_ADDRESS");
335     }
336 
337     // verifies that the address is different than this contract address
338     modifier notThis(address _address) {
339         _notThis(_address);
340         _;
341     }
342 
343     // error message binary size optimization
344     function _notThis(address _address) internal view {
345         require(_address != address(this), "ERR_ADDRESS_IS_SELF");
346     }
347 }
348 
349 // File: contracts/utility/interfaces/IContractRegistry.sol
350 
351 pragma solidity 0.4.26;
352 
353 /*
354     Contract Registry interface
355 */
356 contract IContractRegistry {
357     function addressOf(bytes32 _contractName) public view returns (address);
358 
359     // deprecated, backward compatibility
360     function getAddress(bytes32 _contractName) public view returns (address);
361 }
362 
363 // File: contracts/utility/ContractRegistryClient.sol
364 
365 pragma solidity 0.4.26;
366 
367 
368 
369 
370 /**
371   * @dev Base contract for ContractRegistry clients
372 */
373 contract ContractRegistryClient is Owned, Utils {
374     bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
375     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
376     bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
377     bytes32 internal constant CONVERTER_FACTORY = "ConverterFactory";
378     bytes32 internal constant CONVERSION_PATH_FINDER = "ConversionPathFinder";
379     bytes32 internal constant CONVERTER_UPGRADER = "BancorConverterUpgrader";
380     bytes32 internal constant CONVERTER_REGISTRY = "BancorConverterRegistry";
381     bytes32 internal constant CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
382     bytes32 internal constant BNT_TOKEN = "BNTToken";
383     bytes32 internal constant BANCOR_X = "BancorX";
384     bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
385 
386     IContractRegistry public registry;      // address of the current contract-registry
387     IContractRegistry public prevRegistry;  // address of the previous contract-registry
388     bool public onlyOwnerCanUpdateRegistry; // only an owner can update the contract-registry
389 
390     /**
391       * @dev verifies that the caller is mapped to the given contract name
392       *
393       * @param _contractName    contract name
394     */
395     modifier only(bytes32 _contractName) {
396         _only(_contractName);
397         _;
398     }
399 
400     // error message binary size optimization
401     function _only(bytes32 _contractName) internal view {
402         require(msg.sender == addressOf(_contractName), "ERR_ACCESS_DENIED");
403     }
404 
405     /**
406       * @dev initializes a new ContractRegistryClient instance
407       *
408       * @param  _registry   address of a contract-registry contract
409     */
410     constructor(IContractRegistry _registry) internal validAddress(_registry) {
411         registry = IContractRegistry(_registry);
412         prevRegistry = IContractRegistry(_registry);
413     }
414 
415     /**
416       * @dev updates to the new contract-registry
417      */
418     function updateRegistry() public {
419         // verify that this function is permitted
420         require(msg.sender == owner || !onlyOwnerCanUpdateRegistry, "ERR_ACCESS_DENIED");
421 
422         // get the new contract-registry
423         IContractRegistry newRegistry = IContractRegistry(addressOf(CONTRACT_REGISTRY));
424 
425         // verify that the new contract-registry is different and not zero
426         require(newRegistry != address(registry) && newRegistry != address(0), "ERR_INVALID_REGISTRY");
427 
428         // verify that the new contract-registry is pointing to a non-zero contract-registry
429         require(newRegistry.addressOf(CONTRACT_REGISTRY) != address(0), "ERR_INVALID_REGISTRY");
430 
431         // save a backup of the current contract-registry before replacing it
432         prevRegistry = registry;
433 
434         // replace the current contract-registry with the new contract-registry
435         registry = newRegistry;
436     }
437 
438     /**
439       * @dev restores the previous contract-registry
440     */
441     function restoreRegistry() public ownerOnly {
442         // restore the previous contract-registry
443         registry = prevRegistry;
444     }
445 
446     /**
447       * @dev restricts the permission to update the contract-registry
448       *
449       * @param _onlyOwnerCanUpdateRegistry  indicates whether or not permission is restricted to owner only
450     */
451     function restrictRegistryUpdate(bool _onlyOwnerCanUpdateRegistry) public ownerOnly {
452         // change the permission to update the contract-registry
453         onlyOwnerCanUpdateRegistry = _onlyOwnerCanUpdateRegistry;
454     }
455 
456     /**
457       * @dev returns the address associated with the given contract name
458       *
459       * @param _contractName    contract name
460       *
461       * @return contract address
462     */
463     function addressOf(bytes32 _contractName) internal view returns (address) {
464         return registry.addressOf(_contractName);
465     }
466 }
467 
468 // File: contracts/utility/ReentrancyGuard.sol
469 
470 pragma solidity 0.4.26;
471 
472 /**
473   * @dev ReentrancyGuard
474   *
475   * The contract provides protection against re-entrancy - calling a function (directly or
476   * indirectly) from within itself.
477 */
478 contract ReentrancyGuard {
479     // true while protected code is being executed, false otherwise
480     bool private locked = false;
481 
482     /**
483       * @dev ensures instantiation only by sub-contracts
484     */
485     constructor() internal {}
486 
487     // protects a function against reentrancy attacks
488     modifier protected() {
489         _protected();
490         locked = true;
491         _;
492         locked = false;
493     }
494 
495     // error message binary size optimization
496     function _protected() internal view {
497         require(!locked, "ERR_REENTRANCY");
498     }
499 }
500 
501 // File: contracts/utility/TokenHandler.sol
502 
503 pragma solidity 0.4.26;
504 
505 
506 contract TokenHandler {
507     bytes4 private constant APPROVE_FUNC_SELECTOR = bytes4(keccak256("approve(address,uint256)"));
508     bytes4 private constant TRANSFER_FUNC_SELECTOR = bytes4(keccak256("transfer(address,uint256)"));
509     bytes4 private constant TRANSFER_FROM_FUNC_SELECTOR = bytes4(keccak256("transferFrom(address,address,uint256)"));
510 
511     /**
512       * @dev executes the ERC20 token's `approve` function and reverts upon failure
513       * the main purpose of this function is to prevent a non standard ERC20 token
514       * from failing silently
515       *
516       * @param _token   ERC20 token address
517       * @param _spender approved address
518       * @param _value   allowance amount
519     */
520     function safeApprove(IERC20Token _token, address _spender, uint256 _value) public {
521        execute(_token, abi.encodeWithSelector(APPROVE_FUNC_SELECTOR, _spender, _value));
522     }
523 
524     /**
525       * @dev executes the ERC20 token's `transfer` function and reverts upon failure
526       * the main purpose of this function is to prevent a non standard ERC20 token
527       * from failing silently
528       *
529       * @param _token   ERC20 token address
530       * @param _to      target address
531       * @param _value   transfer amount
532     */
533     function safeTransfer(IERC20Token _token, address _to, uint256 _value) public {
534        execute(_token, abi.encodeWithSelector(TRANSFER_FUNC_SELECTOR, _to, _value));
535     }
536 
537     /**
538       * @dev executes the ERC20 token's `transferFrom` function and reverts upon failure
539       * the main purpose of this function is to prevent a non standard ERC20 token
540       * from failing silently
541       *
542       * @param _token   ERC20 token address
543       * @param _from    source address
544       * @param _to      target address
545       * @param _value   transfer amount
546     */
547     function safeTransferFrom(IERC20Token _token, address _from, address _to, uint256 _value) public {
548        execute(_token, abi.encodeWithSelector(TRANSFER_FROM_FUNC_SELECTOR, _from, _to, _value));
549     }
550 
551     /**
552       * @dev executes a function on the ERC20 token and reverts upon failure
553       * the main purpose of this function is to prevent a non standard ERC20 token
554       * from failing silently
555       *
556       * @param _token   ERC20 token address
557       * @param _data    data to pass in to the token's contract for execution
558     */
559     function execute(IERC20Token _token, bytes memory _data) private {
560         uint256[1] memory ret = [uint256(1)];
561 
562         assembly {
563             let success := call(
564                 gas,            // gas remaining
565                 _token,         // destination address
566                 0,              // no ether
567                 add(_data, 32), // input buffer (starts after the first 32 bytes in the `data` array)
568                 mload(_data),   // input length (loaded from the first 32 bytes in the `data` array)
569                 ret,            // output buffer
570                 32              // output length
571             )
572             if iszero(success) {
573                 revert(0, 0)
574             }
575         }
576 
577         require(ret[0] != 0, "ERR_TRANSFER_FAILED");
578     }
579 }
580 
581 // File: contracts/utility/TokenHolder.sol
582 
583 pragma solidity 0.4.26;
584 
585 
586 
587 
588 
589 
590 /**
591   * @dev We consider every contract to be a 'token holder' since it's currently not possible
592   * for a contract to deny receiving tokens.
593   *
594   * The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
595   * the owner to send tokens that were sent to the contract by mistake back to their sender.
596   *
597   * Note that we use the non standard ERC-20 interface which has no return value for transfer
598   * in order to support both non standard as well as standard token contracts.
599   * see https://github.com/ethereum/solidity/issues/4116
600 */
601 contract TokenHolder is ITokenHolder, TokenHandler, Owned, Utils {
602     /**
603       * @dev withdraws tokens held by the contract and sends them to an account
604       * can only be called by the owner
605       *
606       * @param _token   ERC20 token contract address
607       * @param _to      account to receive the new amount
608       * @param _amount  amount to withdraw
609     */
610     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
611         public
612         ownerOnly
613         validAddress(_token)
614         validAddress(_to)
615         notThis(_to)
616     {
617         safeTransfer(_token, _to, _amount);
618     }
619 }
620 
621 // File: contracts/utility/SafeMath.sol
622 
623 pragma solidity 0.4.26;
624 
625 /**
626   * @dev Library for basic math operations with overflow/underflow protection
627 */
628 library SafeMath {
629     /**
630       * @dev returns the sum of _x and _y, reverts if the calculation overflows
631       *
632       * @param _x   value 1
633       * @param _y   value 2
634       *
635       * @return sum
636     */
637     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
638         uint256 z = _x + _y;
639         require(z >= _x, "ERR_OVERFLOW");
640         return z;
641     }
642 
643     /**
644       * @dev returns the difference of _x minus _y, reverts if the calculation underflows
645       *
646       * @param _x   minuend
647       * @param _y   subtrahend
648       *
649       * @return difference
650     */
651     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
652         require(_x >= _y, "ERR_UNDERFLOW");
653         return _x - _y;
654     }
655 
656     /**
657       * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
658       *
659       * @param _x   factor 1
660       * @param _y   factor 2
661       *
662       * @return product
663     */
664     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
665         // gas optimization
666         if (_x == 0)
667             return 0;
668 
669         uint256 z = _x * _y;
670         require(z / _x == _y, "ERR_OVERFLOW");
671         return z;
672     }
673 
674     /**
675       * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
676       *
677       * @param _x   dividend
678       * @param _y   divisor
679       *
680       * @return quotient
681     */
682     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
683         require(_y > 0, "ERR_DIVIDE_BY_ZERO");
684         uint256 c = _x / _y;
685         return c;
686     }
687 }
688 
689 // File: contracts/token/interfaces/IEtherToken.sol
690 
691 pragma solidity 0.4.26;
692 
693 
694 /*
695     Ether Token interface
696 */
697 contract IEtherToken is IERC20Token {
698     function deposit() public payable;
699     function withdraw(uint256 _amount) public;
700     function depositTo(address _to) public payable;
701     function withdrawTo(address _to, uint256 _amount) public;
702 }
703 
704 // File: contracts/token/interfaces/ISmartToken.sol
705 
706 pragma solidity 0.4.26;
707 
708 
709 
710 
711 /*
712     Smart Token interface
713 */
714 contract ISmartToken is IConverterAnchor, IERC20Token {
715     function disableTransfers(bool _disable) public;
716     function issue(address _to, uint256 _amount) public;
717     function destroy(address _from, uint256 _amount) public;
718 }
719 
720 // File: contracts/bancorx/interfaces/IBancorX.sol
721 
722 pragma solidity 0.4.26;
723 
724 
725 contract IBancorX {
726     function token() public view returns (IERC20Token) {this;}
727     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
728     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
729 }
730 
731 // File: contracts/BancorNetwork.sol
732 
733 pragma solidity 0.4.26;
734 
735 
736 
737 
738 
739 
740 
741 
742 
743 
744 
745 
746 
747 // interface of older converters for backward compatibility
748 contract ILegacyConverter {
749     function change(IERC20Token _sourceToken, IERC20Token _targetToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
750 }
751 
752 /**
753   * @dev The BancorNetwork contract is the main entry point for Bancor token conversions.
754   * It also allows for the conversion of any token in the Bancor Network to any other token in a single
755   * transaction by providing a conversion path.
756   *
757   * A note on Conversion Path: Conversion path is a data structure that is used when converting a token
758   * to another token in the Bancor Network, when the conversion cannot necessarily be done by a single
759   * converter and might require multiple 'hops'.
760   * The path defines which converters should be used and what kind of conversion should be done in each step.
761   *
762   * The path format doesn't include complex structure; instead, it is represented by a single array
763   * in which each 'hop' is represented by a 2-tuple - converter anchor & target token.
764   * In addition, the first element is always the source token.
765   * The converter anchor is only used as a pointer to a converter (since converter addresses are more
766   * likely to change as opposed to anchor addresses).
767   *
768   * Format:
769   * [source token, converter anchor, target token, converter anchor, target token...]
770 */
771 contract BancorNetwork is IBancorNetwork, TokenHolder, ContractRegistryClient, ReentrancyGuard {
772     using SafeMath for uint256;
773 
774     uint256 private constant CONVERSION_FEE_RESOLUTION = 1000000;
775     uint256 private constant AFFILIATE_FEE_RESOLUTION = 1000000;
776     address private constant ETH_RESERVE_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
777 
778     struct ConversionStep {
779         IConverter converter;
780         IConverterAnchor anchor;
781         IERC20Token sourceToken;
782         IERC20Token targetToken;
783         address beneficiary;
784         bool isV28OrHigherConverter;
785         bool processAffiliateFee;
786     }
787 
788     uint256 public maxAffiliateFee = 30000;     // maximum affiliate-fee
789 
790     mapping (address => bool) public etherTokens;       // list of all supported ether tokens
791 
792     /**
793       * @dev triggered when a conversion between two tokens occurs
794       *
795       * @param _smartToken  anchor governed by the converter
796       * @param _fromToken   source ERC20 token
797       * @param _toToken     target ERC20 token
798       * @param _fromAmount  amount converted, in the source token
799       * @param _toAmount    amount returned, minus conversion fee
800       * @param _trader      wallet that initiated the trade
801     */
802     event Conversion(
803         address indexed _smartToken,
804         address indexed _fromToken,
805         address indexed _toToken,
806         uint256 _fromAmount,
807         uint256 _toAmount,
808         address _trader
809     );
810 
811     /**
812       * @dev initializes a new BancorNetwork instance
813       *
814       * @param _registry    address of a contract registry contract
815     */
816     constructor(IContractRegistry _registry) ContractRegistryClient(_registry) public {
817         etherTokens[ETH_RESERVE_ADDRESS] = true;
818     }
819 
820     /**
821       * @dev allows the owner to update the maximum affiliate-fee
822       *
823       * @param _maxAffiliateFee   maximum affiliate-fee
824     */
825     function setMaxAffiliateFee(uint256 _maxAffiliateFee)
826         public
827         ownerOnly
828     {
829         require(_maxAffiliateFee <= AFFILIATE_FEE_RESOLUTION, "ERR_INVALID_AFFILIATE_FEE");
830         maxAffiliateFee = _maxAffiliateFee;
831     }
832 
833     /**
834       * @dev allows the owner to register/unregister ether tokens
835       *
836       * @param _token       ether token contract address
837       * @param _register    true to register, false to unregister
838     */
839     function registerEtherToken(IEtherToken _token, bool _register)
840         public
841         ownerOnly
842         validAddress(_token)
843         notThis(_token)
844     {
845         etherTokens[_token] = _register;
846     }
847 
848     /**
849       * @dev returns the conversion path between two tokens in the network
850       * note that this method is quite expensive in terms of gas and should generally be called off-chain
851       *
852       * @param _sourceToken source token address
853       * @param _targetToken target token address
854       *
855       * @return conversion path between the two tokens
856     */
857     function conversionPath(IERC20Token _sourceToken, IERC20Token _targetToken) public view returns (address[]) {
858         IConversionPathFinder pathFinder = IConversionPathFinder(addressOf(CONVERSION_PATH_FINDER));
859         return pathFinder.findPath(_sourceToken, _targetToken);
860     }
861 
862     /**
863       * @dev returns the expected rate of converting a given amount on a given path
864       * note that there is no support for circular paths
865       *
866       * @param _path        conversion path (see conversion path format above)
867       * @param _amount      amount of _path[0] tokens received from the sender
868       *
869       * @return expected rate
870     */
871     function rateByPath(IERC20Token[] _path, uint256 _amount) public view returns (uint256) {
872         uint256 amount;
873         uint256 fee;
874         uint256 supply;
875         uint256 balance;
876         uint32 weight;
877         IConverter converter;
878         IBancorFormula formula = IBancorFormula(addressOf(BANCOR_FORMULA));
879 
880         amount = _amount;
881 
882         // verify that the number of elements is larger than 2 and odd
883         require(_path.length > 2 && _path.length % 2 == 1, "ERR_INVALID_PATH");
884 
885         // iterate over the conversion path
886         for (uint256 i = 2; i < _path.length; i += 2) {
887             IERC20Token sourceToken = _path[i - 2];
888             IERC20Token anchor = _path[i - 1];
889             IERC20Token targetToken = _path[i];
890 
891             converter = IConverter(IConverterAnchor(anchor).owner());
892 
893             // backward compatibility
894             sourceToken = getConverterTokenAddress(converter, sourceToken);
895             targetToken = getConverterTokenAddress(converter, targetToken);
896 
897             if (targetToken == anchor) { // buy the smart token
898                 // check if the current smart token has changed
899                 if (i < 3 || anchor != _path[i - 3])
900                     supply = ISmartToken(anchor).totalSupply();
901 
902                 // get the amount & the conversion fee
903                 balance = converter.getConnectorBalance(sourceToken);
904                 (, weight, , , ) = converter.connectors(sourceToken);
905                 amount = formula.purchaseRate(supply, balance, weight, amount);
906                 fee = amount.mul(converter.conversionFee()).div(CONVERSION_FEE_RESOLUTION);
907                 amount -= fee;
908 
909                 // update the smart token supply for the next iteration
910                 supply = supply.add(amount);
911             }
912             else if (sourceToken == anchor) { // sell the smart token
913                 // check if the current smart token has changed
914                 if (i < 3 || anchor != _path[i - 3])
915                     supply = ISmartToken(anchor).totalSupply();
916 
917                 // get the amount & the conversion fee
918                 balance = converter.getConnectorBalance(targetToken);
919                 (, weight, , , ) = converter.connectors(targetToken);
920                 amount = formula.saleRate(supply, balance, weight, amount);
921                 fee = amount.mul(converter.conversionFee()).div(CONVERSION_FEE_RESOLUTION);
922                 amount -= fee;
923 
924                 // update the smart token supply for the next iteration
925                 supply = supply.sub(amount);
926             }
927             else { // cross reserve conversion
928                 (amount, fee) = getReturn(converter, sourceToken, targetToken, amount);
929             }
930         }
931 
932         return amount;
933     }
934 
935     /**
936       * @dev converts the token to any other token in the bancor network by following
937       * a predefined conversion path and transfers the result tokens to a target account
938       * affiliate account/fee can also be passed in to receive a conversion fee (on top of the liquidity provider fees)
939       * note that the network should already have been given allowance of the source token (if not ETH)
940       *
941       * @param _path                conversion path, see conversion path format above
942       * @param _amount              amount to convert from, in the source token
943       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be greater than zero
944       * @param _beneficiary         account that will receive the conversion result or 0x0 to send the result to the sender account
945       * @param _affiliateAccount    wallet address to receive the affiliate fee or 0x0 to disable affiliate fee
946       * @param _affiliateFee        affiliate fee in PPM or 0 to disable affiliate fee
947       *
948       * @return amount of tokens received from the conversion
949     */
950     function convertByPath(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _beneficiary, address _affiliateAccount, uint256 _affiliateFee)
951         public
952         payable
953         protected
954         greaterThanZero(_minReturn)
955         returns (uint256)
956     {
957         // verify that the path contrains at least a single 'hop' and that the number of elements is odd
958         require(_path.length > 2 && _path.length % 2 == 1, "ERR_INVALID_PATH");
959 
960         // validate msg.value and prepare the source token for the conversion
961         handleSourceToken(_path[0], IConverterAnchor(_path[1]), _amount);
962 
963         // check if affiliate fee is enabled
964         bool affiliateFeeEnabled = false;
965         if (address(_affiliateAccount) == 0) {
966             require(_affiliateFee == 0, "ERR_INVALID_AFFILIATE_FEE");
967         }
968         else {
969             require(0 < _affiliateFee && _affiliateFee <= maxAffiliateFee, "ERR_INVALID_AFFILIATE_FEE");
970             affiliateFeeEnabled = true;
971         }
972 
973         // check if beneficiary is set
974         address beneficiary = msg.sender;
975         if (_beneficiary != address(0))
976             beneficiary = _beneficiary;
977 
978         // convert and get the resulting amount
979         ConversionStep[] memory data = createConversionData(_path, beneficiary, affiliateFeeEnabled);
980         uint256 amount = doConversion(data, _amount, _minReturn, _affiliateAccount, _affiliateFee);
981 
982         // handle the conversion target tokens
983         handleTargetToken(data, amount, beneficiary);
984 
985         return amount;
986     }
987 
988     /**
989       * @dev converts any other token to BNT in the bancor network by following
990       a predefined conversion path and transfers the result to an account on a different blockchain
991       * note that the network should already have been given allowance of the source token (if not ETH)
992       *
993       * @param _path                conversion path, see conversion path format above
994       * @param _amount              amount to convert from, in the source token
995       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be greater than zero
996       * @param _targetBlockchain    blockchain BNT will be issued on
997       * @param _targetAccount       address/account on the target blockchain to send the BNT to
998       * @param _conversionId        pre-determined unique (if non zero) id which refers to this transaction
999       *
1000       * @return the amount of BNT received from this conversion
1001     */
1002     function xConvert(
1003         IERC20Token[] _path,
1004         uint256 _amount,
1005         uint256 _minReturn,
1006         bytes32 _targetBlockchain,
1007         bytes32 _targetAccount,
1008         uint256 _conversionId
1009     )
1010         public
1011         payable
1012         returns (uint256)
1013     {
1014         return xConvert2(_path, _amount, _minReturn, _targetBlockchain, _targetAccount, _conversionId, address(0), 0);
1015     }
1016 
1017     /**
1018       * @dev converts any other token to BNT in the bancor network by following
1019       a predefined conversion path and transfers the result to an account on a different blockchain
1020       * note that the network should already have been given allowance of the source token (if not ETH)
1021       *
1022       * @param _path                conversion path, see conversion path format above
1023       * @param _amount              amount to convert from, in the source token
1024       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be greater than zero
1025       * @param _targetBlockchain    blockchain BNT will be issued on
1026       * @param _targetAccount       address/account on the target blockchain to send the BNT to
1027       * @param _conversionId        pre-determined unique (if non zero) id which refers to this transaction
1028       * @param _affiliateAccount    affiliate account
1029       * @param _affiliateFee        affiliate fee in PPM
1030       *
1031       * @return the amount of BNT received from this conversion
1032     */
1033     function xConvert2(
1034         IERC20Token[] _path,
1035         uint256 _amount,
1036         uint256 _minReturn,
1037         bytes32 _targetBlockchain,
1038         bytes32 _targetAccount,
1039         uint256 _conversionId,
1040         address _affiliateAccount,
1041         uint256 _affiliateFee
1042     )
1043         public
1044         payable
1045         greaterThanZero(_minReturn)
1046         returns (uint256)
1047     {
1048         IERC20Token targetToken = _path[_path.length - 1];
1049         IBancorX bancorX = IBancorX(addressOf(BANCOR_X));
1050 
1051         // verify that the destination token is BNT
1052         require(targetToken == addressOf(BNT_TOKEN), "ERR_INVALID_TARGET_TOKEN");
1053 
1054         // convert and get the resulting amount
1055         uint256 amount = convertByPath(_path, _amount, _minReturn, this, _affiliateAccount, _affiliateFee);
1056 
1057         // grant BancorX allowance
1058         ensureAllowance(targetToken, bancorX, amount);
1059 
1060         // transfer the resulting amount to BancorX
1061         bancorX.xTransfer(_targetBlockchain, _targetAccount, amount, _conversionId);
1062 
1063         return amount;
1064     }
1065 
1066     /**
1067       * @dev allows a user to convert a token that was sent from another blockchain into any other
1068       * token on the BancorNetwork
1069       * ideally this transaction is created before the previous conversion is even complete, so
1070       * so the input amount isn't known at that point - the amount is actually take from the
1071       * BancorX contract directly by specifying the conversion id
1072       *
1073       * @param _path            conversion path
1074       * @param _bancorX         address of the BancorX contract for the source token
1075       * @param _conversionId    pre-determined unique (if non zero) id which refers to this conversion
1076       * @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1077       * @param _beneficiary     wallet to receive the conversion result
1078       *
1079       * @return amount of tokens received from the conversion
1080     */
1081     function completeXConversion(IERC20Token[] _path, IBancorX _bancorX, uint256 _conversionId, uint256 _minReturn, address _beneficiary)
1082         public returns (uint256)
1083     {
1084         // verify that the source token is the BancorX token
1085         require(_path[0] == _bancorX.token(), "ERR_INVALID_SOURCE_TOKEN");
1086 
1087         // get conversion amount from BancorX contract
1088         uint256 amount = _bancorX.getXTransferAmount(_conversionId, msg.sender);
1089 
1090         // perform the conversion
1091         return convertByPath(_path, amount, _minReturn, _beneficiary, address(0), 0);
1092     }
1093 
1094     /**
1095       * @dev executes the actual conversion by following the conversion path
1096       *
1097       * @param _data                conversion data, see ConversionStep struct above
1098       * @param _amount              amount to convert from, in the source token
1099       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be greater than zero
1100       * @param _affiliateAccount    affiliate account
1101       * @param _affiliateFee        affiliate fee in PPM
1102       *
1103       * @return amount of tokens received from the conversion
1104     */
1105     function doConversion(
1106         ConversionStep[] _data,
1107         uint256 _amount,
1108         uint256 _minReturn,
1109         address _affiliateAccount,
1110         uint256 _affiliateFee
1111     ) private returns (uint256) {
1112         uint256 toAmount;
1113         uint256 fromAmount = _amount;
1114 
1115         // iterate over the conversion data
1116         for (uint256 i = 0; i < _data.length; i++) {
1117             ConversionStep memory stepData = _data[i];
1118 
1119             // newer converter
1120             if (stepData.isV28OrHigherConverter) {
1121                 // transfer the tokens to the converter only if the network contract currently holds the tokens
1122                 // not needed with ETH or if it's the first conversion step
1123                 if (i != 0 && _data[i - 1].beneficiary == address(this) && !etherTokens[stepData.sourceToken])
1124                     safeTransfer(stepData.sourceToken, stepData.converter, fromAmount);
1125             }
1126             // older converter
1127             // if the source token is the smart token, no need to do any transfers as the converter controls it
1128             else if (stepData.sourceToken != ISmartToken(stepData.anchor)) {
1129                 // grant allowance for it to transfer the tokens from the network contract
1130                 ensureAllowance(stepData.sourceToken, stepData.converter, fromAmount);
1131             }
1132 
1133             // do the conversion
1134             if (!stepData.isV28OrHigherConverter)
1135                 toAmount = ILegacyConverter(stepData.converter).change(stepData.sourceToken, stepData.targetToken, fromAmount, 1);
1136             else if (etherTokens[stepData.sourceToken])
1137                 toAmount = stepData.converter.convert.value(msg.value)(stepData.sourceToken, stepData.targetToken, fromAmount, msg.sender, stepData.beneficiary);
1138             else
1139                 toAmount = stepData.converter.convert(stepData.sourceToken, stepData.targetToken, fromAmount, msg.sender, stepData.beneficiary);
1140 
1141             // pay affiliate-fee if needed
1142             if (stepData.processAffiliateFee) {
1143                 uint256 affiliateAmount = toAmount.mul(_affiliateFee).div(AFFILIATE_FEE_RESOLUTION);
1144                 require(stepData.targetToken.transfer(_affiliateAccount, affiliateAmount), "ERR_FEE_TRANSFER_FAILED");
1145                 toAmount -= affiliateAmount;
1146             }
1147 
1148             emit Conversion(stepData.anchor, stepData.sourceToken, stepData.targetToken, fromAmount, toAmount, msg.sender);
1149             fromAmount = toAmount;
1150         }
1151 
1152         // ensure the trade meets the minimum requested amount
1153         require(toAmount >= _minReturn, "ERR_RETURN_TOO_LOW");
1154 
1155         return toAmount;
1156     }
1157 
1158     /**
1159       * @dev validates msg.value and prepares the conversion source token for the conversion
1160       *
1161       * @param _sourceToken source token of the first conversion step
1162       * @param _anchor      converter anchor of the first conversion step
1163       * @param _amount      amount to convert from, in the source token
1164     */
1165     function handleSourceToken(IERC20Token _sourceToken, IConverterAnchor _anchor, uint256 _amount) private {
1166         IConverter firstConverter = IConverter(_anchor.owner());
1167         bool isNewerConverter = isV28OrHigherConverter(firstConverter);
1168 
1169         // ETH
1170         if (msg.value > 0) {
1171             // validate msg.value
1172             require(msg.value == _amount, "ERR_ETH_AMOUNT_MISMATCH");
1173 
1174             // EtherToken converter - deposit the ETH into the EtherToken
1175             // note that it can still be a non ETH converter if the path is wrong
1176             // but such conversion will simply revert
1177             if (!isNewerConverter)
1178                 IEtherToken(getConverterEtherTokenAddress(firstConverter)).deposit.value(msg.value)();
1179         }
1180         // EtherToken
1181         else if (etherTokens[_sourceToken]) {
1182             // claim the tokens - if the source token is ETH reserve, this call will fail
1183             // since in that case the transaction must be sent with msg.value
1184             safeTransferFrom(_sourceToken, msg.sender, this, _amount);
1185 
1186             // ETH converter - withdraw the ETH
1187             if (isNewerConverter)
1188                 IEtherToken(_sourceToken).withdraw(_amount);
1189         }
1190         // other ERC20 token
1191         else {
1192             // newer converter - transfer the tokens from the sender directly to the converter
1193             // otherwise claim the tokens
1194             if (isNewerConverter)
1195                 safeTransferFrom(_sourceToken, msg.sender, firstConverter, _amount);
1196             else
1197                 safeTransferFrom(_sourceToken, msg.sender, this, _amount);
1198         }
1199     }
1200 
1201     /**
1202       * @dev handles the conversion target token if the network still holds it at the end of the conversion
1203       *
1204       * @param _data        conversion data, see ConversionStep struct above
1205       * @param _amount      conversion return amount, in the target token
1206       * @param _beneficiary wallet to receive the conversion result
1207     */
1208     function handleTargetToken(ConversionStep[] _data, uint256 _amount, address _beneficiary) private {
1209         ConversionStep memory stepData = _data[_data.length - 1];
1210 
1211         // network contract doesn't hold the tokens, do nothing
1212         if (stepData.beneficiary != address(this))
1213             return;
1214 
1215         IERC20Token targetToken = stepData.targetToken;
1216 
1217         // ETH / EtherToken
1218         if (etherTokens[targetToken]) {
1219             // newer converter should send ETH directly to the beneficiary
1220             assert(!stepData.isV28OrHigherConverter);
1221 
1222             // EtherToken converter - withdraw the ETH and transfer to the beneficiary
1223             IEtherToken(targetToken).withdrawTo(_beneficiary, _amount);
1224         }
1225         // other ERC20 token
1226         else {
1227             safeTransfer(targetToken, _beneficiary, _amount);
1228         }
1229     }
1230 
1231     /**
1232       * @dev creates a memory cache of all conversion steps data to minimize logic and external calls during conversions
1233       *
1234       * @param _conversionPath      conversion path, see conversion path format above
1235       * @param _beneficiary         wallet to receive the conversion result
1236       * @param _affiliateFeeEnabled true if affiliate fee was requested by the sender, false if not
1237       *
1238       * @return cached conversion data to be ingested later on by the conversion flow
1239     */
1240     function createConversionData(IERC20Token[] _conversionPath, address _beneficiary, bool _affiliateFeeEnabled) private view returns (ConversionStep[]) {
1241         ConversionStep[] memory data = new ConversionStep[](_conversionPath.length / 2);
1242 
1243         bool affiliateFeeProcessed = false;
1244         address bntToken = addressOf(BNT_TOKEN);
1245         // iterate the conversion path and create the conversion data for each step
1246         uint256 i;
1247         for (i = 0; i < _conversionPath.length - 1; i += 2) {
1248             IConverterAnchor anchor = IConverterAnchor(_conversionPath[i + 1]);
1249             IConverter converter = IConverter(anchor.owner());
1250             IERC20Token targetToken = _conversionPath[i + 2];
1251 
1252             // check if the affiliate fee should be processed in this step
1253             bool processAffiliateFee = _affiliateFeeEnabled && !affiliateFeeProcessed && targetToken == bntToken;
1254             if (processAffiliateFee)
1255                 affiliateFeeProcessed = true;
1256 
1257             data[i / 2] = ConversionStep({
1258                 // set the converter anchor
1259                 anchor: anchor,
1260 
1261                 // set the converter
1262                 converter: converter,
1263 
1264                 // set the source/target tokens
1265                 sourceToken: _conversionPath[i],
1266                 targetToken: targetToken,
1267 
1268                 // requires knowledge about the next step, so initialize in the next phase
1269                 beneficiary: address(0),
1270 
1271                 // set flags
1272                 isV28OrHigherConverter: isV28OrHigherConverter(converter),
1273                 processAffiliateFee: processAffiliateFee
1274             });
1275         }
1276 
1277         // ETH support
1278         // source is ETH
1279         ConversionStep memory stepData = data[0];
1280         if (etherTokens[stepData.sourceToken]) {
1281             // newer converter - replace the source token address with ETH reserve address
1282             if (stepData.isV28OrHigherConverter)
1283                 stepData.sourceToken = IERC20Token(ETH_RESERVE_ADDRESS);
1284             // older converter - replace the source token with the EtherToken address used by the converter
1285             else
1286                 stepData.sourceToken = IERC20Token(getConverterEtherTokenAddress(stepData.converter));
1287         }
1288 
1289         // target is ETH
1290         stepData = data[data.length - 1];
1291         if (etherTokens[stepData.targetToken]) {
1292             // newer converter - replace the target token address with ETH reserve address
1293             if (stepData.isV28OrHigherConverter)
1294                 stepData.targetToken = IERC20Token(ETH_RESERVE_ADDRESS);
1295             // older converter - replace the target token with the EtherToken address used by the converter
1296             else
1297                 stepData.targetToken = IERC20Token(getConverterEtherTokenAddress(stepData.converter));
1298         }
1299 
1300         // set the beneficiary for each step
1301         for (i = 0; i < data.length; i++) {
1302             stepData = data[i];
1303 
1304             // first check if the converter in this step is newer as older converters don't even support the beneficiary argument
1305             if (stepData.isV28OrHigherConverter) {
1306                 // if affiliate fee is processed in this step, beneficiary is the network contract
1307                 if (stepData.processAffiliateFee)
1308                     stepData.beneficiary = this;
1309                 // if it's the last step, beneficiary is the final beneficiary
1310                 else if (i == data.length - 1)
1311                     stepData.beneficiary = _beneficiary;
1312                 // if the converter in the next step is newer, beneficiary is the next converter
1313                 else if (data[i + 1].isV28OrHigherConverter)
1314                     stepData.beneficiary = data[i + 1].converter;
1315                 // the converter in the next step is older, beneficiary is the network contract
1316                 else
1317                     stepData.beneficiary = this;
1318             }
1319             else {
1320                 // converter in this step is older, beneficiary is the network contract
1321                 stepData.beneficiary = this;
1322             }
1323         }
1324 
1325         return data;
1326     }
1327 
1328     /**
1329       * @dev utility, checks whether allowance for the given spender exists and approves one if it doesn't.
1330       * Note that we use the non standard erc-20 interface in which `approve` has no return value so that
1331       * this function will work for both standard and non standard tokens
1332       *
1333       * @param _token   token to check the allowance in
1334       * @param _spender approved address
1335       * @param _value   allowance amount
1336     */
1337     function ensureAllowance(IERC20Token _token, address _spender, uint256 _value) private {
1338         uint256 allowance = _token.allowance(this, _spender);
1339         if (allowance < _value) {
1340             if (allowance > 0)
1341                 safeApprove(_token, _spender, 0);
1342             safeApprove(_token, _spender, _value);
1343         }
1344     }
1345 
1346     // legacy - returns the address of an EtherToken used by the converter
1347     function getConverterEtherTokenAddress(IConverter _converter) private view returns (address) {
1348         uint256 reserveCount = _converter.connectorTokenCount();
1349         for (uint256 i = 0; i < reserveCount; i++) {
1350             address reserveTokenAddress = _converter.connectorTokens(i);
1351             if (etherTokens[reserveTokenAddress])
1352                 return reserveTokenAddress;
1353         }
1354 
1355         return ETH_RESERVE_ADDRESS;
1356     }
1357 
1358     // legacy - if the token is an ether token, returns the ETH reserve address
1359     // used by the converter, otherwise returns the input token address
1360     function getConverterTokenAddress(IConverter _converter, IERC20Token _token) private view returns (IERC20Token) {
1361         if (!etherTokens[_token])
1362             return _token;
1363 
1364         if (isV28OrHigherConverter(_converter))
1365             return IERC20Token(ETH_RESERVE_ADDRESS);
1366 
1367         return IERC20Token(getConverterEtherTokenAddress(_converter));
1368     }
1369 
1370     bytes4 private constant GET_RETURN_FUNC_SELECTOR = bytes4(keccak256("getReturn(address,address,uint256)"));
1371 
1372     // using assembly code since older converter versions have different return values
1373     function getReturn(address _dest, address _sourceToken, address _targetToken, uint256 _amount) internal view returns (uint256, uint256) {
1374         uint256[2] memory ret;
1375         bytes memory data = abi.encodeWithSelector(GET_RETURN_FUNC_SELECTOR, _sourceToken, _targetToken, _amount);
1376 
1377         assembly {
1378             let success := staticcall(
1379                 gas,           // gas remaining
1380                 _dest,         // destination address
1381                 add(data, 32), // input buffer (starts after the first 32 bytes in the `data` array)
1382                 mload(data),   // input length (loaded from the first 32 bytes in the `data` array)
1383                 ret,           // output buffer
1384                 64             // output length
1385             )
1386             if iszero(success) {
1387                 revert(0, 0)
1388             }
1389         }
1390 
1391         return (ret[0], ret[1]);
1392     }
1393 
1394     bytes4 private constant IS_V28_OR_HIGHER_FUNC_SELECTOR = bytes4(keccak256("isV28OrHigher()"));
1395 
1396     // using assembly code to identify converter version
1397     // can't rely on the version number since the function had a different signature in older converters
1398     function isV28OrHigherConverter(IConverter _converter) internal view returns (bool) {
1399         bool success;
1400         uint256[1] memory ret;
1401         bytes memory data = abi.encodeWithSelector(IS_V28_OR_HIGHER_FUNC_SELECTOR);
1402 
1403         assembly {
1404             success := staticcall(
1405                 5000,          // isV28OrHigher consumes 190 gas, but just for extra safety
1406                 _converter,    // destination address
1407                 add(data, 32), // input buffer (starts after the first 32 bytes in the `data` array)
1408                 mload(data),   // input length (loaded from the first 32 bytes in the `data` array)
1409                 ret,           // output buffer
1410                 32             // output length
1411             )
1412         }
1413 
1414         return success && ret[0] != 0;
1415     }
1416 
1417     /**
1418       * @dev deprecated, backward compatibility
1419     */
1420     function getReturnByPath(IERC20Token[] _path, uint256 _amount) public view returns (uint256, uint256) {
1421         return (rateByPath(_path, _amount), 0);
1422     }
1423 
1424     /**
1425       * @dev deprecated, backward compatibility
1426     */
1427     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
1428         return convertByPath(_path, _amount, _minReturn, address(0), address(0), 0);
1429     }
1430 
1431     /**
1432       * @dev deprecated, backward compatibility
1433     */
1434     function convert2(
1435         IERC20Token[] _path,
1436         uint256 _amount,
1437         uint256 _minReturn,
1438         address _affiliateAccount,
1439         uint256 _affiliateFee
1440     )
1441         public
1442         payable
1443         returns (uint256)
1444     {
1445         return convertByPath(_path, _amount, _minReturn, address(0), _affiliateAccount, _affiliateFee);
1446     }
1447 
1448     /**
1449       * @dev deprecated, backward compatibility
1450     */
1451     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _beneficiary) public payable returns (uint256) {
1452         return convertByPath(_path, _amount, _minReturn, _beneficiary, address(0), 0);
1453     }
1454 
1455     /**
1456       * @dev deprecated, backward compatibility
1457     */
1458     function convertFor2(
1459         IERC20Token[] _path,
1460         uint256 _amount,
1461         uint256 _minReturn,
1462         address _beneficiary,
1463         address _affiliateAccount,
1464         uint256 _affiliateFee
1465     )
1466         public
1467         payable
1468         greaterThanZero(_minReturn)
1469         returns (uint256)
1470     {
1471         return convertByPath(_path, _amount, _minReturn, _beneficiary, _affiliateAccount, _affiliateFee);
1472     }
1473 
1474     /**
1475       * @dev deprecated, backward compatibility
1476     */
1477     function claimAndConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1478         return convertByPath(_path, _amount, _minReturn, address(0), address(0), 0);
1479     }
1480 
1481     /**
1482       * @dev deprecated, backward compatibility
1483     */
1484     function claimAndConvert2(
1485         IERC20Token[] _path,
1486         uint256 _amount,
1487         uint256 _minReturn,
1488         address _affiliateAccount,
1489         uint256 _affiliateFee
1490     )
1491         public
1492         returns (uint256)
1493     {
1494         return convertByPath(_path, _amount, _minReturn, address(0), _affiliateAccount, _affiliateFee);
1495     }
1496 
1497     /**
1498       * @dev deprecated, backward compatibility
1499     */
1500     function claimAndConvertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _beneficiary) public returns (uint256) {
1501         return convertByPath(_path, _amount, _minReturn, _beneficiary, address(0), 0);
1502     }
1503 
1504     /**
1505       * @dev deprecated, backward compatibility
1506     */
1507     function claimAndConvertFor2(
1508         IERC20Token[] _path,
1509         uint256 _amount,
1510         uint256 _minReturn,
1511         address _beneficiary,
1512         address _affiliateAccount,
1513         uint256 _affiliateFee
1514     )
1515         public
1516         returns (uint256)
1517     {
1518         return convertByPath(_path, _amount, _minReturn, _beneficiary, _affiliateAccount, _affiliateFee);
1519     }
1520 }