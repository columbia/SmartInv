1 pragma solidity ^0.4.22;
2 
3 contract DmlMarketplace {
4     // Public Variables
5     mapping(address => bool) public moderators;
6     address public token;
7     
8     // bountyFactory address
9     DmlBountyFactory public bountyFactory;
10     
11     
12     mapping(bytes32 => uint) public totals;
13     mapping(address => mapping(bytes32 => bool)) public hasPurchased;
14     
15     constructor() public {
16         moderators[msg.sender] = true;
17     }
18     
19     function isReady() view public returns (bool success) {
20         if (token == address(0) || bountyFactory == address(0)) {
21             return false;
22         }
23 
24         return true;
25     }
26 
27     function isModerator(address modAddress) view public returns (bool success) {
28         return moderators[modAddress];
29     }
30 
31     function addModerator(address newModerator) public {
32         require(isModerator(msg.sender));
33         moderators[newModerator] = true;
34     }
35 
36     function removeModerator(address mod) public {
37         require(isModerator(msg.sender));
38         moderators[mod] = false;
39     }
40 
41     function init (address newTokenAddress) public returns (bool success) {
42         require(isModerator(msg.sender));
43         token = newTokenAddress;
44         DmlBountyFactory f = new DmlBountyFactory(token);
45         bountyFactory = f;
46         return true;
47     }
48 
49     function setBountyFactory(address factoryAddress) public {
50         require(isModerator(msg.sender));
51         DmlBountyFactory f = DmlBountyFactory(factoryAddress);
52         bountyFactory = f;
53     }
54     
55     function buy(bytes32 algoId, uint value) public returns (bool success) {
56         address sender = msg.sender;
57         
58         require(!hasPurchased[msg.sender][algoId]);
59 
60         ERC20Interface c = ERC20Interface(token);
61         
62         require(c.transferFrom(sender, address(this), value));
63 
64         hasPurchased[sender][algoId] = true;
65         
66         if (totals[algoId] < 1) {
67             totals[algoId] = 1;
68         } else {
69             totals[algoId]++;
70         }
71         
72         return true;
73     }
74     
75     function transferToken (address receiver, uint amount) public {
76         require(isModerator(msg.sender));
77         
78         ERC20Interface c = ERC20Interface(token);
79         require(c.transfer(receiver, amount));
80     }
81 }
82 
83 contract DmlBountyFactory {
84     address public marketplace;
85     address public token;
86     address[] public allBountyAddresses;
87     mapping(address => address[]) public bountyAddressByCreator;
88     mapping(address => address[]) public bountyAddressByParticipant;
89     
90     constructor(address tokenAddress) public {
91         marketplace = msg.sender;
92         token = tokenAddress;
93     }
94 
95     function getAllBounties() view public returns (address[] bounties) {
96         return allBountyAddresses;
97     }
98 
99     function getBountiesByCreator(address creatorAddress) view public returns (address[] bounties) {
100         return bountyAddressByCreator[creatorAddress];
101     }
102 
103     function getBountiesByParticipant(address participantAddress) view public returns (address[] bounties) {
104         return bountyAddressByParticipant[participantAddress];
105     }
106     
107     function createBounty(string name, uint[] prizes) public {
108         address creator = msg.sender;
109         address newBounty = new Bounty(token, creator, name, prizes, marketplace);
110         allBountyAddresses.push(newBounty);
111         bountyAddressByCreator[msg.sender].push(newBounty);
112     }
113     
114     function joinBounty(address bountyAddress) public {
115         Bounty b = Bounty(bountyAddress);
116         
117         require(b.join(msg.sender));
118         
119         bountyAddressByParticipant[msg.sender].push(bountyAddress);
120     }
121 }
122 
123 contract Bounty {
124     // contract addresses
125     address public factory;
126     
127     // public constants
128     address public creator;
129     address public token;
130     address public marketplace;
131 
132     // state variables
133     string public name;
134     uint[] public prizes;
135     uint public createdAt;
136     address[] public winners;
137     address[] public participants;
138     Status public status;
139     mapping(address => bool) public participantsMap;
140 
141     enum Status {
142         Initialized,
143         EnrollmentStart,
144         EnrollmentEnd,
145         BountyStart,
146         BountyEnd,
147         EvaluationEnd,
148         Completed,
149         Paused
150     }
151     
152     constructor(
153         address tokenAddress,
154         address creatorAddress,
155         string initName,
156         uint[] initPrizes,
157         address mpAddress
158     ) public {
159         factory = msg.sender;
160         marketplace = mpAddress;
161         creator = creatorAddress;
162         token = tokenAddress;
163         prizes = initPrizes;
164         status = Status.Initialized;
165         name = initName;
166         createdAt = now;
167     }
168     
169     function isFunded() public view returns (bool success) {
170         ERC20Interface c = ERC20Interface(token);
171         require(getTotalPrize() <= c.balanceOf(address(this)));
172         return true;
173     }
174 
175     function getData() public view returns (string retName, uint[] retPrizes, address[] retWinenrs, address[] retParticipants, Status retStatus, address retCreator, uint createdTime) {
176         return (name, prizes, winners, participants, status, creator, createdAt);
177     }
178     
179     function join(address participantAddress) public returns (bool success) {
180         require(msg.sender == factory);
181 
182         if (status != Status.EnrollmentStart) {
183             return false;
184         }
185         
186         if (participantsMap[participantAddress] == true) {
187             return false;
188         }
189         
190         participants.push(participantAddress);
191         participantsMap[participantAddress] = true;
192         
193         return true;
194     }
195 
196     function updateBounty(string newName, uint[] newPrizes) public {
197         require(updateName(newName));
198         require(updatePrizes(newPrizes));
199     }
200 
201     function updateName(string newName) public returns (bool success) {
202         DmlMarketplace dmp = DmlMarketplace(marketplace);
203         require(dmp.isModerator(msg.sender) || msg.sender == creator);
204         name = newName;
205         return true;
206     }
207 
208     function forceUpdateName(string newName) public returns (bool success) {
209         DmlMarketplace dmp = DmlMarketplace(marketplace);
210         require(dmp.isModerator(msg.sender));
211         name = newName;
212         return true;
213     }
214     
215     function updatePrizes(uint[] newPrizes) public returns (bool success) {
216         DmlMarketplace dmp = DmlMarketplace(marketplace);
217         require(dmp.isModerator(msg.sender) || msg.sender == creator);
218         require(status == Status.Initialized);
219         prizes = newPrizes;
220         return true;
221     }
222 
223     function forceUpdatePrizes(uint[] newPrizes) public returns (bool success) {
224         DmlMarketplace dmp = DmlMarketplace(marketplace);
225         require(dmp.isModerator(msg.sender));
226         prizes = newPrizes;
227         return true;
228     }
229 
230     function setStatus(Status newStatus) private returns (bool success) {
231         DmlMarketplace dmp = DmlMarketplace(marketplace);
232         require(dmp.isModerator(msg.sender) || msg.sender == creator);
233         status = newStatus;
234         return true;
235     }
236 
237     function forceSetStatus(Status newStatus) public returns (bool success) {
238         DmlMarketplace dmp = DmlMarketplace(marketplace);
239         require(dmp.isModerator(msg.sender));
240         status = newStatus;
241         return true;
242     }
243     
244     function startEnrollment() public {
245         require(prizes.length > 0);
246         require(isFunded());
247         setStatus(Status.EnrollmentStart);
248     }
249     
250     function stopEnrollment() public {
251         require(status == Status.EnrollmentStart);
252         setStatus(Status.EnrollmentEnd);
253     }
254     
255     function startBounty() public {
256         require(status == Status.EnrollmentEnd);
257         setStatus(Status.BountyStart);
258     }
259     
260     function stopBounty() public {
261         require(status == Status.BountyStart);
262         setStatus(Status.BountyEnd);
263     }
264 
265     function updateWinners(address[] newWinners) public {
266         DmlMarketplace dmp = DmlMarketplace(marketplace);
267         require(dmp.isModerator(msg.sender) || msg.sender == creator);
268         require(status == Status.BountyEnd);
269         require(newWinners.length == prizes.length);
270 
271         for (uint i = 0; i < newWinners.length; i++) {
272             require(participantsMap[newWinners[i]]);
273         }
274 
275         winners = newWinners;
276         setStatus(Status.EvaluationEnd);
277     }
278 
279     function forceUpdateWinners(address[] newWinners) public {
280         DmlMarketplace dmp = DmlMarketplace(marketplace);
281         require(dmp.isModerator(msg.sender));
282 
283         winners = newWinners;
284     }
285 
286     function payoutWinners() public {
287         ERC20Interface c = ERC20Interface(token);
288         DmlMarketplace dmp = DmlMarketplace(marketplace);
289 
290         require(dmp.isModerator(msg.sender) || msg.sender == creator);
291         require(isFunded());
292         require(winners.length == prizes.length);
293         require(status == Status.EvaluationEnd);
294 
295         for (uint i = 0; i < prizes.length; i++) {
296             require(c.transfer(winners[i], prizes[i]));
297         }
298         
299         setStatus(Status.Completed);
300     }
301     
302     function getTotalPrize() public constant returns (uint total) {
303         uint t = 0;
304         for (uint i = 0; i < prizes.length; i++) {
305             t = t + prizes[i];
306         }
307         return t;
308     }
309 
310     function transferToken (address receiver, uint amount) public {
311         DmlMarketplace dmp = DmlMarketplace(marketplace);
312         require(dmp.isModerator(msg.sender));
313         ERC20Interface c = ERC20Interface(token);
314         require(c.transfer(receiver, amount));
315     }
316     
317 }
318 
319 contract ERC20Interface {
320     function totalSupply() public constant returns (uint);
321     function balanceOf(address tokenOwner) public constant returns (uint balance);
322     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
323     function transfer(address to, uint tokens) public returns (bool success);
324     function approve(address spender, uint tokens) public returns (bool success);
325     function transferFrom(address from, address to, uint tokens) public returns (bool success);
326 }