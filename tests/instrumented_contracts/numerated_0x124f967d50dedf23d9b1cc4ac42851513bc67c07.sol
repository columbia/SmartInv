1 // KpopCeleb is a ERC-721 celeb (https://github.com/ethereum/eips/issues/721)
2 // Kpop celebrity cards as digital collectibles
3 // Kpop.io is the official website
4 
5 pragma solidity ^0.4.18;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   /**
36   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract ERC721 {
54   function approve(address _to, uint _celebId) public;
55   function balanceOf(address _owner) public view returns (uint balance);
56   function implementsERC721() public pure returns (bool);
57   function ownerOf(uint _celebId) public view returns (address addr);
58   function takeOwnership(uint _celebId) public;
59   function totalSupply() public view returns (uint total);
60   function transferFrom(address _from, address _to, uint _celebId) public;
61   function transfer(address _to, uint _celebId) public;
62 
63   event Transfer(address indexed from, address indexed to, uint celebId);
64   event Approval(address indexed owner, address indexed approved, uint celebId);
65 }
66 
67 contract KpopCeleb is ERC721 {
68   using SafeMath for uint;
69 
70   address public author;
71   address public coauthor;
72 
73   string public constant NAME = "KpopCeleb";
74   string public constant SYMBOL = "KpopCeleb";
75 
76   uint public GROWTH_BUMP = 0.5 ether;
77   uint public MIN_STARTING_PRICE = 0.002 ether;
78   uint public PRICE_INCREASE_SCALE = 120; // 120% of previous price
79 
80   struct Celeb {
81     string name;
82   }
83 
84   Celeb[] public celebs;
85 
86   mapping(uint => address) public celebIdToOwner;
87   mapping(uint => uint) public celebIdToPrice; // in wei
88   mapping(address => uint) public userToNumCelebs;
89   mapping(uint => address) public celebIdToApprovedRecipient;
90   mapping(uint => uint[6]) public celebIdToTraitValues;
91   mapping(uint => uint[6]) public celebIdToTraitBoosters;
92 
93   address public KPOP_ARENA_CONTRACT_ADDRESS = 0x0;
94 
95   event Transfer(address indexed from, address indexed to, uint celebId);
96   event Approval(address indexed owner, address indexed approved, uint celebId);
97   event CelebSold(uint celebId, uint oldPrice, uint newPrice, string celebName, address prevOwner, address newOwner);
98 
99   function KpopCeleb() public {
100     author = msg.sender;
101     coauthor = msg.sender;
102   }
103 
104   function _transfer(address _from, address _to, uint _celebId) private {
105     require(ownerOf(_celebId) == _from);
106     require(!isNullAddress(_to));
107     require(balanceOf(_from) > 0);
108 
109     uint prevBalances = balanceOf(_from) + balanceOf(_to);
110     celebIdToOwner[_celebId] = _to;
111     userToNumCelebs[_from]--;
112     userToNumCelebs[_to]++;
113 
114     // Clear outstanding approvals
115     delete celebIdToApprovedRecipient[_celebId];
116 
117     Transfer(_from, _to, _celebId);
118 
119     assert(balanceOf(_from) + balanceOf(_to) == prevBalances);
120   }
121 
122   function buy(uint _celebId) payable public {
123     address prevOwner = ownerOf(_celebId);
124     uint currentPrice = celebIdToPrice[_celebId];
125 
126     require(prevOwner != msg.sender);
127     require(!isNullAddress(msg.sender));
128     require(msg.value >= currentPrice);
129 
130     // Take a cut off the payment
131     uint payment = uint(SafeMath.div(SafeMath.mul(currentPrice, 92), 100));
132     uint leftover = SafeMath.sub(msg.value, currentPrice);
133     uint newPrice;
134 
135     _transfer(prevOwner, msg.sender, _celebId);
136 
137     if (currentPrice < GROWTH_BUMP) {
138       newPrice = SafeMath.mul(currentPrice, 2);
139     } else {
140       newPrice = SafeMath.div(SafeMath.mul(currentPrice, PRICE_INCREASE_SCALE), 100);
141     }
142 
143     celebIdToPrice[_celebId] = newPrice;
144 
145     if (prevOwner != address(this)) {
146       prevOwner.transfer(payment);
147     }
148 
149     CelebSold(_celebId, currentPrice, newPrice,
150       celebs[_celebId].name, prevOwner, msg.sender);
151 
152     msg.sender.transfer(leftover);
153   }
154 
155   function balanceOf(address _owner) public view returns (uint balance) {
156     return userToNumCelebs[_owner];
157   }
158 
159   function ownerOf(uint _celebId) public view returns (address addr) {
160     return celebIdToOwner[_celebId];
161   }
162 
163   function totalSupply() public view returns (uint total) {
164     return celebs.length;
165   }
166 
167   function transfer(address _to, uint _celebId) public {
168     _transfer(msg.sender, _to, _celebId);
169   }
170 
171   /** START FUNCTIONS FOR AUTHORS **/
172 
173   function createCeleb(string _name, uint _price, address _owner, uint[6] _traitValues, uint[6] _traitBoosters) public onlyAuthors {
174     require(_price >= MIN_STARTING_PRICE);
175 
176     address owner = _owner == 0x0 ? author : _owner;
177 
178     uint celebId = celebs.push(Celeb(_name)) - 1;
179     celebIdToOwner[celebId] = owner;
180     celebIdToPrice[celebId] = _price;
181     celebIdToTraitValues[celebId] = _traitValues;
182     celebIdToTraitBoosters[celebId] = _traitBoosters;
183     userToNumCelebs[owner]++;
184   }
185 
186   function updateCeleb(uint _celebId, string _name, uint[6] _traitValues, uint[6] _traitBoosters) public onlyAuthors {
187     require(_celebId >= 0 && _celebId < totalSupply());
188 
189     celebs[_celebId].name = _name;
190     celebIdToTraitValues[_celebId] = _traitValues;
191     celebIdToTraitBoosters[_celebId] = _traitBoosters;
192   }
193 
194   function withdraw(uint _amount, address _to) public onlyAuthors {
195     require(!isNullAddress(_to));
196     require(_amount <= this.balance);
197 
198     _to.transfer(_amount);
199   }
200 
201   function withdrawAll() public onlyAuthors {
202     require(author != 0x0);
203     require(coauthor != 0x0);
204 
205     uint halfBalance = uint(SafeMath.div(this.balance, 2));
206 
207     author.transfer(halfBalance);
208     coauthor.transfer(halfBalance);
209   }
210 
211   function setCoAuthor(address _coauthor) public onlyAuthor {
212     require(!isNullAddress(_coauthor));
213 
214     coauthor = _coauthor;
215   }
216 
217   function setKpopArenaContractAddress(address _address) public onlyAuthors {
218     require(!isNullAddress(_address));
219 
220     KPOP_ARENA_CONTRACT_ADDRESS = _address;
221   }
222 
223   function updateTraits(uint _celebId) public onlyArena {
224     require(_celebId < totalSupply());
225 
226     for (uint i = 0; i < 6; i++) {
227       uint booster = celebIdToTraitBoosters[_celebId][i];
228       celebIdToTraitValues[_celebId][i] = celebIdToTraitValues[_celebId][i].add(booster);
229     }
230   }
231 
232   /** END FUNCTIONS FOR AUTHORS **/
233 
234   function getCeleb(uint _celebId) public view returns (
235     string name,
236     uint price,
237     address owner,
238     uint[6] traitValues,
239     uint[6] traitBoosters
240   ) {
241     name = celebs[_celebId].name;
242     price = celebIdToPrice[_celebId];
243     owner = celebIdToOwner[_celebId];
244     traitValues = celebIdToTraitValues[_celebId];
245     traitBoosters = celebIdToTraitBoosters[_celebId];
246   }
247 
248   /** START FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
249 
250   function approve(address _to, uint _celebId) public {
251     require(msg.sender == ownerOf(_celebId));
252 
253     celebIdToApprovedRecipient[_celebId] = _to;
254 
255     Approval(msg.sender, _to, _celebId);
256   }
257 
258   function transferFrom(address _from, address _to, uint _celebId) public {
259     require(ownerOf(_celebId) == _from);
260     require(isApproved(_to, _celebId));
261     require(!isNullAddress(_to));
262 
263     _transfer(_from, _to, _celebId);
264   }
265 
266   function takeOwnership(uint _celebId) public {
267     require(!isNullAddress(msg.sender));
268     require(isApproved(msg.sender, _celebId));
269 
270     address currentOwner = celebIdToOwner[_celebId];
271 
272     _transfer(currentOwner, msg.sender, _celebId);
273   }
274 
275   /** END FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
276 
277   function implementsERC721() public pure returns (bool) {
278     return true;
279   }
280 
281   /** MODIFIERS **/
282 
283   modifier onlyAuthor() {
284     require(msg.sender == author);
285     _;
286   }
287 
288   modifier onlyAuthors() {
289     require(msg.sender == author || msg.sender == coauthor);
290     _;
291   }
292 
293   modifier onlyArena() {
294     require(msg.sender == author || msg.sender == coauthor || msg.sender == KPOP_ARENA_CONTRACT_ADDRESS);
295     _;
296   }
297 
298   /** FUNCTIONS THAT WONT BE USED FREQUENTLY **/
299 
300   function setMinStartingPrice(uint _price) public onlyAuthors {
301     MIN_STARTING_PRICE = _price;
302   }
303 
304   function setGrowthBump(uint _bump) public onlyAuthors {
305     GROWTH_BUMP = _bump;
306   }
307 
308   function setPriceIncreaseScale(uint _scale) public onlyAuthors {
309     PRICE_INCREASE_SCALE = _scale;
310   }
311 
312   /** PRIVATE FUNCTIONS **/
313 
314   function isApproved(address _to, uint _celebId) private view returns (bool) {
315     return celebIdToApprovedRecipient[_celebId] == _to;
316   }
317 
318   function isNullAddress(address _addr) private pure returns (bool) {
319     return _addr == 0x0;
320   }
321 }