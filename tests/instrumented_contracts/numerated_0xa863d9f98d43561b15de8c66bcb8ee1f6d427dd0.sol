1 pragma solidity ^0.4.24;
2 
3 // File: contracts/lib/ownership/Ownable.sol
4 
5 contract Ownable {
6     address public owner;
7     event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
8 
9     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
10     constructor() public { owner = msg.sender; }
11 
12     /// @dev Throws if called by any contract other than latest designated caller
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /// @dev Allows the current owner to transfer control of the contract to a newOwner.
19     /// @param newOwner The address to transfer ownership to.
20     function transferOwnership(address newOwner) public onlyOwner {
21        require(newOwner != address(0));
22        emit OwnershipTransferred(owner, newOwner);
23        owner = newOwner;
24     }
25 }
26 
27 // File: contracts/lib/lifecycle/Destructible.sol
28 
29 contract Destructible is Ownable {
30 	function selfDestruct() public onlyOwner {
31 		selfdestruct(owner);
32 	}
33 }
34 
35 // File: contracts/lib/ownership/ZapCoordinatorInterface.sol
36 
37 contract ZapCoordinatorInterface is Ownable {
38 	function addImmutableContract(string contractName, address newAddress) external;
39 	function updateContract(string contractName, address newAddress) external;
40 	function getContractName(uint index) public view returns (string);
41 	function getContract(string contractName) public view returns (address);
42 	function updateAllDependencies() external;
43 }
44 
45 // File: contracts/lib/ownership/Upgradable.sol
46 
47 pragma solidity ^0.4.24;
48 
49 contract Upgradable {
50 
51 	address coordinatorAddr;
52 	ZapCoordinatorInterface coordinator;
53 
54 	constructor(address c) public{
55 		coordinatorAddr = c;
56 		coordinator = ZapCoordinatorInterface(c);
57 	}
58 
59     function updateDependencies() external coordinatorOnly {
60        _updateDependencies();
61     }
62 
63     function _updateDependencies() internal;
64 
65     modifier coordinatorOnly() {
66     	require(msg.sender == coordinatorAddr, "Error: Coordinator Only Function");
67     	_;
68     }
69 }
70 
71 // File: contracts/platform/database/DatabaseInterface.sol
72 
73 contract DatabaseInterface is Ownable {
74 	function setStorageContract(address _storageContract, bool _allowed) public;
75 	/*** Bytes32 ***/
76 	function getBytes32(bytes32 key) external view returns(bytes32);
77 	function setBytes32(bytes32 key, bytes32 value) external;
78 	/*** Number **/
79 	function getNumber(bytes32 key) external view returns(uint256);
80 	function setNumber(bytes32 key, uint256 value) external;
81 	/*** Bytes ***/
82 	function getBytes(bytes32 key) external view returns(bytes);
83 	function setBytes(bytes32 key, bytes value) external;
84 	/*** String ***/
85 	function getString(bytes32 key) external view returns(string);
86 	function setString(bytes32 key, string value) external;
87 	/*** Bytes Array ***/
88 	function getBytesArray(bytes32 key) external view returns (bytes32[]);
89 	function getBytesArrayIndex(bytes32 key, uint256 index) external view returns (bytes32);
90 	function getBytesArrayLength(bytes32 key) external view returns (uint256);
91 	function pushBytesArray(bytes32 key, bytes32 value) external;
92 	function setBytesArrayIndex(bytes32 key, uint256 index, bytes32 value) external;
93 	function setBytesArray(bytes32 key, bytes32[] value) external;
94 	/*** Int Array ***/
95 	function getIntArray(bytes32 key) external view returns (int[]);
96 	function getIntArrayIndex(bytes32 key, uint256 index) external view returns (int);
97 	function getIntArrayLength(bytes32 key) external view returns (uint256);
98 	function pushIntArray(bytes32 key, int value) external;
99 	function setIntArrayIndex(bytes32 key, uint256 index, int value) external;
100 	function setIntArray(bytes32 key, int[] value) external;
101 	/*** Address Array ***/
102 	function getAddressArray(bytes32 key) external view returns (address[]);
103 	function getAddressArrayIndex(bytes32 key, uint256 index) external view returns (address);
104 	function getAddressArrayLength(bytes32 key) external view returns (uint256);
105 	function pushAddressArray(bytes32 key, address value) external;
106 	function setAddressArrayIndex(bytes32 key, uint256 index, address value) external;
107 	function setAddressArray(bytes32 key, address[] value) external;
108 }
109 
110 // File: contracts/platform/registry/RegistryInterface.sol
111 
112 // Technically an abstract contract, not interface (solidity compiler devs are working to fix this right now)
113 
114 contract RegistryInterface {
115     function initiateProvider(uint256, bytes32) public returns (bool);
116     function initiateProviderCurve(bytes32, int256[], address) public returns (bool);
117     function setEndpointParams(bytes32, bytes32[]) public;
118     function getEndpointParams(address, bytes32) public view returns (bytes32[]);
119     function getProviderPublicKey(address) public view returns (uint256);
120     function getProviderTitle(address) public view returns (bytes32);
121     function setProviderParameter(bytes32, bytes) public;
122     function getProviderParameter(address, bytes32) public view returns (bytes);
123     function getAllProviderParams(address) public view returns (bytes32[]);
124     function getProviderCurveLength(address, bytes32) public view returns (uint256);
125     function getProviderCurve(address, bytes32) public view returns (int[]);
126     function isProviderInitiated(address) public view returns (bool);
127     function getAllOracles() external view returns (address[]);
128     function getProviderEndpoints(address) public view returns (bytes32[]);
129     function getEndpointBroker(address, bytes32) public view returns (address);
130 }
131 
132 // File: contracts/platform/registry/Registry.sol
133 
134 // v1.0
135 
136 
137 
138 
139 
140 contract Registry is Destructible, RegistryInterface, Upgradable {
141 
142     event NewProvider(
143         address indexed provider,
144         bytes32 indexed title
145     );
146 
147     event NewCurve(
148         address indexed provider,
149         bytes32 indexed endpoint,
150         int[] curve,
151         address indexed broker
152     );
153 
154     DatabaseInterface public db;
155 
156     constructor(address c) Upgradable(c) public {
157         _updateDependencies();
158     }
159 
160     function _updateDependencies() internal {
161         address databaseAddress = coordinator.getContract("DATABASE");
162         db = DatabaseInterface(databaseAddress);
163     }
164 
165     /// @dev initiates a provider.
166     /// If no address->Oracle mapping exists, Oracle object is created
167     /// @param publicKey unique id for provider. used for encyrpted key swap for subscription endpoints
168     /// @param title name
169     function initiateProvider(
170         uint256 publicKey,
171         bytes32 title
172     )
173         public
174         returns (bool)
175     {
176         require(!isProviderInitiated(msg.sender), "Error: Provider is already initiated");
177         createOracle(msg.sender, publicKey, title);
178         addOracle(msg.sender);
179         emit NewProvider(msg.sender, title);
180         return true;
181     }
182 
183     /// @dev initiates an endpoint specific provider curve
184     /// If oracle[specfifier] is uninitialized, Curve is mapped to endpoint
185     /// @param endpoint specifier of endpoint. currently "smart_contract" or "socket_subscription"
186     /// @param curve flattened array of all segments, coefficients across all polynomial terms, [e0,l0,c0,c1,c2,...]
187     /// @param broker address for endpoint. if non-zero address, only this address will be able to bond/unbond 
188     function initiateProviderCurve(
189         bytes32 endpoint,
190         int256[] curve,
191         address broker
192     )
193         returns (bool)
194     {
195         // Provider must be initiated
196         require(isProviderInitiated(msg.sender), "Error: Provider is not yet initiated");
197         // Can't reset their curve
198         require(getCurveUnset(msg.sender, endpoint), "Error: Curve is already set");
199 
200         setCurve(msg.sender, endpoint, curve);        
201         db.pushBytesArray(keccak256(abi.encodePacked('oracles', msg.sender, 'endpoints')), endpoint);
202         db.setBytes32(keccak256(abi.encodePacked('oracles', msg.sender, endpoint, 'broker')), bytes32(broker));
203 
204         emit NewCurve(msg.sender, endpoint, curve, broker);
205 
206         return true;
207     }
208 
209     // Sets provider data
210     function setProviderParameter(bytes32 key, bytes value) public {
211         // Provider must be initiated
212         require(isProviderInitiated(msg.sender), "Error: Provider is not yet initiated");
213 
214         if(!isProviderParamInitialized(msg.sender, key)){
215             // initialize this provider param
216             db.setNumber(keccak256(abi.encodePacked('oracles', msg.sender, 'is_param_set', key)), 1);
217             db.pushBytesArray(keccak256(abi.encodePacked('oracles', msg.sender, 'providerParams')), key);
218         }
219         db.setBytes(keccak256(abi.encodePacked('oracles', msg.sender, 'providerParams', key)), value);
220     }
221 
222     // Gets provider data
223     function getProviderParameter(address provider, bytes32 key) public view returns (bytes){
224         // Provider must be initiated
225         require(isProviderInitiated(provider), "Error: Provider is not yet initiated");
226         require(isProviderParamInitialized(provider, key), "Error: Provider Parameter is not yet initialized");
227         return db.getBytes(keccak256(abi.encodePacked('oracles', provider, 'providerParams', key)));
228     }
229 
230     // Gets keys of all provider params
231     function getAllProviderParams(address provider) public view returns (bytes32[]){
232         // Provider must be initiated
233         require(isProviderInitiated(provider), "Error: Provider is not yet initiated");
234         return db.getBytesArray(keccak256(abi.encodePacked('oracles', provider, 'providerParams')));
235     }
236 
237     // Set endpoint specific parameters for a given endpoint
238     function setEndpointParams(bytes32 endpoint, bytes32[] endpointParams) public {
239         // Provider must be initiated
240         require(isProviderInitiated(msg.sender), "Error: Provider is not yet initialized");
241         // Can't set endpoint params on an unset provider
242         require(!getCurveUnset(msg.sender, endpoint), "Error: Curve is not yet set");
243 
244         db.setBytesArray(keccak256(abi.encodePacked('oracles', msg.sender, 'endpointParams', endpoint)), endpointParams);
245     }
246 
247     /// @return public key
248     function getProviderPublicKey(address provider) public view returns (uint256) {
249         return getPublicKey(provider);
250     }
251 
252     /// @return oracle name
253     function getProviderTitle(address provider) public view returns (bytes32) {
254         return getTitle(provider);
255     }
256 
257 
258     /// @dev get curve paramaters from oracle
259     function getProviderCurve(
260         address provider,
261         bytes32 endpoint
262     )
263         public
264         view
265         returns (int[])
266     {
267         require(!getCurveUnset(provider, endpoint), "Error: Curve is not yet set");
268         return db.getIntArray(keccak256(abi.encodePacked('oracles', provider, 'curves', endpoint)));
269     }
270 
271     function getProviderCurveLength(address provider, bytes32 endpoint) public view returns (uint256){
272         require(!getCurveUnset(provider, endpoint), "Error: Curve is not yet set");
273         return db.getIntArray(keccak256(abi.encodePacked('oracles', provider, 'curves', endpoint))).length;
274     }
275 
276     /// @dev is provider initiated
277     /// @param oracleAddress the provider address
278     /// @return Whether or not the provider has initiated in the Registry.
279     function isProviderInitiated(address oracleAddress) public view returns (bool) {
280         return getProviderTitle(oracleAddress) != 0;
281     }
282 
283     /*** STORAGE FUNCTIONS ***/
284     /// @dev get public key of provider
285     function getPublicKey(address provider) public view returns (uint256) {
286         return db.getNumber(keccak256(abi.encodePacked("oracles", provider, "publicKey")));
287     }
288 
289     /// @dev get title of provider
290     function getTitle(address provider) public view returns (bytes32) {
291         return db.getBytes32(keccak256(abi.encodePacked("oracles", provider, "title")));
292     }
293 
294     /// @dev get the endpoints of a provider
295     function getProviderEndpoints(address provider) public view returns (bytes32[]) {
296         return db.getBytesArray(keccak256(abi.encodePacked("oracles", provider, "endpoints")));
297     }
298 
299     /// @dev get all endpoint params
300     function getEndpointParams(address provider, bytes32 endpoint) public view returns (bytes32[]) {
301         return db.getBytesArray(keccak256(abi.encodePacked('oracles', provider, 'endpointParams', endpoint)));
302     }
303 
304     /// @dev get broker address for endpoint
305     function getEndpointBroker(address oracleAddress, bytes32 endpoint) public view returns (address) {
306         return address(db.getBytes32(keccak256(abi.encodePacked('oracles', oracleAddress, endpoint, 'broker'))));
307     }
308 
309     function getCurveUnset(address provider, bytes32 endpoint) public view returns (bool) {
310         return db.getIntArrayLength(keccak256(abi.encodePacked('oracles', provider, 'curves', endpoint))) == 0;
311     }
312 
313     /// @dev get provider address by index
314     function getOracleAddress(uint256 index) public view returns (address) {
315         return db.getAddressArrayIndex(keccak256(abi.encodePacked('oracleIndex')), index);
316     }
317 
318     /// @dev get all oracle addresses
319     function getAllOracles() external view returns (address[]) {
320         return db.getAddressArray(keccak256(abi.encodePacked('oracleIndex')));
321     }
322 
323     ///  @dev add new provider to mapping
324     function createOracle(address provider, uint256 publicKey, bytes32 title) private {
325         db.setNumber(keccak256(abi.encodePacked('oracles', provider, "publicKey")), uint256(publicKey));
326         db.setBytes32(keccak256(abi.encodePacked('oracles', provider, "title")), title);
327     }
328 
329     /// @dev add new provider address to oracles array
330     function addOracle(address provider) private {
331         db.pushAddressArray(keccak256(abi.encodePacked('oracleIndex')), provider);
332     }
333 
334     /// @dev initialize new curve for provider
335     /// @param provider address of provider
336     /// @param endpoint endpoint specifier
337     /// @param curve flattened array of all segments, coefficients across all polynomial terms, [l0,c0,c1,c2,..., ck, e0, ...]
338     function setCurve(
339         address provider,
340         bytes32 endpoint,
341         int[] curve
342     )
343         private
344     {
345         uint prevEnd = 1;
346         uint index = 0;
347 
348         // Validate the curve
349         while ( index < curve.length ) {
350             // Validate the length of the piece
351             int len = curve[index];
352             require(len > 0, "Error: Invalid Curve");
353 
354             // Validate the end index of the piece
355             uint endIndex = index + uint(len) + 1;
356             require(endIndex < curve.length, "Error: Invalid Curve");
357 
358             // Validate that the end is continuous
359             int end = curve[endIndex];
360             require(uint(end) > prevEnd, "Error: Invalid Curve");
361 
362             prevEnd = uint(end);
363             index += uint(len) + 2; 
364         }
365 
366         db.setIntArray(keccak256(abi.encodePacked('oracles', provider, 'curves', endpoint)), curve);
367     }
368 
369     // Determines whether this parameter has been initialized
370     function isProviderParamInitialized(address provider, bytes32 key) private view returns (bool){
371         uint256 val = db.getNumber(keccak256(abi.encodePacked('oracles', provider, 'is_param_set', key)));
372         return (val == 1) ? true : false;
373     }
374 
375     /*************************************** STORAGE ****************************************
376     * 'oracles', provider, 'endpoints' => {bytes32[]} array of endpoints for this oracle
377     * 'oracles', provider, 'endpointParams', endpoint => {bytes32[]} array of params for this endpoint
378     * 'oracles', provider, 'curves', endpoint => {uint[]} curve array for this endpoint
379     * 'oracles', provider, 'broker', endpoint => {bytes32} broker address for this endpoint
380     * 'oracles', provider, 'is_param_set', key => {uint} Is this provider parameter set (0/1)
381     * 'oracles', provider, "publicKey" => {uint} public key for this oracle
382     * 'oracles', provider, "title" => {bytes32} title of this oracle
383     ****************************************************************************************/
384 }