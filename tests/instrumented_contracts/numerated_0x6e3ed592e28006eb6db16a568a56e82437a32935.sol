1 pragma solidity ^0.4.8;
2 
3 /// @title Oracle contract where m of n predetermined voters determine a value
4 contract FederatedOracleBytes8 {
5     struct Voter {
6         bool isVoter;
7         bool hasVoted;
8     }
9 
10     event VoterAdded(address account);
11     event VoteSubmitted(address account, bytes8 value);
12     event ValueFinalized(bytes8 value);
13 
14     mapping(address => Voter) public voters;
15     mapping(bytes8 => uint8) public votes;
16 
17     uint8 public m;
18     uint8 public n;
19     bytes8 public finalValue;
20 
21     uint8 private voterCount;
22     address private creator;
23 
24     function FederatedOracleBytes8(uint8 m_, uint8 n_) {
25         creator = msg.sender;
26         m = m_;
27         n = n_;
28     }
29 
30     function addVoter(address account) {
31         if (msg.sender != creator) {
32             throw;
33         }
34         if (voterCount == n) {
35             throw;
36         }
37 
38         var voter = voters[account];
39         if (voter.isVoter) {
40             throw;
41         }
42 
43         voter.isVoter = true;
44         voterCount++;
45         VoterAdded(account);
46     }
47 
48     function submitValue(bytes8 value) {
49         var voter = voters[msg.sender];
50         if (!voter.isVoter) {
51             throw;
52         }
53         if (voter.hasVoted) {
54             throw;
55         }
56 
57         voter.hasVoted = true;
58         votes[value]++;
59         VoteSubmitted(msg.sender, value);
60 
61         if (votes[value] == m) {
62             finalValue = value;
63             ValueFinalized(value);
64         }
65     }
66 }
67 
68 // This library can be used to score byte brackets. Byte brackets are a succinct encoding of a
69 // 64 team bracket into an 8-byte array. The tournament results are encoded in the same format and
70 // compared against the bracket picks. To reduce the computation time of scoring a bracket, a 64-bit
71 // value called the "scoring mask" is first computed once for a particular result set and used to
72 // score all brackets.
73 //
74 // Algorithm description: https://drive.google.com/file/d/0BxHbbgrucCx2N1MxcnA1ZE1WQW8/view
75 // Reference implementation: https://gist.github.com/pursuingpareto/b15f1197d96b1a2bbc48
76 library ByteBracket {
77     function getBracketScore(bytes8 bracket, bytes8 results, uint64 filter)
78         constant
79         returns (uint8 points)
80     {
81         uint8 roundNum = 0;
82         uint8 numGames = 32;
83         uint64 blacklist = (uint64(1) << numGames) - 1;
84         uint64 overlap = uint64(~(bracket ^ results));
85 
86         while (numGames > 0) {
87             uint64 scores = overlap & blacklist;
88             points += popcount(scores) << roundNum;
89             blacklist = pairwiseOr(scores & filter);
90             overlap >>= numGames;
91             filter >>= numGames;
92             numGames /= 2;
93             roundNum++;
94         }
95     }
96 
97     function getScoringMask(bytes8 results) constant returns (uint64 mask) {
98         // Filter for the second most significant bit since MSB is ignored.
99         bytes8 bitSelector = 1 << 62;
100         for (uint i = 0; i < 31; i++) {
101             mask <<= 2;
102             if (results & bitSelector != 0) {
103                 mask |= 1;
104             } else {
105                 mask |= 2;
106             }
107             results <<= 1;
108         }
109     }
110 
111     // Returns a bitstring of half the length by taking bits two at a time and ORing them.
112     //
113     // Separates the even and odd bits by repeatedly
114     // shuffling smaller segments of a bitstring.
115     function pairwiseOr(uint64 bits) internal returns (uint64) {
116         uint64 tmp;
117         tmp = (bits ^ (bits >> 1)) & 0x22222222;
118         bits ^= (tmp ^ (tmp << 1));
119         tmp = (bits ^ (bits >> 2)) & 0x0c0c0c0c;
120         bits ^= (tmp ^ (tmp << 2));
121         tmp = (bits ^ (bits >> 4)) & 0x00f000f0;
122         bits ^= (tmp ^ (tmp << 4));
123         tmp = (bits ^ (bits >> 8)) & 0x0000ff00;
124         bits ^= (tmp ^ (tmp << 8));
125         uint64 evens = bits >> 16;
126         uint64 odds = bits % 0x10000;
127         return evens | odds;
128     }
129 
130     // Counts the number of 1s in a bitstring.
131     function popcount(uint64 bits) internal returns (uint8) {
132         bits -= (bits >> 1) & 0x5555555555555555;
133         bits = (bits & 0x3333333333333333) + ((bits >> 2) & 0x3333333333333333);
134         bits = (bits + (bits >> 4)) & 0x0f0f0f0f0f0f0f0f;
135         return uint8(((bits * 0x0101010101010101) & 0xffffffffffffffff) >> 56);
136     }
137 }
138 
139 /**
140  * @title March Madness bracket pool smart contract
141  *
142  * The contract has four phases: submission, tournament, scoring, then the contest is over. During
143  * the submission phase, entrants submit a cryptographic commitment to their bracket picks. Each
144  * address may only make one submission. Entrants may reveal their brackets at any time after making
145  * the commitment. Once the tournament starts, no further submissions are allowed. When the
146  * tournament ends, the results are submitted by the oracles and the scoring period begins. During
147  * the scoring period, entrants may reveal their bracket picks and score their brackets. The highest
148  * scoring bracket revealed is recorded. After the scoring period ends, all entrants with a highest
149  * scoring bracket split the pot and may withdraw their winnings.
150  *
151  * In the event that the oracles do not submit results or fail to reach consensus after a certain
152  * amount of time, entry fees will be returned to entrants.
153  */
154 contract MarchMadness {
155     struct Submission {
156         bytes32 commitment;
157         bytes8 bracket;
158         uint8 score;
159         bool collectedWinnings;
160         bool collectedEntryFee;
161     }
162 
163     event SubmissionAccepted(address account);
164     event NewWinner(address winner, uint8 score);
165     event TournamentOver();
166 
167     FederatedOracleBytes8 resultsOracle;
168 
169 	mapping(address => Submission) submissions;
170 
171     // Amount that winners will collect
172     uint public winnings;
173 
174     // Number of submissions with a winning score
175     uint public numWinners;
176 
177     // Data derived from results used by bracket scoring algorithm
178     uint64 private scoringMask;
179 
180     // Fee in wei required to enter a bracket
181     uint public entryFee;
182 
183     // Duration in seconds of the scoring phase
184     uint public scoringDuration;
185 
186     // Timestamp of the start of the tournament phase
187     uint public tournamentStartTime;
188 
189     // In case the oracles fail to submit the results or reach consensus, the amount of time after
190     // the tournament has started after which to return entry fees to users.
191     uint public noContestTime;
192 
193     // Timestamp of the end of the scoring phase
194     uint public contestOverTime;
195 
196     // Byte bracket representation of the tournament results
197     bytes8 public results;
198 
199     // The highest score of a bracket scored so far
200     uint8 public winningScore;
201 
202     // The maximum allowed number of submissions
203     uint32 public maxSubmissions;
204 
205     // The number of brackets submitted so far
206     uint32 public numSubmissions;
207 
208     // IPFS hash of JSON file containing tournament information (eg. teams, regions, etc)
209     string public tournamentDataIPFSHash;
210 
211 	function MarchMadness(
212         uint entryFee_,
213         uint tournamentStartTime_,
214         uint noContestTime_,
215         uint scoringDuration_,
216         uint32 maxSubmissions_,
217         string tournamentDataIPFSHash_,
218         address oracleAddress
219     ) {
220 		entryFee = entryFee_;
221         tournamentStartTime = tournamentStartTime_;
222         scoringDuration = scoringDuration_;
223         noContestTime = noContestTime_;
224         maxSubmissions = maxSubmissions_;
225         tournamentDataIPFSHash = tournamentDataIPFSHash_;
226         resultsOracle = FederatedOracleBytes8(oracleAddress);
227 	}
228 
229     function submitBracket(bytes32 commitment) payable {
230         if (msg.value != entryFee) {
231             throw;
232         }
233         if (now >= tournamentStartTime) {
234             throw;
235         }
236         if (numSubmissions >= maxSubmissions) {
237             throw;
238         }
239 
240         var submission = submissions[msg.sender];
241         if (submission.commitment != 0) {
242             throw;
243         }
244 
245         submission.commitment = commitment;
246         numSubmissions++;
247         SubmissionAccepted(msg.sender);
248     }
249 
250     function startScoring() returns (bool) {
251         if (results != 0) {
252             return false;
253         }
254         if (now < tournamentStartTime) {
255             return false;
256         }
257         if (now > noContestTime) {
258             return false;
259         }
260 
261         bytes8 oracleValue = resultsOracle.finalValue();
262         if (oracleValue == 0) {
263             return false;
264         }
265 
266         results = oracleValue;
267         scoringMask = ByteBracket.getScoringMask(results);
268         contestOverTime = now + scoringDuration;
269         TournamentOver();
270         return true;
271     }
272 
273     function revealBracket(bytes8 bracket, bytes16 salt) returns (bool) {
274         var submission = submissions[msg.sender];
275         if (sha3(msg.sender, bracket, salt) != submission.commitment) {
276             return false;
277         }
278 
279         submission.bracket = bracket;
280         return true;
281     }
282 
283     function scoreBracket(address account) returns (bool) {
284         if (results == 0) {
285             return false;
286         }
287         if (now >= contestOverTime) {
288             return false;
289         }
290 
291         var submission = submissions[account];
292         if (submission.bracket == 0) {
293             return false;
294         }
295         if (submission.score != 0) {
296             return false;
297         }
298 
299         submission.score = ByteBracket.getBracketScore(submission.bracket, results, scoringMask);
300 
301         if (submission.score > winningScore) {
302             winningScore = submission.score;
303             numWinners = 0;
304         }
305         if (submission.score == winningScore) {
306             numWinners++;
307             winnings = this.balance / numWinners;
308             NewWinner(account, submission.score);
309         }
310 
311         return true;
312     }
313 
314     function collectWinnings() returns (bool) {
315         if (now < contestOverTime) {
316             return false;
317         }
318 
319         var submission = submissions[msg.sender];
320         if (submission.score != winningScore) {
321             return false;
322         }
323         if (submission.collectedWinnings) {
324             return false;
325         }
326 
327         submission.collectedWinnings = true;
328 
329         if (!msg.sender.send(winnings)) {
330             throw;
331         }
332 
333         return true;
334     }
335 
336     function collectEntryFee() returns (bool) {
337         if (now < noContestTime) {
338             return false;
339         }
340         if (results != 0) {
341             return false;
342         }
343 
344         var submission = submissions[msg.sender];
345         if (submission.commitment == 0) {
346             return false;
347         }
348         if (submission.collectedEntryFee) {
349             return false;
350         }
351 
352         submission.collectedEntryFee = true;
353 
354         if (!msg.sender.send(entryFee)) {
355             throw;
356         }
357 
358         return true;
359     }
360 
361     function getBracketScore(bytes8 bracket) constant returns (uint8) {
362         if (results == 0) {
363             throw;
364         }
365         return ByteBracket.getBracketScore(bracket, results, scoringMask);
366     }
367 
368     function getBracket(address account) constant returns (bytes8) {
369         return submissions[account].bracket;
370     }
371 
372     function getScore(address account) constant returns (uint8) {
373         return submissions[account].score;
374     }
375 
376     function getCommitment(address account) constant returns (bytes32) {
377         return submissions[account].commitment;
378     }
379 
380     function hasCollectedWinnings(address account) constant returns (bool) {
381         return submissions[account].collectedWinnings;
382     }
383 }