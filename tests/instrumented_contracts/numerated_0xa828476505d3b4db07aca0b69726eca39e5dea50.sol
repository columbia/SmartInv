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
139   function create3DoggiesTokens() public onlyContractOwner {
140      uint256 totalDoggies = totalSupply();
141 	 
142 	 require (totalDoggies<1); // only 3 tokens for start
143 	 
144 	 for (uint8 i=1; i<=3; i++)
145 		_createDoggy("EthDoggy", address(this), startingPrice);
146 	
147   }
148   
149   function getDoggy(uint256 _tokenId) public view returns (string doggyName, uint256 sellingPrice, address owner) {
150     Doggy storage doggy = doggies[_tokenId];
151     doggyName = doggy.name;
152     sellingPrice = doggyIdToPrice[_tokenId];
153     owner = doggyIdToOwner[_tokenId];
154   }
155 
156   function implementsERC721() public pure returns (bool) {
157     return true;
158   }
159 
160   function name() public pure returns (string) { //ERC721
161     return NAME;
162   }
163 
164   function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721
165     owner = doggyIdToOwner[_tokenId];
166     require(owner != address(0));
167   }
168 
169   // Allows someone to send ether and obtain the token
170   function purchase(uint256 _tokenId) public payable {
171     address oldOwner = doggyIdToOwner[_tokenId];
172     address newOwner = msg.sender;
173 
174     uint256 sellingPrice = doggyIdToPrice[_tokenId];
175 
176     require(oldOwner != newOwner);
177     require(_addressNotNull(newOwner));
178     require(msg.value >= sellingPrice);
179 
180     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 9), 10)); //90% to previous owner
181     uint256 divs_payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 1), 20)); //5% divs
182     
183 	address divs_address = doggyIdToDivs[_tokenId];
184 	
185     // Next price will rise on 50%
186     doggyIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 3), 2)); 
187 
188     _transfer(oldOwner, newOwner, _tokenId);
189 
190     // Pay previous tokenOwner if owner is not contract
191     if (oldOwner != address(this)) {
192       oldOwner.transfer(payment); //
193     }
194 
195     // Pay winner tokenOwner if owner is not contract
196     if (divs_address != address(this)) {
197       divs_address.transfer(divs_payment); //
198     }
199 
200     TokenSold(_tokenId, sellingPrice, doggyIdToPrice[_tokenId], oldOwner, newOwner, doggies[_tokenId].name);
201 	
202     if (msg.value > sellingPrice) { //if excess pay
203 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
204 		msg.sender.transfer(purchaseExcess);
205 	}
206   }
207   
208   function changeDoggy(uint256 _tokenId) public payable { //
209     require(doggyIdToPrice[_tokenId] >= 1 ether);
210 	
211     require(doggyIdToOwner[_tokenId] == msg.sender && msg.value == 20 finney); //tax 0.02eth for change
212 	
213 	uint256 newPrice1 =  uint256(SafeMath.div(SafeMath.mul(doggyIdToPrice[_tokenId], 3), 10)); //30%
214 	uint256 newPrice2 =  uint256(SafeMath.div(SafeMath.mul(doggyIdToPrice[_tokenId], 7), 10)); //70%
215     
216     //get two doggies within one
217 	createDoggyToken("EthDoggy", newPrice1);
218 	createDoggyToken("EthDoggy", newPrice2);
219 	
220 	doggyIdToOwner[_tokenId] = address(this); //return changed doggy to doggypics
221 	doggyIdToPrice[_tokenId] = 10 finney;
222 	 
223   }
224 
225 
226   function symbol() public pure returns (string) { //ERC721
227     return SYMBOL;
228   }
229 
230 
231   function takeOwnership(uint256 _tokenId) public { //ERC721
232     address newOwner = msg.sender;
233     address oldOwner = doggyIdToOwner[_tokenId];
234 
235     require(_addressNotNull(newOwner));
236     require(_approved(newOwner, _tokenId));
237 
238     _transfer(oldOwner, newOwner, _tokenId);
239   }
240 
241   function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view
242     return doggyIdToPrice[_tokenId];
243   }
244 
245   function ALLownersANDprices(uint256 _startDoggyId) public view returns (address[] owners, address[] divs, uint256[] prices) { //for web site view
246 	
247 	uint256 totalDoggies = totalSupply();
248 	
249     if (totalDoggies == 0 || _startDoggyId >= totalDoggies) {
250         // Return an empty array
251       return (new address[](0),new address[](0),new uint256[](0));
252     }
253 	
254 	uint256 indexTo;
255 	if (totalDoggies > _startDoggyId+1000)
256 		indexTo = _startDoggyId + 1000;
257 	else 	
258 		indexTo = totalDoggies;
259 		
260     uint256 totalResultDoggies = indexTo - _startDoggyId;		
261 		
262 	address[] memory owners_res = new address[](totalResultDoggies);
263 	address[] memory divs_res = new address[](totalResultDoggies);
264 	uint256[] memory prices_res = new uint256[](totalResultDoggies);
265 	
266 	for (uint256 doggyId = _startDoggyId; doggyId < indexTo; doggyId++) {
267 	  owners_res[doggyId - _startDoggyId] = doggyIdToOwner[doggyId];
268 	  divs_res[doggyId - _startDoggyId] = doggyIdToDivs[doggyId];
269 	  prices_res[doggyId - _startDoggyId] = doggyIdToPrice[doggyId];
270 	}
271 	
272 	return (owners_res, divs_res, prices_res);
273   }
274   
275   function tokensOfOwner(address _owner) public view returns(uint256[] ownerToken) { //ERC721 for web site view
276     uint256 tokenCount = balanceOf(_owner);
277     if (tokenCount == 0) {
278         // Return an empty array
279       return new uint256[](0);
280     } else {
281       uint256[] memory result = new uint256[](tokenCount);
282       uint256 totalDoggies = totalSupply();
283       uint256 resultIndex = 0;
284 
285       uint256 doggyId;
286       for (doggyId = 0; doggyId <= totalDoggies; doggyId++) {
287         if (doggyIdToOwner[doggyId] == _owner) {
288           result[resultIndex] = doggyId;
289           resultIndex++;
290         }
291       }
292       return result;
293     }
294   }
295 
296   function totalSupply() public view returns (uint256 total) { //ERC721
297     return doggies.length;
298   }
299 
300   function transfer(address _to, uint256 _tokenId) public { //ERC721
301     require(_owns(msg.sender, _tokenId));
302     require(_addressNotNull(_to));
303 
304 	_transfer(msg.sender, _to, _tokenId);
305   }
306 
307   function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721
308     require(_owns(_from, _tokenId));
309     require(_approved(_to, _tokenId));
310     require(_addressNotNull(_to));
311 
312     _transfer(_from, _to, _tokenId);
313   }
314 
315 
316   /* PRIVATE FUNCTIONS */
317   function _addressNotNull(address _to) private pure returns (bool) {
318     return _to != address(0);
319   }
320 
321   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
322     return doggyIdToApproved[_tokenId] == _to;
323   }
324 
325   function _createDoggy(string _name, address _owner, uint256 _price) private {
326     Doggy memory _doggy = Doggy({
327       name: _name
328     });
329     uint256 newDoggyId = doggies.push(_doggy) - 1;
330 
331     require(newDoggyId == uint256(uint32(newDoggyId))); //check maximum limit of tokens
332 
333     DoggyCreated(newDoggyId, _name, _owner);
334 
335     doggyIdToPrice[newDoggyId] = _price;
336 	doggyIdToDivs[newDoggyId] = _owner; //dividents address;
337 
338     _transfer(address(0), _owner, newDoggyId);
339   }
340 
341   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
342     return _checkedAddr == doggyIdToOwner[_tokenId];
343   }
344 
345 function _transfer(address _from, address _to, uint256 _tokenId) private {
346     ownershipTokenCount[_to]++;
347     doggyIdToOwner[_tokenId] = _to;
348 
349     // When creating new doggies _from is 0x0, but we can't account that address.
350     if (_from != address(0)) {
351       ownershipTokenCount[_from]--;
352       // clear any previously approved ownership exchange
353       delete doggyIdToApproved[_tokenId];
354     }
355 
356     // Emit the transfer event.
357     Transfer(_from, _to, _tokenId);
358   }
359 }