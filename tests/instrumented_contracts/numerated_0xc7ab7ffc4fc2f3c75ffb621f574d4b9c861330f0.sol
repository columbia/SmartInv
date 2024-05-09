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
122     function setProviderTitle(bytes32) public;
123     function clearEndpoint(bytes32) public;
124     function getProviderParameter(address, bytes32) public view returns (bytes);
125     function getAllProviderParams(address) public view returns (bytes32[]);
126     function getProviderCurveLength(address, bytes32) public view returns (uint256);
127     function getProviderCurve(address, bytes32) public view returns (int[]);
128     function isProviderInitiated(address) public view returns (bool);
129     function getAllOracles() external view returns (address[]);
130     function getProviderEndpoints(address) public view returns (bytes32[]);
131     function getEndpointBroker(address, bytes32) public view returns (address);
132 }
133 
134 // File: contracts/platform/registry/Registry.sol
135 
136 // v1.0
137 
138 
139 
140 
141 
142 contract Registry is Destructible, RegistryInterface, Upgradable {
143 
144     event NewProvider(
145         address indexed provider,
146         bytes32 indexed title
147     );
148 
149     event NewCurve(
150         address indexed provider,
151         bytes32 indexed endpoint,
152         int[] curve,
153         address indexed broker
154     );
155 
156     DatabaseInterface public db;
157 
158     constructor(address c) Upgradable(c) public {
159         _updateDependencies();
160     }
161 
162     function _updateDependencies() internal {
163         address databaseAddress = coordinator.getContract("DATABASE");
164         db = DatabaseInterface(databaseAddress);
165     }
166 
167     /// @dev initiates a provider.
168     /// If no address->Oracle mapping exists, Oracle object is created
169     /// @param publicKey unique id for provider. used for encyrpted key swap for subscription endpoints
170     /// @param title name
171     function initiateProvider(
172         uint256 publicKey,
173         bytes32 title
174     )
175         public
176         returns (bool)
177     {
178         require(!isProviderInitiated(msg.sender), "Error: Provider is already initiated");
179         createOracle(msg.sender, publicKey, title);
180         addOracle(msg.sender);
181         emit NewProvider(msg.sender, title);
182         return true;
183     }
184 
185     /// @dev initiates an endpoint specific provider curve
186     /// If oracle[specfifier] is uninitialized, Curve is mapped to endpoint
187     /// @param endpoint specifier of endpoint. currently "smart_contract" or "socket_subscription"
188     /// @param curve flattened array of all segments, coefficients across all polynomial terms, [e0,l0,c0,c1,c2,...]
189     /// @param broker address for endpoint. if non-zero address, only this address will be able to bond/unbond 
190     function initiateProviderCurve(
191         bytes32 endpoint,
192         int256[] curve,
193         address broker
194     )
195         returns (bool)
196     {
197         // Provider must be initiated
198         require(isProviderInitiated(msg.sender), "Error: Provider is not yet initiated");
199         // Can't reset their curve
200         require(getCurveUnset(msg.sender, endpoint), "Error: Curve is already set");
201         // Can't initiate null endpoint
202         require(endpoint != bytes32(0), "Error: Can't initiate null endpoint");
203 
204         setCurve(msg.sender, endpoint, curve);        
205         db.pushBytesArray(keccak256(abi.encodePacked('oracles', msg.sender, 'endpoints')), endpoint);
206         db.setBytes32(keccak256(abi.encodePacked('oracles', msg.sender, endpoint, 'broker')), bytes32(broker));
207 
208         emit NewCurve(msg.sender, endpoint, curve, broker);
209 
210         return true;
211     }
212 
213     // Sets provider data
214     function setProviderParameter(bytes32 key, bytes value) public {
215         // Provider must be initiated
216         require(isProviderInitiated(msg.sender), "Error: Provider is not yet initiated");
217 
218         if(!isProviderParamInitialized(msg.sender, key)){
219             // initialize this provider param
220             db.setNumber(keccak256(abi.encodePacked('oracles', msg.sender, 'is_param_set', key)), 1);
221             db.pushBytesArray(keccak256(abi.encodePacked('oracles', msg.sender, 'providerParams')), key);
222         }
223         db.setBytes(keccak256(abi.encodePacked('oracles', msg.sender, 'providerParams', key)), value);
224     }
225 
226     // Gets provider data
227     function getProviderParameter(address provider, bytes32 key) public view returns (bytes){
228         // Provider must be initiated
229         require(isProviderInitiated(provider), "Error: Provider is not yet initiated");
230         require(isProviderParamInitialized(provider, key), "Error: Provider Parameter is not yet initialized");
231         return db.getBytes(keccak256(abi.encodePacked('oracles', provider, 'providerParams', key)));
232     }
233 
234     // Gets keys of all provider params
235     function getAllProviderParams(address provider) public view returns (bytes32[]){
236         // Provider must be initiated
237         require(isProviderInitiated(provider), "Error: Provider is not yet initiated");
238         return db.getBytesArray(keccak256(abi.encodePacked('oracles', provider, 'providerParams')));
239     }
240 
241     // Set endpoint specific parameters for a given endpoint
242     function setEndpointParams(bytes32 endpoint, bytes32[] endpointParams) public {
243         // Provider must be initiated
244         require(isProviderInitiated(msg.sender), "Error: Provider is not yet initialized");
245         // Can't set endpoint params on an unset provider
246         require(!getCurveUnset(msg.sender, endpoint), "Error: Curve is not yet set");
247 
248         db.setBytesArray(keccak256(abi.encodePacked('oracles', msg.sender, 'endpointParams', endpoint)), endpointParams);
249     }
250 
251     //Set title for registered provider account
252     function setProviderTitle(bytes32 title) public {
253 
254         require(isProviderInitiated(msg.sender), "Error: Provider is not initiated");
255         db.setBytes32(keccak256(abi.encodePacked('oracles', msg.sender, "title")), title);
256     }
257 
258     //Clear an endpoint with no bonds
259     function clearEndpoint(bytes32 endpoint) public {
260 
261         require(isProviderInitiated(msg.sender), "Error: Provider is not initiated");
262 
263         uint256 bound = db.getNumber(keccak256(abi.encodePacked('totalBound', msg.sender, endpoint)));
264         require(bound == 0, "Error: Endpoint must have no bonds");
265 
266         int256[] memory nullArray = new int256[](0);
267         bytes32[] memory endpoints =  db.getBytesArray(keccak256(abi.encodePacked("oracles", msg.sender, "endpoints")));
268         for(uint256 i = 0; i < endpoints.length; i++) {
269             if( endpoints[i] == endpoint ) {
270                db.setBytesArrayIndex(keccak256(abi.encodePacked("oracles", msg.sender, "endpoints")), i, bytes32(0));
271                break; 
272             }
273         }
274         db.pushBytesArray(keccak256(abi.encodePacked('oracles', msg.sender, 'endpoints')), bytes32(0));
275         db.setBytes32(keccak256(abi.encodePacked('oracles', msg.sender, endpoint, 'broker')), bytes32(0));
276         db.setIntArray(keccak256(abi.encodePacked('oracles', msg.sender, 'curves', endpoint)), nullArray);
277     }
278 
279     /// @return public key
280     function getProviderPublicKey(address provider) public view returns (uint256) {
281         return getPublicKey(provider);
282     }
283 
284     /// @return oracle name
285     function getProviderTitle(address provider) public view returns (bytes32) {
286         return getTitle(provider);
287     }
288 
289 
290     /// @dev get curve paramaters from oracle
291     function getProviderCurve(
292         address provider,
293         bytes32 endpoint
294     )
295         public
296         view
297         returns (int[])
298     {
299         require(!getCurveUnset(provider, endpoint), "Error: Curve is not yet set");
300         return db.getIntArray(keccak256(abi.encodePacked('oracles', provider, 'curves', endpoint)));
301     }
302 
303     function getProviderCurveLength(address provider, bytes32 endpoint) public view returns (uint256){
304         require(!getCurveUnset(provider, endpoint), "Error: Curve is not yet set");
305         return db.getIntArray(keccak256(abi.encodePacked('oracles', provider, 'curves', endpoint))).length;
306     }
307 
308     /// @dev is provider initiated
309     /// @param oracleAddress the provider address
310     /// @return Whether or not the provider has initiated in the Registry.
311     function isProviderInitiated(address oracleAddress) public view returns (bool) {
312         return getProviderTitle(oracleAddress) != 0;
313     }
314 
315     /*** STORAGE FUNCTIONS ***/
316     /// @dev get public key of provider
317     function getPublicKey(address provider) public view returns (uint256) {
318         return db.getNumber(keccak256(abi.encodePacked("oracles", provider, "publicKey")));
319     }
320 
321     /// @dev get title of provider
322     function getTitle(address provider) public view returns (bytes32) {
323         return db.getBytes32(keccak256(abi.encodePacked("oracles", provider, "title")));
324     }
325 
326     /// @dev get the endpoints of a provider
327     function getProviderEndpoints(address provider) public view returns (bytes32[]) {
328         return db.getBytesArray(keccak256(abi.encodePacked("oracles", provider, "endpoints")));
329     }
330 
331     /// @dev get all endpoint params
332     function getEndpointParams(address provider, bytes32 endpoint) public view returns (bytes32[]) {
333         return db.getBytesArray(keccak256(abi.encodePacked('oracles', provider, 'endpointParams', endpoint)));
334     }
335 
336     /// @dev get broker address for endpoint
337     function getEndpointBroker(address oracleAddress, bytes32 endpoint) public view returns (address) {
338         return address(db.getBytes32(keccak256(abi.encodePacked('oracles', oracleAddress, endpoint, 'broker'))));
339     }
340 
341     function getCurveUnset(address provider, bytes32 endpoint) public view returns (bool) {
342         return db.getIntArrayLength(keccak256(abi.encodePacked('oracles', provider, 'curves', endpoint))) == 0;
343     }
344 
345     /// @dev get provider address by index
346     function getOracleAddress(uint256 index) public view returns (address) {
347         return db.getAddressArrayIndex(keccak256(abi.encodePacked('oracleIndex')), index);
348     }
349 
350     /// @dev get all oracle addresses
351     function getAllOracles() external view returns (address[]) {
352         return db.getAddressArray(keccak256(abi.encodePacked('oracleIndex')));
353     }
354 
355     ///  @dev add new provider to mapping
356     function createOracle(address provider, uint256 publicKey, bytes32 title) private {
357         db.setNumber(keccak256(abi.encodePacked('oracles', provider, "publicKey")), uint256(publicKey));
358         db.setBytes32(keccak256(abi.encodePacked('oracles', provider, "title")), title);
359     }
360 
361     /// @dev add new provider address to oracles array
362     function addOracle(address provider) private {
363         db.pushAddressArray(keccak256(abi.encodePacked('oracleIndex')), provider);
364     }
365 
366     /// @dev initialize new curve for provider
367     /// @param provider address of provider
368     /// @param endpoint endpoint specifier
369     /// @param curve flattened array of all segments, coefficients across all polynomial terms, [l0,c0,c1,c2,..., ck, e0, ...]
370     function setCurve(
371         address provider,
372         bytes32 endpoint,
373         int[] curve
374     )
375         private
376     {
377         uint prevEnd = 1;
378         uint index = 0;
379 
380         // Validate the curve
381         while ( index < curve.length ) {
382             // Validate the length of the piece
383             int len = curve[index];
384             require(len > 0, "Error: Invalid Curve");
385 
386             // Validate the end index of the piece
387             uint endIndex = index + uint(len) + 1;
388             require(endIndex < curve.length, "Error: Invalid Curve");
389 
390             // Validate that the end is continuous
391             int end = curve[endIndex];
392             require(uint(end) > prevEnd, "Error: Invalid Curve");
393 
394             prevEnd = uint(end);
395             index += uint(len) + 2; 
396         }
397 
398         db.setIntArray(keccak256(abi.encodePacked('oracles', provider, 'curves', endpoint)), curve);
399     }
400 
401     // Determines whether this parameter has been initialized
402     function isProviderParamInitialized(address provider, bytes32 key) private view returns (bool){
403         uint256 val = db.getNumber(keccak256(abi.encodePacked('oracles', provider, 'is_param_set', key)));
404         return (val == 1) ? true : false;
405     }
406 
407     /*************************************** STORAGE ****************************************
408     * 'oracles', provider, 'endpoints' => {bytes32[]} array of endpoints for this oracle
409     * 'oracles', provider, 'endpointParams', endpoint => {bytes32[]} array of params for this endpoint
410     * 'oracles', provider, 'curves', endpoint => {uint[]} curve array for this endpoint
411     * 'oracles', provider, 'broker', endpoint => {bytes32} broker address for this endpoint
412     * 'oracles', provider, 'is_param_set', key => {uint} Is this provider parameter set (0/1)
413     * 'oracles', provider, "publicKey" => {uint} public key for this oracle
414     * 'oracles', provider, "title" => {bytes32} title of this oracle
415     ****************************************************************************************/
416 }