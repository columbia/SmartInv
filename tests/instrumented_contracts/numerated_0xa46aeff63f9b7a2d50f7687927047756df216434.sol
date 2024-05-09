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
44     mapping (uint => Sample) sampleTypes;
45     
46     uint public numOfSampleTypes;
47     
48     uint public numOfCommon;
49     uint public numOfRare;
50     uint public numOfLegendary;
51     uint public numOfMythical;
52     
53     function addNewSampleType(string _ipfsHash, uint _rarityType) public onlyOwner {
54         
55         if (_rarityType == 0) {
56             numOfCommon++;
57         } else if (_rarityType == 1) {
58             numOfRare++;
59         } else if(_rarityType == 2) {
60             numOfLegendary++;
61         } else if(_rarityType == 3) {
62             numOfMythical++;
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
73     function getType(uint _randomNum) public view returns (uint) {
74         uint range = 0;
75         
76         if (_randomNum > 0 && _randomNum < 600) {
77             range = 600 / numOfCommon;
78             return _randomNum / range;
79             
80         } else if(_randomNum >= 600 && _randomNum < 900) {
81             range = 300 / numOfRare;
82             return _randomNum / range;
83         } else {
84             range = 100 / numOfLegendary;
85             return _randomNum / range;
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
108     mapping(uint => uint[]) public soundEffects;
109     
110     uint public numOfJingles;
111     
112     address public cryptoJingles;
113     Marketplace public marketplaceContract;
114     
115     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
116     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
117     event EffectAdded(uint indexed jingleId, uint[] effectParams);
118     event Composed(uint indexed jingleId, address indexed owner, 
119                 uint[5] samples, uint[5] jingleTypes, string name, string author);
120     
121     modifier onlyCryptoJingles() {
122         require(msg.sender == cryptoJingles);
123         _;
124     }
125     
126     function Jingle() public {
127     }
128     
129     function transfer(address _to, uint256 _jingleId) public {
130         require(tokensForOwner[_jingleId] != 0x0);
131         require(tokensForOwner[_jingleId] == msg.sender);
132         
133         tokensForApproved[_jingleId] = 0x0;
134         
135         removeJingle(msg.sender, _jingleId);
136         addJingle(_to, _jingleId);
137         
138         Approval(msg.sender, 0, _jingleId);
139         Transfer(msg.sender, _to, _jingleId);
140     }
141     
142     
143     function approve(address _to, uint256 _jingleId) public {
144         require(tokensForOwner[_jingleId] != 0x0);
145         require(ownerOf(_jingleId) == msg.sender);
146         require(_to != msg.sender);
147         
148         if (_getApproved(_jingleId) != 0x0 || _to != 0x0) {
149             tokensForApproved[_jingleId] = _to;
150             Approval(msg.sender, _to, _jingleId);
151         }
152     }
153     
154     function transferFrom(address _from, address _to, uint256 _jingleId) public {
155         require(tokensForOwner[_jingleId] != 0x0);
156         require(_getApproved(_jingleId) == msg.sender);
157         require(ownerOf(_jingleId) == _from);
158         require(_to != 0x0);
159         
160         tokensForApproved[_jingleId] = 0x0;
161         
162         removeJingle(_from, _jingleId);
163         addJingle(_to, _jingleId);
164         
165         Approval(_from, 0, _jingleId);
166         Transfer(_from, _to, _jingleId);
167         
168     }
169     
170     function approveAndSell(uint _jingleId, uint _amount) public {
171         approve(address(marketplaceContract), _jingleId);
172         
173         marketplaceContract.sell(msg.sender, _jingleId, _amount);
174     }
175     
176     function composeJingle(address _owner, uint[5] jingles, 
177             uint[5] jingleTypes, string name, string author) public onlyCryptoJingles {
178         
179         uint _jingleId = numOfJingles;
180         
181         uniqueJingles[keccak256(jingles)] = true;
182         
183         tokensForOwner[_jingleId] = _owner;
184         
185         tokensOwned[_owner].push(_jingleId);
186         
187         samplesInJingle[_jingleId] = jingles;
188         
189         tokenPosInArr[_jingleId] = tokensOwned[_owner].length - 1;
190         
191         if (bytes(author).length == 0) {
192             author = "Soundtoshi Nakajingles";
193         }
194         
195         jinglesInfo[numOfJingles] = MetaInfo({
196             name: name,
197             author: author
198         });
199         
200         Composed(numOfJingles, _owner, jingles, jingleTypes, name, author);
201         
202         numOfJingles++;
203     }
204     
205     function addSoundEffect(uint _jingleId, uint[] _effectParams) external {
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
293     mapping (uint => uint) public tokenType;
294     
295     uint public numOfSamples;
296     
297     address public cryptoJingles;
298 
299     SampleStorage public sampleStorage;
300     
301     event Mint(address indexed _to, uint256 indexed _tokenId);
302     
303     modifier onlyCryptoJingles() {
304         require(msg.sender == cryptoJingles);
305         _;
306     }
307     
308     function Sample(address _sampleStorage) public {
309         sampleStorage = SampleStorage(_sampleStorage);
310     }
311     
312     function mint(address _owner, uint _randomNum) public onlyCryptoJingles {
313         
314         uint sampleType = sampleStorage.getType(_randomNum);
315         
316         addSample(_owner, sampleType, numOfSamples);
317         
318         Mint(_owner, numOfSamples);
319         
320         numOfSamples++;
321     }
322     
323     //TODO: check this again
324     // find who owns that sample and at what position is it in the owners arr 
325     // Swap that token with the last one in arr and delete the end of arr
326     function removeSample(address _owner, uint _sampleId) public onlyCryptoJingles {
327         uint length = tokensOwned[_owner].length;
328         uint index = tokenPosInArr[_sampleId];
329         uint swapToken = tokensOwned[_owner][length - 1];
330 
331         tokensOwned[_owner][index] = swapToken;
332         tokenPosInArr[swapToken] = index;
333 
334         delete tokensOwned[_owner][length - 1];
335         tokensOwned[_owner].length--;
336         
337         tokensForOwner[_sampleId] = 0x0;
338         
339     }
340     
341     function getSamplesForOwner(address _owner) public constant returns (uint[]) {
342         return tokensOwned[_owner];
343     }
344     
345     function getTokenType(uint _sampleId) public constant returns (uint) {
346         return tokenType[_sampleId];
347     }
348     
349     function isTokenOwner(uint _tokenId, address _user) public constant returns(bool) {
350         return tokensForOwner[_tokenId] == _user;
351     }
352     
353     function getAllSamplesForOwner(address _owner) public constant returns(uint[]) {
354         uint[] memory samples = tokensOwned[_owner];
355         
356         uint[] memory usersSamples = new uint[](samples.length * 2);
357         
358         uint j = 0;
359         
360         for(uint i = 0; i < samples.length; ++i) {
361             usersSamples[j] = samples[i];
362             usersSamples[j + 1] = tokenType[samples[i]];
363             j += 2;
364         }
365         
366         return usersSamples;
367     }
368     
369     // Internal functions of the contract
370     
371     function addSample(address _owner, uint _sampleType, uint _sampleId) internal {
372         tokensForOwner[_sampleId] = _owner;
373         
374         tokensOwned[_owner].push(_sampleId);
375         
376         tokenType[_sampleId] = _sampleType;
377         
378         tokenPosInArr[_sampleId] = tokensOwned[_owner].length - 1;
379     }
380     
381      // Owner functions 
382     // Set the crypto jingles contract can 
383     function setCryptoJinglesContract(address _cryptoJingles) public onlyOwner {
384         require(cryptoJingles == 0x0);
385         
386         cryptoJingles = _cryptoJingles;
387     }
388 }
389 
390 contract CryptoJingles is Ownable {
391     
392     struct Purchase {
393         address user;
394         uint blockNumber;
395         bool revealed;
396         uint numSamples;
397         bool exists;
398     }
399     
400     event Purchased(address indexed user, uint blockNumber, uint numJingles, uint numOfPurchases);
401     event JinglesOpened(address byWhom, address jingleOwner, uint currBlockNumber);
402     
403     mapping (uint => bool) public isAlreadyUsed;
404     
405     mapping(address => string) public authors;
406 
407     uint numOfPurchases;
408     
409     uint MAX_SAMPLES_PER_PURCHASE = 15;
410     uint SAMPLE_PRICE = 10 ** 15;
411     uint SAMPLES_PER_JINGLE = 5;
412     uint NUM_SAMPLE_RANGE = 1000;
413     
414     Sample public sampleContract;
415     Jingle public jingleContract;
416     
417     function CryptoJingles(address _sample, address _jingle) public {
418         numOfPurchases = 0;
419         sampleContract = Sample(_sample);
420         jingleContract = Jingle(_jingle);
421     }
422     
423     function buySamples(uint _numSamples, address _to) public payable {
424         require(_numSamples <= MAX_SAMPLES_PER_PURCHASE);
425         require(msg.value >= (SAMPLE_PRICE * _numSamples));
426         
427          for (uint i = 0; i < _numSamples; ++i) {
428             
429             bytes32 blockHash = block.blockhash(block.number - 1);
430             
431             uint randomNum = randomGen(blockHash, i);
432             sampleContract.mint(_to, randomNum);
433         }
434         
435         Purchased(_to, block.number, _numSamples, numOfPurchases);
436         
437         numOfPurchases++;
438     }
439     
440     function composeJingle(string name, uint[5] samples) public {
441         require(jingleContract.uniqueJingles(keccak256(samples)) == false);
442         
443         //check if you own all the 5 samples 
444         for (uint i = 0; i < SAMPLES_PER_JINGLE; ++i) {
445             bool isOwner = sampleContract.isTokenOwner(samples[i], msg.sender);
446             
447             require(isOwner == true && isAlreadyUsed[samples[i]] == false);
448             
449             isAlreadyUsed[samples[i]] = true;
450         }
451         
452         uint[5] memory sampleTypes;
453         
454         // remove all the samples from your Ownership
455         for (uint j = 0; j < SAMPLES_PER_JINGLE; ++j) {
456             sampleTypes[j] = sampleContract.tokenType(samples[j]);
457             sampleContract.removeSample(msg.sender, samples[j]);
458         }
459         
460         //create a new jingle containing those 5 samples
461         jingleContract.composeJingle(msg.sender, samples, sampleTypes, name, authors[msg.sender]);
462     }
463     
464     // Addresses can set their name when composing jingles
465     function setAuthorName(string _name) public {
466         authors[msg.sender] = _name;
467     }
468     
469     function randomGen(bytes32 blockHash, uint seed) constant public returns (uint randomNumber) {
470         return (uint(keccak256(blockHash, block.timestamp, numOfPurchases, seed )) % NUM_SAMPLE_RANGE);
471     }
472     
473     // The only ether kept on this contract are owner money for samples
474     function withdraw(uint _amount) public onlyOwner {
475         require(_amount <= this.balance);
476         
477         msg.sender.transfer(_amount);
478     }
479     
480 }
481 
482 contract Marketplace is Ownable {
483     
484     modifier onlyJingle() {
485         require(msg.sender == address(jingleContract));
486         _;
487     }
488     
489     struct Order {
490         uint price;
491         address seller;
492         uint timestamp;
493         bool exists;
494     }
495     
496     event SellOrder(address owner, uint jingleId, uint price);
497     event Bought(uint jingleId, address buyer, uint price);
498     event Canceled(address owner, uint jingleId);
499     
500     uint public numOrders;
501     uint public ownerBalance;
502     
503     uint OWNERS_CUT = 3; // 3 percent of every sale goes to owner
504     
505     mapping (uint => Order) public sellOrders;
506     mapping(uint => uint) public positionOfJingle;
507     
508     uint[] public jinglesOnSale;
509     
510     Jingle public jingleContract;
511     
512     function Marketplace(address _jingle) public {
513         jingleContract = Jingle(_jingle);
514         ownerBalance = 0;
515     }
516 
517     function sell(address _owner, uint _jingleId, uint _amount) public onlyJingle {
518         require(_amount > 100);
519         require(sellOrders[_jingleId].exists == false);
520         
521         sellOrders[_jingleId] = Order({
522            price: _amount,
523            seller: _owner,
524            timestamp: now,
525            exists: true
526         });
527         
528         numOrders++;
529         
530         // set for iterating
531         jinglesOnSale.push(_jingleId);
532         positionOfJingle[_jingleId] = jinglesOnSale.length - 1;
533         
534         //transfer ownership 
535         jingleContract.transferFrom(_owner, this, _jingleId);
536         
537         //Fire an sell event
538         SellOrder(_owner, _jingleId, _amount);
539     }
540     
541     function buy(uint _jingleId) public payable {
542         require(sellOrders[_jingleId].exists == true);
543         require(msg.value >= sellOrders[_jingleId].price);
544         
545         sellOrders[_jingleId].exists = false;
546         
547         numOrders--;
548         
549         //delete stuff for iterating 
550         removeOrder(_jingleId);
551         
552         //transfer ownership 
553         jingleContract.transfer(msg.sender, _jingleId);
554         
555         // transfer money to seller
556         uint price = sellOrders[_jingleId].price;
557         
558         uint threePercent = (price / 100) * OWNERS_CUT;
559         
560         sellOrders[_jingleId].seller.transfer(price - threePercent);
561         
562         ownerBalance += threePercent;
563         
564         //fire and event
565         Bought(_jingleId, msg.sender, msg.value);
566     }
567     
568     function cancel(uint _jingleId) public {
569         require(sellOrders[_jingleId].exists == true);
570         require(sellOrders[_jingleId].seller == msg.sender);
571         
572         sellOrders[_jingleId].exists = false;
573         
574         numOrders--;
575         
576         //delete stuff for iterating 
577         removeOrder(_jingleId);
578         
579         jingleContract.transfer(msg.sender, _jingleId);
580         
581         //fire and event
582         Canceled(msg.sender, _jingleId);
583     }
584     
585     function removeOrder(uint _jingleId) internal {
586         uint length = jinglesOnSale.length;
587         uint index = positionOfJingle[_jingleId];
588         uint lastOne = jinglesOnSale[length - 1];
589 
590         jinglesOnSale[index] = lastOne;
591         positionOfJingle[lastOne] = index;
592 
593         delete jinglesOnSale[length - 1];
594         jinglesOnSale.length--;
595     }
596     
597     //Owners functions 
598     function withdraw(uint _amount) public onlyOwner {
599         require(_amount <= ownerBalance);
600         
601         msg.sender.transfer(_amount);
602     }
603     
604 }