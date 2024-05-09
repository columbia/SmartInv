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
51   mapping (uint256 => address) public lastBuyer;
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
86   function setTop(uint256 _id, address _newExtra, uint256 _price) public onlyCXX {
87     require(_newExtra != address(0));
88     topOwner[_id] = TopOwner(_newExtra, _price);
89   }
90   function setLast(uint256 _id, address _newExtra) public onlyCXX {
91     require(_newExtra != address(0));
92     lastBuyer[_id] = _newExtra;
93   }
94 
95   /*** DEFAULT METHODS ***/
96   function symbol() public pure returns (string) { return SYMBOL; }
97   function name() public pure returns (string) { return NAME; }
98   function implementsERC721() public pure returns (bool) { return true; }
99 
100   /*** CONSTRUCTOR ***/
101   function EtherBrand() public {
102     ceoAddress = msg.sender;
103     cooAddress = msg.sender;
104     cfoAddress = msg.sender;
105     topOwner[1] = TopOwner(msg.sender, 0); // 0.5
106     topOwner[2] = TopOwner(msg.sender, 0); // 0.1
107     topOwner[3] = TopOwner(msg.sender, 0); // 0.05
108     topOwner[4] = TopOwner(msg.sender, 0);
109     topOwner[5] = TopOwner(msg.sender, 0);
110     lastBuyer[1] = msg.sender;
111     lastBuyer[2] = msg.sender;
112     lastBuyer[3] = msg.sender;
113     extra[1] = msg.sender;
114     extra[2] = msg.sender;
115     extra[3] = msg.sender;
116     extra[4] = msg.sender;
117     extra[5] = msg.sender;
118   }
119 
120   /*** INTERFACE METHODS ***/
121 
122   function createBrand(bytes32 _name, uint256 _price) public onlyCXX {
123     require(msg.sender != address(0));
124     _create_brand(_name, address(this), _price, 0);
125   }
126 
127   function createPromoBrand(bytes32 _name, address _owner, uint256 _price, uint256 _last_price) public onlyCXX {
128     require(msg.sender != address(0));
129     require(_owner != address(0));
130     _create_brand(_name, _owner, _price, _last_price);
131   }
132 
133   function openGame() public onlyCXX {
134     require(msg.sender != address(0));
135     gameOpen = true;
136   }
137 
138   function totalSupply() public view returns (uint256 total) {
139     return brand_count;
140   }
141 
142   function balanceOf(address _owner) public view returns (uint256 balance) {
143     return ownerCount[_owner];
144   }
145   function priceOf(uint256 _brand_id) public view returns (uint256 price) {
146     return brands[_brand_id].price;
147   }
148 
149   function getBrand(uint256 _brand_id) public view returns (
150     uint256 id,
151     bytes32 brand_name,
152     address owner,
153     uint256 price,
154     uint256 last_price
155   ) {
156     id = _brand_id;
157     brand_name = brands[_brand_id].name;
158     owner = brands[_brand_id].owner;
159     price = brands[_brand_id].price;
160     last_price = brands[_brand_id].last_price;
161   }
162   
163   function getBrands() public view returns (uint256[], bytes32[], address[], uint256[]) {
164     uint256[] memory ids = new uint256[](brand_count);
165     bytes32[] memory names = new bytes32[](brand_count);
166     address[] memory owners = new address[](brand_count);
167     uint256[] memory prices = new uint256[](brand_count);
168     for(uint256 _id = 0; _id < brand_count; _id++){
169       ids[_id] = _id;
170       names[_id] = brands[_id].name;
171       owners[_id] = brands[_id].owner;
172       prices[_id] = brands[_id].price;
173     }
174     return (ids, names, owners, prices);
175   }
176   
177   function purchase(uint256 _brand_id) public payable {
178     require(gameOpen == true);
179     Brand storage brand = brands[_brand_id];
180 
181     require(brand.owner != msg.sender);
182     require(msg.sender != address(0));
183     require(msg.value >= brand.price);
184 
185     uint256 excess = SafeMath.sub(msg.value, brand.price);
186     uint256 half_diff = SafeMath.div(SafeMath.sub(brand.price, brand.last_price), 2);
187     uint256 reward = SafeMath.add(half_diff, brand.last_price);
188 
189     topOwner[1].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 15)));  // 15%
190     topOwner[2].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 12)));  // 12%
191     topOwner[3].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 9)));   // 9%
192     topOwner[4].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 5)));   // 5%
193     topOwner[5].addr.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 2)));   // 2% == 43%
194   
195     lastBuyer[1].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 20))); // 20%
196     lastBuyer[2].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 15))); // 15%
197     lastBuyer[3].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 10))); // 10% == 45%
198   
199     extra[1].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
200     extra[2].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
201     extra[3].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
202     extra[4].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
203     extra[5].transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));      // 1%
204     
205     cfoAddress.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 6)));    // 6%
206     cooAddress.transfer(uint256(SafeMath.mul(SafeMath.div(half_diff, 100), 1)));    // 1%
207 
208     if(brand.owner == address(this)){
209       cfoAddress.transfer(reward);
210     } else {
211       brand.owner.transfer(reward);
212     }
213     
214     if(brand.price > topOwner[5].price){
215         for(uint8 i = 1; i <= 5; i++){
216             if(brand.price > topOwner[(i+1)].price){
217                 if(i >= 4){ topOwner[5] = topOwner[4]; }
218                 if(i >= 3){ topOwner[4] = topOwner[3]; }
219                 if(i >= 2){ topOwner[3] = topOwner[2]; }
220                 if(i >= 1){ topOwner[2] = topOwner[1]; }
221                 topOwner[i] = TopOwner(msg.sender, brand.price);
222                 break;
223             }
224         }
225     }
226     
227     if(extra[3] == ceoAddress && brand.price >= 1000000000000000000){ extra[3] == msg.sender; } // 1 ETH
228     if(extra[4] == ceoAddress && brand.price >= 2500000000000000000){ extra[4] == msg.sender; } // 2.5 ETH
229     if(extra[5] == ceoAddress && brand.price >= 5000000000000000000){ extra[5] == msg.sender; } // 5 ETH
230     
231     brand.last_price = brand.price;
232     address _old_owner = brand.owner;
233     
234     if(brand.price < 50000000000000000){ // 0.05
235         brand.price = SafeMath.mul(SafeMath.div(brand.price, 100), 150);
236     } else {
237         brand.price = SafeMath.mul(SafeMath.div(brand.price, 100), 125);
238     }
239     brand.owner = msg.sender;
240 
241     lastBuyer[3] = lastBuyer[2];
242     lastBuyer[2] = lastBuyer[1];
243     lastBuyer[1] = msg.sender;
244 
245     Transfer(_old_owner, brand.owner, _brand_id);
246     TokenSold(_brand_id, brand.last_price, brand.price, _old_owner, brand.owner, brand.name);
247 
248     msg.sender.transfer(excess);
249   }
250 
251   function payout() public onlyCEO {
252     cfoAddress.transfer(this.balance);
253   }
254 
255   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
256     uint256 tokenCount = balanceOf(_owner);
257     if (tokenCount == 0) {
258       return new uint256[](0);
259     } else {
260       uint256[] memory result = new uint256[](tokenCount);
261       uint256 resultIndex = 0;
262       for (uint256 brandId = 0; brandId <= totalSupply(); brandId++) {
263         if (brands[brandId].owner == _owner) {
264           result[resultIndex] = brandId;
265           resultIndex++;
266         }
267       }
268       return result;
269     }
270   }
271 
272   /*** ERC-721 compliance. ***/
273 
274   function approve(address _to, uint256 _brand_id) public {
275     require(msg.sender == brands[_brand_id].owner);
276     brands[_brand_id].approve_transfer_to = _to;
277     Approval(msg.sender, _to, _brand_id);
278   }
279   function ownerOf(uint256 _brand_id) public view returns (address owner){
280     owner = brands[_brand_id].owner;
281     require(owner != address(0));
282   }
283   function takeOwnership(uint256 _brand_id) public {
284     address oldOwner = brands[_brand_id].owner;
285     require(msg.sender != address(0));
286     require(brands[_brand_id].approve_transfer_to == msg.sender);
287     _transfer(oldOwner, msg.sender, _brand_id);
288   }
289   function transfer(address _to, uint256 _brand_id) public {
290     require(msg.sender != address(0));
291     require(msg.sender == brands[_brand_id].owner);
292     _transfer(msg.sender, _to, _brand_id);
293   }
294   function transferFrom(address _from, address _to, uint256 _brand_id) public {
295     require(_from == brands[_brand_id].owner);
296     require(brands[_brand_id].approve_transfer_to == _to);
297     require(_to != address(0));
298     _transfer(_from, _to, _brand_id);
299   }
300 
301   /*** PRIVATE METHODS ***/
302 
303   function _create_brand(bytes32 _name, address _owner, uint256 _price, uint256 _last_price) private {
304     // Params: name, owner, price, is_for_sale, is_public, share_price, increase, fee, share_count,
305     brands[brand_count] = Brand({
306       name: _name,
307       owner: _owner,
308       price: _price,
309       last_price: _last_price,
310       approve_transfer_to: address(0)
311     });
312     
313     Brand storage brand = brands[brand_count];
314     
315     if(brand.price > topOwner[5].price){
316         for(uint8 i = 1; i <= 5; i++){
317             if(brand.price > topOwner[(i+1)].price){
318                 if(i >= 4){ topOwner[5] = topOwner[4]; }
319                 if(i >= 3){ topOwner[4] = topOwner[3]; }
320                 if(i >= 2){ topOwner[3] = topOwner[2]; }
321                 if(i >= 1){ topOwner[2] = topOwner[1]; }
322                 topOwner[i] = TopOwner(brand.owner, brand.price);
323                 break;
324             }
325         }
326     }
327     
328     Birth(brand_count, _name, _owner);
329     Transfer(address(this), _owner, brand_count);
330     brand_count++;
331   }
332 
333   function _transfer(address _from, address _to, uint256 _brand_id) private {
334     brands[_brand_id].owner = _to;
335     brands[_brand_id].approve_transfer_to = address(0);
336     ownerCount[_from] -= 1;
337     ownerCount[_to] += 1;
338     Transfer(_from, _to, _brand_id);
339   }
340 }
341 
342 library SafeMath {
343   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
344     if (a == 0) {
345       return 0;
346     }
347     uint256 c = a * b;
348     assert(c / a == b);
349     return c;
350   }
351   function div(uint256 a, uint256 b) internal pure returns (uint256) {
352     uint256 c = a / b;
353     return c;
354   }
355   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
356     assert(b <= a);
357     return a - b;
358   }
359   function add(uint256 a, uint256 b) internal pure returns (uint256) {
360     uint256 c = a + b;
361     assert(c >= a);
362     return c;
363   }
364 }