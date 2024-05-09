1 pragma solidity ^0.4.26;
2 
3 // ---------------------------------------------------------------------
4 // Zipmex Token Proxy - https://zipmex.com
5 //
6 // Notes          : This contract is a proxy to the Zipmex Token.
7 //                  It allows upgradeability using CALLDELEGATE pattern (code courtesy of https://openzeppelin.org/).
8 //                  This address should be accessed with the ABI of the current token delegate contract.
9 //
10 // Author: Radek Ostrowski - radek@startonchain.com
11 // ---------------------------------------------------------------------
12 
13 /**
14  * @title ApproveAndCall
15  * @dev Interface function called from `approveAndCall` notifying that the approval happened
16  */
17 contract ApproveAndCall {
18     function receiveApproval(address _from, uint256 _amount, address _tokenContract, bytes _data) public returns (bool);
19 }
20 
21 /**
22  * @title ERC20 interface
23  * @dev see https://github.com/ethereum/EIPs/issues/20
24  */
25 contract ERC20 {
26     function transfer(address to, uint256 value) public returns (bool);
27     function approve(address spender, uint256 value) public returns (bool);
28     function transferFrom(address from, address to, uint256 value) public returns (bool);
29     function balanceOf(address _who) public view returns (uint256);
30     function allowance(address _owner, address _spender) public view returns (uint256);
31 }
32 
33 /**
34  * @title Proxy
35  * @dev Implements delegation of calls to other contracts, with proper
36  * forwarding of return values and bubbling of failures.
37  * It defines a fallback function that delegates all calls to the address
38  * returned by the abstract _implementation() internal function.
39  */
40 contract Proxy {
41     /**
42      * @dev Fallback function.
43      * Implemented entirely in `_fallback`.
44      */
45     function () payable external {
46         _fallback();
47     }
48 
49     /**
50      * @return The Address of the implementation.
51      */
52     function _implementation() internal view returns (address);
53 
54     /**
55      * @dev Delegates execution to an implementation contract.
56      * This is a low level function that doesn't return to its internal call site.
57      * It will return to the external caller whatever the implementation returns.
58      * @param implementation Address to delegate.
59      */
60     function _delegate(address implementation) internal {
61         assembly {
62         // Copy msg.data. We take full control of memory in this inline assembly
63         // block because it will not return to Solidity code. We overwrite the
64         // Solidity scratch pad at memory position 0.
65             calldatacopy(0, 0, calldatasize)
66 
67         // Call the implementation.
68         // out and outsize are 0 because we don't know the size yet.
69             let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
70 
71         // Copy the returned data.
72             returndatacopy(0, 0, returndatasize)
73 
74             switch result
75             // delegatecall returns 0 on error.
76             case 0 { revert(0, returndatasize) }
77             default { return(0, returndatasize) }
78         }
79     }
80 
81     /**
82      * @dev Function that is run as the first thing in the fallback function.
83      * Can be redefined in derived contracts to add functionality.
84      * Redefinitions must call super._willFallback().
85      */
86     function _willFallback() internal {
87     }
88 
89     /**
90      * @dev fallback implementation.
91      * Extracted to enable manual triggering.
92      */
93     function _fallback() internal {
94         _willFallback();
95         _delegate(_implementation());
96     }
97 }
98 
99 /**
100  * @title UpgradeabilityProxy
101  * @dev This contract implements a proxy that allows to change the
102  * implementation address to which it will delegate.
103  * Such a change is called an implementation upgrade.
104  */
105 contract UpgradeabilityProxy is Proxy {
106     /**
107      * @dev Emitted when the implementation is upgraded.
108      * @param implementation Address of the new implementation.
109      */
110     event Upgraded(address indexed implementation);
111 
112     /**
113      * @dev Storage slot with the address of the current implementation.
114      * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
115      * validated in the constructor.
116      */
117     bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
118 
119     /**
120      * @dev Contract constructor.
121      * @param _implementation Address of the initial implementation.
122      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
123      * It should include the signature and the parameters of the function to be called, as described in
124      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
125      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
126      */
127     constructor(address _implementation, bytes memory _data) public payable {
128         assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
129         _setImplementation(_implementation);
130         if(_data.length > 0) {
131             require(_implementation.delegatecall(_data));
132         }
133     }
134 
135     /**
136      * @dev Returns the current implementation.
137      * @return Address of the current implementation
138      */
139     function _implementation() internal view returns (address impl) {
140         bytes32 slot = IMPLEMENTATION_SLOT;
141         assembly {
142             impl := sload(slot)
143         }
144     }
145 
146     /**
147      * @dev Upgrades the proxy to a new implementation.
148      * @param newImplementation Address of the new implementation.
149      */
150     function _upgradeTo(address newImplementation) internal {
151         _setImplementation(newImplementation);
152         emit Upgraded(newImplementation);
153     }
154 
155     /**
156      * @dev Sets the implementation address of the proxy.
157      * @param newImplementation Address of the new implementation.
158      */
159     function _setImplementation(address newImplementation) private {
160         require(isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
161 
162         bytes32 slot = IMPLEMENTATION_SLOT;
163 
164         assembly {
165             sstore(slot, newImplementation)
166         }
167     }
168 
169     /**
170      * Returns whether the target address is a contract
171      * @dev This function will return false if invoked during the constructor of a contract,
172      * as the code is not actually created until after the constructor finishes.
173      * @param account address of the account to check
174      * @return whether the target address is a contract
175      */
176     function isContract(address account) internal view returns (bool) {
177         uint256 size;
178         // XXX Currently there is no better way to check if there is a contract in an address
179         // than to check the size of the code at that address.
180         // See https://ethereum.stackexchange.com/a/14016/36603
181         // for more details about how this works.
182         // Check this again before the Serenity release, because all addresses will be
183         // contracts then.
184         // solium-disable-next-line security/no-inline-assembly
185         assembly { size := extcodesize(account) }
186         return size > 0;
187     }
188 }
189 
190 /**
191  * @title AdminUpgradeabilityProxy
192  * @dev This contract combines an upgradeability proxy with an authorization
193  * mechanism for administrative tasks.
194  * All external functions in this contract must be guarded by the
195  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
196  * feature proposal that would enable this to be done automatically.
197  */
198 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
199     /**
200      * @dev Emitted when the administration has been transferred.
201      * @param previousAdmin Address of the previous admin.
202      * @param newAdmin Address of the new admin.
203      */
204     event AdminChanged(address previousAdmin, address newAdmin);
205 
206     /**
207      * @dev Storage slot with the admin of the contract.
208      * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
209      * validated in the constructor.
210      */
211     bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
212 
213     /**
214      * @dev Modifier to check whether the `msg.sender` is the admin.
215      * If it is, it will run the function. Otherwise, it will delegate the call
216      * to the implementation.
217      */
218     modifier ifAdmin() {
219         if (msg.sender == _admin()) {
220             _;
221         } else {
222             _fallback();
223         }
224     }
225 
226     /**
227      * Contract constructor.
228      * It sets the `msg.sender` as the proxy administrator.
229      * @param _implementation address of the initial implementation.
230      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
231      * It should include the signature and the parameters of the function to be called, as described in
232      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
233      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
234      */
235     constructor(address _implementation, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
236         assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
237 
238         _setAdmin(msg.sender);
239     }
240 
241     /**
242      * @return The address of the proxy admin.
243      */
244     function admin() external view ifAdmin returns (address) {
245         return _admin();
246     }
247 
248     /**
249      * @return The address of the implementation.
250      */
251     function implementation() external view ifAdmin returns (address) {
252         return _implementation();
253     }
254 
255     /**
256      * @dev Changes the admin of the proxy.
257      * Only the current admin can call this function.
258      * @param newAdmin Address to transfer proxy administration to.
259      */
260     function changeAdmin(address newAdmin) external ifAdmin {
261         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
262         emit AdminChanged(_admin(), newAdmin);
263         _setAdmin(newAdmin);
264     }
265 
266     /**
267      * @dev Upgrade the backing implementation of the proxy.
268      * Only the admin can call this function.
269      * @param newImplementation Address of the new implementation.
270      */
271     function upgradeTo(address newImplementation) external ifAdmin {
272         _upgradeTo(newImplementation);
273     }
274 
275     /**
276      * @dev Upgrade the backing implementation of the proxy and call a function
277      * on the new implementation.
278      * This is useful to initialize the proxied contract.
279      * @param newImplementation Address of the new implementation.
280      * @param data Data to send as msg.data in the low level call.
281      * It should include the signature and the parameters of the function to be called, as described in
282      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
283      */
284     function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
285         _upgradeTo(newImplementation);
286         require(newImplementation.delegatecall(data));
287     }
288 
289     /**
290      * @return The admin slot.
291      */
292     function _admin() internal view returns (address adm) {
293         bytes32 slot = ADMIN_SLOT;
294         assembly {
295             adm := sload(slot)
296         }
297     }
298 
299     /**
300      * @dev Sets the address of the proxy admin.
301      * @param newAdmin Address of the new proxy admin.
302      */
303     function _setAdmin(address newAdmin) internal {
304         bytes32 slot = ADMIN_SLOT;
305 
306         assembly {
307             sstore(slot, newAdmin)
308         }
309     }
310 
311     /**
312      * @dev Only fall back when the sender is not the admin.
313      */
314     function _willFallback() internal {
315         require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
316         super._willFallback();
317     }
318 }
319 
320 contract ZipmexTokenProxy is AdminUpgradeabilityProxy {
321 
322     constructor(address _implementation, bytes _data) AdminUpgradeabilityProxy(_implementation, _data) public payable {
323     }
324 }