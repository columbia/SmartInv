1 pragma solidity ^0.4.18;
2 
3 contract AccessControl {
4   address public owner;
5   address[] public admins;
6 
7   modifier onlyOwner {
8     require(msg.sender == owner);
9     _;
10   }
11 
12   modifier onlyAdmins {
13     bool found = false;
14 
15     for (uint i = 0; i < admins.length; i++) {
16       if (admins[i] == msg.sender) {
17         found = true;
18         break;
19       }
20     }
21 
22     require(found);
23     _;
24   }
25 
26   function addAdmin(address _adminAddress) public onlyOwner {
27     admins.push(_adminAddress);
28   }
29 }
30 
31 contract ERC721 {
32     // Required Functions
33     function implementsERC721() public pure returns (bool);
34     function totalSupply() public view returns (uint256);
35     function balanceOf(address _owner) public view returns (uint256);
36     function ownerOf(uint256 _tokenId) public view returns (address);
37     function transfer(address _to, uint _tokenId) public;
38     function approve(address _to, uint256 _tokenId) public;
39     function transferFrom(address _from, address _to, uint256 _tokenId) public;
40 
41     // Optional Functions
42     function name() public pure returns (string);
43     function symbol() public pure returns (string);
44     function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256);
45     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
46 
47     // Required Events
48     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 }
51 
52 contract TulipBase is AccessControl {
53   struct Tulip {
54     uint256 genes;
55     uint256 createTime;
56     bytes32 name;
57   }
58 
59   Tulip[] public tulips;
60   mapping (uint256 => address) public tulipToOwner;
61   mapping (address => uint256[]) internal ownerToTulips;
62   mapping (uint256 => address) public tulipToApproved;
63 
64   function _generateTulip(bytes32 _name, address _owner, uint16 _gen) internal returns (uint256 id) {
65     id = tulips.length;
66     uint256 createTime = block.timestamp;
67 
68     // Insecure RNG, but good enough for our purposes
69     uint256 seed = uint(block.blockhash(block.number - 1)) + uint(block.blockhash(block.number - 100))
70       + uint(block.coinbase) + createTime + id;
71     uint256 traits = uint256(keccak256(seed));
72     // last 16 bits are generation number
73     uint256 genes = traits / 0x10000 * 0x10000 + _gen;
74 
75     Tulip memory newTulip = Tulip(genes, createTime, _name);
76     tulips.push(newTulip);
77     tulipToOwner[id] = _owner;
78     ownerToTulips[_owner].push(id);
79   }
80 
81   function _transferTulip(address _from, address _to, uint256 _id) internal {
82     tulipToOwner[_id] = _to;
83     ownerToTulips[_to].push(_id);
84     tulipToApproved[_id] = address(0);
85 
86     uint256[] storage fromTulips = ownerToTulips[_from];
87     for (uint256 i = 0; i < fromTulips.length; i++) {
88       if (fromTulips[i] == _id) {
89         break;
90       }
91     }
92     assert(i < fromTulips.length);
93 
94     fromTulips[i] = fromTulips[fromTulips.length - 1];
95     delete fromTulips[fromTulips.length - 1];
96     fromTulips.length--;
97   }
98 }
99 
100 contract TulipToken is TulipBase, ERC721 {
101 
102   function implementsERC721() public pure returns (bool) {
103     return true;
104   }
105 
106   function totalSupply() public view returns (uint256) {
107     return tulips.length;
108   }
109 
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return ownerToTulips[_owner].length;
112   }
113 
114   function ownerOf(uint256 _tokenId) public view returns (address owner) {
115     owner = tulipToOwner[_tokenId];
116     require(owner != address(0));
117   }
118 
119   function transfer(address _to, uint256 _tokenId) public {
120     require(_to != address(0));
121     require(tulipToOwner[_tokenId] == msg.sender);
122 
123     _transferTulip(msg.sender, _to, _tokenId);
124     Transfer(msg.sender, _to, _tokenId);
125   }
126 
127   function approve(address _to, uint256 _tokenId) public {
128     require(tulipToOwner[_tokenId] == msg.sender);
129     tulipToApproved[_tokenId] = _to;
130 
131     Approval(msg.sender, _to, _tokenId);
132   }
133 
134   function transferFrom(address _from, address _to, uint256 _tokenId) public {
135     require(_to != address(0));
136     require(tulipToApproved[_tokenId] == msg.sender);
137     require(tulipToOwner[_tokenId] == _from);
138 
139     _transferTulip(_from, _to, _tokenId);
140     Transfer(_from, _to, _tokenId);
141   }
142 
143   function name() public pure returns (string) {
144     return "Ether Tulips";
145   }
146 
147   function symbol() public pure returns (string) {
148     return "ETHT";
149   }
150 
151   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
152     require(_index < ownerToTulips[_owner].length);
153     return ownerToTulips[_owner][_index];
154   }
155 
156   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
157 }
158 
159 contract TulipSales is TulipToken {
160   event Purchase(address indexed owner, uint256 unitPrice, uint32 amount);
161 
162   uint128 public increasePeriod = 6000; // around 1 day
163   uint128 public startBlock;
164   uint256[] public genToStartPrice;
165   uint256[23] internal exp15;
166 
167   function TulipSales() public {
168     startBlock = uint128(block.number);
169     genToStartPrice.push(10 finney);
170     _setExp15();
171   }
172 
173   // The price increases from the starting price at a rate of 1.5x a day, until
174   // a max of 10000x the original price. For gen 0, this corresponds to a cap
175   // of 100 ETH.
176   function price(uint16 _gen) public view returns (uint256) {
177     require(_gen < genToStartPrice.length);
178 
179     uint128 periodsElapsed = (uint128(block.number) - startBlock) / increasePeriod;
180     return _priceAtPeriod(periodsElapsed, _gen);
181   }
182 
183   function nextPrice(uint16 _gen) public view returns (uint256 futurePrice, uint128 blocksRemaining, uint128 changeBlock) {
184     require(_gen < genToStartPrice.length);
185 
186     uint128 periodsElapsed = (uint128(block.number) - startBlock) / increasePeriod;
187     futurePrice = _priceAtPeriod(periodsElapsed + 1, _gen);
188     blocksRemaining = increasePeriod - (uint128(block.number) - startBlock) % increasePeriod;
189     changeBlock = uint128(block.number) + blocksRemaining;
190   }
191 
192   function buyTulip(bytes32 _name, uint16 _gen) public payable returns (uint256 id) {
193     require(_gen < genToStartPrice.length);
194     require(msg.value == price(_gen));
195 
196     id = _generateTulip(_name, msg.sender, _gen);
197     Transfer(address(0), msg.sender, id);
198     Purchase(msg.sender, price(_gen), 1);
199   }
200 
201   function buyTulips(uint32 _amount, uint16 _gen) public payable returns (uint256 firstId) {
202     require(_gen < genToStartPrice.length);
203     require(msg.value == price(_gen) * _amount);
204     require(_amount <= 100);
205 
206     for (uint32 i = 0; i < _amount; i++) {
207       uint256 id = _generateTulip("", msg.sender, _gen);
208       Transfer(address(0), msg.sender, id);
209 
210       if (i == 0) {
211         firstId = id;
212       }
213     }
214     Purchase(msg.sender, price(_gen), _amount);
215   }
216 
217   function renameTulip(uint256 _id, bytes32 _name) public {
218     require(tulipToOwner[_id] == msg.sender);
219 
220     tulips[_id].name = _name;
221   }
222 
223   function addGen(uint256 _startPrice) public onlyAdmins {
224     require(genToStartPrice.length < 65535);
225 
226     genToStartPrice.push(_startPrice);
227   }
228 
229   function withdrawBalance(uint256 _amount) external onlyAdmins {
230     require(_amount <= this.balance);
231 
232     msg.sender.transfer(_amount);
233   }
234 
235   function _priceAtPeriod(uint128 _period, uint16 _gen) internal view returns (uint256) {
236     if (_period >= exp15.length) {
237       return genToStartPrice[_gen] * 10000;
238     } else {
239       return genToStartPrice[_gen] * exp15[_period] / 1 ether;
240     }
241   }
242 
243   // Set 1 ETH * 1.5^i for 0 <= i <= 22 with 3 significant figures
244   function _setExp15() internal {
245     exp15 = [
246       1000 finney,
247       1500 finney,
248       2250 finney,
249       3380 finney,
250       5060 finney,
251       7590 finney,
252       11400 finney,
253       17100 finney,
254       25600 finney,
255       38400 finney,
256       57700 finney,
257       86500 finney,
258       130 ether,
259       195 ether,
260       292 ether,
261       438 ether,
262       657 ether,
263       985 ether,
264       1480 ether,
265       2220 ether,
266       3330 ether,
267       4990 ether,
268       7480 ether
269     ];
270   }
271 }
272 
273 contract TulipCore is TulipSales {
274   event ContractUpgrade(address newContract);
275   event MaintenanceUpdate(bool maintenance);
276 
277   bool public underMaintenance = false;
278   bool public deprecated = false;
279   address public newContractAddress;
280 
281   function TulipCore() public {
282     owner = msg.sender;
283   }
284 
285   function getTulip(uint256 _id) public view returns (
286     uint256 genes,
287     uint256 createTime,
288     string name
289   ) {
290     Tulip storage tulip = tulips[_id];
291     genes = tulip.genes;
292     createTime = tulip.createTime;
293 
294     bytes memory byteArray = new bytes(32);
295     for (uint8 i = 0; i < 32; i++) {
296       byteArray[i] = tulip.name[i];
297     }
298     name = string(byteArray);
299   }
300 
301   function myTulips() public view returns (uint256[]) {
302     uint256[] memory tulipsMemory = ownerToTulips[msg.sender];
303     return tulipsMemory;
304   }
305 
306   function myTulipsBatched(uint256 _startIndex, uint16 _maxAmount) public view returns (
307     uint256[] tulipIds,
308     uint256 amountRemaining
309   ) {
310     uint256[] storage tulipArr = ownerToTulips[msg.sender];
311     int256 j = int256(tulipArr.length) - 1 - int256(_startIndex);
312     uint256 amount = _maxAmount;
313 
314     if (j < 0) {
315       return (
316         new uint256[](0),
317         0
318       );
319     } else if (j + 1 < _maxAmount) {
320       amount = uint256(j + 1);
321     }
322     uint256[] memory resultIds = new uint256[](amount);
323 
324     for (uint16 i = 0; i < amount; i++) {
325       resultIds[i] = tulipArr[uint256(j)];
326       j--;
327     }
328 
329     return (
330       resultIds,
331       uint256(j+1)
332     );
333   }
334 
335   function setMaintenance(bool _underMaintenance) public onlyAdmins {
336     underMaintenance = _underMaintenance;
337     MaintenanceUpdate(underMaintenance);
338   }
339 
340   function upgradeContract(address _newContractAddress) public onlyAdmins {
341     newContractAddress = _newContractAddress;
342     deprecated = true;
343     ContractUpgrade(_newContractAddress);
344   }
345 }