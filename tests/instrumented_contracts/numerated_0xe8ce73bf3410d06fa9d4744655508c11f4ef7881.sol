1 pragma solidity ^0.4.19;
2 
3 
4 //
5 // SVLightBallotBox
6 // Single use contract to manage a ballot
7 // Author: Max Kaye <max@secure.vote>
8 // (c) SecureVote 2018
9 //
10 // Architecture:
11 // * Ballot authority declares public key with which to encrypt ballots (optional - stored in ballot spec)
12 // * Users submit encrypted or plaintext ballots as blobs (dependent on above)
13 // * These ballots are tracked by the ETH address of the sender
14 // * Following the conclusion of the ballot, the secret key is provided
15 //   by the ballot authority, and all users may transparently and
16 //   independently validate the results
17 //
18 // Notes:
19 // * Since ballots are encrypted the only validation we can do is length, but UI takes care of most of the rest
20 //
21 
22 
23 contract SVLightBallotBox {
24     //// ** Storage Variables
25 
26     // Std owner pattern
27     address public owner;
28 
29     // test mode - operations like changing start/end times
30     bool public testMode = false;
31 
32     // struct for ballot
33     struct Ballot {
34         bytes32 ballotData;
35         address sender;
36         // we use a uint32 here because addresses are 20 bytes and this might help
37         // solidity pack the block number well. gives us a little room to expand too if needed.
38         uint32 blockN;
39     }
40 
41     // Maps to store ballots, along with corresponding log of voters.
42     // Should only be modified through `addBallotAndVoter` internal function
43     mapping (uint256 => Ballot) public ballotMap;
44     mapping (uint256 => bytes32) public associatedPubkeys;
45     uint256 public nVotesCast = 0;
46 
47     // Use a map for voters to look up their ballot
48     mapping (address => uint256) public voterToBallotID;
49 
50     // NOTE - We don't actually want to include the PublicKey because _it's included in the ballotSpec_.
51     // It's better to ensure ppl actually have the ballot spec by not including it in the contract.
52     // Plus we're already storing the hash of the ballotSpec anyway...
53 
54     // Private key to be set after ballot conclusion - curve25519
55     bytes32 public ballotEncryptionSeckey;
56     bool seckeyRevealed = false;
57 
58     // Timestamps for start and end of ballot (UTC)
59     uint64 public startTime;
60     uint64 public endTime;
61     uint64 public creationBlock;
62     uint64 public startingBlockAround;
63 
64     // specHash by which to validate the ballots integrity
65     bytes32 public specHash;
66     bool public useEncryption;
67 
68     // deprecation flag - doesn't actually do anything besides signal that this contract is deprecated;
69     bool public deprecated = false;
70 
71     //// ** Events
72     event CreatedBallot(address _creator, uint64[2] _openPeriod, bool _useEncryption, bytes32 _specHash);
73     event SuccessfulPkVote(address voter, bytes32 ballot, bytes32 pubkey);
74     event SuccessfulVote(address voter, bytes32 ballot);
75     event SeckeyRevealed(bytes32 secretKey);
76     event TestingEnabled();
77     event Error(string error);
78     event DeprecatedContract();
79     event SetOwner(address _owner);
80 
81 
82     //// ** Modifiers
83 
84     modifier onlyOwner {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     modifier ballotOpen {
90         require(uint64(block.timestamp) >= startTime && uint64(block.timestamp) < endTime);
91         _;
92     }
93 
94     modifier onlyTesting {
95         require(testMode);
96         _;
97     }
98 
99     modifier isTrue(bool _b) {
100         require(_b == true);
101         _;
102     }
103 
104     modifier isFalse(bool _b) {
105         require(_b == false);
106         _;
107     }
108 
109     //// ** Functions
110 
111     uint16 constant F_USE_ENC = 0;
112     uint16 constant F_TESTING = 1;
113     // Constructor function - init core params on deploy
114     // timestampts are uint64s to give us plenty of room for millennia
115     // flags are [_useEncryption, enableTesting]
116     function SVLightBallotBox(bytes32 _specHash, uint64[2] openPeriod, bool[2] flags) public {
117         owner = msg.sender;
118 
119         // take the max of the start time provided and the blocks timestamp to avoid a DoS against recent token holders
120         // (which someone might be able to do if they could set the timestamp in the past)
121         startTime = max(openPeriod[0], uint64(block.timestamp));
122         endTime = openPeriod[1];
123         useEncryption = flags[F_USE_ENC];
124         specHash = _specHash;
125         creationBlock = uint64(block.number);
126         // add a rough prediction of what block is the starting block
127         startingBlockAround = uint64((startTime - block.timestamp) / 15 + block.number);
128 
129         if (flags[F_TESTING]) {
130             testMode = true;
131             TestingEnabled();
132         }
133 
134         CreatedBallot(msg.sender, [startTime, endTime], useEncryption, specHash);
135     }
136 
137     // Ballot submission
138     function submitBallotWithPk(bytes32 encryptedBallot, bytes32 senderPubkey) isTrue(useEncryption) ballotOpen public {
139         addBallotAndVoterWithPk(encryptedBallot, senderPubkey);
140         SuccessfulPkVote(msg.sender, encryptedBallot, senderPubkey);
141     }
142 
143     function submitBallotNoPk(bytes32 ballot) isFalse(useEncryption) ballotOpen public {
144         addBallotAndVoterNoPk(ballot);
145         SuccessfulVote(msg.sender, ballot);
146     }
147 
148     // Internal function to ensure atomicity of voter log
149     function addBallotAndVoterWithPk(bytes32 encryptedBallot, bytes32 senderPubkey) internal {
150         uint256 ballotNumber = addBallotAndVoterNoPk(encryptedBallot);
151         associatedPubkeys[ballotNumber] = senderPubkey;
152     }
153 
154     function addBallotAndVoterNoPk(bytes32 encryptedBallot) internal returns (uint256) {
155         uint256 ballotNumber = nVotesCast;
156         ballotMap[ballotNumber] = Ballot(encryptedBallot, msg.sender, uint32(block.number));
157         voterToBallotID[msg.sender] = ballotNumber;
158         nVotesCast += 1;
159         return ballotNumber;
160     }
161 
162     // Allow the owner to reveal the secret key after ballot conclusion
163     function revealSeckey(bytes32 _secKey) onlyOwner public {
164         require(block.timestamp > endTime);
165 
166         ballotEncryptionSeckey = _secKey;
167         seckeyRevealed = true; // this flag allows the contract to be locked
168         SeckeyRevealed(_secKey);
169     }
170 
171     function getEncSeckey() public constant returns (bytes32) {
172         return ballotEncryptionSeckey;
173     }
174 
175     // Test functions
176     function setEndTime(uint64 newEndTime) onlyTesting onlyOwner public {
177         endTime = newEndTime;
178     }
179 
180     function setDeprecated() onlyOwner public {
181         deprecated = true;
182         DeprecatedContract();
183     }
184 
185     function setOwner(address newOwner) onlyOwner public {
186         owner = newOwner;
187         SetOwner(newOwner);
188     }
189 
190     // utils
191     function max(uint64 a, uint64 b) pure internal returns(uint64) {
192         if (a > b) {
193             return a;
194         }
195         return b;
196     }
197 }
198 
199 
200 //
201 // The Index by which democracies and ballots are tracked (and optionally deployed).
202 // Author: Max Kaye <max@secure.vote>
203 // (c) SecureVote 2018
204 //
205 
206 contract SVLightIndexShim {
207 
208     address public owner;
209 
210     struct Ballot {
211         bytes32 specHash;
212         bytes32 extraData;
213         address votingContract;
214         uint64 startTs;
215     }
216 
217     struct Democ {
218         string name;
219         address admin;
220         Ballot[] ballots;
221     }
222 
223     mapping (bytes32 => Democ) public democs;
224     bytes32[] public democList;
225 
226     bool public paymentEnabled = false;
227 
228     SVLightIndexShim prevIndex;
229 
230     //* EVENTS /
231 
232     event PaymentMade(uint128[2] valAndRemainder);
233     event DemocInit(string name, bytes32 democHash, address admin);
234     event BallotInit(bytes32 specHash, uint64[2] openPeriod, bool[2] flags);
235     event BallotAdded(bytes32 democHash, bytes32 specHash, bytes32 extraData, address votingContract);
236     event SetFees(uint128[2] _newFees);
237     event PaymentEnabled(bool _feeEnabled);
238 
239     //* MODIFIERS /
240 
241     modifier onlyBy(address _account) {
242         require(msg.sender == _account);
243         _;
244     }
245 
246     //* FUNCTIONS /
247 
248 
249     // constructor
250     constructor(SVLightIndexShim _prevIndex) public {
251         owner = msg.sender;
252         prevIndex = _prevIndex;
253 
254         bytes32 democHash;
255         bytes32 specHash;
256         bytes32 extraData;
257         address votingContract;
258         uint64 startTime;
259 
260         for (uint i = 0; i < prevIndex.nDemocs(); i++) {
261             democHash = prevIndex.democList(i);
262             democList.push(democHash);
263             // only democracies are SWM
264             democs[democHash].admin = msg.sender;
265 
266             for (uint j = 0; j < prevIndex.nBallots(democHash); j++) {
267                 (specHash, extraData, votingContract, startTime) = prevIndex.getNthBallot(democHash, j);
268                 democs[democHash].ballots.push(Ballot(specHash, extraData, votingContract, startTime));
269             }
270         }
271     }
272 
273     //* GLOBAL INFO */
274 
275     function nDemocs() public constant returns (uint256) {
276         return democList.length;
277     }
278 
279     //* PAYMENT AND OWNER FUNCTIONS */
280 
281     function setOwner(address _owner) onlyBy(owner) public {
282         owner = _owner;
283     }
284 
285     function setDemocAdminEmergency(bytes32 democHash, address newAdmin) onlyBy(owner) public {
286         democs[democHash].admin = newAdmin;
287     }
288 
289     //* DEMOCRACY FUNCTIONS - INDIVIDUAL */
290 
291     function getDemocInfo(bytes32 democHash) public constant returns (string name, address admin, uint256 nBallots) {
292         // only democs are SWM Gov democs
293         return ("SWM Governance", democs[democHash].admin, democs[democHash].ballots.length);
294     }
295 
296     function setAdmin(bytes32 democHash, address newAdmin) onlyBy(democs[democHash].admin) public {
297         democs[democHash].admin = newAdmin;
298     }
299 
300     function nBallots(bytes32 democHash) public constant returns (uint256) {
301         return democs[democHash].ballots.length;
302     }
303 
304     function getNthBallot(bytes32 democHash, uint256 n) public constant returns (bytes32 specHash, bytes32 extraData, address votingContract, uint64 startTime) {
305         return (democs[democHash].ballots[n].specHash, democs[democHash].ballots[n].extraData, democs[democHash].ballots[n].votingContract, democs[democHash].ballots[n].startTs);
306     }
307 
308     //* ADD BALLOT TO RECORD */
309 
310     function _commitBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, address votingContract, uint64 startTs) internal {
311         democs[democHash].ballots.push(Ballot(specHash, extraData, votingContract, startTs));
312         BallotAdded(democHash, specHash, extraData, votingContract);
313     }
314 
315     function addBallot(bytes32 democHash, bytes32 extraData, address votingContract)
316                       onlyBy(democs[democHash].admin)
317                       public
318                       {
319         SVLightBallotBox bb = SVLightBallotBox(votingContract);
320         bytes32 specHash = bb.specHash();
321         uint64 startTs = bb.startTime();
322         _commitBallot(democHash, specHash, extraData, votingContract, startTs);
323     }
324 
325     function deployBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData,
326                           uint64[2] openPeriod, bool[2] flags)
327                           onlyBy(democs[democHash].admin)
328                           public payable {
329         // the start time is max(startTime, block.timestamp) to avoid a DoS whereby a malicious electioneer could disenfranchise
330         // token holders who have recently acquired tokens.
331         uint64 startTs = max(openPeriod[0], uint64(block.timestamp));
332         SVLightBallotBox votingContract = new SVLightBallotBox(specHash, [startTs, openPeriod[1]], flags);
333         votingContract.setOwner(msg.sender);
334         _commitBallot(democHash, specHash, extraData, address(votingContract), startTs);
335         BallotInit(specHash, [startTs, openPeriod[1]], flags);
336     }
337 
338     // utils
339     function max(uint64 a, uint64 b) pure internal returns(uint64) {
340         if (a > b) {
341             return a;
342         }
343         return b;
344     }
345 }