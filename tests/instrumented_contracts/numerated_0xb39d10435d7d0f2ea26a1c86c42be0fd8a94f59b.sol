1 pragma solidity ^0.4.18;
2 
3 contract TittyBase {
4 
5     event Transfer(address indexed from, address indexed to);
6     event Creation(address indexed from, uint256 tittyId, uint256 wpId);
7     event AddAccessory(uint256 tittyId, uint256 accessoryId);
8 
9     struct Accessory {
10 
11         uint256 id;
12         string name;
13         uint256 price;
14         bool isActive;
15 
16     }
17 
18     struct Titty {
19 
20         uint256 id;
21         string name;
22         string gender;
23         uint256 originalPrice;
24         uint256 salePrice;
25         uint256[] accessories;
26         bool forSale;
27     }
28 
29     //Storage
30     Titty[] Titties;
31     Accessory[] Accessories;
32     mapping (uint256 => address) public tittyIndexToOwner;
33     mapping (address => uint256) public ownerTittiesCount;
34     mapping (uint256 => address) public tittyApproveIndex;
35 
36     function _transfer(address _from, address _to, uint256 _tittyId) internal {
37 
38         ownerTittiesCount[_to]++;
39 
40         tittyIndexToOwner[_tittyId] = _to;
41         if (_from != address(0)) {
42             ownerTittiesCount[_from]--;
43             delete tittyApproveIndex[_tittyId];
44         }
45 
46         Transfer(_from, _to);
47 
48     }
49 
50     function _changeTittyPrice (uint256 _newPrice, uint256 _tittyId) internal {
51 
52         require(tittyIndexToOwner[_tittyId] == msg.sender);
53         Titty storage _titty = Titties[_tittyId];
54         _titty.salePrice = _newPrice;
55 
56         Titties[_tittyId] = _titty;
57     }
58 
59     function _setTittyForSale (bool _forSale, uint256 _tittyId) internal {
60 
61         require(tittyIndexToOwner[_tittyId] == msg.sender);
62         Titty storage _titty = Titties[_tittyId];
63         _titty.forSale = _forSale;
64 
65         Titties[_tittyId] = _titty;
66     }
67 
68     function _changeName (string _name, uint256 _tittyId) internal {
69 
70         require(tittyIndexToOwner[_tittyId] == msg.sender);
71         Titty storage _titty = Titties[_tittyId];
72         _titty.name = _name;
73 
74         Titties[_tittyId] = _titty;
75     }
76 
77     function addAccessory (uint256 _id, string _name, uint256 _price, uint256 tittyId ) internal returns (uint) {
78 
79         Accessory memory _accessory = Accessory({
80 
81             id: _id,
82             name: _name,
83             price: _price,
84             isActive: true
85 
86         });
87 
88         Titty storage titty = Titties[tittyId];
89         uint256 newAccessoryId = Accessories.push(_accessory) - 1;
90         titty.accessories.push(newAccessoryId);
91         AddAccessory(tittyId, newAccessoryId);
92 
93         return newAccessoryId;
94 
95     }
96 
97     function totalAccessories(uint256 _tittyId) public view returns (uint256) {
98 
99         Titty storage titty = Titties[_tittyId];
100         return titty.accessories.length;
101 
102     }
103 
104     function getAccessory(uint256 _tittyId, uint256 _aId) public view returns (uint256 id, string name,  uint256 price, bool active) {
105 
106         Titty storage titty = Titties[_tittyId];
107         uint256 accId = titty.accessories[_aId];
108         Accessory storage accessory = Accessories[accId];
109         id = accessory.id;
110         name = accessory.name;
111         price = accessory.price;
112         active = accessory.isActive;
113 
114     }
115 
116     function createTitty (uint256 _id, string _gender, uint256 _price, address _owner, string _name) internal returns (uint) {
117         
118         Titty memory _titty = Titty({
119             id: _id,
120             name: _name,
121             gender: _gender,
122             originalPrice: _price,
123             salePrice: _price,
124             accessories: new uint256[](0),
125             forSale: false
126         });
127 
128         uint256 newTittyId = Titties.push(_titty) - 1;
129 
130         Creation(
131             _owner,
132             newTittyId,
133             _id
134         );
135 
136         _transfer(0, _owner, newTittyId);
137         return newTittyId;
138     }
139 
140     
141 
142 }
143 
144 
145 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
146 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
147 contract ERC721 {
148     function implementsERC721() public pure returns (bool);
149     function totalSupply() public view returns (uint256 total);
150     function balanceOf(address _owner) public view returns (uint256 balance);
151     function ownerOf(uint256 _tokenId) public view returns (address owner);
152     function approve(address _to, uint256 _tokenId) public;
153     function transferFrom(address _from, address _to, uint256 _tokenId) public;
154     function transfer(address _to, uint256 _tokenId) public;
155     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
156     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
157 
158     // Optional
159     // function name() public view returns (string name);
160     // function symbol() public view returns (string symbol);
161     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
162     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
163 }
164 
165 
166 
167 
168 
169 
170 contract TittyOwnership is TittyBase, ERC721 {
171 
172     string public name = "CryptoTittes";
173     string public symbol = "CT";
174 
175     function implementsERC721() public pure returns (bool) {
176         return true;
177     }
178 
179     function _isOwner(address _user, uint256 _tittyId) internal view returns (bool) {
180         return tittyIndexToOwner[_tittyId] == _user;
181     }
182 
183     function _approve(uint256 _tittyId, address _approved) internal {
184          tittyApproveIndex[_tittyId] = _approved; 
185     }
186 
187     function _approveFor(address _user, uint256 _tittyId) internal view returns (bool) {
188          return tittyApproveIndex[_tittyId] == _user; 
189     }
190 
191     function totalSupply() public view returns (uint256 total) {
192         return Titties.length - 1;
193     }
194 
195     function balanceOf(address _owner) public view returns (uint256 balance) {
196         return ownerTittiesCount[_owner];
197     }
198     
199     function ownerOf(uint256 _tokenId) public view returns (address owner) {
200         owner = tittyIndexToOwner[_tokenId];
201         require(owner != address(0));
202     }
203 
204     function approve(address _to, uint256 _tokenId) public {
205         require(_isOwner(msg.sender, _tokenId));
206         _approve(_tokenId, _to);
207         Approval(msg.sender, _to, _tokenId);
208     }
209 
210     function transferFrom(address _from, address _to, uint256 _tokenId) public {
211         require(_approveFor(msg.sender, _tokenId));
212         require(_isOwner(_from, _tokenId));
213 
214         _transfer(_from, _to, _tokenId);
215         
216 
217     }
218     function transfer(address _to, uint256 _tokenId) public {
219         require(_to != address(0));
220         require(_isOwner(msg.sender, _tokenId));
221 
222         _transfer(msg.sender, _to, _tokenId);
223     }
224 
225 
226 
227 }
228 
229 contract TittyPurchase is TittyOwnership {
230 
231     address private wallet;
232     address private boat;
233 
234     function TittyPurchase(address _wallet, address _boat) public {
235         wallet = _wallet;
236         boat = _boat;
237 
238         createTitty(0, "unissex", 1000000000, address(0), "genesis");
239     }
240 
241     function purchaseNew(uint256 _id, string _name, string _gender, uint256 _price) public payable {
242 
243         if (msg.value == 0 && msg.value != _price)
244             revert();
245 
246         uint256 boatFee = calculateBoatFee(msg.value);
247         createTitty(_id, _gender, _price, msg.sender, _name);
248         wallet.transfer(msg.value - boatFee);
249         boat.transfer(boatFee);
250 
251     }
252 
253     function purchaseExistent(uint256 _tittyId) public payable {
254 
255         Titty storage titty = Titties[_tittyId];
256         uint256 fee = calculateFee(titty.salePrice);
257         if (msg.value == 0 && msg.value != titty.salePrice)
258             revert();
259         
260         uint256 val = msg.value - fee;
261         address owner = tittyIndexToOwner[_tittyId];
262         _approve(_tittyId, msg.sender);
263         transferFrom(owner, msg.sender, _tittyId);
264         owner.transfer(val);
265         wallet.transfer(fee);
266 
267     }
268 
269     function purchaseAccessory(uint256 _tittyId, uint256 _accId, string _name, uint256 _price) public payable {
270 
271         if (msg.value == 0 && msg.value != _price)
272             revert();
273 
274         wallet.transfer(msg.value);
275         addAccessory(_accId, _name, _price,  _tittyId);
276         
277         
278     }
279 
280     function getAmountOfTitties() public view returns(uint) {
281         return Titties.length;
282     }
283 
284     function getLatestId() public view returns (uint) {
285         return Titties.length - 1;
286     }
287 
288     function getTittyByWpId(address _owner, uint256 _wpId) public view returns (bool own, uint256 tittyId) {
289         
290         for (uint256 i = 1; i<=totalSupply(); i++) {
291             Titty storage titty = Titties[i];
292             bool isOwner = _isOwner(_owner, i);
293             if (titty.id == _wpId && isOwner) {
294                 return (true, i);
295             }
296         }
297         
298         return (false, 0);
299     }
300 
301     function belongsTo(address _account, uint256 _tittyId) public view returns (bool) {
302         return _isOwner(_account, _tittyId);
303     }
304 
305     function changePrice(uint256 _price, uint256 _tittyId) public {
306         _changeTittyPrice(_price, _tittyId);
307     }
308 
309     function changeName(string _name, uint256 _tittyId) public {
310         _changeName(_name, _tittyId);
311     }
312 
313     function makeItSellable(uint256 _tittyId) public {
314         _setTittyForSale(true, _tittyId);
315     }
316 
317     function calculateFee (uint256 _price) internal pure returns(uint) {
318         return (_price * 10)/100;
319     }
320 
321     function calculateBoatFee (uint256 _price) internal pure returns(uint) {
322         return (_price * 25)/100;
323     }
324 
325     function() external {}
326 
327     function getATitty(uint256 _tittyId)
328         public 
329         view 
330         returns (
331         uint256 id,
332         string name,
333         string gender,
334         uint256 originalPrice,
335         uint256 salePrice,
336         bool forSale
337         ) {
338 
339             Titty storage titty = Titties[_tittyId];
340             id = titty.id;
341             name = titty.name;
342             gender = titty.gender;
343             originalPrice = titty.originalPrice;
344             salePrice = titty.salePrice;
345             forSale = titty.forSale;
346         }
347 
348 }