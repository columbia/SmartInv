1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 
9 contract Ownable {
10   address public owner;
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   /**
15    * @dev The isOwner constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function isOwner() public {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /*** Dennis & Bani welcome you ***/
46 contract EtherCup is Ownable {
47 
48   // NOTE: Player is our global term used to describe unique tokens
49 
50   using SafeMath for uint256;
51 
52   /*** EVENTS ***/
53   event NewPlayer(uint tokenId, string name);
54   event TokenSold(uint256 tokenId, uint256 oldPrice, address prevOwner, address winner, string name);
55   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
56   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
57 
58 
59   /*** CONSTANTS ***/
60   uint256 private price = 0.01 ether;
61   uint256 private priceLimitOne = 0.05 ether;
62   uint256 private priceLimitTwo = 0.5 ether;
63   uint256 private priceLimitThree = 2 ether;
64   uint256 private priceLimitFour = 5 ether;
65 
66 
67   /*** STORAGE ***/
68   mapping (uint => address) public playerToOwner;
69   mapping (address => uint) ownerPlayerCount;
70   mapping (uint256 => uint256) public playerToPrice;
71   mapping (uint => address) playerApprovals;
72 
73   // The address of the accounts (or contracts) that can execute actions within each roles.
74   address public ceoAddress;
75 
76   /*** DATATYPES ***/
77   struct Player {
78     string name;
79   }
80 
81   Player[] public players;
82 
83 
84   /*** ACCESS MODIFIERS ***/
85   /// @dev Access modifier for CEO-only functionality
86   modifier onlyCEO() {
87     require(msg.sender == ceoAddress);
88     _;
89   }
90 
91   modifier onlyOwnerOf(uint _tokenId) {
92     require(msg.sender == playerToOwner[_tokenId]);
93     _;
94   }
95 
96   /*** CONSTRUCTOR ***/
97   // In newer versions use "constructor() public {  };" instead of "function PlayerLab() public {  };"
98   constructor() public {
99     ceoAddress = msg.sender;
100 
101   }
102 
103   /*** CEO ***/
104   /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
105   /// @param _newCEO The address of the new CEO
106   function setCEO(address _newCEO) public onlyCEO {
107     require(_newCEO != address(0));
108     ceoAddress = _newCEO;
109   }
110 
111 
112   /*** CREATE PLAYERS ***/
113   function createNewPlayer(string _name) public onlyCEO {
114     _createPlayer(_name, price);
115   }
116 
117   function _createPlayer(string _name, uint256 _price) internal {
118     uint id = players.push(Player(_name)) - 1;
119     playerToOwner[id] = msg.sender;
120     ownerPlayerCount[msg.sender] = ownerPlayerCount[msg.sender].add(1);
121     emit NewPlayer(id, _name);
122 
123     playerToPrice[id] = _price;
124   }
125 
126 
127   /*** Buy ***/
128   function calculateNextPrice (uint256 _price) public view returns (uint256 _nextPrice) {
129     if (_price < priceLimitOne) {
130       return _price.mul(200).div(95); // < 0.05
131     } else if (_price < priceLimitTwo) {
132       return _price.mul(175).div(95); // < 0.5
133     } else if (_price < priceLimitThree) {
134       return _price.mul(150).div(95); // < 2
135     } else if (_price < priceLimitFour) {
136       return _price.mul(125).div(95); // < 5
137     } else {
138       return _price.mul(115).div(95); // >= 5
139     }
140   }
141 
142   function calculateDevCut (uint256 _price) public pure returns (uint256 _devCut) {
143     return _price.mul(5).div(100);
144 
145   }
146 
147   function purchase(uint256 _tokenId) public payable {
148 
149     address oldOwner = playerToOwner[_tokenId];
150     address newOwner = msg.sender;
151 
152     uint256 sellingPrice = playerToPrice[_tokenId];
153     uint256 purchaseExcess = msg.value.sub(sellingPrice);
154 
155     // Making sure token owner is not sending to self
156     require(oldOwner != newOwner);
157 
158     // Making sure sent amount is greater than or equal to the sellingPrice
159     require(msg.value >= sellingPrice);
160 
161     _transfer(oldOwner, newOwner, _tokenId);
162     playerToPrice[_tokenId] = nextPriceOf(_tokenId);
163 
164     // Devevloper's cut which is left in contract and accesed by
165     // `withdrawAll` and `withdrawAmountTo` methods.
166     uint256 devCut = calculateDevCut(sellingPrice);
167 
168     uint256 payment = sellingPrice.sub(devCut);
169 
170     // Pay previous tokenOwner if owner is not contract
171     if (oldOwner != address(this)) {
172       oldOwner.transfer(payment);
173     }
174 
175     if (purchaseExcess > 0){
176         newOwner.transfer(purchaseExcess);
177     }
178 
179 
180     emit TokenSold(_tokenId, sellingPrice, oldOwner, newOwner, players[_tokenId].name);
181   }
182 
183   /*** Withdraw Dev Cut ***/
184   /*
185     NOTICE: These functions withdraw the developer's cut which is left
186     in the contract by `buy`. User funds are immediately sent to the old
187     owner in `buy`, no user funds are left in the contract.
188   */
189   function withdrawAll () onlyCEO() public {
190     ceoAddress.transfer(address(this).balance);
191   }
192 
193   function withdrawAmount (uint256 _amount) onlyCEO() public {
194     ceoAddress.transfer(_amount);
195   }
196 
197   function showDevCut () onlyCEO() public view returns (uint256) {
198     return address(this).balance;
199   }
200 
201 
202   /*** ***/
203   function priceOf(uint256 _tokenId) public view returns (uint256 _price) {
204     return playerToPrice[_tokenId];
205   }
206 
207   function priceOfMultiple(uint256[] _tokenIds) public view returns (uint256[]) {
208     uint[] memory values = new uint[](_tokenIds.length);
209 
210     for (uint256 i = 0; i < _tokenIds.length; i++) {
211       values[i] = priceOf(_tokenIds[i]);
212     }
213     return values;
214   }
215 
216   function nextPriceOf(uint256 _tokenId) public view returns (uint256 _nextPrice) {
217     return calculateNextPrice(priceOf(_tokenId));
218   }
219 
220   /*** ERC721 ***/
221   function totalSupply() public view returns (uint256 total) {
222     return players.length;
223   }
224 
225   function balanceOf(address _owner) public view returns (uint256 _balance) {
226     return ownerPlayerCount[_owner];
227   }
228 
229   function ownerOf(uint256 _tokenId) public view returns (address _owner) {
230     return playerToOwner[_tokenId];
231   }
232 
233   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
234     playerApprovals[_tokenId] = _to;
235     emit Approval(msg.sender, _to, _tokenId);
236   }
237 
238   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
239     _transfer(msg.sender, _to, _tokenId);
240   }
241 
242   function _transfer(address _from, address _to, uint256 _tokenId) private {
243 
244     ownerPlayerCount[_to] = ownerPlayerCount[_to].add(1);
245     ownerPlayerCount[_from] = ownerPlayerCount[_from].sub(1);
246     playerToOwner[_tokenId] = _to;
247     emit Transfer(_from, _to, _tokenId);
248   }
249 
250   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
251   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
252   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
253   ///  not contract-to-contract calls.
254   function tokensOfOwner(address _owner) public view returns(uint256[] ownerTokens) {
255     uint256 tokenCount = balanceOf(_owner);
256     if (tokenCount == 0) {
257         // Return an empty array
258       return new uint256[](0);
259     } else {
260       uint256[] memory result = new uint256[](tokenCount);
261       uint256 totalPlayers = totalSupply();
262       uint256 resultIndex = 0;
263 
264       uint256 playerId;
265       for (playerId = 0; playerId <= totalPlayers; playerId++) {
266         if (playerToOwner[playerId] == _owner) {
267           result[resultIndex] = playerId;
268           resultIndex++;
269         }
270       }
271       return result;
272     }
273   }
274 
275 }
276 
277 /**
278  * @title SafeMath
279  * @dev Math operations with safety checks that throw on error
280  */
281 library SafeMath {
282 
283 /**
284 * @dev Multiplies two numbers, throws on overflow.
285 */
286 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
287  if (a == 0) {
288    return 0;
289  }
290  uint256 c = a * b;
291  assert(c / a == b);
292  return c;
293 }
294 
295 /**
296 * @dev Integer division of two numbers, truncating the quotient.
297 */
298 function div(uint256 a, uint256 b) internal pure returns (uint256) {
299  // assert(b > 0); // Solidity automatically throws when dividing by 0
300  uint256 c = a / b;
301  // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302  return c;
303 }
304 
305 /**
306 * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
307 */
308 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
309  assert(b <= a);
310  return a - b;
311 }
312 
313 /**
314 * @dev Adds two numbers, throws on overflow.
315 */
316 function add(uint256 a, uint256 b) internal pure returns (uint256) {
317  uint256 c = a + b;
318  assert(c >= a);
319  return c;
320 }
321 }