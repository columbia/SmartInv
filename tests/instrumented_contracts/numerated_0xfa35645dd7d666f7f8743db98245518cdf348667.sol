1 pragma solidity ^0.4.24;
2 /***
3  * https://templeofeth.io
4  *
5  * Tribal Warfare.
6  *
7  * A timer countdown - starts 12 mins.
8  * 6 Tribal masks flipping
9  * Price increase by 35% per flip
10  * TMPL tokens 10%
11  * Dev fee: 5 %
12  * 110% previous owner.
13  * 5% goes into current pot.
14  * 5% goes into next pot.
15  * Each mask has a “time power” that adds 2,4,6,8,10,12 minutes to the timer when the card flips.
16  * When the timer runs out the round ends and the last mask to flip wins the current pot.
17  * Next round starts on next flip - prices are reset.
18  *
19  * Temple Warning: Do not play with more than you can afford to lose.
20  */
21 
22 contract TempleInterface {
23   function purchaseFor(address _referredBy, address _customerAddress) public payable returns (uint256);
24 }
25 
26 contract TribalWarfare {
27 
28   /*=================================
29   =            MODIFIERS            =
30   =================================*/
31 
32   /// @dev Access modifier for owner functions
33   modifier onlyOwner() {
34     require(msg.sender == contractOwner);
35     _;
36   }
37 
38   /// @dev Prevent contract calls.
39   modifier notContract() {
40     require(tx.origin == msg.sender);
41     _;
42   }
43 
44   /// @dev notPaused
45   modifier notPaused() {
46     require(paused == false);
47     _;
48   }
49 
50   /// @dev easyOnGas
51   modifier easyOnGas() {
52     require(tx.gasprice < 99999999999);
53     _;
54   }
55 
56   /*==============================
57   =            EVENTS            =
58   ==============================*/
59 
60   event onTokenSold(
61        uint256 indexed tokenId,
62        uint256 price,
63        address prevOwner,
64        address newOwner,
65        string name
66     );
67 
68     event onRoundEnded(
69          uint256 indexed roundNumber,
70          uint256 indexed tokenId,
71          address owner,
72          uint256 winnings
73       );
74 
75   /*==============================
76   =            CONSTANTS         =
77   ==============================*/
78 
79   uint256 private increaseRatePercent =  135;
80   uint256 private devFeePercent =  5;
81   uint256 private currentPotPercent =  5;
82   uint256 private nextPotPercent =  5;
83   uint256 private exchangeTokenPercent =  10;
84   uint256 private previousOwnerPercent =  110;
85   uint256 private initialRoundDuration =  12 minutes;
86 
87   /*==============================
88   =            STORAGE           =
89   ==============================*/
90 
91   /// @dev A mapping from token IDs to the address that owns them.
92   mapping (uint256 => address) public tokenIndexToOwner;
93 
94   // @dev A mapping from owner address to count of tokens that address owns.
95   mapping (address => uint256) private ownershipTokenCount;
96 
97   // @dev The address of the owner
98   address public contractOwner;
99 
100   // @dev Current dev fee
101   uint256 public currentDevFee = 0;
102 
103   // @dev The address of the temple contract
104   address public templeOfEthaddress = 0x0e21902d93573c18fd0acbadac4a5464e9732f54; // MAINNET
105 
106   /// @dev Interface to exchange
107   TempleInterface public templeContract;
108 
109   // @dev paused
110   bool public paused = false;
111 
112   uint256 public currentPot =  0;
113   uint256 public nextPot =  0;
114   uint256 public roundNumber =  0;
115   uint256 public roundEndingTime =  0;
116   uint256 public lastFlip =  0; // the last token to flip
117 
118   /*==============================
119   =            DATATYPES         =
120   ==============================*/
121 
122   struct TribalMask {
123     string name;
124     uint256 basePrice;
125     uint256 currentPrice;
126     uint256 timePowerMinutes;
127   }
128 
129   TribalMask [6] public tribalMasks;
130 
131   constructor () public {
132 
133     contractOwner = msg.sender;
134     templeContract = TempleInterface(templeOfEthaddress);
135     paused=true;
136 
137     TribalMask memory _Yucatec = TribalMask({
138             name: "Yucatec",
139             basePrice: 0.018 ether,
140             currentPrice: 0.018 ether,
141             timePowerMinutes: 12 minutes
142             });
143 
144     tribalMasks[0] =  _Yucatec;
145 
146     TribalMask memory _Chiapas = TribalMask({
147             name: "Chiapas",
148             basePrice: 0.020 ether,
149             currentPrice: 0.020 ether,
150             timePowerMinutes: 10 minutes
151             });
152 
153     tribalMasks[1] =  _Chiapas;
154 
155     TribalMask memory _Kekchi = TribalMask({
156             name: "Kekchi",
157             basePrice: 0.022 ether,
158             currentPrice: 0.022 ether,
159             timePowerMinutes: 8 minutes
160             });
161 
162     tribalMasks[2] =  _Kekchi;
163 
164     TribalMask memory _Chontal = TribalMask({
165             name: "Chontal",
166             basePrice: 0.024 ether,
167             currentPrice: 0.024 ether,
168             timePowerMinutes: 6 minutes
169             });
170 
171     tribalMasks[3] =  _Chontal;
172 
173     TribalMask memory _Akatek = TribalMask({
174             name: "Akatek",
175             basePrice: 0.028 ether,
176             currentPrice: 0.028 ether,
177             timePowerMinutes: 4 minutes
178             });
179 
180     tribalMasks[4] =  _Akatek;
181 
182     TribalMask memory _Itza = TribalMask({
183             name: "Itza",
184             basePrice: 0.030 ether,
185             currentPrice: 0.030 ether,
186             timePowerMinutes: 2 minutes
187             });
188 
189     tribalMasks[5] =  _Itza;
190 
191     _transfer(0x0, contractOwner, 0);
192     _transfer(0x0, contractOwner, 1);
193     _transfer(0x0, contractOwner, 2);
194     _transfer(0x0, contractOwner, 3);
195     _transfer(0x0, contractOwner, 4);
196     _transfer(0x0, contractOwner, 5);
197 
198   }
199 
200   /// @notice Returns all the relevant information about a specific token.
201   /// @param _tokenId The tokenId of the token of interest.
202   function getTribalMask(uint256 _tokenId) public view returns (
203     string maskName,
204     uint256 basePrice,
205     uint256 currentPrice,
206     address currentOwner
207   ) {
208     TribalMask storage mask = tribalMasks[_tokenId];
209     maskName = mask.name;
210     basePrice = mask.basePrice;
211     currentPrice = priceOf(_tokenId);
212     currentOwner = tokenIndexToOwner[_tokenId];
213   }
214 
215   /// For querying owner of token
216   /// @param _tokenId The tokenID for owner inquiry
217   function ownerOf(uint256 _tokenId)
218     public
219     view
220     returns (address owner)
221   {
222     owner = tokenIndexToOwner[_tokenId];
223     require(owner != address(0));
224   }
225 
226   function () public payable {
227       // allow donations to the pots for seeding etc.
228       currentPot = currentPot + SafeMath.div(msg.value,2);
229       nextPot = nextPot + SafeMath.div(msg.value,2);
230   }
231 
232  function start() public payable onlyOwner {
233    roundNumber = 1;
234    roundEndingTime = now + initialRoundDuration;
235    currentPot = currentPot + SafeMath.div(msg.value,2);
236    nextPot = nextPot + SafeMath.div(msg.value,2);
237    paused = false;
238  }
239 
240  function isRoundEnd() public view returns (bool){
241      return (now>roundEndingTime);
242  }
243 
244  function newRound() internal {
245    // round is over
246    // distribute the winnings
247     tokenIndexToOwner[lastFlip].transfer(currentPot);
248    // some event
249    emit onRoundEnded(roundNumber, lastFlip, tokenIndexToOwner[lastFlip], currentPot);
250 
251    // reset prices
252    tribalMasks[0].currentPrice=tribalMasks[0].basePrice;
253    tribalMasks[1].currentPrice=tribalMasks[1].basePrice;
254    tribalMasks[2].currentPrice=tribalMasks[2].basePrice;
255    tribalMasks[3].currentPrice=tribalMasks[3].basePrice;
256    tribalMasks[4].currentPrice=tribalMasks[4].basePrice;
257    tribalMasks[5].currentPrice=tribalMasks[5].basePrice;
258    roundNumber++;
259    roundEndingTime = now + initialRoundDuration;
260    currentPot = nextPot;
261    nextPot = 0;
262  }
263 
264   // Allows someone to send ether and obtain the token
265   function purchase(uint256 _tokenId , address _referredBy) public payable notContract notPaused easyOnGas  {
266 
267     // check if round ends
268     if (now >= roundEndingTime){
269         newRound();
270     }
271 
272     uint256 currentPrice = tribalMasks[_tokenId].currentPrice;
273     // Making sure sent amount is greater than or equal to the sellingPrice
274     require(msg.value >= currentPrice);
275 
276     address oldOwner = tokenIndexToOwner[_tokenId];
277     address newOwner = msg.sender;
278 
279      // Making sure token owner is not sending to self
280     require(oldOwner != newOwner);
281 
282     // Safety check to prevent against an unexpected 0x0 default.
283     require(_addressNotNull(newOwner));
284 
285     uint256 previousOwnerGets = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),previousOwnerPercent);
286     uint256 exchangeTokensAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),exchangeTokenPercent);
287     uint256 devFeeAmount = SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),devFeePercent);
288     currentPot = currentPot + SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),currentPotPercent);
289     nextPot = nextPot + SafeMath.mul(SafeMath.div(currentPrice,increaseRatePercent),nextPotPercent);
290 
291     // ovebid should be discouraged but not punished at round end.
292     if (msg.value > currentPrice){
293       if (now < roundEndingTime){
294         nextPot = nextPot + (msg.value - currentPrice);
295       }else{
296         // hardly fair to punish round ender
297         msg.sender.transfer(msg.value - currentPrice);
298       }
299     }
300 
301     currentDevFee = currentDevFee + devFeeAmount;
302 
303     templeContract.purchaseFor.value(exchangeTokensAmount)(_referredBy, msg.sender);
304 
305     // do the sale
306     _transfer(oldOwner, newOwner, _tokenId);
307 
308     // set new price
309     tribalMasks[_tokenId].currentPrice = SafeMath.mul(SafeMath.div(currentPrice,100),increaseRatePercent);
310     // extend the time
311     roundEndingTime = roundEndingTime + tribalMasks[_tokenId].timePowerMinutes;
312 
313     lastFlip = _tokenId;
314     // Pay previous tokenOwner if owner is not contract
315     if (oldOwner != address(this)) {
316       if (oldOwner.send(previousOwnerGets)){}
317     }
318 
319     emit onTokenSold(_tokenId, currentPrice, oldOwner, newOwner, tribalMasks[_tokenId].name);
320 
321   }
322 
323   function priceOf(uint256 _tokenId) public view returns (uint256 price) {
324       if(isRoundEnd()){
325         return  tribalMasks[_tokenId].basePrice;
326       }
327     return tribalMasks[_tokenId].currentPrice;
328   }
329 
330   /*** PRIVATE FUNCTIONS ***/
331   /// Safety check on _to address to prevent against an unexpected 0x0 default.
332   function _addressNotNull(address _to) private pure returns (bool) {
333     return _to != address(0);
334   }
335 
336   /// Check for token ownership
337   function _owns(address claimant, uint256 _tokenId) private view returns (bool) {
338     return claimant == tokenIndexToOwner[_tokenId];
339   }
340 
341   /// @dev Assigns ownership of a specific token to an address.
342   function _transfer(address _from, address _to, uint256 _tokenId) private {
343 
344     // no transfer to contract
345     uint length;
346     assembly { length := extcodesize(_to) }
347     require (length == 0);
348 
349     ownershipTokenCount[_to]++;
350     //transfer ownership
351     tokenIndexToOwner[_tokenId] = _to;
352 
353     if (_from != address(0)) {
354       ownershipTokenCount[_from]--;
355     }
356 
357   }
358 
359   /// @dev Not a charity
360   function collectDevFees() public onlyOwner {
361       if (currentDevFee < address(this).balance){
362          uint256 amount = currentDevFee;
363          currentDevFee = 0;
364          contractOwner.transfer(amount);
365       }
366   }
367 
368 }
369 
370 
371 /**
372  * @title SafeMath
373  * @dev Math operations with safety checks that throw on error
374  */
375 library SafeMath {
376 
377     /**
378     * @dev Multiplies two numbers, throws on overflow.
379     */
380     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
381         if (a == 0) {
382             return 0;
383         }
384         uint256 c = a * b;
385         assert(c / a == b);
386         return c;
387     }
388 
389     /**
390     * @dev Integer division of two numbers, truncating the quotient.
391     */
392     function div(uint256 a, uint256 b) internal pure returns (uint256) {
393         // assert(b > 0); // Solidity automatically throws when dividing by 0
394         uint256 c = a / b;
395         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
396         return c;
397     }
398 
399     /**
400     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
401     */
402     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
403         assert(b <= a);
404         return a - b;
405     }
406 
407     /**
408     * @dev Adds two numbers, throws on overflow.
409     */
410     function add(uint256 a, uint256 b) internal pure returns (uint256) {
411         uint256 c = a + b;
412         assert(c >= a);
413         return c;
414     }
415 
416 }