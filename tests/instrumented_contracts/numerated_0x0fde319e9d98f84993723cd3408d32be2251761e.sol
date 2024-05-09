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
140 	  _createDoggy("EthDoggy", 0x4844928357e83855b1b9fbacf65947fe1ff48e26, 170859375000000000);
141 	  _createDoggy("EthDoggy", 0x5632ca98e5788eddb2397757aa82d1ed6171e5ad, 384433593750000000);
142 	  _createDoggy("EthDoggy", 0x28d02f67316123dc0293849a0d254ad86b379b34, 113906250000000000);
143 	  _createDoggy("EthDoggy", 0x28d02f67316123dc0293849a0d254ad86b379b34, 172995117187500000);
144 	  _createDoggy("EthDoggy", 0x7cd84443027d2e19473c3657f167ada34417654f, 113906250000000000);
145 	  _createDoggy("EthDoggy", 0x7cd84443027d2e19473c3657f167ada34417654f, 172995117187500000);
146 	  _createDoggy("EthDoggy", 0x7cd84443027d2e19473c3657f167ada34417654f, 403655273437500000);
147 	  _createDoggy("EthDoggy", 0xe6c58f8e459fe570afff5b4622990ea1744f0e28, 181644873046875000);
148 	  _createDoggy("EthDoggy", 0xe6c58f8e459fe570afff5b4622990ea1744f0e28, 423838037109375000);
149 	  
150   }
151   
152   function getDoggy(uint256 _tokenId) public view returns (string doggyName, uint256 sellingPrice, address owner) {
153     Doggy storage doggy = doggies[_tokenId];
154     doggyName = doggy.name;
155     sellingPrice = doggyIdToPrice[_tokenId];
156     owner = doggyIdToOwner[_tokenId];
157   }
158 
159   function implementsERC721() public pure returns (bool) {
160     return true;
161   }
162 
163   function name() public pure returns (string) { //ERC721
164     return NAME;
165   }
166 
167   function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721
168     owner = doggyIdToOwner[_tokenId];
169     require(owner != address(0));
170   }
171 
172   // Allows someone to send ether and obtain the token
173   function purchase(uint256 _tokenId) public payable {
174     address oldOwner = doggyIdToOwner[_tokenId];
175     address newOwner = msg.sender;
176 
177     uint256 sellingPrice = doggyIdToPrice[_tokenId];
178 
179     require(oldOwner != newOwner);
180     require(_addressNotNull(newOwner));
181     require(msg.value >= sellingPrice);
182 
183     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 9), 10)); //90% to previous owner
184     uint256 divs_payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 1), 20)); //5% divs
185     
186 	address divs_address = doggyIdToDivs[_tokenId];
187 	
188     // Next price will rise on 50%
189     doggyIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 3), 2)); 
190 
191     _transfer(oldOwner, newOwner, _tokenId);
192 
193     // Pay previous tokenOwner if owner is not contract
194     if (oldOwner != address(this)) {
195       oldOwner.transfer(payment); //
196     }
197 
198     // Pay winner tokenOwner if owner is not contract
199     if (divs_address != address(this)) {
200       divs_address.transfer(divs_payment); //
201     }
202 
203     TokenSold(_tokenId, sellingPrice, doggyIdToPrice[_tokenId], oldOwner, newOwner, doggies[_tokenId].name);
204 	
205     if (msg.value > sellingPrice) { //if excess pay
206 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
207 		msg.sender.transfer(purchaseExcess);
208 	}
209   }
210   
211   function changeDoggy(uint256 _tokenId) public payable { //
212     require(doggyIdToPrice[_tokenId] >= 300 finney);
213 	
214     require(doggyIdToOwner[_tokenId] == msg.sender && msg.value == 20 finney); //tax 0.02eth for change
215 	
216 	uint256 newPrice1 =  uint256(SafeMath.div(SafeMath.mul(doggyIdToPrice[_tokenId], 3), 10)); //30%
217 	uint256 newPrice2 =  uint256(SafeMath.div(SafeMath.mul(doggyIdToPrice[_tokenId], 7), 10)); //70%
218     
219     //get two doggies within one
220 	createDoggyToken("EthDoggy", newPrice1);
221 	createDoggyToken("EthDoggy", newPrice2);
222 	
223 	doggyIdToOwner[_tokenId] = address(this); //return changed doggy to doggypics
224 	doggyIdToPrice[_tokenId] = 10 finney;
225 	 
226   }
227 
228 
229   function symbol() public pure returns (string) { //ERC721
230     return SYMBOL;
231   }
232 
233 
234   function takeOwnership(uint256 _tokenId) public { //ERC721
235     address newOwner = msg.sender;
236     address oldOwner = doggyIdToOwner[_tokenId];
237 
238     require(_addressNotNull(newOwner));
239     require(_approved(newOwner, _tokenId));
240 
241     _transfer(oldOwner, newOwner, _tokenId);
242   }
243 
244   function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view
245     return doggyIdToPrice[_tokenId];
246   }
247 
248   function ALLownersANDprices(uint256 _startDoggyId) public view returns (address[] owners, address[] divs, uint256[] prices) { //for web site view
249 	
250 	uint256 totalDoggies = totalSupply();
251 	
252     if (totalDoggies == 0 || _startDoggyId >= totalDoggies) {
253         // Return an empty array
254       return (new address[](0),new address[](0),new uint256[](0));
255     }
256 	
257 	uint256 indexTo;
258 	if (totalDoggies > _startDoggyId+1000)
259 		indexTo = _startDoggyId + 1000;
260 	else 	
261 		indexTo = totalDoggies;
262 		
263     uint256 totalResultDoggies = indexTo - _startDoggyId;		
264 		
265 	address[] memory owners_res = new address[](totalResultDoggies);
266 	address[] memory divs_res = new address[](totalResultDoggies);
267 	uint256[] memory prices_res = new uint256[](totalResultDoggies);
268 	
269 	for (uint256 doggyId = _startDoggyId; doggyId < indexTo; doggyId++) {
270 	  owners_res[doggyId - _startDoggyId] = doggyIdToOwner[doggyId];
271 	  divs_res[doggyId - _startDoggyId] = doggyIdToDivs[doggyId];
272 	  prices_res[doggyId - _startDoggyId] = doggyIdToPrice[doggyId];
273 	}
274 	
275 	return (owners_res, divs_res, prices_res);
276   }
277   
278   function tokensOfOwner(address _owner) public view returns(uint256[] ownerToken) { //ERC721 for web site view
279     uint256 tokenCount = balanceOf(_owner);
280     if (tokenCount == 0) {
281         // Return an empty array
282       return new uint256[](0);
283     } else {
284       uint256[] memory result = new uint256[](tokenCount);
285       uint256 totalDoggies = totalSupply();
286       uint256 resultIndex = 0;
287 
288       uint256 doggyId;
289       for (doggyId = 0; doggyId <= totalDoggies; doggyId++) {
290         if (doggyIdToOwner[doggyId] == _owner) {
291           result[resultIndex] = doggyId;
292           resultIndex++;
293         }
294       }
295       return result;
296     }
297   }
298 
299   function totalSupply() public view returns (uint256 total) { //ERC721
300     return doggies.length;
301   }
302 
303   function transfer(address _to, uint256 _tokenId) public { //ERC721
304     require(_owns(msg.sender, _tokenId));
305     require(_addressNotNull(_to));
306 
307 	_transfer(msg.sender, _to, _tokenId);
308   }
309 
310   function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721
311     require(_owns(_from, _tokenId));
312     require(_approved(_to, _tokenId));
313     require(_addressNotNull(_to));
314 
315     _transfer(_from, _to, _tokenId);
316   }
317 
318 
319   /* PRIVATE FUNCTIONS */
320   function _addressNotNull(address _to) private pure returns (bool) {
321     return _to != address(0);
322   }
323 
324   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
325     return doggyIdToApproved[_tokenId] == _to;
326   }
327 
328   function _createDoggy(string _name, address _owner, uint256 _price) private {
329     Doggy memory _doggy = Doggy({
330       name: _name
331     });
332     uint256 newDoggyId = doggies.push(_doggy) - 1;
333 
334     require(newDoggyId == uint256(uint32(newDoggyId))); //check maximum limit of tokens
335 
336     DoggyCreated(newDoggyId, _name, _owner);
337 
338     doggyIdToPrice[newDoggyId] = _price;
339 	
340 	if (newDoggyId<3) //migration
341 		doggyIdToDivs[newDoggyId] = address(this); //dividents address;
342 	else if (newDoggyId>2 && newDoggyId<=4) 
343 		doggyIdToDivs[newDoggyId] = address(0x28d02f67316123dc0293849a0d254ad86b379b34); //dividents address;
344 	else if (newDoggyId>4 && newDoggyId<=6) 
345 		doggyIdToDivs[newDoggyId] = address(0x7cd84443027d2e19473c3657f167ada34417654f); //dividents address;
346 	else if (newDoggyId>6 && newDoggyId<=8) 
347 		doggyIdToDivs[newDoggyId] = address(0xe6c58f8e459fe570afff5b4622990ea1744f0e28); //dividents address;
348 	else 
349 		doggyIdToDivs[newDoggyId] = _owner; //dividents address;
350 
351     _transfer(address(0), _owner, newDoggyId);
352   }
353 
354   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
355     return _checkedAddr == doggyIdToOwner[_tokenId];
356   }
357 
358 function _transfer(address _from, address _to, uint256 _tokenId) private {
359     ownershipTokenCount[_to]++;
360     doggyIdToOwner[_tokenId] = _to;
361 
362     // When creating new doggies _from is 0x0, but we can't account that address.
363     if (_from != address(0)) {
364       ownershipTokenCount[_from]--;
365       // clear any previously approved ownership exchange
366       delete doggyIdToApproved[_tokenId];
367     }
368 
369     // Emit the transfer event.
370     Transfer(_from, _to, _tokenId);
371   }
372 }