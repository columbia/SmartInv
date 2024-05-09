1 pragma solidity ^0.4.19;
2 contract AccessControl {
3     address public owner;
4     // address[] public moderators;
5     uint16 public totalModerators = 0;
6     mapping (address => bool) public moderators;
7     bool public isMaintaining = false;
8 
9     function AccessControl() public {
10         owner = msg.sender;
11         moderators[msg.sender] = true;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     modifier onlyModerators() {
20         require(moderators[msg.sender] == true);
21         _;
22     }
23 
24     modifier isActive {
25         require(!isMaintaining);
26         _;
27     }
28 
29     function ChangeOwner(address _newOwner) onlyOwner public {
30         if (_newOwner != address(0)) {
31             owner = _newOwner;
32         }
33     }
34 
35     function AddModerator(address _newModerator) onlyOwner public {
36         if (moderators[_newModerator] == false) {
37             moderators[_newModerator] = true;
38             totalModerators += 1;
39         }
40     }
41 
42     function RemoveModerator(address _oldModerator) onlyOwner public {
43         if (moderators[_oldModerator] == true) {
44             moderators[_oldModerator] = false;
45             totalModerators -= 1;
46         }
47     }
48 
49     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
50         isMaintaining = _isMaintaining;
51     }
52 }
53 
54 contract DTT is AccessControl{
55   function approve(address _spender, uint256 _value) public returns (bool success);
56   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
57   function balanceOf(address _addr) public returns (uint);
58   mapping (address => mapping (address => uint256)) public allowance;
59 }
60 
61 contract DataBase is AccessControl{
62   function addMonsterObj(uint64 _monsterId,uint256 _genes,uint32 _classId,address _master,string _name,string _skills) public;
63   function getTotalMonster() constant public returns(uint64);
64   function setMonsterGene(uint64 _monsterId,uint256 _genes) public;
65 }
66 contract NFTToken is AccessControl{
67   function transferAuction(address _from, address _to, uint256 _value) external;
68   function ownerOf(uint256 _tokenId) public constant returns (address owner);
69 }
70 
71 contract CryptoAndDragonsAuction is AccessControl{
72   event Bought (uint256 indexed _itemId, address indexed _owner, uint256 _price);
73   event Sold (uint256 indexed _itemId, address indexed _owner, uint256 _price);
74   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
75   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
76   event Hatch(address indexed _owner, uint16 _tableId);
77 
78   address public thisAddress;
79   address public dragonTreasureToken;
80   address public databaseContract;
81   address public ERC721Contract;
82 
83   uint256 public totalAuction;
84   uint256 private increaseRate = 0.1 ether;
85 
86   mapping (address => address) public masterToReferral;
87 
88   function setNewMonster(uint256 _genes,uint32 _classId,address _master,string _name,string _skills) onlyModerators public returns(uint64 _monsterId) {
89     DataBase data = DataBase(databaseContract);
90     uint64 monsterId = data.getTotalMonster() + 1;
91     data.addMonsterObj(monsterId,_genes,_classId,_master,_name,_skills);
92     return monsterId;
93   }
94   function setMasterToReferral(address _master, address _referral) onlyOwner public{
95     masterToReferral[_master] = _referral;
96   }
97 
98   function setAddresses(address _dragonTreasureToken,address _databaseContract,address _ERC721Contract) onlyOwner public{
99     dragonTreasureToken = _dragonTreasureToken;
100     databaseContract = _databaseContract;
101     ERC721Contract = _ERC721Contract;
102   }
103 
104   struct Auction {
105     uint256 classId;
106     uint256 monsterId;
107     uint256 price;
108     uint256 endTime;
109     uint8 rarity;
110     address bidder;
111   }
112   Auction[] public auctions;
113 
114 
115   uint randNonce = 0;
116   function randMod(uint _modulus) internal returns(uint) {
117     randNonce++;
118     return uint(keccak256(now, msg.sender, randNonce)) % _modulus;
119   }
120 
121 
122   function getSortedArray(uint[] storageInt) public pure returns(uint[]) {
123       uint[] memory a = getCloneArray(storageInt);
124       quicksort(a);
125       return a;
126   }
127   function getCloneArray(uint[] a) private pure returns(uint[]) {
128       return a;
129   }
130   function swap(uint[] a, uint l, uint r) private pure {
131       uint t = a[l];
132       a[l] = a[r];
133       a[r] = t;
134   }
135   function getPivot(uint a, uint b, uint c) private pure returns(uint) {
136       if(a > b){
137           if(b > c){
138               return b;
139           }else{
140               return a > c ? c : a ;
141           }
142       }else{
143           if(a > c){
144               return a;
145           }else{
146               return b > c ? c : b ;
147           }
148       }
149   }
150   function quicksort(uint[] a) private pure {
151       uint left = 0;
152       uint right = a.length - 1;
153       quicksort_core(a, left, right);
154   }
155   function quicksort_core(uint[] a, uint left, uint right) private pure {
156       if(right <= left){
157           return;
158       }
159       uint l = left;
160       uint r = right;
161       uint p = getPivot(a[l], a[l+1], a[r]);
162       while(true){
163           while(a[l] < p){
164               l++;
165           }
166           while(p < a[r]){
167               r--;
168           }
169           if(r <= l){
170               break;
171           }
172           swap(a, l, r);
173           l++;
174           r--;
175       }
176       quicksort_core(a, left, l-1);
177       quicksort_core(a, r+1, right);
178   }
179 
180   /* Withdraw */
181   /*
182     NOTICE: These functions withdraw the developer's cut which is left
183     in the contract by `buy`. User funds are immediately sent to the old
184     owner in `buy`, no user funds are left in the contract.
185   */
186   function withdrawAll () onlyOwner public {
187     msg.sender.transfer(this.balance);
188   }
189 
190   function withdrawAmount (uint256 _amount) onlyOwner public {
191     msg.sender.transfer(_amount);
192   }
193 
194 
195   function addAuction(uint32 _classId, uint256 _monsterId, uint256 _price, uint8 _rarity, uint32 _endTime) onlyOwner public {
196     Auction memory auction = Auction({
197       classId: _classId,
198       monsterId: _monsterId,
199       price: _price,
200       rarity: _rarity,
201       endTime: _endTime + now,
202       bidder: msg.sender
203     });
204     auctions.push(auction);
205     totalAuction += 1;
206   }
207 
208   function burnAuction() onlyOwner external {
209     uint256 counter = 0;
210     for (uint256 i = 0; i < totalAuction; i++) {
211       if(auctions[i].endTime < now - 86400 * 3){
212         delete auctions[i];
213         counter++;
214       }
215     }
216     totalAuction -= counter;
217   }
218 
219   /* Buying */
220 
221   function ceil(uint a) public pure returns (uint ) {
222     return uint(int(a * 100) / 100);
223   }
224   /*
225      Buy a country directly from the contract for the calculated price
226      which ensures that the owner gets a profit.  All countries that
227      have been listed can be bought by this method. User funds are sent
228      directly to the previous owner and are never stored in the contract.
229   */
230   function setGenes(uint256 _price, uint256 _monsterId) internal{
231     DataBase data = DataBase(databaseContract);
232     uint256 gene = _price / 100000000000000000;
233     if(gene > 255)
234       gene = 255;
235     uint256 genes = 0;
236     genes += gene * 1000000000000000;
237     genes += gene * 1000000000000;
238     genes += gene * 1000000000;
239     genes += gene * 1000000;
240     genes += gene * 1000;
241     genes += gene;
242     if(genes > 255255255255255255)
243       genes = 255255255255255255;
244     data.setMonsterGene(uint64(_monsterId),genes);
245   }
246 
247   function buy (uint256 _auctionId, address _referral) payable public {
248     NFTToken CNDERC721 = NFTToken(ERC721Contract);
249     require(auctions[_auctionId].endTime > now);
250     require(CNDERC721.ownerOf(auctions[_auctionId].monsterId) != address(0));
251     require(ceil(msg.value) >= ceil(auctions[_auctionId].price + increaseRate));
252     require(CNDERC721.ownerOf(auctions[_auctionId].monsterId) != msg.sender);
253     require(!isContract(msg.sender));
254     require(msg.sender != address(0));
255     address oldOwner = CNDERC721.ownerOf(auctions[_auctionId].monsterId);
256     address newOwner = msg.sender;
257     uint256 oldPrice = auctions[_auctionId].price;
258     uint256 price = ceil(msg.value);
259     setGenes(price,auctions[_auctionId].monsterId);
260     CNDERC721.transferAuction(oldOwner, newOwner, auctions[_auctionId].monsterId);
261     auctions[_auctionId].price = ceil(price);
262     auctions[_auctionId].bidder = msg.sender;
263     DTT DTTtoken = DTT(dragonTreasureToken);
264     if(masterToReferral[msg.sender] != address(0) && masterToReferral[msg.sender] != msg.sender){
265       DTTtoken.approve(masterToReferral[msg.sender], DTTtoken.allowance(this,masterToReferral[msg.sender]) + (price - oldPrice) / 1000000000 * 5);
266     }else if(_referral != address(0) && _referral != msg.sender){
267       masterToReferral[msg.sender] = _referral;
268       DTTtoken.approve(_referral, DTTtoken.allowance(this,_referral) + (price - oldPrice) / 1000000000 * 5);
269     }
270 
271     DTTtoken.approve(msg.sender, DTTtoken.allowance(this,msg.sender) + (price - oldPrice) / 1000000000 * 5);
272     if(oldPrice > 0)
273       oldOwner.transfer(oldPrice);
274     Bought(auctions[_auctionId].monsterId, newOwner, price);
275     Sold(auctions[_auctionId].monsterId, oldOwner, price);
276   }
277 
278   function monstersForSale (uint8 optSort) external view returns (uint256[] _monsters){
279     uint256[] memory mcount = new uint256[](totalAuction);
280     uint256 counter = 0;
281     for (uint256 i = 0; i < totalAuction; i++) {
282         mcount[counter] = i;
283         counter++;
284     }
285     if(optSort != 0){
286       sortAuction(mcount);
287     }
288     return mcount;
289   }
290   function sortAuction (uint256[] _mcount) public view returns (uint256[] _monsters){
291     uint256[] memory mcount = new uint256[](_mcount.length);
292     for(uint256 i = 0; i < _mcount.length; i++){
293       mcount[i] = auctions[i].price * 10000000000 + i;
294     }
295     uint256[] memory tmps = getSortedArray(_mcount);
296     uint256[] memory result = new uint256[](tmps.length);
297     for(uint256 i2 = 0; i2 < tmps.length; i2++){
298       result[i2] = tmps[i2] % 10000000000;
299     }
300     return result;
301   }
302 
303   /* Util */
304   function isContract(address addr) internal view returns (bool) {
305     uint size;
306     assembly { size := extcodesize(addr) } // solium-disable-line
307     return size > 0;
308   }
309 }