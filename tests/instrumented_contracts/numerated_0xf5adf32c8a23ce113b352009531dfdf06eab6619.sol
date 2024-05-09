1 pragma solidity 0.5.3;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 
78 /**
79  * @title Secondary
80  * @dev A Secondary contract can only be used by its primary account (the one that created it)
81  */
82 contract OwnableSecondary is Ownable {
83   address private _primary;
84 
85   event PrimaryTransferred(
86     address recipient
87   );
88 
89   /**
90    * @dev Sets the primary account to the one that is creating the Secondary contract.
91    */
92   constructor() internal {
93     _primary = msg.sender;
94     emit PrimaryTransferred(_primary);
95   }
96 
97   /**
98    * @dev Reverts if called from any account other than the primary or the owner.
99    */
100    modifier onlyPrimaryOrOwner() {
101      require(msg.sender == _primary || msg.sender == owner(), "not the primary user nor the owner");
102      _;
103    }
104 
105    /**
106     * @dev Reverts if called from any account other than the primary.
107     */
108   modifier onlyPrimary() {
109     require(msg.sender == _primary, "not the primary user");
110     _;
111   }
112 
113   /**
114    * @return the address of the primary.
115    */
116   function primary() public view returns (address) {
117     return _primary;
118   }
119 
120   /**
121    * @dev Transfers contract to a new primary.
122    * @param recipient The address of new primary.
123    */
124   function transferPrimary(address recipient) public onlyOwner {
125     require(recipient != address(0), "new primary address is null");
126     _primary = recipient;
127     emit PrimaryTransferred(_primary);
128   }
129 }
130 
131 
132 
133 
134 
135 
136 contract ImmutableEternalStorageInterface is OwnableSecondary {
137   /********************/
138   /** PUBLIC - WRITE **/
139   /********************/
140   function createUint(bytes32 key, uint value) external;
141 
142   function createString(bytes32 key, string calldata value) external;
143 
144   function createAddress(bytes32 key, address value) external;
145 
146   function createBytes(bytes32 key, bytes calldata value) external;
147 
148   function createBytes32(bytes32 key, bytes32 value) external;
149 
150   function createBool(bytes32 key, bool value) external;
151 
152   function createInt(bytes32 key, int value) external;
153 
154   /*******************/
155   /** PUBLIC - READ **/
156   /*******************/
157   function getUint(bytes32 key) external view returns(uint);
158 
159   function uintExists(bytes32 key) external view returns(bool);
160 
161   function getString(bytes32 key) external view returns(string memory);
162 
163   function stringExists(bytes32 key) external view returns(bool);
164 
165   function getAddress(bytes32 key) external view returns(address);
166 
167   function addressExists(bytes32 key) external view returns(bool);
168 
169   function getBytes(bytes32 key) external view returns(bytes memory);
170 
171   function bytesExists(bytes32 key) external view returns(bool);
172 
173   function getBytes32(bytes32 key) external view returns(bytes32);
174 
175   function bytes32Exists(bytes32 key) external view returns(bool);
176 
177   function getBool(bytes32 key) external view returns(bool);
178 
179   function boolExists(bytes32 key) external view returns(bool);
180 
181   function getInt(bytes32 key) external view returns(int);
182 
183   function intExists(bytes32 key) external view returns(bool);
184 }
185 
186 
187 
188 
189 
190 contract StatementRegisteryInterface is OwnableSecondary {
191   /********************/
192   /** PUBLIC - WRITE **/
193   /********************/
194   function recordStatement(string calldata buildingPermitId, uint[] calldata statementDataLayout, bytes calldata statementData) external returns(bytes32);
195 
196   /*******************/
197   /** PUBLIC - READ **/
198   /*******************/
199   function statementIdsByBuildingPermit(string calldata id) external view returns(bytes32[] memory);
200 
201   function statementExists(bytes32 statementId) public view returns(bool);
202 
203   function getStatementString(bytes32 statementId, string memory key) public view returns(string memory);
204 
205   function getStatementPcId(bytes32 statementId) external view returns (string memory);
206 
207   function getStatementAcquisitionDate(bytes32 statementId) external view returns (string memory);
208 
209   function getStatementRecipient(bytes32 statementId) external view returns (string memory);
210 
211   function getStatementArchitect(bytes32 statementId) external view returns (string memory);
212 
213   function getStatementCityHall(bytes32 statementId) external view returns (string memory);
214 
215   function getStatementMaximumHeight(bytes32 statementId) external view returns (string memory);
216 
217   function getStatementDestination(bytes32 statementId) external view returns (string memory);
218 
219   function getStatementSiteArea(bytes32 statementId) external view returns (string memory);
220 
221   function getStatementBuildingArea(bytes32 statementId) external view returns (string memory);
222 
223   function getStatementNearImage(bytes32 statementId) external view returns(string memory);
224 
225   function getStatementFarImage(bytes32 statementId) external view returns(string memory);
226 
227   function getAllStatements() external view returns(bytes32[] memory);
228 }
229 
230 
231 
232 contract StatementRegistery is StatementRegisteryInterface {
233   ImmutableEternalStorageInterface public dataStore;
234   string[] public buildingPermitIds;
235   mapping(bytes32 => uint) public statementCountByBuildingPermitHash;
236 
237   event NewStatementEvent(string indexed buildingPermitId, bytes32 statementId);
238 
239   /********************/
240   /** PUBLIC - WRITE **/
241   /********************/
242   constructor(address immutableDataStore) public {
243     require(immutableDataStore != address(0), "null data store");
244     dataStore = ImmutableEternalStorageInterface(immutableDataStore);
245   }
246 
247   /* Only to be called by the Controller contract */
248   function recordStatement(
249     string calldata buildingPermitId,
250     uint[] calldata statementDataLayout,
251     bytes calldata statementData
252   ) external onlyPrimaryOrOwner returns(bytes32) {
253     bytes32 statementId = generateNewStatementId(buildingPermitId);
254 
255     assert(!statementExists(statementId));
256 
257     recordStatementKeyValues(statementId, statementDataLayout, statementData);
258 
259     dataStore.createBool(keccak256(abi.encodePacked(statementId)), true);
260     updateStatementCountByBuildingPermit(buildingPermitId);
261 
262     emit NewStatementEvent(buildingPermitId, statementId);
263 
264     return statementId;
265   }
266 
267   /*******************/
268   /** PUBLIC - READ **/
269   /*******************/
270   function statementIdsByBuildingPermit(string calldata buildingPermitId) external view returns(bytes32[] memory) {
271     uint nbStatements = statementCountByBuildingPermit(buildingPermitId);
272 
273     bytes32[] memory res = new bytes32[](nbStatements);
274 
275     while(nbStatements > 0) {
276       nbStatements--;
277       res[nbStatements] = computeStatementId(buildingPermitId,nbStatements);
278     }
279 
280     return res;
281   }
282 
283   function statementExists(bytes32 statementId) public view returns(bool) {
284     return dataStore.boolExists(keccak256(abi.encodePacked(statementId)));
285   }
286 
287   function getStatementString(bytes32 statementId, string memory key) public view returns(string memory) {
288     return dataStore.getString(keccak256(abi.encodePacked(statementId, key)));
289   }
290 
291   function getStatementPcId(bytes32 statementId) external view returns (string memory) {
292     return getStatementString(statementId, "pcId");
293   }
294 
295   function getStatementAcquisitionDate(bytes32 statementId) external view returns (string memory) {
296     return getStatementString(statementId, "acquisitionDate");
297   }
298 
299   function getStatementRecipient(bytes32 statementId) external view returns (string memory) {
300     return getStatementString(statementId, "recipient");
301   }
302 
303   function getStatementArchitect(bytes32 statementId) external view returns (string memory) {
304     return getStatementString(statementId, "architect");
305   }
306 
307   function getStatementCityHall(bytes32 statementId) external view returns (string memory) {
308     return getStatementString(statementId, "cityHall");
309   }
310 
311   function getStatementMaximumHeight(bytes32 statementId) external view returns (string memory) {
312     return getStatementString(statementId, "maximumHeight");
313   }
314 
315   function getStatementDestination(bytes32 statementId) external view returns (string memory) {
316     return getStatementString(statementId, "destination");
317   }
318 
319   function getStatementSiteArea(bytes32 statementId) external view returns (string memory) {
320     return getStatementString(statementId, "siteArea");
321   }
322 
323   function getStatementBuildingArea(bytes32 statementId) external view returns (string memory) {
324     return getStatementString(statementId, "buildingArea");
325   }
326 
327   function getStatementNearImage(bytes32 statementId) external view returns(string memory) {
328     return getStatementString(statementId, "nearImage");
329   }
330 
331   function getStatementFarImage(bytes32 statementId) external view returns(string memory) {
332     return getStatementString(statementId, "farImage");
333   }
334 
335   function getAllStatements() external view returns(bytes32[] memory) {
336     uint nbStatements = 0;
337     for(uint idx = 0; idx < buildingPermitIds.length; idx++) {
338       nbStatements += statementCountByBuildingPermit(buildingPermitIds[idx]);
339     }
340 
341     bytes32[] memory res = new bytes32[](nbStatements);
342 
343     uint statementIdx = 0;
344     for(uint idx = 0; idx < buildingPermitIds.length; idx++) {
345       nbStatements = statementCountByBuildingPermit(buildingPermitIds[idx]);
346       while(nbStatements > 0){
347         nbStatements--;
348         res[statementIdx] = computeStatementId(buildingPermitIds[idx],nbStatements);
349         statementIdx++;
350       }
351     }
352 
353     return res;
354   }
355 
356   /**********************/
357   /** INTERNAL - WRITE **/
358   /**********************/
359   function updateStatementCountByBuildingPermit(string memory buildingPermitId) internal {
360     uint oldCount = statementCountByBuildingPermitHash[keccak256(abi.encodePacked(buildingPermitId))];
361 
362     if(oldCount == 0) { // first record for this building permit id
363       buildingPermitIds.push(buildingPermitId);
364     }
365 
366     uint newCount = oldCount + 1;
367     assert(newCount > oldCount);
368     statementCountByBuildingPermitHash[keccak256(abi.encodePacked(buildingPermitId))] = newCount;
369   }
370 
371   function recordStatementKeyValues(
372     bytes32 statementId,
373     uint[] memory statementDataLayout,
374     bytes memory statementData) internal {
375     string[] memory infos = parseStatementStrings(statementDataLayout, statementData);
376 
377     require(infos.length == 11, "the statement key values array length is incorrect");
378 
379     /** enforce the rules given in the legal specifications **/
380     // required infos
381     require(!isEmpty(infos[0]) && !isEmpty(infos[1]), "acquisitionDate and pcId are required");
382     require(!isEmpty(infos[9]) && !isEmpty(infos[10]), "missing image");
383 
384     // < 2 missing non required info
385     uint nbMissingNRIs = (isEmpty(infos[2]) ? 1 : 0) + (isEmpty(infos[3]) ? 1 : 0) + (isEmpty(infos[4]) ? 1 : 0) + (isEmpty(infos[7]) ? 1 : 0);
386     require(nbMissingNRIs <= 2, "> 2 missing non required info");
387 
388     // mo missing mandatory info or one missing mandatory info and 0 missing non required info
389     uint nbMissingMIs = (isEmpty(infos[5]) ? 1 : 0) + (isEmpty(infos[6]) ? 1 : 0) + (isEmpty(infos[8]) ? 1 : 0);
390     require(nbMissingMIs == 0 || (nbMissingMIs == 1 && nbMissingNRIs == 0), "missing mandatory info");
391 
392     recordStatementString(statementId, "pcId", infos[0]);
393     recordStatementString(statementId, "acquisitionDate", infos[1]);
394     if(!isEmpty(infos[2])) recordStatementString(statementId, "recipient", infos[2]);
395     if(!isEmpty(infos[3])) recordStatementString(statementId, "architect", infos[3]);
396     if(!isEmpty(infos[4])) recordStatementString(statementId, "cityHall", infos[4]);
397     if(!isEmpty(infos[5])) recordStatementString(statementId, "maximumHeight", infos[5]);
398     if(!isEmpty(infos[6])) recordStatementString(statementId, "destination", infos[6]);
399     if(!isEmpty(infos[7])) recordStatementString(statementId, "siteArea", infos[7]);
400     if(!isEmpty(infos[8])) recordStatementString(statementId, "buildingArea", infos[8]);
401     recordStatementString(statementId, "nearImage", infos[9]);
402     recordStatementString(statementId, "farImage", infos[10]);
403   }
404 
405   function recordStatementString(bytes32 statementId, string memory key, string memory value) internal {
406     require(!dataStore.stringExists(keccak256(abi.encodePacked(statementId, key))), "Trying to write an existing key-value string pair");
407 
408     dataStore.createString(keccak256(abi.encodePacked(statementId,key)), value);
409   }
410 
411   /*********************/
412   /** INTERNAL - READ **/
413   /*********************/
414   function generateNewStatementId(string memory buildingPermitId) internal view returns (bytes32) {
415     uint nbStatements = statementCountByBuildingPermit(buildingPermitId);
416     return computeStatementId(buildingPermitId,nbStatements);
417   }
418 
419   function statementCountByBuildingPermit(string memory buildingPermitId) internal view returns (uint) {
420     return statementCountByBuildingPermitHash[keccak256(abi.encodePacked(buildingPermitId))]; // mapping's default is 0
421   }
422 
423   function computeStatementId(string memory buildingPermitId, uint statementNb) internal pure returns (bytes32) {
424     return keccak256(abi.encodePacked(buildingPermitId,statementNb));
425   }
426 
427   function parseStatementStrings(uint[] memory statementDataLayout, bytes memory statementData) internal pure returns(string[] memory) {
428     string[] memory res = new string[](statementDataLayout.length);
429     uint bytePos = 0;
430     uint resLength = res.length;
431     for(uint i = 0; i < resLength; i++) {
432       bytes memory strBytes = new bytes(statementDataLayout[i]);
433       uint strBytesLength = strBytes.length;
434       for(uint j = 0; j < strBytesLength; j++) {
435         strBytes[j] = statementData[bytePos];
436         bytePos++;
437       }
438       res[i] = string(strBytes);
439     }
440 
441     return res;
442   }
443 
444   function isEmpty(string memory s) internal pure returns(bool) {
445     return bytes(s).length == 0;
446   }
447 }