1 /* ===============================================
2 * Flattened with Solidifier by Coinage
3 * 
4 * https://solidifier.coina.ge
5 * ===============================================
6 */
7 
8 
9 /*
10 -----------------------------------------------------------------
11 FILE INFORMATION
12 -----------------------------------------------------------------
13 
14 file:       Owned.sol
15 version:    1.1
16 author:     Anton Jurisevic
17             Dominic Romanowski
18 
19 date:       2018-2-26
20 
21 -----------------------------------------------------------------
22 MODULE DESCRIPTION
23 -----------------------------------------------------------------
24 
25 An Owned contract, to be inherited by other contracts.
26 Requires its owner to be explicitly set in the constructor.
27 Provides an onlyOwner access modifier.
28 
29 To change owner, the current owner must nominate the next owner,
30 who then has to accept the nomination. The nomination can be
31 cancelled before it is accepted by the new owner by having the
32 previous owner change the nomination (setting it to 0).
33 
34 -----------------------------------------------------------------
35 */
36 
37 pragma solidity 0.4.25;
38 
39 /**
40  * @title A contract with an owner.
41  * @notice Contract ownership can be transferred by first nominating the new owner,
42  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
43  */
44 contract Owned {
45     address public owner;
46     address public nominatedOwner;
47 
48     /**
49      * @dev Owned Constructor
50      */
51     constructor(address _owner)
52         public
53     {
54         require(_owner != address(0), "Owner address cannot be 0");
55         owner = _owner;
56         emit OwnerChanged(address(0), _owner);
57     }
58 
59     /**
60      * @notice Nominate a new owner of this contract.
61      * @dev Only the current owner may nominate a new owner.
62      */
63     function nominateNewOwner(address _owner)
64         external
65         onlyOwner
66     {
67         nominatedOwner = _owner;
68         emit OwnerNominated(_owner);
69     }
70 
71     /**
72      * @notice Accept the nomination to be owner.
73      */
74     function acceptOwnership()
75         external
76     {
77         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
78         emit OwnerChanged(owner, nominatedOwner);
79         owner = nominatedOwner;
80         nominatedOwner = address(0);
81     }
82 
83     modifier onlyOwner
84     {
85         require(msg.sender == owner, "Only the contract owner may perform this action");
86         _;
87     }
88 
89     event OwnerNominated(address newOwner);
90     event OwnerChanged(address oldOwner, address newOwner);
91 }
92 
93 
94 /*
95 -----------------------------------------------------------------
96 FILE INFORMATION
97 -----------------------------------------------------------------
98 
99 file:       Proxy.sol
100 version:    1.3
101 author:     Anton Jurisevic
102 
103 date:       2018-05-29
104 
105 -----------------------------------------------------------------
106 MODULE DESCRIPTION
107 -----------------------------------------------------------------
108 
109 A proxy contract that, if it does not recognise the function
110 being called on it, passes all value and call data to an
111 underlying target contract.
112 
113 This proxy has the capacity to toggle between DELEGATECALL
114 and CALL style proxy functionality.
115 
116 The former executes in the proxy's context, and so will preserve 
117 msg.sender and store data at the proxy address. The latter will not.
118 Therefore, any contract the proxy wraps in the CALL style must
119 implement the Proxyable interface, in order that it can pass msg.sender
120 into the underlying contract as the state parameter, messageSender.
121 
122 -----------------------------------------------------------------
123 */
124 
125 
126 contract Proxy is Owned {
127 
128     Proxyable public target;
129     bool public useDELEGATECALL;
130 
131     constructor(address _owner)
132         Owned(_owner)
133         public
134     {}
135 
136     function setTarget(Proxyable _target)
137         external
138         onlyOwner
139     {
140         target = _target;
141         emit TargetUpdated(_target);
142     }
143 
144     function setUseDELEGATECALL(bool value) 
145         external
146         onlyOwner
147     {
148         useDELEGATECALL = value;
149     }
150 
151     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
152         external
153         onlyTarget
154     {
155         uint size = callData.length;
156         bytes memory _callData = callData;
157 
158         assembly {
159             /* The first 32 bytes of callData contain its length (as specified by the abi). 
160              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
161              * in length. It is also leftpadded to be a multiple of 32 bytes.
162              * This means moving call_data across 32 bytes guarantees we correctly access
163              * the data itself. */
164             switch numTopics
165             case 0 {
166                 log0(add(_callData, 32), size)
167             } 
168             case 1 {
169                 log1(add(_callData, 32), size, topic1)
170             }
171             case 2 {
172                 log2(add(_callData, 32), size, topic1, topic2)
173             }
174             case 3 {
175                 log3(add(_callData, 32), size, topic1, topic2, topic3)
176             }
177             case 4 {
178                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
179             }
180         }
181     }
182 
183     function()
184         external
185         payable
186     {
187         if (useDELEGATECALL) {
188             assembly {
189                 /* Copy call data into free memory region. */
190                 let free_ptr := mload(0x40)
191                 calldatacopy(free_ptr, 0, calldatasize)
192 
193                 /* Forward all gas and call data to the target contract. */
194                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
195                 returndatacopy(free_ptr, 0, returndatasize)
196 
197                 /* Revert if the call failed, otherwise return the result. */
198                 if iszero(result) { revert(free_ptr, returndatasize) }
199                 return(free_ptr, returndatasize)
200             }
201         } else {
202             /* Here we are as above, but must send the messageSender explicitly 
203              * since we are using CALL rather than DELEGATECALL. */
204             target.setMessageSender(msg.sender);
205             assembly {
206                 let free_ptr := mload(0x40)
207                 calldatacopy(free_ptr, 0, calldatasize)
208 
209                 /* We must explicitly forward ether to the underlying contract as well. */
210                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
211                 returndatacopy(free_ptr, 0, returndatasize)
212 
213                 if iszero(result) { revert(free_ptr, returndatasize) }
214                 return(free_ptr, returndatasize)
215             }
216         }
217     }
218 
219     modifier onlyTarget {
220         require(Proxyable(msg.sender) == target, "Must be proxy target");
221         _;
222     }
223 
224     event TargetUpdated(Proxyable newTarget);
225 }
226 
227 
228 /*
229 -----------------------------------------------------------------
230 FILE INFORMATION
231 -----------------------------------------------------------------
232 
233 file:       Proxyable.sol
234 version:    1.1
235 author:     Anton Jurisevic
236 
237 date:       2018-05-15
238 
239 checked:    Mike Spain
240 approved:   Samuel Brooks
241 
242 -----------------------------------------------------------------
243 MODULE DESCRIPTION
244 -----------------------------------------------------------------
245 
246 A proxyable contract that works hand in hand with the Proxy contract
247 to allow for anyone to interact with the underlying contract both
248 directly and through the proxy.
249 
250 -----------------------------------------------------------------
251 */
252 
253 
254 // This contract should be treated like an abstract contract
255 contract Proxyable is Owned {
256     /* The proxy this contract exists behind. */
257     Proxy public proxy;
258     Proxy public integrationProxy;
259 
260     /* The caller of the proxy, passed through to this contract.
261      * Note that every function using this member must apply the onlyProxy or
262      * optionalProxy modifiers, otherwise their invocations can use stale values. */
263     address messageSender;
264 
265     constructor(address _proxy, address _owner)
266         Owned(_owner)
267         public
268     {
269         proxy = Proxy(_proxy);
270         emit ProxyUpdated(_proxy);
271     }
272 
273     function setProxy(address _proxy)
274         external
275         onlyOwner
276     {
277         proxy = Proxy(_proxy);
278         emit ProxyUpdated(_proxy);
279     }
280 
281     function setIntegrationProxy(address _integrationProxy)
282         external
283         onlyOwner
284     {
285         integrationProxy = Proxy(_integrationProxy);
286     }
287 
288     function setMessageSender(address sender)
289         external
290         onlyProxy
291     {
292         messageSender = sender;
293     }
294 
295     modifier onlyProxy {
296         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
297         _;
298     }
299 
300     modifier optionalProxy
301     {
302         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy) {
303             messageSender = msg.sender;
304         }
305         _;
306     }
307 
308     modifier optionalProxy_onlyOwner
309     {
310         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy) {
311             messageSender = msg.sender;
312         }
313         require(messageSender == owner, "Owner only function");
314         _;
315     }
316 
317     event ProxyUpdated(address proxyAddress);
318 }
319 
320 
321 /**
322  * @title ERC20 interface
323  * @dev see https://github.com/ethereum/EIPs/issues/20
324  */
325 contract IERC20 {
326     function totalSupply() public view returns (uint);
327 
328     function balanceOf(address owner) public view returns (uint);
329 
330     function allowance(address owner, address spender) public view returns (uint);
331 
332     function transfer(address to, uint value) public returns (bool);
333 
334     function approve(address spender, uint value) public returns (bool);
335 
336     function transferFrom(address from, address to, uint value) public returns (bool);
337 
338     // ERC20 Optional
339     function name() public view returns (string);
340     function symbol() public view returns (string);
341     function decimals() public view returns (uint8);
342 
343     event Transfer(
344       address indexed from,
345       address indexed to,
346       uint value
347     );
348 
349     event Approval(
350       address indexed owner,
351       address indexed spender,
352       uint value
353     );
354 }
355 
356 
357 /*
358 -----------------------------------------------------------------
359 FILE INFORMATION
360 -----------------------------------------------------------------
361 
362 file:       ProxyERC20.sol
363 version:    1.0
364 author:     Jackson Chan, Clinton Ennis
365 
366 date:       2019-06-19
367 
368 -----------------------------------------------------------------
369 MODULE DESCRIPTION
370 -----------------------------------------------------------------
371 
372 A proxy contract that is ERC20 compliant for the Synthetix Network.
373 
374 If it does not recognise a function being called on it, passes all
375 value and call data to an underlying target contract.
376 
377 The ERC20 standard has been explicitly implemented to ensure
378 contract to contract calls are compatable on MAINNET
379 
380 -----------------------------------------------------------------
381 */
382 
383 
384 contract ProxyERC20 is Proxy, IERC20 {
385 
386     constructor(address _owner)
387         Proxy(_owner)
388         public
389     {}
390 
391     // ------------- ERC20 Details ------------- //
392 
393     function name() public view returns (string){
394         // Immutable static call from target contract
395         return IERC20(target).name();
396     }
397 
398     function symbol() public view returns (string){
399          // Immutable static call from target contract
400         return IERC20(target).symbol();
401     }
402 
403     function decimals() public view returns (uint8){
404          // Immutable static call from target contract
405         return IERC20(target).decimals();
406     }
407 
408     // ------------- ERC20 Interface ------------- //
409 
410     /**
411     * @dev Total number of tokens in existence
412     */
413     function totalSupply() public view returns (uint256) {
414         // Immutable static call from target contract
415         return IERC20(target).totalSupply();
416     }
417 
418     /**
419     * @dev Gets the balance of the specified address.
420     * @param owner The address to query the balance of.
421     * @return An uint256 representing the amount owned by the passed address.
422     */
423     function balanceOf(address owner) public view returns (uint256) {
424         // Immutable static call from target contract
425         return IERC20(target).balanceOf(owner);
426     }
427 
428     /**
429     * @dev Function to check the amount of tokens that an owner allowed to a spender.
430     * @param owner address The address which owns the funds.
431     * @param spender address The address which will spend the funds.
432     * @return A uint256 specifying the amount of tokens still available for the spender.
433     */
434     function allowance(
435         address owner,
436         address spender
437     )
438         public
439         view
440         returns (uint256)
441     {
442         // Immutable static call from target contract
443         return IERC20(target).allowance(owner, spender);
444     }
445 
446     /**
447     * @dev Transfer token for a specified address
448     * @param to The address to transfer to.
449     * @param value The amount to be transferred.
450     */
451     function transfer(address to, uint256 value) public returns (bool) {
452         // Mutable state call requires the proxy to tell the target who the msg.sender is.
453         target.setMessageSender(msg.sender);
454 
455         // Forward the ERC20 call to the target contract
456         IERC20(target).transfer(to, value);
457 
458         // Event emitting will occur via Synthetix.Proxy._emit()
459         return true;
460     }
461 
462     /**
463     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
464     * Beware that changing an allowance with this method brings the risk that someone may use both the old
465     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
466     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
467     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
468     * @param spender The address which will spend the funds.
469     * @param value The amount of tokens to be spent.
470     */
471     function approve(address spender, uint256 value) public returns (bool) {
472         // Mutable state call requires the proxy to tell the target who the msg.sender is.
473         target.setMessageSender(msg.sender);
474 
475         // Forward the ERC20 call to the target contract
476         IERC20(target).approve(spender, value);
477 
478         // Event emitting will occur via Synthetix.Proxy._emit()
479         return true;
480     }
481 
482     /**
483     * @dev Transfer tokens from one address to another
484     * @param from address The address which you want to send tokens from
485     * @param to address The address which you want to transfer to
486     * @param value uint256 the amount of tokens to be transferred
487     */
488     function transferFrom(
489         address from,
490         address to,
491         uint256 value
492     )
493         public
494         returns (bool)
495     {
496         // Mutable state call requires the proxy to tell the target who the msg.sender is.
497         target.setMessageSender(msg.sender);
498 
499         // Forward the ERC20 call to the target contract
500         IERC20(target).transferFrom(from, to, value);
501 
502         // Event emitting will occur via Synthetix.Proxy._emit()
503         return true;
504     }
505 }
506 
