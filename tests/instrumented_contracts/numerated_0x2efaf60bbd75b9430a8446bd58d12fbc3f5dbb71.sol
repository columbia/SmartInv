1 pragma solidity ^0.4.18;
2 
3 ///EtherMinerals
4 
5 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
6 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
7 contract ERC721 {
8     function approve(address _to, uint256 _tokenId) public;
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function implementsERC721() public pure returns (bool);
11     function ownerOf(uint256 _tokenId) public view returns (address addr);
12     function takeOwnership(uint256 _tokenId) public;
13     function totalSupply() public view returns (uint256 total);
14     function transferFrom(address _from, address _to, uint256 _tokenId) public;
15     function transfer(address _to, uint256 _tokenId) public;
16 
17     event Transfer(address indexed from, address indexed to, uint256 tokenId);
18     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
19 }
20 
21 contract EtherMinerals is ERC721 {
22 
23   /*** EVENTS ***/
24   event Birth(uint256 tokenId, bytes32 name, address owner);
25   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, bytes32 name);
26   event Transfer(address from, address to, uint256 tokenId);
27 
28   /*** STRUCTS ***/
29   struct Mineral {
30     bytes32 name;
31     address owner;
32     uint256 price;
33     uint256 last_price;
34     address approve_transfer_to;
35   }
36 
37   /*** CONSTANTS ***/
38   string public constant NAME = "EtherMinerals";
39   string public constant SYMBOL = "MINERAL";
40   
41   uint256 private startingPrice = 0.01 ether;
42   uint256 private firstStepLimit =  0.15 ether;
43   uint256 private secondStepLimit = 0.564957 ether;
44   
45   bool public gameOpen = false;
46 
47   /*** STORAGE ***/
48   mapping (address => uint256) private ownerCount;
49   mapping (uint256 => address) public lastBuyer;
50 
51   address public ceoAddress;
52   mapping (uint256 => address) public extra;
53   
54   uint256 mineral_count;
55  
56   mapping (uint256 => Mineral) private minerals;
57 
58   /*** ACCESS MODIFIERS ***/
59   modifier onlyCEO() { require(msg.sender == ceoAddress); _; }
60 
61   /*** ACCESS MODIFIES ***/
62   function setCEO(address _newCEO) public onlyCEO {
63     require(_newCEO != address(0));
64     ceoAddress = _newCEO;
65   }
66 
67   function setLast(uint256 _id, address _newExtra) public onlyCEO {
68     require(_newExtra != address(0));
69     lastBuyer[_id] = _newExtra;
70   }
71 
72   /*** DEFAULT METHODS ***/
73   function symbol() public pure returns (string) { return SYMBOL; }
74   function name() public pure returns (string) { return NAME; }
75   function implementsERC721() public pure returns (bool) { return true; }
76 
77   /*** CONSTRUCTOR ***/
78   function EtherMinerals() public {
79     ceoAddress = msg.sender;
80     lastBuyer[1] = msg.sender;
81     lastBuyer[2] = msg.sender;
82     lastBuyer[3] = msg.sender;
83     lastBuyer[4] = msg.sender;
84     lastBuyer[5] = msg.sender;
85     lastBuyer[6] = msg.sender;
86     lastBuyer[7] = msg.sender;
87     lastBuyer[8] = msg.sender;
88     lastBuyer[9] = msg.sender;
89   }
90 
91   /*** INTERFACE METHODS ***/
92 
93   function createMineral(bytes32 _name, uint256 _price) public onlyCEO {
94     require(msg.sender != address(0));
95     _create_mineral(_name, address(this), _price, 0);
96   }
97 
98   function createPromoMineral(bytes32 _name, address _owner, uint256 _price, uint256 _last_price) public onlyCEO {
99     require(msg.sender != address(0));
100     require(_owner != address(0));
101     _create_mineral(_name, _owner, _price, _last_price);
102   }
103 
104   function openGame() public onlyCEO {
105     require(msg.sender != address(0));
106     gameOpen = true;
107   }
108 
109   function totalSupply() public view returns (uint256 total) {
110     return mineral_count;
111   }
112 
113   function balanceOf(address _owner) public view returns (uint256 balance) {
114     return ownerCount[_owner];
115   }
116   function priceOf(uint256 _mineral_id) public view returns (uint256 price) {
117     return minerals[_mineral_id].price;
118   }
119 
120   function getMineral(uint256 _mineral_id) public view returns (
121     uint256 id,
122     bytes32 mineral_name,
123     address owner,
124     uint256 price,
125     uint256 last_price
126   ) {
127     id = _mineral_id;
128     mineral_name = minerals[_mineral_id].name;
129     owner = minerals[_mineral_id].owner;
130     price = minerals[_mineral_id].price;
131     last_price = minerals[_mineral_id].last_price;
132   }
133   
134   function getMinerals() public view returns (uint256[], bytes32[], address[], uint256[]) {
135     uint256[] memory ids = new uint256[](mineral_count);
136     bytes32[] memory names = new bytes32[](mineral_count);
137     address[] memory owners = new address[](mineral_count);
138     uint256[] memory prices = new uint256[](mineral_count);
139     for(uint256 _id = 0; _id < mineral_count; _id++){
140       ids[_id] = _id;
141       names[_id] = minerals[_id].name;
142       owners[_id] = minerals[_id].owner;
143       prices[_id] = minerals[_id].price;
144     }
145     return (ids, names, owners, prices);
146   }
147   
148   function getBalance() public onlyCEO view returns(uint){
149       return address(this).balance;
150   }
151   
152 
153   
154   function purchase(uint256 _mineral_id) public payable {
155     require(gameOpen == true);
156     Mineral storage mineral = minerals[_mineral_id];
157 
158     require(mineral.owner != msg.sender);
159     require(msg.sender != address(0));  
160     require(msg.value >= mineral.price);
161 
162     uint256 excess = SafeMath.sub(msg.value, mineral.price);
163     uint256 reward = uint256(SafeMath.div(SafeMath.mul(mineral.price, 90), 100));
164   
165 
166     if(mineral.owner != address(this)){
167       mineral.owner.transfer(reward);
168     }
169     
170     
171     mineral.last_price = mineral.price;
172     address _old_owner = mineral.owner;
173     
174     if (mineral.price < firstStepLimit) {
175       // first stage
176       mineral.price = SafeMath.div(SafeMath.mul(mineral.price, 200), 90);
177     } else if (mineral.price < secondStepLimit) {
178       // second stage
179       mineral.price = SafeMath.div(SafeMath.mul(mineral.price, 118), 90);
180     } else {
181       // third stage
182       mineral.price = SafeMath.div(SafeMath.mul(mineral.price, 113), 90);
183     }
184     mineral.owner = msg.sender;
185 
186     emit Transfer(_old_owner, mineral.owner, _mineral_id);
187     emit TokenSold(_mineral_id, mineral.last_price, mineral.price, _old_owner, mineral.owner, mineral.name);
188 
189     msg.sender.transfer(excess);
190   }
191 
192   function payout() public onlyCEO {
193     ceoAddress.transfer(address(this).balance);
194   }
195 
196   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
197     uint256 tokenCount = balanceOf(_owner);
198     if (tokenCount == 0) {
199       return new uint256[](0);
200     } else {
201       uint256[] memory result = new uint256[](tokenCount);
202       uint256 resultIndex = 0;
203       for (uint256 mineralId = 0; mineralId <= totalSupply(); mineralId++) {
204         if (minerals[mineralId].owner == _owner) {
205           result[resultIndex] = mineralId;
206           resultIndex++;
207         }
208       }
209       return result;
210     }
211   }
212 
213   /*** ERC-721 compliance. ***/
214 
215   function approve(address _to, uint256 _mineral_id) public {
216     require(msg.sender == minerals[_mineral_id].owner);
217     minerals[_mineral_id].approve_transfer_to = _to;
218     emit Approval(msg.sender, _to, _mineral_id);
219   }
220   function ownerOf(uint256 _mineral_id) public view returns (address owner){
221     owner = minerals[_mineral_id].owner;
222     require(owner != address(0));
223   }
224   function takeOwnership(uint256 _mineral_id) public {
225     address oldOwner = minerals[_mineral_id].owner;
226     require(msg.sender != address(0));
227     require(minerals[_mineral_id].approve_transfer_to == msg.sender);
228     _transfer(oldOwner, msg.sender, _mineral_id);
229   }
230   function transfer(address _to, uint256 _mineral_id) public {
231     require(msg.sender != address(0));
232     require(msg.sender == minerals[_mineral_id].owner);
233     _transfer(msg.sender, _to, _mineral_id);
234   }
235   function transferFrom(address _from, address _to, uint256 _mineral_id) public {
236     require(_from == minerals[_mineral_id].owner);
237     require(minerals[_mineral_id].approve_transfer_to == _to);
238     require(_to != address(0));
239     _transfer(_from, _to, _mineral_id);
240   }
241  
242   function createAllTokens() public onlyCEO{
243     createMineral("Emerald", 10000000000000000);
244     createMineral("Opal", 10000000000000000);
245     createMineral("Diamond", 10000000000000000);
246     createMineral("Bismuth", 10000000000000000);
247     createMineral("Amethyst", 10000000000000000);
248     createMineral("Gold", 10000000000000000);
249     createMineral("Fluorite", 10000000000000000);
250     createMineral("Ruby", 10000000000000000);
251     createMineral("Sapphire", 10000000000000000);
252     createMineral("Pascoite", 10000000000000000);
253     createMineral("Karpatite", 10000000000000000);
254     createMineral("Uvarovite", 10000000000000000);
255     createMineral("Kryptonite", 10000000000000000);
256     createMineral("Good ol' Rock", 10000000000000000);
257     createMineral("Malachite", 10000000000000000);
258     createMineral("Silver", 10000000000000000);
259     createMineral("Burmese Tourmaline" ,10000000000000000);
260     }
261 
262   /*** PRIVATE METHODS ***/
263 
264   function _create_mineral(bytes32 _name, address _owner, uint256 _price, uint256 _last_price) private {
265     // Params: name, owner, price, is_for_sale, is_public, share_price, increase, fee, share_count,
266     minerals[mineral_count] = Mineral({
267       name: _name,
268       owner: _owner,
269       price: _price,
270       last_price: _last_price,
271       approve_transfer_to: address(0)
272     });
273     
274 
275     
276     
277     emit Birth(mineral_count, _name, _owner);
278     emit Transfer(address(this), _owner, mineral_count);
279     mineral_count++;
280   }
281 
282   function _transfer(address _from, address _to, uint256 _mineral_id) private {
283     minerals[_mineral_id].owner = _to;
284     minerals[_mineral_id].approve_transfer_to = address(0);
285     ownerCount[_from] -= 1;
286     ownerCount[_to] += 1;
287     emit Transfer(_from, _to, _mineral_id);
288   }
289 }
290 
291 library SafeMath {
292   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
293     if (a == 0) {
294       return 0;
295     }
296     uint256 c = a * b;
297     assert(c / a == b);
298     return c;
299   }
300   function div(uint256 a, uint256 b) internal pure returns (uint256) {
301     uint256 c = a / b;
302     return c;
303   }
304   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
305     assert(b <= a);
306     return a - b;
307   }
308   function add(uint256 a, uint256 b) internal pure returns (uint256) {
309     uint256 c = a + b;
310     assert(c >= a);
311     return c;
312   }
313 }