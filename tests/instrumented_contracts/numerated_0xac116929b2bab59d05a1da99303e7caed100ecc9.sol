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
19 
20     mapping(bytes32 => uint256[]) internal uintArrayStorage;
21     mapping(bytes32 => string[]) internal stringArrayStorage;
22     mapping(bytes32 => address[]) internal addressArrayStorage;
23     //mapping(bytes32 => bytes[]) internal bytesArrayStorage;
24     mapping(bytes32 => bool[]) internal boolArrayStorage;
25     mapping(bytes32 => int256[]) internal intArrayStorage;
26     mapping(bytes32 => bytes32[]) internal bytes32ArrayStorage;
27 }
28 
29 // File: contracts/upgradeability/Proxy.sol
30 
31 pragma solidity 0.4.24;
32 
33 
34 /**
35  * @title Proxy
36  * @dev Gives the possibility to delegate any call to a foreign implementation.
37  */
38 contract Proxy {
39 
40   /**
41   * @dev Tells the address of the implementation where every call will be delegated.
42   * @return address of the implementation to which it will be delegated
43   */
44     function implementation() public view returns (address);
45 
46     function setImplementation(address _newImplementation) external;
47 
48   /**
49   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
50   * This function will return whatever the implementation call returns
51   */
52     function () payable public {
53         address _impl = implementation();
54         require(_impl != address(0));
55 
56         address _innerImpl;
57         bytes4 sig;
58         address thisAddress = address(this);
59         if (_impl.call(0x5c60da1b)) { // bytes(keccak256("implementation()"))
60             _innerImpl = Proxy(_impl).implementation();
61             this.setImplementation(_innerImpl);
62             sig = 0xd784d426; // bytes4(keccak256("setImplementation(address)"))
63         }
64 
65         assembly {
66             /*
67                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
68                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
69                 memory. It's needed because we're going to write the return data of delegatecall to the
70                 free memory slot.
71             */
72             let ptr := mload(0x40)
73             /*
74                 `calldatacopy` is copy calldatasize bytes from calldata
75                 First argument is the destination to which data is copied(ptr)
76                 Second argument specifies the start position of the copied data.
77                     Since calldata is sort of its own unique location in memory,
78                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
79                     That's always going to be the zeroth byte of the function selector.
80                 Third argument, calldatasize, specifies how much data will be copied.
81                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
82             */
83             calldatacopy(ptr, 0, calldatasize)
84             /*
85                 delegatecall params explained:
86                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
87                     us the amount of gas still available to execution
88 
89                 _impl: address of the contract to delegate to
90 
91                 ptr: to pass copied data
92 
93                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
94 
95                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
96                         these are set to 0, 0 so the output data will not be written to memory. The output
97                         data will be read using `returndatasize` and `returdatacopy` instead.
98 
99                 result: This will be 0 if the call fails and 1 if it succeeds
100             */
101             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
102             /*
103 
104             */
105             /*
106                 ptr current points to the value stored at 0x40,
107                 because we assigned it like ptr := mload(0x40).
108                 Because we use 0x40 as a free memory pointer,
109                 we want to make sure that the next time we want to allocate memory,
110                 we aren't overwriting anything important.
111                 So, by adding ptr and returndatasize,
112                 we get a memory location beyond the end of the data we will be copying to ptr.
113                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
114             */
115             mstore(0x40, add(ptr, returndatasize))
116             /*
117                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
118                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
119                     the amount of data to copy.
120                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
121             */
122             returndatacopy(ptr, 0, returndatasize)
123 
124             let retdatasize := returndatasize
125 
126             switch sig
127             case 0 {}
128             default {
129                 let x := mload(0x40)
130                 mstore(x, sig)
131                 mstore(add(x, 0x04), _impl)
132                 let success := call(gas, thisAddress, 0, x, 0x24, x, 0x0)
133             }
134 
135             /*
136                 if `result` is 0, revert.
137                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
138                 copied to `ptr` from the delegatecall return data
139             */
140             switch result
141             case 0 { revert(ptr, retdatasize) }
142             default { return(ptr, retdatasize) }
143         }
144     }
145 }
146 
147 // File: contracts/upgradeability/UpgradeabilityStorage.sol
148 
149 pragma solidity 0.4.24;
150 
151 
152 /**
153  * @title UpgradeabilityStorage
154  * @dev This contract holds all the necessary state variables to support the upgrade functionality
155  */
156 contract UpgradeabilityStorage {
157     // Version name of the current implementation
158     uint256 internal _version;
159 
160     // Address of the current implementation
161     address internal _implementation;
162 
163     /**
164     * @dev Tells the version name of the current implementation
165     * @return string representing the name of the current version
166     */
167     function version() public view returns (uint256) {
168         return _version;
169     }
170 
171     /**
172     * @dev Tells the address of the current implementation
173     * @return address of the current implementation
174     */
175     function implementation() public view returns (address) {
176         return _implementation;
177     }
178 
179     function setImplementation(address _newImplementation) external {
180         require(msg.sender == address(this));
181         _implementation = _newImplementation;
182     }
183 }
184 
185 // File: contracts/upgradeability/UpgradeabilityProxy.sol
186 
187 pragma solidity 0.4.24;
188 
189 
190 
191 
192 /**
193  * @title UpgradeabilityProxy
194  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
195  */
196 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
197     /**
198     * @dev This event will be emitted every time the implementation gets upgraded
199     * @param version representing the version name of the upgraded implementation
200     * @param implementation representing the address of the upgraded implementation
201     */
202     event Upgraded(uint256 version, address indexed implementation);
203 
204     /**
205     * @dev Upgrades the implementation address
206     * @param version representing the version name of the new implementation to be set
207     * @param implementation representing the address of the new implementation to be set
208     */
209     function _upgradeTo(uint256 version, address implementation) internal {
210         require(_implementation != implementation);
211         require(version > _version);
212         _version = version;
213         _implementation = implementation;
214         emit Upgraded(version, implementation);
215     }
216 }
217 
218 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
219 
220 pragma solidity 0.4.24;
221 
222 
223 /**
224  * @title UpgradeabilityOwnerStorage
225  * @dev This contract keeps track of the upgradeability owner
226  */
227 contract UpgradeabilityOwnerStorage {
228     // Owner of the contract
229     address private _upgradeabilityOwner;
230 
231     /**
232     * @dev Tells the address of the owner
233     * @return the address of the owner
234     */
235     function upgradeabilityOwner() public view returns (address) {
236         return _upgradeabilityOwner;
237     }
238 
239     /**
240     * @dev Sets the address of the owner
241     */
242     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
243         _upgradeabilityOwner = newUpgradeabilityOwner;
244     }
245 }
246 
247 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
248 
249 pragma solidity 0.4.24;
250 
251 
252 
253 
254 /**
255  * @title OwnedUpgradeabilityProxy
256  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
257  */
258 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
259   /**
260   * @dev Event to show ownership has been transferred
261   * @param previousOwner representing the address of the previous owner
262   * @param newOwner representing the address of the new owner
263   */
264     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
265 
266     /**
267     * @dev the constructor sets the original owner of the contract to the sender account.
268     */
269     constructor() public {
270         setUpgradeabilityOwner(msg.sender);
271     }
272 
273     /**
274     * @dev Throws if called by any account other than the owner.
275     */
276     modifier onlyProxyOwner() {
277         require(msg.sender == proxyOwner());
278         _;
279     }
280 
281     /**
282     * @dev Tells the address of the proxy owner
283     * @return the address of the proxy owner
284     */
285     function proxyOwner() public view returns (address) {
286         return upgradeabilityOwner();
287     }
288 
289     /**
290     * @dev Allows the current owner to transfer control of the contract to a newOwner.
291     * @param newOwner The address to transfer ownership to.
292     */
293     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
294         require(newOwner != address(0));
295         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
296         setUpgradeabilityOwner(newOwner);
297     }
298 
299     /**
300     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
301     * @param version representing the version name of the new implementation to be set.
302     * @param implementation representing the address of the new implementation to be set.
303     */
304     function upgradeTo(uint256 version, address implementation) public onlyProxyOwner {
305         _upgradeTo(version, implementation);
306     }
307 
308     /**
309     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
310     * to initialize whatever is needed through a low level call.
311     * @param version representing the version name of the new implementation to be set.
312     * @param implementation representing the address of the new implementation to be set.
313     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
314     * signature of the implementation to be called with the needed payload
315     */
316     function upgradeToAndCall(uint256 version, address implementation, bytes data) payable public onlyProxyOwner {
317         upgradeTo(version, implementation);
318         require(address(this).call.value(msg.value)(data));
319     }
320 }
321 
322 // File: contracts/upgradeability/EternalStorageProxy.sol
323 
324 pragma solidity 0.4.24;
325 
326 
327 
328 
329 /**
330  * @title EternalStorageProxy
331  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
332  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
333  * authorization control functionalities
334  */
335 contract EternalStorageProxy is OwnedUpgradeabilityProxy, EternalStorage {}