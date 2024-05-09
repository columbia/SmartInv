1 pragma solidity ^0.4.13;
2 
3 contract MoonCatRescue {
4   enum Modes { Inactive, Disabled, Test, Live }
5 
6   Modes public mode = Modes.Inactive;
7 
8   address owner;
9 
10   bytes16 public imageGenerationCodeMD5 = 0xdbad5c08ec98bec48490e3c196eec683; // use this to verify mooncatparser.js the cat image data generation javascript file.
11 
12   string public name = "MoonCats";
13   string public symbol = "?"; // unicode cat symbol
14   uint8 public decimals = 0;
15 
16   uint256 public totalSupply = 25600;
17   uint16 public remainingCats = 25600 - 256; // there will only ever be 25,000 cats
18   uint16 public remainingGenesisCats = 256; // there can only be a maximum of 256 genesis cats
19   uint16 public rescueIndex = 0;
20 
21   bytes5[25600] public rescueOrder;
22 
23   bytes32 public searchSeed = 0x0; // gets set with the immediately preceding blockhash when the contract is activated to prevent "premining"
24 
25   struct AdoptionOffer {
26     bool exists;
27     bytes5 catId;
28     address seller;
29     uint price;
30     address onlyOfferTo;
31   }
32 
33   struct AdoptionRequest{
34     bool exists;
35     bytes5 catId;
36     address requester;
37     uint price;
38   }
39 
40   mapping (bytes5 => AdoptionOffer) public adoptionOffers;
41   mapping (bytes5 => AdoptionRequest) public adoptionRequests;
42 
43   mapping (bytes5 => bytes32) public catNames;
44   mapping (bytes5 => address) public catOwners;
45   mapping (address => uint256) public balanceOf; //number of cats owned by a given address
46   mapping (address => uint) public pendingWithdrawals;
47 
48   /* events */
49 
50   event CatRescued(address indexed to, bytes5 indexed catId);
51   event CatNamed(bytes5 indexed catId, bytes32 catName);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53   event CatAdopted(bytes5 indexed catId, uint price, address indexed from, address indexed to);
54   event AdoptionOffered(bytes5 indexed catId, uint price, address indexed toAddress);
55   event AdoptionOfferCancelled(bytes5 indexed catId);
56   event AdoptionRequested(bytes5 indexed catId, uint price, address indexed from);
57   event AdoptionRequestCancelled(bytes5 indexed catId);
58   event GenesisCatsAdded(bytes5[16] catIds);
59 
60   function MoonCatRescue() payable {
61     owner = msg.sender;
62     assert((remainingCats + remainingGenesisCats) == totalSupply);
63     assert(rescueOrder.length == totalSupply);
64     assert(rescueIndex == 0);
65   }
66 
67   /* registers and validates cats that are found */
68   function rescueCat(bytes32 seed) activeMode returns (bytes5) {
69     require(remainingCats > 0); // cannot register any cats once supply limit is reached
70     bytes32 catIdHash = keccak256(seed, searchSeed); // generate the prospective catIdHash
71     require(catIdHash[0] | catIdHash[1] | catIdHash[2] == 0x0); // ensures the validity of the catIdHash
72     bytes5 catId = bytes5((catIdHash & 0xffffffff) << 216); // one byte to indicate genesis, and the last 4 bytes of the catIdHash
73     require(catOwners[catId] == 0x0); // if the cat is already registered, throw an error. All cats are unique.
74 
75     rescueOrder[rescueIndex] = catId;
76     rescueIndex++;
77 
78     catOwners[catId] = msg.sender;
79     balanceOf[msg.sender]++;
80     remainingCats--;
81 
82     CatRescued(msg.sender, catId);
83 
84     return catId;
85   }
86 
87   /* assigns a name to a cat, once a name is assigned it cannot be changed */
88   function nameCat(bytes5 catId, bytes32 catName) onlyCatOwner(catId) {
89     require(catNames[catId] == 0x0); // ensure the current name is empty; cats can only be named once
90     require(!adoptionOffers[catId].exists); // cats cannot be named while they are up for adoption
91     catNames[catId] = catName;
92     CatNamed(catId, catName);
93   }
94 
95   /* puts a cat up for anyone to adopt */
96   function makeAdoptionOffer(bytes5 catId, uint price) onlyCatOwner(catId) {
97     require(price > 0);
98     adoptionOffers[catId] = AdoptionOffer(true, catId, msg.sender, price, 0x0);
99     AdoptionOffered(catId, price, 0x0);
100   }
101 
102   /* puts a cat up for a specific address to adopt */
103   function makeAdoptionOfferToAddress(bytes5 catId, uint price, address to) onlyCatOwner(catId) isNotSender(to){
104     adoptionOffers[catId] = AdoptionOffer(true, catId, msg.sender, price, to);
105     AdoptionOffered(catId, price, to);
106   }
107 
108   /* cancel an adoption offer */
109   function cancelAdoptionOffer(bytes5 catId) onlyCatOwner(catId) {
110     adoptionOffers[catId] = AdoptionOffer(false, catId, 0x0, 0, 0x0);
111     AdoptionOfferCancelled(catId);
112   }
113 
114   /* accepts an adoption offer  */
115   function acceptAdoptionOffer(bytes5 catId) payable {
116     AdoptionOffer storage offer = adoptionOffers[catId];
117     require(offer.exists);
118     require(offer.onlyOfferTo == 0x0 || offer.onlyOfferTo == msg.sender);
119     require(msg.value >= offer.price);
120     if(msg.value > offer.price) {
121       pendingWithdrawals[msg.sender] += (msg.value - offer.price); // if the submitted amount exceeds the price allow the buyer to withdraw the difference
122     }
123     transferCat(catId, catOwners[catId], msg.sender, offer.price);
124   }
125 
126   /* transfer a cat directly without payment */
127   function giveCat(bytes5 catId, address to) onlyCatOwner(catId) {
128     transferCat(catId, msg.sender, to, 0);
129   }
130 
131   /* requests adoption of a cat with an ETH offer */
132   function makeAdoptionRequest(bytes5 catId) payable isNotSender(catOwners[catId]) {
133     require(catOwners[catId] != 0x0); // the cat must be owned
134     AdoptionRequest storage existingRequest = adoptionRequests[catId];
135     require(msg.value > 0);
136     require(msg.value > existingRequest.price);
137 
138 
139     if(existingRequest.price > 0) {
140       pendingWithdrawals[existingRequest.requester] += existingRequest.price;
141     }
142 
143     adoptionRequests[catId] = AdoptionRequest(true, catId, msg.sender, msg.value);
144     AdoptionRequested(catId, msg.value, msg.sender);
145 
146   }
147 
148   /* allows the owner of the cat to accept an adoption request */
149   function acceptAdoptionRequest(bytes5 catId) onlyCatOwner(catId) {
150     AdoptionRequest storage existingRequest = adoptionRequests[catId];
151     require(existingRequest.exists);
152     address existingRequester = existingRequest.requester;
153     uint existingPrice = existingRequest.price;
154     adoptionRequests[catId] = AdoptionRequest(false, catId, 0x0, 0); // the adoption request must be cancelled before calling transferCat to prevent refunding the requester.
155     transferCat(catId, msg.sender, existingRequester, existingPrice);
156   }
157 
158   /* allows the requester to cancel their adoption request */
159   function cancelAdoptionRequest(bytes5 catId) {
160     AdoptionRequest storage existingRequest = adoptionRequests[catId];
161     require(existingRequest.exists);
162     require(existingRequest.requester == msg.sender);
163 
164     uint price = existingRequest.price;
165 
166     adoptionRequests[catId] = AdoptionRequest(false, catId, 0x0, 0);
167 
168     msg.sender.transfer(price);
169 
170     AdoptionRequestCancelled(catId);
171   }
172 
173 
174   function withdraw() {
175     uint amount = pendingWithdrawals[msg.sender];
176     pendingWithdrawals[msg.sender] = 0;
177     msg.sender.transfer(amount);
178   }
179 
180   /* owner only functions */
181 
182   /* disable contract before activation. A safeguard if a bug is found before the contract is activated */
183   function disableBeforeActivation() onlyOwner inactiveMode {
184     mode = Modes.Disabled;  // once the contract is disabled it's mode cannot be changed
185   }
186 
187   /* activates the contract in *Live* mode which sets the searchSeed and enables rescuing */
188   function activate() onlyOwner inactiveMode {
189     searchSeed = block.blockhash(block.number - 1); // once the searchSeed is set it cannot be changed;
190     mode = Modes.Live; // once the contract is activated it's mode cannot be changed
191   }
192 
193   /* activates the contract in *Test* mode which sets the searchSeed and enables rescuing */
194   function activateInTestMode() onlyOwner inactiveMode { //
195     searchSeed = 0x5713bdf5d1c3398a8f12f881f0f03b5025b6f9c17a97441a694d5752beb92a3d; // once the searchSeed is set it cannot be changed;
196     mode = Modes.Test; // once the contract is activated it's mode cannot be changed
197   }
198 
199   /* add genesis cats in groups of 16 */
200   function addGenesisCatGroup() onlyOwner activeMode {
201     require(remainingGenesisCats > 0);
202     bytes5[16] memory newCatIds;
203     uint256 price = (17 - (remainingGenesisCats / 16)) * 300000000000000000;
204     for(uint8 i = 0; i < 16; i++) {
205 
206       uint16 genesisCatIndex = 256 - remainingGenesisCats;
207       bytes5 genesisCatId = (bytes5(genesisCatIndex) << 24) | 0xff00000ca7;
208 
209       newCatIds[i] = genesisCatId;
210 
211       rescueOrder[rescueIndex] = genesisCatId;
212       rescueIndex++;
213       balanceOf[0x0]++;
214       remainingGenesisCats--;
215 
216       adoptionOffers[genesisCatId] = AdoptionOffer(true, genesisCatId, owner, price, 0x0);
217     }
218     GenesisCatsAdded(newCatIds);
219   }
220 
221 
222   /* aggregate getters */
223 
224   function getCatIds() constant returns (bytes5[]) {
225     bytes5[] memory catIds = new bytes5[](rescueIndex);
226     for (uint i = 0; i < rescueIndex; i++) {
227       catIds[i] = rescueOrder[i];
228     }
229     return catIds;
230   }
231 
232 
233   function getCatNames() constant returns (bytes32[]) {
234     bytes32[] memory names = new bytes32[](rescueIndex);
235     for (uint i = 0; i < rescueIndex; i++) {
236       names[i] = catNames[rescueOrder[i]];
237     }
238     return names;
239   }
240 
241   function getCatOwners() constant returns (address[]) {
242     address[] memory owners = new address[](rescueIndex);
243     for (uint i = 0; i < rescueIndex; i++) {
244       owners[i] = catOwners[rescueOrder[i]];
245     }
246     return owners;
247   }
248 
249   function getCatOfferPrices() constant returns (uint[]) {
250     uint[] memory catOffers = new uint[](rescueIndex);
251     for (uint i = 0; i < rescueIndex; i++) {
252       bytes5 catId = rescueOrder[i];
253       if(adoptionOffers[catId].exists && adoptionOffers[catId].onlyOfferTo == 0x0) {
254         catOffers[i] = adoptionOffers[catId].price;
255       }
256     }
257     return catOffers;
258   }
259 
260   function getCatRequestPrices() constant returns (uint[]) {
261     uint[] memory catRequests = new uint[](rescueIndex);
262     for (uint i = 0; i < rescueIndex; i++) {
263       bytes5 catId = rescueOrder[i];
264       catRequests[i] = adoptionRequests[catId].price;
265     }
266     return catRequests;
267   }
268 
269   function getCatDetails(bytes5 catId) constant returns (bytes5 id,
270                                                          address owner,
271                                                          bytes32 name,
272                                                          address onlyOfferTo,
273                                                          uint offerPrice,
274                                                          address requester,
275                                                          uint requestPrice) {
276 
277     return (catId,
278             catOwners[catId],
279             catNames[catId],
280             adoptionOffers[catId].onlyOfferTo,
281             adoptionOffers[catId].price,
282             adoptionRequests[catId].requester,
283             adoptionRequests[catId].price);
284   }
285 
286   /* modifiers */
287   modifier onlyOwner() {
288     require(msg.sender == owner);
289     _;
290   }
291 
292   modifier inactiveMode() {
293     require(mode == Modes.Inactive);
294     _;
295   }
296 
297   modifier activeMode() {
298     require(mode == Modes.Live || mode == Modes.Test);
299     _;
300   }
301 
302   modifier onlyCatOwner(bytes5 catId) {
303     require(catOwners[catId] == msg.sender);
304     _;
305   }
306 
307   modifier isNotSender(address a) {
308     require(msg.sender != a);
309     _;
310   }
311 
312   /* transfer helper */
313   function transferCat(bytes5 catId, address from, address to, uint price) private {
314     catOwners[catId] = to;
315     balanceOf[from]--;
316     balanceOf[to]++;
317     adoptionOffers[catId] = AdoptionOffer(false, catId, 0x0, 0, 0x0); // cancel any existing adoption offer when cat is transferred
318 
319     AdoptionRequest storage request = adoptionRequests[catId]; //if the recipient has a pending adoption request, cancel it
320     if(request.requester == to) {
321       pendingWithdrawals[to] += request.price;
322       adoptionRequests[catId] = AdoptionRequest(false, catId, 0x0, 0);
323     }
324 
325     pendingWithdrawals[from] += price;
326 
327     Transfer(from, to, 1);
328     CatAdopted(catId, price, from, to);
329   }
330 
331 }