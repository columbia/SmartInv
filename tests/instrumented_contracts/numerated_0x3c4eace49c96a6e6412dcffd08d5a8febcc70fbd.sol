1 /*
2 Copyright 2018 Ethecom.com
3 
4 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
5 
6 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
7 
8 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
9 */
10 
11 pragma solidity ^0.4.21;
12 
13 contract Ownable {
14     address public owner;
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     function transferOwnership(address newOwner) public onlyOwner {
25         if (newOwner != address(0)) {
26             owner = newOwner;
27         }
28     }
29 }
30 
31 contract Utils {
32     function sqrt(uint256 x) public pure returns (uint256 y) {
33         uint z = (x + 1) / 2;
34         y = x;
35         while (z < y) {
36             y = z;
37             z = (x / z + z) / 2;
38         }
39     }
40 
41     function lowerCase(bytes32 value) public pure returns (bytes32) {
42         bytes32 result = value;
43         for (uint i = 0; i < 32; i++) {
44             if (uint(value[i]) >= 65 && uint(value[i]) <= 90) {
45                 result |= bytes32(0x20) << (31-i)*8;
46             }
47         }
48         return result;
49     }
50     
51     function validateCompanyName(bytes32 name) public pure returns (bool) {
52         for (uint i = 0; i < 32; i++) {
53             if (uint(name[i]) != 0 && (uint(name[i]) < 32 || uint(name[i]) > 126)) {
54                 return false;
55             }
56         }
57         return true;
58     }
59 }
60 
61 contract CompanyCostInterface is Ownable {
62     function getCreationCost() public view returns (uint256); // in ECOM without decimals
63     function getCompanyCount() public view returns (uint256);
64     function getOffsaleCount() public view returns (uint256);
65     function increaseCompanyCountByOne() public;
66     function increaseOffsaleCountByOne() public;
67     function decreaseOffsaleCountByOne() public;
68 
69     function calculateNextPrice(uint256 oldPrice) public view returns (uint256);
70     function calculatePreviousPrice(uint256 newPrice) public view returns (uint256);
71 }
72 
73 contract RandomGeneratorInterface {
74     function rand(address sender) public returns (uint256);
75 }
76 
77 contract TopCompanyFactoryInterface is Ownable {
78     struct TopCompany {
79         bytes32 name;
80         uint256 performance;
81         bytes32 logoUrl;
82     }
83 
84     uint256 public startPrice; // First available value of a top company (In wei)
85     int256 public startBlock;
86     uint256 public initialAvailableCount;
87 
88     // Release a new company every 2 hours (given that a block is generated every 15 seconds)
89     uint256 public blocksBetweenNewCompany;
90 
91     uint256 public companyCount;
92     TopCompany[] public companies;
93     mapping(bytes32 => uint256) public companiesIndex;
94     function canBuyCompany(bytes32 nameLowercase) public view returns (bool);
95     function getCompanyByName(bytes32 nameLowercase) public view returns (bytes32 name, uint256 performance, bytes32 logoUrl);
96     function getCompany(uint256 index) public view returns (bytes32 name, uint256 performance, bytes32 logoUrl);
97     function removeCompany(bytes32 nameLowercase) public returns (uint256);
98 }
99 
100 contract ECOMTokenInterface is Ownable {
101     uint256 public totalSupply;
102     function balanceOf(address _owner) public view returns (uint256 balance);
103     function transfer(address _to, uint256 _value) public returns (bool success);
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
105     function approve(address _spender, uint256 _value) public returns (bool success);
106     function ownerApprove(address _sender, uint256 _value) public returns (bool success);
107     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
108 
109     event Transfer(address indexed _from, address indexed _to, uint256 _value);
110     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
111 }
112 
113 contract Ethecom is Ownable {
114     struct Company {
115         bytes32 name;
116         bytes32 logoUrl;
117         uint performance;
118         address owner;
119         uint price;
120         uint lastPrice;
121         bool isOnsale;
122     }
123 
124     event CompanyCreated(bytes32 name, bytes32 logoUrl,uint256 performance, uint256 price, address owner);
125     event CompanyTransferred(bytes32 name, uint256 newPrice, address oldOwner, address owner);
126     event CompanyLogoUpdated(bytes32 name, bytes32 logoUrl, address owner);
127     event CompanySaleStatusChanged(bytes32 name, bool saleStatus, uint256 lastPrice, address owner);
128     event SuperPrivilegeLuckyDrawResult(uint256 resultValue, bool status, address owner);
129 
130     ECOMTokenInterface public tokenContract;
131     TopCompanyFactoryInterface public factoryContract;
132     RandomGeneratorInterface public randContract;
133     CompanyCostInterface public costContract;
134     Utils private utils;
135     uint ECOMDecimal = 100000000;
136 
137     // Owner can update this value
138     uint256 public blocksPerDay = 5000;
139 
140     // Map company name to company object
141     mapping(bytes32 => Company) public companies;
142 
143     // Total performance of all companies owned by a user
144     mapping(address => uint256) public ownedPerformance;
145 
146     // The last time a user claim their ECOM token so that it will be transferred to their eth account
147     mapping(address => uint256) public lastTokenClaimedBlock;
148 
149     // Number of super privileges an account has 
150     mapping (address => uint256) public superPrivilegeCount;
151 
152     // Minimum random value required to get a super privilege
153     uint256 public minRandomPrivilegeValue = 90;
154     uint256 public superPrivilegeCost = 30; // in ECOM token
155 
156     uint256 public maxUserCreatedPerformance = 35;// Max performance of a user created company
157     uint256 public oldOwnerProfit = 80;
158     uint256 public logoFee = 10; // In ECOM
159     uint256 public minCompanyValue = 1000000000000000; // in wei
160     uint256 public maxCompanyValue = 100000000000000000000; // in wei
161 
162     constructor(address ECOMToken, address topCompanyFactory, address randomGenerator, address companyCost) public {
163         factoryContract = TopCompanyFactoryInterface(topCompanyFactory);
164         randContract = RandomGeneratorInterface(randomGenerator);
165         costContract = CompanyCostInterface(companyCost);
166         tokenContract = ECOMTokenInterface(ECOMToken);
167 
168         utils = new Utils();
169     }
170 
171     /**
172      *  For configurations
173      */
174 
175     function updateBlocksPerDay(uint256 value) public onlyOwner {
176         blocksPerDay = value;
177     }
178 
179     function updateSuperPrivilegeParams(uint256 minRandom, uint256 cost) public onlyOwner {
180         minRandomPrivilegeValue = minRandom;
181         superPrivilegeCost = cost;
182     }
183 
184     function updateUserCreatedPerformance(uint256 max) public onlyOwner {
185         maxUserCreatedPerformance = max;
186     }
187 
188     function updateLogoFee(uint256 newFee) public onlyOwner {
189         logoFee = newFee;
190     }
191 
192     function updateOldOwnerProfit(uint256 newProfit) public onlyOwner {
193         oldOwnerProfit = newProfit;
194     }
195 
196     function updateMinCompanyValue(uint256 minValue) public onlyOwner {
197         minCompanyValue = minValue;
198     }
199 
200     /**
201      * Core methods
202      * ------------------------------------------------------------------------------------------
203      */
204 
205     function purchaseCompany(bytes32 nameFromUser, bool superPrivilege) public payable {
206         bytes32 nameLowercase = utils.lowerCase(nameFromUser);
207         Company storage c = companies[nameLowercase];
208         require(c.owner != address(0));
209         require(c.owner != msg.sender);
210         require(c.price == msg.value);
211         require(c.isOnsale == true);
212         if (superPrivilege) {
213             require(superPrivilegeCount[msg.sender] > 0);
214         }
215 
216         address oldOwner = c.owner;
217         uint256 profit = c.price - c.lastPrice;
218         oldOwner.transfer(c.lastPrice + profit * 8/10);
219 
220         c.owner = msg.sender;
221         c.lastPrice = c.price;
222         c.price = costContract.calculateNextPrice(c.price);
223         
224         emit CompanyTransferred(c.name, c.price, oldOwner, msg.sender);
225 
226         claimToken(oldOwner);
227         ownedPerformance[oldOwner] -= c.performance;
228 
229         claimToken(msg.sender);
230         ownedPerformance[msg.sender] += c.performance;
231 
232         if (superPrivilege) {
233             c.isOnsale = false;
234             superPrivilegeCount[msg.sender]--;
235             emit CompanySaleStatusChanged(c.name, c.isOnsale, c.price, msg.sender);
236         }
237     }
238 
239     function purchaseTopCompany(bytes32 nameFromUser, bool superPrivilege) public payable {
240         // Check for sending enough eth
241         uint256 startPrice = factoryContract.startPrice();
242         require(msg.value == startPrice);
243 
244         bytes32 nameLowercase = utils.lowerCase(nameFromUser);
245         // uint256 index = factoryContract.companiesIndex(nameLowercase);
246 
247         // Check for company name availability
248         // require(index != 0);
249         require(companies[nameLowercase].owner == address(0));
250 
251         // Check if it is avaialble for purchase
252         require(factoryContract.canBuyCompany(nameLowercase));
253         if (superPrivilege) {
254             require(superPrivilegeCount[msg.sender] > 0);
255         }
256 
257         bytes32 name;
258         uint256 performance;
259         bytes32 logoUrl;
260         (name, performance, logoUrl) = factoryContract.getCompanyByName(nameLowercase);
261         uint256 price = costContract.calculateNextPrice(startPrice);
262         Company memory c = Company(name, logoUrl, performance, msg.sender, price, startPrice, !superPrivilege);
263         companies[nameLowercase] = c;
264 
265         claimToken(msg.sender);
266         ownedPerformance[msg.sender] += performance;
267 
268         factoryContract.removeCompany(nameLowercase);
269         //emit CompanyCreated(name, logoUrl, performance, price, msg.sender);
270         emit CompanyTransferred(name, price, address(0), msg.sender);
271 
272         if (superPrivilege) {
273             superPrivilegeCount[msg.sender]--;
274             emit CompanySaleStatusChanged(c.name, c.isOnsale, c.price, msg.sender);
275         }
276     }
277 
278     // Anyone with enough ECOM token can create a company
279     // Companies are unique by name
280     // User can set the inital value for their company (without knowing it performance)
281     // Newly created company will be put on sale immediately
282     function createCompany(bytes32 name, bytes32 logoUrl, uint256 value) public {
283         require(value >= minCompanyValue);
284         require(value <= maxCompanyValue);
285         require(utils.validateCompanyName(name) == true);
286 
287         bytes32 nameLowercase = utils.lowerCase(name);
288 
289         // If company doesn't exists, owner address will be address 0
290         require(factoryContract.companiesIndex(nameLowercase) == 0);
291         require(companies[nameLowercase].owner == address(0));
292 
293         uint256 cost = costContract.getCreationCost() * ECOMDecimal;
294         claimToken(msg.sender);
295         transferECOMTokenToContract(cost);
296 
297         uint256 performance = generateRandomPerformance();
298         Company memory c = Company(name, logoUrl, performance, msg.sender, value, costContract.calculatePreviousPrice(value), true);
299         companies[nameLowercase] = c;
300 
301         ownedPerformance[msg.sender] += performance;
302 
303         costContract.increaseCompanyCountByOne();
304         emit CompanyCreated(name, logoUrl, performance, value, msg.sender);
305     }
306 
307     // Use 1 super privilege to permanently own a company
308     function permanentlyOwnMyCompany(bytes32 nameFromUser) public {
309         bytes32 nameLowercase = utils.lowerCase(nameFromUser);
310         Company storage c = companies[nameLowercase];
311         require(superPrivilegeCount[msg.sender] > 0);
312         require(c.owner != address(0));
313         require(c.owner == msg.sender);
314         require(c.isOnsale == true);
315         
316         c.isOnsale = false;
317         superPrivilegeCount[msg.sender]--;
318 
319         emit CompanySaleStatusChanged(c.name, false, c.price, msg.sender);
320     }
321 
322     // Put a permanently owned company on sale again
323     function putCompanyOnsale(bytes32 nameFromUser, uint256 startPrice) public {
324         require(startPrice >= minCompanyValue);
325         require(startPrice <= maxCompanyValue);
326         bytes32 nameLowercase = utils.lowerCase(nameFromUser);
327         Company storage c = companies[nameLowercase];
328         require(c.owner != address(0));
329         require(c.owner == msg.sender);
330         require(c.isOnsale == false);
331 
332         c.price = startPrice;
333         c.lastPrice = costContract.calculatePreviousPrice(c.price);
334         c.isOnsale = true;
335 
336         emit CompanySaleStatusChanged(c.name, c.isOnsale, c.price, msg.sender);
337     }
338 
339     // Anyone can call to this method to try to get a super privileged
340     function runSuperPrivilegeLuckyDraw() public {
341         claimToken(msg.sender);
342         transferECOMTokenToContract(superPrivilegeCost*ECOMDecimal);
343         uint256 rand = randContract.rand(msg.sender);
344         rand = rand % 100;
345         bool status = false;
346         if (rand >= minRandomPrivilegeValue) {
347             superPrivilegeCount[msg.sender] = superPrivilegeCount[msg.sender] + 1;
348             status = true;
349         }
350 
351         emit SuperPrivilegeLuckyDrawResult(rand, status, msg.sender);
352     }
353 
354     // Anyone who owned some companies can claim their token
355     function claimMyToken() public {
356         require(ownedPerformance[msg.sender] > 0);
357 
358         claimToken(msg.sender);
359     }
360 
361     function updateLogoUrl(bytes32 companyName, bytes32 logoUrl) public {
362         bytes32 nameLowercase = utils.lowerCase(companyName);
363         Company storage c = companies[nameLowercase];
364         require(c.owner == msg.sender);
365         claimToken(msg.sender);
366         transferECOMTokenToContract(logoFee * ECOMDecimal);
367         c.logoUrl = logoUrl;
368         emit CompanyLogoUpdated(c.name, c.logoUrl, msg.sender);
369     }
370 
371     /**
372      * End core methods
373      * ------------------------------------------------------------------------------------------
374      */
375 
376      /**
377      *  For migration
378      */
379 
380     function updateTokenContract(address addr) public onlyOwner {
381         tokenContract = ECOMTokenInterface(addr);
382     }
383 
384     function updateRandContract(address addr) public onlyOwner {
385         randContract = RandomGeneratorInterface(addr);
386     }
387 
388     function updateCostContract(address addr) public onlyOwner {
389         costContract = CompanyCostInterface(addr);
390     }
391 
392     function updateFactoryContract(address addr) public onlyOwner {
393         factoryContract = TopCompanyFactoryInterface(addr);
394     }
395 
396     function transferSubcontractsOwnership(address addr) public onlyOwner {
397         tokenContract.transferOwnership(addr);
398         costContract.transferOwnership(addr);
399         factoryContract.transferOwnership(addr);
400 
401         // Random generator contract doesn't need to be transferred
402     }
403 
404     /**
405      * For owner
406      */
407     function withdraw(uint256 amount) public onlyOwner {
408         if (amount == 0) {
409             owner.transfer(address(this).balance);
410         } else {
411             owner.transfer(amount);
412         }
413     }
414 
415     /**
416      * View methods
417      */
418 
419     function getTopCompanyStartPrice() public view returns (uint256) {
420         return factoryContract.startPrice();
421     }
422 
423     function getTopCompanyStartBlock() public view returns (int256) {
424         return factoryContract.startBlock();
425     }
426 
427     function getTopCompanyBlocksInBetween() public view returns (uint256) {
428         return factoryContract.blocksBetweenNewCompany();
429     }
430 
431     function getTopCompanyCount() public view returns (uint256) {
432         return factoryContract.companyCount();
433     }
434 
435     function getTopCompanyAtIndex(uint256 index) public view returns (bytes32 name, uint256 performance, bytes32 logoUrl) {
436         return factoryContract.getCompany(index);
437     }
438 
439     function getCompanyCreationCost() public view returns (uint256) {
440         return costContract.getCreationCost();
441     }
442 
443     function checkCompanyNameAvailability(bytes32 name) public view returns (uint256) {
444         uint256 result = 1;
445         bytes32 nameLowercase = utils.lowerCase(name);
446         if (utils.validateCompanyName(name) != true) {
447             result = 0;
448         } else if (factoryContract.companiesIndex(nameLowercase) != 0) {
449             result = 0;
450         } else if (companies[nameLowercase].owner != address(0)) {
451             result = 0;
452         }
453         return result;
454     }
455 
456     // Private methods
457     function transferECOMTokenToContract(uint256 amount) private {
458         require(tokenContract.balanceOf(msg.sender) >= amount);
459         tokenContract.ownerApprove(msg.sender, amount);
460         tokenContract.transferFrom(msg.sender, address(this), amount);
461     }
462 
463     function generateRandomPerformance() private returns (uint256) {
464         uint256 rand = randContract.rand(msg.sender);
465         rand = rand % (maxUserCreatedPerformance * maxUserCreatedPerformance);
466         rand = utils.sqrt(rand);
467         return maxUserCreatedPerformance - rand;
468     }
469 
470     function claimToken(address receiver) private {
471         uint256 numBlock = block.number - lastTokenClaimedBlock[receiver];
472         uint256 profitPerBlock = ownedPerformance[receiver] * ECOMDecimal / blocksPerDay;
473         uint256 profit = numBlock * profitPerBlock;
474         if (profit > 0) {
475             tokenContract.transfer(receiver, profit);
476         }
477         lastTokenClaimedBlock[receiver] = block.number;
478     }
479 }