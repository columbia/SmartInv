1 pragma solidity ^0.4.18;
2 
3 /*
4     Manages ownership and permissions for the whole contract.
5 */
6 
7 pragma solidity ^0.4.18;
8 
9 /*
10     Manages ownership and permissions for the whole contract.
11 */
12 
13 contract BLAccess {
14 
15     address public mainAddress; //Main Contract Address
16     address public bonusAddress; //BonusAddress
17     event UpdatedMainAccount(address _newMainAddress);
18     event UpdatedBonusAccount(address _newBonusAddress);
19 
20     function BLAccess() public {
21         mainAddress = msg.sender;
22         bonusAddress = msg.sender;
23     }
24 
25     modifier onlyPrimary() {
26         require(msg.sender == mainAddress);
27         _;
28     }
29 
30     modifier onlyBonus() {
31       require(msg.sender == bonusAddress);
32       _;
33     }
34 
35     function setSecondary(address _newSecondary) external onlyPrimary {
36       require(_newSecondary != address(0));
37       bonusAddress = _newSecondary;
38       UpdatedBonusAccount(_newSecondary);
39     }
40 
41     //Allows to change the primary account for the contract
42     function setPrimaryAccount(address _newMainAddress) external onlyPrimary {
43         require(_newMainAddress != address(0));
44         mainAddress = _newMainAddress;
45         UpdatedMainAccount(_newMainAddress);
46     }
47 
48 }
49 
50 
51 /*
52  Interface for our separate eternal storage.
53 */
54 
55 contract DataStorageInterface {
56     function getUInt(bytes32 record) public constant returns (uint);
57     function setUInt(bytes32 record, uint value) public;
58     function getAdd(bytes32 record) public constant returns (address);
59     function setAdd(bytes32 record, address value) public;
60     function getBytes32(bytes32 record) public constant returns (bytes32);
61     function setBytes32(bytes32 record, bytes32 value) public;
62     function getBool(bytes32 record) public constant returns (bool);
63     function setBool(bytes32 record, bool value) public;
64     function withdraw(address beneficiary) public;
65 }
66 
67 /*
68  Wrapper around Data Storage interface
69 */
70 
71 contract BLStorage is BLAccess {
72 
73     DataStorageInterface internal s;
74     address public storageAddress;
75 
76     event StorageUpdated(address _newStorageAddress);
77 
78     function BLStorage() public {
79         s = DataStorageInterface(mainAddress);
80     }
81 
82     // allows to setup a new Storage address. Should never be needed but you never know!
83     function setDataStorage(address newAddress) public onlyPrimary {
84         s = DataStorageInterface(newAddress);
85         storageAddress = newAddress;
86         StorageUpdated(newAddress);
87     }
88 
89     function getKey(uint x, uint y) internal pure returns(bytes32 key) {
90         key = keccak256(x, ":", y);
91     }
92 }
93 
94 
95 contract BLBalances is BLStorage {
96 
97     event WithdrawBalance(address indexed owner, uint amount);
98     event AllowanceGranted(address indexed owner, uint _amount);
99     event SentFeeToPlatform(uint amount);
100     event SentAmountToOwner(uint amount, address indexed owner);
101     event BonusGranted(address _beneficiary, uint _amount);
102     event SentAmountToNeighbours(uint reward, address indexed owner);
103 
104     // get the balance for a given account
105     function getBalance() public view returns (uint) {
106         return s.getUInt(keccak256(msg.sender, "balance"));
107     }
108 
109     // get the balance for a given account
110     function getAccountBalance(address _account) public view onlyPrimary returns (uint) {
111         return s.getUInt(keccak256(_account, "balance"));
112     }
113 
114     function getAccountAllowance(address _account) public view onlyPrimary returns (uint) {
115         return s.getUInt(keccak256(_account, "promoAllowance"));
116     }
117 
118     function getMyAllowance() public view returns (uint) {
119         return s.getUInt(keccak256(msg.sender, "promoAllowance"));
120     }
121 
122     // IF a block has been assigned a bonus, provude the bonus to the next buyer.
123     function giveBonusIfExists(uint x, uint y) internal {
124       bytes32 key = getKey(x, y);
125       uint bonus = s.getUInt(keccak256(key, "bonus"));
126       uint balance = s.getUInt(keccak256(msg.sender, "balance"));
127       uint total = balance + bonus;
128       s.setUInt(keccak256(msg.sender, "balance"), total);
129       s.setUInt(keccak256(key, "bonus"), 0);
130       if (bonus > 0) {
131         BonusGranted(msg.sender, bonus);
132       }
133     }
134 
135     // allow a block allowance for promo and early beta users
136     function grantAllowance(address beneficiary, uint allowance) public onlyPrimary {
137         uint existingAllowance = s.getUInt(keccak256(beneficiary, "promoAllowance"));
138         existingAllowance += allowance;
139         s.setUInt(keccak256(beneficiary, "promoAllowance"), existingAllowance);
140         AllowanceGranted(beneficiary, allowance);
141     }
142 
143     // withdraw the current balance
144     function withdraw() public {
145         uint balance = s.getUInt(keccak256(msg.sender, "balance"));
146         s.withdraw(msg.sender);
147         WithdrawBalance(msg.sender, balance);
148     }
149 
150     // Trading and buying balances flow
151     function rewardParties (uint x, uint y, uint feePercentage) internal {
152         uint fee = msg.value * feePercentage / 100;
153         uint remainder = msg.value - fee;
154         uint rewardPct = s.getUInt("neighbourRewardPercentage");
155         uint toOwner = remainder - (remainder * rewardPct * 8 / 100);
156         rewardContract(fee);
157         rewardPreviousOwner(x, y, toOwner);
158         rewardNeighbours(x, y, remainder, rewardPct);
159     }
160 
161     function rewardNeighbours (uint x, uint y, uint remainder, uint rewardPct) internal {
162         uint rewardAmount = remainder * rewardPct / 100;
163       address nw = s.getAdd(keccak256(keccak256(x-1, ":", y-1), "owner"));
164       address n = s.getAdd(keccak256(keccak256(x-1, ":", y), "owner"));
165       address ne = s.getAdd(keccak256(keccak256(x-1, ":", y+1), "owner"));
166       address w = s.getAdd(keccak256(keccak256(x, ":", y-1), "owner"));
167       address e = s.getAdd(keccak256(keccak256(x, ":", y+1), "owner"));
168       address sw = s.getAdd(keccak256(keccak256(x+1, ":", y-1), "owner"));
169       address south = s.getAdd(keccak256(keccak256(x+1, ":", y), "owner"));
170       address se = s.getAdd(keccak256(keccak256(x+1, ":", y+1), "owner"));
171       nw != address(0) ? rewardBlock(nw, rewardAmount) : rewardBlock(bonusAddress, rewardAmount);
172       n != address(0) ? rewardBlock(n, rewardAmount) : rewardBlock(bonusAddress, rewardAmount);
173       ne != address(0) ? rewardBlock(ne, rewardAmount) : rewardBlock(bonusAddress, rewardAmount);
174       w != address(0) ? rewardBlock(w, rewardAmount) : rewardBlock(bonusAddress, rewardAmount);
175       e != address(0) ? rewardBlock(e, rewardAmount) : rewardBlock(bonusAddress, rewardAmount);
176       sw != address(0) ? rewardBlock(sw, rewardAmount) : rewardBlock(bonusAddress, rewardAmount);
177       south != address(0) ? rewardBlock(south, rewardAmount) : rewardBlock(bonusAddress, rewardAmount);
178       se != address(0) ? rewardBlock(se, rewardAmount) : rewardBlock(bonusAddress, rewardAmount);
179     }
180 
181     function rewardBlock(address account, uint reward) internal {
182       uint balance = s.getUInt(keccak256(account, "balance"));
183       balance += reward;
184       s.setUInt(keccak256(account, "balance"), balance);
185       SentAmountToNeighbours(reward,account);
186     }
187 
188     // contract commissions
189     function rewardContract (uint fee) internal {
190         uint mainBalance = s.getUInt(keccak256(mainAddress, "balance"));
191         mainBalance += fee;
192         s.setUInt(keccak256(mainAddress, "balance"), mainBalance);
193         SentFeeToPlatform(fee);
194     }
195 
196     // reward the previous owner of the block or the contract if the block is bought for the first time
197     function rewardPreviousOwner (uint x, uint y, uint amount) internal {
198         uint rewardBalance;
199         bytes32 key = getKey(x, y);
200         address owner = s.getAdd(keccak256(key, "owner"));
201         if (owner == address(0)) {
202             rewardBalance = s.getUInt(keccak256(mainAddress, "balance"));
203             rewardBalance += amount;
204             s.setUInt(keccak256(mainAddress, "balance"), rewardBalance);
205             SentAmountToOwner(amount, mainAddress);
206         } else {
207             rewardBalance = s.getUInt(keccak256(owner, "balance"));
208             rewardBalance += amount;
209             s.setUInt(keccak256(owner, "balance"), rewardBalance);
210             SentAmountToOwner(amount, owner);
211         }
212     }
213 }
214 
215 contract BLBlocks is BLBalances {
216 
217     event CreatedBlock(
218         uint x,
219         uint y,
220         uint price,
221         address indexed owner,
222         bytes32 name,
223         bytes32 description,
224         bytes32 url,
225         bytes32 imageURL);
226 
227     event SetBlockForSale(
228         uint x,
229         uint y,
230         uint price,
231         address indexed owner);
232 
233     event UnsetBlockForSale(
234         uint x,
235         uint y,
236         address indexed owner);
237 
238     event BoughtBlock(
239         uint x,
240         uint y,
241         uint price,
242         address indexed owner,
243         bytes32 name,
244         bytes32 description,
245         bytes32 url,
246         bytes32 imageURL);
247 
248     event SoldBlock(
249         uint x,
250         uint y,
251         uint oldPrice,
252         uint newPrice,
253         uint feePercentage,
254         address indexed owner);
255 
256     event UpdatedBlock(uint x,
257         uint y,
258         bytes32 name,
259         bytes32 description,
260         bytes32 url,
261         bytes32 imageURL,
262         address indexed owner);
263 
264     // Create a block if it doesn't exist
265     function createBlock(
266         uint x,
267         uint y,
268         bytes32 name,
269         bytes32 description,
270         bytes32 url,
271         bytes32 imageURL
272     ) public payable {
273         bytes32 key = getKey(x, y);
274         uint initialPrice = s.getUInt("initialPrice");
275         address owner = s.getAdd(keccak256(key, "owner"));
276         uint allowance = s.getUInt(keccak256(msg.sender, "promoAllowance"));
277         require(msg.value >= initialPrice || allowance > 0);
278         require(owner == address(0));
279         uint feePercentage = s.getUInt("buyOutFeePercentage");
280         if (msg.value >= initialPrice) {
281             rewardParties(x, y, feePercentage);
282             s.setUInt(keccak256(key, "price"), msg.value);
283         } else {
284             allowance--;
285             s.setUInt(keccak256(msg.sender, "promoAllowance"), allowance);
286             s.setUInt(keccak256(key, "price"), initialPrice);
287         }
288         s.setBytes32(keccak256(key, "name"), name);
289         s.setBytes32(keccak256(key, "description"), description);
290         s.setBytes32(keccak256(key, "url"), url);
291         s.setBytes32(keccak256(key, "imageURL"), imageURL);
292         s.setAdd(keccak256(key, "owner"), msg.sender);
293         uint blockCount = s.getUInt("blockCount");
294         giveBonusIfExists(x, y);
295         blockCount++;
296         s.setUInt("blockCount", blockCount);
297         storageAddress.transfer(msg.value);
298         CreatedBlock(x,
299             y,
300             msg.value,
301             msg.sender,
302             name,
303             description,
304             url,
305             imageURL);
306     }
307 
308     // Get details for a block
309     function getBlock (uint x, uint y) public view returns (
310         uint price,
311         bytes32 name,
312         bytes32 description,
313         bytes32 url,
314         bytes32 imageURL,
315         uint forSale,
316         uint pricePerDay,
317         address owner
318     ) {
319         bytes32 key = getKey(x, y);
320         price = s.getUInt(keccak256(key, "price"));
321         name = s.getBytes32(keccak256(key, "name"));
322         description = s.getBytes32(keccak256(key, "description"));
323         url = s.getBytes32(keccak256(key, "url"));
324         imageURL = s.getBytes32(keccak256(key, "imageURL"));
325         forSale = s.getUInt(keccak256(key, "forSale"));
326         pricePerDay = s.getUInt(keccak256(key, "pricePerDay"));
327         owner = s.getAdd(keccak256(key, "owner"));
328     }
329 
330     // Sets a block up for sale
331     function sellBlock(uint x, uint y, uint price) public {
332         bytes32 key = getKey(x, y);
333         uint basePrice = s.getUInt(keccak256(key, "price"));
334         require(s.getAdd(keccak256(key, "owner")) == msg.sender);
335         require(price < basePrice * 2);
336         s.setUInt(keccak256(key, "forSale"), price);
337         SetBlockForSale(x, y, price, msg.sender);
338     }
339 
340     // Sets a block not for sale
341     function cancelSellBlock(uint x, uint y) public {
342         bytes32 key = getKey(x, y);
343         require(s.getAdd(keccak256(key, "owner")) == msg.sender);
344         s.setUInt(keccak256(key, "forSale"), 0);
345         UnsetBlockForSale(x, y, msg.sender);
346     }
347 
348     // transfers ownership of an existing block
349     function buyBlock(
350         uint x,
351         uint y,
352         bytes32 name,
353         bytes32 description,
354         bytes32 url,
355         bytes32 imageURL
356     ) public payable {
357         bytes32 key = getKey(x, y);
358         uint price = s.getUInt(keccak256(key, "price"));
359         uint forSale = s.getUInt(keccak256(key, "forSale"));
360         address owner = s.getAdd(keccak256(key, "owner"));
361         require(owner != address(0));
362         require((forSale > 0 && msg.value >= forSale) || msg.value >= price * 2);
363         uint feePercentage = s.getUInt("buyOutFeePercentage");
364         rewardParties(x, y, feePercentage);
365         s.setUInt(keccak256(key, "price"), msg.value);
366         s.setBytes32(keccak256(key, "name"), name);
367         s.setBytes32(keccak256(key, "description"), description);
368         s.setBytes32(keccak256(key, "url"), url);
369         s.setBytes32(keccak256(key, "imageURL"), imageURL);
370         s.setAdd(keccak256(key, "owner"), msg.sender);
371         s.setUInt(keccak256(key, "forSale"), 0);
372         s.setUInt(keccak256(key, "pricePerDay"), 0);
373         giveBonusIfExists(x, y);
374         storageAddress.transfer(msg.value);
375         BoughtBlock(x, y, msg.value, msg.sender,
376             name, description, url, imageURL);
377         SoldBlock(x, y, price, msg.value, feePercentage, owner);
378     }
379 
380     // update details for an existing block
381     function updateBlock(
382         uint x,
383         uint y,
384         bytes32 name,
385         bytes32 description,
386         bytes32 url,
387         bytes32 imageURL
388     )  public {
389         bytes32 key = getKey(x, y);
390         address owner = s.getAdd(keccak256(key, "owner"));
391         require(msg.sender == owner);
392         s.setBytes32(keccak256(key, "name"), name);
393         s.setBytes32(keccak256(key, "description"), description);
394         s.setBytes32(keccak256(key, "url"), url);
395         s.setBytes32(keccak256(key, "imageURL"), imageURL);
396         UpdatedBlock(x, y, name, description, url, imageURL, msg.sender);
397     }
398     
399     // Add a bonus to a block. That bonus will be awarded to the next buyer.
400     // Note, we are not emitting an event to avoid cheating.
401     function addBonusToBlock(
402         uint x,
403         uint y,
404         uint bonus
405     ) public onlyPrimary {
406         bytes32 key = getKey(x, y);
407         uint bonusBalance = s.getUInt(keccak256(bonusAddress, "balance"));
408         require(bonusBalance >= bonus);
409         s.setUInt(keccak256(key, "bonus"), bonus);
410     }
411 
412 }
413 
414 /*
415     Main Blocklord contract. It exposes some commodity functions and functions from its subcontracts.
416 */
417 
418 contract BLMain is BLBlocks {
419 
420     event ChangedInitialPrice(uint price);
421     event ChangedFeePercentage(uint fee);
422 
423     // provides the total number of purchased blocks
424     function totalSupply() public view returns (uint count) {
425         count = s.getUInt("blockCount");
426         return count;
427     }
428 
429     // allows to change the price of an empty block
430     function setInitialPrice(uint price) public onlyPrimary {
431         s.setUInt("initialPrice", price);
432         ChangedInitialPrice(price);
433     }
434 
435     // allows to change the platform fee percentage
436     function setFeePercentage(uint feePercentage) public onlyPrimary {
437         s.setUInt("buyOutFeePercentage", feePercentage);
438         ChangedFeePercentage(feePercentage);
439     }
440 
441     // provides the starting price for an empty block
442     function getInitialPrice() public view returns (uint) {
443         return s.getUInt("initialPrice");
444     }
445 
446     // provides the price of an empty block
447     function getFeePercentage() public view returns (uint) {
448         return s.getUInt("buyOutFeePercentage");
449     }
450 }