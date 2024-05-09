1 pragma solidity ^0.4.23;
2 
3 /**
4  *      Preparing contracts 
5  * 
6  **/
7 
8 // Ownable contract with CFO
9 contract Ownable {
10     address public owner;
11     address public cfoAddress;
12 
13     constructor() public{
14         owner = msg.sender;
15         cfoAddress = msg.sender;
16     }
17 
18     modifier onlyOwner() {
19         require(msg.sender == owner);
20         _;
21     }
22     
23     modifier onlyCFO() {
24         require(msg.sender == cfoAddress);
25         _;
26     }
27 
28     function transferOwnership(address newOwner) external onlyOwner {
29         if (newOwner != address(0)) {
30             owner = newOwner;
31         }
32     }
33     
34     function setCFO(address newCFO) external onlyOwner {
35         require(newCFO != address(0));
36 
37         cfoAddress = newCFO;
38     }
39 }
40 
41 // Pausable contract which allows children to implement an emergency stop mechanism.
42 contract Pausable is Ownable {
43     event Pause();
44     event Unpause();
45 
46     bool public paused = false;
47 
48     // Modifier to make a function callable only when the contract is not paused.
49     modifier whenNotPaused() {
50         require(!paused);
51         _;
52     }
53 
54     // Modifier to make a function callable only when the contract is paused.
55     modifier whenPaused() {
56         require(paused);
57         _;
58     }
59 
60 
61     // called by the owner to pause, triggers stopped state
62     function pause() onlyOwner whenNotPaused public {
63         paused = true;
64         emit Pause();
65     }
66 
67     // called by the owner to unpause, returns to normal state
68     function unpause() onlyOwner whenPaused public {
69         paused = false;
70         emit Unpause();
71     }
72 }
73 
74 // Gen mixer
75 contract MixGenInterface {
76     function isMixGen() public pure returns (bool);
77     function openEgg(uint64 userNumber, uint16 eggQuality) public returns (uint256 genes, uint16 quality);
78     function uniquePet(uint64 newPetId) public returns (uint256 genes, uint16 quality);
79 }
80 
81 contract RewardContract {
82      function get(address receiver, uint256 ethValue) external;
83 }
84 
85 // Configuration of external contracts
86 contract ExternalContracts is Ownable {
87     MixGenInterface public geneScience;
88     RewardContract public reward;
89     
90     function setMixGenAddress(address _address) external onlyOwner {
91         MixGenInterface candidateContract = MixGenInterface(_address);
92         require(candidateContract.isMixGen());
93         
94         geneScience = candidateContract;
95     }
96         
97     function setRewardAddress(address _address) external onlyOwner {
98         reward = RewardContract(_address);
99     }
100 }
101 
102 // Population settings and base functions
103 contract PopulationControl is Pausable {
104     
105     // start breed timeout is 12 hours
106     uint32 public breedTimeout = 12 hours;
107     uint32 maxTimeout = 178 days;
108     
109     function setBreedTimeout(uint32 timeout) external onlyOwner {
110         require(timeout <= maxTimeout);
111         
112         breedTimeout = timeout;
113     }
114 }
115 
116 /**
117  *      Presale main contracts 
118  * 
119  **/
120 
121 // Pet base contract
122 contract PetBase is PopulationControl{
123     
124     // events
125     event Birth(address owner, uint64 petId, uint16 quality, uint256 genes);
126     event Death(uint64 petId);
127     
128     event Transfer(address from, address to, uint256 tokenId);
129     
130     // data storage
131     struct Pet {
132         uint256 genes;
133         uint64 birthTime;
134         uint16 quality;
135     }
136     
137     mapping (uint64 => Pet) pets;
138     mapping (uint64 => address) petIndexToOwner;
139     mapping (address => uint256) public ownershipTokenCount;
140     mapping (uint64 => uint64) breedTimeouts;
141  
142     uint64 tokensCount;
143     uint64 lastTokenId;
144 
145     // pet creation
146     function createPet(
147         uint256 _genes,
148         uint16 _quality,
149         address _owner
150     )
151         internal
152         returns (uint64)
153     {
154         Pet memory _pet = Pet({
155             genes: _genes,
156             birthTime: uint64(now),
157             quality: _quality
158         });
159                
160         lastTokenId++;
161         tokensCount++;
162 		
163         uint64 newPetId = lastTokenId;
164                 
165         pets[newPetId] = _pet;
166         
167         _transfer(0, _owner, newPetId);
168         
169         breedTimeouts[newPetId] = uint64( now + (breedTimeout / 2) );
170         emit Birth(_owner, newPetId, _quality, _genes);
171 
172         return newPetId;
173     }
174     
175     // transfer pet function
176     function _transfer(address _from, address _to, uint256 _tokenId) internal {
177         uint64 _tokenId64bit = uint64(_tokenId);
178         
179         ownershipTokenCount[_to]++;
180         petIndexToOwner[_tokenId64bit] = _to;
181         if (_from != address(0)) {
182             ownershipTokenCount[_from]--;
183         }
184         
185          emit Transfer(_from, _to, _tokenId);
186     }
187     
188 	// calculation of recommended price
189     function recommendedPrice(uint16 quality) public pure returns(uint256 price) {
190         
191         require(quality <= uint16(0xF000));
192         require(quality >= uint16(0x1000));
193         
194         uint256 startPrice = 1000;
195         
196         price = startPrice;
197         
198         uint256 revertQuality = uint16(0xF000) - quality;
199         uint256 oneLevel = uint16(0x2000);
200         uint256 oneQuart = oneLevel/4;
201         
202         uint256 fullLevels = revertQuality/oneLevel;
203         uint256 fullQuarts =  (revertQuality % oneLevel) / oneQuart ;
204         
205         uint256 surplus = revertQuality - (fullLevels*oneLevel) - (fullQuarts*oneQuart);
206         
207         
208         // coefficeint is 4.4 per level
209         price = price * 44**fullLevels;
210         price = price / 10**fullLevels;
211         
212         // quart coefficient is sqrt(sqrt(4.4))
213         if(fullQuarts != 0)
214         {
215             price = price * 14483154**fullQuarts;
216             price = price / 10**(7 * fullQuarts);
217         }
218 
219         // for surplus we using next quart coefficient
220         if(surplus != 0)
221         {
222             uint256 nextQuartPrice = (price * 14483154) / 10**7;
223             uint256 surPlusCoefficient = surplus * 10**6  /oneQuart;
224             uint256 surPlusPrice = ((nextQuartPrice - price) * surPlusCoefficient) / 10**6;
225             
226             price+= surPlusPrice;
227         }
228         
229         price*= 5 szabo;
230     }
231     
232 	// grade calculation based on parrot quality
233     function getGradeByQuailty(uint16 quality) public pure returns (uint8 grade) {
234         
235         require(quality <= uint16(0xF000));
236         require(quality >= uint16(0x1000));
237         
238         if(quality == uint16(0xF000))
239             return 7;
240         
241         quality+= uint16(0x1000);
242         
243         return uint8 ( quality / uint16(0x2000) );
244     }
245 }
246 
247 // Ownership
248 contract PetOwnership is PetBase {
249 
250     // function for the opportunity to gift parrots before the start of the game
251     function transfer(
252         address _to,
253         uint256 _tokenId
254     )
255         external
256         whenNotPaused
257     {
258         require(_to != address(0));
259         require(_to != address(this));
260         require(_owns(msg.sender, uint64(_tokenId)));
261 
262         _transfer(msg.sender, _to, _tokenId);
263     }
264  
265 	// checks if a given address is the current owner of a particular pet
266     function _owns(address _claimant, uint64 _tokenId) internal view returns (bool) {
267         return petIndexToOwner[_tokenId] == _claimant;
268     }
269     
270 	// returns the address currently assigned ownership of a given pet
271     function ownerOf(uint256 _tokenId) external view returns (address owner) {
272         uint64 _tokenId64bit = uint64(_tokenId);
273         owner = petIndexToOwner[_tokenId64bit];
274         
275         require(owner != address(0));
276     }   
277 }
278 
279 // Settings for eggs minted by administration
280 contract EggMinting is PetOwnership{
281     
282     uint8 public uniquePetsCount = 100;
283     
284     uint16 public globalPresaleLimit = 1500;
285 
286     mapping (uint16 => uint16) public eggLimits;
287     mapping (uint16 => uint16) public purchesedEggs;
288     
289     constructor() public {
290         eggLimits[42689] = 200;
291         eggLimits[36070] = 200;
292     }
293     
294     function totalSupply() public view returns (uint) {
295         return tokensCount;
296     }
297     
298     function setEggLimit(uint16 quality, uint16 limit) external onlyOwner {
299         eggLimits[quality] = limit;
300     }
301 
302     function eggAvailable(uint16 quality) constant public returns(bool) {
303         return (eggLimits[quality] > purchesedEggs[quality]);
304     }
305 }
306 
307 // Buying eggs from the company
308 contract EggPurchase is EggMinting, ExternalContracts {
309     
310     uint16[4] discountThresholds =    [20, 100, 300, 500];
311     uint8[4]  discountPercents   =    [75, 50,  30,  20 ];
312     
313 	// purchasing egg
314     function purchaseEgg(uint64 userNumber, uint16 quality) external payable whenNotPaused {
315 	
316         // checking egg availablity
317         require(eggAvailable(quality));
318         
319         // checking total count of presale eggs
320         require(tokensCount <= globalPresaleLimit);
321 
322         // calculating price
323         uint256 eggPrice = ( recommendedPrice(quality) * (100 - getCurrentDiscountPercent()) ) / 100;
324 
325         // checking payment amount
326         require(msg.value >= eggPrice);
327         
328         // increment egg counter
329         purchesedEggs[quality]++;
330         
331         // initialize variables for store child genes and quility
332         uint256 childGenes;
333         uint16 childQuality;
334 
335         // get genes and quality of new pet by opening egg through external interface
336         (childGenes, childQuality) = geneScience.openEgg(userNumber, quality);
337          
338         // creating new pet
339         createPet(
340             childGenes,      // genes string
341             childQuality,    // child quality by open egg
342             msg.sender       // owner
343         );
344         
345         reward.get(msg.sender, recommendedPrice(quality));
346     }
347     
348     function getCurrentDiscountPercent() constant public returns (uint8 discount) {
349         
350         for(uint8 i = 0; i <= 3; i++)
351         {
352             if(tokensCount < (discountThresholds[i] + uniquePetsCount ))
353                 return discountPercents[i];
354         }
355         
356         return 10;
357     }
358 }
359 
360 // contracts for migrate unique pets from first presale contract
361 contract PreSaleOne {
362     function getPet(uint256 _id) external view returns (uint64 birthTime, uint256 genes, uint64 breedTimeout, uint16 quality, address owner);
363     function totalSupply() public view returns (uint);
364 }
365 
366 contract Migrate is Pausable, PetBase, EggMinting {
367     PreSaleOne public presaleOne;
368     uint256 public presaleOneSupply;
369     
370     constructor() public {
371         presaleOne = PreSaleOne(0xa41f4d2797f98abafb13d98345318dc33cc1fbfc);
372     }
373 
374     function migratePets(uint8 count) external onlyOwner whenPaused {
375         
376         for(uint8 i = 0; i< count; i++)
377         {
378             if(tokensCount >= uniquePetsCount)
379                 continue;
380                 
381             uint64 newPetId = tokensCount+1;
382             
383             (uint64 birthTime, uint256 genes, uint64 breedTimeout, uint16 quality, address owner) = presaleOne.getPet(newPetId);
384             if(birthTime == 0 || breedTimeout == 0 || quality == 0 || owner == address(0) || genes == 0)
385                 continue;
386                 
387             migratePet(birthTime, genes, breedTimeout, quality, owner);
388         }
389     }
390     
391     // same function as createPet, but with setting birth time and breed timout
392     function migratePet(
393         uint64 _birthTime,
394         uint256 _genes,
395         uint64 _breedTimeout,
396         uint16 _quality,
397         address _owner
398     )
399         internal
400         returns (uint64)
401     {
402         Pet memory _pet = Pet({
403             genes: _genes,
404             birthTime: _birthTime,
405             quality: _quality
406         });
407                
408         lastTokenId++;
409         tokensCount++;
410 		
411         uint64 newPetId = lastTokenId;
412                 
413         pets[newPetId] = _pet;
414         
415         _transfer(0, _owner, newPetId);
416         
417         breedTimeouts[newPetId] = _breedTimeout;
418         emit Birth(_owner, newPetId, _quality, _genes);
419 
420         return newPetId;
421     }
422 }
423 
424 // Launch it
425 contract PreSaleTwo is EggPurchase, Migrate {
426     
427     constructor() public {
428         paused = true;
429     }
430     
431     function getPet(uint256 _id) external view returns (
432         uint64 birthTime,
433         uint256 genes,
434         uint64 breedTimeout,
435         uint16 quality,
436         address owner
437     ) {
438         if(_id > 100 && _id <= presaleOneSupply)
439             return presaleOne.getPet(_id);
440         
441         uint64 _tokenId64bit = uint64(_id);
442         
443         Pet storage pet = pets[_tokenId64bit];
444         
445         birthTime = pet.birthTime;
446         genes = pet.genes;
447         breedTimeout = uint64(breedTimeouts[_tokenId64bit]);
448         quality = pet.quality;
449         owner = petIndexToOwner[_tokenId64bit];
450     }
451     
452     function unpause() public onlyOwner whenPaused {
453         require(address(geneScience) != address(0));
454 		require(address(reward) != address(0));
455 		
456 		// if count of pets is less than in first contract - start count from last id
457 		presaleOneSupply = presaleOne.totalSupply();
458 		require(presaleOneSupply != 0);
459 		    
460 		if(tokensCount < presaleOneSupply)
461 		{
462 		    tokensCount = uint64(presaleOneSupply);
463 		    lastTokenId = tokensCount;
464         }
465         
466         super.unpause();
467     }
468     
469     function withdrawBalance(uint256 summ) external onlyCFO {
470         cfoAddress.transfer(summ);
471     }
472 }