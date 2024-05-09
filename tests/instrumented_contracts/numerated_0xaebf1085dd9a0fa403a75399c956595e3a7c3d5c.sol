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
99     function setConversionWhitelist(IWhitelist _whitelist) public;
100     function getQuickBuyPathLength() public view returns (uint256);
101     function transferTokenOwnership(address _newOwner) public;
102     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
103     function acceptTokenOwnership() public;
104     function transferManagement(address _newManager) public;
105     function acceptManagement() public;
106     function setConversionFee(uint32 _conversionFee) public;
107     function setQuickBuyPath(IERC20Token[] _path) public;
108     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance) public;
109     function updateConnector(IERC20Token _connectorToken, uint32 _weight, bool _enableVirtualBalance, uint256 _virtualBalance) public;
110     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
111     function getReserveBalance(IERC20Token _reserveToken) public view returns (uint256);
112     function connectors(address _address) public view returns (
113         uint256 virtualBalance, 
114         uint32 weight, 
115         bool isVirtualBalanceEnabled, 
116         bool isPurchaseEnabled, 
117         bool isSet
118     );
119     function reserves(address _address) public view returns (
120         uint256 virtualBalance, 
121         uint32 weight, 
122         bool isVirtualBalanceEnabled, 
123         bool isPurchaseEnabled, 
124         bool isSet
125     );
126 }
127 
128 /*
129     Provides support and utilities for contract ownership
130 */
131 contract Owned is IOwned {
132     address public owner;
133     address public newOwner;
134 
135     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
136 
137     /**
138         @dev constructor
139     */
140     function Owned() public {
141         owner = msg.sender;
142     }
143 
144     // allows execution by the owner only
145     modifier ownerOnly {
146         assert(msg.sender == owner);
147         _;
148     }
149 
150     /**
151         @dev allows transferring the contract ownership
152         the new owner still needs to accept the transfer
153         can only be called by the contract owner
154 
155         @param _newOwner    new contract owner
156     */
157     function transferOwnership(address _newOwner) public ownerOnly {
158         require(_newOwner != owner);
159         newOwner = _newOwner;
160     }
161 
162     /**
163         @dev used by a new owner to accept an ownership transfer
164     */
165     function acceptOwnership() public {
166         require(msg.sender == newOwner);
167         emit OwnerUpdate(owner, newOwner);
168         owner = newOwner;
169         newOwner = address(0);
170     }
171 }
172 
173 /**
174     Id definitions for bancor contracts
175 
176     Can be used in conjunction with the contract registry to get contract addresses
177 */
178 contract ContractIds {
179     // generic
180     bytes32 public constant CONTRACT_FEATURES = "ContractFeatures";
181 
182     // bancor logic
183     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
184     bytes32 public constant BANCOR_FORMULA = "BancorFormula";
185     bytes32 public constant BANCOR_GAS_PRICE_LIMIT = "BancorGasPriceLimit";
186 
187     bytes32 public constant BANCOR_CONVERTER_FACTORY = "BancorConverterFactory";
188     bytes32 public constant BANCOR_CONVERTER_UPGRADER = "BancorConverterUpgrader";
189 
190     // tokens
191     bytes32 public constant BNT_TOKEN = "BNTToken";
192 }
193 
194 /**
195     Id definitions for bancor contract features
196 
197     Can be used to query the ContractFeatures contract to check whether a certain feature is supported by a contract
198 */
199 contract FeatureIds {
200     // converter features
201     uint256 public constant CONVERTER_CONVERSION_WHITELIST = 1 << 0;
202 }
203 
204 /*
205     Bancor Converter Upgrader
206 
207     The Bancor converter upgrader contract allows upgrading an older Bancor converter
208     contract (0.4 and up) to the latest version.
209     To begin the upgrade process, first transfer the converter ownership to the upgrader
210     contract and then call the upgrade function.
211     At the end of the process, the ownership of the newly upgraded converter will be transferred
212     back to the original owner.
213     The address of the new converter is available in the ConverterUpgrade event.
214 */
215 contract BancorConverterUpgrader is Owned, ContractIds, FeatureIds {
216     string public version = '0.2';
217 
218     IContractRegistry public registry;                      // contract registry contract address
219     IBancorConverterFactory public bancorConverterFactory;  // bancor converter factory contract
220 
221     // triggered when the contract accept a converter ownership
222     event ConverterOwned(address indexed _converter, address indexed _owner);
223     // triggered when the upgrading process is done
224     event ConverterUpgrade(address indexed _oldConverter, address indexed _newConverter);
225 
226     /**
227         @dev constructor
228     */
229     function BancorConverterUpgrader(IBancorConverterFactory _bancorConverterFactory, IContractRegistry _registry) public {
230         bancorConverterFactory = _bancorConverterFactory;
231         registry = _registry;
232     }
233 
234     /*
235         @dev allows the owner to update the factory contract address
236 
237         @param _bancorConverterFactory    address of a bancor converter factory contract
238     */
239     function setBancorConverterFactory(IBancorConverterFactory _bancorConverterFactory) public ownerOnly {
240         bancorConverterFactory = _bancorConverterFactory;
241     }
242 
243     /*
244         @dev allows the owner to update the contract registry contract address
245 
246         @param _registry   address of a contract registry contract
247     */
248     function setContractRegistry(IContractRegistry _registry) public ownerOnly {
249         registry = _registry;
250     }
251 
252     /**
253         @dev upgrade an old converter to the latest version
254         will throw if ownership wasn't transferred to the upgrader before calling this function.
255         ownership of the new converter will be transferred back to the original owner.
256         fires the ConverterUpgrade event upon success.
257 
258         @param _oldConverter   old converter contract address
259         @param _version        old converter version
260     */
261     function upgrade(IBancorConverterExtended _oldConverter, bytes32 _version) public {
262         bool formerVersions = false;
263         if (_version == "0.4")
264             formerVersions = true;
265         acceptConverterOwnership(_oldConverter);
266         IBancorConverterExtended newConverter = createConverter(_oldConverter);
267         copyConnectors(_oldConverter, newConverter, formerVersions);
268         copyConversionFee(_oldConverter, newConverter);
269         copyQuickBuyPath(_oldConverter, newConverter);
270         transferConnectorsBalances(_oldConverter, newConverter, formerVersions);                
271         ISmartToken token = _oldConverter.token();
272 
273         if (token.owner() == address(_oldConverter)) {
274             _oldConverter.transferTokenOwnership(newConverter);
275             newConverter.acceptTokenOwnership();
276         }
277 
278         _oldConverter.transferOwnership(msg.sender);
279         newConverter.transferOwnership(msg.sender);
280         newConverter.transferManagement(msg.sender);
281 
282         emit ConverterUpgrade(address(_oldConverter), address(newConverter));
283     }
284 
285     /**
286         @dev the first step when upgrading a converter is to transfer the ownership to the local contract.
287         the upgrader contract then needs to accept the ownership transfer before initiating
288         the upgrade process.
289         fires the ConverterOwned event upon success
290 
291         @param _oldConverter       converter to accept ownership of
292     */
293     function acceptConverterOwnership(IBancorConverterExtended _oldConverter) private {
294         require(msg.sender == _oldConverter.owner());
295         _oldConverter.acceptOwnership();
296         emit ConverterOwned(_oldConverter, this);
297     }
298 
299     /**
300         @dev creates a new converter with same basic data as the original old converter
301         the newly created converter will have no connectors at this step.
302 
303         @param _oldConverter    old converter contract address
304 
305         @return the new converter  new converter contract address
306     */
307     function createConverter(IBancorConverterExtended _oldConverter) private returns(IBancorConverterExtended) {
308         IWhitelist whitelist;
309         ISmartToken token = _oldConverter.token();
310         uint32 maxConversionFee = _oldConverter.maxConversionFee();
311 
312         address converterAdderess  = bancorConverterFactory.createConverter(
313             token,
314             registry,
315             maxConversionFee,
316             IERC20Token(address(0)),
317             0
318         );
319 
320         IBancorConverterExtended converter = IBancorConverterExtended(converterAdderess);
321         converter.acceptOwnership();
322         converter.acceptManagement();
323 
324         // get the contract features address from the registry
325         IContractFeatures features = IContractFeatures(registry.getAddress(ContractIds.CONTRACT_FEATURES));
326 
327         if (features.isSupported(_oldConverter, FeatureIds.CONVERTER_CONVERSION_WHITELIST)) {
328             whitelist = _oldConverter.conversionWhitelist();
329             if (whitelist != address(0))
330                 converter.setConversionWhitelist(whitelist);
331         }
332 
333         return converter;
334     }
335 
336     /**
337         @dev copies the connectors from the old converter to the new one.
338         note that this will not work for an unlimited number of connectors due to block gas limit constraints.
339 
340         @param _oldConverter    old converter contract address
341         @param _newConverter    new converter contract address
342         @param _isLegacyVersion true if the converter version is under 0.5
343     */
344     function copyConnectors(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter, bool _isLegacyVersion)
345         private
346     {
347         uint256 virtualBalance;
348         uint32 weight;
349         bool isVirtualBalanceEnabled;
350         bool isPurchaseEnabled;
351         bool isSet;
352         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
353 
354         for (uint16 i = 0; i < connectorTokenCount; i++) {
355             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
356             (virtualBalance, weight, isVirtualBalanceEnabled, isPurchaseEnabled, isSet) = readConnector(
357                 _oldConverter,
358                 connectorAddress,
359                 _isLegacyVersion
360             );
361 
362             IERC20Token connectorToken = IERC20Token(connectorAddress);
363             _newConverter.addConnector(connectorToken, weight, isVirtualBalanceEnabled);
364 
365             if (isVirtualBalanceEnabled)
366                 _newConverter.updateConnector(connectorToken, weight, isVirtualBalanceEnabled, virtualBalance);
367         }
368     }
369 
370     /**
371         @dev copies the conversion fee from the old converter to the new one
372 
373         @param _oldConverter    old converter contract address
374         @param _newConverter    new converter contract address
375     */
376     function copyConversionFee(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter) private {
377         uint32 conversionFee = _oldConverter.conversionFee();
378         _newConverter.setConversionFee(conversionFee);
379     }
380 
381     /**
382         @dev copies the quick buy path from the old converter to the new one
383 
384         @param _oldConverter    old converter contract address
385         @param _newConverter    new converter contract address
386     */
387     function copyQuickBuyPath(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter) private {
388         uint256 quickBuyPathLength = _oldConverter.getQuickBuyPathLength();
389         if (quickBuyPathLength <= 0)
390             return;
391 
392         IERC20Token[] memory path = new IERC20Token[](quickBuyPathLength);
393         for (uint256 i = 0; i < quickBuyPathLength; i++) {
394             path[i] = _oldConverter.quickBuyPath(i);
395         }
396 
397         _newConverter.setQuickBuyPath(path);
398     }
399 
400     /**
401         @dev transfers the balance of each connector in the old converter to the new one.
402         note that the function assumes that the new converter already has the exact same number of
403         also, this will not work for an unlimited number of connectors due to block gas limit constraints.
404 
405         @param _oldConverter    old converter contract address
406         @param _newConverter    new converter contract address
407         @param _isLegacyVersion true if the converter version is under 0.5
408     */
409     function transferConnectorsBalances(IBancorConverterExtended _oldConverter, IBancorConverterExtended _newConverter, bool _isLegacyVersion)
410         private
411     {
412         uint256 connectorBalance;
413         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
414 
415         for (uint16 i = 0; i < connectorTokenCount; i++) {
416             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
417             IERC20Token connector = IERC20Token(connectorAddress);
418             connectorBalance = connector.balanceOf(_oldConverter);
419             _oldConverter.withdrawTokens(connector, address(_newConverter), connectorBalance);
420         }
421     }
422 
423     /**
424         @dev returns the connector settings
425 
426         @param _converter       old converter contract address
427         @param _address         connector's address to read from
428         @param _isLegacyVersion true if the converter version is under 0.5
429 
430         @return connector's settings
431     */
432     function readConnector(IBancorConverterExtended _converter, address _address, bool _isLegacyVersion) 
433         private
434         view
435         returns(uint256 virtualBalance, uint32 weight, bool isVirtualBalanceEnabled, bool isPurchaseEnabled, bool isSet)
436     {
437         return _isLegacyVersion ? _converter.reserves(_address) : _converter.connectors(_address);
438     }
439 }