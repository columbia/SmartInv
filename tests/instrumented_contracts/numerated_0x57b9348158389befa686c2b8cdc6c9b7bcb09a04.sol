1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46 
47   address public contractOwner;
48 
49   event ContractOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51   function Ownable() public {
52     contractOwner = msg.sender;
53   }
54 
55   modifier onlyContractOwner() {
56     require(msg.sender == contractOwner);
57     _;
58   }
59 
60   function transferContractOwnership(address _newOwner) public onlyContractOwner {
61     require(_newOwner != address(0));
62     ContractOwnershipTransferred(contractOwner, _newOwner);
63     contractOwner = _newOwner;
64   }
65   
66   function payoutFromContract() public onlyContractOwner {
67       contractOwner.transfer(this.balance);
68   }  
69 
70 }
71 
72 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
73 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
74 contract ERC721 {
75   // Required methods
76   function approve(address _to, uint256 _tokenId) public;
77   function balanceOf(address _owner) public view returns (uint256 balance);
78   function implementsERC721() public pure returns (bool);
79   function ownerOf(uint256 _tokenId) public view returns (address addr);
80   function takeOwnership(uint256 _tokenId) public;
81   function totalSupply() public view returns (uint256 total);
82   function transferFrom(address _from, address _to, uint256 _tokenId) public;
83   function transfer(address _to, uint256 _tokenId) public;
84 
85   event Transfer(address indexed from, address indexed to, uint256 tokenId);
86   event Approval(address indexed owner, address indexed approved, uint256 tokenId);
87 
88   // Optional
89   // function name() public view returns (string name);
90   // function symbol() public view returns (string symbol);
91   // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
92   // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
93   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
94 }
95 
96 contract DoggyEthPics is ERC721, Ownable {
97 
98   event DoggyCreated(uint256 tokenId, string name, address owner);
99   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
100   event Transfer(address from, address to, uint256 tokenId);
101 
102   string public constant NAME = "DoggyEthPics";
103   string public constant SYMBOL = "DoggyPicsToken";
104 
105   uint256 private startingPrice = 0.01 ether;
106 
107   mapping (uint256 => address) public doggyIdToOwner;
108 
109   mapping (uint256 => address) public doggyIdToDivs;
110 
111   mapping (address => uint256) private ownershipTokenCount;
112 
113   mapping (uint256 => address) public doggyIdToApproved;
114 
115   mapping (uint256 => uint256) private doggyIdToPrice;
116 
117   /*** DATATYPES ***/
118   struct Doggy {
119     string name;
120   }
121 
122   Doggy[] private doggies;
123 
124   function approve(address _to, uint256 _tokenId) public { //ERC721
125     // Caller must own token.
126     require(_owns(msg.sender, _tokenId));
127     doggyIdToApproved[_tokenId] = _to;
128     Approval(msg.sender, _to, _tokenId);
129   }
130 
131   function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721
132     return ownershipTokenCount[_owner];
133   }
134 
135   function createDoggyToken(string _name, uint256 _price) private {
136     _createDoggy(_name, msg.sender, _price);
137   }
138 
139   function create3DoggiesTokens() public onlyContractOwner { //migration
140 	  _createDoggy("EthDoggy", 0xe6c58f8e459fe570afff5b4622990ea1744f0e28, 384433593750000000);
141 	  _createDoggy("EthDoggy", 0x5632ca98e5788eddb2397757aa82d1ed6171e5ad, 384433593750000000);
142 	  _createDoggy("EthDoggy", 0x7cd84443027d2e19473c3657f167ada34417654f, 576650390625000000);
143 	
144   }
145   
146   function getDoggy(uint256 _tokenId) public view returns (string doggyName, uint256 sellingPrice, address owner) {
147     Doggy storage doggy = doggies[_tokenId];
148     doggyName = doggy.name;
149     sellingPrice = doggyIdToPrice[_tokenId];
150     owner = doggyIdToOwner[_tokenId];
151   }
152 
153   function implementsERC721() public pure returns (bool) {
154     return true;
155   }
156 
157   function name() public pure returns (string) { //ERC721
158     return NAME;
159   }
160 
161   function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721
162     owner = doggyIdToOwner[_tokenId];
163     require(owner != address(0));
164   }
165 
166   // Allows someone to send ether and obtain the token
167   function purchase(uint256 _tokenId) public payable {
168     address oldOwner = doggyIdToOwner[_tokenId];
169     address newOwner = msg.sender;
170 
171     uint256 sellingPrice = doggyIdToPrice[_tokenId];
172 
173     require(oldOwner != newOwner);
174     require(_addressNotNull(newOwner));
175     require(msg.value >= sellingPrice);
176 
177     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 9), 10)); //90% to previous owner
178     uint256 divs_payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 1), 20)); //5% divs
179     
180 	address divs_address = doggyIdToDivs[_tokenId];
181 	
182     // Next price will rise on 50%
183     doggyIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 3), 2)); 
184 
185     _transfer(oldOwner, newOwner, _tokenId);
186 
187     // Pay previous tokenOwner if owner is not contract
188     if (oldOwner != address(this)) {
189       oldOwner.transfer(payment); //
190     }
191 
192     // Pay winner tokenOwner if owner is not contract
193     if (divs_address != address(this)) {
194       divs_address.transfer(divs_payment); //
195     }
196 
197     TokenSold(_tokenId, sellingPrice, doggyIdToPrice[_tokenId], oldOwner, newOwner, doggies[_tokenId].name);
198 	
199     if (msg.value > sellingPrice) { //if excess pay
200 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
201 		msg.sender.transfer(purchaseExcess);
202 	}
203   }
204   
205   function changeDoggy(uint256 _tokenId) public payable { //
206     require(doggyIdToPrice[_tokenId] >= 500 finney);
207 	
208     require(doggyIdToOwner[_tokenId] == msg.sender && msg.value == 20 finney); //tax 0.02eth for change
209 	
210 	uint256 newPrice1 =  uint256(SafeMath.div(SafeMath.mul(doggyIdToPrice[_tokenId], 3), 10)); //30%
211 	uint256 newPrice2 =  uint256(SafeMath.div(SafeMath.mul(doggyIdToPrice[_tokenId], 7), 10)); //70%
212     
213     //get two doggies within one
214 	createDoggyToken("EthDoggy", newPrice1);
215 	createDoggyToken("EthDoggy", newPrice2);
216 	
217 	doggyIdToOwner[_tokenId] = address(this); //return changed doggy to doggypics
218 	doggyIdToPrice[_tokenId] = 10 finney;
219 	 
220   }
221 
222 
223   function symbol() public pure returns (string) { //ERC721
224     return SYMBOL;
225   }
226 
227 
228   function takeOwnership(uint256 _tokenId) public { //ERC721
229     address newOwner = msg.sender;
230     address oldOwner = doggyIdToOwner[_tokenId];
231 
232     require(_addressNotNull(newOwner));
233     require(_approved(newOwner, _tokenId));
234 
235     _transfer(oldOwner, newOwner, _tokenId);
236   }
237 
238   function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view
239     return doggyIdToPrice[_tokenId];
240   }
241 
242   function ALLownersANDprices(uint256 _startDoggyId) public view returns (address[] owners, address[] divs, uint256[] prices) { //for web site view
243 	
244 	uint256 totalDoggies = totalSupply();
245 	
246     if (totalDoggies == 0 || _startDoggyId >= totalDoggies) {
247         // Return an empty array
248       return (new address[](0),new address[](0),new uint256[](0));
249     }
250 	
251 	uint256 indexTo;
252 	if (totalDoggies > _startDoggyId+1000)
253 		indexTo = _startDoggyId + 1000;
254 	else 	
255 		indexTo = totalDoggies;
256 		
257     uint256 totalResultDoggies = indexTo - _startDoggyId;		
258 		
259 	address[] memory owners_res = new address[](totalResultDoggies);
260 	address[] memory divs_res = new address[](totalResultDoggies);
261 	uint256[] memory prices_res = new uint256[](totalResultDoggies);
262 	
263 	for (uint256 doggyId = _startDoggyId; doggyId < indexTo; doggyId++) {
264 	  owners_res[doggyId - _startDoggyId] = doggyIdToOwner[doggyId];
265 	  divs_res[doggyId - _startDoggyId] = doggyIdToDivs[doggyId];
266 	  prices_res[doggyId - _startDoggyId] = doggyIdToPrice[doggyId];
267 	}
268 	
269 	return (owners_res, divs_res, prices_res);
270   }
271   
272   function tokensOfOwner(address _owner) public view returns(uint256[] ownerToken) { //ERC721 for web site view
273     uint256 tokenCount = balanceOf(_owner);
274     if (tokenCount == 0) {
275         // Return an empty array
276       return new uint256[](0);
277     } else {
278       uint256[] memory result = new uint256[](tokenCount);
279       uint256 totalDoggies = totalSupply();
280       uint256 resultIndex = 0;
281 
282       uint256 doggyId;
283       for (doggyId = 0; doggyId <= totalDoggies; doggyId++) {
284         if (doggyIdToOwner[doggyId] == _owner) {
285           result[resultIndex] = doggyId;
286           resultIndex++;
287         }
288       }
289       return result;
290     }
291   }
292 
293   function totalSupply() public view returns (uint256 total) { //ERC721
294     return doggies.length;
295   }
296 
297   function transfer(address _to, uint256 _tokenId) public { //ERC721
298     require(_owns(msg.sender, _tokenId));
299     require(_addressNotNull(_to));
300 
301 	_transfer(msg.sender, _to, _tokenId);
302   }
303 
304   function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721
305     require(_owns(_from, _tokenId));
306     require(_approved(_to, _tokenId));
307     require(_addressNotNull(_to));
308 
309     _transfer(_from, _to, _tokenId);
310   }
311 
312 
313   /* PRIVATE FUNCTIONS */
314   function _addressNotNull(address _to) private pure returns (bool) {
315     return _to != address(0);
316   }
317 
318   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
319     return doggyIdToApproved[_tokenId] == _to;
320   }
321 
322   function _createDoggy(string _name, address _owner, uint256 _price) private {
323     Doggy memory _doggy = Doggy({
324       name: _name
325     });
326     uint256 newDoggyId = doggies.push(_doggy) - 1;
327 
328     require(newDoggyId == uint256(uint32(newDoggyId))); //check maximum limit of tokens
329 
330     DoggyCreated(newDoggyId, _name, _owner);
331 
332     doggyIdToPrice[newDoggyId] = _price;
333 	
334 	if (newDoggyId<3) //migration
335 		doggyIdToDivs[newDoggyId] = 0xa828476505d3b4db07aca0b69726eca39e5dea50; //dividents address;
336 	else 
337 		doggyIdToDivs[newDoggyId] = _owner; //dividents address;
338 
339     _transfer(address(0), _owner, newDoggyId);
340   }
341 
342   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
343     return _checkedAddr == doggyIdToOwner[_tokenId];
344   }
345 
346 function _transfer(address _from, address _to, uint256 _tokenId) private {
347     ownershipTokenCount[_to]++;
348     doggyIdToOwner[_tokenId] = _to;
349 
350     // When creating new doggies _from is 0x0, but we can't account that address.
351     if (_from != address(0)) {
352       ownershipTokenCount[_from]--;
353       // clear any previously approved ownership exchange
354       delete doggyIdToApproved[_tokenId];
355     }
356 
357     // Emit the transfer event.
358     Transfer(_from, _to, _tokenId);
359   }
360 }