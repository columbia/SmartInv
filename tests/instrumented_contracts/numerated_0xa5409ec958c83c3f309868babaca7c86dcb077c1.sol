1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40   /**
41    * @dev Allows the current owner to relinquish control of the contract.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 }
48 
49 contract ERC20Basic {
50   function totalSupply() public view returns (uint256);
51   function balanceOf(address who) public view returns (uint256);
52   function transfer(address to, uint256 value) public returns (bool);
53   event Transfer(address indexed from, address indexed to, uint256 value);
54 }
55 
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender)
58     public view returns (uint256);
59 
60   function transferFrom(address from, address to, uint256 value)
61     public returns (bool);
62 
63   function approve(address spender, uint256 value) public returns (bool);
64   event Approval(
65     address indexed owner,
66     address indexed spender,
67     uint256 value
68   );
69 }
70 
71 contract TokenRecipient {
72     event ReceivedEther(address indexed sender, uint amount);
73     event ReceivedTokens(address indexed from, uint256 value, address indexed token, bytes extraData);
74 
75     /**
76      * @dev Receive tokens and generate a log event
77      * @param from Address from which to transfer tokens
78      * @param value Amount of tokens to transfer
79      * @param token Address of token
80      * @param extraData Additional data to log
81      */
82     function receiveApproval(address from, uint256 value, address token, bytes extraData) public {
83         ERC20 t = ERC20(token);
84         require(t.transferFrom(from, this, value));
85         emit ReceivedTokens(from, value, token, extraData);
86     }
87 
88     /**
89      * @dev Receive Ether and generate a log event
90      */
91     function () payable public {
92         emit ReceivedEther(msg.sender, msg.value);
93     }
94 }
95 
96 contract ProxyRegistry is Ownable {
97 
98     /* DelegateProxy implementation contract. Must be initialized. */
99     address public delegateProxyImplementation;
100 
101     /* Authenticated proxies by user. */
102     mapping(address => OwnableDelegateProxy) public proxies;
103 
104     /* Contracts pending access. */
105     mapping(address => uint) public pending;
106 
107     /* Contracts allowed to call those proxies. */
108     mapping(address => bool) public contracts;
109 
110     /* Delay period for adding an authenticated contract.
111        This mitigates a particular class of potential attack on the Wyvern DAO (which owns this registry) - if at any point the value of assets held by proxy contracts exceeded the value of half the WYV supply (votes in the DAO),
112        a malicious but rational attacker could buy half the Wyvern and grant themselves access to all the proxy contracts. A delay period renders this attack nonthreatening - given two weeks, if that happened, users would have
113        plenty of time to notice and transfer their assets.
114     */
115     uint public DELAY_PERIOD = 2 weeks;
116 
117     /**
118      * Start the process to enable access for specified contract. Subject to delay period.
119      *
120      * @dev ProxyRegistry owner only
121      * @param addr Address to which to grant permissions
122      */
123     function startGrantAuthentication (address addr)
124         public
125         onlyOwner
126     {
127         require(!contracts[addr] && pending[addr] == 0);
128         pending[addr] = now;
129     }
130 
131     /**
132      * End the process to nable access for specified contract after delay period has passed.
133      *
134      * @dev ProxyRegistry owner only
135      * @param addr Address to which to grant permissions
136      */
137     function endGrantAuthentication (address addr)
138         public
139         onlyOwner
140     {
141         require(!contracts[addr] && pending[addr] != 0 && ((pending[addr] + DELAY_PERIOD) < now));
142         pending[addr] = 0;
143         contracts[addr] = true;
144     }
145 
146     /**
147      * Revoke access for specified contract. Can be done instantly.
148      *
149      * @dev ProxyRegistry owner only
150      * @param addr Address of which to revoke permissions
151      */    
152     function revokeAuthentication (address addr)
153         public
154         onlyOwner
155     {
156         contracts[addr] = false;
157     }
158 
159     /**
160      * Register a proxy contract with this registry
161      *
162      * @dev Must be called by the user which the proxy is for, creates a new AuthenticatedProxy
163      * @return New AuthenticatedProxy contract
164      */
165     function registerProxy()
166         public
167         returns (OwnableDelegateProxy proxy)
168     {
169         require(proxies[msg.sender] == address(0));
170         proxy = new OwnableDelegateProxy(msg.sender, delegateProxyImplementation, abi.encodeWithSignature("initialize(address,address)", msg.sender, address(this)));
171         proxies[msg.sender] = proxy;
172         return proxy;
173     }
174 
175 }
176 
177 contract WyvernProxyRegistry is ProxyRegistry {
178 
179     string public constant name = "Project Wyvern Proxy Registry";
180 
181     /* Whether the initial auth address has been set. */
182     bool public initialAddressSet = false;
183 
184     constructor ()
185         public
186     {
187         delegateProxyImplementation = new AuthenticatedProxy();
188     }
189 
190     /** 
191      * Grant authentication to the initial Exchange protocol contract
192      *
193      * @dev No delay, can only be called once - after that the standard registry process with a delay must be used
194      * @param authAddress Address of the contract to grant authentication
195      */
196     function grantInitialAuthentication (address authAddress)
197         onlyOwner
198         public
199     {
200         require(!initialAddressSet);
201         initialAddressSet = true;
202         contracts[authAddress] = true;
203     }
204 
205 }
206 
207 contract OwnedUpgradeabilityStorage {
208 
209   // Current implementation
210   address internal _implementation;
211 
212   // Owner of the contract
213   address private _upgradeabilityOwner;
214 
215   /**
216    * @dev Tells the address of the owner
217    * @return the address of the owner
218    */
219   function upgradeabilityOwner() public view returns (address) {
220     return _upgradeabilityOwner;
221   }
222 
223   /**
224    * @dev Sets the address of the owner
225    */
226   function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
227     _upgradeabilityOwner = newUpgradeabilityOwner;
228   }
229 
230   /**
231   * @dev Tells the address of the current implementation
232   * @return address of the current implementation
233   */
234   function implementation() public view returns (address) {
235     return _implementation;
236   }
237 
238   /**
239   * @dev Tells the proxy type (EIP 897)
240   * @return Proxy type, 2 for forwarding proxy
241   */
242   function proxyType() public pure returns (uint256 proxyTypeId) {
243     return 2;
244   }
245 }
246 
247 contract AuthenticatedProxy is TokenRecipient, OwnedUpgradeabilityStorage {
248 
249     /* Whether initialized. */
250     bool initialized = false;
251 
252     /* Address which owns this proxy. */
253     address public user;
254 
255     /* Associated registry with contract authentication information. */
256     ProxyRegistry public registry;
257 
258     /* Whether access has been revoked. */
259     bool public revoked;
260 
261     /* Delegate call could be used to atomically transfer multiple assets owned by the proxy contract with one order. */
262     enum HowToCall { Call, DelegateCall }
263 
264     /* Event fired when the proxy access is revoked or unrevoked. */
265     event Revoked(bool revoked);
266 
267     /**
268      * Initialize an AuthenticatedProxy
269      *
270      * @param addrUser Address of user on whose behalf this proxy will act
271      * @param addrRegistry Address of ProxyRegistry contract which will manage this proxy
272      */
273     function initialize (address addrUser, ProxyRegistry addrRegistry)
274         public
275     {
276         require(!initialized);
277         initialized = true;
278         user = addrUser;
279         registry = addrRegistry;
280     }
281 
282     /**
283      * Set the revoked flag (allows a user to revoke ProxyRegistry access)
284      *
285      * @dev Can be called by the user only
286      * @param revoke Whether or not to revoke access
287      */
288     function setRevoke(bool revoke)
289         public
290     {
291         require(msg.sender == user);
292         revoked = revoke;
293         emit Revoked(revoke);
294     }
295 
296     /**
297      * Execute a message call from the proxy contract
298      *
299      * @dev Can be called by the user, or by a contract authorized by the registry as long as the user has not revoked access
300      * @param dest Address to which the call will be sent
301      * @param howToCall Which kind of call to make
302      * @param calldata Calldata to send
303      * @return Result of the call (success or failure)
304      */
305     function proxy(address dest, HowToCall howToCall, bytes calldata)
306         public
307         returns (bool result)
308     {
309         require(msg.sender == user || (!revoked && registry.contracts(msg.sender)));
310         if (howToCall == HowToCall.Call) {
311             result = dest.call(calldata);
312         } else if (howToCall == HowToCall.DelegateCall) {
313             result = dest.delegatecall(calldata);
314         }
315         return result;
316     }
317 
318     /**
319      * Execute a message call and assert success
320      * 
321      * @dev Same functionality as `proxy`, just asserts the return value
322      * @param dest Address to which the call will be sent
323      * @param howToCall What kind of call to make
324      * @param calldata Calldata to send
325      */
326     function proxyAssert(address dest, HowToCall howToCall, bytes calldata)
327         public
328     {
329         require(proxy(dest, howToCall, calldata));
330     }
331 
332 }
333 
334 contract Proxy {
335 
336   /**
337   * @dev Tells the address of the implementation where every call will be delegated.
338   * @return address of the implementation to which it will be delegated
339   */
340   function implementation() public view returns (address);
341 
342   /**
343   * @dev Tells the type of proxy (EIP 897)
344   * @return Type of proxy, 2 for upgradeable proxy
345   */
346   function proxyType() public pure returns (uint256 proxyTypeId);
347 
348   /**
349   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
350   * This function will return whatever the implementation call returns
351   */
352   function () payable public {
353     address _impl = implementation();
354     require(_impl != address(0));
355 
356     assembly {
357       let ptr := mload(0x40)
358       calldatacopy(ptr, 0, calldatasize)
359       let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
360       let size := returndatasize
361       returndatacopy(ptr, 0, size)
362 
363       switch result
364       case 0 { revert(ptr, size) }
365       default { return(ptr, size) }
366     }
367   }
368 }
369 
370 contract OwnedUpgradeabilityProxy is Proxy, OwnedUpgradeabilityStorage {
371   /**
372   * @dev Event to show ownership has been transferred
373   * @param previousOwner representing the address of the previous owner
374   * @param newOwner representing the address of the new owner
375   */
376   event ProxyOwnershipTransferred(address previousOwner, address newOwner);
377 
378   /**
379   * @dev This event will be emitted every time the implementation gets upgraded
380   * @param implementation representing the address of the upgraded implementation
381   */
382   event Upgraded(address indexed implementation);
383 
384   /**
385   * @dev Upgrades the implementation address
386   * @param implementation representing the address of the new implementation to be set
387   */
388   function _upgradeTo(address implementation) internal {
389     require(_implementation != implementation);
390     _implementation = implementation;
391     emit Upgraded(implementation);
392   }
393 
394   /**
395   * @dev Throws if called by any account other than the owner.
396   */
397   modifier onlyProxyOwner() {
398     require(msg.sender == proxyOwner());
399     _;
400   }
401 
402   /**
403    * @dev Tells the address of the proxy owner
404    * @return the address of the proxy owner
405    */
406   function proxyOwner() public view returns (address) {
407     return upgradeabilityOwner();
408   }
409 
410   /**
411    * @dev Allows the current owner to transfer control of the contract to a newOwner.
412    * @param newOwner The address to transfer ownership to.
413    */
414   function transferProxyOwnership(address newOwner) public onlyProxyOwner {
415     require(newOwner != address(0));
416     emit ProxyOwnershipTransferred(proxyOwner(), newOwner);
417     setUpgradeabilityOwner(newOwner);
418   }
419 
420   /**
421    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy.
422    * @param implementation representing the address of the new implementation to be set.
423    */
424   function upgradeTo(address implementation) public onlyProxyOwner {
425     _upgradeTo(implementation);
426   }
427 
428   /**
429    * @dev Allows the upgradeability owner to upgrade the current implementation of the proxy
430    * and delegatecall the new implementation for initialization.
431    * @param implementation representing the address of the new implementation to be set.
432    * @param data represents the msg.data to bet sent in the low level call. This parameter may include the function
433    * signature of the implementation to be called with the needed payload
434    */
435   function upgradeToAndCall(address implementation, bytes data) payable public onlyProxyOwner {
436     upgradeTo(implementation);
437     require(address(this).delegatecall(data));
438   }
439 }
440 
441 contract OwnableDelegateProxy is OwnedUpgradeabilityProxy {
442 
443     constructor(address owner, address initialImplementation, bytes calldata)
444         public
445     {
446         setUpgradeabilityOwner(owner);
447         _upgradeTo(initialImplementation);
448         require(initialImplementation.delegatecall(calldata));
449     }
450 
451 }