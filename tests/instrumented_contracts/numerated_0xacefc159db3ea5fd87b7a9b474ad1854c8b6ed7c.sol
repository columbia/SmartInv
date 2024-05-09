1 pragma solidity 0.4.19;
2 
3 
4 // version 1.1
5 contract Randao {
6     struct Participant {
7         uint256   secret;
8         bytes32   commitment;
9         uint256   reward;
10         bool      revealed;
11         bool      rewarded;
12     }
13 
14     struct Consumer {
15         address caddr;
16         uint256 bountypot;
17     }
18 
19     struct Campaign {
20         uint32    bnum;
21         uint96    deposit;
22         uint16    commitBalkline;
23         uint16    commitDeadline;
24 
25         uint256   random;
26         bool      settled;
27         uint256   bountypot;
28         uint32    commitNum;
29         uint32    revealsNum;
30 
31         mapping (address => Consumer) consumers;
32         mapping (address => Participant) participants;
33     }
34 
35     uint256 public numCampaigns;
36     Campaign[] public campaigns;
37     address public founder;
38 
39     modifier blankAddress(address _n) { if (_n != 0) revert(); _; }
40 
41     modifier moreThanZero(uint256 _deposit) { if (_deposit <= 0) revert(); _; }
42 
43     modifier notBeBlank(bytes32 _s) { if (_s == "") revert(); _; }
44 
45     modifier beBlank(bytes32 _s) { if (_s != "") revert(); _; }
46 
47     modifier beFalse(bool _t) { if (_t) revert(); _; }
48 
49     function Randao() public {
50         founder = msg.sender;
51     }
52 
53     event LogCampaignAdded(uint256 indexed campaignID,
54         address indexed from,
55         uint32 indexed bnum,
56         uint96 deposit,
57         uint16 commitBalkline,
58         uint16 commitDeadline,
59         uint256 bountypot);
60 
61     modifier timeLineCheck(uint32 _bnum, uint16 _commitBalkline, uint16 _commitDeadline) {
62         if (block.number >= _bnum) revert();
63         if (_commitBalkline <= 0) revert();
64         if (_commitDeadline <= 0) revert();
65         if (_commitDeadline >= _commitBalkline) revert();
66         if (block.number >= _bnum - _commitBalkline) revert();
67         _;
68     }
69 
70     function newCampaign(
71         uint32 _bnum,
72         uint96 _deposit,
73         uint16 _commitBalkline,
74         uint16 _commitDeadline
75     ) payable
76     timeLineCheck(_bnum, _commitBalkline, _commitDeadline)
77     moreThanZero(_deposit) external returns (uint256 _campaignID) {
78         _campaignID = campaigns.length++;
79         Campaign storage c = campaigns[_campaignID];
80         numCampaigns++;
81         c.bnum = _bnum;
82         c.deposit = _deposit;
83         c.commitBalkline = _commitBalkline;
84         c.commitDeadline = _commitDeadline;
85         c.bountypot = msg.value;
86         c.consumers[msg.sender] = Consumer(msg.sender, msg.value);
87         LogCampaignAdded(_campaignID, msg.sender, _bnum, _deposit, _commitBalkline, _commitDeadline, msg.value);
88     }
89 
90     event LogFollow(uint256 indexed CampaignId, address indexed from, uint256 bountypot);
91 
92     function follow(uint256 _campaignID)
93     external payable returns (bool) {
94         Campaign storage c = campaigns[_campaignID];
95         Consumer storage consumer = c.consumers[msg.sender];
96         return followCampaign(_campaignID, c, consumer);
97     }
98 
99     modifier checkFollowPhase(uint256 _bnum, uint16 _commitDeadline) {
100         if (block.number > _bnum - _commitDeadline) revert();
101         _;
102     }
103 
104     function followCampaign(
105         uint256 _campaignID,
106         Campaign storage c,
107         Consumer storage consumer
108     ) checkFollowPhase(c.bnum, c.commitDeadline)
109     blankAddress(consumer.caddr) internal returns (bool) {
110         c.bountypot += msg.value;
111         c.consumers[msg.sender] = Consumer(msg.sender, msg.value);
112         LogFollow(_campaignID, msg.sender, msg.value);
113         return true;
114     }
115 
116     event LogCommit(uint256 indexed CampaignId, address indexed from, bytes32 commitment);
117 
118     function commit(uint256 _campaignID, bytes32 _hs) notBeBlank(_hs) external payable {
119         Campaign storage c = campaigns[_campaignID];
120         commitmentCampaign(_campaignID, _hs, c);
121     }
122 
123     modifier checkDeposit(uint256 _deposit) { if (msg.value != _deposit) revert(); _; }
124 
125     modifier checkCommitPhase(uint256 _bnum, uint16 _commitBalkline, uint16 _commitDeadline) {
126         if (block.number < _bnum - _commitBalkline) revert();
127         if (block.number > _bnum - _commitDeadline) revert();
128         _;
129     }
130 
131     function commitmentCampaign(
132         uint256 _campaignID,
133         bytes32 _hs,
134         Campaign storage c
135     ) checkDeposit(c.deposit)
136     checkCommitPhase(c.bnum, c.commitBalkline, c.commitDeadline)
137     beBlank(c.participants[msg.sender].commitment) internal {
138         c.participants[msg.sender] = Participant(0, _hs, 0, false, false);
139         c.commitNum++;
140         LogCommit(_campaignID, msg.sender, _hs);
141     }
142 
143     event LogReveal(uint256 indexed CampaignId, address indexed from, uint256 secret);
144 
145     function reveal(uint256 _campaignID, uint256 _s) external {
146         Campaign storage c = campaigns[_campaignID];
147         Participant storage p = c.participants[msg.sender];
148         revealCampaign(_campaignID, _s, c, p);
149     }
150 
151     modifier checkRevealPhase(uint256 _bnum, uint16 _commitDeadline) {
152         if (block.number <= _bnum - _commitDeadline) revert();
153         if (block.number >= _bnum) revert();
154         _;
155     }
156 
157     modifier checkSecret(uint256 _s, bytes32 _commitment) {
158         if (keccak256(keccak256(_s)) != _commitment) revert();
159         _;
160     }
161 
162     function revealCampaign(
163         uint256 _campaignID,
164         uint256 _s,
165         Campaign storage c,
166         Participant storage p
167     ) checkRevealPhase(c.bnum, c.commitDeadline)
168     checkSecret(_s, p.commitment)
169     beFalse(p.revealed) internal {
170         p.secret = _s;
171         p.revealed = true;
172         c.revealsNum++;
173         c.random ^= uint256(keccak256(p.secret));
174         LogReveal(_campaignID, msg.sender, _s);
175     }
176 
177     modifier bountyPhase(uint256 _bnum){ if (block.number < _bnum) revert(); _; }
178 
179     function getRandom(uint256 _campaignID) external returns (uint256) {
180         Campaign storage c = campaigns[_campaignID];
181         return returnRandom(c);
182     }
183 
184     function returnRandom(Campaign storage c) bountyPhase(c.bnum) internal returns (uint256) {
185         if (c.revealsNum == c.commitNum) {
186             c.settled = true;
187             return c.random;
188         }
189     }
190 
191     // The commiter get his bounty and deposit, there are three situations
192     // 1. Campaign succeeds.Every revealer gets his deposit and the bounty.
193     // 2. Someone revels, but some does not,Campaign fails.
194     // The revealer can get the deposit and the fines are distributed.
195     // 3. Nobody reveals, Campaign fails.Every commiter can get his deposit.
196     function getMyBounty(uint256 _campaignID) external {
197         Campaign storage c = campaigns[_campaignID];
198         Participant storage p = c.participants[msg.sender];
199         transferBounty(c, p);
200     }
201 
202     function transferBounty(
203         Campaign storage c,
204         Participant storage p
205     ) bountyPhase(c.bnum)
206     beFalse(p.rewarded) internal {
207         if (c.revealsNum > 0) {
208             if (p.revealed) {
209                 uint256 share = calculateShare(c);
210                 returnReward(share, c, p);
211             }
212             // Nobody reveals
213         } else {
214             returnReward(0, c, p);
215         }
216     }
217 
218     function calculateShare(Campaign c) internal pure returns (uint256 _share) {
219         // Someone does not reveal. Campaign fails.
220         if (c.commitNum > c.revealsNum) {
221             _share = fines(c) / c.revealsNum;
222             // Campaign succeeds.
223         } else {
224             _share = c.bountypot / c.revealsNum;
225         }
226     }
227 
228     function returnReward(
229         uint256 _share,
230         Campaign storage c,
231         Participant storage p
232     ) internal {
233         p.reward = _share;
234         p.rewarded = true;
235         if (!msg.sender.send(_share + c.deposit)) {
236             p.reward = 0;
237             p.rewarded = false;
238         }
239     }
240 
241     function fines(Campaign c) internal pure returns (uint256) {
242         return (c.commitNum - c.revealsNum) * c.deposit;
243     }
244 
245     // If the campaign fails, the consumers can get back the bounty.
246     function refundBounty(uint256 _campaignID) external {
247         Campaign storage c = campaigns[_campaignID];
248         returnBounty(c);
249     }
250 
251     modifier campaignFailed(uint32 _commitNum, uint32 _revealsNum) {
252         if (_commitNum == _revealsNum && _commitNum != 0) revert();
253         _;
254     }
255 
256     modifier beConsumer(address _caddr) {
257         if (_caddr != msg.sender) revert();
258         _;
259     }
260 
261     function returnBounty(Campaign storage c)
262     bountyPhase(c.bnum)
263     campaignFailed(c.commitNum, c.revealsNum)
264     beConsumer(c.consumers[msg.sender].caddr) internal {
265         uint256 bountypot = c.consumers[msg.sender].bountypot;
266         c.consumers[msg.sender].bountypot = 0;
267         if (!msg.sender.send(bountypot)) {
268             c.consumers[msg.sender].bountypot = bountypot;
269         }
270     }
271 
272     function getDoubleKeccak256(uint256 _s) public pure returns (bytes32) {
273         return keccak256(keccak256(_s));
274     }
275 
276     function getKeccak256(uint256 _s) public pure returns (bytes32) {
277         return keccak256(_s);
278     }
279 
280     function getBytes32(uint256 _s) public pure returns (bytes32) {
281         return bytes32(_s);
282     }
283 }