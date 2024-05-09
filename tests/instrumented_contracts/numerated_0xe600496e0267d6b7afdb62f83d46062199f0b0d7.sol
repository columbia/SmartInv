1 pragma solidity 0.4.24;
2 
3 // File: contracts/upgradeability/EternalStorage.sol
4 
5 /**
6  * @title EternalStorage
7  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
8  */
9 contract EternalStorage {
10 
11     mapping(bytes32 => uint256) internal uintStorage;
12     mapping(bytes32 => string) internal stringStorage;
13     mapping(bytes32 => address) internal addressStorage;
14     mapping(bytes32 => bytes) internal bytesStorage;
15     mapping(bytes32 => bool) internal boolStorage;
16     mapping(bytes32 => int256) internal intStorage;
17 
18 
19     mapping(bytes32 => uint256[]) internal uintArrayStorage;
20     mapping(bytes32 => string[]) internal stringArrayStorage;
21     mapping(bytes32 => address[]) internal addressArrayStorage;
22     //mapping(bytes32 => bytes[]) internal bytesArrayStorage;
23     mapping(bytes32 => bool[]) internal boolArrayStorage;
24     mapping(bytes32 => int256[]) internal intArrayStorage;
25     mapping(bytes32 => bytes32[]) internal bytes32ArrayStorage;
26 }
27 
28 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
29 
30 /**
31  * @title UpgradeabilityOwnerStorage
32  * @dev This contract keeps track of the upgradeability owner
33  */
34 contract UpgradeabilityOwnerStorage {
35     // Owner of the contract
36     address private _upgradeabilityOwner;
37 
38     /**
39     * @dev Tells the address of the owner
40     * @return the address of the owner
41     */
42     function upgradeabilityOwner() public view returns (address) {
43         return _upgradeabilityOwner;
44     }
45 
46     /**
47     * @dev Sets the address of the owner
48     */
49     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
50         _upgradeabilityOwner = newUpgradeabilityOwner;
51     }
52 }
53 
54 // File: contracts/upgradeability/Proxy.sol
55 
56 /**
57  * @title Proxy
58  * @dev Gives the possibility to delegate any call to a foreign implementation.
59  */
60 contract Proxy {
61 
62   /**
63   * @dev Tells the address of the implementation where every call will be delegated.
64   * @return address of the implementation to which it will be delegated
65   */
66     function implementation() public view returns (address);
67 
68     function setImplementation(address _newImplementation) external;
69 
70   /**
71   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
72   * This function will return whatever the implementation call returns
73   */
74     function () payable public {
75         address _impl = implementation();
76         require(_impl != address(0));
77 
78         address _innerImpl;
79         bytes4 sig;
80         address thisAddress = address(this);
81         if (_impl.call(0x5c60da1b)) { // bytes(keccak256("implementation()"))
82             _innerImpl = Proxy(_impl).implementation();
83             this.setImplementation(_innerImpl);
84             sig = 0xd784d426; // bytes4(keccak256("setImplementation(address)"))
85         }
86 
87         assembly {
88             /*
89                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
90                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
91                 memory. It's needed because we're going to write the return data of delegatecall to the
92                 free memory slot.
93             */
94             let ptr := mload(0x40)
95             /*
96                 `calldatacopy` is copy calldatasize bytes from calldata
97                 First argument is the destination to which data is copied(ptr)
98                 Second argument specifies the start position of the copied data.
99                     Since calldata is sort of its own unique location in memory,
100                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
101                     That's always going to be the zeroth byte of the function selector.
102                 Third argument, calldatasize, specifies how much data will be copied.
103                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
104             */
105             calldatacopy(ptr, 0, calldatasize)
106             /*
107                 delegatecall params explained:
108                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
109                     us the amount of gas still available to execution
110 
111                 _impl: address of the contract to delegate to
112 
113                 ptr: to pass copied data
114 
115                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
116 
117                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
118                         these are set to 0, 0 so the output data will not be written to memory. The output
119                         data will be read using `returndatasize` and `returdatacopy` instead.
120 
121                 result: This will be 0 if the call fails and 1 if it succeeds
122             */
123             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
124             /*
125 
126             */
127             /*
128                 ptr current points to the value stored at 0x40,
129                 because we assigned it like ptr := mload(0x40).
130                 Because we use 0x40 as a free memory pointer,
131                 we want to make sure that the next time we want to allocate memory,
132                 we aren't overwriting anything important.
133                 So, by adding ptr and returndatasize,
134                 we get a memory location beyond the end of the data we will be copying to ptr.
135                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
136             */
137             mstore(0x40, add(ptr, returndatasize))
138             /*
139                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
140                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
141                     the amount of data to copy.
142                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
143             */
144             returndatacopy(ptr, 0, returndatasize)
145 
146             let retdatasize := returndatasize
147 
148             switch sig
149             case 0 {}
150             default {
151                 let x := mload(0x40)
152                 mstore(x, sig)
153                 mstore(add(x, 0x04), _impl)
154                 let success := call(gas, thisAddress, 0, x, 0x24, x, 0x0)
155             }
156 
157             /*
158                 if `result` is 0, revert.
159                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
160                 copied to `ptr` from the delegatecall return data
161             */
162             switch result
163             case 0 { revert(ptr, retdatasize) }
164             default { return(ptr, retdatasize) }
165         }
166     }
167 }
168 
169 // File: contracts/upgradeability/UpgradeabilityStorage.sol
170 
171 /**
172  * @title UpgradeabilityStorage
173  * @dev This contract holds all the necessary state variables to support the upgrade functionality
174  */
175 contract UpgradeabilityStorage {
176     // Version name of the current implementation
177     uint256 internal _version;
178 
179     // Address of the current implementation
180     address internal _implementation;
181 
182     /**
183     * @dev Tells the version name of the current implementation
184     * @return string representing the name of the current version
185     */
186     function version() public view returns (uint256) {
187         return _version;
188     }
189 
190     /**
191     * @dev Tells the address of the current implementation
192     * @return address of the current implementation
193     */
194     function implementation() public view returns (address) {
195         return _implementation;
196     }
197 
198     function setImplementation(address _newImplementation) external {
199         require(msg.sender == address(this));
200         _implementation = _newImplementation;
201     }
202 }
203 
204 // File: contracts/upgradeability/UpgradeabilityProxy.sol
205 
206 /**
207  * @title UpgradeabilityProxy
208  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
209  */
210 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
211     /**
212     * @dev This event will be emitted every time the implementation gets upgraded
213     * @param version representing the version name of the upgraded implementation
214     * @param implementation representing the address of the upgraded implementation
215     */
216     event Upgraded(uint256 version, address indexed implementation);
217 
218     /**
219     * @dev Upgrades the implementation address
220     * @param version representing the version name of the new implementation to be set
221     * @param implementation representing the address of the new implementation to be set
222     */
223     function _upgradeTo(uint256 version, address implementation) internal {
224         require(_implementation != implementation);
225         require(version > _version);
226         _version = version;
227         _implementation = implementation;
228         emit Upgraded(version, implementation);
229     }
230 }
231 
232 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
233 
234 /**
235  * @title OwnedUpgradeabilityProxy
236  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
237  */
238 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
239   /**
240   * @dev Event to show ownership has been transferred
241   * @param previousOwner representing the address of the previous owner
242   * @param newOwner representing the address of the new owner
243   */
244     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
245 
246     /**
247     * @dev the constructor sets the original owner of the contract to the sender account.
248     */
249     constructor() public {
250         setUpgradeabilityOwner(msg.sender);
251     }
252 
253     /**
254     * @dev Throws if called by any account other than the owner.
255     */
256     modifier onlyProxyOwner() {
257         require(msg.sender == proxyOwner());
258         _;
259     }
260 
261     /**
262     * @dev Tells the address of the proxy owner
263     * @return the address of the proxy owner
264     */
265     function proxyOwner() public view returns (address) {
266         return upgradeabilityOwner();
267     }
268 
269     /**
270     * @dev Allows the current owner to transfer control of the contract to a newOwner.
271     * @param newOwner The address to transfer ownership to.
272     */
273     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
274         require(newOwner != address(0));
275         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
276         setUpgradeabilityOwner(newOwner);
277     }
278 
279     /**
280     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
281     * @param version representing the version name of the new implementation to be set.
282     * @param implementation representing the address of the new implementation to be set.
283     */
284     function upgradeTo(uint256 version, address implementation) public onlyProxyOwner {
285         _upgradeTo(version, implementation);
286     }
287 
288     /**
289     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
290     * to initialize whatever is needed through a low level call.
291     * @param version representing the version name of the new implementation to be set.
292     * @param implementation representing the address of the new implementation to be set.
293     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
294     * signature of the implementation to be called with the needed payload
295     */
296     function upgradeToAndCall(uint256 version, address implementation, bytes data) payable public onlyProxyOwner {
297         upgradeTo(version, implementation);
298         require(address(this).call.value(msg.value)(data));
299     }
300 }
301 
302 // File: contracts/upgradeability/EternalStorageProxy.sol
303 
304 /**
305  * @title EternalStorageProxy
306  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
307  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
308  * authorization control functionalities
309  */
310 contract EternalStorageProxy is OwnedUpgradeabilityProxy, EternalStorage {}