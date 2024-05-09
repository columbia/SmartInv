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
18 }
19 
20 // File: contracts/upgradeability/Proxy.sol
21 
22 /**
23  * @title Proxy
24  * @dev Gives the possibility to delegate any call to a foreign implementation.
25  */
26 contract Proxy {
27 
28   /**
29   * @dev Tells the address of the implementation where every call will be delegated.
30   * @return address of the implementation to which it will be delegated
31   */
32     function implementation() public view returns (address);
33 
34   /**
35   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
36   * This function will return whatever the implementation call returns
37   */
38     function () payable public {
39         address _impl = implementation();
40         require(_impl != address(0));
41         assembly {
42             /*
43                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
44                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
45                 memory. It's needed because we're going to write the return data of delegatecall to the
46                 free memory slot.
47             */
48             let ptr := mload(0x40)
49             /*
50                 `calldatacopy` is copy calldatasize bytes from calldata
51                 First argument is the destination to which data is copied(ptr)
52                 Second argument specifies the start position of the copied data.
53                     Since calldata is sort of its own unique location in memory,
54                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
55                     That's always going to be the zeroth byte of the function selector.
56                 Third argument, calldatasize, specifies how much data will be copied.
57                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
58             */
59             calldatacopy(ptr, 0, calldatasize)
60             /*
61                 delegatecall params explained:
62                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
63                     us the amount of gas still available to execution
64 
65                 _impl: address of the contract to delegate to
66 
67                 ptr: to pass copied data
68 
69                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
70 
71                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
72                         these are set to 0, 0 so the output data will not be written to memory. The output
73                         data will be read using `returndatasize` and `returdatacopy` instead.
74 
75                 result: This will be 0 if the call fails and 1 if it succeeds
76             */
77             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
78             /*
79 
80             */
81             /*
82                 ptr current points to the value stored at 0x40,
83                 because we assigned it like ptr := mload(0x40).
84                 Because we use 0x40 as a free memory pointer,
85                 we want to make sure that the next time we want to allocate memory,
86                 we aren't overwriting anything important.
87                 So, by adding ptr and returndatasize,
88                 we get a memory location beyond the end of the data we will be copying to ptr.
89                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
90             */
91             mstore(0x40, add(ptr, returndatasize))
92             /*
93                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
94                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
95                     the amount of data to copy.
96                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
97             */
98             returndatacopy(ptr, 0, returndatasize)
99 
100             /*
101                 if `result` is 0, revert.
102                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
103                 copied to `ptr` from the delegatecall return data
104             */
105             switch result
106             case 0 { revert(ptr, returndatasize) }
107             default { return(ptr, returndatasize) }
108         }
109     }
110 }
111 
112 // File: contracts/upgradeability/UpgradeabilityStorage.sol
113 
114 /**
115  * @title UpgradeabilityStorage
116  * @dev This contract holds all the necessary state variables to support the upgrade functionality
117  */
118 contract UpgradeabilityStorage {
119     // Version name of the current implementation
120     uint256 internal _version;
121 
122     // Address of the current implementation
123     address internal _implementation;
124 
125     /**
126     * @dev Tells the version name of the current implementation
127     * @return string representing the name of the current version
128     */
129     function version() public view returns (uint256) {
130         return _version;
131     }
132 
133     /**
134     * @dev Tells the address of the current implementation
135     * @return address of the current implementation
136     */
137     function implementation() public view returns (address) {
138         return _implementation;
139     }
140 }
141 
142 // File: contracts/upgradeability/UpgradeabilityProxy.sol
143 
144 /**
145  * @title UpgradeabilityProxy
146  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
147  */
148 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
149     /**
150     * @dev This event will be emitted every time the implementation gets upgraded
151     * @param version representing the version name of the upgraded implementation
152     * @param implementation representing the address of the upgraded implementation
153     */
154     event Upgraded(uint256 version, address indexed implementation);
155 
156     /**
157     * @dev Upgrades the implementation address
158     * @param version representing the version name of the new implementation to be set
159     * @param implementation representing the address of the new implementation to be set
160     */
161     function _upgradeTo(uint256 version, address implementation) internal {
162         require(_implementation != implementation);
163         require(version > _version);
164         _version = version;
165         _implementation = implementation;
166         emit Upgraded(version, implementation);
167     }
168 }
169 
170 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
171 
172 /**
173  * @title UpgradeabilityOwnerStorage
174  * @dev This contract keeps track of the upgradeability owner
175  */
176 contract UpgradeabilityOwnerStorage {
177     // Owner of the contract
178     address private _upgradeabilityOwner;
179 
180     /**
181     * @dev Tells the address of the owner
182     * @return the address of the owner
183     */
184     function upgradeabilityOwner() public view returns (address) {
185         return _upgradeabilityOwner;
186     }
187 
188     /**
189     * @dev Sets the address of the owner
190     */
191     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
192         _upgradeabilityOwner = newUpgradeabilityOwner;
193     }
194 }
195 
196 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
197 
198 /**
199  * @title OwnedUpgradeabilityProxy
200  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
201  */
202 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
203   /**
204   * @dev Event to show ownership has been transferred
205   * @param previousOwner representing the address of the previous owner
206   * @param newOwner representing the address of the new owner
207   */
208     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
209 
210     /**
211     * @dev the constructor sets the original owner of the contract to the sender account.
212     */
213     constructor() public {
214         setUpgradeabilityOwner(msg.sender);
215     }
216 
217     /**
218     * @dev Throws if called by any account other than the owner.
219     */
220     modifier onlyProxyOwner() {
221         require(msg.sender == proxyOwner());
222         _;
223     }
224 
225     /**
226     * @dev Tells the address of the proxy owner
227     * @return the address of the proxy owner
228     */
229     function proxyOwner() public view returns (address) {
230         return upgradeabilityOwner();
231     }
232 
233     /**
234     * @dev Allows the current owner to transfer control of the contract to a newOwner.
235     * @param newOwner The address to transfer ownership to.
236     */
237     function transferProxyOwnership(address newOwner) public onlyProxyOwner {
238         require(newOwner != address(0));
239         emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
240         setUpgradeabilityOwner(newOwner);
241     }
242 
243     /**
244     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
245     * @param version representing the version name of the new implementation to be set.
246     * @param implementation representing the address of the new implementation to be set.
247     */
248     function upgradeTo(uint256 version, address implementation) public onlyProxyOwner {
249         _upgradeTo(version, implementation);
250     }
251 
252     /**
253     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
254     * to initialize whatever is needed through a low level call.
255     * @param version representing the version name of the new implementation to be set.
256     * @param implementation representing the address of the new implementation to be set.
257     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
258     * signature of the implementation to be called with the needed payload
259     */
260     function upgradeToAndCall(uint256 version, address implementation, bytes data) payable public onlyProxyOwner {
261         upgradeTo(version, implementation);
262         require(address(this).call.value(msg.value)(data));
263     }
264 }
265 
266 // File: contracts\upgradeability\EternalStorageProxy.sol
267 
268 /**
269  * @title EternalStorageProxy
270  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
271  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
272  * authorization control functionalities
273  */
274 contract EternalStorageProxy is OwnedUpgradeabilityProxy, EternalStorage {}