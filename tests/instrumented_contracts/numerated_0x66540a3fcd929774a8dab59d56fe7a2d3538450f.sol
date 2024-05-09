1 pragma solidity 0.4.26;
2 
3 // File: contracts/token/interfaces/IERC20Token.sol
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
24 /*
25     Whitelist interface
26 */
27 contract IWhitelist {
28     function isWhitelisted(address _address) public view returns (bool);
29 }
30 
31 // File: contracts/converter/interfaces/IBancorConverter.sol
32 
33 /*
34     Bancor Converter interface
35 */
36 contract IBancorConverter {
37     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256);
38     function convert2(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public returns (uint256);
39     function quickConvert2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public payable returns (uint256);
40     function conversionWhitelist() public view returns (IWhitelist) {this;}
41     function conversionFee() public view returns (uint32) {this;}
42     function reserves(address _address) public view returns (uint256, uint32, bool, bool, bool) {_address; this;}
43     function getReserveBalance(IERC20Token _reserveToken) public view returns (uint256);
44     function reserveTokens(uint256 _index) public view returns (IERC20Token) {_index; this;}
45     // deprecated, backward compatibility
46     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
47     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
48     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
49     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool);
50     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
51     function connectorTokens(uint256 _index) public view returns (IERC20Token);
52 }
53 
54 // File: contracts/converter/interfaces/IBancorConverterUpgrader.sol
55 
56 /*
57     Bancor Converter Upgrader interface
58 */
59 contract IBancorConverterUpgrader {
60     function upgrade(bytes32 _version) public;
61     function upgrade(uint16 _version) public;
62 }
63 
64 // File: contracts/converter/interfaces/IBancorFormula.sol
65 
66 /*
67     Bancor Formula interface
68 */
69 contract IBancorFormula {
70     function calculatePurchaseReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _depositAmount) public view returns (uint256);
71     function calculateSaleReturn(uint256 _supply, uint256 _reserveBalance, uint32 _reserveRatio, uint256 _sellAmount) public view returns (uint256);
72     function calculateCrossReserveReturn(uint256 _fromReserveBalance, uint32 _fromReserveRatio, uint256 _toReserveBalance, uint32 _toReserveRatio, uint256 _amount) public view returns (uint256);
73     // deprecated, backward compatibility
74     function calculateCrossConnectorReturn(uint256 _fromConnectorBalance, uint32 _fromConnectorWeight, uint256 _toConnectorBalance, uint32 _toConnectorWeight, uint256 _amount) public view returns (uint256);
75 }
76 
77 // File: contracts/IBancorNetwork.sol
78 
79 /*
80     Bancor Network interface
81 */
82 contract IBancorNetwork {
83     function convert2(
84         IERC20Token[] _path,
85         uint256 _amount,
86         uint256 _minReturn,
87         address _affiliateAccount,
88         uint256 _affiliateFee
89     ) public payable returns (uint256);
90 
91     function claimAndConvert2(
92         IERC20Token[] _path,
93         uint256 _amount,
94         uint256 _minReturn,
95         address _affiliateAccount,
96         uint256 _affiliateFee
97     ) public returns (uint256);
98 
99     function convertFor2(
100         IERC20Token[] _path,
101         uint256 _amount,
102         uint256 _minReturn,
103         address _for,
104         address _affiliateAccount,
105         uint256 _affiliateFee
106     ) public payable returns (uint256);
107 
108     function claimAndConvertFor2(
109         IERC20Token[] _path,
110         uint256 _amount,
111         uint256 _minReturn,
112         address _for,
113         address _affiliateAccount,
114         uint256 _affiliateFee
115     ) public returns (uint256);
116 
117     function convertForPrioritized4(
118         IERC20Token[] _path,
119         uint256 _amount,
120         uint256 _minReturn,
121         address _for,
122         uint256[] memory _signature,
123         address _affiliateAccount,
124         uint256 _affiliateFee
125     ) public payable returns (uint256);
126 
127     // deprecated, backward compatibility
128     function convert(
129         IERC20Token[] _path,
130         uint256 _amount,
131         uint256 _minReturn
132     ) public payable returns (uint256);
133 
134     // deprecated, backward compatibility
135     function claimAndConvert(
136         IERC20Token[] _path,
137         uint256 _amount,
138         uint256 _minReturn
139     ) public returns (uint256);
140 
141     // deprecated, backward compatibility
142     function convertFor(
143         IERC20Token[] _path,
144         uint256 _amount,
145         uint256 _minReturn,
146         address _for
147     ) public payable returns (uint256);
148 
149     // deprecated, backward compatibility
150     function claimAndConvertFor(
151         IERC20Token[] _path,
152         uint256 _amount,
153         uint256 _minReturn,
154         address _for
155     ) public returns (uint256);
156 
157     // deprecated, backward compatibility
158     function convertForPrioritized3(
159         IERC20Token[] _path,
160         uint256 _amount,
161         uint256 _minReturn,
162         address _for,
163         uint256 _customVal,
164         uint256 _block,
165         uint8 _v,
166         bytes32 _r,
167         bytes32 _s
168     ) public payable returns (uint256);
169 
170     // deprecated, backward compatibility
171     function convertForPrioritized2(
172         IERC20Token[] _path,
173         uint256 _amount,
174         uint256 _minReturn,
175         address _for,
176         uint256 _block,
177         uint8 _v,
178         bytes32 _r,
179         bytes32 _s
180     ) public payable returns (uint256);
181 
182     // deprecated, backward compatibility
183     function convertForPrioritized(
184         IERC20Token[] _path,
185         uint256 _amount,
186         uint256 _minReturn,
187         address _for,
188         uint256 _block,
189         uint256 _nonce,
190         uint8 _v,
191         bytes32 _r,
192         bytes32 _s
193     ) public payable returns (uint256);
194 }
195 
196 // File: contracts/ContractIds.sol
197 
198 /**
199   * @dev Id definitions for bancor contracts
200   * 
201   * Can be used in conjunction with the contract registry to get contract addresses
202 */
203 contract ContractIds {
204     // generic
205     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
206     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
207     bytes32 public constant NON_STANDARD_TOKEN_REGISTRY = "NonStandardTokenRegistry";
208 
209     // bancor logic
210     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
211     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
212     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
213     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
214     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
215 
216     // BNT core
217     bytes32 public constant BNT_TOKEN = "BNTToken";
218 
219     // BancorX
220     bytes32 public constant BANCOR_X = "BancorX";
221     bytes32 public constant BANCOR_X_UPGRADER = "BancorXUpgrader";
222 }
223 
224 // File: contracts/FeatureIds.sol
225 
226 /**
227   * @dev Id definitions for bancor contract features
228   * 
229   * Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
230 */
231 contract FeatureIds {
232     // converter features
233     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
234 }
235 
236 // File: contracts/utility/interfaces/IOwned.sol
237 
238 /*
239     Owned contract interface
240 */
241 contract IOwned {
242     // this function isn't abstract since the compiler emits automatically generated getter functions as external
243     function owner() public view returns (address) {this;}
244 
245     function transferOwnership(address _newOwner) public;
246     function acceptOwnership() public;
247 }
248 
249 // File: contracts/utility/Owned.sol
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
275         require(msg.sender == owner);
276         _;
277     }
278 
279     /**
280       * @dev allows transferring the contract ownership
281       * the new owner still needs to accept the transfer
282       * can only be called by the contract owner
283       * 
284       * @param _newOwner    new contract owner
285     */
286     function transferOwnership(address _newOwner) public ownerOnly {
287         require(_newOwner != owner);
288         newOwner = _newOwner;
289     }
290 
291     /**
292       * @dev used by a new owner to accept an ownership transfer
293     */
294     function acceptOwnership() public {
295         require(msg.sender == newOwner);
296         emit OwnerUpdate(owner, newOwner);
297         owner = newOwner;
298         newOwner = address(0);
299     }
300 }
301 
302 // File: contracts/utility/Managed.sol
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
362 // File: contracts/utility/Utils.sol
363 
364 /**
365   * @dev Utilities & Common Modifiers
366 */
367 contract Utils {
368     /**
369       * constructor
370     */
371     constructor() public {
372     }
373 
374     // verifies that an amount is greater than zero
375     modifier greaterThanZero(uint256 _amount) {
376         require(_amount > 0);
377         _;
378     }
379 
380     // validates an address - currently only checks that it isn't null
381     modifier validAddress(address _address) {
382         require(_address != address(0));
383         _;
384     }
385 
386     // verifies that the address is different than this contract address
387     modifier notThis(address _address) {
388         require(_address != address(this));
389         _;
390     }
391 
392 }
393 
394 // File: contracts/utility/SafeMath.sol
395 
396 /**
397   * @dev Library for basic math operations with overflow/underflow protection
398 */
399 library SafeMath {
400     /**
401       * @dev returns the sum of _x and _y, reverts if the calculation overflows
402       * 
403       * @param _x   value 1
404       * @param _y   value 2
405       * 
406       * @return sum
407     */
408     function add(uint256 _x, uint256 _y) internal pure returns (uint256) {
409         uint256 z = _x + _y;
410         require(z >= _x);
411         return z;
412     }
413 
414     /**
415       * @dev returns the difference of _x minus _y, reverts if the calculation underflows
416       * 
417       * @param _x   minuend
418       * @param _y   subtrahend
419       * 
420       * @return difference
421     */
422     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
423         require(_x >= _y);
424         return _x - _y;
425     }
426 
427     /**
428       * @dev returns the product of multiplying _x by _y, reverts if the calculation overflows
429       * 
430       * @param _x   factor 1
431       * @param _y   factor 2
432       * 
433       * @return product
434     */
435     function mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
436         // gas optimization
437         if (_x == 0)
438             return 0;
439 
440         uint256 z = _x * _y;
441         require(z / _x == _y);
442         return z;
443     }
444 
445       /**
446         * ev Integer division of two numbers truncating the quotient, reverts on division by zero.
447         * 
448         * aram _x   dividend
449         * aram _y   divisor
450         * 
451         * eturn quotient
452     */
453     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
454         require(_y > 0);
455         uint256 c = _x / _y;
456 
457         return c;
458     }
459 }
460 
461 // File: contracts/utility/interfaces/IContractRegistry.sol
462 
463 /*
464     Contract Registry interface
465 */
466 contract IContractRegistry {
467     function addressOf(bytes32 _contractName) public view returns (address);
468 
469     // deprecated, backward compatibility
470     function getAddress(bytes32 _contractName) public view returns (address);
471 }
472 
473 // File: contracts/utility/interfaces/IContractFeatures.sol
474 
475 /*
476     Contract Features interface
477 */
478 contract IContractFeatures {
479     function isSupported(address _contract, uint256 _features) public view returns (bool);
480     function enableFeatures(uint256 _features, bool _enable) public;
481 }
482 
483 // File: contracts/utility/interfaces/IAddressList.sol
484 
485 /*
486     Address list interface
487 */
488 contract IAddressList {
489     mapping (address => bool) public listedAddresses;
490 }
491 
492 // File: contracts/token/interfaces/ISmartToken.sol
493 
494 /*
495     Smart Token interface
496 */
497 contract ISmartToken is IOwned, IERC20Token {
498     function disableTransfers(bool _disable) public;
499     function issue(address _to, uint256 _amount) public;
500     function destroy(address _from, uint256 _amount) public;
501 }
502 
503 // File: contracts/token/interfaces/ISmartTokenController.sol
504 
505 /*
506     Smart Token Controller interface
507 */
508 contract ISmartTokenController {
509     function claimTokens(address _from, uint256 _amount) public;
510     function token() public view returns (ISmartToken) {this;}
511 }
512 
513 // File: contracts/utility/interfaces/ITokenHolder.sol
514 
515 /*
516     Token Holder interface
517 */
518 contract ITokenHolder is IOwned {
519     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
520 }
521 
522 // File: contracts/token/interfaces/INonStandardERC20.sol
523 
524 /*
525     ERC20 Standard Token interface which doesn't return true/false for transfer, transferFrom and approve
526 */
527 contract INonStandardERC20 {
528     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
529     function name() public view returns (string) {this;}
530     function symbol() public view returns (string) {this;}
531     function decimals() public view returns (uint8) {this;}
532     function totalSupply() public view returns (uint256) {this;}
533     function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
534     function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}
535 
536     function transfer(address _to, uint256 _value) public;
537     function transferFrom(address _from, address _to, uint256 _value) public;
538     function approve(address _spender, uint256 _value) public;
539 }
540 
541 // File: contracts/utility/TokenHolder.sol
542 
543 /**
544   * @dev We consider every contract to be a 'token holder' since it's currently not possible
545   * for a contract to deny receiving tokens.
546   * 
547   * The TokenHolder's contract sole purpose is to provide a safety mechanism that allows
548   * the owner to send tokens that were sent to the contract by mistake back to their sender.
549   * 
550   * Note that we use the non standard ERC-20 interface which has no return value for transfer
551   * in order to support both non standard as well as standard token contracts.
552   * see https://github.com/ethereum/solidity/issues/4116
553 */
554 contract TokenHolder is ITokenHolder, Owned, Utils {
555     /**
556       * @dev initializes a new TokenHolder instance
557     */
558     constructor() public {
559     }
560 
561     /**
562       * @dev withdraws tokens held by the contract and sends them to an account
563       * can only be called by the owner
564       * 
565       * @param _token   ERC20 token contract address
566       * @param _to      account to receive the new amount
567       * @param _amount  amount to withdraw
568     */
569     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)
570         public
571         ownerOnly
572         validAddress(_token)
573         validAddress(_to)
574         notThis(_to)
575     {
576         INonStandardERC20(_token).transfer(_to, _amount);
577     }
578 }
579 
580 // File: contracts/token/SmartTokenController.sol
581 
582 /**
583   * @dev The smart token controller is an upgradable part of the smart token that allows
584   * more functionality as well as fixes for bugs/exploits.
585   * Once it accepts ownership of the token, it becomes the token's sole controller
586   * that can execute any of its functions.
587   * 
588   * To upgrade the controller, ownership must be transferred to a new controller, along with
589   * any relevant data.
590   * 
591   * The smart token must be set on construction and cannot be changed afterwards.
592   * Wrappers are provided (as opposed to a single 'execute' function) for each of the token's functions, for easier access.
593   * 
594   * Note that the controller can transfer token ownership to a new controller that
595   * doesn't allow executing any function on the token, for a trustless solution.
596   * Doing that will also remove the owner's ability to upgrade the controller.
597 */
598 contract SmartTokenController is ISmartTokenController, TokenHolder {
599     ISmartToken public token;   // Smart Token contract
600     address public bancorX;     // BancorX contract
601 
602     /**
603       * @dev initializes a new SmartTokenController instance
604       * 
605       * @param  _token      smart token governed by the controller
606     */
607     constructor(ISmartToken _token)
608         public
609         validAddress(_token)
610     {
611         token = _token;
612     }
613 
614     // ensures that the controller is the token's owner
615     modifier active() {
616         require(token.owner() == address(this));
617         _;
618     }
619 
620     // ensures that the controller is not the token's owner
621     modifier inactive() {
622         require(token.owner() != address(this));
623         _;
624     }
625 
626     /**
627       * @dev allows transferring the token ownership
628       * the new owner needs to accept the transfer
629       * can only be called by the contract owner
630       * 
631       * @param _newOwner    new token owner
632     */
633     function transferTokenOwnership(address _newOwner) public ownerOnly {
634         token.transferOwnership(_newOwner);
635     }
636 
637     /**
638       * @dev used by a new owner to accept a token ownership transfer
639       * can only be called by the contract owner
640     */
641     function acceptTokenOwnership() public ownerOnly {
642         token.acceptOwnership();
643     }
644 
645     /**
646       * @dev withdraws tokens held by the controller and sends them to an account
647       * can only be called by the owner
648       * 
649       * @param _token   ERC20 token contract address
650       * @param _to      account to receive the new amount
651       * @param _amount  amount to withdraw
652     */
653     function withdrawFromToken(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
654         ITokenHolder(token).withdrawTokens(_token, _to, _amount);
655     }
656 
657     /**
658       * @dev allows the associated BancorX contract to claim tokens from any address (so that users
659       * dont have to first give allowance when calling BancorX)
660       * 
661       * @param _from      address to claim the tokens from
662       * @param _amount    the amount of tokens to claim
663      */
664     function claimTokens(address _from, uint256 _amount) public {
665         // only the associated BancorX contract may call this method
666         require(msg.sender == bancorX);
667 
668         // destroy the tokens belonging to _from, and issue the same amount to bancorX
669         token.destroy(_from, _amount);
670         token.issue(msg.sender, _amount);
671     }
672 
673     /**
674       * @dev allows the owner to set the associated BancorX contract
675       * @param _bancorX    BancorX contract
676      */
677     function setBancorX(address _bancorX) public ownerOnly {
678         bancorX = _bancorX;
679     }
680 }
681 
682 // File: contracts/token/interfaces/IEtherToken.sol
683 
684 /*
685     Ether Token interface
686 */
687 contract IEtherToken is ITokenHolder, IERC20Token {
688     function deposit() public payable;
689     function withdraw(uint256 _amount) public;
690     function withdrawTo(address _to, uint256 _amount) public;
691 }
692 
693 // File: contracts/bancorx/interfaces/IBancorX.sol
694 
695 contract IBancorX {
696     function xTransfer(bytes32 _toBlockchain, bytes32 _to, uint256 _amount, uint256 _id) public;
697     function getXTransferAmount(uint256 _xTransferId, address _for) public view returns (uint256);
698 }
699 
700 // File: contracts/converter/BancorConverter.sol
701 
702 /**
703   * @dev Bancor Converter
704   * 
705   * The Bancor converter allows for conversions between a Smart Token and other ERC20 tokens and between different ERC20 tokens and themselves. 
706   * 
707   * The ERC20 reserve balance can be virtual, meaning that conversions between reserve tokens are based on the virtual balance instead of relying on the actual reserve balance.
708   * 
709   * This mechanism opens the possibility to create different financial tools (for example, lower slippage in conversions).
710   * 
711   * The converter is upgradable (just like any SmartTokenController) and all upgrades are opt-in. 
712   * 
713   * WARNING: It is NOT RECOMMENDED to use the converter with Smart Tokens that have less than 8 decimal digits or with very small numbers because of precision loss 
714   * 
715   * Open issues:
716   * - Front-running attacks are currently mitigated by the following mechanisms:
717   *     - minimum return argument for each conversion provides a way to define a minimum/maximum price for the transaction
718   *     - gas price limit prevents users from having control over the order of execution
719   *     - gas price limit check can be skipped if the transaction comes from a trusted, whitelisted signer
720   * 
721   * Other potential solutions might include a commit/reveal based schemes
722   * - Possibly add getters for the reserve fields so that the client won't need to rely on the order in the struct
723 */
724 contract BancorConverter is IBancorConverter, SmartTokenController, Managed, ContractIds, FeatureIds {
725     using SafeMath for uint256;
726 
727     uint32 private constant RATIO_RESOLUTION = 1000000;
728     uint64 private constant CONVERSION_FEE_RESOLUTION = 1000000;
729 
730     struct Reserve {
731         uint256 virtualBalance;         // reserve virtual balance
732         uint32 ratio;                   // reserve ratio, represented in ppm, 1-1000000
733         bool isVirtualBalanceEnabled;   // true if virtual balance is enabled, false if not
734         bool isSaleEnabled;             // is sale of the reserve token enabled, can be set by the owner
735         bool isSet;                     // used to tell if the mapping element is defined
736     }
737 
738     /**
739       * @dev version number
740     */
741     uint16 public version = 20;
742     string public converterType = 'bancor';
743 
744     bool public allowRegistryUpdate = true;             // allows the owner to prevent/allow the registry to be updated
745     IContractRegistry public prevRegistry;              // address of previous registry as security mechanism
746     IContractRegistry public registry;                  // contract registry contract
747     IWhitelist public conversionWhitelist;              // whitelist contract with list of addresses that are allowed to use the converter
748     IERC20Token[] public reserveTokens;                 // ERC20 standard token addresses (prior version 17, use 'connectorTokens' instead)
749     mapping (address => Reserve) public reserves;       // reserve token addresses -> reserve data (prior version 17, use 'connectors' instead)
750     uint32 private totalReserveRatio = 0;               // used to efficiently prevent increasing the total reserve ratio above 100%
751     uint32 public maxConversionFee = 0;                 // maximum conversion fee for the lifetime of the contract,
752                                                         // represented in ppm, 0...1000000 (0 = no fee, 100 = 0.01%, 1000000 = 100%)
753     uint32 public conversionFee = 0;                    // current conversion fee, represented in ppm, 0...maxConversionFee
754     bool public conversionsEnabled = true;              // true if token conversions is enabled, false if not
755 
756     /**
757       * @dev triggered when a conversion between two tokens occurs
758       * 
759       * @param _fromToken       ERC20 token converted from
760       * @param _toToken         ERC20 token converted to
761       * @param _trader          wallet that initiated the trade
762       * @param _amount          amount converted, in fromToken
763       * @param _return          amount returned, minus conversion fee
764       * @param _conversionFee   conversion fee
765     */
766     event Conversion(
767         address indexed _fromToken,
768         address indexed _toToken,
769         address indexed _trader,
770         uint256 _amount,
771         uint256 _return,
772         int256 _conversionFee
773     );
774 
775     /**
776       * @dev triggered after a conversion with new price data
777       * 
778       * @param  _connectorToken     reserve token
779       * @param  _tokenSupply        smart token supply
780       * @param  _connectorBalance   reserve balance
781       * @param  _connectorWeight    reserve ratio
782     */
783     event PriceDataUpdate(
784         address indexed _connectorToken,
785         uint256 _tokenSupply,
786         uint256 _connectorBalance,
787         uint32 _connectorWeight
788     );
789 
790     /**
791       * @dev triggered when the conversion fee is updated
792       * 
793       * @param  _prevFee    previous fee percentage, represented in ppm
794       * @param  _newFee     new fee percentage, represented in ppm
795     */
796     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
797 
798     /**
799       * @dev triggered when conversions are enabled/disabled
800       * 
801       * @param  _conversionsEnabled true if conversions are enabled, false if not
802     */
803     event ConversionsEnable(bool _conversionsEnabled);
804 
805     /**
806       * @dev triggered when virtual balances are enabled/disabled
807       * 
808       * @param  _enabled true if virtual balances are enabled, false if not
809     */
810     event VirtualBalancesEnable(bool _enabled);
811 
812     /**
813       * @dev initializes a new BancorConverter instance
814       * 
815       * @param  _token              smart token governed by the converter
816       * @param  _registry           address of a contract registry contract
817       * @param  _maxConversionFee   maximum conversion fee, represented in ppm
818       * @param  _reserveToken       optional, initial reserve, allows defining the first reserve at deployment time
819       * @param  _reserveRatio       optional, ratio for the initial reserve
820     */
821     constructor(
822         ISmartToken _token,
823         IContractRegistry _registry,
824         uint32 _maxConversionFee,
825         IERC20Token _reserveToken,
826         uint32 _reserveRatio
827     )
828         public
829         SmartTokenController(_token)
830         validAddress(_registry)
831         validConversionFee(_maxConversionFee)
832     {
833         registry = _registry;
834         prevRegistry = _registry;
835         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
836 
837         // initialize supported features
838         if (features != address(0))
839             features.enableFeatures(FeatureIds.CONVERTER_CONVERSION_WHITELIST, true);
840 
841         maxConversionFee = _maxConversionFee;
842 
843         if (_reserveToken != address(0))
844             addReserve(_reserveToken, _reserveRatio);
845     }
846 
847     // validates a reserve token address - verifies that the address belongs to one of the reserve tokens
848     modifier validReserve(IERC20Token _address) {
849         require(reserves[_address].isSet);
850         _;
851     }
852 
853     // validates conversion fee
854     modifier validConversionFee(uint32 _conversionFee) {
855         require(_conversionFee >= 0 && _conversionFee <= CONVERSION_FEE_RESOLUTION);
856         _;
857     }
858 
859     // validates reserve ratio
860     modifier validReserveRatio(uint32 _ratio) {
861         require(_ratio > 0 && _ratio <= RATIO_RESOLUTION);
862         _;
863     }
864 
865     // allows execution only when the total ratio is 100%
866     modifier fullTotalRatioOnly() {
867         require(totalReserveRatio == RATIO_RESOLUTION);
868         _;
869     }
870 
871     // allows execution only when conversions aren't disabled
872     modifier conversionsAllowed {
873         require(conversionsEnabled);
874         _;
875     }
876 
877     // allows execution by the BancorNetwork contract only
878     modifier bancorNetworkOnly {
879         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
880         require(msg.sender == address(bancorNetwork));
881         _;
882     }
883 
884     // allows execution by the converter upgrader contract only
885     modifier converterUpgraderOnly {
886         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
887         require(msg.sender == converterUpgrader);
888         _;
889     }
890 
891     // allows execution only if the total-supply of the token is greater than zero
892     modifier totalSupplyGreaterThanZeroOnly {
893         require(token.totalSupply() > 0);
894         _;
895     }
896 
897     /**
898       * @dev sets the contract registry to whichever address the current registry is pointing to
899      */
900     function updateRegistry() public {
901         // require that upgrading is allowed or that the caller is the owner
902         require(allowRegistryUpdate || msg.sender == owner);
903 
904         // get the address of whichever registry the current registry is pointing to
905         address newRegistry = registry.addressOf(ContractIds.CONTRACT_REGISTRY);
906 
907         // if the new registry hasn't changed or is the zero address, revert
908         require(newRegistry != address(registry) && newRegistry != address(0));
909 
910         // set the previous registry as current registry and current registry as newRegistry
911         prevRegistry = registry;
912         registry = IContractRegistry(newRegistry);
913     }
914 
915     /**
916       * @dev security mechanism allowing the converter owner to revert to the previous registry,
917       * to be used in emergency scenario
918     */
919     function restoreRegistry() public ownerOrManagerOnly {
920         // set the registry as previous registry
921         registry = prevRegistry;
922 
923         // after a previous registry is restored, only the owner can allow future updates
924         allowRegistryUpdate = false;
925     }
926 
927     /**
928       * @dev disables the registry update functionality
929       * this is a safety mechanism in case of a emergency
930       * can only be called by the manager or owner
931       * 
932       * @param _disable    true to disable registry updates, false to re-enable them
933     */
934     function disableRegistryUpdate(bool _disable) public ownerOrManagerOnly {
935         allowRegistryUpdate = !_disable;
936     }
937 
938     /**
939       * @dev returns the number of reserve tokens defined
940       * note that prior to version 17, you should use 'connectorTokenCount' instead
941       * 
942       * @return number of reserve tokens
943     */
944     function reserveTokenCount() public view returns (uint16) {
945         return uint16(reserveTokens.length);
946     }
947 
948     /**
949       * @dev allows the owner to update & enable the conversion whitelist contract address
950       * when set, only addresses that are whitelisted are actually allowed to use the converter
951       * note that the whitelist check is actually done by the BancorNetwork contract
952       * 
953       * @param _whitelist    address of a whitelist contract
954     */
955     function setConversionWhitelist(IWhitelist _whitelist)
956         public
957         ownerOnly
958         notThis(_whitelist)
959     {
960         conversionWhitelist = _whitelist;
961     }
962 
963     /**
964       * @dev disables the entire conversion functionality
965       * this is a safety mechanism in case of a emergency
966       * can only be called by the manager
967       * 
968       * @param _disable true to disable conversions, false to re-enable them
969     */
970     function disableConversions(bool _disable) public ownerOrManagerOnly {
971         if (conversionsEnabled == _disable) {
972             conversionsEnabled = !_disable;
973             emit ConversionsEnable(conversionsEnabled);
974         }
975     }
976 
977     /**
978       * @dev allows transferring the token ownership
979       * the new owner needs to accept the transfer
980       * can only be called by the contract owner
981       * note that token ownership can only be transferred while the owner is the converter upgrader contract
982       * 
983       * @param _newOwner    new token owner
984     */
985     function transferTokenOwnership(address _newOwner)
986         public
987         ownerOnly
988         converterUpgraderOnly
989     {
990         super.transferTokenOwnership(_newOwner);
991     }
992 
993     /**
994       * @dev used by a new owner to accept a token ownership transfer
995       * can only be called by the contract owner
996       * note that token ownership can only be accepted if its total-supply is greater than zero
997     */
998     function acceptTokenOwnership()
999         public
1000         ownerOnly
1001         totalSupplyGreaterThanZeroOnly
1002     {
1003         super.acceptTokenOwnership();
1004     }
1005 
1006     /**
1007       * @dev updates the current conversion fee
1008       * can only be called by the manager
1009       * 
1010       * @param _conversionFee new conversion fee, represented in ppm
1011     */
1012     function setConversionFee(uint32 _conversionFee)
1013         public
1014         ownerOrManagerOnly
1015     {
1016         require(_conversionFee >= 0 && _conversionFee <= maxConversionFee);
1017         emit ConversionFeeUpdate(conversionFee, _conversionFee);
1018         conversionFee = _conversionFee;
1019     }
1020 
1021     /**
1022       * @dev given a return amount, returns the amount minus the conversion fee
1023       * 
1024       * @param _amount      return amount
1025       * @param _magnitude   1 for standard conversion, 2 for cross reserve conversion
1026       * 
1027       * @return return amount minus conversion fee
1028     */
1029     function getFinalAmount(uint256 _amount, uint8 _magnitude) public view returns (uint256) {
1030         return _amount.mul((CONVERSION_FEE_RESOLUTION - conversionFee) ** _magnitude).div(CONVERSION_FEE_RESOLUTION ** _magnitude);
1031     }
1032 
1033     /**
1034       * @dev withdraws tokens held by the converter and sends them to an account
1035       * can only be called by the owner
1036       * note that reserve tokens can only be withdrawn by the owner while the converter is inactive
1037       * unless the owner is the converter upgrader contract
1038       * 
1039       * @param _token   ERC20 token contract address
1040       * @param _to      account to receive the new amount
1041       * @param _amount  amount to withdraw
1042     */
1043     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public {
1044         address converterUpgrader = registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER);
1045 
1046         // if the token is not a reserve token, allow withdrawal
1047         // otherwise verify that the converter is inactive or that the owner is the upgrader contract
1048         require(!reserves[_token].isSet || token.owner() != address(this) || owner == converterUpgrader);
1049         super.withdrawTokens(_token, _to, _amount);
1050     }
1051 
1052     /**
1053       * @dev upgrades the converter to the latest version
1054       * can only be called by the owner
1055       * note that the owner needs to call acceptOwnership/acceptManagement on the new converter after the upgrade
1056     */
1057     function upgrade() public ownerOnly {
1058         IBancorConverterUpgrader converterUpgrader = IBancorConverterUpgrader(registry.addressOf(ContractIds.BANCOR_CONVERTER_UPGRADER));
1059 
1060         transferOwnership(converterUpgrader);
1061         converterUpgrader.upgrade(version);
1062         acceptOwnership();
1063     }
1064 
1065     /**
1066       * @dev defines a new reserve for the token
1067       * can only be called by the owner while the converter is inactive
1068       * note that prior to version 17, you should use 'addConnector' instead
1069       * 
1070       * @param _token                  address of the reserve token
1071       * @param _ratio                  constant reserve ratio, represented in ppm, 1-1000000
1072     */
1073     function addReserve(IERC20Token _token, uint32 _ratio)
1074         public
1075         ownerOnly
1076         inactive
1077         validAddress(_token)
1078         notThis(_token)
1079         validReserveRatio(_ratio)
1080     {
1081         require(_token != token && !reserves[_token].isSet && totalReserveRatio + _ratio <= RATIO_RESOLUTION); // validate input
1082 
1083         reserves[_token].ratio = _ratio;
1084         reserves[_token].isVirtualBalanceEnabled = false;
1085         reserves[_token].virtualBalance = 0;
1086         reserves[_token].isSaleEnabled = true;
1087         reserves[_token].isSet = true;
1088         reserveTokens.push(_token);
1089         totalReserveRatio += _ratio;
1090     }
1091 
1092     /**
1093       * @dev updates a reserve's virtual balance
1094       * only used during an upgrade process
1095       * can only be called by the contract owner while the owner is the converter upgrader contract
1096       * note that prior to version 17, you should use 'updateConnector' instead
1097       * 
1098       * @param _reserveToken    address of the reserve token
1099       * @param _virtualBalance  new reserve virtual balance, or 0 to disable virtual balance
1100     */
1101     function updateReserveVirtualBalance(IERC20Token _reserveToken, uint256 _virtualBalance)
1102         public
1103         ownerOnly
1104         converterUpgraderOnly
1105         validReserve(_reserveToken)
1106     {
1107         Reserve storage reserve = reserves[_reserveToken];
1108         reserve.isVirtualBalanceEnabled = _virtualBalance != 0;
1109         reserve.virtualBalance = _virtualBalance;
1110     }
1111 
1112     /**
1113       * @dev enables virtual balance for the reserves
1114       * virtual balance only affects conversions between reserve tokens
1115       * virtual balance of all reserves can only scale by the same factor, to keep the ratio between them the same
1116       * note that the balance is determined during the execution of this function and set statically -
1117       * meaning that it's not calculated dynamically based on the factor after each conversion
1118       * can only be called by the contract owner while the converter is active
1119       * 
1120       * @param _scaleFactor  percentage, 100-1000 (100 = no virtual balance, 1000 = virtual balance = actual balance * 10)
1121     */
1122     function enableVirtualBalances(uint16 _scaleFactor)
1123         public
1124         ownerOnly
1125         active
1126     {
1127         // validate input
1128         require(_scaleFactor >= 100 && _scaleFactor <= 1000);
1129         bool enable = _scaleFactor != 100;
1130 
1131         // iterate through the reserves and scale their balance by the ratio provided,
1132         // or disable virtual balance altogether if a factor of 100% is passed in
1133         IERC20Token reserveToken;
1134         for (uint16 i = 0; i < reserveTokens.length; i++) {
1135             reserveToken = reserveTokens[i];
1136             Reserve storage reserve = reserves[reserveToken];
1137             reserve.isVirtualBalanceEnabled = enable;
1138             reserve.virtualBalance = enable ? reserveToken.balanceOf(this).mul(_scaleFactor).div(100) : 0;
1139         }
1140 
1141         emit VirtualBalancesEnable(enable);
1142     }
1143 
1144     /**
1145       * @dev disables converting from the given reserve token in case the reserve token got compromised
1146       * can only be called by the owner
1147       * note that converting to the token is still enabled regardless of this flag and it cannot be disabled by the owner
1148       * note that prior to version 17, you should use 'disableConnectorSale' instead
1149       * 
1150       * @param _reserveToken    reserve token contract address
1151       * @param _disable         true to disable the token, false to re-enable it
1152     */
1153     function disableReserveSale(IERC20Token _reserveToken, bool _disable)
1154         public
1155         ownerOnly
1156         validReserve(_reserveToken)
1157     {
1158         reserves[_reserveToken].isSaleEnabled = !_disable;
1159     }
1160 
1161     /**
1162       * @dev returns the reserve's virtual balance if one is defined, otherwise returns the actual balance
1163       * note that prior to version 17, you should use 'getConnectorBalance' instead
1164       * 
1165       * @param _reserveToken    reserve token contract address
1166       * 
1167       * @return reserve balance
1168     */
1169     function getReserveBalance(IERC20Token _reserveToken)
1170         public
1171         view
1172         validReserve(_reserveToken)
1173         returns (uint256)
1174     {
1175         Reserve storage reserve = reserves[_reserveToken];
1176         return reserve.isVirtualBalanceEnabled ? reserve.virtualBalance : _reserveToken.balanceOf(this);
1177     }
1178 
1179     /**
1180       * @dev calculates the expected return of converting a given amount of tokens
1181       * 
1182       * @param _fromToken  contract address of the token to convert from
1183       * @param _toToken    contract address of the token to convert to
1184       * @param _amount     amount of tokens received from the user
1185       * 
1186       * @return amount of tokens that the user will receive
1187       * @return amount of tokens that the user will pay as fee
1188     */
1189     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256, uint256) {
1190         require(_fromToken != _toToken); // validate input
1191 
1192         // conversion between the token and one of its reserves
1193         if (_toToken == token)
1194             return getPurchaseReturn(_fromToken, _amount);
1195         else if (_fromToken == token)
1196             return getSaleReturn(_toToken, _amount);
1197 
1198         // conversion between 2 reserves
1199         return getCrossReserveReturn(_fromToken, _toToken, _amount);
1200     }
1201 
1202     /**
1203       * @dev calculates the expected return of buying with a given amount of tokens
1204       * 
1205       * @param _reserveToken    contract address of the reserve token
1206       * @param _depositAmount   amount of reserve-tokens received from the user
1207       * 
1208       * @return amount of supply-tokens that the user will receive
1209       * @return amount of supply-tokens that the user will pay as fee
1210     */
1211     function getPurchaseReturn(IERC20Token _reserveToken, uint256 _depositAmount)
1212         public
1213         view
1214         active
1215         validReserve(_reserveToken)
1216         returns (uint256, uint256)
1217     {
1218         Reserve storage reserve = reserves[_reserveToken];
1219         require(reserve.isSaleEnabled); // validate input
1220 
1221         uint256 tokenSupply = token.totalSupply();
1222         uint256 reserveBalance = _reserveToken.balanceOf(this);
1223         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1224         uint256 amount = formula.calculatePurchaseReturn(tokenSupply, reserveBalance, reserve.ratio, _depositAmount);
1225         uint256 finalAmount = getFinalAmount(amount, 1);
1226 
1227         // return the amount minus the conversion fee and the conversion fee
1228         return (finalAmount, amount - finalAmount);
1229     }
1230 
1231     /**
1232       * @dev calculates the expected return of selling a given amount of tokens
1233       * 
1234       * @param _reserveToken    contract address of the reserve token
1235       * @param _sellAmount      amount of supply-tokens received from the user
1236       * 
1237       * @return amount of reserve-tokens that the user will receive
1238       * @return amount of reserve-tokens that the user will pay as fee
1239     */
1240     function getSaleReturn(IERC20Token _reserveToken, uint256 _sellAmount)
1241         public
1242         view
1243         active
1244         validReserve(_reserveToken)
1245         returns (uint256, uint256)
1246     {
1247         Reserve storage reserve = reserves[_reserveToken];
1248         uint256 tokenSupply = token.totalSupply();
1249         uint256 reserveBalance = _reserveToken.balanceOf(this);
1250         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1251         uint256 amount = formula.calculateSaleReturn(tokenSupply, reserveBalance, reserve.ratio, _sellAmount);
1252         uint256 finalAmount = getFinalAmount(amount, 1);
1253 
1254         // return the amount minus the conversion fee and the conversion fee
1255         return (finalAmount, amount - finalAmount);
1256     }
1257 
1258     /**
1259       * @dev calculates the expected return of converting a given amount from one reserve to another
1260       * note that prior to version 17, you should use 'getCrossConnectorReturn' instead
1261       * 
1262       * @param _fromReserveToken    contract address of the reserve token to convert from
1263       * @param _toReserveToken      contract address of the reserve token to convert to
1264       * @param _amount              amount of tokens received from the user
1265       * 
1266       * @return amount of tokens that the user will receive
1267       * @return amount of tokens that the user will pay as fee
1268     */
1269     function getCrossReserveReturn(IERC20Token _fromReserveToken, IERC20Token _toReserveToken, uint256 _amount)
1270         public
1271         view
1272         active
1273         validReserve(_fromReserveToken)
1274         validReserve(_toReserveToken)
1275         returns (uint256, uint256)
1276     {
1277         Reserve storage fromReserve = reserves[_fromReserveToken];
1278         Reserve storage toReserve = reserves[_toReserveToken];
1279         require(fromReserve.isSaleEnabled); // validate input
1280 
1281         IBancorFormula formula = IBancorFormula(registry.addressOf(ContractIds.BANCOR_FORMULA));
1282         uint256 amount = formula.calculateCrossReserveReturn(
1283             getReserveBalance(_fromReserveToken), 
1284             fromReserve.ratio, 
1285             getReserveBalance(_toReserveToken), 
1286             toReserve.ratio, 
1287             _amount);
1288         uint256 finalAmount = getFinalAmount(amount, 2);
1289 
1290         // return the amount minus the conversion fee and the conversion fee
1291         // the fee is higher (magnitude = 2) since cross reserve conversion equals 2 conversions (from / to the smart token)
1292         return (finalAmount, amount - finalAmount);
1293     }
1294 
1295     /**
1296       * @dev converts a specific amount of _fromToken to _toToken
1297       * can only be called by the bancor network contract
1298       * 
1299       * @param _fromToken  ERC20 token to convert from
1300       * @param _toToken    ERC20 token to convert to
1301       * @param _amount     amount to convert, in fromToken
1302       * @param _minReturn  if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1303       * 
1304       * @return conversion return amount
1305     */
1306     function convertInternal(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn)
1307         public
1308         bancorNetworkOnly
1309         conversionsAllowed
1310         greaterThanZero(_minReturn)
1311         returns (uint256)
1312     {
1313         require(_fromToken != _toToken); // validate input
1314 
1315         // conversion between the token and one of its reserves
1316         if (_toToken == token)
1317             return buy(_fromToken, _amount, _minReturn);
1318         else if (_fromToken == token)
1319             return sell(_toToken, _amount, _minReturn);
1320 
1321         uint256 amount;
1322         uint256 feeAmount;
1323 
1324         // conversion between 2 reserves
1325         (amount, feeAmount) = getCrossReserveReturn(_fromToken, _toToken, _amount);
1326         // ensure the trade gives something in return and meets the minimum requested amount
1327         require(amount != 0 && amount >= _minReturn);
1328 
1329         // update the source token virtual balance if relevant
1330         Reserve storage fromReserve = reserves[_fromToken];
1331         if (fromReserve.isVirtualBalanceEnabled)
1332             fromReserve.virtualBalance = fromReserve.virtualBalance.add(_amount);
1333 
1334         // update the target token virtual balance if relevant
1335         Reserve storage toReserve = reserves[_toToken];
1336         if (toReserve.isVirtualBalanceEnabled)
1337             toReserve.virtualBalance = toReserve.virtualBalance.sub(amount);
1338 
1339         // ensure that the trade won't deplete the reserve balance
1340         uint256 toReserveBalance = getReserveBalance(_toToken);
1341         assert(amount < toReserveBalance);
1342 
1343         // transfer funds from the caller in the from reserve token
1344         ensureTransferFrom(_fromToken, msg.sender, this, _amount);
1345         // transfer funds to the caller in the to reserve token
1346         // the transfer might fail if virtual balance is enabled
1347         ensureTransfer(_toToken, msg.sender, amount);
1348 
1349         // dispatch the conversion event
1350         // the fee is higher (magnitude = 2) since cross reserve conversion equals 2 conversions (from / to the smart token)
1351         dispatchConversionEvent(_fromToken, _toToken, _amount, amount, feeAmount);
1352 
1353         // dispatch price data updates for the smart token / both reserves
1354         emit PriceDataUpdate(_fromToken, token.totalSupply(), _fromToken.balanceOf(this), fromReserve.ratio);
1355         emit PriceDataUpdate(_toToken, token.totalSupply(), _toToken.balanceOf(this), toReserve.ratio);
1356         return amount;
1357     }
1358 
1359     /**
1360       * @dev buys the token by depositing one of its reserve tokens
1361       * 
1362       * @param _reserveToken    reserve token contract address
1363       * @param _depositAmount   amount to deposit (in the reserve token)
1364       * @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1365       * 
1366       * @return buy return amount
1367     */
1368     function buy(IERC20Token _reserveToken, uint256 _depositAmount, uint256 _minReturn) internal returns (uint256) {
1369         uint256 amount;
1370         uint256 feeAmount;
1371         (amount, feeAmount) = getPurchaseReturn(_reserveToken, _depositAmount);
1372         // ensure the trade gives something in return and meets the minimum requested amount
1373         require(amount != 0 && amount >= _minReturn);
1374 
1375         // update virtual balance if relevant
1376         Reserve storage reserve = reserves[_reserveToken];
1377         if (reserve.isVirtualBalanceEnabled)
1378             reserve.virtualBalance = reserve.virtualBalance.add(_depositAmount);
1379 
1380         // transfer funds from the caller in the reserve token
1381         ensureTransferFrom(_reserveToken, msg.sender, this, _depositAmount);
1382         // issue new funds to the caller in the smart token
1383         token.issue(msg.sender, amount);
1384 
1385         // dispatch the conversion event
1386         dispatchConversionEvent(_reserveToken, token, _depositAmount, amount, feeAmount);
1387 
1388         // dispatch price data update for the smart token/reserve
1389         emit PriceDataUpdate(_reserveToken, token.totalSupply(), _reserveToken.balanceOf(this), reserve.ratio);
1390         return amount;
1391     }
1392 
1393     /**
1394       * @dev sells the token by withdrawing from one of its reserve tokens
1395       * 
1396       * @param _reserveToken    reserve token contract address
1397       * @param _sellAmount      amount to sell (in the smart token)
1398       * @param _minReturn       if the conversion results in an amount smaller the minimum return - it is cancelled, must be nonzero
1399       * 
1400       * @return sell return amount
1401     */
1402     function sell(IERC20Token _reserveToken, uint256 _sellAmount, uint256 _minReturn) internal returns (uint256) {
1403         require(_sellAmount <= token.balanceOf(msg.sender)); // validate input
1404         uint256 amount;
1405         uint256 feeAmount;
1406         (amount, feeAmount) = getSaleReturn(_reserveToken, _sellAmount);
1407         // ensure the trade gives something in return and meets the minimum requested amount
1408         require(amount != 0 && amount >= _minReturn);
1409 
1410         // ensure that the trade will only deplete the reserve balance if the total supply is depleted as well
1411         uint256 tokenSupply = token.totalSupply();
1412         uint256 reserveBalance = _reserveToken.balanceOf(this);
1413         assert(amount < reserveBalance || (amount == reserveBalance && _sellAmount == tokenSupply));
1414 
1415         // update virtual balance if relevant
1416         Reserve storage reserve = reserves[_reserveToken];
1417         if (reserve.isVirtualBalanceEnabled)
1418             reserve.virtualBalance = reserve.virtualBalance.sub(amount);
1419 
1420         // destroy _sellAmount from the caller's balance in the smart token
1421         token.destroy(msg.sender, _sellAmount);
1422         // transfer funds to the caller in the reserve token
1423         ensureTransfer(_reserveToken, msg.sender, amount);
1424 
1425         // dispatch the conversion event
1426         dispatchConversionEvent(token, _reserveToken, _sellAmount, amount, feeAmount);
1427 
1428         // dispatch price data update for the smart token/reserve
1429         emit PriceDataUpdate(_reserveToken, token.totalSupply(), _reserveToken.balanceOf(this), reserve.ratio);
1430         return amount;
1431     }
1432 
1433     /**
1434       * @dev converts a specific amount of _fromToken to _toToken
1435       * note that prior to version 16, you should use 'convert' instead
1436       * 
1437       * @param _fromToken           ERC20 token to convert from
1438       * @param _toToken             ERC20 token to convert to
1439       * @param _amount              amount to convert, in fromToken
1440       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1441       * @param _affiliateAccount    affiliate account
1442       * @param _affiliateFee        affiliate fee in PPM
1443       * 
1444       * @return conversion return amount
1445     */
1446     function convert2(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee) public returns (uint256) {
1447         IERC20Token[] memory path = new IERC20Token[](3);
1448         (path[0], path[1], path[2]) = (_fromToken, token, _toToken);
1449         return quickConvert2(path, _amount, _minReturn, _affiliateAccount, _affiliateFee);
1450     }
1451 
1452     /**
1453       * @dev converts the token to any other token in the bancor network by following a predefined conversion path
1454       * note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1455       * note that prior to version 16, you should use 'quickConvert' instead
1456       * 
1457       * @param _path                conversion path, see conversion path format in the BancorNetwork contract
1458       * @param _amount              amount to convert from (in the initial source token)
1459       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1460       * @param _affiliateAccount    affiliate account
1461       * @param _affiliateFee        affiliate fee in PPM
1462       * 
1463       * @return tokens issued in return
1464     */
1465     function quickConvert2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _affiliateAccount, uint256 _affiliateFee)
1466         public
1467         payable
1468         returns (uint256)
1469     {
1470         return quickConvertPrioritized2(_path, _amount, _minReturn, getSignature(0x0, 0x0, 0x0, 0x0, 0x0), _affiliateAccount, _affiliateFee);
1471     }
1472 
1473     /**
1474       * @dev converts the token to any other token in the bancor network by following a predefined conversion path
1475       * note that when converting from an ERC20 token (as opposed to a smart token), allowance must be set beforehand
1476       * note that prior to version 16, you should use 'quickConvertPrioritized' instead
1477       * 
1478       * @param _path                conversion path, see conversion path format in the BancorNetwork contract
1479       * @param _amount              amount to convert from (in the initial source token)
1480       * @param _minReturn           if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1481       * @param _signature           an array of the following elements:
1482       *     [0] uint256             custom value that was signed for prioritized conversion; must be equal to _amount
1483       *     [1] uint256             if the current block exceeded the given parameter - it is cancelled
1484       *     [2] uint8               (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
1485       *     [3] bytes32             (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
1486       *     [4] bytes32             (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
1487       * if the array is empty (length == 0), then the gas-price limit is verified instead of the signature
1488       * @param _affiliateAccount    affiliate account
1489       * @param _affiliateFee        affiliate fee in PPM
1490       * 
1491       * @return tokens issued in return
1492     */
1493     function quickConvertPrioritized2(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256[] memory _signature, address _affiliateAccount, uint256 _affiliateFee)
1494         public
1495         payable
1496         returns (uint256)
1497     {
1498         require(_signature.length == 0 || _signature[0] == _amount);
1499 
1500         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1501 
1502         // we need to transfer the source tokens from the caller to the BancorNetwork contract,
1503         // so it can execute the conversion on behalf of the caller
1504         if (msg.value == 0) {
1505             // not ETH, send the source tokens to the BancorNetwork contract
1506             // if the token is the smart token, no allowance is required - destroy the tokens
1507             // from the caller and issue them to the BancorNetwork contract
1508             if (_path[0] == token) {
1509                 token.destroy(msg.sender, _amount); // destroy _amount tokens from the caller's balance in the smart token
1510                 token.issue(bancorNetwork, _amount); // issue _amount new tokens to the BancorNetwork contract
1511             } else {
1512                 // otherwise, we assume we already have allowance, transfer the tokens directly to the BancorNetwork contract
1513                 ensureTransferFrom(_path[0], msg.sender, bancorNetwork, _amount);
1514             }
1515         }
1516 
1517         // execute the conversion and pass on the ETH with the call
1518         return bancorNetwork.convertForPrioritized4.value(msg.value)(_path, _amount, _minReturn, msg.sender, _signature, _affiliateAccount, _affiliateFee);
1519     }
1520 
1521     /**
1522       * @dev allows a user to convert BNT that was sent from another blockchain into any other
1523       * token on the BancorNetwork without specifying the amount of BNT to be converted, but
1524       * rather by providing the xTransferId which allows us to get the amount from BancorX.
1525       * note that prior to version 16, you should use 'completeXConversion' instead
1526       * 
1527       * @param _path            conversion path, see conversion path format in the BancorNetwork contract
1528       * @param _minReturn       if the conversion results in an amount smaller than the minimum return - it is cancelled, must be nonzero
1529       * @param _conversionId    pre-determined unique (if non zero) id which refers to this transaction 
1530       * @param _signature       an array of the following elements:
1531       *     [0] uint256         custom value that was signed for prioritized conversion; must be equal to _conversionId
1532       *     [1] uint256         if the current block exceeded the given parameter - it is cancelled
1533       *     [2] uint8           (signature[128:130]) associated with the signer address and helps to validate if the signature is legit
1534       *     [3] bytes32         (signature[0:64]) associated with the signer address and helps to validate if the signature is legit
1535       *     [4] bytes32         (signature[64:128]) associated with the signer address and helps to validate if the signature is legit
1536       * if the array is empty (length == 0), then the gas-price limit is verified instead of the signature
1537       * 
1538       * @return tokens issued in return
1539     */
1540     function completeXConversion2(
1541         IERC20Token[] _path,
1542         uint256 _minReturn,
1543         uint256 _conversionId,
1544         uint256[] memory _signature
1545     )
1546         public
1547         returns (uint256)
1548     {
1549         // verify that the custom value (if valid) is equal to _conversionId
1550         require(_signature.length == 0 || _signature[0] == _conversionId);
1551 
1552         IBancorX bancorX = IBancorX(registry.addressOf(ContractIds.BANCOR_X));
1553         IBancorNetwork bancorNetwork = IBancorNetwork(registry.addressOf(ContractIds.BANCOR_NETWORK));
1554 
1555         // verify that the first token in the path is BNT
1556         require(_path[0] == registry.addressOf(ContractIds.BNT_TOKEN));
1557 
1558         // get conversion amount from BancorX contract
1559         uint256 amount = bancorX.getXTransferAmount(_conversionId, msg.sender);
1560 
1561         // send BNT from msg.sender to the BancorNetwork contract
1562         token.destroy(msg.sender, amount);
1563         token.issue(bancorNetwork, amount);
1564 
1565         return bancorNetwork.convertForPrioritized4(_path, amount, _minReturn, msg.sender, _signature, address(0), 0);
1566     }
1567 
1568     /**
1569       * @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1570       * true on success but revert on failure instead
1571       * 
1572       * @param _token     the token to transfer
1573       * @param _to        the address to transfer the tokens to
1574       * @param _amount    the amount to transfer
1575     */
1576     function ensureTransfer(IERC20Token _token, address _to, uint256 _amount) private {
1577         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1578 
1579         if (addressList.listedAddresses(_token)) {
1580             uint256 prevBalance = _token.balanceOf(_to);
1581             // we have to cast the token contract in an interface which has no return value
1582             INonStandardERC20(_token).transfer(_to, _amount);
1583             uint256 postBalance = _token.balanceOf(_to);
1584             assert(postBalance > prevBalance);
1585         } else {
1586             // if the token isn't whitelisted, we assert on transfer
1587             assert(_token.transfer(_to, _amount));
1588         }
1589     }
1590 
1591     /**
1592       * @dev ensures transfer of tokens, taking into account that some ERC-20 implementations don't return
1593       * true on success but revert on failure instead
1594       * 
1595       * @param _token     the token to transfer
1596       * @param _from      the address to transfer the tokens from
1597       * @param _to        the address to transfer the tokens to
1598       * @param _amount    the amount to transfer
1599     */
1600     function ensureTransferFrom(IERC20Token _token, address _from, address _to, uint256 _amount) private {
1601         IAddressList addressList = IAddressList(registry.addressOf(ContractIds.NON_STANDARD_TOKEN_REGISTRY));
1602 
1603         if (addressList.listedAddresses(_token)) {
1604             uint256 prevBalance = _token.balanceOf(_to);
1605             // we have to cast the token contract in an interface which has no return value
1606             INonStandardERC20(_token).transferFrom(_from, _to, _amount);
1607             uint256 postBalance = _token.balanceOf(_to);
1608             assert(postBalance > prevBalance);
1609         } else {
1610             // if the token is standard, we assert on transfer
1611             assert(_token.transferFrom(_from, _to, _amount));
1612         }
1613     }
1614 
1615     /**
1616       * @dev buys the token with all reserve tokens using the same percentage
1617       * for example, if the caller increases the supply by 10%,
1618       * then it will cost an amount equal to 10% of each reserve token balance
1619       * note that the function can be called only if the total ratio is 100% and conversions are enabled
1620       * 
1621       * @param _amount  amount to increase the supply by (in the smart token)
1622     */
1623     function fund(uint256 _amount)
1624         public
1625         fullTotalRatioOnly
1626         conversionsAllowed
1627     {
1628         uint256 supply = token.totalSupply();
1629 
1630         // iterate through the reserve tokens and transfer a percentage equal to the ratio between _amount
1631         // and the total supply in each reserve from the caller to the converter
1632         IERC20Token reserveToken;
1633         uint256 reserveBalance;
1634         uint256 reserveAmount;
1635         for (uint16 i = 0; i < reserveTokens.length; i++) {
1636             reserveToken = reserveTokens[i];
1637             reserveBalance = reserveToken.balanceOf(this);
1638             reserveAmount = _amount.mul(reserveBalance).sub(1).div(supply).add(1);
1639 
1640             // update virtual balance if relevant
1641             Reserve storage reserve = reserves[reserveToken];
1642             if (reserve.isVirtualBalanceEnabled)
1643                 reserve.virtualBalance = reserve.virtualBalance.add(reserveAmount);
1644 
1645             // transfer funds from the caller in the reserve token
1646             ensureTransferFrom(reserveToken, msg.sender, this, reserveAmount);
1647 
1648             // dispatch price data update for the smart token/reserve
1649             emit PriceDataUpdate(reserveToken, supply + _amount, reserveBalance + reserveAmount, reserve.ratio);
1650         }
1651 
1652         // issue new funds to the caller in the smart token
1653         token.issue(msg.sender, _amount);
1654     }
1655 
1656     /**
1657       * @dev sells the token for all reserve tokens using the same percentage
1658       * for example, if the holder sells 10% of the supply,
1659       * then they will receive 10% of each reserve token balance in return
1660       * note that the function can be called only if the total ratio is 100%
1661       * 
1662       * @param _amount  amount to liquidate (in the smart token)
1663     */
1664     function liquidate(uint256 _amount) public fullTotalRatioOnly {
1665         uint256 supply = token.totalSupply();
1666 
1667         // destroy _amount from the caller's balance in the smart token
1668         token.destroy(msg.sender, _amount);
1669 
1670         // iterate through the reserve tokens and send a percentage equal to the ratio between _amount
1671         // and the total supply from each reserve balance to the caller
1672         IERC20Token reserveToken;
1673         uint256 reserveBalance;
1674         uint256 reserveAmount;
1675         for (uint16 i = 0; i < reserveTokens.length; i++) {
1676             reserveToken = reserveTokens[i];
1677             reserveBalance = reserveToken.balanceOf(this);
1678             reserveAmount = _amount.mul(reserveBalance).div(supply);
1679 
1680             // update virtual balance if relevant
1681             Reserve storage reserve = reserves[reserveToken];
1682             if (reserve.isVirtualBalanceEnabled)
1683                 reserve.virtualBalance = reserve.virtualBalance.sub(reserveAmount);
1684 
1685             // transfer funds to the caller in the reserve token
1686             ensureTransfer(reserveToken, msg.sender, reserveAmount);
1687 
1688             // dispatch price data update for the smart token/reserve
1689             emit PriceDataUpdate(reserveToken, supply - _amount, reserveBalance - reserveAmount, reserve.ratio);
1690         }
1691     }
1692 
1693     /**
1694       * @dev helper, dispatches the Conversion event
1695       * 
1696       * @param _fromToken       ERC20 token to convert from
1697       * @param _toToken         ERC20 token to convert to
1698       * @param _amount          amount purchased/sold (in the source token)
1699       * @param _returnAmount    amount returned (in the target token)
1700     */
1701     function dispatchConversionEvent(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _returnAmount, uint256 _feeAmount) private {
1702         // fee amount is converted to 255 bits -
1703         // negative amount means the fee is taken from the source token, positive amount means its taken from the target token
1704         // currently the fee is always taken from the target token
1705         // since we convert it to a signed number, we first ensure that it's capped at 255 bits to prevent overflow
1706         assert(_feeAmount < 2 ** 255);
1707         emit Conversion(_fromToken, _toToken, msg.sender, _amount, _returnAmount, int256(_feeAmount));
1708     }
1709 
1710     function getSignature(
1711         uint256 _customVal,
1712         uint256 _block,
1713         uint8 _v,
1714         bytes32 _r,
1715         bytes32 _s
1716     ) private pure returns (uint256[] memory) {
1717         if (_v == 0x0 && _r == 0x0 && _s == 0x0)
1718             return new uint256[](0);
1719         uint256[] memory signature = new uint256[](5);
1720         signature[0] = _customVal;
1721         signature[1] = _block;
1722         signature[2] = uint256(_v);
1723         signature[3] = uint256(_r);
1724         signature[4] = uint256(_s);
1725         return signature;
1726     }
1727 
1728     /**
1729       * @dev deprecated, backward compatibility
1730     */
1731     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1732         return convertInternal(_fromToken, _toToken, _amount, _minReturn);
1733     }
1734 
1735     /**
1736       * @dev deprecated, backward compatibility
1737     */
1738     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256) {
1739         return convert2(_fromToken, _toToken, _amount, _minReturn, address(0), 0);
1740     }
1741 
1742     /**
1743       * @dev deprecated, backward compatibility
1744     */
1745     function quickConvert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256) {
1746         return quickConvert2(_path, _amount, _minReturn, address(0), 0);
1747     }
1748 
1749     /**
1750       * @dev deprecated, backward compatibility
1751     */
1752     function quickConvertPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256) {
1753         return quickConvertPrioritized2(_path, _amount, _minReturn, getSignature(_amount, _block, _v, _r, _s), address(0), 0);
1754     }
1755 
1756     /**
1757       * @dev deprecated, backward compatibility
1758     */
1759     function completeXConversion(IERC20Token[] _path, uint256 _minReturn, uint256 _conversionId, uint256 _block, uint8 _v, bytes32 _r, bytes32 _s) public returns (uint256) {
1760         return completeXConversion2(_path, _minReturn, _conversionId, getSignature(_conversionId, _block, _v, _r, _s));
1761     }
1762 
1763     /**
1764       * @dev deprecated, backward compatibility
1765     */
1766     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) {
1767         Reserve storage reserve = reserves[_address];
1768         return(reserve.virtualBalance, reserve.ratio, reserve.isVirtualBalanceEnabled, reserve.isSaleEnabled, reserve.isSet);
1769     }
1770 
1771     /**
1772       * @dev deprecated, backward compatibility
1773     */
1774     function connectorTokens(uint256 _index) public view returns (IERC20Token) {
1775         return BancorConverter.reserveTokens[_index];
1776     }
1777 
1778     /**
1779       * @dev deprecated, backward compatibility
1780     */
1781     function connectorTokenCount() public view returns (uint16) {
1782         return reserveTokenCount();
1783     }
1784 
1785     /**
1786       * @dev deprecated, backward compatibility
1787     */
1788     function addConnector(IERC20Token _token, uint32 _weight, bool /*_enableVirtualBalance*/) public {
1789         addReserve(_token, _weight);
1790     }
1791 
1792     /**
1793       * @dev deprecated, backward compatibility
1794     */
1795     function updateConnector(IERC20Token _connectorToken, uint32 /*_weight*/, bool /*_enableVirtualBalance*/, uint256 _virtualBalance) public {
1796         updateReserveVirtualBalance(_connectorToken, _virtualBalance);
1797     }
1798 
1799     /**
1800       * @dev deprecated, backward compatibility
1801     */
1802     function disableConnectorSale(IERC20Token _connectorToken, bool _disable) public {
1803         disableReserveSale(_connectorToken, _disable);
1804     }
1805 
1806     /**
1807       * @dev deprecated, backward compatibility
1808     */
1809     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256) {
1810         return getReserveBalance(_connectorToken);
1811     }
1812 
1813     /**
1814       * @dev deprecated, backward compatibility
1815     */
1816     function getCrossConnectorReturn(IERC20Token _fromConnectorToken, IERC20Token _toConnectorToken, uint256 _amount) public view returns (uint256, uint256) {
1817         return getCrossReserveReturn(_fromConnectorToken, _toConnectorToken, _amount);
1818     }
1819 }
