1 pragma solidity ^0.4.18;
2 
3 // KpopToken is a ERC-721 token (https://github.com/ethereum/eips/issues/721)
4 // Kpop celebrity cards as digital collectibles
5 // Kpop.io is the official website
6 
7 contract ERC721 {
8   function approve(address _to, uint _tokenId) public;
9   function balanceOf(address _owner) public view returns (uint balance);
10   function implementsERC721() public pure returns (bool);
11   function ownerOf(uint _tokenId) public view returns (address addr);
12   function takeOwnership(uint _tokenId) public;
13   function totalSupply() public view returns (uint total);
14   function transferFrom(address _from, address _to, uint _tokenId) public;
15   function transfer(address _to, uint _tokenId) public;
16 
17   event Transfer(address indexed from, address indexed to, uint tokenId);
18   event Approval(address indexed owner, address indexed approved, uint tokenId);
19 }
20 
21 contract KpopToken is ERC721 {
22   address public author;
23   address public coauthor;
24 
25   string public constant NAME = "Kpopio";
26   string public constant SYMBOL = "KpopToken";
27 
28   uint public GROWTH_BUMP = 0.1 ether;
29   uint public MIN_STARTING_PRICE = 0.002 ether;
30   uint public PRICE_INCREASE_SCALE = 120; // 120% of previous price
31 
32   struct Celeb {
33     string name;
34   }
35 
36   Celeb[] public celebs;
37 
38   mapping(uint => address) public tokenIdToOwner;
39   mapping(uint => uint) public tokenIdToPrice; // in wei
40   mapping(address => uint) public userToNumCelebs;
41   mapping(uint => address) public tokenIdToApprovedRecipient;
42 
43   event Transfer(address indexed from, address indexed to, uint tokenId);
44   event Approval(address indexed owner, address indexed approved, uint tokenId);
45   event CelebSold(uint tokenId, uint oldPrice, uint newPrice, string celebName, address prevOwner, address newOwner);
46 
47   function KpopToken() public {
48     author = msg.sender;
49     coauthor = msg.sender;
50   }
51 
52   function _transfer(address _from, address _to, uint _tokenId) private {
53     require(ownerOf(_tokenId) == _from);
54     require(!isNullAddress(_to));
55     require(balanceOf(_from) > 0);
56 
57     uint prevBalances = balanceOf(_from) + balanceOf(_to);
58     tokenIdToOwner[_tokenId] = _to;
59     userToNumCelebs[_from]--;
60     userToNumCelebs[_to]++;
61 
62     // Clear outstanding approvals
63     delete tokenIdToApprovedRecipient[_tokenId];
64 
65     Transfer(_from, _to, _tokenId);
66     
67     assert(balanceOf(_from) + balanceOf(_to) == prevBalances);
68   }
69 
70   function buy(uint _tokenId) payable public {
71     address prevOwner = ownerOf(_tokenId);
72     uint currentPrice = tokenIdToPrice[_tokenId];
73 
74     require(prevOwner != msg.sender);
75     require(!isNullAddress(msg.sender));
76     require(msg.value >= currentPrice);
77 
78     // Take a cut off the payment
79     uint payment = uint(SafeMath.div(SafeMath.mul(currentPrice, 92), 100));
80     uint leftover = SafeMath.sub(msg.value, currentPrice);
81     uint newPrice;
82 
83     _transfer(prevOwner, msg.sender, _tokenId);
84 
85     if (currentPrice < GROWTH_BUMP) {
86       newPrice = SafeMath.mul(currentPrice, 2);
87     } else {
88       newPrice = SafeMath.div(SafeMath.mul(currentPrice, PRICE_INCREASE_SCALE), 100);
89     }
90 
91     tokenIdToPrice[_tokenId] = newPrice;
92 
93     if (prevOwner != address(this)) {
94       prevOwner.transfer(payment);
95     }
96 
97     CelebSold(_tokenId, currentPrice, newPrice,
98       celebs[_tokenId].name, prevOwner, msg.sender);
99 
100     msg.sender.transfer(leftover);
101   }
102 
103   function balanceOf(address _owner) public view returns (uint balance) {
104     return userToNumCelebs[_owner];
105   }
106 
107   function ownerOf(uint _tokenId) public view returns (address addr) {
108     return tokenIdToOwner[_tokenId];
109   }
110 
111   function totalSupply() public view returns (uint total) {
112     return celebs.length;
113   }
114 
115   function transfer(address _to, uint _tokenId) public {
116     _transfer(msg.sender, _to, _tokenId);
117   }
118 
119   /** START FUNCTIONS FOR AUTHORS **/
120 
121   function createCeleb(string _name, uint _price) public onlyAuthors {
122     require(_price >= MIN_STARTING_PRICE);
123 
124     uint tokenId = celebs.push(Celeb(_name)) - 1;
125     tokenIdToOwner[tokenId] = author;
126     tokenIdToPrice[tokenId] = _price;
127     userToNumCelebs[author]++;
128   }
129 
130   function withdraw(uint _amount, address _to) public onlyAuthors {
131     require(!isNullAddress(_to));
132     require(_amount <= this.balance);
133 
134     _to.transfer(_amount);
135   }
136 
137   function withdrawAll() public onlyAuthors {
138     require(author != 0x0);
139     require(coauthor != 0x0);
140 
141     uint halfBalance = uint(SafeMath.div(this.balance, 2));
142 
143     author.transfer(halfBalance);
144     coauthor.transfer(halfBalance);
145   }
146 
147   function setCoAuthor(address _coauthor) public onlyAuthor {
148     require(!isNullAddress(_coauthor));
149 
150     coauthor = _coauthor;
151   }
152 
153   /** END FUNCTIONS FOR AUTHORS **/
154 
155   function getCeleb(uint _tokenId) public view returns (
156     string name,
157     uint price,
158     address owner
159   ) {
160     name = celebs[_tokenId].name;
161     price = tokenIdToPrice[_tokenId];
162     owner = tokenIdToOwner[_tokenId];
163   }
164 
165   /** START FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
166 
167   function approve(address _to, uint _tokenId) public {
168     require(msg.sender == ownerOf(_tokenId));
169 
170     tokenIdToApprovedRecipient[_tokenId] = _to;
171 
172     Approval(msg.sender, _to, _tokenId);
173   }
174 
175   function transferFrom(address _from, address _to, uint _tokenId) public {
176     require(ownerOf(_tokenId) == _from);
177     require(isApproved(_to, _tokenId));
178     require(!isNullAddress(_to));
179 
180     _transfer(_from, _to, _tokenId);
181   }
182 
183   function takeOwnership(uint _tokenId) public {
184     require(!isNullAddress(msg.sender));
185     require(isApproved(msg.sender, _tokenId));
186 
187     address currentOwner = tokenIdToOwner[_tokenId];
188 
189     _transfer(currentOwner, msg.sender, _tokenId);
190   }
191 
192   /** END FUNCTIONS RELATED TO EXTERNAL CONTRACT INTERACTIONS **/
193 
194   function implementsERC721() public pure returns (bool) {
195     return true;
196   }
197 
198   /** MODIFIERS **/
199 
200   modifier onlyAuthor() {
201     require(msg.sender == author);
202     _;
203   }
204 
205   modifier onlyAuthors() {
206     require(msg.sender == author || msg.sender == coauthor);
207     _;
208   }
209 
210   /** FUNCTIONS THAT WONT BE USED FREQUENTLY **/
211 
212   function setMinStartingPrice(uint _price) public onlyAuthors {
213     MIN_STARTING_PRICE = _price;
214   }
215 
216   function setGrowthBump(uint _bump) public onlyAuthors {
217     GROWTH_BUMP = _bump;
218   }
219 
220   function setPriceIncreaseScale(uint _scale) public onlyAuthors {
221     PRICE_INCREASE_SCALE = _scale;
222   }
223 
224   /** PRIVATE FUNCTIONS **/
225 
226   function isApproved(address _to, uint _tokenId) private view returns (bool) {
227     return tokenIdToApprovedRecipient[_tokenId] == _to;
228   }
229 
230   function isNullAddress(address _addr) private pure returns (bool) {
231     return _addr == 0x0;
232   }
233 }
234 
235 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
236 
237 /**
238  * @title SafeMath
239  * @dev Math operations with safety checks that throw on error
240  */
241 library SafeMath {
242 
243   /**
244   * @dev Multiplies two numbers, throws on overflow.
245   */
246   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247     if (a == 0) {
248       return 0;
249     }
250     uint256 c = a * b;
251     assert(c / a == b);
252     return c;
253   }
254 
255   /**
256   * @dev Integer division of two numbers, truncating the quotient.
257   */
258   function div(uint256 a, uint256 b) internal pure returns (uint256) {
259     // assert(b > 0); // Solidity automatically throws when dividing by 0
260     uint256 c = a / b;
261     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
262     return c;
263   }
264 
265   /**
266   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
267   */
268   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269     assert(b <= a);
270     return a - b;
271   }
272 
273   /**
274   * @dev Adds two numbers, throws on overflow.
275   */
276   function add(uint256 a, uint256 b) internal pure returns (uint256) {
277     uint256 c = a + b;
278     assert(c >= a);
279     return c;
280   }
281 }