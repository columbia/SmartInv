1 pragma solidity ^0.4.17;
2 //**
3 //**
4 contract ERC721 {
5    // ERC20 compatible functions
6   string public name = "CryptoElections";
7   string public symbol = "CE";
8    function totalSupply()  public view returns (uint256);
9    function balanceOf(address _owner) public constant returns (uint);
10    // Functions that define ownership
11    function ownerOf(uint256 _tokenId) public constant returns (address owner);
12    function approve(address _to, uint256 _tokenId) public returns (bool success);
13    function takeOwnership(uint256 _tokenId) public;
14    function transfer(address _to, uint256 _tokenId) public returns (bool success);
15   function transferFrom(address _from, address _to, uint _tokenId) public returns (bool success);
16    function tokensOfOwnerByIndex(address _owner, uint256 _index) view public  returns (uint tokenId);
17    // Token metadata
18  // function tokenMetadata(uint256 _tokenId) constant returns (string infoUrl);
19  function implementsERC721() public pure returns (bool);
20 }
21 
22 contract CryptoElections is ERC721 {
23 
24     /* Define variable owner of the type address */
25     address creator;
26 
27     modifier onlyCreator() {
28         require(msg.sender == creator);
29         _;
30     }
31 
32     modifier onlyCountryOwner(uint256 countryId) {
33         require(countries[countryId].president==msg.sender);
34         _;
35     }
36     modifier onlyCityOwner(uint cityId) {
37         require(cities[cityId].mayor==msg.sender);
38         _;
39     }
40 
41     struct Country {
42         address president;
43         string slogan;
44         string flagUrl;
45     }
46     struct City {
47         address mayor;
48         string slogan;
49         string picture;
50         uint purchases;
51         uint startPrice;
52           uint multiplierStep;
53     }
54     
55     
56     
57     bool maintenance=false;
58     bool transferEnabled=false;
59     bool inited=false;
60     event withdrawalEvent(address user,uint value);
61     event pendingWithdrawalEvent(address user,uint value);
62     event assignCountryEvent(address user,uint countryId);
63     event buyCityEvent(address user,uint cityId);
64     
65        // Events
66    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
67    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
68    
69    
70     mapping(uint => Country) public countries ;
71     mapping(uint =>  uint[]) public countriesCities ;
72     mapping(uint =>  uint) public citiesCountries ;
73 
74     mapping(uint =>  uint) public cityPopulation ;
75     mapping(uint => City) public cities;
76     mapping(address => uint[]) public userCities;
77     mapping(address => uint) public userPendingWithdrawals;
78     mapping(address => string) public userNicknames;
79      mapping(bytes32 => bool) public takenNicknames;
80     mapping(address => mapping (address => uint256)) private allowed;
81        
82     uint totalCities=0;
83 
84  function implementsERC721() public pure returns (bool)
85     {
86         return true;
87     }
88 
89 
90 
91     // ------------------------------------------------------------------------
92     // Returns alloed status
93     // ------------------------------------------------------------------------
94     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
95         require(transferEnabled);
96         return allowed[tokenOwner][spender];
97     }
98 
99    function totalSupply()  public  view returns (uint256 ) {
100        
101        return totalCities;
102    }
103     function CryptoElections() public {
104         creator = msg.sender;
105     }
106 
107     function () public payable {
108         revert();
109     }
110    
111     
112       function balanceOf(address _owner) constant public returns (uint balance) {
113           
114           return userCities[_owner].length;
115       }
116       
117         function ownerOf(uint256 _tokenId) constant public  returns (address owner) {
118             
119             return cities[_tokenId].mayor;
120         }
121  
122  
123        function approve(address _to, uint256 _tokenId) public returns (bool success){
124            require(transferEnabled);
125        require(msg.sender == ownerOf(_tokenId));
126        require(msg.sender != _to);
127        allowed[msg.sender][_to] = _tokenId;
128        Approval(msg.sender, _to, _tokenId);
129        return true;
130    }
131    
132      function takeOwnership(uint256 _tokenId) public {
133          require(transferEnabled);
134        require(cityPopulation[_tokenId]!=0);
135        address oldOwner = ownerOf(_tokenId);
136        address newOwner = msg.sender;
137        require(newOwner != oldOwner);
138        // cities can be transfered one-by-one
139        require(allowed[oldOwner][newOwner] == _tokenId);
140        
141        
142        _removeUserCity(oldOwner,_tokenId);
143        cities[_tokenId].mayor=newOwner;
144        _addUserCity(newOwner,_tokenId);
145        
146    
147        Transfer(oldOwner, newOwner, _tokenId);
148    }
149    
150 
151       function transfer(address _to, uint256 _tokenId) public  returns (bool success) {
152        require(transferEnabled);
153        address currentOwner = msg.sender;
154        address newOwner = _to;
155       
156         require(cityPopulation[_tokenId]!=0);
157        require(currentOwner == ownerOf(_tokenId));
158        require(currentOwner != newOwner);
159        require(newOwner != address(0));
160         _removeUserCity(currentOwner,_tokenId);
161        cities[_tokenId].mayor=newOwner;
162    
163         _addUserCity(newOwner,_tokenId);
164        Transfer(currentOwner, newOwner, _tokenId);
165        return true;
166    }
167    
168      function transferFrom(address from, address to, uint _tokenId) public returns (bool success) {
169          
170            require(transferEnabled);
171        address currentOwner = from;
172        address newOwner = to;
173       
174         require(cityPopulation[_tokenId]!=0);
175        require(currentOwner == ownerOf(_tokenId));
176        require(currentOwner != newOwner);
177        require(newOwner != address(0));
178          // cities can be transfered one-by-one
179        require(allowed[currentOwner][msg.sender] == _tokenId);
180        
181         _removeUserCity(currentOwner,_tokenId);
182        cities[_tokenId].mayor=newOwner;
183    
184         _addUserCity(newOwner,_tokenId);
185        Transfer(currentOwner, newOwner, _tokenId);
186        
187          return true;
188          
189      }
190    
191    
192     function tokensOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint tokenId) {
193        
194         return userCities[_owner][_index];
195     }
196    // Token metadata
197 
198 
199   
200     function markContractAsInited() public
201     onlyCreator() 
202     {
203      inited=true;   
204     }
205     
206     
207  /*
208     Functions to migrate from previous contract. After migration is complete this functions will be blocked
209     */
210     function addOldMayors(uint[] citiesIds,uint[] purchases,address[] mayors) public 
211     onlyCreator()
212     {
213         require(!inited);
214         for (uint i = 0;i<citiesIds.length;i++) {
215             cities[citiesIds[i]].mayor = mayors[i];
216             cities[citiesIds[i]].purchases = purchases[i];
217         }
218     }
219     
220     function addOldNickname(address user,string nickname) public
221     onlyCreator()
222     {
223         require(!inited);
224            takenNicknames[keccak256(nickname)]=true;
225          userNicknames[user] = nickname;
226     }
227     function addOldPresidents(uint[] countriesIds,address[] presidents) public
228     onlyCreator()
229     {
230         require(!inited);
231         for (uint i = 0;i<countriesIds.length;i++) {
232             countries[countriesIds[i]].president = presidents[i];
233         }
234     }
235     
236       function addOldWithdrawals(address[] userIds,uint[] withdrawals) public
237     onlyCreator()
238     {
239         require(!inited);
240         for (uint i = 0;i<userIds.length;i++) {
241             userPendingWithdrawals[userIds[i]] = withdrawals[i];
242         }
243     }
244     
245     /* This function is executed at initialization and sets the owner of the contract */
246     /* Function to recover the funds on the contract */
247     function kill() public
248     onlyCreator()
249     {
250         selfdestruct(creator);
251     }
252 
253     function transferContract(address newCreator) public
254     onlyCreator()
255     {
256         creator=newCreator;
257     }
258 
259 
260 
261     // Contract initialisation
262     function addCountryCities(uint countryId,uint[] _cities,uint multiplierStep,uint startPrice)  public
263     onlyCreator()
264     {
265         countriesCities[countryId] = _cities;
266         for (uint i = 0;i<_cities.length;i++) {
267             Transfer(0x0,address(this),_cities[i]);
268             cities[_cities[i]].multiplierStep=multiplierStep;
269               cities[_cities[i]].startPrice=startPrice;
270             citiesCountries[_cities[i]] = countryId;
271         }
272         //skipping uniquality check
273         totalCities+=_cities.length;
274     }
275     function setMaintenanceMode(bool _maintenance) public
276     onlyCreator()
277     {
278         maintenance=_maintenance;
279     }
280 
281    function setTransferMode(bool _status) public
282     onlyCreator()
283     {
284         transferEnabled=_status;
285     }
286     // Contract initialisation
287     function addCitiesPopulation(uint[] _cities,uint[]_populations)  public
288     onlyCreator()
289     {
290 
291         for (uint i = 0;i<_cities.length;i++) {
292 
293             cityPopulation[_cities[i]] = _populations[i];
294         }
295         
296     }
297 
298     function setCountrySlogan(uint countryId,string slogan) public
299     onlyCountryOwner(countryId)
300     {
301         countries[countryId].slogan = slogan;
302     }
303 
304     function setCountryPicture(uint countryId,string _flagUrl) public
305     onlyCountryOwner(countryId)
306     {
307         countries[countryId].flagUrl = _flagUrl;
308     }
309 
310     function setCitySlogan(uint256 cityId,string _slogan) public
311     onlyCityOwner(cityId)
312     {
313         cities[cityId].slogan = _slogan;
314     }
315 
316     function setCityPicture(uint256 cityId,string _picture) public
317     onlyCityOwner(cityId)
318     {
319         cities[cityId].picture = _picture;
320     }
321 
322 function stringToBytes32(string memory source) private pure returns (bytes32 result) {
323     bytes memory tempEmptyStringTest = bytes(source);
324     if (tempEmptyStringTest.length == 0) {
325         return 0x0;
326     }
327 
328     assembly {
329         result := mload(add(source, 32))
330     }
331 }
332     // returns address mayor;
333         
334       function getCities(uint[] citiesIds)  public view returns (City[]) {
335      
336         City[] memory cityArray= new City[](citiesIds.length);
337      
338         for (uint i=0;i<citiesIds.length;i++) {
339           
340             cityArray[i]=cities[citiesIds[i]];
341           
342             
343         }
344         return cityArray;
345         
346     }
347     
348               function getCitiesStrings(uint[] citiesIds)  public view returns (  bytes32[],bytes32[]) {
349      
350         bytes32 [] memory slogans=new bytes32[](citiesIds.length);
351          bytes32 [] memory pictures=new bytes32[](citiesIds.length);
352    
353      
354         for (uint i=0;i<citiesIds.length;i++) {
355           
356             slogans[i]=stringToBytes32(cities[citiesIds[i]].slogan);
357             pictures[i]=stringToBytes32(cities[citiesIds[i]].picture);
358        
359             
360         }
361         return (slogans,pictures);
362         
363     }
364     
365    
366     function getCitiesData(uint[] citiesIds)  public view returns (  address [],uint[],uint[],uint[]) {
367    
368          address [] memory mayors=new address[](citiesIds.length);
369    
370         uint [] memory purchases=new uint[](citiesIds.length);
371         uint [] memory startPrices=new uint[](citiesIds.length);
372         uint [] memory multiplierSteps=new uint[](citiesIds.length);
373                                     
374         for (uint i=0;i<citiesIds.length;i++) {
375             mayors[i]=(cities[citiesIds[i]].mayor);
376       
377             purchases[i]=(cities[citiesIds[i]].purchases);
378             startPrices[i]=(cities[citiesIds[i]].startPrice);
379             multiplierSteps[i]=(cities[citiesIds[i]].multiplierStep);
380             
381         }
382         return (mayors,purchases,startPrices,multiplierSteps);
383         
384     }
385     
386     function getCountriesData(uint[] countriesIds)  public view returns (    address [],bytes32[],bytes32[]) {
387           address [] memory presidents=new address[](countriesIds.length);
388         bytes32 [] memory slogans=new bytes32[](countriesIds.length);
389          bytes32 [] memory flagUrls=new bytes32[](countriesIds.length);
390    
391         for (uint i=0;i<countriesIds.length;i++) {
392             presidents[i]=(countries[countriesIds[i]].president);
393             slogans[i]=stringToBytes32(countries[countriesIds[i]].slogan);
394             flagUrls[i]=stringToBytes32(countries[countriesIds[i]].flagUrl);
395             
396         }
397         return (presidents,slogans,flagUrls);
398         
399     }
400 
401     function withdraw() public {
402         if (maintenance) revert();
403         uint amount = userPendingWithdrawals[msg.sender];
404         // Remember to zero the pending refund before
405         // sending to prevent re-entrancy attacks
406 
407         userPendingWithdrawals[msg.sender] = 0;
408         withdrawalEvent(msg.sender,amount);
409         msg.sender.transfer(amount);
410     }
411   
412   function getPrices2(uint purchases,uint startPrice,uint multiplierStep) public pure returns (uint[4]) {
413       
414         uint price=startPrice;
415         uint pricePrev = price;
416         uint systemCommission = startPrice;
417         uint presidentCommission = 0;
418         uint ownerCommission;
419 
420         for (uint i = 1;i<=purchases;i++) {
421             if (i<=multiplierStep)
422                 price = price*2;
423             else
424                 price = (price*12)/10;
425 
426             presidentCommission = price/100;
427             systemCommission = (price-pricePrev)*2/10;
428             ownerCommission = price-presidentCommission-systemCommission;
429 
430             pricePrev = price;
431         }
432         return [price,systemCommission,presidentCommission,ownerCommission];
433     }
434 
435 
436     function setNickname(string nickname) public returns(bool) {
437         if (maintenance) revert();
438         if (takenNicknames[keccak256(nickname)]==true) {
439                      return false;
440         }
441         userNicknames[msg.sender] = nickname;
442         takenNicknames[keccak256(nickname)]=true;
443         return true;
444     }
445 
446     function _assignCountry(uint countryId)    private returns (bool) {
447         uint  totalPopulation;
448         uint  controlledPopulation;
449 
450         uint  population;
451         for (uint i = 0;i<countriesCities[countryId].length;i++) {
452             population = cityPopulation[countriesCities[countryId][i]];
453             if (cities[countriesCities[countryId][i]].mayor==msg.sender) {
454                 controlledPopulation += population;
455             }
456             totalPopulation += population;
457         }
458         if (controlledPopulation*2>(totalPopulation)) {
459             countries[countryId].president = msg.sender;
460             assignCountryEvent(msg.sender,countryId);
461             return true;
462         } else {
463             return false;
464         }
465     }
466     
467 
468     function buyCity(uint cityId) payable  public  {
469         if (maintenance) revert();
470         uint[4] memory prices = getPrices2(cities[cityId].purchases,cities[cityId].startPrice,cities[cityId].multiplierStep);
471 
472         if (cities[cityId].mayor==msg.sender) {
473             revert();
474         }
475         if (cityPopulation[cityId]==0) {
476             revert();
477         }
478 
479         if ( msg.value+userPendingWithdrawals[msg.sender]>=prices[0]) {
480             // use user limit
481             userPendingWithdrawals[msg.sender] = userPendingWithdrawals[msg.sender]+msg.value-prices[0];
482             pendingWithdrawalEvent(msg.sender,userPendingWithdrawals[msg.sender]+msg.value-prices[0]);
483 
484             cities[cityId].purchases = cities[cityId].purchases+1;
485 
486             userPendingWithdrawals[cities[cityId].mayor] += prices[3];
487             pendingWithdrawalEvent(cities[cityId].mayor,prices[3]);
488 
489             if (countries[citiesCountries[cityId]].president==0) {
490                 userPendingWithdrawals[creator] += prices[2];
491                 pendingWithdrawalEvent(creator,prices[2]);
492 
493             } else {
494                 userPendingWithdrawals[countries[citiesCountries[cityId]].president] += prices[2];
495                 pendingWithdrawalEvent(countries[citiesCountries[cityId]].president,prices[2]);
496             }
497             // change mayor
498             address oldMayor;
499             oldMayor=cities[cityId].mayor;
500             if (cities[cityId].mayor>0) {
501                 _removeUserCity(cities[cityId].mayor,cityId);
502             }
503 
504 
505 
506             cities[cityId].mayor = msg.sender;
507             _addUserCity(msg.sender,cityId);
508 
509             _assignCountry(citiesCountries[cityId]);
510 
511             //send money to creator
512             creator.transfer(prices[1]);
513            // buyCityEvent(msg.sender,cityId);
514              Transfer(0x0,msg.sender,cityId);
515 
516         } else {
517             revert();
518         }
519     }
520     function getUserCities(address user) public view returns (uint[]) {
521         return userCities[user];
522     }
523 
524     function _addUserCity(address user,uint cityId) private {
525         bool added = false;
526         for (uint i = 0; i<userCities[user].length; i++) {
527             if (userCities[user][i]==0) {
528                 userCities[user][i] = cityId;
529                 added = true;
530                 break;
531             }
532         }
533         if (!added)
534             userCities[user].push(cityId);
535     }
536 
537     function _removeUserCity(address user,uint cityId) private {
538         for (uint i = 0; i<userCities[user].length; i++) {
539             if (userCities[user][i]==cityId) {
540                 delete userCities[user][i];
541             }
542         }
543     }
544 
545 }