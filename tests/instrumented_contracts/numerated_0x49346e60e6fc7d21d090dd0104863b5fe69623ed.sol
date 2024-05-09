1 // File: contracts/upgradeability/EternalStorage.sol
2 
3 pragma solidity 0.4.24;
4 
5 /**
6  * @title EternalStorage
7  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
8  */
9 contract EternalStorage {
10     mapping(bytes32 => uint256) internal uintStorage;
11     mapping(bytes32 => string) internal stringStorage;
12     mapping(bytes32 => address) internal addressStorage;
13     mapping(bytes32 => bytes) internal bytesStorage;
14     mapping(bytes32 => bool) internal boolStorage;
15     mapping(bytes32 => int256) internal intStorage;
16 
17 }
18 
19 // File: openzeppelin-solidity/contracts/AddressUtils.sol
20 
21 pragma solidity ^0.4.24;
22 
23 
24 /**
25  * Utility library of inline functions on addresses
26  */
27 library AddressUtils {
28 
29   /**
30    * Returns whether the target address is a contract
31    * @dev This function will return false if invoked during the constructor of a contract,
32    * as the code is not actually created until after the constructor finishes.
33    * @param _addr address to check
34    * @return whether the target address is a contract
35    */
36   function isContract(address _addr) internal view returns (bool) {
37     uint256 size;
38     // XXX Currently there is no better way to check if there is a contract in an address
39     // than to check the size of the code at that address.
40     // See https://ethereum.stackexchange.com/a/14016/36603
41     // for more details about how this works.
42     // TODO Check this again before the Serenity release, because all addresses will be
43     // contracts then.
44     // solium-disable-next-line security/no-inline-assembly
45     assembly { size := extcodesize(_addr) }
46     return size > 0;
47   }
48 
49 }
50 
51 // File: contracts/upgradeability/Proxy.sol
52 
53 pragma solidity 0.4.24;
54 
55 /**
56  * @title Proxy
57  * @dev Gives the possibility to delegate any call to a foreign implementation.
58  */
59 contract Proxy {
60     /**
61     * @dev Tells the address of the implementation where every call will be delegated.
62     * @return address of the implementation to which it will be delegated
63     */
64     /* solcov ignore next */
65     function implementation() public view returns (address);
66 
67     /**
68     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
69     * This function will return whatever the implementation call returns
70     */
71     function() public payable {
72         // solhint-disable-previous-line no-complex-fallback
73         address _impl = implementation();
74         require(_impl != address(0));
75         assembly {
76             /*
77                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
78                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
79                 memory. It's needed because we're going to write the return data of delegatecall to the
80                 free memory slot.
81             */
82             let ptr := mload(0x40)
83             /*
84                 `calldatacopy` is copy calldatasize bytes from calldata
85                 First argument is the destination to which data is copied(ptr)
86                 Second argument specifies the start position of the copied data.
87                     Since calldata is sort of its own unique location in memory,
88                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
89                     That's always going to be the zeroth byte of the function selector.
90                 Third argument, calldatasize, specifies how much data will be copied.
91                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
92             */
93             calldatacopy(ptr, 0, calldatasize)
94             /*
95                 delegatecall params explained:
96                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
97                     us the amount of gas still available to execution
98 
99                 _impl: address of the contract to delegate to
100 
101                 ptr: to pass copied data
102 
103                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
104 
105                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
106                         these are set to 0, 0 so the output data will not be written to memory. The output
107                         data will be read using `returndatasize` and `returdatacopy` instead.
108 
109                 result: This will be 0 if the call fails and 1 if it succeeds
110             */
111             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
112             /*
113 
114             */
115             /*
116                 ptr current points to the value stored at 0x40,
117                 because we assigned it like ptr := mload(0x40).
118                 Because we use 0x40 as a free memory pointer,
119                 we want to make sure that the next time we want to allocate memory,
120                 we aren't overwriting anything important.
121                 So, by adding ptr and returndatasize,
122                 we get a memory location beyond the end of the data we will be copying to ptr.
123                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
124             */
125             mstore(0x40, add(ptr, returndatasize))
126             /*
127                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
128                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
129                     the amount of data to copy.
130                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
131             */
132             returndatacopy(ptr, 0, returndatasize)
133 
134             /*
135                 if `result` is 0, revert.
136                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
137                 copied to `ptr` from the delegatecall return data
138             */
139             switch result
140                 case 0 {
141                     revert(ptr, returndatasize)
142                 }
143                 default {
144                     return(ptr, returndatasize)
145                 }
146         }
147     }
148 }
149 
150 // File: contracts/upgradeability/UpgradeabilityStorage.sol
151 
152 pragma solidity 0.4.24;
153 
154 /**
155  * @title UpgradeabilityStorage
156  * @dev This contract holds all the necessary state variables to support the upgrade functionality
157  */
158 contract UpgradeabilityStorage {
159     // Version name of the current implementation
160     uint256 internal _version;
161 
162     // Address of the current implementation
163     address internal _implementation;
164 
165     /**
166     * @dev Tells the version name of the current implementation
167     * @return uint256 representing the name of the current version
168     */
169     function version() external view returns (uint256) {
170         return _version;
171     }
172 
173     /**
174     * @dev Tells the address of the current implementation
175     * @return address of the current implementation
176     */
177     function implementation() public view returns (address) {
178         return _implementation;
179     }
180 }
181 
182 // File: contracts/upgradeability/UpgradeabilityProxy.sol
183 
184 pragma solidity 0.4.24;
185 
186 
187 
188 
189 /**
190  * @title UpgradeabilityProxy
191  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
192  */
193 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
194     /**
195     * @dev This event will be emitted every time the implementation gets upgraded
196     * @param version representing the version name of the upgraded implementation
197     * @param implementation representing the address of the upgraded implementation
198     */
199     event Upgraded(uint256 version, address indexed implementation);
200 
201     /**
202     * @dev Upgrades the implementation address
203     * @param version representing the version name of the new implementation to be set
204     * @param implementation representing the address of the new implementation to be set
205     */
206     function _upgradeTo(uint256 version, address implementation) internal {
207         require(_implementation != implementation);
208 
209         // This additional check verifies that provided implementation is at least a contract
210         require(AddressUtils.isContract(implementation));
211 
212         // This additional check guarantees that new version will be at least greater than the privios one,
213         // so it is impossible to reuse old versions, or use the last version twice
214         require(version > _version);
215 
216         _version = version;
217         _implementation = implementation;
218         emit Upgraded(version, implementation);
219     }
220 }
221 
222 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
223 
224 pragma solidity 0.4.24;
225 
226 /**
227  * @title UpgradeabilityOwnerStorage
228  * @dev This contract keeps track of the upgradeability owner
229  */
230 contract UpgradeabilityOwnerStorage {
231     // Owner of the contract
232     address internal _upgradeabilityOwner;
233 
234     /**
235     * @dev Tells the address of the owner
236     * @return the address of the owner
237     */
238     function upgradeabilityOwner() public view returns (address) {
239         return _upgradeabilityOwner;
240     }
241 
242     /**
243     * @dev Sets the address of the owner
244     */
245     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
246         _upgradeabilityOwner = newUpgradeabilityOwner;
247     }
248 }
249 
250 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
251 
252 pragma solidity 0.4.24;
253 
254 
255 
256 /**
257  * @title OwnedUpgradeabilityProxy
258  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
259  */
260 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
261     /**
262     * @dev Event to show ownership has been transferred
263     * @param previousOwner representing the address of the previous owner
264     * @param newOwner representing the address of the new owner
265     */
266     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
267 
268     /**
269     * @dev the constructor sets the original owner of the contract to the sender account.
270     */
271     constructor() public {
272         setUpgradeabilityOwner(msg.sender);
273     }
274 
275     /**
276     * @dev Throws if called by any account other than the owner.
277     */
278     modifier onlyUpgradeabilityOwner() {
279         require(msg.sender == upgradeabilityOwner());
280         /* solcov ignore next */
281         _;
282     }
283 
284     /**
285     * @dev Allows the current owner to transfer control of the contract to a newOwner.
286     * @param newOwner The address to transfer ownership to.
287     */
288     function transferProxyOwnership(address newOwner) external onlyUpgradeabilityOwner {
289         require(newOwner != address(0));
290         emit ProxyOwnershipTransferred(upgradeabilityOwner(), newOwner);
291         setUpgradeabilityOwner(newOwner);
292     }
293 
294     /**
295     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
296     * @param version representing the version name of the new implementation to be set.
297     * @param implementation representing the address of the new implementation to be set.
298     */
299     function upgradeTo(uint256 version, address implementation) public onlyUpgradeabilityOwner {
300         _upgradeTo(version, implementation);
301     }
302 
303     /**
304     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
305     * to initialize whatever is needed through a low level call.
306     * @param version representing the version name of the new implementation to be set.
307     * @param implementation representing the address of the new implementation to be set.
308     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
309     * signature of the implementation to be called with the needed payload
310     */
311     function upgradeToAndCall(uint256 version, address implementation, bytes data)
312         external
313         payable
314         onlyUpgradeabilityOwner
315     {
316         upgradeTo(version, implementation);
317         // solhint-disable-next-line avoid-call-value
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
328 /**
329  * @title EternalStorageProxy
330  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
331  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
332  * authorization control functionalities
333  */
334 // solhint-disable-next-line no-empty-blocks
335 contract EternalStorageProxy is EternalStorage, OwnedUpgradeabilityProxy {}