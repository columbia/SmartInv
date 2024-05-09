1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() public {
21         owner = msg.sender;
22     }
23 
24 
25     /**
26      * @dev Throws if called by any account other than the owner.
27      */
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33 
34     /**
35      * @dev Allows the current owner to transfer control of the contract to a newOwner.
36      * @param newOwner The address to transfer ownership to.
37      */
38     function transferOwnership(address newOwner) public onlyOwner {
39         require(newOwner != address(0));
40         OwnershipTransferred(owner, newOwner);
41         owner = newOwner;
42     }
43 
44 }
45 
46 
47 
48 
49 
50 
51 
52 contract FishbankBoosters is Ownable {
53 
54     struct Booster {
55         address owner;
56         uint32 duration;
57         uint8 boosterType;
58         uint24 raiseValue;
59         uint8 strength;
60         uint32 amount;
61     }
62 
63     Booster[] public boosters;
64     bool public implementsERC721 = true;
65     string public name = "Fishbank Boosters";
66     string public symbol = "FISHB";
67     mapping(uint256 => address) public approved;
68     mapping(address => uint256) public balances;
69     address public fishbank;
70     address public chests;
71     address public auction;
72 
73     modifier onlyBoosterOwner(uint256 _tokenId) {
74         require(boosters[_tokenId].owner == msg.sender);
75         _;
76     }
77 
78     modifier onlyChest() {
79         require(chests == msg.sender);
80         _;
81     }
82 
83     function FishbankBoosters() public {
84         //nothing yet
85     }
86 
87     //mints the boosters can only be called by owner. could be a smart contract
88     function mintBooster(address _owner, uint32 _duration, uint8 _type, uint8 _strength, uint32 _amount, uint24 _raiseValue) onlyChest public {
89         boosters.length ++;
90 
91         Booster storage tempBooster = boosters[boosters.length - 1];
92 
93         tempBooster.owner = _owner;
94         tempBooster.duration = _duration;
95         tempBooster.boosterType = _type;
96         tempBooster.strength = _strength;
97         tempBooster.amount = _amount;
98         tempBooster.raiseValue = _raiseValue;
99 
100         Transfer(address(0), _owner, boosters.length - 1);
101     }
102 
103     function setFishbank(address _fishbank) onlyOwner public {
104         fishbank = _fishbank;
105     }
106 
107     function setChests(address _chests) onlyOwner public {
108         if (chests != address(0)) {
109             revert();
110         }
111         chests = _chests;
112     }
113 
114     function setAuction(address _auction) onlyOwner public {
115         auction = _auction;
116     }
117 
118     function getBoosterType(uint256 _tokenId) view public returns (uint8 boosterType) {
119         boosterType = boosters[_tokenId].boosterType;
120     }
121 
122     function getBoosterAmount(uint256 _tokenId) view public returns (uint32 boosterAmount) {
123         boosterAmount = boosters[_tokenId].amount;
124     }
125 
126     function getBoosterDuration(uint256 _tokenId) view public returns (uint32) {
127         if (boosters[_tokenId].boosterType == 4 || boosters[_tokenId].boosterType == 2) {
128             return boosters[_tokenId].duration + boosters[_tokenId].raiseValue * 60;
129         }
130         return boosters[_tokenId].duration;
131     }
132 
133     function getBoosterStrength(uint256 _tokenId) view public returns (uint8 strength) {
134         strength = boosters[_tokenId].strength;
135     }
136 
137     function getBoosterRaiseValue(uint256 _tokenId) view public returns (uint24 raiseValue) {
138         raiseValue = boosters[_tokenId].raiseValue;
139     }
140 
141     //ERC721 functionality
142     //could split this to a different contract but doesn't make it easier to read
143     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
144     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
145 
146     function totalSupply() public view returns (uint256 total) {
147         total = boosters.length;
148     }
149 
150     function balanceOf(address _owner) public view returns (uint256 balance){
151         balance = balances[_owner];
152     }
153 
154     function ownerOf(uint256 _tokenId) public view returns (address owner){
155         owner = boosters[_tokenId].owner;
156     }
157 
158     function _transfer(address _from, address _to, uint256 _tokenId) internal {
159         require(boosters[_tokenId].owner == _from);
160         //can only transfer if previous owner equals from
161         boosters[_tokenId].owner = _to;
162         approved[_tokenId] = address(0);
163         //reset approved of fish on every transfer
164         balances[_from] -= 1;
165         //underflow can only happen on 0x
166         balances[_to] += 1;
167         //overflows only with very very large amounts of fish
168         Transfer(_from, _to, _tokenId);
169     }
170 
171     function transfer(address _to, uint256 _tokenId) public
172     onlyBoosterOwner(_tokenId) //check if msg.sender is the owner of this fish
173     returns (bool)
174     {
175         _transfer(msg.sender, _to, _tokenId);
176         //after master modifier invoke internal transfer
177         return true;
178     }
179 
180     function approve(address _to, uint256 _tokenId) public
181     onlyBoosterOwner(_tokenId)
182     {
183         approved[_tokenId] = _to;
184         Approval(msg.sender, _to, _tokenId);
185     }
186 
187     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {
188         require(approved[_tokenId] == msg.sender || msg.sender == fishbank || msg.sender == auction);
189         //require msg.sender to be approved for this token or to be the fishbank contract
190         _transfer(_from, _to, _tokenId);
191         //handles event, balances and approval reset
192         return true;
193     }
194 
195 
196     function takeOwnership(uint256 _tokenId) public {
197         require(approved[_tokenId] == msg.sender);
198         _transfer(ownerOf(_tokenId), msg.sender, _tokenId);
199     }
200 
201 
202 }
203 
204 
205 contract FishbankChests is Ownable {
206 
207     struct Chest {
208         address owner;
209         uint16 boosters;
210         uint16 chestType;
211         uint24 raiseChance;//Increace chance to catch bigger chest (1 = 1:10000)
212         uint8 onlySpecificType;
213         uint8 onlySpecificStrength;
214         uint24 raiseStrength;
215     }
216 
217     Chest[] public chests;
218     FishbankBoosters public boosterContract;
219     mapping(uint256 => address) public approved;
220     mapping(address => uint256) public balances;
221     mapping(address => bool) public minters;
222 
223     modifier onlyChestOwner(uint256 _tokenId) {
224         require(chests[_tokenId].owner == msg.sender);
225         _;
226     }
227 
228     modifier onlyMinters() {
229         require(minters[msg.sender]);
230         _;
231     }
232 
233     function FishbankChests(address _boosterAddress) public {
234         boosterContract = FishbankBoosters(_boosterAddress);
235     }
236 
237     function addMinter(address _minter) onlyOwner public {
238         minters[_minter] = true;
239     }
240 
241     function removeMinter(address _minter) onlyOwner public {
242         minters[_minter] = false;
243     }
244 
245     //create a chest
246 
247     function mintChest(address _owner, uint16 _boosters, uint24 _raiseStrength, uint24 _raiseChance, uint8 _onlySpecificType, uint8 _onlySpecificStrength) onlyMinters public {
248 
249         chests.length++;
250         chests[chests.length - 1].owner = _owner;
251         chests[chests.length - 1].boosters = _boosters;
252         chests[chests.length - 1].raiseStrength = _raiseStrength;
253         chests[chests.length - 1].raiseChance = _raiseChance;
254         chests[chests.length - 1].onlySpecificType = _onlySpecificType;
255         chests[chests.length - 1].onlySpecificStrength = _onlySpecificStrength;
256         Transfer(address(0), _owner, chests.length - 1);
257     }
258 
259     function convertChest(uint256 _tokenId) onlyChestOwner(_tokenId) public {
260 
261         Chest memory chest = chests[_tokenId];
262         uint16 numberOfBoosters = chest.boosters;
263 
264         if (chest.onlySpecificType != 0) {//Specific boosters
265             if (chest.onlySpecificType == 1 || chest.onlySpecificType == 3) {
266                 boosterContract.mintBooster(msg.sender, 2 days, chest.onlySpecificType, chest.onlySpecificStrength, chest.boosters, chest.raiseStrength);
267             } else if (chest.onlySpecificType == 5) {//Instant attack
268                 boosterContract.mintBooster(msg.sender, 0, 5, 1, chest.boosters, chest.raiseStrength);
269             } else if (chest.onlySpecificType == 2) {//Freeze
270                 uint32 freezeTime = 7 days;
271                 if (chest.onlySpecificStrength == 2) {
272                     freezeTime = 14 days;
273                 } else if (chest.onlySpecificStrength == 3) {
274                     freezeTime = 30 days;
275                 }
276                 boosterContract.mintBooster(msg.sender, freezeTime, 5, chest.onlySpecificType, chest.boosters, chest.raiseStrength);
277             } else if (chest.onlySpecificType == 4) {//Watch
278                 uint32 watchTime = 12 hours;
279                 if (chest.onlySpecificStrength == 2) {
280                     watchTime = 48 hours;
281                 } else if (chest.onlySpecificStrength == 3) {
282                     watchTime = 3 days;
283                 }
284                 boosterContract.mintBooster(msg.sender, watchTime, 4, chest.onlySpecificStrength, chest.boosters, chest.raiseStrength);
285             }
286 
287         } else {//Regular chest
288 
289             for (uint8 i = 0; i < numberOfBoosters; i ++) {
290                 uint24 random = uint16(keccak256(block.coinbase, block.blockhash(block.number - 1), i, chests.length)) % 1000
291                 - chest.raiseChance;
292                 //get random 0 - 9999 minus raiseChance
293 
294                 if (random > 850) {
295                     boosterContract.mintBooster(msg.sender, 2 days, 1, 1, 1, chest.raiseStrength); //Small Agility Booster
296                 } else if (random > 700) {
297                     boosterContract.mintBooster(msg.sender, 7 days, 2, 1, 1, chest.raiseStrength); //Small Freezer
298                 } else if (random > 550) {
299                     boosterContract.mintBooster(msg.sender, 2 days, 3, 1, 1, chest.raiseStrength); //Small Power Booster
300                 } else if (random > 400) {
301                     boosterContract.mintBooster(msg.sender, 12 hours, 4, 1, 1, chest.raiseStrength); //Tiny Watch
302                 } else if (random > 325) {
303                     boosterContract.mintBooster(msg.sender, 48 hours, 4, 2, 1, chest.raiseStrength); //Small Watch
304                 } else if (random > 250) {
305                     boosterContract.mintBooster(msg.sender, 2 days, 1, 2, 1, chest.raiseStrength); //Mid Agility Booster
306                 } else if (random > 175) {
307                     boosterContract.mintBooster(msg.sender, 14 days, 2, 2, 1, chest.raiseStrength); //Mid Freezer
308                 } else if (random > 100) {
309                     boosterContract.mintBooster(msg.sender, 2 days, 3, 2, 1, chest.raiseStrength); //Mid Power Booster
310                 } else if (random > 80) {
311                     boosterContract.mintBooster(msg.sender, 2 days, 1, 3, 1, chest.raiseStrength); //Big Agility Booster
312                 } else if (random > 60) {
313                     boosterContract.mintBooster(msg.sender, 30 days, 2, 3, 1, chest.raiseStrength); //Big Freezer
314                 } else if (random > 40) {
315                     boosterContract.mintBooster(msg.sender, 2 days, 3, 3, 1, chest.raiseStrength); //Big Power Booster
316                 } else if (random > 20) {
317                     boosterContract.mintBooster(msg.sender, 0, 5, 1, 1, 0); //Instant Attack
318                 } else {
319                     boosterContract.mintBooster(msg.sender, 3 days, 4, 3, 1, 0); //Gold Watch
320                 }
321             }
322         }
323 
324         _transfer(msg.sender, address(0), _tokenId); //burn chest
325     }
326 
327     //ERC721 functionality
328     //could split this to a different contract but doesn't make it easier to read
329     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     function totalSupply() public view returns (uint256 total) {
333         total = chests.length;
334     }
335 
336     function balanceOf(address _owner) public view returns (uint256 balance){
337         balance = balances[_owner];
338     }
339 
340     function ownerOf(uint256 _tokenId) public view returns (address owner){
341         owner = chests[_tokenId].owner;
342     }
343 
344     function _transfer(address _from, address _to, uint256 _tokenId) internal {
345         require(chests[_tokenId].owner == _from); //can only transfer if previous owner equals from
346         chests[_tokenId].owner = _to;
347         approved[_tokenId] = address(0); //reset approved of fish on every transfer
348         balances[_from] -= 1; //underflow can only happen on 0x
349         balances[_to] += 1; //overflows only with very very large amounts of fish
350         Transfer(_from, _to, _tokenId);
351     }
352 
353     function transfer(address _to, uint256 _tokenId) public
354     onlyChestOwner(_tokenId) //check if msg.sender is the owner of this fish
355     returns (bool)
356     {
357         _transfer(msg.sender, _to, _tokenId);
358         //after master modifier invoke internal transfer
359         return true;
360     }
361 
362     function approve(address _to, uint256 _tokenId) public
363     onlyChestOwner(_tokenId)
364     {
365         approved[_tokenId] = _to;
366         Approval(msg.sender, _to, _tokenId);
367     }
368 
369     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) {
370         require(approved[_tokenId] == msg.sender);
371         //require msg.sender to be approved for this token
372         _transfer(_from, _to, _tokenId);
373         //handles event, balances and approval reset
374         return true;
375     }
376 
377 }