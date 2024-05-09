1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-30
3 */
4 
5 // File: contracts/upgradeability/EternalStorage.sol
6 
7 pragma solidity 0.4.24;
8 
9 /**
10  * @title EternalStorage
11  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
12  */
13 contract EternalStorage {
14     mapping(bytes32 => uint256) internal uintStorage;
15     mapping(bytes32 => string) internal stringStorage;
16     mapping(bytes32 => address) internal addressStorage;
17     mapping(bytes32 => bytes) internal bytesStorage;
18     mapping(bytes32 => bool) internal boolStorage;
19     mapping(bytes32 => int256) internal intStorage;
20 
21 }
22 
23 // File: openzeppelin-solidity/contracts/AddressUtils.sol
24 
25 pragma solidity ^0.4.24;
26 
27 
28 /**
29  * Utility library of inline functions on addresses
30  */
31 library AddressUtils {
32 
33   /**
34    * Returns whether the target address is a contract
35    * @dev This function will return false if invoked during the constructor of a contract,
36    * as the code is not actually created until after the constructor finishes.
37    * @param _addr address to check
38    * @return whether the target address is a contract
39    */
40   function isContract(address _addr) internal view returns (bool) {
41     uint256 size;
42     // XXX Currently there is no better way to check if there is a contract in an address
43     // than to check the size of the code at that address.
44     // See https://ethereum.stackexchange.com/a/14016/36603
45     // for more details about how this works.
46     // TODO Check this again before the Serenity release, because all addresses will be
47     // contracts then.
48     // solium-disable-next-line security/no-inline-assembly
49     assembly { size := extcodesize(_addr) }
50     return size > 0;
51   }
52 
53 }
54 
55 // File: contracts/upgradeability/Proxy.sol
56 
57 pragma solidity 0.4.24;
58 
59 /**
60  * @title Proxy
61  * @dev Gives the possibility to delegate any call to a foreign implementation.
62  */
63 contract Proxy {
64     /**
65     * @dev Tells the address of the implementation where every call will be delegated.
66     * @return address of the implementation to which it will be delegated
67     */
68     /* solcov ignore next */
69     function implementation() public view returns (address);
70 
71     /**
72     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
73     * This function will return whatever the implementation call returns
74     */
75     function() public payable {
76         // solhint-disable-previous-line no-complex-fallback
77         address _impl = implementation();
78         require(_impl != address(0));
79         assembly {
80             /*
81                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
82                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
83                 memory. It's needed because we're going to write the return data of delegatecall to the
84                 free memory slot.
85             */
86             let ptr := mload(0x40)
87             /*
88                 `calldatacopy` is copy calldatasize bytes from calldata
89                 First argument is the destination to which data is copied(ptr)
90                 Second argument specifies the start position of the copied data.
91                     Since calldata is sort of its own unique location in memory,
92                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
93                     That's always going to be the zeroth byte of the function selector.
94                 Third argument, calldatasize, specifies how much data will be copied.
95                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
96             */
97             calldatacopy(ptr, 0, calldatasize)
98             /*
99                 delegatecall params explained:
100                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
101                     us the amount of gas still available to execution
102 
103                 _impl: address of the contract to delegate to
104 
105                 ptr: to pass copied data
106 
107                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
108 
109                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
110                         these are set to 0, 0 so the output data will not be written to memory. The output
111                         data will be read using `returndatasize` and `returdatacopy` instead.
112 
113                 result: This will be 0 if the call fails and 1 if it succeeds
114             */
115             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
116             /*
117 
118             */
119             /*
120                 ptr current points to the value stored at 0x40,
121                 because we assigned it like ptr := mload(0x40).
122                 Because we use 0x40 as a free memory pointer,
123                 we want to make sure that the next time we want to allocate memory,
124                 we aren't overwriting anything important.
125                 So, by adding ptr and returndatasize,
126                 we get a memory location beyond the end of the data we will be copying to ptr.
127                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
128             */
129             mstore(0x40, add(ptr, returndatasize))
130             /*
131                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
132                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
133                     the amount of data to copy.
134                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
135             */
136             returndatacopy(ptr, 0, returndatasize)
137 
138             /*
139                 if `result` is 0, revert.
140                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
141                 copied to `ptr` from the delegatecall return data
142             */
143             switch result
144                 case 0 {
145                     revert(ptr, returndatasize)
146                 }
147                 default {
148                     return(ptr, returndatasize)
149                 }
150         }
151     }
152 }
153 
154 // File: contracts/upgradeability/UpgradeabilityStorage.sol
155 
156 pragma solidity 0.4.24;
157 
158 /**
159  * @title UpgradeabilityStorage
160  * @dev This contract holds all the necessary state variables to support the upgrade functionality
161  */
162 contract UpgradeabilityStorage {
163     // Version name of the current implementation
164     uint256 internal _version;
165 
166     // Address of the current implementation
167     address internal _implementation;
168 
169     /**
170     * @dev Tells the version name of the current implementation
171     * @return uint256 representing the name of the current version
172     */
173     function version() external view returns (uint256) {
174         return _version;
175     }
176 
177     /**
178     * @dev Tells the address of the current implementation
179     * @return address of the current implementation
180     */
181     function implementation() public view returns (address) {
182         return _implementation;
183     }
184 }
185 
186 // File: contracts/upgradeability/UpgradeabilityProxy.sol
187 
188 pragma solidity 0.4.24;
189 
190 
191 
192 
193 /**
194  * @title UpgradeabilityProxy
195  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
196  */
197 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
198     /**
199     * @dev This event will be emitted every time the implementation gets upgraded
200     * @param version representing the version name of the upgraded implementation
201     * @param implementation representing the address of the upgraded implementation
202     */
203     event Upgraded(uint256 version, address indexed implementation);
204 
205     /**
206     * @dev Upgrades the implementation address
207     * @param version representing the version name of the new implementation to be set
208     * @param implementation representing the address of the new implementation to be set
209     */
210     function _upgradeTo(uint256 version, address implementation) internal {
211         require(_implementation != implementation);
212 
213         // This additional check verifies that provided implementation is at least a contract
214         require(AddressUtils.isContract(implementation));
215 
216         // This additional check guarantees that new version will be at least greater than the privios one,
217         // so it is impossible to reuse old versions, or use the last version twice
218         require(version > _version);
219 
220         _version = version;
221         _implementation = implementation;
222         emit Upgraded(version, implementation);
223     }
224 }
225 
226 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
227 
228 pragma solidity 0.4.24;
229 
230 /**
231  * @title UpgradeabilityOwnerStorage
232  * @dev This contract keeps track of the upgradeability owner
233  */
234 contract UpgradeabilityOwnerStorage {
235     // Owner of the contract
236     address internal _upgradeabilityOwner;
237 
238     /**
239     * @dev Tells the address of the owner
240     * @return the address of the owner
241     */
242     function upgradeabilityOwner() public view returns (address) {
243         return _upgradeabilityOwner;
244     }
245 
246     /**
247     * @dev Sets the address of the owner
248     */
249     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
250         _upgradeabilityOwner = newUpgradeabilityOwner;
251     }
252 }
253 
254 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
255 
256 pragma solidity 0.4.24;
257 
258 
259 
260 /**
261  * @title OwnedUpgradeabilityProxy
262  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
263  */
264 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
265     /**
266     * @dev Event to show ownership has been transferred
267     * @param previousOwner representing the address of the previous owner
268     * @param newOwner representing the address of the new owner
269     */
270     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
271 
272     /**
273     * @dev the constructor sets the original owner of the contract to the sender account.
274     */
275     constructor() public {
276         setUpgradeabilityOwner(msg.sender);
277     }
278 
279     /**
280     * @dev Throws if called by any account other than the owner.
281     */
282     modifier onlyUpgradeabilityOwner() {
283         require(msg.sender == upgradeabilityOwner());
284         /* solcov ignore next */
285         _;
286     }
287 
288     /**
289     * @dev Allows the current owner to transfer control of the contract to a newOwner.
290     * @param newOwner The address to transfer ownership to.
291     */
292     function transferProxyOwnership(address newOwner) external onlyUpgradeabilityOwner {
293         require(newOwner != address(0));
294         emit ProxyOwnershipTransferred(upgradeabilityOwner(), newOwner);
295         setUpgradeabilityOwner(newOwner);
296     }
297 
298     /**
299     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
300     * @param version representing the version name of the new implementation to be set.
301     * @param implementation representing the address of the new implementation to be set.
302     */
303     function upgradeTo(uint256 version, address implementation) public onlyUpgradeabilityOwner {
304         _upgradeTo(version, implementation);
305     }
306 
307     /**
308     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
309     * to initialize whatever is needed through a low level call.
310     * @param version representing the version name of the new implementation to be set.
311     * @param implementation representing the address of the new implementation to be set.
312     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
313     * signature of the implementation to be called with the needed payload
314     */
315     function upgradeToAndCall(uint256 version, address implementation, bytes data)
316         external
317         payable
318         onlyUpgradeabilityOwner
319     {
320         upgradeTo(version, implementation);
321         // solhint-disable-next-line avoid-call-value
322         require(address(this).call.value(msg.value)(data));
323     }
324 }
325 
326 // File: contracts/upgradeability/EternalStorageProxy.sol
327 
328 pragma solidity 0.4.24;
329 
330 
331 
332 /**
333  * @title EternalStorageProxy
334  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
335  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
336  * authorization control functionalities
337  */
338 // solhint-disable-next-line no-empty-blocks
339 contract EternalStorageProxy is EternalStorage, OwnedUpgradeabilityProxy {}