1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Registrar
5  */
6 contract Registrar {
7 	address private contractOwner;
8 	bool public paused;
9 
10 	struct Manifest {
11 		address registrant;
12 		bytes32 name;
13 		uint256 version;
14 		uint256 index;
15 		bytes32 hashTypeName;
16 		string checksum;
17 		uint256 createdOn;
18 	}
19 	
20 	struct HashType {
21 	    bytes32 name;
22 	    bool active;
23 	}
24 	
25 	uint256 public numHashTypes;
26 	mapping(bytes32 => Manifest) private manifests;
27 	mapping(address => bytes32[]) private registrantManifests;
28 	mapping(bytes32 => bytes32[]) private registrantNameManifests;
29 	mapping(bytes32 => uint256) private registrantNameVersionCount;
30 	mapping(bytes32 => uint256) public hashTypeIdLookup;
31 	mapping(uint256 => HashType) public hashTypes;
32 	
33 	 /**
34 	  * @dev Log when a manifest registration is successful
35 	  */
36 	event LogManifest(address indexed registrant, bytes32 indexed name, uint256 indexed version, bytes32 hashTypeName, string checksum);
37 
38     /**
39 	 * @dev Checks if contractOwner addresss is calling
40 	 */
41 	modifier onlyContractOwner {
42 		require(msg.sender == contractOwner);
43 		_;
44 	}
45 
46     /**
47 	 * @dev Checks if contract is active
48 	 */
49 	modifier contractIsActive {
50 		require(paused == false);
51 		_;
52 	}
53 
54     /**
55      * @dev Checks if the values provided for this manifest are valid
56      */
57     modifier manifestIsValid(bytes32 name, bytes32 hashTypeName, string checksum, address registrant) {
58         require(name != bytes32(0x0) && 
59             hashTypes[hashTypeIdLookup[hashTypeName]].active == true &&
60             bytes(checksum).length != 0 &&
61             registrant != address(0x0) &&
62             manifests[keccak256(abi.encodePacked(registrant, name, nextVersion(registrant, name)))].name == bytes32(0x0)
63             );
64         _;
65     }
66     
67 	/**
68 	 * Constructor
69      */
70 	constructor() public {
71 		contractOwner = msg.sender;
72 		addHashType('sha256');
73 	}
74 
75     /******************************************/
76     /*           OWNER ONLY METHODS           */
77     /******************************************/
78     
79     /**
80      * @dev Allows contractOwner to add hashType
81      * @param _name The value to be added
82      */
83     function addHashType(bytes32 _name) public onlyContractOwner {
84         require(hashTypeIdLookup[_name] == 0);
85         numHashTypes++;
86         hashTypeIdLookup[_name] = numHashTypes;
87         HashType storage _hashType = hashTypes[numHashTypes];
88         
89         // Store info about this hashType
90         _hashType.name = _name;
91         _hashType.active = true;
92     }
93     
94 	/**
95 	 * @dev Allows contractOwner to activate/deactivate hashType
96 	 * @param _name The name of the hashType
97 	 * @param _active The value to be set
98 	 */
99 	function setActiveHashType(bytes32 _name, bool _active) public onlyContractOwner {
100         require(hashTypeIdLookup[_name] > 0);
101         hashTypes[hashTypeIdLookup[_name]].active = _active;
102 	}
103 
104     /**
105      * @dev Allows contractOwner to pause the contract
106      * @param _paused The value to be set
107      */
108 	function setPaused(bool _paused) public onlyContractOwner {
109 		paused = _paused;
110 	}
111     
112     /**
113 	 * @dev Allows contractOwner to kill the contract
114 	 */
115     function kill() public onlyContractOwner {
116 		selfdestruct(contractOwner);
117 	}
118 
119     /******************************************/
120     /*            PUBLIC METHODS              */
121     /******************************************/
122 	/**
123 	 * @dev Function to determine the next version value of a manifest
124 	 * @param _registrant The registrant address of the manifest
125 	 * @param _name The name of the manifest
126 	 * @return The next version value
127 	 */
128 	function nextVersion(address _registrant, bytes32 _name) public view returns (uint256) {
129 	    bytes32 registrantNameIndex = keccak256(abi.encodePacked(_registrant, _name));
130 	    return (registrantNameVersionCount[registrantNameIndex] + 1);
131 	}
132 	
133 	/**
134 	 * @dev Function to register a manifest
135 	 * @param _name The name of the manifest
136 	 * @param _hashTypeName The hashType of the manifest
137 	 * @param _checksum The checksum of the manifest
138 	 */
139 	function register(bytes32 _name, bytes32 _hashTypeName, string _checksum) public 
140 	    contractIsActive
141 	    manifestIsValid(_name, _hashTypeName, _checksum, msg.sender) {
142 
143 	    // Generate registrant name index
144 	    bytes32 registrantNameIndex = keccak256(abi.encodePacked(msg.sender, _name));
145 	    
146 	    // Increment the version for this manifest
147 	    registrantNameVersionCount[registrantNameIndex]++;
148 	    
149 	    // Generate ID for this manifest
150 	    bytes32 manifestId = keccak256(abi.encodePacked(msg.sender, _name, registrantNameVersionCount[registrantNameIndex]));
151 	    
152         Manifest storage _manifest = manifests[manifestId];
153         
154         // Store info about this manifest
155         _manifest.registrant = msg.sender;
156         _manifest.name = _name;
157         _manifest.version = registrantNameVersionCount[registrantNameIndex];
158         _manifest.index = registrantNameManifests[registrantNameIndex].length;
159         _manifest.hashTypeName = _hashTypeName;
160         _manifest.checksum = _checksum;
161         _manifest.createdOn = now;
162         
163         registrantManifests[msg.sender].push(manifestId);
164         registrantNameManifests[registrantNameIndex].push(manifestId);
165 
166 	    emit LogManifest(msg.sender, _manifest.name, _manifest.version, _manifest.hashTypeName, _manifest.checksum);
167 	}
168 
169     /**
170      * @dev Function to get a manifest registration based on registrant address, manifest name and version
171      * @param _registrant The registrant address of the manifest
172      * @param _name The name of the manifest
173      * @param _version The version of the manifest
174      * @return The registrant address of the manifest
175      * @return The name of the manifest
176      * @return The version of the manifest
177      * @return The index of this manifest in registrantNameManifests
178      * @return The hashTypeName of the manifest
179      * @return The checksum of the manifest
180      * @return The created on date of the manifest
181      */
182 	function getManifest(address _registrant, bytes32 _name, uint256 _version) public view 
183 	    returns (address, bytes32, uint256, uint256, bytes32, string, uint256) {
184 	        
185 	    bytes32 manifestId = keccak256(abi.encodePacked(_registrant, _name, _version));
186 	    require(manifests[manifestId].name != bytes32(0x0));
187 
188 	    Manifest memory _manifest = manifests[manifestId];
189 	    return (
190 	        _manifest.registrant,
191 	        _manifest.name,
192 	        _manifest.version,
193 	        _manifest.index,
194 	        _manifest.hashTypeName,
195 	        _manifest.checksum,
196 	        _manifest.createdOn
197 	   );
198 	}
199 
200     /**
201      * @dev Function to get a manifest registration based on manifestId
202      * @param _manifestId The registration ID of the manifest
203      * @return The registrant address of the manifest
204      * @return The name of the manifest
205      * @return The version of the manifest
206      * @return The index of this manifest in registrantNameManifests
207      * @return The hashTypeName of the manifest
208      * @return The checksum of the manifest
209      * @return The created on date of the manifest
210      */
211 	function getManifestById(bytes32 _manifestId) public view
212 	    returns (address, bytes32, uint256, uint256, bytes32, string, uint256) {
213 	    require(manifests[_manifestId].name != bytes32(0x0));
214 
215 	    Manifest memory _manifest = manifests[_manifestId];
216 	    return (
217 	        _manifest.registrant,
218 	        _manifest.name,
219 	        _manifest.version,
220 	        _manifest.index,
221 	        _manifest.hashTypeName,
222 	        _manifest.checksum,
223 	        _manifest.createdOn
224 	   );
225 	}
226 
227     /**
228      * @dev Function to get the latest manifest registration based on registrant address and manifest name
229      * @param _registrant The registrant address of the manifest
230      * @param _name The name of the manifest
231      * @return The registrant address of the manifest
232      * @return The name of the manifest
233      * @return The version of the manifest
234      * @return The index of this manifest in registrantNameManifests
235      * @return The hashTypeName of the manifest
236      * @return The checksum of the manifest
237      * @return The created on date of the manifest
238      */
239 	function getLatestManifestByName(address _registrant, bytes32 _name) public view
240 	    returns (address, bytes32, uint256, uint256, bytes32, string, uint256) {
241 	        
242 	    bytes32 registrantNameIndex = keccak256(abi.encodePacked(_registrant, _name));
243 	    require(registrantNameManifests[registrantNameIndex].length > 0);
244 	    
245 	    bytes32 manifestId = registrantNameManifests[registrantNameIndex][registrantNameManifests[registrantNameIndex].length - 1];
246 	    Manifest memory _manifest = manifests[manifestId];
247 
248 	    return (
249 	        _manifest.registrant,
250 	        _manifest.name,
251 	        _manifest.version,
252 	        _manifest.index,
253 	        _manifest.hashTypeName,
254 	        _manifest.checksum,
255 	        _manifest.createdOn
256 	   );
257 	}
258 	
259 	/**
260      * @dev Function to get the latest manifest registration based on registrant address
261      * @param _registrant The registrant address of the manifest
262      * @return The registrant address of the manifest
263      * @return The name of the manifest
264      * @return The version of the manifest
265      * @return The index of this manifest in registrantNameManifests
266      * @return The hashTypeName of the manifest
267      * @return The checksum of the manifest
268      * @return The created on date of the manifest
269      */
270 	function getLatestManifest(address _registrant) public view
271 	    returns (address, bytes32, uint256, uint256, bytes32, string, uint256) {
272 	    require(registrantManifests[_registrant].length > 0);
273 	    
274 	    bytes32 manifestId = registrantManifests[_registrant][registrantManifests[_registrant].length - 1];
275 	    Manifest memory _manifest = manifests[manifestId];
276 
277 	    return (
278 	        _manifest.registrant,
279 	        _manifest.name,
280 	        _manifest.version,
281 	        _manifest.index,
282 	        _manifest.hashTypeName,
283 	        _manifest.checksum,
284 	        _manifest.createdOn
285 	   );
286 	}
287 	
288 	/**
289      * @dev Function to get a list of manifest Ids based on registrant address
290      * @param _registrant The registrant address of the manifest
291      * @return Array of manifestIds
292      */
293 	function getManifestIdsByRegistrant(address _registrant) public view returns (bytes32[]) {
294 	    return registrantManifests[_registrant];
295 	}
296 
297     /**
298      * @dev Function to get a list of manifest Ids based on registrant address and manifest name
299      * @param _registrant The registrant address of the manifest
300      * @param _name The name of the manifest
301      * @return Array of registrationsIds
302      */
303 	function getManifestIdsByName(address _registrant, bytes32 _name) public view returns (bytes32[]) {
304 	    bytes32 registrantNameIndex = keccak256(abi.encodePacked(_registrant, _name));
305 	    return registrantNameManifests[registrantNameIndex];
306 	}
307 	
308 	/**
309      * @dev Function to get manifest Id based on registrant address, manifest name and version
310      * @param _registrant The registrant address of the manifest
311      * @param _name The name of the manifest
312      * @param _version The version of the manifest
313      * @return The manifestId of the manifest
314      */
315 	function getManifestId(address _registrant, bytes32 _name, uint256 _version) public view returns (bytes32) {
316 	    bytes32 manifestId = keccak256(abi.encodePacked(_registrant, _name, _version));
317 	    require(manifests[manifestId].name != bytes32(0x0));
318 	    return manifestId;
319 	}
320 }