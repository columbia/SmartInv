1 pragma solidity ^0.4.18;
2 
3 contract CryptoflipCar {
4 string version = '1.1';
5 address ownerAddress = 0x3177Abbe93422c9525652b5d4e1101a248A99776;
6 address foundTeamAddress = 0x30A38029bEd78159B0342FF9722C3B56479328D8;
7 
8 struct WhaleCard {
9    address ownerAddress;
10    uint256 curPrice;
11 }
12 
13 struct Car {
14     string name;
15     address[4] ownerAddresses;
16     uint256 curPrice;
17     uint256 companyId;
18     uint256 makeId;
19     bool is_released;
20     string adv_link;
21     string adv_text;
22     address adv_owner;
23     uint256 adv_price;
24 }
25     
26 struct Company {
27     string name;
28     address ownerAddress;
29     uint256 curPrice;
30     bool is_released;
31     string adv_link;
32     string adv_text;
33     address adv_owner;
34     uint256 adv_price;
35 }
36 
37 struct Make {
38     string name;
39     address ownerAddress;
40     uint256 curPrice;
41     uint256 companyId;
42     bool is_released;
43     string adv_link;
44     string adv_text;
45     address adv_owner;
46     uint256 adv_price;
47 }
48 
49 Company[] companies;
50 Make[] makes;
51 Car[] cars;
52 WhaleCard whalecard;
53 
54 modifier onlyOwner() {
55 require (msg.sender == ownerAddress);
56 _;
57 }
58 
59 bool companiesAreInitiated = false;
60 bool makesAreInitiated = false;
61 bool carsAreInitiated = false;
62 bool whalecardAreInitiated = false;
63 bool isPaused = false;
64 
65 /*
66 We use the following functions to pause and unpause the game.
67 */
68 function pauseGame() public onlyOwner {
69   isPaused = true;
70 }
71 
72 function playGame() public onlyOwner {
73   isPaused = false;
74 }
75 
76 function GetIsPauded() public view returns(bool) {
77   return(isPaused);
78 }
79 
80 function purchaseCarAdv(uint256 _cardId, string _text, string _link) public payable {
81   require(msg.value >= cars[_cardId].adv_price);
82   require(isPaused == false);
83   require(cars[_cardId].is_released == true);
84   uint256 totalpercent = 160;
85   uint256 commission5percent = div(mul(msg.value, 5), totalpercent);
86   foundTeamAddress.transfer(commission5percent);
87   uint256 commissionOwner = msg.value - commission5percent;
88   cars[_cardId].ownerAddresses[0].transfer(commission5percent);
89   commissionOwner = commissionOwner - commission5percent;
90   cars[_cardId].adv_owner.transfer(commissionOwner);
91   cars[_cardId].adv_owner = msg.sender;
92   cars[_cardId].adv_price = div(mul(cars[_cardId].adv_price, totalpercent), 100);
93   cars[_cardId].adv_text = _text;
94   cars[_cardId].adv_link = _link;  
95 }
96 
97 function purchaseCompanyAdv(uint256 _cardId, string _text, string _link) public payable {
98   require(msg.value >= companies[_cardId].adv_price);
99   require(isPaused == false);
100   require(companies[_cardId].is_released == true);
101   uint256 totalpercent = 160;
102   uint256 commission5percent = div(mul(msg.value, 5), totalpercent);
103   foundTeamAddress.transfer(commission5percent);
104   uint256 commissionOwner = msg.value - commission5percent;
105   companies[_cardId].ownerAddress.transfer(commission5percent);
106   commissionOwner = commissionOwner - commission5percent;
107   companies[_cardId].adv_owner.transfer(commissionOwner);
108   companies[_cardId].adv_owner = msg.sender;
109   companies[_cardId].adv_price = div(mul(companies[_cardId].adv_price, totalpercent), 100);
110   companies[_cardId].adv_text = _text;
111   companies[_cardId].adv_link = _link;  
112 }
113 
114 function purchaseMakeAdv(uint256 _cardId, string _text, string _link) public payable {
115   require(msg.value >= makes[_cardId].adv_price);
116   require(isPaused == false);
117   require(makes[_cardId].is_released == true);
118   uint256 totalpercent = 160;
119   uint256 commission5percent = div(mul(msg.value, 5), totalpercent);
120   foundTeamAddress.transfer(commission5percent);
121   uint256 commissionOwner = msg.value - commission5percent;
122   makes[_cardId].ownerAddress.transfer(commission5percent);
123   commissionOwner = commissionOwner - commission5percent;
124   makes[_cardId].adv_owner.transfer(commissionOwner);
125   makes[_cardId].adv_owner = msg.sender;
126   makes[_cardId].adv_price = div(mul(makes[_cardId].adv_price, totalpercent), 100);
127   makes[_cardId].adv_text = _text;
128   makes[_cardId].adv_link = _link;  
129 }
130 
131 function purchaseWhaleCard() public payable {
132     require(msg.value >= whalecard.curPrice);
133     require(isPaused == false);
134     require(whalecardAreInitiated == true);
135     uint256 totalpercent = 155;
136     uint256 commission5percent = div(mul(msg.value, 5) , totalpercent);
137     foundTeamAddress.transfer(commission5percent);    
138     uint256 commissionOwner = msg.value - commission5percent;
139     whalecard.ownerAddress.transfer(commissionOwner);    
140     whalecard.ownerAddress = msg.sender;
141     whalecard.curPrice = div(mul(whalecard.curPrice, totalpercent), 100);
142 }
143 
144 function purchaseCarCard(uint256 _cardId) public payable {
145   require(isPaused == false);   
146   require(msg.value >= cars[_cardId].curPrice);
147   require(cars[_cardId].is_released == true);
148   require(carsAreInitiated == true);
149   uint256 totalpercent = 150 + 5 + 2 + 2;
150   uint256 commission1percent = div(mul(msg.value, 1) , totalpercent);  
151   uint256 commissionOwner = msg.value;
152   if (whalecardAreInitiated == true){
153     totalpercent = totalpercent + 1;
154     whalecard.ownerAddress.transfer(commission1percent);
155     commissionOwner = commissionOwner - commission1percent;    
156   }
157   uint256 commission5percent = mul(commission1percent, 5);
158   foundTeamAddress.transfer(commission5percent);
159   commissionOwner = commissionOwner - commission5percent;
160   uint256 commission2percent = mul(commission1percent, 2);
161   uint256 companyId = cars[_cardId].companyId;
162   companies[companyId].ownerAddress.transfer(commission2percent);
163   commissionOwner = commissionOwner - commission2percent;
164   uint256 makeId = cars[_cardId].makeId;
165   makes[makeId].ownerAddress.transfer(commission2percent);
166   commissionOwner = commissionOwner - commission2percent;
167   if (cars[_cardId].ownerAddresses[3] != 0){
168       cars[_cardId].ownerAddresses[3].transfer(commission2percent);
169       commissionOwner = commissionOwner - commission2percent;
170       totalpercent = totalpercent + 2;
171   }
172   cars[_cardId].ownerAddresses[3] = cars[_cardId].ownerAddresses[2];
173   if (cars[_cardId].ownerAddresses[2] != 0){
174       cars[_cardId].ownerAddresses[2].transfer(commission2percent);
175       commissionOwner = commissionOwner - commission2percent;
176       totalpercent = totalpercent + 2;
177   }
178   cars[_cardId].ownerAddresses[2] = cars[_cardId].ownerAddresses[1];
179   if (cars[_cardId].ownerAddresses[1] != 0){
180       cars[_cardId].ownerAddresses[1].transfer(commission2percent);
181       commissionOwner = commissionOwner - commission2percent;
182       totalpercent = totalpercent + 2;
183   }
184   cars[_cardId].ownerAddresses[1] = cars[_cardId].ownerAddresses[0];
185   cars[_cardId].ownerAddresses[0].transfer(commissionOwner);
186   cars[_cardId].ownerAddresses[0] = msg.sender;
187   totalpercent = totalpercent + 2;
188   cars[_cardId].curPrice = div(mul(cars[_cardId].curPrice, totalpercent), 100);
189 }
190 
191 function purchaseMakeCard(uint256 _cardId) public payable {
192   require(isPaused == false);   
193   require(msg.value >= makes[_cardId].curPrice);
194   require(makes[_cardId].is_released == true);
195   require(makesAreInitiated == true);
196   uint256 totalpercent = 150 + 5 + 2;
197   uint256 commission1percent = div(mul(msg.value, 1) , totalpercent);  
198   uint256 commissionOwner = msg.value;
199   if (whalecardAreInitiated == true){
200     totalpercent = totalpercent + 1;
201     whalecard.ownerAddress.transfer(commission1percent);
202     commissionOwner = commissionOwner - commission1percent;    
203   }
204   uint256 commission5percent = mul(commission1percent, 5);
205   foundTeamAddress.transfer(commission5percent);
206   commissionOwner = commissionOwner - commission5percent;
207   uint256 commission2percent = mul(commission1percent, 2);
208   uint256 companyId = makes[_cardId].companyId;
209   companies[companyId].ownerAddress.transfer(commission2percent);
210   commissionOwner = commissionOwner - commission2percent;
211   makes[_cardId].ownerAddress.transfer(commissionOwner);
212   makes[_cardId].ownerAddress = msg.sender;
213   makes[_cardId].curPrice = div(mul(makes[_cardId].curPrice, totalpercent), 100);
214 }
215 
216 function purchaseCompanyCard(uint256 _cardId) public payable {
217   require(isPaused == false);   
218   require(msg.value >= companies[_cardId].curPrice);
219   require(companies[_cardId].is_released == true);
220   require(companiesAreInitiated == true);
221   uint256 totalpercent = 150 + 5;
222   uint256 commission1percent = div(mul(msg.value, 1) , totalpercent);  
223   uint256 commissionOwner = msg.value;
224   if (whalecardAreInitiated == true){
225     totalpercent = totalpercent + 1;
226     whalecard.ownerAddress.transfer(commission1percent);
227     commissionOwner = commissionOwner - commission1percent;    
228   }
229   uint256 commission5percent = mul(commission1percent, 5);
230   foundTeamAddress.transfer(commission5percent);
231   commissionOwner = commissionOwner - commission5percent;
232   companies[_cardId].ownerAddress.transfer(commissionOwner);
233   companies[_cardId].ownerAddress = msg.sender;
234   companies[_cardId].curPrice = div(mul(companies[_cardId].curPrice, totalpercent), 100);
235 }
236 // This function will return all of the details of our company
237 function getCompanyCount() public view returns (uint) {
238   return companies.length;
239 }
240 
241 function getMakeCount() public view returns (uint) {
242   return makes.length;
243 }
244 
245 function getCarCount() public view returns (uint) {
246   return cars.length;
247 }
248 
249 function getWhaleCard() public view returns (
250 address ownerAddress1,
251 uint256 curPrice
252 ){
253     ownerAddress1 = whalecard.ownerAddress;
254     curPrice = whalecard.curPrice;    
255 }
256 
257 // This function will return all of the details of our company
258 function getCompany(uint256 _companyId) public view returns (
259 string name,
260 address ownerAddress1,
261 uint256 curPrice,
262 bool is_released,
263 string adv_text,
264 string adv_link,
265 uint256 adv_price,
266 address adv_owner,
267 uint id
268 ) {
269   Company storage _company = companies[_companyId];
270   name = _company.name;
271   ownerAddress1 = _company.ownerAddress;
272   curPrice = _company.curPrice;
273   is_released = _company.is_released;
274   id = _companyId;
275   adv_text = _company.adv_text;
276   adv_link = _company.adv_link;
277   adv_price = _company.adv_price;
278   adv_owner = _company.adv_owner;
279 }
280 
281 function getMake(uint _makeId) public view returns (
282 string name,
283 address ownerAddress1,
284 uint256 curPrice,
285 uint256 companyId,
286 bool is_released,
287 string adv_text,
288 string adv_link,
289 uint256 adv_price,
290 address adv_owner,
291 uint id
292 ) {
293   Make storage _make = makes[_makeId];
294   name = _make.name;
295   ownerAddress1 = _make.ownerAddress;
296   curPrice = _make.curPrice;
297   companyId = _make.companyId;
298   is_released = _make.is_released;
299   id = _makeId;
300   adv_text = _make.adv_text;
301   adv_link = _make.adv_link;
302   adv_price = _make.adv_price;
303   adv_owner = _make.adv_owner;
304 }
305 
306 function getCar(uint _carId) public view returns (
307 string name,
308 address[4] ownerAddresses,
309 uint256 curPrice,
310 uint256 companyId,
311 uint256 makeId,
312 bool is_released,
313 string adv_text,
314 string adv_link,
315 uint256 adv_price,
316 address adv_owner,
317 uint id
318 ) {
319   Car storage _car = cars[_carId];
320   name = _car.name;
321   ownerAddresses = _car.ownerAddresses;
322   curPrice = _car.curPrice;
323   makeId = _car.makeId;
324   companyId = _car.companyId;
325   is_released = _car.is_released;
326   id = _carId;
327   adv_text = _car.adv_text;
328   adv_link = _car.adv_link;
329   adv_price = _car.adv_price;
330   adv_owner = _car.adv_owner;
331 }
332 
333 
334 /**
335 @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
336 */
337 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
338 if (a == 0) {
339 return 0;
340 }
341 uint256 c = a * b;
342 return c;
343 }
344 
345 /**
346 @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
347 */
348 function div(uint256 a, uint256 b) internal pure returns (uint256) {
349 // assert(b > 0); // Solidity automatically throws when dividing by 0
350 uint c = a / b;
351 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
352 return c;
353 }
354 
355 
356 
357 function InitiateCompanies() public onlyOwner {
358   require(companiesAreInitiated == false);
359   addCompany("Aston Martin", 0xe7eca2a94e9d59848f3c1e1ffaacd881d4c3a4f2, 592240896000000000 ,true);
360   addCompany("BMW", 0x327bfb6286026bd1a017ba6693e0f47c8b98731b, 592240896000000000 ,true);
361   addCompany("Ferrari", 0xef764bac8a438e7e498c2e5fccf0f174c3e3f8db, 379641600000000000 ,true);
362   addCompany("Honda", 0xef764bac8a438e7e498c2e5fccf0f174c3e3f8db, 243360000000000000 ,true);
363   companies[0].adv_text="BurnUP!!!";
364   companies[0].adv_link="https://burnup.io/?r=0x049bEd1598655b64F09E4835084fBc502ab1aD86";
365   companies[0].adv_owner=0x049bed1598655b64f09e4835084fbc502ab1ad86;
366   companies[0].adv_price=8000000000000000;
367   companiesAreInitiated = true;
368 }
369 
370 function addCompany(string name, address address1, uint256 price, bool is_released) public onlyOwner {
371   uint companyId = companies.length++;
372   companies[companyId].name = name;
373   companies[companyId].curPrice   = price;
374   companies[companyId].ownerAddress = address1;
375   companies[companyId].is_released   = is_released;
376   companies[companyId].adv_text = 'Your Ad here';
377   companies[companyId].adv_link = 'http://cryptoflipcars.site/';
378   companies[companyId].adv_price   = 5000000000000000;
379   companies[companyId].adv_owner = address1;
380 }
381 
382 function setReleaseCompany(uint256 _companyId, bool is_released) public onlyOwner {
383   companies[_companyId].is_released = is_released;
384 }
385 
386 function InitiateMakes() public onlyOwner {
387   require(makesAreInitiated == false);
388   addMake("DB5", 0x7396176ac6c1ef05d57180e7733b9188b3571d9a, 98465804768000000 ,0, true);
389   addMake("DB6", 0x3130259deedb3052e24fad9d5e1f490cb8cccaa0, 62320129600000000 ,0, true);
390   addMake("DB9", 0xa2381223639181689cd6c46d38a1a4884bb6d83c, 39443120000000000 ,0, true);
391   addMake("One-77", 0xa2381223639181689cd6c46d38a1a4884bb6d83c, 39443120000000000 ,0, true);
392   addMake("BMW 507", 0x049bed1598655b64f09e4835084fbc502ab1ad86, 98465804768000000 ,1, false);
393   addMake("BMW Z8", 0xd17e2bfe196470a9fefb567e8f5992214eb42f24, 98465804768000000 ,1, false);
394   addMake("Fererrari LaFerrari", 0x7396176ac6c1ef05d57180e7733b9188b3571d9a, 24964000000000000 ,2, true);
395   addMake("Ferrari California", 0xa2381223639181689cd6c46d38a1a4884bb6d83c, 15800000000000000 ,2, true);
396   addMake("Honda Accord", 0x7396176ac6c1ef05d57180e7733b9188b3571d9a, 24964000000000000 ,3, true);
397   addMake("Honda Civic", 0xa2381223639181689cd6c46d38a1a4884bb6d83c, 15800000000000000 ,3, false);
398   makesAreInitiated = true;
399 }
400 
401 function addMake(string name, address address1, uint256 price, uint256 companyId,  bool is_released) public onlyOwner {
402   uint makeId = makes.length++;
403   makes[makeId].name = name;
404   makes[makeId].curPrice   = price;
405   makes[makeId].ownerAddress = address1;
406   makes[makeId].companyId   = companyId;
407   makes[makeId].is_released   = is_released;
408   makes[makeId].adv_text = 'Your Ad here';
409   makes[makeId].adv_link = 'http://cryptoflipcars.site/';
410   makes[makeId].adv_price   = 5000000000000000;
411   makes[makeId].adv_owner = address1;
412 }
413 
414 
415 
416 function InitiateCars() public onlyOwner {
417   require(carsAreInitiated == false);
418   addCar("1964 DB5 James Bond Edition", 0x5c035bb4cb7dacbfee076a5e61aa39a10da2e956, 8100000000000000 ,0, 0, true);
419   addCar("Blue 1965" , 0x71f35825a3b1528859dfa1a64b24242bc0d12990, 8100000000000000 ,0, 0, true);
420   addCar("1964 DB5 James Bond Edition", 0x71f35825a3b1528859dfa1a64b24242bc0d12990, 8100000000000000 ,0, 0, true);
421   addCar("Blue 1965" , 0x71f35825a3b1528859dfa1a64b24242bc0d12990, 8100000000000000 ,0, 0, true);
422   addCar("Z8 2003", 0x3177abbe93422c9525652b5d4e1101a248a99776, 10000000000000000 ,1, 5, true);
423   addCar("DB6 Chocolate", 0x3177abbe93422c9525652b5d4e1101a248a99776, 10000000000000000 ,0, 1, true);
424   addCar("507 Black", 0x3177abbe93422c9525652b5d4e1101a248a99776, 10000000000000000 ,1, 4, true);
425   addCar("507 Silver", 0x62d5be95c330b512b35922e347319afd708da981, 16200000000000000 ,1, 4, true);
426   addCar("Z8 Black with Red Interior", 0x3177abbe93422c9525652b5d4e1101a248a99776, 10000000000000000 ,1, 5, true);
427   addCar("Gordon Ramsey's Grey LaFerrari", 0x3177abbe93422c9525652b5d4e1101a248a99776, 10000000000000000 ,2, 6, true);
428   carsAreInitiated = true;
429 }
430 
431 function InitiateWhaleCard() public onlyOwner {
432     require(whalecardAreInitiated == false);
433     whalecard.ownerAddress = ownerAddress;
434     whalecard.curPrice = 100000000000000000;
435     whalecardAreInitiated = true;
436 }
437 
438 function addCar(string name, address address1, uint256 price, uint256 companyId, uint256 makeId,  bool is_released) public onlyOwner {
439   uint carId = cars.length++;
440   cars[carId].name = name;
441   cars[carId].curPrice   = price;
442   cars[carId].ownerAddresses[0] = address1;
443   cars[carId].companyId   = companyId;
444   cars[carId].makeId   = makeId;
445   cars[carId].is_released   = is_released;
446   cars[carId].adv_text = 'Your Ad here';
447   cars[carId].adv_link = 'http://cryptoflipcars.site/';
448   cars[carId].adv_price   = 5000000000000000;
449   cars[carId].adv_owner = address1;
450 }
451 
452 function setReleaseCar(uint256 _carId, bool is_released) public onlyOwner {
453   cars[_carId].is_released = is_released;
454 }
455 
456 function setReleaseMake(uint256 _makeId, bool is_released) public onlyOwner {
457   makes[_makeId].is_released = is_released;
458 }
459 }