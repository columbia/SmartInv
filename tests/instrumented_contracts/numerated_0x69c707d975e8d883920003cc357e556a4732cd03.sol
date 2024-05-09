1 
2 // File: contracts/upgradeability/EternalStorage.sol
3 
4 pragma solidity 0.4.24;
5 
6 /**
7  * @title EternalStorage
8  * @dev This contract holds all the necessary state variables to carry out the storage of any contract.
9  */
10 contract EternalStorage {
11     mapping(bytes32 => uint256) internal uintStorage;
12     mapping(bytes32 => string) internal stringStorage;
13     mapping(bytes32 => address) internal addressStorage;
14     mapping(bytes32 => bytes) internal bytesStorage;
15     mapping(bytes32 => bool) internal boolStorage;
16     mapping(bytes32 => int256) internal intStorage;
17 
18 }
19 
20 // File: openzeppelin-solidity/contracts/AddressUtils.sol
21 
22 pragma solidity ^0.4.24;
23 
24 
25 /**
26  * Utility library of inline functions on addresses
27  */
28 library AddressUtils {
29 
30   /**
31    * Returns whether the target address is a contract
32    * @dev This function will return false if invoked during the constructor of a contract,
33    * as the code is not actually created until after the constructor finishes.
34    * @param _addr address to check
35    * @return whether the target address is a contract
36    */
37   function isContract(address _addr) internal view returns (bool) {
38     uint256 size;
39     // XXX Currently there is no better way to check if there is a contract in an address
40     // than to check the size of the code at that address.
41     // See https://ethereum.stackexchange.com/a/14016/36603
42     // for more details about how this works.
43     // TODO Check this again before the Serenity release, because all addresses will be
44     // contracts then.
45     // solium-disable-next-line security/no-inline-assembly
46     assembly { size := extcodesize(_addr) }
47     return size > 0;
48   }
49 
50 }
51 
52 // File: contracts/upgradeability/Proxy.sol
53 
54 pragma solidity 0.4.24;
55 
56 /**
57  * @title Proxy
58  * @dev Gives the possibility to delegate any call to a foreign implementation.
59  */
60 contract Proxy {
61     /**
62     * @dev Tells the address of the implementation where every call will be delegated.
63     * @return address of the implementation to which it will be delegated
64     */
65     /* solcov ignore next */
66     function implementation() public view returns (address);
67 
68     /**
69     * @dev Fallback function allowing to perform a delegatecall to the given implementation.
70     * This function will return whatever the implementation call returns
71     */
72     function() public payable {
73         // solhint-disable-previous-line no-complex-fallback
74         address _impl = implementation();
75         require(_impl != address(0));
76         assembly {
77             /*
78                 0x40 is the "free memory slot", meaning a pointer to next slot of empty memory. mload(0x40)
79                 loads the data in the free memory slot, so `ptr` is a pointer to the next slot of empty
80                 memory. It's needed because we're going to write the return data of delegatecall to the
81                 free memory slot.
82             */
83             let ptr := mload(0x40)
84             /*
85                 `calldatacopy` is copy calldatasize bytes from calldata
86                 First argument is the destination to which data is copied(ptr)
87                 Second argument specifies the start position of the copied data.
88                     Since calldata is sort of its own unique location in memory,
89                     0 doesn't refer to 0 in memory or 0 in storage - it just refers to the zeroth byte of calldata.
90                     That's always going to be the zeroth byte of the function selector.
91                 Third argument, calldatasize, specifies how much data will be copied.
92                     calldata is naturally calldatasize bytes long (same thing as msg.data.length)
93             */
94             calldatacopy(ptr, 0, calldatasize)
95             /*
96                 delegatecall params explained:
97                 gas: the amount of gas to provide for the call. `gas` is an Opcode that gives
98                     us the amount of gas still available to execution
99 
100                 _impl: address of the contract to delegate to
101 
102                 ptr: to pass copied data
103 
104                 calldatasize: loads the size of `bytes memory data`, same as msg.data.length
105 
106                 0, 0: These are for the `out` and `outsize` params. Because the output could be dynamic,
107                         these are set to 0, 0 so the output data will not be written to memory. The output
108                         data will be read using `returndatasize` and `returdatacopy` instead.
109 
110                 result: This will be 0 if the call fails and 1 if it succeeds
111             */
112             let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
113             /*
114 
115             */
116             /*
117                 ptr current points to the value stored at 0x40,
118                 because we assigned it like ptr := mload(0x40).
119                 Because we use 0x40 as a free memory pointer,
120                 we want to make sure that the next time we want to allocate memory,
121                 we aren't overwriting anything important.
122                 So, by adding ptr and returndatasize,
123                 we get a memory location beyond the end of the data we will be copying to ptr.
124                 We place this in at 0x40, and any reads from 0x40 will now read from free memory
125             */
126             mstore(0x40, add(ptr, returndatasize))
127             /*
128                 `returndatacopy` is an Opcode that copies the last return data to a slot. `ptr` is the
129                     slot it will copy to, 0 means copy from the beginning of the return data, and size is
130                     the amount of data to copy.
131                 `returndatasize` is an Opcode that gives us the size of the last return data. In this case, that is the size of the data returned from delegatecall
132             */
133             returndatacopy(ptr, 0, returndatasize)
134 
135             /*
136                 if `result` is 0, revert.
137                 if `result` is 1, return `size` amount of data from `ptr`. This is the data that was
138                 copied to `ptr` from the delegatecall return data
139             */
140             switch result
141                 case 0 {
142                     revert(ptr, returndatasize)
143                 }
144                 default {
145                     return(ptr, returndatasize)
146                 }
147         }
148     }
149 }
150 
151 // File: contracts/upgradeability/UpgradeabilityStorage.sol
152 
153 pragma solidity 0.4.24;
154 
155 /**
156  * @title UpgradeabilityStorage
157  * @dev This contract holds all the necessary state variables to support the upgrade functionality
158  */
159 contract UpgradeabilityStorage {
160     // Version name of the current implementation
161     uint256 internal _version;
162 
163     // Address of the current implementation
164     address internal _implementation;
165 
166     /**
167     * @dev Tells the version name of the current implementation
168     * @return uint256 representing the name of the current version
169     */
170     function version() external view returns (uint256) {
171         return _version;
172     }
173 
174     /**
175     * @dev Tells the address of the current implementation
176     * @return address of the current implementation
177     */
178     function implementation() public view returns (address) {
179         return _implementation;
180     }
181 }
182 
183 // File: contracts/upgradeability/UpgradeabilityProxy.sol
184 
185 pragma solidity 0.4.24;
186 
187 
188 
189 
190 /**
191  * @title UpgradeabilityProxy
192  * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
193  */
194 contract UpgradeabilityProxy is Proxy, UpgradeabilityStorage {
195     /**
196     * @dev This event will be emitted every time the implementation gets upgraded
197     * @param version representing the version name of the upgraded implementation
198     * @param implementation representing the address of the upgraded implementation
199     */
200     event Upgraded(uint256 version, address indexed implementation);
201 
202     /**
203     * @dev Upgrades the implementation address
204     * @param version representing the version name of the new implementation to be set
205     * @param implementation representing the address of the new implementation to be set
206     */
207     function _upgradeTo(uint256 version, address implementation) internal {
208         require(_implementation != implementation);
209 
210         // This additional check verifies that provided implementation is at least a contract
211         require(AddressUtils.isContract(implementation));
212 
213         // This additional check guarantees that new version will be at least greater than the privios one,
214         // so it is impossible to reuse old versions, or use the last version twice
215         require(version > _version);
216 
217         _version = version;
218         _implementation = implementation;
219         emit Upgraded(version, implementation);
220     }
221 }
222 
223 // File: contracts/upgradeability/UpgradeabilityOwnerStorage.sol
224 
225 pragma solidity 0.4.24;
226 
227 /**
228  * @title UpgradeabilityOwnerStorage
229  * @dev This contract keeps track of the upgradeability owner
230  */
231 contract UpgradeabilityOwnerStorage {
232     // Owner of the contract
233     address internal _upgradeabilityOwner;
234 
235     /**
236     * @dev Tells the address of the owner
237     * @return the address of the owner
238     */
239     function upgradeabilityOwner() public view returns (address) {
240         return _upgradeabilityOwner;
241     }
242 
243     /**
244     * @dev Sets the address of the owner
245     */
246     function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
247         _upgradeabilityOwner = newUpgradeabilityOwner;
248     }
249 }
250 
251 // File: contracts/upgradeability/OwnedUpgradeabilityProxy.sol
252 
253 pragma solidity 0.4.24;
254 
255 
256 
257 /**
258  * @title OwnedUpgradeabilityProxy
259  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
260  */
261 contract OwnedUpgradeabilityProxy is UpgradeabilityOwnerStorage, UpgradeabilityProxy {
262     /**
263     * @dev Event to show ownership has been transferred
264     * @param previousOwner representing the address of the previous owner
265     * @param newOwner representing the address of the new owner
266     */
267     event ProxyOwnershipTransferred(address previousOwner, address newOwner);
268 
269     /**
270     * @dev the constructor sets the original owner of the contract to the sender account.
271     */
272     constructor() public {
273         setUpgradeabilityOwner(msg.sender);
274     }
275 
276     /**
277     * @dev Throws if called by any account other than the owner.
278     */
279     modifier onlyUpgradeabilityOwner() {
280         require(msg.sender == upgradeabilityOwner());
281         /* solcov ignore next */
282         _;
283     }
284 
285     /**
286     * @dev Allows the current owner to transfer control of the contract to a newOwner.
287     * @param newOwner The address to transfer ownership to.
288     */
289     function transferProxyOwnership(address newOwner) external onlyUpgradeabilityOwner {
290         require(newOwner != address(0));
291         emit ProxyOwnershipTransferred(upgradeabilityOwner(), newOwner);
292         setUpgradeabilityOwner(newOwner);
293     }
294 
295     /**
296     * @dev Allows the upgradeability owner to upgrade the current version of the proxy.
297     * @param version representing the version name of the new implementation to be set.
298     * @param implementation representing the address of the new implementation to be set.
299     */
300     function upgradeTo(uint256 version, address implementation) public onlyUpgradeabilityOwner {
301         _upgradeTo(version, implementation);
302     }
303 
304     /**
305     * @dev Allows the upgradeability owner to upgrade the current version of the proxy and call the new implementation
306     * to initialize whatever is needed through a low level call.
307     * @param version representing the version name of the new implementation to be set.
308     * @param implementation representing the address of the new implementation to be set.
309     * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
310     * signature of the implementation to be called with the needed payload
311     */
312     function upgradeToAndCall(uint256 version, address implementation, bytes data)
313         external
314         payable
315         onlyUpgradeabilityOwner
316     {
317         upgradeTo(version, implementation);
318         // solhint-disable-next-line avoid-call-value
319         require(address(this).call.value(msg.value)(data));
320     }
321 }
322 
323 // File: contracts/upgradeability/EternalStorageProxy.sol
324 
325 pragma solidity 0.4.24;
326 
327 
328 
329 /**
330  * @title EternalStorageProxy
331  * @dev This proxy holds the storage of the token contract and delegates every call to the current implementation set.
332  * Besides, it allows to upgrade the token's behaviour towards further implementations, and provides basic
333  * authorization control functionalities
334  */
335 // solhint-disable-next-line no-empty-blocks
336 contract EternalStorageProxy is EternalStorage, OwnedUpgradeabilityProxy {}
