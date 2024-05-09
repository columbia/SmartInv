1 // File: contracts/zeppelin/Proxy.sol
2 
3 pragma solidity 0.4.24;
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
73 pragma solidity 0.4.24;
74 
75 
76 /**
77  * Utility library of inline functions on addresses
78  */
79 library AddressUtils {
80 
81     /**
82      * Returns whether the target address is a contract
83      * @dev This function will return false if invoked during the constructor of a contract,
84      * as the code is not actually created until after the constructor finishes.
85      * @param addr address to check
86      * @return whether the target address is a contract
87      */
88     function isContract(address addr) internal view returns (bool) {
89         uint256 size;
90         // XXX Currently there is no better way to check if there is a contract in an address
91         // than to check the size of the code at that address.
92         // See https://ethereum.stackexchange.com/a/14016/36603
93         // for more details about how this works.
94         // TODO Check this again before the Serenity release, because all addresses will be
95         // contracts then.
96         // solium-disable-next-line security/no-inline-assembly
97         assembly { size := extcodesize(addr) }
98         return size > 0;
99     }
100 
101 }
102 
103 // File: contracts/zeppelin/UpgradeabilityProxy.sol
104 
105 pragma solidity 0.4.24;
106 
107 
108 
109 /**
110  * @title UpgradeabilityProxy
111  * @dev This contract implements a proxy that allows to change the
112  * implementation address to which it will delegate.
113  * Such a change is called an implementation upgrade.
114  */
115 contract UpgradeabilityProxy is Proxy {
116     /**
117      * @dev Emitted when the implementation is upgraded.
118      * @param implementation Address of the new implementation.
119      */
120     event Upgraded(address implementation);
121 
122     /**
123      * @dev Storage slot with the address of the current implementation.
124      * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
125      * validated in the constructor.
126      */
127     bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
128 
129     /**
130      * @dev Contract constructor.
131      * @param _implementation Address of the initial implementation.
132      */
133     constructor(address _implementation) public {
134         assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
135 
136         _setImplementation(_implementation);
137     }
138 
139     /**
140      * @dev Returns the current implementation.
141      * @return Address of the current implementation
142      */
143     function _implementation() internal view returns (address impl) {
144         bytes32 slot = IMPLEMENTATION_SLOT;
145         assembly {
146             impl := sload(slot)
147         }
148     }
149 
150     /**
151      * @dev Upgrades the proxy to a new implementation.
152      * @param newImplementation Address of the new implementation.
153      */
154     function _upgradeTo(address newImplementation) internal {
155         _setImplementation(newImplementation);
156         emit Upgraded(newImplementation);
157     }
158 
159     /**
160      * @dev Sets the implementation address of the proxy.
161      * @param newImplementation Address of the new implementation.
162      */
163     function _setImplementation(address newImplementation) private {
164         require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
165 
166         bytes32 slot = IMPLEMENTATION_SLOT;
167 
168         assembly {
169             sstore(slot, newImplementation)
170         }
171     }
172 }
173 
174 // File: contracts/zeppelin/AdminUpgradeabilityProxy.sol
175 
176 pragma solidity 0.4.24;
177 
178 
179 /**
180  * @title AdminUpgradeabilityProxy
181  * @dev This contract combines an upgradeability proxy with an authorization
182  * mechanism for administrative tasks.
183  * All external functions in this contract must be guarded by the
184  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
185  * feature proposal that would enable this to be done automatically.
186  */
187 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
188     /**
189      * @dev Emitted when the administration has been transferred.
190      * @param previousAdmin Address of the previous admin.
191      * @param newAdmin Address of the new admin.
192      */
193     event AdminChanged(address previousAdmin, address newAdmin);
194 
195     /**
196      * @dev Storage slot with the admin of the contract.
197      * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
198      * validated in the constructor.
199      */
200     bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
201 
202     /**
203      * @dev Modifier to check whether the `msg.sender` is the admin.
204      * If it is, it will run the function. Otherwise, it will delegate the call
205      * to the implementation.
206      */
207     modifier ifAdmin() {
208         if (msg.sender == _admin()) {
209             _;
210         } else {
211             _fallback();
212         }
213     }
214 
215     /**
216      * Contract constructor.
217      * It sets the `msg.sender` as the proxy administrator.
218      * @param _implementation address of the initial implementation.
219      */
220     constructor(address _implementation) UpgradeabilityProxy(_implementation) public {
221         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
222 
223         _setAdmin(msg.sender);
224     }
225 
226     /**
227      * @return The address of the proxy admin.
228      */
229     function admin() external view ifAdmin returns (address) {
230         return _admin();
231     }
232 
233     /**
234      * @return The address of the implementation.
235      */
236     function implementation() external view ifAdmin returns (address) {
237         return _implementation();
238     }
239 
240     /**
241      * @dev Changes the admin of the proxy.
242      * Only the current admin can call this function.
243      * @param newAdmin Address to transfer proxy administration to.
244      */
245     function changeAdmin(address newAdmin) external ifAdmin {
246         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
247         emit AdminChanged(_admin(), newAdmin);
248         _setAdmin(newAdmin);
249     }
250 
251     /**
252      * @dev Upgrade the backing implementation of the proxy.
253      * Only the admin can call this function.
254      * @param newImplementation Address of the new implementation.
255      */
256     function upgradeTo(address newImplementation) external ifAdmin {
257         _upgradeTo(newImplementation);
258     }
259 
260     /**
261      * @dev Upgrade the backing implementation of the proxy and call a function
262      * on the new implementation.
263      * This is useful to initialize the proxied contract.
264      * @param newImplementation Address of the new implementation.
265      * @param data Data to send as msg.data in the low level call.
266      * It should include the signature and the parameters of the function to be
267      * called, as described in
268      * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
269      */
270     function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
271         _upgradeTo(newImplementation);
272         require(address(this).call.value(msg.value)(data));
273     }
274 
275     /**
276      * @return The admin slot.
277      */
278     function _admin() internal view returns (address adm) {
279         bytes32 slot = ADMIN_SLOT;
280         assembly {
281             adm := sload(slot)
282         }
283     }
284 
285     /**
286      * @dev Sets the address of the proxy admin.
287      * @param newAdmin Address of the new proxy admin.
288      */
289     function _setAdmin(address newAdmin) internal {
290         bytes32 slot = ADMIN_SLOT;
291 
292         assembly {
293             sstore(slot, newAdmin)
294         }
295     }
296 
297     /**
298      * @dev Only fall back when the sender is not the admin.
299      */
300     function _willFallback() internal {
301         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
302         super._willFallback();
303     }
304 }