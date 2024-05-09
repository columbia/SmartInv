1 pragma solidity ^0.4.25;
2 
3 // just ownable contract
4 contract Ownable {
5     address public owner;
6 
7     constructor() public{
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) external onlyOwner {
17         if (newOwner != address(0)) {
18             owner = newOwner;
19         }
20     }
21 }
22 
23 // Pausable contract which allows children to implement an emergency stop mechanism.
24 contract Pausable is Ownable {
25     event Pause();
26     event Unpause();
27 
28     bool public paused = false;
29 
30     // Modifier to make a function callable only when the contract is not paused.
31     modifier whenNotPaused() {
32         require(!paused);
33         _;
34     }
35 
36     // Modifier to make a function callable only when the contract is paused.
37     modifier whenPaused() {
38         require(paused);
39         _;
40     }
41 
42 
43     // Сalled by the owner to pause, triggers stopped state
44     function pause() onlyOwner whenNotPaused public {
45         paused = true;
46         emit Pause();
47     }
48 
49     // Сalled by the owner to unpause, returns to normal state
50     function unpause() onlyOwner whenPaused public {
51         paused = false;
52         emit Unpause();
53     }
54 }
55 
56 // Interface for pet contract
57 contract ParentInterface {
58     function ownerOf(uint256 _tokenId) external view returns (address owner);
59     function getPet(uint256 _id) external view returns (uint64 birthTime, uint256 genes,uint64 breedTimeout,uint16 quality,address owner);
60     function totalSupply() public view returns (uint);
61 }
62 
63 // Simple utils, which calculate circle seats and grade by quality
64 contract Utils {
65     
66     function getGradeByQuailty(uint16 quality) public pure returns (uint8 grade) {
67         
68         require(quality <= uint16(0xF000));
69         require(quality >= uint16(0x1000));
70         
71         if(quality == uint16(0xF000))
72             return 7;
73         
74         quality+= uint16(0x1000);
75         
76         return uint8 ( quality / uint16(0x2000) );
77     }
78     
79     function seatsByGrade(uint8 grade) public pure returns(uint8 seats) {
80 	    if(grade > 4)
81 	        return 1;
82 	
83 		seats = 8 - grade - 2;
84 
85 		return seats;
86 	}
87 }
88 
89 // Main contract, which calculating queue
90 contract ReferralQueue {
91     
92     // ID in circle
93     uint64 currentReceiverId = 1;
94 
95     // Circle length
96     uint64 public circleLength;
97     
98     // Store queue of referral circle
99     struct ReferralSeat {
100         uint64 petId;
101         uint64 givenPetId;
102     }
103     
104     mapping (uint64 => ReferralSeat) public referralCircle;
105     
106     // Store simple information about each pet: parent parrot and current referral reward
107     struct PetInfo {
108         uint64 parentId;
109         uint256 amount;
110     }
111     
112     mapping (uint64 => PetInfo) public petsInfo;
113 
114     
115     function addPetIntoCircle(uint64 _id, uint8 _seats) internal {
116         
117         // Adding seats into queue
118         for(uint8 i=0; i < _seats; i++)
119 		{
120 		    ReferralSeat memory _seat = ReferralSeat({
121                 petId: _id,
122                 givenPetId: 0
123             });
124 
125             // Increasing circle length and save current seat in circle            
126             circleLength++;
127             referralCircle[circleLength] = _seat;
128 		}
129 		
130 		// Attach the parrot to the current receiver in the circle 
131 		// First 3 parrots adding without attaching
132 		if(_id>103) {
133 		    
134 		    referralCircle[currentReceiverId].givenPetId = _id;
135 		    
136 		    // adding new pet into information list
137 		    PetInfo memory petInfo = PetInfo({
138 		        parentId: referralCircle[currentReceiverId].petId,
139 		        amount: 0
140 		    });
141 		    
142 		    petsInfo[_id] = petInfo;
143 		    
144 		    // Increace circle receiver ID
145             currentReceiverId++;
146         }
147     }
148     
149     // Current pet ID in circle for automatical attach
150     function getCurrentReceiverId() view public returns(uint64 receiverId) {
151         
152         return referralCircle[currentReceiverId].petId;
153     }
154 }
155 
156 contract Reward is ReferralQueue {
157     
158     // Getting egg price by id and quality
159     function getEggPrice(uint64 _petId, uint16 _quality) pure public returns(uint256 price) {
160         		
161         uint64[6] memory egg_prices = [0, 150 finney, 600 finney, 3 ether, 12 ether, 600 finney];
162         
163 		uint8 egg = 2;
164 	
165 		if(_quality > 55000)
166 		    egg = 1;
167 			
168 		if(_quality > 26000 && _quality < 26500)
169 			egg = 3;
170 			
171 		if(_quality > 39100 && _quality < 39550)
172 			egg = 3;
173 			
174 		if(_quality > 31000 && _quality < 31250)
175 			egg = 4;
176 			
177 		if(_quality > 34500 && _quality < 35500)
178 			egg = 5;
179 			
180 		price = egg_prices[egg];
181 		
182 		uint8 discount = 10;
183 		
184 		if(_petId<= 600)
185 			discount = 20;
186 		if(_petId<= 400)
187 			discount = 30;
188 		if(_petId<= 200)
189 			discount = 50;
190 		if(_petId<= 120)
191 			discount = 80;
192 		
193 		price = price - (price*discount / 100);
194     }
195     
196     // Save rewards for all referral levels
197     function applyReward(uint64 _petId, uint16 _quality) internal {
198         
199         uint8[6] memory rewardByLevel = [0,250,120,60,30,15];
200         
201         uint256 eggPrice = getEggPrice(_petId, _quality);
202         
203         uint64 _currentPetId = _petId;
204         
205         // make rewards for 5 levels
206         for(uint8 level=1; level<=5; level++) {
207             uint64 _parentId = petsInfo[_currentPetId].parentId;
208             // if no parent referral - break
209             if(_parentId == 0)
210                 break;
211             
212             // increase pet balance
213             petsInfo[_parentId].amount+= eggPrice * rewardByLevel[level] / 1000;
214             
215             // get parent id from parent id to move to the next level
216             _currentPetId = _parentId;
217         }
218         
219     }
220     
221     // Save rewards for all referral levels
222     function applyRewardByAmount(uint64 _petId, uint256 _price) internal {
223         
224         uint8[6] memory rewardByLevel = [0,250,120,60,30,15];
225         
226         uint64 _currentPetId = _petId;
227         
228         // Make rewards for 5 levels
229         for(uint8 i=1; i<=5; i++) {
230             uint64 _parentId = petsInfo[_currentPetId].parentId;
231             // if no parent referral - break
232             if(_parentId == 0)
233                 break;
234             
235             // Increase pet balance
236             petsInfo[_parentId].amount+= _price * rewardByLevel[i] / 1000;
237             
238             // Get parent id from parent id to move to the next level
239             _currentPetId = _parentId;
240         }
241         
242     }
243 }
244 
245 // Launch it
246 contract ReferralCircle is Reward, Utils, Pausable {
247     
248     // Interface link
249     ParentInterface public parentInterface;
250     
251     // Limit of manual synchronization repeats
252     uint8 public syncLimit = 5;
253     
254     // Pet counter
255     uint64 public lastPetId = 100;
256     
257     // Manual sync enabled
258     bool public petSyncEnabled = true;
259     
260     // Setting default parent interface    
261     constructor() public {
262         parentInterface = ParentInterface(0x115f56742474f108AD3470DDD857C31a3f626c3C);
263     }
264 
265     // Disable manual synchronization
266     function disablePetSync() external onlyOwner {
267         petSyncEnabled = false;
268     }
269 
270     // Enable manual synchronization
271     function enablePetSync() external onlyOwner {
272         petSyncEnabled = true;
273     }
274     
275     // Make synchronization, available for any sender
276     function sync() external whenNotPaused {
277         
278         // Checking synchronization status
279         require(petSyncEnabled);
280         
281         // Get supply of pets from parent contract
282         uint64 petSupply = uint64(parentInterface.totalSupply());
283         require(petSupply > lastPetId);
284 
285         // Synchronize pets        
286         for(uint8 i=0; i < syncLimit; i++)
287         {
288             lastPetId++;
289             
290             if(lastPetId > petSupply)
291             {
292                 lastPetId = petSupply;
293                 break;
294             }
295             
296             addPet(lastPetId);
297         }
298     }
299     
300     // Change synchronization limit by owner
301     function setSyncLimit(uint8 _limit) external onlyOwner {
302         syncLimit = _limit;
303     }
304 
305     // Function of manual add pet    
306     function addPet(uint64 _id) internal {
307         (uint64 birthTime, uint256 genes, uint64 breedTimeout, uint16 quality, address owner) = parentInterface.getPet(_id);
308         
309         uint16 gradeQuality = quality;
310 
311         // For first pets - bonus quality in grade calculating
312         if(_id < 244)
313 			gradeQuality = quality - 13777;
314 			
315 		// Calculating seats in circle
316         uint8 petGrade = getGradeByQuailty(gradeQuality);
317         uint8 petSeats = seatsByGrade(petGrade);
318         
319         // Adding pet into circle
320         addPetIntoCircle(_id, petSeats);
321         
322         // Save reward for each referral level
323         applyReward(_id, quality);
324     }
325     
326     // Function for automatic add pet
327     function automaticPetAdd(uint256 _price, uint16 _quality, uint64 _id) external {
328         require(!petSyncEnabled);
329         require(msg.sender == address(parentInterface));
330         
331         lastPetId = _id;
332         
333         // Calculating seats in circle
334         uint8 petGrade = getGradeByQuailty(_quality);
335         uint8 petSeats = seatsByGrade(petGrade);
336         
337         // Adding pet into circle
338         addPetIntoCircle(_id, petSeats);
339         
340         // Save reward for each referral level
341         applyRewardByAmount(_id, _price);
342     }
343     
344     // Function for withdraw reward by pet owner
345     function withdrawReward(uint64 _petId) external whenNotPaused {
346         
347         // Get pet information
348         PetInfo memory petInfo = petsInfo[_petId];
349         
350         // Get owner of pet from pet contract and check it
351          (uint64 birthTime, uint256 genes, uint64 breedTimeout, uint16 quality, address petOwner) = parentInterface.getPet(_petId);
352         require(petOwner == msg.sender);
353 
354         // Transfer reward
355         msg.sender.transfer(petInfo.amount);
356         
357         // Change reward amount in pet information
358         petInfo.amount = 0;
359         petsInfo[_petId] = petInfo;
360     }
361     
362     // Emergency reward sending by admin
363     function sendRewardByAdmin(uint64 _petId) external onlyOwner whenNotPaused {
364         
365         // Get pet information
366         PetInfo memory petInfo = petsInfo[_petId];
367         
368         // Get owner of pet from pet contract and check it
369         (uint64 birthTime, uint256 genes, uint64 breedTimeout, uint16 quality, address petOwner) = parentInterface.getPet(_petId);
370 
371         // Transfer reward
372         petOwner.transfer(petInfo.amount);
373         
374         // Change reward amount in pet information
375         petInfo.amount = 0;
376         petsInfo[_petId] = petInfo;
377     }
378         
379     // Change parent contract
380     function setParentAddress(address _address) public whenPaused onlyOwner
381     {
382         parentInterface = ParentInterface(_address);
383     }
384 
385     // Just refill    
386     function () public payable {}
387     
388     // Withdraw balance by owner
389     function withdrawBalance(uint256 summ) external onlyOwner {
390         owner.transfer(summ);
391     }
392 }