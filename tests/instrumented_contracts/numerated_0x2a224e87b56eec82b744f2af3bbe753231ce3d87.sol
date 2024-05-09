1 /**
2  * Copyright (c) 2018-present, Leap DAO (leapdao.org)
3  *
4  * This source code is licensed under the Mozilla Public License, version 2,
5  * found in the LICENSE file in the root directory of this source tree.
6  */
7 
8 pragma solidity 0.5.2;
9 
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23      * account.
24      */
25     constructor () internal {
26         _owner = msg.sender;
27         emit OwnershipTransferred(address(0), _owner);
28     }
29 
30     /**
31      * @return the address of the owner.
32      */
33     function owner() public view returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(isOwner());
42         _;
43     }
44 
45     /**
46      * @return true if `msg.sender` is the owner of the contract.
47      */
48     function isOwner() public view returns (bool) {
49         return msg.sender == _owner;
50     }
51 
52     /**
53      * @dev Allows the current owner to relinquish control of the contract.
54      * @notice Renouncing to ownership will leave the contract without an owner.
55      * It will not be possible to call the functions with the `onlyOwner`
56      * modifier anymore.
57      */
58     function renounceOwnership() public onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) public onlyOwner {
68         _transferOwnership(newOwner);
69     }
70 
71     /**
72      * @dev Transfers control of the contract to a newOwner.
73      * @param newOwner The address to transfer ownership to.
74      */
75     function _transferOwnership(address newOwner) internal {
76         require(newOwner != address(0));
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 }
81 pragma solidity ^0.5.0;
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 interface IERC20 {
88     function transfer(address to, uint256 value) external returns (bool);
89 
90     function approve(address spender, uint256 value) external returns (bool);
91 
92     function transferFrom(address from, address to, uint256 value) external returns (bool);
93 
94     function totalSupply() external view returns (uint256);
95 
96     function balanceOf(address who) external view returns (uint256);
97 
98     function allowance(address owner, address spender) external view returns (uint256);
99 
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * Copyright (c) 2018-present, Leap DAO (leapdao.org)
107  *
108  * This source code is licensed under the Mozilla Public License, version 2,
109  * found in the LICENSE file in the root directory of this source tree.
110  */
111 
112 
113 pragma solidity 0.5.2;
114 
115 /**
116  * @title Proxy
117  * @dev Implements delegation of calls to other contracts, with proper
118  * forwarding of return values and bubbling of failures.
119  * It defines a fallback function that delegates all calls to the address
120  * returned by the abstract _implementation() internal function.
121  */
122 contract Proxy {
123   /**
124    * @dev Fallback function.
125    * Implemented entirely in `_fallback`.
126    */
127   function () external payable {
128     _fallback();
129   }
130 
131   /**
132    * @return The Address of the implementation.
133    */
134   function _implementation() internal view returns (address);
135 
136   /**
137    * @dev Delegates execution to an implementation contract.
138    * This is a low level function that doesn't return to its internal call site.
139    * It will return to the external caller whatever the implementation returns.
140    * @param implementation Address to delegate.
141    */
142   function _delegate(address implementation) internal {
143     assembly {
144       // Copy msg.data. We take full control of memory in this inline assembly
145       // block because it will not return to Solidity code. We overwrite the
146       // Solidity scratch pad at memory position 0.
147       calldatacopy(0, 0, calldatasize)
148 
149       // Call the implementation.
150       // out and outsize are 0 because we don't know the size yet.
151       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
152 
153       // Copy the returned data.
154       returndatacopy(0, 0, returndatasize)
155 
156       switch result
157       // delegatecall returns 0 on error.
158       case 0 { revert(0, returndatasize) }
159       default { return(0, returndatasize) }
160     }
161   }
162 
163   /**
164    * @dev Function that is run as the first thing in the fallback function.
165    * Can be redefined in derived contracts to add functionality.
166    * Redefinitions must call super._willFallback().
167    */
168   function _willFallback() internal {
169   }
170 
171   /**
172    * @dev fallback implementation.
173    * Extracted to enable manual triggering.
174    */
175   function _fallback() internal {
176     _willFallback();
177     _delegate(_implementation());
178   }
179 }
180 
181 /**
182  * Utility library of inline functions on addresses
183  */
184 library Address {
185     /**
186      * Returns whether the target address is a contract
187      * @dev This function will return false if invoked during the constructor of a contract,
188      * as the code is not actually created until after the constructor finishes.
189      * @param account address of the account to check
190      * @return whether the target address is a contract
191      */
192     function isContract(address account) internal view returns (bool) {
193         uint256 size;
194         // XXX Currently there is no better way to check if there is a contract in an address
195         // than to check the size of the code at that address.
196         // See https://ethereum.stackexchange.com/a/14016/36603
197         // for more details about how this works.
198         // TODO Check this again before the Serenity release, because all addresses will be
199         // contracts then.
200         // solhint-disable-next-line no-inline-assembly
201         assembly { size := extcodesize(account) }
202         return size > 0;
203     }
204 }
205 
206 /**
207  * @title UpgradeabilityProxy
208  * @dev This contract implements a proxy that allows to change the
209  * implementation address to which it will delegate.
210  * Such a change is called an implementation upgrade.
211  */
212 contract UpgradeabilityProxy is Proxy {
213   /**
214    * @dev Emitted when the implementation is upgraded.
215    * @param implementation Address of the new implementation.
216    */
217   event Upgraded(address indexed implementation);
218 
219   /**
220    * @dev Storage slot with the address of the current implementation.
221    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
222    * validated in the constructor.
223    */
224   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
225 
226   /**
227    * @dev Contract constructor.
228    * @param _implementation Address of the initial implementation.
229    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
230    * It should include the signature and the parameters of the function to be called, as described in
231    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
232    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
233    */
234   constructor(address _implementation, bytes memory _data) public payable {
235     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
236     _setImplementation(_implementation);
237     if (_data.length > 0) {
238       bool rv;
239       (rv,) = _implementation.delegatecall(_data);
240       require(rv);
241     }
242   }
243 
244   /**
245    * @dev Returns the current implementation.
246    * @return Address of the current implementation
247    */
248   function _implementation() internal view returns (address impl) {
249     bytes32 slot = IMPLEMENTATION_SLOT;
250     assembly {
251       impl := sload(slot)
252     }
253   }
254 
255   /**
256    * @dev Upgrades the proxy to a new implementation.
257    * @param newImplementation Address of the new implementation.
258    */
259   function _upgradeTo(address newImplementation) internal {
260     _setImplementation(newImplementation);
261     emit Upgraded(newImplementation);
262   }
263 
264   /**
265    * @dev Sets the implementation address of the proxy.
266    * @param newImplementation Address of the new implementation.
267    */
268   function _setImplementation(address newImplementation) private {
269     require(Address.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
270 
271     bytes32 slot = IMPLEMENTATION_SLOT;
272 
273     assembly {
274       sstore(slot, newImplementation)
275     }
276   }
277 }
278 
279 /**
280  * @title AdminUpgradeabilityProxy
281  * @dev This contract combines an upgradeability proxy with an authorization
282  * mechanism for administrative tasks.
283  * All external functions in this contract must be guarded by the
284  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
285  * feature proposal that would enable this to be done automatically.
286  */
287 contract AdminUpgradeabilityProxy is UpgradeabilityProxy {
288   /**
289    * @dev Emitted when the administration has been transferred.
290    * @param previousAdmin Address of the previous admin.
291    * @param newAdmin Address of the new admin.
292    */
293   event AdminChanged(address previousAdmin, address newAdmin);
294 
295   /**
296    * @dev Storage slot with the admin of the contract.
297    * This is the keccak-256 hash of "org.zeppelinos.proxy.admin", and is
298    * validated in the constructor.
299    */
300   bytes32 private constant ADMIN_SLOT = 0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b;
301 
302   /**
303    * @dev Modifier to check whether the `msg.sender` is the admin.
304    * If it is, it will run the function. Otherwise, it will delegate the call
305    * to the implementation.
306    */
307   modifier ifAdmin() {
308     if (msg.sender == _admin()) {
309       _;
310     } else {
311       _fallback();
312     }
313   }
314 
315   /**
316    * Contract constructor.
317    * It sets the `msg.sender` as the proxy administrator.
318    * @param _implementation address of the initial implementation.
319    * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
320    * It should include the signature and the parameters of the function to be called, as described in
321    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
322    * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
323    */
324   constructor(address _implementation, bytes memory _data) UpgradeabilityProxy(_implementation, _data) public payable {
325     assert(ADMIN_SLOT == keccak256("org.zeppelinos.proxy.admin"));
326 
327     _setAdmin(msg.sender);
328   }
329 
330   /**
331    * @return The address of the proxy admin.
332    */
333   function admin() external ifAdmin returns (address) {
334     return _admin();
335   }
336 
337   /**
338    * @return The address of the implementation.
339    */
340   function implementation() external ifAdmin returns (address) {
341     return _implementation();
342   }
343 
344   /**
345    * @dev Changes the admin of the proxy.
346    * Only the current admin can call this function.
347    * @param newAdmin Address to transfer proxy administration to.
348    */
349   function changeAdmin(address newAdmin) external ifAdmin {
350     require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
351     emit AdminChanged(_admin(), newAdmin);
352     _setAdmin(newAdmin);
353   }
354 
355   /**
356    * @dev Upgrade the backing implementation of the proxy.
357    * Only the admin can call this function.
358    * @param newImplementation Address of the new implementation.
359    */
360   function upgradeTo(address newImplementation) external ifAdmin {
361     _upgradeTo(newImplementation);
362   }
363 
364   /**
365    * @dev Upgrade the backing implementation of the proxy and call a function
366    * on the new implementation.
367    * This is useful to initialize the proxied contract.
368    * @param newImplementation Address of the new implementation.
369    * @param data Data to send as msg.data in the low level call.
370    * It should include the signature and the parameters of the function to be called, as described in
371    * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
372    */
373   function upgradeToAndCall(address newImplementation, bytes calldata data) external payable ifAdmin {
374     _upgradeTo(newImplementation);
375     bool rv;
376     (rv,) = newImplementation.delegatecall(data);
377     require(rv);
378   }
379 
380   /**
381    * @return The admin slot.
382    */
383   function _admin() internal view returns (address adm) {
384     bytes32 slot = ADMIN_SLOT;
385     assembly {
386       adm := sload(slot)
387     }
388   }
389 
390   /**
391    * @dev Sets the address of the proxy admin.
392    * @param newAdmin Address of the new proxy admin.
393    */
394   function _setAdmin(address newAdmin) internal {
395     bytes32 slot = ADMIN_SLOT;
396 
397     assembly {
398       sstore(slot, newAdmin)
399     }
400   }
401 
402   /**
403    * @dev Only fall back when the sender is not the admin.
404    */
405   function _willFallback() internal {
406     require(msg.sender != _admin(), "Cannot call fallback function from the proxy admin");
407     super._willFallback();
408   }
409 }
410 
411 /**
412  * @title AdminUpgradeabilityProxy
413  * @dev This contract combines an upgradeability proxy with an authorization
414  * mechanism for administrative tasks.
415  * All external functions in this contract must be guarded by the
416  * `ifAdmin` modifier. See ethereum/solidity#3864 for a Solidity
417  * feature proposal that would enable this to be done automatically.
418  */
419 contract AdminableProxy is AdminUpgradeabilityProxy {
420 
421   /**
422    * Contract constructor.
423    */
424   constructor(address _implementation, bytes memory _data) 
425   AdminUpgradeabilityProxy(_implementation, _data) public payable {
426   }
427 
428   /**
429    * @dev apply proposal.
430    */
431   function applyProposal(bytes calldata data) external ifAdmin returns (bool) {
432     bool rv;
433     (rv, ) = _implementation().delegatecall(data);
434     return rv;
435   }
436 
437 }
438 
439 contract MinGov is Ownable {
440   
441   uint256 public proposalTime;
442   uint256 public first;
443   uint256 public size;
444   
445   struct Proposal {
446     address subject;
447     uint32 created;
448     bool canceled;
449     bytes msgData;
450   }
451   
452   mapping(uint256 => Proposal) public proposals;
453   
454   event NewProposal(uint256 indexed proposalId, address indexed subject, bytes msgData);
455   event Execution(uint256 indexed proposalId, address indexed subject, bytes msgData);
456   
457   constructor(uint256 _proposalTime) public {
458     proposalTime = _proposalTime;
459     first = 1;
460     size = 0;
461   }
462 
463   function propose(address _subject, bytes memory _msgData) public onlyOwner {
464     require(size < 5);
465     proposals[first + size] = Proposal(
466       _subject,
467       uint32(now),
468       false,
469       _msgData
470     );
471     emit NewProposal(first + size, _subject, _msgData);
472     size++;
473   }
474   
475   function cancel(uint256 _proposalId) public onlyOwner() {
476     Proposal storage prop = proposals[_proposalId];
477     require(prop.created > 0);
478     require(prop.canceled == false);
479     prop.canceled = true;
480   }
481 
482   function withdrawTax(address _token) public onlyOwner {
483     IERC20 token = IERC20(_token);
484     token.transfer(owner(), token.balanceOf(address(this)));
485   }
486 
487   function finalize() public {
488     for (uint256 i = first; i < first + size; i++) {
489       Proposal memory prop = proposals[i];
490       if (prop.created + proposalTime <= now) {
491         if (!prop.canceled) {
492           bool rv;
493           bytes4 sig = getSig(prop.msgData);
494           // 0x8f283970 = changeAdmin(address)
495           // 0x3659cfe6 = upgradeTo(address)
496            // 0x983b2d56 = addMinter(address)
497           if (sig == 0x8f283970||sig == 0x3659cfe6||sig == 0x983b2d56) {
498             // this changes proxy parameters 
499             (rv, ) = prop.subject.call(prop.msgData);
500           } else {
501             // this changes governance parameters to the implementation
502             rv = AdminableProxy(address(uint160(prop.subject))).applyProposal(prop.msgData);
503           }
504           if (rv) {
505             emit Execution(i, prop.subject, prop.msgData);
506           }
507         }
508         delete proposals[i];
509         first++;
510         size--;
511       }
512     }
513   }
514 
515   // proxy function to manage validator slots without governance delay
516   function setSlot(uint256 _slotId, address, bytes32) public onlyOwner {
517     // extract subject
518     address payable subject = address(uint160(_slotId >> 96));
519     // strip out subject from data
520     bytes memory msgData = new bytes(100);
521     assembly {
522       calldatacopy(add(msgData, 32), 0, 4)
523       calldatacopy(add(msgData, 56), 24, 76)
524     }
525     // call subject
526     require(AdminableProxy(subject).applyProposal(msgData), "setSlot call failed");
527   }
528 
529   function getSig(bytes memory _msgData) internal pure returns (bytes4) {
530     return bytes4(_msgData[3]) >> 24 | bytes4(_msgData[2]) >> 16 | bytes4(_msgData[1]) >> 8 | bytes4(_msgData[0]);
531   }
532 
533 }