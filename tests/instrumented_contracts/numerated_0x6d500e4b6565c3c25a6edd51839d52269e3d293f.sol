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
92   // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
93 }
94 
95 contract KiddyToys is ERC721, Ownable {
96 
97   event ToyCreated(uint256 tokenId, string name, address owner);
98   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
99   event Transfer(address from, address to, uint256 tokenId);
100 
101   string public constant NAME = "KiddyToys";
102   string public constant SYMBOL = "ToyToken";
103 
104   uint256 private startingPrice = 0.01 ether;
105 
106   mapping (uint256 => address) public toyIdToOwner;
107 
108   mapping (address => uint256) private ownershipTokenCount;
109 
110   mapping (uint256 => address) public toyIdToApproved;
111 
112   mapping (uint256 => uint256) private toyIdToPrice;
113 
114   /*** DATATYPES ***/
115   struct Toy {
116     string name;
117   }
118 
119   Toy[] private toys;
120 
121   function approve(address _to, uint256 _tokenId) public { //ERC721
122     // Caller must own token.
123     require(_owns(msg.sender, _tokenId));
124     toyIdToApproved[_tokenId] = _to;
125     Approval(msg.sender, _to, _tokenId);
126   }
127 
128   function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721
129     return ownershipTokenCount[_owner];
130   }
131 
132   function createContractToy(string _name) public onlyContractOwner {
133     _createToy(_name, address(this), startingPrice);
134   }
135 
136   function create20ContractToy() public onlyContractOwner {
137      uint256 totalToys = totalSupply();
138 	 
139      require (totalToys < 1);
140 	 
141  	 _createToy("Sandy train", address(this), startingPrice);
142  	 _createToy("Red Teddy", address(this), startingPrice);
143 	 _createToy("Brown Teddy", address(this), startingPrice);
144 	 _createToy("White Horsy", address(this), startingPrice);
145 	 _createToy("Blue rocking Horsy", address(this), startingPrice);
146 	 _createToy("Arch pyramid", address(this), startingPrice);
147 	 _createToy("Sandy rocking Horsy", address(this), startingPrice);
148 	 _createToy("Letter cubes", address(this), startingPrice);
149 	 _createToy("Ride carousel", address(this), startingPrice);
150 	 _createToy("Town car", address(this), startingPrice);
151 	 _createToy("Nighty train", address(this), startingPrice);
152 	 _createToy("Big circles piramid", address(this), startingPrice);
153 	 _createToy("Small circles piramid", address(this), startingPrice);
154 	 _createToy("Red lamp", address(this), startingPrice);
155 	 _createToy("Ducky", address(this), startingPrice);
156 	 _createToy("Small ball", address(this), startingPrice);
157 	 _createToy("Big ball", address(this), startingPrice);
158 	 _createToy("Digital cubes", address(this), startingPrice);
159 	 _createToy("Small Dolly", address(this), startingPrice);
160 	 _createToy("Big Dolly", address(this), startingPrice);
161   }
162   
163   function getToy(uint256 _tokenId) public view returns (string toyName, uint256 sellingPrice, address owner) {
164     Toy storage toy = toys[_tokenId];
165     toyName = toy.name;
166     sellingPrice = toyIdToPrice[_tokenId];
167     owner = toyIdToOwner[_tokenId];
168   }
169 
170   function implementsERC721() public pure returns (bool) {
171     return true;
172   }
173 
174   function name() public pure returns (string) { //ERC721
175     return NAME;
176   }
177 
178   function ownerOf(uint256 _tokenId) public view returns (address owner) { //ERC721
179     owner = toyIdToOwner[_tokenId];
180     require(owner != address(0));
181   }
182 
183   // Allows someone to send ether and obtain the token
184   function purchase(uint256 _tokenId) public payable {
185     address oldOwner = toyIdToOwner[_tokenId];
186     address newOwner = msg.sender;
187 
188     uint256 sellingPrice = toyIdToPrice[_tokenId];
189 
190     require(oldOwner != newOwner);
191     require(_addressNotNull(newOwner));
192     require(msg.value >= sellingPrice);
193 
194     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 9), 10)); //90% to previous owner
195     uint256 win_payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 9), 180)); //5% to random owner
196 
197     uint256 randomToyId = uint256(block.blockhash(block.number-1))%20;
198 	address winner = toyIdToOwner[randomToyId];
199 	
200     // Next price will in 2 times more.
201     toyIdToPrice[_tokenId] = SafeMath.mul(sellingPrice, 2);
202 
203     _transfer(oldOwner, newOwner, _tokenId);
204 
205     // Pay previous tokenOwner if owner is not contract
206     if (oldOwner != address(this)) {
207       oldOwner.transfer(payment); //
208     }
209 
210     // Pay winner tokenOwner if owner is not contract
211     if (winner != address(this)) {
212       winner.transfer(win_payment); //
213     }
214 
215     TokenSold(_tokenId, sellingPrice, toyIdToPrice[_tokenId], oldOwner, newOwner, toys[_tokenId].name);
216 	
217     if (msg.value > sellingPrice) { //if excess pay
218 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
219 		msg.sender.transfer(purchaseExcess);
220 	}
221   }
222 
223 
224   function symbol() public pure returns (string) { //ERC721
225     return SYMBOL;
226   }
227 
228 
229   function takeOwnership(uint256 _tokenId) public { //ERC721
230     address newOwner = msg.sender;
231     address oldOwner = toyIdToOwner[_tokenId];
232 
233     require(_addressNotNull(newOwner));
234     require(_approved(newOwner, _tokenId));
235 
236     _transfer(oldOwner, newOwner, _tokenId);
237   }
238 
239   function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view
240     return toyIdToPrice[_tokenId];
241   }
242   
243   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) { //for web site view
244     uint256 tokenCount = balanceOf(_owner);
245     if (tokenCount == 0) {
246         // Return an empty array
247       return new uint256[](0);
248     } else {
249       uint256[] memory result = new uint256[](tokenCount);
250       uint256 totalToys = totalSupply();
251       uint256 resultIndex = 0;
252 
253       uint256 toyId;
254       for (toyId = 0; toyId <= totalToys; toyId++) {
255         if (toyIdToOwner[toyId] == _owner) {
256           result[resultIndex] = toyId;
257           resultIndex++;
258         }
259       }
260       return result;
261     }
262   }
263 
264   function totalSupply() public view returns (uint256 total) { //ERC721
265     return toys.length;
266   }
267 
268   function transfer(address _to, uint256 _tokenId) public { //ERC721
269     require(_owns(msg.sender, _tokenId));
270     require(_addressNotNull(_to));
271 
272 	_transfer(msg.sender, _to, _tokenId);
273   }
274 
275   function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721
276     require(_owns(_from, _tokenId));
277     require(_approved(_to, _tokenId));
278     require(_addressNotNull(_to));
279 
280     _transfer(_from, _to, _tokenId);
281   }
282 
283 
284   /* PRIVATE FUNCTIONS */
285   function _addressNotNull(address _to) private pure returns (bool) {
286     return _to != address(0);
287   }
288 
289   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
290     return toyIdToApproved[_tokenId] == _to;
291   }
292 
293   function _createToy(string _name, address _owner, uint256 _price) private {
294     Toy memory _toy = Toy({
295       name: _name
296     });
297     uint256 newToyId = toys.push(_toy) - 1;
298 
299     require(newToyId == uint256(uint32(newToyId))); //check maximum limit of tokens
300 
301     ToyCreated(newToyId, _name, _owner);
302 
303     toyIdToPrice[newToyId] = _price;
304 
305     _transfer(address(0), _owner, newToyId);
306   }
307 
308   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
309     return _checkedAddr == toyIdToOwner[_tokenId];
310   }
311 
312 function _transfer(address _from, address _to, uint256 _tokenId) private {
313     ownershipTokenCount[_to]++;
314     toyIdToOwner[_tokenId] = _to;
315 
316     // When creating new toys _from is 0x0, but we can't account that address.
317     if (_from != address(0)) {
318       ownershipTokenCount[_from]--;
319       // clear any previously approved ownership exchange
320       delete toyIdToApproved[_tokenId];
321     }
322 
323     // Emit the transfer event.
324     Transfer(_from, _to, _tokenId);
325   }
326 }