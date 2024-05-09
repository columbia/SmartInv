1 pragma solidity ^0.4.21;
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
15     ERC20 Standard Token interface
16 */
17 contract IERC20Token {
18     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
19     function name() public view returns (string) {}
20     function symbol() public view returns (string) {}
21     function decimals() public view returns (uint8) {}
22     function totalSupply() public view returns (uint256) {}
23     function balanceOf(address _owner) public view returns (uint256) { _owner; }
24     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
25 
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29 }
30 
31 /*
32     Smart Token interface
33 */
34 contract ISmartToken is IOwned, IERC20Token {
35     function disableTransfers(bool _disable) public;
36     function issue(address _to, uint256 _amount) public;
37     function destroy(address _from, uint256 _amount) public;
38 }
39 
40 /*
41     Contract Registry interface
42 */
43 contract IContractRegistry {
44     function getAddress(bytes32 _contractName) public view returns (address);
45 }
46 
47 /*
48     Contract Features interface
49 */
50 contract IContractFeatures {
51     function isSupported(address _contract, uint256 _features) public view returns (bool);
52     function enableFeatures(uint256 _features, bool _enable) public;
53 }
54 
55 /*
56     Whitelist interface
57 */
58 contract IWhitelist {
59     function isWhitelisted(address _address) public view returns (bool);
60 }
61 
62 /*
63     Bancor Converter interface
64 */
65 contract IBancorConverter {
66     function getReturn(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount) public view returns (uint256);
67     function convert(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
68     function conversionWhitelist() public view returns (IWhitelist) {}
69     // deprecated, backward compatibility
70     function change(IERC20Token _fromToken, IERC20Token _toToken, uint256 _amount, uint256 _minReturn) public returns (uint256);
71 }
72 
73 /*
74     Bancor Converter Factory interface
75 */
76 contract IBancorConverterFactory {
77     function createConverter(
78         ISmartToken _token,
79         IContractRegistry _registry,
80         uint32 _maxConversionFee,
81         IERC20Token _connectorToken,
82         uint32 _connectorWeight
83     )
84     public returns (address);
85 }
86 
87 /*
88     Bancor converter dedicated interface
89 */
90 contract IBancorConverterExtended is IBancorConverter, IOwned {
91     function token() public view returns (ISmartToken) {}
92     function quickBuyPath(uint256 _index) public view returns (IERC20Token) { _index; }
93     function maxConversionFee() public view returns (uint32) {}
94     function conversionFee() public view returns (uint32) {}
95     function connectorTokenCount() public view returns (uint16);
96     function reserveTokenCount() public view returns (uint16);
97     function connectorTokens(uint256 _index) public view returns (IERC20Token) { _index; }
98     function reserveTokens(uint256 _index) public view returns (IERC20Token) { _index; }
99     function setConversionWhitelist(IWhitelist _whitelist) public view;
100     function getQuickBuyPathLength() public view returns (uint256);
101     function transferTokenOwnership(address _newOwner) public view;
102     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public view;
103     function acceptTokenOwnership() public view;
104     function transferManagement(address _newManager) public view;
105     function acceptManagement() public;
106     function setConversionFee(uint32 _conversionFee) public view;
107     function setQuickBuyPath(IERC20Token[] _path) public view;
108     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance) public view;
109     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
110     function getReserveBalance(IERC20Token _reserveToken) public view returns (uint256);
111     function connectors(address _address) public view returns (
112         uint256 virtualBalance, 
113         uint32 weight, 
114         bool isVirtualBalanceEnabled, 
115         bool isPurchaseEnabled, 
116         bool isSet
117     );
118     function reserves(address _address) public view returns (
119         uint256 virtualBalance, 
120         uint32 weight, 
121         bool isVirtualBalanceEnabled, 
122         bool isPurchaseEnabled, 
123         bool isSet
124     );
125 }
126 
127 /*
128     Provides support and utilities for contract ownership
129 */
130 contract Owned is IOwned {
131     address public owner;
132     address public newOwner;
133 
134     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
135 
136     /**
137         @dev constructor
138     */
139     function Owned() public {
140         owner = msg.sender;
141     }
142 
143     // allows execution by the owner only
144     modifier ownerOnly {
145         assert(msg.sender == owner);
146         _;
147     }
148 
149     /**
150         @dev allows transferring the contract ownership
151         the new owner still needs to accept the transfer
152         can only be called by the contract owner
153 
154         @param _newOwner    new contract owner
155     */
156     function transferOwnership(address _newOwner) public ownerOnly {
157         require(_newOwner != owner);
158         newOwner = _newOwner;
159     }
160 
161     /**
162         @dev used by a new owner to accept an ownership transfer
163     */
164     function acceptOwnership() public {
165         require(msg.sender == newOwner);
166         emit OwnerUpdate(owner, newOwner);
167         owner = newOwner;
168         newOwner = address(0);
169     }
170 }
171 
172 /**
173     Id definitions for bancor contracts
174 
175     Can be used in conjunction with the contract registry to get contract addresses
176 */
177 contract ContractIds {
178     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
179     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
180     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
181 }
182 
183 /**
184     Id definitions for bancor contract features
185 
186     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
187 */
188 contract FeatureIds {
189     // converter features
190     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
191 }
192 
193 /*
194     Bancor Converter Upgrader
195 
196     The Bancor converter upgrader contract allows upgrading an older Bancor converter
197     contract (0.4 and up) to the latest version.
198     To begin the upgrade process, first transfer the converter ownership to the upgrader
199     contract and then call the upgrade function.
200     At the end of the process, the ownership of the newly upgraded converter will be transferred
201     back to the original owner.
202     The address of the new converter is available in the ConverterUpgrade event.
203 */
204 contract BancorConverterUpgrader is Owned, ContractIds, FeatureIds {
205     string public version = '0.2';
206 
207     IContractRegistry public registry;                      // contract registry contract address
208     IBancorConverterFactory public bancorConverterFactory;  // bancor converter factory contract
209 
210     // triggered when the contract accept a converter ownership
211     event ConverterOwned(address indexed _converter, address indexed _owner);
212     // triggered when the upgrading process is done
213     event ConverterUpgrade(address indexed _oldConverter, address indexed _newConverter);
214 
215     /**
216         @dev constructor
217     */
218     function BancorConverterUpgrader(IBancorConverterFactory _bancorConverterFactory, IContractRegistry _registry) public {
219         bancorConverterFactory = _bancorConverterFactory;
220         registry = _registry;
221     }
222 
223     /*
224         @dev allows the owner to update the factory contract address
225 
226         @param _bancorConverterFactory    address of a bancor converter factory contract
227     */
228     function setBancorConverterFactory(IBancorConverterFactory _bancorConverterFactory) public ownerOnly {
229         bancorConverterFactory = _bancorConverterFactory;
230     }
231 
232     /*
233         @dev allows the owner to update the contract registry contract address
234 
235         @param _registry   address of a contract registry contract
236     */
237     function setContractRegistry(IContractRegistry _registry) public ownerOnly {
238         registry = _registry;
239     }
240 
241     /**
242         @dev upgrade an old converter to the latest version
243         will throw if ownership wasn't transferred to the upgrader before calling this function.
244         ownership of the new converter will be transferred back to the original owner.
245         fires the ConverterUpgrade event upon success.
246 
247         @param _oldConverter   old converter contract address
248         @param _version        old converter version
249     */
250     function upgrade(IBancorConverterExtended _oldConverter, bytes32 _version) public {
251         bool formerVersions = false;
252         if (_version == "0.4")
253             formerVersions = true;
254         acceptConverterOwnership(_oldConverter);
255         IBancorConverterExtended newConverter = createConverter(_oldConverter);
256         copyConnectors(_oldConverter, newConverter, formerVersions);
257         copyConversionFee(_oldConverter, newConverter);
258         copyQuickBuyPath(_oldConverter, newConverter);
259         transferConnectorsBalances(_oldConverter, newConverter, formerVersions);                
260         ISmartToken token = _oldConverter.token();
261 
262         if (token.owner() == address(_oldConverter)) {
263             _oldConverter.transferTokenOwnership(newConverter);
264             newConverter.acceptTokenOwnership();
265         }
266 
267         _oldConverter.transferOwnership(msg.sender);
268         newConverter.transferOwnership(msg.sender);
269         newConverter.transferManagement(msg.sender);
270 
271         emit ConverterUpgrade(address(_oldConverter), address(newConverter));
272     }
273 
274     /**
275         @dev the first step when upgrading a converter is to transfer the ownership to the local contract.
276         the upgrader contract then needs to accept the ownership transfer before initiating
277         the upgrade process.
278         fires the ConverterOwned event upon success
279 
280         @param _oldConverter       converter to accept ownership of
281     */
282     function acceptConverterOwnership(IBancorConverterExtended _oldConverter) private {
283         require(msg.sender == _oldConverter.owner());
284         _oldConverter.acceptOwnership();
285         emit ConverterOwned(_oldConverter, this);
286     }
287 
288     /**
289         @dev creates a new converter with same basic data as the original old converter
290         the newly created converter will have no connectors at this step.
291 
292         @param _oldConverter    old converter contract address
293 
294         @return the new converter  new converter contract address
295     */
296     function createConverter(IBancorConverterExtended _oldConverter) private returns(IBancorConverterExtended) {
297         IWhitelist whitelist;
298         ISmartToken token = _oldConverter.token();
299         uint32 maxConversionFee = _oldConverter.maxConversionFee();
300 
301         address converterAdderess  = bancorConverterFactory.createConverter(
302             token,
303             registry,
304             maxConversionFee,
305             IERC20Token(address(0)),
306             0
307         );
308 
309         IBancorConverterExtended converter = IBancorConverterExtended(converterAdderess);
310         converter.acceptOwnership();
311         converter.acceptManagement();
312 
313         // get the contract features address from the registry
314         IContractFeatures features = IContractFeatures(registry.getAddress(ContractIds.CONTRACT_FEATURES));
315 
316         if (features.isSupported(_oldConverter, FeatureIds.CONVERTER_CONVERSION_WHITELIST)) {
317             whitelist = _oldConverter.conversionWhitelist();
318             if (whitelist != address(0))
319                 converter.setConversionWhitelist(whitelist);
320         }
321 
322         return converter;
323     }
324 
325     /**
326         @dev copies the connectors from the old converter to the new one.
327         note that this will not work for an unlimited number of connectors due to block gas limit constraints.
328 
329         @param _oldConverter    old converter contract address
330         @param _newConverter    new converter contract address
331         @param _isLegacyVersion true if the converter version is under 0.5
332     */
333     function copyConnectors(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter, bool _isLegacyVersion)
334         private
335     {
336         uint256 virtualBalance;
337         uint32 weight;
338         bool isVirtualBalanceEnabled;
339         bool isPurchaseEnabled;
340         bool isSet;
341         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
342 
343         for (uint16 i = 0; i < connectorTokenCount; i++) {
344             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
345             (virtualBalance, weight, isVirtualBalanceEnabled, isPurchaseEnabled, isSet) = readConnector(
346                 _oldConverter,
347                 connectorAddress,
348                 _isLegacyVersion
349             );
350 
351             IERC20Token connectorToken = IERC20Token(connectorAddress);
352             _newConverter.addConnector(connectorToken, weight, isVirtualBalanceEnabled);
353         }
354     }
355 
356     /**
357         @dev copies the conversion fee from the old converter to the new one
358 
359         @param _oldConverter    old converter contract address
360         @param _newConverter    new converter contract address
361     */
362     function copyConversionFee(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter) private {
363         uint32 conversionFee = _oldConverter.conversionFee();
364         _newConverter.setConversionFee(conversionFee);
365     }
366 
367     /**
368         @dev copies the quick buy path from the old converter to the new one
369 
370         @param _oldConverter    old converter contract address
371         @param _newConverter    new converter contract address
372     */
373     function copyQuickBuyPath(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter) private {
374         uint256 quickBuyPathLength = _oldConverter.getQuickBuyPathLength();
375         if (quickBuyPathLength <= 0)
376             return;
377 
378         IERC20Token[] memory path = new IERC20Token[](quickBuyPathLength);
379         for (uint256 i = 0; i < quickBuyPathLength; i++) {
380             path[i] = _oldConverter.quickBuyPath(i);
381         }
382 
383         _newConverter.setQuickBuyPath(path);
384     }
385 
386     /**
387         @dev transfers the balance of each connector in the old converter to the new one.
388         note that the function assumes that the new converter already has the exact same number of
389         also, this will not work for an unlimited number of connectors due to block gas limit constraints.
390 
391         @param _oldConverter    old converter contract address
392         @param _newConverter    new converter contract address
393         @param _isLegacyVersion true if the converter version is under 0.5
394     */
395     function transferConnectorsBalances(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter, bool _isLegacyVersion)
396         private
397     {
398         uint256 connectorBalance;
399         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
400 
401         for (uint16 i = 0; i < connectorTokenCount; i++) {
402             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
403             IERC20Token connector = IERC20Token(connectorAddress);
404             connectorBalance = _isLegacyVersion ? _oldConverter.getReserveBalance(connector) : _oldConverter.getConnectorBalance(connector);
405             _oldConverter.withdrawTokens(connector, address(_newConverter), connectorBalance);
406         }
407     }
408 
409     /**
410         @dev returns the connector settings
411 
412         @param _converter       old converter contract address
413         @param _address         connector's address to read from
414         @param _isLegacyVersion true if the converter version is under 0.5
415 
416         @return connector's settings
417     */
418     function readConnector(IBancorConverterExtended _converter, address _address, bool _isLegacyVersion) 
419         private
420         view
421         returns(uint256 virtualBalance, uint32 weight, bool isVirtualBalanceEnabled, bool isPurchaseEnabled, bool isSet)
422     {
423         return _isLegacyVersion ? _converter.reserves(_address) : _converter.connectors(_address);
424     }
425 }