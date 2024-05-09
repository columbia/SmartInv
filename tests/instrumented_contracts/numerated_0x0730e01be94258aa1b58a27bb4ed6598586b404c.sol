1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7         return 0;
8     }
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     require(b > 0);
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     require(b <= a);
22     uint256 c = a - b;
23     return c;
24   }
25 
26   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
27     require(b != 0);
28     return a % b;
29   }
30 }
31 
32 library BnsLib {
33   struct TopLevelDomain {
34     uint price;
35     uint lastUpdate;
36     bool min;
37     bool exists;
38   }
39 
40   struct Domain {
41     address owner;
42     bool allowSubdomains;
43     bytes content;
44     mapping(string => string) domainStorage;
45     mapping(address => bool) approvedForSubdomain;
46   }
47 
48   function hasOnlyDomainLevelCharacters(string memory str) internal pure returns (bool) {
49     /* [9-0] [A-Z] [a-z] [-] */
50     bytes memory b = bytes(str);
51     for(uint i; i<b.length; i++) {
52       bytes1 char = b[i];
53       if (! (
54         (char >= 0x30 && char <= 0x39) ||
55         (char >= 0x41 && char <= 0x5A) ||
56         (char >= 0x61 && char <= 0x7A) ||
57         (char == 0x2d)
58       )) return false;
59     }
60     return true;
61   }
62 
63   function strictJoin(string memory self, string memory s2, bytes1 delimiter) 
64   internal pure returns (string memory) {
65     /* Allow [0-9] [a-z] [-] Make [A-Z] lowercase */
66     bytes memory orig = bytes(self);
67     bytes memory addStr = bytes(s2);
68     uint retSize = orig.length + addStr.length + 1;
69     bytes memory ret = new bytes(retSize);
70     for (uint i = 0; i < orig.length; i ++) {
71       require(
72         (orig[i] >= 0x30 && orig[i] <= 0x39) || // 0-9
73         (orig[i] >= 0x41 && orig[i] <= 0x5A) || // A-Z
74         (orig[i] >= 0x61 && orig[i] <= 0x7A) || // a-z
75         (orig[i] == 0x2d || orig[i] == 0x5f), // -  _
76         "Invalid character."
77       );
78       if (orig[i] >= 0x41 && orig[i] <= 0x5A) ret[i] = bytes1(uint8(orig[i]) + 32);
79       else ret[i] = orig[i];
80     }
81     ret[orig.length] = delimiter;
82     for (uint x = 0; x < addStr.length; x ++) {
83       if (addStr[x] >= 0x41 && addStr[x] <= 0x5A)
84         ret[orig.length + x + 1] = bytes1(uint8(addStr[x]) + 32);
85       else ret[orig.length + x + 1] = addStr[x];
86     }
87     return string(ret);
88   }
89 }
90 
91 contract BetterNameService {
92   using BnsLib for *;
93   using SafeMath for uint;  
94 
95 
96   constructor() public {
97     createTopLevelDomain("bns");
98     creat0r = msg.sender;
99   }
100 
101   
102   address creat0r;  
103   uint updateAfter = 15000; // target around 1 update per day
104   uint minPrice = 10000000000000000; // 0.01 eth
105 
106   mapping(string => BnsLib.TopLevelDomain) internal tldPrices;
107   mapping(string => BnsLib.Domain) domains; // domain and subdomain owners
108 
109 
110   function withdraw(uint amount) public {
111     require(msg.sender == creat0r, "Only the creat0r can call that.");
112     msg.sender.transfer(amount);
113   }
114 
115   function balanceOf() public view returns (uint) {
116     return address(this).balance;
117   }
118 
119 
120 
121 /*----------------<BEGIN MODIFIERS>----------------*/
122   modifier tldExists(string memory tld) {
123     require(tldPrices[tld].exists, "TLD does not exist");
124     _;
125   }
126 
127   modifier tldNotExists(string memory tld) {
128     require(!tldPrices[tld].exists, "TLD exists");
129     _;
130   }
131 
132   modifier domainExists(string memory domain) {
133     require(
134       domains[domain].owner != address(0) &&
135       domains[domain].owner != address(0x01), 
136       "Domain does not exist or has been invalidated.");
137     _;
138   }
139 
140   modifier domainNotExists(string memory domain) {
141     require(domains[domain].owner == address(0), "Domain exists");
142     _;
143   }
144 
145   modifier onlyDomainOwner(string memory domain) {
146     require(msg.sender == domains[domain].owner, "Not owner of domain");
147     _;
148   }
149 
150   modifier onlyAllowed(string memory domain) {
151     require(
152       domains[domain].allowSubdomains ||
153       domains[domain].owner == msg.sender ||
154       domains[domain].approvedForSubdomain[msg.sender],
155       "Not allowed to register subdomain."
156     );
157     _;
158   }
159 
160   modifier onlyDomainLevelCharacters(string memory domainLevel) {
161     require(BnsLib.hasOnlyDomainLevelCharacters(domainLevel), "Invalid characters");
162     _;
163   }
164 /*----------------</END MODIFIERS>----------------*/
165 
166 
167 
168 /*----------------<BEGIN EVENTS>----------------*/
169   event TopLevelDomainCreated(bytes32 indexed tldHash, string tld);
170   event TopLevelDomainPriceUpdated(bytes32 indexed tldHash, string tld, uint price);
171 
172   event DomainRegistered(bytes32 indexed domainHash, 
173   string domain, address owner, 
174   address registeredBy, bool open);
175 
176   event SubdomainInvalidated(bytes32 indexed subdomainHash, 
177   string subdomain, address invalidatedBy);
178 
179   event DomainRegistrationOpened(bytes32 indexed domainHash, string domain);
180   event DomainRegistrationClosed(bytes32 indexed domainHash, string domain);
181 
182   event ApprovedForDomain(bytes32 indexed domainHash, string domain, address indexed approved);
183   event DisapprovedForDomain(bytes32 indexed domainHash, 
184   string domain, address indexed disapproved);
185 
186   event ContentUpdated(bytes32 indexed domainHash, string domain, bytes content);
187 /*----------------</END EVENTS>----------------*/
188 
189 
190 
191 /*----------------<BEGIN VIEW FUNCTIONS>----------------*/
192   function getTldPrice(string tld) public view returns (uint) {
193     return tldPrices[tld].min ? minPrice : tldPrices[tld].price;
194   }
195 
196   function expectedTldPrice(string tld) public view returns (uint) {
197     if (tldPrices[tld].min) return minPrice;
198     uint blockCount = block.number.sub(tldPrices[tld].lastUpdate);
199     if (blockCount >= updateAfter) {
200       uint updatesDue = blockCount.div(updateAfter);
201       uint newPrice = tldPrices[tld].price.mul(750**updatesDue).div(1000**updatesDue);
202       if (newPrice <= minPrice) return minPrice;
203       return newPrice;
204     }
205     return tldPrices[tld].price;
206   }
207 
208   function getDomainOwner(string domain) public view returns (address) {
209     return domains[domain].owner;
210   }
211 
212   function isPublicDomainRegistrationOpen(string memory domain) public view returns (bool) {
213     return domains[domain].allowSubdomains;
214   }
215   
216   function isApprovedToRegister(string memory domain, address addr) 
217   public view returns (bool) {
218     return domains[domain].allowSubdomains || 
219       domains[domain].owner == addr || 
220       domains[domain].approvedForSubdomain[addr];
221   }
222 
223   function isDomainInvalidated(string memory domain) public view returns(bool) {
224     return domains[domain].owner == address(0x01);
225   }
226 
227   function getContent(string memory domain) public view returns (bytes) {
228     return domains[domain].content;
229   }
230 
231 
232   /*<BEGIN STORAGE FUNCTIONS>*/
233   function getDomainStorageSingle(string domain, string key) 
234   public view domainExists(domain) returns (string) {
235     return domains[domain].domainStorage[key];
236   }
237 
238   function getDomainStorageMany(string domain, string[] memory keys) 
239   public view domainExists(domain) returns (string[2][]) {
240     string[2][] memory results = new string[2][](keys.length);
241     for(uint i = 0; i < keys.length; i++) {
242       string memory key = keys[i];
243       results[i] = [key, domains[domain].domainStorage[key]];
244     }
245     return results;
246   }
247   /*</END STORAGE FUNCTIONS>*/
248 /*----------------</END VIEW FUNCTIONS>----------------*/
249 
250 
251 
252 /*----------------<BEGIN PRICE FUNCTIONS>----------------*/
253   function returnRemainder(uint price) internal {
254     if (msg.value > price) msg.sender.transfer(msg.value.sub(price));
255   }
256 
257   function updateTldPrice(string memory tld) public returns (uint) {
258     if (!tldPrices[tld].min) {
259       // tld price has not reached the minimum price
260       uint price = expectedTldPrice(tld);
261       if (price != tldPrices[tld].price) {
262         if (price == minPrice) {
263           tldPrices[tld].min = true;
264           tldPrices[tld].price = 0;
265           tldPrices[tld].lastUpdate = 0;
266         } else {
267           tldPrices[tld].price = price;
268           tldPrices[tld].lastUpdate = block.number.sub((block.number.sub(tldPrices[tld].lastUpdate)).mod(updateAfter));
269         }
270         emit TopLevelDomainPriceUpdated(keccak256(abi.encode(tld)), tld, price);
271       }
272       return price;
273     }
274     else return minPrice;
275   }
276 /*----------------</END PRICE FUNCTIONS>----------------*/
277 
278 
279 
280 /*----------------<BEGIN DOMAIN REGISTRATION FUNCTIONS>----------------*/
281   /*<BEGIN TLD FUNCTIONS>*/
282   function createTopLevelDomain(string memory tld) 
283   public tldNotExists(tld) onlyDomainLevelCharacters(tld) {
284     tldPrices[tld] = BnsLib.TopLevelDomain({
285       price: 5000000000000000000,
286       lastUpdate: block.number,
287       exists: true,
288       min: false
289     });
290     emit TopLevelDomainCreated(keccak256(abi.encode(tld)), tld);
291   }
292   /*</END TLD FUNCTIONS>*/
293 
294 
295   /*<BEGIN INTERNAL REGISTRATION FUNCTIONS>*/
296   function _register(string memory domain, address owner, bool open) 
297   internal domainNotExists(domain) {
298     domains[domain].owner = owner;
299     emit DomainRegistered(keccak256(abi.encode(domain)), domain, owner, msg.sender, open);
300     if (open) domains[domain].allowSubdomains = true;
301   }
302 
303   function _registerDomain(string memory domain, string memory tld, bool open) 
304   internal tldExists(tld) {
305     uint price = updateTldPrice(tld);
306     require(msg.value >= price, "Insufficient price.");
307     _register(domain.strictJoin(tld, 0x40), msg.sender, open);
308     returnRemainder(price);
309   }
310 
311   function _registerSubdomain(
312     string memory subdomain, string memory domain, address owner, bool open) 
313   internal onlyAllowed(domain) {
314     _register(subdomain.strictJoin(domain, 0x2e), owner, open);
315   }
316   /*</END INTERNAL REGISTRATION FUNCTIONS>*/
317 
318 
319   /*<BEGIN REGISTRATION OVERLOADS>*/
320   function registerDomain(string memory domain, bool open) public payable {
321     _registerDomain(domain, "bns", open);
322   }
323 
324   function registerDomain(string memory domain, string memory tld, bool open) public payable {
325     _registerDomain(domain, tld, open);
326   }
327   /*</END REGISTRATION OVERLOADS>*/
328 
329 
330   /*<BEGIN SUBDOMAIN REGISTRATION OVERLOADS>*/
331   function registerSubdomain(string memory subdomain, string memory domain, bool open) public {
332     _registerSubdomain(subdomain, domain, msg.sender, open);
333   }
334 
335   function registerSubdomainAsDomainOwner(
336     string memory subdomain, string memory domain, address subdomainOwner) 
337   public onlyDomainOwner(domain) {
338     _registerSubdomain(subdomain, domain, subdomainOwner, false);
339   }
340   /*</END SUBDOMAIN REGISTRATION OVERLOADS>*/
341 /*----------------</END DOMAIN REGISTRATION FUNCTIONS>----------------*/
342 
343 
344 
345 /*----------------<BEGIN DOMAIN MANAGEMENT FUNCTIONS>----------------*/
346   function transferDomain(string domain, address recipient) public onlyDomainOwner(domain) {
347     domains[domain].owner = recipient;
348   }
349 
350   /*<BEGIN CONTENT HASH FUNCTIONS>*/
351   function setContent(string memory domain, bytes memory content) 
352   public onlyDomainOwner(domain) {
353     domains[domain].content = content;
354     emit ContentUpdated(keccak256(abi.encode(domain)), domain, content);
355   }
356 
357   function deleteContent(string memory domain) public onlyDomainOwner(domain) {
358     delete domains[domain].content;
359     emit ContentUpdated(keccak256(abi.encode(domain)), domain, domains[domain].content);
360   }
361   /*</END CONTENT HASH FUNCTIONS>*/
362 
363 
364   /*<BEGIN APPROVAL FUNCTIONS>*/
365   function approveForSubdomain(string memory domain, address user) public onlyDomainOwner(domain) {
366     domains[domain].approvedForSubdomain[user] = true;
367     emit ApprovedForDomain(keccak256(abi.encode(domain)), domain, user);
368   }
369 
370   function disapproveForSubdomain(string memory domain, address user) 
371   public onlyDomainOwner(domain) {
372     domains[domain].approvedForSubdomain[user] = false;
373     emit DisapprovedForDomain(keccak256(abi.encode(domain)), domain, user);
374   }
375   /*</END APPROVAL FUNCTIONS>*/
376 
377 
378   /*<BEGIN INVALIDATION FUNCTIONS>*/
379   function _invalidateDomain(string memory domain) internal {
380     domains[domain].owner = address(0x01);
381     emit SubdomainInvalidated(keccak256(abi.encode(domain)), domain, msg.sender);
382   }
383 
384   function invalidateDomain(string memory domain) public onlyDomainOwner(domain) {
385     _invalidateDomain(domain);
386   }
387 
388   function invalidateSubdomainAsDomainOwner(string memory subdomain, string memory domain) 
389   public onlyDomainOwner(domain) {
390     _invalidateDomain(subdomain.strictJoin(domain, "."));
391   }
392   /*</END INVALIDATION FUNCTIONS>*/
393 
394 
395   /*<BEGIN RESTRICTION FUNCTIONS>*/
396   function openPublicDomainRegistration(string domain) public onlyDomainOwner(domain) {
397     domains[domain].allowSubdomains = true;
398     emit DomainRegistrationOpened(keccak256(abi.encode(domain)), domain);
399   }
400 
401   function closePublicDomainRegistration(string domain) public onlyDomainOwner(domain) {
402     domains[domain].allowSubdomains = false;
403     emit DomainRegistrationClosed(keccak256(abi.encode(domain)), domain);
404   }
405   /*</END RESTRICTION FUNCTIONS>*/
406 
407 
408   /*<BEGIN STORAGE FUNCTIONS>*/
409   function setDomainStorageSingle(string memory domain, string memory key, string memory value) 
410   public onlyDomainOwner(domain) {
411     domains[domain].domainStorage[key] = value;
412   }
413 
414   function setDomainStorageMany(string memory domain, string[2][] memory kvPairs) 
415   public onlyDomainOwner(domain) {
416     for(uint i = 0; i < kvPairs.length; i++) {
417       domains[domain].domainStorage[kvPairs[i][0]] = kvPairs[i][1];
418     }
419   }
420   /*</END STORAGE FUNCTIONS>*/
421 /*----------------</END DOMAIN MANAGEMENT FUNCTIONS>----------------*/
422 }