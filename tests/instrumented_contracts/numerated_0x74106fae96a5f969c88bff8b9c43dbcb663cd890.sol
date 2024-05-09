1 pragma solidity 0.5.2;
2 
3 contract Ownable {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner, "");
12         _;
13     }
14 
15     function transferOwnership(address newOwner) public onlyOwner {
16         require(newOwner != address(0), "");
17         owner = newOwner;
18     }
19 
20 }
21 
22 contract iRNG {
23     function __callback(bytes32 _queryId, uint _result) public;
24 }
25 
26 
27 contract Randao is Ownable {
28     struct Participant {
29         uint256   secret;
30         bytes32   commitment;
31         uint256   reward;
32         bool      revealed;
33         bool      rewarded;
34     }
35 
36     struct Consumer {
37         address caddr;
38         uint256 bountypot;
39     }
40 
41     struct Campaign {
42         uint32    bnum;
43         uint96    deposit;
44         uint16    commitBalkline;
45         uint16    commitDeadline;
46 
47         uint256   random;
48         bool      settled;
49         uint256   bountypot;
50         uint32    commitNum;
51         uint32    revealsNum;
52 
53         mapping (address => Consumer) consumers;
54         mapping (address => Participant) participants;
55     }
56 
57     uint256 public numCampaigns;
58     Campaign[] public campaigns;
59     address public founder;
60 
61     address public rng;
62 
63     modifier blankAddress(address _n) { if (_n != address(0)) revert(); _; }
64 
65     modifier moreThanZero(uint256 _deposit) { if (_deposit <= 0) revert(); _; }
66 
67     modifier notBeBlank(bytes32 _s) { if (_s == "") revert(); _; }
68 
69     modifier beBlank(bytes32 _s) { if (_s != "") revert(); _; }
70 
71     modifier beFalse(bool _t) { if (_t) revert(); _; }
72 
73     constructor() public {
74         founder = msg.sender;
75     }
76 
77     event LogCampaignAdded(uint256 indexed campaignID,
78         address from,
79         uint32 bnum,
80         uint96 deposit,
81         uint16 commitBalkline,
82         uint16 commitDeadline,
83         uint256 bountypot);
84 
85     modifier timeLineCheck(uint32 _bnum, uint16 _commitBalkline, uint16 _commitDeadline) {
86         if (block.number >= _bnum) revert();
87         if (_commitBalkline <= 0) revert();
88         if (_commitDeadline <= 0) revert();
89         if (_commitDeadline >= _commitBalkline) revert();
90         if (block.number >= _bnum - _commitBalkline) revert();
91         _;
92     }
93 
94     function newCampaign(
95         uint32 _bnum,
96         uint96 _deposit,
97         uint16 _commitBalkline,
98         uint16 _commitDeadline
99     )
100         payable
101         timeLineCheck(_bnum, _commitBalkline, _commitDeadline)
102         moreThanZero(_deposit)
103         external
104         returns (uint256 _campaignID)
105     {
106         _campaignID = campaigns.length++;
107         Campaign storage c = campaigns[_campaignID];
108         numCampaigns++;
109         c.bnum = _bnum;
110         c.deposit = _deposit;
111         c.commitBalkline = _commitBalkline;
112         c.commitDeadline = _commitDeadline;
113         c.bountypot = msg.value;
114         c.consumers[msg.sender] = Consumer(msg.sender, msg.value);
115         emit LogCampaignAdded(_campaignID, msg.sender, _bnum, _deposit, _commitBalkline, _commitDeadline, msg.value);
116     }
117 
118     event LogFollow(uint256 indexed CampaignId, address indexed from, uint256 bountypot);
119 
120     function follow(uint256 _campaignID)
121         external
122         payable
123         returns (bool)
124     {
125         Campaign storage c = campaigns[_campaignID];
126         Consumer storage consumer = c.consumers[msg.sender];
127         return followCampaign(_campaignID, c, consumer);
128     }
129 
130     modifier checkFollowPhase(uint256 _bnum, uint16 _commitDeadline) {
131         if (block.number > _bnum - _commitDeadline) revert();
132         _;
133     }
134 
135     function followCampaign(
136         uint256 _campaignID,
137         Campaign storage c,
138         Consumer storage consumer
139     )
140         checkFollowPhase(c.bnum, c.commitDeadline)
141         blankAddress(consumer.caddr)
142         internal
143         returns (bool)
144     {
145         c.bountypot += msg.value;
146         c.consumers[msg.sender] = Consumer(msg.sender, msg.value);
147         emit LogFollow(_campaignID, msg.sender, msg.value);
148         return true;
149     }
150 
151     event LogCommit(uint256 indexed CampaignId, address indexed from, bytes32 commitment);
152 
153     function commit(uint256 _campaignID, bytes32 _hs) notBeBlank(_hs) external payable {
154         Campaign storage c = campaigns[_campaignID];
155         commitmentCampaign(_campaignID, _hs, c);
156     }
157 
158     modifier checkDeposit(uint256 _deposit) { if (msg.value != _deposit) revert(); _; }
159 
160     modifier checkCommitPhase(uint256 _bnum, uint16 _commitBalkline, uint16 _commitDeadline) {
161         if (block.number < _bnum - _commitBalkline) revert();
162         if (block.number > _bnum - _commitDeadline) revert();
163         _;
164     }
165 
166     function commitmentCampaign(
167         uint256 _campaignID,
168         bytes32 _hs,
169         Campaign storage c
170     )
171         checkDeposit(c.deposit)
172         checkCommitPhase(c.bnum, c.commitBalkline, c.commitDeadline)
173         beBlank(c.participants[msg.sender].commitment)
174         internal
175     {
176         c.participants[msg.sender] = Participant(0, _hs, 0, false, false);
177         c.commitNum++;
178         emit LogCommit(_campaignID, msg.sender, _hs);
179     }
180 
181     event LogReveal(uint256 indexed CampaignId, address indexed from, uint256 secret);
182 
183     function reveal(uint256 _campaignID, uint256 _s) external {
184         Campaign storage c = campaigns[_campaignID];
185         Participant storage p = c.participants[msg.sender];
186         revealCampaign(_campaignID, _s, c, p);
187     }
188 
189     modifier checkRevealPhase(uint256 _bnum, uint16 _commitDeadline) {
190         if (block.number <= _bnum - _commitDeadline) revert();
191         if (block.number >= _bnum) revert();
192         _;
193     }
194 
195     modifier checkSecret(uint256 _s, bytes32 _commitment) {
196         if (keccak256(abi.encodePacked(keccak256(abi.encodePacked(_s)))) != _commitment) revert();
197         _;
198     }
199 
200     function revealCampaign(
201         uint256 _campaignID,
202         uint256 _s,
203         Campaign storage c,
204         Participant storage p
205     )
206         checkRevealPhase(c.bnum, c.commitDeadline)
207         checkSecret(_s, p.commitment)
208         beFalse(p.revealed)
209         internal
210     {
211         p.secret = _s;
212         p.revealed = true;
213         c.revealsNum++;
214         c.random ^= uint256(keccak256(abi.encodePacked(p.secret)));
215         emit LogReveal(_campaignID, msg.sender, _s);
216     }
217 
218     modifier bountyPhase(uint256 _bnum){ if (block.number < _bnum) revert(); _; }
219 
220     function getRandom(uint256 _campaignID) external returns (uint256) {
221         Campaign storage c = campaigns[_campaignID];
222         return returnRandom(c);
223     }
224 
225     function returnRandom(Campaign storage c) bountyPhase(c.bnum) internal returns (uint256) {
226         if (c.revealsNum > 0) {
227             c.settled = true;
228             return c.random;
229         }
230     }
231 
232     // The commiter get his bounty and deposit, there are three situations
233     // 1. Campaign succeeds.Every revealer gets his deposit and the bounty.
234     // 2. Someone revels, but some does not,Campaign fails.
235     // The revealer can get the deposit and the fines are distributed.
236     // 3. Nobody reveals, Campaign fails.Every commiter can get his deposit.
237     function getMyBounty(uint256 _campaignID) external {
238         Campaign storage c = campaigns[_campaignID];
239         Participant storage p = c.participants[msg.sender];
240         transferBounty(c, p);
241     }
242 
243     function transferBounty(
244         Campaign storage c,
245         Participant storage p
246     )
247         bountyPhase(c.bnum)
248         beFalse(p.rewarded)
249         internal
250     {
251         if (c.revealsNum > 0) {
252             if (p.revealed) {
253                 uint256 share = calculateShare(c);
254                 returnReward(share, c, p);
255             }
256             // Nobody reveals
257         } else {
258             returnReward(0, c, p);
259         }
260     }
261 
262     function calculateShare(Campaign memory c) internal pure returns (uint256 _share) {
263         // Someone does not reveal. Campaign fails.
264         if (c.commitNum > c.revealsNum) {
265             _share = (c.bountypot + fines(c)) / c.revealsNum;
266             // Campaign succeeds.
267         } else {
268             _share = c.bountypot / c.revealsNum;
269         }
270     }
271 
272     function returnReward(
273         uint256 _share,
274         Campaign storage c,
275         Participant storage p
276     ) internal {
277         p.reward = _share;
278         p.rewarded = true;
279         if (!msg.sender.send(_share + c.deposit)) {
280             p.reward = 0;
281             p.rewarded = false;
282         }
283     }
284 
285     function fines(Campaign memory c) internal pure returns (uint256) {
286         return (c.commitNum - c.revealsNum) * c.deposit;
287     }
288 
289     // If the campaign fails, the consumers can get back the bounty.
290     function refundBounty(uint256 _campaignID) external {
291         Campaign storage c = campaigns[_campaignID];
292         returnBounty(c);
293     }
294 
295     modifier campaignFailed(uint32 _commitNum, uint32 _revealsNum) {
296         if (_commitNum != 0 && _revealsNum != 0) revert();
297         _;
298     }
299 
300     modifier beConsumer(address _caddr) {
301         if (_caddr != msg.sender) revert();
302         _;
303     }
304 
305     function returnBounty(Campaign storage c)
306         bountyPhase(c.bnum)
307         campaignFailed(c.commitNum, c.revealsNum)
308         beConsumer(c.consumers[msg.sender].caddr)
309         internal
310     {
311         uint256 bountypot = c.consumers[msg.sender].bountypot;
312         c.consumers[msg.sender].bountypot = 0;
313         if (!msg.sender.send(bountypot)) {
314             c.consumers[msg.sender].bountypot = bountypot;
315         }
316     }
317 
318     function getDoubleKeccak256(uint256 _s) public pure returns (bytes32) {
319         return bytes32(keccak256(abi.encodePacked(keccak256(abi.encodePacked(_s)))));
320     }
321 
322     function getKeccak256(uint256 _s) public pure returns (bytes32) {
323         return bytes32(keccak256(abi.encodePacked(_s)));
324     }
325 
326     function getBytes32(uint256 _s) public pure returns (bytes32) {
327         return bytes32(_s);
328     }
329 
330     function setRNG(address _rng) public onlyOwner {
331         require(_rng != address(0));
332 
333         rng = _rng;
334     }
335 
336     function sendRandomToRNg(uint256 _campaignID) public onlyOwner bountyPhase(campaigns[_campaignID].bnum) {
337         iRNG(rng).__callback(bytes32(_campaignID), campaigns[_campaignID].random);
338     }
339 
340 }