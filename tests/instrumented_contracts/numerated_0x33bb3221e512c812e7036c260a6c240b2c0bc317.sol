1 pragma solidity ^0.4.25;
2 
3 // -------------------------------------------------------------------
4 // Medical Coin Proxy
5 // -------------------------------------------------------------------
6 
7 /**
8  * @title ApproveAndCall
9  * @dev Interface function called from `approveAndCall` notifying that the approval happened
10  */
11 contract ApproveAndCall {
12     function receiveApproval(address _from, uint256 _amount, address _tokenContract, bytes _data) public returns (bool);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 {
20     function transfer(address to, uint256 value) public returns (bool);
21     function approve(address spender, uint256 value) public returns (bool);
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23     function balanceOf(address _who) public view returns (uint256);
24     function allowance(address _owner, address _spender) public view returns (uint256);
25 }
26 
27 /**
28  * @title Proxy
29  * @dev Implements delegation of calls to other contracts, with proper
30  * forwarding of return values and bubbling of failures.
31  * It defines a fallback function that delegates all calls to the address
32  * returned by the abstract _implementation() internal function.
33  */
34 contract Proxy {
35     /**
36      * @dev Fallback function.
37      * Implemented entirely in `_fallback`.
38      */
39     function () payable external {
40         _fallback();
41     }
42 
43     /**
44      * @return The Address of the implementation.
45      */
46     function _implementation() internal view returns (address);
47 
48     /**
49      * @dev Delegates execution to an implementation contract.
50      * This is a low level function that doesn't return to its internal call site.
51      * It will return to the external caller whatever the implementation returns.
52      * @param implementation Address to delegate.
53      */
54     function _delegate(address implementation) internal {
55         assembly {
56         // Copy msg.data. We take full control of memory in this inline assembly
57         // block because it will not return to Solidity code. We overwrite the
58         // Solidity scratch pad at memory position 0.
59             calldatacopy(0, 0, calldatasize)
60 
61         // Call the implementation.
62         // out and outsize are 0 because we don't know the size yet.
63             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
64 
65         // Copy the returned data.
66             returndatacopy(0, 0, returndatasize)
67 
68             switch result
69             // delegatecall returns 0 on error.
70             case 0 { revert(0, returndatasize) }
71             default { return(0, returndatasize) }
72         }
73     }
74 
75     /**
76      * @dev Function that is run as the first thing in the fallback function.
77      * Can be redefined in derived contracts to add functionality.
78      * Redefinitions must call super._willFallback().
79      */
80     function _willFallback() internal {
81     }
82 
83     /**
84      * @dev fallback implementation.
85      * Extracted to enable manual triggering.
86      */
87     function _fallback() internal {
88         _willFallback();
89         _delegate(_implementation());
90     }
91 }
92 
93 /**
94  * @title UpgradeabilityProxy
95  * @dev This contract implements a proxy that allows to change the
96  * implementation address to which it will delegate.
97  * Such a change is called an implementation upgrade.
98  */
99 contract UpgradeabilityProxy is Proxy {
100     /**
101      * @dev Emitted when the implementation is upgraded.
102      * @param implementation Address of the new implementation.
103      */
104     event Upgraded(address indexed implementation);
105 
106     /**
107      * @dev Storage slot with the address of the current implementation.
108      * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
109      * validated in the constructor.
110      */
111     bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
112 
113     /**
114      * @dev Contract constructor.
115      * @param _implementation Address of the initial implementation.
116      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
117      * It should include the signature and the parameters of the function to be called, as described in
118      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
119      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
120      */
121     constructor(address _implementation, bytes memory _data) public payable {
122         assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
123         _setImplementation(_implementation);
124         if(_data.length > 0) {
125             require(_implementation.delegatecall(_data));
126         }
127     }
128 
129     /**
130      * @dev Returns the current implementation.
131      * @return Address of the current implementation
132      */
133     function _implementation() internal view returns (address impl) {
134         bytes32 slot = IMPLEMENTATION_SLOT;
135         assembly {
136             impl := sload(slot)
137         }
138     }
139 
140     /**
141      * @dev Upgrades the proxy to a new implementation.
142      * @param newImplementation Address of the new implementation.
143      */
144     function _upgradeTo(address newImplementation) internal {
145         _setImplementation(newImplementation);
146         emit Upgraded(newImplementation);
147     }
148 
149     /**
150      * @dev Sets the implementation address of the proxy.
151      * @param newImplementation Address of the new implementation.
152      */
153     function _setImplementation(address newImplementation) private {
154         require(isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
155 
156         bytes32 slot = IMPLEMENTATION_SLOT;
157 
158         assembly {
159             sstore(slot, newImplementation)
160         }
161     }
162 
163     /**
164      * Returns whether the target address is a contract
165      * @dev This function will return false if invoked during the constructor of a contract,
166      * as the code is not actually created until after the constructor finishes.
167      * @param account address of the account to check
168      * @return whether the target address is a contract
169      */
170     function isContract(address account) internal view returns (bool) {
171         uint256 size;
172         // XXX Currently there is no better way to check if there is a contract in an address
173         // than to check the size of the code at that address.
174         // See https://ethereum.stackexchange.com/a/14016/36603
175         // for more details about how this works.
176         // Check this again before the Serenity release, because all addresses will be
177         // contracts then.
178         // solium-disable-next-line security/no-inline-assembly
179         assembly { size := extcodesize(account) }
180         return size > 0;
181     }
182 }
183 
184 /**
185  * @title AdminUpgradeabilityProxy
186  * @dev This contract combines an upgradeability proxy with an authorization
187  * mechanism for administrative tasks.
188  * All external functions in this contract must be guarded by the
189  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
190  * feature proposal that would enable this to be done automatically.
191  */
192 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
193     /**
194      * @dev Emitted when the administration has been transferred.
195      * @param previousAdmin Address of the previous admin.
196      * @param newAdmin Address of the new admin.
197      */
198     event AdminChanged(address previousAdmin, address newAdmin);
199 
200     /**
201      * @dev Storage slot with the admin of the contract.
202      * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
203      * validated in the constructor.
204      */
205     bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
206 
207     /**
208      * @dev Modifier to check whether the `msg.sender` is the admin.
209      * If it is, it will run the function. Otherwise, it will delegate the call
210      * to the implementation.
211      */
212     modifier ifAdmin() {
213         if (msg.sender == _admin()) {
214             _;
215         } else {
216             _fallback();
217         }
218     }
219 
220     /**
221      * Contract constructor.
222      * It sets the `msg.sender` as the proxy administrator.
223      * @param _implementation address of the initial implementation.
224      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
225      * It should include the signature and the parameters of the function to be called, as described in
226      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
227      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
228      */
229     constructor(address _implementation, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
230         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
231 
232         _setAdmin(msg.sender);
233     }
234 
235     /**
236      * @return The address of the proxy admin.
237      */
238     function admin() external view ifAdmin returns (address) {
239         return _admin();
240     }
241 
242     /**
243      * @return The address of the implementation.
244      */
245     function implementation() external view ifAdmin returns (address) {
246         return _implementation();
247     }
248 
249     /**
250      * @dev Changes the admin of the proxy.
251      * Only the current admin can call this function.
252      * @param newAdmin Address to transfer proxy administration to.
253      */
254     function changeAdmin(address newAdmin) external ifAdmin {
255         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
256         emit AdminChanged(_admin(), newAdmin);
257         _setAdmin(newAdmin);
258     }
259 
260     /**
261      * @dev Upgrade the backing implementation of the proxy.
262      * Only the admin can call this function.
263      * @param newImplementation Address of the new implementation.
264      */
265     function upgradeTo(address newImplementation) external ifAdmin {
266         _upgradeTo(newImplementation);
267     }
268 
269     /**
270      * @dev Upgrade the backing implementation of the proxy and call a function
271      * on the new implementation.
272      * This is useful to initialize the proxied contract.
273      * @param newImplementation Address of the new implementation.
274      * @param data Data to send as msg.data in the low level call.
275      * It should include the signature and the parameters of the function to be called, as described in
276      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
277      */
278     function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
279         _upgradeTo(newImplementation);
280         require(newImplementation.delegatecall(data));
281     }
282 
283     /**
284      * @return The admin slot.
285      */
286     function _admin() internal view returns (address adm) {
287         bytes32 slot = ADMIN_SLOT;
288         assembly {
289             adm := sload(slot)
290         }
291     }
292 
293     /**
294      * @dev Sets the address of the proxy admin.
295      * @param newAdmin Address of the new proxy admin.
296      */
297     function _setAdmin(address newAdmin) internal {
298         bytes32 slot = ADMIN_SLOT;
299 
300         assembly {
301             sstore(slot, newAdmin)
302         }
303     }
304 
305     /**
306      * @dev Only fall back when the sender is not the admin.
307      */
308     function _willFallback() internal {
309         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
310         super._willFallback();
311     }
312 }
313 
314 contract MedicalCoinProxy is AdminUpgradeabilityProxy {
315 
316     constructor(address _implementation, bytes _data) AdminUpgradeabilityProxy(_implementation, _data) public payable {
317     }
318 }