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
76     function openEgg(uint64 userNumber, uint16 eggQuality) public returns (uint256 genes, uint16 quality);
77     function uniquePet(uint64 newPetId) public returns (uint256 genes, uint16 quality);
78 }
79 
80 // Configuration of external contracts
81 contract ExternalContracts is Ownable {
82     MixGenInterface public geneScience;
83     
84     address public marketAddress;
85     
86     function setMixGenAddress(address _address) external onlyOwner {
87         MixGenInterface candidateContract = MixGenInterface(_address);
88         
89         geneScience = candidateContract;
90     }
91     
92     function setMarketAddress(address _address) external onlyOwner {
93         marketAddress = _address;
94     }
95 }
96 
97 // Population settings and base functions
98 contract PopulationControl is Pausable {
99     
100     // start breed timeout is 12 hours
101     uint32 public breedTimeout = 12 hours;
102     uint32 maxTimeout = 178 days;
103     
104     function setBreedTimeout(uint32 timeout) external onlyOwner {
105         require(timeout <= maxTimeout);
106         
107         breedTimeout = timeout;
108     }
109 }
110 
111 /**
112  *      Presale main contracts 
113  * 
114  **/
115 
116 // Pet base contract
117 contract PetBase is PopulationControl{
118     
119     // events
120     event Birth(address owner, uint64 petId, uint16 quality, uint256 genes);
121     event Death(uint64 petId);
122     
123     event Transfer(address from, address to, uint256 tokenId);
124     
125     // data storage
126     struct Pet {
127         uint256 genes;
128         uint64 birthTime;
129         uint16 quality;
130     }
131     
132     mapping (uint64 => Pet) pets;
133     mapping (uint64 => address) petIndexToOwner;
134     mapping (address => uint256) public ownershipTokenCount;
135     mapping (uint64 => uint64) breedTimeouts;
136  
137     uint64 tokensCount;
138     uint64 lastTokenId;
139 
140     // pet creation
141     function createPet(
142         uint256 _genes,
143         uint16 _quality,
144         address _owner
145     )
146         internal
147         returns (uint64)
148     {
149         Pet memory _pet = Pet({
150             genes: _genes,
151             birthTime: uint64(now),
152             quality: _quality
153         });
154                
155         lastTokenId++;
156         tokensCount++;
157 		
158         uint64 newPetId = lastTokenId;
159                 
160         pets[newPetId] = _pet;
161         
162         _transfer(0, _owner, newPetId);
163         
164         breedTimeouts[newPetId] = uint64( now + (breedTimeout / 2) );
165         emit Birth(_owner, newPetId, _quality, _genes);
166 
167         return newPetId;
168     }
169     
170     // transfer pet function
171     function _transfer(address _from, address _to, uint256 _tokenId) internal {
172         uint64 _tokenId64bit = uint64(_tokenId);
173         
174         ownershipTokenCount[_to]++;
175         petIndexToOwner[_tokenId64bit] = _to;
176         if (_from != address(0)) {
177             ownershipTokenCount[_from]--;
178         }
179         
180          emit Transfer(_from, _to, _tokenId);
181     }
182     
183 	// calculation of recommended price
184     function recommendedPrice(uint16 quality) public pure returns(uint256 price) {
185         
186         require(quality <= uint16(0xF000));
187         require(quality >= uint16(0x1000));
188         
189         uint256 startPrice = 1000;
190         
191         price = startPrice;
192         
193         uint256 revertQuality = uint16(0xF000) - quality;
194         uint256 oneLevel = uint16(0x2000);
195         uint256 oneQuart = oneLevel/4;
196         
197         uint256 fullLevels = revertQuality/oneLevel;
198         uint256 fullQuarts =  (revertQuality % oneLevel) / oneQuart ;
199         
200         uint256 surplus = revertQuality - (fullLevels*oneLevel) - (fullQuarts*oneQuart);
201         
202         
203         // coefficeint is 4.4 per level
204         price = price * 44**fullLevels;
205         price = price / 10**fullLevels;
206         
207         // quart coefficient is sqrt(sqrt(4.4))
208         if(fullQuarts != 0)
209         {
210             price = price * 14483154**fullQuarts;
211             price = price / 10**(7 * fullQuarts);
212         }
213 
214         // for surplus we using next quart coefficient
215         if(surplus != 0)
216         {
217             uint256 nextQuartPrice = (price * 14483154) / 10**7;
218             uint256 surPlusCoefficient = surplus * 10**6  /oneQuart;
219             uint256 surPlusPrice = ((nextQuartPrice - price) * surPlusCoefficient) / 10**6;
220             
221             price+= surPlusPrice;
222         }
223         
224         price*= 50 szabo;
225     }
226     
227 	// grade calculation based on parrot quality
228     function getGradeByQuailty(uint16 quality) public pure returns (uint8 grade) {
229         
230         require(quality <= uint16(0xF000));
231         require(quality >= uint16(0x1000));
232         
233         if(quality == uint16(0xF000))
234             return 7;
235         
236         quality+= uint16(0x1000);
237         
238         return uint8 ( quality / uint16(0x2000) );
239     }
240 }
241 
242 // Ownership
243 contract PetOwnership is PetBase {
244 
245     // function for the opportunity to gift parrots before the start of the game
246     function transfer(
247         address _to,
248         uint256 _tokenId
249     )
250         external
251         whenNotPaused
252     {
253         require(_to != address(0));
254         require(_to != address(this));
255         require(_owns(msg.sender, uint64(_tokenId)));
256 
257         _transfer(msg.sender, _to, _tokenId);
258     }
259  
260 	// checks if a given address is the current owner of a particular pet
261     function _owns(address _claimant, uint64 _tokenId) internal view returns (bool) {
262         return petIndexToOwner[_tokenId] == _claimant;
263     }
264     
265 	// returns the address currently assigned ownership of a given pet
266     function ownerOf(uint256 _tokenId) external view returns (address owner) {
267         uint64 _tokenId64bit = uint64(_tokenId);
268         owner = petIndexToOwner[_tokenId64bit];
269         
270         require(owner != address(0));
271     }   
272 }
273 
274 // Settings for eggs minted by administration
275 contract EggMinting is PetOwnership{
276     
277     uint8 public uniquePetsCount = 100;
278     
279     uint16 public globalPresaleLimit = 2500;
280 
281     mapping (uint16 => uint16) public eggLimits;
282     mapping (uint16 => uint16) public purchesedEggs;
283     
284     constructor() public {
285         eggLimits[55375] = 200;
286         eggLimits[48770] = 1100;
287         eggLimits[39904] = 200;
288         eggLimits[32223] = 25;
289     }
290     
291     function totalSupply() public view returns (uint) {
292         return tokensCount;
293     }
294     
295     function setEggLimit(uint16 quality, uint16 limit) external onlyOwner {
296         eggLimits[quality] = limit;
297     }
298 
299     function eggAvailable(uint16 quality) constant public returns(bool) {
300         // first 100 eggs - only cheap
301         if( quality < 48000 && tokensCount < ( 100 + uniquePetsCount ) )
302            return false;
303         
304         return (eggLimits[quality] > purchesedEggs[quality]);
305     }
306 }
307 
308 // Buying eggs from the company
309 contract EggPurchase is EggMinting, ExternalContracts {
310     
311     uint16[4] discountThresholds =    [20, 100, 500, 1000];
312     uint8[4]  discountPercents   =    [75, 50,  30,  20  ];
313     
314 	// purchasing egg
315     function purchaseEgg(uint64 userNumber, uint16 quality) external payable whenNotPaused {
316 
317         require(tokensCount >= uniquePetsCount);
318 		
319         // checking egg availablity
320         require(eggAvailable(quality));
321         
322         // checking total count of presale eggs
323         require(tokensCount <= globalPresaleLimit);
324 
325         // calculating price
326         uint256 eggPrice = ( recommendedPrice(quality) * (100 - getCurrentDiscountPercent()) ) / 100;
327 
328         // checking payment amount
329         require(msg.value >= eggPrice);
330         
331         // increment egg counter
332         purchesedEggs[quality]++;
333         
334         // initialize variables for store child genes and quility
335         uint256 childGenes;
336         uint16 childQuality;
337 
338         // get genes and quality of new pet by opening egg through external interface
339         (childGenes, childQuality) = geneScience.openEgg(userNumber, quality);
340          
341         // creating new pet
342         createPet(
343             childGenes,      // genes string
344             childQuality,    // child quality by open egg
345             msg.sender       // owner
346         );
347     }
348     
349     function getCurrentDiscountPercent() constant public returns (uint8 discount) {
350         
351         for(uint8 i = 0; i <= 3; i++)
352         {
353             if(tokensCount < (discountThresholds[i] + uniquePetsCount ))
354                 return discountPercents[i];
355         }
356         
357         return 10;
358     }
359 }
360 
361 // Launch it
362 contract PreSale is EggPurchase {
363     
364     constructor() public {
365         paused = true;
366     }
367         
368     function generateUniquePets(uint8 count) external onlyOwner whenNotPaused {
369         
370         require(marketAddress != address(0));
371         require(address(geneScience) != address(0));
372         
373         uint256 childGenes;
374         uint16 childQuality;
375         uint64 newPetId;
376 
377         for(uint8 i = 0; i< count; i++)
378         {
379             if(tokensCount >= uniquePetsCount)
380                 continue;
381             
382             newPetId = tokensCount+1;
383 
384             (childGenes, childQuality) = geneScience.uniquePet(newPetId);
385             createPet(childGenes, childQuality, marketAddress);
386         }
387     }
388     
389     function getPet(uint256 _id) external view returns (
390         uint64 birthTime,
391         uint256 genes,
392         uint64 breedTimeout,
393         uint16 quality,
394         address owner
395     ) {
396         uint64 _tokenId64bit = uint64(_id);
397         
398         Pet storage pet = pets[_tokenId64bit];
399         
400         birthTime = pet.birthTime;
401         genes = pet.genes;
402         breedTimeout = uint64(breedTimeouts[_tokenId64bit]);
403         quality = pet.quality;
404         owner = petIndexToOwner[_tokenId64bit];
405     }
406     
407     function unpause() public onlyOwner whenPaused {
408         require(address(geneScience) != address(0));
409 
410         super.unpause();
411     }
412     
413     function withdrawBalance(uint256 summ) external onlyCFO {
414         cfoAddress.transfer(summ);
415     }
416 }