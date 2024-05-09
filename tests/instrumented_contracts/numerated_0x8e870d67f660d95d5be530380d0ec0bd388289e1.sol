1 pragma solidity ^0.4.24;
2 
3 // File: contracts/zeppelin/Proxy.sol
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 contract Proxy {
13     /**
14      * @dev Fallback function.
15      * Implemented entirely in `_fallback`.
16      */
17     function () payable external {
18         _fallback();
19     }
20 
21     /**
22      * @return The Address of the implementation.
23      */
24     function _implementation() internal view returns (address);
25 
26     /**
27      * @dev Delegates execution to an implementation contract.
28      * This is a low level function that doesn't return to its internal call site.
29      * It will return to the external caller whatever the implementation returns.
30      * @param implementation Address to delegate.
31      */
32     function _delegate(address implementation) internal {
33         assembly {
34         // Copy msg.data. We take full control of memory in this inline assembly
35         // block because it will not return to Solidity code. We overwrite the
36         // Solidity scratch pad at memory position 0.
37             calldatacopy(0, 0, calldatasize)
38 
39         // Call the implementation.
40         // out and outsize are 0 because we don't know the size yet.
41             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
42 
43         // Copy the returned data.
44             returndatacopy(0, 0, returndatasize)
45 
46             switch result
47             // delegatecall returns 0 on error.
48             case 0 { revert(0, returndatasize) }
49             default { return(0, returndatasize) }
50         }
51     }
52 
53     /**
54      * @dev Function that is run as the first thing in the fallback function.
55      * Can be redefined in derived contracts to add functionality.
56      * Redefinitions must call super._willFallback().
57      */
58     function _willFallback() internal {
59     }
60 
61     /**
62      * @dev fallback implementation.
63      * Extracted to enable manual triggering.
64      */
65     function _fallback() internal {
66         _willFallback();
67         _delegate(_implementation());
68     }
69 }
70 
71 // File: contracts/zeppelin/AddressUtils.sol
72 
73 /**
74  * Utility library of inline functions on addresses
75  */
76 library AddressUtils {
77 
78     /**
79      * Returns whether the target address is a contract
80      * @dev This function will return false if invoked during the constructor of a contract,
81      * as the code is not actually created until after the constructor finishes.
82      * @param addr address to check
83      * @return whether the target address is a contract
84      */
85     function isContract(address addr) internal view returns (bool) {
86         uint256 size;
87         // XXX Currently there is no better way to check if there is a contract in an address
88         // than to check the size of the code at that address.
89         // See https://ethereum.stackexchange.com/a/14016/36603
90         // for more details about how this works.
91         // TODO Check this again before the Serenity release, because all addresses will be
92         // contracts then.
93         // solium-disable-next-line security/no-inline-assembly
94         assembly { size := extcodesize(addr) }
95         return size > 0;
96     }
97 
98 }
99 
100 // File: contracts/zeppelin/UpgradeabilityProxy.sol
101 
102 /**
103  * @title UpgradeabilityProxy
104  * @dev This contract implements a proxy that allows to change the
105  * implementation address to which it will delegate.
106  * Such a change is called an implementation upgrade.
107  */
108 contract UpgradeabilityProxy is Proxy {
109     /**
110      * @dev Emitted when the implementation is upgraded.
111      * @param implementation Address of the new implementation.
112      */
113     event Upgraded(address implementation);
114 
115     /**
116      * @dev Storage slot with the address of the current implementation.
117      * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
118      * validated in the constructor.
119      */
120     bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
121 
122     /**
123      * @dev Contract constructor.
124      * @param _implementation Address of the initial implementation.
125      */
126     constructor(address _implementation) public {
127         assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
128 
129         _setImplementation(_implementation);
130     }
131 
132     /**
133      * @dev Returns the current implementation.
134      * @return Address of the current implementation
135      */
136     function _implementation() internal view returns (address impl) {
137         bytes32 slot = IMPLEMENTATION_SLOT;
138         assembly {
139             impl := sload(slot)
140         }
141     }
142 
143     /**
144      * @dev Upgrades the proxy to a new implementation.
145      * @param newImplementation Address of the new implementation.
146      */
147     function _upgradeTo(address newImplementation) internal {
148         _setImplementation(newImplementation);
149         emit Upgraded(newImplementation);
150     }
151 
152     /**
153      * @dev Sets the implementation address of the proxy.
154      * @param newImplementation Address of the new implementation.
155      */
156     function _setImplementation(address newImplementation) private {
157         require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
158 
159         bytes32 slot = IMPLEMENTATION_SLOT;
160 
161         assembly {
162             sstore(slot, newImplementation)
163         }
164     }
165 }
166 
167 // File: contracts/zeppelin/AdminUpgradeabilityProxy.sol
168 
169 /**
170  * @title AdminUpgradeabilityProxy
171  * @dev This contract combines an upgradeability proxy with an authorization
172  * mechanism for administrative tasks.
173  * All external functions in this contract must be guarded by the
174  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
175  * feature proposal that would enable this to be done automatically.
176  */
177 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
178     /**
179      * @dev Emitted when the administration has been transferred.
180      * @param previousAdmin Address of the previous admin.
181      * @param newAdmin Address of the new admin.
182      */
183     event AdminChanged(address previousAdmin, address newAdmin);
184 
185     /**
186      * @dev Storage slot with the admin of the contract.
187      * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
188      * validated in the constructor.
189      */
190     bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
191 
192     /**
193      * @dev Modifier to check whether the `msg.sender` is the admin.
194      * If it is, it will run the function. Otherwise, it will delegate the call
195      * to the implementation.
196      */
197     modifier ifAdmin() {
198         if (msg.sender == _admin()) {
199             _;
200         } else {
201             _fallback();
202         }
203     }
204 
205     /**
206      * Contract constructor.
207      * It sets the `msg.sender` as the proxy administrator.
208      * @param _implementation address of the initial implementation.
209      */
210     constructor(address _implementation) UpgradeabilityProxy(_implementation) public {
211         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
212 
213         _setAdmin(msg.sender);
214     }
215 
216     /**
217      * @return The address of the proxy admin.
218      */
219     function admin() external view ifAdmin returns (address) {
220         return _admin();
221     }
222 
223     /**
224      * @return The address of the implementation.
225      */
226     function implementation() external view ifAdmin returns (address) {
227         return _implementation();
228     }
229 
230     /**
231      * @dev Changes the admin of the proxy.
232      * Only the current admin can call this function.
233      * @param newAdmin Address to transfer proxy administration to.
234      */
235     function changeAdmin(address newAdmin) external ifAdmin {
236         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
237         emit AdminChanged(_admin(), newAdmin);
238         _setAdmin(newAdmin);
239     }
240 
241     /**
242      * @dev Upgrade the backing implementation of the proxy.
243      * Only the admin can call this function.
244      * @param newImplementation Address of the new implementation.
245      */
246     function upgradeTo(address newImplementation) external ifAdmin {
247         _upgradeTo(newImplementation);
248     }
249 
250     /**
251      * @dev Upgrade the backing implementation of the proxy and call a function
252      * on the new implementation.
253      * This is useful to initialize the proxied contract.
254      * @param newImplementation Address of the new implementation.
255      * @param data Data to send as msg.data in the low level call.
256      * It should include the signature and the parameters of the function to be
257      * called, as described in
258      * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
259      */
260     function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
261         _upgradeTo(newImplementation);
262         require(address(this).call.value(msg.value)(data));
263     }
264 
265     /**
266      * @return The admin slot.
267      */
268     function _admin() internal view returns (address adm) {
269         bytes32 slot = ADMIN_SLOT;
270         assembly {
271             adm := sload(slot)
272         }
273     }
274 
275     /**
276      * @dev Sets the address of the proxy admin.
277      * @param newAdmin Address of the new proxy admin.
278      */
279     function _setAdmin(address newAdmin) internal {
280         bytes32 slot = ADMIN_SLOT;
281 
282         assembly {
283             sstore(slot, newAdmin)
284         }
285     }
286 
287     /**
288      * @dev Only fall back when the sender is not the admin.
289      */
290     function _willFallback() internal {
291         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
292         super._willFallback();
293     }
294 }