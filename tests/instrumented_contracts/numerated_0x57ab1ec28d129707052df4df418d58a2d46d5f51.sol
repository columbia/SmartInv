1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-08
3 */
4 
5 /* ===============================================
6 * Flattened with Solidifier by Coinage
7 * 
8 * https://solidifier.coina.ge
9 * ===============================================
10 */
11 
12 
13 /*
14 -----------------------------------------------------------------
15 FILE INFORMATION
16 -----------------------------------------------------------------
17 
18 file:       Owned.sol
19 version:    1.1
20 author:     Anton Jurisevic
21             Dominic Romanowski
22 
23 date:       2018-2-26
24 
25 -----------------------------------------------------------------
26 MODULE DESCRIPTION
27 -----------------------------------------------------------------
28 
29 An Owned contract, to be inherited by other contracts.
30 Requires its owner to be explicitly set in the constructor.
31 Provides an onlyOwner access modifier.
32 
33 To change owner, the current owner must nominate the next owner,
34 who then has to accept the nomination. The nomination can be
35 cancelled before it is accepted by the new owner by having the
36 previous owner change the nomination (setting it to 0).
37 
38 -----------------------------------------------------------------
39 */
40 
41 pragma solidity 0.4.25;
42 
43 /**
44  * @title A contract with an owner.
45  * @notice Contract ownership can be transferred by first nominating the new owner,
46  * who must then accept the ownership, which prevents accidental incorrect ownership transfers.
47  */
48 contract Owned {
49     address public owner;
50     address public nominatedOwner;
51 
52     /**
53      * @dev Owned Constructor
54      */
55     constructor(address _owner)
56         public
57     {
58         require(_owner != address(0), "Owner address cannot be 0");
59         owner = _owner;
60         emit OwnerChanged(address(0), _owner);
61     }
62 
63     /**
64      * @notice Nominate a new owner of this contract.
65      * @dev Only the current owner may nominate a new owner.
66      */
67     function nominateNewOwner(address _owner)
68         external
69         onlyOwner
70     {
71         nominatedOwner = _owner;
72         emit OwnerNominated(_owner);
73     }
74 
75     /**
76      * @notice Accept the nomination to be owner.
77      */
78     function acceptOwnership()
79         external
80     {
81         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
82         emit OwnerChanged(owner, nominatedOwner);
83         owner = nominatedOwner;
84         nominatedOwner = address(0);
85     }
86 
87     modifier onlyOwner
88     {
89         require(msg.sender == owner, "Only the contract owner may perform this action");
90         _;
91     }
92 
93     event OwnerNominated(address newOwner);
94     event OwnerChanged(address oldOwner, address newOwner);
95 }
96 
97 
98 /*
99 -----------------------------------------------------------------
100 FILE INFORMATION
101 -----------------------------------------------------------------
102 
103 file:       Proxy.sol
104 version:    1.3
105 author:     Anton Jurisevic
106 
107 date:       2018-05-29
108 
109 -----------------------------------------------------------------
110 MODULE DESCRIPTION
111 -----------------------------------------------------------------
112 
113 A proxy contract that, if it does not recognise the function
114 being called on it, passes all value and call data to an
115 underlying target contract.
116 
117 This proxy has the capacity to toggle between DELEGATECALL
118 and CALL style proxy functionality.
119 
120 The former executes in the proxy's context, and so will preserve 
121 msg.sender and store data at the proxy address. The latter will not.
122 Therefore, any contract the proxy wraps in the CALL style must
123 implement the Proxyable interface, in order that it can pass msg.sender
124 into the underlying contract as the state parameter, messageSender.
125 
126 -----------------------------------------------------------------
127 */
128 
129 
130 contract Proxy is Owned {
131 
132     Proxyable public target;
133     bool public useDELEGATECALL;
134 
135     constructor(address _owner)
136         Owned(_owner)
137         public
138     {}
139 
140     function setTarget(Proxyable _target)
141         external
142         onlyOwner
143     {
144         target = _target;
145         emit TargetUpdated(_target);
146     }
147 
148     function setUseDELEGATECALL(bool value) 
149         external
150         onlyOwner
151     {
152         useDELEGATECALL = value;
153     }
154 
155     function _emit(bytes callData, uint numTopics, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4)
156         external
157         onlyTarget
158     {
159         uint size = callData.length;
160         bytes memory _callData = callData;
161 
162         assembly {
163             /* The first 32 bytes of callData contain its length (as specified by the abi). 
164              * Length is assumed to be a uint256 and therefore maximum of 32 bytes
165              * in length. It is also leftpadded to be a multiple of 32 bytes.
166              * This means moving call_data across 32 bytes guarantees we correctly access
167              * the data itself. */
168             switch numTopics
169             case 0 {
170                 log0(add(_callData, 32), size)
171             } 
172             case 1 {
173                 log1(add(_callData, 32), size, topic1)
174             }
175             case 2 {
176                 log2(add(_callData, 32), size, topic1, topic2)
177             }
178             case 3 {
179                 log3(add(_callData, 32), size, topic1, topic2, topic3)
180             }
181             case 4 {
182                 log4(add(_callData, 32), size, topic1, topic2, topic3, topic4)
183             }
184         }
185     }
186 
187     function()
188         external
189         payable
190     {
191         if (useDELEGATECALL) {
192             assembly {
193                 /* Copy call data into free memory region. */
194                 let free_ptr := mload(0x40)
195                 calldatacopy(free_ptr, 0, calldatasize)
196 
197                 /* Forward all gas and call data to the target contract. */
198                 let result := delegatecall(gas, sload(target_slot), free_ptr, calldatasize, 0, 0)
199                 returndatacopy(free_ptr, 0, returndatasize)
200 
201                 /* Revert if the call failed, otherwise return the result. */
202                 if iszero(result) { revert(free_ptr, returndatasize) }
203                 return(free_ptr, returndatasize)
204             }
205         } else {
206             /* Here we are as above, but must send the messageSender explicitly 
207              * since we are using CALL rather than DELEGATECALL. */
208             target.setMessageSender(msg.sender);
209             assembly {
210                 let free_ptr := mload(0x40)
211                 calldatacopy(free_ptr, 0, calldatasize)
212 
213                 /* We must explicitly forward ether to the underlying contract as well. */
214                 let result := call(gas, sload(target_slot), callvalue, free_ptr, calldatasize, 0, 0)
215                 returndatacopy(free_ptr, 0, returndatasize)
216 
217                 if iszero(result) { revert(free_ptr, returndatasize) }
218                 return(free_ptr, returndatasize)
219             }
220         }
221     }
222 
223     modifier onlyTarget {
224         require(Proxyable(msg.sender) == target, "Must be proxy target");
225         _;
226     }
227 
228     event TargetUpdated(Proxyable newTarget);
229 }
230 
231 
232 /*
233 -----------------------------------------------------------------
234 FILE INFORMATION
235 -----------------------------------------------------------------
236 
237 file:       Proxyable.sol
238 version:    1.1
239 author:     Anton Jurisevic
240 
241 date:       2018-05-15
242 
243 checked:    Mike Spain
244 approved:   Samuel Brooks
245 
246 -----------------------------------------------------------------
247 MODULE DESCRIPTION
248 -----------------------------------------------------------------
249 
250 A proxyable contract that works hand in hand with the Proxy contract
251 to allow for anyone to interact with the underlying contract both
252 directly and through the proxy.
253 
254 -----------------------------------------------------------------
255 */
256 
257 
258 // This contract should be treated like an abstract contract
259 contract Proxyable is Owned {
260     /* The proxy this contract exists behind. */
261     Proxy public proxy;
262     Proxy public integrationProxy;
263 
264     /* The caller of the proxy, passed through to this contract.
265      * Note that every function using this member must apply the onlyProxy or
266      * optionalProxy modifiers, otherwise their invocations can use stale values. */
267     address messageSender;
268 
269     constructor(address _proxy, address _owner)
270         Owned(_owner)
271         public
272     {
273         proxy = Proxy(_proxy);
274         emit ProxyUpdated(_proxy);
275     }
276 
277     function setProxy(address _proxy)
278         external
279         onlyOwner
280     {
281         proxy = Proxy(_proxy);
282         emit ProxyUpdated(_proxy);
283     }
284 
285     function setIntegrationProxy(address _integrationProxy)
286         external
287         onlyOwner
288     {
289         integrationProxy = Proxy(_integrationProxy);
290     }
291 
292     function setMessageSender(address sender)
293         external
294         onlyProxy
295     {
296         messageSender = sender;
297     }
298 
299     modifier onlyProxy {
300         require(Proxy(msg.sender) == proxy || Proxy(msg.sender) == integrationProxy, "Only the proxy can call");
301         _;
302     }
303 
304     modifier optionalProxy
305     {
306         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy) {
307             messageSender = msg.sender;
308         }
309         _;
310     }
311 
312     modifier optionalProxy_onlyOwner
313     {
314         if (Proxy(msg.sender) != proxy && Proxy(msg.sender) != integrationProxy) {
315             messageSender = msg.sender;
316         }
317         require(messageSender == owner, "Owner only function");
318         _;
319     }
320 
321     event ProxyUpdated(address proxyAddress);
322 }
323 
324 
325 /**
326  * @title ERC20 interface
327  * @dev see https://github.com/ethereum/EIPs/issues/20
328  */
329 contract IERC20 {
330     function totalSupply() public view returns (uint);
331 
332     function balanceOf(address owner) public view returns (uint);
333 
334     function allowance(address owner, address spender) public view returns (uint);
335 
336     function transfer(address to, uint value) public returns (bool);
337 
338     function approve(address spender, uint value) public returns (bool);
339 
340     function transferFrom(address from, address to, uint value) public returns (bool);
341 
342     // ERC20 Optional
343     function name() public view returns (string);
344     function symbol() public view returns (string);
345     function decimals() public view returns (uint8);
346 
347     event Transfer(
348       address indexed from,
349       address indexed to,
350       uint value
351     );
352 
353     event Approval(
354       address indexed owner,
355       address indexed spender,
356       uint value
357     );
358 }
359 
360 
361 /*
362 -----------------------------------------------------------------
363 FILE INFORMATION
364 -----------------------------------------------------------------
365 
366 file:       ProxyERC20.sol
367 version:    1.0
368 author:     Jackson Chan, Clinton Ennis
369 
370 date:       2019-06-19
371 
372 -----------------------------------------------------------------
373 MODULE DESCRIPTION
374 -----------------------------------------------------------------
375 
376 A proxy contract that is ERC20 compliant for the Synthetix Network.
377 
378 If it does not recognise a function being called on it, passes all
379 value and call data to an underlying target contract.
380 
381 The ERC20 standard has been explicitly implemented to ensure
382 contract to contract calls are compatable on MAINNET
383 
384 -----------------------------------------------------------------
385 */
386 
387 
388 contract ProxyERC20 is Proxy, IERC20 {
389 
390     constructor(address _owner)
391         Proxy(_owner)
392         public
393     {}
394 
395     // ------------- ERC20 Details ------------- //
396 
397     function name() public view returns (string){
398         // Immutable static call from target contract
399         return IERC20(target).name();
400     }
401 
402     function symbol() public view returns (string){
403          // Immutable static call from target contract
404         return IERC20(target).symbol();
405     }
406 
407     function decimals() public view returns (uint8){
408          // Immutable static call from target contract
409         return IERC20(target).decimals();
410     }
411 
412     // ------------- ERC20 Interface ------------- //
413 
414     /**
415     * @dev Total number of tokens in existence
416     */
417     function totalSupply() public view returns (uint256) {
418         // Immutable static call from target contract
419         return IERC20(target).totalSupply();
420     }
421 
422     /**
423     * @dev Gets the balance of the specified address.
424     * @param owner The address to query the balance of.
425     * @return An uint256 representing the amount owned by the passed address.
426     */
427     function balanceOf(address owner) public view returns (uint256) {
428         // Immutable static call from target contract
429         return IERC20(target).balanceOf(owner);
430     }
431 
432     /**
433     * @dev Function to check the amount of tokens that an owner allowed to a spender.
434     * @param owner address The address which owns the funds.
435     * @param spender address The address which will spend the funds.
436     * @return A uint256 specifying the amount of tokens still available for the spender.
437     */
438     function allowance(
439         address owner,
440         address spender
441     )
442         public
443         view
444         returns (uint256)
445     {
446         // Immutable static call from target contract
447         return IERC20(target).allowance(owner, spender);
448     }
449 
450     /**
451     * @dev Transfer token for a specified address
452     * @param to The address to transfer to.
453     * @param value The amount to be transferred.
454     */
455     function transfer(address to, uint256 value) public returns (bool) {
456         // Mutable state call requires the proxy to tell the target who the msg.sender is.
457         target.setMessageSender(msg.sender);
458 
459         // Forward the ERC20 call to the target contract
460         IERC20(target).transfer(to, value);
461 
462         // Event emitting will occur via Synthetix.Proxy._emit()
463         return true;
464     }
465 
466     /**
467     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
468     * Beware that changing an allowance with this method brings the risk that someone may use both the old
469     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
470     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
471     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
472     * @param spender The address which will spend the funds.
473     * @param value The amount of tokens to be spent.
474     */
475     function approve(address spender, uint256 value) public returns (bool) {
476         // Mutable state call requires the proxy to tell the target who the msg.sender is.
477         target.setMessageSender(msg.sender);
478 
479         // Forward the ERC20 call to the target contract
480         IERC20(target).approve(spender, value);
481 
482         // Event emitting will occur via Synthetix.Proxy._emit()
483         return true;
484     }
485 
486     /**
487     * @dev Transfer tokens from one address to another
488     * @param from address The address which you want to send tokens from
489     * @param to address The address which you want to transfer to
490     * @param value uint256 the amount of tokens to be transferred
491     */
492     function transferFrom(
493         address from,
494         address to,
495         uint256 value
496     )
497         public
498         returns (bool)
499     {
500         // Mutable state call requires the proxy to tell the target who the msg.sender is.
501         target.setMessageSender(msg.sender);
502 
503         // Forward the ERC20 call to the target contract
504         IERC20(target).transferFrom(from, to, value);
505 
506         // Event emitting will occur via Synthetix.Proxy._emit()
507         return true;
508     }
509 }