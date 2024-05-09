1 // File: contracts/utils/EvmUtil.sol
2 
3 pragma solidity ^0.5.13;
4 
5 library EvmUtil {
6 
7     function getChainId() internal pure returns (uint) {
8         uint256 chainId;
9         assembly { chainId := chainid() }
10         return chainId;
11     }
12 
13 }
14 
15 // File: contracts/governance/dmg/IDMGToken.sol
16 
17 /*
18  * Copyright 2020 DMM Foundation
19  *
20  * Licensed under the Apache License, Version 2.0 (the "License");
21  * you may not use this file except in compliance with the License.
22  * You may obtain a copy of the License at
23  *
24  * http://www.apache.org/licenses/LICENSE-2.0
25  *
26  * Unless required by applicable law or agreed to in writing, software
27  * distributed under the License is distributed on an "AS IS" BASIS,
28  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
29  * See the License for the specific language governing permissions and
30  * limitations under the License.
31  */
32 
33 
34 pragma solidity ^0.5.13;
35 pragma experimental ABIEncoderV2;
36 
37 interface IDMGToken {
38 
39     function getPriorVotes(address account, uint blockNumber) external view returns (uint128);
40 
41 }
42 
43 // File: contracts/governance/governors/ITimelockInterface.sol
44 
45 /*
46  * Copyright 2020 DMM Foundation
47  *
48  * Licensed under the Apache License, Version 2.0 (the "License");
49  * you may not use this file except in compliance with the License.
50  * You may obtain a copy of the License at
51  *
52  * http://www.apache.org/licenses/LICENSE-2.0
53  *
54  * Unless required by applicable law or agreed to in writing, software
55  * distributed under the License is distributed on an "AS IS" BASIS,
56  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
57  * See the License for the specific language governing permissions and
58  * limitations under the License.
59  */
60 
61 /*
62  *
63  * Copyright 2020 Compound Labs, Inc.
64  *
65  * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
66  * following conditions are met:
67  * 1.   Redistributions of source code must retain the above copyright notice, this list of conditions and the following
68  *      disclaimer.
69  * 2.   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
70  *      following disclaimer in the documentation and/or other materials provided with the distribution.
71  * 3.   Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
72  *      products derived from this software without specific prior written permission.
73  *
74  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
75  * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
76  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
77  * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
78  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
79  * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
80  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
81  */
82 
83 pragma solidity ^0.5.13;
84 
85 interface ITimelockInterface {
86 
87     function delay() external view returns (uint);
88 
89     function GRACE_PERIOD() external view returns (uint);
90 
91     function acceptAdmin() external;
92 
93     function queuedTransactions(bytes32 hash) external view returns (bool);
94 
95     function queueTransaction(
96         address target,
97         uint value,
98         string calldata signature,
99         bytes calldata data,
100         uint eta
101     ) external returns (bytes32);
102 
103     function cancelTransaction(
104         address target,
105         uint value,
106         string calldata signature,
107         bytes calldata data,
108         uint eta
109     ) external;
110 
111     function executeTransaction(
112         address target,
113         uint value,
114         string calldata signature,
115         bytes calldata data,
116         uint eta
117     ) external payable returns (bytes memory);
118 }
119 
120 // File: contracts/governance/governors/GovernorAlphaData.sol
121 
122 /*
123  * Copyright 2020 DMM Foundation
124  *
125  * Licensed under the Apache License, Version 2.0 (the "License");
126  * you may not use this file except in compliance with the License.
127  * You may obtain a copy of the License at
128  *
129  * http://www.apache.org/licenses/LICENSE-2.0
130  *
131  * Unless required by applicable law or agreed to in writing, software
132  * distributed under the License is distributed on an "AS IS" BASIS,
133  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
134  * See the License for the specific language governing permissions and
135  * limitations under the License.
136  */
137 
138 /*
139  *
140  * Copyright 2020 Compound Labs, Inc.
141  *
142  * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
143  * following conditions are met:
144  * 1.   Redistributions of source code must retain the above copyright notice, this list of conditions and the following
145  *      disclaimer.
146  * 2.   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
147  *      following disclaimer in the documentation and/or other materials provided with the distribution.
148  * 3.   Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
149  *      products derived from this software without specific prior written permission.
150  *
151  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
152  * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
153  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
154  * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
155  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
156  * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
157  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
158  */
159 
160 pragma solidity ^0.5.13;
161 
162 contract GovernorAlphaData {
163 
164     /// @notice An event emitted when a new proposal is created
165     event ProposalCreated(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string title, string description);
166 
167     /// @notice An event emitted when a vote has been cast on a proposal
168     event VoteCast(address voter, uint proposalId, bool support, uint votes);
169 
170     /// @notice An event emitted when a proposal has been canceled
171     event ProposalCanceled(uint id);
172 
173     /// @notice An event emitted when a proposal has been queued in the Timelock
174     event ProposalQueued(uint id, uint eta);
175 
176     /// @notice An event emitted when a proposal has been executed in the Timelock
177     event ProposalExecuted(uint id);
178 
179     struct Proposal {
180         /// @notice Unique id for looking up a proposal
181         uint id;
182 
183         /// @notice Creator of the proposal
184         address proposer;
185 
186         /// @notice The timestamp that the proposal will be available for execution, set once the vote succeeds
187         uint eta;
188 
189         /// @notice the ordered list of target addresses for calls to be made
190         address[] targets;
191 
192         /// @notice The ordered list of values (i.e. msg.value) to be passed to the calls to be made
193         uint[] values;
194 
195         /// @notice The ordered list of function signatures to be called
196         string[] signatures;
197 
198         /// @notice The ordered list of calldata to be passed to each call
199         bytes[] calldatas;
200 
201         /// @notice The block at which voting begins: holders must delegate their votes prior to this block
202         uint startBlock;
203 
204         /// @notice The block at which voting ends: votes must be cast prior to this block
205         uint endBlock;
206 
207         /// @notice Current number of votes in favor of this proposal
208         uint forVotes;
209 
210         /// @notice Current number of votes in opposition to this proposal
211         uint againstVotes;
212 
213         /// @notice Flag marking whether the proposal has been canceled
214         bool canceled;
215 
216         /// @notice Flag marking whether the proposal has been executed
217         bool executed;
218 
219         /// @notice Receipts of ballots for the entire set of voters
220         mapping(address => Receipt) receipts;
221     }
222 
223     /// @notice Ballot receipt record for a voter
224     struct Receipt {
225         /// @notice Whether or not a vote has been cast
226         bool hasVoted;
227 
228         /// @notice Whether or not the voter supports the proposal
229         bool support;
230 
231         /// @notice The number of votes the voter had, which were cast
232         uint128 votes;
233     }
234 
235     /// @notice Possible states that a proposal may be in
236     enum ProposalState {
237         Pending,
238         Active,
239         Canceled,
240         Defeated,
241         Succeeded,
242         Queued,
243         Expired,
244         Executed
245     }
246 
247 }
248 
249 // File: contracts/governance/governors/GovernorAlpha.sol
250 
251 /*
252  * Copyright 2020 DMM Foundation
253  *
254  * Licensed under the Apache License, Version 2.0 (the "License");
255  * you may not use this file except in compliance with the License.
256  * You may obtain a copy of the License at
257  *
258  * http://www.apache.org/licenses/LICENSE-2.0
259  *
260  * Unless required by applicable law or agreed to in writing, software
261  * distributed under the License is distributed on an "AS IS" BASIS,
262  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
263  * See the License for the specific language governing permissions and
264  * limitations under the License.
265  */
266 
267 /*
268  *
269  * Copyright 2020 Compound Labs, Inc.
270  *
271  * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
272  * following conditions are met:
273  * 1.   Redistributions of source code must retain the above copyright notice, this list of conditions and the following
274  *      disclaimer.
275  * 2.   Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the
276  *      following disclaimer in the documentation and/or other materials provided with the distribution.
277  * 3.   Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote
278  *      products derived from this software without specific prior written permission.
279  *
280  * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
281  * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
282  * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
283  * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
284  * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
285  * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
286  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
287  */
288 
289 pragma solidity ^0.5.13;
290 
291 
292 
293 
294 
295 /**
296  * This contract is mainly based on Compound's Governor Alpha contract. Attribution to Compound Labs as the original
297  * creator of the contract can be seen above.
298  *
299  * Changes made to the original contract include slight name changes, adding a `title` field to the Proposal struct,
300  * and minor data type adjustments to account for DMG using more bits for storage (128 instead of 96).
301  */
302 contract GovernorAlpha is GovernorAlphaData {
303     /// @notice The name of this contract
304     string public constant name = "DMM Governor Alpha";
305 
306     /// @notice The address of the DMM Protocol Timelock
307     ITimelockInterface public timelock;
308 
309     /// @notice The address of the DMG governance token
310     IDMGToken public dmg;
311 
312     /// @notice The address of the Governor Guardian
313     address public guardian;
314 
315     /// @notice The total number of proposals
316     uint public proposalCount;
317 
318     /// @notice The number of votes in support of a proposal required in order for a quorum to be reached and for a vote to succeed
319     uint public quorumVotes;
320 
321     /// @notice The minimum number of votes needed to create a proposal
322     uint public proposalThreshold;
323 
324     /// @notice The duration of voting on a proposal, in blocks
325     uint public votingPeriod;
326 
327     /// @notice The official record of all proposals ever proposed
328     mapping(uint => Proposal) public proposals;
329 
330     /// @notice The latest proposal for each proposer
331     mapping(address => uint) public latestProposalIds;
332 
333     /// @notice The EIP-712 typehash for the contract's domain
334     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
335 
336     /// @notice The EIP-712 typehash for the ballot struct used by the contract
337     bytes32 public constant BALLOT_TYPEHASH = keccak256("Ballot(uint256 proposalId,bool support)");
338 
339     constructor(address dmg_, address guardian_) public {
340         dmg = IDMGToken(dmg_);
341         guardian = guardian_;
342         quorumVotes = 500_000e18;
343         proposalThreshold = 100_000e18;
344 
345         // ~3 days in blocks (assuming 15s blocks)
346         votingPeriod = 17280;
347     }
348 
349     function initializeTimelock(address timelock_) public {
350         require(msg.sender == guardian, "GovernorAlpha::setTimelock: Caller must be guardian");
351         require(address(timelock) == address(0x0), "GovernorAlpha::setTimelock: timelock must not be initialized yet");
352 
353         timelock = ITimelockInterface(timelock_);
354     }
355 
356     function setQuorumVotes(uint quorumVotes_) public {
357         require(msg.sender == address(timelock), "GovernorAlpha::setQuorumVotes: invalid sender");
358         quorumVotes = quorumVotes_;
359     }
360 
361     function setProposalThreshold(uint proposalThreshold_) public {
362         require(msg.sender == address(timelock), "GovernorAlpha::setProposalThreshold: invalid sender");
363         proposalThreshold = proposalThreshold_;
364     }
365 
366     /**
367      * @return  The maximum number of actions that can be included in a proposal
368      */
369     function proposalMaxOperations() public pure returns (uint) {
370         // 10 actions
371         return 10;
372     }
373 
374     /**
375      * @return  The delay before voting on a proposal may take place, once proposed
376      */
377     function votingDelay() public pure returns (uint) {
378         // 1 block
379         return 1;
380     }
381 
382     function setVotingPeriod(uint votingPeriod_) public {
383         require(msg.sender == address(timelock), "GovernorAlpha::setVotingPeriod: invalid sender");
384         require(votingPeriod_ >= 5760, "GovernorAlpha::setVotingPeriod: new voting period must exceed minimum");
385 
386         // The minimum number of blocks for a vote is ~1 day (assuming 15s blocks)
387         votingPeriod = votingPeriod_;
388     }
389 
390     function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory title, string memory description) public returns (uint) {
391         require(msg.sender == guardian || dmg.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold, "GovernorAlpha::propose: proposer votes below proposal threshold");
392         require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "GovernorAlpha::propose: proposal function information arity mismatch");
393         require(targets.length != 0, "GovernorAlpha::propose: must provide actions");
394         require(targets.length <= proposalMaxOperations(), "GovernorAlpha::propose: too many actions");
395 
396         uint latestProposalId = latestProposalIds[msg.sender];
397         if (latestProposalId != 0) {
398             ProposalState proposersLatestProposalState = state(latestProposalId);
399             require(proposersLatestProposalState != ProposalState.Active, "GovernorAlpha::propose: one live proposal per proposer, found an already active proposal");
400             require(proposersLatestProposalState != ProposalState.Pending, "GovernorAlpha::propose: one live proposal per proposer, found an already pending proposal");
401         }
402 
403         uint startBlock = add256(block.number, votingDelay());
404         uint endBlock = add256(startBlock, votingPeriod);
405 
406         proposalCount++;
407         Proposal memory newProposal = Proposal({
408             id : proposalCount,
409             proposer : msg.sender,
410             eta : 0,
411             targets : targets,
412             values : values,
413             signatures : signatures,
414             calldatas : calldatas,
415             startBlock : startBlock,
416             endBlock : endBlock,
417             forVotes : 0,
418             againstVotes : 0,
419             canceled : false,
420             executed : false
421             });
422 
423         proposals[newProposal.id] = newProposal;
424         latestProposalIds[newProposal.proposer] = newProposal.id;
425 
426         emit ProposalCreated(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, title, description);
427         return newProposal.id;
428     }
429 
430     function queue(uint proposalId) public {
431         require(state(proposalId) == ProposalState.Succeeded, "GovernorAlpha::queue: proposal can only be queued if it is succeeded");
432         Proposal storage proposal = proposals[proposalId];
433         uint eta = add256(block.timestamp, timelock.delay());
434         for (uint i = 0; i < proposal.targets.length; i++) {
435             _queueOrRevert(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);
436         }
437         proposal.eta = eta;
438         emit ProposalQueued(proposalId, eta);
439     }
440 
441     function _queueOrRevert(address target, uint value, string memory signature, bytes memory data, uint eta) internal {
442         require(!timelock.queuedTransactions(keccak256(abi.encode(target, value, signature, data, eta))), "GovernorAlpha::_queueOrRevert: proposal action already queued at eta");
443         timelock.queueTransaction(target, value, signature, data, eta);
444     }
445 
446     function execute(uint proposalId) public payable {
447         require(state(proposalId) == ProposalState.Queued, "GovernorAlpha::execute: proposal can only be executed if it is queued");
448         Proposal storage proposal = proposals[proposalId];
449         proposal.executed = true;
450         for (uint i = 0; i < proposal.targets.length; i++) {
451             timelock.executeTransaction.value(proposal.values[i])(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
452         }
453         emit ProposalExecuted(proposalId);
454     }
455 
456     function cancel(uint proposalId) public {
457         ProposalState state = state(proposalId);
458         require(state != ProposalState.Executed, "GovernorAlpha::cancel: cannot cancel executed proposal");
459 
460         Proposal storage proposal = proposals[proposalId];
461         require(msg.sender == guardian || dmg.getPriorVotes(proposal.proposer, sub256(block.number, 1)) < proposalThreshold, "GovernorAlpha::cancel: proposer above threshold");
462 
463         proposal.canceled = true;
464         for (uint i = 0; i < proposal.targets.length; i++) {
465             timelock.cancelTransaction(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
466         }
467 
468         emit ProposalCanceled(proposalId);
469     }
470 
471     function getActions(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {
472         Proposal storage p = proposals[proposalId];
473         return (p.targets, p.values, p.signatures, p.calldatas);
474     }
475 
476     function getReceipt(uint proposalId, address voter) public view returns (Receipt memory) {
477         return proposals[proposalId].receipts[voter];
478     }
479 
480     function state(uint proposalId) public view returns (ProposalState) {
481         require(proposalCount >= proposalId && proposalId > 0, "GovernorAlpha::state: invalid proposal id");
482         Proposal storage proposal = proposals[proposalId];
483         if (proposal.canceled) {
484             return ProposalState.Canceled;
485         } else if (block.number <= proposal.startBlock) {
486             return ProposalState.Pending;
487         } else if (block.number <= proposal.endBlock) {
488             return ProposalState.Active;
489         } else if (proposal.forVotes <= proposal.againstVotes || proposal.forVotes < quorumVotes) {
490             return ProposalState.Defeated;
491         } else if (proposal.eta == 0) {
492             return ProposalState.Succeeded;
493         } else if (proposal.executed) {
494             return ProposalState.Executed;
495         } else if (block.timestamp >= add256(proposal.eta, timelock.GRACE_PERIOD())) {
496             return ProposalState.Expired;
497         } else {
498             return ProposalState.Queued;
499         }
500     }
501 
502     function castVote(uint proposalId, bool support) public {
503         return _castVote(msg.sender, proposalId, support);
504     }
505 
506     function castVoteBySig(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {
507         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
508         bytes32 structHash = keccak256(abi.encode(BALLOT_TYPEHASH, proposalId, support));
509         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
510         address signatory = ecrecover(digest, v, r, s);
511         require(signatory != address(0), "GovernorAlpha::castVoteBySig: invalid signature");
512         return _castVote(signatory, proposalId, support);
513     }
514 
515     function _castVote(address voter, uint proposalId, bool support) internal {
516         require(state(proposalId) == ProposalState.Active, "GovernorAlpha::_castVote: voting is closed");
517         Proposal storage proposal = proposals[proposalId];
518         Receipt storage receipt = proposal.receipts[voter];
519         require(receipt.hasVoted == false, "GovernorAlpha::_castVote: voter already voted");
520         uint128 votes = dmg.getPriorVotes(voter, proposal.startBlock);
521 
522         if (support) {
523             proposal.forVotes = add256(proposal.forVotes, votes);
524         } else {
525             proposal.againstVotes = add256(proposal.againstVotes, votes);
526         }
527 
528         receipt.hasVoted = true;
529         receipt.support = support;
530         receipt.votes = votes;
531 
532         emit VoteCast(voter, proposalId, support, votes);
533     }
534 
535     function __acceptAdmin() public {
536         require(msg.sender == guardian, "GovernorAlpha::__acceptAdmin: sender must be gov guardian");
537         timelock.acceptAdmin();
538     }
539 
540     function __abdicate() public {
541         require(msg.sender == guardian, "GovernorAlpha::__abdicate: sender must be gov guardian");
542         guardian = address(0);
543     }
544 
545     function __queueSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {
546         require(msg.sender == guardian, "GovernorAlpha::__queueSetTimelockPendingAdmin: sender must be gov guardian");
547         timelock.queueTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
548     }
549 
550     function __executeSetTimelockPendingAdmin(address newPendingAdmin, uint eta) public {
551         require(msg.sender == guardian, "GovernorAlpha::__executeSetTimelockPendingAdmin: sender must be gov guardian");
552         timelock.executeTransaction(address(timelock), 0, "setPendingAdmin(address)", abi.encode(newPendingAdmin), eta);
553     }
554 
555     function add256(uint256 a, uint256 b) internal pure returns (uint) {
556         uint c = a + b;
557         require(c >= a, "addition overflow");
558         return c;
559     }
560 
561     function sub256(uint256 a, uint256 b) internal pure returns (uint) {
562         require(b <= a, "subtraction underflow");
563         return a - b;
564     }
565 
566     function getChainId() internal pure returns (uint) {
567         uint chainId;
568         assembly {chainId := chainid()}
569         return chainId;
570     }
571 }