1 // File: contracts/upgradeability/EternalStorage.sol
2 
3 pragma solidity 0.4.24;
4 
5 
6 /**
7  * @title EternalStorage
8  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
9  */
10 contract EternalStorage {
11 
12     mapping(bytes32 => uint256) internal uintStorage;
13     mapping(bytes32 => string) internal stringStorage;
14     mapping(bytes32 => address) internal addressStorage;
15     mapping(bytes32 => bytes) internal bytesStorage;
16     mapping(bytes32 => bool) internal boolStorage;
17     mapping(bytes32 => int256) internal intStorage;
18 
19 }
20 
21 // File: contracts/upgradeability/Proxy.sol
22 
23 pragma solidity 0.4.24;
24 
25 
26 /**
27  * @title Proxy
28  * @dev Gives the possibility to delegate any call to a foreign implementation.
29  */
30 contract Proxy {
31 
32   /**
33   * @dev Tells the address of the implementation where every call will be delegated.
34   * @return address of the implementation to which it will be delegated
35   */
36     function implementation() public view returns (address);
37 
38   /**
39   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
40   * This function will return whatever the implementation call returns
41   */
42     function () payable public {
43         address _impl = implementation();
44         require(_impl != address(0));
45         assembly {
46             /*
47                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
48                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
49                 memory. It's needed because we're going to write the return data of delegatecall to the
50                 free memory slot.
51             */
52             let ptr := mload(0x40)
53             /*
54                 `calldatacopy` is copy calldatasize bytes from calldata
55                 First argument is the destination to which data is copied(ptr)
56                 Second argument specifies the start position of the copied data.
57                     Since calldata is sort of its own unique location in memory,
58                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
59                     That's always going to be the zeroth byte of the function selector.
60                 Third argument, calldatasize, specifies how much data will be copied.
61                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
62             */
63             calldatacopy(ptr, 0, calldatasize)
64             /*
65                 delegatecall params explained:
66                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
67                     us the amount of gas still available to execution
68 
69                 _impl: address of the contract to delegate to
70 
71                 ptr: to pass copied data
72 
73                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
74 
75                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
76                         these are set to 0, 0 so the output data will not be written to memory. The output
77                         data will be read using `returndatasize` and `returdatacopy` instead.
78 
79                 result: This will be 0 if the call fails and 1 if it succeeds
80             */
81             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
82             /*
83 
84             */
85             /*
86                 ptr current points to the value stored at 0x40,
87                 because we assigned it like ptr := mload(0x40).
88                 Because we use 0x40 as a free memory pointer,
89                 we want to make sure that the next time we want to allocate memory,
90                 we aren't overwriting anything important.
91                 So, by adding ptr and returndatasize,
92                 we get a memory location beyond the end of the data we will be copying to ptr.
93                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
94             */
95             mstore(0x40, add(ptr, returndatasize))
96             /*
97                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
98                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
99                     the amount of data to copy.
100                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
101             */
102             returndatacopy(ptr, 0, returndatasize)
103 
104             /*
105                 if `result` is 0, revert.
106                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
107                 copied to `ptr` from the delegatecall return data
108             */
109             switch result
110             case 0 { revert(ptr, returndatasize) }
111             default { return(ptr, returndatasize) }
112         }
113     }
114 }
115 
116 // File: contracts/upgradeability/UpgradeabilityStorage.sol
117 
118 pragma solidity 0.4.24;
119 
120 
121 /**
122  * @title UpgradeabilityStorage
123  * @dev This contract holds all the necessary state variables to support the upgrade functionality
124  */
125 contract UpgradeabilityStorage {
126     // Version name of the current implementation
127     uint256 internal _version;
128 
129     // Address of the current implementation
130     address internal _implementation;
131 
132     /**
133     * @dev Tells the version name of the current implementation
134     * @return string representing the name of the current version
135     */
136     function version() public view returns (uint256) {
137         return _version;
138     }
139 
140     /**
141     * @dev Tells the address of the current implementation
142     * @return address of the current implementation
143     */
144     function implementation() public view returns (address) {
145         return _implementation;
146     }
147 }
148 
149 // File: contracts/upgradeability/UpgradeabilityProxy.sol
150 
151 pragma solidity 0.4.24;
152 
153 
154 
155 
156 /**
157  * @title UpgradeabilityProxy
158  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
159  */
160 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
161     /**
162     * @dev This event will be emitted every time the implementation gets upgraded
163     * @param version representing the version name of the upgraded implementation
164     * @param implementation representing the address of the upgraded implementation
165     */
166     event Upgraded(uint256 version, address indexed implementation);
167 
168     /**
169     * @dev Upgrades the implementation address
170     * @param version representing the version name of the new implementation to be set
171     * @param implementation representing the address of the new implementation to be set
172     */
173     function _upgradeTo(uint256 version, address implementation) internal {
174         require(_implementation != implementation);
175         require(version > _version);
176         _version = version;
177         _implementation = implementation;
178         emit Upgraded(version, implementation);
179     }
180 }
181 
182 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
183 
184 pragma solidity 0.4.24;
185 
186 
187 /**
188  * @title UpgradeabilityOwnerStorage
189  * @dev This contract keeps track of the upgradeability owner
190  */
191 contract UpgradeabilityOwnerStorage {
192     // Owner of the contract
193     address private _upgradeabilityOwner;
194 
195     /**
196     * @dev Tells the address of the owner
197     * @return the address of the owner
198     */
199     function upgradeabilityOwner() public view returns (address) {
200         return _upgradeabilityOwner;
201     }
202 
203     /**
204     * @dev Sets the address of the owner
205     */
206     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
207         _upgradeabilityOwner = newUpgradeabilityOwner;
208     }
209 }
210 
211 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
212 
213 pragma solidity 0.4.24;
214 
215 
216 
217 
218 /**
219  * @title OwnedUpgradeabilityProxy
220  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
221  */
222 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
223   /**
224   * @dev Event to show ownership has been transferred
225   * @param previousOwner representing the address of the previous owner
226   * @param newOwner representing the address of the new owner
227   */
228     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
229 
230     /**
231     * @dev the constructor sets the original owner of the contract to the sender account.
232     */
233     constructor() public {
234         setUpgradeabilityOwner(msg.sender);
235     }
236 
237     /**
238     * @dev Throws if called by any account other than the owner.
239     */
240     modifier onlyProxyOwner() {
241         require(msg.sender == proxyOwner());
242         _;
243     }
244 
245     /**
246     * @dev Tells the address of the proxy owner
247     * @return the address of the proxy owner
248     */
249     function proxyOwner() public view returns (address) {
250         return upgradeabilityOwner();
251     }
252 
253     /**
254     * @dev Allows the current owner to transfer control of the contract to a newOwner.
255     * @param newOwner The address to transfer ownership to.
256     */
257     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
258         require(newOwner != address(0));
259         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
260         setUpgradeabilityOwner(newOwner);
261     }
262 
263     /**
264     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
265     * @param version representing the version name of the new implementation to be set.
266     * @param implementation representing the address of the new implementation to be set.
267     */
268     function upgradeTo(uint256 version, address implementation) public onlyProxyOwner {
269         _upgradeTo(version, implementation);
270     }
271 
272     /**
273     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
274     * to initialize whatever is needed through a low level call.
275     * @param version representing the version name of the new implementation to be set.
276     * @param implementation representing the address of the new implementation to be set.
277     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
278     * signature of the implementation to be called with the needed payload
279     */
280     function upgradeToAndCall(uint256 version, address implementation, bytes data) payable public onlyProxyOwner {
281         upgradeTo(version, implementation);
282         require(address(this).call.value(msg.value)(data));
283     }
284 }
285 
286 // File: contracts/upgradeability/EternalStorageProxy.sol
287 
288 pragma solidity 0.4.24;
289 
290 
291 
292 
293 /**
294  * @title EternalStorageProxy
295  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
296  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
297  * authorization control functionalities
298  */
299 contract EternalStorageProxy is OwnedUpgradeabilityProxy, EternalStorage {}