1 pragma solidity 0.4.19;
2 
3 // version 1.1
4 contract Randao {
5     struct Participant {
6         uint256   secret;
7         bytes32   commitment;
8         uint256   reward;
9         bool      revealed;
10         bool      rewarded;
11     }
12 
13     struct Consumer {
14         address caddr;
15         uint256 bountypot;
16     }
17 
18     struct Campaign {
19         uint32    bnum;
20         uint96    deposit;
21         uint16    commitBalkline;
22         uint16    commitDeadline;
23 
24         uint256   random;
25         bool      settled;
26         uint256   bountypot;
27         uint32    commitNum;
28         uint32    revealsNum;
29 
30         mapping (address => Consumer) consumers;
31         mapping (address => Participant) participants;
32     }
33 
34     uint256 public numCampaigns;
35     Campaign[] public campaigns;
36     address public founder;
37 
38     modifier blankAddress(address _n) { if (_n != 0) revert(); _; }
39 
40     modifier moreThanZero(uint256 _deposit) { if (_deposit <= 0) revert(); _; }
41 
42     modifier notBeBlank(bytes32 _s) { if (_s == "") revert(); _; }
43 
44     modifier beBlank(bytes32 _s) { if (_s != "") revert(); _; }
45 
46     modifier beFalse(bool _t) { if (_t) revert(); _; }
47 
48     function Randao() public {
49         founder = msg.sender;
50     }
51 
52     event LogCampaignAdded(uint256 indexed campaignID,
53         address indexed from,
54         uint32 indexed bnum,
55         uint96 deposit,
56         uint16 commitBalkline,
57         uint16 commitDeadline,
58         uint256 bountypot);
59 
60     modifier timeLineCheck(uint32 _bnum, uint16 _commitBalkline, uint16 _commitDeadline) {
61         if (block.number >= _bnum) revert();
62         if (_commitBalkline <= 0) revert();
63         if (_commitDeadline <= 0) revert();
64         if (_commitDeadline >= _commitBalkline) revert();
65         if (block.number >= _bnum - _commitBalkline) revert();
66         _;
67     }
68 
69     function newCampaign(
70         uint32 _bnum,
71         uint96 _deposit,
72         uint16 _commitBalkline,
73         uint16 _commitDeadline
74     ) payable
75     timeLineCheck(_bnum, _commitBalkline, _commitDeadline)
76     moreThanZero(_deposit) external returns (uint256 _campaignID) {
77         _campaignID = campaigns.length++;
78         Campaign storage c = campaigns[_campaignID];
79         numCampaigns++;
80         c.bnum = _bnum;
81         c.deposit = _deposit;
82         c.commitBalkline = _commitBalkline;
83         c.commitDeadline = _commitDeadline;
84         c.bountypot = msg.value;
85         c.consumers[msg.sender] = Consumer(msg.sender, msg.value);
86         LogCampaignAdded(_campaignID, msg.sender, _bnum, _deposit, _commitBalkline, _commitDeadline, msg.value);
87     }
88 
89     event LogFollow(uint256 indexed CampaignId, address indexed from, uint256 bountypot);
90 
91     function follow(uint256 _campaignID)
92     external payable returns (bool) {
93         Campaign storage c = campaigns[_campaignID];
94         Consumer storage consumer = c.consumers[msg.sender];
95         return followCampaign(_campaignID, c, consumer);
96     }
97 
98     modifier checkFollowPhase(uint256 _bnum, uint16 _commitDeadline) {
99         if (block.number > _bnum - _commitDeadline) revert();
100         _;
101     }
102 
103     function followCampaign(
104         uint256 _campaignID,
105         Campaign storage c,
106         Consumer storage consumer
107     ) checkFollowPhase(c.bnum, c.commitDeadline)
108     blankAddress(consumer.caddr) internal returns (bool) {
109         c.bountypot += msg.value;
110         c.consumers[msg.sender] = Consumer(msg.sender, msg.value);
111         LogFollow(_campaignID, msg.sender, msg.value);
112         return true;
113     }
114 
115     event LogCommit(uint256 indexed CampaignId, address indexed from, bytes32 commitment);
116 
117     function commit(uint256 _campaignID, bytes32 _hs) notBeBlank(_hs) external payable {
118         Campaign storage c = campaigns[_campaignID];
119         commitmentCampaign(_campaignID, _hs, c);
120     }
121 
122     modifier checkDeposit(uint256 _deposit) { if (msg.value != _deposit) revert(); _; }
123 
124     modifier checkCommitPhase(uint256 _bnum, uint16 _commitBalkline, uint16 _commitDeadline) {
125         if (block.number < _bnum - _commitBalkline) revert();
126         if (block.number > _bnum - _commitDeadline) revert();
127         _;
128     }
129 
130     function commitmentCampaign(
131         uint256 _campaignID,
132         bytes32 _hs,
133         Campaign storage c
134     ) checkDeposit(c.deposit)
135     checkCommitPhase(c.bnum, c.commitBalkline, c.commitDeadline)
136     beBlank(c.participants[msg.sender].commitment) internal {
137         c.participants[msg.sender] = Participant(0, _hs, 0, false, false);
138         c.commitNum++;
139         LogCommit(_campaignID, msg.sender, _hs);
140     }
141 
142     event LogReveal(uint256 indexed CampaignId, address indexed from, uint256 secret);
143 
144     function reveal(uint256 _campaignID, uint256 _s) external {
145         Campaign storage c = campaigns[_campaignID];
146         Participant storage p = c.participants[msg.sender];
147         revealCampaign(_campaignID, _s, c, p);
148     }
149 
150     modifier checkRevealPhase(uint256 _bnum, uint16 _commitDeadline) {
151         if (block.number <= _bnum - _commitDeadline) revert();
152         if (block.number >= _bnum) revert();
153         _;
154     }
155 
156     modifier checkSecret(uint256 _s, bytes32 _commitment) {
157         if (keccak256(keccak256(_s)) != _commitment) revert();
158         _;
159     }
160 
161     function revealCampaign(
162         uint256 _campaignID,
163         uint256 _s,
164         Campaign storage c,
165         Participant storage p
166     ) checkRevealPhase(c.bnum, c.commitDeadline)
167     checkSecret(_s, p.commitment)
168     beFalse(p.revealed) internal {
169         p.secret = _s;
170         p.revealed = true;
171         c.revealsNum++;
172         c.random ^= uint256(keccak256(p.secret));
173         LogReveal(_campaignID, msg.sender, _s);
174     }
175 
176     modifier bountyPhase(uint256 _bnum){ if (block.number < _bnum) revert(); _; }
177 
178     function getRandom(uint256 _campaignID) external returns (uint256) {
179         Campaign storage c = campaigns[_campaignID];
180         return returnRandom(c);
181     }
182 
183     function returnRandom(Campaign storage c) bountyPhase(c.bnum) internal returns (uint256) {
184         if (c.revealsNum == c.commitNum) {
185             c.settled = true;
186             return c.random;
187         }
188     }
189 
190     // The commiter get his bounty and deposit, there are three situations
191     // 1. Campaign succeeds.Every revealer gets his deposit and the bounty.
192     // 2. Someone revels, but some does not,Campaign fails.
193     // The revealer can get the deposit and the fines are distributed.
194     // 3. Nobody reveals, Campaign fails.Every commiter can get his deposit.
195     function getMyBounty(uint256 _campaignID) external {
196         Campaign storage c = campaigns[_campaignID];
197         Participant storage p = c.participants[msg.sender];
198         transferBounty(c, p);
199     }
200 
201     function transferBounty(
202         Campaign storage c,
203         Participant storage p
204     ) bountyPhase(c.bnum)
205     beFalse(p.rewarded) internal {
206         if (c.revealsNum > 0) {
207             if (p.revealed) {
208                 uint256 share = calculateShare(c);
209                 returnReward(share, c, p);
210             }
211             // Nobody reveals
212         } else {
213             returnReward(0, c, p);
214         }
215     }
216 
217     function calculateShare(Campaign c) internal pure returns (uint256 _share) {
218         // Someone does not reveal. Campaign fails.
219         if (c.commitNum > c.revealsNum) {
220             _share = fines(c) / c.revealsNum;
221             // Campaign succeeds.
222         } else {
223             _share = c.bountypot / c.revealsNum;
224         }
225     }
226 
227     function returnReward(
228         uint256 _share,
229         Campaign storage c,
230         Participant storage p
231     ) internal {
232         p.reward = _share;
233         p.rewarded = true;
234         if (!msg.sender.send(_share + c.deposit)) {
235             p.reward = 0;
236             p.rewarded = false;
237         }
238     }
239 
240     function fines(Campaign c) internal pure returns (uint256) {
241         return (c.commitNum - c.revealsNum) * c.deposit;
242     }
243 
244     // If the campaign fails, the consumers can get back the bounty.
245     function refundBounty(uint256 _campaignID) external {
246         Campaign storage c = campaigns[_campaignID];
247         returnBounty(c);
248     }
249 
250     modifier campaignFailed(uint32 _commitNum, uint32 _revealsNum) {
251         if (_commitNum == _revealsNum && _commitNum != 0) revert();
252         _;
253     }
254 
255     modifier beConsumer(address _caddr) {
256         if (_caddr != msg.sender) revert();
257         _;
258     }
259 
260     function returnBounty(Campaign storage c)
261     bountyPhase(c.bnum)
262     campaignFailed(c.commitNum, c.revealsNum)
263     beConsumer(c.consumers[msg.sender].caddr) internal {
264         uint256 bountypot = c.consumers[msg.sender].bountypot;
265         c.consumers[msg.sender].bountypot = 0;
266         if (!msg.sender.send(bountypot)) {
267             c.consumers[msg.sender].bountypot = bountypot;
268         }
269     }
270 
271     function getDoubleKeccak256(uint256 _s) public pure returns (bytes32) {
272         return keccak256(keccak256(_s));
273     }
274 
275     function getKeccak256(uint256 _s) public pure returns (bytes32) {
276         return keccak256(_s);
277     }
278 
279     function getBytes32(uint256 _s) public pure returns (bytes32) {
280         return bytes32(_s);
281     }
282 }