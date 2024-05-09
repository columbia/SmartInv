1 pragma solidity 0.4.15;
2 
3 /// @title Ownable
4 /// @dev The Ownable contract has an owner address, and provides basic authorization control
5 /// functions, this simplifies the implementation of "user permissions".
6 contract Ownable {
7 
8   // EVENTS
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12   // PUBLIC FUNCTIONS
13 
14   /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19   /// @dev Allows the current owner to transfer control of the contract to a newOwner.
20   /// @param newOwner The address to transfer ownership to.
21   function transferOwnership(address newOwner) onlyOwner public {
22     require(newOwner != address(0));
23     OwnershipTransferred(owner, newOwner);
24     owner = newOwner;
25   }
26 
27   // MODIFIERS
28 
29   /// @dev Throws if called by any account other than the owner.
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   // FIELDS
36 
37   address public owner;
38 }
39 
40 /// @title ERC20 interface
41 /// @dev Full ERC20 interface described at https://github.com/ethereum/EIPs/issues/20.
42 contract ERC20 {
43 
44   // EVENTS
45 
46   event Transfer(address indexed from, address indexed to, uint256 value);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 
49   // PUBLIC FUNCTIONS
50 
51   function transfer(address _to, uint256 _value) public returns (bool);
52   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
53   function approve(address _spender, uint256 _value) public returns (bool);
54   function balanceOf(address _owner) public constant returns (uint256);
55   function allowance(address _owner, address _spender) public constant returns (uint256);
56 
57   // FIELDS
58 
59   uint256 public totalSupply;
60 }
61 
62 contract WithToken {
63     ERC20 public token;
64 }
65 
66 contract SSPTypeAware {
67     enum SSPType { Gate, Direct }
68 }
69 
70 contract SSPRegistry is SSPTypeAware{
71     // This is the function that actually insert a record.
72     function register(address key, SSPType sspType, uint16 publisherFee, address recordOwner);
73 
74     // Updates the values of the given record.
75     function updatePublisherFee(address key, uint16 newFee, address sender);
76 
77     function applyKarmaDiff(address key, uint256[2] diff);
78 
79     // Unregister a given record
80     function unregister(address key, address sender);
81 
82     //Transfer ownership of record
83     function transfer(address key, address newOwner, address sender);
84 
85     function getOwner(address key) constant returns(address);
86 
87     // Tells whether a given key is registered.
88     function isRegistered(address key) constant returns(bool);
89 
90     function getSSP(address key) constant returns(address sspAddress, SSPType sspType, uint16 publisherFee, uint256[2] karma, address recordOwner);
91 
92     function getAllSSP() constant returns(address[] addresses, SSPType[] sspTypes, uint16[] publisherFees, uint256[2][] karmas, address[] recordOwners);
93 
94     function kill();
95 }
96 
97 contract PublisherRegistry {
98     // This is the function that actually insert a record.
99     function register(address key, bytes32[5] url, address recordOwner);
100 
101     // Updates the values of the given record.
102     function updateUrl(address key, bytes32[5] url, address sender);
103 
104     function applyKarmaDiff(address key, uint256[2] diff);
105 
106     // Unregister a given record
107     function unregister(address key, address sender);
108 
109     //Transfer ownership of record
110     function transfer(address key, address newOwner, address sender);
111 
112     function getOwner(address key) constant returns(address);
113 
114     // Tells whether a given key is registered.
115     function isRegistered(address key) constant returns(bool);
116 
117     function getPublisher(address key) constant returns(address publisherAddress, bytes32[5] url, uint256[2] karma, address recordOwner);
118 
119     //@dev Get list of all registered publishers
120     //@return Returns array of addresses registered as DSP with register times
121     function getAllPublishers() constant returns(address[] addresses, bytes32[5][] urls, uint256[2][] karmas, address[] recordOwners);
122 
123     function kill();
124 }
125 
126 contract DSPTypeAware {
127     enum DSPType { Gate, Direct }
128 }
129 
130 contract DSPRegistry is DSPTypeAware{
131     // This is the function that actually insert a record.
132     function register(address key, DSPType dspType, bytes32[5] url, address recordOwner);
133 
134     // Updates the values of the given record.
135     function updateUrl(address key, bytes32[5] url, address sender);
136 
137     function applyKarmaDiff(address key, uint256[2] diff);
138 
139     // Unregister a given record
140     function unregister(address key, address sender);
141 
142     // Transfer ownership of a given record.
143     function transfer(address key, address newOwner, address sender);
144 
145     function getOwner(address key) constant returns(address);
146 
147     // Tells whether a given key is registered.
148     function isRegistered(address key) constant returns(bool);
149 
150     function getDSP(address key) constant returns(address dspAddress, DSPType dspType, bytes32[5] url, uint256[2] karma, address recordOwner);
151 
152     //@dev Get list of all registered dsp
153     //@return Returns array of addresses registered as DSP with register times
154     function getAllDSP() constant returns(address[] addresses, DSPType[] dspTypes, bytes32[5][] urls, uint256[2][] karmas, address[] recordOwners) ;
155 
156     function kill();
157 }
158 
159 contract DepositRegistry {
160     // This is the function that actually insert a record.
161     function register(address key, uint256 amount, address depositOwner);
162 
163     // Unregister a given record
164     function unregister(address key);
165 
166     function transfer(address key, address newOwner, address sender);
167 
168     function spend(address key, uint256 amount);
169 
170     function refill(address key, uint256 amount);
171 
172     // Tells whether a given key is registered.
173     function isRegistered(address key) constant returns(bool);
174 
175     function getDepositOwner(address key) constant returns(address);
176 
177     function getDeposit(address key) constant returns(uint256 amount);
178 
179     function getDepositRecord(address key) constant returns(address owner, uint time, uint256 amount, address depositOwner);
180 
181     function hasEnough(address key, uint256 amount) constant returns(bool);
182 
183     function kill();
184 }
185 
186 contract AuditorRegistry {
187     // This is the function that actually insert a record.
188     function register(address key, address recordOwner);
189 
190     function applyKarmaDiff(address key, uint256[2] diff);
191 
192     // Unregister a given record
193     function unregister(address key, address sender);
194 
195     //Transfer ownership of record
196     function transfer(address key, address newOwner, address sender);
197 
198     function getOwner(address key) constant returns(address);
199 
200     // Tells whether a given key is registered.
201     function isRegistered(address key) constant returns(bool);
202 
203     function getAuditor(address key) constant returns(address auditorAddress, uint256[2] karma, address recordOwner);
204 
205     //@dev Get list of all registered dsp
206     //@return Returns array of addresses registered as DSP with register times
207     function getAllAuditors() constant returns(address[] addresses, uint256[2][] karmas, address[] recordOwners);
208 
209     function kill();
210 }
211 
212 contract DepositAware is WithToken{
213     function returnDeposit(address depositAccount, DepositRegistry depositRegistry) internal {
214         if (depositRegistry.isRegistered(depositAccount)) {
215             uint256 amount = depositRegistry.getDeposit(depositAccount);
216             address depositOwner = depositRegistry.getDepositOwner(depositAccount);
217             if (amount > 0) {
218                 token.transfer(depositOwner, amount);
219                 depositRegistry.unregister(depositAccount);
220             }
221         }
222     }
223 }
224 
225 contract SecurityDepositAware is DepositAware{
226     uint256 constant SECURITY_DEPOSIT_SIZE = 10;
227 
228     DepositRegistry public securityDepositRegistry;
229 
230     function receiveSecurityDeposit(address depositAccount) internal {
231         token.transferFrom(msg.sender, this, SECURITY_DEPOSIT_SIZE);
232         securityDepositRegistry.register(depositAccount, SECURITY_DEPOSIT_SIZE, msg.sender);
233     }
234 
235     function transferSecurityDeposit(address depositAccount, address newOwner) {
236         securityDepositRegistry.transfer(depositAccount, newOwner, msg.sender);
237     }
238 }
239 
240 contract AuditorRegistrar is SecurityDepositAware{
241     AuditorRegistry public auditorRegistry;
242 
243     event AuditorRegistered(address auditorAddress);
244     event AuditorUnregistered(address auditorAddress);
245 
246     //@dev Retrieve information about registered Auditor
247     //@return Address of registered Auditor and time when registered
248     function findAuditor(address addr) constant returns(address auditorAddress, uint256[2] karma, address recordOwner) {
249         return auditorRegistry.getAuditor(addr);
250     }
251 
252     //@dev check if Auditor registered
253     function isAuditorRegistered(address key) constant returns(bool) {
254         return auditorRegistry.isRegistered(key);
255     }
256 
257     //@dev Register organisation as Auditor
258     //@param auditorAddress address of wallet to register
259     function registerAuditor(address auditorAddress) {
260         receiveSecurityDeposit(auditorAddress);
261         auditorRegistry.register(auditorAddress, msg.sender);
262         AuditorRegistered(auditorAddress);
263     }
264 
265     //@dev Unregister Auditor and return unused deposit
266     //@param Address of Auditor to be unregistered
267     function unregisterAuditor(address auditorAddress) {
268         returnDeposit(auditorAddress, securityDepositRegistry);
269         auditorRegistry.unregister(auditorAddress, msg.sender);
270         AuditorUnregistered(auditorAddress);
271     }
272 
273     //@dev transfer ownership of this Auditor record
274     //@param address of Auditor
275     //@param address of new owner
276     function transferAuditorRecord(address key, address newOwner) {
277         auditorRegistry.transfer(key, newOwner, msg.sender);
278     }
279 }
280 
281 contract DSPRegistrar is DSPTypeAware, SecurityDepositAware {
282     DSPRegistry public dspRegistry;
283 
284     event DSPRegistered(address dspAddress);
285     event DSPUnregistered(address dspAddress);
286     event DSPParametersChanged(address dspAddress);
287 
288     //@dev Retrieve information about registered DSP
289     //@return Address of registered DSP and time when registered
290     function findDsp(address addr) constant returns(address dspAddress, DSPType dspType, bytes32[5] url, uint256[2] karma, address recordOwner) {
291         return dspRegistry.getDSP(addr);
292     }
293 
294     //@dev Register organisation as DSP
295     //@param dspAddress address of wallet to register
296     function registerDsp(address dspAddress, DSPType dspType, bytes32[5] url) {
297         receiveSecurityDeposit(dspAddress);
298         dspRegistry.register(dspAddress, dspType, url, msg.sender);
299         DSPRegistered(dspAddress);
300     }
301 
302     //@dev check if DSP registered
303     function isDspRegistered(address key) constant returns(bool) {
304         return dspRegistry.isRegistered(key);
305     }
306 
307     //@dev Unregister DSP and return unused deposit
308     //@param Address of DSP to be unregistered
309     function unregisterDsp(address dspAddress) {
310         returnDeposit(dspAddress, securityDepositRegistry);
311         dspRegistry.unregister(dspAddress, msg.sender);
312         DSPUnregistered(dspAddress);
313     }
314 
315     //@dev Change url of DSP
316     //@param address of DSP to change
317     //@param new url
318     function updateUrl(address key, bytes32[5] url) {
319         dspRegistry.updateUrl(key, url, msg.sender);
320         DSPParametersChanged(key);
321     }
322 
323     //@dev transfer ownership of this DSP record
324     //@param address of DSP
325     //@param address of new owner
326     function transferDSPRecord(address key, address newOwner) {
327         dspRegistry.transfer(key, newOwner, msg.sender);
328     }
329 }
330 
331 contract PublisherRegistrar is SecurityDepositAware{
332     PublisherRegistry public publisherRegistry;
333 
334     event PublisherRegistered(address publisherAddress);
335     event PublisherUnregistered(address publisherAddress);
336     event PublisherParametersChanged(address publisherAddress);
337 
338     //@dev Retrieve information about registered Publisher
339     //@return Address of registered Publisher and time when registered
340     function findPublisher(address addr) constant returns(address publisherAddress, bytes32[5] url, uint256[2] karma, address recordOwner) {
341         return publisherRegistry.getPublisher(addr);
342     }
343 
344     function isPublisherRegistered(address key) constant returns(bool) {
345         return publisherRegistry.isRegistered(key);
346     }
347 
348     //@dev Register organisation as Publisher
349     //@param publisherAddress address of wallet to register
350     function registerPublisher(address publisherAddress, bytes32[5] url) {
351         receiveSecurityDeposit(publisherAddress);
352         publisherRegistry.register(publisherAddress, url, msg.sender);
353         PublisherRegistered(publisherAddress);
354     }
355 
356     //@dev Unregister Publisher and return unused deposit
357     //@param Address of Publisher to be unregistered
358     function unregisterPublisher(address publisherAddress) {
359         returnDeposit(publisherAddress, securityDepositRegistry);
360         publisherRegistry.unregister(publisherAddress, msg.sender);
361         PublisherUnregistered(publisherAddress);
362     }
363 
364     //@dev transfer ownership of this Publisher record
365     //@param address of Publisher
366     //@param address of new owner
367     function transferPublisherRecord(address key, address newOwner) {
368         publisherRegistry.transfer(key, newOwner, msg.sender);
369     }
370 }
371 
372 contract SSPRegistrar is SSPTypeAware, SecurityDepositAware{
373     SSPRegistry public sspRegistry;
374 
375     event SSPRegistered(address sspAddress);
376     event SSPUnregistered(address sspAddress);
377     event SSPParametersChanged(address sspAddress);
378 
379     //@dev Retrieve information about registered SSP
380     //@return Address of registered SSP and time when registered
381     function findSsp(address sspAddr) constant returns(address sspAddress, SSPType sspType, uint16 publisherFee, uint256[2] karma, address recordOwner) {
382         return sspRegistry.getSSP(sspAddr);
383     }
384 
385     //@dev Register organisation as SSP
386     //@param sspAddress address of wallet to register
387     function registerSsp(address sspAddress, SSPType sspType, uint16 publisherFee) {
388         receiveSecurityDeposit(sspAddress);
389         sspRegistry.register(sspAddress, sspType, publisherFee, msg.sender);
390         SSPRegistered(sspAddress);
391     }
392 
393     //@dev check if SSP registered
394     function isSspRegistered(address key) constant returns(bool) {
395         return sspRegistry.isRegistered(key);
396     }
397 
398     //@dev Unregister SSP and return unused deposit
399     //@param Address of SSP to be unregistered
400     function unregisterSsp(address sspAddress) {
401         returnDeposit(sspAddress, securityDepositRegistry);
402         sspRegistry.unregister(sspAddress, msg.sender);
403         SSPUnregistered(sspAddress);
404     }
405 
406     //@dev Change publisher fee of SSP
407     //@param address of SSP to change
408     //@param new publisher fee
409     function updatePublisherFee(address key, uint16 newFee) {
410         sspRegistry.updatePublisherFee(key, newFee, msg.sender);
411         SSPParametersChanged(key);
412     }
413 
414     //@dev transfer ownership of this SSP record
415     //@param address of SSP
416     //@param address of new owner
417     function transferSSPRecord(address key, address newOwner) {
418         sspRegistry.transfer(key, newOwner, msg.sender);
419     }
420 }
421 
422 contract ChannelApi {
423     function applyRuntimeUpdate(address from, address to, uint impressionsCount, uint fraudCount);
424 
425     function applyAuditorsCheckUpdate(address from, address to, uint fraudCountDelta);
426 }
427 
428 contract RegistryProvider {
429     function replaceSSPRegistry(SSPRegistry newRegistry);
430 
431     function replaceDSPRegistry(DSPRegistry newRegistry);
432 
433     function replacePublisherRegistry(PublisherRegistry newRegistry) ;
434 
435     function replaceAuditorRegistry(AuditorRegistry newRegistry);
436 
437     function replaceSecurityDepositRegistry(DepositRegistry newRegistry);
438 
439     function getSSPRegistry() internal constant returns (SSPRegistry);
440 
441     function getDSPRegistry() internal constant returns (DSPRegistry);
442 
443     function getPublisherRegistry() internal constant returns (PublisherRegistry);
444 
445     function getAuditorRegistry() internal constant returns (AuditorRegistry);
446 
447     function getSecurityDepositRegistry() internal constant returns (DepositRegistry);
448 }
449 
450 contract StateChannelListener is RegistryProvider, ChannelApi {
451     address channelContractAddress;
452 
453     event ChannelContractAddressChanged(address indexed previousAddress, address indexed newAddress);
454 
455     function applyRuntimeUpdate(address from, address to, uint impressionsCount, uint fraudCount) onlyChannelContract {
456         uint256[2] storage karmaDiff;
457         karmaDiff[0] = impressionsCount;
458         karmaDiff[1] = 0;
459         if (getDSPRegistry().isRegistered(from)) {
460             getDSPRegistry().applyKarmaDiff(from, karmaDiff);
461         } else if (getSSPRegistry().isRegistered(from)) {
462             getSSPRegistry().applyKarmaDiff(from, karmaDiff);
463         }
464 
465         karmaDiff[1] = fraudCount;
466         if (getSSPRegistry().isRegistered(to)) {
467             karmaDiff[0] = 0;
468             getSSPRegistry().applyKarmaDiff(to, karmaDiff);
469         } else if (getPublisherRegistry().isRegistered(to)) {
470             karmaDiff[0] = impressionsCount;
471             getPublisherRegistry().applyKarmaDiff(to, karmaDiff);
472         }
473     }
474 
475     function applyAuditorsCheckUpdate(address from, address to, uint fraudCountDelta) onlyChannelContract {
476         //To be implemented
477     }
478 
479     modifier onlyChannelContract() {
480         require(msg.sender == channelContractAddress);
481         _;
482     }
483 }
484 
485 contract PapyrusDAO is WithToken,
486                        RegistryProvider,
487                        StateChannelListener,
488                        SSPRegistrar,
489                        DSPRegistrar,
490                        PublisherRegistrar,
491                        AuditorRegistrar,
492                        Ownable {
493 
494     function PapyrusDAO(ERC20 papyrusToken,
495                         SSPRegistry _sspRegistry,
496                         DSPRegistry _dspRegistry,
497                         PublisherRegistry _publisherRegistry,
498                         AuditorRegistry _auditorRegistry,
499                         DepositRegistry _securityDepositRegistry
500     ) {
501         token = papyrusToken;
502         sspRegistry = _sspRegistry;
503         dspRegistry = _dspRegistry;
504         publisherRegistry = _publisherRegistry;
505         auditorRegistry = _auditorRegistry;
506         securityDepositRegistry = _securityDepositRegistry;
507     }
508 
509     event DepositsTransferred(address newDao, uint256 sum);
510     event SSPRegistryReplaced(address from, address to);
511     event DSPRegistryReplaced(address from, address to);
512     event PublisherRegistryReplaced(address from, address to);
513     event AuditorRegistryReplaced(address from, address to);
514     event SecurityDepositRegistryReplaced(address from, address to);
515 
516     function replaceSSPRegistry(SSPRegistry newRegistry) onlyOwner {
517         address old = sspRegistry;
518         sspRegistry = newRegistry;
519         SSPRegistryReplaced(old, newRegistry);
520     }
521 
522     function replaceDSPRegistry(DSPRegistry newRegistry) onlyOwner {
523         address old = dspRegistry;
524         dspRegistry = newRegistry;
525         DSPRegistryReplaced(old, newRegistry);
526     }
527 
528     function replacePublisherRegistry(PublisherRegistry newRegistry) onlyOwner {
529         address old = publisherRegistry;
530         publisherRegistry = newRegistry;
531         PublisherRegistryReplaced(old, publisherRegistry);
532     }
533 
534     function replaceAuditorRegistry(AuditorRegistry newRegistry) onlyOwner {
535         address old = auditorRegistry;
536         auditorRegistry = newRegistry;
537         AuditorRegistryReplaced(old, auditorRegistry);
538     }
539 
540     function replaceSecurityDepositRegistry(DepositRegistry newRegistry) onlyOwner {
541         address old = securityDepositRegistry;
542         securityDepositRegistry = newRegistry;
543         SecurityDepositRegistryReplaced(old, securityDepositRegistry);
544     }
545 
546     function replaceChannelContractAddress(address newChannelContract) onlyOwner public {
547         require(newChannelContract != address(0));
548         ChannelContractAddressChanged(channelContractAddress, newChannelContract);
549         channelContractAddress = newChannelContract;
550     }
551 
552     function getSSPRegistry() internal constant returns (SSPRegistry) {
553         return sspRegistry;
554     }
555 
556     function getDSPRegistry() internal constant returns (DSPRegistry) {
557         return dspRegistry;
558     }
559 
560     function getPublisherRegistry() internal constant returns (PublisherRegistry) {
561         return publisherRegistry;
562     }
563 
564     function getAuditorRegistry() internal constant returns (AuditorRegistry) {
565         return auditorRegistry;
566     }
567 
568     function getSecurityDepositRegistry() internal constant returns (DepositRegistry) {
569         return securityDepositRegistry;
570     }
571 
572     function transferDepositsToNewDao(address newDao) onlyOwner {
573         uint256 depositSum = token.balanceOf(this);
574         token.transfer(newDao, depositSum);
575         DepositsTransferred(newDao, depositSum);
576     }
577 
578     function kill() onlyOwner {
579         selfdestruct(owner);
580     }
581 }