1 pragma solidity ^0.4.18;
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
15     Provides support and utilities for contract ownership
16 */
17 contract Owned is IOwned {
18     address public owner;
19     address public newOwner;
20 
21     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
22 
23     /**
24         @dev constructor
25     */
26     function Owned() public {
27         owner = msg.sender;
28     }
29 
30     // allows execution by the owner only
31     modifier ownerOnly {
32         assert(msg.sender == owner);
33         _;
34     }
35 
36     /**
37         @dev allows transferring the contract ownership
38         the new owner still needs to accept the transfer
39         can only be called by the contract owner
40 
41         @param _newOwner    new contract owner
42     */
43     function transferOwnership(address _newOwner) public ownerOnly {
44         require(_newOwner != owner);
45         newOwner = _newOwner;
46     }
47 
48     /**
49         @dev used by a new owner to accept an ownership transfer
50     */
51     function acceptOwnership() public {
52         require(msg.sender == newOwner);
53         OwnerUpdate(owner, newOwner);
54         owner = newOwner;
55         newOwner = address(0);
56     }
57 }
58 
59 /*
60     ERC20 Standard Token interface
61 */
62 contract IERC20Token {
63     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
64     function name() public view returns (string) {}
65     function symbol() public view returns (string) {}
66     function decimals() public view returns (uint8) {}
67     function totalSupply() public view returns (uint256) {}
68     function balanceOf(address _owner) public view returns (uint256) { _owner; }
69     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
70 
71     function transfer(address _to, uint256 _value) public returns (bool success);
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
73     function approve(address _spender, uint256 _value) public returns (bool success);
74 }
75 
76 /*
77     Smart Token interface
78 */
79 contract ISmartToken is IOwned, IERC20Token {
80     function disableTransfers(bool _disable) public;
81     function issue(address _to, uint256 _amount) public;
82     function destroy(address _from, uint256 _amount) public;
83 }
84 
85 /*
86     Bancor Formula interface
87 */
88 contract IBancorFormula {
89     function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);
90     function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);
91     function calculateCrossConnectorReturn(uint256 _connector1Balance, uint32 _connector1Weight, uint256 _connector2Balance, uint32 _connector2Weight, uint256 _amount) public view returns (uint256);
92 }
93 
94 /*
95     Bancor Gas Price Limit interface
96 */
97 contract IBancorGasPriceLimit {
98     function gasPrice() public view returns (uint256) {}
99     function validateGasPrice(uint256) public view;
100 }
101 
102 /*
103     Bancor Quick Converter interface
104 */
105 contract IBancorQuickConverter {
106     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
107     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
108     function convertForPrioritized(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for, uint256 _block, uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s) public payable returns (uint256);
109 }
110 
111 /*
112     Bancor Converter Extensions interface
113 */
114 contract IBancorConverterExtensions {
115     function formula() public view returns (IBancorFormula) {}
116     function gasPriceLimit() public view returns (IBancorGasPriceLimit) {}
117     function quickConverter() public view returns (IBancorQuickConverter) {}
118 }
119 
120 /*
121     Bancor Converter Factory interface
122 */
123 contract IBancorConverterFactory {
124     function createConverter(ISmartToken _token, IBancorConverterExtensions _extensions, uint32 _maxConversionFee, IERC20Token _connectorToken, uint32 _connectorWeight) public returns (address);
125 }
126 
127 /*
128     Bancor converter dedicated interface
129 */
130 contract IBancorConverter is IOwned {
131     function token() public view returns (ISmartToken) {}
132     function extensions() public view returns (IBancorConverterExtensions) {}
133     function quickBuyPath(uint256 _index) public view returns (IERC20Token) {}
134     function maxConversionFee() public view returns (uint32) {}
135     function conversionFee() public view returns (uint32) {}
136     function connectorTokenCount() public view returns (uint16);
137     function reserveTokenCount() public view returns (uint16);
138     function connectorTokens(uint256 _index) public view returns (IERC20Token) {}
139     function reserveTokens(uint256 _index) public view returns (IERC20Token) {}
140     function setExtensions(IBancorConverterExtensions _extensions) public view;
141     function getQuickBuyPathLength() public view returns (uint256);
142     function transferTokenOwnership(address _newOwner) public view;
143     function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public view;
144     function acceptTokenOwnership() public view;
145     function transferManagement(address _newManager) public view;
146     function acceptManagement() public;
147     function setConversionFee(uint32 _conversionFee) public view;
148     function setQuickBuyPath(IERC20Token[] _path) public view;
149     function addConnector(IERC20Token _token, uint32 _weight, bool _enableVirtualBalance) public view;
150     function getConnectorBalance(IERC20Token _connectorToken) public view returns (uint256);
151     function getReserveBalance(IERC20Token _reserveToken) public view returns (uint256);
152     function connectors(address _address) public view returns (
153         uint256 virtualBalance, 
154         uint32 weight, 
155         bool isVirtualBalanceEnabled, 
156         bool isPurchaseEnabled, 
157         bool isSet
158     );
159     function reserves(address _address) public view returns (
160         uint256 virtualBalance, 
161         uint32 weight, 
162         bool isVirtualBalanceEnabled, 
163         bool isPurchaseEnabled, 
164         bool isSet
165     );
166 }
167 
168 /*
169     Bancor Converter Upgrader
170 
171     The Bancor converter upgrader contract allows upgrading an older Bancor converter
172     contract (0.4 and up) to the latest version.
173     To begin the upgrade process, first transfer the converter ownership to the upgrader
174     contract and then call the upgrade function.
175     At the end of the process, the ownership of the newly upgraded converter will be transferred
176     back to the original owner.
177     The address of the new converter is available in the ConverterUpgrade event.
178 */
179 contract BancorConverterUpgrader is Owned {
180     IBancorConverterFactory public bancorConverterFactory;  // bancor converter factory contract
181 
182     // triggered when the contract accept a converter ownership
183     event ConverterOwned(address indexed _converter, address indexed _owner);
184     // triggered when the upgrading process is done
185     event ConverterUpgrade(address indexed _oldConverter, address indexed _newConverter);
186 
187     /**
188         @dev constructor
189     */
190     function BancorConverterUpgrader(IBancorConverterFactory _bancorConverterFactory)
191         public
192     {
193         bancorConverterFactory = _bancorConverterFactory;
194     }
195 
196     /*
197         @dev allows the owner to update the factory contract address
198 
199         @param _bancorConverterFactory    address of a bancor converter factory contract
200     */
201     function setBancorConverterFactory(IBancorConverterFactory _bancorConverterFactory) public ownerOnly
202     {
203         bancorConverterFactory = _bancorConverterFactory;
204     }
205 
206     /**
207         @dev upgrade an old converter to the latest version
208         will throw if ownership wasn't transferred to the upgrader before calling this function.
209         ownership of the new converter will be transferred back to the original owner.
210         fires the ConverterUpgrade event upon success.
211 
212         @param _oldConverter   old converter contract address
213         @param _version        old converter version
214     */
215     function upgrade(IBancorConverter _oldConverter, bytes32 _version) public {
216         bool formerVersions = false;
217         if (_version == "0.4")
218             formerVersions = true;
219         acceptConverterOwnership(_oldConverter);
220         IBancorConverter toConverter = createConverter(_oldConverter);
221         copyConnectors(_oldConverter, toConverter, formerVersions);
222         copyConversionFee(_oldConverter, toConverter);
223         copyQuickBuyPath(_oldConverter, toConverter);
224         transferConnectorsBalances(_oldConverter, toConverter, formerVersions);
225         _oldConverter.transferTokenOwnership(toConverter);
226         toConverter.acceptTokenOwnership();
227         _oldConverter.transferOwnership(msg.sender);
228         toConverter.transferOwnership(msg.sender);
229         toConverter.transferManagement(msg.sender);
230 
231         ConverterUpgrade(address(_oldConverter), address(toConverter));
232     }
233 
234     /**
235         @dev the first step when upgrading a converter is to transfer the ownership to the local contract.
236         the upgrader contract then needs to accept the ownership transfer before initiating
237         the upgrade process.
238         fires the ConverterOwned event upon success
239 
240         @param _oldConverter       converter to accept ownership of
241     */
242     function acceptConverterOwnership(IBancorConverter _oldConverter) private {
243         require(msg.sender == _oldConverter.owner());
244         _oldConverter.acceptOwnership();
245         ConverterOwned(_oldConverter, this);
246     }
247 
248     /**
249         @dev creates a new converter with same basic data as the original old converter
250         the newly created converter will have no connectors at this step.
251 
252         @param _oldConverter       old converter contract address
253 
254         @return the new converter  new converter contract address
255     */
256     function createConverter(IBancorConverter _oldConverter) private returns(IBancorConverter) {
257         ISmartToken token = _oldConverter.token();
258         IBancorConverterExtensions extensions = _oldConverter.extensions();
259         uint32 maxConversionFee = _oldConverter.maxConversionFee();
260 
261         address converterAdderess  = bancorConverterFactory.createConverter(
262             token,
263             extensions,
264             maxConversionFee,
265             IERC20Token(address(0)),
266             0
267         );
268 
269         IBancorConverter converter = IBancorConverter(converterAdderess);
270         converter.acceptOwnership();
271         converter.acceptManagement();
272 
273         return converter;
274     }
275 
276     /**
277         @dev copies the connectors from the old converter to the new one.
278         note that this will not work for an unlimited number of connectors due to block gas limit constraints.
279 
280         @param _oldConverter    old converter contract address
281         @param _newConverter    new converter contract address
282         @param _isLegacyVersion true if the converter version is under 0.5
283     */
284     function copyConnectors(IBancorConverter _oldConverter, IBancorConverter _newConverter, bool _isLegacyVersion)
285         private
286     {
287         uint256 virtualBalance;
288         uint32 weight;
289         bool isVirtualBalanceEnabled;
290         bool isPurchaseEnabled;
291         bool isSet;
292         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
293 
294         for (uint16 i = 0; i < connectorTokenCount; i++) {
295             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
296             (virtualBalance, weight, isVirtualBalanceEnabled, isPurchaseEnabled, isSet) = readConnector(
297                 _oldConverter,
298                 connectorAddress,
299                 _isLegacyVersion
300             );
301 
302             IERC20Token connectorToken = IERC20Token(connectorAddress);
303             _newConverter.addConnector(connectorToken, weight, isVirtualBalanceEnabled);
304         }
305     }
306 
307     /**
308         @dev copies the conversion fee from the old converter to the new one
309 
310         @param _oldConverter    old converter contract address
311         @param _newConverter    new converter contract address
312     */
313     function copyConversionFee(IBancorConverter _oldConverter, IBancorConverter _newConverter) private {
314         uint32 conversionFee = _oldConverter.conversionFee();
315         _newConverter.setConversionFee(conversionFee);
316     }
317 
318     /**
319         @dev copies the quick buy path from the old converter to the new one
320 
321         @param _oldConverter    old converter contract address
322         @param _newConverter    new converter contract address
323     */
324     function copyQuickBuyPath(IBancorConverter _oldConverter, IBancorConverter _newConverter) private {
325         uint256 quickBuyPathLength = _oldConverter.getQuickBuyPathLength();
326         if (quickBuyPathLength <= 0)
327             return;
328 
329         IERC20Token[] memory path = new IERC20Token[](quickBuyPathLength);
330         for (uint256 i = 0; i < quickBuyPathLength; i++) {
331             path[i] = _oldConverter.quickBuyPath(i);
332         }
333 
334         _newConverter.setQuickBuyPath(path);
335     }
336 
337     /**
338         @dev transfers the balance of each connector in the old converter to the new one.
339         note that the function assumes that the new converter already has the exact same number of
340         also, this will not work for an unlimited number of connectors due to block gas limit constraints.
341 
342         @param _oldConverter    old converter contract address
343         @param _newConverter    new converter contract address
344         @param _isLegacyVersion true if the converter version is under 0.5
345     */
346     function transferConnectorsBalances(IBancorConverter _oldConverter, IBancorConverter _newConverter, bool _isLegacyVersion)
347         private
348     {
349         uint256 connectorBalance;
350         uint16 connectorTokenCount = _isLegacyVersion ? _oldConverter.reserveTokenCount() : _oldConverter.connectorTokenCount();
351 
352         for (uint16 i = 0; i < connectorTokenCount; i++) {
353             address connectorAddress = _isLegacyVersion ? _oldConverter.reserveTokens(i) : _oldConverter.connectorTokens(i);
354             IERC20Token connector = IERC20Token(connectorAddress);
355             connectorBalance = _isLegacyVersion ? _oldConverter.getReserveBalance(connector) : _oldConverter.getConnectorBalance(connector);
356             _oldConverter.withdrawTokens(connector, address(_newConverter), connectorBalance);
357         }
358     }
359 
360     /**
361         @dev returns the connector settings
362 
363         @param _converter       old converter contract address
364         @param _address         connector's address to read from
365         @param _isLegacyVersion true if the converter version is under 0.5
366 
367         @return connector's settings
368     */
369     function readConnector(IBancorConverter _converter, address _address, bool _isLegacyVersion) 
370         private
371         view
372         returns(uint256 virtualBalance, uint32 weight, bool isVirtualBalanceEnabled, bool isPurchaseEnabled, bool isSet)
373     {
374         return _isLegacyVersion ? _converter.reserves(_address) : _converter.connectors(_address);
375     }
376 }