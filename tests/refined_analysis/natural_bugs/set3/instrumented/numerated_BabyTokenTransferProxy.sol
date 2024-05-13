1 // SPDX-License-Identifier: MIT
2 
3 /**
4  *Submitted for verification at BscScan.com on 2021-04-10
5 */
6 
7 /***
8  *    ██████╗ ███████╗ ██████╗  ██████╗ 
9  *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗
10  *    ██║  ██║█████╗  ██║  ███╗██║   ██║
11  *    ██║  ██║██╔══╝  ██║   ██║██║   ██║
12  *    ██████╔╝███████╗╚██████╔╝╚██████╔╝
13  *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ 
14  *    
15  * https://dego.finance
16                                   
17 * MIT License
18 * ===========
19 *
20 * Copyright (c) 2020 dego
21 *
22 * Permission is hereby granted, free of charge, to any person obtaining a copy
23 * of this software and associated documentation files (the "Software"), to deal
24 * in the Software without restriction, including without limitation the rights
25 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
26 * copies of the Software, and to permit persons to whom the Software is
27 * furnished to do so, subject to the following conditions:
28 *
29 * The above copyright notice and this permission notice shall be included in all
30 * copies or substantial portions of the Software.
31 *
32 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
33 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
34 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
35 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
36 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
37 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
38 */
39 
40 pragma solidity ^0.4.13;
41 import "hardhat/console.sol";
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipRenounced(address indexed previousOwner);
48   event OwnershipTransferred(
49     address indexed previousOwner,
50     address indexed newOwner
51   );
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   constructor() public {
59     owner = msg.sender;
60   }
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     emit OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80   /**
81    * @dev Allows the current owner to relinquish control of the contract.
82    */
83   function renounceOwnership() public onlyOwner {
84     emit OwnershipRenounced(owner);
85     owner = address(0);
86   }
87 }
88 
89 contract ERC20Basic {
90   function totalSupply() public view returns (uint256);
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender)
98     public view returns (uint256);
99 
100   function transferFrom(address from, address to, uint256 value)
101     public returns (bool);
102 
103   function approve(address spender, uint256 value) public returns (bool);
104   event Approval(
105     address indexed owner,
106     address indexed spender,
107     uint256 value
108   );
109 }
110 
111 contract TokenRecipient {
112     event ReceivedEther(address indexed sender, uint amount);
113     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
114 
115     /**
116      * @dev Receive tokens and generate a log event
117      * @param from Address from which to transfer tokens
118      * @param value Amount of tokens to transfer
119      * @param token Address of token
120      * @param extraData Additional data to log
121      */
122     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
123         ERC20 t = ERC20(token);
124         require(t.transferFrom(from, this, value));
125         emit ReceivedTokens(from, value, token, extraData);
126     }
127 
128     /**
129      * @dev Receive Ether and generate a log event
130      */
131     function () payable public {
132         emit ReceivedEther(msg.sender, msg.value);
133     }
134 }
135 
136 contract ProxyRegistry is Ownable {
137 
138     /* DelegateProxy implementation contract. Must be initialized. */
139     address public delegateProxyImplementation;
140 
141     /* Authenticated proxies by user. */
142     mapping(address => OwnableDelegateProxy) public proxies;
143 
144     /* Contracts pending access. */
145     mapping(address => uint) public pending;
146 
147     /* Contracts allowed to call those proxies. */
148     mapping(address => bool) public contracts;
149 
150     /* Delay period for adding an authenticated contract.
151        This mitigates a particular class of potential attack on the Baby DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the Baby supply (votes in the offline DAO),
152        a malicious but rational attacker could buy half the Baby and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
153        plenty of time to notice and transfer their assets.
154     */
155     uint public DELAY_PERIOD = 2 weeks;
156 
157     /**
158      * Start the process to enable access for specified contract. Subject to delay period.
159      *
160      * @dev ProxyRegistry owner only
161      * @param addr Address to which to grant permissions
162      */
163     function startGrantAuthentication (address addr)
164         public
165         onlyOwner
166     {
167         require(!contracts[addr] && pending[addr] == 0);
168         pending[addr] = now;
169     }
170 
171     /**
172      * End the process to nable access for specified contract after delay period has passed.
173      *
174      * @dev ProxyRegistry owner only
175      * @param addr Address to which to grant permissions
176      */
177     function endGrantAuthentication (address addr)
178         public
179         onlyOwner
180     {
181         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
182         pending[addr] = 0;
183         contracts[addr] = true;
184     }
185 
186     /**
187      * Revoke access for specified contract. Can be done instantly.
188      *
189      * @dev ProxyRegistry owner only
190      * @param addr Address of which to revoke permissions
191      */    
192     function revokeAuthentication (address addr)
193         public
194         onlyOwner
195     {
196         contracts[addr] = false;
197     }
198 
199     /**
200      * Register a proxy contract with this registry
201      *
202      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
203      * @return New AuthenticatedProxy contract
204      */
205     function registerProxy()
206         public
207         returns (OwnableDelegateProxy proxy)
208     {
209         require(proxies[msg.sender] == address(0));
210         proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));
211         proxies[msg.sender] = proxy;
212         return proxy;
213     }
214 
215 }
216 
217 contract TokenTransferProxy {
218 
219     /* Authentication registry. */
220     ProxyRegistry public registry;
221 
222     /**
223      * Call ERC20 `transferFrom`
224      *
225      * @dev Authenticated contract only
226      * @param token ERC20 token address
227      * @param from From address
228      * @param to To address
229      * @param amount Transfer amount
230      */
231     function transferFrom(address token, address from, address to, uint amount)
232         public
233         returns (bool)
234     {
235         require(registry.contracts(msg.sender));
236         return ERC20(token).transferFrom(from, to, amount);
237     }
238 
239 }
240 
241 contract BabyTokenTransferProxy is TokenTransferProxy {
242 
243     constructor (ProxyRegistry registryAddr)
244         public
245     {
246         registry = registryAddr;
247     }
248 
249 }
250 
251 contract OwnedUpgradeabilityStorage {
252 
253   // Current implementation
254   address internal _implementation;
255 
256   // Owner of the contract
257   address private _upgradeabilityOwner;
258 
259   /**
260    * @dev Tells the address of the owner
261    * @return the address of the owner
262    */
263   function upgradeabilityOwner() public view returns (address) {
264     return _upgradeabilityOwner;
265   }
266 
267   /**
268    * @dev Sets the address of the owner
269    */
270   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
271     _upgradeabilityOwner = newUpgradeabilityOwner;
272   }
273 
274   /**
275   * @dev Tells the address of the current implementation
276   * @return address of the current implementation
277   */
278   function implementation() public view returns (address) {
279     return _implementation;
280   }
281 
282   /**
283   * @dev Tells the proxy type (EIP 897)
284   * @return Proxy type, 2 for forwarding proxy
285   */
286   function proxyType() public pure returns (uint256 proxyTypeId) {
287     return 2;
288   }
289 }
290 
291 contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {
292 
293     /* Whether initialized. */
294     bool initialized = false;
295 
296     /* Address which owns this proxy. */
297     address public user;
298 
299     /* Associated registry with contract authentication information. */
300     ProxyRegistry public registry;
301 
302     /* Whether access has been revoked. */
303     bool public revoked;
304 
305     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
306     enum HowToCall { Call, DelegateCall }
307 
308     /* Event fired when the proxy access is revoked or unrevoked. */
309     event Revoked(bool revoked);
310 
311     /**
312      * Initialize an AuthenticatedProxy
313      *
314      * @param addrUser Address of user on whose behalf this proxy will act
315      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
316      */
317     function initialize (address addrUser, ProxyRegistry addrRegistry)
318         public
319     {
320         require(!initialized);
321         initialized = true;
322         user = addrUser;
323         registry = addrRegistry;
324     }
325 
326     /**
327      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
328      *
329      * @dev Can be called by the user only
330      * @param revoke Whether or not to revoke access
331      */
332     function setRevoke(bool revoke)
333         public
334     {
335         require(msg.sender == user);
336         revoked = revoke;
337         emit Revoked(revoke);
338     }
339 
340     /**
341      * Execute a message call from the proxy contract
342      *
343      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
344      * @param dest Address to which the call will be sent
345      * @param howToCall Which kind of call to make
346      * @param calldata Calldata to send
347      * @return Result of the call (success or failure)
348      */
349     function proxy(address dest, HowToCall howToCall, bytes calldata)
350         public
351         returns (bool result)
352     {
353         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
354         if (howToCall == HowToCall.Call) {
355             result = dest.call(calldata);
356         } else if (howToCall == HowToCall.DelegateCall) {
357             result = dest.delegatecall(calldata);
358         }
359         return result;
360     }
361 
362     /**
363      * Execute a message call and assert success
364      * 
365      * @dev Same functionality as `proxy`, just asserts the return value
366      * @param dest Address to which the call will be sent
367      * @param howToCall What kind of call to make
368      * @param calldata Calldata to send
369      */
370     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
371         public
372     {
373         require(proxy(dest, howToCall, calldata));
374     }
375 
376 }
377 
378 contract Proxy {
379 
380   /**
381   * @dev Tells the address of the implementation where every call will be delegated.
382   * @return address of the implementation to which it will be delegated
383   */
384   function implementation() public view returns (address);
385 
386   /**
387   * @dev Tells the type of proxy (EIP 897)
388   * @return Type of proxy, 2 for upgradeable proxy
389   */
390   function proxyType() public pure returns (uint256 proxyTypeId);
391 
392   /**
393   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
394   * This function will return whatever the implementation call returns
395   */
396   function () payable public {
397     address _impl = implementation();
398     require(_impl != address(0));
399 
400     assembly {
401       let ptr := mload(0x40)
402       calldatacopy(ptr, 0, calldatasize)
403       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
404       let size := returndatasize
405       returndatacopy(ptr, 0, size)
406 
407       switch result
408       case 0 { revert(ptr, size) }
409       default { return(ptr, size) }
410     }
411   }
412 }
413 
414 contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
415   /**
416   * @dev Event to show ownership has been transferred
417   * @param previousOwner representing the address of the previous owner
418   * @param newOwner representing the address of the new owner
419   */
420   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
421 
422   /**
423   * @dev This event will be emitted every time the implementation gets upgraded
424   * @param implementation representing the address of the upgraded implementation
425   */
426   event Upgraded(address indexed implementation);
427 
428   /**
429   * @dev Upgrades the implementation address
430   * @param implementation representing the address of the new implementation to be set
431   */
432   function _upgradeTo(address implementation) internal {
433     require(_implementation != implementation);
434     _implementation = implementation;
435     emit Upgraded(implementation);
436   }
437 
438   /**
439   * @dev Throws if called by any account other than the owner.
440   */
441   modifier onlyProxyOwner() {
442     require(msg.sender == proxyOwner());
443     _;
444   }
445 
446   /**
447    * @dev Tells the address of the proxy owner
448    * @return the address of the proxy owner
449    */
450   function proxyOwner() public view returns (address) {
451     return upgradeabilityOwner();
452   }
453 
454   /**
455    * @dev Allows the current owner to transfer control of the contract to a newOwner.
456    * @param newOwner The address to transfer ownership to.
457    */
458   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
459     require(newOwner != address(0));
460     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
461     setUpgradeabilityOwner(newOwner);
462   }
463 
464   /**
465    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
466    * @param implementation representing the address of the new implementation to be set.
467    */
468   function upgradeTo(address implementation) public onlyProxyOwner {
469     _upgradeTo(implementation);
470   }
471 
472   /**
473    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
474    * and delegatecall the new implementation for initialization.
475    * @param implementation representing the address of the new implementation to be set.
476    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
477    * signature of the implementation to be called with the needed payload
478    */
479   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
480     upgradeTo(implementation);
481     require(address(this).delegatecall(data));
482   }
483 }
484 
485 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
486 
487     constructor(address owner, address initialImplementation, bytes calldata)
488         public
489     {
490         setUpgradeabilityOwner(owner);
491         _upgradeTo(initialImplementation);
492         require(initialImplementation.delegatecall(calldata));
493     }
494 
495 }
