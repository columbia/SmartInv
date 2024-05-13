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
20 * Copyright (c) 2021 dego
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
151        This mitigates a particular class of potential attack on the TreasureLand DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the TreasureLand supply (votes in the offline DAO),
152        a malicious but rational attacker could buy half the TreasureLand and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
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
217 contract BabyRegistry is ProxyRegistry {
218 
219     string public constant name = "Project Baby Proxy Registry";
220 
221     /* Whether the initial auth address has been set. */
222     bool public initialAddressSet = false;
223 
224     constructor ()
225         public
226     {
227         delegateProxyImplementation = new AuthenticatedProxy();
228     }
229 
230     /** 
231      * Grant authentication to the initial Exchange protocol contract
232      *
233      * @dev No delay, can only be called once - after that the standard registry process with a delay must be used
234      * @param authAddress Address of the contract to grant authentication
235      */
236     function grantInitialAuthentication (address authAddress)
237         onlyOwner
238         public
239     {
240         require(!initialAddressSet);
241         initialAddressSet = true;
242         contracts[authAddress] = true;
243     }
244 
245 }
246 
247 contract OwnedUpgradeabilityStorage {
248 
249   // Current implementation
250   address internal _implementation;
251 
252   // Owner of the contract
253   address private _upgradeabilityOwner;
254 
255   /**
256    * @dev Tells the address of the owner
257    * @return the address of the owner
258    */
259   function upgradeabilityOwner() public view returns (address) {
260     return _upgradeabilityOwner;
261   }
262 
263   /**
264    * @dev Sets the address of the owner
265    */
266   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
267     _upgradeabilityOwner = newUpgradeabilityOwner;
268   }
269 
270   /**
271   * @dev Tells the address of the current implementation
272   * @return address of the current implementation
273   */
274   function implementation() public view returns (address) {
275     return _implementation;
276   }
277 
278   /**
279   * @dev Tells the proxy type (EIP 897)
280   * @return Proxy type, 2 for forwarding proxy
281   */
282   function proxyType() public pure returns (uint256 proxyTypeId) {
283     return 2;
284   }
285 }
286 
287 contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {
288 
289     /* Whether initialized. */
290     bool initialized = false;
291 
292     /* Address which owns this proxy. */
293     address public user;
294 
295     /* Associated registry with contract authentication information. */
296     ProxyRegistry public registry;
297 
298     /* Whether access has been revoked. */
299     bool public revoked;
300 
301     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
302     enum HowToCall { Call, DelegateCall }
303 
304     /* Event fired when the proxy access is revoked or unrevoked. */
305     event Revoked(bool revoked);
306 
307     /**
308      * Initialize an AuthenticatedProxy
309      *
310      * @param addrUser Address of user on whose behalf this proxy will act
311      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
312      */
313     function initialize (address addrUser, ProxyRegistry addrRegistry)
314         public
315     {
316         require(!initialized);
317         initialized = true;
318         user = addrUser;
319         registry = addrRegistry;
320     }
321 
322     /**
323      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
324      *
325      * @dev Can be called by the user only
326      * @param revoke Whether or not to revoke access
327      */
328     function setRevoke(bool revoke)
329         public
330     {
331         require(msg.sender == user);
332         revoked = revoke;
333         emit Revoked(revoke);
334     }
335 
336     /**
337      * Execute a message call from the proxy contract
338      *
339      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
340      * @param dest Address to which the call will be sent
341      * @param howToCall Which kind of call to make
342      * @param calldata Calldata to send
343      * @return Result of the call (success or failure)
344      */
345     function proxy(address dest, HowToCall howToCall, bytes calldata)
346         public
347         returns (bool result)
348     {
349         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
350         if (howToCall == HowToCall.Call) {
351             result = dest.call(calldata);
352         } else if (howToCall == HowToCall.DelegateCall) {
353             result = dest.delegatecall(calldata);
354         }
355         return result;
356     }
357 
358     /**
359      * Execute a message call and assert success
360      * 
361      * @dev Same functionality as `proxy`, just asserts the return value
362      * @param dest Address to which the call will be sent
363      * @param howToCall What kind of call to make
364      * @param calldata Calldata to send
365      */
366     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
367         public
368     {
369         require(proxy(dest, howToCall, calldata));
370     }
371 
372 }
373 
374 contract Proxy {
375 
376   /**
377   * @dev Tells the address of the implementation where every call will be delegated.
378   * @return address of the implementation to which it will be delegated
379   */
380   function implementation() public view returns (address);
381 
382   /**
383   * @dev Tells the type of proxy (EIP 897)
384   * @return Type of proxy, 2 for upgradeable proxy
385   */
386   function proxyType() public pure returns (uint256 proxyTypeId);
387 
388   /**
389   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
390   * This function will return whatever the implementation call returns
391   */
392   function () payable public {
393     address _impl = implementation();
394     require(_impl != address(0));
395 
396     assembly {
397       let ptr := mload(0x40)
398       calldatacopy(ptr, 0, calldatasize)
399       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
400       let size := returndatasize
401       returndatacopy(ptr, 0, size)
402 
403       switch result
404       case 0 { revert(ptr, size) }
405       default { return(ptr, size) }
406     }
407   }
408 }
409 
410 contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
411   /**
412   * @dev Event to show ownership has been transferred
413   * @param previousOwner representing the address of the previous owner
414   * @param newOwner representing the address of the new owner
415   */
416   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
417 
418   /**
419   * @dev This event will be emitted every time the implementation gets upgraded
420   * @param implementation representing the address of the upgraded implementation
421   */
422   event Upgraded(address indexed implementation);
423 
424   /**
425   * @dev Upgrades the implementation address
426   * @param implementation representing the address of the new implementation to be set
427   */
428   function _upgradeTo(address implementation) internal {
429     require(_implementation != implementation);
430     _implementation = implementation;
431     emit Upgraded(implementation);
432   }
433 
434   /**
435   * @dev Throws if called by any account other than the owner.
436   */
437   modifier onlyProxyOwner() {
438     require(msg.sender == proxyOwner());
439     _;
440   }
441 
442   /**
443    * @dev Tells the address of the proxy owner
444    * @return the address of the proxy owner
445    */
446   function proxyOwner() public view returns (address) {
447     return upgradeabilityOwner();
448   }
449 
450   /**
451    * @dev Allows the current owner to transfer control of the contract to a newOwner.
452    * @param newOwner The address to transfer ownership to.
453    */
454   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
455     require(newOwner != address(0));
456     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
457     setUpgradeabilityOwner(newOwner);
458   }
459 
460   /**
461    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
462    * @param implementation representing the address of the new implementation to be set.
463    */
464   function upgradeTo(address implementation) public onlyProxyOwner {
465     _upgradeTo(implementation);
466   }
467 
468   /**
469    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
470    * and delegatecall the new implementation for initialization.
471    * @param implementation representing the address of the new implementation to be set.
472    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
473    * signature of the implementation to be called with the needed payload
474    */
475   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
476     upgradeTo(implementation);
477     require(address(this).delegatecall(data));
478   }
479 }
480 
481 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
482 
483     constructor(address owner, address initialImplementation, bytes calldata)
484         public
485     {
486         setUpgradeabilityOwner(owner);
487         _upgradeTo(initialImplementation);
488         require(initialImplementation.delegatecall(calldata));
489     }
490 
491 }
