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
96 contract EthPizzeria is ERC721, Ownable {
97 
98   event PizzaCreated(uint256 tokenId, string name, address owner);
99   event TokenSold(uint256 tokenId, uint256 oldPrice, uint256 newPrice, address prevOwner, address winner, string name);
100   event Transfer(address from, address to, uint256 tokenId);
101 
102   string public constant NAME = "EthPizzeria";
103   string public constant SYMBOL = "PizzeriaToken";
104 
105   uint256 private startingPrice = 0.01 ether;
106 
107   mapping (uint256 => address) public pizzaIdToOwner;
108 
109   mapping (uint256 => address) public pizzaIdToDivs;
110 
111   mapping (address => uint256) private ownershipTokenCount;
112 
113   mapping (uint256 => address) public pizzaIdToApproved;
114 
115   mapping (uint256 => uint256) private pizzaIdToPrice;
116 
117   /*** DATATYPES ***/
118   struct Pizza {
119     string name;
120   }
121 
122   Pizza[] private pizzas;
123 
124   function approve(address _to, uint256 _tokenId) public { //ERC721
125     // Caller must own token.
126     require(_owns(msg.sender, _tokenId));
127     pizzaIdToApproved[_tokenId] = _to;
128     Approval(msg.sender, _to, _tokenId);
129   }
130 
131   function balanceOf(address _owner) public view returns (uint256 balance) { //ERC721
132     return ownershipTokenCount[_owner];
133   }
134 
135   function createPizzaToken(string _name, uint256 _price) private {
136     _createPizza(_name, msg.sender, _price);
137   }
138 
139   function create21PizzasTokens() public onlyContractOwner {
140      uint256 totalPizzas = totalSupply();
141 	 
142 	 require (totalPizzas<1); // only 21 tokens for start
143 	 
144 	 for (uint8 i=1; i<=21; i++)
145 		_createPizza("EthPizza", address(this), startingPrice);
146 	
147   }
148   
149   function getPizza(uint256 _tokenId) public view returns (string pizzaName, uint256 sellingPrice, address owner) {
150     Pizza storage pizza = pizzas[_tokenId];
151     pizzaName = pizza.name;
152     sellingPrice = pizzaIdToPrice[_tokenId];
153     owner = pizzaIdToOwner[_tokenId];
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
165     owner = pizzaIdToOwner[_tokenId];
166     require(owner != address(0));
167   }
168 
169   // Allows someone to send ether and obtain the token
170   function purchase(uint256 _tokenId) public payable {
171     address oldOwner = pizzaIdToOwner[_tokenId];
172     address newOwner = msg.sender;
173 
174     uint256 sellingPrice = pizzaIdToPrice[_tokenId];
175 
176     require(oldOwner != newOwner);
177     require(_addressNotNull(newOwner));
178     require(msg.value >= sellingPrice);
179 
180     uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 97), 100)); //97% to previous owner
181     uint256 divs_payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 25), 1000)); //2,5% divs
182     
183 	address divs_address = pizzaIdToDivs[_tokenId];
184 	
185     // Next price will rise on 30%
186     pizzaIdToPrice[_tokenId] = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 130), 100));
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
200     TokenSold(_tokenId, sellingPrice, pizzaIdToPrice[_tokenId], oldOwner, newOwner, pizzas[_tokenId].name);
201 	
202     if (msg.value > sellingPrice) { //if excess pay
203 	    uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
204 		msg.sender.transfer(purchaseExcess);
205 	}
206   }
207   
208   function changePizza(uint256 _tokenId) public payable { //
209 
210     require(pizzaIdToOwner[_tokenId] == msg.sender && msg.value == 10 finney); //tax 0.01eth for change
211 	
212 	uint256 newPrice =  SafeMath.div(pizzaIdToPrice[_tokenId], 2);
213     
214     //get two pizzas within one
215 	createPizzaToken("EthPizza", newPrice);
216 	createPizzaToken("EthPizza", newPrice);
217 	
218 	pizzaIdToOwner[_tokenId] = address(this); //return changed pizza to pizzeria
219 	pizzaIdToPrice[_tokenId] = 10 finney;
220 	 
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
231     address oldOwner = pizzaIdToOwner[_tokenId];
232 
233     require(_addressNotNull(newOwner));
234     require(_approved(newOwner, _tokenId));
235 
236     _transfer(oldOwner, newOwner, _tokenId);
237   }
238 
239   function priceOf(uint256 _tokenId) public view returns (uint256 price) { //for web site view
240     return pizzaIdToPrice[_tokenId];
241   }
242 
243   function ALLownersANDprices(uint256 _startPizzaId) public view returns (address[] owners, address[] divs, uint256[] prices) { //for web site view
244 	
245 	uint256 totalPizzas = totalSupply();
246 	
247     if (totalPizzas == 0 || _startPizzaId >= totalPizzas) {
248         // Return an empty array
249       return (new address[](0),new address[](0),new uint256[](0));
250     }
251 	
252 	uint256 indexTo;
253 	if (totalPizzas > _startPizzaId+1000)
254 		indexTo = _startPizzaId + 1000;
255 	else 	
256 		indexTo = totalPizzas;
257 		
258     uint256 totalResultPizzas = indexTo - _startPizzaId;		
259 		
260 	address[] memory owners_res = new address[](totalResultPizzas);
261 	address[] memory divs_res = new address[](totalResultPizzas);
262 	uint256[] memory prices_res = new uint256[](totalResultPizzas);
263 	
264 	for (uint256 pizzaId = _startPizzaId; pizzaId < indexTo; pizzaId++) {
265 	  owners_res[pizzaId - _startPizzaId] = pizzaIdToOwner[pizzaId];
266 	  divs_res[pizzaId - _startPizzaId] = pizzaIdToDivs[pizzaId];
267 	  prices_res[pizzaId - _startPizzaId] = pizzaIdToPrice[pizzaId];
268 	}
269 	
270 	return (owners_res, divs_res, prices_res);
271   }
272   
273   function tokensOfOwner(address _owner) public view returns(uint256[] ownerToken) { //ERC721 for web site view
274     uint256 tokenCount = balanceOf(_owner);
275     if (tokenCount == 0) {
276         // Return an empty array
277       return new uint256[](0);
278     } else {
279       uint256[] memory result = new uint256[](tokenCount);
280       uint256[] memory divs = new uint256[](tokenCount);
281       uint256 totalPizzas = totalSupply();
282       uint256 resultIndex = 0;
283 
284       uint256 pizzaId;
285       for (pizzaId = 0; pizzaId <= totalPizzas; pizzaId++) {
286         if (pizzaIdToOwner[pizzaId] == _owner) {
287           result[resultIndex] = pizzaId;
288           resultIndex++;
289         }
290       }
291       return result;
292     }
293   }
294 
295   function totalSupply() public view returns (uint256 total) { //ERC721
296     return pizzas.length;
297   }
298 
299   function transfer(address _to, uint256 _tokenId) public { //ERC721
300     require(_owns(msg.sender, _tokenId));
301     require(_addressNotNull(_to));
302 
303 	_transfer(msg.sender, _to, _tokenId);
304   }
305 
306   function transferFrom(address _from, address _to, uint256 _tokenId) public { //ERC721
307     require(_owns(_from, _tokenId));
308     require(_approved(_to, _tokenId));
309     require(_addressNotNull(_to));
310 
311     _transfer(_from, _to, _tokenId);
312   }
313 
314 
315   /* PRIVATE FUNCTIONS */
316   function _addressNotNull(address _to) private pure returns (bool) {
317     return _to != address(0);
318   }
319 
320   function _approved(address _to, uint256 _tokenId) private view returns (bool) {
321     return pizzaIdToApproved[_tokenId] == _to;
322   }
323 
324   function _createPizza(string _name, address _owner, uint256 _price) private {
325     Pizza memory _pizza = Pizza({
326       name: _name
327     });
328     uint256 newPizzaId = pizzas.push(_pizza) - 1;
329 
330     require(newPizzaId == uint256(uint32(newPizzaId))); //check maximum limit of tokens
331 
332     PizzaCreated(newPizzaId, _name, _owner);
333 
334     pizzaIdToPrice[newPizzaId] = _price;
335 	pizzaIdToDivs[newPizzaId] = _owner; //dividents address;
336 
337     _transfer(address(0), _owner, newPizzaId);
338   }
339 
340   function _owns(address _checkedAddr, uint256 _tokenId) private view returns (bool) {
341     return _checkedAddr == pizzaIdToOwner[_tokenId];
342   }
343 
344 function _transfer(address _from, address _to, uint256 _tokenId) private {
345     ownershipTokenCount[_to]++;
346     pizzaIdToOwner[_tokenId] = _to;
347 
348     // When creating new pizzas _from is 0x0, but we can't account that address.
349     if (_from != address(0)) {
350       ownershipTokenCount[_from]--;
351       // clear any previously approved ownership exchange
352       delete pizzaIdToApproved[_tokenId];
353     }
354 
355     // Emit the transfer event.
356     Transfer(_from, _to, _tokenId);
357   }
358 }