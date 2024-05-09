1 pragma solidity ^0.4.24;
2 
3 contract EternalStorage {
4 
5     /// @notice Internal mappings used to store all kinds on data into the contract
6     mapping(bytes32 => uint256) internal uintStorage;
7     mapping(bytes32 => string) internal stringStorage;
8     mapping(bytes32 => address) internal addressStorage;
9     mapping(bytes32 => bytes) internal bytesStorage;
10     mapping(bytes32 => bool) internal boolStorage;
11     mapping(bytes32 => int256) internal intStorage;
12     mapping(bytes32 => bytes32) internal bytes32Storage;
13 
14     /// @notice Internal mappings used to store arrays of different data types
15     mapping(bytes32 => bytes32[]) internal bytes32ArrayStorage;
16     mapping(bytes32 => uint256[]) internal uintArrayStorage;
17     mapping(bytes32 => address[]) internal addressArrayStorage;
18     mapping(bytes32 => string[]) internal stringArrayStorage;
19 
20     //////////////////
21     //// set functions
22     //////////////////
23     /// @notice Set the key values using the Overloaded `set` functions
24     /// Ex- string version = "0.0.1"; replace to
25     /// set(keccak256(abi.encodePacked("version"), "0.0.1");
26     /// same for the other variables as well some more example listed below
27     /// ex1 - address securityTokenAddress = 0x123; replace to
28     /// set(keccak256(abi.encodePacked("securityTokenAddress"), 0x123);
29     /// ex2 - bytes32 tokenDetails = "I am ST20"; replace to
30     /// set(keccak256(abi.encodePacked("tokenDetails"), "I am ST20");
31     /// ex3 - mapping(string => address) ownedToken;
32     /// set(keccak256(abi.encodePacked("ownedToken", "Chris")), 0x123);
33     /// ex4 - mapping(string => uint) tokenIndex;
34     /// tokenIndex["TOKEN"] = 1; replace to set(keccak256(abi.encodePacked("tokenIndex", "TOKEN"), 1);
35     /// ex5 - mapping(string => SymbolDetails) registeredSymbols; where SymbolDetails is the structure having different type of values as
36     /// {uint256 date, string name, address owner} etc.
37     /// registeredSymbols["TOKEN"].name = "MyFristToken"; replace to set(keccak256(abi.encodePacked("registeredSymbols_name", "TOKEN"), "MyFirstToken");
38     /// More generalized- set(keccak256(abi.encodePacked("registeredSymbols_<struct variable>", "keyname"), "value");
39 
40     function set(bytes32 _key, uint256 _value) internal {
41         uintStorage[_key] = _value;
42     }
43 
44     function set(bytes32 _key, address _value) internal {
45         addressStorage[_key] = _value;
46     }
47 
48     function set(bytes32 _key, bool _value) internal {
49         boolStorage[_key] = _value;
50     }
51 
52     function set(bytes32 _key, bytes32 _value) internal {
53         bytes32Storage[_key] = _value;
54     }
55 
56     function set(bytes32 _key, string _value) internal {
57         stringStorage[_key] = _value;
58     }
59 
60     ////////////////////
61     /// get functions
62     ////////////////////
63     /// @notice Get function use to get the value of the singleton state variables
64     /// Ex1- string public version = "0.0.1";
65     /// string _version = getString(keccak256(abi.encodePacked("version"));
66     /// Ex2 - assert(temp1 == temp2); replace to
67     /// assert(getUint(keccak256(abi.encodePacked(temp1)) == getUint(keccak256(abi.encodePacked(temp2));
68     /// Ex3 - mapping(string => SymbolDetails) registeredSymbols; where SymbolDetails is the structure having different type of values as
69     /// {uint256 date, string name, address owner} etc.
70     /// string _name = getString(keccak256(abi.encodePacked("registeredSymbols_name", "TOKEN"));
71 
72     function getBool(bytes32 _key) internal view returns (bool) {
73         return boolStorage[_key];
74     }
75 
76     function getUint(bytes32 _key) internal view returns (uint256) {
77         return uintStorage[_key];
78     }
79 
80     function getAddress(bytes32 _key) internal view returns (address) {
81         return addressStorage[_key];
82     }
83 
84     function getString(bytes32 _key) internal view returns (string) {
85         return stringStorage[_key];
86     }
87 
88     function getBytes32(bytes32 _key) internal view returns (bytes32) {
89         return bytes32Storage[_key];
90     }
91 
92 
93     ////////////////////////////
94     // deleteArray functions
95     ////////////////////////////
96     /// @notice Function used to delete the array element.
97     /// Ex1- mapping(address => bytes32[]) tokensOwnedByOwner;
98     /// For deleting the item from array developers needs to create a funtion for that similarly
99     /// in this case we have the helper function deleteArrayBytes32() which will do it for us
100     /// deleteArrayBytes32(keccak256(abi.encodePacked("tokensOwnedByOwner", 0x1), 3); -- it will delete the index 3
101 
102 
103     //Deletes from mapping (bytes32 => array[]) at index _index
104     function deleteArrayAddress(bytes32 _key, uint256 _index) internal {
105         address[] storage array = addressArrayStorage[_key];
106         require(_index < array.length, "Index should less than length of the array");
107         array[_index] = array[array.length - 1];
108         array.length = array.length - 1;
109     }
110 
111     //Deletes from mapping (bytes32 => bytes32[]) at index _index
112     function deleteArrayBytes32(bytes32 _key, uint256 _index) internal {
113         bytes32[] storage array = bytes32ArrayStorage[_key];
114         require(_index < array.length, "Index should less than length of the array");
115         array[_index] = array[array.length - 1];
116         array.length = array.length - 1;
117     }
118 
119     //Deletes from mapping (bytes32 => uint[]) at index _index
120     function deleteArrayUint(bytes32 _key, uint256 _index) internal {
121         uint256[] storage array = uintArrayStorage[_key];
122         require(_index < array.length, "Index should less than length of the array");
123         array[_index] = array[array.length - 1];
124         array.length = array.length - 1;
125     }
126 
127     //Deletes from mapping (bytes32 => string[]) at index _index
128     function deleteArrayString(bytes32 _key, uint256 _index) internal {
129         string[] storage array = stringArrayStorage[_key];
130         require(_index < array.length, "Index should less than length of the array");
131         array[_index] = array[array.length - 1];
132         array.length = array.length - 1;
133     }
134 
135     ////////////////////////////
136     //// pushArray functions
137     ///////////////////////////
138     /// @notice Below are the helper functions to facilitate storing arrays of different data types.
139     /// Ex1- mapping(address => bytes32[]) tokensOwnedByTicker;
140     /// tokensOwnedByTicker[owner] = tokensOwnedByTicker[owner].push("xyz"); replace with
141     /// pushArray(keccak256(abi.encodePacked("tokensOwnedByTicker", owner), "xyz");
142 
143     /// @notice use to store the values for the array
144     /// @param _key bytes32 type
145     /// @param _value [uint256, string, bytes32, address] any of the data type in array
146     function pushArray(bytes32 _key, address _value) internal {
147         addressArrayStorage[_key].push(_value);
148     }
149 
150     function pushArray(bytes32 _key, bytes32 _value) internal {
151         bytes32ArrayStorage[_key].push(_value);
152     }
153 
154     function pushArray(bytes32 _key, string _value) internal {
155         stringArrayStorage[_key].push(_value);
156     }
157 
158     function pushArray(bytes32 _key, uint256 _value) internal {
159         uintArrayStorage[_key].push(_value);
160     }
161 
162     /////////////////////////
163     //// Set Array functions
164     ////////////////////////
165     /// @notice used to intialize the array
166     /// Ex1- mapping (address => address[]) public reputation;
167     /// reputation[0x1] = new address[](0); It can be replaced as
168     /// setArray(hash('reputation', 0x1), new address[](0)); 
169     
170     function setArray(bytes32 _key, address[] _value) internal {
171         addressArrayStorage[_key] = _value;
172     }
173 
174     function setArray(bytes32 _key, uint256[] _value) internal {
175         uintArrayStorage[_key] = _value;
176     }
177 
178     function setArray(bytes32 _key, bytes32[] _value) internal {
179         bytes32ArrayStorage[_key] = _value;
180     }
181 
182     function setArray(bytes32 _key, string[] _value) internal {
183         stringArrayStorage[_key] = _value;
184     }
185 
186     /////////////////////////
187     /// getArray functions
188     /////////////////////////
189     /// @notice Get functions to get the array of the required data type
190     /// Ex1- mapping(address => bytes32[]) tokensOwnedByOwner;
191     /// getArrayBytes32(keccak256(abi.encodePacked("tokensOwnedByOwner", 0x1)); It return the bytes32 array
192     /// Ex2- uint256 _len =  tokensOwnedByOwner[0x1].length; replace with
193     /// getArrayBytes32(keccak256(abi.encodePacked("tokensOwnedByOwner", 0x1)).length;
194 
195     function getArrayAddress(bytes32 _key) internal view returns(address[]) {
196         return addressArrayStorage[_key];
197     }
198 
199     function getArrayBytes32(bytes32 _key) internal view returns(bytes32[]) {
200         return bytes32ArrayStorage[_key];
201     }
202 
203     function getArrayString(bytes32 _key) internal view returns(string[]) {
204         return stringArrayStorage[_key];
205     }
206 
207     function getArrayUint(bytes32 _key) internal view returns(uint[]) {
208         return uintArrayStorage[_key];
209     }
210 
211     ///////////////////////////////////
212     /// setArrayIndexValue() functions
213     ///////////////////////////////////
214     /// @notice set the value of particular index of the address array
215     /// Ex1- mapping(bytes32 => address[]) moduleList;
216     /// general way is -- moduleList[moduleType][index] = temp; 
217     /// It can be re-write as -- setArrayIndexValue(keccak256(abi.encodePacked('moduleList', moduleType)), index, temp); 
218 
219     function setArrayIndexValue(bytes32 _key, uint256 _index, address _value) internal {
220         addressArrayStorage[_key][_index] = _value;
221     }
222 
223     function setArrayIndexValue(bytes32 _key, uint256 _index, uint256 _value) internal {
224         uintArrayStorage[_key][_index] = _value;
225     }
226 
227     function setArrayIndexValue(bytes32 _key, uint256 _index, bytes32 _value) internal {
228         bytes32ArrayStorage[_key][_index] = _value;
229     }
230 
231     function setArrayIndexValue(bytes32 _key, uint256 _index, string _value) internal {
232         stringArrayStorage[_key][_index] = _value;
233     }
234 
235         /////////////////////////////
236         /// Public getters functions
237         /////////////////////////////
238 
239     function getUintValues(bytes32 _variable) public view returns(uint256) {
240         return uintStorage[_variable];
241     }
242 
243     function getBoolValues(bytes32 _variable) public view returns(bool) {
244         return boolStorage[_variable];
245     }
246 
247     function getStringValues(bytes32 _variable) public view returns(string) {
248         return stringStorage[_variable];
249     }
250 
251     function getAddressValues(bytes32 _variable) public view returns(address) {
252         return addressStorage[_variable];
253     }
254 
255     function getBytes32Values(bytes32 _variable) public view returns(bytes32) {
256         return bytes32Storage[_variable];
257     }
258 
259     function getBytesValues(bytes32 _variable) public view returns(bytes) {
260         return bytesStorage[_variable];
261     }
262 
263 }
264 
265 /**
266  * @title Proxy
267  * @dev Gives the possibility to delegate any call to a foreign implementation.
268  */
269 contract Proxy {
270 
271     /**
272     * @dev Tells the address of the implementation where every call will be delegated.
273     * @return address of the implementation to which it will be delegated
274     */
275     function _implementation() internal view returns (address);
276 
277     /**
278     * @dev Fallback function.
279     * Implemented entirely in `_fallback`.
280     */
281     function _fallback() internal {
282         _delegate(_implementation());
283     }
284 
285     /**
286     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
287     * This function will return whatever the implementation call returns
288     */
289     function _delegate(address implementation) internal {
290         /*solium-disable-next-line security/no-inline-assembly*/
291         assembly {
292             // Copy msg.data. We take full control of memory in this inline assembly
293             // block because it will not return to Solidity code. We overwrite the
294             // Solidity scratch pad at memory position 0.
295             calldatacopy(0, 0, calldatasize)
296 
297             // Call the implementation.
298             // out and outsize are 0 because we don't know the size yet.
299             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
300 
301             // Copy the returned data.
302             returndatacopy(0, 0, returndatasize)
303 
304             switch result
305             // delegatecall returns 0 on error.
306             case 0 { revert(0, returndatasize) }
307             default { return(0, returndatasize) }
308         }
309     }
310 
311     function () public payable {
312         _fallback();
313     }
314 }
315 
316 /**
317  * Utility library of inline functions on addresses
318  */
319 library AddressUtils {
320 
321   /**
322    * Returns whether the target address is a contract
323    * @dev This function will return false if invoked during the constructor of a contract,
324    *  as the code is not actually created until after the constructor finishes.
325    * @param addr address to check
326    * @return whether the target address is a contract
327    */
328   function isContract(address addr) internal view returns (bool) {
329     uint256 size;
330     // XXX Currently there is no better way to check if there is a contract in an address
331     // than to check the size of the code at that address.
332     // See https://ethereum.stackexchange.com/a/14016/36603
333     // for more details about how this works.
334     // TODO Check this again before the Serenity release, because all addresses will be
335     // contracts then.
336     // solium-disable-next-line security/no-inline-assembly
337     assembly { size := extcodesize(addr) }
338     return size > 0;
339   }
340 
341 }
342 
343 /**
344  * @title UpgradeabilityProxy
345  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
346  */
347 contract UpgradeabilityProxy is Proxy {
348 
349     // Version name of the current implementation
350     string internal __version;
351 
352     // Address of the current implementation
353     address internal __implementation;
354 
355     /**
356     * @dev This event will be emitted every time the implementation gets upgraded
357     * @param _newVersion representing the version name of the upgraded implementation
358     * @param _newImplementation representing the address of the upgraded implementation
359     */
360     event Upgraded(string _newVersion, address indexed _newImplementation);
361 
362     /**
363     * @dev Upgrades the implementation address
364     * @param _newVersion representing the version name of the new implementation to be set
365     * @param _newImplementation representing the address of the new implementation to be set
366     */
367     function _upgradeTo(string _newVersion, address _newImplementation) internal {
368         require(
369             __implementation != _newImplementation && _newImplementation != address(0),
370             "Old address is not allowed and implementation address should not be 0x"
371         );
372         require(AddressUtils.isContract(_newImplementation), "Cannot set a proxy implementation to a non-contract address");
373         require(bytes(_newVersion).length > 0, "Version should not be empty string");
374         require(keccak256(abi.encodePacked(__version)) != keccak256(abi.encodePacked(_newVersion)), "New version equals to current");
375         __version = _newVersion;
376         __implementation = _newImplementation;
377         emit Upgraded(_newVersion, _newImplementation);
378     }
379 
380 }
381 
382 /**
383  * @title OwnedUpgradeabilityProxy
384  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
385  */
386 contract OwnedUpgradeabilityProxy is UpgradeabilityProxy {
387 
388     // Owner of the contract
389     address private __upgradeabilityOwner;
390 
391     /**
392     * @dev Event to show ownership has been transferred
393     * @param _previousOwner representing the address of the previous owner
394     * @param _newOwner representing the address of the new owner
395     */
396     event ProxyOwnershipTransferred(address _previousOwner, address _newOwner);
397 
398     /**
399     * @dev Throws if called by any account other than the owner.
400     */
401     modifier ifOwner() {
402         if (msg.sender == _upgradeabilityOwner()) {
403             _;
404         } else {
405             _fallback();
406         }
407     }
408 
409     /**
410     * @dev the constructor sets the original owner of the contract to the sender account.
411     */
412     constructor() public {
413         _setUpgradeabilityOwner(msg.sender);
414     }
415 
416     /**
417     * @dev Tells the address of the owner
418     * @return the address of the owner
419     */
420     function _upgradeabilityOwner() internal view returns (address) {
421         return __upgradeabilityOwner;
422     }
423 
424     /**
425     * @dev Sets the address of the owner
426     */
427     function _setUpgradeabilityOwner(address _newUpgradeabilityOwner) internal {
428         require(_newUpgradeabilityOwner != address(0), "Address should not be 0x");
429         __upgradeabilityOwner = _newUpgradeabilityOwner;
430     }
431 
432     /**
433     * @notice Internal function to provide the address of the implementation contract
434     */
435     function _implementation() internal view returns (address) {
436         return __implementation;
437     }
438 
439     /**
440     * @dev Tells the address of the proxy owner
441     * @return the address of the proxy owner
442     */
443     function proxyOwner() external ifOwner returns (address) {
444         return _upgradeabilityOwner();
445     }
446 
447     /**
448     * @dev Tells the version name of the current implementation
449     * @return string representing the name of the current version
450     */
451     function version() external ifOwner returns (string) {
452         return __version;
453     }
454 
455     /**
456     * @dev Tells the address of the current implementation
457     * @return address of the current implementation
458     */
459     function implementation() external ifOwner returns (address) {
460         return _implementation();
461     }
462 
463     /**
464     * @dev Allows the current owner to transfer control of the contract to a newOwner.
465     * @param _newOwner The address to transfer ownership to.
466     */
467     function transferProxyOwnership(address _newOwner) external ifOwner {
468         require(_newOwner != address(0), "Address should not be 0x");
469         emit ProxyOwnershipTransferred(_upgradeabilityOwner(), _newOwner);
470         _setUpgradeabilityOwner(_newOwner);
471     }
472 
473     /**
474     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
475     * @param _newVersion representing the version name of the new implementation to be set.
476     * @param _newImplementation representing the address of the new implementation to be set.
477     */
478     function upgradeTo(string _newVersion, address _newImplementation) external ifOwner {
479         _upgradeTo(_newVersion, _newImplementation);
480     }
481 
482     /**
483     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
484     * to initialize whatever is needed through a low level call.
485     * @param _newVersion representing the version name of the new implementation to be set.
486     * @param _newImplementation representing the address of the new implementation to be set.
487     * @param _data represents the msg.data to bet sent in the low level call. This parameter may include the function
488     * signature of the implementation to be called with the needed payload
489     */
490     function upgradeToAndCall(string _newVersion, address _newImplementation, bytes _data) external payable ifOwner {
491         _upgradeTo(_newVersion, _newImplementation);
492         /*solium-disable-next-line security/no-call-value*/
493         require(address(this).call.value(msg.value)(_data), "Fail in executing the function of implementation contract");
494     }
495 
496 }
497 
498 /**
499  * @title SecurityTokenRegistryProxy
500  * @dev This proxy holds the storage of the SecurityTokenRegistry contract and delegates every call to the current implementation set.
501  * Besides, it allows to upgrade the SecurityTokenRegistry's behaviour towards further implementations, and provides basic
502  * authorization control functionalities
503  */
504 /*solium-disable-next-line no-empty-blocks*/
505 contract SecurityTokenRegistryProxy is EternalStorage, OwnedUpgradeabilityProxy {
506 
507 }