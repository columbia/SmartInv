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
12     mapping(address => uint) public totals;
13     mapping(address => mapping(address => bool)) public hasPurchased;
14     address[] public algos;
15     mapping(address => address[]) public algosByCreator;
16     
17     constructor() public {
18         moderators[msg.sender] = true;
19     }
20     
21     function isReady() view public returns (bool success) {
22         if (token == address(0) || bountyFactory == address(0)) {
23             return false;
24         }
25 
26         return true;
27     }
28 
29     function isModerator(address modAddress) view public returns (bool success) {
30         return moderators[modAddress];
31     }
32 
33     function addModerator(address newModerator) public {
34         require(isModerator(msg.sender));
35         moderators[newModerator] = true;
36     }
37 
38     function removeModerator(address mod) public {
39         require(isModerator(msg.sender));
40         moderators[mod] = false;
41     }
42 
43     function addAlgo(uint price) public {
44         require(isReady());
45         Algo a = new Algo(price, msg.sender, token, address(this));
46         algos.push(a);
47         algosByCreator[msg.sender].push(a);
48     }
49 
50     function getAllAlgos() view public returns (address[] _algos) {
51         return algos;
52     }
53 
54     function getAlgosByCreator(address creatorAddress) view public returns (address[] _algos) {
55         return algosByCreator[creatorAddress];
56     }
57 
58     function init (address newTokenAddress) public returns (bool success) {
59         require(isModerator(msg.sender));
60         token = newTokenAddress;
61         DmlBountyFactory f = new DmlBountyFactory(token);
62         bountyFactory = f;
63         return true;
64     }
65 
66     function setBountyFactory(address factoryAddress) public {
67         require(isModerator(msg.sender));
68         DmlBountyFactory f = DmlBountyFactory(factoryAddress);
69         bountyFactory = f;
70     }
71     
72     function buy(address algoAddress, uint value) public returns (bool success) {
73         address sender = msg.sender;
74         
75         require(!hasPurchased[msg.sender][algoAddress]);
76 
77         ERC20Interface c = ERC20Interface(token);
78         
79         require(c.transferFrom(sender, algoAddress, value));
80 
81         hasPurchased[sender][algoAddress] = true;
82         
83         if (totals[algoAddress] < 1) {
84             totals[algoAddress] = 1;
85         } else {
86             totals[algoAddress]++;
87         }
88         
89         return true;
90     }
91 
92     function forceBuy(address algoAddress, address purchaser) public returns (bool success) {
93         require(isModerator(msg.sender));
94         hasPurchased[purchaser][algoAddress] = true;
95         return true;
96     }
97     
98     function transferToken (address receiver, uint amount) public {
99         require(isModerator(msg.sender));
100         
101         ERC20Interface c = ERC20Interface(token);
102         require(c.transfer(receiver, amount));
103     }
104 }
105 
106 contract DmlBountyFactory {
107     address public marketplace;
108     address public token;
109     address[] public allBountyAddresses;
110     mapping(address => address[]) public bountyAddressByCreator;
111     mapping(address => address[]) public bountyAddressByParticipant;
112     
113     constructor(address tokenAddress) public {
114         marketplace = msg.sender;
115         token = tokenAddress;
116     }
117 
118     function getAllBounties() view public returns (address[] bounties) {
119         return allBountyAddresses;
120     }
121 
122     function getBountiesByCreator(address creatorAddress) view public returns (address[] bounties) {
123         return bountyAddressByCreator[creatorAddress];
124     }
125 
126     function getBountiesByParticipant(address participantAddress) view public returns (address[] bounties) {
127         return bountyAddressByParticipant[participantAddress];
128     }
129     
130     function createBounty(string name, uint[] prizes) public {
131         address creator = msg.sender;
132         address newBounty = new Bounty(token, creator, name, prizes, marketplace);
133         allBountyAddresses.push(newBounty);
134         bountyAddressByCreator[msg.sender].push(newBounty);
135     }
136     
137     function joinBounty(address bountyAddress) public {
138         Bounty b = Bounty(bountyAddress);
139         
140         require(b.join(msg.sender));
141         
142         bountyAddressByParticipant[msg.sender].push(bountyAddress);
143     }
144 }
145 
146 contract Bounty {
147     // contract addresses
148     address public factory;
149     
150     // public constants
151     address public creator;
152     address public token;
153     address public marketplace;
154 
155     // state variables
156     string public name;
157     uint[] public prizes;
158     uint public createdAt;
159     address[] public winners;
160     address[] public participants;
161     Status public status;
162     mapping(address => bool) public participantsMap;
163 
164     enum Status {
165         Initialized,
166         EnrollmentStart,
167         EnrollmentEnd,
168         BountyStart,
169         BountyEnd,
170         EvaluationEnd,
171         Completed,
172         Paused,
173         Cancelled
174     }
175     
176     constructor(
177         address tokenAddress,
178         address creatorAddress,
179         string initName,
180         uint[] initPrizes,
181         address mpAddress
182     ) public {
183         factory = msg.sender;
184         marketplace = mpAddress;
185         creator = creatorAddress;
186         token = tokenAddress;
187         prizes = initPrizes;
188         status = Status.Initialized;
189         name = initName;
190         createdAt = now;
191     }
192     
193     function isFunded() public view returns (bool success) {
194         ERC20Interface c = ERC20Interface(token);
195         require(getTotalPrize() <= c.balanceOf(address(this)));
196         return true;
197     }
198 
199     function getData() public view returns (string retName, uint[] retPrizes, address[] retWinenrs, address[] retParticipants, Status retStatus, address retCreator, uint createdTime) {
200         return (name, prizes, winners, participants, status, creator, createdAt);
201     }
202     
203     function join(address participantAddress) public returns (bool success) {
204         require(msg.sender == factory);
205 
206         if (status != Status.EnrollmentStart) {
207             return false;
208         }
209         
210         if (participantsMap[participantAddress] == true) {
211             return false;
212         }
213         
214         participants.push(participantAddress);
215         participantsMap[participantAddress] = true;
216         
217         return true;
218     }
219 
220     function changeCreator(address _creator) public {
221         DmlMarketplace dmp = DmlMarketplace(marketplace);
222         require(dmp.isModerator(msg.sender));
223         creator = _creator;
224     } 
225 
226     function updateBounty(string newName, uint[] newPrizes) public {
227         require(updateName(newName));
228         require(updatePrizes(newPrizes));
229     }
230 
231     function updateName(string newName) public returns (bool success) {
232         DmlMarketplace dmp = DmlMarketplace(marketplace);
233         require(dmp.isModerator(msg.sender) || msg.sender == creator);
234         name = newName;
235         return true;
236     }
237 
238     function forceUpdateName(string newName) public returns (bool success) {
239         DmlMarketplace dmp = DmlMarketplace(marketplace);
240         require(dmp.isModerator(msg.sender));
241         name = newName;
242         return true;
243     }
244     
245     function updatePrizes(uint[] newPrizes) public returns (bool success) {
246         DmlMarketplace dmp = DmlMarketplace(marketplace);
247         require(dmp.isModerator(msg.sender) || msg.sender == creator);
248         require(status == Status.Initialized);
249         prizes = newPrizes;
250         return true;
251     }
252 
253     function forceUpdatePrizes(uint[] newPrizes) public returns (bool success) {
254         DmlMarketplace dmp = DmlMarketplace(marketplace);
255         require(dmp.isModerator(msg.sender));
256         prizes = newPrizes;
257         return true;
258     }
259 
260     function setStatus(Status newStatus) private returns (bool success) {
261         DmlMarketplace dmp = DmlMarketplace(marketplace);
262         require(dmp.isModerator(msg.sender) || msg.sender == creator);
263         status = newStatus;
264         return true;
265     }
266 
267     function forceSetStatus(Status newStatus) public returns (bool success) {
268         DmlMarketplace dmp = DmlMarketplace(marketplace);
269         require(dmp.isModerator(msg.sender));
270         status = newStatus;
271         return true;
272     }
273     
274     function startEnrollment() public {
275         require(status == Status.Initialized);
276         require(prizes.length > 0);
277         require(isFunded());
278         setStatus(Status.EnrollmentStart);
279     }
280     
281     function stopEnrollment() public {
282         require(status == Status.EnrollmentStart);
283         setStatus(Status.EnrollmentEnd);
284     }
285     
286     function startBounty() public {
287         require(status == Status.EnrollmentEnd);
288         setStatus(Status.BountyStart);
289     }
290     
291     function stopBounty() public {
292         require(status == Status.BountyStart);
293         setStatus(Status.BountyEnd);
294     }
295 
296     function updateWinners(address[] newWinners) public {
297         DmlMarketplace dmp = DmlMarketplace(marketplace);
298         require(dmp.isModerator(msg.sender) || msg.sender == creator);
299         require(status == Status.BountyEnd);
300         require(newWinners.length == prizes.length);
301 
302         for (uint i = 0; i < newWinners.length; i++) {
303             require(participantsMap[newWinners[i]]);
304         }
305 
306         winners = newWinners;
307         setStatus(Status.EvaluationEnd);
308     }
309 
310     function forceUpdateWinners(address[] newWinners) public {
311         DmlMarketplace dmp = DmlMarketplace(marketplace);
312         require(dmp.isModerator(msg.sender));
313 
314         winners = newWinners;
315     }
316 
317     function payoutWinners() public {
318         ERC20Interface c = ERC20Interface(token);
319         DmlMarketplace dmp = DmlMarketplace(marketplace);
320 
321         require(dmp.isModerator(msg.sender) || msg.sender == creator);
322         require(isFunded());
323         require(winners.length == prizes.length);
324         require(status == Status.EvaluationEnd);
325 
326         for (uint i = 0; i < prizes.length; i++) {
327             require(c.transfer(winners[i], prizes[i]));
328         }
329         
330         setStatus(Status.Completed);
331     }
332     
333     function getTotalPrize() public constant returns (uint total) {
334         uint t = 0;
335         for (uint i = 0; i < prizes.length; i++) {
336             t = t + prizes[i];
337         }
338         return t;
339     }
340 
341     function transferToken (address receiver, uint amount) public {
342         DmlMarketplace dmp = DmlMarketplace(marketplace);
343         require(dmp.isModerator(msg.sender));
344         ERC20Interface c = ERC20Interface(token);
345         require(c.transfer(receiver, amount));
346     }
347 }
348 
349 contract Algo {
350     // public constants
351     address public creator;
352     address public token;
353     address public marketplace;
354     uint public price;
355     Status public status;
356 
357     enum Status {
358         PendingReview,
359         Inactive,
360         Active
361     }
362 
363     constructor(
364         uint _price,
365         address _creator,
366         address _token,
367         address _marketplace
368     ) public {
369         price = _price;
370         marketplace = _marketplace;
371         token = _token;
372         creator = _creator;
373     }
374 
375     function updatePrice(uint _price) public {
376         require(isModOrCreator());
377         price = _price;
378     }
379 
380     function setActive() public {
381         require(isModOrCreator());
382         require(status == Status.Inactive);
383         status = Status.Active;
384     }
385 
386     function setInactive() public {
387         require(isModOrCreator());
388         require(status == Status.Active);
389         status = Status.Inactive;
390     }
391 
392     function approveAlgo() public {
393         require(isMod());
394         status = Status.Active;
395     }
396 
397     function setPendingReview() public {
398         require(isMod());
399         status = Status.PendingReview; 
400     }
401 
402     function changeCreator(address _creator) public {
403         DmlMarketplace dmp = DmlMarketplace(marketplace);
404         require(dmp.isModerator(msg.sender));
405         creator = _creator;
406     } 
407 
408     function getData() view public returns (uint _price, Status _status) {
409         return (price, status);
410     }
411 
412     function isMod() view private returns (bool success) {
413         DmlMarketplace dmp = DmlMarketplace(marketplace);
414         return (dmp.isModerator(msg.sender));
415     }
416 
417     function isModOrCreator() view private returns (bool success) {
418         return (isMod() || msg.sender == creator);
419     }
420 
421     function transferToken (address receiver, uint amount) public {
422         require(isModOrCreator());
423         ERC20Interface c = ERC20Interface(token);
424         require(c.transfer(receiver, amount));
425     }
426 }
427 
428 contract ERC20Interface {
429     function totalSupply() public constant returns (uint);
430     function balanceOf(address tokenOwner) public constant returns (uint balance);
431     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
432     function transfer(address to, uint tokens) public returns (bool success);
433     function approve(address spender, uint tokens) public returns (bool success);
434     function transferFrom(address from, address to, uint tokens) public returns (bool success);
435 }