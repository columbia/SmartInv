1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 
23 }
24 
25 contract ERC721 {
26     function implementsERC721() public pure returns (bool);
27     function totalSupply() public view returns (uint256 total);
28     function balanceOf(address _owner) public view returns (uint256 balance);
29     function ownerOf(uint256 _tokenId) public view returns (address owner);
30     function approve(address _to, uint256 _tokenId) public;
31     function transferFrom(address _from, address _to, uint256 _tokenId) public;
32     function transfer(address _to, uint256 _tokenId) public;
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
35 }
36 
37 contract SampleStorage is Ownable {
38     
39     struct Sample {
40         string ipfsHash;
41         uint rarity;
42     }
43     
44     mapping (uint32 => Sample) public sampleTypes;
45     
46     uint32 public numOfSampleTypes;
47     
48     uint32 public numOfCommon;
49     uint32 public numOfRare;
50     uint32 public numOfLegendary;
51 
52     // The mythical sample is a type common that appears only once in a 1000
53     function addNewSampleType(string _ipfsHash, uint _rarityType) public onlyOwner {
54         
55         if (_rarityType == 0) {
56             numOfCommon++;
57         } else if (_rarityType == 1) {
58             numOfRare++;
59         } else if(_rarityType == 2) {
60             numOfLegendary++;
61         } else if(_rarityType == 3) {
62             numOfCommon++;
63         }
64         
65         sampleTypes[numOfSampleTypes] = Sample({
66            ipfsHash: _ipfsHash,
67            rarity: _rarityType
68         });
69         
70         numOfSampleTypes++;
71     }
72     
73     function getType(uint _randomNum) public view returns (uint32) {
74         uint32 range = 0;
75         
76         if (_randomNum > 0 && _randomNum < 600) {
77             range = 600 / numOfCommon;
78             return uint32(_randomNum) / range;
79             
80         } else if(_randomNum >= 600 && _randomNum < 900) {
81             range = 300 / numOfRare;
82             return uint32(_randomNum) / range;
83         } else {
84             range = 100 / numOfLegendary;
85             return uint32(_randomNum) / range;
86         }
87     }
88     
89 }
90 
91 contract Jingle is Ownable, ERC721 {
92     
93     struct MetaInfo {
94         string name;
95         string author;
96     }
97     
98     mapping (uint => address) internal tokensForOwner;
99     mapping (uint => address) internal tokensForApproved;
100     mapping (address => uint[]) internal tokensOwned;
101     mapping (uint => uint) internal tokenPosInArr;
102     
103     mapping(uint => uint[]) internal samplesInJingle;
104     mapping(uint => MetaInfo) public jinglesInfo;
105     
106     mapping(bytes32 => bool) public uniqueJingles;
107     
108     mapping(uint => uint8[]) public soundEffects;
109     mapping(uint => uint8[20]) public settings;
110     
111     uint public numOfJingles;
112     
113     address public cryptoJingles;
114     Marketplace public marketplaceContract;
115     
116     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
117     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
118     event EffectAdded(uint indexed jingleId, uint8[] effectParams);
119     event Composed(uint indexed jingleId, address indexed owner, uint32[5] samples, uint32[5] jingleTypes,
120             string name, string author, uint8[20] settings);
121     
122     modifier onlyCryptoJingles() {
123         require(msg.sender == cryptoJingles);
124         _;
125     }
126     
127     function transfer(address _to, uint256 _jingleId) public {
128         require(tokensForOwner[_jingleId] != 0x0);
129         require(tokensForOwner[_jingleId] == msg.sender);
130         
131         tokensForApproved[_jingleId] = 0x0;
132         
133         removeJingle(msg.sender, _jingleId);
134         addJingle(_to, _jingleId);
135         
136         Approval(msg.sender, 0, _jingleId);
137         Transfer(msg.sender, _to, _jingleId);
138     }
139     
140     
141     function approve(address _to, uint256 _jingleId) public {
142         require(tokensForOwner[_jingleId] != 0x0);
143         require(ownerOf(_jingleId) == msg.sender);
144         require(_to != msg.sender);
145         
146         if (_getApproved(_jingleId) != 0x0 || _to != 0x0) {
147             tokensForApproved[_jingleId] = _to;
148             Approval(msg.sender, _to, _jingleId);
149         }
150     }
151     
152     function transferFrom(address _from, address _to, uint256 _jingleId) public {
153         require(tokensForOwner[_jingleId] != 0x0);
154         require(_getApproved(_jingleId) == msg.sender);
155         require(ownerOf(_jingleId) == _from);
156         require(_to != 0x0);
157         
158         tokensForApproved[_jingleId] = 0x0;
159         
160         removeJingle(_from, _jingleId);
161         addJingle(_to, _jingleId);
162         
163         Approval(_from, 0, _jingleId);
164         Transfer(_from, _to, _jingleId);
165         
166     }
167     
168     function approveAndSell(uint _jingleId, uint _amount) public {
169         approve(address(marketplaceContract), _jingleId);
170         
171         marketplaceContract.sell(msg.sender, _jingleId, _amount);
172     }
173     
174     function composeJingle(address _owner, uint32[5] jingles, 
175     uint32[5] jingleTypes, string name, string author, uint8[20] _settings) public onlyCryptoJingles {
176         
177         uint _jingleId = numOfJingles;
178         
179         uniqueJingles[keccak256(jingles)] = true;
180         
181         tokensForOwner[_jingleId] = _owner;
182         
183         tokensOwned[_owner].push(_jingleId);
184         
185         samplesInJingle[_jingleId] = jingles;
186         settings[_jingleId] = _settings;
187         
188         tokenPosInArr[_jingleId] = tokensOwned[_owner].length - 1;
189         
190         if (bytes(author).length == 0) {
191             author = "Soundtoshi Nakajingles";
192         }
193         
194         jinglesInfo[numOfJingles] = MetaInfo({
195             name: name,
196             author: author
197         });
198         
199         Composed(numOfJingles, _owner, jingles, jingleTypes, 
200         name, author, _settings);
201         
202         numOfJingles++;
203     }
204     
205     function addSoundEffect(uint _jingleId, uint8[] _effectParams) external {
206         require(msg.sender == ownerOf(_jingleId));
207         
208         soundEffects[_jingleId] = _effectParams;
209         
210         EffectAdded(_jingleId, _effectParams);
211     }
212     
213     function implementsERC721() public pure returns (bool) {
214         return true;
215     }
216     
217     function totalSupply() public view returns (uint256) {
218         return numOfJingles;
219     }
220     
221     function balanceOf(address _owner) public view returns (uint256 balance) {
222         return tokensOwned[_owner].length;
223     }
224     
225     function ownerOf(uint256 _jingleId) public view returns (address) {
226         return tokensForOwner[_jingleId];
227     }
228     
229     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
230         return tokensOwned[_owner][_index];
231     }
232     
233     function getSamplesForJingle(uint _jingleId) external view returns(uint[]) {
234         return samplesInJingle[_jingleId];
235     }
236     
237     function getAllJingles(address _owner) external view returns(uint[]) {
238         return tokensOwned[_owner];
239     }
240     
241     function getMetaInfo(uint _jingleId) external view returns(string, string) {
242         return (jinglesInfo[_jingleId].name, jinglesInfo[_jingleId].author);
243     }
244     
245     function _getApproved(uint _jingleId) internal view returns (address) {
246         return tokensForApproved[_jingleId];
247     }
248     
249      // Internal functions of the contract
250     
251     function addJingle(address _owner, uint _jingleId) internal {
252         tokensForOwner[_jingleId] = _owner;
253         
254         tokensOwned[_owner].push(_jingleId);
255         
256         tokenPosInArr[_jingleId] = tokensOwned[_owner].length - 1;
257     }
258     
259     // find who owns that jingle and at what position is it in the owners arr 
260     // Swap that token with the last one in arr and delete the end of arr
261     function removeJingle(address _owner, uint _jingleId) internal {
262         uint length = tokensOwned[_owner].length;
263         uint index = tokenPosInArr[_jingleId];
264         uint swapToken = tokensOwned[_owner][length - 1];
265 
266         tokensOwned[_owner][index] = swapToken;
267         tokenPosInArr[swapToken] = index;
268 
269         delete tokensOwned[_owner][length - 1];
270         tokensOwned[_owner].length--;
271     }
272     
273     // Owner functions 
274     function setCryptoJinglesContract(address _cryptoJingles) public onlyOwner {
275         require(cryptoJingles == 0x0);
276         
277         cryptoJingles = _cryptoJingles;
278     }
279     
280     function setMarketplaceContract(address _marketplace) public onlyOwner {
281         require(address(marketplaceContract) == 0x0);
282         
283         marketplaceContract = Marketplace(_marketplace);
284     }
285 }
286 
287 contract Sample is Ownable {
288     
289     mapping (uint => address) internal tokensForOwner;
290     mapping (address => uint[]) internal tokensOwned;
291     mapping (uint => uint) internal tokenPosInArr;
292     
293     mapping (uint => uint32) public tokenType;
294     
295     uint public numOfSamples;
296     
297     address public cryptoJingles;
298     address public sampleRegistry;
299 
300 
301     SampleStorage public sampleStorage;
302     
303     event Mint(address indexed _to, uint256 indexed _tokenId);
304     
305     modifier onlyCryptoJingles() {
306         require(msg.sender == cryptoJingles);
307         _;
308     }
309     
310     function Sample(address _sampleStorage) public {
311         sampleStorage = SampleStorage(_sampleStorage);
312     }
313     
314     function mint(address _owner, uint _randomNum) public onlyCryptoJingles {
315         
316         uint32 sampleType = sampleStorage.getType(_randomNum);
317         
318         addSample(_owner, sampleType, numOfSamples);
319         
320         Mint(_owner, numOfSamples);
321         
322         numOfSamples++;
323     }
324     
325     function mintForSampleRegitry(address _owner, uint32 _type) public {
326         require(msg.sender == sampleRegistry);
327         
328         addSample(_owner, _type, numOfSamples);
329         
330         Mint(_owner, numOfSamples);
331         
332         numOfSamples++;
333     }
334     
335     function removeSample(address _owner, uint _sampleId) public onlyCryptoJingles {
336         uint length = tokensOwned[_owner].length;
337         uint index = tokenPosInArr[_sampleId];
338         uint swapToken = tokensOwned[_owner][length - 1];
339 
340         tokensOwned[_owner][index] = swapToken;
341         tokenPosInArr[swapToken] = index;
342 
343         delete tokensOwned[_owner][length - 1];
344         tokensOwned[_owner].length--;
345         
346         tokensForOwner[_sampleId] = 0x0;
347         
348     }
349     
350     function getSamplesForOwner(address _owner) public constant returns (uint[]) {
351         return tokensOwned[_owner];
352     }
353     
354     function getTokenType(uint _sampleId) public constant returns (uint) {
355         return tokenType[_sampleId];
356     }
357     
358     function isTokenOwner(uint _tokenId, address _user) public constant returns(bool) {
359         return tokensForOwner[_tokenId] == _user;
360     }
361     
362     function getAllSamplesForOwner(address _owner) public constant returns(uint[]) {
363         uint[] memory samples = tokensOwned[_owner];
364         
365         uint[] memory usersSamples = new uint[](samples.length * 2);
366         
367         uint j = 0;
368         
369         for(uint i = 0; i < samples.length; ++i) {
370             usersSamples[j] = samples[i];
371             usersSamples[j + 1] = tokenType[samples[i]];
372             j += 2;
373         }
374         
375         return usersSamples;
376     }
377     
378     // Internal functions of the contract
379     
380     function addSample(address _owner, uint32 _sampleType, uint _sampleId) internal {
381         tokensForOwner[_sampleId] = _owner;
382         
383         tokensOwned[_owner].push(_sampleId);
384         
385         tokenType[_sampleId] = _sampleType;
386         
387         tokenPosInArr[_sampleId] = tokensOwned[_owner].length - 1;
388     }
389     
390      // Owner functions 
391     // Set the crypto jingles contract can 
392     function setCryptoJinglesContract(address _cryptoJingles) public onlyOwner {
393         require(cryptoJingles == 0x0);
394         
395         cryptoJingles = _cryptoJingles;
396     }
397     
398     function setSampleRegistry(address _sampleRegistry) public onlyOwner {
399         sampleRegistry = _sampleRegistry;
400     }
401 }
402 
403 contract CryptoJingles is Ownable {
404     
405     struct Purchase {
406         address user;
407         uint blockNumber;
408         bool revealed;
409         uint numSamples;
410         bool exists;
411     }
412     
413     event Purchased(address indexed user, uint blockNumber, uint numJingles, uint numOfPurchases);
414     event JinglesOpened(address byWhom, address jingleOwner, uint currBlockNumber);
415     
416     mapping (uint => bool) public isAlreadyUsed;
417     
418     mapping(address => string) public authors;
419 
420     uint numOfPurchases;
421     
422     uint MAX_SAMPLES_PER_PURCHASE = 15;
423     uint SAMPLE_PRICE = 10 ** 15;
424     uint SAMPLES_PER_JINGLE = 5;
425     uint NUM_SAMPLE_RANGE = 1000;
426     
427     Sample public sampleContract;
428     Jingle public jingleContract;
429     
430     function CryptoJingles(address _sample, address _jingle) public {
431         numOfPurchases = 0;
432         sampleContract = Sample(_sample);
433         jingleContract = Jingle(_jingle);
434     }
435     
436     function buySamples(uint _numSamples, address _to) public payable {
437         require(_numSamples <= MAX_SAMPLES_PER_PURCHASE);
438         require(msg.value >= (SAMPLE_PRICE * _numSamples));
439         require(_to != 0x0);
440         
441          for (uint i = 0; i < _numSamples; ++i) {
442             
443             bytes32 blockHash = block.blockhash(block.number - 1);
444             
445             uint randomNum = randomGen(blockHash, i);
446             sampleContract.mint(_to, randomNum);
447         }
448         
449         Purchased(_to, block.number, _numSamples, numOfPurchases);
450         
451         numOfPurchases++;
452     }
453     
454     function composeJingle(string name, uint32[5] samples, uint8[20] settings) public {
455         require(jingleContract.uniqueJingles(keccak256(samples)) == false);
456         
457         uint32[5] memory sampleTypes;
458         
459         //check if you own all the 5 samples 
460         for (uint i = 0; i < SAMPLES_PER_JINGLE; ++i) {
461             bool isOwner = sampleContract.isTokenOwner(samples[i], msg.sender);
462             
463             require(isOwner == true && isAlreadyUsed[samples[i]] == false);
464             
465             isAlreadyUsed[samples[i]] = true;
466             
467             sampleTypes[i] = sampleContract.tokenType(samples[i]);
468             sampleContract.removeSample(msg.sender, samples[i]);
469         }
470         
471         //create a new jingle containing those 5 samples
472         jingleContract.composeJingle(msg.sender, samples, sampleTypes, name,
473                             authors[msg.sender], settings);
474     }
475     
476     // Addresses can set their name when composing jingles
477     function setAuthorName(string _name) public {
478         authors[msg.sender] = _name;
479     }
480     
481     function randomGen(bytes32 blockHash, uint seed) constant public returns (uint randomNumber) {
482         return (uint(keccak256(blockHash, block.timestamp, numOfPurchases, seed )) % NUM_SAMPLE_RANGE);
483     }
484     
485     // The only ether kept on this contract are owner money for samples
486     function withdraw(uint _amount) public onlyOwner {
487         require(_amount <= this.balance);
488         
489         msg.sender.transfer(_amount);
490     }
491     
492 }
493 
494 contract Marketplace is Ownable {
495     
496     modifier onlyJingle() {
497         require(msg.sender == address(jingleContract));
498         _;
499     }
500     
501     struct Order {
502         uint price;
503         address seller;
504         uint timestamp;
505         bool exists;
506     }
507     
508     event SellOrder(address owner, uint jingleId, uint price);
509     event Bought(uint jingleId, address buyer, uint price);
510     event Canceled(address owner, uint jingleId);
511     
512     uint public numOrders;
513     uint public ownerBalance;
514     
515     uint OWNERS_CUT = 3; // 3 percent of every sale goes to owner
516     
517     mapping (uint => Order) public sellOrders;
518     mapping(uint => uint) public positionOfJingle;
519     
520     uint[] public jinglesOnSale;
521     
522     Jingle public jingleContract;
523     
524     function Marketplace(address _jingle) public {
525         jingleContract = Jingle(_jingle);
526         ownerBalance = 0;
527     }
528 
529     function sell(address _owner, uint _jingleId, uint _amount) public onlyJingle {
530         require(_amount > 100);
531         require(sellOrders[_jingleId].exists == false);
532         
533         sellOrders[_jingleId] = Order({
534            price: _amount,
535            seller: _owner,
536            timestamp: now,
537            exists: true
538         });
539         
540         numOrders++;
541         
542         // set for iterating
543         jinglesOnSale.push(_jingleId);
544         positionOfJingle[_jingleId] = jinglesOnSale.length - 1;
545         
546         //transfer ownership 
547         jingleContract.transferFrom(_owner, this, _jingleId);
548         
549         //Fire an sell event
550         SellOrder(_owner, _jingleId, _amount);
551     }
552     
553     function buy(uint _jingleId) public payable {
554         require(sellOrders[_jingleId].exists == true);
555         require(msg.value >= sellOrders[_jingleId].price);
556         
557         sellOrders[_jingleId].exists = false;
558         
559         numOrders--;
560         
561         //delete stuff for iterating 
562         removeOrder(_jingleId);
563         
564         //transfer ownership 
565         jingleContract.transfer(msg.sender, _jingleId);
566         
567         // transfer money to seller
568         uint price = sellOrders[_jingleId].price;
569         
570         uint threePercent = (price / 100) * OWNERS_CUT;
571         
572         sellOrders[_jingleId].seller.transfer(price - threePercent);
573         
574         ownerBalance += threePercent;
575         
576         //fire and event
577         Bought(_jingleId, msg.sender, msg.value);
578     }
579     
580     function cancel(uint _jingleId) public {
581         require(sellOrders[_jingleId].exists == true);
582         require(sellOrders[_jingleId].seller == msg.sender);
583         
584         sellOrders[_jingleId].exists = false;
585         
586         numOrders--;
587         
588         //delete stuff for iterating 
589         removeOrder(_jingleId);
590         
591         jingleContract.transfer(msg.sender, _jingleId);
592         
593         //fire and event
594         Canceled(msg.sender, _jingleId);
595     }
596     
597     function removeOrder(uint _jingleId) internal {
598         uint length = jinglesOnSale.length;
599         uint index = positionOfJingle[_jingleId];
600         uint lastOne = jinglesOnSale[length - 1];
601 
602         jinglesOnSale[index] = lastOne;
603         positionOfJingle[lastOne] = index;
604 
605         delete jinglesOnSale[length - 1];
606         jinglesOnSale.length--;
607     }
608     
609     function getAllJinglesOnSale() public view returns(uint[]) {
610         return jinglesOnSale;
611     }
612     
613     //Owners functions 
614     function withdraw(uint _amount) public onlyOwner {
615         require(_amount <= ownerBalance);
616         
617         msg.sender.transfer(_amount);
618     }
619     
620 }