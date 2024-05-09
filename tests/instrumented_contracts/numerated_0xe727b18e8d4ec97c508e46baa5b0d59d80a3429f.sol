1 pragma solidity ^0.4.23;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7     // this function isn't abstract since the compiler emits automatically generated getter functions as external
8     function owner() public view returns (address) {}
9 
10     function transferOwnership(address _newOwner) public;
11     function acceptOwnership() public;
12 }
13 
14 /*
15     Whitelist interface
16 */
17 contract IWhitelist {
18     function isWhitelisted(address _address) public view returns (bool);
19 }
20 
21 /*
22     Contract Registry interface
23 */
24 contract IContractRegistry {
25     function addressOf(bytes32 _contractName) public view returns (address);
26 
27     // deprecated, backward compatibility
28     function getAddress(bytes32 _contractName) public view returns (address);
29 }
30 
31 /*
32     Contract Features interface
33 */
34 contract IContractFeatures {
35     function isSupported(address _contract, uint256 _features) public view returns (bool);
36     function enableFeatures(uint256 _features, bool _enable) public;
37 }
38 
39 /*
40     ERC20 Standard Token interface
41 */
42 contract IERC20Token {
43     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
44     function name() public view returns (string) {}
45     function symbol() public view returns (string) {}
46     function decimals() public view returns (uint8) {}
47     function totalSupply() public view returns (uint256) {}
48     function balanceOf(address _owner) public view returns (uint256) { _owner; }
49     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
50 
51     function transfer(address _to, uint256 _value) public returns (bool success);
52     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
53     function approve(address _spender, uint256 _value) public returns (bool success);
54 }
55 
56 /*
57     Smart Token interface
58 */
59 contract ISmartToken is IOwned, IERC20Token {
60     function disableTransfers(bool _disable) public;
61     function issue(address _to, uint256 _amount) public;
62     function destroy(address _from, uint256 _amount) public;
63 }
64 
65 /*
66     Bancor Converter interface
67 */
68 contract IBancorConverter {
69     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
70     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
71     function conversionWhitelist() public view returns (IWhitelist) {}
72     // deprecated, backward compatibility
73     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
74 }
75 
76 /*
77     Bancor converter dedicated interface
78 */
79 contract IBancorConverterExtended is IBancorConverter, IOwned {
80     function token() public view returns (ISmartToken) {}
81     function quickBuyPath(uint256 _index) public view returns (IERC20Token) { _index; }
82     function maxConversionFee() public view returns (uint32) {}
83     function conversionFee() public view returns (uint32) {}
84     function connectorTokenCount() public view returns (uint16);
85     function reserveTokenCount() public view returns (uint16);
86     function connectorTokens(uint256 _index) public view returns (IERC20Token) { _index; }
87     function reserveTokens(uint256 _index) public view returns (IERC20Token) { _index; }
88     function setConversionWhitelist(IWhitelist _whitelist) public;
89     function getQuickBuyPathLength() public view returns (uint256);
90     function transferTokenOwnership(address _newOwner) public;
91     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
92     function acceptTokenOwnership() public;
93     function transferManagement(address _newManager) public;
94     function acceptManagement() public;
95     function setConversionFee(uint32 _conversionFee) public;
96     function setQuickBuyPath(IERC20Token[] _path) public;
97     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance) public;
98     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance) public;
99     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
100     function getReserveBalance(IERC20Token _reserveToken) public view returns (uint256);
101     function connectors(address _address) public view returns (
102         uint256 virtualBalance, 
103         uint32 weight, 
104         bool isVirtualBalanceEnabled, 
105         bool isPurchaseEnabled, 
106         bool isSet
107     );
108     function reserves(address _address) public view returns (
109         uint256 virtualBalance, 
110         uint32 weight, 
111         bool isVirtualBalanceEnabled, 
112         bool isPurchaseEnabled, 
113         bool isSet
114     );
115 }
116 
117 /*
118     Bancor Converter Factory interface
119 */
120 contract IBancorConverterFactory {
121     function createConverter(
122         ISmartToken _token,
123         IContractRegistry _registry,
124         uint32 _maxConversionFee,
125         IERC20Token _connectorToken,
126         uint32 _connectorWeight
127     )
128     public returns (address);
129 }
130 
131 /*
132     Provides support and utilities for contract ownership
133 */
134 contract Owned is IOwned {
135     address public owner;
136     address public newOwner;
137 
138     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
139 
140     /**
141         @dev constructor
142     */
143     constructor() public {
144         owner = msg.sender;
145     }
146 
147     // allows execution by the owner only
148     modifier ownerOnly {
149         assert(msg.sender == owner);
150         _;
151     }
152 
153     /**
154         @dev allows transferring the contract ownership
155         the new owner still needs to accept the transfer
156         can only be called by the contract owner
157 
158         @param _newOwner    new contract owner
159     */
160     function transferOwnership(address _newOwner) public ownerOnly {
161         require(_newOwner != owner);
162         newOwner = _newOwner;
163     }
164 
165     /**
166         @dev used by a new owner to accept an ownership transfer
167     */
168     function acceptOwnership() public {
169         require(msg.sender == newOwner);
170         emit OwnerUpdate(owner, newOwner);
171         owner = newOwner;
172         newOwner = address(0);
173     }
174 }
175 
176 /**
177     Id definitions for bancor contracts
178 
179     Can be used in conjunction with the contract registry to get contract addresses
180 */
181 contract ContractIds {
182     // generic
183     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
184 
185     // bancor logic
186     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
187     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
188     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
189     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
190 }
191 
192 /**
193     Id definitions for bancor contract features
194 
195     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
196 */
197 contract FeatureIds {
198     // converter features
199     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
200 }
201 
202 /*
203     Bancor Converter Upgrader
204 
205     The Bancor converter upgrader contract allows upgrading an older Bancor converter
206     contract (0.4 and up) to the latest version.
207     To begin the upgrade process, first transfer the converter ownership to the upgrader
208     contract and then call the upgrade function.
209     At the end of the process, the ownership of the newly upgraded converter will be transferred
210     back to the original owner.
211     The address of the new converter is available in the ConverterUpgrade event.
212 */
213 contract BancorConverterUpgrader is Owned, ContractIds, FeatureIds {
214     string public version = '0.3';
215 
216     IContractRegistry public registry;                      // contract registry contract address
217 
218     // triggered when the contract accept a converter ownership
219     event ConverterOwned(address indexed _converter, address indexed _owner);
220     // triggered when the upgrading process is done
221     event ConverterUpgrade(address indexed _oldConverter, address indexed _newConverter);
222 
223     /**
224         @dev constructor
225     */
226     constructor(IContractRegistry _registry) public {
227         registry = _registry;
228     }
229 
230     /*
231         @dev allows the owner to update the contract registry contract address
232 
233         @param _registry   address of a contract registry contract
234     */
235     function setRegistry(IContractRegistry _registry) public ownerOnly {
236         registry = _registry;
237     }
238 
239     /**
240         @dev upgrade an old converter to the latest version
241         will throw if ownership wasn't transferred to the upgrader before calling this function.
242         ownership of the new converter will be transferred back to the original owner.
243         fires the ConverterUpgrade event upon success.
244 
245         @param _oldConverter   old converter contract address
246         @param _version        old converter version
247     */
248     function upgrade(IBancorConverterExtended _oldConverter, bytes32 _version) public {
249         bool formerVersions = false;
250         if (_version == "0.4")
251             formerVersions = true;
252         acceptConverterOwnership(_oldConverter);
253         IBancorConverterExtended newConverter = createConverter(_oldConverter);
254         copyConnectors(_oldConverter, newConverter, formerVersions);
255         copyConversionFee(_oldConverter, newConverter);
256         copyQuickBuyPath(_oldConverter, newConverter);
257         transferConnectorsBalances(_oldConverter, newConverter, formerVersions);                
258         ISmartToken token = _oldConverter.token();
259 
260         if (token.owner() == address(_oldConverter)) {
261             _oldConverter.transferTokenOwnership(newConverter);
262             newConverter.acceptTokenOwnership();
263         }
264 
265         _oldConverter.transferOwnership(msg.sender);
266         newConverter.transferOwnership(msg.sender);
267         newConverter.transferManagement(msg.sender);
268 
269         emit ConverterUpgrade(address(_oldConverter), address(newConverter));
270     }
271 
272     /**
273         @dev the first step when upgrading a converter is to transfer the ownership to the local contract.
274         the upgrader contract then needs to accept the ownership transfer before initiating
275         the upgrade process.
276         fires the ConverterOwned event upon success
277 
278         @param _oldConverter       converter to accept ownership of
279     */
280     function acceptConverterOwnership(IBancorConverterExtended _oldConverter) private {
281         require(msg.sender == _oldConverter.owner());
282         _oldConverter.acceptOwnership();
283         emit ConverterOwned(_oldConverter, this);
284     }
285 
286     /**
287         @dev creates a new converter with same basic data as the original old converter
288         the newly created converter will have no connectors at this step.
289 
290         @param _oldConverter    old converter contract address
291 
292         @return the new converter  new converter contract address
293     */
294     function createConverter(IBancorConverterExtended _oldConverter) private returns(IBancorConverterExtended) {
295         IWhitelist whitelist;
296         ISmartToken token = _oldConverter.token();
297         uint32 maxConversionFee = _oldConverter.maxConversionFee();
298 
299         IBancorConverterFactory converterFactory = IBancorConverterFactory(registry.addressOf(ContractIds.BANCOR_CONVERTER_FACTORY));
300         address converterAdderess  = converterFactory.createConverter(
301             token,
302             registry,
303             maxConversionFee,
304             IERC20Token(address(0)),
305             0
306         );
307 
308         IBancorConverterExtended converter = IBancorConverterExtended(converterAdderess);
309         converter.acceptOwnership();
310         converter.acceptManagement();
311 
312         // get the contract features address from the registry
313         IContractFeatures features = IContractFeatures(registry.addressOf(ContractIds.CONTRACT_FEATURES));
314 
315         if (features.isSupported(_oldConverter, FeatureIds.CONVERTER_CONVERSION_WHITELIST)) {
316             whitelist = _oldConverter.conversionWhitelist();
317             if (whitelist != address(0))
318                 converter.setConversionWhitelist(whitelist);
319         }
320 
321         return converter;
322     }
323 
324     /**
325         @dev copies the connectors from the old converter to the new one.
326         note that this will not work for an unlimited number of connectors due to block gas limit constraints.
327 
328         @param _oldConverter    old converter contract address
329         @param _newConverter    new converter contract address
330         @param _isLegacyVersion true if the converter version is under 0.5
331     */
332     function copyConnectors(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter, bool _isLegacyVersion)
333         private
334     {
335         uint256 virtualBalance;
336         uint32 weight;
337         bool isVirtualBalanceEnabled;
338         bool isPurchaseEnabled;
339         bool isSet;
340         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
341 
342         for (uint16 i = 0; i < connectorTokenCount; i++) {
343             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
344             (virtualBalance, weight, isVirtualBalanceEnabled, isPurchaseEnabled, isSet) = readConnector(
345                 _oldConverter,
346                 connectorAddress,
347                 _isLegacyVersion
348             );
349 
350             IERC20Token connectorToken = IERC20Token(connectorAddress);
351             _newConverter.addConnector(connectorToken, weight, isVirtualBalanceEnabled);
352 
353             if (isVirtualBalanceEnabled)
354                 _newConverter.updateConnector(connectorToken, weight, isVirtualBalanceEnabled, virtualBalance);
355         }
356     }
357 
358     /**
359         @dev copies the conversion fee from the old converter to the new one
360 
361         @param _oldConverter    old converter contract address
362         @param _newConverter    new converter contract address
363     */
364     function copyConversionFee(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter) private {
365         uint32 conversionFee = _oldConverter.conversionFee();
366         _newConverter.setConversionFee(conversionFee);
367     }
368 
369     /**
370         @dev copies the quick buy path from the old converter to the new one
371 
372         @param _oldConverter    old converter contract address
373         @param _newConverter    new converter contract address
374     */
375     function copyQuickBuyPath(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter) private {
376         uint256 quickBuyPathLength = _oldConverter.getQuickBuyPathLength();
377         if (quickBuyPathLength <= 0)
378             return;
379 
380         IERC20Token[] memory path = new IERC20Token[](quickBuyPathLength);
381         for (uint256 i = 0; i < quickBuyPathLength; i++) {
382             path[i] = _oldConverter.quickBuyPath(i);
383         }
384 
385         _newConverter.setQuickBuyPath(path);
386     }
387 
388     /**
389         @dev transfers the balance of each connector in the old converter to the new one.
390         note that the function assumes that the new converter already has the exact same number of
391         also, this will not work for an unlimited number of connectors due to block gas limit constraints.
392 
393         @param _oldConverter    old converter contract address
394         @param _newConverter    new converter contract address
395         @param _isLegacyVersion true if the converter version is under 0.5
396     */
397     function transferConnectorsBalances(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter, bool _isLegacyVersion)
398         private
399     {
400         uint256 connectorBalance;
401         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
402 
403         for (uint16 i = 0; i < connectorTokenCount; i++) {
404             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
405             IERC20Token connector = IERC20Token(connectorAddress);
406             connectorBalance = connector.balanceOf(_oldConverter);
407             _oldConverter.withdrawTokens(connector, address(_newConverter), connectorBalance);
408         }
409     }
410 
411     /**
412         @dev returns the connector settings
413 
414         @param _converter       old converter contract address
415         @param _address         connector's address to read from
416         @param _isLegacyVersion true if the converter version is under 0.5
417 
418         @return connector's settings
419     */
420     function readConnector(IBancorConverterExtended _converter, address _address, bool _isLegacyVersion) 
421         private
422         view
423         returns(uint256 virtualBalance, uint32 weight, bool isVirtualBalanceEnabled, bool isPurchaseEnabled, bool isSet)
424     {
425         return _isLegacyVersion ? _converter.reserves(_address) : _converter.connectors(_address);
426     }
427 }