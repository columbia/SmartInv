1 pragma solidity ^0.4.18;
2 
3 /*
4     Manages ownership and permissions for the whole contract.
5 */
6 
7 contract BLAccess {
8 
9     address public mainAddress; //Main Contract Address
10     event UpdatedMainAccount(address _newMainAddress);
11 
12     function BLAccess() public {
13         mainAddress = msg.sender;
14     }
15 
16     modifier onlyPrimary() {
17         require(msg.sender == mainAddress);
18         _;
19     }
20 
21     //Allows to change the primary account for the contract
22     function setPrimaryAccount(address _newMainAddress) external onlyPrimary {
23         require(_newMainAddress != address(0));
24         mainAddress = _newMainAddress;
25         UpdatedMainAccount(_newMainAddress);
26     }
27 
28 }
29 
30 /*
31  Interface for our separate eternal storage.
32 */
33 
34 contract DataStorageInterface {
35     function getUInt(bytes32 record) public constant returns (uint);
36     function setUInt(bytes32 record, uint value) public;
37     function getAdd(bytes32 record) public constant returns (address);
38     function setAdd(bytes32 record, address value) public;
39     function getBytes32(bytes32 record) public constant returns (bytes32);
40     function setBytes32(bytes32 record, bytes32 value) public;
41     function getBool(bytes32 record) public constant returns (bool);
42     function setBool(bytes32 record, bool value) public;
43     function withdraw(address beneficiary) public;
44 }
45 
46 /*
47  Wrapper around Data Storage interface
48 */
49 
50 contract BLStorage is BLAccess {
51 
52     DataStorageInterface internal s;
53     address public storageAddress;
54 
55     event StorageUpdated(address _newStorageAddress);
56 
57     function BLStorage() public {
58         s = DataStorageInterface(mainAddress);
59     }
60 
61     // allows to setup a new Storage address. Should never be needed but you never know!
62     function setDataStorage(address newAddress) public onlyPrimary {
63         s = DataStorageInterface(newAddress);
64         storageAddress = newAddress;
65         StorageUpdated(newAddress);
66     }
67 
68     function getKey(uint x, uint y) internal pure returns(bytes32 key) {
69         key = keccak256(x, ":", y);
70     }
71 }
72 
73 
74 contract BLBalances is BLStorage {
75 
76     event WithdrawBalance(address indexed owner, uint amount);
77     event AllowanceGranted(address indexed owner, uint _amount);
78     event SentFeeToPlatform(uint amount);
79     event SentAmountToOwner(uint amount, address indexed owner);
80 
81     // get the balance for a given account
82     function getBalance() public view returns (uint) {
83         return s.getUInt(keccak256(msg.sender, "balance"));
84     }
85 
86     // get the balance for a given account
87     function getAccountBalance(address _account) public view onlyPrimary returns (uint) {
88         return s.getUInt(keccak256(_account, "balance"));
89     }
90 
91     function getAccountAllowance(address _account) public view onlyPrimary returns (uint) {
92         return s.getUInt(keccak256(_account, "promoAllowance"));
93     }
94 
95     function getMyAllowance() public view returns (uint) {
96         return s.getUInt(keccak256(msg.sender, "promoAllowance"));
97     }
98 
99     // allow a block allowance for promo and early beta users
100     function grantAllowance(address beneficiary, uint allowance) public onlyPrimary {
101         uint existingAllowance = s.getUInt(keccak256(beneficiary, "promoAllowance"));
102         existingAllowance += allowance;
103         s.setUInt(keccak256(beneficiary, "promoAllowance"), existingAllowance);
104         AllowanceGranted(beneficiary, allowance);
105     }
106 
107     // withdraw the current balance
108     function withdraw() public {
109         uint balance = s.getUInt(keccak256(msg.sender, "balance"));
110         s.withdraw(msg.sender);
111         WithdrawBalance(msg.sender, balance);
112     }
113 
114     // Trading and buying balances flow
115     function rewardParties (address owner, uint feePercentage) internal {
116         uint fee = msg.value * feePercentage / 100;
117         rewardContract(fee);
118         rewardPreviousOwner(owner, msg.value - fee);
119     }
120 
121     // contract commissions
122     function rewardContract (uint fee) internal {
123         uint mainBalance = s.getUInt(keccak256(mainAddress, "balance"));
124         mainBalance += fee;
125         s.setUInt(keccak256(mainAddress, "balance"), mainBalance);
126         SentFeeToPlatform(fee);
127     }
128 
129     // reward the previous owner of the block or the contract if the block is bought for the first time
130     function rewardPreviousOwner (address owner, uint amount) internal {
131         uint rewardBalance;
132         if (owner == address(0)) {
133             rewardBalance = s.getUInt(keccak256(mainAddress, "balance"));
134             rewardBalance += amount;
135             s.setUInt(keccak256(mainAddress, "balance"), rewardBalance);
136             SentAmountToOwner(amount, mainAddress);
137         } else {
138             rewardBalance = s.getUInt(keccak256(owner, "balance"));
139             rewardBalance += amount;
140             s.setUInt(keccak256(owner, "balance"), rewardBalance);
141             SentAmountToOwner(amount, owner);
142         }
143     }
144 }
145 
146 contract BLBlocks is BLBalances {
147 
148     event CreatedBlock(
149         uint x,
150         uint y,
151         uint price,
152         address indexed owner,
153         bytes32 name,
154         bytes32 description,
155         bytes32 url,
156         bytes32 imageURL);
157 
158     event SetBlockForSale(
159         uint x,
160         uint y,
161         uint price,
162         address indexed owner);
163 
164     event UnsetBlockForSale(
165         uint x,
166         uint y,
167         address indexed owner);
168 
169     event BoughtBlock(
170         uint x,
171         uint y,
172         uint price,
173         address indexed owner,
174         bytes32 name,
175         bytes32 description,
176         bytes32 url,
177         bytes32 imageURL);
178 
179     event SoldBlock(
180         uint x,
181         uint y,
182         uint oldPrice,
183         uint newPrice,
184         uint feePercentage,
185         address indexed owner);
186 
187     event UpdatedBlock(uint x,
188         uint y,
189         bytes32 name,
190         bytes32 description,
191         bytes32 url,
192         bytes32 imageURL,
193         address indexed owner);
194 
195     // Create a block if it doesn't exist
196     function createBlock(
197         uint x,
198         uint y,
199         bytes32 name,
200         bytes32 description,
201         bytes32 url,
202         bytes32 imageURL
203     ) public payable {
204         bytes32 key = getKey(x, y);
205         uint initialPrice = s.getUInt("initialPrice");
206         address owner = s.getAdd(keccak256(key, "owner"));
207         uint allowance = s.getUInt(keccak256(msg.sender, "promoAllowance"));
208         require(msg.value >= initialPrice || allowance > 0);
209         require(owner == address(0));
210         uint feePercentage = s.getUInt("buyOutFeePercentage");
211         if (msg.value >= initialPrice) {
212             rewardParties(owner, feePercentage);
213             s.setUInt(keccak256(key, "price"), msg.value);
214         } else {
215             allowance--;
216             s.setUInt(keccak256(msg.sender, "promoAllowance"), allowance);
217             s.setUInt(keccak256(key, "price"), initialPrice);
218         }
219         s.setBytes32(keccak256(key, "name"), name);
220         s.setBytes32(keccak256(key, "description"), description);
221         s.setBytes32(keccak256(key, "url"), url);
222         s.setBytes32(keccak256(key, "imageURL"), imageURL);
223         s.setAdd(keccak256(key, "owner"), msg.sender);
224         uint blockCount = s.getUInt("blockCount");
225         blockCount++;
226         s.setUInt("blockCount", blockCount);
227         storageAddress.transfer(msg.value);
228         CreatedBlock(x,
229             y,
230             msg.value,
231             msg.sender,
232             name,
233             description,
234             url,
235             imageURL);
236     }
237 
238     // Get details for a block
239     function getBlock (uint x, uint y) public view returns (
240         uint price,
241         bytes32 name,
242         bytes32 description,
243         bytes32 url,
244         bytes32 imageURL,
245         uint forSale,
246         uint pricePerDay,
247         address owner
248     ) {
249         bytes32 key = getKey(x, y);
250         price = s.getUInt(keccak256(key, "price"));
251         name = s.getBytes32(keccak256(key, "name"));
252         description = s.getBytes32(keccak256(key, "description"));
253         url = s.getBytes32(keccak256(key, "url"));
254         imageURL = s.getBytes32(keccak256(key, "imageURL"));
255         forSale = s.getUInt(keccak256(key, "forSale"));
256         pricePerDay = s.getUInt(keccak256(key, "pricePerDay"));
257         owner = s.getAdd(keccak256(key, "owner"));
258     }
259 
260     // Sets a block up for sale
261     function sellBlock(uint x, uint y, uint price) public {
262         bytes32 key = getKey(x, y);
263         uint basePrice = s.getUInt(keccak256(key, "price"));
264         require(s.getAdd(keccak256(key, "owner")) == msg.sender);
265         require(price < basePrice * 2);
266         s.setUInt(keccak256(key, "forSale"), price);
267         SetBlockForSale(x, y, price, msg.sender);
268     }
269 
270     // Sets a block not for sale
271     function cancelSellBlock(uint x, uint y) public {
272         bytes32 key = getKey(x, y);
273         require(s.getAdd(keccak256(key, "owner")) == msg.sender);
274         s.setUInt(keccak256(key, "forSale"), 0);
275         UnsetBlockForSale(x, y, msg.sender);
276     }
277 
278     // transfers ownership of an existing block
279     function buyBlock(
280         uint x,
281         uint y,
282         bytes32 name,
283         bytes32 description,
284         bytes32 url,
285         bytes32 imageURL
286     ) public payable {
287         bytes32 key = getKey(x, y);
288         uint price = s.getUInt(keccak256(key, "price"));
289         uint forSale = s.getUInt(keccak256(key, "forSale"));
290         address owner = s.getAdd(keccak256(key, "owner"));
291         require(owner != address(0));
292         require((forSale > 0 && msg.value >= forSale) || msg.value >= price * 2);
293         uint feePercentage = s.getUInt("buyOutFeePercentage");
294         rewardParties(owner, feePercentage);
295         s.setUInt(keccak256(key, "price"), msg.value);
296         s.setBytes32(keccak256(key, "name"), name);
297         s.setBytes32(keccak256(key, "description"), description);
298         s.setBytes32(keccak256(key, "url"), url);
299         s.setBytes32(keccak256(key, "imageURL"), imageURL);
300         s.setAdd(keccak256(key, "owner"), msg.sender);
301         s.setUInt(keccak256(key, "forSale"), 0);
302         s.setUInt(keccak256(key, "pricePerDay"), 0);
303         storageAddress.transfer(msg.value);
304         BoughtBlock(x, y, msg.value, msg.sender,
305             name, description, url, imageURL);
306         SoldBlock(x, y, price, msg.value, feePercentage, owner);
307     }
308 
309     // update details for an existing block
310     function updateBlock(
311         uint x,
312         uint y,
313         bytes32 name,
314         bytes32 description,
315         bytes32 url,
316         bytes32 imageURL
317     )  public {
318         bytes32 key = getKey(x, y);
319         address owner = s.getAdd(keccak256(key, "owner"));
320         require(msg.sender == owner);
321         s.setBytes32(keccak256(key, "name"), name);
322         s.setBytes32(keccak256(key, "description"), description);
323         s.setBytes32(keccak256(key, "url"), url);
324         s.setBytes32(keccak256(key, "imageURL"), imageURL);
325         UpdatedBlock(x, y, name, description, url, imageURL, msg.sender);
326     }
327 
328 }
329 
330 contract BLTenancies is BLBlocks {
331 
332     event ToRent(
333         uint x,
334         uint y,
335         uint pricePerDay,
336         address indexed owner);
337 
338     event NotToRent(
339         uint x,
340         uint y,
341         address indexed owner);
342 
343     event LeasedBlock(
344         uint x,
345         uint y,
346         uint paid,
347         uint expiry,
348         bytes32 tenantName,
349         bytes32 tenantDescription,
350         bytes32 teantURL,
351         bytes32 tenantImageURL,
352         address indexed owner);
353 
354     event RentedBlock(
355         uint x,
356         uint y,
357         uint paid,
358         uint feePercentage,
359         address indexed owner);
360 
361     // Sets a block up for rent, requires a rental price to be provided
362     function setForRent(
363         uint x,
364         uint y,
365         uint pricePerDay
366     ) public {
367         bytes32 key = getKey(x, y);
368         uint price = s.getUInt(keccak256(key, "price"));
369         require(s.getAdd(keccak256(key, "owner")) == msg.sender);
370         require(pricePerDay >= price / 10);
371         s.setUInt(keccak256(key, "pricePerDay"), pricePerDay);
372         ToRent(x, y, pricePerDay, msg.sender);
373     }
374 
375     // Sets a block not for rent
376     function cancelRent(
377         uint x,
378         uint y
379     ) public {
380         bytes32 key = getKey(x, y);
381         address owner = s.getAdd(keccak256(key, "owner"));
382         require(owner == msg.sender);
383         s.setUInt(keccak256(key, "pricePerDay"), 0);
384         NotToRent(x, y, msg.sender);
385     }
386 
387     // actually rent a block to a willing tenant
388     function leaseBlock(
389         uint x,
390         uint y,
391         uint duration,
392         bytes32 tenantName,
393         bytes32 tenantDescription,
394         bytes32 tenantURL,
395         bytes32 tenantImageURL
396     ) public payable {
397         bytes32 key = getKey(x, y);
398         uint pricePerDay = s.getUInt(keccak256(key, "pricePerDay"));
399         require(pricePerDay > 0);
400         require(msg.value >= pricePerDay * duration);
401         require(now >= s.getUInt(keccak256(key, "expiry")));
402         address owner = s.getAdd(keccak256(key, "owner"));
403         uint feePercentage = s.getUInt("buyOutFeePercentage");
404         rewardParties(owner, feePercentage);
405         uint expiry = now + 86400 * duration;
406         s.setUInt(keccak256(key, "expiry"), expiry);
407         s.setBytes32(keccak256(key, "tenantName"), tenantName);
408         s.setBytes32(keccak256(key, "tenantDescription"), tenantDescription);
409         s.setBytes32(keccak256(key, "tenantURL"), tenantURL);
410         s.setBytes32(keccak256(key, "tenantImageURL"), tenantImageURL);
411         storageAddress.transfer(msg.value);
412         RentedBlock(x, y, msg.value, feePercentage, owner);
413         LeasedBlock(x, y, msg.value, expiry, tenantName, tenantDescription, tenantURL, tenantImageURL, msg.sender);
414     }
415 
416     // get details for a tenancy
417     function getTenancy (uint x, uint y) public view returns (
418         uint expiry,
419         bytes32 tenantName,
420         bytes32 tenantDescription,
421         bytes32 tenantURL,
422         bytes32 tenantImageURL
423     ) {
424         bytes32 key = getKey(x, y);
425         expiry = s.getUInt(keccak256(key, "tenantExpiry"));
426         tenantName = s.getBytes32(keccak256(key, "tenantName"));
427         tenantDescription = s.getBytes32(keccak256(key, "tenantDescription"));
428         tenantURL = s.getBytes32(keccak256(key, "tenantURL"));
429         tenantImageURL = s.getBytes32(keccak256(key, "tenantImageURL"));
430     }
431 }
432 
433 /*
434     Main Blocklord contract. It exposes some commodity functions and functions from its subcontracts.
435 */
436 
437 contract BLMain is BLTenancies {
438 
439     event ChangedInitialPrice(uint price);
440     event ChangedFeePercentage(uint fee);
441 
442     // provides the total number of purchased blocks
443     function totalSupply() public view returns (uint count) {
444         count = s.getUInt("blockCount");
445         return count;
446     }
447 
448     // allows to change the price of an empty block
449     function setInitialPrice(uint price) public onlyPrimary {
450         s.setUInt("initialPrice", price);
451         ChangedInitialPrice(price);
452     }
453 
454     // allows to change the platform fee percentage
455     function setFeePercentage(uint feePercentage) public onlyPrimary {
456         s.setUInt("buyOutFeePercentage", feePercentage);
457         ChangedFeePercentage(feePercentage);
458     }
459 
460     // provides the starting price for an empty block
461     function getInitialPrice() public view returns (uint) {
462         return s.getUInt("initialPrice");
463     }
464 
465     // provides the price of an empty block
466     function getFeePercentage() public view returns (uint) {
467         return s.getUInt("buyOutFeePercentage");
468     }
469 }