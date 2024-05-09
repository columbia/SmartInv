1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 /**
67  * @title Pausable
68  * @dev Base contract which allows children to implement an emergency stop mechanism.
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73 
74   bool public paused = false;
75 
76 
77   /**
78    * @dev Modifier to make a function callable only when the contract is not paused.
79    */
80   modifier whenNotPaused() {
81     require(!paused);
82     _;
83   }
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is paused.
87    */
88   modifier whenPaused() {
89     require(paused);
90     _;
91   }
92 
93   /**
94    * @dev called by the owner to pause, triggers stopped state
95    */
96   function pause() public onlyOwner whenNotPaused {
97     paused = true;
98     emit Pause();
99   }
100 
101   /**
102    * @dev called by the owner to unpause, returns to normal state
103    */
104   function unpause() public onlyOwner whenPaused {
105     paused = false;
106     emit Unpause();
107   }
108 }
109 
110 contract SuperHeroes is Pausable {
111     
112   /*** CONSTANTS ***/
113 
114   string public constant name = "SuperHero";
115   string public constant symbol = "SH";
116   
117   /** VARIABLES **/
118   uint256 public fee = 2;
119   uint256 public snatch = 24 hours;
120 
121   /*** DATA TYPES ***/
122 
123   struct Token {
124     string name;
125     uint256 price;
126     uint256 purchased;
127   }
128 
129   /*** STORAGE ***/
130 
131   Token[] tokens;
132 
133   mapping (uint256 => address) public tokenIndexToOwner;
134   mapping (address => uint256) ownershipTokenCount;
135   mapping (uint256 => address) public tokenIndexToApproved;
136   mapping (uint256 => Token) public herosForSale;
137 
138   /*** INTERNAL FUNCTIONS ***/
139 
140   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
141     return tokenIndexToOwner[_tokenId] == _claimant;
142   }
143 
144   function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
145     return tokenIndexToApproved[_tokenId] == _claimant;
146   }
147 
148   function _approve(address _to, uint256 _tokenId) internal {
149     tokenIndexToApproved[_tokenId] = _to;
150   }
151 
152   function _transfer(address _from, address _to, uint256 _tokenId) internal whenNotPaused {
153     ownershipTokenCount[_to]++;
154     tokenIndexToOwner[_tokenId] = _to;
155 
156     if (_from != address(0)) {
157       ownershipTokenCount[_from]--;
158       delete tokenIndexToApproved[_tokenId];
159     }
160   }
161 
162   function _mint(string _name, uint256 _price) internal returns (uint256 tokenId) {
163     require(tokens.length < 250, "Max amount of superheroes is reached");  
164     Token memory token = Token({
165       name: _name,
166       price: _price,
167       purchased: now
168     });
169     tokenId = tokens.push(token) - 1;
170     
171     _transfer(0, owner, tokenId);
172   }
173 
174 
175   function totalSupply() public view returns (uint256) {
176     return tokens.length;
177   }
178 
179   function balanceOf(address _owner) public view returns (uint256) {
180     return ownershipTokenCount[_owner];
181   }
182 
183   function ownerOf(uint256 _tokenId) external view returns (address owner) {
184     owner = tokenIndexToOwner[_tokenId];
185 
186     require(owner != address(0));
187   }
188 
189   function approve(address _to, uint256 _tokenId) external {
190     require(_owns(msg.sender, _tokenId));
191 
192     _approve(_to, _tokenId);
193   }
194 
195   function transfer(address _to, uint256 _tokenId) external {
196     require(_to != address(0));
197     require(_to != address(this));
198     require(_owns(msg.sender, _tokenId));
199 
200     _transfer(msg.sender, _to, _tokenId);
201   }
202 
203   function transferFrom(address _from, address _to, uint256 _tokenId) external {
204     require(_to != address(0));
205     require(_to != address(this));
206     require(_approvedFor(msg.sender, _tokenId));
207     require(_owns(_from, _tokenId));
208 
209     _transfer(_from, _to, _tokenId);
210   }
211 
212   function tokensOfOwner(address _owner) external view returns (uint256[]) {
213     uint256 balance = balanceOf(_owner);
214 
215     if (balance == 0) {
216       return new uint256[](0);
217     } else {
218       uint256[] memory result = new uint256[](balance);
219       uint256 maxTokenId = totalSupply();
220       uint256 idx = 0;
221 
222       uint256 tokenId;
223       for (tokenId = 1; tokenId <= maxTokenId; tokenId++) {
224         if (tokenIndexToOwner[tokenId] == _owner) {
225           result[idx] = tokenId;
226           idx++;
227         }
228       }
229     }
230 
231     return result;
232   }
233 
234 
235   /*** EXTERNAL FUNCTIONS ***/
236 
237   function mint(string _name, uint256 _price) external onlyOwner returns (uint256) {
238     uint256 pricerecalc = _price;
239     return _mint(_name, pricerecalc);
240   }
241 
242   function getToken(uint256 _tokenId) external view returns (string _name, uint256 _price, uint256 _purchased) {
243     Token memory token = tokens[_tokenId];
244 
245     _name = token.name;
246     _price = token.price;
247     _purchased = token.purchased;
248   }
249   
250   function snatchHero(uint256 _id) external payable whenNotPaused {
251       require(now - tokens[_id].purchased <= snatch);
252       uint256 pricerecalc = tokens[_id].price;
253       require(pricerecalc <= msg.value);
254       address previos = tokenIndexToOwner[_id];
255       uint256 realPriceFee = msg.value * fee / 100;
256       uint256 realPrice = msg.value - realPriceFee;
257       uint256 newPriceRise = pricerecalc * 120 / 100;
258       // owner.transfer(realPriceFee);
259       previos.transfer(realPrice);
260       _transfer(previos, msg.sender, _id);
261       tokens[_id].purchased = now;
262       tokens[_id].price = newPriceRise;
263   }
264   
265   function buyHero(uint256 _id) external payable whenNotPaused {
266       require(herosForSale[_id].price != 0);
267       uint256 pricerecalc = herosForSale[_id].price;
268       require(msg.value >= pricerecalc);
269       // owner.transfer(msg.value);
270       _transfer(owner, msg.sender, _id);
271       uint256 newPriceRise = pricerecalc * 120 / 100;
272       tokens[_id].purchased = now;
273       tokens[_id].price = newPriceRise;
274       
275       delete herosForSale[_id];
276   }
277   
278   function saleHero(uint256 _id) external onlyOwner whenNotPaused {
279       require(msg.sender == tokenIndexToOwner[_id]);
280       herosForSale[_id] = tokens[_id];
281   }
282 
283   function changePrice(uint256 _id, uint256 _price) external whenNotPaused {
284       require(msg.sender == tokenIndexToOwner[_id]);
285       tokens[_id].price = _price;
286   }
287   
288   function withdraw(address to, uint256 amount) external onlyOwner {
289       to.transfer(amount);
290   }
291 }