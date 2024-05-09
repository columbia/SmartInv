1 pragma solidity ^0.4.24;
2 /***
3  * https://templeofeth.io
4  *
5  * Tiki Madness.
6  *
7  * 6 Tiki Masks are flipping
8  * Price increases by 32% every flip.
9  *
10  * 10% of rise buyer gets TMPL tokens in the TempleOfETH.
11  * 5% of rise goes to tiki holder fund.
12  * 5% of rise goes to temple management.
13  * 2% of rise goes to the God Tiki owner (The Tiki with the lowest value.)
14  * The rest (110%) goes to previous owner.
15  * Over 1 hour price will fall to 12.5% of the Tiki Holder fund..
16  * Holders after 1 hours with no flip can collect the holder fund.
17  *
18  * Temple Warning: Do not play with more than you can afford to lose.
19  */
20 
21 contract TempleInterface {
22   function purchaseFor(address _referredBy, address _customerAddress) public payable returns (uint256);
23 }
24 
25 contract TikiMadness {
26 
27   /*=================================
28   =            MODIFIERS            =
29   =================================*/
30 
31   /// @dev Access modifier for owner functions
32   modifier onlyOwner() {
33     require(msg.sender == contractOwner);
34     _;
35   }
36 
37   /// @dev Prevent contract calls.
38   modifier notContract() {
39     require(tx.origin == msg.sender);
40     _;
41   }
42 
43   /// @dev notPaused
44   modifier notPaused() {
45     require(now > startTime);
46     _;
47   }
48 
49   /// @dev easyOnGas
50   modifier easyOnGas() {
51     require(tx.gasprice < 99999999999);
52     _;
53   }
54 
55   /*==============================
56   =            EVENTS            =
57   ==============================*/
58 
59   event onTokenSold(
60        uint256 indexed tokenId,
61        uint256 price,
62        address prevOwner,
63        address newOwner,
64        string name
65     );
66 
67 
68   /*==============================
69   =            CONSTANTS         =
70   ==============================*/
71 
72   uint256 private increaseRatePercent =  132;
73   uint256 private godTikiPercent =  2; // 2% of all sales
74   uint256 private devFeePercent =  5;
75   uint256 private bagHolderFundPercent =  5;
76   uint256 private exchangeTokenPercent =  10;
77   uint256 private previousOwnerPercent =  110;
78   uint256 private priceFallDuration =  1 hours;
79 
80   /*==============================
81   =            STORAGE           =
82   ==============================*/
83 
84   /// @dev A mapping from tiki IDs to the address that owns them.
85   mapping (uint256 => address) public tikiIndexToOwner;
86 
87   // @dev A mapping from owner address to count of tokens that address owns.
88   mapping (address => uint256) private ownershipTokenCount;
89 
90   // @dev The address of the owner
91   address public contractOwner;
92   
93   /// @dev Start Time
94   uint256 public startTime = 1543692600; // GMT: Saturday, December 1, 2018 19:30:00 PM
95 
96   // @dev Current dev fee
97   uint256 public currentDevFee = 0;
98 
99   // @dev The address of the temple contract
100   address public templeOfEthaddress = 0x0e21902d93573c18fd0acbadac4a5464e9732f54; // MAINNET
101 
102   /// @dev Interface to temple
103   TempleInterface public templeContract;
104 
105   /*==============================
106   =            DATATYPES         =
107   ==============================*/
108 
109   struct TikiMask {
110     string name;
111     uint256 basePrice; // current base price = 12.5% of holder fund.
112     uint256 highPrice;
113     uint256 fallDuration;
114     uint256 saleTime; // when was sold last
115     uint256 bagHolderFund;
116   }
117 
118   TikiMask [6] public tikiMasks;
119 
120   constructor () public {
121 
122     contractOwner = msg.sender;
123     templeContract = TempleInterface(templeOfEthaddress);
124 
125     TikiMask memory _Huracan = TikiMask({
126             name: "Huracan",
127             basePrice: 0.015 ether,
128             highPrice: 0.015 ether,
129             fallDuration: priceFallDuration,
130             saleTime: now,
131             bagHolderFund: 0
132             });
133 
134     tikiMasks[0] =  _Huracan;
135 
136     TikiMask memory _Itzamna = TikiMask({
137             name: "Itzamna",
138             basePrice: 0.018 ether,
139             highPrice: 0.018 ether,
140             fallDuration: priceFallDuration,
141             saleTime: now,
142             bagHolderFund: 0
143             });
144 
145     tikiMasks[1] =  _Itzamna;
146 
147     TikiMask memory _Mitnal = TikiMask({
148             name: "Mitnal",
149             basePrice: 0.020 ether,
150             highPrice: 0.020 ether,
151             fallDuration: priceFallDuration,
152             saleTime: now,
153             bagHolderFund: 0
154             });
155 
156     tikiMasks[2] =  _Mitnal;
157 
158     TikiMask memory _Tepeu = TikiMask({
159             name: "Tepeu",
160             basePrice: 0.025 ether,
161             highPrice: 0.025 ether,
162             fallDuration: priceFallDuration,
163             saleTime: now,
164             bagHolderFund: 0
165             });
166 
167     tikiMasks[3] =  _Tepeu;
168 
169     TikiMask memory _Usukan = TikiMask({
170             name: "Usukan",
171             basePrice: 0.030 ether,
172             highPrice: 0.030 ether,
173             fallDuration: priceFallDuration,
174             saleTime: now,
175             bagHolderFund: 0
176             });
177 
178     tikiMasks[4] =  _Usukan;
179 
180     TikiMask memory _Voltan = TikiMask({
181             name: "Voltan",
182             basePrice: 0.035 ether,
183             highPrice: 0.035 ether,
184             fallDuration: priceFallDuration,
185             saleTime: now,
186             bagHolderFund: 0
187             });
188 
189     tikiMasks[5] =  _Voltan;
190 
191     _transfer(0x0, contractOwner, 0);
192     _transfer(0x0, contractOwner, 1);
193     _transfer(0x0, contractOwner, 2);
194     _transfer(0x0, contractOwner, 3);
195     _transfer(0x0, contractOwner, 4);
196     _transfer(0x0, contractOwner, 5);
197 
198 
199   }
200 
201 
202   /// For querying balance of a particular account
203   /// @param _owner The address for balance query
204   function balanceOf(address _owner) public view returns (uint256 balance) {
205     return ownershipTokenCount[_owner];
206   }
207 
208   /// @notice Returns all the relevant information about a specific tiki.
209   /// @param _tokenId The tokenId of the tiki of interest.
210   function getTiki(uint256 _tokenId) public view returns (
211     string tikiName,
212     uint256 currentPrice,
213     uint256 basePrice,
214     address currentOwner,
215     uint256 bagHolderFund,
216     bool isBagFundAvailable
217   ) {
218     TikiMask storage tiki = tikiMasks[_tokenId];
219     tikiName = tiki.name;
220     currentPrice = priceOf(_tokenId);
221     basePrice = tiki.basePrice;
222     currentOwner = tikiIndexToOwner[_tokenId];
223     bagHolderFund = tiki.bagHolderFund;
224     isBagFundAvailable = now > (tiki.saleTime + priceFallDuration);
225   }
226 
227 
228   /// For querying owner of token
229   /// @param _tokenId The tokenID for owner inquiry
230   function ownerOf(uint256 _tokenId)
231     public
232     view
233     returns (address owner)
234   {
235     owner = tikiIndexToOwner[_tokenId];
236     require(owner != address(0));
237   }
238 
239   // Allows someone to send ether and obtain the token
240   function purchase(uint256 _tokenId , address _referredBy) public payable notContract notPaused easyOnGas  {
241 
242     address oldOwner = tikiIndexToOwner[_tokenId];
243     address newOwner = msg.sender;
244 
245     uint256 currentPrice = priceOf(_tokenId);
246 
247     // Making sure token owner is not sending to self
248     require(oldOwner != newOwner);
249 
250     // Safety check to prevent against an unexpected 0x0 default.
251     require(_addressNotNull(newOwner));
252 
253     // Making sure sent amount is greater than or equal to the sellingPrice
254     require(msg.value >= currentPrice);
255 
256     uint256 previousOwnerGets = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),previousOwnerPercent);
257     uint256 exchangeTokensAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),exchangeTokenPercent);
258     uint256 devFeeAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),devFeePercent);
259     uint256 bagHolderFundAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),bagHolderFundPercent);
260     uint256 godTikiGets = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),godTikiPercent);
261 
262     if (msg.value>currentPrice){
263       bagHolderFundAmount = bagHolderFundAmount + (msg.value-currentPrice); // overbidding should be discouraged
264     }
265     currentDevFee = currentDevFee + devFeeAmount;
266 
267     // buy the tokens for this player and include the referrer too (templenodes work)
268     templeContract.purchaseFor.value(exchangeTokensAmount)(_referredBy, msg.sender);
269  
270     // the god tiki receives their amount.
271     ownerOf(godTiki()).transfer(godTikiGets);
272 
273     // do the sale
274     _transfer(oldOwner, newOwner, _tokenId);
275 
276     // set new price and saleTime
277     tikiMasks[_tokenId].highPrice = SafeMath.mul(SafeMath.div(currentPrice,100),increaseRatePercent);
278     tikiMasks[_tokenId].saleTime = now;
279     tikiMasks[_tokenId].bagHolderFund = tikiMasks[_tokenId].bagHolderFund + bagHolderFundAmount;
280     tikiMasks[_tokenId].basePrice = max(tikiMasks[_tokenId].basePrice,SafeMath.div(tikiMasks[_tokenId].bagHolderFund,8));  // 12.5% of the holder fund
281 
282     // Pay previous tokenOwner if owner is not contract
283     if (oldOwner != address(this)) {
284       if (oldOwner.send(previousOwnerGets)){}
285     }
286 
287     emit onTokenSold(_tokenId, currentPrice, oldOwner, newOwner, tikiMasks[_tokenId].name);
288 
289   }
290 
291   /// @dev this is the tiki with the current lowest value - it receives 2% of ALL sales.
292   function godTiki() public view returns (uint256 tokenId) {
293     uint256 lowestPrice = priceOf(0);
294     uint256 lowestId = 0;
295     for(uint x=1;x<6;x++){
296       if(priceOf(x)<lowestPrice){
297         lowestId=x;
298       }
299     }
300     return lowestId;
301   }
302 
303   /// @dev calculate the current price of this token
304   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
305 
306     TikiMask storage tiki = tikiMasks[_tokenId];
307     uint256 secondsPassed  = now - tiki.saleTime;
308 
309     if (secondsPassed >= tiki.fallDuration || tiki.highPrice==tiki.basePrice) {
310             return tiki.basePrice;
311     }
312 
313     uint256 totalPriceChange = tiki.highPrice - tiki.basePrice;
314     uint256 currentPriceChange = totalPriceChange * secondsPassed /tiki.fallDuration;
315     uint256 currentPrice = tiki.highPrice - currentPriceChange;
316 
317     return currentPrice;
318   }
319 
320   /// @dev allow holder to collect fund if time is expired
321   function collectBagHolderFund(uint256 _tokenId) public notPaused {
322       require(msg.sender == tikiIndexToOwner[_tokenId]);
323       uint256 bagHolderFund;
324       bool isBagFundAvailable = false;
325        (
326         ,
327         ,
328         ,
329         ,
330         bagHolderFund,
331         isBagFundAvailable
332         ) = getTiki(_tokenId);
333         require(isBagFundAvailable && bagHolderFund > 0);
334         uint256 amount = bagHolderFund;
335         tikiMasks[_tokenId].bagHolderFund = 0;
336         tikiMasks[_tokenId].basePrice = 0.015 ether;
337         msg.sender.transfer(amount);
338   }
339 
340   function paused() public view returns (bool){
341     return (now < startTime);
342   }
343 
344   /*** PRIVATE FUNCTIONS ***/
345   /// Safety check on _to address to prevent against an unexpected 0x0 default.
346   function _addressNotNull(address _to) private pure returns (bool) {
347     return _to != address(0);
348   }
349 
350   /// Check for token ownership
351   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
352     return claimant == tikiIndexToOwner[_tokenId];
353   }
354 
355   /// @dev Assigns ownership of a specific token to an address.
356   function _transfer(address _from, address _to, uint256 _tokenId) private {
357 
358     // no transfer to contract
359     uint length;
360     assembly { length := extcodesize(_to) }
361     require (length == 0);
362 
363     ownershipTokenCount[_to]++;
364     //transfer ownership
365     tikiIndexToOwner[_tokenId] = _to;
366 
367     if (_from != address(0)) {
368       ownershipTokenCount[_from]--;
369     }
370   }
371 
372   /// @dev Not a charity
373   function collectDevFees() public onlyOwner {
374       if (currentDevFee < address(this).balance){
375          uint256 amount = currentDevFee;
376          currentDevFee = 0;
377          contractOwner.transfer(amount);
378       }
379   }
380 
381 
382     /// @dev stop and start
383     function max(uint a, uint b) private pure returns (uint) {
384            return a > b ? a : b;
385     }
386 
387 }
388 
389 
390 /**
391  * @title SafeMath
392  * @dev Math operations with safety checks that throw on error
393  */
394 library SafeMath {
395 
396     /**
397     * @dev Multiplies two numbers, throws on overflow.
398     */
399     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
400         if (a == 0) {
401             return 0;
402         }
403         uint256 c = a * b;
404         assert(c / a == b);
405         return c;
406     }
407 
408     /**
409     * @dev Integer division of two numbers, truncating the quotient.
410     */
411     function div(uint256 a, uint256 b) internal pure returns (uint256) {
412         // assert(b > 0); // Solidity automatically throws when dividing by 0
413         uint256 c = a / b;
414         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
415         return c;
416     }
417 
418     /**
419     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
420     */
421     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
422         assert(b <= a);
423         return a - b;
424     }
425 
426     /**
427     * @dev Adds two numbers, throws on overflow.
428     */
429     function add(uint256 a, uint256 b) internal pure returns (uint256) {
430         uint256 c = a + b;
431         assert(c >= a);
432         return c;
433     }
434 
435 }