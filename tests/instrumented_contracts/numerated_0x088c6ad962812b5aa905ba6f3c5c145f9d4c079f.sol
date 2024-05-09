1 pragma solidity ^0.4.18;
2 
3 // -----------------------------------------------------------------------------------------------
4 // CryptoCatsMarket v3
5 //
6 // Ethereum contract for Cryptocats (cryptocats.thetwentysix.io),
7 // a digital asset marketplace DAPP for unique 8-bit cats on the Ethereum blockchain.
8 // 
9 // Versions:  
10 // 3.0 - Bug fix to make ETH value sent in with getCat function withdrawable by contract owner.
11 //       Special thanks to BokkyPooBah (https://github.com/bokkypoobah) who found this issue!
12 // 2.0 - Remove claimCat function with getCat function that is payable and accepts incoming ETH. 
13 //       Feature added to set ETH pricing by each cat release and also for specific cats
14 // 1.0 - Feature added to create new cat releases, add attributes and offer to sell/buy cats
15 // 0.0 - Initial contract to support ownership of 12 unique 8-bit cats on the Ethereum blockchain
16 // 
17 // Original contract code based off Cryptopunks DAPP by the talented people from Larvalabs 
18 // (https://github.com/larvalabs/cryptopunks)
19 //
20 // (c) Nas Munawar / Gendry Morales / Jochy Reyes / TheTwentySix. 2017. The MIT Licence.
21 // ----------------------------------------------------------------------------------------------
22 
23 contract CryptoCatsMarket {
24     
25     /* modifier to add to function that should only be callable by contract owner */
26     modifier onlyBy(address _account)
27     {
28         require(msg.sender == _account);
29         _;
30     }
31 
32 
33     /* You can use this hash to verify the image file containing all cats */
34     string public imageHash = "3b82cfd5fb39faff3c2c9241ca5a24439f11bdeaa7d6c0771eb782ea7c963917";
35 
36     /* Variables to store contract owner and contract token standard details */
37     address owner;
38     string public standard = 'CryptoCats';
39     string public name;
40     string public symbol;
41     uint8 public decimals;
42     uint256 public _totalSupply;
43     
44     // Store reference to previous cryptocat contract containing alpha release owners
45     // PROD - previous contract address
46     address public previousContractAddress = 0x9508008227b6b3391959334604677d60169EF540;
47 
48     // ROPSTEN - previous contract address
49     // address public previousContractAddress = 0xccEC9B9cB223854C46843A1990c36C4A37D80E2e;
50 
51     uint8 public contractVersion;
52     bool public totalSupplyIsLocked;
53 
54     bool public allCatsAssigned = false;        // boolean flag to indicate if all available cats are claimed
55     uint public catsRemainingToAssign = 0;   // variable to track cats remaining to be assigned/claimed
56     uint public currentReleaseCeiling;       // variable to track maximum cat index for latest release
57 
58     /* Create array to store cat index to owner address */
59     mapping (uint => address) public catIndexToAddress;
60     
61     /* Create array to store cat release id to price in wei for all cats in that release */
62     mapping (uint32 => uint) public catReleaseToPrice;
63 
64     /* Create array to store cat index to any exception price deviating from release price */
65     mapping (uint => uint) public catIndexToPriceException;
66 
67     /* Create an array with all balances */
68     mapping (address => uint) public balanceOf;
69     /* Store type descriptor string for each attribute number */
70     mapping (uint => string) public attributeType;
71     /* Store up to 6 cat attribute strings where attribute types are defined in attributeType */
72     mapping (uint => string[6]) public catAttributes;
73 
74     /* Struct that is used to describe seller offer details */
75     struct Offer {
76         bool isForSale;         // flag identifying if cat is for sale
77         uint catIndex;
78         address seller;         // owner address
79         uint minPrice;       // price in ETH owner is willing to sell cat for
80         address sellOnlyTo;     // address identifying only buyer that seller is wanting to offer cat to
81     }
82 
83     uint[] public releaseCatIndexUpperBound;
84 
85     // Store sale Offer details for each cat made for sale by its owner
86     mapping (uint => Offer) public catsForSale;
87 
88     // Store pending withdrawal amounts in ETH that a failed bidder or successful seller is able to withdraw
89     mapping (address => uint) public pendingWithdrawals;
90 
91     /* Define event types to publish transaction details related to transfer and buy/sell activities */
92     event CatTransfer(address indexed from, address indexed to, uint catIndex);
93     event CatOffered(uint indexed catIndex, uint minPrice, address indexed toAddress);
94     event CatBought(uint indexed catIndex, uint price, address indexed fromAddress, address indexed toAddress);
95     event CatNoLongerForSale(uint indexed catIndex);
96 
97     /* Define event types used to publish to EVM log when cat assignment/claim and cat transfer occurs */
98     event Assign(address indexed to, uint256 catIndex);
99     event Transfer(address indexed from, address indexed to, uint256 value);
100     /* Define event for reporting new cats release transaction details into EVM log */
101     event ReleaseUpdate(uint256 indexed newCatsAdded, uint256 totalSupply, uint256 catPrice, string newImageHash);
102     /* Define event for logging update to cat price for existing release of cats (only impacts unclaimed cats) */
103     event UpdateReleasePrice(uint32 releaseId, uint256 catPrice);
104     /* Define event for logging transactions that change any cat attributes into EVM log*/
105     event UpdateAttribute(uint indexed attributeNumber, address indexed ownerAddress, bytes32 oldValue, bytes32 newValue);
106 
107     /* Initializes contract with initial supply tokens to the creator of the contract */
108     function CryptoCatsMarket() payable {
109         owner = msg.sender;                          // Set contract creation sender as owner
110         _totalSupply = 625;                          // Set total supply
111         catsRemainingToAssign = _totalSupply;        // Initialise cats remaining to total supply amount
112         name = "CRYPTOCATS";                         // Set the name for display purposes
113         symbol = "CCAT";                             // Set the symbol for display purposes
114         decimals = 0;                                // Amount of decimals for display purposes
115         contractVersion = 3;
116         currentReleaseCeiling = 625;
117         totalSupplyIsLocked = false;
118 
119         releaseCatIndexUpperBound.push(12);             // Register release 0 getting to 12 cats
120         releaseCatIndexUpperBound.push(189);            // Register release 1 getting to 189 cats
121         releaseCatIndexUpperBound.push(_totalSupply);   // Register release 2 getting to 625 cats
122 
123         catReleaseToPrice[0] = 0;                       // Set price for release 0
124         catReleaseToPrice[1] = 0;                       // Set price for release 1
125         catReleaseToPrice[2] = 80000000000000000;       // Set price for release 2 to Wei equivalent of 0.08 ETH
126     }
127     
128     /* Admin function to make total supply permanently locked (callable by owner only) */
129     function lockTotalSupply()
130         onlyBy(owner)
131     {
132         totalSupplyIsLocked = true;
133     }
134 
135     /* Admin function to set attribute type descriptor text (callable by owner only) */
136     function setAttributeType(uint attributeIndex, string descriptionText)
137         onlyBy(owner)
138     {
139         require(attributeIndex >= 0 && attributeIndex < 6);
140         attributeType[attributeIndex] = descriptionText;
141     }
142     
143     /* Admin function to release new cat index numbers and update image hash for new cat releases */
144     function releaseCats(uint32 _releaseId, uint numberOfCatsAdded, uint256 catPrice, string newImageHash) 
145         onlyBy(owner)
146         returns (uint256 newTotalSupply) 
147     {
148         require(!totalSupplyIsLocked);                  // Check that new cat releases still available
149         require(numberOfCatsAdded > 0);                 // Require release to have more than 0 cats 
150         currentReleaseCeiling = currentReleaseCeiling + numberOfCatsAdded;  // Add new cats to release ceiling
151         uint _previousSupply = _totalSupply;
152         _totalSupply = _totalSupply + numberOfCatsAdded;
153         catsRemainingToAssign = catsRemainingToAssign + numberOfCatsAdded;  // Update cats remaining to assign count
154         imageHash = newImageHash;                                           // Update image hash
155 
156         catReleaseToPrice[_releaseId] = catPrice;                           // Update price for new release of cats                    
157         releaseCatIndexUpperBound.push(_totalSupply);                       // Track upper bound of cat index for this release
158 
159         ReleaseUpdate(numberOfCatsAdded, _totalSupply, catPrice, newImageHash); // Send EVM event containing details of release
160         return _totalSupply;                                                    // Return new total supply of cats
161     }
162 
163     /* Admin function to update price for an entire release of cats still available for claiming */
164     function updateCatReleasePrice(uint32 _releaseId, uint256 catPrice)
165         onlyBy(owner)
166     {
167         require(_releaseId <= releaseCatIndexUpperBound.length);            // Check that release is id valid
168         catReleaseToPrice[_releaseId] = catPrice;                           // Update price for cat release
169         UpdateReleasePrice(_releaseId, catPrice);                           // Send EVM event with release id and price details
170     }
171    
172     /* Migrate details of previous contract cat owners addresses and cat balances to new contract instance */
173     function migrateCatOwnersFromPreviousContract(uint startIndex, uint endIndex) 
174         onlyBy(owner)
175     {
176         PreviousCryptoCatsContract previousCatContract = PreviousCryptoCatsContract(previousContractAddress);
177         for (uint256 catIndex = startIndex; catIndex <= endIndex; catIndex++) {     // Loop through cat index based on start/end index
178             address catOwner = previousCatContract.catIndexToAddress(catIndex);     // Retrieve owner address from previous contract
179 
180             if (catOwner != 0x0) {                                                  // Check that cat index has an owner address and is not unclaimed
181                 catIndexToAddress[catIndex] = catOwner;                             // Update owner address in current contract
182                 uint256 ownerBalance = previousCatContract.balanceOf(catOwner);     
183                 balanceOf[catOwner] = ownerBalance;                                 // Update owner cat balance
184             }
185         }
186 
187         catsRemainingToAssign = previousCatContract.catsRemainingToAssign();        // Update count of total cats remaining to assign from prev contract
188     }
189     
190     /* Add value for cat attribute that has been defined (only for cat owner) */
191     function setCatAttributeValue(uint catIndex, uint attrIndex, string attrValue) {
192         require(catIndex < _totalSupply);                      // cat index requested should not exceed total supply
193         require(catIndexToAddress[catIndex] == msg.sender);    // require sender to be cat owner
194         require(attrIndex >= 0 && attrIndex < 6);              // require that attribute index is 0 - 5
195         bytes memory tempAttributeTypeText = bytes(attributeType[attrIndex]);
196         require(tempAttributeTypeText.length != 0);            // require that attribute being stored is not empty
197         catAttributes[catIndex][attrIndex] = attrValue;        // store attribute value string in contract based on cat index
198     }
199 
200     /* Transfer cat by owner to another wallet address
201        Different usage in Cryptocats than in normal token transfers 
202        This will transfer an owner's cat to another wallet's address
203        Cat is identified by cat index passed in as _value */
204     function transfer(address _to, uint256 _value) returns (bool success) {
205         if (_value < _totalSupply &&                    // ensure cat index is valid
206             catIndexToAddress[_value] == msg.sender &&  // ensure sender is owner of cat
207             balanceOf[msg.sender] > 0) {                // ensure sender balance of cat exists
208             balanceOf[msg.sender]--;                    // update (reduce) cat balance  from owner
209             catIndexToAddress[_value] = _to;            // set new owner of cat in cat index
210             balanceOf[_to]++;                           // update (include) cat balance for recepient
211             Transfer(msg.sender, _to, _value);          // trigger event with transfer details to EVM
212             success = true;                             // set success as true after transfer completed
213         } else {
214             success = false;                            // set success as false if conditions not met
215         }
216         return success;                                 // return success status
217     }
218 
219     /* Returns count of how many cats are owned by an owner */
220     function balanceOf(address _owner) constant returns (uint256 balance) {
221         require(balanceOf[_owner] != 0);    // requires that cat owner balance is not 0
222         return balanceOf[_owner];           // return number of cats owned from array of balances by owner address
223     }
224 
225     /* Return total supply of cats existing */
226     function totalSupply() constant returns (uint256 totalSupply) {
227         return _totalSupply;
228     }
229 
230     /* Claim cat at specified index if it is unassigned - Deprecated as replaced with getCat function in v2.0 */
231     // function claimCat(uint catIndex) {
232     //     require(!allCatsAssigned);                      // require all cats have not been assigned/claimed
233     //     require(catsRemainingToAssign != 0);            // require cats remaining to be assigned count is not 0
234     //     require(catIndexToAddress[catIndex] == 0x0);    // require owner address for requested cat index is empty
235     //     require(catIndex < _totalSupply);               // require cat index requested does not exceed total supply
236     //     require(catIndex < currentReleaseCeiling);      // require cat index to not be above current ceiling of released cats
237     //     catIndexToAddress[catIndex] = msg.sender;       // Assign sender's address as owner of cat
238     //     balanceOf[msg.sender]++;                        // Increase sender's balance holder 
239     //     catsRemainingToAssign--;                        // Decrease cats remaining count
240     //     Assign(msg.sender, catIndex);                   // Triggers address assignment event to EVM's
241     //                                                     // log to allow javascript callbacks
242     // }
243 
244     /* Return the release index for a cat based on the cat index */
245     function getCatRelease(uint catIndex) returns (uint32) {
246         for (uint32 i = 0; i < releaseCatIndexUpperBound.length; i++) {     // loop through release index record array
247             if (releaseCatIndexUpperBound[i] > catIndex) {                  // check if highest cat index for release is higher than submitted cat index 
248                 return i;                                                   // return release id
249             }
250         }   
251     }
252 
253     /* Gets cat price for a particular cat index */
254     function getCatPrice(uint catIndex) returns (uint catPrice) {
255         require(catIndex < _totalSupply);                   // Require that cat index is valid
256 
257         if(catIndexToPriceException[catIndex] != 0) {       // Check if there is any exception pricing
258             return catIndexToPriceException[catIndex];      // Return price if there is overriding exception pricing
259         }
260 
261         uint32 releaseId = getCatRelease(catIndex);         
262         return catReleaseToPrice[releaseId];                // Return cat price based on release pricing if no exception pricing
263     }
264 
265     /* Sets exception price in Wei that differs from release price for single cat based on cat index */
266     function setCatPrice(uint catIndex, uint catPrice)
267         onlyBy(owner) 
268     {
269         require(catIndex < _totalSupply);                   // Require that cat index is valid
270         require(catPrice > 0);                              // Check that cat price is not 0
271         catIndexToPriceException[catIndex] = catPrice;      // Create cat price record in exception pricing array for this cat index
272     }
273 
274     /* Get cat with no owner at specified index by paying price */
275     function getCat(uint catIndex) payable {
276         require(!allCatsAssigned);                      // require all cats have not been assigned/claimed
277         require(catsRemainingToAssign != 0);            // require cats remaining to be assigned count is not 0
278         require(catIndexToAddress[catIndex] == 0x0);    // require owner address for requested cat index is empty
279         require(catIndex < _totalSupply);               // require cat index requested does not exceed total supply
280         require(catIndex < currentReleaseCeiling);      // require cat index to not be above current ceiling of released cats
281         require(getCatPrice(catIndex) <= msg.value);    // require ETH amount sent with tx is sufficient for cat price
282 
283         catIndexToAddress[catIndex] = msg.sender;       // Assign sender's address as owner of cat
284         balanceOf[msg.sender]++;                        // Increase sender's balance holder 
285         catsRemainingToAssign--;                        // Decrease cats remaining count
286         pendingWithdrawals[owner] += msg.value;         // Add paid amount to pending withdrawals for contract owner (bugfix in v3.0)
287         Assign(msg.sender, catIndex);                   // Triggers address assignment event to EVM's
288                                                         // log to allow javascript callbacks
289     }
290 
291     /* Get address of owner based on cat index */
292     function getCatOwner(uint256 catIndex) public returns (address) {
293         require(catIndexToAddress[catIndex] != 0x0);
294         return catIndexToAddress[catIndex];             // Return address at array position of cat index
295     }
296 
297     /* Get address of contract owner who performed contract creation and initialisation */
298     function getContractOwner() public returns (address) {
299         return owner;                                   // Return address of contract owner
300     }
301 
302     /* Indicate that cat is no longer for sale (by cat owner only) */
303     function catNoLongerForSale(uint catIndex) {
304         require (catIndexToAddress[catIndex] == msg.sender);                // Require that sender is cat owner
305         require (catIndex < _totalSupply);                                  // Require that cat index is valid
306         catsForSale[catIndex] = Offer(false, catIndex, msg.sender, 0, 0x0); // Switch cat for sale flag to false and reset all other values
307         CatNoLongerForSale(catIndex);                                       // Create EVM event logging that cat is no longer for sale 
308     }
309 
310     /* Create sell offer for cat with a certain minimum sale price in wei (by cat owner only) */
311     function offerCatForSale(uint catIndex, uint minSalePriceInWei) {
312         require (catIndexToAddress[catIndex] == msg.sender);                // Require that sender is cat owner 
313         require (catIndex < _totalSupply);                                  // Require that cat index is valid
314         catsForSale[catIndex] = Offer(true, catIndex, msg.sender, minSalePriceInWei, 0x0);  // Set cat for sale flag to true and update with price details 
315         CatOffered(catIndex, minSalePriceInWei, 0x0);                       // Create EVM event to log details of cat sale
316     }
317 
318     /* Create sell offer for cat only to a particular buyer address with certain minimum sale price in wei (by cat owner only) */
319     function offerCatForSaleToAddress(uint catIndex, uint minSalePriceInWei, address toAddress) {
320         require (catIndexToAddress[catIndex] == msg.sender);                // Require that sender is cat owner 
321         require (catIndex < _totalSupply);                                  // Require that cat index is valid
322         catsForSale[catIndex] = Offer(true, catIndex, msg.sender, minSalePriceInWei, toAddress); // Set cat for sale flag to true and update with price details and only sell to address
323         CatOffered(catIndex, minSalePriceInWei, toAddress);                 // Create EVM event to log details of cat sale
324     }
325 
326     /* Buy cat that is currently on offer  */
327     function buyCat(uint catIndex) payable {
328         require (catIndex < _totalSupply);                      // require that cat index is valid and less than total cat index                
329         Offer offer = catsForSale[catIndex];
330         require (offer.isForSale);                              // require that cat is marked for sale  // require buyer to have required address if indicated in offer 
331         require (msg.value >= offer.minPrice);                  // require buyer sent enough ETH
332         require (offer.seller == catIndexToAddress[catIndex]);  // require seller must still be owner of cat
333         if (offer.sellOnlyTo != 0x0) {                          // if cat offer sell only to address is not blank
334             require (offer.sellOnlyTo == msg.sender);           // require that buyer is allowed to buy offer
335         }
336         
337         address seller = offer.seller;
338 
339         catIndexToAddress[catIndex] = msg.sender;               // update cat owner address to buyer's address
340         balanceOf[seller]--;                                    // reduce cat balance of seller
341         balanceOf[msg.sender]++;                                // increase cat balance of buyer
342         Transfer(seller, msg.sender, 1);                        // create EVM event logging transfer of 1 cat from seller to owner
343 
344         CatNoLongerForSale(catIndex);                           // create EVM event logging cat is no longer for sale
345         pendingWithdrawals[seller] += msg.value;                // increase pending withdrawal amount of seller based on amount sent in buyer's message
346         CatBought(catIndex, msg.value, seller, msg.sender);     // create EVM event logging details of cat purchase
347 
348     }
349 
350     /* Withdraw any pending ETH amount that is owed to failed bidder or successful seller */
351     function withdraw() {
352         uint amount = pendingWithdrawals[msg.sender];   // store amount that can be withdrawn by sender
353         pendingWithdrawals[msg.sender] = 0;             // zero pending withdrawal amount
354         msg.sender.transfer(amount);                    // before performing transfer to message sender
355     }
356 }
357 
358 contract PreviousCryptoCatsContract {
359 
360     /* You can use this hash to verify the image file containing all cats */
361     string public imageHash = "e055fe5eb1d95ea4e42b24d1038db13c24667c494ce721375bdd827d34c59059";
362 
363     /* Variables to store contract owner and contract token standard details */
364     address owner;
365     string public standard = 'CryptoCats';
366     string public name;
367     string public symbol;
368     uint8 public decimals;
369     uint256 public _totalSupply;
370     
371     // Store reference to previous cryptocat contract containing alpha release owners
372     // PROD
373     address public previousContractAddress = 0xa185B9E63FB83A5a1A13A4460B8E8605672b6020;
374     // ROPSTEN
375     // address public previousContractAddress = 0x0b0DB7bd68F944C219566E54e84483b6c512737B;
376     uint8 public contractVersion;
377     bool public totalSupplyIsLocked;
378 
379     bool public allCatsAssigned = false;        // boolean flag to indicate if all available cats are claimed
380     uint public catsRemainingToAssign = 0;   // variable to track cats remaining to be assigned/claimed
381     uint public currentReleaseCeiling;       // variable to track maximum cat index for latest release
382 
383     /* Create array to store cat index to owner address */
384     mapping (uint => address) public catIndexToAddress;
385 
386     /* Create an array with all balances */
387     mapping (address => uint) public balanceOf;
388 
389     /* Initializes contract with initial supply tokens to the creator of the contract */
390     function PreviousCryptoCatsContract() payable {
391         owner = msg.sender;                          // Set contract creation sender as owner
392     }
393 
394     /* Returns count of how many cats are owned by an owner */
395     function balanceOf(address _owner) constant returns (uint256 balance) {
396         require(balanceOf[_owner] != 0);    // requires that cat owner balance is not 0
397         return balanceOf[_owner];           // return number of cats owned from array of balances by owner address
398     }
399 
400     /* Return total supply of cats existing */
401     function totalSupply() constant returns (uint256 totalSupply) {
402         return _totalSupply;
403     }
404 
405     /* Get address of owner based on cat index */
406     function getCatOwner(uint256 catIndex) public returns (address) {
407         require(catIndexToAddress[catIndex] != 0x0);
408         return catIndexToAddress[catIndex];             // Return address at array position of cat index
409     }
410 
411     /* Get address of contract owner who performed contract creation and initialisation */
412     function getContractOwner() public returns (address) {
413         return owner;                                   // Return address of contract owner
414     }
415 
416 }