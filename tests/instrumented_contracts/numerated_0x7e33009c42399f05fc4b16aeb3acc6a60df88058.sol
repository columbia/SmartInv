1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/interfaces/IERC20Token.sol
4 
5 /*
6     ERC20 Standard Token interface
7 */
8 contract IERC20Token {
9     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
10     function name() public view returns (string) {}
11     function symbol() public view returns (string) {}
12     function decimals() public view returns (uint8) {}
13     function totalSupply() public view returns (uint256) {}
14     function balanceOf(address _owner) public view returns (uint256) { _owner; }
15     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
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
38     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
39     function conversionWhitelist() public view returns (IWhitelist) {}
40     function conversionFee() public view returns (uint32) {}
41     function connectors(address _address) public view returns (uint256, uint32, bool, bool, bool) { _address; }
42     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
43     function claimTokens(address _from, uint256 _amount) public;
44     // deprecated, backward compatibility
45     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
46 }
47 
48 // File: contracts/converter/interfaces/IBancorConverterUpgrader.sol
49 
50 /*
51     Bancor Converter Upgrader interface
52 */
53 contract IBancorConverterUpgrader {
54     function upgrade(bytes32 _version) public;
55 }
56 
57 // File: contracts/utility/interfaces/IOwned.sol
58 
59 /*
60     Owned contract interface
61 */
62 contract IOwned {
63     // this function isn't abstract since the compiler emits automatically generated getter functions as external
64     function owner() public view returns (address) {}
65 
66     function transferOwnership(address _newOwner) public;
67     function acceptOwnership() public;
68 }
69 
70 // File: contracts/token/interfaces/ISmartToken.sol
71 
72 /*
73     Smart Token interface
74 */
75 contract ISmartToken is IOwned, IERC20Token {
76     function disableTransfers(bool _disable) public;
77     function issue(address _to, uint256 _amount) public;
78     function destroy(address _from, uint256 _amount) public;
79 }
80 
81 // File: contracts/utility/interfaces/IContractRegistry.sol
82 
83 /*
84     Contract Registry interface
85 */
86 contract IContractRegistry {
87     function addressOf(bytes32 _contractName) public view returns (address);
88 
89     // deprecated, backward compatibility
90     function getAddress(bytes32 _contractName) public view returns (address);
91 }
92 
93 // File: contracts/converter/interfaces/IBancorConverterFactory.sol
94 
95 /*
96     Bancor Converter Factory interface
97 */
98 contract IBancorConverterFactory {
99     function createConverter(
100         ISmartToken _token,
101         IContractRegistry _registry,
102         uint32 _maxConversionFee,
103         IERC20Token _connectorToken,
104         uint32 _connectorWeight
105     )
106     public returns (address);
107 }
108 
109 // File: contracts/utility/Owned.sol
110 
111 /*
112     Provides support and utilities for contract ownership
113 */
114 contract Owned is IOwned {
115     address public owner;
116     address public newOwner;
117 
118     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
119 
120     /**
121         @dev constructor
122     */
123     constructor() public {
124         owner = msg.sender;
125     }
126 
127     // allows execution by the owner only
128     modifier ownerOnly {
129         require(msg.sender == owner);
130         _;
131     }
132 
133     /**
134         @dev allows transferring the contract ownership
135         the new owner still needs to accept the transfer
136         can only be called by the contract owner
137 
138         @param _newOwner    new contract owner
139     */
140     function transferOwnership(address _newOwner) public ownerOnly {
141         require(_newOwner != owner);
142         newOwner = _newOwner;
143     }
144 
145     /**
146         @dev used by a new owner to accept an ownership transfer
147     */
148     function acceptOwnership() public {
149         require(msg.sender == newOwner);
150         emit OwnerUpdate(owner, newOwner);
151         owner = newOwner;
152         newOwner = address(0);
153     }
154 }
155 
156 // File: contracts/utility/interfaces/IContractFeatures.sol
157 
158 /*
159     Contract Features interface
160 */
161 contract IContractFeatures {
162     function isSupported(address _contract, uint256 _features) public view returns (bool);
163     function enableFeatures(uint256 _features, bool _enable) public;
164 }
165 
166 // File: contracts/ContractIds.sol
167 
168 /**
169     Id definitions for bancor contracts
170 
171     Can be used in conjunction with the contract registry to get contract addresses
172 */
173 contract ContractIds {
174     // generic
175     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
176     bytes32 public constant CONTRACT_REGISTRY = "ContractRegistry";
177 
178     // bancor logic
179     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
180     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
181     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
182     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
183     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
184 
185     // Ids of BNT converter and BNT token
186     bytes32 public constant BNT_TOKEN = "BNTToken";
187     bytes32 public constant BNT_CONVERTER = "BNTConverter";
188 
189     // Id of BancorX contract
190     bytes32 public constant BANCOR_X = "BancorX";
191 }
192 
193 // File: contracts/FeatureIds.sol
194 
195 /**
196     Id definitions for bancor contract features
197 
198     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
199 */
200 contract FeatureIds {
201     // converter features
202     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
203 }
204 
205 // File: contracts/converter/BancorConverterUpgrader.sol
206 
207 /*
208     Bancor converter dedicated interface
209 */
210 contract IBancorConverterExtended is IBancorConverter, IOwned {
211     function token() public view returns (ISmartToken) {}
212     function maxConversionFee() public view returns (uint32) {}
213     function conversionFee() public view returns (uint32) {}
214     function connectorTokenCount() public view returns (uint16);
215     function reserveTokenCount() public view returns (uint16);
216     function connectorTokens(uint256 _index) public view returns (IERC20Token) { _index; }
217     function reserveTokens(uint256 _index) public view returns (IERC20Token) { _index; }
218     function setConversionWhitelist(IWhitelist _whitelist) public;
219     function transferTokenOwnership(address _newOwner) public;
220     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
221     function acceptTokenOwnership() public;
222     function transferManagement(address _newManager) public;
223     function acceptManagement() public;
224     function setConversionFee(uint32 _conversionFee) public;
225     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance) public;
226     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance) public;
227     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
228     function getReserveBalance(IERC20Token _reserveToken) public view returns (uint256);
229     function reserves(address _address) public view returns (
230         uint256 virtualBalance, 
231         uint32 weight, 
232         bool isVirtualBalanceEnabled, 
233         bool isPurchaseEnabled, 
234         bool isSet
235     );
236 }
237 
238 /*
239     Bancor Converter Upgrader
240 
241     The Bancor converter upgrader contract allows upgrading an older Bancor converter
242     contract (0.4 and up) to the latest version.
243     To begin the upgrade process, first transfer the converter ownership to the upgrader
244     contract and then call the upgrade function.
245     At the end of the process, the ownership of the newly upgraded converter will be transferred
246     back to the original owner.
247     The address of the new converter is available in the ConverterUpgrade event.
248 */
249 contract BancorConverterUpgrader is IBancorConverterUpgrader, Owned, ContractIds, FeatureIds {
250     string public version = '0.3';
251 
252     IContractRegistry public registry;                      // contract registry contract address
253 
254     // triggered when the contract accept a converter ownership
255     event ConverterOwned(address indexed _converter, address indexed _owner);
256     // triggered when the upgrading process is done
257     event ConverterUpgrade(address indexed _oldConverter, address indexed _newConverter);
258 
259     /**
260         @dev constructor
261     */
262     constructor(IContractRegistry _registry) public {
263         registry = _registry;
264     }
265 
266     /*
267         @dev allows the owner to update the contract registry contract address
268 
269         @param _registry   address of a contract registry contract
270     */
271     function setRegistry(IContractRegistry _registry) public ownerOnly {
272         registry = _registry;
273     }
274 
275     /**
276         @dev upgrades an old converter to the latest version
277         will throw if ownership wasn't transferred to the upgrader before calling this function.
278         ownership of the new converter will be transferred back to the original owner.
279         fires the ConverterUpgrade event upon success.
280         can only be called by a converter
281 
282         @param _version old converter version
283     */
284     function upgrade(bytes32 _version) public {
285         upgradeOld(IBancorConverter(msg.sender), _version);
286     }
287 
288     /**
289         @dev upgrades an old converter to the latest version
290         will throw if ownership wasn't transferred to the upgrader before calling this function.
291         ownership of the new converter will be transferred back to the original owner.
292         fires the ConverterUpgrade event upon success.
293 
294         @param _converter   old converter contract address
295         @param _version     old converter version
296     */
297     function upgradeOld(IBancorConverter _converter, bytes32 _version) public {
298         bool formerVersions = false;
299         if (_version == "0.4")
300             formerVersions = true;
301         IBancorConverterExtended converter = IBancorConverterExtended(_converter);
302         address prevOwner = converter.owner();
303         acceptConverterOwnership(converter);
304         IBancorConverterExtended newConverter = createConverter(converter);
305         copyConnectors(converter, newConverter, formerVersions);
306         copyConversionFee(converter, newConverter);
307         transferConnectorsBalances(converter, newConverter, formerVersions);                
308         ISmartToken token = converter.token();
309 
310         if (token.owner() == address(converter)) {
311             converter.transferTokenOwnership(newConverter);
312             newConverter.acceptTokenOwnership();
313         }
314 
315         converter.transferOwnership(prevOwner);
316         newConverter.transferOwnership(prevOwner);
317         newConverter.transferManagement(prevOwner);
318 
319         emit ConverterUpgrade(address(converter), address(newConverter));
320     }
321 
322     /**
323         @dev the first step when upgrading a converter is to transfer the ownership to the local contract.
324         the upgrader contract then needs to accept the ownership transfer before initiating
325         the upgrade process.
326         fires the ConverterOwned event upon success
327 
328         @param _oldConverter       converter to accept ownership of
329     */
330     function acceptConverterOwnership(IBancorConverterExtended _oldConverter) private {
331         _oldConverter.acceptOwnership();
332         emit ConverterOwned(_oldConverter, this);
333     }
334 
335     /**
336         @dev creates a new converter with same basic data as the original old converter
337         the newly created converter will have no connectors at this step.
338 
339         @param _oldConverter    old converter contract address
340 
341         @return the new converter  new converter contract address
342     */
343     function createConverter(IBancorConverterExtended _oldConverter) private returns(IBancorConverterExtended) {
344         IWhitelist whitelist;
345         ISmartToken token = _oldConverter.token();
346         uint32 maxConversionFee = _oldConverter.maxConversionFee();
347 
348         IBancorConverterFactory converterFactory = IBancorConverterFactory(registry.addressOf(ContractIds.BANCOR_CONVERTER_FACTORY));
349         address converterAddress  = converterFactory.createConverter(
350             token,
351             registry,
352             maxConversionFee,
353             IERC20Token(address(0)),
354             0
355         );
356 
357         IBancorConverterExtended converter = IBancorConverterExtended(converterAddress);
358         converter.acceptOwnership();
359         converter.acceptManagement();
360 
361         // get the contract features address from the registry
362         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
363 
364         if (features.isSupported(_oldConverter, FeatureIds.CONVERTER_CONVERSION_WHITELIST)) {
365             whitelist = _oldConverter.conversionWhitelist();
366             if (whitelist != address(0))
367                 converter.setConversionWhitelist(whitelist);
368         }
369 
370         return converter;
371     }
372 
373     /**
374         @dev copies the connectors from the old converter to the new one.
375         note that this will not work for an unlimited number of connectors due to block gas limit constraints.
376 
377         @param _oldConverter    old converter contract address
378         @param _newConverter    new converter contract address
379         @param _isLegacyVersion true if the converter version is under 0.5
380     */
381     function copyConnectors(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter, bool _isLegacyVersion)
382         private
383     {
384         uint256 virtualBalance;
385         uint32 weight;
386         bool isVirtualBalanceEnabled;
387         bool isPurchaseEnabled;
388         bool isSet;
389         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
390 
391         for (uint16 i = 0; i < connectorTokenCount; i++) {
392             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
393             (virtualBalance, weight, isVirtualBalanceEnabled, isPurchaseEnabled, isSet) = readConnector(
394                 _oldConverter,
395                 connectorAddress,
396                 _isLegacyVersion
397             );
398 
399             IERC20Token connectorToken = IERC20Token(connectorAddress);
400             _newConverter.addConnector(connectorToken, weight, isVirtualBalanceEnabled);
401 
402             if (isVirtualBalanceEnabled)
403                 _newConverter.updateConnector(connectorToken, weight, isVirtualBalanceEnabled, virtualBalance);
404         }
405     }
406 
407     /**
408         @dev copies the conversion fee from the old converter to the new one
409 
410         @param _oldConverter    old converter contract address
411         @param _newConverter    new converter contract address
412     */
413     function copyConversionFee(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter) private {
414         uint32 conversionFee = _oldConverter.conversionFee();
415         _newConverter.setConversionFee(conversionFee);
416     }
417 
418     /**
419         @dev transfers the balance of each connector in the old converter to the new one.
420         note that the function assumes that the new converter already has the exact same number of
421         also, this will not work for an unlimited number of connectors due to block gas limit constraints.
422 
423         @param _oldConverter    old converter contract address
424         @param _newConverter    new converter contract address
425         @param _isLegacyVersion true if the converter version is under 0.5
426     */
427     function transferConnectorsBalances(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter, bool _isLegacyVersion)
428         private
429     {
430         uint256 connectorBalance;
431         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
432 
433         for (uint16 i = 0; i < connectorTokenCount; i++) {
434             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
435             IERC20Token connector = IERC20Token(connectorAddress);
436             connectorBalance = connector.balanceOf(_oldConverter);
437             _oldConverter.withdrawTokens(connector, address(_newConverter), connectorBalance);
438         }
439     }
440 
441     /**
442         @dev returns the connector settings
443 
444         @param _converter       old converter contract address
445         @param _address         connector's address to read from
446         @param _isLegacyVersion true if the converter version is under 0.5
447 
448         @return connector's settings
449     */
450     function readConnector(IBancorConverterExtended _converter, address _address, bool _isLegacyVersion) 
451         private
452         view
453         returns(uint256 virtualBalance, uint32 weight, bool isVirtualBalanceEnabled, bool isPurchaseEnabled, bool isSet)
454     {
455         return _isLegacyVersion ? _converter.reserves(_address) : _converter.connectors(_address);
456     }
457 }