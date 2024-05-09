1 pragma solidity ^0.4.18;
2 
3 // File: contracts/libraries/PermissionsLib.sol
4 
5 /*
6 
7   Copyright 2017 Dharma Labs Inc.
8 
9   Licensed under the Apache License, Version 2.0 (the "License");
10   you may not use this file except in compliance with the License.
11   You may obtain a copy of the License at
12 
13     http://www.apache.org/licenses/LICENSE-2.0
14 
15   Unless required by applicable law or agreed to in writing, software
16   distributed under the License is distributed on an "AS IS" BASIS,
17   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
18   See the License for the specific language governing permissions and
19   limitations under the License.
20 
21 */
22 
23 
24 
25 
26 /**
27  *  Note(kayvon): these events are emitted by our PermissionsLib, but all contracts that
28  *  depend on the library must also define the events in order for web3 clients to pick them up.
29  *  This topic is discussed in greater detail here (under the section "Events and Libraries"):
30  *  https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736
31  */
32 contract PermissionEvents {
33     event Authorized(address indexed agent, string callingContext);
34     event AuthorizationRevoked(address indexed agent, string callingContext);
35 }
36 
37 
38 library PermissionsLib {
39 
40     // TODO(kayvon): remove these events and inherit from PermissionEvents when libraries are
41     // capable of inheritance.
42     // See relevant github issue here: https://github.com/ethereum/solidity/issues/891
43     event Authorized(address indexed agent, string callingContext);
44     event AuthorizationRevoked(address indexed agent, string callingContext);
45 
46     struct Permissions {
47         mapping (address => bool) authorized;
48         mapping (address => uint) agentToIndex; // ensures O(1) look-up
49         address[] authorizedAgents;
50     }
51 
52     function authorize(
53         Permissions storage self,
54         address agent,
55         string callingContext
56     )
57         internal
58     {
59         require(isNotAuthorized(self, agent));
60 
61         self.authorized[agent] = true;
62         self.authorizedAgents.push(agent);
63         self.agentToIndex[agent] = self.authorizedAgents.length - 1;
64         Authorized(agent, callingContext);
65     }
66 
67     function revokeAuthorization(
68         Permissions storage self,
69         address agent,
70         string callingContext
71     )
72         internal
73     {
74         /* We only want to do work in the case where the agent whose
75         authorization is being revoked had authorization permissions in the
76         first place. */
77         require(isAuthorized(self, agent));
78 
79         uint indexOfAgentToRevoke = self.agentToIndex[agent];
80         uint indexOfAgentToMove = self.authorizedAgents.length - 1;
81         address agentToMove = self.authorizedAgents[indexOfAgentToMove];
82 
83         // Revoke the agent's authorization.
84         delete self.authorized[agent];
85 
86         // Remove the agent from our collection of authorized agents.
87         self.authorizedAgents[indexOfAgentToRevoke] = agentToMove;
88 
89         // Update our indices to reflect the above changes.
90         self.agentToIndex[agentToMove] = indexOfAgentToRevoke;
91         delete self.agentToIndex[agent];
92 
93         // Clean up memory that's no longer being used.
94         delete self.authorizedAgents[indexOfAgentToMove];
95         self.authorizedAgents.length -= 1;
96 
97         AuthorizationRevoked(agent, callingContext);
98     }
99 
100     function isAuthorized(Permissions storage self, address agent)
101         internal
102         view
103         returns (bool)
104     {
105         return self.authorized[agent];
106     }
107 
108     function isNotAuthorized(Permissions storage self, address agent)
109         internal
110         view
111         returns (bool)
112     {
113         return !isAuthorized(self, agent);
114     }
115 
116     function getAuthorizedAgents(Permissions storage self)
117         internal
118         view
119         returns (address[])
120     {
121         return self.authorizedAgents;
122     }
123 }
124 
125 // File: zeppelin-solidity/contracts/math/SafeMath.sol
126 
127 /**
128  * @title SafeMath
129  * @dev Math operations with safety checks that throw on error
130  */
131 library SafeMath {
132 
133   /**
134   * @dev Multiplies two numbers, throws on overflow.
135   */
136   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137     if (a == 0) {
138       return 0;
139     }
140     uint256 c = a * b;
141     assert(c / a == b);
142     return c;
143   }
144 
145   /**
146   * @dev Integer division of two numbers, truncating the quotient.
147   */
148   function div(uint256 a, uint256 b) internal pure returns (uint256) {
149     // assert(b > 0); // Solidity automatically throws when dividing by 0
150     uint256 c = a / b;
151     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return c;
153   }
154 
155   /**
156   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
157   */
158   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159     assert(b <= a);
160     return a - b;
161   }
162 
163   /**
164   * @dev Adds two numbers, throws on overflow.
165   */
166   function add(uint256 a, uint256 b) internal pure returns (uint256) {
167     uint256 c = a + b;
168     assert(c >= a);
169     return c;
170   }
171 }
172 
173 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
174 
175 /**
176  * @title Ownable
177  * @dev The Ownable contract has an owner address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Ownable {
181   address public owner;
182 
183 
184   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
185 
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() public {
192     owner = msg.sender;
193   }
194 
195   /**
196    * @dev Throws if called by any account other than the owner.
197    */
198   modifier onlyOwner() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) public onlyOwner {
208     require(newOwner != address(0));
209     OwnershipTransferred(owner, newOwner);
210     owner = newOwner;
211   }
212 
213 }
214 
215 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
216 
217 /**
218  * @title Pausable
219  * @dev Base contract which allows children to implement an emergency stop mechanism.
220  */
221 contract Pausable is Ownable {
222   event Pause();
223   event Unpause();
224 
225   bool public paused = false;
226 
227 
228   /**
229    * @dev Modifier to make a function callable only when the contract is not paused.
230    */
231   modifier whenNotPaused() {
232     require(!paused);
233     _;
234   }
235 
236   /**
237    * @dev Modifier to make a function callable only when the contract is paused.
238    */
239   modifier whenPaused() {
240     require(paused);
241     _;
242   }
243 
244   /**
245    * @dev called by the owner to pause, triggers stopped state
246    */
247   function pause() onlyOwner whenNotPaused public {
248     paused = true;
249     Pause();
250   }
251 
252   /**
253    * @dev called by the owner to unpause, returns to normal state
254    */
255   function unpause() onlyOwner whenPaused public {
256     paused = false;
257     Unpause();
258   }
259 }
260 
261 // File: contracts/DebtRegistry.sol
262 
263 /*
264 
265   Copyright 2017 Dharma Labs Inc.
266 
267   Licensed under the Apache License, Version 2.0 (the "License");
268   you may not use this file except in compliance with the License.
269   You may obtain a copy of the License at
270 
271     http://www.apache.org/licenses/LICENSE-2.0
272 
273   Unless required by applicable law or agreed to in writing, software
274   distributed under the License is distributed on an "AS IS" BASIS,
275   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
276   See the License for the specific language governing permissions and
277   limitations under the License.
278 
279 */
280 
281 
282 
283 
284 
285 
286 
287 /**
288  * The DebtRegistry stores the parameters and beneficiaries of all debt agreements in
289  * Dharma protocol.  It authorizes a limited number of agents to
290  * perform mutations on it -- those agents can be changed at any
291  * time by the contract's owner.
292  *
293  * Author: Nadav Hollander -- Github: nadavhollander
294  */
295 contract DebtRegistry is Pausable, PermissionEvents {
296     using SafeMath for uint;
297     using PermissionsLib for PermissionsLib.Permissions;
298 
299     struct Entry {
300         address version;
301         address beneficiary;
302         address underwriter;
303         uint underwriterRiskRating;
304         address termsContract;
305         bytes32 termsContractParameters;
306         uint issuanceBlockTimestamp;
307     }
308 
309     // Primary registry mapping agreement IDs to their corresponding entries
310     mapping (bytes32 => Entry) internal registry;
311 
312     // Maps debtor addresses to a list of their debts' agreement IDs
313     mapping (address => bytes32[]) internal debtorToDebts;
314 
315     PermissionsLib.Permissions internal entryInsertPermissions;
316     PermissionsLib.Permissions internal entryEditPermissions;
317 
318     string public constant INSERT_CONTEXT = "debt-registry-insert";
319     string public constant EDIT_CONTEXT = "debt-registry-edit";
320 
321     event LogInsertEntry(
322         bytes32 indexed agreementId,
323         address indexed beneficiary,
324         address indexed underwriter,
325         uint underwriterRiskRating,
326         address termsContract,
327         bytes32 termsContractParameters
328     );
329 
330     event LogModifyEntryBeneficiary(
331         bytes32 indexed agreementId,
332         address indexed previousBeneficiary,
333         address indexed newBeneficiary
334     );
335 
336     modifier onlyAuthorizedToInsert() {
337         require(entryInsertPermissions.isAuthorized(msg.sender));
338         _;
339     }
340 
341     modifier onlyAuthorizedToEdit() {
342         require(entryEditPermissions.isAuthorized(msg.sender));
343         _;
344     }
345 
346     modifier onlyExtantEntry(bytes32 agreementId) {
347         require(doesEntryExist(agreementId));
348         _;
349     }
350 
351     modifier nonNullBeneficiary(address beneficiary) {
352         require(beneficiary != address(0));
353         _;
354     }
355 
356     /* Ensures an entry with the specified agreement ID exists within the debt registry. */
357     function doesEntryExist(bytes32 agreementId)
358         public
359         view
360         returns (bool exists)
361     {
362         return registry[agreementId].beneficiary != address(0);
363     }
364 
365     /**
366      * Inserts a new entry into the registry, if the entry is valid and sender is
367      * authorized to make 'insert' mutations to the registry.
368      */
369     function insert(
370         address _version,
371         address _beneficiary,
372         address _debtor,
373         address _underwriter,
374         uint _underwriterRiskRating,
375         address _termsContract,
376         bytes32 _termsContractParameters,
377         uint _salt
378     )
379         public
380         onlyAuthorizedToInsert
381         whenNotPaused
382         nonNullBeneficiary(_beneficiary)
383         returns (bytes32 _agreementId)
384     {
385         Entry memory entry = Entry(
386             _version,
387             _beneficiary,
388             _underwriter,
389             _underwriterRiskRating,
390             _termsContract,
391             _termsContractParameters,
392             block.timestamp
393         );
394 
395         bytes32 agreementId = _getAgreementId(entry, _debtor, _salt);
396 
397         require(registry[agreementId].beneficiary == address(0));
398 
399         registry[agreementId] = entry;
400         debtorToDebts[_debtor].push(agreementId);
401 
402         LogInsertEntry(
403             agreementId,
404             entry.beneficiary,
405             entry.underwriter,
406             entry.underwriterRiskRating,
407             entry.termsContract,
408             entry.termsContractParameters
409         );
410 
411         return agreementId;
412     }
413 
414     /**
415      * Modifies the beneficiary of a debt issuance, if the sender
416      * is authorized to make 'modifyBeneficiary' mutations to
417      * the registry.
418      */
419     function modifyBeneficiary(bytes32 agreementId, address newBeneficiary)
420         public
421         onlyAuthorizedToEdit
422         whenNotPaused
423         onlyExtantEntry(agreementId)
424         nonNullBeneficiary(newBeneficiary)
425     {
426         address previousBeneficiary = registry[agreementId].beneficiary;
427 
428         registry[agreementId].beneficiary = newBeneficiary;
429 
430         LogModifyEntryBeneficiary(
431             agreementId,
432             previousBeneficiary,
433             newBeneficiary
434         );
435     }
436 
437     /**
438      * Adds an address to the list of agents authorized
439      * to make 'insert' mutations to the registry.
440      */
441     function addAuthorizedInsertAgent(address agent)
442         public
443         onlyOwner
444     {
445         entryInsertPermissions.authorize(agent, INSERT_CONTEXT);
446     }
447 
448     /**
449      * Adds an address to the list of agents authorized
450      * to make 'modifyBeneficiary' mutations to the registry.
451      */
452     function addAuthorizedEditAgent(address agent)
453         public
454         onlyOwner
455     {
456         entryEditPermissions.authorize(agent, EDIT_CONTEXT);
457     }
458 
459     /**
460      * Removes an address from the list of agents authorized
461      * to make 'insert' mutations to the registry.
462      */
463     function revokeInsertAgentAuthorization(address agent)
464         public
465         onlyOwner
466     {
467         entryInsertPermissions.revokeAuthorization(agent, INSERT_CONTEXT);
468     }
469 
470     /**
471      * Removes an address from the list of agents authorized
472      * to make 'modifyBeneficiary' mutations to the registry.
473      */
474     function revokeEditAgentAuthorization(address agent)
475         public
476         onlyOwner
477     {
478         entryEditPermissions.revokeAuthorization(agent, EDIT_CONTEXT);
479     }
480 
481     /**
482      * Returns the parameters of a debt issuance in the registry.
483      *
484      * TODO(kayvon): protect this function with our `onlyExtantEntry` modifier once the restriction
485      * on the size of the call stack has been addressed.
486      */
487     function get(bytes32 agreementId)
488         public
489         view
490         returns(address, address, address, uint, address, bytes32, uint)
491     {
492         return (
493             registry[agreementId].version,
494             registry[agreementId].beneficiary,
495             registry[agreementId].underwriter,
496             registry[agreementId].underwriterRiskRating,
497             registry[agreementId].termsContract,
498             registry[agreementId].termsContractParameters,
499             registry[agreementId].issuanceBlockTimestamp
500         );
501     }
502 
503     /**
504      * Returns the beneficiary of a given issuance
505      */
506     function getBeneficiary(bytes32 agreementId)
507         public
508         view
509         onlyExtantEntry(agreementId)
510         returns(address)
511     {
512         return registry[agreementId].beneficiary;
513     }
514 
515     /**
516      * Returns the terms contract address of a given issuance
517      */
518     function getTermsContract(bytes32 agreementId)
519         public
520         view
521         onlyExtantEntry(agreementId)
522         returns (address)
523     {
524         return registry[agreementId].termsContract;
525     }
526 
527     /**
528      * Returns the terms contract parameters of a given issuance
529      */
530     function getTermsContractParameters(bytes32 agreementId)
531         public
532         view
533         onlyExtantEntry(agreementId)
534         returns (bytes32)
535     {
536         return registry[agreementId].termsContractParameters;
537     }
538 
539     /**
540      * Returns a tuple of the terms contract and its associated parameters
541      * for a given issuance
542      */
543     function getTerms(bytes32 agreementId)
544         public
545         view
546         onlyExtantEntry(agreementId)
547         returns(address, bytes32)
548     {
549         return (
550             registry[agreementId].termsContract,
551             registry[agreementId].termsContractParameters
552         );
553     }
554 
555     /**
556      * Returns the timestamp of the block at which a debt agreement was issued.
557      */
558     function getIssuanceBlockTimestamp(bytes32 agreementId)
559         public
560         view
561         onlyExtantEntry(agreementId)
562         returns (uint timestamp)
563     {
564         return registry[agreementId].issuanceBlockTimestamp;
565     }
566 
567     /**
568      * Returns the list of agents authorized to make 'insert' mutations
569      */
570     function getAuthorizedInsertAgents()
571         public
572         view
573         returns(address[])
574     {
575         return entryInsertPermissions.getAuthorizedAgents();
576     }
577 
578     /**
579      * Returns the list of agents authorized to make 'modifyBeneficiary' mutations
580      */
581     function getAuthorizedEditAgents()
582         public
583         view
584         returns(address[])
585     {
586         return entryEditPermissions.getAuthorizedAgents();
587     }
588 
589     /**
590      * Returns the list of debt agreements a debtor is party to,
591      * with each debt agreement listed by agreement ID.
592      */
593     function getDebtorsDebts(address debtor)
594         public
595         view
596         returns(bytes32[])
597     {
598         return debtorToDebts[debtor];
599     }
600 
601     /**
602      * Helper function for computing the hash of a given issuance,
603      * and, in turn, its agreementId
604      */
605     function _getAgreementId(Entry _entry, address _debtor, uint _salt)
606         internal
607         pure
608         returns(bytes32)
609     {
610         return keccak256(
611             _entry.version,
612             _debtor,
613             _entry.underwriter,
614             _entry.underwriterRiskRating,
615             _entry.termsContract,
616             _entry.termsContractParameters,
617             _salt
618         );
619     }
620 }