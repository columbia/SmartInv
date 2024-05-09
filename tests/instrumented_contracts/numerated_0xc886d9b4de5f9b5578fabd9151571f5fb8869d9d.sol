1 // KpopCeleb is a ERC-721 celeb (https://github.com/ethereum/eips/issues/721)
2 // Kpop celebrity cards as digital collectibles
3 // Kpop.io is the official website
4 
5 pragma solidity ^0.4.18;
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 contract ERC721 {
53   function approve(address _to, uint _celebId) public;
54   function balanceOf(address _owner) public view returns (uint balance);
55   function implementsERC721() public pure returns (bool);
56   function ownerOf(uint _celebId) public view returns (address addr);
57   function takeOwnership(uint _celebId) public;
58   function totalSupply() public view returns (uint total);
59   function transferFrom(address _from, address _to, uint _celebId) public;
60   function transfer(address _to, uint _celebId) public;
61 
62   event Transfer(address indexed from, address indexed to, uint celebId);
63   event Approval(address indexed owner, address indexed approved, uint celebId);
64 }
65 
66 contract KpopCeleb is ERC721 {
67   using SafeMath for uint;
68 
69   address public author;
70   address public coauthor;
71 
72   string public constant NAME = "KpopCeleb";
73   string public constant SYMBOL = "KpopCeleb";
74 
75   uint public GROWTH_BUMP = 0.5 ether;
76   uint public MIN_STARTING_PRICE = 0.002 ether;
77   uint public PRICE_INCREASE_SCALE = 120; // 120% of previous price
78 
79   struct Celeb {
80     string name;
81   }
82 
83   Celeb[] public celebs;
84 
85   mapping(uint => address) public celebIdToOwner;
86   mapping(uint => uint) public celebIdToPrice; // in wei
87   mapping(address => uint) public userToNumCelebs;
88   mapping(uint => address) public celebIdToApprovedRecipient;
89   mapping(uint => uint[6]) public celebIdToTraitValues;
90   mapping(uint => uint[6]) public celebIdToTraitBoosters;
91 
92   address public KPOP_ARENA_CONTRACT_ADDRESS = 0x0;
93 
94   event Transfer(address indexed from, address indexed to, uint celebId);
95   event Approval(address indexed owner, address indexed approved, uint celebId);
96   event CelebSold(uint celebId, uint oldPrice, uint newPrice, string celebName, address prevOwner, address newOwner);
97 
98   function KpopCeleb() public {
99     author = msg.sender;
100     coauthor = msg.sender;
101   }
102 
103   function _transfer(address _from, address _to, uint _celebId) private {
104     require(ownerOf(_celebId) == _from);
105     require(!isNullAddress(_to));
106     require(balanceOf(_from) > 0);
107 
108     uint prevBalances = balanceOf(_from) + balanceOf(_to);
109     celebIdToOwner[_celebId] = _to;
110     userToNumCelebs[_from]--;
111     userToNumCelebs[_to]++;
112 
113     // Clear outstanding approvals
114     delete celebIdToApprovedRecipient[_celebId];
115 
116     Transfer(_from, _to, _celebId);
117 
118     assert(balanceOf(_from) + balanceOf(_to) == prevBalances);
119   }
120 
121   function buy(uint _celebId) payable public {
122     address prevOwner = ownerOf(_celebId);
123     uint currentPrice = celebIdToPrice[_celebId];
124 
125     require(prevOwner != msg.sender);
126     require(!isNullAddress(msg.sender));
127     require(msg.value >= currentPrice);
128 
129     // Take a cut off the payment
130     uint payment = uint(SafeMath.div(SafeMath.mul(currentPrice, 92), 100));
131     uint leftover = SafeMath.sub(msg.value, currentPrice);
132     uint newPrice;
133 
134     _transfer(prevOwner, msg.sender, _celebId);
135 
136     if (currentPrice < GROWTH_BUMP) {
137       newPrice = SafeMath.mul(currentPrice, 2);
138     } else {
139       newPrice = SafeMath.div(SafeMath.mul(currentPrice, PRICE_INCREASE_SCALE), 100);
140     }
141 
142     celebIdToPrice[_celebId] = newPrice;
143 
144     if (prevOwner != address(this)) {
145       prevOwner.transfer(payment);
146     }
147 
148     CelebSold(_celebId, currentPrice, newPrice,
149       celebs[_celebId].name, prevOwner, msg.sender);
150 
151     msg.sender.transfer(leftover);
152   }
153 
154   function balanceOf(address _owner) public view returns (uint balance) {
155     return userToNumCelebs[_owner];
156   }
157 
158   function ownerOf(uint _celebId) public view returns (address addr) {
159     return celebIdToOwner[_celebId];
160   }
161 
162   function totalSupply() public view returns (uint total) {
163     return celebs.length;
164   }
165 
166   function transfer(address _to, uint _celebId) public {
167     _transfer(msg.sender, _to, _celebId);
168   }
169 
170   /** START FUNCTIONS FOR AUTHORS **/
171 
172   function createCeleb(string _name, uint _price, uint[6] _traitValues, uint[6] _traitBoosters) public onlyAuthors {
173     require(_price >= MIN_STARTING_PRICE);
174 
175     uint celebId = celebs.push(Celeb(_name)) - 1;
176     celebIdToOwner[celebId] = author;
177     celebIdToPrice[celebId] = _price;
178     celebIdToTraitValues[celebId] = _traitValues;
179     celebIdToTraitBoosters[celebId] = _traitBoosters;
180     userToNumCelebs[author]++;
181   }
182 
183   function updateCeleb(uint _celebId, uint[6] _traitValues, uint[6] _traitBoosters) public onlyAuthors {
184     require(_celebId >= 0 && _celebId < totalSupply());
185 
186     celebIdToTraitValues[_celebId] = _traitValues;
187     celebIdToTraitBoosters[_celebId] = _traitBoosters;
188   }
189 
190   function withdraw(uint _amount, address _to) public onlyAuthors {
191     require(!isNullAddress(_to));
192     require(_amount <= this.balance);
193 
194     _to.transfer(_amount);
195   }
196 
197   function withdrawAll() public onlyAuthors {
198     require(author != 0x0);
199     require(coauthor != 0x0);
200 
201     uint halfBalance = uint(SafeMath.div(this.balance, 2));
202 
203     author.transfer(halfBalance);
204     coauthor.transfer(halfBalance);
205   }
206 
207   function setCoAuthor(address _coauthor) public onlyAuthor {
208     require(!isNullAddress(_coauthor));
209 
210     coauthor = _coauthor;
211   }
212 
213   function setKpopArenaContractAddress(address _address) public onlyAuthors {
214     require(!isNullAddress(_address));
215 
216     KPOP_ARENA_CONTRACT_ADDRESS = _address;
217   }
218 
219   function updateTraits(uint _celebId) public onlyArena {
220     require(_celebId < totalSupply());
221 
222     for (uint i = 0; i < 6; i++) {
223       uint booster = celebIdToTraitBoosters[_celebId][i];
224       celebIdToTraitValues[_celebId][i] = celebIdToTraitValues[_celebId][i].add(booster);
225     }
226   }
227 
228   /** END FUNCTIONS FOR AUTHORS **/
229 
230   function getCeleb(uint _celebId) public view returns (
231     string name,
232     uint price,
233     address owner,
234     uint[6] traitValues,
235     uint[6] traitBoosters
236   ) {
237     name = celebs[_celebId].name;
238     price = celebIdToPrice[_celebId];
239     owner = celebIdToOwner[_celebId];
240     traitValues = celebIdToTraitValues[_celebId];
241     traitBoosters = celebIdToTraitBoosters[_celebId];
242   }
243 
244   /** START FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
245 
246   function approve(address _to, uint _celebId) public {
247     require(msg.sender == ownerOf(_celebId));
248 
249     celebIdToApprovedRecipient[_celebId] = _to;
250 
251     Approval(msg.sender, _to, _celebId);
252   }
253 
254   function transferFrom(address _from, address _to, uint _celebId) public {
255     require(ownerOf(_celebId) == _from);
256     require(isApproved(_to, _celebId));
257     require(!isNullAddress(_to));
258 
259     _transfer(_from, _to, _celebId);
260   }
261 
262   function takeOwnership(uint _celebId) public {
263     require(!isNullAddress(msg.sender));
264     require(isApproved(msg.sender, _celebId));
265 
266     address currentOwner = celebIdToOwner[_celebId];
267 
268     _transfer(currentOwner, msg.sender, _celebId);
269   }
270 
271   /** END FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
272 
273   function implementsERC721() public pure returns (bool) {
274     return true;
275   }
276 
277   /** MODIFIERS **/
278 
279   modifier onlyAuthor() {
280     require(msg.sender == author);
281     _;
282   }
283 
284   modifier onlyAuthors() {
285     require(msg.sender == author || msg.sender == coauthor);
286     _;
287   }
288 
289   modifier onlyArena() {
290     require(msg.sender == author || msg.sender == coauthor || msg.sender == KPOP_ARENA_CONTRACT_ADDRESS);
291     _;
292   }
293 
294   /** FUNCTIONS THAT WONT BE USED FREQUENTLY **/
295 
296   function setMinStartingPrice(uint _price) public onlyAuthors {
297     MIN_STARTING_PRICE = _price;
298   }
299 
300   function setGrowthBump(uint _bump) public onlyAuthors {
301     GROWTH_BUMP = _bump;
302   }
303 
304   function setPriceIncreaseScale(uint _scale) public onlyAuthors {
305     PRICE_INCREASE_SCALE = _scale;
306   }
307 
308   /** PRIVATE FUNCTIONS **/
309 
310   function isApproved(address _to, uint _celebId) private view returns (bool) {
311     return celebIdToApprovedRecipient[_celebId] == _to;
312   }
313 
314   function isNullAddress(address _addr) private pure returns (bool) {
315     return _addr == 0x0;
316   }
317 }