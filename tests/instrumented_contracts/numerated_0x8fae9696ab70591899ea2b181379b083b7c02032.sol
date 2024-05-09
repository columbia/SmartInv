1 pragma solidity ^0.4.18;
2 
3 ///>[ Crypto Brands ]>>>>
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
21 contract EtherBrand is ERC721 {
22 
23   /*** EVENTS ***/
24   event Birth(uint256 tokenId, bytes32 name, address owner);
25   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, bytes32 name);
26   event Transfer(address from, address to, uint256 tokenId);
27 
28   /*** STRUCTS ***/
29   struct Brand {
30     bytes32 name;
31     address owner;
32     uint256 price;
33     uint256 last_price;
34     address approve_transfer_to;
35   }
36   
37   struct TopOwner {
38     address addr;
39     uint256 price;
40   }
41 
42   /*** CONSTANTS ***/
43   string public constant NAME = "EtherBrands";
44   string public constant SYMBOL = "EtherBrand";
45   
46   bool public gameOpen = false;
47 
48   /*** STORAGE ***/
49   mapping (address => uint256) private ownerCount;
50   mapping (uint256 => TopOwner) private topOwner;
51   mapping (uint256 => address) private lastBuyer;
52 
53   address public ceoAddress;
54   address public cooAddress;
55   address public cfoAddress;
56   mapping (uint256 => address) public extra;
57   
58   uint256 brand_count;
59   uint256 lowest_top_brand;
60  
61   mapping (uint256 => Brand) private brands;
62 
63   /*** ACCESS MODIFIERS ***/
64   modifier onlyCEO() { require(msg.sender == ceoAddress); _; }
65   modifier onlyCOO() { require(msg.sender == cooAddress); _; }
66   modifier onlyCXX() { require(msg.sender == ceoAddress || msg.sender == cooAddress); _; }
67 
68   /*** ACCESS MODIFIES ***/
69   function setCEO(address _newCEO) public onlyCEO {
70     require(_newCEO != address(0));
71     ceoAddress = _newCEO;
72   }
73   function setCOO(address _newCOO) public onlyCEO {
74     require(_newCOO != address(0));
75     cooAddress = _newCOO;
76   }
77   function setCFO(address _newCFO) public onlyCEO {
78     require(_newCFO != address(0));
79     cfoAddress = _newCFO;
80   }
81   function setExtra(uint256 _id, address _newExtra) public onlyCXX {
82     require(_newExtra != address(0));
83     // failsave :3 require(_id <= 2); // 3 = 1 ETH, 4 = 2.5 ETH, 5 = 5 ETH
84     extra[_id] = _newExtra;
85   }
86 
87   /*** DEFAULT METHODS ***/
88   function symbol() public pure returns (string) { return SYMBOL; }
89   function name() public pure returns (string) { return NAME; }
90   function implementsERC721() public pure returns (bool) { return true; }
91 
92   /*** CONSTRUCTOR ***/
93   function EtherBrand() public {
94     ceoAddress = msg.sender;
95     cooAddress = msg.sender;
96     cfoAddress = msg.sender;
97     topOwner[1] = TopOwner(msg.sender, 500000000000000000); // 0.5
98     topOwner[2] = TopOwner(msg.sender, 100000000000000000); // 0.1
99     topOwner[3] = TopOwner(msg.sender, 50000000000000000); // 0.05
100     topOwner[4] = TopOwner(msg.sender, 0);
101     topOwner[5] = TopOwner(msg.sender, 0);
102     lastBuyer[1] = msg.sender;
103     lastBuyer[2] = msg.sender;
104     lastBuyer[3] = msg.sender;
105     extra[1] = msg.sender;
106     extra[2] = msg.sender;
107     extra[3] = msg.sender;
108     extra[4] = msg.sender;
109     extra[5] = msg.sender;
110   }
111 
112   /*** INTERFACE METHODS ***/
113 
114   function createBrand(bytes32 _name, uint256 _price) public onlyCXX {
115     require(msg.sender != address(0));
116     _create_brand(_name, address(this), _price);
117   }
118 
119   function createPromoBrand(bytes32 _name, address _owner, uint256 _price) public onlyCXX {
120     require(msg.sender != address(0));
121     require(_owner != address(0));
122     _create_brand(_name, _owner, _price);
123   }
124 
125   function openGame() public onlyCXX {
126     require(msg.sender != address(0));
127     gameOpen = true;
128   }
129 
130   function totalSupply() public view returns (uint256 total) {
131     return brand_count;
132   }
133 
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return ownerCount[_owner];
136   }
137   function priceOf(uint256 _brand_id) public view returns (uint256 price) {
138     return brands[_brand_id].price;
139   }
140 
141   function getBrand(uint256 _brand_id) public view returns (
142     uint256 id,
143     bytes32 brand_name,
144     address owner,
145     uint256 price,
146     uint256 last_price
147   ) {
148     id = _brand_id;
149     brand_name = brands[_brand_id].name;
150     owner = brands[_brand_id].owner;
151     price = brands[_brand_id].price;
152     last_price = brands[_brand_id].last_price;
153   }
154   
155   function getBrands() public view returns (uint256[], bytes32[], address[], uint256[]) {
156     uint256[] memory ids = new uint256[](brand_count);
157     bytes32[] memory names = new bytes32[](brand_count);
158     address[] memory owners = new address[](brand_count);
159     uint256[] memory prices = new uint256[](brand_count);
160     for(uint256 _id = 0; _id < brand_count; _id++){
161       ids[_id] = _id;
162       names[_id] = brands[_id].name;
163       owners[_id] = brands[_id].owner;
164       prices[_id] = brands[_id].price;
165     }
166     return (ids, names, owners, prices);
167   }
168   
169   function purchase(uint256 _brand_id) public payable {
170     require(gameOpen == true);
171     Brand storage brand = brands[_brand_id];
172 
173     require(brand.owner != msg.sender);
174     require(msg.sender != address(0));
175     require(msg.value >= brand.price);
176 
177     uint256 excess = SafeMath.sub(msg.value, brand.price);
178     uint256 half_diff = SafeMath.div(SafeMath.sub(brand.price, brand.last_price), 2);
179     uint256 reward = SafeMath.add(half_diff, brand.last_price);
180 
181     topOwner[1].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 15)));  // 15%
182     topOwner[2].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 12)));  // 12%
183     topOwner[3].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 9)));   // 9%
184     topOwner[4].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 5)));   // 5%
185     topOwner[5].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 2)));   // 2% == 43%
186   
187     lastBuyer[1].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 20))); // 20%
188     lastBuyer[2].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 15))); // 15%
189     lastBuyer[3].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 10))); // 10% == 45%
190   
191     extra[1].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
192     extra[2].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
193     extra[3].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
194     extra[4].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
195     extra[5].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
196     
197     cfoAddress.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 6)));    // 6%
198     cooAddress.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));    // 1%
199 
200     if(brand.owner == address(this)){
201       cfoAddress.transfer(reward);
202     } else {
203       brand.owner.transfer(reward);
204     }
205     
206     if(brand.price > topOwner[5].price){
207         for(uint8 i = 1; i <= 5; i++){
208             if(brand.price > topOwner[(i+1)].price){
209                 if(i <= 1){ topOwner[2] = topOwner[1]; }
210                 if(i <= 2){ topOwner[3] = topOwner[2]; }
211                 if(i <= 3){ topOwner[4] = topOwner[3]; }
212                 if(i <= 4){ topOwner[5] = topOwner[4]; }
213                 topOwner[i] = TopOwner(msg.sender, brand.price);
214                 break;
215             }
216         }
217     }
218     
219     if(extra[3] == ceoAddress && brand.price >= 1000000000000000000){ extra[3] == msg.sender; } // 1 ETH
220     if(extra[4] == ceoAddress && brand.price >= 2500000000000000000){ extra[4] == msg.sender; } // 2.5 ETH
221     if(extra[5] == ceoAddress && brand.price >= 5000000000000000000){ extra[5] == msg.sender; } // 5 ETH
222     
223     brand.last_price = brand.price;
224     address _old_owner = brand.owner;
225     
226     if(brand.price < 50000000000000000){ // 0.05
227         brand.price = SafeMath.mul(SafeMath.div(brand.price, 100), 150);
228     } else {
229         brand.price = SafeMath.mul(SafeMath.div(brand.price, 100), 125);
230     }
231     brand.owner = msg.sender;
232 
233     lastBuyer[3] = lastBuyer[2];
234     lastBuyer[2] = lastBuyer[1];
235     lastBuyer[1] = msg.sender;
236 
237     Transfer(_old_owner, brand.owner, _brand_id);
238     TokenSold(_brand_id, brand.last_price, brand.price, _old_owner, brand.owner, brand.name);
239 
240     msg.sender.transfer(excess);
241   }
242 
243   function payout() public onlyCEO {
244     cfoAddress.transfer(this.balance);
245   }
246 
247   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
248     uint256 tokenCount = balanceOf(_owner);
249     if (tokenCount == 0) {
250       return new uint256[](0);
251     } else {
252       uint256[] memory result = new uint256[](tokenCount);
253       uint256 resultIndex = 0;
254       for (uint256 brandId = 0; brandId <= totalSupply(); brandId++) {
255         if (brands[brandId].owner == _owner) {
256           result[resultIndex] = brandId;
257           resultIndex++;
258         }
259       }
260       return result;
261     }
262   }
263 
264   /*** ERC-721 compliance. ***/
265 
266   function approve(address _to, uint256 _brand_id) public {
267     require(msg.sender == brands[_brand_id].owner);
268     brands[_brand_id].approve_transfer_to = _to;
269     Approval(msg.sender, _to, _brand_id);
270   }
271   function ownerOf(uint256 _brand_id) public view returns (address owner){
272     owner = brands[_brand_id].owner;
273     require(owner != address(0));
274   }
275   function takeOwnership(uint256 _brand_id) public {
276     address oldOwner = brands[_brand_id].owner;
277     require(msg.sender != address(0));
278     require(brands[_brand_id].approve_transfer_to == msg.sender);
279     _transfer(oldOwner, msg.sender, _brand_id);
280   }
281   function transfer(address _to, uint256 _brand_id) public {
282     require(msg.sender != address(0));
283     require(msg.sender == brands[_brand_id].owner);
284     _transfer(msg.sender, _to, _brand_id);
285   }
286   function transferFrom(address _from, address _to, uint256 _brand_id) public {
287     require(_from == brands[_brand_id].owner);
288     require(brands[_brand_id].approve_transfer_to == _to);
289     require(_to != address(0));
290     _transfer(_from, _to, _brand_id);
291   }
292 
293   /*** PRIVATE METHODS ***/
294 
295   function _create_brand(bytes32 _name, address _owner, uint256 _price) private {
296     // Params: name, owner, price, is_for_sale, is_public, share_price, increase, fee, share_count,
297     brands[brand_count] = Brand({
298       name: _name,
299       owner: _owner,
300       price: _price,
301       last_price: 0,
302       approve_transfer_to: address(0)
303     });
304     Birth(brand_count, _name, _owner);
305     Transfer(address(this), _owner, brand_count);
306     brand_count++;
307   }
308 
309   function _transfer(address _from, address _to, uint256 _brand_id) private {
310     brands[_brand_id].owner = _to;
311     brands[_brand_id].approve_transfer_to = address(0);
312     ownerCount[_from] -= 1;
313     ownerCount[_to] += 1;
314     Transfer(_from, _to, _brand_id);
315   }
316 }
317 
318 library SafeMath {
319   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
320     if (a == 0) {
321       return 0;
322     }
323     uint256 c = a * b;
324     assert(c / a == b);
325     return c;
326   }
327   function div(uint256 a, uint256 b) internal pure returns (uint256) {
328     uint256 c = a / b;
329     return c;
330   }
331   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
332     assert(b <= a);
333     return a - b;
334   }
335   function add(uint256 a, uint256 b) internal pure returns (uint256) {
336     uint256 c = a + b;
337     assert(c >= a);
338     return c;
339   }
340 }