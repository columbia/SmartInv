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
125     string src;
126     uint256 price;
127     uint256 purchased;
128   }
129 
130   /*** STORAGE ***/
131 
132   Token[] tokens;
133 
134   mapping (uint256 => address) public tokenIndexToOwner;
135   mapping (address => uint256) ownershipTokenCount;
136   mapping (uint256 => address) public tokenIndexToApproved;
137   mapping (uint256 => Token) public herosForSale;
138 
139   /*** INTERNAL FUNCTIONS ***/
140 
141   function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
142     return tokenIndexToOwner[_tokenId] == _claimant;
143   }
144 
145   function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
146     return tokenIndexToApproved[_tokenId] == _claimant;
147   }
148 
149   function _approve(address _to, uint256 _tokenId) internal {
150     tokenIndexToApproved[_tokenId] = _to;
151   }
152 
153   function _transfer(address _from, address _to, uint256 _tokenId) internal whenNotPaused {
154     ownershipTokenCount[_to]++;
155     tokenIndexToOwner[_tokenId] = _to;
156 
157     if (_from != address(0)) {
158       ownershipTokenCount[_from]--;
159       delete tokenIndexToApproved[_tokenId];
160     }
161   }
162 
163   function _mint(string _name, string _src, uint256 _price) internal returns (uint256 tokenId) {
164     require(tokens.length < 250, "Max amount of superheroes is reached");  
165     Token memory token = Token({
166       name: _name,
167       src: _src,
168       price: _price,
169       purchased: now
170     });
171     tokenId = tokens.push(token) - 1;
172     
173     _transfer(0, owner, tokenId);
174   }
175 
176 
177   function totalSupply() public view returns (uint256) {
178     return tokens.length;
179   }
180 
181   function balanceOf(address _owner) public view returns (uint256) {
182     return ownershipTokenCount[_owner];
183   }
184 
185   function ownerOf(uint256 _tokenId) external view returns (address owner) {
186     owner = tokenIndexToOwner[_tokenId];
187 
188     require(owner != address(0));
189   }
190 
191   function approve(address _to, uint256 _tokenId) external {
192     require(_owns(msg.sender, _tokenId));
193 
194     _approve(_to, _tokenId);
195   }
196 
197   function transfer(address _to, uint256 _tokenId) external {
198     require(_to != address(0));
199     require(_to != address(this));
200     require(_owns(msg.sender, _tokenId));
201 
202     _transfer(msg.sender, _to, _tokenId);
203   }
204 
205   function transferFrom(address _from, address _to, uint256 _tokenId) external {
206     require(_to != address(0));
207     require(_to != address(this));
208     require(_approvedFor(msg.sender, _tokenId));
209     require(_owns(_from, _tokenId));
210 
211     _transfer(_from, _to, _tokenId);
212   }
213 
214   function tokensOfOwner(address _owner) external view returns (uint256[]) {
215     uint256 balance = balanceOf(_owner);
216 
217     if (balance == 0) {
218       return new uint256[](0);
219     } else {
220       uint256[] memory result = new uint256[](balance);
221       uint256 maxTokenId = totalSupply();
222       uint256 idx = 0;
223 
224       uint256 tokenId;
225       for (tokenId = 1; tokenId <= maxTokenId; tokenId++) {
226         if (tokenIndexToOwner[tokenId] == _owner) {
227           result[idx] = tokenId;
228           idx++;
229         }
230       }
231     }
232 
233     return result;
234   }
235 
236 
237   /*** EXTERNAL FUNCTIONS ***/
238 
239   function mint(string _name, string _src, uint256 _price) external onlyOwner returns (uint256) {
240     uint256 pricerecalc = _price;
241     return _mint(_name, _src, pricerecalc);
242   }
243 
244   function getToken(uint256 _tokenId) external view returns (string _name, string _src, uint256 _price, uint256 _purchased) {
245     Token memory token = tokens[_tokenId];
246 
247     _name = token.name;
248     _src = token.src;
249     _price = token.price;
250     _purchased = token.purchased;
251   }
252   
253   function snatchHero(uint256 _id) external payable whenNotPaused {
254       require(now - tokens[_id].purchased <= snatch);
255       uint256 pricerecalc = tokens[_id].price;
256       require(pricerecalc <= msg.value);
257       address previos = tokenIndexToOwner[_id];
258       uint256 realPriceFee = msg.value * fee / 100;
259       uint256 realPrice = msg.value - realPriceFee;
260       uint256 newPriceRise = pricerecalc * 120 / 100;
261       // owner.transfer(realPriceFee);
262       previos.transfer(realPrice);
263       _transfer(previos, msg.sender, _id);
264       tokens[_id].purchased = now;
265       tokens[_id].price = newPriceRise;
266   }
267   
268   function buyHero(uint256 _id) external payable whenNotPaused {
269       require(herosForSale[_id].price != 0);
270       uint256 pricerecalc = herosForSale[_id].price;
271       require(msg.value >= pricerecalc);
272       // owner.transfer(msg.value);
273       _transfer(owner, msg.sender, _id);
274       uint256 newPriceRise = pricerecalc * 120 / 100;
275       tokens[_id].purchased = now;
276       tokens[_id].price = newPriceRise;
277       
278       delete herosForSale[_id];
279   }
280   
281   function saleHero(uint256 _id) external onlyOwner whenNotPaused {
282       require(msg.sender == tokenIndexToOwner[_id]);
283       herosForSale[_id] = tokens[_id];
284   }
285 
286   function changePrice(uint256 _id, uint256 _price) external whenNotPaused {
287       require(msg.sender == tokenIndexToOwner[_id]);
288       tokens[_id].price = _price;
289   }
290   
291   function withdraw(address to, uint256 amount) external onlyOwner {
292       to.transfer(amount);
293   }
294 }