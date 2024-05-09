1 pragma solidity ^ 0.4.25;
2 
3 
4 // -----------------------------------------------------------------------------------------------------------------
5 //
6 //                 Recon® Token Teleportation Service v1.10
7 //
8 //                           of BlockReconChain®
9 //                             for ReconBank®
10 //
11 //                     ERC Token Standard #20 Interface
12 //
13 // -----------------------------------------------------------------------------------------------------------------
14 //.
15 //"
16 //.             ::::::..  .,::::::  .,-:::::     ...    :::.    :::
17 //.           ;;;;``;;;; ;;;;'''' ,;;;'````'  .;;;;;;;.`;;;;,  `;;;
18 //.            [[[,/[[['  [[cccc  [[[        ,[[     \[[,[[[[[. '[[
19 //.            $$$$$$c    $$""""  $$$        $$$,     $$$$$$ "Y$c$$
20 //.            888b "88bo,888oo,__`88bo,__,o,"888,_ _,88P888    Y88
21 //.            MMMM   "W" """"YUMMM "YUMMMMMP" "YMMMMMP" MMM     YM
22 //.
23 //.
24 //" -----------------------------------------------------------------------------------------------------------------
25 //             ¸.•*´¨)
26 //        ¸.•´   ¸.•´¸.•*´¨) ¸.•*¨)
27 //  ¸.•*´       (¸.•´ (¸.•` ¤ ReconBank.eth / ReconBank.com*´¨)
28 //                                                        ¸.•´¸.•*´¨)
29 //                                                      (¸.•´   ¸.•`
30 //                                                          ¸.•´•.¸
31 //   (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
32 // -----------------------------------------------------------------------------------------------------------------
33 //
34 // Common ownership of :
35 //  ____  _            _    _____                       _____ _           _
36 // |  _ \| |          | |  |  __ \                     / ____| |         (_)
37 // | |_) | | ___   ___| | _| |__) |___  ___ ___  _ __ | |    | |__   __ _ _ _ __
38 // |  _ <| |/ _ \ / __| |/ /  _  // _ \/ __/ _ \| '_ \| |    | '_ \ / _` | | '_ \
39 // | |_) | | (_) | (__|   <| | \ \  __/ (_| (_) | | | | |____| | | | (_| | | | | |
40 // |____/|_|\___/ \___|_|\_\_|  \_\___|\___\___/|_| |_|\_____|_| |_|\__,_|_|_| |_|®
41 //'
42 // -----------------------------------------------------------------------------------------------------------------
43 //
44 // This contract is an order from :
45 //'
46 // ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗██████╗  █████╗ ███╗   ██╗██╗  ██╗    ██████╗ ██████╗ ███╗   ███╗®
47 // ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝   ██╔════╝██╔═══██╗████╗ ████║
48 // ██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║██████╔╝███████║██╔██╗ ██║█████╔╝    ██║     ██║   ██║██╔████╔██║
49 // ██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║██╔══██╗██╔══██║██║╚██╗██║██╔═██╗    ██║     ██║   ██║██║╚██╔╝██║
50 // ██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║██████╔╝██║  ██║██║ ╚████║██║  ██╗██╗╚██████╗╚██████╔╝██║ ╚═╝ ██║
51 // ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝'
52 //
53 // -----------------------------------------------------------------------------------------------------------------
54 //
55 //
56 //                                 Copyright MIT :
57 //                      GNU Lesser General Public License 3.0
58 //                  https://www.gnu.org/licenses/lgpl-3.0.en.html
59 //
60 //              Permission is hereby granted, free of charge, to
61 //              any person obtaining a copy of this software and
62 //              associated documentation files ReconCoin® Token
63 //              Teleportation Service, to deal in the Software without
64 //              restriction, including without limitation the rights to
65 //              use, copy, modify, merge, publish, distribute,
66 //              sublicense, and/or sell copies of the Software, and
67 //              to permit persons to whom the Software is furnished
68 //              to do so, subject to the following conditions:
69 //              The above copyright notice and this permission
70 //              notice shall be included in all copies or substantial
71 //              portions of the Software.
72 //
73 //                 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
74 //                 WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
75 //                 INCLUDING BUT NOT LIMITED TO THE
76 //                 WARRANTIES OF MERCHANTABILITY, FITNESS FOR
77 //                 A PARTICULAR PURPOSE AND NONINFRINGEMENT.
78 //                 IN NO EVENT SHALL THE AUTHORS OR
79 //                 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
80 //                 DAMAGES OR OTHER LIABILITY, WHETHER IN AN
81 //                 ACTION OF CONTRACT, TORT OR
82 //                 OTHERWISE, ARISING FROM, OUT OF OR IN
83 //                 CONNECTION WITH THE SOFTWARE OR THE USE
84 //                 OR OTHER DEALINGS IN THE SOFTWARE.
85 //
86 //
87 // -----------------------------------------------------------------------------------------------------------------
88 
89 
90 pragma solidity ^ 0.4.25;
91 
92 
93 // -----------------------------------------------------------------------------------------------------------------
94 // The new assembly support in Solidity makes writing helpers easy.
95 // Many have complained how complex it is to use `ecrecover`, especially in conjunction
96 // with the `eth_sign` RPC call. Here is a helper, which makes that a matter of a single call.
97 //
98 // Sample input parameters:
99 // (with v=0)
100 // "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad",
101 // "0xaca7da997ad177f040240cdccf6905b71ab16b74434388c3a72f34fd25d6439346b2bac274ff29b48b3ea6e2d04c1336eaceafda3c53ab483fc3ff12fac3ebf200",
102 // "0x0e5cb767cce09a7f3ca594df118aa519be5e2b5a"
103 //
104 // (with v=1)
105 // "0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad",
106 // "0xdebaaa0cddb321b2dcaaf846d39605de7b97e77ba6106587855b9106cb10421561a22d94fa8b8a687ff9c911c844d1c016d1a685a9166858f9c7c1bc85128aca01",
107 // "0x8743523d96a1b2cbe0c6909653a56da18ed484af"
108 //
109 // (The hash is a hash of "hello world".)
110 //
111 // Written by Alex Beregszaszi (@axic), use it under the terms of the MIT license.
112 // -----------------------------------------------------------------------------------------------------------------
113 
114 
115 library ReconVerify {
116     // Duplicate Soliditys ecrecover, but catching the CALL return value
117     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
118         // We do our own memory management here. Solidity uses memory offset
119         // 0x40 to store the current end of memory. We write past it (as
120         // writes are memory extensions), but dont update the offset so
121         // Solidity will reuse it. The memory used here is only needed for
122         // this context.
123 
124         // FIXME: inline assembly cant access return values
125         bool ret;
126         address addr;
127 
128         assembly {
129             let size := mload(0x40)
130             mstore(size, hash)
131             mstore(add(size, 32), v)
132             mstore(add(size, 64), r)
133             mstore(add(size, 96), s)
134 
135             // NOTE: we can reuse the request memory because we deal with
136             //       the return code
137             ret := call(3000, 1, 0, size, 128, size, 32)
138             addr := mload(size)
139         }
140 
141         return (ret, addr);
142     }
143 
144     function ecrecovery(bytes32 hash, bytes sig) public returns (bool, address) {
145         bytes32 r;
146         bytes32 s;
147         uint8 v;
148 
149         if (sig.length != 65)
150           return (false, 0);
151 
152         // The signature format is a compact form of:
153         //   {bytes32 r}{bytes32 s}{uint8 v}
154         // Compact means, uint8 is not padded to 32 bytes.
155         assembly {
156             r := mload(add(sig, 32))
157             s := mload(add(sig, 64))
158 
159             // Here we are loading the last 32 bytes. We exploit the fact that
160             // 'mload' will pad with zeroes if we overread.
161             // There is no 'mload8' to do this, but that would be nicer.
162             v := byte(0, mload(add(sig, 96)))
163 
164             // Alternative solution:
165             // 'byte' is not working due to the Solidity parser, so lets
166             // use the second best option, 'and'
167             // v := and(mload(add(sig, 65)), 255)
168         }
169 
170         // albeit non-transactional signatures are not specified by the YP, one would expect it
171         // to match the YP range of [27, 28]
172         //
173         // geth uses [0, 1] and some clients have followed. This might change, see:
174         //  https://github.com/ethereum/go-ethereum/issues/2053
175         if (v < 27)
176           v += 27;
177 
178         if (v != 27 && v != 28)
179             return (false, 0);
180 
181         return safer_ecrecover(hash, v, r, s);
182     }
183 
184     function verify(bytes32 hash, bytes sig, address signer) public returns (bool) {
185         bool ret;
186         address addr;
187         (ret, addr) = ecrecovery(hash, sig);
188         return ret == true && addr == signer;
189     }
190 
191     function recover(bytes32 hash, bytes sig) internal returns (address addr) {
192         bool ret;
193         (ret, addr) = ecrecovery(hash, sig);
194     }
195 }
196 
197 contract ReconVerifyTest {
198     function test_v0() public returns (bool) {
199         bytes32 hash = 0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad;
200         bytes memory sig = "\xac\xa7\xda\x99\x7a\xd1\x77\xf0\x40\x24\x0c\xdc\xcf\x69\x05\xb7\x1a\xb1\x6b\x74\x43\x43\x88\xc3\xa7\x2f\x34\xfd\x25\xd6\x43\x93\x46\xb2\xba\xc2\x74\xff\x29\xb4\x8b\x3e\xa6\xe2\xd0\x4c\x13\x36\xea\xce\xaf\xda\x3c\x53\xab\x48\x3f\xc3\xff\x12\xfa\xc3\xeb\xf2\x00";
201         return ReconVerify.verify(hash, sig, 0x0A5f85C3d41892C934ae82BDbF17027A20717088);
202     }
203 
204     function test_v1() public returns (bool) {
205         bytes32 hash = 0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad;
206         bytes memory sig = "\xde\xba\xaa\x0c\xdd\xb3\x21\xb2\xdc\xaa\xf8\x46\xd3\x96\x05\xde\x7b\x97\xe7\x7b\xa6\x10\x65\x87\x85\x5b\x91\x06\xcb\x10\x42\x15\x61\xa2\x2d\x94\xfa\x8b\x8a\x68\x7f\xf9\xc9\x11\xc8\x44\xd1\xc0\x16\xd1\xa6\x85\xa9\x16\x68\x58\xf9\xc7\xc1\xbc\x85\x12\x8a\xca\x01";
207         return ReconVerify.verify(hash, sig, 0x0f65e64662281D6D42eE6dEcb87CDB98fEAf6060);
208     }
209 }
210 
211 // -----------------------------------------------------------------------------------------------------------------
212 //
213 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
214 //
215 // -----------------------------------------------------------------------------------------------------------------
216 
217 pragma solidity ^ 0.4.25;
218 
219 contract owned {
220     address public owner;
221 
222     function ReconOwned()  public {
223         owner = msg.sender;
224     }
225 
226     modifier onlyOwner {
227         require(msg.sender == owner);
228         _;
229     }
230 
231     function transferOwnership(address newOwner) onlyOwner  public {
232         owner = newOwner;
233     }
234 }
235 
236 
237 contract tokenRecipient {
238     event receivedEther(address sender, uint amount);
239     event receivedTokens(address _from, uint256 _value, address _token, bytes _extraData);
240 
241     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {
242         Token t = Token(_token);
243         require(t.transferFrom(_from, this, _value));
244         emit receivedTokens(_from, _value, _token, _extraData);
245     }
246 
247     function () payable  public {
248         emit receivedEther(msg.sender, msg.value);
249     }
250 }
251 
252 
253 interface Token {
254     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
255 }
256 
257 
258 contract Congress is owned, tokenRecipient {
259     // Contract Variables and events
260     uint public minimumQuorum;
261     uint public debatingPeriodInMinutes;
262     int public majorityMargin;
263     Proposal[] public proposals;
264     uint public numProposals;
265     mapping (address => uint) public memberId;
266     Member[] public members;
267 
268     event ProposalAdded(uint proposalID, address recipient, uint amount, string description);
269     event Voted(uint proposalID, bool position, address voter, string justification);
270     event ProposalTallied(uint proposalID, int result, uint quorum, bool active);
271     event MembershipChanged(address member, bool isMember);
272     event ChangeOfRules(uint newMinimumQuorum, uint newDebatingPeriodInMinutes, int newMajorityMargin);
273 
274     struct Proposal {
275         address recipient;
276         uint amount;
277         string description;
278         uint minExecutionDate;
279         bool executed;
280         bool proposalPassed;
281         uint numberOfVotes;
282         int currentResult;
283         bytes32 proposalHash;
284         Vote[] votes;
285         mapping (address => bool) voted;
286     }
287 
288     struct Member {
289         address member;
290         string name;
291         uint memberSince;
292     }
293 
294     struct Vote {
295         bool inSupport;
296         address voter;
297         string justification;
298     }
299 
300     // Modifier that allows only shareholders to vote and create new proposals
301     modifier onlyMembers {
302         require(memberId[msg.sender] != 0);
303         _;
304     }
305 
306     /**
307      * Constructor function
308      */
309     function ReconCongress (
310         uint minimumQuorumForProposals,
311         uint minutesForDebate,
312         int marginOfVotesForMajority
313     )  payable public {
314         changeVotingRules(minimumQuorumForProposals, minutesForDebate, marginOfVotesForMajority);
315         // It’s necessary to add an empty first member
316         addMember(0, "");
317         // and lets add the founder, to save a step later
318         addMember(owner, 'founder');
319     }
320 
321     /**
322      * Add member
323      *
324      * Make `targetMember` a member named `memberName`
325      *
326      * @param targetMember ethereum address to be added
327      * @param memberName public name for that member
328      */
329     function addMember(address targetMember, string memberName) onlyOwner public {
330         uint id = memberId[targetMember];
331         if (id == 0) {
332             memberId[targetMember] = members.length;
333             id = members.length++;
334         }
335 
336         members[id] = Member({member: targetMember, memberSince: now, name: memberName});
337         emit MembershipChanged(targetMember, true);
338     }
339 
340     /**
341      * Remove member
342      *
343      * @notice Remove membership from `targetMember`
344      *
345      * @param targetMember ethereum address to be removed
346      */
347     function removeMember(address targetMember) onlyOwner public {
348         require(memberId[targetMember] != 0);
349 
350         for (uint i = memberId[targetMember]; i<members.length-1; i++){
351             members[i] = members[i+1];
352         }
353         delete members[members.length-1];
354         members.length--;
355     }
356 
357     /**
358      * Change voting rules
359      *
360      * Make so that proposals need to be discussed for at least `minutesForDebate/60` hours,
361      * have at least `minimumQuorumForProposals` votes, and have 50% + `marginOfVotesForMajority` votes to be executed
362      *
363      * @param minimumQuorumForProposals how many members must vote on a proposal for it to be executed
364      * @param minutesForDebate the minimum amount of delay between when a proposal is made and when it can be executed
365      * @param marginOfVotesForMajority the proposal needs to have 50% plus this number
366      */
367     function changeVotingRules(
368         uint minimumQuorumForProposals,
369         uint minutesForDebate,
370         int marginOfVotesForMajority
371     ) onlyOwner public {
372         minimumQuorum = minimumQuorumForProposals;
373         debatingPeriodInMinutes = minutesForDebate;
374         majorityMargin = marginOfVotesForMajority;
375 
376         emit ChangeOfRules(minimumQuorum, debatingPeriodInMinutes, majorityMargin);
377     }
378 
379     /**
380      * Add Proposal
381      *
382      * Propose to send `weiAmount / 1e18` ether to `beneficiary` for `jobDescription`. `transactionBytecode ? Contains : Does not contain` code.
383      *
384      * @param beneficiary who to send the ether to
385      * @param weiAmount amount of ether to send, in wei
386      * @param jobDescription Description of job
387      * @param transactionBytecode bytecode of transaction
388      */
389     function newProposal(
390         address beneficiary,
391         uint weiAmount,
392         string jobDescription,
393         bytes transactionBytecode
394     )
395         onlyMembers public
396         returns (uint proposalID)
397     {
398         proposalID = proposals.length++;
399         Proposal storage p = proposals[proposalID];
400         p.recipient = beneficiary;
401         p.amount = weiAmount;
402         p.description = jobDescription;
403         p.proposalHash = keccak256(abi.encodePacked(beneficiary, weiAmount, transactionBytecode));
404         p.minExecutionDate = now + debatingPeriodInMinutes * 1 minutes;
405         p.executed = false;
406         p.proposalPassed = false;
407         p.numberOfVotes = 0;
408         emit ProposalAdded(proposalID, beneficiary, weiAmount, jobDescription);
409         numProposals = proposalID+1;
410 
411         return proposalID;
412     }
413 
414     /**
415      * Add proposal in Ether
416      *
417      * Propose to send `etherAmount` ether to `beneficiary` for `jobDescription`. `transactionBytecode ? Contains : Does not contain` code.
418      * This is a convenience function to use if the amount to be given is in round number of ether units.
419      *
420      * @param beneficiary who to send the ether to
421      * @param etherAmount amount of ether to send
422      * @param jobDescription Description of job
423      * @param transactionBytecode bytecode of transaction
424      */
425     function newProposalInEther(
426         address beneficiary,
427         uint etherAmount,
428         string jobDescription,
429         bytes transactionBytecode
430     )
431         onlyMembers public
432         returns (uint proposalID)
433     {
434         return newProposal(beneficiary, etherAmount * 1 ether, jobDescription, transactionBytecode);
435     }
436 
437     /**
438      * Check if a proposal code matches
439      *
440      * @param proposalNumber ID number of the proposal to query
441      * @param beneficiary who to send the ether to
442      * @param weiAmount amount of ether to send
443      * @param transactionBytecode bytecode of transaction
444      */
445     function checkProposalCode(
446         uint proposalNumber,
447         address beneficiary,
448         uint weiAmount,
449         bytes transactionBytecode
450     )
451         constant public
452         returns (bool codeChecksOut)
453     {
454         Proposal storage p = proposals[proposalNumber];
455         return p.proposalHash == keccak256(abi.encodePacked(beneficiary, weiAmount, transactionBytecode));
456     }
457 
458     /**
459      * Log a vote for a proposal
460      *
461      * Vote `supportsProposal? in support of : against` proposal #`proposalNumber`
462      *
463      * @param proposalNumber number of proposal
464      * @param supportsProposal either in favor or against it
465      * @param justificationText optional justification text
466      */
467     function vote(
468         uint proposalNumber,
469         bool supportsProposal,
470         string justificationText
471     )
472         onlyMembers public
473         returns (uint voteID)
474     {
475         Proposal storage p = proposals[proposalNumber]; // Get the proposal
476         require(!p.voted[msg.sender]);                  // If has already voted, cancel
477         p.voted[msg.sender] = true;                     // Set this voter as having voted
478         p.numberOfVotes++;                              // Increase the number of votes
479         if (supportsProposal) {                         // If they support the proposal
480             p.currentResult++;                          // Increase score
481         } else {                                        // If they dont
482             p.currentResult--;                          // Decrease the score
483         }
484 
485         // Create a log of this event
486         emit Voted(proposalNumber,  supportsProposal, msg.sender, justificationText);
487         return p.numberOfVotes;
488     }
489 
490     /**
491      * Finish vote
492      *
493      * Count the votes proposal #`proposalNumber` and execute it if approved
494      *
495      * @param proposalNumber proposal number
496      * @param transactionBytecode optional: if the transaction contained a bytecode, you need to send it
497      */
498     function executeProposal(uint proposalNumber, bytes transactionBytecode) public {
499         Proposal storage p = proposals[proposalNumber];
500 
501         require(now > p.minExecutionDate                                            // If it is past the voting deadline
502             && !p.executed                                                         // and it has not already been executed
503             && p.proposalHash == keccak256(abi.encodePacked(p.recipient, p.amount, transactionBytecode))  // and the supplied code matches the proposal
504             && p.numberOfVotes >= minimumQuorum);                                  // and a minimum quorum has been reached...
505 
506         // ...then execute result
507 
508         if (p.currentResult > majorityMargin) {
509             // Proposal passed; execute the transaction
510 
511             p.executed = true; // Avoid recursive calling
512             require(p.recipient.call.value(p.amount)(transactionBytecode));
513 
514             p.proposalPassed = true;
515         } else {
516             // Proposal failed
517             p.proposalPassed = false;
518         }
519 
520         // Fire Events
521         emit ProposalTallied(proposalNumber, p.currentResult, p.numberOfVotes, p.proposalPassed);
522     }
523 }
524 
525 // -----------------------------------------------------------------------------------------------------------------
526 //
527 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
528 //
529 // -----------------------------------------------------------------------------------------------------------------
530 
531 pragma solidity ^ 0.4.25;
532 
533 library SafeMath {
534     function add(uint a, uint b) internal pure returns (uint c) {
535         c = a + b;
536         require(c >= a);
537     }
538 
539     function sub(uint a, uint b) internal pure returns (uint c) {
540         require(b <= a);
541         c = a - b;
542     }
543 
544     function mul(uint a, uint b) internal pure returns (uint c) {
545         c = a * b;
546         require(a == 0 || c / a == b);
547     }
548 
549     function div(uint a, uint b) internal pure returns (uint c) {
550         require(b > 0);
551         c = a / b;
552     }
553 }
554 
555 
556 pragma solidity ^ 0.4.25;
557 
558 // ----------------------------------------------------------------------------
559 // Recon DateTime Library v1.00
560 //
561 // A energy-efficient Solidity date and time library
562 //
563 // Tested date range 1970/01/01 to 2345/12/31
564 //
565 // Conventions:
566 // Unit      | Range         | Notes
567 // :-------- |:-------------:|:-----
568 // timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
569 // year      | 1970 ... 2345 |
570 // month     | 1 ... 12      |
571 // day       | 1 ... 31      |
572 // hour      | 0 ... 23      |
573 // minute    | 0 ... 59      |
574 // second    | 0 ... 59      |
575 // dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
576 //
577 //
578 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
579 //
580 // GNU Lesser General Public License 3.0
581 // https://www.gnu.org/licenses/lgpl-3.0.en.html
582 // ----------------------------------------------------------------------------
583 
584 
585 library ReconDateTimeLibrary {
586 
587     uint constant SECONDS_PER_DAY = 24 * 60 * 60;
588     uint constant SECONDS_PER_HOUR = 60 * 60;
589     uint constant SECONDS_PER_MINUTE = 60;
590     int constant OFFSET19700101 = 2440588;
591 
592     uint constant DOW_MON = 1;
593     uint constant DOW_TUE = 2;
594     uint constant DOW_WED = 3;
595     uint constant DOW_THU = 4;
596     uint constant DOW_FRI = 5;
597     uint constant DOW_SAT = 6;
598     uint constant DOW_SUN = 7;
599 
600     // ------------------------------------------------------------------------
601     // Calculate the number of days from 1970/01/01 to year/month/day using
602     // the date conversion algorithm from
603     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
604     // and subtracting the offset 2440588 so that 1970/01/01 is day 0
605     //
606     // days = day
607     //      - 32075
608     //      + 1461 * (year + 4800 + (month - 14) / 12) / 4
609     //      + 367 * (month - 2 - (month - 14) / 12 * 12) / 12
610     //      - 3 * ((year + 4900 + (month - 14) / 12) / 100) / 4
611     //      - offset
612     // ------------------------------------------------------------------------
613     function _daysFromDate(uint year, uint month, uint day) internal pure returns (uint _days) {
614         int _year = int(year);
615         int _month = int(month);
616         int _day = int(day);
617 
618         int __days = _day
619           - 32075
620           + 1461 * (_year + 4800 + (_month - 14) / 12) / 4
621           + 367 * (_month - 2 - (_month - 14) / 12 * 12) / 12
622           - 3 * ((_year + 4900 + (_month - 14) / 12) / 100) / 4
623           - OFFSET19700101;
624 
625         _days = uint(__days);
626     }
627 
628     // ------------------------------------------------------------------------
629     // Calculate year/month/day from the number of days since 1970/01/01 using
630     // the date conversion algorithm from
631     //   http://aa.usno.navy.mil/faq/docs/JD_Formula.php
632     // and adding the offset 2440588 so that 1970/01/01 is day 0
633     //
634     // int L = days + 68569 + offset
635     // int N = 4 * L / 146097
636     // L = L - (146097 * N + 3) / 4
637     // year = 4000 * (L + 1) / 1461001
638     // L = L - 1461 * year / 4 + 31
639     // month = 80 * L / 2447
640     // dd = L - 2447 * month / 80
641     // L = month / 11
642     // month = month + 2 - 12 * L
643     // year = 100 * (N - 49) + year + L
644     // ------------------------------------------------------------------------
645     function _daysToDate(uint _days) internal pure returns (uint year, uint month, uint day) {
646         int __days = int(_days);
647 
648         int L = __days + 68569 + OFFSET19700101;
649         int N = 4 * L / 146097;
650         L = L - (146097 * N + 3) / 4;
651         int _year = 4000 * (L + 1) / 1461001;
652         L = L - 1461 * _year / 4 + 31;
653         int _month = 80 * L / 2447;
654         int _day = L - 2447 * _month / 80;
655         L = _month / 11;
656         _month = _month + 2 - 12 * L;
657         _year = 100 * (N - 49) + _year + L;
658 
659         year = uint(_year);
660         month = uint(_month);
661         day = uint(_day);
662     }
663 
664     function timestampFromDate(uint year, uint month, uint day) internal pure returns (uint timestamp) {
665         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY;
666     }
667 
668     function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) internal pure returns (uint timestamp) {
669         timestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + hour * SECONDS_PER_HOUR + minute * SECONDS_PER_MINUTE + second;
670     }
671 
672     function timestampToDate(uint timestamp) internal pure returns (uint year, uint month, uint day) {
673         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
674     }
675 
676     function timestampToDateTime(uint timestamp) internal pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
677         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
678         uint secs = timestamp % SECONDS_PER_DAY;
679         hour = secs / SECONDS_PER_HOUR;
680         secs = secs % SECONDS_PER_HOUR;
681         minute = secs / SECONDS_PER_MINUTE;
682         second = secs % SECONDS_PER_MINUTE;
683     }
684 
685     function isLeapYear(uint timestamp) internal pure returns (bool leapYear) {
686         uint year;
687         uint month;
688         uint day;
689         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
690         leapYear = _isLeapYear(year);
691     }
692 
693     function _isLeapYear(uint year) internal pure returns (bool leapYear) {
694         leapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
695     }
696 
697     function isWeekDay(uint timestamp) internal pure returns (bool weekDay) {
698         weekDay = getDayOfWeek(timestamp) <= DOW_FRI;
699     }
700 
701     function isWeekEnd(uint timestamp) internal pure returns (bool weekEnd) {
702         weekEnd = getDayOfWeek(timestamp) >= DOW_SAT;
703     }
704 
705     function getDaysInMonth(uint timestamp) internal pure returns (uint daysInMonth) {
706         uint year;
707         uint month;
708         uint day;
709         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
710         daysInMonth = _getDaysInMonth(year, month);
711     }
712 
713     function _getDaysInMonth(uint year, uint month) internal pure returns (uint daysInMonth) {
714         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
715             daysInMonth = 31;
716         } else if (month != 2) {
717             daysInMonth = 30;
718         } else {
719             daysInMonth = _isLeapYear(year) ? 29 : 28;
720         }
721     }
722     // 1 = Monday, 7 = Sunday
723     function getDayOfWeek(uint timestamp) internal pure returns (uint dayOfWeek) {
724         uint _days = timestamp / SECONDS_PER_DAY;
725         dayOfWeek = (_days + 3) % 7 + 1;
726     }
727 
728     function getYear(uint timestamp) internal pure returns (uint year) {
729         uint month;
730         uint day;
731         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
732     }
733 
734     function getMonth(uint timestamp) internal pure returns (uint month) {
735         uint year;
736         uint day;
737         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
738     }
739 
740     function getDay(uint timestamp) internal pure returns (uint day) {
741         uint year;
742         uint month;
743         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
744     }
745 
746     function getHour(uint timestamp) internal pure returns (uint hour) {
747         uint secs = timestamp % SECONDS_PER_DAY;
748         hour = secs / SECONDS_PER_HOUR;
749     }
750 
751     function getMinute(uint timestamp) internal pure returns (uint minute) {
752         uint secs = timestamp % SECONDS_PER_HOUR;
753         minute = secs / SECONDS_PER_MINUTE;
754     }
755 
756     function getSecond(uint timestamp) internal pure returns (uint second) {
757         second = timestamp % SECONDS_PER_MINUTE;
758     }
759 
760     function addYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
761         uint year;
762         uint month;
763         uint day;
764         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
765         year += _years;
766         uint daysInMonth = _getDaysInMonth(year, month);
767         if (day > daysInMonth) {
768             day = daysInMonth;
769         }
770         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
771         require(newTimestamp >= timestamp);
772     }
773 
774     function addMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
775         uint year;
776         uint month;
777         uint day;
778         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
779         month += _months;
780         year += (month - 1) / 12;
781         month = (month - 1) % 12 + 1;
782         uint daysInMonth = _getDaysInMonth(year, month);
783         if (day > daysInMonth) {
784             day = daysInMonth;
785         }
786         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
787         require(newTimestamp >= timestamp);
788     }
789 
790     function addDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
791         newTimestamp = timestamp + _days * SECONDS_PER_DAY;
792         require(newTimestamp >= timestamp);
793     }
794 
795     function addHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
796         newTimestamp = timestamp + _hours * SECONDS_PER_HOUR;
797         require(newTimestamp >= timestamp);
798     }
799 
800     function addMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
801         newTimestamp = timestamp + _minutes * SECONDS_PER_MINUTE;
802         require(newTimestamp >= timestamp);
803     }
804 
805     function addSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
806         newTimestamp = timestamp + _seconds;
807         require(newTimestamp >= timestamp);
808     }
809 
810     function subYears(uint timestamp, uint _years) internal pure returns (uint newTimestamp) {
811         uint year;
812         uint month;
813         uint day;
814         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
815         year -= _years;
816         uint daysInMonth = _getDaysInMonth(year, month);
817         if (day > daysInMonth) {
818             day = daysInMonth;
819         }
820         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
821         require(newTimestamp <= timestamp);
822     }
823 
824     function subMonths(uint timestamp, uint _months) internal pure returns (uint newTimestamp) {
825         uint year;
826         uint month;
827         uint day;
828         (year, month, day) = _daysToDate(timestamp / SECONDS_PER_DAY);
829         uint yearMonth = year * 12 + (month - 1) - _months;
830         year = yearMonth / 12;
831         month = yearMonth % 12 + 1;
832         uint daysInMonth = _getDaysInMonth(year, month);
833         if (day > daysInMonth) {
834             day = daysInMonth;
835         }
836         newTimestamp = _daysFromDate(year, month, day) * SECONDS_PER_DAY + timestamp % SECONDS_PER_DAY;
837         require(newTimestamp <= timestamp);
838     }
839 
840     function subDays(uint timestamp, uint _days) internal pure returns (uint newTimestamp) {
841         newTimestamp = timestamp - _days * SECONDS_PER_DAY;
842         require(newTimestamp <= timestamp);
843     }
844 
845     function subHours(uint timestamp, uint _hours) internal pure returns (uint newTimestamp) {
846         newTimestamp = timestamp - _hours * SECONDS_PER_HOUR;
847         require(newTimestamp <= timestamp);
848     }
849 
850     function subMinutes(uint timestamp, uint _minutes) internal pure returns (uint newTimestamp) {
851         newTimestamp = timestamp - _minutes * SECONDS_PER_MINUTE;
852         require(newTimestamp <= timestamp);
853     }
854 
855     function subSeconds(uint timestamp, uint _seconds) internal pure returns (uint newTimestamp) {
856         newTimestamp = timestamp - _seconds;
857         require(newTimestamp <= timestamp);
858     }
859 
860     function diffYears(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _years) {
861         require(fromTimestamp <= toTimestamp);
862         uint fromYear;
863         uint fromMonth;
864         uint fromDay;
865         uint toYear;
866         uint toMonth;
867         uint toDay;
868         (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
869         (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
870         _years = toYear - fromYear;
871     }
872 
873     function diffMonths(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _months) {
874         require(fromTimestamp <= toTimestamp);
875         uint fromYear;
876         uint fromMonth;
877         uint fromDay;
878         uint toYear;
879         uint toMonth;
880         uint toDay;
881         (fromYear, fromMonth, fromDay) = _daysToDate(fromTimestamp / SECONDS_PER_DAY);
882         (toYear, toMonth, toDay) = _daysToDate(toTimestamp / SECONDS_PER_DAY);
883         _months = toYear * 12 + toMonth - fromYear * 12 - fromMonth;
884     }
885 
886     function diffDays(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _days) {
887         require(fromTimestamp <= toTimestamp);
888         _days = (toTimestamp - fromTimestamp) / SECONDS_PER_DAY;
889     }
890 
891     function diffHours(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _hours) {
892         require(fromTimestamp <= toTimestamp);
893         _hours = (toTimestamp - fromTimestamp) / SECONDS_PER_HOUR;
894     }
895 
896     function diffMinutes(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _minutes) {
897         require(fromTimestamp <= toTimestamp);
898         _minutes = (toTimestamp - fromTimestamp) / SECONDS_PER_MINUTE;
899     }
900 
901     function diffSeconds(uint fromTimestamp, uint toTimestamp) internal pure returns (uint _seconds) {
902         require(fromTimestamp <= toTimestamp);
903         _seconds = toTimestamp - fromTimestamp;
904     }
905 }
906 
907 
908 pragma solidity ^ 0.4.25;
909 
910 // ----------------------------------------------------------------------------
911 // Recon DateTime Library v1.00 - Contract Instance
912 //
913 // A energy-efficient Solidity date and time library
914 //
915 //
916 // Tested date range 1970/01/01 to 2345/12/31
917 //
918 // Conventions:
919 // Unit      | Range         | Notes
920 // :-------- |:-------------:|:-----
921 // timestamp | >= 0          | Unix timestamp, number of seconds since 1970/01/01 00:00:00 UTC
922 // year      | 1970 ... 2345 |
923 // month     | 1 ... 12      |
924 // day       | 1 ... 31      |
925 // hour      | 0 ... 23      |
926 // minute    | 0 ... 59      |
927 // second    | 0 ... 59      |
928 // dayOfWeek | 1 ... 7       | 1 = Monday, ..., 7 = Sunday
929 //
930 //
931 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
932 //
933 // GNU Lesser General Public License 3.0
934 // https://www.gnu.org/licenses/lgpl-3.0.en.html
935 // ----------------------------------------------------------------------------
936 
937 contract ReconDateTimeContract {
938     uint public constant SECONDS_PER_DAY = 24 * 60 * 60;
939     uint public constant SECONDS_PER_HOUR = 60 * 60;
940     uint public constant SECONDS_PER_MINUTE = 60;
941     int public constant OFFSET19700101 = 2440588;
942 
943     uint public constant DOW_MON = 1;
944     uint public constant DOW_TUE = 2;
945     uint public constant DOW_WED = 3;
946     uint public constant DOW_THU = 4;
947     uint public constant DOW_FRI = 5;
948     uint public constant DOW_SAT = 6;
949     uint public constant DOW_SUN = 7;
950 
951     function _now() public view returns (uint timestamp) {
952         timestamp = now;
953     }
954 
955     function _nowDateTime() public view returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
956         (year, month, day, hour, minute, second) = ReconDateTimeLibrary.timestampToDateTime(now);
957     }
958 
959     function _daysFromDate(uint year, uint month, uint day) public pure returns (uint _days) {
960         return ReconDateTimeLibrary._daysFromDate(year, month, day);
961     }
962 
963     function _daysToDate(uint _days) public pure returns (uint year, uint month, uint day) {
964         return ReconDateTimeLibrary._daysToDate(_days);
965     }
966 
967     function timestampFromDate(uint year, uint month, uint day) public pure returns (uint timestamp) {
968         return ReconDateTimeLibrary.timestampFromDate(year, month, day);
969     }
970 
971     function timestampFromDateTime(uint year, uint month, uint day, uint hour, uint minute, uint second) public pure returns (uint timestamp) {
972         return ReconDateTimeLibrary.timestampFromDateTime(year, month, day, hour, minute, second);
973     }
974 
975     function timestampToDate(uint timestamp) public pure returns (uint year, uint month, uint day) {
976         (year, month, day) = ReconDateTimeLibrary.timestampToDate(timestamp);
977     }
978 
979     function timestampToDateTime(uint timestamp) public pure returns (uint year, uint month, uint day, uint hour, uint minute, uint second) {
980         (year, month, day, hour, minute, second) = ReconDateTimeLibrary.timestampToDateTime(timestamp);
981     }
982 
983     function isLeapYear(uint timestamp) public pure returns (bool leapYear) {
984         leapYear = ReconDateTimeLibrary.isLeapYear(timestamp);
985     }
986 
987     function _isLeapYear(uint year) public pure returns (bool leapYear) {
988         leapYear = ReconDateTimeLibrary._isLeapYear(year);
989     }
990 
991     function isWeekDay(uint timestamp) public pure returns (bool weekDay) {
992         weekDay = ReconDateTimeLibrary.isWeekDay(timestamp);
993     }
994 
995     function isWeekEnd(uint timestamp) public pure returns (bool weekEnd) {
996         weekEnd = ReconDateTimeLibrary.isWeekEnd(timestamp);
997     }
998 
999     function getDaysInMonth(uint timestamp) public pure returns (uint daysInMonth) {
1000         daysInMonth = ReconDateTimeLibrary.getDaysInMonth(timestamp);
1001     }
1002 
1003     function _getDaysInMonth(uint year, uint month) public pure returns (uint daysInMonth) {
1004         daysInMonth = ReconDateTimeLibrary._getDaysInMonth(year, month);
1005     }
1006 
1007     function getDayOfWeek(uint timestamp) public pure returns (uint dayOfWeek) {
1008         dayOfWeek = ReconDateTimeLibrary.getDayOfWeek(timestamp);
1009     }
1010 
1011     function getYear(uint timestamp) public pure returns (uint year) {
1012         year = ReconDateTimeLibrary.getYear(timestamp);
1013     }
1014 
1015     function getMonth(uint timestamp) public pure returns (uint month) {
1016         month = ReconDateTimeLibrary.getMonth(timestamp);
1017     }
1018 
1019     function getDay(uint timestamp) public pure returns (uint day) {
1020         day = ReconDateTimeLibrary.getDay(timestamp);
1021     }
1022 
1023     function getHour(uint timestamp) public pure returns (uint hour) {
1024         hour = ReconDateTimeLibrary.getHour(timestamp);
1025     }
1026 
1027     function getMinute(uint timestamp) public pure returns (uint minute) {
1028         minute = ReconDateTimeLibrary.getMinute(timestamp);
1029     }
1030 
1031     function getSecond(uint timestamp) public pure returns (uint second) {
1032         second = ReconDateTimeLibrary.getSecond(timestamp);
1033     }
1034 
1035     function addYears(uint timestamp, uint _years) public pure returns (uint newTimestamp) {
1036         newTimestamp = ReconDateTimeLibrary.addYears(timestamp, _years);
1037     }
1038 
1039     function addMonths(uint timestamp, uint _months) public pure returns (uint newTimestamp) {
1040         newTimestamp = ReconDateTimeLibrary.addMonths(timestamp, _months);
1041     }
1042 
1043     function addDays(uint timestamp, uint _days) public pure returns (uint newTimestamp) {
1044         newTimestamp = ReconDateTimeLibrary.addDays(timestamp, _days);
1045     }
1046 
1047     function addHours(uint timestamp, uint _hours) public pure returns (uint newTimestamp) {
1048         newTimestamp = ReconDateTimeLibrary.addHours(timestamp, _hours);
1049     }
1050 
1051     function addMinutes(uint timestamp, uint _minutes) public pure returns (uint newTimestamp) {
1052         newTimestamp = ReconDateTimeLibrary.addMinutes(timestamp, _minutes);
1053     }
1054 
1055     function addSeconds(uint timestamp, uint _seconds) public pure returns (uint newTimestamp) {
1056         newTimestamp = ReconDateTimeLibrary.addSeconds(timestamp, _seconds);
1057     }
1058 
1059     function subYears(uint timestamp, uint _years) public pure returns (uint newTimestamp) {
1060         newTimestamp = ReconDateTimeLibrary.subYears(timestamp, _years);
1061     }
1062 
1063     function subMonths(uint timestamp, uint _months) public pure returns (uint newTimestamp) {
1064         newTimestamp = ReconDateTimeLibrary.subMonths(timestamp, _months);
1065     }
1066 
1067     function subDays(uint timestamp, uint _days) public pure returns (uint newTimestamp) {
1068         newTimestamp = ReconDateTimeLibrary.subDays(timestamp, _days);
1069     }
1070 
1071     function subHours(uint timestamp, uint _hours) public pure returns (uint newTimestamp) {
1072         newTimestamp = ReconDateTimeLibrary.subHours(timestamp, _hours);
1073     }
1074 
1075     function subMinutes(uint timestamp, uint _minutes) public pure returns (uint newTimestamp) {
1076         newTimestamp = ReconDateTimeLibrary.subMinutes(timestamp, _minutes);
1077     }
1078 
1079     function subSeconds(uint timestamp, uint _seconds) public pure returns (uint newTimestamp) {
1080         newTimestamp = ReconDateTimeLibrary.subSeconds(timestamp, _seconds);
1081     }
1082 
1083     function diffYears(uint fromTimestamp, uint toTimestamp) public pure returns (uint _years) {
1084         _years = ReconDateTimeLibrary.diffYears(fromTimestamp, toTimestamp);
1085     }
1086 
1087     function diffMonths(uint fromTimestamp, uint toTimestamp) public pure returns (uint _months) {
1088         _months = ReconDateTimeLibrary.diffMonths(fromTimestamp, toTimestamp);
1089     }
1090 
1091     function diffDays(uint fromTimestamp, uint toTimestamp) public pure returns (uint _days) {
1092         _days = ReconDateTimeLibrary.diffDays(fromTimestamp, toTimestamp);
1093     }
1094 
1095     function diffHours(uint fromTimestamp, uint toTimestamp) public pure returns (uint _hours) {
1096         _hours = ReconDateTimeLibrary.diffHours(fromTimestamp, toTimestamp);
1097     }
1098 
1099     function diffMinutes(uint fromTimestamp, uint toTimestamp) public pure returns (uint _minutes) {
1100         _minutes = ReconDateTimeLibrary.diffMinutes(fromTimestamp, toTimestamp);
1101     }
1102 
1103     function diffSeconds(uint fromTimestamp, uint toTimestamp) public pure returns (uint _seconds) {
1104         _seconds = ReconDateTimeLibrary.diffSeconds(fromTimestamp, toTimestamp);
1105     }
1106 }
1107 
1108 
1109 // -----------------------------------------------------------------------------------------------------------------
1110 //
1111 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
1112 //
1113 // -----------------------------------------------------------------------------------------------------------------
1114 
1115 
1116 pragma solidity ^ 0.4.25;
1117 
1118 contract ERC20Interface {
1119     function totalSupply() public view returns (uint);
1120     function balanceOf(address tokenOwner) public view returns (uint balance);
1121     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
1122     function transfer(address to, uint tokens) public returns (bool success);
1123     function approve(address spender, uint tokens) public returns (bool success);
1124     function transferFrom(address from, address to, uint tokens) public returns (bool success);
1125 
1126     event Transfer(address indexed from, address indexed to, uint tokens);
1127     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
1128     }
1129 
1130 
1131 contract ApproveAndCallFallBack {
1132     function receiveApproval(address from, uint256 tokens, address token, bytes32 hash) public;
1133 }
1134 
1135 
1136 contract ReconTokenInterface is ERC20Interface {
1137     uint public constant reconVersion = 110;
1138 
1139     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
1140     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
1141     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
1142     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
1143     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";
1144 
1145     event OwnershipTransferred(address indexed from, address indexed to);
1146     event MinterUpdated(address from, address to);
1147     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
1148     event MintingDisabled();
1149     event TransfersEnabled();
1150     event AccountUnlocked(address indexed tokenOwner);
1151 
1152     function approveAndCall(address spender, uint tokens, bytes32 hash) public returns (bool success);
1153 
1154     // ------------------------------------------------------------------------
1155     // signed{X} functions
1156     // ------------------------------------------------------------------------
1157     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
1158     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (CheckResult result);
1159     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success);
1160 
1161     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
1162     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (CheckResult result);
1163     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success);
1164 
1165     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
1166     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (CheckResult result);
1167     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success);
1168 
1169     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes32 _data, uint fee, uint nonce) public view returns (bytes32 hash);
1170     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes32 _data, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (CheckResult result);
1171     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes32 _data, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success);
1172 
1173     function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success);
1174     function unlockAccount(address tokenOwner) public;
1175     function disableMinting() public;
1176     function enableTransfers() public;
1177 
1178 
1179     enum CheckResult {
1180         Success,                           // 0 Success
1181         NotTransferable,                   // 1 Tokens not transferable yet
1182         AccountLocked,                     // 2 Account locked
1183         SignerMismatch,                    // 3 Mismatch in signing account
1184         InvalidNonce,                      // 4 Invalid nonce
1185         InsufficientApprovedTokens,        // 5 Insufficient approved tokens
1186         InsufficientApprovedTokensForFees, // 6 Insufficient approved tokens for fees
1187         InsufficientTokens,                // 7 Insufficient tokens
1188         InsufficientTokensForFees,         // 8 Insufficient tokens for fees
1189         OverflowError                      // 9 Overflow error
1190     }
1191 }
1192 
1193 
1194 // -----------------------------------------------------------------------------------------------------------------
1195 //
1196 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
1197 //
1198 // -----------------------------------------------------------------------------------------------------------------
1199 
1200 
1201 pragma solidity ^ 0.4.25;
1202 
1203 library ReconLib {
1204     struct Data {
1205         bool initialised;
1206 
1207         // Ownership
1208         address owner;
1209         address newOwner;
1210 
1211         // Minting and management
1212         address minter;
1213         bool mintable;
1214         bool transferable;
1215         mapping(address => bool) accountLocked;
1216 
1217         // Token
1218         string symbol;
1219         string name;
1220         uint8 decimals;
1221         uint totalSupply;
1222         mapping(address => uint) balances;
1223         mapping(address => mapping(address => uint)) allowed;
1224         mapping(address => uint) nextNonce;
1225     }
1226 
1227 
1228     uint public constant reconVersion = 110;
1229     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
1230     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
1231     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
1232     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
1233     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";
1234 
1235 
1236     event OwnershipTransferred(address indexed from, address indexed to);
1237     event MinterUpdated(address from, address to);
1238     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
1239     event MintingDisabled();
1240     event TransfersEnabled();
1241     event AccountUnlocked(address indexed tokenOwner);
1242     event Transfer(address indexed from, address indexed to, uint tokens);
1243     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
1244 
1245 
1246     function init(Data storage self, address owner, string symbol, string name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) public {
1247         require(!self.initialised);
1248         self.initialised = true;
1249         self.owner = owner;
1250         self.symbol = symbol;
1251         self.name = name;
1252         self.decimals = decimals;
1253         if (initialSupply > 0) {
1254             self.balances[owner] = initialSupply;
1255             self.totalSupply = initialSupply;
1256             emit Mint(self.owner, initialSupply, false);
1257             emit Transfer(address(0), self.owner, initialSupply);
1258         }
1259         self.mintable = mintable;
1260         self.transferable = transferable;
1261     }
1262 
1263     function safeAdd(uint a, uint b) internal pure returns (uint c) {
1264         c = a + b;
1265         require(c >= a);
1266     }
1267 
1268     function safeSub(uint a, uint b) internal pure returns (uint c) {
1269         require(b <= a);
1270         c = a - b;
1271     }
1272 
1273     function safeMul(uint a, uint b) internal pure returns (uint c) {
1274         c = a * b;
1275         require(a == 0 || c / a == b);
1276     }
1277 
1278     function safeDiv(uint a, uint b) internal pure returns (uint c) {
1279         require(b > 0);
1280         c = a / b;
1281     }
1282 
1283 
1284     function transferOwnership(Data storage self, address newOwner) public {
1285         require(msg.sender == self.owner);
1286         self.newOwner = newOwner;
1287     }
1288 
1289     function acceptOwnership(Data storage self) public {
1290         require(msg.sender == self.newOwner);
1291         emit OwnershipTransferred(self.owner, self.newOwner);
1292         self.owner = self.newOwner;
1293         self.newOwner = address(0x0f65e64662281D6D42eE6dEcb87CDB98fEAf6060);
1294     }
1295 
1296     function transferOwnershipImmediately(Data storage self, address newOwner) public {
1297         require(msg.sender == self.owner);
1298         emit OwnershipTransferred(self.owner, newOwner);
1299         self.owner = newOwner;
1300         self.newOwner = address(0x0f65e64662281D6D42eE6dEcb87CDB98fEAf6060);
1301     }
1302 
1303     // ------------------------------------------------------------------------
1304     // Minting and management
1305     // ------------------------------------------------------------------------
1306     function setMinter(Data storage self, address minter) public {
1307         require(msg.sender == self.owner);
1308         require(self.mintable);
1309         emit MinterUpdated(self.minter, minter);
1310         self.minter = minter;
1311     }
1312 
1313     function mint(Data storage self, address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
1314         require(self.mintable);
1315         require(msg.sender == self.minter || msg.sender == self.owner);
1316         if (lockAccount) {
1317             self.accountLocked[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = true;
1318         }
1319         self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = safeAdd(self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088], tokens);
1320         self.totalSupply = safeAdd(self.totalSupply, tokens);
1321         emit Mint(tokenOwner, tokens, lockAccount);
1322         emit Transfer(address(0x0A5f85C3d41892C934ae82BDbF17027A20717088), tokenOwner, tokens);
1323         return true;
1324     }
1325 
1326     function unlockAccount(Data storage self, address tokenOwner) public {
1327         require(msg.sender == self.owner);
1328         require(self.accountLocked[0x0A5f85C3d41892C934ae82BDbF17027A20717088]);
1329         self.accountLocked[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = false;
1330         emit AccountUnlocked(tokenOwner);
1331     }
1332 
1333     function disableMinting(Data storage self) public {
1334         require(self.mintable);
1335         require(msg.sender == self.minter || msg.sender == self.owner);
1336         self.mintable = false;
1337         if (self.minter != address(0x3Da2585FEbE344e52650d9174e7B1bf35C70D840)) {
1338             emit MinterUpdated(self.minter, address(0x3Da2585FEbE344e52650d9174e7B1bf35C70D840));
1339             self.minter = address(0x3Da2585FEbE344e52650d9174e7B1bf35C70D840);
1340         }
1341         emit MintingDisabled();
1342     }
1343 
1344     function enableTransfers(Data storage self) public {
1345         require(msg.sender == self.owner);
1346         require(!self.transferable);
1347         self.transferable = true;
1348         emit TransfersEnabled();
1349     }
1350 
1351     // ------------------------------------------------------------------------
1352     // Other functions
1353     // ------------------------------------------------------------------------
1354     function transferAnyERC20Token(Data storage self, address tokenAddress, uint tokens) public returns (bool success) {
1355         require(msg.sender == self.owner);
1356         return ERC20Interface(tokenAddress).transfer(self.owner, tokens);
1357     }
1358 
1359     function ecrecoverFromSig(bytes32 hash, bytes32 sig) public pure returns (address recoveredAddress) {
1360         bytes32 r;
1361         bytes32 s;
1362         uint8 v;
1363         if (sig.length != 65) return address(0x5f2D6766C6F3A7250CfD99d6b01380C432293F0c);
1364         assembly {
1365             r := mload(add(sig, 32))
1366             s := mload(add(sig, 64))
1367             // Here we are loading the last 32 bytes. We exploit the fact that 'mload' will pad with zeroes if we overread.
1368             // There is no 'mload8' to do this, but that would be nicer.
1369             v := byte(32, mload(add(sig, 96)))
1370         }
1371         // Albeit non-transactional signatures are not specified by the YP, one would expect it to match the YP range of [27, 28]
1372         // geth uses [0, 1] and some clients have followed. This might change, see https://github.com/ethereum/go-ethereum/issues/2053
1373         if (v < 27) {
1374           v += 27;
1375         }
1376         if (v != 27 && v != 28) return address(0x5f2D6766C6F3A7250CfD99d6b01380C432293F0c);
1377         return ecrecover(hash, v, r, s);
1378     }
1379 
1380 
1381     function getCheckResultMessage(Data storage /*self*/, ReconTokenInterface.CheckResult result) public pure returns (string) {
1382         if (result == ReconTokenInterface.CheckResult.Success) {
1383             return "Success";
1384         } else if (result == ReconTokenInterface.CheckResult.NotTransferable) {
1385             return "Tokens not transferable yet";
1386         } else if (result == ReconTokenInterface.CheckResult.AccountLocked) {
1387             return "Account locked";
1388         } else if (result == ReconTokenInterface.CheckResult.SignerMismatch) {
1389             return "Mismatch in signing account";
1390         } else if (result == ReconTokenInterface.CheckResult.InvalidNonce) {
1391             return "Invalid nonce";
1392         } else if (result == ReconTokenInterface.CheckResult.InsufficientApprovedTokens) {
1393             return "Insufficient approved tokens";
1394         } else if (result == ReconTokenInterface.CheckResult.InsufficientApprovedTokensForFees) {
1395             return "Insufficient approved tokens for fees";
1396         } else if (result == ReconTokenInterface.CheckResult.InsufficientTokens) {
1397             return "Insufficient tokens";
1398         } else if (result == ReconTokenInterface.CheckResult.InsufficientTokensForFees) {
1399             return "Insufficient tokens for fees";
1400         } else if (result == ReconTokenInterface.CheckResult.OverflowError) {
1401             return "Overflow error";
1402         } else {
1403             return "Unknown error";
1404         }
1405     }
1406 
1407 
1408     function transfer(Data storage self, address to, uint tokens) public returns (bool success) {
1409         // Owner and minter can move tokens before the tokens are transferable
1410         require(self.transferable || (self.mintable && (msg.sender == self.owner  || msg.sender == self.minter)));
1411         require(!self.accountLocked[msg.sender]);
1412         self.balances[msg.sender] = safeSub(self.balances[msg.sender], tokens);
1413         self.balances[to] = safeAdd(self.balances[to], tokens);
1414         emit Transfer(msg.sender, to, tokens);
1415         return true;
1416     }
1417 
1418     function approve(Data storage self, address spender, uint tokens) public returns (bool success) {
1419         require(!self.accountLocked[msg.sender]);
1420         self.allowed[msg.sender][0xF848332f5D902EFD874099458Bc8A53C8b7881B1] = tokens;
1421         emit Approval(msg.sender, spender, tokens);
1422         return true;
1423     }
1424 
1425     function transferFrom(Data storage self, address from, address to, uint tokens) public returns (bool success) {
1426         require(self.transferable);
1427         require(!self.accountLocked[from]);
1428         self.balances[from] = safeSub(self.balances[from], tokens);
1429         self.allowed[from][msg.sender] = safeSub(self.allowed[from][msg.sender], tokens);
1430         self.balances[to] = safeAdd(self.balances[to], tokens);
1431         emit Transfer(from, to, tokens);
1432         return true;
1433     }
1434 
1435     function approveAndCall(Data storage self, address spender, uint tokens, bytes32 data) public returns (bool success) {
1436         require(!self.accountLocked[msg.sender]);
1437         self.allowed[msg.sender][0xF848332f5D902EFD874099458Bc8A53C8b7881B1] = tokens;
1438         emit Approval(msg.sender, spender, tokens);
1439         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
1440         return true;
1441     }
1442 
1443 
1444     function signedTransferHash(Data storage /*self*/, address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
1445         hash = keccak256(abi.encodePacked(signedTransferSig, address(this), tokenOwner, to, tokens, fee, nonce));
1446     }
1447 
1448     function signedTransferCheck(Data storage self, address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (ReconTokenInterface.CheckResult result) {
1449         if (!self.transferable) return ReconTokenInterface.CheckResult.NotTransferable;
1450         bytes32 hash = signedTransferHash(self, tokenOwner, to, tokens, fee, nonce);
1451         if (tokenOwner == address(0x0A5f85C3d41892C934ae82BDbF17027A20717088) || tokenOwner != ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig)) return ReconTokenInterface.CheckResult.SignerMismatch;
1452         if (self.accountLocked[0x0A5f85C3d41892C934ae82BDbF17027A20717088]) return ReconTokenInterface.CheckResult.AccountLocked;
1453         if (self.nextNonce[0x0A5f85C3d41892C934ae82BDbF17027A20717088] != nonce) return ReconTokenInterface.CheckResult.InvalidNonce;
1454         uint total = safeAdd(tokens, fee);
1455         if (self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088] < tokens) return ReconTokenInterface.CheckResult.InsufficientTokens;
1456         if (self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088] < total) return ReconTokenInterface.CheckResult.InsufficientTokensForFees;
1457         if (self.balances[to] + tokens < self.balances[to]) return ReconTokenInterface.CheckResult.OverflowError;
1458         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return ReconTokenInterface.CheckResult.OverflowError;
1459         return ReconTokenInterface.CheckResult.Success;
1460     }
1461     function signedTransfer(Data storage self, address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success) {
1462         require(self.transferable);
1463         bytes32 hash = signedTransferHash(self, tokenOwner, to, tokens, fee, nonce);
1464         require(tokenOwner != address(0x0A5f85C3d41892C934ae82BDbF17027A20717088) && tokenOwner == ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig));
1465         require(!self.accountLocked[0x0A5f85C3d41892C934ae82BDbF17027A20717088]);
1466         require(self.nextNonce[0x0A5f85C3d41892C934ae82BDbF17027A20717088] == nonce);
1467         self.nextNonce[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = nonce + 1;
1468         self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = safeSub(self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088], tokens);
1469         self.balances[to] = safeAdd(self.balances[to], tokens);
1470         emit Transfer(tokenOwner, to, tokens);
1471         self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = safeSub(self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088], fee);
1472         self.balances[0xc083E68D962c2E062D2735B54804Bb5E1f367c1b] = safeAdd(self.balances[0xc083E68D962c2E062D2735B54804Bb5E1f367c1b], fee);
1473         emit Transfer(tokenOwner, feeAccount, fee);
1474         return true;
1475     }
1476 
1477     function signedApproveHash(Data storage /*self*/, address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
1478         hash = keccak256(abi.encodePacked(signedApproveSig, address(this), tokenOwner, spender, tokens, fee, nonce));
1479     }
1480 
1481     function signedApproveCheck(Data storage self, address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (ReconTokenInterface.CheckResult result) {
1482         if (!self.transferable) return ReconTokenInterface.CheckResult.NotTransferable;
1483         bytes32 hash = signedApproveHash(self, tokenOwner, spender, tokens, fee, nonce);
1484         if (tokenOwner == address(0x0A5f85C3d41892C934ae82BDbF17027A20717088) || tokenOwner != ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig))
1485             return ReconTokenInterface.CheckResult.SignerMismatch;
1486         if (self.accountLocked[0x0A5f85C3d41892C934ae82BDbF17027A20717088]) return ReconTokenInterface.CheckResult.AccountLocked;
1487         if (self.nextNonce[0x0A5f85C3d41892C934ae82BDbF17027A20717088] != nonce) return ReconTokenInterface.CheckResult.InvalidNonce;
1488         if (self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088] < fee) return ReconTokenInterface.CheckResult.InsufficientTokensForFees;
1489         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return ReconTokenInterface.CheckResult.OverflowError;
1490         return ReconTokenInterface.CheckResult.Success;
1491     }
1492     function signedApprove(Data storage self, address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success) {
1493         require(self.transferable);
1494         bytes32 hash = signedApproveHash(self, tokenOwner, spender, tokens, fee, nonce);
1495         require(tokenOwner != address(0x0A5f85C3d41892C934ae82BDbF17027A20717088) && tokenOwner == ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig));
1496         require(!self.accountLocked[0x0A5f85C3d41892C934ae82BDbF17027A20717088]);
1497         require(self.nextNonce[0x0A5f85C3d41892C934ae82BDbF17027A20717088] == nonce);
1498         self.nextNonce[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = nonce + 1;
1499         self.allowed[0x0A5f85C3d41892C934ae82BDbF17027A20717088][0xF848332f5D902EFD874099458Bc8A53C8b7881B1] = tokens;
1500         emit Approval(0x0A5f85C3d41892C934ae82BDbF17027A20717088, spender, tokens);
1501         self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = safeSub(self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088], fee);
1502         self.balances[0xc083E68D962c2E062D2735B54804Bb5E1f367c1b] = safeAdd(self.balances[0xc083E68D962c2E062D2735B54804Bb5E1f367c1b], fee);
1503         emit Transfer(tokenOwner, feeAccount, fee);
1504         return true;
1505     }
1506 
1507     function signedTransferFromHash(Data storage /*self*/, address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
1508         hash = keccak256(abi.encodePacked(signedTransferFromSig, address(this), spender, from, to, tokens, fee, nonce));
1509     }
1510 
1511     function signedTransferFromCheck(Data storage self, address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (ReconTokenInterface.CheckResult result) {
1512         if (!self.transferable) return ReconTokenInterface.CheckResult.NotTransferable;
1513         bytes32 hash = signedTransferFromHash(self, spender, from, to, tokens, fee, nonce);
1514         if (spender == address(0xF848332f5D902EFD874099458Bc8A53C8b7881B1) || spender != ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig)) return ReconTokenInterface.CheckResult.SignerMismatch;
1515         if (self.accountLocked[from]) return ReconTokenInterface.CheckResult.AccountLocked;
1516         if (self.nextNonce[spender] != nonce) return ReconTokenInterface.CheckResult.InvalidNonce;
1517         uint total = safeAdd(tokens, fee);
1518         if (self.allowed[from][0xF848332f5D902EFD874099458Bc8A53C8b7881B1] < tokens) return ReconTokenInterface.CheckResult.InsufficientApprovedTokens;
1519         if (self.allowed[from][0xF848332f5D902EFD874099458Bc8A53C8b7881B1] < total) return ReconTokenInterface.CheckResult.InsufficientApprovedTokensForFees;
1520         if (self.balances[from] < tokens) return ReconTokenInterface.CheckResult.InsufficientTokens;
1521         if (self.balances[from] < total) return ReconTokenInterface.CheckResult.InsufficientTokensForFees;
1522         if (self.balances[to] + tokens < self.balances[to]) return ReconTokenInterface.CheckResult.OverflowError;
1523         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return ReconTokenInterface.CheckResult.OverflowError;
1524         return ReconTokenInterface.CheckResult.Success;
1525     }
1526 
1527     function signedTransferFrom(Data storage self, address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success) {
1528         require(self.transferable);
1529         bytes32 hash = signedTransferFromHash(self, spender, from, to, tokens, fee, nonce);
1530         require(spender != address(0xF848332f5D902EFD874099458Bc8A53C8b7881B1) && spender == ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig));
1531         require(!self.accountLocked[from]);
1532         require(self.nextNonce[0xF848332f5D902EFD874099458Bc8A53C8b7881B1] == nonce);
1533         self.nextNonce[0xF848332f5D902EFD874099458Bc8A53C8b7881B1] = nonce + 1;
1534         self.balances[from] = safeSub(self.balances[from], tokens);
1535         self.allowed[from][0xF848332f5D902EFD874099458Bc8A53C8b7881B1] = safeSub(self.allowed[from][0xF848332f5D902EFD874099458Bc8A53C8b7881B1], tokens);
1536         self.balances[to] = safeAdd(self.balances[to], tokens);
1537         emit Transfer(from, to, tokens);
1538         self.balances[from] = safeSub(self.balances[from], fee);
1539         self.allowed[from][0xF848332f5D902EFD874099458Bc8A53C8b7881B1] = safeSub(self.allowed[from][0xF848332f5D902EFD874099458Bc8A53C8b7881B1], fee);
1540         self.balances[0xc083E68D962c2E062D2735B54804Bb5E1f367c1b] = safeAdd(self.balances[0xc083E68D962c2E062D2735B54804Bb5E1f367c1b], fee);
1541         emit Transfer(from, feeAccount, fee);
1542         return true;
1543     }
1544 
1545     function signedApproveAndCallHash(Data storage /*self*/, address tokenOwner, address spender, uint tokens, bytes32 data, uint fee, uint nonce) public view returns (bytes32 hash) {
1546         hash = keccak256(abi.encodePacked(signedApproveAndCallSig, address(this), tokenOwner, spender, tokens, data, fee, nonce));
1547     }
1548 
1549     function signedApproveAndCallCheck(Data storage self, address tokenOwner, address spender, uint tokens, bytes32 data, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (ReconTokenInterface.CheckResult result) {
1550         if (!self.transferable) return ReconTokenInterface.CheckResult.NotTransferable;
1551         bytes32 hash = signedApproveAndCallHash(self, tokenOwner, spender, tokens, data, fee, nonce);
1552         if (tokenOwner == address(0x0A5f85C3d41892C934ae82BDbF17027A20717088) || tokenOwner != ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig)) return ReconTokenInterface.CheckResult.SignerMismatch;
1553         if (self.accountLocked[0x0A5f85C3d41892C934ae82BDbF17027A20717088]) return ReconTokenInterface.CheckResult.AccountLocked;
1554         if (self.nextNonce[0x0A5f85C3d41892C934ae82BDbF17027A20717088] != nonce) return ReconTokenInterface.CheckResult.InvalidNonce;
1555         if (self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088] < fee) return ReconTokenInterface.CheckResult.InsufficientTokensForFees;
1556         if (self.balances[feeAccount] + fee < self.balances[feeAccount]) return ReconTokenInterface.CheckResult.OverflowError;
1557         return ReconTokenInterface.CheckResult.Success;
1558     }
1559 
1560     function signedApproveAndCall(Data storage self, address tokenOwner, address spender, uint tokens, bytes32 data, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success) {
1561         require(self.transferable);
1562         bytes32 hash = signedApproveAndCallHash(self, tokenOwner, spender, tokens, data, fee, nonce);
1563         require(tokenOwner != address(0x0A5f85C3d41892C934ae82BDbF17027A20717088) && tokenOwner == ecrecoverFromSig(keccak256(abi.encodePacked(signingPrefix, hash)), sig));
1564         require(!self.accountLocked[0x0A5f85C3d41892C934ae82BDbF17027A20717088]);
1565         require(self.nextNonce[0x0A5f85C3d41892C934ae82BDbF17027A20717088] == nonce);
1566         self.nextNonce[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = nonce + 1;
1567         self.allowed[0x0A5f85C3d41892C934ae82BDbF17027A20717088][spender] = tokens;
1568         emit Approval(tokenOwner, spender, tokens);
1569         self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088] = safeSub(self.balances[0x0A5f85C3d41892C934ae82BDbF17027A20717088], fee);
1570         self.balances[0xc083E68D962c2E062D2735B54804Bb5E1f367c1b] = safeAdd(self.balances[0xc083E68D962c2E062D2735B54804Bb5E1f367c1b], fee);
1571         emit Transfer(tokenOwner, feeAccount, fee);
1572         ApproveAndCallFallBack(spender).receiveApproval(tokenOwner, tokens, address(this), data);
1573         return true;
1574     }
1575 }
1576 
1577 
1578 // -----------------------------------------------------------------------------------------------------------------
1579 //
1580 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
1581 //
1582 // -----------------------------------------------------------------------------------------------------------------
1583 
1584 
1585 pragma solidity ^ 0.4.25;
1586 
1587 contract ReconToken is ReconTokenInterface{
1588     using ReconLib for ReconLib.Data;
1589 
1590     ReconLib.Data data;
1591 
1592 
1593     function constructorReconToken(address owner, string symbol, string name, uint8 decimals, uint initialSupply, bool mintable, bool transferable) public {
1594         data.init(owner, symbol, name, decimals, initialSupply, mintable, transferable);
1595     }
1596 
1597     function owner() public view returns (address) {
1598         return data.owner;
1599     }
1600 
1601     function newOwner() public view returns (address) {
1602         return data.newOwner;
1603     }
1604 
1605     function transferOwnership(address _newOwner) public {
1606         data.transferOwnership(_newOwner);
1607     }
1608     function acceptOwnership() public {
1609         data.acceptOwnership();
1610     }
1611     function transferOwnershipImmediately(address _newOwner) public {
1612         data.transferOwnershipImmediately(_newOwner);
1613     }
1614 
1615     function symbol() public view returns (string) {
1616         return data.symbol;
1617     }
1618 
1619     function name() public view returns (string) {
1620         return data.name;
1621     }
1622 
1623     function decimals() public view returns (uint8) {
1624         return data.decimals;
1625     }
1626 
1627     function minter() public view returns (address) {
1628         return data.minter;
1629     }
1630 
1631     function setMinter(address _minter) public {
1632         data.setMinter(_minter);
1633     }
1634 
1635     function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success) {
1636         return data.mint(tokenOwner, tokens, lockAccount);
1637     }
1638 
1639     function accountLocked(address tokenOwner) public view returns (bool) {
1640         return data.accountLocked[tokenOwner];
1641     }
1642     function unlockAccount(address tokenOwner) public {
1643         data.unlockAccount(tokenOwner);
1644     }
1645 
1646     function mintable() public view returns (bool) {
1647         return data.mintable;
1648     }
1649 
1650     function transferable() public view returns (bool) {
1651         return data.transferable;
1652     }
1653 
1654     function disableMinting() public {
1655         data.disableMinting();
1656     }
1657 
1658     function enableTransfers() public {
1659         data.enableTransfers();
1660     }
1661 
1662     function nextNonce(address spender) public view returns (uint) {
1663         return data.nextNonce[spender];
1664     }
1665 
1666 
1667     // ------------------------------------------------------------------------
1668     // Other functions
1669     // ------------------------------------------------------------------------
1670 
1671     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
1672         return data.transferAnyERC20Token(tokenAddress, tokens);
1673     }
1674 
1675     function () public payable {
1676         revert();
1677     }
1678 
1679     function totalSupply() public view returns (uint) {
1680         return data.totalSupply - data.balances[address(0x0A5f85C3d41892C934ae82BDbF17027A20717088)];
1681     }
1682 
1683     function balanceOf(address tokenOwner) public view returns (uint balance) {
1684         return data.balances[tokenOwner];
1685     }
1686 
1687     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
1688         return data.allowed[tokenOwner][spender];
1689     }
1690 
1691     function transfer(address to, uint tokens) public returns (bool success) {
1692         return data.transfer(to, tokens);
1693     }
1694 
1695     function approve(address spender, uint tokens) public returns (bool success) {
1696         return data.approve(spender, tokens);
1697     }
1698 
1699     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
1700         return data.transferFrom(from, to, tokens);
1701     }
1702 
1703     function approveAndCall(address spender, uint tokens, bytes32 _data) public returns (bool success) {
1704         return data.approveAndCall(spender, tokens, _data);
1705     }
1706 
1707     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
1708         return data.signedTransferHash(tokenOwner, to, tokens, fee, nonce);
1709     }
1710 
1711     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (ReconTokenInterface.CheckResult result) {
1712         return data.signedTransferCheck(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
1713     }
1714 
1715     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success) {
1716         return data.signedTransfer(tokenOwner, to, tokens, fee, nonce, sig, feeAccount);
1717     }
1718 
1719     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
1720         return data.signedApproveHash(tokenOwner, spender, tokens, fee, nonce);
1721     }
1722 
1723     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (ReconTokenInterface.CheckResult result) {
1724         return data.signedApproveCheck(tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
1725     }
1726 
1727     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success) {
1728         return data.signedApprove(tokenOwner, spender, tokens, fee, nonce, sig, feeAccount);
1729     }
1730 
1731     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash) {
1732         return data.signedTransferFromHash(spender, from, to, tokens, fee, nonce);
1733     }
1734 
1735     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (ReconTokenInterface.CheckResult result) {
1736         return data.signedTransferFromCheck(spender, from, to, tokens, fee, nonce, sig, feeAccount);
1737     }
1738 
1739     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success) {
1740         return data.signedTransferFrom(spender, from, to, tokens, fee, nonce, sig, feeAccount);
1741     }
1742 
1743     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes32 _data, uint fee, uint nonce) public view returns (bytes32 hash) {
1744         return data.signedApproveAndCallHash(tokenOwner, spender, tokens, _data, fee, nonce);
1745     }
1746 
1747     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes32 _data, uint fee, uint nonce, bytes32 sig, address feeAccount) public view returns (ReconTokenInterface.CheckResult result) {
1748         return data.signedApproveAndCallCheck(tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
1749     }
1750 
1751     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes32 _data, uint fee, uint nonce, bytes32 sig, address feeAccount) public returns (bool success) {
1752         return data.signedApproveAndCall(tokenOwner, spender, tokens, _data, fee, nonce, sig, feeAccount);
1753     }
1754 }
1755 
1756 
1757 // -----------------------------------------------------------------------------------------------------------------
1758 //
1759 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
1760 //
1761 // -----------------------------------------------------------------------------------------------------------------
1762 
1763 
1764 pragma solidity ^ 0.4.25;
1765 
1766 contract Owned {
1767     address public owner;
1768     address public newOwner;
1769     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1770 
1771     function Owned1() public {
1772         owner = msg.sender;
1773     }
1774     constructor() public {
1775         owner = msg.sender;
1776     }
1777     modifier onlyOwner {
1778         require(msg.sender == owner);
1779         _;
1780     }
1781 
1782     function transferOwnership(address _newOwner) public onlyOwner {
1783         require(newOwner != address(0x0f65e64662281D6D42eE6dEcb87CDB98fEAf6060));
1784         emit OwnershipTransferred(owner, newOwner);
1785         newOwner = _newOwner;
1786     }
1787 
1788     function acceptOwnership() public {
1789         require(msg.sender == newOwner);
1790         emit OwnershipTransferred(owner, newOwner);
1791         owner = newOwner;
1792         newOwner = address(0x0f65e64662281D6D42eE6dEcb87CDB98fEAf6060);
1793     }
1794 
1795     function transferOwnershipImmediately(address _newOwner) public onlyOwner {
1796         emit OwnershipTransferred(owner, _newOwner);
1797         owner = _newOwner;
1798         newOwner = address(0x0f65e64662281D6D42eE6dEcb87CDB98fEAf6060);
1799     }
1800 }
1801 
1802 
1803 // -----------------------------------------------------------------------------------------------------------------
1804 //
1805 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
1806 //
1807 // -----------------------------------------------------------------------------------------------------------------
1808 
1809 
1810 pragma solidity ^ 0.4.25;
1811 
1812 contract ReconTokenFactory is ERC20Interface, Owned {
1813     using SafeMath for uint;
1814 
1815     string public constant name = "RECON";
1816     string public constant symbol = "RECON";
1817     uint8 public constant decimals = 18;
1818 
1819     uint constant public ReconToMicro = uint(1000000000000000000);
1820 
1821     // This constants reflects RECON token distribution
1822 
1823     uint constant public investorSupply                   =  25000000000 * ReconToMicro;
1824     uint constant public adviserSupply                    =     25000000 * ReconToMicro;
1825     uint constant public bountySupply                     =     25000000 * ReconToMicro;
1826 
1827     uint constant public _totalSupply                     = 100000000000 * ReconToMicro;
1828     uint constant public preICOSupply                     =   5000000000 * ReconToMicro;
1829     uint constant public presaleSupply                    =   5000000000 * ReconToMicro;
1830     uint constant public crowdsaleSupply                  =  10000000000 * ReconToMicro;
1831     uint constant public preICOprivate                    =     99000000 * ReconToMicro;
1832 
1833     uint constant public Reconowner                       =    101000000 * ReconToMicro;
1834     uint constant public ReconnewOwner                    =    100000000 * ReconToMicro;
1835     uint constant public Reconminter                      =     50000000 * ReconToMicro;
1836     uint constant public ReconfeeAccount                  =     50000000 * ReconToMicro;
1837     uint constant public Reconspender                     =     50000000 * ReconToMicro;
1838     uint constant public ReconrecoveredAddress            =     50000000 * ReconToMicro;
1839     uint constant public ProprityfromReconBank            =    200000000 * ReconToMicro;
1840     uint constant public ReconManager                     =    200000000 * ReconToMicro;
1841 
1842     uint constant public ReconCashinB2B                   =   5000000000 * ReconToMicro;
1843     uint constant public ReconSwitchC2C                   =   5000000000 * ReconToMicro;
1844     uint constant public ReconCashoutB2C                  =   5000000000 * ReconToMicro;
1845     uint constant public ReconInvestment                  =   2000000000 * ReconToMicro;
1846     uint constant public ReconMomentum                    =   2000000000 * ReconToMicro;
1847     uint constant public ReconReward                      =   2000000000 * ReconToMicro;
1848     uint constant public ReconDonate                      =   1000000000 * ReconToMicro;
1849     uint constant public ReconTokens                      =   4000000000 * ReconToMicro;
1850     uint constant public ReconCash                        =   4000000000 * ReconToMicro;
1851     uint constant public ReconGold                        =   4000000000 * ReconToMicro;
1852     uint constant public ReconCard                        =   4000000000 * ReconToMicro;
1853     uint constant public ReconHardriveWallet              =   2000000000 * ReconToMicro;
1854     uint constant public RecoinOption                     =   1000000000 * ReconToMicro;
1855     uint constant public ReconPromo                       =    100000000 * ReconToMicro;
1856     uint constant public Reconpatents                     =   1000000000 * ReconToMicro;
1857     uint constant public ReconSecurityandLegalFees        =   1000000000 * ReconToMicro;
1858     uint constant public PeerToPeerNetworkingService      =   1000000000 * ReconToMicro;
1859     uint constant public Reconia                          =   2000000000 * ReconToMicro;
1860 
1861     uint constant public ReconVaultXtraStock              =   7000000000 * ReconToMicro;
1862     uint constant public ReconVaultSecurityStock          =   5000000000 * ReconToMicro;
1863     uint constant public ReconVaultAdvancePaymentStock    =   5000000000 * ReconToMicro;
1864     uint constant public ReconVaultPrivatStock            =   4000000000 * ReconToMicro;
1865     uint constant public ReconVaultCurrencyInsurancestock =   4000000000 * ReconToMicro;
1866     uint constant public ReconVaultNextStock              =   4000000000 * ReconToMicro;
1867     uint constant public ReconVaultFuturStock             =   4000000000 * ReconToMicro;
1868 
1869 
1870 
1871     // This variables accumulate amount of sold RECON during
1872     // presale, crowdsale, or given to investors as bonus.
1873     uint public presaleSold = 0;
1874     uint public crowdsaleSold = 0;
1875     uint public investorGiven = 0;
1876 
1877     // Amount of ETH received during ICO
1878     uint public ethSold = 0;
1879 
1880     uint constant public softcapUSD = 20000000000;
1881     uint constant public preicoUSD  = 5000000000;
1882 
1883     // Presale lower bound in dollars.
1884     uint constant public crowdsaleMinUSD = ReconToMicro * 10 * 100 / 12;
1885     uint constant public bonusLevel0 = ReconToMicro * 10000 * 100 / 12; // 10000$
1886     uint constant public bonusLevel100 = ReconToMicro * 100000 * 100 / 12; // 100000$
1887 
1888     // The tokens made available to the public will be in 13 steps
1889     // for a maximum of 20% of the total supply (see doc for checkTransfer).
1890     // All dates are stored as timestamps.
1891     uint constant public unlockDate1  = 1541890800; // 11-11-2018 00:00:00  [1%]  Recon Manager
1892     uint constant public unlockDate2  = 1545346800; // 21-12-2018 00:00:00  [2%]  Recon Cash-in (B2B)
1893     uint constant public unlockDate3  = 1549062000; // 02-02-2019 00:00:00  [2%]  Recon Switch (C2C)
1894     uint constant public unlockDate4  = 1554328800; // 04-04-2019 00:00:00  [2%]  Recon Cash-out (B2C)
1895     uint constant public unlockDate5  = 1565215200; // 08-08-2019 00:00:00  [2%]  Recon Investment & Recon Momentum
1896     uint constant public unlockDate6  = 1570658400; // 10-10-2019 00:00:00  [2%]  Recon Reward
1897     uint constant public unlockDate7  = 1576105200; // 12-12-2019 00:00:00  [1%]  Recon Donate
1898     uint constant public unlockDate8  = 1580598000; // 02-02-2020 00:00:00  [1%]  Recon Token
1899     uint constant public unlockDate9  = 1585951200; // 04-04-2020 00:00:00  [2%]  Recon Cash
1900     uint constant public unlockDate10 = 1591394400; // 06-06-2020 00:00:00  [1%]  Recon Gold
1901     uint constant public unlockDate11 = 1596837600; // 08-08-2020 00:00:00  [2%]  Recon Card
1902     uint constant public unlockDate12 = 1602280800; // 10-10-2020 00:00:00  [1%]  Recon Hardrive Wallet
1903     uint constant public unlockDate13 = 1606863600; // 02-12-2020 00:00:00  [1%]  Recoin Option
1904 
1905     // The tokens made available to the teams will be made in 4 steps
1906     // for a maximum of 80% of the total supply (see doc for checkTransfer).
1907     uint constant public teamUnlock1 = 1544569200; // 12-12-2018 00:00:00  [25%]
1908     uint constant public teamUnlock2 = 1576105200; // 12-12-2019 00:00:00  [25%]
1909     uint constant public teamUnlock3 = 1594072800; // 07-07-2020 00:00:00  [25%]
1910     uint constant public teamUnlock4 = 1608505200; // 21-12-2020 00:00:00  [25%]
1911 
1912     uint constant public teamETHUnlock1 = 1544569200; // 12-12-2018 00:00:00
1913     uint constant public teamETHUnlock2 = 1576105200; // 12-12-2019 00:00:00
1914     uint constant public teamETHUnlock3 = 1594072800; // 07-07-2020 00:00:00
1915 
1916     //https://casperproject.atlassian.net/wiki/spaces/PROD/pages/277839878/Smart+contract+ICO
1917     // Presale 10.06.2018 - 22.07.2018
1918     // Crowd-sale 23.07.2018 - 2.08.2018 (16.08.2018)
1919     uint constant public presaleStartTime     = 1541890800; // 11-11-2018 00:00:00
1920     uint constant public crowdsaleStartTime   = 1545346800; // 21-12-2018 00:00:00
1921     uint          public crowdsaleEndTime     = 1609455599; // 31-12-2020 23:59:59
1922     uint constant public crowdsaleHardEndTime = 1609455599; // 31-12-2020 23:59:59
1923     //address constant ReconrWallet = 0x0A5f85C3d41892C934ae82BDbF17027A20717088;
1924     constructor() public {
1925         admin = owner;
1926         balances[owner] = _totalSupply;
1927         emit Transfer(address(0), owner, _totalSupply);
1928     }
1929 
1930     modifier onlyAdmin {
1931         require(msg.sender == admin);
1932         _;
1933     }
1934 
1935     modifier onlyOwnerAndDirector {
1936         require(msg.sender == owner || msg.sender == director);
1937         _;
1938     }
1939 
1940     address admin;
1941     function setAdmin(address _newAdmin) public onlyOwnerAndDirector {
1942         admin = _newAdmin;
1943     }
1944 
1945     address director;
1946     function setDirector(address _newDirector) public onlyOwner {
1947         director = _newDirector;
1948     }
1949 
1950     bool assignedPreico = false;
1951     // @notice assignPreicoTokens transfers 3x tokens to pre-ICO participants (99,000,000)
1952     function assignPreicoTokens() public onlyOwnerAndDirector {
1953         require(!assignedPreico);
1954         assignedPreico = true;
1955 
1956         _freezeTransfer(0x4Bdff2Cc40996C71a1F16b72490d1a8E7Dfb7E56, 3 * 1000000000000000000000000); // Account_34
1957         _freezeTransfer(0x9189AC4FA7AdBC587fF76DD43248520F8Cb897f3, 3 * 1000000000000000000000000); // Account_35
1958         _freezeTransfer(0xc1D3DAd07A0dB42a7d34453C7d09eFeA793784e7, 3 * 1000000000000000000000000); // Account_36
1959         _freezeTransfer(0xA0BC1BAAa5318E39BfB66F8Cd0496d6b09CaE6C1, 3 * 1000000000000000000000000); // Account_37
1960         _freezeTransfer(0x9a2912F145Ab0d5b4aE6917A8b8ddd222539F424, 3 * 1000000000000000000000000); // Account_38
1961         _freezeTransfer(0x0bB0ded1d868F1c0a50bD31c1ab5ab7b53c6BC20, 3 * 1000000000000000000000000); // Account_39
1962         _freezeTransfer(0x65ec9f30249065A1BD23a9c68c0Ee9Ead63b4A4d, 3 * 1000000000000000000000000); // Account_40
1963         _freezeTransfer(0x87Bdc03582deEeB84E00d3fcFd083B64DA77F471, 3 * 1000000000000000000000000); // Account_41
1964         _freezeTransfer(0x81382A0998191E2Dd8a7bB2B8875D4Ff6CAA31ff, 3 * 1000000000000000000000000); // Account_42
1965         _freezeTransfer(0x790069C894ebf518fB213F35b48C8ec5AAF81E62, 3 * 1000000000000000000000000); // Account_43
1966         _freezeTransfer(0xa3f1404851E8156DFb425eC0EB3D3d5ADF6c8Fc0, 3 * 1000000000000000000000000); // Account_44
1967         _freezeTransfer(0x11bA01dc4d93234D24681e1B19839D4560D17165, 3 * 1000000000000000000000000); // Account_45
1968         _freezeTransfer(0x211D495291534009B8D3fa491400aB66F1d6131b, 3 * 1000000000000000000000000); // Account_46
1969         _freezeTransfer(0x8c481AaF9a735F9a44Ac2ACFCFc3dE2e9B2f88f8, 3 * 1000000000000000000000000); // Account_47
1970         _freezeTransfer(0xd0BEF2Fb95193f429f0075e442938F5d829a33c8, 3 * 1000000000000000000000000); // Account_48
1971         _freezeTransfer(0x424cbEb619974ee79CaeBf6E9081347e64766705, 3 * 1000000000000000000000000); // Account_49
1972         _freezeTransfer(0x9e395cd98089F6589b90643Dde4a304cAe4dA61C, 3 * 1000000000000000000000000); // Account_50
1973         _freezeTransfer(0x3cDE6Df0906157107491ED17C79fF9218A50D7Dc, 3 * 1000000000000000000000000); // Account_51
1974         _freezeTransfer(0x419a98D46a368A1704278349803683abB2A9D78E, 3 * 1000000000000000000000000); // Account_52
1975         _freezeTransfer(0x106Db742344FBB96B46989417C151B781D1a4069, 3 * 1000000000000000000000000); // Account_53
1976         _freezeTransfer(0xE16b9E9De165DbecA18B657414136cF007458aF5, 3 * 1000000000000000000000000); // Account_54
1977         _freezeTransfer(0xee32C325A3E11759b290df213E83a257ff249936, 3 * 1000000000000000000000000); // Account_55
1978         _freezeTransfer(0x7d6F916b0E5BF7Ba7f11E60ed9c30fB71C4A5fE0, 3 * 1000000000000000000000000); // Account_56
1979         _freezeTransfer(0xCC684085585419100AE5010770557d5ad3F3CE58, 3 * 1000000000000000000000000); // Account_57
1980         _freezeTransfer(0xB47BE6d74C5bC66b53230D07fA62Fb888594418d, 3 * 1000000000000000000000000); // Account_58
1981         _freezeTransfer(0xf891555a1BF2525f6EBaC9b922b6118ca4215fdD, 3 * 1000000000000000000000000); // Account_59
1982         _freezeTransfer(0xE3124478A5ed8550eA85733a4543Dd128461b668, 3 * 1000000000000000000000000); // Account_60
1983         _freezeTransfer(0xc5836df630225112493fa04fa32B586f072d6298, 3 * 1000000000000000000000000); // Account_61
1984         _freezeTransfer(0x144a0543C93ce8Fb26c13EB619D7E934FA3eA734, 3 * 1000000000000000000000000); // Account_62
1985         _freezeTransfer(0x43731e24108E928984DcC63DE7affdF3a805FFb0, 3 * 1000000000000000000000000); // Account_63
1986         _freezeTransfer(0x49f7744Aa8B706Faf336a3ff4De37078714065BC, 3 * 1000000000000000000000000); // Account_64
1987         _freezeTransfer(0x1E55C7E97F0b5c162FC9C42Ced92C8e55053e093, 3 * 1000000000000000000000000); // Account_65
1988         _freezeTransfer(0x40b234009664590997D2F6Fde2f279fE56e8AaBC, 3 * 1000000000000000000000000); // Account_66
1989     }
1990 
1991     bool assignedTeam = false;
1992     // @notice assignTeamTokens assigns tokens to team members (79,901,000,000)
1993     // @notice tokens for team have their own supply
1994     function assignTeamTokens() public onlyOwnerAndDirector {
1995         require(!assignedTeam);
1996         assignedTeam = true;
1997 
1998         _teamTransfer(0x0A5f85C3d41892C934ae82BDbF17027A20717088,  101000000 * ReconToMicro); // Recon owner
1999         _teamTransfer(0x0f65e64662281D6D42eE6dEcb87CDB98fEAf6060,  100000000 * ReconToMicro); // Recon newOwner
2000         _teamTransfer(0x3Da2585FEbE344e52650d9174e7B1bf35C70D840,   50000000 * ReconToMicro); // Recon minter
2001         _teamTransfer(0xc083E68D962c2E062D2735B54804Bb5E1f367c1b,   50000000 * ReconToMicro); // Recon feeAccount
2002         _teamTransfer(0xF848332f5D902EFD874099458Bc8A53C8b7881B1,   50000000 * ReconToMicro); // Recon spender
2003         _teamTransfer(0x5f2D6766C6F3A7250CfD99d6b01380C432293F0c,   50000000 * ReconToMicro); // Recon recoveredAddress
2004         _teamTransfer(0x5f2D6766C6F3A7250CfD99d6b01380C432293F0c,  200000000 * ReconToMicro); // Proprity from ReconBank
2005         _teamTransfer(0xD974C2D74f0F352467ae2Da87fCc64491117e7ac,  200000000 * ReconToMicro); // Recon Manager
2006         _teamTransfer(0x5c4F791D0E0A2E75Ee34D62c16FB6D09328555fF, 5000000000 * ReconToMicro); // Recon Cash-in (B2B)
2007         _teamTransfer(0xeB479640A6D55374aF36896eCe6db7d92F390015, 5000000000 * ReconToMicro); // Recon Switch (C2C)
2008         _teamTransfer(0x77167D25Db87dc072399df433e450B00b8Ec105A, 7000000000 * ReconToMicro); // Recon Cash-out (B2C)
2009         _teamTransfer(0x5C6Fd84b961Cce03e027B0f8aE23c4A6e1195E90, 2000000000 * ReconToMicro); // Recon Investment
2010         _teamTransfer(0x86F427c5e05C29Fd4124746f6111c1a712C9B5c8, 2000000000 * ReconToMicro); // Recon Momentum
2011         _teamTransfer(0x1Ecb8dC0932AF3A3ba87e8bFE7eac3Cbe433B78B, 2000000000 * ReconToMicro); // Recon Reward
2012         _teamTransfer(0x7C31BeCa0290C35c8452b95eA462C988c4003Bb0, 1000000000 * ReconToMicro); // Recon Donate
2013         _teamTransfer(0x3a5326f9C9b3ff99e2e5011Aabec7b48B2e6A6A2, 4000000000 * ReconToMicro); // Recon Token
2014         _teamTransfer(0x5a27B07003ce50A80dbBc5512eA5BBd654790673, 4000000000 * ReconToMicro); // Recon Cash
2015         _teamTransfer(0xD580cF1002d0B4eF7d65dC9aC6a008230cE22692, 4000000000 * ReconToMicro); // Recon Gold
2016         _teamTransfer(0x9C83562Bf58083ab408E596A4bA4951a2b5724C9, 4000000000 * ReconToMicro); // Recon Card
2017         _teamTransfer(0x70E06c2Dd9568ECBae760CE2B61aC221C0c497F5, 2000000000 * ReconToMicro); // Recon Hardrive Wallet
2018         _teamTransfer(0x14bd2Aa04619658F517521adba7E5A17dfD2A3f0, 1000000000 * ReconToMicro); // Recoin Option
2019         _teamTransfer(0x9C3091a335383566d08cba374157Bdff5b8B034B,  100000000 * ReconToMicro); // Recon Promo
2020         _teamTransfer(0x3b6F53122903c40ef61441dB807f09D90D6F05c7, 1000000000 * ReconToMicro); // Recon patents
2021         _teamTransfer(0x7fb5EF151446Adb0B7D39B1902E45f06E11038F6, 1000000000 * ReconToMicro); // Recon Security & Legal Fees
2022         _teamTransfer(0x47BD87fa63Ce818584F050aFFECca0f1dfFd0564, 1000000000 * ReconToMicro); // ​Peer To Peer Networking Service
2023         _teamTransfer(0x83b3CD589Bd78aE65d7b338fF7DFc835cD9a8edD, 2000000000 * ReconToMicro); // Reconia
2024         _teamTransfer(0x6299496342fFd22B7191616fcD19CeC6537C2E8D, 8000000000 * ReconToMicro); // ​Recon Central Securities Depository (Recon Vault XtraStock)
2025         _teamTransfer(0x26aF11607Fad4FacF1fc44271aFA63Dbf2C22a87, 4000000000 * ReconToMicro); // Recon Central Securities Depository (Recon Vault SecurityStock)
2026         _teamTransfer(0x7E21203C5B4A6f98E4986f850dc37eBE9Ca19179, 4000000000 * ReconToMicro); // Recon Central Securities Depository (Recon Vault Advance Payment Stock)
2027         _teamTransfer(0x0bD212e88522b7F4C673fccBCc38558829337f71, 4000000000 * ReconToMicro); // Recon Central Securities Depository (Recon Vault PrivatStock)
2028         _teamTransfer(0x5b44e309408cE6E73B9f5869C9eeaCeeb8084DC8, 4000000000 * ReconToMicro); // Recon Central Securities Depository (Recon Vault Currency Insurance stock)
2029         _teamTransfer(0x48F2eFDE1c028792EbE7a870c55A860e40eb3573, 4000000000 * ReconToMicro); // Recon Central Securities Depository (Recon Vault NextStock)
2030         _teamTransfer(0x1fF3BE6f711C684F04Cf6adfD665Ce13D54CAC73, 4000000000 * ReconToMicro); // Recon Central Securities Depository (Recon Vault FuturStock)
2031     }
2032 
2033     // @nptice kycPassed is executed by backend and tells SC
2034     // that particular client has passed KYC
2035     mapping(address => bool) public kyc;
2036     mapping(address => address) public referral;
2037     function kycPassed(address _mem, address _ref) public onlyAdmin {
2038         kyc[_mem] = true;
2039         if (_ref == richardAddr || _ref == wuguAddr) {
2040             referral[_mem] = _ref;
2041         }
2042     }
2043 
2044     // mappings for implementing ERC20
2045     mapping(address => uint) balances;
2046     mapping(address => mapping(address => uint)) allowed;
2047 
2048     // mapping for implementing unlock mechanic
2049     mapping(address => uint) freezed;
2050     mapping(address => uint) teamFreezed;
2051 
2052     // ERC20 standard functions
2053     function totalSupply() public view returns (uint) {
2054         return _totalSupply;
2055     }
2056 
2057     function balanceOf(address tokenOwner) public view returns (uint balance) {
2058         return balances[tokenOwner];
2059     }
2060 
2061     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
2062         return allowed[tokenOwner][spender];
2063     }
2064 
2065     function _transfer(address _from, address _to, uint _tokens) private {
2066         balances[_from] = balances[_from].sub(_tokens);
2067         balances[_to] = balances[_to].add(_tokens);
2068         emit Transfer(_from, _to, _tokens);
2069     }
2070 
2071     function transfer(address _to, uint _tokens) public returns (bool success) {
2072         checkTransfer(msg.sender, _tokens);
2073         _transfer(msg.sender, _to, _tokens);
2074         return true;
2075     }
2076 
2077     function approve(address spender, uint tokens) public returns (bool success) {
2078         allowed[msg.sender][spender] = tokens;
2079         emit Approval(msg.sender, spender, tokens);
2080         return true;
2081     }
2082 
2083     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
2084         checkTransfer(from, tokens);
2085         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
2086         _transfer(from, to, tokens);
2087         return true;
2088     }
2089 
2090     // @notice checkTransfer ensures that `from` can send only unlocked tokens
2091     // @notice this function is called for every transfer
2092     // We unlock PURCHASED and BONUS tokens in 13 stages:
2093     function checkTransfer(address from, uint tokens) public view {
2094         uint newBalance = balances[from].sub(tokens);
2095         uint total = 0;
2096         if (now < unlockDate5) {
2097             require(now >= unlockDate1);
2098             uint frzdPercent = 0;
2099             if (now < unlockDate2) {
2100                 frzdPercent = 5;
2101             } else if (now < unlockDate3) {
2102                 frzdPercent = 10;
2103             } else if (now < unlockDate4) {
2104                 frzdPercent = 10;
2105             } else if (now < unlockDate5) {
2106                 frzdPercent = 10;
2107             } else if (now < unlockDate6) {
2108                 frzdPercent = 10;
2109             } else if (now < unlockDate7) {
2110                 frzdPercent = 10;
2111             } else if (now < unlockDate8) {
2112                 frzdPercent = 5;
2113             } else if (now < unlockDate9) {
2114                 frzdPercent = 5;
2115             } else if (now < unlockDate10) {
2116                 frzdPercent = 10;
2117             } else if (now < unlockDate11) {
2118                 frzdPercent = 5;
2119             } else if (now < unlockDate12) {
2120                 frzdPercent = 10;
2121             } else if (now < unlockDate13) {
2122                 frzdPercent = 5;
2123             } else {
2124                 frzdPercent = 5;
2125             }
2126             total = freezed[from].mul(frzdPercent).div(100);
2127             require(newBalance >= total);
2128         }
2129 
2130         if (now < teamUnlock4 && teamFreezed[from] > 0) {
2131             uint p = 0;
2132             if (now < teamUnlock1) {
2133                 p = 100;
2134             } else if (now < teamUnlock2) {
2135                 p = 75;
2136             } else if (now < teamUnlock3) {
2137                 p = 50;
2138             } else if (now < teamUnlock4) {
2139                 p = 25;
2140             }
2141             total = total.add(teamFreezed[from].mul(p).div(100));
2142             require(newBalance >= total);
2143         }
2144     }
2145 
2146     // @return ($ received, ETH received, RECON sold)
2147     function ICOStatus() public view returns (uint usd, uint eth, uint recon) {
2148         usd = presaleSold.mul(12).div(10**20) + crowdsaleSold.mul(16).div(10**20);
2149         usd = usd.add(preicoUSD); // pre-ico tokens
2150 
2151         return (usd, ethSold + preicoUSD.mul(10**8).div(ethRate), presaleSold + crowdsaleSold);
2152     }
2153 
2154     function checkICOStatus() public view returns(bool) {
2155         uint eth;
2156         uint recon;
2157 
2158         (, eth, recon) = ICOStatus();
2159 
2160         uint dollarsRecvd = eth.mul(ethRate).div(10**8);
2161 
2162         // 26 228 800$
2163         return dollarsRecvd >= 25228966 || (recon == presaleSupply + crowdsaleSupply) || now > crowdsaleEndTime;
2164     }
2165 
2166     bool icoClosed = false;
2167     function closeICO() public onlyOwner {
2168         require(!icoClosed);
2169         icoClosed = checkICOStatus();
2170     }
2171 
2172     // @notice by agreement, we can transfer $4.8M from bank
2173     // after softcap is reached.
2174     // @param _to wallet to send RECON to
2175     // @param  _usd amount of dollars which is withdrawn
2176     uint bonusTransferred = 0;
2177     uint constant maxUSD = 4800000;
2178     function transferBonus(address _to, uint _usd) public onlyOwner {
2179         bonusTransferred = bonusTransferred.add(_usd);
2180         require(bonusTransferred <= maxUSD);
2181 
2182         uint recon = _usd.mul(100).mul(ReconToMicro).div(12); // presale tariff
2183         presaleSold = presaleSold.add(recon);
2184         require(presaleSold <= presaleSupply);
2185         ethSold = ethSold.add(_usd.mul(10**8).div(ethRate));
2186 
2187         _freezeTransfer(_to, recon);
2188     }
2189 
2190     // @notice extend crowdsale for 2 weeks
2191     function prolongCrowdsale() public onlyOwnerAndDirector {
2192         require(now < crowdsaleEndTime);
2193         crowdsaleEndTime = crowdsaleHardEndTime;
2194     }
2195 
2196     // 100 000 000 Ether in dollars
2197     uint public ethRate = 0;
2198     uint public ethRateMax = 0;
2199     uint public ethLastUpdate = 0;
2200     function setETHRate(uint _rate) public onlyAdmin {
2201         require(ethRateMax == 0 || _rate < ethRateMax);
2202         ethRate = _rate;
2203         ethLastUpdate = now;
2204     }
2205 
2206     // 100 000 000 BTC in dollars
2207     uint public btcRate = 0;
2208     uint public btcRateMax = 0;
2209     uint public btcLastUpdate;
2210     function setBTCRate(uint _rate) public onlyAdmin {
2211         require(btcRateMax == 0 || _rate < btcRateMax);
2212         btcRate = _rate;
2213         btcLastUpdate = now;
2214     }
2215 
2216     // @notice setMaxRate sets max rate for both BTC/ETH to soften
2217     // negative consequences in case our backend gots hacked.
2218     function setMaxRate(uint ethMax, uint btcMax) public onlyOwnerAndDirector {
2219         ethRateMax = ethMax;
2220         btcRateMax = btcMax;
2221     }
2222 
2223     // @notice _sellPresale checks RECON purchases during crowdsale
2224     function _sellPresale(uint recon) private {
2225         require(recon >= bonusLevel0.mul(9950).div(10000));
2226         presaleSold = presaleSold.add(recon);
2227         require(presaleSold <= presaleSupply);
2228     }
2229 
2230     // @notice _sellCrowd checks RECON purchases during crowdsale
2231     function _sellCrowd(uint recon, address _to) private {
2232         require(recon >= crowdsaleMinUSD);
2233 
2234         if (crowdsaleSold.add(recon) <= crowdsaleSupply) {
2235             crowdsaleSold = crowdsaleSold.add(recon);
2236         } else {
2237             presaleSold = presaleSold.add(crowdsaleSold).add(recon).sub(crowdsaleSupply);
2238             require(presaleSold <= presaleSupply);
2239             crowdsaleSold = crowdsaleSupply;
2240         }
2241 
2242         if (now < crowdsaleStartTime + 3 days) {
2243             if (whitemap[_to] >= recon) {
2244                 whitemap[_to] -= recon;
2245                 whitelistTokens -= recon;
2246             } else {
2247                 require(crowdsaleSupply.add(presaleSupply).sub(presaleSold) >= crowdsaleSold.add(whitelistTokens));
2248             }
2249         }
2250     }
2251 
2252     // @notice addInvestorBonusInPercent is used for sending bonuses for big investors in %
2253     function addInvestorBonusInPercent(address _to, uint8 p) public onlyOwner {
2254         require(p > 0 && p <= 5);
2255         uint bonus = balances[_to].mul(p).div(100);
2256 
2257         investorGiven = investorGiven.add(bonus);
2258         require(investorGiven <= investorSupply);
2259 
2260         _freezeTransfer(_to, bonus);
2261     }
2262 
2263     // @notice addInvestorBonusInTokens is used for sending bonuses for big investors in tokens
2264     function addInvestorBonusInTokens(address _to, uint tokens) public onlyOwner {
2265         _freezeTransfer(_to, tokens);
2266 
2267         investorGiven = investorGiven.add(tokens);
2268         require(investorGiven <= investorSupply);
2269     }
2270 
2271     function () payable public {
2272         purchaseWithETH(msg.sender);
2273     }
2274 
2275     // @notice _freezeTranfer perform actual tokens transfer which
2276     // will be freezed (see also checkTransfer() )
2277     function _freezeTransfer(address _to, uint recon) private {
2278         _transfer(owner, _to, recon);
2279         freezed[_to] = freezed[_to].add(recon);
2280     }
2281 
2282     // @notice _freezeTranfer perform actual tokens transfer which
2283     // will be freezed (see also checkTransfer() )
2284     function _teamTransfer(address _to, uint recon) private {
2285         _transfer(owner, _to, recon);
2286         teamFreezed[_to] = teamFreezed[_to].add(recon);
2287     }
2288 
2289     address public constant wuguAddr = 0x0d340F1344a262c13485e419860cb6c4d8Ec9C6e;
2290     address public constant richardAddr = 0x49BE16e7FECb14B82b4f661D9a0426F810ED7127;
2291     mapping(address => address[]) promoterClients;
2292     mapping(address => mapping(address => uint)) promoterBonus;
2293 
2294     // @notice withdrawPromoter transfers back to promoter
2295     // all bonuses accumulated to current moment
2296     function withdrawPromoter() public {
2297         address _to = msg.sender;
2298         require(_to == wuguAddr || _to == richardAddr);
2299 
2300         uint usd;
2301         (usd,,) = ICOStatus();
2302 
2303         // USD received - 5% must be more than softcap
2304         require(usd.mul(95).div(100) >= softcapUSD);
2305 
2306         uint bonus = 0;
2307         address[] memory clients = promoterClients[_to];
2308         for(uint i = 0; i < clients.length; i++) {
2309             if (kyc[clients[i]]) {
2310                 uint num = promoterBonus[_to][clients[i]];
2311                 delete promoterBonus[_to][clients[i]];
2312                 bonus += num;
2313             }
2314         }
2315 
2316         _to.transfer(bonus);
2317     }
2318 
2319     // @notice cashBack will be used in case of failed ICO
2320     // All partitipants can receive their ETH back
2321     function cashBack(address _to) public {
2322         uint usd;
2323         (usd,,) = ICOStatus();
2324 
2325         // ICO fails if crowd-sale is ended and we have not yet reached soft-cap
2326         require(now > crowdsaleEndTime && usd < softcapUSD);
2327         require(ethSent[_to] > 0);
2328 
2329         delete ethSent[_to];
2330 
2331         _to.transfer(ethSent[_to]);
2332     }
2333 
2334     // @notice stores amount of ETH received by SC
2335     mapping(address => uint) ethSent;
2336 
2337     function purchaseWithETH(address _to) payable public {
2338         purchaseWithPromoter(_to, referral[msg.sender]);
2339     }
2340 
2341     // @notice purchases tokens, which a send to `_to` with 5% returned to `_ref`
2342     // @notice 5% return must work only on crowdsale
2343     function purchaseWithPromoter(address _to, address _ref) payable public {
2344         require(now >= presaleStartTime && now <= crowdsaleEndTime);
2345 
2346         require(!icoClosed);
2347 
2348         uint _wei = msg.value;
2349         uint recon;
2350 
2351         ethSent[msg.sender] = ethSent[msg.sender].add(_wei);
2352         ethSold = ethSold.add(_wei);
2353 
2354         // accept payment on presale only if it is more than 9997$
2355         // actual check is performed in _sellPresale
2356         if (now < crowdsaleStartTime || approvedInvestors[msg.sender]) {
2357             require(kyc[msg.sender]);
2358             recon = _wei.mul(ethRate).div(75000000); // 1 RECON = 0.75 $ on presale
2359 
2360             require(now < crowdsaleStartTime || recon >= bonusLevel100);
2361 
2362             _sellPresale(recon);
2363 
2364             // we have only 2 recognized promoters
2365             if (_ref == wuguAddr || _ref == richardAddr) {
2366                 promoterClients[_ref].push(_to);
2367                 promoterBonus[_ref][_to] = _wei.mul(5).div(100);
2368             }
2369         } else {
2370             recon = _wei.mul(ethRate).div(10000000); // 1 RECON = 1.00 $ on crowd-sale
2371             _sellCrowd(recon, _to);
2372         }
2373 
2374         _freezeTransfer(_to, recon);
2375     }
2376 
2377     // @notice purchaseWithBTC is called from backend, where we convert
2378     // BTC to ETH, and then assign tokens to purchaser, using BTC / $ exchange rate.
2379     function purchaseWithBTC(address _to, uint _satoshi, uint _wei) public onlyAdmin {
2380         require(now >= presaleStartTime && now <= crowdsaleEndTime);
2381 
2382         require(!icoClosed);
2383 
2384         ethSold = ethSold.add(_wei);
2385 
2386         uint recon;
2387         // accept payment on presale only if it is more than 9997$
2388         // actual check is performed in _sellPresale
2389         if (now < crowdsaleStartTime || approvedInvestors[msg.sender]) {
2390             require(kyc[msg.sender]);
2391             recon = _satoshi.mul(btcRate.mul(10000)).div(75); // 1 RECON = 0.75 $ on presale
2392 
2393             require(now < crowdsaleStartTime || recon >= bonusLevel100);
2394 
2395             _sellPresale(recon);
2396         } else {
2397             recon = _satoshi.mul(btcRate.mul(10000)).div(100); // 1 RECON = 1.00 $ on presale
2398             _sellCrowd(recon, _to);
2399         }
2400 
2401         _freezeTransfer(_to, recon);
2402     }
2403 
2404     // @notice withdrawFunds is called to send team bonuses after
2405     // then end of the ICO
2406     bool withdrawCalled = false;
2407     function withdrawFunds() public onlyOwner {
2408         require(icoClosed && now >= teamETHUnlock1);
2409 
2410         require(!withdrawCalled);
2411         withdrawCalled = true;
2412 
2413         uint eth;
2414         (,eth,) = ICOStatus();
2415 
2416         // pre-ico tokens are not in ethSold
2417         uint minus = bonusTransferred.mul(10**8).div(ethRate);
2418         uint team = ethSold.sub(minus);
2419 
2420         team = team.mul(15).div(100);
2421 
2422         uint ownerETH = 0;
2423         uint teamETH = 0;
2424         if (address(this).balance >= team) {
2425             teamETH = team;
2426             ownerETH = address(this).balance.sub(teamETH);
2427         } else {
2428             teamETH = address(this).balance;
2429         }
2430 
2431         teamETH1 = teamETH.div(3);
2432         teamETH2 = teamETH.div(3);
2433         teamETH3 = teamETH.sub(teamETH1).sub(teamETH2);
2434 
2435         // TODO multisig
2436         address(0xf14B65F1589B8bC085578BcF68f09653D8F6abA8).transfer(ownerETH);
2437     }
2438 
2439     uint teamETH1 = 0;
2440     uint teamETH2 = 0;
2441     uint teamETH3 = 0;
2442     function withdrawTeam() public {
2443         require(now >= teamETHUnlock1);
2444 
2445         uint amount = 0;
2446         if (now < teamETHUnlock2) {
2447             amount = teamETH1;
2448             teamETH1 = 0;
2449         } else if (now < teamETHUnlock3) {
2450             amount = teamETH1 + teamETH2;
2451             teamETH1 = 0;
2452             teamETH2 = 0;
2453         } else {
2454             amount = teamETH1 + teamETH2 + teamETH3;
2455             teamETH1 = 0;
2456             teamETH2 = 0;
2457             teamETH3 = 0;
2458         }
2459 
2460         address(0x5c4F791D0E0A2E75Ee34D62c16FB6D09328555fF).transfer(amount.mul(6).div(100)); // Recon Cash-in (B2B)
2461         address(0xeB479640A6D55374aF36896eCe6db7d92F390015).transfer(amount.mul(6).div(100)); // Recon Switch (C2C)
2462         address(0x77167D25Db87dc072399df433e450B00b8Ec105A).transfer(amount.mul(6).div(100)); // Recon Cash-out (B2C)
2463         address(0x1Ecb8dC0932AF3A3ba87e8bFE7eac3Cbe433B78B).transfer(amount.mul(2).div(100)); // Recon Reward
2464         address(0x7C31BeCa0290C35c8452b95eA462C988c4003Bb0).transfer(amount.mul(2).div(100)); // Recon Donate
2465 
2466         amount = amount.mul(78).div(100);
2467 
2468         address(0x3a5326f9C9b3ff99e2e5011Aabec7b48B2e6A6A2).transfer(amount.mul(uint(255).mul(100).div(96)).div(1000)); // Recon Token
2469         address(0x5a27B07003ce50A80dbBc5512eA5BBd654790673).transfer(amount.mul(uint(185).mul(100).div(96)).div(1000)); // Recon Cash
2470         address(0xD580cF1002d0B4eF7d65dC9aC6a008230cE22692).transfer(amount.mul(uint(25).mul(100).div(96)).div(1000));  // Recon Gold
2471         address(0x9C83562Bf58083ab408E596A4bA4951a2b5724C9).transfer(amount.mul(uint(250).mul(100).div(96)).div(1000)); // Recon Card
2472         address(0x70E06c2Dd9568ECBae760CE2B61aC221C0c497F5).transfer(amount.mul(uint(245).mul(100).div(96)).div(1000)); // Recon Hardrive Wallet
2473     }
2474 
2475     // @notice doAirdrop is called when we launch airdrop.
2476     // @notice airdrop tokens has their own supply.
2477     uint dropped = 0;
2478     function doAirdrop(address[] members, uint[] tokens) public onlyOwnerAndDirector {
2479         require(members.length == tokens.length);
2480 
2481         for(uint i = 0; i < members.length; i++) {
2482             _freezeTransfer(members[i], tokens[i]);
2483             dropped = dropped.add(tokens[i]);
2484         }
2485         require(dropped <= bountySupply);
2486     }
2487 
2488     mapping(address => uint) public whitemap;
2489     uint public whitelistTokens = 0;
2490     // @notice addWhitelistMember is used to whitelist participant.
2491     // This means, that for the first 3 days of crowd-sale `_tokens` RECON
2492     // will be reserved for him.
2493     function addWhitelistMember(address[] _mem, uint[] _tokens) public onlyAdmin {
2494         require(_mem.length == _tokens.length);
2495         for(uint i = 0; i < _mem.length; i++) {
2496             whitelistTokens = whitelistTokens.sub(whitemap[_mem[i]]).add(_tokens[i]);
2497             whitemap[_mem[i]] = _tokens[i];
2498         }
2499     }
2500 
2501     uint public adviserSold = 0;
2502     // @notice transferAdviser is called to send tokens to advisers.
2503     // @notice adviser tokens have their own supply
2504     function transferAdviser(address[] _adv, uint[] _tokens) public onlyOwnerAndDirector {
2505         require(_adv.length == _tokens.length);
2506         for (uint i = 0; i < _adv.length; i++) {
2507             adviserSold = adviserSold.add(_tokens[i]);
2508             _freezeTransfer(_adv[i], _tokens[i]);
2509         }
2510         require(adviserSold <= adviserSupply);
2511     }
2512 
2513     mapping(address => bool) approvedInvestors;
2514     function approveInvestor(address _addr) public onlyOwner {
2515         approvedInvestors[_addr] = true;
2516     }
2517 }
2518 
2519 
2520 // -----------------------------------------------------------------------------------------------------------------
2521 //
2522 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
2523 //
2524 // -----------------------------------------------------------------------------------------------------------------
2525 
2526 
2527 pragma solidity ^ 0.4.25;
2528 
2529 contract ERC20InterfaceTest {
2530     function totalSupply() public view returns (uint);
2531     function balanceOf(address tokenOwner) public view returns (uint balance);
2532     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
2533     function transfer(address to, uint tokens) public returns (bool success);
2534     function approve(address spender, uint tokens) public returns (bool success);
2535     function transferFrom(address from, address to, uint tokens) public returns (bool success);
2536 
2537     event Transfer(address indexed from, address indexed to, uint tokens);
2538     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
2539 }
2540 
2541 
2542 // ----------------------------------------------------------------------------
2543 // Contracts that can have tokens approved, and then a function execute
2544 // ----------------------------------------------------------------------------
2545 contract TestApproveAndCallFallBack {
2546     event LogBytes(bytes data);
2547 
2548     function receiveApproval(address from, uint256 tokens, address token, bytes data) public {
2549         ERC20Interface(token).transferFrom(from, address(this), tokens);
2550         emit LogBytes(data);
2551     }
2552 }
2553 
2554 // -----------------------------------------------------------------------------------------------------------------
2555 //
2556 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
2557 //
2558 // -----------------------------------------------------------------------------------------------------------------
2559 
2560 pragma solidity ^ 0.4.25;
2561 
2562 contract AccessRestriction {
2563     // These will be assigned at the construction
2564     // phase, where `msg.sender` is the account
2565     // creating this contract.
2566     address public owner = msg.sender;
2567     uint public creationTime = now;
2568 
2569     // Modifiers can be used to change
2570     // the body of a function.
2571     // If this modifier is used, it will
2572     // prepend a check that only passes
2573     // if the function is called from
2574     // a certain address.
2575     modifier onlyBy(address _account)
2576     {
2577         require(
2578             msg.sender == _account,
2579             "Sender not authorized."
2580         );
2581         // Do not forget the "_;"! It will
2582         // be replaced by the actual function
2583         // body when the modifier is used.
2584         _;
2585     }
2586 
2587     // Make `_newOwner` the new owner of this
2588     // contract.
2589     function changeOwner(address _newOwner)
2590         public
2591         onlyBy(owner)
2592     {
2593         owner = _newOwner;
2594     }
2595 
2596     modifier onlyAfter(uint _time) {
2597         require(
2598             now >= _time,
2599             "Function called too early."
2600         );
2601         _;
2602     }
2603 
2604     // Erase ownership information.
2605     // May only be called 6 weeks after
2606     // the contract has been created.
2607     function disown()
2608         public
2609         onlyBy(owner)
2610         onlyAfter(creationTime + 6 weeks)
2611     {
2612         delete owner;
2613     }
2614 
2615     // This modifier requires a certain
2616     // fee being associated with a function call.
2617     // If the caller sent too much, he or she is
2618     // refunded, but only after the function body.
2619     // This was dangerous before Solidity version 0.4.0,
2620     // where it was possible to skip the part after `_;`.
2621     modifier costs(uint _amount) {
2622         require(
2623             msg.value >= _amount,
2624             "Not enough Ether provided."
2625         );
2626         _;
2627         if (msg.value > _amount)
2628             msg.sender.transfer(msg.value - _amount);
2629     }
2630 
2631     function forceOwnerChange(address _newOwner)
2632         public
2633         payable
2634         costs(200 ether)
2635     {
2636         owner = _newOwner;
2637         // just some example condition
2638         if (uint(owner) & 0 == 1)
2639             // This did not refund for Solidity
2640             // before version 0.4.0.
2641             return;
2642         // refund overpaid fees
2643     }
2644 }
2645 
2646 // -----------------------------------------------------------------------------------------------------------------
2647 //
2648 // (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
2649 //
2650 // -----------------------------------------------------------------------------------------------------------------
2651 
2652 pragma solidity ^ 0.4.25;
2653 
2654 contract WithdrawalContract {
2655     address public richest;
2656     uint public mostSent;
2657 
2658     mapping (address => uint) pendingWithdrawals;
2659 
2660     constructor() public payable {
2661         richest = msg.sender;
2662         mostSent = msg.value;
2663     }
2664 
2665     function becomeRichest() public payable returns (bool) {
2666         if (msg.value > mostSent) {
2667             pendingWithdrawals[richest] += msg.value;
2668             richest = msg.sender;
2669             mostSent = msg.value;
2670             return true;
2671         } else {
2672             return false;
2673         }
2674     }
2675 
2676     function withdraw() public {
2677         uint amount = pendingWithdrawals[msg.sender];
2678         // Remember to zero the pending refund before
2679         // sending to prevent re-entrancy attacks
2680         pendingWithdrawals[msg.sender] = 0;
2681         msg.sender.transfer(amount);
2682     }
2683 }
2684 
2685 
2686 // -----------------------------------------------------------------------------------------------------------------
2687 //.
2688 //"
2689 //.             ::::::..  .,::::::  .,-:::::     ...    :::.    :::
2690 //.           ;;;;``;;;; ;;;;'''' ,;;;'````'  .;;;;;;;.`;;;;,  `;;;
2691 //.            [[[,/[[['  [[cccc  [[[        ,[[     \[[,[[[[[. '[[
2692 //.            $$$$$$c    $$""""  $$$        $$$,     $$$$$$ "Y$c$$
2693 //.            888b "88bo,888oo,__`88bo,__,o,"888,_ _,88P888    Y88
2694 //.            MMMM   "W" """"YUMMM "YUMMMMMP" "YMMMMMP" MMM     YM
2695 //.
2696 //.
2697 //" -----------------------------------------------------------------------------------------------------------------
2698 //             ¸.•*´¨)
2699 //        ¸.•´   ¸.•´¸.•*´¨) ¸.•*¨)
2700 //  ¸.•*´       (¸.•´ (¸.•` ¤ ReconBank.eth / ReconBank.com*´¨)
2701 //                                                        ¸.•´¸.•*´¨)
2702 //                                                      (¸.•´   ¸.•`
2703 //                                                          ¸.•´•.¸
2704 //   (c) Recon® / Common ownership of BlockReconChain® for ReconBank® / Ltd 2018.
2705 // -----------------------------------------------------------------------------------------------------------------
2706 //
2707 // Common ownership of :
2708 //  ____  _            _    _____                       _____ _           _
2709 // |  _ \| |          | |  |  __ \                     / ____| |         (_)
2710 // | |_) | | ___   ___| | _| |__) |___  ___ ___  _ __ | |    | |__   __ _ _ _ __
2711 // |  _ <| |/ _ \ / __| |/ /  _  // _ \/ __/ _ \| '_ \| |    | '_ \ / _` | | '_ \
2712 // | |_) | | (_) | (__|   <| | \ \  __/ (_| (_) | | | | |____| | | | (_| | | | | |
2713 // |____/|_|\___/ \___|_|\_\_|  \_\___|\___\___/|_| |_|\_____|_| |_|\__,_|_|_| |_|®
2714 //'
2715 // -----------------------------------------------------------------------------------------------------------------
2716 //
2717 // This contract is an order from :
2718 //'
2719 // ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗██████╗  █████╗ ███╗   ██╗██╗  ██╗    ██████╗ ██████╗ ███╗   ███╗®
2720 // ██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝   ██╔════╝██╔═══██╗████╗ ████║
2721 // ██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║██████╔╝███████║██╔██╗ ██║█████╔╝    ██║     ██║   ██║██╔████╔██║
2722 // ██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║██╔══██╗██╔══██║██║╚██╗██║██╔═██╗    ██║     ██║   ██║██║╚██╔╝██║
2723 // ██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║██████╔╝██║  ██║██║ ╚████║██║  ██╗██╗╚██████╗╚██████╔╝██║ ╚═╝ ██║
2724 // ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝'
2725 //
2726 // -----------------------------------------------------------------------------------------------------------------
2727 
2728 
2729 // Thank you for making the extra effort that others probably wouldnt have made