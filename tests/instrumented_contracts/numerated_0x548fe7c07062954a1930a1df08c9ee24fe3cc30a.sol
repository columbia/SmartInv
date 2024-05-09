1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34 
35   address public contractOwner;
36 
37   event ContractOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39   function Ownable() public {
40     contractOwner = msg.sender;
41   }
42 
43   modifier onlyContractOwner() {
44     require(msg.sender == contractOwner);
45     _;
46   }
47 
48   function transferContractOwnership(address _newOwner) public onlyContractOwner {
49     require(_newOwner != address(0));
50     ContractOwnershipTransferred(contractOwner, _newOwner);
51     contractOwner = _newOwner;
52   }
53   
54   function payoutFromContract() public onlyContractOwner {
55       contractOwner.transfer(this.balance);
56   }  
57 
58 }
59 
60 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
61 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
62 contract ERC721 {
63   // Required methods
64   function approve(address _to, uint256 _tokenId) public;
65   function balanceOf(address _owner) public view returns (uint256 balance);
66   function implementsERC721() public pure returns (bool);
67   function ownerOf(uint256 _tokenId) public view returns (address addr);
68   function takeOwnership(uint256 _tokenId) public;
69   function totalSupply() public view returns (uint256 total);
70   function transferFrom(address _from, address _to, uint256 _tokenId) public;
71   function transfer(address _to, uint256 _tokenId) public;
72 
73   event Transfer(address indexed from, address indexed to, uint256 tokenId);
74   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
75 
76   // Optional
77   // function name() public view returns (string name);
78   // function symbol() public view returns (string symbol);
79   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
80   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
81 }
82 
83 contract CryptoDrinks is ERC721, Ownable {
84 
85   event DrinkCreated(uint256 tokenId, string name, address owner);
86   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
87   event Transfer(address from, address to, uint256 tokenId);
88 
89   string public constant NAME = "CryptoDrinks";
90   string public constant SYMBOL = "DrinksToken";
91 
92   uint256 private startingPrice = 0.02 ether;
93   
94   uint256 private startTime = now;
95 
96   mapping (uint256 => address) public drinkIdToOwner;
97 
98   mapping (address => uint256) private ownershipTokenCount;
99 
100   mapping (uint256 => address) public drinkIdToApproved;
101 
102   mapping (uint256 => uint256) private drinkIdToPrice;
103 
104   /*** DATATYPES ***/
105   struct Drink {
106     string name;
107   }
108 
109   Drink[] private drinks;
110 
111   function approve(address _to, uint256 _tokenId) public { //ERC721
112     // Caller must own token.
113     require(_owns(msg.sender, _tokenId));
114     drinkIdToApproved[_tokenId] = _to;
115     Approval(msg.sender, _to, _tokenId);
116   }
117 
118   function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721
119     return ownershipTokenCount[_owner];
120   }
121 
122   function createOneDrink(string _name) public onlyContractOwner {
123     _createDrink(_name, address(this), startingPrice);
124   }
125 
126   function createManyDrinks() public onlyContractOwner {
127      uint256 totalDrinks = totalSupply();
128 	 
129      require (totalDrinks < 1);
130 	 
131  	 _createDrink("Barmen", address(this), 1 ether);
132  	 _createDrink("Vodka", address(this), startingPrice);
133 	 _createDrink("Wine", address(this), startingPrice);
134 	 _createDrink("Cognac", address(this), startingPrice);
135 	 _createDrink("Martini", address(this), startingPrice);
136 	 _createDrink("Beer", address(this), startingPrice);
137 	 _createDrink("Tequila", address(this), startingPrice);
138 	 _createDrink("Whiskey", address(this), startingPrice);
139 	 _createDrink("Baileys", address(this), startingPrice);
140 	 _createDrink("Champagne", address(this), startingPrice);
141   }
142   
143   function getDrink(uint256 _tokenId) public view returns (string drinkName, uint256 sellingPrice, address owner) {
144     Drink storage drink = drinks[_tokenId];
145     drinkName = drink.name;
146     sellingPrice = drinkIdToPrice[_tokenId];
147     owner = drinkIdToOwner[_tokenId];
148   }
149 
150   function implementsERC721() public pure returns (bool) {
151     return true;
152   }
153 
154   function name() public pure returns (string) { //ERC721
155     return NAME;
156   }
157 
158   function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721
159     owner = drinkIdToOwner[_tokenId];
160     require(owner != address(0));
161   }
162 
163   // Allows someone to send ether and obtain the token
164   function purchase(uint256 _tokenId) public payable {
165   
166 	require (now - startTime >= 10800 || _tokenId==0); //3 hours
167 	
168     address oldOwner = drinkIdToOwner[_tokenId];
169     address newOwner = msg.sender;
170 
171     uint256 sellingPrice = drinkIdToPrice[_tokenId];
172 
173     require(oldOwner != newOwner);
174     require(_addressNotNull(newOwner));
175     require(msg.value >= sellingPrice);
176 
177     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 9), 10)); //90% to previous owner
178     uint256 barmen_payment = uint256(SafeMath.div(sellingPrice, 10)); //10% to barmen
179 
180 	address barmen = ownerOf(0);
181 	
182     // Next price will in 2 times more if it less then 1 ether.
183 	if (sellingPrice >= 1 ether)
184 		drinkIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 3), 2));
185 	else 	
186 		drinkIdToPrice[_tokenId] = uint256(SafeMath.mul(sellingPrice, 2));
187 
188     _transfer(oldOwner, newOwner, _tokenId);
189 
190     // Pay previous tokenOwner if owner is not contract
191     if (oldOwner != address(this)) {
192       oldOwner.transfer(payment); //
193     }
194 
195     // Pay 10% to barmen, if drink sold
196 	// token 0 not drink, its barmen
197     if (_tokenId > 0) {
198       barmen.transfer(barmen_payment); //
199     }
200 
201     TokenSold(_tokenId, sellingPrice, drinkIdToPrice[_tokenId], oldOwner, newOwner, drinks[_tokenId].name);
202 	
203     if (msg.value > sellingPrice) { //if excess pay
204 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
205 		msg.sender.transfer(purchaseExcess);
206 	}
207   }
208 
209   function secondsAfterStart() public view returns (uint256) { //ERC721
210     return uint256(now - startTime);
211   }
212   
213   function symbol() public pure returns (string) { //ERC721
214     return SYMBOL;
215   }
216 
217 
218   function takeOwnership(uint256 _tokenId) public { //ERC721
219     address newOwner = msg.sender;
220     address oldOwner = drinkIdToOwner[_tokenId];
221 
222     require(_addressNotNull(newOwner));
223     require(_approved(newOwner, _tokenId));
224 
225     _transfer(oldOwner, newOwner, _tokenId);
226   }
227 
228   function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view
229     return drinkIdToPrice[_tokenId];
230   }
231   
232   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) { //for web site view
233     uint256 tokenCount = balanceOf(_owner);
234     if (tokenCount == 0) {
235         // Return an empty array
236       return new uint256[](0);
237     } else {
238       uint256[] memory result = new uint256[](tokenCount);
239       uint256 totalDrinks = totalSupply();
240       uint256 resultIndex = 0;
241 
242       uint256 drinkId;
243       for (drinkId = 0; drinkId <= totalDrinks; drinkId++) {
244         if (drinkIdToOwner[drinkId] == _owner) {
245           result[resultIndex] = drinkId;
246           resultIndex++;
247         }
248       }
249       return result;
250     }
251   }
252 
253   function totalSupply() public view returns (uint256 total) { //ERC721
254     return drinks.length;
255   }
256 
257   function transfer(address _to, uint256 _tokenId) public { //ERC721
258     require(_owns(msg.sender, _tokenId));
259     require(_addressNotNull(_to));
260 
261 	_transfer(msg.sender, _to, _tokenId);
262   }
263 
264   function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721
265     require(_owns(_from, _tokenId));
266     require(_approved(_to, _tokenId));
267     require(_addressNotNull(_to));
268 
269     _transfer(_from, _to, _tokenId);
270   }
271 
272 
273   /* PRIVATE FUNCTIONS */
274   function _addressNotNull(address _to) private pure returns (bool) {
275     return _to != address(0);
276   }
277 
278   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
279     return drinkIdToApproved[_tokenId] == _to;
280   }
281 
282   function _createDrink(string _name, address _owner, uint256 _price) private {
283     Drink memory _drink = Drink({
284       name: _name
285     });
286     uint256 newDrinkId = drinks.push(_drink) - 1;
287 
288     require(newDrinkId == uint256(uint32(newDrinkId))); //check maximum limit of tokens
289 
290     DrinkCreated(newDrinkId, _name, _owner);
291 
292     drinkIdToPrice[newDrinkId] = _price;
293 
294     _transfer(address(0), _owner, newDrinkId);
295   }
296 
297   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
298     return _checkedAddr == drinkIdToOwner[_tokenId];
299   }
300 
301 function _transfer(address _from, address _to, uint256 _tokenId) private {
302     ownershipTokenCount[_to]++;
303     drinkIdToOwner[_tokenId] = _to;
304 
305     // When creating new drinks _from is 0x0, but we can't account that address.
306     if (_from != address(0)) {
307       ownershipTokenCount[_from]--;
308       // clear any previously approved ownership exchange
309       delete drinkIdToApproved[_tokenId];
310     }
311 
312     // Emit the transfer event.
313     Transfer(_from, _to, _tokenId);
314   }
315 }