1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: SystemStatus.sol
9 *
10 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/SystemStatus.sol
11 * Docs: https://docs.synthetix.io/contracts/SystemStatus
12 *
13 * Contract Dependencies: 
14 *	- ISystemStatus
15 *	- Owned
16 * Libraries: (none)
17 *
18 * MIT License
19 * ===========
20 *
21 * Copyright (c) 2021 Synthetix
22 *
23 * Permission is hereby granted, free of charge, to any person obtaining a copy
24 * of this software and associated documentation files (the "Software"), to deal
25 * in the Software without restriction, including without limitation the rights
26 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
27 * copies of the Software, and to permit persons to whom the Software is
28 * furnished to do so, subject to the following conditions:
29 *
30 * The above copyright notice and this permission notice shall be included in all
31 * copies or substantial portions of the Software.
32 *
33 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
34 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
35 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
36 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
37 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
38 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
39 */
40 
41 
42 
43 pragma solidity ^0.5.16;
44 
45 
46 // https://docs.synthetix.io/contracts/source/contracts/owned
47 contract Owned {
48     address public owner;
49     address public nominatedOwner;
50 
51     constructor(address _owner) public {
52         require(_owner != address(0), "Owner address cannot be 0");
53         owner = _owner;
54         emit OwnerChanged(address(0), _owner);
55     }
56 
57     function nominateNewOwner(address _owner) external onlyOwner {
58         nominatedOwner = _owner;
59         emit OwnerNominated(_owner);
60     }
61 
62     function acceptOwnership() external {
63         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
64         emit OwnerChanged(owner, nominatedOwner);
65         owner = nominatedOwner;
66         nominatedOwner = address(0);
67     }
68 
69     modifier onlyOwner {
70         _onlyOwner();
71         _;
72     }
73 
74     function _onlyOwner() private view {
75         require(msg.sender == owner, "Only the contract owner may perform this action");
76     }
77 
78     event OwnerNominated(address newOwner);
79     event OwnerChanged(address oldOwner, address newOwner);
80 }
81 
82 
83 // https://docs.synthetix.io/contracts/source/interfaces/isystemstatus
84 interface ISystemStatus {
85     struct Status {
86         bool canSuspend;
87         bool canResume;
88     }
89 
90     struct Suspension {
91         bool suspended;
92         // reason is an integer code,
93         // 0 => no reason, 1 => upgrading, 2+ => defined by system usage
94         uint248 reason;
95     }
96 
97     // Views
98     function accessControl(bytes32 section, address account) external view returns (bool canSuspend, bool canResume);
99 
100     function requireSystemActive() external view;
101 
102     function requireIssuanceActive() external view;
103 
104     function requireExchangeActive() external view;
105 
106     function requireExchangeBetweenSynthsAllowed(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
107 
108     function requireSynthActive(bytes32 currencyKey) external view;
109 
110     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view;
111 
112     function systemSuspension() external view returns (bool suspended, uint248 reason);
113 
114     function issuanceSuspension() external view returns (bool suspended, uint248 reason);
115 
116     function exchangeSuspension() external view returns (bool suspended, uint248 reason);
117 
118     function synthExchangeSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
119 
120     function synthSuspension(bytes32 currencyKey) external view returns (bool suspended, uint248 reason);
121 
122     function getSynthExchangeSuspensions(bytes32[] calldata synths)
123         external
124         view
125         returns (bool[] memory exchangeSuspensions, uint256[] memory reasons);
126 
127     function getSynthSuspensions(bytes32[] calldata synths)
128         external
129         view
130         returns (bool[] memory suspensions, uint256[] memory reasons);
131 
132     // Restricted functions
133     function suspendSynth(bytes32 currencyKey, uint256 reason) external;
134 
135     function updateAccessControl(
136         bytes32 section,
137         address account,
138         bool canSuspend,
139         bool canResume
140     ) external;
141 }
142 
143 
144 // Inheritance
145 
146 
147 // https://docs.synthetix.io/contracts/source/contracts/systemstatus
148 contract SystemStatus is Owned, ISystemStatus {
149     mapping(bytes32 => mapping(address => Status)) public accessControl;
150 
151     uint248 public constant SUSPENSION_REASON_UPGRADE = 1;
152 
153     bytes32 public constant SECTION_SYSTEM = "System";
154     bytes32 public constant SECTION_ISSUANCE = "Issuance";
155     bytes32 public constant SECTION_EXCHANGE = "Exchange";
156     bytes32 public constant SECTION_SYNTH_EXCHANGE = "SynthExchange";
157     bytes32 public constant SECTION_SYNTH = "Synth";
158 
159     Suspension public systemSuspension;
160 
161     Suspension public issuanceSuspension;
162 
163     Suspension public exchangeSuspension;
164 
165     mapping(bytes32 => Suspension) public synthExchangeSuspension;
166 
167     mapping(bytes32 => Suspension) public synthSuspension;
168 
169     constructor(address _owner) public Owned(_owner) {}
170 
171     /* ========== VIEWS ========== */
172     function requireSystemActive() external view {
173         _internalRequireSystemActive();
174     }
175 
176     function requireIssuanceActive() external view {
177         // Issuance requires the system be active
178         _internalRequireSystemActive();
179 
180         // and issuance itself of course
181         _internalRequireIssuanceActive();
182     }
183 
184     function requireExchangeActive() external view {
185         // Exchanging requires the system be active
186         _internalRequireSystemActive();
187 
188         // and exchanging itself of course
189         _internalRequireExchangeActive();
190     }
191 
192     function requireSynthExchangeActive(bytes32 currencyKey) external view {
193         // Synth exchange and transfer requires the system be active
194         _internalRequireSystemActive();
195         _internalRequireSynthExchangeActive(currencyKey);
196     }
197 
198     function requireSynthActive(bytes32 currencyKey) external view {
199         // Synth exchange and transfer requires the system be active
200         _internalRequireSystemActive();
201         _internalRequireSynthActive(currencyKey);
202     }
203 
204     function requireSynthsActive(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view {
205         // Synth exchange and transfer requires the system be active
206         _internalRequireSystemActive();
207         _internalRequireSynthActive(sourceCurrencyKey);
208         _internalRequireSynthActive(destinationCurrencyKey);
209     }
210 
211     function requireExchangeBetweenSynthsAllowed(bytes32 sourceCurrencyKey, bytes32 destinationCurrencyKey) external view {
212         // Synth exchange and transfer requires the system be active
213         _internalRequireSystemActive();
214 
215         // and exchanging must be active
216         _internalRequireExchangeActive();
217 
218         // and the synth exchanging between the synths must be active
219         _internalRequireSynthExchangeActive(sourceCurrencyKey);
220         _internalRequireSynthExchangeActive(destinationCurrencyKey);
221 
222         // and finally, the synths cannot be suspended
223         _internalRequireSynthActive(sourceCurrencyKey);
224         _internalRequireSynthActive(destinationCurrencyKey);
225     }
226 
227     function isSystemUpgrading() external view returns (bool) {
228         return systemSuspension.suspended && systemSuspension.reason == SUSPENSION_REASON_UPGRADE;
229     }
230 
231     function getSynthExchangeSuspensions(bytes32[] calldata synths)
232         external
233         view
234         returns (bool[] memory exchangeSuspensions, uint256[] memory reasons)
235     {
236         exchangeSuspensions = new bool[](synths.length);
237         reasons = new uint256[](synths.length);
238 
239         for (uint i = 0; i < synths.length; i++) {
240             exchangeSuspensions[i] = synthExchangeSuspension[synths[i]].suspended;
241             reasons[i] = synthExchangeSuspension[synths[i]].reason;
242         }
243     }
244 
245     function getSynthSuspensions(bytes32[] calldata synths)
246         external
247         view
248         returns (bool[] memory suspensions, uint256[] memory reasons)
249     {
250         suspensions = new bool[](synths.length);
251         reasons = new uint256[](synths.length);
252 
253         for (uint i = 0; i < synths.length; i++) {
254             suspensions[i] = synthSuspension[synths[i]].suspended;
255             reasons[i] = synthSuspension[synths[i]].reason;
256         }
257     }
258 
259     /* ========== MUTATIVE FUNCTIONS ========== */
260     function updateAccessControl(
261         bytes32 section,
262         address account,
263         bool canSuspend,
264         bool canResume
265     ) external onlyOwner {
266         _internalUpdateAccessControl(section, account, canSuspend, canResume);
267     }
268 
269     function updateAccessControls(
270         bytes32[] calldata sections,
271         address[] calldata accounts,
272         bool[] calldata canSuspends,
273         bool[] calldata canResumes
274     ) external onlyOwner {
275         require(
276             sections.length == accounts.length &&
277                 accounts.length == canSuspends.length &&
278                 canSuspends.length == canResumes.length,
279             "Input array lengths must match"
280         );
281         for (uint i = 0; i < sections.length; i++) {
282             _internalUpdateAccessControl(sections[i], accounts[i], canSuspends[i], canResumes[i]);
283         }
284     }
285 
286     function suspendSystem(uint256 reason) external {
287         _requireAccessToSuspend(SECTION_SYSTEM);
288         systemSuspension.suspended = true;
289         systemSuspension.reason = uint248(reason);
290         emit SystemSuspended(systemSuspension.reason);
291     }
292 
293     function resumeSystem() external {
294         _requireAccessToResume(SECTION_SYSTEM);
295         systemSuspension.suspended = false;
296         emit SystemResumed(uint256(systemSuspension.reason));
297         systemSuspension.reason = 0;
298     }
299 
300     function suspendIssuance(uint256 reason) external {
301         _requireAccessToSuspend(SECTION_ISSUANCE);
302         issuanceSuspension.suspended = true;
303         issuanceSuspension.reason = uint248(reason);
304         emit IssuanceSuspended(reason);
305     }
306 
307     function resumeIssuance() external {
308         _requireAccessToResume(SECTION_ISSUANCE);
309         issuanceSuspension.suspended = false;
310         emit IssuanceResumed(uint256(issuanceSuspension.reason));
311         issuanceSuspension.reason = 0;
312     }
313 
314     function suspendExchange(uint256 reason) external {
315         _requireAccessToSuspend(SECTION_EXCHANGE);
316         exchangeSuspension.suspended = true;
317         exchangeSuspension.reason = uint248(reason);
318         emit ExchangeSuspended(reason);
319     }
320 
321     function resumeExchange() external {
322         _requireAccessToResume(SECTION_EXCHANGE);
323         exchangeSuspension.suspended = false;
324         emit ExchangeResumed(uint256(exchangeSuspension.reason));
325         exchangeSuspension.reason = 0;
326     }
327 
328     function suspendSynthExchange(bytes32 currencyKey, uint256 reason) external {
329         bytes32[] memory currencyKeys = new bytes32[](1);
330         currencyKeys[0] = currencyKey;
331         _internalSuspendSynthExchange(currencyKeys, reason);
332     }
333 
334     function suspendSynthsExchange(bytes32[] calldata currencyKeys, uint256 reason) external {
335         _internalSuspendSynthExchange(currencyKeys, reason);
336     }
337 
338     function resumeSynthExchange(bytes32 currencyKey) external {
339         bytes32[] memory currencyKeys = new bytes32[](1);
340         currencyKeys[0] = currencyKey;
341         _internalResumeSynthsExchange(currencyKeys);
342     }
343 
344     function resumeSynthsExchange(bytes32[] calldata currencyKeys) external {
345         _internalResumeSynthsExchange(currencyKeys);
346     }
347 
348     function suspendSynth(bytes32 currencyKey, uint256 reason) external {
349         bytes32[] memory currencyKeys = new bytes32[](1);
350         currencyKeys[0] = currencyKey;
351         _internalSuspendSynths(currencyKeys, reason);
352     }
353 
354     function suspendSynths(bytes32[] calldata currencyKeys, uint256 reason) external {
355         _internalSuspendSynths(currencyKeys, reason);
356     }
357 
358     function resumeSynth(bytes32 currencyKey) external {
359         bytes32[] memory currencyKeys = new bytes32[](1);
360         currencyKeys[0] = currencyKey;
361         _internalResumeSynths(currencyKeys);
362     }
363 
364     function resumeSynths(bytes32[] calldata currencyKeys) external {
365         _internalResumeSynths(currencyKeys);
366     }
367 
368     /* ========== INTERNAL FUNCTIONS ========== */
369 
370     function _requireAccessToSuspend(bytes32 section) internal view {
371         require(accessControl[section][msg.sender].canSuspend, "Restricted to access control list");
372     }
373 
374     function _requireAccessToResume(bytes32 section) internal view {
375         require(accessControl[section][msg.sender].canResume, "Restricted to access control list");
376     }
377 
378     function _internalRequireSystemActive() internal view {
379         require(
380             !systemSuspension.suspended,
381             systemSuspension.reason == SUSPENSION_REASON_UPGRADE
382                 ? "Synthetix is suspended, upgrade in progress... please stand by"
383                 : "Synthetix is suspended. Operation prohibited"
384         );
385     }
386 
387     function _internalRequireIssuanceActive() internal view {
388         require(!issuanceSuspension.suspended, "Issuance is suspended. Operation prohibited");
389     }
390 
391     function _internalRequireExchangeActive() internal view {
392         require(!exchangeSuspension.suspended, "Exchange is suspended. Operation prohibited");
393     }
394 
395     function _internalRequireSynthExchangeActive(bytes32 currencyKey) internal view {
396         require(!synthExchangeSuspension[currencyKey].suspended, "Synth exchange suspended. Operation prohibited");
397     }
398 
399     function _internalRequireSynthActive(bytes32 currencyKey) internal view {
400         require(!synthSuspension[currencyKey].suspended, "Synth is suspended. Operation prohibited");
401     }
402 
403     function _internalSuspendSynths(bytes32[] memory currencyKeys, uint256 reason) internal {
404         _requireAccessToSuspend(SECTION_SYNTH);
405         for (uint i = 0; i < currencyKeys.length; i++) {
406             bytes32 currencyKey = currencyKeys[i];
407             synthSuspension[currencyKey].suspended = true;
408             synthSuspension[currencyKey].reason = uint248(reason);
409             emit SynthSuspended(currencyKey, reason);
410         }
411     }
412 
413     function _internalResumeSynths(bytes32[] memory currencyKeys) internal {
414         _requireAccessToResume(SECTION_SYNTH);
415         for (uint i = 0; i < currencyKeys.length; i++) {
416             bytes32 currencyKey = currencyKeys[i];
417             emit SynthResumed(currencyKey, uint256(synthSuspension[currencyKey].reason));
418             delete synthSuspension[currencyKey];
419         }
420     }
421 
422     function _internalSuspendSynthExchange(bytes32[] memory currencyKeys, uint256 reason) internal {
423         _requireAccessToSuspend(SECTION_SYNTH_EXCHANGE);
424         for (uint i = 0; i < currencyKeys.length; i++) {
425             bytes32 currencyKey = currencyKeys[i];
426             synthExchangeSuspension[currencyKey].suspended = true;
427             synthExchangeSuspension[currencyKey].reason = uint248(reason);
428             emit SynthExchangeSuspended(currencyKey, reason);
429         }
430     }
431 
432     function _internalResumeSynthsExchange(bytes32[] memory currencyKeys) internal {
433         _requireAccessToResume(SECTION_SYNTH_EXCHANGE);
434         for (uint i = 0; i < currencyKeys.length; i++) {
435             bytes32 currencyKey = currencyKeys[i];
436             emit SynthExchangeResumed(currencyKey, uint256(synthExchangeSuspension[currencyKey].reason));
437             delete synthExchangeSuspension[currencyKey];
438         }
439     }
440 
441     function _internalUpdateAccessControl(
442         bytes32 section,
443         address account,
444         bool canSuspend,
445         bool canResume
446     ) internal {
447         require(
448             section == SECTION_SYSTEM ||
449                 section == SECTION_ISSUANCE ||
450                 section == SECTION_EXCHANGE ||
451                 section == SECTION_SYNTH_EXCHANGE ||
452                 section == SECTION_SYNTH,
453             "Invalid section supplied"
454         );
455         accessControl[section][account].canSuspend = canSuspend;
456         accessControl[section][account].canResume = canResume;
457         emit AccessControlUpdated(section, account, canSuspend, canResume);
458     }
459 
460     /* ========== EVENTS ========== */
461 
462     event SystemSuspended(uint256 reason);
463     event SystemResumed(uint256 reason);
464 
465     event IssuanceSuspended(uint256 reason);
466     event IssuanceResumed(uint256 reason);
467 
468     event ExchangeSuspended(uint256 reason);
469     event ExchangeResumed(uint256 reason);
470 
471     event SynthExchangeSuspended(bytes32 currencyKey, uint256 reason);
472     event SynthExchangeResumed(bytes32 currencyKey, uint256 reason);
473 
474     event SynthSuspended(bytes32 currencyKey, uint256 reason);
475     event SynthResumed(bytes32 currencyKey, uint256 reason);
476 
477     event AccessControlUpdated(bytes32 indexed section, address indexed account, bool canSuspend, bool canResume);
478 }
479 
480     