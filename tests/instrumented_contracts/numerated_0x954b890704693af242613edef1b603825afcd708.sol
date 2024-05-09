1 pragma solidity ^0.4.13;
2 
3 library AddressUtils {
4 
5   /**
6    * Returns whether the target address is a contract
7    * @dev This function will return false if invoked during the constructor of a contract,
8    * as the code is not actually created until after the constructor finishes.
9    * @param _addr address to check
10    * @return whether the target address is a contract
11    */
12   function isContract(address _addr) internal view returns (bool) {
13     uint256 size;
14     // XXX Currently there is no better way to check if there is a contract in an address
15     // than to check the size of the code at that address.
16     // See https://ethereum.stackexchange.com/a/14016/36603
17     // for more details about how this works.
18     // TODO Check this again before the Serenity release, because all addresses will be
19     // contracts then.
20     // solium-disable-next-line security/no-inline-assembly
21     assembly { size := extcodesize(_addr) }
22     return size > 0;
23   }
24 
25 }
26 
27 contract Proxy {
28   /**
29    * @dev Fallback function.
30    * Implemented entirely in `_fallback`.
31    */
32   function () payable external {
33     _fallback();
34   }
35 
36   /**
37    * @return The Address of the implementation.
38    */
39   function _implementation() internal view returns (address);
40 
41   /**
42    * @dev Delegates execution to an implementation contract.
43    * This is a low level function that doesn't return to its internal call site.
44    * It will return to the external caller whatever the implementation returns.
45    * @param implementation Address to delegate.
46    */
47   function _delegate(address implementation) internal {
48     assembly {
49       // Copy msg.data. We take full control of memory in this inline assembly
50       // block because it will not return to Solidity code. We overwrite the
51       // Solidity scratch pad at memory position 0.
52       calldatacopy(0, 0, calldatasize)
53 
54       // Call the implementation.
55       // out and outsize are 0 because we don't know the size yet.
56       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
57 
58       // Copy the returned data.
59       returndatacopy(0, 0, returndatasize)
60 
61       switch result
62       // delegatecall returns 0 on error.
63       case 0 { revert(0, returndatasize) }
64       default { return(0, returndatasize) }
65     }
66   }
67 
68   /**
69    * @dev Function that is run as the first thing in the fallback function.
70    * Can be redefined in derived contracts to add functionality.
71    * Redefinitions must call super._willFallback().
72    */
73   function _willFallback() internal {
74   }
75 
76   /**
77    * @dev fallback implementation.
78    * Extracted to enable manual triggering.
79    */
80   function _fallback() internal {
81     _willFallback();
82     _delegate(_implementation());
83   }
84 }
85 
86 contract UpgradeabilityProxy is Proxy {
87   /**
88    * @dev Emitted when the implementation is upgraded.
89    * @param implementation Address of the new implementation.
90    */
91   event Upgraded(address implementation);
92 
93   /**
94    * @dev Storage slot with the address of the current implementation.
95    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
96    * validated in the constructor.
97    */
98   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
99 
100   /**
101    * @dev Contract constructor.
102    * @param _implementation Address of the initial implementation.
103    */
104   constructor(address _implementation) public {
105     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
106 
107     _setImplementation(_implementation);
108   }
109 
110   /**
111    * @dev Returns the current implementation.
112    * @return Address of the current implementation
113    */
114   function _implementation() internal view returns (address impl) {
115     bytes32 slot = IMPLEMENTATION_SLOT;
116     assembly {
117       impl := sload(slot)
118     }
119   }
120 
121   /**
122    * @dev Upgrades the proxy to a new implementation.
123    * @param newImplementation Address of the new implementation.
124    */
125   function _upgradeTo(address newImplementation) internal {
126     _setImplementation(newImplementation);
127     emit Upgraded(newImplementation);
128   }
129 
130   /**
131    * @dev Sets the implementation address of the proxy.
132    * @param newImplementation Address of the new implementation.
133    */
134   function _setImplementation(address newImplementation) private {
135     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
136 
137     bytes32 slot = IMPLEMENTATION_SLOT;
138 
139     assembly {
140       sstore(slot, newImplementation)
141     }
142   }
143 }
144 
145 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
146   /**
147    * @dev Emitted when the administration has been transferred.
148    * @param previousAdmin Address of the previous admin.
149    * @param newAdmin Address of the new admin.
150    */
151   event AdminChanged(address previousAdmin, address newAdmin);
152 
153   /**
154    * @dev Storage slot with the admin of the contract.
155    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
156    * validated in the constructor.
157    */
158   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
159 
160   /**
161    * @dev Modifier to check whether the `msg.sender` is the admin.
162    * If it is, it will run the function. Otherwise, it will delegate the call
163    * to the implementation.
164    */
165   modifier ifAdmin() {
166     if (msg.sender == _admin()) {
167       _;
168     } else {
169       _fallback();
170     }
171   }
172 
173   /**
174    * Contract constructor.
175    * It sets the `msg.sender` as the proxy administrator.
176    * @param _implementation address of the initial implementation.
177    */
178   constructor(address _implementation) UpgradeabilityProxy(_implementation) public {
179     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
180 
181     _setAdmin(msg.sender);
182   }
183 
184   /**
185    * @return The address of the proxy admin.
186    */
187   function admin() external view ifAdmin returns (address) {
188     return _admin();
189   }
190 
191   /**
192    * @return The address of the implementation.
193    */
194   function implementation() external view ifAdmin returns (address) {
195     return _implementation();
196   }
197 
198   /**
199    * @dev Changes the admin of the proxy.
200    * Only the current admin can call this function.
201    * @param newAdmin Address to transfer proxy administration to.
202    */
203   function changeAdmin(address newAdmin) external ifAdmin {
204     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
205     emit AdminChanged(_admin(), newAdmin);
206     _setAdmin(newAdmin);
207   }
208 
209   /**
210    * @dev Upgrade the backing implementation of the proxy.
211    * Only the admin can call this function.
212    * @param newImplementation Address of the new implementation.
213    */
214   function upgradeTo(address newImplementation) external ifAdmin {
215     _upgradeTo(newImplementation);
216   }
217 
218   /**
219    * @dev Upgrade the backing implementation of the proxy and call a function
220    * on the new implementation.
221    * This is useful to initialize the proxied contract.
222    * @param newImplementation Address of the new implementation.
223    * @param data Data to send as msg.data in the low level call.
224    * It should include the signature and the parameters of the function to be
225    * called, as described in
226    * https://solidity.readthedocs.io/en/develop/abi-spec.html#function-selector-and-argument-encoding.
227    */
228   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
229     _upgradeTo(newImplementation);
230     require(address(this).call.value(msg.value)(data));
231   }
232 
233   /**
234    * @return The admin slot.
235    */
236   function _admin() internal view returns (address adm) {
237     bytes32 slot = ADMIN_SLOT;
238     assembly {
239       adm := sload(slot)
240     }
241   }
242 
243   /**
244    * @dev Sets the address of the proxy admin.
245    * @param newAdmin Address of the new proxy admin.
246    */
247   function _setAdmin(address newAdmin) internal {
248     bytes32 slot = ADMIN_SLOT;
249 
250     assembly {
251       sstore(slot, newAdmin)
252     }
253   }
254 
255   /**
256    * @dev Only fall back when the sender is not the admin.
257    */
258   function _willFallback() internal {
259     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
260     super._willFallback();
261   }
262 }