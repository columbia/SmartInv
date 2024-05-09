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
62   //Brand[] public brands;
63 
64   /*** ACCESS MODIFIERS ***/
65   modifier onlyCEO() { require(msg.sender == ceoAddress); _; }
66   modifier onlyCOO() { require(msg.sender == cooAddress); _; }
67   modifier onlyCXX() { require(msg.sender == ceoAddress || msg.sender == cooAddress); _; }
68 
69   /*** ACCESS MODIFIES ***/
70   function setCEO(address _newCEO) public onlyCEO {
71     require(_newCEO != address(0));
72     ceoAddress = _newCEO;
73   }
74   function setCOO(address _newCOO) public onlyCEO {
75     require(_newCOO != address(0));
76     cooAddress = _newCOO;
77   }
78   function setCFO(address _newCFO) public onlyCEO {
79     require(_newCFO != address(0));
80     cfoAddress = _newCFO;
81   }
82   function setExtra(uint256 _id, address _newExtra) public onlyCXX {
83     require(_newExtra != address(0));
84     // failsave :3 require(_id <= 2); // 3 = 1 ETH, 4 = 2.5 ETH, 5 = 5 ETH
85     extra[_id] = _newExtra;
86   }
87 
88   /*** DEFAULT METHODS ***/
89   function symbol() public pure returns (string) { return SYMBOL; }
90   function name() public pure returns (string) { return NAME; }
91   function implementsERC721() public pure returns (bool) { return true; }
92 
93   /*** CONSTRUCTOR ***/
94   function EtherBrand() public {
95     ceoAddress = msg.sender;
96     cooAddress = msg.sender;
97     cfoAddress = msg.sender;
98     topOwner[1] = TopOwner(msg.sender, 500000000000000000); // 0.5
99     topOwner[2] = TopOwner(msg.sender, 100000000000000000); // 0.1
100     topOwner[3] = TopOwner(msg.sender, 50000000000000000); // 0.05
101     topOwner[4] = TopOwner(msg.sender, 0);
102     topOwner[5] = TopOwner(msg.sender, 0);
103     lastBuyer[1] = msg.sender;
104     lastBuyer[2] = msg.sender;
105     lastBuyer[3] = msg.sender;
106     extra[1] = msg.sender;
107     extra[2] = msg.sender;
108     extra[3] = msg.sender;
109     extra[4] = msg.sender;
110     extra[5] = msg.sender;
111   }
112 
113   /*** INTERFACE METHODS ***/
114 
115   function createBrand(bytes32 _name, uint256 _price) public onlyCXX {
116     require(msg.sender != address(0));
117     _create_brand(_name, address(this), _price);
118   }
119 
120   function createPromoBrand(bytes32 _name, address _owner, uint256 _price) public onlyCXX {
121     require(msg.sender != address(0));
122     require(_owner != address(0));
123     _create_brand(_name, _owner, _price);
124   }
125 
126   function openGame() public onlyCXX {
127     require(msg.sender != address(0));
128     gameOpen = true;
129   }
130 
131   function totalSupply() public view returns (uint256 total) {
132     return brand_count;
133   }
134 
135   function balanceOf(address _owner) public view returns (uint256 balance) {
136     return ownerCount[_owner];
137   }
138   function priceOf(uint256 _brand_id) public view returns (uint256 price) {
139     return brands[_brand_id].price;
140   }
141 
142   function getBrand(uint256 _brand_id) public view returns (
143     uint256 id,
144     bytes32 brand_name,
145     address owner,
146     uint256 price,
147     uint256 last_price
148   ) {
149     id = _brand_id;
150     brand_name = brands[_brand_id].name;
151     owner = brands[_brand_id].owner;
152     price = brands[_brand_id].price;
153     last_price = brands[_brand_id].last_price;
154   }
155   
156   function getBrands() public view returns (uint256[], bytes32[], address[], uint256[]) {
157     uint256[] memory ids = new uint256[](brand_count);
158     bytes32[] memory names = new bytes32[](brand_count);
159     address[] memory owners = new address[](brand_count);
160     uint256[] memory prices = new uint256[](brand_count);
161     for(uint256 _id = 0; _id < brand_count; _id++){
162       ids[_id] = _id;
163       names[_id] = brands[_id].name;
164       owners[_id] = brands[_id].owner;
165       prices[_id] = brands[_id].price;
166     }
167     return (ids, names, owners, prices);
168   }
169   
170   function purchase(uint256 _brand_id) public payable {
171     require(gameOpen == true);
172     Brand storage brand = brands[_brand_id];
173 
174     require(brand.owner != msg.sender);
175     require(msg.sender != address(0));
176     require(msg.value >= brand.price);
177 
178     uint256 excess = SafeMath.sub(msg.value, brand.price);
179     uint256 half_diff = SafeMath.div(SafeMath.sub(brand.price, brand.last_price), 2);
180     uint256 reward = SafeMath.add(half_diff, brand.last_price);
181 
182     topOwner[1].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 15)));  // 15%
183     topOwner[2].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 12)));  // 12%
184     topOwner[3].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 9)));   // 9%
185     topOwner[4].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 5)));   // 5%
186     topOwner[5].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 2)));   // 2% == 43%
187   
188     lastBuyer[1].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 20))); // 20%
189     lastBuyer[2].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 15))); // 15%
190     lastBuyer[3].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 10))); // 10% == 45%
191   
192     extra[1].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
193     extra[2].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
194     extra[3].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
195     extra[4].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
196     extra[5].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
197     
198     cfoAddress.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 6)));    // 6%
199     cooAddress.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));    // 1%
200 
201     if(brand.owner == address(this)){
202       cfoAddress.transfer(reward);
203     } else {
204       brand.owner.transfer(reward);
205     }
206     
207     if(brand.price > topOwner[5].price){
208         for(uint8 i = 1; i <= 5; i++){
209             if(brand.price > topOwner[(i+1)].price){
210                 if(i <= 1){ topOwner[2] = topOwner[1]; }
211                 if(i <= 2){ topOwner[3] = topOwner[2]; }
212                 if(i <= 3){ topOwner[4] = topOwner[3]; }
213                 if(i <= 4){ topOwner[5] = topOwner[4]; }
214                 topOwner[i] = TopOwner(msg.sender, brand.price);
215                 break;
216             }
217         }
218     }
219     
220     if(extra[3] == ceoAddress && brand.price >= 1000000000000000000){ extra[3] == msg.sender; } // 1 ETH
221     if(extra[4] == ceoAddress && brand.price >= 2500000000000000000){ extra[4] == msg.sender; } // 2.5 ETH
222     if(extra[5] == ceoAddress && brand.price >= 5000000000000000000){ extra[5] == msg.sender; } // 5 ETH
223     
224     brand.last_price = brand.price;
225     address _old_owner = brand.owner;
226     
227     if(brand.price < 50000000000000000){ // 0.05
228         brand.price = SafeMath.mul(SafeMath.div(brand.price, 100), 150);
229     } else {
230         brand.price = SafeMath.mul(SafeMath.div(brand.price, 100), 125);
231     }
232     brand.owner = msg.sender;
233 
234     lastBuyer[3] = lastBuyer[2];
235     lastBuyer[2] = lastBuyer[1];
236     lastBuyer[1] = msg.sender;
237 
238     Transfer(_old_owner, brand.owner, _brand_id);
239     TokenSold(_brand_id, brand.last_price, brand.price, _old_owner, brand.owner, brand.name);
240 
241     msg.sender.transfer(excess);
242   }
243 
244   function payout() public onlyCEO {
245     cfoAddress.transfer(this.balance);
246   }
247 
248   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
249     uint256 tokenCount = balanceOf(_owner);
250     if (tokenCount == 0) {
251       return new uint256[](0);
252     } else {
253       uint256[] memory result = new uint256[](tokenCount);
254       uint256 resultIndex = 0;
255       for (uint256 brandId = 0; brandId <= totalSupply(); brandId++) {
256         if (brands[brandId].owner == _owner) {
257           result[resultIndex] = brandId;
258           resultIndex++;
259         }
260       }
261       return result;
262     }
263   }
264 
265   /*** ERC-721 compliance. ***/
266 
267   function approve(address _to, uint256 _brand_id) public {
268     require(msg.sender == brands[_brand_id].owner);
269     brands[_brand_id].approve_transfer_to = _to;
270     Approval(msg.sender, _to, _brand_id);
271   }
272   function ownerOf(uint256 _brand_id) public view returns (address owner){
273     owner = brands[_brand_id].owner;
274     require(owner != address(0));
275   }
276   function takeOwnership(uint256 _brand_id) public {
277     address oldOwner = brands[_brand_id].owner;
278     require(msg.sender != address(0));
279     require(brands[_brand_id].approve_transfer_to == msg.sender);
280     _transfer(oldOwner, msg.sender, _brand_id);
281   }
282   function transfer(address _to, uint256 _brand_id) public {
283     require(msg.sender != address(0));
284     require(msg.sender == brands[_brand_id].owner);
285     _transfer(msg.sender, _to, _brand_id);
286   }
287   function transferFrom(address _from, address _to, uint256 _brand_id) public {
288     require(_from == brands[_brand_id].owner);
289     require(brands[_brand_id].approve_transfer_to == _to);
290     require(_to != address(0));
291     _transfer(_from, _to, _brand_id);
292   }
293 
294   /*** PRIVATE METHODS ***/
295 
296   function _create_brand(bytes32 _name, address _owner, uint256 _price) private {
297     // Params: name, owner, price, is_for_sale, is_public, share_price, increase, fee, share_count,
298     brands[brand_count] = Brand({
299       name: _name,
300       owner: _owner,
301       price: _price,
302       last_price: 0,
303       approve_transfer_to: address(0)
304     });
305     Birth(brand_count, _name, _owner);
306     Transfer(address(this), _owner, brand_count);
307     brand_count++;
308   }
309 
310   function _transfer(address _from, address _to, uint256 _brand_id) private {
311     brands[_brand_id].owner = _to;
312     brands[_brand_id].approve_transfer_to = address(0);
313     ownerCount[_from] -= 1;
314     ownerCount[_to] += 1;
315     Transfer(_from, _to, _brand_id);
316   }
317 }
318 
319 library SafeMath {
320   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
321     if (a == 0) {
322       return 0;
323     }
324     uint256 c = a * b;
325     assert(c / a == b);
326     return c;
327   }
328   function div(uint256 a, uint256 b) internal pure returns (uint256) {
329     uint256 c = a / b;
330     return c;
331   }
332   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
333     assert(b <= a);
334     return a - b;
335   }
336   function add(uint256 a, uint256 b) internal pure returns (uint256) {
337     uint256 c = a + b;
338     assert(c >= a);
339     return c;
340   }
341 }