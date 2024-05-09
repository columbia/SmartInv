1 // File: contracts/zos/upgradeability/Proxy.sol
2 
3 /**
4  * The MIT License (MIT)
5  *
6  * ZeppelinOS (zos) <https://github.com/zeppelinos/zos>
7  * Copyright (c) 2018 ZeppelinOS Global Limited.
8  * 
9  * Permission is hereby granted, free of charge, to any person obtaining a copy 
10  * of this software and associated documentation files (the "Software"), to deal 
11  * in the Software without restriction, including without limitation the rights 
12  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
13  * copies of the Software, and to permit persons to whom the Software is furnished to 
14  * do so, subject to the following conditions:
15  *
16  * The above copyright notice and this permission notice shall be included in all 
17  * copies or substantial portions of the Software.
18  *
19  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
20  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
21  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
22  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
23  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
24  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
25  */
26 pragma solidity 0.4.25;
27 
28 /**
29  * @title Proxy
30  * @dev Implements delegation of calls to other contracts, with proper
31  * forwarding of return values and bubbling of failures.
32  * It defines a fallback function that delegates all calls to the address
33  * returned by the abstract _implementation() internal function.
34  */
35 contract Proxy {
36   /**
37    * @dev Fallback function.
38    * Implemented entirely in `_fallback`.
39    */
40   function () payable external {
41     _fallback();
42   }
43 
44   /**
45    * @return The Address of the implementation.
46    */
47   function _implementation() internal view returns (address);
48 
49   /**
50    * @dev Delegates execution to an implementation contract.
51    * This is a low level function that doesn't return to its internal call site.
52    * It will return to the external caller whatever the implementation returns.
53    * @param implementation Address to delegate.
54    */
55   function _delegate(address implementation) internal {
56     assembly {
57       // Copy msg.data. We take full control of memory in this inline assembly
58       // block because it will not return to Solidity code. We overwrite the
59       // Solidity scratch pad at memory position 0.
60       calldatacopy(0, 0, calldatasize)
61 
62       // Call the implementation.
63       // out and outsize are 0 because we don't know the size yet.
64       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
65 
66       // Copy the returned data.
67       returndatacopy(0, 0, returndatasize)
68 
69       switch result
70       // delegatecall returns 0 on error.
71       case 0 { revert(0, returndatasize) }
72       default { return(0, returndatasize) }
73     }
74   }
75 
76   /**
77    * @dev Function that is run as the first thing in the fallback function.
78    * Can be redefined in derived contracts to add functionality.
79    * Redefinitions must call super._willFallback().
80    */
81   function _willFallback() internal {
82   }
83 
84   /**
85    * @dev fallback implementation.
86    * Extracted to enable manual triggering.
87    */
88   function _fallback() internal {
89     _willFallback();
90     _delegate(_implementation());
91   }
92 }
93 
94 // File: contracts/utils/Address.sol
95 
96 /**
97  * The MIT License (MIT)
98  *
99  * OpenZeppelin <https://github.com/OpenZeppelin/openzeppelin-solidity/>     
100  * Copyright (c) 2016 Smart Contract Solutions, Inc.
101  *
102  * Permission is hereby granted, free of charge, to any person obtaining a copy 
103  * of this software and associated documentation files (the "Software"), to deal 
104  * in the Software without restriction, including without limitation the rights 
105  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
106  * copies of the Software, and to permit persons to whom the Software is furnished to 
107  * do so, subject to the following conditions:
108  *
109  * The above copyright notice and this permission notice shall be included in all 
110  * copies or substantial portions of the Software.
111  *
112  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
113  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
114  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
115  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
116  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
117  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
118  */
119 pragma solidity 0.4.25;
120 
121 /**
122  * Utility library of inline functions on addresses
123  */
124 library Address {
125     /**
126      * Returns whether the target address is a contract
127      * @dev This function will return false if invoked during the constructor of a contract,
128      * as the code is not actually created until after the constructor finishes.
129      * @param account address of the account to check
130      * @return whether the target address is a contract
131      */
132     function isContract(address account) internal view returns (bool) {
133         uint256 size;
134         // XXX Currently there is no better way to check if there is a contract in an address
135         // than to check the size of the code at that address.
136         // See https://ethereum.stackexchange.com/a/14016/36603
137         // for more details about how this works.
138         // TODO Check this again before the Serenity release, because all addresses will be
139         // contracts then.
140         // solhint-disable-next-line no-inline-assembly
141         assembly { size := extcodesize(account) }
142         return size > 0;
143     }
144 }
145 
146 // File: contracts/zos/upgradeability/UpgradeabilityProxy.sol
147 
148 /**
149  * The MIT License (MIT)
150  *
151  * ZeppelinOS (zos) <https://github.com/zeppelinos/zos>
152  * Copyright (c) 2018 ZeppelinOS Global Limited.
153  * 
154  * Permission is hereby granted, free of charge, to any person obtaining a copy 
155  * of this software and associated documentation files (the "Software"), to deal 
156  * in the Software without restriction, including without limitation the rights 
157  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
158  * copies of the Software, and to permit persons to whom the Software is furnished to 
159  * do so, subject to the following conditions:
160  *
161  * The above copyright notice and this permission notice shall be included in all 
162  * copies or substantial portions of the Software.
163  *
164  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
165  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
166  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
167  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
168  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
169  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
170  */
171 pragma solidity 0.4.25;
172 
173 
174 
175 /**
176  * @title UpgradeabilityProxy
177  * @dev This contract implements a proxy that allows to change the
178  * implementation address to which it will delegate.
179  * Such a change is called an implementation upgrade.
180  */
181 contract UpgradeabilityProxy is Proxy {
182   /**
183    * @dev Emitted when the implementation is upgraded.
184    * @param implementation Address of the new implementation.
185    */
186   event Upgraded(address indexed implementation);
187 
188   /**
189    * @dev Storage slot with the address of the current implementation.
190    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
191    * validated in the constructor.
192    */
193   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
194 
195   /**
196    * @dev Contract constructor.
197    * @param _implementation Address of the initial implementation.
198    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
199    * It should include the signature and the parameters of the function to be called, as described in
200    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
201    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
202    */
203   constructor(address _implementation, bytes _data) public payable {
204     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
205     _setImplementation(_implementation);
206     if(_data.length > 0) {
207       require(_implementation.delegatecall(_data));
208     }
209   }
210 
211   /**
212    * @dev Returns the current implementation.
213    * @return Address of the current implementation
214    */
215   function _implementation() internal view returns (address impl) {
216     bytes32 slot = IMPLEMENTATION_SLOT;
217     assembly {
218       impl := sload(slot)
219     }
220   }
221 
222   /**
223    * @dev Upgrades the proxy to a new implementation.
224    * @param newImplementation Address of the new implementation.
225    */
226   function _upgradeTo(address newImplementation) internal {
227     _setImplementation(newImplementation);
228     emit Upgraded(newImplementation);
229   }
230 
231   /**
232    * @dev Sets the implementation address of the proxy.
233    * @param newImplementation Address of the new implementation.
234    */
235   function _setImplementation(address newImplementation) private {
236     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
237 
238     bytes32 slot = IMPLEMENTATION_SLOT;
239 
240     assembly {
241       sstore(slot, newImplementation)
242     }
243   }
244 }
245 
246 // File: contracts/zos/upgradeability/AdminUpgradeabilityProxy.sol
247 
248 /**
249  * The MIT License (MIT)
250  *
251  * ZeppelinOS (zos) <https://github.com/zeppelinos/zos>
252  * Copyright (c) 2018 ZeppelinOS Global Limited.
253  * 
254  * Permission is hereby granted, free of charge, to any person obtaining a copy 
255  * of this software and associated documentation files (the "Software"), to deal 
256  * in the Software without restriction, including without limitation the rights 
257  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
258  * copies of the Software, and to permit persons to whom the Software is furnished to 
259  * do so, subject to the following conditions:
260  *
261  * The above copyright notice and this permission notice shall be included in all 
262  * copies or substantial portions of the Software.
263  *
264  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
265  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
266  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
267  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
268  * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
269  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
270  */
271 pragma solidity 0.4.25;
272 
273 
274 /**
275  * @title AdminUpgradeabilityProxy
276  * @dev This contract combines an upgradeability proxy with an authorization
277  * mechanism for administrative tasks.
278  * All external functions in this contract must be guarded by the
279  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
280  * feature proposal that would enable this to be done automatically.
281  */
282 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
283   /**
284    * @dev Emitted when the administration has been transferred.
285    * @param previousAdmin Address of the previous admin.
286    * @param newAdmin Address of the new admin.
287    */
288   event AdminChanged(address previousAdmin, address newAdmin);
289 
290   /**
291    * @dev Storage slot with the admin of the contract.
292    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
293    * validated in the constructor.
294    */
295   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
296 
297   /**
298    * @dev Modifier to check whether the `msg.sender` is the admin.
299    * If it is, it will run the function. Otherwise, it will delegate the call
300    * to the implementation.
301    */
302   modifier ifAdmin() {
303     if (msg.sender == _admin()) {
304       _;
305     } else {
306       _fallback();
307     }
308   }
309 
310   /**
311    * Contract constructor.
312    * @param _implementation address of the initial implementation.
313    * @param _admin Address of the proxy administrator.
314    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
315    * It should include the signature and the parameters of the function to be called, as described in
316    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
317    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
318    */
319   constructor(address _implementation, address _admin, bytes _data) UpgradeabilityProxy(_implementation, _data) public payable {
320     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
321 
322     _setAdmin(_admin);
323   }
324 
325   /**
326    * @return The address of the proxy admin.
327    */
328   function admin() external view ifAdmin returns (address) {
329     return _admin();
330   }
331 
332   /**
333    * @return The address of the implementation.
334    */
335   function implementation() external view ifAdmin returns (address) {
336     return _implementation();
337   }
338 
339   /**
340    * @dev Changes the admin of the proxy.
341    * Only the current admin can call this function.
342    * @param newAdmin Address to transfer proxy administration to.
343    */
344   function changeAdmin(address newAdmin) external ifAdmin {
345     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
346     emit AdminChanged(_admin(), newAdmin);
347     _setAdmin(newAdmin);
348   }
349 
350   /**
351    * @dev Upgrade the backing implementation of the proxy.
352    * Only the admin can call this function.
353    * @param newImplementation Address of the new implementation.
354    */
355   function upgradeTo(address newImplementation) external ifAdmin {
356     _upgradeTo(newImplementation);
357   }
358 
359   /**
360    * @dev Upgrade the backing implementation of the proxy and call a function
361    * on the new implementation.
362    * This is useful to initialize the proxied contract.
363    * @param newImplementation Address of the new implementation.
364    * @param data Data to send as msg.data in the low level call.
365    * It should include the signature and the parameters of the function to be called, as described in
366    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
367    */
368   function upgradeToAndCall(address newImplementation, bytes data) payable external ifAdmin {
369     _upgradeTo(newImplementation);
370     require(newImplementation.delegatecall(data));
371   }
372 
373   /**
374    * @return The admin slot.
375    */
376   function _admin() internal view returns (address adm) {
377     bytes32 slot = ADMIN_SLOT;
378     assembly {
379       adm := sload(slot)
380     }
381   }
382 
383   /**
384    * @dev Sets the address of the proxy admin.
385    * @param newAdmin Address of the new proxy admin.
386    */
387   function _setAdmin(address newAdmin) internal {
388     bytes32 slot = ADMIN_SLOT;
389 
390     assembly {
391       sstore(slot, newAdmin)
392     }
393   }
394 
395   /**
396    * @dev Only fall back when the sender is not the admin.
397    */
398   function _willFallback() internal {
399     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
400     super._willFallback();
401   }
402 }