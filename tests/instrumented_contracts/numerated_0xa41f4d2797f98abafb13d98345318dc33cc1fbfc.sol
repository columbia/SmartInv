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
90     address public storeAddress;
91     
92     function setMixGenAddress(address _address) external onlyOwner {
93         MixGenInterface candidateContract = MixGenInterface(_address);
94         require(candidateContract.isMixGen());
95         
96         geneScience = candidateContract;
97     }
98     
99     function setStoreAddress(address _address) external onlyOwner {
100         storeAddress = _address;
101     }
102         
103     function setRewardAddress(address _address) external onlyOwner {
104         reward = RewardContract(_address);
105     }
106 }
107 
108 // Population settings and base functions
109 contract PopulationControl is Pausable {
110     
111     // start breed timeout is 12 hours
112     uint32 public breedTimeout = 12 hours;
113     uint32 maxTimeout = 178 days;
114     
115     function setBreedTimeout(uint32 timeout) external onlyOwner {
116         require(timeout <= maxTimeout);
117         
118         breedTimeout = timeout;
119     }
120 }
121 
122 /**
123  *      Presale main contracts 
124  * 
125  **/
126 
127 // Pet base contract
128 contract PetBase is PopulationControl{
129     
130     // events
131     event Birth(address owner, uint64 petId, uint16 quality, uint256 genes);
132     event Death(uint64 petId);
133     
134     event Transfer(address from, address to, uint256 tokenId);
135     
136     // data storage
137     struct Pet {
138         uint256 genes;
139         uint64 birthTime;
140         uint16 quality;
141     }
142     
143     mapping (uint64 => Pet) pets;
144     mapping (uint64 => address) petIndexToOwner;
145     mapping (address => uint256) public ownershipTokenCount;
146     mapping (uint64 => uint64) breedTimeouts;
147  
148     uint64 tokensCount;
149     uint64 lastTokenId;
150 
151     // pet creation
152     function createPet(
153         uint256 _genes,
154         uint16 _quality,
155         address _owner
156     )
157         internal
158         returns (uint64)
159     {
160         Pet memory _pet = Pet({
161             genes: _genes,
162             birthTime: uint64(now),
163             quality: _quality
164         });
165                
166         lastTokenId++;
167         tokensCount++;
168 		
169         uint64 newPetId = lastTokenId;
170                 
171         pets[newPetId] = _pet;
172         
173         _transfer(0, _owner, newPetId);
174         
175         breedTimeouts[newPetId] = uint64( now + (breedTimeout / 2) );
176         emit Birth(_owner, newPetId, _quality, _genes);
177 
178         return newPetId;
179     }
180     
181     // transfer pet function
182     function _transfer(address _from, address _to, uint256 _tokenId) internal {
183         uint64 _tokenId64bit = uint64(_tokenId);
184         
185         ownershipTokenCount[_to]++;
186         petIndexToOwner[_tokenId64bit] = _to;
187         if (_from != address(0)) {
188             ownershipTokenCount[_from]--;
189         }
190         
191          emit Transfer(_from, _to, _tokenId);
192     }
193     
194 	// calculation of recommended price
195     function recommendedPrice(uint16 quality) public pure returns(uint256 price) {
196         
197         require(quality <= uint16(0xF000));
198         require(quality >= uint16(0x1000));
199         
200         uint256 startPrice = 1000;
201         
202         price = startPrice;
203         
204         uint256 revertQuality = uint16(0xF000) - quality;
205         uint256 oneLevel = uint16(0x2000);
206         uint256 oneQuart = oneLevel/4;
207         
208         uint256 fullLevels = revertQuality/oneLevel;
209         uint256 fullQuarts =  (revertQuality % oneLevel) / oneQuart ;
210         
211         uint256 surplus = revertQuality - (fullLevels*oneLevel) - (fullQuarts*oneQuart);
212         
213         
214         // coefficeint is 4.4 per level
215         price = price * 44**fullLevels;
216         price = price / 10**fullLevels;
217         
218         // quart coefficient is sqrt(sqrt(4.4))
219         if(fullQuarts != 0)
220         {
221             price = price * 14483154**fullQuarts;
222             price = price / 10**(7 * fullQuarts);
223         }
224 
225         // for surplus we using next quart coefficient
226         if(surplus != 0)
227         {
228             uint256 nextQuartPrice = (price * 14483154) / 10**7;
229             uint256 surPlusCoefficient = surplus * 10**6  /oneQuart;
230             uint256 surPlusPrice = ((nextQuartPrice - price) * surPlusCoefficient) / 10**6;
231             
232             price+= surPlusPrice;
233         }
234         
235         price*= 50 szabo;
236     }
237     
238 	// grade calculation based on parrot quality
239     function getGradeByQuailty(uint16 quality) public pure returns (uint8 grade) {
240         
241         require(quality <= uint16(0xF000));
242         require(quality >= uint16(0x1000));
243         
244         if(quality == uint16(0xF000))
245             return 7;
246         
247         quality+= uint16(0x1000);
248         
249         return uint8 ( quality / uint16(0x2000) );
250     }
251 }
252 
253 // Ownership
254 contract PetOwnership is PetBase {
255 
256     // function for the opportunity to gift parrots before the start of the game
257     function transfer(
258         address _to,
259         uint256 _tokenId
260     )
261         external
262         whenNotPaused
263     {
264         require(_to != address(0));
265         require(_to != address(this));
266         require(_owns(msg.sender, uint64(_tokenId)));
267 
268         _transfer(msg.sender, _to, _tokenId);
269     }
270  
271 	// checks if a given address is the current owner of a particular pet
272     function _owns(address _claimant, uint64 _tokenId) internal view returns (bool) {
273         return petIndexToOwner[_tokenId] == _claimant;
274     }
275     
276 	// returns the address currently assigned ownership of a given pet
277     function ownerOf(uint256 _tokenId) external view returns (address owner) {
278         uint64 _tokenId64bit = uint64(_tokenId);
279         owner = petIndexToOwner[_tokenId64bit];
280         
281         require(owner != address(0));
282     }   
283 }
284 
285 // Settings for eggs minted by administration
286 contract EggMinting is PetOwnership{
287     
288     uint8 public uniquePetsCount = 100;
289     
290     uint16 public globalPresaleLimit = 1500;
291 
292     mapping (uint16 => uint16) public eggLimits;
293     mapping (uint16 => uint16) public purchesedEggs;
294     
295     constructor() public {
296         eggLimits[55375] = 200;
297         eggLimits[47780] = 400;
298         eggLimits[38820] = 100;
299         eggLimits[31201] = 50;
300     }
301     
302     function totalSupply() public view returns (uint) {
303         return tokensCount;
304     }
305     
306     function setEggLimit(uint16 quality, uint16 limit) external onlyOwner {
307         eggLimits[quality] = limit;
308     }
309 
310     function eggAvailable(uint16 quality) constant public returns(bool) {
311         // first 100 eggs - only cheap
312         if( quality < 47000 && tokensCount < ( 100 + uniquePetsCount ) )
313            return false;
314         
315         return (eggLimits[quality] > purchesedEggs[quality]);
316     }
317 }
318 
319 // Buying eggs from the company
320 contract EggPurchase is EggMinting, ExternalContracts {
321     
322     uint16[4] discountThresholds =    [20, 100, 250, 500];
323     uint8[4]  discountPercents   =    [75, 50,  30,  20 ];
324     
325 	// purchasing egg
326     function purchaseEgg(uint64 userNumber, uint16 quality) external payable whenNotPaused {
327 
328         require(tokensCount >= uniquePetsCount);
329 		
330         // checking egg availablity
331         require(eggAvailable(quality));
332         
333         // checking total count of presale eggs
334         require(tokensCount <= globalPresaleLimit);
335 
336         // calculating price
337         uint256 eggPrice = ( recommendedPrice(quality) * (100 - getCurrentDiscountPercent()) ) / 100;
338 
339         // checking payment amount
340         require(msg.value >= eggPrice);
341         
342         // increment egg counter
343         purchesedEggs[quality]++;
344         
345         // initialize variables for store child genes and quility
346         uint256 childGenes;
347         uint16 childQuality;
348 
349         // get genes and quality of new pet by opening egg through external interface
350         (childGenes, childQuality) = geneScience.openEgg(userNumber, quality);
351          
352         // creating new pet
353         createPet(
354             childGenes,      // genes string
355             childQuality,    // child quality by open egg
356             msg.sender       // owner
357         );
358         
359         reward.get(msg.sender, recommendedPrice(quality));
360     }
361     
362     function getCurrentDiscountPercent() constant public returns (uint8 discount) {
363         
364         for(uint8 i = 0; i <= 3; i++)
365         {
366             if(tokensCount < (discountThresholds[i] + uniquePetsCount ))
367                 return discountPercents[i];
368         }
369         
370         return 10;
371     }
372 }
373 
374 // Launch it
375 contract PreSale is EggPurchase {
376     
377     constructor() public {
378         paused = true;
379     }
380         
381     function generateUniquePets(uint8 count) external onlyOwner whenNotPaused {
382         
383         require(storeAddress != address(0));
384         require(address(geneScience) != address(0));
385         require(tokensCount < uniquePetsCount);
386         
387         uint256 childGenes;
388         uint16 childQuality;
389         uint64 newPetId;
390 
391         for(uint8 i = 0; i< count; i++)
392         {
393             if(tokensCount >= uniquePetsCount)
394                 continue;
395             
396             newPetId = tokensCount+1;
397 
398             (childGenes, childQuality) = geneScience.uniquePet(newPetId);
399             createPet(childGenes, childQuality, storeAddress);
400         }
401     }
402     
403     function getPet(uint256 _id) external view returns (
404         uint64 birthTime,
405         uint256 genes,
406         uint64 breedTimeout,
407         uint16 quality,
408         address owner
409     ) {
410         uint64 _tokenId64bit = uint64(_id);
411         
412         Pet storage pet = pets[_tokenId64bit];
413         
414         birthTime = pet.birthTime;
415         genes = pet.genes;
416         breedTimeout = uint64(breedTimeouts[_tokenId64bit]);
417         quality = pet.quality;
418         owner = petIndexToOwner[_tokenId64bit];
419     }
420     
421     function unpause() public onlyOwner whenPaused {
422         require(address(geneScience) != address(0));
423 		require(address(reward) != address(0));
424 
425         super.unpause();
426     }
427     
428     function withdrawBalance(uint256 summ) external onlyCFO {
429         cfoAddress.transfer(summ);
430     }
431 }