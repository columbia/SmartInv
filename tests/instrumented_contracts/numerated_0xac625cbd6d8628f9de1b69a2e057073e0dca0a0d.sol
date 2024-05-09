1 pragma solidity ^0.4.19;
2 
3 contract AccessControl {
4     address public owner;
5     // address[] public moderators;
6     uint16 public totalModerators = 0;
7     mapping (address => bool) public moderators;
8     bool public isMaintaining = false;
9 
10     function AccessControl() public {
11         owner = msg.sender;
12         moderators[msg.sender] = true;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     modifier onlyModerators() {
21         require(moderators[msg.sender] == true);
22         _;
23     }
24 
25     modifier isActive {
26         require(!isMaintaining);
27         _;
28     }
29 
30     function ChangeOwner(address _newOwner) onlyOwner public {
31         if (_newOwner != address(0)) {
32             owner = _newOwner;
33         }
34     }
35 
36     function AddModerator(address _newModerator) onlyOwner public {
37         if (moderators[_newModerator] == false) {
38             moderators[_newModerator] = true;
39             totalModerators += 1;
40         }
41     }
42 
43     function RemoveModerator(address _oldModerator) onlyOwner public {
44         if (moderators[_oldModerator] == true) {
45             moderators[_oldModerator] = false;
46             totalModerators -= 1;
47         }
48     }
49 
50     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
51         isMaintaining = _isMaintaining;
52     }
53 }
54 
55 contract DTT is AccessControl{
56   function approve(address _spender, uint256 _value) public returns (bool success);
57   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
58   function balanceOf(address _addr) public returns (uint);
59   mapping (address => mapping (address => uint256)) public allowance;
60 }
61 
62 contract DataBase is AccessControl{
63   function addMonsterObj(uint64 _monsterId,uint256 _genes,uint32 _classId,address _master,string _name,string _skills) public;
64   function getTotalMonster() constant public returns(uint64);
65   function setMonsterGene(uint64 _monsterId,uint256 _genes) public;
66 }
67 contract NFTToken is AccessControl{
68   function transferAuction(address _from, address _to, uint256 _value) external;
69   function ownerOf(uint256 _tokenId) public constant returns (address owner);
70 }
71 
72 contract CryptoAndDragonsPresale is AccessControl{
73   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
74   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
75   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
76   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
77   event Hatch(address indexed _owner, uint16 _tableId);
78 
79   address public thisAddress;
80   address public dragonTreasureToken;
81   address public databaseContract;
82   address public ERC721Contract;
83   uint256 public totalClass;
84   uint256 public totalMonster;
85   uint256 public totalAuction;
86   uint256 private increaseRate = 0.1 ether;
87   uint64 public cooldownTime = 2 hours;
88   mapping (address => address) public masterToReferral;
89   mapping (uint16 => uint32[]) private EggTable;
90   mapping (uint8 => uint256) public EggTotal;
91   function setNewMonster(uint256 _genes,uint32 _classId,address _master,string _name,string _skills) onlyModerators public returns(uint64 _monsterId) {
92     DataBase data = DataBase(databaseContract);
93     uint64 monsterId = data.getTotalMonster() + 1;
94     data.addMonsterObj(monsterId,_genes,_classId,_master,_name,_skills);
95     return monsterId;
96   }
97   function setMasterToReferral(address _master, address _referral) onlyOwner public{
98     masterToReferral[_master] = _referral;
99   }
100   function setEggTotal(uint8 _tableNum,uint256 _tableVal) onlyOwner public{
101     EggTotal[_tableNum] = _tableVal;
102   }
103   function setAddresses(address _dragonTreasureToken,address _databaseContract,address _ERC721Contract) onlyOwner public{
104     dragonTreasureToken = _dragonTreasureToken;
105     databaseContract = _databaseContract;
106     ERC721Contract = _ERC721Contract;
107   }
108   function setEggTable(uint16 _tableNum,uint32[] _tableVals) onlyOwner public{
109     EggTable[_tableNum] = _tableVals;
110   }
111   function userWithdraw(uint256 _value) public{
112     DTT DTTtoken = DTT(dragonTreasureToken);
113     DTTtoken.transferFrom(this,msg.sender,_value);
114   }
115 
116   struct Egg {
117     uint8 tableId;
118     uint32 classId;
119     uint256 genes;
120     uint256 hatchTime;
121     uint32 matronId;
122     uint32 sireId;
123     uint16 generation;
124     address master;
125   }
126 
127   struct Auction {
128     uint256 classId;
129     uint256 monsterId;
130     uint256 price;
131     uint256 endTime;
132     uint8 rarity;
133     address bidder;
134   }
135 
136   Egg[] public eggs;
137   Auction[] public auctions;
138 
139 
140   uint randNonce = 0;
141   function randMod(uint _modulus) internal returns(uint) {
142     randNonce++;
143     return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
144   }
145 
146   function setCooldown(uint64 _time) onlyOwner public{
147     cooldownTime = _time;
148   }
149 
150   function getSortedArray(uint[] storageInt) public pure returns(uint[]) {
151       uint[] memory a = getCloneArray(storageInt);
152       quicksort(a);
153       return a;
154   }
155   function getCloneArray(uint[] a) private pure returns(uint[]) {
156       return a;
157   }
158   function swap(uint[] a, uint l, uint r) private pure {
159       uint t = a[l];
160       a[l] = a[r];
161       a[r] = t;
162   }
163   function getPivot(uint a, uint b, uint c) private pure returns(uint) {
164       if(a > b){
165           if(b > c){
166               return b;
167           }else{
168               return a > c ? c : a ;
169           }
170       }else{
171           if(a > c){
172               return a;
173           }else{
174               return b > c ? c : b ;
175           }
176       }
177   }
178   function quicksort(uint[] a) private pure {
179       uint left = 0;
180       uint right = a.length - 1;
181       quicksort_core(a, left, right);
182   }
183   function quicksort_core(uint[] a, uint left, uint right) private pure {
184       if(right <= left){
185           return;
186       }
187       uint l = left;
188       uint r = right;
189       uint p = getPivot(a[l], a[l+1], a[r]);
190       while(true){
191           while(a[l] < p){
192               l++;
193           }
194           while(p < a[r]){
195               r--;
196           }
197           if(r <= l){
198               break;
199           }
200           swap(a, l, r);
201           l++;
202           r--;
203       }
204       quicksort_core(a, left, l-1);
205       quicksort_core(a, r+1, right);
206   }
207 
208   /* Withdraw */
209   /*
210     NOTICE: These functions withdraw the developer's cut which is left
211     in the contract by `buy`. User funds are immediately sent to the old
212     owner in `buy`, no user funds are left in the contract.
213   */
214   function withdrawAll () onlyOwner public {
215     msg.sender.transfer(this.balance);
216   }
217 
218   function withdrawAmount (uint256 _amount) onlyOwner public {
219     msg.sender.transfer(_amount);
220   }
221 
222 
223   function addAuction(uint32 _classId, uint256 _monsterId, uint256 _price, uint8 _rarity, uint8 _endTime) onlyOwner public {
224     Auction memory auction = Auction({
225       classId: _classId,
226       monsterId: _monsterId,
227       price: _price,
228       rarity: _rarity,
229       endTime: 86400 * _endTime + now,
230       bidder: msg.sender
231     });
232     auctions.push(auction);
233     totalAuction += 1;
234   }
235 
236   function burnAuction() onlyOwner external {
237     uint256 counter = 0;
238     for (uint256 i = 0; i < totalAuction; i++) {
239       if(auctions[i].endTime < now - 86400 * 3){
240         delete auctions[i];
241         counter++;
242       }
243     }
244     totalAuction -= counter;
245   }
246 
247   /* Buying */
248 
249   function ceil(uint a) public pure returns (uint ) {
250     return uint(int(a * 100) / 100);
251   }
252   /*
253      Buy a country directly from the contract for the calculated price
254      which ensures that the owner gets a profit.  All countries that
255      have been listed can be bought by this method. User funds are sent
256      directly to the previous owner and are never stored in the contract.
257   */
258   function setGenes(uint256 _price, uint256 _monsterId) internal{
259     DataBase data = DataBase(databaseContract);
260     uint256 gene = _price / 10000000000000000;
261     if(gene > 255)
262       gene = 255;
263     uint256 genes = 0;
264     genes += gene * 1000000000000000;
265     genes += gene * 1000000000000;
266     genes += gene * 1000000000;
267     genes += gene * 1000000;
268     genes += gene * 1000;
269     genes += gene;
270     if(genes > 255255255255255255)
271       genes = 255255255255255255;
272     data.setMonsterGene(uint64(_monsterId),genes);
273   }
274 
275   function buy (uint256 _auctionId, address _referral) payable public {
276     NFTToken CNDERC721 = NFTToken(ERC721Contract);
277     require(auctions[_auctionId].endTime > now);
278     require(CNDERC721.ownerOf(auctions[_auctionId].monsterId) != address(0));
279     require(ceil(msg.value) >= ceil(auctions[_auctionId].price + increaseRate));
280     require(CNDERC721.ownerOf(auctions[_auctionId].monsterId) != msg.sender);
281     require(!isContract(msg.sender));
282     require(msg.sender != address(0));
283     address oldOwner = CNDERC721.ownerOf(auctions[_auctionId].monsterId);
284     address newOwner = msg.sender;
285     uint256 oldPrice = auctions[_auctionId].price;
286     uint256 price = ceil(msg.value);
287     setGenes(price,auctions[_auctionId].monsterId);
288     CNDERC721.transferAuction(oldOwner, newOwner, auctions[_auctionId].monsterId);
289     auctions[_auctionId].price = ceil(price);
290     auctions[_auctionId].bidder = msg.sender;
291     DTT DTTtoken = DTT(dragonTreasureToken);
292     if(masterToReferral[msg.sender] != address(0) && masterToReferral[msg.sender] != msg.sender){
293       DTTtoken.approve(masterToReferral[msg.sender], DTTtoken.allowance(this,masterToReferral[msg.sender]) + price / 1000000000 * 5);
294     }else if(_referral != address(0) && _referral != msg.sender){
295       masterToReferral[msg.sender] = _referral;
296       DTTtoken.approve(_referral, DTTtoken.allowance(this,_referral) + price / 1000000000 * 5);
297     }
298 
299     DTTtoken.approve(msg.sender, DTTtoken.allowance(this,msg.sender) + price / 1000000000 * 5);
300     if(oldPrice > 0)
301       oldOwner.transfer(oldPrice);
302     Bought(auctions[_auctionId].monsterId, newOwner, price);
303     Sold(auctions[_auctionId].monsterId, oldOwner, price);
304   }
305 
306   function buyBlueStarEgg(address _sender, uint256 _tokens, uint16 _amount) isActive public returns(uint256) {
307     require(_amount <= 10 && _amount > 0);
308     uint256 price = ceil(5 * 10**8);
309     if (_tokens < price)
310         revert();
311     DataBase data = DataBase(databaseContract);
312     for (uint8 i = 0; i < _amount; i++) {
313       uint256 genes = 0;
314       genes += (randMod(205) + 51) * 1000000000000000;
315       genes += (randMod(205) + 51) * 1000000000000;
316       genes += (randMod(205) + 51) * 1000000000;
317       genes += (randMod(205) + 51) * 1000000;
318       genes += (randMod(205) + 51) * 1000;
319       genes += randMod(205) + 51;
320       uint32 classId = EggTable[1][randMod(EggTable[1].length)];
321       EggTotal[1] += 1;
322       uint64 monsterId = data.getTotalMonster() + 1;
323       data.addMonsterObj(monsterId,genes,classId,_sender,"","");
324     }
325     Hatch(msg.sender, 1);
326     return price * _amount;
327   }
328 
329   function buyRareEgg(uint8 _table, uint _amount, address _referral) isActive payable public {
330     require(_amount <= 10 && _amount > 0);
331     uint256 price = 0.1 ether;
332     if(EggTotal[_table] > 0)
333     price += uint((int(EggTotal[_table] / 500) * 10**18) / 20);
334     require(msg.value >= price * _amount);
335 
336     DTT DTTtoken = DTT(dragonTreasureToken);
337     DataBase data = DataBase(databaseContract);
338     uint256 bonus = 10;
339     if(_amount >= 10){
340       bonus = 12;
341     }
342     if(masterToReferral[msg.sender] != address(0) && masterToReferral[msg.sender] != msg.sender){
343       DTTtoken.approve(masterToReferral[msg.sender], DTTtoken.allowance(this,masterToReferral[msg.sender]) + price / 10000000000 * 5 * bonus * _amount);
344     }else if(_referral != address(0) && _referral != msg.sender){
345       masterToReferral[msg.sender] = _referral;
346       DTTtoken.approve(_referral, DTTtoken.allowance(this,_referral) + price / 10000000000 * 5 * bonus * _amount);
347     }
348 
349     DTTtoken.approve(msg.sender, DTTtoken.allowance(this,msg.sender) + price / 10000000000 * 5 * bonus * _amount);
350     for (uint8 i = 0; i < _amount; i++) {
351       uint256 genes = 0;
352       genes += (randMod(155) + 101) * 1000000000000000;
353       genes += (randMod(155) + 101) * 1000000000000;
354       genes += (randMod(155) + 101) * 1000000000;
355       genes += (randMod(155) + 101) * 1000000;
356       genes += (randMod(155) + 101) * 1000;
357       genes += randMod(155) + 101;
358       uint32 classId = EggTable[_table][randMod(EggTable[_table].length)];
359       EggTotal[_table] += 1;
360       uint64 monsterId = data.getTotalMonster() + 1;
361       data.addMonsterObj(monsterId,genes,classId,msg.sender,"","");
362     }
363     Hatch(msg.sender, _table);
364   }
365 
366   function hatchEgg(uint256 _eggId, string _name) public{
367     require(eggs[_eggId].hatchTime <= now);
368     require(eggs[_eggId].classId != 0 && eggs[_eggId].master == msg.sender);
369     DataBase CNDDB = DataBase(databaseContract);
370     uint64 monsterId = CNDDB.getTotalMonster() + 1;
371     string memory skills = "0:0:0:0";
372     CNDDB.addMonsterObj(monsterId,eggs[_eggId].genes,eggs[_eggId].classId,msg.sender,_name,skills);
373     eggs[_eggId].classId = 0;
374     eggs[_eggId].master = address(0);
375   }
376 
377   function monstersForSale (uint8 optSort) external view returns (uint256[] _monsters){
378     uint256[] memory mcount = new uint256[](totalAuction);
379     uint256 counter = 0;
380     for (uint256 i = 0; i < totalAuction; i++) {
381         mcount[counter] = i;
382         counter++;
383     }
384     if(optSort != 0){
385       sortAuction(mcount);
386     }
387     return mcount;
388   }
389   function sortAuction (uint256[] _mcount) public view returns (uint256[] _monsters){
390     uint256[] memory mcount = new uint256[](_mcount.length);
391     for(uint256 i = 0; i < _mcount.length; i++){
392       mcount[i] = auctions[i].price * 10000000000 + i;
393     }
394     uint256[] memory tmps = getSortedArray(_mcount);
395     uint256[] memory result = new uint256[](tmps.length);
396     for(uint256 i2 = 0; i2 < tmps.length; i2++){
397       result[i2] = tmps[i2] % 10000000000;
398     }
399     return result;
400   }
401 
402   /* Util */
403   function isContract(address addr) internal view returns (bool) {
404     uint size;
405     assembly { size := extcodesize(addr) } // solium-disable-line
406     return size > 0;
407   }
408 }