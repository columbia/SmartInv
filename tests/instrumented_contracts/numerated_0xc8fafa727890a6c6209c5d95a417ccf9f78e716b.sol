1 pragma solidity 0.4.18;
2 
3 contract Managble {
4     address public manager;
5 
6     function Managble() {
7         manager = msg.sender;
8     }
9 
10     modifier onlyManager {
11         require(msg.sender == manager);
12         _;
13     }
14 
15     function changeManager(address newManager) onlyManager {
16         if (newManager != address(0)) {
17             manager = newManager;
18         }
19     }
20 }
21 
22 contract Pausable is Managble {
23     
24     bool public paused = false;
25 
26     event Pause();
27     event Unpause();
28 
29     modifier whenNotPaused() {
30         require(!paused);
31         _;
32     }
33 
34     modifier whenPaused {
35         require(paused);
36         _;
37     }
38 
39     function pause() onlyManager whenNotPaused returns (bool) {
40         paused = true;
41         Pause();
42         return true;
43     }
44 
45     function unpause() onlyManager whenPaused returns (bool) {
46         paused = false;
47         Unpause();
48         return true;
49     }
50 }
51 
52 contract SafeMath {
53   function assert(bool assertion) internal {
54     if (!assertion) throw;
55   }
56 
57   function safeMul(uint a, uint b) internal returns (uint) {
58     uint c = a * b;
59     assert(a == 0 || c / a == b);
60     return c;
61   }
62 
63   function safeDiv(uint a, uint b) internal returns (uint) {
64     assert(b > 0);
65     uint c = a / b;
66     assert(a == b * c + a % b);
67     return c;
68   }
69 }
70 
71 contract RedPocket is Pausable, SafeMath {
72 
73     // FIELDS 
74     uint public minReward = 20000000000000000; // to make sure what claimants get can overcome the gas they paid. unit in wei
75     uint public promotionCommisionPercent = 1; // unit in percent
76     
77     Promotion[] public allPromotions;
78     mapping (uint256 => address) public promotionIndexToHost; // For host: A mapping from promotion IDs to the address that owns them.
79     mapping (address => uint256) hostingCount; // For host: A mapping from host address to count of promotion that address owns. (ownershipTokenCount)
80     mapping (uint256 => address) public promotionIndexToClaimant; // For claimant: A mapping from promotion IDs to the address that did the claim.
81     mapping (address => uint256) claimedCount; // For claimant: A mapping from claimant address to count of promotion that address claimed. (ownershipTokenCount)
82 
83     // apply cooldowns to claimant to prevent individual claim-spam (might not apply)
84     uint32[14] public cooldowns = [
85         uint32(1 minutes),
86         uint32(2 minutes),
87         uint32(5 minutes),
88         uint32(10 minutes),
89         uint32(30 minutes),
90         uint32(1 hours),
91         uint32(2 hours),
92         uint32(4 hours),
93         uint32(8 hours),
94         uint32(16 hours),
95         uint32(1 days),
96         uint32(2 days),
97         uint32(4 days),
98         uint32(7 days)
99     ];
100 
101 
102     // uint public numOfAllPromotions; // this is for the ease of showing value in the contract directly.
103     uint[] public finishedPromotionIDs;
104     uint public numOfFinishedPromotions;
105 
106     // uint public totalNumOfClaimants;
107     // uint public totalEtherGivenOut;
108 
109     // EVENETS
110 
111     // STRUCT
112     struct Promotion {
113         uint id;
114         address host; // each promotion hosted by an address
115         string name; // promotion title
116         string msg; // promotion's promoting message
117         string url;
118 
119         uint eachRedPocketAmt; // the amount of reward in each red pocket. Unit in msg.value / wei
120         uint maxRedPocketNum; 
121         uint claimedNum;
122         uint moneyPool;
123 
124         uint startBlock; // the starting represent in blocks
125         uint blockLast; // duration of the promotion, count in blocks
126 
127         bool finished;
128     }
129 
130     // constructor
131     function RedPocket() { }
132 
133     // when a host create an promotion event
134     function newPromotion(
135         string _name, 
136         string _msg, 
137         string _url,
138         uint _eachAmt,
139         uint _maxNum,
140         uint _blockStart,
141         uint _blockLast
142     ) 
143         whenNotPaused
144         payable
145         returns (uint)
146     {
147         // check min reward requirement
148         require(_eachAmt > minReward); // unit in wei
149 
150         // check if the deposit amount is enough for the input 
151         uint256 inputAmt = _eachAmt * _maxNum; // unit in wei
152         require(inputAmt <= msg.value); 
153 
154         // service charging
155         require (manager.send(safeDiv(safeMul(msg.value, promotionCommisionPercent), 100)));
156         uint deposit = safeDiv(safeMul(msg.value, 100 - promotionCommisionPercent), 100);
157 
158         Promotion memory _promotion = Promotion({
159             id: allPromotions.length,
160             host: msg.sender,
161             name: _name,
162             msg: _msg,
163             url: _url,
164             eachRedPocketAmt: safeDiv(deposit, _maxNum),
165             maxRedPocketNum: _maxNum,
166             claimedNum: 0,
167             moneyPool: deposit,
168             startBlock: _blockStart,
169             blockLast: _blockLast,
170             finished: false
171         });
172         uint256 newPromotionId = allPromotions.push(_promotion) - 1; // set promotion ID
173 
174         promotionIndexToHost[newPromotionId] = msg.sender;
175         hostingCount[msg.sender]++;
176 
177         return newPromotionId;
178     }
179 
180     // this is the 'grab red pocket' function
181     function claimReward(uint _promoteID, uint _moneyPool) whenNotPaused {
182         Promotion storage p = allPromotions[_promoteID];
183 
184         // prevent direct try and claim
185         require(p.moneyPool == _moneyPool); 
186 
187         // check if promotion is closed
188         require(p.finished == false);
189 
190         // prevent same claimant claimed twice in same promotion
191         require(!_claims(msg.sender, _promoteID));
192 
193         // send red pocket
194         if (msg.sender.send(p.eachRedPocketAmt)) {
195             p.moneyPool -= p.eachRedPocketAmt;
196             p.claimedNum++;
197             promotionIndexToClaimant[_promoteID] = msg.sender;
198             claimedCount[msg.sender]++;
199         }
200 
201         // set promotion finish if moneyPool run out of money / event run out of pocket / timeout
202         if (p.moneyPool < p.eachRedPocketAmt || p.claimedNum >= p.maxRedPocketNum || (block.number - p.startBlock >= p.blockLast)) {
203             p.finished = true;
204             finishedPromotionIDs.push(_promoteID);
205             numOfFinishedPromotions++;
206         }
207     }
208 
209     // Returns the total number of promotions
210     function totalPromotions() public view returns (uint) {
211         return allPromotions.length;
212     }
213 
214     // Checks if a given address already claimed in a promotion
215     function _claims(address _claimant, uint256 _promotionId) internal returns (bool) {
216         return promotionIndexToHost[_promotionId] == _claimant;
217     }
218 
219     // For host: Returns the number of promotions hosted by a specific address.
220     function numberOfHosting(address _host) public returns (uint256 count) {
221         return hostingCount[_host];
222     }
223 
224     // For host: returns an array of promotion IDs that an address hosts
225     function promotionsOfHost(address _host) external view returns(uint256[] promotionIDs) {
226         uint256 count = numberOfHosting(_host);
227 
228         if (count == 0) {
229             return new uint256[](0); // Return an empty array
230         } else {
231             uint256[] memory result = new uint256[](count);
232             uint256 resultIndex = 0;
233             uint256 promotionId;
234 
235             for (promotionId = 0; promotionId < allPromotions.length; promotionId++) {
236                 if (promotionIndexToHost[promotionId] == _host) {
237                     result[resultIndex] = promotionId;
238                     resultIndex++;
239                 }
240             }
241 
242             return result;
243         }
244     }
245 
246     // For claimant: Returns the number of promotions claimed by a specific address.
247     function numberOfClaimed(address _claimant) public returns (uint256 count) {
248         return claimedCount[_claimant];
249     }
250 
251     // For claimant: returns an array of promotion IDs that an address claimed
252     function promotionsOfClaimant(address _claimant) external view returns(uint256[] promotionIDs) {
253         uint256 count = numberOfClaimed(_claimant);
254 
255         if (count == 0) {
256             return new uint256[](0); // Return an empty array
257         } else {
258             uint256[] memory result = new uint256[](count);
259             uint256 resultIndex = 0;
260             uint256 promotionId;
261 
262             for (promotionId = 0; promotionId < allPromotions.length; promotionId++) {
263                 if (promotionIndexToClaimant[promotionId] == _claimant) {
264                     result[resultIndex] = promotionId;
265                     resultIndex++;
266                 }
267             }
268 
269             return result;
270         }
271     }
272 
273     // // Returns all the relevant information about a specific promotion.
274     function getPromotion(uint256 _id)
275         external
276         view
277         returns (
278         uint id,
279         address host,
280         string name,
281         string msg,
282         string url,
283         uint eachRedPocketAmt,
284         uint maxRedPocketNum,
285         uint claimedNum,
286         uint moneyPool,
287         uint startBlock,
288         uint blockLast,
289         bool finished
290     ) {
291         Promotion storage p = allPromotions[_id];
292 
293         id = p.id;
294         host = p.host;
295         name = p.name;
296         msg = p.msg;
297         url = p.url;
298         eachRedPocketAmt = p.eachRedPocketAmt;
299         maxRedPocketNum = p.maxRedPocketNum;
300         claimedNum = p.claimedNum;
301         moneyPool = p.moneyPool;
302         startBlock = p.startBlock;
303         blockLast = p.blockLast;
304         finished = p.finished;
305     }
306 
307     // The host is able to withdraw the fund when the promotion is finished
308     function safeWithdraw(uint _promoteID) whenNotPaused {
309         Promotion storage p = allPromotions[_promoteID];
310         require(p.finished == true);
311         
312         if (msg.sender.send(p.moneyPool)) {
313             p.moneyPool = 0;
314         }
315     }
316 
317     // either host or manager can end the promotion if needed
318     function endPromotion(uint _promoteID) {
319         Promotion storage p = allPromotions[_promoteID];
320         require(msg.sender == p.host || msg.sender == manager);
321         p.finished = true;
322 	}
323 
324     function updateCommission(uint _newPercent) whenNotPaused onlyManager {
325         promotionCommisionPercent = _newPercent;
326     }
327 
328     function updateMinReward(uint _newReward) whenNotPaused onlyManager {
329         minReward = _newReward;
330     }
331 
332     function drain() whenPaused onlyManager {
333 		if (!manager.send(this.balance)) throw;
334 	}
335 
336 }