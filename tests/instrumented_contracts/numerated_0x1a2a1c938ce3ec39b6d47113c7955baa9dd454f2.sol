1 // File: @axie/contract-library/contracts/access/HasAdmin.sol
2 
3 pragma solidity ^0.5.2;
4 
5 
6 contract HasAdmin {
7   event AdminChanged(address indexed _oldAdmin, address indexed _newAdmin);
8   event AdminRemoved(address indexed _oldAdmin);
9 
10   address public admin;
11 
12   modifier onlyAdmin {
13     require(msg.sender == admin);
14     _;
15   }
16 
17   constructor() internal {
18     admin = msg.sender;
19     emit AdminChanged(address(0), admin);
20   }
21 
22   function changeAdmin(address _newAdmin) external onlyAdmin {
23     require(_newAdmin != address(0));
24     emit AdminChanged(admin, _newAdmin);
25     admin = _newAdmin;
26   }
27 
28   function removeAdmin() external onlyAdmin {
29     emit AdminRemoved(admin);
30     admin = address(0);
31   }
32 }
33 
34 // File: @axie/contract-library/contracts/proxy/ProxyStorage.sol
35 
36 pragma solidity ^0.5.2;
37 
38 /**
39  * @title ProxyStorage
40  * @dev Store the address of logic contact that the proxy should forward to.
41  */
42 contract ProxyStorage is HasAdmin {
43   address internal _proxyTo;
44 }
45 
46 // File: @axie/contract-library/contracts/proxy/Proxy.sol
47 
48 pragma solidity ^0.5.2;
49 
50 
51 /**
52  * @title Proxy
53  * @dev Gives the possibility to delegate any call to a foreign implementation.
54  */
55 contract Proxy is ProxyStorage {
56 
57   event ProxyUpdated(address indexed _new, address indexed _old);
58 
59   constructor(address _proxyTo) public {
60     updateProxyTo(_proxyTo);
61   }
62 
63   /**
64   * @dev Tells the address of the implementation where every call will be delegated.
65   * @return address of the implementation to which it will be delegated
66   */
67   function implementation() public view returns (address) {
68     return _proxyTo;
69   }
70 
71   /**
72   * @dev See more at: https://eips.ethereum.org/EIPS/eip-897
73   * @return type of proxy - always upgradable
74   */
75   function proxyType() external pure returns (uint256) {
76       // Upgradeable proxy
77       return 2;
78   }
79 
80   /**
81   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
82   * This function will return whatever the implementation call returns
83   */
84   function () payable external {
85     address _impl = implementation();
86     require(_impl != address(0));
87 
88     assembly {
89       let ptr := mload(0x40)
90       calldatacopy(ptr, 0, calldatasize)
91       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
92       let size := returndatasize
93       returndatacopy(ptr, 0, size)
94 
95       switch result
96       case 0 { revert(ptr, size) }
97       default { return(ptr, size) }
98     }
99   }
100 
101   function updateProxyTo(address _newProxyTo) public onlyAdmin {
102     require(_newProxyTo != address(0x0));
103 
104     _proxyTo = _newProxyTo;
105     emit ProxyUpdated(_newProxyTo, _proxyTo);
106   }
107 }
108 
109 // File: @axie/contract-library/contracts/lifecycle/Pausable.sol
110 
111 pragma solidity ^0.5.2;
112 
113 
114 
115 contract Pausable is HasAdmin {
116   event Paused();
117   event Unpaused();
118 
119   bool public paused;
120 
121   modifier whenNotPaused() {
122     require(!paused);
123     _;
124   }
125 
126   modifier whenPaused() {
127     require(paused);
128     _;
129   }
130 
131   function pause() public onlyAdmin whenNotPaused {
132     paused = true;
133     emit Paused();
134   }
135 
136   function unpause() public onlyAdmin whenPaused {
137     paused = false;
138     emit Unpaused();
139   }
140 }
141 
142 // File: @axie/contract-library/contracts/math/SafeMath.sol
143 
144 pragma solidity ^0.5.2;
145 
146 
147 library SafeMath {
148   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
149     c = a + b;
150     require(c >= a);
151   }
152 
153   function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
154     require(b <= a);
155     return a - b;
156   }
157 
158   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
159     if (a == 0) {
160       return 0;
161     }
162 
163     c = a * b;
164     require(c / a == b);
165   }
166 
167   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
168     // Since Solidity automatically asserts when dividing by 0,
169     // but we only need it to revert.
170     require(b > 0);
171     return a / b;
172   }
173 
174   function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
175     // Same reason as `div`.
176     require(b > 0);
177     return a % b;
178   }
179 
180   function ceilingDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
181     return add(div(a, b), mod(a, b) > 0 ? 1 : 0);
182   }
183 
184   function subU64(uint64 a, uint64 b) internal pure returns (uint64 c) {
185     require(b <= a);
186     return a - b;
187   }
188 
189   function addU8(uint8 a, uint8 b) internal pure returns (uint8 c) {
190     c = a + b;
191     require(c >= a);
192   }
193 }
194 
195 // File: contracts/chain/common/IValidator.sol
196 
197 pragma solidity ^0.5.17;
198 
199 
200 contract IValidator {
201   event ValidatorAdded(uint256 indexed _id, address indexed _validator);
202   event ValidatorRemoved(uint256 indexed _id, address indexed _validator);
203   event ThresholdUpdated(
204     uint256 indexed _id,
205     uint256 indexed _numerator,
206     uint256 indexed _denominator,
207     uint256 _previousNumerator,
208     uint256 _previousDenominator
209   );
210 
211   function isValidator(address _addr) public view returns (bool);
212   function getValidators() public view returns (address[] memory _validators);
213 
214   function checkThreshold(uint256 _voteCount) public view returns (bool);
215 }
216 
217 // File: contracts/chain/common/Validator.sol
218 
219 pragma solidity ^0.5.17;
220 
221 
222 
223 
224 contract Validator is IValidator {
225   using SafeMath for uint256;
226 
227   mapping(address => bool) validatorMap;
228   address[] public validators;
229   uint256 public validatorCount;
230 
231   uint256 public num;
232   uint256 public denom;
233 
234   constructor(address[] memory _validators, uint256 _num, uint256 _denom)
235     public
236   {
237     validators = _validators;
238     validatorCount = _validators.length;
239 
240     for (uint256 _i = 0; _i < validatorCount; _i++) {
241       address _validator = _validators[_i];
242       validatorMap[_validator] = true;
243     }
244 
245     num = _num;
246     denom = _denom;
247   }
248 
249   function isValidator(address _addr)
250     public
251     view
252     returns (bool)
253   {
254     return validatorMap[_addr];
255   }
256 
257   function getValidators()
258     public
259     view
260     returns (address[] memory _validators)
261   {
262     _validators = validators;
263   }
264 
265   function checkThreshold(uint256 _voteCount)
266     public
267     view
268     returns (bool)
269   {
270     return _voteCount.mul(denom) >= num.mul(validatorCount);
271   }
272 
273   function _addValidator(uint256 _id, address _validator)
274     internal
275   {
276     require(!validatorMap[_validator]);
277 
278     validators.push(_validator);
279     validatorMap[_validator] = true;
280     validatorCount++;
281 
282     emit ValidatorAdded(_id, _validator);
283   }
284 
285   function _removeValidator(uint256 _id, address _validator)
286     internal
287   {
288     require(isValidator(_validator));
289 
290     uint256 _index;
291     for (uint256 _i = 0; _i < validatorCount; _i++) {
292       if (validators[_i] == _validator) {
293         _index = _i;
294         break;
295       }
296     }
297 
298     validatorMap[_validator] = false;
299     validators[_index] = validators[validatorCount - 1];
300     validators.pop();
301 
302     validatorCount--;
303 
304     emit ValidatorRemoved(_id, _validator);
305   }
306 
307   function _updateQuorum(uint256 _id, uint256 _numerator, uint256 _denominator)
308     internal
309   {
310     require(_numerator <= _denominator);
311     uint256 _previousNumerator = num;
312     uint256 _previousDenominator = denom;
313 
314     num = _numerator;
315     denom = _denominator;
316 
317     emit ThresholdUpdated(
318       _id,
319       _numerator,
320       _denominator,
321       _previousNumerator,
322       _previousDenominator
323     );
324   }
325 }
326 
327 // File: contracts/chain/mainchain/MainchainValidator.sol
328 
329 pragma solidity ^0.5.17;
330 
331 
332 
333 
334 /**
335  * @title Validator
336  * @dev Simple validator contract
337  */
338 contract MainchainValidator is Validator, HasAdmin {
339   uint256 nonce;
340 
341   constructor(
342     address[] memory _validators,
343     uint256 _num,
344     uint256 _denom
345   ) Validator(_validators, _num, _denom) public {
346   }
347 
348   function addValidators(address[] calldata _validators) external onlyAdmin {
349     for (uint256 _i; _i < _validators.length; ++_i) {
350       _addValidator(nonce++, _validators[_i]);
351     }
352   }
353 
354   function removeValidator(address _validator) external onlyAdmin {
355     _removeValidator(nonce++, _validator);
356   }
357 
358   function updateQuorum(uint256 _numerator, uint256 _denominator) external onlyAdmin {
359     _updateQuorum(nonce++, _numerator, _denominator);
360   }
361 }
362 
363 // File: contracts/chain/common/Registry.sol
364 
365 pragma solidity ^0.5.17;
366 
367 
368 
369 contract Registry is HasAdmin {
370 
371   event ContractAddressUpdated(
372     string indexed _name,
373     bytes32 indexed _code,
374     address indexed _newAddress
375   );
376 
377   event TokenMapped(
378     address indexed _mainchainToken,
379     address indexed _sidechainToken,
380     uint32 _standard
381   );
382 
383   string public constant GATEWAY = "GATEWAY";
384   string public constant WETH_TOKEN = "WETH_TOKEN";
385   string public constant VALIDATOR = "VALIDATOR";
386   string public constant ACKNOWLEDGEMENT = "ACKNOWLEDGEMENT";
387 
388   struct TokenMapping {
389     address mainchainToken;
390     address sidechainToken;
391     uint32 standard; // 20, 721 or any other standards
392   }
393 
394   mapping(bytes32 => address) public contractAddresses;
395   mapping(address => TokenMapping) public mainchainMap;
396   mapping(address => TokenMapping) public sidechainMap;
397 
398   function getContract(string calldata _name)
399     external
400     view
401     returns (address _address)
402   {
403     bytes32 _code = getCode(_name);
404     _address = contractAddresses[_code];
405     require(_address != address(0));
406   }
407 
408   function isTokenMapped(address _token, uint32 _standard, bool _isMainchain)
409     external
410     view
411     returns (bool)
412   {
413     TokenMapping memory _mapping = _getTokenMapping(_token, _isMainchain);
414 
415     return _mapping.mainchainToken != address(0) &&
416       _mapping.sidechainToken != address(0) &&
417       _mapping.standard == _standard;
418   }
419 
420   function updateContract(string calldata _name, address _newAddress)
421     external
422     onlyAdmin
423   {
424     bytes32 _code = getCode(_name);
425     contractAddresses[_code] = _newAddress;
426 
427     emit ContractAddressUpdated(_name, _code, _newAddress);
428   }
429 
430   function mapToken(address _mainchainToken, address _sidechainToken, uint32 _standard)
431     external
432     onlyAdmin
433   {
434     TokenMapping memory _map = TokenMapping(
435       _mainchainToken,
436       _sidechainToken,
437       _standard
438     );
439 
440     mainchainMap[_mainchainToken] = _map;
441     sidechainMap[_sidechainToken] = _map;
442 
443     emit TokenMapped(
444       _mainchainToken,
445       _sidechainToken,
446       _standard
447     );
448   }
449 
450   function clearMapToken(address _mainchainToken, address _sidechainToken)
451     external
452     onlyAdmin
453   {
454     TokenMapping storage _mainchainMap = mainchainMap[_mainchainToken];
455     _clearMapEntry(_mainchainMap);
456 
457     TokenMapping storage _sidechainMap = sidechainMap[_sidechainToken];
458     _clearMapEntry(_sidechainMap);
459   }
460 
461   function getMappedToken(
462     address _token,
463     bool _isMainchain
464   )
465     external
466     view
467   returns (
468     address _mainchainToken,
469     address _sidechainToken,
470     uint32 _standard
471   )
472   {
473     TokenMapping memory _mapping = _getTokenMapping(_token, _isMainchain);
474     _mainchainToken = _mapping.mainchainToken;
475     _sidechainToken = _mapping.sidechainToken;
476     _standard = _mapping.standard;
477   }
478 
479   function getCode(string memory _name)
480     public
481     pure
482     returns (bytes32)
483   {
484     return keccak256(abi.encodePacked(_name));
485   }
486 
487   function _getTokenMapping(
488     address _token,
489     bool isMainchain
490   )
491     internal
492     view
493     returns (TokenMapping memory _mapping)
494   {
495     if (isMainchain) {
496       _mapping = mainchainMap[_token];
497     } else {
498       _mapping = sidechainMap[_token];
499     }
500   }
501 
502   function _clearMapEntry(TokenMapping storage _entry)
503     internal
504   {
505     _entry.mainchainToken = address(0);
506     _entry.sidechainToken = address(0);
507     _entry.standard = 0;
508   }
509 }
510 
511 // File: contracts/chain/mainchain/MainchainGatewayStorage.sol
512 
513 pragma solidity ^0.5.17;
514 
515 
516 
517 
518 
519 
520 
521 /**
522  * @title GatewayStorage
523  * @dev Storage of deposit and withdraw information.
524  */
525 contract MainchainGatewayStorage is ProxyStorage, Pausable {
526 
527   event TokenDeposited(
528     uint256 indexed _depositId,
529     address indexed _owner,
530     address indexed _tokenAddress,
531     address _sidechainAddress,
532     uint32  _standard,
533     uint256 _tokenNumber // ERC-20 amount or ERC721 tokenId
534   );
535 
536   event TokenWithdrew(
537     uint256 indexed _withdrawId,
538     address indexed _owner,
539     address indexed _tokenAddress,
540     uint256 _tokenNumber
541   );
542 
543   struct DepositEntry {
544     address owner;
545     address tokenAddress;
546     address sidechainAddress;
547     uint32  standard;
548     uint256 tokenNumber;
549   }
550 
551   struct WithdrawalEntry {
552     address owner;
553     address tokenAddress;
554     uint256 tokenNumber;
555   }
556 
557   Registry public registry;
558 
559   uint256 public depositCount;
560   DepositEntry[] public deposits;
561   mapping(uint256 => WithdrawalEntry) public withdrawals;
562 
563   function updateRegistry(address _registry) external onlyAdmin {
564     registry = Registry(_registry);
565   }
566 }
567 
568 // File: contracts/chain/mainchain/MainchainGatewayProxy.sol
569 
570 pragma solidity ^0.5.17;
571 
572 
573 
574 
575 
576 
577 contract MainchainGatewayProxy is Proxy, MainchainGatewayStorage {
578   constructor(address _proxyTo, address _registry)
579     public
580     Proxy(_proxyTo)
581   {
582     registry = Registry(_registry);
583   }
584 }