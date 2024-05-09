1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title IngressRegistrar
5  */
6 contract IngressRegistrar {
7 	address private owner;
8 	bool public paused;
9 
10 	struct Manifest {
11 		address registrant;
12 		bytes32 name;
13 		bytes32 version;
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
29 	mapping(bytes32 => uint256) public hashTypeIdLookup;
30 	mapping(uint256 => HashType) public hashTypes;
31 	
32 	 /**
33 	  * @dev Log when a manifest registration is successful
34 	  */
35 	event LogManifest(address indexed registrant, bytes32 indexed name, bytes32 indexed version, bytes32 hashTypeName, string checksum);
36 
37     /**
38 	 * @dev Checks if owner addresss is calling
39 	 */
40 	modifier onlyOwner {
41 		require(msg.sender == owner);
42 		_;
43 	}
44 
45     /**
46 	 * @dev Checks if contract is active
47 	 */
48 	modifier contractIsActive {
49 		require(paused == false);
50 		_;
51 	}
52 
53     /**
54      * @dev Checks if the values provided for this manifest are valid
55      */
56     modifier manifestIsValid(bytes32 name, bytes32 version, bytes32 hashTypeName, string checksum, address registrant) {
57         require(name != bytes32(0x0) && 
58             version != bytes32(0x0) && 
59             hashTypes[hashTypeIdLookup[hashTypeName]].active == true &&
60             bytes(checksum).length != 0 &&
61             registrant != address(0x0) &&
62             manifests[keccak256(registrant, name, version)].name == bytes32(0x0)
63             );
64         _;
65     }
66     
67 	/**
68 	 * Constructor
69      */
70 	constructor() public {
71 		owner = msg.sender;
72 		addHashType('md5');
73 		addHashType('sha1');
74 	}
75 
76     /******************************************/
77     /*           OWNER ONLY METHODS           */
78     /******************************************/
79     
80     /**
81      * @dev Allows owner to add hashType
82      * @param name The value to be added
83      */
84     function addHashType(bytes32 name) public onlyOwner {
85         require(hashTypeIdLookup[name] == 0);
86         numHashTypes++;
87         hashTypeIdLookup[name] = numHashTypes;
88         HashType storage _hashType = hashTypes[numHashTypes];
89         
90         // Store info about this hashType
91         _hashType.name = name;
92         _hashType.active = true;
93     }
94     
95 	/**
96 	 * @dev Allows owner to activate/deactivate hashType
97 	 * @param name The name of the hashType
98 	 * @param active The value to be set
99 	 */
100 	function setActiveHashType(bytes32 name, bool active) public onlyOwner {
101         require(hashTypeIdLookup[name] > 0);
102         hashTypes[hashTypeIdLookup[name]].active = active;
103 	}
104     
105     /**
106 	 * @dev Allows owner to kill the contract
107 	 */
108     function kill() public onlyOwner {
109 		selfdestruct(owner);
110 	}
111 
112     /**
113      * @dev Allows owner to pause the contract
114      * @param _paused The value to be set
115      */
116 	function setPaused(bool _paused) public onlyOwner {
117 		paused = _paused;
118 	}
119 	
120     /******************************************/
121     /*            PUBLIC METHODS              */
122     /******************************************/
123 	
124 	/**
125 	 * @dev Function to register a manifest
126 	 * @param name The name of the manifest
127 	 * @param version The version of the manifest
128 	 * @param hashTypeName The hashType of the manifest
129 	 * @param checksum The checksum of the manifest
130 	 */
131 	function register(bytes32 name, bytes32 version, bytes32 hashTypeName, string checksum) public 
132 	    contractIsActive
133 	    manifestIsValid(name, version, hashTypeName, checksum, msg.sender) {
134 	    
135 	    // Generate ID for this manifest
136 	    bytes32 manifestId = keccak256(msg.sender, name, version);
137 	    
138 	    // Generate registrant name index
139 	    bytes32 registrantNameIndex = keccak256(msg.sender, name);
140 
141         Manifest storage _manifest = manifests[manifestId];
142         
143         // Store info about this manifest
144         _manifest.registrant = msg.sender;
145         _manifest.name = name;
146         _manifest.version = version;
147         _manifest.index = registrantNameManifests[registrantNameIndex].length;
148         _manifest.hashTypeName = hashTypeName;
149         _manifest.checksum = checksum;
150         _manifest.createdOn = now;
151         
152         registrantManifests[msg.sender].push(manifestId);
153         registrantNameManifests[registrantNameIndex].push(manifestId);
154 
155 	    emit LogManifest(msg.sender, name, version, hashTypeName, checksum);
156 	}
157 
158     /**
159      * @dev Function to get a manifest registration based on registrant address, manifest name and version
160      * @param registrant The registrant address of the manifest
161      * @param name The name of the manifest
162      * @param version The version of the manifest
163      * @return The registrant address of the manifest
164      * @return The name of the manifest
165      * @return The version of the manifest
166      * @return The index of this manifest in registrantNameManifests
167      * @return The hashTypeName of the manifest
168      * @return The checksum of the manifest
169      * @return The created on date of the manifest
170      */
171 	function getManifest(address registrant, bytes32 name, bytes32 version) public view 
172 	    returns (address, bytes32, bytes32, uint256, bytes32, string, uint256) {
173 	        
174 	    bytes32 manifestId = keccak256(registrant, name, version);
175 	    require(manifests[manifestId].name != bytes32(0x0));
176 
177 	    Manifest memory _manifest = manifests[manifestId];
178 	    return (
179 	        _manifest.registrant,
180 	        _manifest.name,
181 	        _manifest.version,
182 	        _manifest.index,
183 	        _manifest.hashTypeName,
184 	        _manifest.checksum,
185 	        _manifest.createdOn
186 	   );
187 	}
188 
189     /**
190      * @dev Function to get a manifest registration based on manifestId
191      * @param manifestId The registration ID of the manifest
192      * @return The registrant address of the manifest
193      * @return The name of the manifest
194      * @return The version of the manifest
195      * @return The index of this manifest in registrantNameManifests
196      * @return The hashTypeName of the manifest
197      * @return The checksum of the manifest
198      * @return The created on date of the manifest
199      */
200 	function getManifestById(bytes32 manifestId) public view
201 	    returns (address, bytes32, bytes32, uint256, bytes32, string, uint256) {
202 	    require(manifests[manifestId].name != bytes32(0x0));
203 
204 	    Manifest memory _manifest = manifests[manifestId];
205 	    return (
206 	        _manifest.registrant,
207 	        _manifest.name,
208 	        _manifest.version,
209 	        _manifest.index,
210 	        _manifest.hashTypeName,
211 	        _manifest.checksum,
212 	        _manifest.createdOn
213 	   );
214 	}
215 
216     /**
217      * @dev Function to get the latest manifest registration based on registrant address and manifest name
218      * @param registrant The registrant address of the manifest
219      * @param name The name of the manifest
220      * @return The registrant address of the manifest
221      * @return The name of the manifest
222      * @return The version of the manifest
223      * @return The index of this manifest in registrantNameManifests
224      * @return The hashTypeName of the manifest
225      * @return The checksum of the manifest
226      * @return The created on date of the manifest
227      */
228 	function getLatestManifestByName(address registrant, bytes32 name) public view
229 	    returns (address, bytes32, bytes32, uint256, bytes32, string, uint256) {
230 	        
231 	    bytes32 registrantNameIndex = keccak256(registrant, name);
232 	    require(registrantNameManifests[registrantNameIndex].length > 0);
233 	    
234 	    bytes32 manifestId = registrantNameManifests[registrantNameIndex][registrantNameManifests[registrantNameIndex].length - 1];
235 	    Manifest memory _manifest = manifests[manifestId];
236 
237 	    return (
238 	        _manifest.registrant,
239 	        _manifest.name,
240 	        _manifest.version,
241 	        _manifest.index,
242 	        _manifest.hashTypeName,
243 	        _manifest.checksum,
244 	        _manifest.createdOn
245 	   );
246 	}
247 	
248 	/**
249      * @dev Function to get the latest manifest registration based on registrant address
250      * @param registrant The registrant address of the manifest
251      * @return The registrant address of the manifest
252      * @return The name of the manifest
253      * @return The version of the manifest
254      * @return The index of this manifest in registrantNameManifests
255      * @return The hashTypeName of the manifest
256      * @return The checksum of the manifest
257      * @return The created on date of the manifest
258      */
259 	function getLatestManifest(address registrant) public view
260 	    returns (address, bytes32, bytes32, uint256, bytes32, string, uint256) {
261 	    require(registrantManifests[registrant].length > 0);
262 	    
263 	    bytes32 manifestId = registrantManifests[registrant][registrantManifests[registrant].length - 1];
264 	    Manifest memory _manifest = manifests[manifestId];
265 
266 	    return (
267 	        _manifest.registrant,
268 	        _manifest.name,
269 	        _manifest.version,
270 	        _manifest.index,
271 	        _manifest.hashTypeName,
272 	        _manifest.checksum,
273 	        _manifest.createdOn
274 	   );
275 	}
276 	
277 	/**
278      * @dev Function to get a list of manifest Ids based on registrant address
279      * @param registrant The registrant address of the manifest
280      * @return Array of manifestIds
281      */
282 	function getManifestIdsByRegistrant(address registrant) public view returns (bytes32[]) {
283 	    return registrantManifests[registrant];
284 	}
285 
286     /**
287      * @dev Function to get a list of manifest Ids based on registrant address and manifest name
288      * @param registrant The registrant address of the manifest
289      * @param name The name of the manifest
290      * @return Array of registrationsIds
291      */
292 	function getManifestIdsByName(address registrant, bytes32 name) public view returns (bytes32[]) {
293 	    bytes32 registrantNameIndex = keccak256(registrant, name);
294 	    return registrantNameManifests[registrantNameIndex];
295 	}
296 	
297 	/**
298      * @dev Function to get manifest Id based on registrant address, manifest name and version
299      * @param registrant The registrant address of the manifest
300      * @param name The name of the manifest
301      * @param version The version of the manifest
302      * @return The manifestId of the manifest
303      */
304 	function getManifestId(address registrant, bytes32 name, bytes32 version) public view returns (bytes32) {
305 	    bytes32 manifestId = keccak256(registrant, name, version);
306 	    require(manifests[manifestId].name != bytes32(0x0));
307 	    return manifestId;
308 	}
309 }