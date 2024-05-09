1 pragma solidity >=0.4.25 <0.6.0;
2 
3 
4 
5 /*
6  * Hubii Nahmii
7  *
8  * Compliant with the Hubii Nahmii specification v0.12.
9  *
10  * Copyright (C) 2017-2018 Hubii AS
11  */
12 
13 
14 /**
15  * @title Modifiable
16  * @notice A contract with basic modifiers
17  */
18 contract Modifiable {
19     //
20     // Modifiers
21     // -----------------------------------------------------------------------------------------------------------------
22     modifier notNullAddress(address _address) {
23         require(_address != address(0));
24         _;
25     }
26 
27     modifier notThisAddress(address _address) {
28         require(_address != address(this));
29         _;
30     }
31 
32     modifier notNullOrThisAddress(address _address) {
33         require(_address != address(0));
34         require(_address != address(this));
35         _;
36     }
37 
38     modifier notSameAddresses(address _address1, address _address2) {
39         if (_address1 != _address2)
40             _;
41     }
42 }
43 
44 /*
45  * Hubii Nahmii
46  *
47  * Compliant with the Hubii Nahmii specification v0.12.
48  *
49  * Copyright (C) 2017-2018 Hubii AS
50  */
51 
52 
53 
54 /**
55  * @title SelfDestructible
56  * @notice Contract that allows for self-destruction
57  */
58 contract SelfDestructible {
59     //
60     // Variables
61     // -----------------------------------------------------------------------------------------------------------------
62     bool public selfDestructionDisabled;
63 
64     //
65     // Events
66     // -----------------------------------------------------------------------------------------------------------------
67     event SelfDestructionDisabledEvent(address wallet);
68     event TriggerSelfDestructionEvent(address wallet);
69 
70     //
71     // Functions
72     // -----------------------------------------------------------------------------------------------------------------
73     /// @notice Get the address of the destructor role
74     function destructor()
75     public
76     view
77     returns (address);
78 
79     /// @notice Disable self-destruction of this contract
80     /// @dev This operation can not be undone
81     function disableSelfDestruction()
82     public
83     {
84         // Require that sender is the assigned destructor
85         require(destructor() == msg.sender);
86 
87         // Disable self-destruction
88         selfDestructionDisabled = true;
89 
90         // Emit event
91         emit SelfDestructionDisabledEvent(msg.sender);
92     }
93 
94     /// @notice Destroy this contract
95     function triggerSelfDestruction()
96     public
97     {
98         // Require that sender is the assigned destructor
99         require(destructor() == msg.sender);
100 
101         // Require that self-destruction has not been disabled
102         require(!selfDestructionDisabled);
103 
104         // Emit event
105         emit TriggerSelfDestructionEvent(msg.sender);
106 
107         // Self-destruct and reward destructor
108         selfdestruct(msg.sender);
109     }
110 }
111 
112 /*
113  * Hubii Nahmii
114  *
115  * Compliant with the Hubii Nahmii specification v0.12.
116  *
117  * Copyright (C) 2017-2018 Hubii AS
118  */
119 
120 
121 
122 
123 
124 
125 /**
126  * @title Ownable
127  * @notice A modifiable that has ownership roles
128  */
129 contract Ownable is Modifiable, SelfDestructible {
130     //
131     // Variables
132     // -----------------------------------------------------------------------------------------------------------------
133     address public deployer;
134     address public operator;
135 
136     //
137     // Events
138     // -----------------------------------------------------------------------------------------------------------------
139     event SetDeployerEvent(address oldDeployer, address newDeployer);
140     event SetOperatorEvent(address oldOperator, address newOperator);
141 
142     //
143     // Constructor
144     // -----------------------------------------------------------------------------------------------------------------
145     constructor(address _deployer) internal notNullOrThisAddress(_deployer) {
146         deployer = _deployer;
147         operator = _deployer;
148     }
149 
150     //
151     // Functions
152     // -----------------------------------------------------------------------------------------------------------------
153     /// @notice Return the address that is able to initiate self-destruction
154     function destructor()
155     public
156     view
157     returns (address)
158     {
159         return deployer;
160     }
161 
162     /// @notice Set the deployer of this contract
163     /// @param newDeployer The address of the new deployer
164     function setDeployer(address newDeployer)
165     public
166     onlyDeployer
167     notNullOrThisAddress(newDeployer)
168     {
169         if (newDeployer != deployer) {
170             // Set new deployer
171             address oldDeployer = deployer;
172             deployer = newDeployer;
173 
174             // Emit event
175             emit SetDeployerEvent(oldDeployer, newDeployer);
176         }
177     }
178 
179     /// @notice Set the operator of this contract
180     /// @param newOperator The address of the new operator
181     function setOperator(address newOperator)
182     public
183     onlyOperator
184     notNullOrThisAddress(newOperator)
185     {
186         if (newOperator != operator) {
187             // Set new operator
188             address oldOperator = operator;
189             operator = newOperator;
190 
191             // Emit event
192             emit SetOperatorEvent(oldOperator, newOperator);
193         }
194     }
195 
196     /// @notice Gauge whether message sender is deployer or not
197     /// @return true if msg.sender is deployer, else false
198     function isDeployer()
199     internal
200     view
201     returns (bool)
202     {
203         return msg.sender == deployer;
204     }
205 
206     /// @notice Gauge whether message sender is operator or not
207     /// @return true if msg.sender is operator, else false
208     function isOperator()
209     internal
210     view
211     returns (bool)
212     {
213         return msg.sender == operator;
214     }
215 
216     /// @notice Gauge whether message sender is operator or deployer on the one hand, or none of these on these on
217     /// on the other hand
218     /// @return true if msg.sender is operator, else false
219     function isDeployerOrOperator()
220     internal
221     view
222     returns (bool)
223     {
224         return isDeployer() || isOperator();
225     }
226 
227     // Modifiers
228     // -----------------------------------------------------------------------------------------------------------------
229     modifier onlyDeployer() {
230         require(isDeployer());
231         _;
232     }
233 
234     modifier notDeployer() {
235         require(!isDeployer());
236         _;
237     }
238 
239     modifier onlyOperator() {
240         require(isOperator());
241         _;
242     }
243 
244     modifier notOperator() {
245         require(!isOperator());
246         _;
247     }
248 
249     modifier onlyDeployerOrOperator() {
250         require(isDeployerOrOperator());
251         _;
252     }
253 
254     modifier notDeployerOrOperator() {
255         require(!isDeployerOrOperator());
256         _;
257     }
258 }
259 
260 /*
261  * Hubii Nahmii
262  *
263  * Compliant with the Hubii Nahmii specification v0.12.
264  *
265  * Copyright (C) 2017-2018 Hubii AS
266  */
267 
268 
269 
270 /**
271  * @title TransferController
272  * @notice A base contract to handle transfers of different currency types
273  */
274 contract TransferController {
275     //
276     // Events
277     // -----------------------------------------------------------------------------------------------------------------
278     event CurrencyTransferred(address from, address to, uint256 value,
279         address currencyCt, uint256 currencyId);
280 
281     //
282     // Functions
283     // -----------------------------------------------------------------------------------------------------------------
284     function isFungible()
285     public
286     view
287     returns (bool);
288 
289     function standard()
290     public
291     view
292     returns (string memory);
293 
294     /// @notice MUST be called with DELEGATECALL
295     function receive(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
296     public;
297 
298     /// @notice MUST be called with DELEGATECALL
299     function approve(address to, uint256 value, address currencyCt, uint256 currencyId)
300     public;
301 
302     /// @notice MUST be called with DELEGATECALL
303     function dispatch(address from, address to, uint256 value, address currencyCt, uint256 currencyId)
304     public;
305 
306     //----------------------------------------
307 
308     function getReceiveSignature()
309     public
310     pure
311     returns (bytes4)
312     {
313         return bytes4(keccak256("receive(address,address,uint256,address,uint256)"));
314     }
315 
316     function getApproveSignature()
317     public
318     pure
319     returns (bytes4)
320     {
321         return bytes4(keccak256("approve(address,uint256,address,uint256)"));
322     }
323 
324     function getDispatchSignature()
325     public
326     pure
327     returns (bytes4)
328     {
329         return bytes4(keccak256("dispatch(address,address,uint256,address,uint256)"));
330     }
331 }
332 
333 /*
334  * Hubii Nahmii
335  *
336  * Compliant with the Hubii Nahmii specification v0.12.
337  *
338  * Copyright (C) 2017-2018 Hubii AS
339  */
340 
341 
342 
343 
344 
345 
346 /**
347  * @title TransferControllerManager
348  * @notice Handles the management of transfer controllers
349  */
350 contract TransferControllerManager is Ownable {
351     //
352     // Constants
353     // -----------------------------------------------------------------------------------------------------------------
354     struct CurrencyInfo {
355         bytes32 standard;
356         bool blacklisted;
357     }
358 
359     //
360     // Variables
361     // -----------------------------------------------------------------------------------------------------------------
362     mapping(bytes32 => address) public registeredTransferControllers;
363     mapping(address => CurrencyInfo) public registeredCurrencies;
364 
365     //
366     // Events
367     // -----------------------------------------------------------------------------------------------------------------
368     event RegisterTransferControllerEvent(string standard, address controller);
369     event ReassociateTransferControllerEvent(string oldStandard, string newStandard, address controller);
370 
371     event RegisterCurrencyEvent(address currencyCt, string standard);
372     event DeregisterCurrencyEvent(address currencyCt);
373     event BlacklistCurrencyEvent(address currencyCt);
374     event WhitelistCurrencyEvent(address currencyCt);
375 
376     //
377     // Constructor
378     // -----------------------------------------------------------------------------------------------------------------
379     constructor(address deployer) Ownable(deployer) public {
380     }
381 
382     //
383     // Functions
384     // -----------------------------------------------------------------------------------------------------------------
385     function registerTransferController(string calldata standard, address controller)
386     external
387     onlyDeployer
388     notNullAddress(controller)
389     {
390         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:58]");
391         bytes32 standardHash = keccak256(abi.encodePacked(standard));
392 
393         registeredTransferControllers[standardHash] = controller;
394 
395         // Emit event
396         emit RegisterTransferControllerEvent(standard, controller);
397     }
398 
399     function reassociateTransferController(string calldata oldStandard, string calldata newStandard, address controller)
400     external
401     onlyDeployer
402     notNullAddress(controller)
403     {
404         require(bytes(newStandard).length > 0, "Empty new standard not supported [TransferControllerManager.sol:72]");
405         bytes32 oldStandardHash = keccak256(abi.encodePacked(oldStandard));
406         bytes32 newStandardHash = keccak256(abi.encodePacked(newStandard));
407 
408         require(registeredTransferControllers[oldStandardHash] != address(0), "Old standard not registered [TransferControllerManager.sol:76]");
409         require(registeredTransferControllers[newStandardHash] == address(0), "New standard previously registered [TransferControllerManager.sol:77]");
410 
411         registeredTransferControllers[newStandardHash] = registeredTransferControllers[oldStandardHash];
412         registeredTransferControllers[oldStandardHash] = address(0);
413 
414         // Emit event
415         emit ReassociateTransferControllerEvent(oldStandard, newStandard, controller);
416     }
417 
418     function registerCurrency(address currencyCt, string calldata standard)
419     external
420     onlyOperator
421     notNullAddress(currencyCt)
422     {
423         require(bytes(standard).length > 0, "Empty standard not supported [TransferControllerManager.sol:91]");
424         bytes32 standardHash = keccak256(abi.encodePacked(standard));
425 
426         require(registeredCurrencies[currencyCt].standard == bytes32(0), "Currency previously registered [TransferControllerManager.sol:94]");
427 
428         registeredCurrencies[currencyCt].standard = standardHash;
429 
430         // Emit event
431         emit RegisterCurrencyEvent(currencyCt, standard);
432     }
433 
434     function deregisterCurrency(address currencyCt)
435     external
436     onlyOperator
437     {
438         require(registeredCurrencies[currencyCt].standard != 0, "Currency not registered [TransferControllerManager.sol:106]");
439 
440         registeredCurrencies[currencyCt].standard = bytes32(0);
441         registeredCurrencies[currencyCt].blacklisted = false;
442 
443         // Emit event
444         emit DeregisterCurrencyEvent(currencyCt);
445     }
446 
447     function blacklistCurrency(address currencyCt)
448     external
449     onlyOperator
450     {
451         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:119]");
452 
453         registeredCurrencies[currencyCt].blacklisted = true;
454 
455         // Emit event
456         emit BlacklistCurrencyEvent(currencyCt);
457     }
458 
459     function whitelistCurrency(address currencyCt)
460     external
461     onlyOperator
462     {
463         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:131]");
464 
465         registeredCurrencies[currencyCt].blacklisted = false;
466 
467         // Emit event
468         emit WhitelistCurrencyEvent(currencyCt);
469     }
470 
471     /**
472     @notice The provided standard takes priority over assigned interface to currency
473     */
474     function transferController(address currencyCt, string memory standard)
475     public
476     view
477     returns (TransferController)
478     {
479         if (bytes(standard).length > 0) {
480             bytes32 standardHash = keccak256(abi.encodePacked(standard));
481 
482             require(registeredTransferControllers[standardHash] != address(0), "Standard not registered [TransferControllerManager.sol:150]");
483             return TransferController(registeredTransferControllers[standardHash]);
484         }
485 
486         require(registeredCurrencies[currencyCt].standard != bytes32(0), "Currency not registered [TransferControllerManager.sol:154]");
487         require(!registeredCurrencies[currencyCt].blacklisted, "Currency blacklisted [TransferControllerManager.sol:155]");
488 
489         address controllerAddress = registeredTransferControllers[registeredCurrencies[currencyCt].standard];
490         require(controllerAddress != address(0), "No matching transfer controller [TransferControllerManager.sol:158]");
491 
492         return TransferController(controllerAddress);
493     }
494 }