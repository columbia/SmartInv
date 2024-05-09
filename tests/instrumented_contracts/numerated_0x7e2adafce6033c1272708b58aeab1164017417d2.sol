1 pragma solidity ^0.4.18;
2 
3 contract CryptoflipCar {
4 
5 address ownerAddress = 0x3177Abbe93422c9525652b5d4e1101a248A99776;
6 address foundTeamAddress = 0x30A38029bEd78159B0342FF9722C3B56479328D8;
7 
8 struct WhaleCard {
9    address ownerAddress;
10    uint256 curPrice;
11 }
12 
13 struct Company {
14 string name;
15 address ownerAddress;
16 uint256 curPrice;
17 bool is_released;
18 }
19 
20 struct Make {
21 string name;
22 address ownerAddress;
23 uint256 curPrice;
24 uint256 companyId;
25 bool is_released;
26 }
27 
28 struct Car {
29 string name;
30 address[] ownerAddresses;
31 uint256 curPrice;
32 uint256 companyId;
33 uint256 makeId;
34 bool is_released;
35 }
36 
37 struct Adv {
38 string text;
39 string link;
40 uint256 card_type;  /* 0: company 1: makes 2: car*/
41 uint256 curPrice;
42 address ownerAddress;
43 uint256 cardId;
44 }
45 
46 Company[] companies;
47 Make[] makes;
48 Car[] cars;
49 Adv[] advs;
50 WhaleCard whalecard;
51 modifier onlyOwner() {
52 require (msg.sender == ownerAddress);
53 _;
54 }
55 
56 bool companiesAreInitiated = false;
57 bool makesAreInitiated = false;
58 bool carsAreInitiated = false;
59 bool whalecardAreInitiated = false;
60 bool isPaused = false;
61 
62 /*
63 We use the following functions to pause and unpause the game.
64 */
65 function pauseGame() public onlyOwner {
66   isPaused = true;
67 }
68 
69 function playGame() public onlyOwner {
70   isPaused = false;
71 }
72 
73 function GetIsPauded() public view returns(bool) {
74   return(isPaused);
75 }
76 
77 function purchaseAdv(uint256 _cardType, uint256 _cardId, string _text, string _link) public payable {
78   require(msg.value >= advs[_advId].curPrice);
79   require(isPaused == false);
80   uint256 _advId;
81   bool is_adv = false;
82   for (uint i=0; i < advs.length; i++) {
83     if (advs[i].card_type == _cardType && advs[i].cardId == _cardId){
84         _advId = i;
85         is_adv = true;
86     }
87   }    
88   require(is_adv == true);
89   uint256 totalpercent = 160;
90 
91   uint256 commission5percent = (msg.value * 5 / totalpercent);
92   foundTeamAddress.transfer(commission5percent);
93 
94   uint256 commissionOwner = msg.value - commission5percent;
95     
96   if (advs[_advId].card_type == 0){
97     companies[advs[_advId].cardId].ownerAddress.transfer(commission5percent);
98     commissionOwner = commissionOwner - commission5percent;
99   } else if (advs[_advId].card_type == 1) {
100     makes[advs[_advId].cardId].ownerAddress.transfer(commission5percent);
101     commissionOwner = commissionOwner - commission5percent;
102   } else if (advs[_advId].card_type == 2) {
103     makes[advs[_advId].cardId].ownerAddress.transfer(commission5percent);
104     commissionOwner = commissionOwner - commission5percent;
105   }
106 
107   advs[_advId].ownerAddress.transfer(commissionOwner);
108   advs[_advId].ownerAddress = msg.sender;
109   advs[_advId].curPrice = div(mul(advs[_advId].curPrice, totalpercent), 100);
110   advs[_advId].text = _text;
111   advs[_advId].link = _link;  
112 }
113 
114 function purchaseWhaleCard() public payable {
115     require(msg.value >= whalecard.curPrice);
116     require(isPaused == false);
117     require(whalecardAreInitiated == true);
118     uint256 totalpercent = 155;
119     uint256 commission5percent = div(mul(msg.value, 5) , totalpercent);
120     foundTeamAddress.transfer(commission5percent);    
121     uint256 commissionOwner = msg.value - commission5percent;
122     whalecard.ownerAddress.transfer(commissionOwner);    
123     whalecard.ownerAddress = msg.sender;
124     whalecard.curPrice = div(mul(whalecard.curPrice, totalpercent), 100);
125 }
126 
127 function purchaseCard(uint256 _cardType, uint256 _cardId) public payable {
128   require(isPaused == false);   
129   uint256 totalpercent = 150;
130   uint256 ownercount = 0;
131   if (_cardType == 0){
132       require(companies[_cardId].is_released == true);
133       require(msg.value >= companies[_cardId].curPrice);
134       totalpercent = totalpercent + 5;
135   } else if (_cardType == 1) {
136       require(makes[_cardId].is_released == true);
137       require(msg.value >= makes[_cardId].curPrice);      
138       totalpercent = totalpercent + 5 + 2;
139   } else if (_cardType == 2) {
140       require(cars[_cardId].is_released == true);
141       require(msg.value >= cars[_cardId].curPrice);            
142       uint256 len = cars[_cardId].ownerAddresses.length;
143       ownercount = 1;
144       if (cars[_cardId].ownerAddresses.length > 4){
145         ownercount = 3;
146       } else {
147         ownercount = len-1;
148       }
149       totalpercent = 150 + 5 + 2 + 2 + mul(ownercount, 2);
150   }
151 
152   uint256 commissionOwner = msg.value;
153   uint256 commission1percent = div(mul(msg.value, 1) , totalpercent);  
154   if (whalecardAreInitiated == true){
155     totalpercent = totalpercent + 1;
156 
157     whalecard.ownerAddress.transfer(commission1percent);
158     commissionOwner = commissionOwner - commission1percent;    
159   }
160   
161   uint256 commission5percent = mul(commission1percent, 5);
162   foundTeamAddress.transfer(commission5percent);
163 
164   commissionOwner = commissionOwner - commission5percent;
165   uint256 commission2percent = mul(commission1percent, 2);
166 
167   if (_cardType == 0){
168     companies[_cardId].ownerAddress.transfer(commissionOwner);
169     companies[_cardId].ownerAddress = msg.sender;
170     companies[_cardId].curPrice = div(mul(companies[_cardId].curPrice, totalpercent), 100);
171   } else if (_cardType == 1) {
172     uint256 companyId = makes[_cardId].companyId;
173     companies[companyId].ownerAddress.transfer(commission2percent);
174     commissionOwner = commissionOwner - commission5percent;
175     makes[_cardId].ownerAddress.transfer(commissionOwner);
176     makes[_cardId].ownerAddress = msg.sender;
177     makes[_cardId].curPrice = div(mul(makes[_cardId].curPrice, totalpercent), 100);
178   } else if (_cardType == 2){
179     companyId = makes[_cardId].companyId;
180     companies[companyId].ownerAddress.transfer(commission2percent);
181     commissionOwner = commissionOwner - commission2percent;
182     
183     uint256 makeId = cars[_cardId].makeId;
184 
185     makes[makeId].ownerAddress.transfer(commission2percent);
186     commissionOwner = commissionOwner - commission2percent;
187 
188     if (len > 1){
189         for (uint i=len-2; i>=0; i--) {
190             if (i > len-5){
191                 cars[_cardId].ownerAddresses[i].transfer(commission2percent);
192                 commissionOwner = commissionOwner - commission2percent;
193             }
194         }
195     }
196 
197     cars[_cardId].ownerAddresses[len-1].transfer(commissionOwner);
198     cars[_cardId].ownerAddresses.push(msg.sender);
199     if (ownercount < 3) totalpercent = totalpercent + 2;
200     cars[_cardId].curPrice = div(mul(cars[_cardId].curPrice, totalpercent), 100);
201   }
202 }
203 
204 // This function will return all of the details of our company
205 function getCompanyCount() public view returns (uint) {
206   return companies.length;
207 }
208 
209 function getMakeCount() public view returns (uint) {
210   return makes.length;
211 }
212 
213 function getCarCount() public view returns (uint) {
214   return cars.length;
215 }
216 
217 function getWhaleCard() public view returns (
218 address ownerAddress1,
219 uint256 curPrice
220 ){
221     ownerAddress1 = whalecard.ownerAddress;
222     curPrice = whalecard.curPrice;    
223 }
224 
225 // This function will return all of the details of our company
226 function getCompany(uint256 _companyId) public view returns (
227 string name,
228 address ownerAddress1,
229 uint256 curPrice,
230 bool is_released,
231 uint id
232 ) {
233   Company storage _company = companies[_companyId];
234   name = _company.name;
235   ownerAddress1 = _company.ownerAddress;
236   curPrice = _company.curPrice;
237   is_released = _company.is_released;
238   id = _companyId;
239 }
240 
241 function getMake(uint _makeId) public view returns (
242 string name,
243 address ownerAddress1,
244 uint256 curPrice,
245 uint256 companyId,
246 bool is_released,
247 uint id
248 ) {
249   Make storage _make = makes[_makeId];
250   name = _make.name;
251   ownerAddress1 = _make.ownerAddress;
252   curPrice = _make.curPrice;
253   companyId = _make.companyId;
254   is_released = _make.is_released;
255   id = _makeId;
256 }
257 
258 function getCar(uint _carId) public view returns (
259 string name,
260 address[] ownerAddresses,
261 uint256 curPrice,
262 uint256 companyId,
263 uint256 makeId,
264 bool is_released,
265 uint id
266 ) {
267   Car storage _car = cars[_carId];
268   name = _car.name;
269   ownerAddresses = _car.ownerAddresses;
270   curPrice = _car.curPrice;
271   makeId = _car.makeId;
272   companyId = _car.companyId;
273   is_released = _car.is_released;
274   id = _carId;
275 }
276 
277 
278 function getAdv(uint _cardType, uint _cardId) public view returns (
279 string text,
280 string link,
281 uint256 card_type,
282 address ownerAddress1,
283 uint256 curPrice,
284 uint256 cardId
285 ) {
286   Adv storage _adv = advs[0];
287   for (uint i=0; i < advs.length; i++) {
288     if (advs[i].card_type == _cardType && advs[i].cardId == _cardId){
289         _adv = advs[i];
290     }
291   }
292   text = _adv.text;
293   link = _adv.link;
294   ownerAddress1 = _adv.ownerAddress;
295   curPrice = _adv.curPrice;
296   cardId = _adv.cardId;
297   card_type = _adv.card_type;
298 }
299 
300 /**
301 @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
302 */
303 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
304 if (a == 0) {
305 return 0;
306 }
307 uint256 c = a * b;
308 return c;
309 }
310 
311 /**
312 @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
313 */
314 function div(uint256 a, uint256 b) internal pure returns (uint256) {
315 // assert(b > 0); // Solidity automatically throws when dividing by 0
316 uint c = a / b;
317 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
318 return c;
319 }
320 
321 
322 
323 function InitiateCompanies() public onlyOwner {
324   require(companiesAreInitiated == false);
325   addCompany('Aston Martin',ownerAddress, 100000000000000000);
326   addCompany('BMW',ownerAddress, 100000000000000000);
327   addCompany('Ferrari',ownerAddress, 100000000000000000);
328   addCompany('Honda',ownerAddress, 100000000000000000);
329   companiesAreInitiated = true;
330 }
331 
332 function addCompany(string name, address address1, uint256 price) public onlyOwner {
333   uint companyId = companies.length++;
334   companies[companyId].name = name;
335   companies[companyId].curPrice   = price;
336   companies[companyId].ownerAddress = address1;
337   companies[companyId].is_released   = true;
338 
339   uint advId = advs.length++;
340   advs[advId].text = 'Your Ad here';
341   advs[advId].link = 'http://cryptoflipcars.site/';
342   advs[advId].curPrice   = 5000000000000000;
343   advs[advId].card_type   = 0;
344   advs[advId].ownerAddress = address1;
345   advs[advId].cardId = companyId;
346 }
347 
348 function setReleaseCompany(uint256 _companyId, bool is_released) public onlyOwner {
349   companies[_companyId].is_released = is_released;
350 }
351 
352 function InitiateMakes() public onlyOwner {
353   require(makesAreInitiated == false);
354   addMake('DB5',ownerAddress,0,10000000000000000);
355   addMake('DB6',ownerAddress,0,10000000000000000);
356   addMake('DB9',ownerAddress,0,10000000000000000);
357   addMake('One-77',ownerAddress,0,10000000000000000);
358   makesAreInitiated = true;
359 }
360 
361 function addMake(string name, address address1, uint256 companyId, uint256 price) public onlyOwner {
362   uint makeId = makes.length++;
363   makes[makeId].name = name;
364   makes[makeId].curPrice   = price;
365   makes[makeId].ownerAddress = address1;
366   makes[makeId].companyId   = companyId;
367   makes[makeId].is_released   = true;
368 
369   uint advId = advs.length++;
370   advs[advId].text = 'Your Ad here';
371   advs[advId].link = 'http://cryptoflipcars.site/';
372   advs[advId].curPrice   = 5000000000000000;
373   advs[advId].card_type   = 1;
374   advs[advId].ownerAddress = address1;
375   advs[advId].cardId = makeId;
376 }
377 
378 
379 
380 function InitiateCars() public onlyOwner {
381   require(carsAreInitiated == false);
382   addCar('1964 DB5 James Bond Edition',ownerAddress, 0, 0, 5000000000000000);
383   addCar('Blue 1965 ',ownerAddress, 0, 0, 5000000000000000);
384   addCar('1964 DB5 James Bond Edition',ownerAddress,0,0,5000000000000000);
385   addCar('Blue 1965 ',ownerAddress,0,0,5000000000000000);
386   carsAreInitiated = true;
387 }
388 
389 function InitiateWhaleCard() public onlyOwner {
390     require(whalecardAreInitiated == false);
391     whalecard.ownerAddress = ownerAddress;
392     whalecard.curPrice = 100000000000000000;
393     whalecardAreInitiated = true;
394 }
395 
396 function addCar(string name, address address1, uint256 companyId, uint256 makeId, uint256 price ) public onlyOwner {
397   uint carId = cars.length++;
398   cars[carId].name = name;
399   cars[carId].curPrice   = price;
400   cars[carId].ownerAddresses.push(address1);
401   cars[carId].companyId   = companyId;
402   cars[carId].makeId   = makeId;
403   cars[carId].is_released   = true;
404 
405   uint advId = advs.length++;
406   advs[advId].text = 'Your Ad here';
407   advs[advId].link = 'http://cryptoflipcars.site/';
408   advs[advId].curPrice   = 5000000000000000;
409   advs[advId].card_type   = 2;
410   advs[advId].ownerAddress = address1;
411   advs[advId].cardId = carId;
412 }
413 
414 function setReleaseCar(uint256 _carId, bool is_released) public onlyOwner {
415   cars[_carId].is_released = is_released;
416 }
417 
418 function setReleaseMake(uint256 _makeId, bool is_released) public onlyOwner {
419   makes[_makeId].is_released = is_released;
420 }
421 }