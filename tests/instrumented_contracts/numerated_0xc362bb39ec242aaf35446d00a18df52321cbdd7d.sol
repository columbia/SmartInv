1 /**
2  *Submitted for verification at Etherscan.io on 2018-10-18
3 */
4 
5 pragma solidity 0.4.24;
6 
7 // File: contracts/upgradeability/EternalStorage.sol
8 
9 /**
10  * @title EternalStorage
11  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
12  */
13 contract EternalStorage {
14 
15     mapping(bytes32 => uint256) internal uintStorage;
16     mapping(bytes32 => string) internal stringStorage;
17     mapping(bytes32 => address) internal addressStorage;
18     mapping(bytes32 => bytes) internal bytesStorage;
19     mapping(bytes32 => bool) internal boolStorage;
20     mapping(bytes32 => int256) internal intStorage;
21 
22 }
23 
24 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
25 
26 /**
27  * @title UpgradeabilityOwnerStorage
28  * @dev This contract keeps track of the upgradeability owner
29  */
30 contract UpgradeabilityOwnerStorage {
31     // Owner of the contract
32     address private _upgradeabilityOwner;
33 
34     /**
35     * @dev Tells the address of the owner
36     * @return the address of the owner
37     */
38     function upgradeabilityOwner() public view returns (address) {
39         return _upgradeabilityOwner;
40     }
41 
42     /**
43     * @dev Sets the address of the owner
44     */
45     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
46         _upgradeabilityOwner = newUpgradeabilityOwner;
47     }
48 }
49 
50 // File: contracts/upgradeability/Proxy.sol
51 
52 /**
53  * @title Proxy
54  * @dev Gives the possibility to delegate any call to a foreign implementation.
55  */
56 contract Proxy {
57 
58   /**
59   * @dev Tells the address of the implementation where every call will be delegated.
60   * @return address of the implementation to which it will be delegated
61   */
62     function implementation() public view returns (address);
63 
64   /**
65   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
66   * This function will return whatever the implementation call returns
67   */
68     function () payable public {
69         address _impl = implementation();
70         require(_impl != address(0));
71         assembly {
72             /*
73                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
74                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
75                 memory. It's needed because we're going to write the return data of delegatecall to the
76                 free memory slot.
77             */
78             let ptr := mload(0x40)
79             /*
80                 `calldatacopy` is copy calldatasize bytes from calldata
81                 First argument is the destination to which data is copied(ptr)
82                 Second argument specifies the start position of the copied data.
83                     Since calldata is sort of its own unique location in memory,
84                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
85                     That's always going to be the zeroth byte of the function selector.
86                 Third argument, calldatasize, specifies how much data will be copied.
87                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
88             */
89             calldatacopy(ptr, 0, calldatasize)
90             /*
91                 delegatecall params explained:
92                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
93                     us the amount of gas still available to execution
94 
95                 _impl: address of the contract to delegate to
96 
97                 ptr: to pass copied data
98 
99                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
100 
101                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
102                         these are set to 0, 0 so the output data will not be written to memory. The output
103                         data will be read using `returndatasize` and `returdatacopy` instead.
104 
105                 result: This will be 0 if the call fails and 1 if it succeeds
106             */
107             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
108             /*
109 
110             */
111             /*
112                 ptr current points to the value stored at 0x40,
113                 because we assigned it like ptr := mload(0x40).
114                 Because we use 0x40 as a free memory pointer,
115                 we want to make sure that the next time we want to allocate memory,
116                 we aren't overwriting anything important.
117                 So, by adding ptr and returndatasize,
118                 we get a memory location beyond the end of the data we will be copying to ptr.
119                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
120             */
121             mstore(0x40, add(ptr, returndatasize))
122             /*
123                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
124                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
125                     the amount of data to copy.
126                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
127             */
128             returndatacopy(ptr, 0, returndatasize)
129 
130             /*
131                 if `result` is 0, revert.
132                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
133                 copied to `ptr` from the delegatecall return data
134             */
135             switch result
136             case 0 { revert(ptr, returndatasize) }
137             default { return(ptr, returndatasize) }
138         }
139     }
140 }
141 
142 // File: contracts/upgradeability/UpgradeabilityStorage.sol
143 
144 /**
145  * @title UpgradeabilityStorage
146  * @dev This contract holds all the necessary state variables to support the upgrade functionality
147  */
148 contract UpgradeabilityStorage {
149     // Version name of the current implementation
150     uint256 internal _version;
151 
152     // Address of the current implementation
153     address internal _implementation;
154 
155     /**
156     * @dev Tells the version name of the current implementation
157     * @return string representing the name of the current version
158     */
159     function version() public view returns (uint256) {
160         return _version;
161     }
162 
163     /**
164     * @dev Tells the address of the current implementation
165     * @return address of the current implementation
166     */
167     function implementation() public view returns (address) {
168         return _implementation;
169     }
170 }
171 
172 // File: contracts/upgradeability/UpgradeabilityProxy.sol
173 
174 /**
175  * @title UpgradeabilityProxy
176  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
177  */
178 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
179     /**
180     * @dev This event will be emitted every time the implementation gets upgraded
181     * @param version representing the version name of the upgraded implementation
182     * @param implementation representing the address of the upgraded implementation
183     */
184     event Upgraded(uint256 version, address indexed implementation);
185 
186     /**
187     * @dev Upgrades the implementation address
188     * @param version representing the version name of the new implementation to be set
189     * @param implementation representing the address of the new implementation to be set
190     */
191     function _upgradeTo(uint256 version, address implementation) internal {
192         require(_implementation != implementation);
193         require(version > _version);
194         _version = version;
195         _implementation = implementation;
196         emit Upgraded(version, implementation);
197     }
198 }
199 
200 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
201 
202 /**
203  * @title OwnedUpgradeabilityProxy
204  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
205  */
206 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
207   /**
208   * @dev Event to show ownership has been transferred
209   * @param previousOwner representing the address of the previous owner
210   * @param newOwner representing the address of the new owner
211   */
212     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
213 
214     /**
215     * @dev the constructor sets the original owner of the contract to the sender account.
216     */
217     constructor() public {
218         setUpgradeabilityOwner(msg.sender);
219     }
220 
221     /**
222     * @dev Throws if called by any account other than the owner.
223     */
224     modifier onlyProxyOwner() {
225         require(msg.sender == proxyOwner());
226         _;
227     }
228 
229     /**
230     * @dev Tells the address of the proxy owner
231     * @return the address of the proxy owner
232     */
233     function proxyOwner() public view returns (address) {
234         return upgradeabilityOwner();
235     }
236 
237     /**
238     * @dev Allows the current owner to transfer control of the contract to a newOwner.
239     * @param newOwner The address to transfer ownership to.
240     */
241     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
242         require(newOwner != address(0));
243         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
244         setUpgradeabilityOwner(newOwner);
245     }
246 
247     /**
248     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
249     * @param version representing the version name of the new implementation to be set.
250     * @param implementation representing the address of the new implementation to be set.
251     */
252     function upgradeTo(uint256 version, address implementation) public onlyProxyOwner {
253         _upgradeTo(version, implementation);
254     }
255 
256     /**
257     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
258     * to initialize whatever is needed through a low level call.
259     * @param version representing the version name of the new implementation to be set.
260     * @param implementation representing the address of the new implementation to be set.
261     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
262     * signature of the implementation to be called with the needed payload
263     */
264     function upgradeToAndCall(uint256 version, address implementation, bytes data) payable public onlyProxyOwner {
265         upgradeTo(version, implementation);
266         require(address(this).call.value(msg.value)(data));
267     }
268 }
269 
270 // File: contracts/upgradeability/EternalStorageProxy.sol
271 
272 /**
273  * @title EternalStorageProxy
274  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
275  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
276  * authorization control functionalities
277  */
278 contract EternalStorageProxy is OwnedUpgradeabilityProxy, EternalStorage {}