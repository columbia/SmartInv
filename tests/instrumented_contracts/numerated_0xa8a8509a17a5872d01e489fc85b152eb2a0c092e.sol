1 pragma solidity ^0.4.19;
2 
3 
4 //
5 // SVLightBallotBox
6 // Single use contract to manage a ballot
7 // Author: Max Kaye <max@secure.vote>
8 // License: MIT
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
203 // License: MIT
204 //
205 
206 contract SVLightIndex {
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
226     // addresses that do not have to pay for democs
227     mapping (address => bool) public democWhitelist;
228     // democs that do not have to pay for issues
229     mapping (address => bool) public ballotWhitelist;
230 
231     // payment details
232     address public payTo;
233     // uint128's used because they account for amounts up to 3.4e38 wei or 3.4e20 ether
234     uint128 public democFee = 0.05 ether; // 0.05 ether; about $50 at 3 March 2018
235     mapping (address => uint128) democFeeFor;
236     uint128 public ballotFee = 0.01 ether; // 0.01 ether; about $10 at 3 March 2018
237     mapping (address => uint128) ballotFeeFor;
238     bool public paymentEnabled = true;
239 
240     uint8 constant PAY_DEMOC = 0;
241     uint8 constant PAY_BALLOT = 1;
242 
243     function getPaymentParams(uint8 paymentType) internal constant returns (bool, uint128, uint128) {
244         if (paymentType == PAY_DEMOC) {
245             return (democWhitelist[msg.sender], democFee, democFeeFor[msg.sender]);
246         } else if (paymentType == PAY_BALLOT) {
247             return (ballotWhitelist[msg.sender], ballotFee, ballotFeeFor[msg.sender]);
248         } else {
249             assert(false);
250         }
251     }
252 
253     //* EVENTS /
254 
255     event PaymentMade(uint128[2] valAndRemainder);
256     event DemocInit(string name, bytes32 democHash, address admin);
257     event BallotInit(bytes32 specHash, uint64[2] openPeriod, bool[2] flags);
258     event BallotAdded(bytes32 democHash, bytes32 specHash, bytes32 extraData, address votingContract);
259     event SetFees(uint128[2] _newFees);
260     event PaymentEnabled(bool _feeEnabled);
261 
262     //* MODIFIERS /
263 
264     modifier onlyBy(address _account) {
265         require(msg.sender == _account);
266         _;
267     }
268 
269     modifier payReq(uint8 paymentType) {
270         // get our whitelist, generalFee, and fee's for particular addresses
271         bool wl;
272         uint128 genFee;
273         uint128 feeFor;
274         (wl, genFee, feeFor) = getPaymentParams(paymentType);
275         // init v to something large in case of exploit or something
276         uint128 v = 1000 ether;
277         // check whitelists - do not require payment in some cases
278         if (paymentEnabled && !wl) {
279             v = feeFor;
280             if (v == 0){
281                 // if there's no fee for the individual user then set it to the general fee
282                 v = genFee;
283             }
284             require(msg.value >= v);
285 
286             // handle payments
287             uint128 remainder = uint128(msg.value) - v;
288             payTo.transfer(v); // .transfer so it throws on failure
289             if (!msg.sender.send(remainder)){
290                 payTo.transfer(remainder);
291             }
292             PaymentMade([v, remainder]);
293         }
294 
295         // do main
296         _;
297     }
298 
299 
300     //* FUNCTIONS /
301 
302 
303     // constructor
304     function SVLightIndex() public {
305         owner = msg.sender;
306         payTo = msg.sender;
307     }
308 
309     //* GLOBAL INFO */
310 
311     function nDemocs() public constant returns (uint256) {
312         return democList.length;
313     }
314 
315     //* PAYMENT AND OWNER FUNCTIONS */
316 
317     function setPayTo(address newPayTo) onlyBy(owner) public {
318         payTo = newPayTo;
319     }
320 
321     function setEth(uint128[2] newFees) onlyBy(owner) public {
322         democFee = newFees[PAY_DEMOC];
323         ballotFee = newFees[PAY_BALLOT];
324         SetFees([democFee, ballotFee]);
325     }
326 
327     function setOwner(address _owner) onlyBy(owner) public {
328         owner = _owner;
329     }
330 
331     function setPaymentEnabled(bool _enabled) onlyBy(owner) public {
332         paymentEnabled = _enabled;
333         PaymentEnabled(_enabled);
334     }
335 
336     function setWhitelistDemoc(address addr, bool _free) onlyBy(owner) public {
337         democWhitelist[addr] = _free;
338     }
339 
340     function setWhitelistBallot(address addr, bool _free) onlyBy(owner) public {
341         ballotWhitelist[addr] = _free;
342     }
343 
344     function setFeeFor(address addr, uint128[2] fees) onlyBy(owner) public {
345         democFeeFor[addr] = fees[PAY_DEMOC];
346         ballotFeeFor[addr] = fees[PAY_BALLOT];
347     }
348 
349     //* DEMOCRACY FUNCTIONS - INDIVIDUAL */
350 
351     function initDemoc(string democName) payReq(PAY_DEMOC) public payable returns (bytes32) {
352         bytes32 democHash = keccak256(democName, msg.sender, democList.length, this);
353         democList.push(democHash);
354         democs[democHash].name = democName;
355         democs[democHash].admin = msg.sender;
356         DemocInit(democName, democHash, msg.sender);
357         return democHash;
358     }
359 
360     function getDemocInfo(bytes32 democHash) public constant returns (string name, address admin, uint256 nBallots) {
361         return (democs[democHash].name, democs[democHash].admin, democs[democHash].ballots.length);
362     }
363 
364     function setAdmin(bytes32 democHash, address newAdmin) onlyBy(democs[democHash].admin) public {
365         democs[democHash].admin = newAdmin;
366     }
367 
368     function nBallots(bytes32 democHash) public constant returns (uint256) {
369         return democs[democHash].ballots.length;
370     }
371 
372     function getNthBallot(bytes32 democHash, uint256 n) public constant returns (bytes32 specHash, bytes32 extraData, address votingContract, uint64 startTime) {
373         return (democs[democHash].ballots[n].specHash, democs[democHash].ballots[n].extraData, democs[democHash].ballots[n].votingContract, democs[democHash].ballots[n].startTs);
374     }
375 
376     //* ADD BALLOT TO RECORD */
377 
378     function _commitBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData, address votingContract, uint64 startTs) internal {
379         democs[democHash].ballots.push(Ballot(specHash, extraData, votingContract, startTs));
380         BallotAdded(democHash, specHash, extraData, votingContract);
381     }
382 
383     function addBallot(bytes32 democHash, bytes32 extraData, address votingContract)
384                       onlyBy(democs[democHash].admin)
385                       payReq(PAY_BALLOT)
386                       public
387                       payable
388                       {
389         SVLightBallotBox bb = SVLightBallotBox(votingContract);
390         bytes32 specHash = bb.specHash();
391         uint64 startTs = bb.startTime();
392         _commitBallot(democHash, specHash, extraData, votingContract, startTs);
393     }
394 
395     function deployBallot(bytes32 democHash, bytes32 specHash, bytes32 extraData,
396                           uint64[2] openPeriod, bool[2] flags)
397                           onlyBy(democs[democHash].admin)
398                           payReq(PAY_BALLOT)
399                           public payable {
400         // the start time is max(startTime, block.timestamp) to avoid a DoS whereby a malicious electioneer could disenfranchise
401         // token holders who have recently acquired tokens.
402         uint64 startTs = max(openPeriod[0], uint64(block.timestamp));
403         SVLightBallotBox votingContract = new SVLightBallotBox(specHash, [startTs, openPeriod[1]], flags);
404         votingContract.setOwner(msg.sender);
405         _commitBallot(democHash, specHash, extraData, address(votingContract), startTs);
406         BallotInit(specHash, [startTs, openPeriod[1]], flags);
407     }
408 
409     // utils
410     function max(uint64 a, uint64 b) pure internal returns(uint64) {
411         if (a > b) {
412             return a;
413         }
414         return b;
415     }
416 }